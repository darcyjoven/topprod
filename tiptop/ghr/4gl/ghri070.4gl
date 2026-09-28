# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri070.4gl
# Descriptions...: 
# Date & Author..: 03/19/13 by zhangbo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrda    RECORD LIKE hrda_file.*
DEFINE  g_hrda_t  RECORD LIKE hrda_file.*
DEFINE  g_hrda_1  DYNAMIC ARRAY OF RECORD
          hrda00_1     LIKE   hrda_file.hrda00,
          hrda01_1     LIKE   hrda_file.hrda01,
          hrat02_1     LIKE   hrat_file.hrat02,
          hrat04_1     LIKE   hrao_file.hrao02,
          hrat05_1     LIKE   hras_file.hras04,
          hrda02_1     LIKE   hrda_file.hrda02,
          hrcz02_1     LIKE   hrcz_file.hrcz02,
          hrda03_1     LIKE   hrda_file.hrda03,
          hrda04_1     LIKE   hrda_file.hrda04,
          hrda05_1     LIKE   hrda_file.hrda05,
          hrda06_1     LIKE   hrda_file.hrda06,
          hrda07_1     LIKE   hrda_file.hrda07,
          hrda08_1     LIKE   hrda_file.hrda08
                  END RECORD
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_hrda01            LIKE hrda_file.hrda01
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
 
   INITIALIZE g_hrda.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrda_file WHERE hrda00 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i070_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i070_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri070"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_set_combo_items("hrat17",NULL,NULL)
   CALL cl_set_combo_items("hrat22",NULL,NULL)
   #性别
   CALL i070_get_items('333') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrat17",l_name,l_items)
   #学历
   CALL i070_get_items('317') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrat22",l_name,l_items) 
     
   CALL cl_ui_init()
   
   
   
   LET g_action_choice=""
   CALL i070_menu()
 
   CLOSE WINDOW i070_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i070_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i070_get_items_pre FROM l_sql
       DECLARE i070_get_items CURSOR FOR i070_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i070_get_items INTO l_hrag06,l_hrag07
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

FUNCTION i070_curs()

    CLEAR FORM
    INITIALIZE g_hrda.* TO NULL
    CONSTRUCT BY NAME g_wc ON                              
        hrda01,hrda02,hrda03,hrda04,hrda05,hrda06,
        hrda07,hrda08

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrda01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrda.hrda01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrda01
                 NEXT FIELD hrda01
                 
              WHEN INFIELD(hrda02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrcz01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrda.hrda02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrda02
                 NEXT FIELD hrda02
                 
             WHEN INFIELD(hrda03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrct11"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrda.hrda03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrda03
                 NEXT FIELD hrda03
                    
                        
             WHEN INFIELD(hrda04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrct11"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrda.hrda04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrda04
                 NEXT FIELD hrda04

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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdauser', 'hrdagrup')  #
                                                                     
    CALL cl_replace_str(g_wc,'hrda01','hrat01') RETURNING g_wc

    LET g_sql = "SELECT DISTINCT hrda00 FROM hrda_file,hrat_file ",                       #
                " WHERE ",g_wc CLIPPED,
                "   AND hratid=hrda01 ", 
                " ORDER BY hrda00"
    PREPARE i070_prepare FROM g_sql
    DECLARE i070_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i070_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrda00) FROM hrda_file,hrat_file WHERE ",g_wc CLIPPED,
                "   AND hratid=hrda01 "
    PREPARE i070_precount FROM g_sql
    DECLARE i070_count CURSOR FOR i070_precount
END FUNCTION
	
FUNCTION i070_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i070_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i070_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i070_q()
            END IF

        ON ACTION next
            CALL i070_fetch('N')

        ON ACTION previous
            CALL i070_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i070_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i070_r()
            END IF
            	       	   	

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i070_fetch('/')

        ON ACTION first
            CALL i070_fetch('F')

        ON ACTION last
            CALL i070_fetch('L')

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
              IF g_hrda.hrda00 IS NOT NULL THEN
                 LET g_doc.column1 = "hrda00"
                 LET g_doc.value1 = g_hrda.hrda00
                 CALL cl_doc()
              END IF
           END IF
           	
        ON ACTION exporttoexcel   #No.FUN-4B0020
           LET g_action_choice = 'exporttoexcel'
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrda_1),'','')
           END IF   	
    END MENU

