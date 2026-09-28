# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri085.4gl
# Descriptions...: 
# Date & Author..: 07/01/13 by zhangbo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"


DEFINE  g_hrdr    RECORD LIKE hrdr_file.*
DEFINE  g_hrdr_t  RECORD LIKE hrdr_file.*
DEFINE  g_hrdr_b  DYNAMIC ARRAY OF RECORD
          hrdr02    LIKE   hrdr_file.hrdr02,
          hrat02    LIKE   hrat_file.hrat02,
          hrat04    LIKE   hrao_file.hrao02,
          hrdr06    LIKE   hrdr_file.hrdr06,
          hrdr07    LIKE   hrdr_file.hrdr07,
          hrdr03    LIKE   hrdr_file.hrdr03,
          hrdr04    LIKE   hrdr_file.hrdr04,
          hrdr05    LIKE   hrdr_file.hrdr05,
          hrdr08    LIKE   hrdr_file.hrdr08,
          hrdr01    LIKE   hrdr_file.hrdr01
                  END RECORD
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_hrdr01            LIKE hrdr_file.hrdr01
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
    DEFINE p_row,p_col         LIKE type_file.num5      
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
 
   INITIALIZE g_hrdr.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrdr_file WHERE hrdr01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i085_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i085_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri085"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   
   CALL cl_set_combo_items("hrdr03",NULL,NULL)
   CALL cl_set_combo_items("hrdr06",NULL,NULL)
   CALL cl_set_combo_items("hrdr06_b",NULL,NULL)
   
   
   #薪资年度
   CALL i085_get_hrdr03() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdr03",l_name,l_items)
   
   
   #浮动参数
   CALL i085_get_hrdr06() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdr06",l_name,l_items)
   CALL cl_set_combo_items("hrdr06_b",l_name,l_items)
   
   LET g_action_choice=""
   CALL i085_menu()
 
   CLOSE WINDOW i085_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i085_get_hrdr03()
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrac01     LIKE   hrac_file.hrac01
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
                 "  ORDER BY hrac01"
       PREPARE i085_get_hrdr03_pre FROM l_sql
       DECLARE i085_get_hrdr03 CURSOR FOR i085_get_hrdr03_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i085_get_hrdr03 INTO l_hrac01
             		       		 
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrac01
            LET l_items=l_hrac01
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrac01 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrac01 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items

END FUNCTION

FUNCTION i085_get_hrdr06()
DEFINE l_name   LIKE type_file.chr1000
DEFINE l_items  STRING
DEFINE l_hrdh01     LIKE   hrdh_file.hrdh01
DEFINE l_hrdh06     LIKE   hrdh_file.hrdh06
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrdh01,hrdh06 FROM hrdh_file WHERE hrdh03='002' AND hrdh02='002' ",
                 "  ORDER BY NLSSORT(hrdh06,'NLS_SORT = SCHINESE_PINYIN_M') "
       PREPARE i085_get_hrdr06_pre FROM l_sql
       DECLARE i085_get_hrdr06 CURSOR FOR i085_get_hrdr06_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i085_get_hrdr06 INTO l_hrdh01,l_hrdh06
             		       		 
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrdh01
            LET l_items=l_hrdh06
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrdh01 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrdh06 CLIPPED
          END IF
       END FOREACH
       SELECT replace(l_name,' ','')  INTO l_name FROM dual
       RETURN l_name,l_items

END FUNCTION
	
FUNCTION i085_curs()

    CLEAR FORM
    INITIALIZE g_hrdr.* TO NULL
    
    IF gs_wc IS NULL THEN
       CONSTRUCT BY NAME g_wc ON                              
           hrdr02,hrdr03,hrdr04,hrdr05,hrdr06,hrdr07,hrdr08,
           hrdruser,hrdrgrup,hrdrmodu,hrdrdate,hrdracti,hrdroriu,hrdrorig
       
           BEFORE CONSTRUCT                                    
              CALL cl_qbe_init()                               
       
           ON ACTION controlp
              CASE
                 WHEN INFIELD(hrdr02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_hrat01"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_hrdr.hrdr02
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrdr02
                    NEXT FIELD hrdr02
                               
       
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
       
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdruser', 'hrdrgrup')  #
                                                                     
       CALL cl_replace_str(g_wc,'hrdr02','hrat01') RETURNING g_wc 
    ELSE
   	   LET g_wc=gs_wc
   	END IF                                                                       

    LET g_sql = "SELECT hrdr01 FROM hrdr_file,hrat_file ",                       #
                " WHERE ",g_wc CLIPPED,
                "   AND hrdr02=hratid ",
                " ORDER BY hrdr01"
    PREPARE i085_prepare FROM g_sql
    DECLARE i085_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i085_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrdr01) FROM hrdr_file,hrat_file WHERE ",g_wc CLIPPED,
                "   AND hrdr02=hratid "
    PREPARE i085_precount FROM g_sql
    DECLARE i085_count CURSOR FOR i085_precount
END FUNCTION	
	
