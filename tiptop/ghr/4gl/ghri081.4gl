# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri081.4gl
# Descriptions...: 
# Date & Author..: 06/26/13 by zhangbo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrdn    RECORD LIKE hrdn_file.*
DEFINE  g_hrdn_t  RECORD LIKE hrdn_file.*
DEFINE  g_hrdn_b  DYNAMIC ARRAY OF RECORD
          hrdn02    LIKE   hrdn_file.hrdn02,
          hrat02    LIKE   hrat_file.hrat02,
          hrat04    LIKE   hrao_file.hrao02,
          hrat05    LIKE   hras_file.hras04,
          hrat66    LIKE   hrat_file.hrat66,
          hrat19    LIKE   hrad_file.hrad03,
          hrdn03    LIKE   hrbr_file.hrbr02,
          hrdn04    LIKE   hrbr_file.hrbr02,
          hrdn05    LIKE   hrdn_file.hrdn05,
          hrdn08    LIKE   hrdn_file.hrdn08,
          hrdn07    LIKE   hrdn_file.hrdn07,
          hrdn09    LIKE   hrdn_file.hrdn09,
          hrdn10    LIKE   hrdn_file.hrdn10,
          hrdn12    LIKE   hrdn_file.hrdn12,
          hrdn01    LIKE   hrdn_file.hrdn01
                  END RECORD
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_hrdn01            LIKE hrdn_file.hrdn01
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

MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
    DEFINE l_name   STRING
    DEFINE l_items  STRING

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
 
   INITIALIZE g_hrdn.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrdn_file WHERE hrdn01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i081_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i081_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri081"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   
   CALL cl_set_combo_items("hrdn08",NULL,NULL)
   CALL cl_set_combo_items("hrdn08_b",NULL,NULL)
   
   #帐号性质
   CALL i081_get_items('614') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdn08",l_name,l_items)
   CALL cl_set_combo_items("hrdn08_b",l_name,l_items) 
   
   LET g_action_choice=""
   CALL i081_menu()
 
   CLOSE WINDOW i081_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i081_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i081_get_items_pre FROM l_sql
       DECLARE i081_get_items CURSOR FOR i081_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i081_get_items INTO l_hrag06,l_hrag07
             		       		 
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items

END FUNCTION