END FUNCTION	
	
FUNCTION i070_a()
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING	
DEFINE l_no         LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_hrda00     LIKE  hrda_file.hrda00
DEFINE l_hrda       RECORD LIKE  hrda_file.*

    CLEAR FORM                                   #
    INITIALIZE g_hrda.* LIKE hrda_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrda.hrdauser = g_user
        LET g_hrda.hrdaoriu = g_user
        LET g_hrda.hrdaorig = g_grup
        LET g_hrda.hrdagrup = g_grup               #
        LET g_hrda.hrdadate = g_today
        LET g_hrda.hrdaacti = 'Y'
        CALL i070_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrda.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrda.hrda02 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        	
        LET l_year=YEAR(g_today) USING "&&&&"
        LET l_month=MONTH(g_today) USING "&&"
        LET l_day=DAY(g_today) USING "&&"
        LET l_year=l_year.trim()
        LET l_month=l_month.trim()
        LET l_day=l_day.trim()
        LET g_hrda.hrda00=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
        LET l_hrda00=g_hrda.hrda00,"%"
        LET l_sql="SELECT MAX(hrda00) FROM hrda_file",
                  " WHERE hrda00 LIKE '",l_hrda00,"'"
        PREPARE i070_hrda00 FROM l_sql
        EXECUTE i070_hrda00 INTO g_hrda.hrda00
        IF cl_null(g_hrda.hrda00) THEN 
           LET g_hrda.hrda00=l_hrda00[1,8],'0001'
        ELSE
           LET l_no=g_hrda.hrda00[9,12]
           LET l_no=l_no+1 USING "&&&&"
           LET g_hrda.hrda00=l_hrda00[1,8],l_no
        END IF
        	
        LET l_hrda.*=g_hrda.*
        SELECT hratid INTO l_hrda.hrda01 FROM hrat_file WHERE hrat01=g_hrda.hrda01
        	
        INSERT INTO hrda_file VALUES(l_hrda.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrda_file",g_hrda.hrda00,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrda00 INTO g_hrda.hrda00 FROM hrda_file WHERE hrda00 = g_hrda.hrda00
            CALL i070_b_fill(g_wc)
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION	
	
FUNCTION i070_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_sql         STRING
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hrat04      LIKE hrao_file.hrao02
   DEFINE l_hrat05      LIKE hras_file.hras04
   DEFINE l_hrat06      LIKE hrat_file.hrat02
   DEFINE l_hrat42      LIKE hrai_file.hrai04
   DEFINE l_hrat17      LIKE hrat_file.hrat17
   DEFINE l_hrat22      LIKE hrat_file.hrat22
   DEFINE l_hrat25      LIKE hrat_file.hrat25
   DEFINE l_hrcz02      LIKE hrcz_file.hrcz02
   #DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
   #DEFINE l_hrct08_e,l_hrct08_b    LIKE hrct_file.hrct08 
   DEFINE l_hrct07_b,l_hrct07_e    DATE     #hrct_file还未建
   DEFINE l_hrct08_e,l_hrct08_b    DATE
   DEFINE l_hratid      LIKE hrat_file.hratid  
   DEFINE l_hrat03      LIKE hrat_file.hrat03
   
   DISPLAY BY NAME
      g_hrda.hrda01,g_hrda.hrda02,g_hrda.hrda03,g_hrda.hrda04,
      g_hrda.hrda05,g_hrda.hrda06,g_hrda.hrda07,g_hrda.hrda08

   INPUT BY NAME
      g_hrda.hrda01,g_hrda.hrda02,g_hrda.hrda03,g_hrda.hrda04,
      g_hrda.hrda05,g_hrda.hrda06,g_hrda.hrda07,g_hrda.hrda08
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          #CALL i070_set_entry(p_cmd)
          #CALL i070_set_no_entry(p_cmd)
          IF NOT cl_null(g_hrda.hrda01) THEN
             CALL cl_set_comp_entry("hrda03,hrda04",TRUE)
          ELSE
             CALL cl_set_comp_entry("hrda03,hrda04",FALSE)
          END IF
          LET g_before_input_done = TRUE
      
      AFTER FIELD hrda01
         IF NOT cl_null(g_hrda.hrda01) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrda.hrda01
         	                                            AND hratconf='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此员工编号','!',0)
         	  	 NEXT FIELD hrda01
         	  END IF	
         	  
                  SELECT hratid,hrat03 INTO l_hratid,l_hrat03 FROM hrat_file WHERE hrat01=g_hrda.hrda01
         	  #IF g_hrda.hrda01 != g_hrda_t.hrda01 OR g_hrda_t.hrda01 IS NULL THEN     
                  IF l_hratid != g_hrda_t.hrda01 OR g_hrda_t.hrda01 IS NULL THEN                                    	
         	     IF NOT cl_null(g_hrda.hrda02) AND NOT cl_null(g_hrda.hrda03) 
         	        AND NOT cl_null(g_hrda.hrda04) THEN
         	        LET l_n=0
         	        SELECT hrct07 INTO l_hrct07_b FROM hrct_file 
         	         WHERE hrct11=g_hrda.hrda03
                           AND hrct03=l_hrat03
         	        SELECT hrct08 INTO l_hrct08_e FROM hrct_file 
         	         WHERE hrct11=g_hrda.hrda04
                           AND hrct03=l_hrat03
         	        #SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrda.hrda01 
                        IF p_cmd='a' THEN
         	           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrda_file 
         	             WHERE hrda01=l_hratid
         	               AND hrda02=g_hrda.hrda02
                               #AND hrda00<>g_hrda.hrda00
         	               AND A.hrct11=hrda03
         	               AND B.hrct11=hrda04
                               AND A.hrct03=l_hrat03
                               AND B.hrct03=l_hrat03
         	               AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
         	                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
         	                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e)) 
                        ELSE
                           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrda_file
                             WHERE hrda01=l_hratid
                               AND hrda02=g_hrda.hrda02
                               AND hrda00<>g_hrda.hrda00
                               AND A.hrct11=hrda03
                               AND B.hrct11=hrda04
                               AND A.hrct03=l_hrat03
                               AND B.hrct03=l_hrat03
                               AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
         	        END IF    
         	        IF l_n>0 THEN
         	           CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
         	           NEXT FIELD hrda01
         	        END IF
         	     END IF           
         	  END IF 
         	  	
         	  SELECT hrat02,hrat04,hrat05,hrat06,hrat17,hrat22,hrat25,hrat42
         	    INTO l_hrat02,l_hrat04,l_hrat05,l_hrat06,l_hrat17,l_hrat22,l_hrat25,l_hrat42 
         	    FROM hrat_file
         	   WHERE hrat01=g_hrda.hrda01
         	     #AND hrat04=hrao01
         	     #AND hrat05=hras01
         	     #AND hrat42=hrai03
                  SELECT hrao02 INTO l_hrat04 FROM hrao_file WHERE hrao01=l_hrat04
                  SELECT hras04 INTO l_hrat05 FROM hras_file WHERE hras01=l_hrat05
                  SELECT hrai04 INTO l_hrat42 FROM hrai_file WHERE hrai03=l_hrat42
         	  DISPLAY l_hrat02 TO hrat02
         	  DISPLAY l_hrat04 TO hrat04
         	  DISPLAY l_hrat05 TO hrat05
         	  DISPLAY l_hrat06 TO hrat06
         	  DISPLAY l_hrat17 TO hrat17    	        	    	
         	  DISPLAY l_hrat22 TO hrat22
         	  DISPLAY l_hrat25 TO hrat25
         	  DISPLAY l_hrat42 TO hrat42
             CALL cl_set_comp_entry("hrda03,hrda04",TRUE)
         ELSE   
             CALL cl_set_comp_entry("hrda03,hrda04",FALSE)	  
         END IF
         	
      AFTER FIELD hrda02
         IF NOT cl_null(g_hrda.hrda02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrcz_file WHERE hrcz01=g_hrda.hrda02
         	                                            AND hrczacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此周期薪资','!',0)
         	  	 NEXT FIELD hrda02      
         	  END IF
         	  	   	
         	  SELECT hrcz02 INTO l_hrcz02 FROM hrcz_file WHERE hrcz01=g_hrda.hrda02
         	                                               AND hrczacti='Y'	
         	  DISPLAY l_hrcz02 TO hrcz02
         	  
         	  IF g_hrda.hrda02 != g_hrda_t.hrda02 OR g_hrda_t.hrda02 IS NULL THEN                                         	
         	     IF NOT cl_null(g_hrda.hrda01) AND NOT cl_null(g_hrda.hrda03) 
         	        AND NOT cl_null(g_hrda.hrda04) THEN
                        SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrda.hrda01
         	        LET l_n=0
         	        SELECT hrct07 INTO l_hrct07_b FROM hrct_file 
         	         WHERE hrct11=g_hrda.hrda03
                           AND hrct03=l_hrat03
         	        SELECT hrct08 INTO l_hrct08_e FROM hrct_file 
         	         WHERE hrct11=g_hrda.hrda04
                           AND hrct03=l_hrat03
         	        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrda.hrda01 
                        IF p_cmd='a' THEN
         	           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrda_file 
         	             WHERE hrda01=l_hratid
         	               AND hrda02=g_hrda.hrda02
                               #AND hrda00<>g_hrda.hrda00
         	               AND A.hrct11=hrda03
         	               AND B.hrct11=hrda04
                               AND A.hrct03=l_hrat03
                               AND B.hrct03=l_hrat03
         	               AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
         	                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
         	                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        ELSE
                           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrda_file
                             WHERE hrda01=l_hratid
                               AND hrda02=g_hrda.hrda02
                               AND hrda00<>g_hrda.hrda00
                               AND A.hrct11=hrda03
                               AND B.hrct11=hrda04
                               AND A.hrct03=l_hrat03
                               AND B.hrct03=l_hrat03
                               AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        END IF
         	            
         	        IF l_n>0 THEN
         	           CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
         	           NEXT FIELD hrda02
         	        END IF
         	     END IF           
         	  END IF         	    	                                               	 		
         END IF	  			           
         	                                    	  		                                           
      AFTER FIELD hrda03
         IF g_hrda.hrda03 IS NOT NULL THEN
         	  LET l_n=0
                  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrda.hrda01
         	  SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrda.hrda03
                                                            AND hrct03=l_hrat03
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此薪资发放周期','!',0)
         	  	 NEXT FIELD hrda03      #hrct_file还未建,测试MARK
         	  END IF
         	  	
         	  IF NOT cl_null(g_hrda.hrda04) THEN
         	  	 #SELECT hrct08 INTO l_hrct08_b FROM hrct_file WHERE hrct11=g_hrda.hrda03   #mark by zhangbo130705
                         SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrda.hrda03    #add by zhangbo130705
                                                                        AND hrct03=l_hrat03
         	  	 SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrda.hrda04
                                                                        AND hrct03=l_hrat03
         	  	 #IF l_hrct08_b>=l_hrct07_e THEN     #mark by zhangbo130705
                         IF l_hrct07_b>l_hrct07_e THEN       #add by zhangbo130705--关联公司只需要比较开始日期或者结束日期            
         	  	 	  CALL cl_err('开始期间不可比结束期间大','!',0)
         	  	 	  NEXT FIELD hrda03     #hrct_file还未建,测试MARK
         	  	 END IF
         	  END IF
         	  	
         	  IF g_hrda.hrda03 != g_hrda_t.hrda03 OR g_hrda_t.hrda03 IS NULL THEN                                         	
         	     IF NOT cl_null(g_hrda.hrda01) AND NOT cl_null(g_hrda.hrda02) 
         	        AND NOT cl_null(g_hrda.hrda04) THEN
         	        LET l_n=0
         	        SELECT hrct07 INTO l_hrct07_b FROM hrct_file 
         	         WHERE hrct11=g_hrda.hrda03
                           AND hrct03=l_hrat03
         	        SELECT hrct08 INTO l_hrct08_e FROM hrct_file 
         	         WHERE hrct11=g_hrda.hrda04
                           AND hrct03=l_hrat03
         	        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrda.hrda01
                        IF p_cmd='a' THEN
         	           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrda_file 
         	             WHERE hrda01=l_hratid
         	               AND hrda02=g_hrda.hrda02
                               #AND hrda00<>g_hrda.hrda00
         	               AND A.hrct11=hrda03
         	               AND B.hrct11=hrda04
                               AND A.hrct03=l_hrat03
                               AND B.hrct03=l_hrat03
         	               AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
         	                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
         	                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        ELSE
                           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrda_file
                             WHERE hrda01=l_hratid
                               AND hrda02=g_hrda.hrda02
                               AND hrda00<>g_hrda.hrda00
                               AND A.hrct11=hrda03
                               AND B.hrct11=hrda04
                               AND A.hrct03=l_hrat03
                               AND B.hrct03=l_hrat03
                               AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        END IF
         	            
         	        IF l_n>0 THEN
         	           CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
         	           NEXT FIELD hrda03
         	        END IF
         	     END IF           
         	  END IF         	    	  		 		  
         	  	 		 
         END IF
         	
      AFTER FIELD hrda04
         IF NOT cl_null(g_hrda.hrda04) THEN
                  LET l_n=0
                  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrda.hrda01
         	  SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrda.hrda04
                                                            AND hrct03=l_hrat03
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此薪资发放周期','!',0)
         	  	 NEXT FIELD hrda04      #hrct_file还未建,测试MARK
         	  END IF
         	  	
         	  IF NOT cl_null(g_hrda.hrda03) THEN
         	  	 #SELECT hrct08 INTO l_hrct08_b FROM hrct_file WHERE hrct11=g_hrda.hrda03    #mark by zhangbo130705
                         SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrda.hrda03     #add by zhangbo130705
                                                                        AND hrct03=l_hrat03
         	  	 SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrda.hrda04
                                                                        AND hrct03=l_hrat03
         	  	 #IF l_hrct08_b>=l_hrct07_e THEN    #mark by zhangbo130705
                         IF l_hrct07_b>l_hrct07_e THEN     #add by zhangbo130705--开始日期可以相等,即只设置一个月
         	  	 	  CALL cl_err('开始期间不可比结束期间大','!',0)
         	  	 	  NEXT FIELD hrda04     #hrct_file还未建,测试MARK
         	  	 END IF
         	  END IF
         	  	
         	  IF g_hrda.hrda04 != g_hrda_t.hrda04 OR g_hrda_t.hrda04 IS NULL THEN                                         	
         	     IF NOT cl_null(g_hrda.hrda01) AND NOT cl_null(g_hrda.hrda02) 
         	        AND NOT cl_null(g_hrda.hrda03) THEN
         	        LET l_n=0
         	        SELECT hrct07 INTO l_hrct07_b FROM hrct_file 
         	         WHERE hrct11=g_hrda.hrda03
                           AND hrct03=l_hrat03
         	        SELECT hrct08 INTO l_hrct08_e FROM hrct_file 
         	         WHERE hrct11=g_hrda.hrda04
                           AND hrct03=l_hrat03 
         	        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrda.hrda01 
                        IF p_cmd='a' THEN
         	           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrda_file 
         	             WHERE hrda01=l_hratid
         	               AND hrda02=g_hrda.hrda02
                               #AND hrda00<>g_hrda.hrda00
         	               AND A.hrct11=hrda03
         	               AND B.hrct11=hrda04
                               AND A.hrct03=l_hrat03
                               AND B.hrct03=l_hrat03
         	               AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
         	                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
         	                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
                        ELSE
                           SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrda_file
                             WHERE hrda01=l_hratid
                               AND hrda02=g_hrda.hrda02
                               AND hrda00<>g_hrda.hrda00
                               AND A.hrct11=hrda03
                               AND B.hrct11=hrda04
                               AND A.hrct03=l_hrat03
                               AND B.hrct03=l_hrat03
                               AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
         	        END IF    
         	        IF l_n>0 THEN
         	           CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
         	           NEXT FIELD hrda04
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
           WHEN INFIELD(hrda01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = g_hrda.hrda01
              CALL cl_create_qry() RETURNING g_hrda.hrda01
              DISPLAY BY NAME g_hrda.hrda01
              NEXT FIELD hrda01
           
           WHEN INFIELD(hrda02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrcz01"
              LET g_qryparam.default1 = g_hrda.hrda02
              CALL cl_create_qry() RETURNING g_hrda.hrda02
              DISPLAY BY NAME g_hrda.hrda02
              NEXT FIELD hrda02
           
           WHEN INFIELD(hrda03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrda.hrda03
              CALL cl_create_qry() RETURNING g_hrda.hrda03
              DISPLAY BY NAME g_hrda.hrda03
              NEXT FIELD hrda03
              
           WHEN INFIELD(hrda04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.default1 = g_hrda.hrda04
              CALL cl_create_qry() RETURNING g_hrda.hrda04
              DISPLAY BY NAME g_hrda.hrda04
              NEXT FIELD hrda04
              
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
	
FUNCTION i070_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrda.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i070_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i070_count
    FETCH i070_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i070_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrda.hrda00,SQLCA.sqlcode,0)
        INITIALIZE g_hrda.* TO NULL
    ELSE
        CALL i070_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i070_b_fill(g_wc)
    END IF
END FUNCTION


FUNCTION i070_fetch(p_flhrda)
    DEFINE p_flhrda         LIKE type_file.chr1

    CASE p_flhrda
        WHEN 'N' FETCH NEXT     i070_cs INTO g_hrda.hrda00
        WHEN 'P' FETCH PREVIOUS i070_cs INTO g_hrda.hrda00
        WHEN 'F' FETCH FIRST    i070_cs INTO g_hrda.hrda00
        WHEN 'L' FETCH LAST     i070_cs INTO g_hrda.hrda00
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
            FETCH ABSOLUTE g_jump i070_cs INTO g_hrda.hrda00
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrda.hrda00,SQLCA.sqlcode,0)
        INITIALIZE g_hrda.* TO NULL
        LET g_hrda.hrda00 = NULL
        RETURN
    ELSE
      CASE p_flhrda
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrda.* FROM hrda_file    
       WHERE hrda00 = g_hrda.hrda00
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrda_file",g_hrda.hrda00,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i070_show()                 
    END IF
END FUNCTION	
	
FUNCTION i070_show()
DEFINE l_hrat02      LIKE hrat_file.hrat02
DEFINE l_hrat04      LIKE hrao_file.hrao02
DEFINE l_hrat05      LIKE hras_file.hras04
DEFINE l_hrat06      LIKE hrat_file.hrat02
DEFINE l_hrat42      LIKE hrai_file.hrai04
DEFINE l_hrat17      LIKE hrat_file.hrat17
DEFINE l_hrat22      LIKE hrat_file.hrat22
DEFINE l_hrat25      LIKE hrat_file.hrat25
DEFINE l_hrcz02      LIKE hrcz_file.hrcz02

    LET g_hrda_t.* = g_hrda.*
    SELECT hrat01 INTO g_hrda.hrda01 FROM hrat_file WHERE hratid=g_hrda.hrda01 
    DISPLAY BY NAME g_hrda.hrda01,g_hrda.hrda02,g_hrda.hrda03,
                    g_hrda.hrda04,g_hrda.hrda05,g_hrda.hrda06,
                    g_hrda.hrda07,g_hrda.hrda08
    SELECT hrat02,hrat04,hrat05,hrat06,hrat17,hrat22,hrat25,hrat42
      INTO l_hrat02,l_hrat04,l_hrat05,l_hrat06,l_hrat17,l_hrat22,l_hrat25,l_hrat42 
      FROM hrat_file
     WHERE hrat01=g_hrda.hrda01
       #AND hrat04=hrao01
       #AND hrat05=hras01
       #AND hrat42=hrai03

    SELECT hrao02 INTO l_hrat04 FROM hrao_file WHERE hrao01=l_hrat04
    SELECT hras04 INTO l_hrat05 FROM hras_file WHERE hras01=l_hrat05
    SELECT hrai04 INTO l_hrat42 FROM hrai_file WHERE hrai03=l_hrat42
    SELECT hrcz02 INTO l_hrcz02 FROM hrcz_file WHERE hrcz01=g_hrda.hrda02   
    DISPLAY l_hrat02 TO hrat02
    DISPLAY l_hrat04 TO hrat04
    DISPLAY l_hrat05 TO hrat05
    DISPLAY l_hrat06 TO hrat06
    DISPLAY l_hrat17 TO hrat17    	        	    	
    DISPLAY l_hrat22 TO hrat22
    DISPLAY l_hrat25 TO hrat25
    DISPLAY l_hrat42 TO hrat42
    DISPLAY l_hrcz02 TO hrcz02   
    CALL cl_show_fld_cont()
END FUNCTION
	
FUNCTION i070_u()
DEFINE l_hrda    RECORD LIKE  hrda_file.*

    IF g_hrda.hrda00 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrda.* FROM hrda_file WHERE hrda00=g_hrda.hrda00
    IF g_hrda.hrdaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i070_cl USING g_hrda.hrda00
    IF STATUS THEN
       CALL cl_err("OPEN i070_cl:", STATUS, 1)
       CLOSE i070_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i070_cl INTO g_hrda.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrda.hrda01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i070_show()                          
    WHILE TRUE
        CALL i070_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrda.*=g_hrda_t.*
            CALL i070_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrda.hrdamodu=g_user
        LET g_hrda.hrdadate=g_today
        LET l_hrda.*=g_hrda.*
        SELECT hratid INTO l_hrda.hrda01 FROM hrat_file WHERE hrat01=g_hrda.hrda01	
        UPDATE hrda_file SET hrda_file.* = l_hrda.*    
         WHERE hrda00 = g_hrda_t.hrda00
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrda_file",g_hrda.hrda00,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        SELECT * INTO g_hrda.* FROM hrda_file WHERE hrda00=g_hrda_t.hrda00
        CALL i070_show()	
        EXIT WHILE
    END WHILE
    CLOSE i070_cl
    COMMIT WORK
    CALL i070_b_fill(g_wc)
END FUNCTION
	
FUNCTION i070_r()
    IF g_hrda.hrda00 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i070_cl USING g_hrda.hrda00
    IF STATUS THEN
       CALL cl_err("OPEN i070_cl:", STATUS, 0)
       CLOSE i070_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i070_cl INTO g_hrda.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrda.hrda01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i070_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrda00"
       LET g_doc.value1 = g_hrda.hrda00
       CALL cl_del_doc()

       DELETE FROM hrda_file WHERE hrda00 = g_hrda.hrda00
       
       CLEAR FORM
       OPEN i070_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i070_cl
          CLOSE i070_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i070_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i070_cl
          CLOSE i070_count
          COMMIT WORK
          CALL i070_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i070_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i070_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i070_fetch('/')
       END IF
    END IF
    CLOSE i070_cl
    COMMIT WORK
    CALL i070_b_fill(g_wc)
END FUNCTION
	
FUNCTION i070_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrda_1.clear()
        
        LET l_sql=" SELECT hrda00,hrda01,'','','',hrda02,'',hrda03,hrda04,hrda05,hrda06,hrda07,hrda08 ",
                  "   FROM hrda_file,hrat_file WHERE ",p_wc CLIPPED,
                  "    AND hratid=hrda01 ",
                  "  ORDER BY hrda00 "
                  
        PREPARE i070_b_pre FROM l_sql
        DECLARE i070_b_cs CURSOR FOR i070_b_pre
        
        LET l_i=1
        
        FOREACH i070_b_cs INTO g_hrda_1[l_i].*
        
           SELECT hrat01 INTO g_hrda_1[l_i].hrda01_1 FROM hrat_file
            WHERE hratid=g_hrda_1[l_i].hrda01_1
        
           SELECT hrat02,hrat04,hrat05 
             INTO g_hrda_1[l_i].hrat02_1,g_hrda_1[l_i].hrat04_1,g_hrda_1[l_i].hrat05_1
             FROM hrat_file
            WHERE hrat01=g_hrda_1[l_i].hrda01_1  
           SELECT hrao02 INTO g_hrda_1[l_i].hrat04_1 FROM hrao_file WHERE hrao01=g_hrda_1[l_i].hrat04_1
           SELECT hras04 INTO g_hrda_1[l_i].hrat05_1 FROM hras_file WHERE hras01=g_hrda_1[l_i].hrat05_1  
           SELECT hrcz02 INTO g_hrda_1[l_i].hrcz02_1 FROM hrcz_file WHERE hrcz01=g_hrda_1[l_i].hrda02_1
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrda_1.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrda_1 TO s_hrda_1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION 
	
FUNCTION i070_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i070_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrda_file.*
           INTO g_hrda.*
           FROM hrda_file
          WHERE hrda00=g_hrda_1[l_ac].hrda00_1
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i070_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
      END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN    
               CALL i070_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i070_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i070_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i070_u()
            END IF
            EXIT WHILE

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrda_1),'','')
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


FUNCTION i070_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrda_1 TO s_hrda_1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i070_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DISPLAY

      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i070_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DISPLAY

      ON ACTION first
         CALL i070_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i070_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i070_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i070_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i070_fetch('L')
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
				
	
	
	
	