FUNCTION i085_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i085_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i085_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            LET gs_wc=NULL
            IF cl_chk_act_auth() THEN
                 CALL i085_q()
            END IF  

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i085_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i085_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i085_r()
            END IF
            	
        ON ACTION piliang
           LET g_action_choice="piliang"
           IF cl_chk_act_auth() THEN
              CALL i085_gen()
           END IF    	
            	
            	
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        
        ON ACTION next
            CALL i085_fetch('N')

        ON ACTION previous
            CALL i085_fetch('P')
        
        ON ACTION jump
            CALL i085_fetch('/')

        ON ACTION first
            CALL i085_fetch('F')

        ON ACTION last
            CALL i085_fetch('L')

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
              IF g_hrdr.hrdr01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrdr01"
                 LET g_doc.value1 = g_hrdr.hrdr01
                 CALL cl_doc()
              END IF
           END IF
           	
        ON ACTION exporttoexcel   #No.FUN-4B0020
           LET g_action_choice = 'exporttoexcel'
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdr_b),'','')
           END IF   	
        ON ACTION import
            LET g_action_choice="import"
            IF cl_chk_act_auth() THEN
                 CALL i085_import()
            END IF
    END MENU

END FUNCTION	
	
FUNCTION i085_a()
DEFINE l_hrdr    RECORD LIKE  hrdr_file.*

    CLEAR FORM                                   #
    INITIALIZE g_hrdr.* LIKE hrdr_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrdr.hrdruser = g_user
        LET g_hrdr.hrdroriu = g_user
        LET g_hrdr.hrdrorig = g_grup
        LET g_hrdr.hrdrgrup = g_grup               #
        LET g_hrdr.hrdrdate = g_today
        LET g_hrdr.hrdracti = 'Y'
        LET g_hrdr.hrdr05 = 1
        LET g_hrdr.hrdr07 = 0
        CALL i085_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrdr.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        	
        IF g_hrdr.hrdr02 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        
        SELECT MAX(hrdr01) INTO g_hrdr.hrdr01 FROM hrdr_file
        
        IF cl_null(g_hrdr.hrdr01) THEN
        	 LET g_hrdr.hrdr01='0000000001'
        ELSE
        	 LET g_hrdr.hrdr01=g_hrdr.hrdr01+1 USING "&&&&&&&&&&"	 	
        END IF
        	
        LET l_hrdr.*=g_hrdr.*
        
        SELECT hratid INTO l_hrdr.hrdr02 FROM hrat_file WHERE hrat01=g_hrdr.hrdr02	
        		
        INSERT INTO hrdr_file VALUES(l_hrdr.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdr_file",g_hrdr.hrdr02,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrdr01 INTO g_hrdr.hrdr01 FROM hrdr_file WHERE hrdr01 = g_hrdr.hrdr01
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION
	
FUNCTION i085_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_sql         STRING
   DEFINE l_hratid      LIKE hrat_file.hratid
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hrat17      LIKE hrag_file.hrag07
   DEFINE l_hrat04      LIKE hrao_file.hrao02
   DEFINE l_hrat05      LIKE hras_file.hras04
   DEFINE l_hrat22      LIKE hrag_file.hrag07
   DEFINE l_hrat42      LIKE hrai_file.hrai04
   DEFINE l_hrat06      LIKE hrat_file.hrat02
   DEFINE l_hrat66      LIKE hrat_file.hrat66

   

   
   DISPLAY BY NAME
      g_hrdr.hrdr02,g_hrdr.hrdr03,g_hrdr.hrdr04,
      g_hrdr.hrdr05,g_hrdr.hrdr06,g_hrdr.hrdr07,g_hrdr.hrdr08,
      g_hrdr.hrdruser,g_hrdr.hrdrgrup,g_hrdr.hrdrmodu,g_hrdr.hrdrdate,g_hrdr.hrdracti

   INPUT BY NAME
      g_hrdr.hrdr02,g_hrdr.hrdr03,g_hrdr.hrdr04,
      g_hrdr.hrdr05,g_hrdr.hrdr06,g_hrdr.hrdr07,g_hrdr.hrdr08
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          
      AFTER FIELD hrdr02
         IF NOT cl_null(g_hrdr.hrdr02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrdr.hrdr02
         	                                            AND hratconf='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此员工','!',0)
         	  	 NEXT FIELD hrdr02
         	  END IF	
         	                                           	
         	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdr.hrdr02   	
 	  
         	  IF l_hratid != g_hrdr_t.hrdr02 OR g_hrdr_t.hrdr02 IS NULL THEN
         	  	 IF NOT cl_null(g_hrdr.hrdr03) AND 
         	  	 	  NOT cl_null(g_hrdr.hrdr04) AND 
         	  	 	  NOT cl_null(g_hrdr.hrdr06) THEN
         	  	 	  LET l_n=0
         	  	 	  SELECT COUNT(*) INTO l_n FROM hrdr_file 
         	  	 	   WHERE hrdr02=l_hratid
         	  	 	     AND hrdr03=g_hrdr.hrdr03
         	  	 	     AND hrdr04=g_hrdr.hrdr04
         	  	 	     AND hrdr06=g_hrdr.hrdr06
         	  	 	  IF l_n>0 THEN
         	  	 	  	 CALL cl_err('此员工在此年度期别已设置该浮动参数','!',0)
         	  	 	  	 NEXT FIELD hrdr02
         	  	 	  END IF 	 	  	
         	  	 END IF
         	  END IF	 	
         	  
         	  SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01=g_hrdr.hrdr02
         	  SELECT hrag07 INTO l_hrat17 FROM hrag_file,hrat_file 
         	   WHERE hrag01='333' AND hrag06=hrat17 AND hrat01=g_hrdr.hrdr02
         	  SELECT hrao02 INTO l_hrat04 FROM hrao_file,hrat_file 
         	   WHERE hrao01=hrat04 AND hrat01=g_hrdr.hrdr02
         	  SELECT hras04 INTO l_hrat05 FROM hras_file,hrat_file
         	   WHERE hras01=hrat05 AND hrat01=g_hrdr.hrdr02
         	  SELECT hrag07 INTO l_hrat22 FROM hrag_file,hrat_file
         	   WHERE hrag01='317' AND hrat22=hrag06 AND hrat01=g_hrdr.hrdr02
         	  SELECT hrai04 INTO l_hrat42 FROM hrai_file,hrat_file
         	   WHERE hrat42=hrai03 AND hrat01=g_hrdr.hrdr02
         	  SELECT A.hrat02 INTO l_hrat06 FROM hrat_file A,hrat_file B
         	   WHERE B.hrat06=A.hrat01 AND B.hrat01=g_hrdr.hrdr02
         	  SELECT hrat25 INTO l_hrat66 FROM hrat_file WHERE hrat01=g_hrdr.hrdr02          	
         	  
         	  DISPLAY l_hrat02 TO hrat02
         	  DISPLAY l_hrat17 TO hrat17
         	  DISPLAY l_hrat04 TO hrat04
         	  DISPLAY l_hrat05 TO hrat05
         	  DISPLAY l_hrat22 TO hrat22
         	  DISPLAY l_hrat42 TO hrat42
         	  DISPLAY l_hrat06 TO hrat06
         	  DISPLAY l_hrat66 TO hrat66  	
         END IF
         	
         	
      AFTER FIELD hrdr03
         IF NOT cl_null(g_hrdr.hrdr03) THEN
         	  IF g_hrdr.hrdr03 != g_hrdr_t.hrdr03 OR g_hrdr_t.hrdr03 IS NULL THEN
         	  	 IF NOT cl_null(g_hrdr.hrdr02) AND 
         	  	 	  NOT cl_null(g_hrdr.hrdr04) AND 
         	  	 	  NOT cl_null(g_hrdr.hrdr06) THEN
         	  	 	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdr.hrdr02   	
         	  	 	  LET l_n=0
         	  	 	  SELECT COUNT(*) INTO l_n FROM hrdr_file 
         	  	 	   WHERE hrdr02=l_hratid
         	  	 	     AND hrdr03=g_hrdr.hrdr03
         	  	 	     AND hrdr04=g_hrdr.hrdr04
         	  	 	     AND hrdr06=g_hrdr.hrdr06
         	  	 	  IF l_n>0 THEN
         	  	 	  	 CALL cl_err('此员工在此年度期别已设置该浮动参数','!',0)
         	  	 	  	 NEXT FIELD hrdr03
         	  	 	  END IF 	 	  	
         	  	 END IF
         	  END IF	 	
         	  
         END IF
         	   	
      AFTER FIELD hrdr04
         IF NOT cl_null(g_hrdr.hrdr04) THEN
         	  IF g_hrdr.hrdr04 != g_hrdr_t.hrdr04 OR g_hrdr_t.hrdr04 IS NULL THEN
         	  	 IF NOT cl_null(g_hrdr.hrdr02) AND 
         	  	 	  NOT cl_null(g_hrdr.hrdr03) AND 
         	  	 	  NOT cl_null(g_hrdr.hrdr06) THEN
         	  	 	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdr.hrdr02   	
         	  	 	  LET l_n=0
         	  	 	  SELECT COUNT(*) INTO l_n FROM hrdr_file 
         	  	 	   WHERE hrdr02=l_hratid
         	  	 	     AND hrdr03=g_hrdr.hrdr03
         	  	 	     AND hrdr04=g_hrdr.hrdr04
         	  	 	     AND hrdr06=g_hrdr.hrdr06
         	  	 	  IF l_n>0 THEN
         	  	 	  	 CALL cl_err('此员工在此年度期别已设置该浮动参数','!',0)
         	  	 	  	 NEXT FIELD hrdr04
         	  	 	  END IF 	 	  	
         	  	 END IF
         	  END IF	
         END IF	
         	
      AFTER FIELD hrdr06
         IF NOT cl_null(g_hrdr.hrdr06) THEN
         	  IF g_hrdr.hrdr06 != g_hrdr_t.hrdr06 OR g_hrdr_t.hrdr06 IS NULL THEN
         	  	 IF NOT cl_null(g_hrdr.hrdr02) AND 
         	  	 	  NOT cl_null(g_hrdr.hrdr03) AND 
         	  	 	  NOT cl_null(g_hrdr.hrdr04) THEN
         	  	 	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdr.hrdr02   	
         	  	 	  LET l_n=0
         	  	 	  SELECT COUNT(*) INTO l_n FROM hrdr_file 
         	  	 	   WHERE hrdr02=l_hratid
         	  	 	     AND hrdr03=g_hrdr.hrdr03
         	  	 	     AND hrdr04=g_hrdr.hrdr04
         	  	 	     AND hrdr06=g_hrdr.hrdr06
         	  	 	  IF l_n>0 THEN
         	  	 	  	 CALL cl_err('此员工在此年度期别已设置该浮动参数','!',0)
         	  	 	  	 NEXT FIELD hrdr06
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
           WHEN INFIELD(hrdr02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = g_hrdr.hrdr02
              CALL cl_create_qry() RETURNING g_hrdr.hrdr02
              DISPLAY BY NAME g_hrdr.hrdr02
              NEXT FIELD hrdr02
              
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
	
FUNCTION i085_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdr.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i085_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i085_count
    FETCH i085_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i085_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdr.hrdr01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdr.* TO NULL
    ELSE
        CALL i085_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i085_b_fill(g_wc)
    END IF
END FUNCTION	
	
FUNCTION i085_fetch(p_flhrdr)
    DEFINE p_flhrdr         LIKE type_file.chr1

    CASE p_flhrdr
        WHEN 'N' FETCH NEXT     i085_cs INTO g_hrdr.hrdr01
        WHEN 'P' FETCH PREVIOUS i085_cs INTO g_hrdr.hrdr01
        WHEN 'F' FETCH FIRST    i085_cs INTO g_hrdr.hrdr01
        WHEN 'L' FETCH LAST     i085_cs INTO g_hrdr.hrdr01
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
            FETCH ABSOLUTE g_jump i085_cs INTO g_hrdr.hrdr01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdr.hrdr01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdr.* TO NULL
        LET g_hrdr.hrdr01 = NULL
        RETURN
    ELSE
      CASE p_flhrdr
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      #DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrdr.* FROM hrdr_file    
       WHERE hrdr01 = g_hrdr.hrdr01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrdr_file",g_hrdr.hrdr01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i085_show()                 
    END IF
END FUNCTION	
	
FUNCTION i085_show()
DEFINE l_hrat02      LIKE hrat_file.hrat02
DEFINE l_hrat17      LIKE hrag_file.hrag07
DEFINE l_hrat04      LIKE hrao_file.hrao02
DEFINE l_hrat05      LIKE hras_file.hras04
DEFINE l_hrat22      LIKE hrag_file.hrag07
DEFINE l_hrat42      LIKE hrai_file.hrai04
DEFINE l_hrat06      LIKE hrat_file.hrat02
DEFINE l_hrat66      LIKE hrat_file.hrat66
DEFINE l_name   STRING
DEFINE l_items  STRING

    SELECT * INTO g_hrdr.* FROM hrdr_file WHERE hrdr01=g_hrdr.hrdr01

    LET g_hrdr_t.* = g_hrdr.*
    
    SELECT hrat01 INTO g_hrdr.hrdr02 FROM hrat_file WHERE hratid=g_hrdr.hrdr02
    DISPLAY BY NAME g_hrdr.hrdr02,g_hrdr.hrdr03,g_hrdr.hrdr04,
                    g_hrdr.hrdr05,g_hrdr.hrdr06,g_hrdr.hrdr07,g_hrdr.hrdr08,
                    g_hrdr.hrdruser,g_hrdr.hrdrgrup,g_hrdr.hrdrmodu,
                    g_hrdr.hrdrdate,g_hrdr.hrdracti,g_hrdr.hrdrorig,g_hrdr.hrdroriu
    
    SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01=g_hrdr.hrdr02
    SELECT hrag07 INTO l_hrat17 FROM hrag_file,hrat_file 
     WHERE hrag01='333' AND hrag06=hrat17 AND hrat01=g_hrdr.hrdr02
    SELECT hrao02 INTO l_hrat04 FROM hrao_file,hrat_file 
     WHERE hrao01=hrat04 AND hrat01=g_hrdr.hrdr02
    SELECT hras04 INTO l_hrat05 FROM hras_file,hrat_file
     WHERE hras01=hrat05 AND hrat01=g_hrdr.hrdr02
    SELECT hrag07 INTO l_hrat22 FROM hrag_file,hrat_file
     WHERE hrag01='317' AND hrat22=hrag06 AND hrat01=g_hrdr.hrdr02
    SELECT hrai04 INTO l_hrat42 FROM hrai_file,hrat_file
     WHERE hrat42=hrai03 AND hrat01=g_hrdr.hrdr02
    SELECT A.hrat02 INTO l_hrat06 FROM  hrat_file A,hrat_file B
     WHERE B.hrat06=A.hrat01 AND B.hrat01=g_hrdr.hrdr02
    SELECT hrat25 INTO l_hrat66 FROM hrat_file WHERE hrat01=g_hrdr.hrdr02          	
   
    DISPLAY l_hrat02 TO hrat02
    DISPLAY l_hrat17 TO hrat17
    DISPLAY l_hrat04 TO hrat04
    DISPLAY l_hrat05 TO hrat05
    DISPLAY l_hrat22 TO hrat22
    DISPLAY l_hrat42 TO hrat42
    DISPLAY l_hrat06 TO hrat06
    DISPLAY l_hrat66 TO hrat66
    CALL cl_show_fld_cont()
END FUNCTION
	
FUNCTION i085_u()
DEFINE l_hrdr    RECORD LIKE  hrdr_file.*

    IF g_hrdr.hrdr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    SELECT * INTO g_hrdr.* FROM hrdr_file WHERE hrdr01=g_hrdr.hrdr01
    
    IF g_hrdr.hrdracti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    	
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i085_cl USING g_hrdr.hrdr01
    IF STATUS THEN
       CALL cl_err("OPEN i085_cl:", STATUS, 1)
       CLOSE i085_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i085_cl INTO g_hrdr.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdr.hrdr01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i085_show()                          
    WHILE TRUE
        CALL i085_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdr.*=g_hrdr_t.*
            CALL i085_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrdr.hrdrmodu=g_user
        LET g_hrdr.hrdrdate=g_today	
        
        LET l_hrdr.*=g_hrdr.*
        SELECT hratid INTO l_hrdr.hrdr02 FROM hrat_file WHERE hrat01=g_hrdr.hrdr02
        
        UPDATE hrdr_file SET hrdr_file.* = l_hrdr.*    
         WHERE hrdr01 = g_hrdr_t.hrdr01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdr_file",g_hrdr.hrdr01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i085_show()	
        EXIT WHILE
    END WHILE
    CLOSE i085_cl
    COMMIT WORK
    CALL i085_b_fill(g_wc)
END FUNCTION	
	
FUNCTION i085_r()
    IF g_hrdr.hrdr01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i085_cl USING g_hrdr.hrdr01
    IF STATUS THEN
       CALL cl_err("OPEN i085_cl:", STATUS, 0)
       CLOSE i085_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i085_cl INTO g_hrdr.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdr.hrdr01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i085_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrdr01"
       LET g_doc.value1 = g_hrdr.hrdr01
       CALL cl_del_doc()
       
       DELETE FROM hrdr_file WHERE hrdr01 = g_hrdr.hrdr01
       
       CLEAR FORM
       OPEN i085_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i085_cl
          CLOSE i085_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i085_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i085_cl
          CLOSE i085_count
          COMMIT WORK
          DISPLAY g_row_count TO FORMONLY.cnt
          CALL i085_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i085_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i085_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i085_fetch('/')
       END IF
    END IF
    CLOSE i085_cl
    COMMIT WORK
    CALL i085_b_fill(g_wc)
END FUNCTION
	
FUNCTION i085_x()
    IF g_hrdr.hrdr01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i085_cl USING g_hrdr.hrdr01
    IF STATUS THEN
       CALL cl_err("OPEN i085_cl:", STATUS, 1)
       CLOSE i085_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i085_cl INTO g_hrdr.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdr.hrdr01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i085_show()
    IF cl_exp(0,0,g_hrdr.hrdracti) THEN
        LET g_chr = g_hrdr.hrdracti
        IF g_hrdr.hrdracti='Y' THEN
            LET g_hrdr.hrdracti='N'
        ELSE
            LET g_hrdr.hrdracti='Y'
        END IF
        UPDATE hrdr_file
           SET hrdracti=g_hrdr.hrdracti
            WHERE hrdr01=g_hrdr.hrdr01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrdr.hrdr01,SQLCA.sqlcode,0)
            LET g_hrdr.hrdracti = g_chr
        END IF
        DISPLAY BY NAME g_hrdr.hrdracti
    END IF
    CLOSE i085_cl
    COMMIT WORK
    CALL i085_b_fill(g_wc)
END FUNCTION					
	
FUNCTION i085_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrdr_b.clear()
        
        LET l_sql=" SELECT hrdr02,'','',hrdr06,hrdr07,hrdr03,hrdr04,hrdr05,hrdr08,hrdr01 ",
                  "   FROM hrdr_file,hrat_file WHERE ",p_wc CLIPPED,
                  "    AND hrdr02=hratid ",
                  "  ORDER BY hrdr01 "
                  
        PREPARE i085_b_pre FROM l_sql
        DECLARE i085_b_cs CURSOR FOR i085_b_pre
        
        LET l_i=1
        
        FOREACH i085_b_cs INTO g_hrdr_b[l_i].*
        
           SELECT hrat01 INTO g_hrdr_b[l_i].hrdr02 FROM hrat_file WHERE hratid=g_hrdr_b[l_i].hrdr02
           SELECT hrat02 INTO g_hrdr_b[l_i].hrat02 FROM hrat_file WHERE hrat01=g_hrdr_b[l_i].hrdr02
           SELECT hrao02 INTO g_hrdr_b[l_i].hrat04 FROM hrat_file,hrao_file
            WHERE hrat04=hrao01 AND hrat01=g_hrdr_b[l_i].hrdr02
                        
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrdr_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrdr_b TO s_hrdr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION	
	
FUNCTION i085_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i085_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrdr_file.*
           INTO g_hrdr.*
           FROM hrdr_file
          WHERE hrdr01=g_hrdr_b[l_ac].hrdr01
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i085_fetch('/')
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
               CALL i085_a()
            END IF
            EXIT WHILE

        WHEN "query"
            LET gs_wc=NULL
            IF cl_chk_act_auth() THEN
               CALL i085_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i085_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i085_u()
            END IF
            EXIT WHILE
            	
        WHEN "piliang"
            IF cl_chk_act_auth() THEN
               CALL i085_gen()
            END IF
            EXIT WHILE     	

        WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i085_x()
               CALL i085_show()
            END IF     	        	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdr_b),'','')
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
	
