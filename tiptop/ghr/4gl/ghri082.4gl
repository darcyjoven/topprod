# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri082.4gl
# Descriptions...: 
# Date & Author..: 06/27/13 by zhangbo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrdo    RECORD LIKE hrdo_file.*
DEFINE  g_hrdo_t  RECORD LIKE hrdo_file.*
DEFINE  g_hrdo_b  DYNAMIC ARRAY OF RECORD
          hrdo02    LIKE   hrdo_file.hrdo02,
          hrat02    LIKE   hrat_file.hrat02,
          hrat03    LIKE   hraa_file.hraa12,
          hrat04    LIKE   hrao_file.hrao02,
          hrat05    LIKE   hras_file.hras04,
          hrat66    LIKE   hrat_file.hrat66,
          hrat19    LIKE   hrad_file.hrad03,
          hrdo04    LIKE   hrdo_file.hrdo04,
          hrdo05    LIKE   hrdo_file.hrdo05,
          hrdo03    LIKE   hrdo_file.hrdo03,
          hrdo06    LIKE   hrdo_file.hrdo06,
          hrdo01    LIKE   hrdo_file.hrdo01
                  END RECORD
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_hrdo01            LIKE hrdo_file.hrdo01
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
DEFINE gs_wc        STRING

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
 
   INITIALIZE g_hrdo.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrdo_file WHERE hrdo01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i082_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i082_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri082"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   
   
   LET g_action_choice=""
   CALL i082_menu()
 
   CLOSE WINDOW i082_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i082_curs()

    CLEAR FORM
    INITIALIZE g_hrdo.* TO NULL
    
    IF gs_wc IS NULL THEN
       CONSTRUCT BY NAME g_wc ON                              
           hrdo02,hrdo04,hrdo05,hrdo03,hrdo06,
           hrdouser,hrdogrup,hrdomodu,hrdodate,hrdoacti,hrdooriu,hrdoorig
       
           BEFORE CONSTRUCT                                    
              CALL cl_qbe_init()                               
       
           ON ACTION controlp
              CASE
                 WHEN INFIELD(hrdo02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrat01"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_hrdo.hrdo02
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrdo02
                    NEXT FIELD hrdo02
                           
                WHEN INFIELD(hrdo04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrct11"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_hrdo.hrdo04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrdo04
                    NEXT FIELD hrdo04
                    
                WHEN INFIELD(hrdo05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrct11"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_hrdo.hrdo05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrdo05
                    NEXT FIELD hrdo05    
       
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
       
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdouser', 'hrdogrup')  #
                                                                     
       CALL cl_replace_str(g_wc,'hrdo02','hrat01') RETURNING g_wc 
    ELSE
   	   LET g_wc=gs_wc
   	END IF                                                                       

    LET g_sql = "SELECT hrdo01 FROM hrdo_file,hrat_file ",                       #
                " WHERE ",g_wc CLIPPED,
                "   AND hrdo02=hratid ",
                " ORDER BY hrdo01"
    PREPARE i082_prepare FROM g_sql
    DECLARE i082_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i082_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrdo01) FROM hrdo_file,hrat_file WHERE ",g_wc CLIPPED,
                "   AND hrdo02=hratid "
    PREPARE i082_precount FROM g_sql
    DECLARE i082_count CURSOR FOR i082_precount
END FUNCTION

FUNCTION i082_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i082_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i082_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            LET gs_wc=NULL
            IF cl_chk_act_auth() THEN
                 CALL i082_q()
            END IF  

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i082_u()
            END IF

        #ON ACTION invalid
        #    LET g_action_choice="invalid"
        #    IF cl_chk_act_auth() THEN
        #         CALL i082_x()
        #    END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i082_r()
            END IF
            	
        ON ACTION piliang
           LET g_action_choice="piliang"
           IF cl_chk_act_auth() THEN
              CALL i082_gen()
           END IF    	
            	
            	
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        
        ON ACTION next
            CALL i082_fetch('N')

        ON ACTION previous
            CALL i082_fetch('P')
        
        ON ACTION jump
            CALL i082_fetch('/')

        ON ACTION first
            CALL i082_fetch('F')

        ON ACTION last
            CALL i082_fetch('L')

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
              IF g_hrdo.hrdo01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrdo01"
                 LET g_doc.value1 = g_hrdo.hrdo01
                 CALL cl_doc()
              END IF
           END IF
           	
        ON ACTION exporttoexcel   #No.FUN-4B0020
           LET g_action_choice = 'exporttoexcel'
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdo_b),'','')
           END IF   	
    END MENU