FUNCTION i081_curs()

    CLEAR FORM
    INITIALIZE g_hrdn.* TO NULL
    
    CONSTRUCT BY NAME g_wc ON                              
        hrdn02,hrdn03,hrdn04,hrdn05,hrdn09,
        hrdn08,hrdn13,hrdn10,hrdn07,hrdn12,
        hrdnuser,hrdngrup,hrdnmodu,hrdndate,hrdnacti,hrdnoriu,hrdnorig

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrdn02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdn.hrdn02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdn02
                 NEXT FIELD hrdn02
                 
              WHEN INFIELD(hrdn03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbr01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdn.hrdn03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdn03
                 NEXT FIELD hrdn03
                 
             WHEN INFIELD(hrdn04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbr01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdn.hrdn04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdn04
                 NEXT FIELD hrdn04
                    
                        
             WHEN INFIELD(hrdn09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrct11"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdn.hrdn09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdn09
                 NEXT FIELD hrdn09
                 
             WHEN INFIELD(hrdn10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrct11"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdn.hrdn10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdn10
                 NEXT FIELD hrdn10    

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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdnuser', 'hrdngrup')  #
                                                                     
    CALL cl_replace_str(g_wc,'hrdn02','hrat01') RETURNING g_wc                                                                 

    LET g_sql = "SELECT hrdn01 FROM hrdn_file,hrat_file ",                       #
                " WHERE ",g_wc CLIPPED,
                "   AND hrdn02=hratid ",
                " ORDER BY hrdn01"
    PREPARE i081_prepare FROM g_sql
    DECLARE i081_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i081_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrdn01) FROM hrdn_file,hrat_file WHERE ",g_wc CLIPPED,
                "   AND hrdn02=hratid "
    PREPARE i081_precount FROM g_sql
    DECLARE i081_count CURSOR FOR i081_precount
END FUNCTION
	
FUNCTION i081_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i081_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i081_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i081_q()
            END IF  

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i081_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i081_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i081_r()
            END IF
            	
       #帐号合用
        ON ACTION hy_info
           LET g_action_choice="hy_info"
           IF cl_chk_act_auth() THEN
              LET g_msg="ghri081_1 '",g_hrdn.hrdn01,"'"
              CALL cl_cmdrun_wait(g_msg)
           END IF     	
            	
            	
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        
        ON ACTION next
            CALL i081_fetch('N')

        ON ACTION previous
            CALL i081_fetch('P')
        
        ON ACTION jump
            CALL i081_fetch('/')

        ON ACTION first
            CALL i081_fetch('F')

        ON ACTION last
            CALL i081_fetch('L')

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
              IF g_hrdn.hrdn01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrdn01"
                 LET g_doc.value1 = g_hrdn.hrdn01
                 CALL cl_doc()
              END IF
           END IF
           	
        ON ACTION exporttoexcel   #No.FUN-4B0020
           LET g_action_choice = 'exporttoexcel'
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdn_b),'','')
           END IF   	
    END MENU

END FUNCTION	
	
FUNCTION i081_a()
DEFINE l_hrdn    RECORD LIKE  hrdn_file.*

    CLEAR FORM                                   #
    INITIALIZE g_hrdn.* LIKE hrdn_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrdn.hrdnuser = g_user
        LET g_hrdn.hrdnoriu = g_user
        LET g_hrdn.hrdnorig = g_grup
        LET g_hrdn.hrdngrup = g_grup               #
        LET g_hrdn.hrdndate = g_today
        LET g_hrdn.hrdnacti = 'Y'
        LET g_hrdn.hrdn07 = g_today
        LET g_hrdn.hrdn13 = 'N'
       
        CALL i081_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrdn.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrdn.hrdn02 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        
        SELECT MAX(hrdn01) INTO g_hrdn.hrdn01 FROM hrdn_file
        
        IF cl_null(g_hrdn.hrdn01) THEN
        	 LET g_hrdn.hrdn01='0000000001'
        ELSE
        	 LET g_hrdn.hrdn01=g_hrdn.hrdn01+1 USING "&&&&&&&&&&"	 	
        END IF
        	
        LET l_hrdn.*=g_hrdn.*
        
        SELECT hratid INTO l_hrdn.hrdn02 FROM hrat_file WHERE hrat01=g_hrdn.hrdn02	
        		
        INSERT INTO hrdn_file VALUES(l_hrdn.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdn_file",g_hrdn.hrdn02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrdn01 INTO g_hrdn.hrdn01 FROM hrdn_file WHERE hrdn01 = g_hrdn.hrdn01
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION
	
FUNCTION i081_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_sql         STRING
   DEFINE l_hratid      LIKE hrat_file.hratid
   DEFINE l_hrdn02_desc LIKE hrat_file.hrat02
   DEFINE l_hrdn03_desc LIKE hrbr_file.hrbr02
   DEFINE l_hrdn04_desc LIKE hrbr_file.hrbr02
   DEFINE l_string      STRING
   DEFINE l_num,l_i     LIKE type_file.num5
   DEFINE l_check       LIKE type_file.chr1
   DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
   DEFINE l_hrct08_b,l_hrct08_e    LIKE hrct_file.hrct08 
   DEFINE l_hrat03                 LIKE hrat_file.hrat03       #add by zhangbo130705
   

   
   DISPLAY BY NAME
      g_hrdn.hrdn02,g_hrdn.hrdn03,g_hrdn.hrdn04,
      g_hrdn.hrdn05,g_hrdn.hrdn08,
      g_hrdn.hrdn09,g_hrdn.hrdn13,g_hrdn.hrdn10,g_hrdn.hrdn07,g_hrdn.hrdn12,
      g_hrdn.hrdnuser,g_hrdn.hrdngrup,g_hrdn.hrdnmodu,g_hrdn.hrdndate,g_hrdn.hrdnacti

   INPUT BY NAME
      g_hrdn.hrdn02,g_hrdn.hrdn03,g_hrdn.hrdn04,
      g_hrdn.hrdn05,g_hrdn.hrdn08,
      g_hrdn.hrdn09,g_hrdn.hrdn13,g_hrdn.hrdn10,g_hrdn.hrdn07,g_hrdn.hrdn12
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          
      AFTER FIELD hrdn02
         IF NOT cl_null(g_hrdn.hrdn02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
         	                                            AND hratconf='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此员工','!',0)
         	  	 NEXT FIELD hrdn02
         	  END IF	
         	                                           	
         	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
         	  
         	  IF l_hratid != g_hrdn_t.hrdn02 OR g_hrdn_t.hrdn02 IS NULL THEN
                     IF NOT cl_null(g_hrdn.hrdn05) THEN
                         LET l_n=0
                         SELECT COUNT(*) INTO l_n FROM hrdn_file WHERE hrdn05=g_hrdn.hrdn05
                                                                   AND hrdn02<>l_hratid
                         IF l_n>0 THEN
                            CALL cl_err('不同员工银行帐号不能重复','!',0)
                            NEXT FIELD hrdn02
                         END IF
                     END IF

         	     IF NOT cl_null(g_hrdn.hrdn09) AND 
         	  	NOT cl_null(g_hrdn.hrdn10) THEN
         	  	SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
                        SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdn.hrdn02    #add by zhangbo130705
         	  	SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdn.hrdn09
                                                                       AND hrct03=l_hrat03       #add by zhangbo130705
         	  	SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdn.hrdn10 
                                                                       AND hrct03=l_hrat03       #add by zhangbo130705
         	  	LET l_n=0
         	  	IF p_cmd='a' THEN
                           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
                            WHERE hrdn02=l_hratid
                              AND A.hrct11=hrdn09
                              AND B.hrct11=hrdn10
                              AND A.hrct03=l_hrat03       #add by zhangbo130705
                              AND B.hrct03=l_hrat03       #add by zhangbo130705
                              AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                               OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                               OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        ELSE
                           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
                            WHERE hrdn02=l_hratid
                              AND hrdn01<>g_hrdn.hrdn01
                              AND A.hrct11=hrdn09
                              AND B.hrct11=hrdn10
                              AND A.hrct03=l_hrat03       #add by zhangbo130705
                              AND B.hrct03=l_hrat03       #add by zhangbo130705
                              AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                               OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                               OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        END IF
                        IF l_n>0 THEN
                           CALL cl_err('该员工设置的薪资月有交叉','!',0)
                           NEXT FIELD hrdn02
                        END IF
         	     END IF
         	  END IF
         	  	
         	  SELECT hrat02 INTO l_hrdn02_desc FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
         	  DISPLAY l_hrdn02_desc TO hrdn02_desc	
         	    	
         END IF
         	
      AFTER FIELD hrdn03
         IF NOT cl_null(g_hrdn.hrdn03) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrbr_file WHERE hrbr01=g_hrdn.hrdn03
         	                                            AND hrbracti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此银行','!',0)
         	  	 NEXT FIELD hrdn03
         	  END IF
         	  	   	
         	  SELECT hrbr02 INTO l_hrdn03_desc FROM hrbr_file WHERE hrbr01=g_hrdn.hrdn03
         	                                                    AND hrbracti='Y'	
         	  DISPLAY l_hrdn03_desc TO hrdn03_desc                                               	 		
         END IF	  			                    	                                    	  		                                           
         	
      AFTER FIELD hrdn04
         IF NOT cl_null(g_hrdn.hrdn04) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrbr_file WHERE hrbr01=g_hrdn.hrdn04
         	                                            AND hrbracti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此银行','!',0)
         	  	 NEXT FIELD hrdn04
         	  END IF
         	  	   	
         	  SELECT hrbr02 INTO l_hrdn04_desc FROM hrbr_file WHERE hrbr01=g_hrdn.hrdn04
         	                                                    AND hrbracti='Y'	
         	  DISPLAY l_hrdn04_desc TO hrdn04_desc 	
         END IF	  		 		
         	
      AFTER FIELD hrdn05
         IF NOT cl_null(g_hrdn.hrdn05) THEN
            LET l_string = g_hrdn.hrdn05
            LET l_string = l_string.trim()
            LET l_num = l_string.getLength()
            FOR l_i = 1 TO l_num
               LET l_check = l_string.getCharAt(l_i)
               IF l_check NOT MATCHES "[0-9]" THEN
               	  CALL cl_err('银行卡帐号必须全部为数字','!',0)
                  NEXT FIELD hrdn05
                  EXIT FOR
               END IF
            END FOR
            
            IF g_hrdn.hrdn05 != g_hrdn_t.hrdn05 
            	 OR g_hrdn_t.hrdn05 IS NULL THEN
            	 IF NOT cl_null(g_hrdn.hrdn02) THEN
            	 	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
            	    LET l_n=0
            	    SELECT COUNT(*) INTO l_n FROM hrdn_file WHERE hrdn05=g_hrdn.hrdn05
            	                                              AND hrdn02<>l_hratid
            	    IF l_n>0 THEN
            	 	     CALL cl_err('不同员工银行帐号不能重复','!',0)
            	 	     NEXT FIELD hrdn05
            	    END IF
            	 END IF   	
            END IF	 		                                                   	  	
         END IF	
         	
         	
      AFTER FIELD hrdn09
         IF NOT cl_null(g_hrdn.hrdn09) THEN
         	  LET l_n=0
                  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdn.hrdn02       #add by zhangbo130705
         	  SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdn.hrdn09
                                                            AND hrct03=l_hrat03               #add by zhangbo130705
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此薪资月','!',0)
         	  	 NEXT FIELD hrdn09
         	  END IF
         	  
            IF NOT cl_null(g_hrdn.hrdn10) THEN
               #SELECT hrct08 INTO l_hrct08_b FROM hrct_file WHERE hrct11=g_hrdn.hrdn09       #mark by zhangbo130705
               SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdn.hrdn09        #add by zhangbo130705
                                                              AND hrct03=l_hrat03             #add by zhangbo130705
               SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrdn.hrdn10
                                                              AND hrct03=l_hrat03             #add by zhangbo130705
               #IF l_hrct08_b>=l_hrct07_e THEN      #mark by zhangbo130705
               IF l_hrct07_b>l_hrct07_e THEN        #add by zhangbo130705
                  CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                  NEXT FIELD hrdn09
               END IF
            END IF	
            
            IF g_hrdn.hrdn09 != g_hrdn_t.hrdn09 OR g_hrdn_t.hrdn09 IS NULL THEN
         	     IF NOT cl_null(g_hrdn.hrdn02) AND 
         	  	    NOT cl_null(g_hrdn.hrdn10) THEN
         	  	    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
         	  	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdn.hrdn09
         	  	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdn.hrdn10
         	  	    LET l_n=0
         	  	    IF p_cmd='a' THEN
                     SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
                       WHERE hrdn02=l_hratid
                        AND A.hrct11=hrdn09
                        AND B.hrct11=hrdn10
                        AND A.hrct03=l_hrat03       #add by zhangbo130705
                        AND B.hrct03=l_hrat03       #add by zhangbo130705
                        AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                             OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                             OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                  ELSE
                     SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
                      WHERE hrdn02=l_hratid
                        AND hrdn01<>g_hrdn.hrdn01
                        AND A.hrct11=hrdn09
                        AND B.hrct11=hrdn10
                        AND A.hrct03=l_hrat03       #add by zhangbo130705
                        AND B.hrct03=l_hrat03       #add by zhangbo130705
                        AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                             OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                             OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                  END IF
                  IF l_n>0 THEN
                     CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
                     NEXT FIELD hrdn09
                  END IF
         	  	 END IF
            END IF
         END IF
      AFTER FIELD hrdn13
         IF g_hrdn.hrdn13 = 'Y' THEN
              CALL cl_set_comp_entry('hrdn10',FALSE)
              LET g_hrdn.hrdn10= NULL     
          ELSE 
              CALL cl_set_comp_entry('hrdn10',TRUE) 	     	   
         END IF    	   	
      AFTER FIELD hrdn10
         IF NOT cl_null(g_hrdn.hrdn10) THEN
         	  LET l_n=0
                  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdn.hrdn02       #add by zhangbo130705
         	  SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdn.hrdn10
                                                            AND hrct03=l_hrat03               #add by zhangbo130705
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此薪资月','!',0)
         	  	 NEXT FIELD hrdn10
         	  END IF
         	  
            IF NOT cl_null(g_hrdn.hrdn09) THEN
               #SELECT hrct08 INTO l_hrct08_b FROM hrct_file WHERE hrct11=g_hrdn.hrdn09       #mark by zhangbo130705
               SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdn.hrdn09        #add by zhangbo130705
                                                              AND hrct03=l_hrat03             #add by zhangbo130705
               SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrdn.hrdn10
                                                              AND hrct03=l_hrat03             #add by zhangbo130705
               #IF l_hrct08_b>=l_hrct07_e THEN     #mark by zhangbo1300705
               IF l_hrct07_b>=l_hrct07_e THEN      #add by zhangbo130705
                  CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                  NEXT FIELD hrdn10
               END IF
            END IF	
            
            IF g_hrdn.hrdn10 != g_hrdn_t.hrdn10 OR g_hrdn_t.hrdn10 IS NULL THEN
         	     IF NOT cl_null(g_hrdn.hrdn02) AND 
         	  	NOT cl_null(g_hrdn.hrdn09) THEN
         	  	SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
         	  	SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdn.hrdn09
         	  	SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdn.hrdn10
         	  	LET l_n=0
         	        IF p_cmd='a' THEN
                           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
                           WHERE hrdn02=l_hratid
                             AND A.hrct11=hrdn09
                             AND B.hrct11=hrdn10
                             AND A.hrct03=l_hrat03      #add by zhangbo130705
                             AND B.hrct03=l_hrat03      #add by zhangbo130705
                             AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                              OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                              OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        ELSE
                           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
                            WHERE hrdn02=l_hratid
                              AND hrdn01<>g_hrdn.hrdn01
                              AND A.hrct11=hrdn09
                              AND B.hrct11=hrdn10
                              AND A.hrct03=l_hrat03      #add by zhangbo130705
                              AND B.hrct03=l_hrat03      #add by zhangbo130705
                              AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                               OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                               OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        END IF
                        IF l_n>0 THEN
                           CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
                           NEXT FIELD hrdn10
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
           WHEN INFIELD(hrdn02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01_1"
              LET g_qryparam.default1 = g_hrdn.hrdn02
              CALL cl_create_qry() RETURNING g_hrdn.hrdn02
              DISPLAY BY NAME g_hrdn.hrdn02
              NEXT FIELD hrdn02
           
           WHEN INFIELD(hrdn03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbr01"
              LET g_qryparam.default1 = g_hrdn.hrdn03
              CALL cl_create_qry() RETURNING g_hrdn.hrdn03
              DISPLAY BY NAME g_hrdn.hrdn03
              NEXT FIELD hrdn03
           
           WHEN INFIELD(hrdn04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbr01"
              LET g_qryparam.default1 = g_hrdn.hrdn04
              CALL cl_create_qry() RETURNING g_hrdn.hrdn04
              DISPLAY BY NAME g_hrdn.hrdn04
              NEXT FIELD hrdn04
              
           WHEN INFIELD(hrdn09)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrdn.hrdn09
              CALL cl_create_qry() RETURNING g_hrdn.hrdn09
              DISPLAY BY NAME g_hrdn.hrdn09
              NEXT FIELD hrdn09
              
           WHEN INFIELD(hrdn10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrdn.hrdn10
              CALL cl_create_qry() RETURNING g_hrdn.hrdn10
              DISPLAY BY NAME g_hrdn.hrdn10
              NEXT FIELD hrdn10
              
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
	
FUNCTION i081_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdn.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i081_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i081_count
    FETCH i081_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i081_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdn.hrdn01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdn.* TO NULL
    ELSE
        CALL i081_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i081_b_fill(g_wc)
    END IF
END FUNCTION
	
FUNCTION i081_fetch(p_flhrdn)
    DEFINE p_flhrdn         LIKE type_file.chr1

    CASE p_flhrdn
        WHEN 'N' FETCH NEXT     i081_cs INTO g_hrdn.hrdn01
        WHEN 'P' FETCH PREVIOUS i081_cs INTO g_hrdn.hrdn01
        WHEN 'F' FETCH FIRST    i081_cs INTO g_hrdn.hrdn01
        WHEN 'L' FETCH LAST     i081_cs INTO g_hrdn.hrdn01
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
            FETCH ABSOLUTE g_jump i081_cs INTO g_hrdn.hrdn01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdn.hrdn01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdn.* TO NULL
        LET g_hrdn.hrdn01 = NULL
        RETURN
    ELSE
      CASE p_flhrdn
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      #DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrdn.* FROM hrdn_file    
       WHERE hrdn01 = g_hrdn.hrdn01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrdn_file",g_hrdn.hrdn01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i081_show()                 
    END IF
END FUNCTION	
	
FUNCTION i081_show()
DEFINE l_hrdn02_desc     LIKE     hrat_file.hrat02
DEFINE l_hrdn03_desc     LIKE     hrbr_file.hrbr02	
DEFINE l_hrdn04_desc     LIKE     hrbr_file.hrbr02

    SELECT * INTO g_hrdn.* FROM hrdn_file WHERE hrdn01=g_hrdn.hrdn01

    LET g_hrdn_t.* = g_hrdn.*
    SELECT hrat01 INTO g_hrdn.hrdn02 FROM hrat_file WHERE hratid=g_hrdn.hrdn02
    DISPLAY BY NAME g_hrdn.hrdn02,g_hrdn.hrdn03,
                    g_hrdn.hrdn04,g_hrdn.hrdn05,
                    g_hrdn.hrdn09,g_hrdn.hrdn08,g_hrdn.hrdn13,g_hrdn.hrdn10,
                    g_hrdn.hrdn07,g_hrdn.hrdn12,
                    g_hrdn.hrdnuser,g_hrdn.hrdngrup,g_hrdn.hrdnmodu,
                    g_hrdn.hrdndate,g_hrdn.hrdnacti,g_hrdn.hrdnorig,g_hrdn.hrdnoriu
    
    SELECT hrat02 INTO l_hrdn02_desc FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
    SELECT hrbr02 INTO l_hrdn03_desc FROM hrbr_file WHERE hrbr01=g_hrdn.hrdn03
    SELECT hrbr02 INTO l_hrdn04_desc FROM hrbr_file WHERE hrbr01=g_hrdn.hrdn04
                                                                                                                                             
    DISPLAY l_hrdn02_desc TO hrdn02_desc
    DISPLAY l_hrdn03_desc TO hrdn03_desc
    DISPLAY l_hrdn04_desc TO hrdn04_desc
    CALL cl_show_fld_cont()
END FUNCTION
	
FUNCTION i081_u()
DEFINE l_hrdn    RECORD LIKE  hrdn_file.*

    IF g_hrdn.hrdn01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    SELECT * INTO g_hrdn.* FROM hrdn_file WHERE hrdn01=g_hrdn.hrdn01
    
    IF g_hrdn.hrdnacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    	
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i081_cl USING g_hrdn.hrdn01
    IF STATUS THEN
       CALL cl_err("OPEN i081_cl:", STATUS, 1)
       CLOSE i081_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i081_cl INTO g_hrdn.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdn.hrdn01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i081_show()                          
    WHILE TRUE
        CALL i081_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdn.*=g_hrdn_t.*
            CALL i081_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrdn.hrdnmodu=g_user
        LET g_hrdn.hrdndate=g_today	
        
        LET l_hrdn.*=g_hrdn.*
        SELECT hratid INTO l_hrdn.hrdn02 FROM hrat_file WHERE hrat01=g_hrdn.hrdn02
        
        UPDATE hrdn_file SET hrdn_file.* = l_hrdn.*    
            WHERE hrdn01 = g_hrdn_t.hrdn01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdn_file",g_hrdn.hrdn01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i081_show()	
        EXIT WHILE
    END WHILE
    CLOSE i081_cl
    COMMIT WORK
    CALL i081_b_fill(g_wc)
END FUNCTION
	
FUNCTION i081_x()
    IF g_hrdn.hrdn01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i081_cl USING g_hrdn.hrdn01
    IF STATUS THEN
       CALL cl_err("OPEN i081_cl:", STATUS, 1)
       CLOSE i081_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i081_cl INTO g_hrdn.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdn.hrdn01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i081_show()
    IF cl_exp(0,0,g_hrdn.hrdnacti) THEN
        LET g_chr = g_hrdn.hrdnacti
        IF g_hrdn.hrdnacti='Y' THEN
            LET g_hrdn.hrdnacti='N'
        ELSE
            LET g_hrdn.hrdnacti='Y'
        END IF
        UPDATE hrdn_file
            SET hrdnacti=g_hrdn.hrdnacti
            WHERE hrdn01=g_hrdn.hrdn01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrdn.hrdn01,SQLCA.sqlcode,0)
            LET g_hrdn.hrdnacti = g_chr
        END IF
        DISPLAY BY NAME g_hrdn.hrdnacti
    END IF
    CLOSE i081_cl
    COMMIT WORK
    CALL i081_b_fill(g_wc)
END FUNCTION
	
FUNCTION i081_r()
    IF g_hrdn.hrdn01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i081_cl USING g_hrdn.hrdn01
    IF STATUS THEN
       CALL cl_err("OPEN i081_cl:", STATUS, 0)
       CLOSE i081_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i081_cl INTO g_hrdn.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdn.hrdn01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i081_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrdn01"
       LET g_doc.value1 = g_hrdn.hrdn01
       CALL cl_del_doc()
       
       DELETE FROM hrdn_file WHERE hrdn01 = g_hrdn.hrdn01
       
       CLEAR FORM
       OPEN i081_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i081_cl
          CLOSE i081_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i081_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i081_cl
          CLOSE i081_count
          COMMIT WORK
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL i081_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i081_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i081_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i081_fetch('/')
       END IF
    END IF
    CLOSE i081_cl
    COMMIT WORK
    CALL i081_b_fill(g_wc)
END FUNCTION
	
FUNCTION i081_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrdn_b.clear()
        
        LET l_sql=" SELECT hrdn02,'','','','','',hrdn03,hrdn04,hrdn05,hrdn08,hrdn07,hrdn09,hrdn10,hrdn12,hrdn01 ",
                  "   FROM hrdn_file,hrat_file WHERE ",p_wc CLIPPED,
                  "    AND hrdn02=hratid ",
                  "  ORDER BY hrdn01 "
                  
        PREPARE i081_b_pre FROM l_sql
        DECLARE i081_b_cs CURSOR FOR i081_b_pre
        
        LET l_i=1
        
        FOREACH i081_b_cs INTO g_hrdn_b[l_i].*
        
           SELECT hrat01 INTO g_hrdn_b[l_i].hrdn02 FROM hrat_file WHERE hratid=g_hrdn_b[l_i].hrdn02
           SELECT hrat02 INTO g_hrdn_b[l_i].hrat02 FROM hrat_file WHERE hrat01=g_hrdn_b[l_i].hrdn02
           SELECT hrao02 INTO g_hrdn_b[l_i].hrat04 FROM hrat_file,hrao_file
            WHERE hrat04=hrao01 AND hrat01=g_hrdn_b[l_i].hrdn02
           SELECT hras04 INTO g_hrdn_b[l_i].hrat05 FROM hrat_file,hras_file
            WHERE hras01=hrat05 AND hrat01=g_hrdn_b[l_i].hrdn02
           SELECT hrat66 INTO g_hrdn_b[l_i].hrat66 FROM hrat_file WHERE hrat01=g_hrdn_b[l_i].hrdn02     
           SELECT hrad03 INTO g_hrdn_b[l_i].hrat19 FROM hrat_file,hrad_file
            WHERE hrat19=hrad02 AND hrat01=g_hrdn_b[l_i].hrdn02
           SELECT hrbr02 INTO g_hrdn_b[l_i].hrdn03 FROM hrbr_file WHERE hrbr01=g_hrdn_b[l_i].hrdn03
           SELECT hrbr02 INTO g_hrdn_b[l_i].hrdn04 FROM hrbr_file WHERE hrbr01=g_hrdn_b[l_i].hrdn04
              
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrdn_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrdn_b TO s_hrdn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION
	
FUNCTION i081_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i081_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrdn_file.*
           INTO g_hrdn.*
           FROM hrdn_file
          WHERE hrdn01=g_hrdn_b[l_ac].hrdn01
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i081_fetch('/')
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
               CALL i081_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i081_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i081_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i081_u()
            END IF
            EXIT WHILE

        WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i081_x()
               CALL i081_show()
            END IF     	        	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdn_b),'','')
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


FUNCTION i081_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdn_b TO s_hrdn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i081_fetch('/')
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
         CALL i081_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL cl_set_comp_visible("Page3", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", TRUE)    #NO.FUN-840018 ADD
         EXIT DISPLAY

      ON ACTION first
         CALL i081_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i081_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i081_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i081_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i081_fetch('L')
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
   
      AFTER DISPLAY
         CONTINUE DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION								