FUNCTION i085_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdr_b TO s_hrdr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i085_fetch('/')
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
         CALL i085_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL cl_set_comp_visible("Page3", FALSE)   #NO.FUN-840018 ADD
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         CALL cl_set_comp_visible("Page3", TRUE)    #NO.FUN-840018 ADD
         EXIT DISPLAY

      ON ACTION first
         CALL i085_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i085_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i085_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i085_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i085_fetch('L')
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
	
FUNCTION i085_gen()
DEFINE l_hrdr     RECORD LIKE   hrdr_file.*
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
DEFINE l_str      STRING  
DEFINE tok base.StringTokenizer
DEFINE l_value    LIKE   hrat_file.hrat01
DEFINE l_start,l_end    LIKE   hrdr_file.hrdr01
DEFINE l_gen    DYNAMIC ARRAY OF RECORD
         name   LIKE   hrdr_file.hrdr06,
         value  LIKE   hrdr_file.hrdr07
                END RECORD
DEFINE i,l_i    LIKE  type_file.num5                
                 
         CLEAR FORM
         INITIALIZE l_hrdr.* TO NULL
         CALL l_gen.clear()
         
         DROP TABLE i085_tmp
         CREATE TEMP TABLE i085_tmp(
            hrdr06    LIKE  hrdr_file.hrdr06,
            hrdr07    DEC
                                    )

         
         WHILE TRUE
         	
         INPUT l_hrdr.hrdr03,l_hrdr.hrdr04,l_hrdr.hrdr05,l_hrdr.hrdr08
         WITHOUT DEFAULTS FROM hrdr03,hrdr04,hrdr05,hrdr08
         
         BEFORE INPUT
            LET l_hrdr.hrdruser = g_user
            LET l_hrdr.hrdroriu = g_user
            LET l_hrdr.hrdrorig = g_grup
            LET l_hrdr.hrdrgrup = g_grup               #
            LET l_hrdr.hrdrdate = g_today
            LET l_hrdr.hrdracti = 'Y'
            LET l_hrdr.hrdr05 = 1
            
            DISPLAY l_hrdr.hrdr05 TO hrdr05
                
             
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
             
             
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
       END IF 
       	
       DELETE FROM i085_tmp	
       CALL i085_gen_para()
       
       IF INT_FLAG THEN
       	  LET INT_FLAG=0
       	  DELETE FROM i085_tmp 
       	  CONTINUE WHILE
       ELSE
       	  LET l_n=0 
       	  SELECT COUNT(*) INTO l_n FROM i085_tmp WHERE 1=1
       	  IF l_n=0 THEN
       	     CONTINUE WHILE
       	  ELSE   		 
       	     EXIT WHILE
       	  END IF   	
       END IF	  		  	 	     
       
       END WHILE
       	
       LET g_success='Y'
       LET li_k=1
       LET l_start=''
       LET l_end=''
       
       BEGIN WORK	
       
       LET l_sql="SELECT hrdr06,hrdr07 FROM i085_tmp"
       PREPARE i085_para_pre FROM l_sql
       DECLARE i085_para CURSOR FOR i085_para_pre
       
       LET i=1
       
       FOREACH i085_para INTO l_gen[i].*
          
          LET i=i+1
          
       END FOREACH
       
       CALL l_gen.deleteElement(i)
       LET i=i-1   
             	
       LET tok = base.StringTokenizer.create(l_str,"|")
       IF NOT cl_null(l_str) THEN
          WHILE tok.hasMoreTokens()
             LET l_value=tok.nextToken()
             SELECT hratid INTO l_hrdr.hrdr02 FROM hrat_file WHERE hrat01=l_value
             
             FOR l_i=1 TO i
                 LET l_hrdr.hrdr06=l_gen[l_i].name
                 LET l_hrdr.hrdr07=l_gen[l_i].value
                 LET l_n=0
                 SELECT COUNT(*) INTO l_n FROM hrdr_file 
                  WHERE hrdr02=l_hrdr.hrdr02
                    AND hrdr03=l_hrdr.hrdr03
                    AND hrdr04=l_hrdr.hrdr04
                    AND hrdr06=l_hrdr.hrdr06
                 IF l_n>0 THEN
             	      LET g_success='N'
                    LET lr_err[li_k].line=li_k
                    LET lr_err[li_k].key1=l_value
                    LET lr_err[li_k].err="此员工在此年度月份以维护此参数"
                    LET li_k=li_k+1
                    CONTINUE FOR
                 END IF   
                 
                 SELECT MAX(hrdr01) INTO l_hrdr.hrdr01 FROM hrdr_file
        
                 IF cl_null(l_hrdr.hrdr01) THEN
        	          LET l_hrdr.hrdr01='0000000001'
                 ELSE
        	          LET l_hrdr.hrdr01=l_hrdr.hrdr01+1 USING "&&&&&&&&&&"	 	
                 END IF
             	
                 INSERT INTO hrdr_file VALUES (l_hrdr.*)
             
                 IF SQLCA.sqlcode THEN  
                    LET g_success='N'
                    LET lr_err[li_k].line=li_k
                    LET lr_err[li_k].key1=l_value
                    LET lr_err[li_k].err=SQLCA.sqlcode
                    LET li_k=li_k+1
                    CONTINUE FOR
                 END IF
             	
                 IF cl_null(l_start) THEN
             	      LET l_start=l_hrdr.hrdr01
                 END IF	  
             	
                 LET l_end=l_hrdr.hrdr01	 	
             END FOR	
                        
          END WHILE
       END IF	
       	
       IF lr_err.getLength() > 0 AND g_success='N' THEN
          ROLLBACK WORK
          CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"序号|工号|错误描述")
          CALL i085_show()
       ELSE
          COMMIT WORK
          CALL cl_err('生成成功','!',1)
          LET gs_wc=" hrdr01 BETWEEN '",l_start,"' AND '",l_end,"'"
          CALL i085_q()
       END IF   	
       
