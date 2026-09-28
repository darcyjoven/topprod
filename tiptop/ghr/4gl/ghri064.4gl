# Prog. Version..: '5.25.04-08.10.22(00000)'     #
#
# Pattern name...: ghri064.4gl
# Descriptions...: 
# Date & Author..: 13/05/22 by kuangxj


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrcx    RECORD LIKE hrcx_file.*
DEFINE  g_hrcx_t  RECORD LIKE hrcx_file.*

DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
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
DEFINE  g_h,g_m     LIKE type_file.num5
DEFINE l_hrat01     LIKE hrat_file.hrat01
DEFINE l_hratid     LIKE hrat_file.hratid
DEFINE l_hrat02     LIKE hrat_file.hrat02
DEFINE l_hrat03     LIKE hrat_file.hrat03
DEFINE l_hrat04     LIKE hrat_file.hrat04
DEFINE l_hrat05     LIKE hrat_file.hrat05
DEFINE l_hrat06     LIKE hrat_file.hrat06
DEFINE l_hrat25     LIKE hrat_file.hrat25
DEFINE l_hrat03_name LIKE hraa_file.hraa12
DEFINE l_hrat04_name LIKE hrao_file.hrao02           
DEFINE l_hrat05_name LIKE hrap_file.hrap06             
DEFINE l_hrat06_name LIKE hrat_file.hrat02  
DEFINE l_hrag07      LIKE hrag_file.hrag07                     
DEFINE l_errmeg      STRING
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
 
   INITIALIZE g_hrcx.* TO NULL
   CALL i064_setnull()   

   LET g_forupd_sql = "SELECT * FROM hrcx_file WHERE hrcx01 = ? AND hrcx02 = ? AND hrcx04 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i064_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i064_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri064"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
   CALL cl_set_label_justify("i064_w","right")  
   LET g_action_choice=""
   CALL i064_menu()
 
   CLOSE WINDOW i064_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i064_curs()

    CLEAR FORM
    INITIALIZE g_hrcx.* TO NULL
    CALL i064_setnull()   
     CONSTRUCT BY NAME g_wc ON       
        hrat01,hrcx02,hrcx03,hrcx04,hrcx05,hrcx06,hrcx07,hrcx08,
        hrcxuser,hrcxgrup,hrcxmodu,hrcxdate,hrcxoriu,hrcxorig
   
                                 
       

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrcx01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = l_hrat01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
                 
              WHEN INFIELD(hrcx02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrcx02"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrcx.hrcx02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcx02
                 NEXT FIELD hrcx02
                 
             WHEN INFIELD(hrcx03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '530'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 LET g_qryparam.default1 = g_hrcx.hrcx02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcx03
                 NEXT FIELD hrcx03
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcxuser', 'hrcxgrup')  #
                                                                     #
    IF g_wc.getIndexOf("hrat01",1) THEN
    
        LET g_sql = "SELECT hrcx01,hrcx02,hrcx04 FROM hrcx_file,hrat_file ",                       
                    " WHERE hrcx01=hratid   AND  ",g_wc CLIPPED, " ORDER BY hrcx01,hrcx02,hrcx04"
    ELSE 
    	  LET g_sql = "SELECT hrcx01,hrcx02,hrcx04 FROM hrcx_file ",                       
                    " WHERE ",g_wc CLIPPED, " ORDER BY hrcx01,hrcx02,hrcx04"
    END IF 
    PREPARE i064_prepare FROM g_sql
    DECLARE i064_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i064_prepare
    IF g_wc.getIndexOf("hrat01",1) THEN
        LET g_sql = "SELECT COUNT(*) FROM hrcx_file,hrat_file WHERE  hrcx01=hratid   AND  ",g_wc CLIPPED
    ELSE  
        LET g_sql = "SELECT COUNT(*) FROM hrcx_file WHERE   ",g_wc CLIPPED
    END IF 
    PREPARE i064_precount FROM g_sql
    DECLARE i064_count CURSOR FOR i064_precount
END FUNCTION
	
FUNCTION i064_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
       
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i064_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i064_q()
            END IF

        ON ACTION next
            CALL i064_fetch('N')

        ON ACTION previous
            CALL i064_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i064_u()
            END IF
            
        ON ACTION recard
            LET g_action_choice="recard"
            IF cl_chk_act_auth() THEN
                 CALL i064_recard()
            END IF
       

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i064_r()
            END IF
            	
       
       

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i064_fetch('/')

        ON ACTION first
            CALL i064_fetch('F')

        ON ACTION last
            CALL i064_fetch('L')

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
              IF g_hrcx.hrcx01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrcx01"
                 LET g_doc.value1 = g_hrcx.hrcx01
                 CALL cl_doc()
              END IF
           END IF
           	
       	
    END MENU

END FUNCTION


FUNCTION i064_a()

    CLEAR FORM                                   #
    INITIALIZE g_hrcx.* LIKE hrcx_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        
        CALL i064_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrcx.* TO NULL
            CALL i064_setnull()   
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrcx.hrcx01 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        INSERT INTO hrcx_file VALUES(g_hrcx.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcx_file",g_hrcx.hrcx01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrcx01 INTO g_hrcx.hrcx01 FROM hrcx_file WHERE hrcx01 = g_hrcx.hrcx01
            CALL i064_show()
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION

FUNCTION i064_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_sql         STRING

   
   DISPLAY BY NAME
      g_hrcx.hrcx02,g_hrcx.hrcx03,g_hrcx.hrcx04,
      g_hrcx.hrcx05,g_hrcx.hrcx06,g_hrcx.hrcx07,g_hrcx.hrcx08,
      g_hrcx.hrcxuser,g_hrcx.hrcxgrup,g_hrcx.hrcxmodu,g_hrcx.hrcxdate,
      g_hrcx.hrcxorig,g_hrcx.hrcxoriu
  
   INPUT  l_hrat01,g_hrcx.hrcx02,g_hrcx.hrcx03,g_hrcx.hrcx04,g_hrcx.hrcx05
   WITHOUT DEFAULTS        
    FROM  hrat01,hrcx02,hrcx03,hrcx04,hrcx05         
    
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          IF p_cmd='a' THEN 
             LET l_hrat01=''
             LET g_hrcx.hrcxuser = g_user
             LET g_hrcx.hrcxoriu = g_user
             LET g_hrcx.hrcxorig = g_grup
             LET g_hrcx.hrcxgrup = g_grup              
             LET g_hrcx.hrcxdate = g_today
             LET g_hrcx.hrcx04 = g_today
             LET g_hrcx.hrcx05 = "00:00"
             LET g_hrcx.hrcx06 = g_today
             LET g_hrcx.hrcx07 ="23:59"
             LET g_hrcx.hrcx08 = 'N'
          DISPLAY BY NAME g_hrcx.hrcx04,g_hrcx.hrcx05,g_hrcx.hrcx06,g_hrcx.hrcx07,g_hrcx.hrcx08,
                          g_hrcx.hrcxuser,g_hrcx.hrcxgrup,g_hrcx.hrcxmodu,g_hrcx.hrcxdate,
                          g_hrcx.hrcxorig,g_hrcx.hrcxoriu
          END IF 
      AFTER FIELD hrat01
         IF NOT cl_null(l_hrat01) THEN
         
           SELECT hratid,hrat02,hrat03,hrat04,hrat05,hrat06,hrat25
             INTO g_hrcx.hrcx01,l_hrat02,l_hrat03,l_hrat04,l_hrat05,l_hrat06,l_hrat25
             FROM hrat_file
            WHERE hrat01 = l_hrat01
              AND hratconf = 'Y'
           IF SQLCA.sqlcode THEN
              CALL cl_err(l_hrat01,SQLCA.sqlcode,0)
              NEXT FIELD hrat01
           END IF 
           SELECT hraa12 INTO l_hrat03_name
            FROM  hraa_file
            WHERE hraa01=l_hrat03
            
           SELECT hrao02 INTO l_hrat04_name
            FROM  hrao_file
            WHERE hrao01=l_hrat04
            
           SELECT hrap06 INTO l_hrat05_name
            FROM  hrap_file
            WHERE hrap01=l_hrat05
            
           SELECT hrat02  INTO l_hrat06_name
             FROM hrat_file
            WHERE hrat01=l_hrat06
            
         END IF 
         
         DISPLAY l_hrat02 TO hrat02
         DISPLAY l_hrat03 TO hrat03
         DISPLAY l_hrat03_name TO hrat03_name
         DISPLAY l_hrat04 TO hrat04
         DISPLAY l_hrat04_name TO hrat04_name
         DISPLAY l_hrat05 TO hrat05
         DISPLAY l_hrat05_name TO hrat05_name
         DISPLAY l_hrat06 TO hrat06
         DISPLAY l_hrat06_name TO hrat06_name
         DISPLAY l_hrat25 TO hrat25 
      
      
      AFTER FIELD hrcx02
         IF NOT cl_null(g_hrcx.hrcx02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrcx_file 
         	   WHERE hrcx02=g_hrcx.hrcx02
         	     AND hrcx08='N'
         	     AND hrcx01! = g_hrcx.hrcx01
         	     AND hrcx04! = g_hrcx.hrcx04
         	  IF l_n>0 THEN
         	  	 CALL cl_err(g_hrcx.hrcx02,'ghr-079',0)
         	  	 NEXT FIELD hrcx02
         	  END IF
         	 
         END IF
         	
      AFTER FIELD hrcx03
         IF NOT cl_null(g_hrcx.hrcx03) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag06=g_hrcx.hrcx03
         	                                            AND hrag01='530'
         	                                            AND hragacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('','!',0)
         	  	 NEXT FIELD hrcx03
         	  END IF
         	  	   	
         	  SELECT hrag07 INTO l_hrag07 
         	   FROM hrag_file 
         	  WHERE hrag06=g_hrcx.hrcx03
         	    AND hrag01='530'
         	    AND hragacti='Y'	
         	  DISPLAY l_hrag07 TO hrag07                                            	 		
         END IF	  			           
         	                                    	  		                                           
      
      AFTER FIELD hrcx04 
        IF g_hrcx.hrcx08='Y' THEN    	
           IF g_hrcx.hrcx04>g_hrcx.hrcx06 OR (g_hrcx.hrcx04=g_hrcx.hrcx06	 AND g_hrcx.hrcx05>g_hrcx.hrcx07) THEN 
              LET l_errmeg=g_hrcx.hrcx04,' ',g_hrcx.hrcx05,'>',g_hrcx.hrcx06,' ',g_hrcx.hrcx07
              CALL cl_err(l_errmeg,'ghr-099',1)
              NEXT FIELD hrcx04 
           END IF 
       END IF        
      AFTER FIELD hrcx05
         IF NOT cl_null(g_hrcx.hrcx05) THEN
            LET g_h=''
         	  LET g_m='' 
         	  LET g_h=g_hrcx.hrcx05[1,2]
         	  LET g_m=g_hrcx.hrcx05[4,5]
         	  IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
         	  	 CALL cl_err(g_hrcx.hrcx05,'asf-807',0)
         	  	 NEXT FIELD hrcx05
         	  END IF 
         	  IF g_hrcx.hrcx08='Y' AND  g_hrcx.hrcx04=g_hrcx.hrcx06	 AND g_hrcx.hrcx05>g_hrcx.hrcx07 THEN 
         	    LET l_errmeg=g_hrcx.hrcx04,' ',g_hrcx.hrcx05,'>',g_hrcx.hrcx06,' ',g_hrcx.hrcx07
              CALL cl_err(l_errmeg,'ghr-099',1)
              NEXT FIELD hrcx05 
           END IF                                                   	  	
         END IF	
         	
    
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrat01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat02"
              LET g_qryparam.default1 = l_hrat01
              CALL cl_create_qry() RETURNING l_hrat01
              DISPLAY l_hrat01 TO hrat01
              NEXT FIELD hrat01
              
           WHEN INFIELD(hrcx03)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 ='530'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrcx.hrcx03
              CALL cl_create_qry() RETURNING g_hrcx.hrcx03
              DISPLAY BY NAME g_hrcx.hrcx03
              NEXT FIELD hrcx03
           OTHERWISE
              EXIT CASE
           END CASE

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
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

FUNCTION i064_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrcx.* TO NULL
    CALL i064_setnull()   
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i064_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i064_count
    FETCH i064_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i064_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcx.hrcx01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcx.* TO NULL
        CALL i064_setnull()   
    ELSE
        CALL i064_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i064_show()
    END IF
END FUNCTION

FUNCTION i064_fetch(p_flhrcx)
    DEFINE p_flhrcx         LIKE type_file.chr1

    CASE p_flhrcx
        WHEN 'N' FETCH NEXT     i064_cs INTO g_hrcx.hrcx01,g_hrcx.hrcx02,g_hrcx.hrcx04
        WHEN 'P' FETCH PREVIOUS i064_cs INTO g_hrcx.hrcx01,g_hrcx.hrcx02,g_hrcx.hrcx04
        WHEN 'F' FETCH FIRST    i064_cs INTO g_hrcx.hrcx01,g_hrcx.hrcx02,g_hrcx.hrcx04
        WHEN 'L' FETCH LAST     i064_cs INTO g_hrcx.hrcx01,g_hrcx.hrcx02,g_hrcx.hrcx04
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
            FETCH ABSOLUTE g_jump i064_cs INTO g_hrcx.hrcx01,g_hrcx.hrcx02,g_hrcx.hrcx04
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcx.hrcx01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcx.* TO NULL
        CALL i064_setnull()   
        RETURN
    ELSE
      CASE p_flhrcx
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrcx.* FROM hrcx_file    
       WHERE hrcx01 = g_hrcx.hrcx01
         AND hrcx02 = g_hrcx.hrcx02
         AND hrcx04 = g_hrcx.hrcx04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrcx_file",g_hrcx.hrcx01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i064_show()                 
    END IF
END FUNCTION

FUNCTION i064_show()
DEFINE l_hrcx02_1     LIKE     hraa_file.hraa12
DEFINE l_hrcx03_1     LIKE     hrar_file.hrar04	
DEFINE at01cx06_1     LIKE     hrag_file.hrag07
DEFINE l_hrcx08_1     LIKE     hrag_file.hrag07
DEFINE l_hrcx11_1     LIKE     hrag_file.hrag07

    LET g_hrcx_t.* = g_hrcx.*
    DISPLAY BY NAME g_hrcx.hrcx02,g_hrcx.hrcx03,
                    g_hrcx.hrcx04,g_hrcx.hrcx05,g_hrcx.hrcx06,
                    g_hrcx.hrcx07,g_hrcx.hrcx08,
                    g_hrcx.hrcxuser,g_hrcx.hrcxgrup,g_hrcx.hrcxmodu,
                    g_hrcx.hrcxdate,g_hrcx.hrcxorig,g_hrcx.hrcxoriu
    LET l_hrat01 =''
    LET l_hrat02 =''
    LET l_hrat03 =''
    LET l_hrat04 =''
    LET l_hrat05 =''
    LET l_hrat06 =''
    LET l_hrat25 =''
    LET l_hrat03_name =''
    LET l_hrat04_name =''
    LET l_hrat05_name =''
    LET l_hrat06_name =''
    LET l_hrag07 =''
    SELECT hrat01,hrat02,hrat03,hrat04,hrat05,hrat06,hrat25
      INTO l_hrat01,l_hrat02,l_hrat03,l_hrat04,l_hrat05,l_hrat06,l_hrat25
      FROM hrat_file
     WHERE hratid = g_hrcx.hrcx01
     
    SELECT hraa12 INTO l_hrat03_name
      FROM  hraa_file
     WHERE hraa01=l_hrat03
     
    SELECT hrao02 INTO l_hrat04_name
     FROM  hrao_file
     WHERE hrao01=l_hrat04
       AND hrao00=l_hrat03
     
    SELECT hrap06 INTO l_hrat05_name
     FROM  hrap_file
     WHERE hrap05=l_hrat05
       AND hrap01=l_hrat04
     
    SELECT hrat02  INTO l_hrat06_name
      FROM hrat_file
     WHERE hrat01=l_hrat06
    
    SELECT hrag07 INTO l_hrag07 
      FROM hrag_file 
     WHERE hrag06=g_hrcx.hrcx03
       AND hrag01='530'
       AND hragacti='Y'
       
    DISPLAY l_hrat01 TO hrat01   	
    DISPLAY l_hrag07 TO hrag07                                                                                                                                        
    DISPLAY l_hrat02 TO hrat02
    DISPLAY l_hrat03 TO hrat03
    DISPLAY l_hrat03_name TO hrat03_name
    DISPLAY l_hrat04 TO hrat04
    DISPLAY l_hrat04_name TO hrat04_name
    DISPLAY l_hrat05 TO hrat05
    DISPLAY l_hrat05_name TO hrat05_name
    DISPLAY l_hrat06 TO hrat06
    DISPLAY l_hrat06_name TO hrat06_name
    DISPLAY l_hrat25 TO hrat25 
      
    CALL cl_show_fld_cont()
END FUNCTION


FUNCTION i064_u()
    IF g_hrcx.hrcx01 IS NULL  THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i064_cl USING g_hrcx.hrcx01,g_hrcx.hrcx02,g_hrcx.hrcx04
    IF STATUS THEN
       CALL cl_err("OPEN i064_cl:", STATUS, 1)
       CLOSE i064_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i064_cl INTO g_hrcx.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcx.hrcx01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i064_show()                          
    WHILE TRUE
        CALL i064_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrcx.*=g_hrcx_t.*
            CALL i064_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrcx.hrcxmodu=g_user
        LET g_hrcx.hrcxdate=g_today	
        UPDATE hrcx_file SET hrcx_file.* = g_hrcx.*    
            WHERE hrcx01 = g_hrcx_t.hrcx01
              AND hrcx02 = g_hrcx_t.hrcx02
              AND hrcx04 = g_hrcx_t.hrcx04
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrcx_file",g_hrcx.hrcx01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i064_show()	
        EXIT WHILE
    END WHILE
    CLOSE i064_cl
    COMMIT WORK
    CALL i064_show()
END FUNCTION


FUNCTION i064_r()
    IF g_hrcx.hrcx01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i064_cl USING g_hrcx.hrcx01,g_hrcx.hrcx02,g_hrcx.hrcx04
    IF STATUS THEN
       CALL cl_err("OPEN i064_cl:", STATUS, 0)
       CLOSE i064_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i064_cl INTO g_hrcx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcx.hrcx01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i064_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrcx01"
       LET g_doc.value1 = g_hrcx.hrcx01
       CALL cl_del_doc()
       
       DELETE FROM hrcx_file 
        WHERE hrcx01 = g_hrcx.hrcx01  
         AND hrcx02 = g_hrcx_t.hrcx02
         AND hrcx04 = g_hrcx_t.hrcx04
     
       
       CLEAR FORM
       OPEN i064_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i064_cl
          CLOSE i064_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i064_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i064_cl
          CLOSE i064_count
          COMMIT WORK
     
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i064_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i064_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i064_fetch('/')
       END IF
    END IF
    CLOSE i064_cl
    COMMIT WORK
    CALL i064_show()
END FUNCTION

FUNCTION i064_recard()	
DEFINE l_date LIKE hrcx_file.hrcx06
DEFINE l_time LIKE hrcx_file.hrcx07
DEFINE  p_row,p_col         LIKE type_file.num5
     IF g_hrcx.hrcx01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    LET p_row = 2 LET p_col = 2

    OPEN WINDOW i064_w1 AT p_row,p_col 
     WITH FORM "ghr/42f/ghri0641"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
   CALL cl_set_label_justify("i064_w1","right")  
   LET l_date = g_hrcx.hrcx06
   LET l_time = g_hrcx.hrcx07
   
   DISPLAY BY NAME l_date,l_time

   INPUT BY NAME  l_date,l_time 
                  WITHOUT DEFAULTS

      AFTER FIELD l_date 
      IF cl_null(l_date)THEN 
         NEXT FIELD l_date 
      ELSE 
      	 IF g_hrcx.hrcx04>l_date OR (g_hrcx.hrcx04=l_date	 AND g_hrcx.hrcx05>l_time) THEN 
             LET l_errmeg=g_hrcx.hrcx04,' ',g_hrcx.hrcx05,'>',l_date,' ',l_time
             CALL cl_err(l_errmeg,'ghr-099',1)
             NEXT FIELD l_date 
           END IF 
      END IF 
      
      AFTER FIELD l_time
       IF NOT cl_null(l_time) THEN
            LET g_h=''
         	  LET g_m='' 
         	  LET g_h=l_time[1,2]
         	  LET g_m=l_time[4,5]
         	  IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
         	  	 CALL cl_err(l_time,'asf-807',0)
         	  	 NEXT FIELD l_time
         	  END IF 
         	  IF   g_hrcx.hrcx04=l_date	 AND g_hrcx.hrcx05>l_time THEN 
         	    LET l_errmeg=g_hrcx.hrcx04,' ',g_hrcx.hrcx05,'>',l_date,' ',l_time
              CALL cl_err(l_errmeg,'ghr-099',1)
              NEXT FIELD l_time 
           END IF	                                                 	  	
         END IF	
      
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
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i064_w1 RETURN END IF
   IF NOT cl_null(l_date) AND NOT cl_null(l_time) THEN 
      UPDATE hrcx_file 
        SET  hrcx08 = 'Y',
             hrcx06 = l_date,
             hrcx07 = l_time
       WHERE hrcx01 = g_hrcx.hrcx01
         AND hrcx02 = g_hrcx.hrcx02
         AND hrcx04 = g_hrcx.hrcx04           
            
              
    IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","hrcx_file",l_date,l_time,SQLCA.sqlcode,"","",1) 
    END IF 
   END IF      
   CLOSE WINDOW i064_w1 
   SELECT *  INTO g_hrcx.* FROM hrcx_file 
    WHERE hrcx01 = g_hrcx.hrcx01
      AND hrcx02 = g_hrcx.hrcx02
      AND hrcx04 = g_hrcx.hrcx04  
   CALL  i064_show()
END FUNCTION 

FUNCTION i064_setnull()
LET l_hrat01 = NULL 
LET l_hrat02 = NULL
LET l_hrat03 = NULL
LET l_hrat03_name = NULL
LET l_hrat04 = NULL
LET l_hrat04_name = NULL
LET l_hrat05 = NULL
LET l_hrat05_name = NULL
LET l_hrat06 = NULL
LET l_hrat06_name = NULL
LET l_hrat25 = NULL
END FUNCTION