END FUNCTION	
	
FUNCTION i082_a()
DEFINE l_hrdo    RECORD LIKE  hrdo_file.*

    CLEAR FORM                                   #
    INITIALIZE g_hrdo.* LIKE hrdo_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrdo.hrdouser = g_user
        LET g_hrdo.hrdooriu = g_user
        LET g_hrdo.hrdoorig = g_grup
        LET g_hrdo.hrdogrup = g_grup               #
        LET g_hrdo.hrdodate = g_today
        LET g_hrdo.hrdoacti = 'Y'
        LET g_hrdo.hrdo03 = g_today
        CALL i082_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrdo.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrdo.hrdo02 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        
        SELECT MAX(hrdo01) INTO g_hrdo.hrdo01 FROM hrdo_file
        
        IF cl_null(g_hrdo.hrdo01) THEN
        	 LET g_hrdo.hrdo01='0000000001'
        ELSE
        	 LET g_hrdo.hrdo01=g_hrdo.hrdo01+1 USING "&&&&&&&&&&"	 	
        END IF
        	
        LET l_hrdo.*=g_hrdo.*
        
        SELECT hratid INTO l_hrdo.hrdo02 FROM hrat_file WHERE hrat01=g_hrdo.hrdo02	
        		
        INSERT INTO hrdo_file VALUES(l_hrdo.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdo_file",g_hrdo.hrdo02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrdo01 INTO g_hrdo.hrdo01 FROM hrdo_file WHERE hrdo01 = g_hrdo.hrdo01
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION	
	
FUNCTION i082_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_sql         STRING
   DEFINE l_hratid      LIKE hrat_file.hratid
   DEFINE l_hrdo02_desc LIKE hrat_file.hrat02
   DEFINE l_string      STRING
   DEFINE l_num,l_i     LIKE type_file.num5
   DEFINE l_check       LIKE type_file.chr1
   DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
   DEFINE l_hrct08_b,l_hrct08_e    LIKE hrct_file.hrct08 
   DEFINE l_hrat03      LIKE  hrat_file.hrat03        #add by zhangbo130705

   
   DISPLAY BY NAME
      g_hrdo.hrdo02,g_hrdo.hrdo04,g_hrdo.hrdo05,g_hrdo.hrdo03,g_hrdo.hrdo06,
      g_hrdo.hrdouser,g_hrdo.hrdogrup,g_hrdo.hrdomodu,g_hrdo.hrdodate,g_hrdo.hrdoacti

   INPUT BY NAME
      g_hrdo.hrdo02,g_hrdo.hrdo04,g_hrdo.hrdo05,
      g_hrdo.hrdo03,g_hrdo.hrdo06
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          
      AFTER FIELD hrdo02
         IF NOT cl_null(g_hrdo.hrdo02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrdo.hrdo02
         	                                            AND hratconf='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此员工','!',0)
         	  	 NEXT FIELD hrdo02
         	  END IF	
         	                                           	
         	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdo.hrdo02   	
 	  
         	  IF l_hratid != g_hrdo_t.hrdo02 OR g_hrdo_t.hrdo02 IS NULL THEN
         	  	 IF NOT cl_null(g_hrdo.hrdo04) AND 
         	  	    NOT cl_null(g_hrdo.hrdo05) THEN
         	  	    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdo.hrdo02
                            SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdo.hrdo02    #add by zhangbo130705
         	  	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdo.hrdo04
                                                                           AND hrct03=l_hrat03       #add by zhangbo130705
         	  	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdo.hrdo05
                                                                           AND hrct03=l_hrat03       #add by zhangbo130705
         	  	    LET l_n=0
         	  	    IF p_cmd='a' THEN
                     SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdo_file
                       WHERE hrdo02=l_hratid
                        AND A.hrct11=hrdo04
                        AND B.hrct11=hrdo05
                        AND A.hrct03=l_hrat03      #add by zhangbo130705
                        AND B.hrct03=l_hrat03      #add by zhangbo130705
                        AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                             OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                             OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                  ELSE
                      SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdo_file
                       WHERE hrdo02=l_hratid
                         AND hrdo01<>g_hrdo.hrdo01
                         AND A.hrct11=hrdo04
                         AND B.hrct11=hrdo05
                         AND A.hrct03=l_hrat03      #add by zhangbo130705
                         AND B.hrct03=l_hrat03      #add by zhangbo130705
                         AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                              OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                              OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                  END IF
                  IF l_n>0 THEN
                     CALL cl_err('该员工设置的薪资月有交叉','!',0)
                     NEXT FIELD hrdo02
                  END IF
         	  	 END IF
         	  END IF
         	  	
         	  SELECT hrat02 INTO l_hrdo02_desc FROM hrat_file WHERE hrat01=g_hrdo.hrdo02
         	  DISPLAY l_hrdo02_desc TO hrdo02_desc	
         	    	
         END IF
         	
         	
      AFTER FIELD hrdo04
         IF NOT cl_null(g_hrdo.hrdo04) THEN
         	  LET l_n=0
                  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdo.hrdo02    #add by zhangbo130705
         	  SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdo.hrdo04
                                                            AND hrct03=l_hrat03            #add by zhangbo130705
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此薪资月','!',0)
         	  	 NEXT FIELD hrdo04
         	  END IF
         	  
            IF NOT cl_null(g_hrdo.hrdo05) THEN
               SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdo.hrdo04   #mod by zhangbo130705
                                                              AND hrct03=l_hrat03        #add by zhangbo130705
               SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrdo.hrdo05
                                                              AND hrct03=l_hrat03        #add by zhangbo130705  
               IF l_hrct07_b>l_hrct07_e THEN                                             #add by zhangbo130705
                  CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                  NEXT FIELD hrdo04
               END IF
            END IF	
            
            IF g_hrdo.hrdo04 != g_hrdo_t.hrdo04 OR g_hrdo_t.hrdo04 IS NULL THEN
         	     IF NOT cl_null(g_hrdo.hrdo02) AND 
         	  	    NOT cl_null(g_hrdo.hrdo05) THEN
         	  	    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdo.hrdo02
         	  	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdo.hrdo04
                                                                           AND hrct03=l_hrat03         #add by zhangbo130705
         	  	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdo.hrdo05
                                                                           AND hrct03=l_hrat03         #add by zhangbo130705
         	  	    LET l_n=0 
         	  	    IF p_cmd='a' THEN
                     SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdo_file
                       WHERE hrdo02=l_hratid
                         AND A.hrct11=hrdo04
                         AND B.hrct11=hrdo05
                         AND A.hrct03=l_hrat03      #add by zhangbo130705
                         AND B.hrct03=l_hrat03      #add by zhangbo130705
                         AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                              OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                              OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                  ELSE
                     SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdo_file
                      WHERE hrdo02=l_hratid
                        AND hrdo01<>g_hrdo.hrdo01
                        AND A.hrct11=hrdo04
                        AND B.hrct11=hrdo05
                        AND A.hrct03=l_hrat03      #add by zhangbo130705
                         AND B.hrct03=l_hrat03      #add by zhangbo130705
                        AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                             OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                             OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                  END IF
                  IF l_n>0 THEN
                     CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
                     NEXT FIELD hrdo04
                  END IF
         	  	 END IF
            END IF
         END IF
         	   	
      AFTER FIELD hrdo05
         IF NOT cl_null(g_hrdo.hrdo05) THEN
         	  LET l_n=0
                  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdo.hrdo02    #add by zhangbo130705
         	  SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdo.hrdo05
                                                            AND hrct03=l_hrat03             #add by zhangbo130705 
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此薪资月','!',0)
         	  	 NEXT FIELD hrdo05
         	  END IF
         	  
            IF NOT cl_null(g_hrdo.hrdo04) THEN
               SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdo.hrdo04    #mod by zhangbo130705
                                                              AND hrct03=l_hrat3             #add by zhangbo130705
               SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrdo.hrdo05
                                                              AND hrct03=l_hrat3             #add by zhangbo130705
               IF l_hrct07_b>l_hrct07_e THEN       #mod by zhangbo130705
                  CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                  NEXT FIELD hrdo05
               END IF
            END IF	
            
            IF g_hrdo.hrdo05 != g_hrdo_t.hrdo05 OR g_hrdo_t.hrdo05 IS NULL THEN
         	     IF NOT cl_null(g_hrdo.hrdo02) AND 
         	  	    NOT cl_null(g_hrdo.hrdo04) THEN
         	  	    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdo.hrdo02
         	  	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdo.hrdo04
         	  	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdo.hrdo05
         	  	    LET l_n=0
         	  IF p_cmd='a' THEN
                     SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdo_file
                       WHERE hrdo02=l_hratid
                         AND A.hrct11=hrdo04
                         AND B.hrct11=hrdo05
                         AND A.hrct03=l_hrat03      #add by zhangbo130705
                         AND B.hrct03=l_hrat03      #add by zhangbo130705
                         AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                              OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                              OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                  ELSE
                     SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdo_file
                      WHERE hrdo02=l_hratid
                        AND hrdo01<>g_hrdo.hrdo01
                        AND A.hrct11=hrdo04
                        AND B.hrct11=hrdo05
                        AND A.hrct03=l_hrat03      #add by zhangbo130705
                         AND B.hrct03=l_hrat03      #add by zhangbo130705
                        AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                             OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                             OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                  END IF
                  IF l_n>0 THEN
                     CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
                     NEXT FIELD hrdo05
                  END IF
         	  	 END IF
            END IF
         END IF	    	    	 		                     	  	                    	  	   	 	                                             	    		  	      	

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrdo02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = g_hrdo.hrdo02
              CALL cl_create_qry() RETURNING g_hrdo.hrdo02
              DISPLAY BY NAME g_hrdo.hrdo02
              NEXT FIELD hrdo02
              
           WHEN INFIELD(hrdo04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrdo.hrdo04
              CALL cl_create_qry() RETURNING g_hrdo.hrdo04
              DISPLAY BY NAME g_hrdo.hrdo04
              NEXT FIELD hrdo04
              
           WHEN INFIELD(hrdo05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrdo.hrdo05
              CALL cl_create_qry() RETURNING g_hrdo.hrdo05
              DISPLAY BY NAME g_hrdo.hrdo05
              NEXT FIELD hrdo05
              
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
	
FUNCTION i082_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdo.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i082_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i082_count
    FETCH i082_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i082_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdo.hrdo01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdo.* TO NULL
    ELSE
        CALL i082_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i082_b_fill(g_wc)
    END IF
END FUNCTION	
	
FUNCTION i082_fetch(p_flhrdo)
    DEFINE p_flhrdo         LIKE type_file.chr1

    CASE p_flhrdo
        WHEN 'N' FETCH NEXT     i082_cs INTO g_hrdo.hrdo01
        WHEN 'P' FETCH PREVIOUS i082_cs INTO g_hrdo.hrdo01
        WHEN 'F' FETCH FIRST    i082_cs INTO g_hrdo.hrdo01
        WHEN 'L' FETCH LAST     i082_cs INTO g_hrdo.hrdo01
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
            FETCH ABSOLUTE g_jump i082_cs INTO g_hrdo.hrdo01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdo.hrdo01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdo.* TO NULL
        LET g_hrdo.hrdo01 = NULL
        RETURN
    ELSE
      CASE p_flhrdo
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      #DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrdo.* FROM hrdo_file    
       WHERE hrdo01 = g_hrdo.hrdo01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrdo_file",g_hrdo.hrdo01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i082_show()                 
    END IF
END FUNCTION	
	
FUNCTION i082_show()
DEFINE l_hrdo02_desc     LIKE     hrat_file.hrat02

    SELECT * INTO g_hrdo.* FROM hrdo_file WHERE hrdo01=g_hrdo.hrdo01

    LET g_hrdo_t.* = g_hrdo.*
    
    SELECT hrat01 INTO g_hrdo.hrdo02 FROM hrat_file WHERE hratid=g_hrdo.hrdo02
    DISPLAY BY NAME g_hrdo.hrdo02,g_hrdo.hrdo04,g_hrdo.hrdo05,
                    g_hrdo.hrdo03,g_hrdo.hrdo06,
                    g_hrdo.hrdouser,g_hrdo.hrdogrup,g_hrdo.hrdomodu,
                    g_hrdo.hrdodate,g_hrdo.hrdoacti,g_hrdo.hrdoorig,g_hrdo.hrdooriu
    
    SELECT hrat02 INTO l_hrdo02_desc FROM hrat_file WHERE hrat01=g_hrdo.hrdo02
                                                                                                                                             
    DISPLAY l_hrdo02_desc TO hrdo02_desc
    CALL cl_show_fld_cont()
END FUNCTION	
	
FUNCTION i082_u()
DEFINE l_hrdo    RECORD LIKE  hrdo_file.*

    IF g_hrdo.hrdo01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    SELECT * INTO g_hrdo.* FROM hrdo_file WHERE hrdo01=g_hrdo.hrdo01
    
    #IF g_hrdo.hrdoacti = 'N' THEN
    #    CALL cl_err('',9027,0)
    #    RETURN
    #END IF
    	
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i082_cl USING g_hrdo.hrdo01
    IF STATUS THEN
       CALL cl_err("OPEN i082_cl:", STATUS, 1)
       CLOSE i082_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i082_cl INTO g_hrdo.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdo.hrdo01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i082_show()                          
    WHILE TRUE
        CALL i082_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdo.*=g_hrdo_t.*
            CALL i082_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrdo.hrdomodu=g_user
        LET g_hrdo.hrdodate=g_today	
        
        LET l_hrdo.*=g_hrdo.*
        SELECT hratid INTO l_hrdo.hrdo02 FROM hrat_file WHERE hrat01=g_hrdo.hrdo02
        
        UPDATE hrdo_file SET hrdo_file.* = l_hrdo.*    
            WHERE hrdo01 = g_hrdo_t.hrdo01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdo_file",g_hrdo.hrdo01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i082_show()	
        EXIT WHILE
    END WHILE
    CLOSE i082_cl
    COMMIT WORK
    CALL i082_b_fill(g_wc)
END FUNCTION				

FUNCTION i082_r()
    IF g_hrdo.hrdo01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i082_cl USING g_hrdo.hrdo01
    IF STATUS THEN
       CALL cl_err("OPEN i082_cl:", STATUS, 0)
       CLOSE i082_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i082_cl INTO g_hrdo.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdo.hrdo01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i082_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrdo01"
       LET g_doc.value1 = g_hrdo.hrdo01
       CALL cl_del_doc()
       
       DELETE FROM hrdo_file WHERE hrdo01 = g_hrdo.hrdo01
       
       CLEAR FORM
       OPEN i082_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i082_cl
          CLOSE i082_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i082_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i082_cl
          CLOSE i082_count
          COMMIT WORK
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL i082_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i082_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i082_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i082_fetch('/')
       END IF
    END IF
    CLOSE i082_cl
    COMMIT WORK
    CALL i082_b_fill(g_wc)
END FUNCTION	
	
FUNCTION i082_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrdo_b.clear()
        
        LET l_sql=" SELECT hrdo02,'','','','','','',hrdo04,hrdo05,hrdo03,hrdo06,hrdo01 ",
                  "   FROM hrdo_file,hrat_file WHERE ",p_wc CLIPPED,
                  "    AND hrdo02=hratid ",
                  "  ORDER BY hrdo01 "
                  
        PREPARE i082_b_pre FROM l_sql
        DECLARE i082_b_cs CURSOR FOR i082_b_pre
        
        LET l_i=1
        
        FOREACH i082_b_cs INTO g_hrdo_b[l_i].*
        
           SELECT hrat01 INTO g_hrdo_b[l_i].hrdo02 FROM hrat_file WHERE hratid=g_hrdo_b[l_i].hrdo02
           SELECT hrat02 INTO g_hrdo_b[l_i].hrat02 FROM hrat_file WHERE hrat01=g_hrdo_b[l_i].hrdo02
           SELECT hraa12 INTO g_hrdo_b[l_i].hrat03 FROM hrat_file,hraa_file
            WHERE hrat03=hraa01 AND hrat01=g_hrdo_b[l_i].hrdo02
           SELECT hrao02 INTO g_hrdo_b[l_i].hrat04 FROM hrat_file,hrao_file
            WHERE hrat04=hrao01 AND hrat01=g_hrdo_b[l_i].hrdo02
           SELECT hras04 INTO g_hrdo_b[l_i].hrat05 FROM hrat_file,hras_file
            WHERE hras01=hrat05 AND hrat01=g_hrdo_b[l_i].hrdo02
           SELECT hrat66 INTO g_hrdo_b[l_i].hrat66 FROM hrat_file WHERE hrat01=g_hrdo_b[l_i].hrdo02     
           SELECT hrad03 INTO g_hrdo_b[l_i].hrat19 FROM hrat_file,hrad_file
            WHERE hrat19=hrad02 AND hrat01=g_hrdo_b[l_i].hrdo02
           
              
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrdo_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrdo_b TO s_hrdo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION	
	
FUNCTION i082_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i082_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrdo_file.*
           INTO g_hrdo.*
           FROM hrdo_file
          WHERE hrdo01=g_hrdo_b[l_ac].hrdo01
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i082_fetch('/')
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
               CALL i082_a()
            END IF
            EXIT WHILE

        WHEN "query"
            LET gs_wc=NULL
            IF cl_chk_act_auth() THEN
               CALL i082_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i082_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i082_u()
            END IF
            EXIT WHILE
            	
        WHEN "piliang"
            IF cl_chk_act_auth() THEN
               CALL i082_gen()
            END IF
            EXIT WHILE     	

        #WHEN "invalid"
        #    IF cl_chk_act_auth() THEN
        #       CALL i082_x()
        #       CALL i082_show()
        #    END IF     	        	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdo_b),'','')
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
	
FUNCTION i082_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdo_b TO s_hrdo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i082_fetch('/')
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
         CALL i082_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL cl_set_comp_visible("Page3", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", TRUE)    #NO.FUN-840018 ADD
         EXIT DISPLAY

      ON ACTION first
         CALL i082_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i082_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i082_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i082_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i082_fetch('L')
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

      #ON ACTION invalid
      #   LET g_action_choice="invalid"
      #   EXIT DISPLAY
      
      ON ACTION piliang
         LET g_action_choice="piliang"
         EXIT DISPLAY 

      #No.FUN-9C0089 add begin----------------
      ON ACTION exporttoexcel
         LET g_action_choice="exporttoexcel"
         EXIT DISPLAY
      #No.FUN-9C0089 add -end----------------- 
   
      AFTER DISPLAY
         CONTINUE DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
FUNCTION i082_gen()
DEFINE l_hrdo     RECORD LIKE   hrdo_file.*
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
DEFINE l_start,l_end    LIKE   hrdo_file.hrdo01
DEFINE l_hrat03     LIKE  hrat_file.hrat03      #add by zhangbo130705
DEFINE l_n1,l_n2    LIKE  type_file.num5        #add by zhangbo130705
                 
         CLEAR FORM
         INITIALIZE l_hrdo.* TO NULL
         
         WHILE TRUE
         	
         INPUT l_hrdo.hrdo04,
               l_hrdo.hrdo05,l_hrdo.hrdo03,l_hrdo.hrdo06
         WITHOUT DEFAULTS FROM hrdo04,hrdo05,hrdo03,hrdo06
         
         BEFORE INPUT
            LET l_hrdo.hrdouser = g_user
            LET l_hrdo.hrdooriu = g_user
            LET l_hrdo.hrdoorig = g_grup
            LET l_hrdo.hrdogrup = g_grup               #
            LET l_hrdo.hrdodate = g_today
            LET l_hrdo.hrdoacti = 'Y'
            LET l_hrdo.hrdo03 = g_today
            
            DISPLAY l_hrdo.hrdo03 TO hrdo03
        
           
         AFTER FIELD hrdo04
            IF NOT cl_null(l_hrdo.hrdo04) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdo.hrdo04
         	     IF l_n=0 THEN
         	  	    CALL cl_err('无此薪资月','!',0)
         	  	    NEXT FIELD hrdo04
         	     END IF
         	  	
               IF NOT cl_null(l_hrdo.hrdo05) THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdo.hrdo04    #mod by zhangbo130705
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdo.hrdo05
                  IF l_hrct07_b>l_hrct07_e THEN                                              #mod by zhangbo130705
                     CALL cl_err('开始期间不可比结束期间大','!',0)
                     NEXT FIELD hrdo04
                  END IF
               END IF	
                
            END IF
             
         AFTER FIELD hrdo05
            IF NOT cl_null(l_hrdo.hrdo05) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdo.hrdo05
         	     IF l_n=0 THEN
         	  	    CALL cl_err('无此薪资月','!',0)
         	  	    NEXT FIELD hrdo05
         	     END IF
         	  	
               IF NOT cl_null(l_hrdo.hrdo04) THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdo.hrdo04    #mod by zhangbo130705
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdo.hrdo05
                  IF l_hrct07_b>l_hrct07_e THEN                                              #mod by zhangbo130705
                     CALL cl_err('开始期间不可比结束期间大','!',0)
                     NEXT FIELD hrdo05
                  END IF
               END IF	
                
            END IF
             
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
             
         ON ACTION controlp
            CASE
              WHEN INFIELD(hrdo04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = l_hrdo.hrdo04
              CALL cl_create_qry() RETURNING l_hrdo.hrdo04
              DISPLAY l_hrdo.hrdo04 TO hrdo04
              NEXT FIELD hrdo04
              
              WHEN INFIELD(hrdo05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = l_hrdo.hrdo05
              CALL cl_create_qry() RETURNING l_hrdo.hrdo05
              DISPLAY l_hrdo.hrdo05 TO hrdo05
              NEXT FIELD hrdo05
               
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
       LET l_start=''
       LET l_end=''
       
       BEGIN WORK	
       	
       LET tok = base.StringTokenizer.create(l_str,"|")
       IF NOT cl_null(l_str) THEN
          WHILE tok.hasMoreTokens()
             LET l_value=tok.nextToken()
             SELECT hratid INTO l_hrdo.hrdo02 FROM hrat_file WHERE hrat01=l_value
             SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=l_value        #add by zhangbo130705
             #add by zhangbo130705---begin
             LET l_n1=0
             LET l_n2=0
             SELECT COUNT(*) INTO l_n1 FROM hrct_file WHERE hrct11=l_hrdo.hrdo04
                                                        AND hrct03=l_hrat03
             SELECT COUNT(*) INTO l_n2 FROM hrct_file WHERE hrct11=l_hrdo.hrdo05
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
             SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdo.hrdo04
                                                            AND hrct03=l_hrat03        #add by zhangbo130705
             SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=l_hrdo.hrdo05
                                                            AND hrct03=l_hrat03        #add by zhangbo130705
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdo_file
              WHERE hrdo02=l_hrdo.hrdo02
                AND A.hrct11=hrdo04
                AND B.hrct11=hrdo05
                AND A.hrct03=l_hrat03        #add by zhangbo130705
                AND B.hrct03=l_hrat03        #add by zhangbo130705
                AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                      OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                      OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
             IF l_n>0 THEN
             	  LET g_success='N'
                LET lr_err[li_k].line=li_k
                LET lr_err[li_k].key1=l_value
                LET lr_err[li_k].err="此员工薪资月有交叉"
                LET li_k=li_k+1
                CONTINUE WHILE
             END IF
             
             SELECT MAX(hrdo01) INTO l_hrdo.hrdo01 FROM hrdo_file
        
             IF cl_null(l_hrdo.hrdo01) THEN
        	      LET l_hrdo.hrdo01='0000000001'
             ELSE
        	      LET l_hrdo.hrdo01=l_hrdo.hrdo01+1 USING "&&&&&&&&&&"	 	
             END IF
             	
             INSERT INTO hrdo_file VALUES (l_hrdo.*)
             
             IF SQLCA.sqlcode THEN  
                LET g_success='N'
                LET lr_err[li_k].line=li_k
                LET lr_err[li_k].key1=l_value
                LET lr_err[li_k].err=SQLCA.sqlcode
                LET li_k=li_k+1
                CONTINUE WHILE
             END IF
             	
             IF cl_null(l_start) THEN
             	  LET l_start=l_hrdo.hrdo01
             END IF	  
             	
             LET l_end=l_hrdo.hrdo01	 	
             	           
          END WHILE
       END IF	
       	
       IF lr_err.getLength() > 0 AND g_success='N' THEN
          ROLLBACK WORK
          CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"序号|工号|错误描述")
          CALL i082_show()
       ELSE
          COMMIT WORK
          CALL cl_err('生成成功','!',1)
          LET gs_wc=" hrdo01 BETWEEN '",l_start,"' AND '",l_end,"'"
          CALL i082_q()
       END IF   	
       
END FUNCTION		