END FUNCTION
	
FUNCTION i085_gen_para()
DEFINE l_name   STRING
DEFINE l_items  STRING	
DEFINE l_gen     DYNAMIC ARRAY OF RECORD 
         name    LIKE  hrdr_file.hrdr06,
         value   LIKE  hrdr_file.hrdr07
                 END RECORD
DEFINE l_gen_t   RECORD 
         name    LIKE  hrdr_file.hrdr06,
         value   LIKE  hrdr_file.hrdr07
                 END RECORD                 	
DEFINE l_ac_t          LIKE type_file.num5,                 
       l_n             LIKE type_file.num5,                 
       l_lock_sw       LIKE type_file.chr1,                 
       p_cmd           LIKE type_file.chr1,                 
       l_allow_insert  LIKE type_file.chr1,                 
       l_allow_delete  LIKE type_file.chr1 
DEFINE l_rec_b,li_ac   LIKE type_file.num5        
DEFINE p_row,p_col     LIKE type_file.num5   
    
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    
    LET l_rec_b=0
    
    CALL l_gen.clear()
    
    LET p_row=3   LET p_col=6
    
    OPEN WINDOW i085_gen_w AT p_row,p_col WITH FORM "ghr/42f/ghri085_gen"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("ghri085_gen")
    
    CALL cl_set_combo_items("name",NULL,NULL)
    
    #浮动参数
    CALL i085_get_hrdr06() RETURNING l_name,l_items
    CALL cl_set_combo_items("name",l_name,l_items) 
    
    LET g_forupd_sql = "SELECT hrdr06,hrdr07",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM i085_tmp WHERE hrdr06=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i085_bcl CURSOR FROM g_forupd_sql 
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    INPUT ARRAY l_gen WITHOUT DEFAULTS FROM s_gen.*
          ATTRIBUTE (COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(li_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET li_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
 
        IF l_rec_b>=li_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end   
                      
           LET l_gen_t.* = l_gen[li_ac].*  #BACKUP
           OPEN i085_bcl USING l_gen_t.name
           IF STATUS THEN
              CALL cl_err("OPEN i085_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i085_bcl INTO l_gen[li_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(l_gen_t.name,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
	
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE l_gen[li_ac].* TO NULL      #900423  
         LET l_gen_t.* = l_gen[li_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD name
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           #LET INT_FLAG = 0
           CLOSE i085_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO i085_tmp VALUES (l_gen[li_ac].name,l_gen[li_ac].value)
 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","i085_tmp",l_gen[li_ac].name,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET l_rec_b=l_rec_b+1         
           COMMIT WORK  
        END IF        	  	
       	
    AFTER FIELD name
       IF NOT cl_null(l_gen[li_ac].name) THEN
       	  IF l_gen[li_ac].name != l_gen_t.name OR l_gen_t.name IS NULL THEN
       	  	 LET l_n=0
       	  	 SELECT COUNT(*) INTO l_n FROM i085_tmp WHERE hrdr06=l_gen[li_ac].name
       	  	 IF l_n>0 THEN
       	  	 	  CALL cl_err('参数不可重复','!',0)
       	  	 	  NEXT FIELD name
       	  	 END IF
       	  END IF
       END IF
       		  		 		    	      	
       	
    BEFORE DELETE                           
       IF l_gen_t.name IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM i085_tmp WHERE hrdr06 = l_gen_t.name
                    
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","i085_tmp",l_gen_t.name,l_gen_t.value,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
          	 LET l_rec_b=l_rec_b-1   
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         #LET INT_FLAG = 0
         LET l_gen[li_ac].* = l_gen_t.*
         CLOSE i085_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(l_gen[li_ac].name,-263,0)
          LET l_gen[li_ac].* = l_gen_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE i085_tmp SET hrdr06=l_gen[li_ac].name,
                              hrdr07=l_gen[li_ac].value
                        WHERE hrdr06=l_gen_t.name
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","i085_tmp",l_gen_t.name,l_gen_t.value,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET l_gen[li_ac].* = l_gen_t.* 
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET li_ac = ARR_CURR()            
       LET l_ac_t = li_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          #LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET l_gen[li_ac].* = l_gen_t.*
          END IF
          CLOSE i085_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i085_bcl                
        COMMIT WORK  
 
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE i085_bcl
    COMMIT WORK	
	  
	  CLOSE WINDOW i085_gen_w
END FUNCTION				

#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i085_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 13/11/13 By shenran 
#=================================================================#
FUNCTION i085_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_err   VARCHAR(300),
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrdr01  LIKE hrdr_file.hrdr01,
         hrdr02  LIKE hrdr_file.hrdr02,
         hrdr03  LIKE hrdr_file.hrdr03,
         hrdr04  LIKE hrdr_file.hrdr04,
         hrdr06  LIKE hrdr_file.hrdr06,
         hrdr07  LIKE hrdr_file.hrdr07,
         hrdr08  LIKE hrdr_file.hrdr08
         
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE l_hrdh06      LIKE hrdh_file.hrdh06
DEFINE l_hrat02      LIKE hrat_file.hrat02
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
          l_fac     LIKE ima_file.ima31_fac, 
          g_cnt,n     LIKE type_file.num5
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
                FOR n = 5 TO 999
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells(1,'||n||').Value'],[sr.hrdr06])#获取导入浮动项目编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells(2,'||n||').Value'],[l_hrdh06])#获取导入浮动项目编码
                  IF cl_null(sr.hrdr06) THEN #获取不到导入浮动项目编码时退出循环
                     EXIT FOR 
                  END IF 
                  CALL cl_progress_bar(iROW-2) 
                  FOR i = 3 TO iRow         
                     CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrdr02])   #工号
                     CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[l_hrat02])    #姓名
                     CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrdr03])   #年度
                     CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrdr04])   #月份
                     CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||n||').Value'],[sr.hrdr07])   #浮动项目值
                     IF cl_null(sr.hrdr07) OR sr.hrdr07 = 0 THEN 
                        CALL cl_progressing(l_hrat02)
                        CONTINUE FOR
                     END IF
                     LET l_err = '[',sr.hrdr02,']',l_hrat02,'   ',l_hrdh06
                     IF NOT cl_null(sr.hrdr02) AND NOT cl_null(sr.hrdr03) AND NOT cl_null(sr.hrdr04) AND NOT cl_null(sr.hrdr06) AND NOT cl_null(sr.hrdr07) THEN
                        SELECT MAX(hrdr01) INTO sr.hrdr01 FROM hrdr_file
                        IF cl_null(sr.hrdr01) THEN
                           LET sr.hrdr01='0000000001'
                        ELSE 
                           LET sr.hrdr01=sr.hrdr01+1 USING "&&&&&&&&&&"
                        END IF 
                        SELECT hratid INTO sr.hrdr02 FROM hrat_file WHERE hrat01=sr.hrdr02
                        LET l_n=0
                        SELECT COUNT(*) INTO l_n FROM hrdr_file WHERE hrdr02=sr.hrdr02 AND hrdr03=sr.hrdr03 AND hrdr04=sr.hrdr04 AND hrdr06=sr.hrdr06
                        IF l_n>0 THEN 
                           LET l_err = '[',sr.hrdr02,']',l_hrat02,'当月已经存在[',l_hrdh06,']浮动项目值'
                           CALL cl_err3("ins","hrdr_file",sr.hrdr01,'',l_err,"","",1)
                           LET g_success  = 'N'
                           CALL cl_progressing(l_err)
                           CONTINUE FOR 
                        END IF 
 #                       IF sr.hrdr07 <> "" AND sr.hrdr07 <> 0 THEN
                           INSERT INTO hrdr_file(hrdr01,hrdr02,hrdr03,hrdr04,hrdr05,hrdr06,hrdr07,hrdr08,hrdracti,hrdruser,hrdrgrup,hrdrdate,hrdrorig,hrdroriu)
                              VALUES (sr.hrdr01,sr.hrdr02,sr.hrdr03,sr.hrdr04,'1',sr.hrdr06,sr.hrdr07,sr.hrdr08,'Y',g_user,g_grup,g_today,g_grup,g_user)
                           IF SQLCA.sqlcode THEN 
                              CALL cl_err3("ins","hrdr_file",sr.hrdr01,'',SQLCA.sqlcode,"","",1)   
                              LET g_success  = 'N'
                              CONTINUE FOR 
                           END IF 
 #                       END IF
                     END IF 
                     CALL cl_progressing(l_err)
                  END FOR 
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE 
                  IF g_success = 'Y' THEN 
                     COMMIT WORK 
                     CALL cl_err( '导入成功','!', 1 )
                  END IF 
                END IF 
#                FOR i = 1 TO iRow             
#                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrdr02])
#                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrdr03])
#                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrdr04])
#                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrdr06])
#                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrdr07])
#                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrdr08])
#               IF i > 1 THEN  
#                 IF NOT cl_null(sr.hrdr02) AND NOT cl_null(sr.hrdr03) AND NOT cl_null(sr.hrdr04)
#                	 AND NOT cl_null(sr.hrdr06) AND NOT cl_null(sr.hrdr07) THEN 
#                	 SELECT MAX(hrdr01) INTO sr.hrdr01 FROM hrdr_file
#                   IF cl_null(sr.hrdr01) THEN
#                   	 LET sr.hrdr01='0000000001'
#                   ELSE
#                   	 LET sr.hrdr01=sr.hrdr01+1 USING "&&&&&&&&&&"	 	
#                   END IF
#                   
#                   SELECT hratid INTO sr.hrdr02 FROM hrat_file WHERE hrat01=sr.hrdr02	
#                   LET l_n=0
#         	  	 	   SELECT COUNT(*) INTO l_n FROM hrdr_file 
#         	  	 	    WHERE hrdr02=sr.hrdr02
#         	  	 	      AND hrdr03=sr.hrdr03
#         	  	 	      AND hrdr04=sr.hrdr04
#         	  	 	      AND hrdr06=sr.hrdr06
#         	  	 	   IF l_n>0 THEN
#         	  	 	  	  CALL cl_err3("ins","hrdr_file",sr.hrdr01,'','此员工在此年度期别已设置该浮动参数',"","",1)   ##
#                      LET g_success  = 'N'
#                      CONTINUE FOR
#         	  	 	   END IF 	 	  	
#                    INSERT INTO hrdr_file(hrdr01,hrdr02,hrdr03,hrdr04,hrdr05,hrdr06,hrdr07,hrdr08,hrdracti,hrdruser,hrdrgrup,hrdrdate,hrdrorig,hrdroriu)
#                      VALUES (sr.hrdr01,sr.hrdr02,sr.hrdr03,sr.hrdr04,'1',sr.hrdr06,sr.hrdr07,sr.hrdr08,'Y',g_user,g_grup,g_today,g_grup,g_user)
#                    IF SQLCA.sqlcode THEN 
#                       CALL cl_err3("ins","hrdr_file",sr.hrdr01,'',SQLCA.sqlcode,"","",1)   
#                       LET g_success  = 'N'
#                       CONTINUE FOR 
#                    END IF 
#                END IF 
#               END IF 
#                  # LET i = i + 1
#                                
#                END FOR 
#                IF g_success = 'N' THEN 
#                   ROLLBACK WORK 
#                   CALL s_showmsg() 
#                ELSE IF g_success = 'Y' THEN 
#                   COMMIT WORK 
#                   CALL cl_err( '导入成功','!', 1 )
#                     END IF 
#                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
          END IF
       ELSE
       	  DISPLAY 'NO EXCEL'
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
       SELECT * INTO g_hrdr.* FROM hrdr_file
       WHERE hrdr01=sr.hrdr01
       
       CALL i085_show()
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------

