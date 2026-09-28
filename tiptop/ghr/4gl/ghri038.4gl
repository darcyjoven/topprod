# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri038.4gl
# Descriptions...: 
# Date & Author..: 05/09/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE g_hrbx              RECORD LIKE hrbx_file.*
DEFINE g_hrbx_t            RECORD LIKE hrbx_file.*
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_wc,g_sql          STRING
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_rec_b             LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_msg               STRING
DEFINE g_hrby              DYNAMIC ARRAY OF RECORD
          hrby02    LIKE hrby_file.hrby02,
          hrby03    LIKE hrby_file.hrby03,
          hrby04    LIKE hrby_file.hrby04,
          hrby05    LIKE hrby_file.hrby05,
          hrby06    LIKE hrby_file.hrby06,
          hrby07    LIKE hrby_file.hrby07,
          hrby08    LIKE hrby_file.hrby08,
          hrat02    LIKE hrat_file.hrat02,
          hrby10    LIKE hrby_file.hrby10,
          hrby11    LIKE hrby_file.hrby11,
          hrby13    LIKE hrby_file.hrby13,
          hrbyacti  LIKE hrby_file.hrbyacti
                END RECORD 
               
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
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   INITIALIZE g_hrbx.* TO NULL
   
   LET g_forupd_sql = "SELECT * FROM hrbx_file WHERE hrbx01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i038_cl CURSOR FROM g_forupd_sql                 
   
   OPEN WINDOW i038_w AT 2,4
     WITH FORM "ghr/42f/ghri038"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   
   LET g_action_choice=""
   CALL i038_menu()

 
   CLOSE WINDOW i038_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN


FUNCTION i038_curs()

    CLEAR FORM
    INITIALIZE g_hrbx.* TO NULL
    CONSTRUCT BY NAME g_wc ON                              
        hrbx01,hrbx02,hrbx03,hrbx04,hrbx05,hrbx06,hrbx07,hrbx08,
        hrbxuser,hrbxgrup,hrbxmodu,hrbxdate,hrbxoriu,hrbxorig

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrbx01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbx01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbx.hrbx01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbx01
                 NEXT FIELD hrbx01
                 
              WHEN INFIELD(hrbx02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbu01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbx.hrbx02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbx02
                 NEXT FIELD hrbx02
                 
             WHEN INFIELD(hrbx04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrbx.hrbx04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrbx04
                 NEXT FIELD hrbx04                 

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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbxuser', 'hrbxgrup')  
                        
    CALL cl_replace_str(g_wc,'hrbx04','hrat01') RETURNING g_wc

    LET g_sql = "SELECT hrbx01 FROM hrbx_file LEFT OUTER JOIN hrat_file ",        
                "    ON hratid=hrbx04 WHERE ",g_wc CLIPPED, 
                " ORDER BY hrbx01"
    PREPARE i038_prepare FROM g_sql
    DECLARE i038_cs SCROLL CURSOR WITH HOLD FOR i038_prepare

    LET g_sql = "SELECT COUNT(*) FROM hrbx_file LEFT OUTER JOIN hrat_file ON hratid=hrbx04 WHERE ",g_wc CLIPPED
    PREPARE i038_precount FROM g_sql
    DECLARE i038_count CURSOR FOR i038_precount
END FUNCTION
	
FUNCTION i038_menu()
    DEFINE l_cmd    STRING
    DEFINE l_hrbu23 LIKE hrbu_file.hrbu23

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i038_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i038_q()
            END IF

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i038_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i038_r()
            END IF
            	
        ON ACTION ghri038_a
            LET g_action_choice="ghri038_a"
            IF cl_chk_act_auth() THEN
            	SELECT hrbu23 INTO l_hrbu23 FROM hrbu_file WHERE hrbu01=g_hrbx.hrbx02
            	IF l_hrbu23=1 THEN 
               CALL i038_read_txt()
              ELSE 
               CALL i038_read_excel()
              END IF 
            END IF    	

        ON ACTION ghri038_b
            LET g_action_choice='ghri038_b'
            IF cl_chk_act_auth() THEN 
               CALL i038_modify_txt()
            END IF 
           
        ON ACTION HELP
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
            
        ON ACTION next
            CALL i038_fetch('N')

        ON ACTION previous
            CALL i038_fetch('P')    

        ON ACTION jump
            CALL i038_fetch('/')

        ON ACTION first
            CALL i038_fetch('F')

        ON ACTION last
            CALL i038_fetch('L')

        ON ACTION item_list
            CALL i038_list_fill()
            
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
              IF g_hrbx.hrbx01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrbx01"
                 LET g_doc.value1 = g_hrbx.hrbx01
                 CALL cl_doc()
              END IF
           END IF
    END MENU
    
END FUNCTION	
	
FUNCTION i038_a()
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING	
DEFINE l_no         LIKE type_file.chr10	
DEFINE l_hrat01     LIKE hrat_file.hrat01
DEFINE l_hrbx01     LIKE hrbx_file.hrbx01
DEFINE l_n          LIKE type_file.num5
DEFINE l_sql        STRING

    CLEAR FORM     
    INITIALIZE g_hrbx.* LIKE hrbx_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrbx.hrbx03 = g_today
        LET g_hrbx.hrbx05 = 'Y'
        LET g_hrbx.hrbxuser = g_user
        LET g_hrbx.hrbxoriu = g_user
        LET g_hrbx.hrbxorig = g_grup
        LET g_hrbx.hrbxgrup = g_grup 
        LET g_hrbx.hrbxmodu = g_user
        LET g_hrbx.hrbxdate = g_today
        LET l_year=YEAR(g_today) USING "&&&&"
        LET l_month=MONTH(g_today) USING "&&"
        LET l_day=DAY(g_today) USING "&&"
        LET l_year=l_year.trim()
        LET l_month=l_month.trim()
        LET l_day=l_day.trim()
        LET g_hrbx.hrbx01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
        CALL i038_i("a")                  
        IF INT_FLAG THEN            
            INITIALIZE g_hrbx.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrbx.hrbx01 IS NULL THEN   
            CONTINUE WHILE
        END IF
        LET l_hrbx01=g_hrbx.hrbx01,"%"
        LET l_sql="SELECT MAX(hrbx01) FROM hrbx_file",
                   "  WHERE hrbx01 LIKE '",l_hrbx01,"'"
        PREPARE i038_hrbx01 FROM l_sql
        EXECUTE i038_hrbx01 INTO g_hrbx.hrbx01
        IF cl_null(g_hrbx.hrbx01) THEN 
           LET g_hrbx.hrbx01=l_hrbx01[1,8],'0001'
        ELSE
           LET l_no=g_hrbx.hrbx01[9,12]
           LET l_no=l_no+1 USING "&&&&"
           LET g_hrbx.hrbx01=l_hrbx01[1,8],l_no
        END IF
        	
        DISPLAY BY NAME g_hrbx.hrbx01
        
        LET l_hrat01=g_hrbx.hrbx04
        SELECT hratid INTO g_hrbx.hrbx04 FROM hrat_file WHERE hrat01=l_hrat01 
        		  	
        INSERT INTO hrbx_file VALUES(g_hrbx.*)     
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbx_file",g_hrbx.hrbx01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrbx01 INTO g_hrbx.hrbx01 FROM hrbx_file WHERE hrbx01 = g_hrbx.hrbx01
        END IF
        EXIT WHILE
    END WHILE

END FUNCTION	

FUNCTION i038_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_sql         STRING
   DEFINE l_hrbx02_desc LIKE hrbu_file.hrbu02
   DEFINE l_hrbx04_desc LIKE hrat_file.hrat02

   DISPLAY BY NAME
      g_hrbx.hrbx01,g_hrbx.hrbx02,g_hrbx.hrbx03,g_hrbx.hrbx04,
      g_hrbx.hrbx05,g_hrbx.hrbx06,g_hrbx.hrbx07,g_hrbx.hrbx08,
      g_hrbx.hrbxuser,g_hrbx.hrbxgrup,g_hrbx.hrbxmodu,g_hrbx.hrbxdate

   INPUT BY NAME
      g_hrbx.hrbx01,g_hrbx.hrbx02,g_hrbx.hrbx04,
      g_hrbx.hrbx03,g_hrbx.hrbx05,g_hrbx.hrbx06
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i038_set_entry(p_cmd)
          CALL i038_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          
      
      AFTER FIELD hrbx02
         IF NOT cl_null(g_hrbx.hrbx02) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrbu_file WHERE hrbu01=g_hrbx.hrbx02 
            IF l_n=0 THEN
               CALL cl_err('无此考勤机型号信息','!',0)
            END IF
         	  
            SELECT hrbu02 INTO l_hrbx02_desc FROM hrbu_file
             WHERE hrbu01=g_hrbx.hrbx02
            DISPLAY l_hrbx02_desc TO hrbx02_desc   	  	
         END IF
         	
         	  		                                           
      AFTER FIELD hrbx04
         IF NOT cl_null(g_hrbx.hrbx04) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrat_file
             WHERE hrat01=g_hrbx.hrbx04 AND hratconf='Y'
            IF l_n=0 THEN
               CALL cl_err('无此考勤机员工信息','!',0)
               NEXT FIELD hrbx04
            END IF
         	  
            SELECT hrat02 INTO l_hrbx04_desc FROM hrat_file
             WHERE hrat01=g_hrbx.hrbx04 AND hratconf='Y'
            DISPLAY l_hrbx04_desc TO hrbx04_desc   	  	
         END IF 

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
         CASE
           WHEN INFIELD(hrbx02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbu01"
              LET g_qryparam.default1 = g_hrbx.hrbx02
              CALL cl_create_qry() RETURNING g_hrbx.hrbx02
              DISPLAY BY NAME g_hrbx.hrbx02
              NEXT FIELD hrbx02
           
           WHEN INFIELD(hrbx04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = g_hrbx.hrbx04
              LET g_qryparam.arg1 = g_hrbx.hrbx04
              CALL cl_create_qry() RETURNING g_hrbx.hrbx04
              DISPLAY BY NAME g_hrbx.hrbx04
              NEXT FIELD hrbx04
            
           OTHERWISE EXIT CASE
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
	
FUNCTION i038_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrbx.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i038_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i038_count
    FETCH i038_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i038_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbx.hrbx01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbx.* TO NULL
    ELSE
        CALL i038_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION	
	
FUNCTION i038_fetch(p_flhrbx)
    DEFINE p_flhrbx         LIKE type_file.chr1

    CASE p_flhrbx
        WHEN 'N' FETCH NEXT     i038_cs INTO g_hrbx.hrbx01
        WHEN 'P' FETCH PREVIOUS i038_cs INTO g_hrbx.hrbx01
        WHEN 'F' FETCH FIRST    i038_cs INTO g_hrbx.hrbx01
        WHEN 'L' FETCH LAST     i038_cs INTO g_hrbx.hrbx01
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
            FETCH ABSOLUTE g_jump i038_cs INTO g_hrbx.hrbx01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrbx.hrbx01,SQLCA.sqlcode,0)
        INITIALIZE g_hrbx.* TO NULL
        LET g_hrbx.hrbx01 = NULL
        RETURN
    ELSE
      CASE p_flhrbx
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrbx.* FROM hrbx_file    
       WHERE hrbx01 = g_hrbx.hrbx01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrbx_file",g_hrbx.hrbx01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i038_show()                 
    END IF
END FUNCTION

FUNCTION i038_show()
DEFINE l_hrbx02_desc     LIKE     hrbu_file.hrbu02
DEFINE l_hrbx04_desc     LIKE     hrat_file.hrat02	
    
    
    LET g_hrbx_t.* = g_hrbx.*
    
    SELECT hrat01 INTO g_hrbx.hrbx04 FROM hrat_file WHERE hratid=g_hrbx.hrbx04
    
    DISPLAY BY NAME g_hrbx.hrbx01,g_hrbx.hrbx02,g_hrbx.hrbx03,
                    g_hrbx.hrbx04,g_hrbx.hrbx05,g_hrbx.hrbx06,
                    g_hrbx.hrbx07,g_hrbx.hrbx08,
                    g_hrbx.hrbxuser,g_hrbx.hrbxgrup,g_hrbx.hrbxmodu,
                    g_hrbx.hrbxdate,g_hrbx.hrbxorig,g_hrbx.hrbxoriu
    SELECT hrbu02 INTO l_hrbx02_desc FROM hrbu_file WHERE hrbu01=g_hrbx.hrbx02
    SELECT hrat02 INTO l_hrbx04_desc FROM hrat_file WHERE hrat01=g_hrbx.hrbx04
    DISPLAY l_hrbx02_desc TO hrbx02_desc
    DISPLAY l_hrbx04_desc TO hrbx04_desc
    
    CALL cl_show_fld_cont()
END FUNCTION	
	
FUNCTION i038_u()
    IF g_hrbx.hrbx01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i038_cl USING g_hrbx.hrbx01
    IF STATUS THEN
       CALL cl_err("OPEN i038_cl:", STATUS, 1)
       CLOSE i038_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i038_cl INTO g_hrbx.*    
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbx.hrbx01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i038_show()                      
    WHILE TRUE
        CALL i038_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrbx.*=g_hrbx_t.*
            CALL i038_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrbx.hrbxmodu=g_user
        LET g_hrbx.hrbxdate=g_today
        
        SELECT hratid INTO g_hrbx.hrbx04 FROM hrat_file WHERE hrat01=g_hrbx.hrbx04
        	
        UPDATE hrbx_file SET hrbx_file.* = g_hrbx.*    
            WHERE hrbx01 = g_hrbx_t.hrbx01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrbx_file",g_hrbx.hrbx01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        SELECT * INTO g_hrbx.* FROM hrbx_file WHERE hrbx01=g_hrbx.hrbx01	 
        CALL i038_show()	
        EXIT WHILE
    END WHILE
    CLOSE i038_cl
    COMMIT WORK
END FUNCTION	
	
FUNCTION i038_r()
DEFINE l_n   LIKE   type_file.num5

    IF g_hrbx.hrbx01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i038_cl USING g_hrbx.hrbx01
    IF STATUS THEN
       CALL cl_err("OPEN i038_cl:", STATUS, 0)
       CLOSE i038_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i038_cl INTO g_hrbx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrbx.hrbx01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i038_show()
    LET l_n=0 
    SELECT COUNT(*) INTO l_n FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
    IF l_n>0 THEN
       IF cl_confirm('已汇入采集数据,是否继续?') THEN
       	  LET g_doc.column1 = "hrbx01"
          LET g_doc.value1 = g_hrbx.hrbx01

          CALL cl_del_doc()
          DELETE FROM hrbx_file WHERE hrbx01 = g_hrbx.hrbx01
          DELETE FROM hrby_file WHERE hrby01 = g_hrbx.hrbx01
          CLEAR FORM
          OPEN i038_count
          IF STATUS THEN
             CLOSE i038_cl
             CLOSE i038_count
             COMMIT WORK
             RETURN
          END IF
          FETCH i038_count INTO g_row_count
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i038_cl
             CLOSE i038_count
             COMMIT WORK
             RETURN
          END IF
          DISPLAY g_row_count TO FORMONLY.cnt

          OPEN i038_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i038_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE                 #No.FUN-6A0066
             CALL i038_fetch('/')
          END IF
       END IF	  
    ELSE   	 
       IF cl_delete() THEN
          LET g_doc.column1 = "hrbx01"
          LET g_doc.value1 = g_hrbx.hrbx01

          CALL cl_del_doc()
          DELETE FROM hrbx_file WHERE hrbx01 = g_hrbx.hrbx01

          CLEAR FORM
          OPEN i038_count
          IF STATUS THEN
             CLOSE i038_cl
             CLOSE i038_count
             COMMIT WORK
             RETURN
          END IF
          FETCH i038_count INTO g_row_count
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i038_cl
             CLOSE i038_count
             COMMIT WORK
             RETURN
          END IF
          DISPLAY g_row_count TO FORMONLY.cnt

          OPEN i038_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i038_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE                 #No.FUN-6A0066
             CALL i038_fetch('/')
          END IF
       END IF
    END IF   	
    CLOSE i038_cl
    COMMIT WORK
END FUNCTION	
	
PRIVATE FUNCTION i038_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrbx02,hrbx05",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i038_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   DEFINE   l_n       LIKE type_file.num5

   IF p_cmd = 'u' THEN
   	  SELECT COUNT(*) INTO l_n FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
   	  IF l_n>0 THEN
         CALL cl_set_comp_entry("hrbx02,hrbx05",FALSE)
      END IF   
   END IF
END FUNCTION
	
FUNCTION i038_read_txt()
DEFINE ls_file          STRING 
DEFINE ls_loc           STRING 
DEFINE ls_file_t        LIKE type_file.chr1000
DEFINE l_channel        base.Channel
DEFINE s                STRING
DEFINE s_t              LIKE type_file.chr100
DEFINE day_now          DATETIME YEAR TO DAY
DEFINE time_now         DATETIME HOUR TO FRACTION(5)
DEFINE l_hrbu           RECORD LIKE hrbu_file.* 
DEFINE l_i              LIKE type_file.num5
DEFINE l_n              LIKE type_file.num5 
DEFINE l_length1        LIKE type_file.num5
DEFINE l_length2        LIKE type_file.num5
DEFINE l_hrbx07         LIKE hrbx_file.hrbx07
DEFINE l_hrbx08         LIKE hrbx_file.hrbx08
DEFINE l_a              LIKE type_file.num5
DEFINE l_b              LIKE type_file.num5 
DEFINE l_year           STRING
DEFINE l_month          STRING
DEFINE l_day            STRING
DEFINE l_date           LIKE type_file.dat
DEFINE l_sql            STRING         
DEFINE l_end            LIKE type_file.num5
DEFINE l_enda           LIKE type_file.num5
DEFINE l_endb           LIKE type_file.num5

       CREATE TEMP TABLE tmp_file(
          usestr LIKE type_file.chr100,
          usenum LIKE hrby_file.hrby02);
       DELETE FROM tmp_file
       
       IF g_hrbx.hrbx01 IS NULL THEN
          CALL cl_err('',-400,0)
          RETURN
       END IF

       LET ls_file = cl_browse_file()   #获取文件
       IF cl_null(ls_file) THEN
          RETURN
       END IF
 
       LET day_now = CURRENT YEAR TO DAY
       LET time_now = CURRENT HOUR TO FRACTION(5)
       LET ls_loc="/u1/topprod/tiptop/ghr/ghri038/ghri038_",day_now,".",time_now,".txt"
       
       IF NOT cl_upload_file(ls_file,ls_loc) THEN
          CALL cl_err(NULL,"lib-212", 1)
          RETURN
       END IF
       	
       LET l_channel=base.channel.create()
       CALL l_channel.openfile(ls_loc , "r" ) 
       IF STATUS THEN
          CALL l_channel.close()
          CALL cl_err(ls_loc,'!','1')
          RETURN 
       END IF 

       SELECT hrbu_file.*,greatest(hrbu05,hrbu07,hrbu09,hrbu11,hrbu13,hrbu15,hrbu17,hrbu19,hrbu21) 
         INTO l_hrbu.*,l_length2 
         FROM hrbu_file
        WHERE hrbu01=g_hrbx.hrbx02
	   
       LET l_n=0 
       SELECT COUNT(*) INTO l_n FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
       IF l_n>0 THEN
          IF NOT cl_confirm('已有采集数据,是否删除原有数据,重新汇入') THEN
             RETURN
          ELSE
             DELETE FROM hrby_file WHERE hrby01=g_hrbx.hrbx01	  
             UPDATE hrbx_file SET hrbx07=NULL,hrbx08=NULL WHERE hrbx01=g_hrbx.hrbx01
          END IF
       END IF		

       LET l_n=1
       WHILE TRUE
           LET s = l_channel.readLine()
           IF l_channel.isEof() THEN EXIT WHILE END IF 
           IF s IS NULL OR s=" " THEN   
             CONTINUE WHILE 
           END IF 

           LET l_length1=s.getLength()
           IF l_length1<l_length2 THEN
              CONTINUE WHILE
           END IF

           LET l_year=s.subString(l_hrbu.hrbu08,l_hrbu.hrbu09)
           LET l_month=s.subString(l_hrbu.hrbu10,l_hrbu.hrbu11)
           LET l_day=s.subString(l_hrbu.hrbu12,l_hrbu.hrbu13)
           IF l_hrbu.hrbu09-l_hrbu.hrbu08='1' THEN 
              LET l_year='20',l_year
           END IF 
           LET l_year=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
           LET l_sql=" SELECT to_date('",l_year,"','yyyymmdd') FROM DUAL"
           PREPARE get_hrby05 FROM l_sql
           EXECUTE get_hrby05 INTO l_date
          
           LET s_t=s
           INSERT INTO tmp_file VALUES(s_t,l_n)
           INSERT INTO hrby_file(hrby01,hrby02,hrby05,hrby11,hrby12,hrbyacti) VALUES(g_hrbx.hrbx01,l_n,l_date,'0','1','Y')
           LET l_n=l_n+1
       END WHILE

       LET l_end=l_hrbu.hrbu05-l_hrbu.hrbu04+1
       LET l_sql="UPDATE hrby_file SET hrby03=(SELECT substr(usestr,",l_hrbu.hrbu04,",",l_end,") FROM tmp_file WHERE hrby02=usenum)",
                 " WHERE hrby01='",g_hrbx.hrbx01,"'" 
       PREPARE ins_p2 FROM l_sql
       EXECUTE ins_p2

       LET l_end=l_hrbu.hrbu07-l_hrbu.hrbu06+1
       LET l_sql="UPDATE hrby_file SET hrby04=(SELECT substr(usestr,",l_hrbu.hrbu06,",",l_end,") FROM tmp_file WHERE hrby02=usenum)",
                 " WHERE hrby01='",g_hrbx.hrbx01,"'" 
       PREPARE ins_p3 FROM l_sql
       EXECUTE ins_p3

       LET l_end=l_hrbu.hrbu15-l_hrbu.hrbu14+1
       LET l_enda=l_hrbu.hrbu17-l_hrbu.hrbu16+1
       LET l_endb=l_hrbu.hrbu19-l_hrbu.hrbu18+1
       IF l_hrbu.hrbu19>0 THEN 
          LET l_sql="UPDATE hrby_file SET hrby06=(SELECT substr(usestr,",l_hrbu.hrbu14,",",l_end,")||':'||substr(usestr,",l_hrbu.hrbu16,",",l_enda,")||':'||substr(usestr,",l_hrbu.hrbu18,",",l_endb,") FROM tmp_file WHERE hrby02=usenum)"
       ELSE
          LET l_sql="UPDATE hrby_file SET hrby06=(SELECT substr(usestr,",l_hrbu.hrbu14,",",l_end,")||':'||substr(usestr,",l_hrbu.hrbu16,",",l_enda,") FROM tmp_file WHERE hrby02=usenum)"
       END IF 
       LET l_sql=l_sql CLIPPED," WHERE hrby01='",g_hrbx.hrbx01,"'" 
       PREPARE ins_p4 FROM l_sql
       EXECUTE ins_p4

       IF l_hrbu.hrbu21>0 THEN
          LET l_end=l_hrbu.hrbu21-l_hrbu.hrbu20+1
          LET l_sql=" UPDATE hrby_file SET hrby07=(SELECT substr(usestr,",l_hrbu.hrbu20,",",l_end,") FROM tmp_file WHERE hrby02=usenum)",
                    " WHERE hrby01='",g_hrbx.hrbx01,"'" 
          PREPARE ins_p5 FROM l_sql
          EXECUTE ins_p5
       END IF 
       
       IF l_length1>l_length2 THEN
          LET l_end=l_length1-l_length2+1
          LET l_sql="UPDATE hrby_file SET hrby08=(SELECT substr(usestr,",l_length2,",",l_end,") FROM tmp_file WHERE hrby02=usenum)",
                    " WHERE hrby01='",g_hrbx.hrbx01,"'" 
          PREPARE ins_p6 FROM l_sql
          EXECUTE ins_p6
       END IF 
       
       LET l_sql="UPDATE hrby_file SET hrby11='2' WHERE hrby03 NOT IN",
                 " (SELECT hrbv01 FROM hrbv_file) AND hrby01='",g_hrbx.hrbx01,"'"
       PREPARE ins_p7 FROM l_sql
       EXECUTE ins_p7

       LET l_sql="UPDATE hrby_file SET hrby09=(SELECT hrcx01 FROM hrcx_file",
                 " WHERE rownum=1 AND hrcx04||hrcx05<=hrby05||hrby06",
                 "   AND (hrcx06 IS NULL OR hrcx06||hrcx07>=hrby05||hrby06)",
                 "   AND hrcx02=hrby04) WHERE hrby11='0' AND hrby01='",g_hrbx.hrbx01,"'"
       PREPARE ins_p8 FROM l_sql
       EXECUTE ins_p8

       LET l_sql="UPDATE hrby_file SET hrby09=(SELECT hrbw01 FROM hrbw_file", 
                 " WHERE rownum=1 AND hrbw05<=hrby05 AND hrbw02=hrby04 ",
                 "   AND (hrbw06 IS NULL OR  hrbw06>=hrby05)) WHERE hrby11='0'",
                 "   AND hrby09 IS NULL AND hrby01='",g_hrbx.hrbx01,"'"
       PREPARE ins_p9 FROM l_sql
       EXECUTE ins_p9
       
       LET l_sql="UPDATE hrby_file SET hrby11='3' WHERE hrby01='",g_hrbx.hrbx01,"' AND hrby09 IS NULL AND hrby11='0'"
       PREPARE ins_p10 FROM l_sql
       EXECUTE ins_p10

       LET l_sql="UPDATE hrby_file SET hrby11='1' WHERE hrby01='",g_hrbx.hrbx01,"' AND hrby11='0'"
       PREPARE ins_p11 FROM l_sql
       EXECUTE ins_p11
          
       IF l_hrbu.hrbu21>0 THEN 
          LET l_sql="UPDATE hrby_file SET hrby10=(SELECT hrbua03 FROM hrbua_file",
                    " WHERE hrbua01=hrby03 AND hrbua02=hrby07 ) WHERE hrby01='",g_hrbx.hrbx01,"'"
       ELSE 
          LET l_sql="UPDATE hrby_file SET hrby10=(SELECT hrbv04 FROM hrbv_file",
                    " WHERE hrbv01=hrby03 ) WHERE hrby01='",g_hrbx.hrbx01,"'",
                    "   AND hrby11<>'2'"
       END IF 
       PREPARE ins_p12 FROM l_sql
       EXECUTE ins_p12


       LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                 "( SELECT hrby09||hrby05 FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
       PREPARE upd_p1 FROM l_sql
       EXECUTE upd_p1
      
       LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                 "( SELECT hrby09||(hrby05+1) FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
       PREPARE upd_p2 FROM l_sql
       EXECUTE upd_p2

       LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                 "( SELECT hrby09||(hrby05-1) FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
       PREPARE upd_p3 FROM l_sql
       EXECUTE upd_p3      
                
       LET ls_file_t=ls_file
       LET l_a=ls_file.getLength()
       FOR l_b=l_a TO 1 STEP -1
           IF ls_file_t[l_b,l_b]='/' THEN 
              EXIT FOR
           END IF 
       END FOR 
       LET l_b=l_b+1
       LET l_hrbx07=ls_file_t[l_b,l_a]
       SELECT max(hrby02) INTO l_hrbx08 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
       IF cl_null(l_hrbx08) THEN LET l_hrbx08=0 END IF 
       UPDATE hrbx_file SET hrbx07=l_hrbx07,hrbx08=l_hrbx08 WHERE hrbx01=g_hrbx.hrbx01
       DISPLAY l_hrbx07 TO hrbx07
       DISPLAY l_hrbx08 TO hrbx08

       CALL cl_err('数据采集完毕','!',1)
       	
END FUNCTION 	

FUNCTION i038_modify_txt()
DEFINE lr_err  DYNAMIC ARRAY OF RECORD
       line    STRING,
       key1    STRING,
       err     STRING
               END RECORD
DEFINE l_hrby  RECORD LIKE hrby_file.*
DEFINE l_sql   STRING
DEFINE li_k    LIKE type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_count LIKE type_file.num5

       LET li_k=1 
       LET l_sql="SELECT * FROM hrby_file WHERE hrby11!='1' "
       PREPARE modify_p FROM l_sql
       DECLARE modify_c CURSOR FOR modify_p
       FOREACH modify_c INTO l_hrby.*
          LET l_hrby.hrby09=NULL       #清空重新赋值
          LET l_hrby.hrby10=NULL       #清空重新赋值
          LET l_hrby.hrby11=NULL       #清空重新赋值
          
          LET l_n=0
          SELECT count(*) INTO l_n FROM hrbv_file WHERE hrbv01=l_hrby.hrby03
          IF l_n=0 THEN 
             LET l_hrby.hrby11='2'
             LET lr_err[li_k].line=li_k
             LET lr_err[li_k].key1=l_hrby.hrby01,"(",l_hrby.hrby02,")"
             LET lr_err[li_k].err='未登记考勤机'
             LET li_k=li_k+1
          ELSE
             LET l_sql="SELECT hrcx01 FROM hrcx_file WHERE hrcx02='",l_hrby.hrby04,"' AND rownum=1 ",
                       "   AND ((hrcx04-to_date('",l_hrby.hrby05,"'))*24*60+",
                       "        (substr(hrcx05,1,2)-substr('",l_hrby.hrby06,"',1,2))*60+",
                       "        (substr(hrcx05,4,2)-substr('",l_hrby.hrby06,"',4,2)))<=0",
                       "   AND (((hrcx06-to_date('",l_hrby.hrby05,"'))*24*60+",
                       "        (substr(hrcx07,1,2)-substr('",l_hrby.hrby06,"',1,2))*60+",
                       "        (substr(hrcx07,4,2)-substr('",l_hrby.hrby06,"',4,2)))>=0 OR hrcx06 IS NULL )"
             PREPARE i038_new_hrby09 FROM l_sql
             EXECUTE i038_new_hrby09 INTO l_hrby.hrby09
             IF cl_null(l_hrby.hrby09) THEN  
                SELECT hrbw01 INTO l_hrby.hrby09 FROM hrbw_file 
                 WHERE hrbw02=l_hrby.hrby04 AND rownum=1
                   AND hrbw05<=l_hrby.hrby05
                   AND (hrbw06>=l_hrby.hrby05 OR hrbw06 IS null)
                IF STATUS=100 THEN 
                   LET l_hrby.hrby11='3'
                   LET lr_err[li_k].line=li_k
                   LET lr_err[li_k].key1=l_hrby.hrby01,"(",l_hrby.hrby02,")"
                   LET lr_err[li_k].err='未注册电子卡'
                   LET li_k=li_k+1
                ELSE
                   LET l_hrby.hrby11='1'
                END IF 
             ELSE 
                LET l_hrby.hrby11='1'
             END IF 
          END IF 

          IF l_hrby.hrby11!='2' THEN 
             SELECT hrbv04 INTO l_hrby.hrby10 FROM hrbv_file
              WHERE hrbv01=l_hrby.hrby03
          END IF 
             
          UPDATE hrby_file SET hrby09=l_hrby.hrby09,hrby10=l_hrby.hrby10,hrby11=l_hrby.hrby11
           WHERE hrby01=l_hrby.hrby01 AND hrby02=l_hrby.hrby02

          IF l_hrby.hrby11='1' THEN 
             LET l_count=0
             SELECT count(*) INTO l_count FROM hrcp_file WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05-1 AND hrcp35='Y' AND hrcpconf='N'
             IF l_count>0 THEN 
                UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05-1
             END IF 
             LET l_count=0
             SELECT count(*) INTO l_count FROM hrcp_file WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05 AND hrcp35='Y' AND hrcpconf='N'
             IF l_count>0 THEN 
                UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05
             END IF    
             LET l_count=0
             SELECT count(*) INTO l_count FROM hrcp_file WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05+1 AND hrcp35='Y' AND hrcpconf='N'
             IF l_count>0 THEN 
                UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02=l_hrby.hrby09 AND hrcp03=l_hrby.hrby05+1
             END IF 
          END IF 

          IF SQLCA.sqlcode THEN
             LET lr_err[li_k].line=li_k
             LET lr_err[li_k].key1=l_hrby.hrby01,"(",l_hrby.hrby02,")"
             LET lr_err[li_k].err=SQLCA.sqlcode
             LET li_k=li_k+1
             CONTINUE FOREACH   
          END IF  
       END FOREACH

       CALL lr_err.deleteElement(li_k)
       IF lr_err.getLength() > 0 THEN
          CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"行序|单号(项次)|错误描述")  
       END IF

       CALL cl_err('数据修正完毕','!',1)
END FUNCTION 
		
FUNCTION i038_list_fill()
   LET g_sql = "SELECT hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby08,hrat02,hrby10,hrby11,hrby13,hrbyacti",
               "  FROM hrby_file LEFT OUTER JOIN hrat_file ON hratid=hrby09",
               " WHERE hrby01='",g_hrbx.hrbx01,"'",
               " ORDER BY hrby02"
   PREPARE i038_get_hrby_p FROM g_sql
   DECLARE i038_get_hrby_c CURSOR FOR i038_get_hrby_p
   CALL g_hrby.clear()
   LET g_cnt = 1

   FOREACH i038_get_hrby_c INTO g_hrby[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrby.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrby TO s_hrby.* ATTRIBUTE(COUNT=g_rec_b)
         
      ON ACTION EXIT 
         EXIT PROGRAM 
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION MAIN
         CALL i038_show()
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION 

FUNCTION i038_read_excel()
DEFINE l_file     LIKE type_file.chr1000,
       l_file1    STRING,
       l_file2    LIKE type_file.chr1000,
       l_filename LIKE type_file.chr200,
       l_sql      STRING,
       l_data     VARCHAR(300),
       p_argv1    LIKE type_file.num5
DEFINE l_count    LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrby03   LIKE hrby_file.hrby03,
         hrby04   LIKE hrby_file.hrby04,
         hrby05   LIKE hrby_file.hrby05,
         hrby06   LIKE hrby_file.hrby06,
         hrby07   LIKE hrby_file.hrby07
        
              END RECORD      
DEFINE l_tok         base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r  LIKE  type_file.num5
DEFINE l_n           LIKE type_file.num5
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
DEFINE l_gfe02       LIKE gfe_file.gfe02
DEFINE l_gfeacti     LIKE gfe_file.gfeacti
DEFINE l_flag        LIKE type_file.num5,
       l_fac         LIKE ima_file.ima31_fac 
DEFINE l_hrbu        RECORD  LIKE hrbu_file.*
DEFINE l_hrby02      LIKE hrby_file.hrby02
DEFINE l_rq          LIKE type_file.chr20
DEFINE l_rq1          LIKE type_file.chr20
DEFINE l_rq2          LIKE type_file.chr20
DEFINE l_rq3          LIKE type_file.chr20
DEFINE l_hrbx07         LIKE hrbx_file.hrbx07
DEFINE l_hrbx08         LIKE hrbx_file.hrbx08
DEFINE l_a              LIKE type_file.num5
DEFINE l_b              LIKE type_file.num5 
DEFINE l_hrby051        LIKE hrby_file.hrby05
DEFINE l_hrby052        LIKE hrby_file.hrby05
DEFINE l_hrby053        LIKE hrby_file.hrby05
DEFINE l_hrby061        LIKE hrby_file.hrby06
DEFINE l_hrby062        LIKE hrby_file.hrby06
DEFINE l_hrby063        LIKE hrby_file.hrby06

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   IF g_hrbx.hrbx01 IS NULL THEN
          CALL cl_err('',-400,0)
          RETURN
   END IF
   LET l_n=0 
       SELECT COUNT(*) INTO l_n FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
       IF l_n>0 THEN
          IF NOT cl_confirm('已有采集数据,是否删除原有数据,重新汇入') THEN
             RETURN
          ELSE
             DELETE FROM hrby_file WHERE hrby01=g_hrbx.hrbx01	  
             UPDATE hrbx_file SET hrbx07=NULL,hrbx08=NULL WHERE hrbx01=g_hrbx.hrbx01
          END IF
       END IF		
   SELECT * INTO g_hrbx.* FROM hrbx_file WHERE hrbx01= g_hrbx.hrbx01
   SELECT * INTO l_hrbu.* FROM hrbu_file WHERE hrbu01=	g_hrbx.hrbx02
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
       LET l_file1=l_file
       LET l_file2=l_file
     
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
                IF l_hrbu.hrbu30='2' THEN           
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu24||').Value'],[sr.hrby03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu25||').Value'],[sr.hrby04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu27||').Value'],[sr.hrby05])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu28||').Value'],[sr.hrby06])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu31||').Value'],[l_hrby061])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu32||').Value'],[l_hrby062])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu33||').Value'],[l_hrby063])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu29||').Value'],[sr.hrby07])
                 ELSE 
                 	  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu24||').Value'],[sr.hrby03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu25||').Value'],[sr.hrby04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu26||').Value'],[l_rq])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu31||').Value'],[l_rq1])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu32||').Value'],[l_rq2])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu33||').Value'],[l_rq3])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||l_hrbu.hrbu29||').Value'],[sr.hrby07])
                    LET sr.hrby05=l_rq[1,10]
                    LET l_hrby051=l_rq1[1,10]
                    LET l_hrby052=l_rq2[1,10]
                    LET l_hrby053=l_rq3[1,10]
                    LET sr.hrby06=l_rq[12,19]
                    LET l_hrby061=l_rq1[12,19]
                    LET l_hrby062=l_rq2[12,19]
                    LET l_hrby063=l_rq3[12,19]
                END IF 
                IF NOT cl_null(sr.hrby03) AND NOT cl_null(sr.hrby04) AND NOT cl_null(sr.hrby07) THEN 
                	 IF i > 1 THEN 
                	  IF NOT cl_null(sr.hrby05) AND NOT cl_null(sr.hrby06) THEN 
                	  	SELECT MAX(hrby02) INTO l_hrby02 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
                	  	IF cl_null(l_hrby02) THEN LET l_hrby02=0 END IF 
                     INSERT INTO hrby_file(hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby11,hrby12,hrbyacti)
                      VALUES (g_hrbx.hrbx01,l_hrby02+1,sr.hrby03,sr.hrby04,sr.hrby05,sr.hrby06,sr.hrby07,0,1,'Y')
                     IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrby_file",g_hrbx.hrbx01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                     END IF 
                    END IF
                    IF l_hrbu.hrbu30='2' THEN
                    	IF NOT cl_null(sr.hrby05) AND NOT cl_null(l_hrby061) THEN 
                	  	 SELECT MAX(hrby02) INTO l_hrby02 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
                	  	 IF cl_null(l_hrby02) THEN LET l_hrby02=0 END IF 
                       INSERT INTO hrby_file(hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby11,hrby12,hrbyacti)
                       VALUES (g_hrbx.hrbx01,l_hrby02+1,sr.hrby03,sr.hrby04,sr.hrby05,l_hrby061,sr.hrby07,0,1,'Y')
                      IF SQLCA.sqlcode THEN 
                        CALL cl_err3("ins","hrby_file",g_hrbx.hrbx01,'',SQLCA.sqlcode,"","",1)   
                        LET g_success  = 'N'
                        CONTINUE FOR 
                      END IF 
                      END IF
                      IF NOT cl_null(sr.hrby05) AND NOT cl_null(l_hrby062) THEN 
                	  	 SELECT MAX(hrby02) INTO l_hrby02 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
                	  	 IF cl_null(l_hrby02) THEN LET l_hrby02=0 END IF 
                       INSERT INTO hrby_file(hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby11,hrby12,hrbyacti)
                       VALUES (g_hrbx.hrbx01,l_hrby02+1,sr.hrby03,sr.hrby04,sr.hrby05,l_hrby062,sr.hrby07,0,1,'Y')
                      IF SQLCA.sqlcode THEN 
                        CALL cl_err3("ins","hrby_file",g_hrbx.hrbx01,'',SQLCA.sqlcode,"","",1)   
                        LET g_success  = 'N'
                        CONTINUE FOR 
                      END IF 
                      END IF
                      IF NOT cl_null(sr.hrby05) AND NOT cl_null(l_hrby063) THEN 
                	  	 SELECT MAX(hrby02) INTO l_hrby02 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
                	  	 IF cl_null(l_hrby02) THEN LET l_hrby02=0 END IF 
                       INSERT INTO hrby_file(hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby11,hrby12,hrbyacti)
                       VALUES (g_hrbx.hrbx01,l_hrby02+1,sr.hrby03,sr.hrby04,sr.hrby05,l_hrby063,sr.hrby07,0,1,'Y')
                       IF SQLCA.sqlcode THEN 
                        CALL cl_err3("ins","hrby_file",g_hrbx.hrbx01,'',SQLCA.sqlcode,"","",1)   
                        LET g_success  = 'N'
                        CONTINUE FOR 
                       END IF 
                      END IF
                     ELSE 
                     	IF NOT cl_null(l_hrby051) AND NOT cl_null(l_hrby061) THEN 
                	  	 SELECT MAX(hrby02) INTO l_hrby02 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
                	  	 IF cl_null(l_hrby02) THEN LET l_hrby02=0 END IF 
                       INSERT INTO hrby_file(hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby11,hrby12,hrbyacti)
                       VALUES (g_hrbx.hrbx01,l_hrby02+1,sr.hrby03,sr.hrby04,l_hrby051,l_hrby061,sr.hrby07,0,1,'Y')
                      IF SQLCA.sqlcode THEN 
                        CALL cl_err3("ins","hrby_file",g_hrbx.hrbx01,'',SQLCA.sqlcode,"","",1)   
                        LET g_success  = 'N'
                        CONTINUE FOR 
                      END IF 
                      END IF
                      IF NOT cl_null(l_hrby052) AND NOT cl_null(l_hrby062) THEN 
                	  	 SELECT MAX(hrby02) INTO l_hrby02 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
                	  	 IF cl_null(l_hrby02) THEN LET l_hrby02=0 END IF 
                       INSERT INTO hrby_file(hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby11,hrby12,hrbyacti)
                       VALUES (g_hrbx.hrbx01,l_hrby02+1,sr.hrby03,sr.hrby04,l_hrby052,l_hrby062,sr.hrby07,0,1,'Y')
                      IF SQLCA.sqlcode THEN 
                        CALL cl_err3("ins","hrby_file",g_hrbx.hrbx01,'',SQLCA.sqlcode,"","",1)   
                        LET g_success  = 'N'
                        CONTINUE FOR 
                      END IF 
                      END IF
                      IF NOT cl_null(l_hrby053) AND NOT cl_null(l_hrby063) THEN 
                	  	 SELECT MAX(hrby02) INTO l_hrby02 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
                	  	 IF cl_null(l_hrby02) THEN LET l_hrby02=0 END IF 
                       INSERT INTO hrby_file(hrby01,hrby02,hrby03,hrby04,hrby05,hrby06,hrby07,hrby11,hrby12,hrbyacti)
                       VALUES (g_hrbx.hrbx01,l_hrby02+1,sr.hrby03,sr.hrby04,l_hrby053,l_hrby063,sr.hrby07,0,1,'Y')
                       IF SQLCA.sqlcode THEN 
                        CALL cl_err3("ins","hrby_file",g_hrbx.hrbx01,'',SQLCA.sqlcode,"","",1)   
                        LET g_success  = 'N'
                        CONTINUE FOR 
                       END IF 
                      END IF
                    END IF  
                   END IF 
                END IF 
                 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                 ELSE IF g_success = 'Y' THEN 
                   COMMIT WORK 
                   LET l_sql="UPDATE hrby_file SET hrby11='2' WHERE hrby03 NOT IN",
                  " (SELECT hrbv01 FROM hrbv_file) AND hrby01='",g_hrbx.hrbx01,"'"
                   PREPARE ins_s7 FROM l_sql
                   EXECUTE ins_s7
                   
                   LET l_sql="UPDATE hrby_file SET hrby09=(SELECT hrcx01 FROM hrcx_file",
                             " WHERE rownum=1 AND hrcx04||hrcx05<=hrby05||hrby06",
                             "   AND (hrcx06 IS NULL OR hrcx06||hrcx07>=hrby05||hrby06)",
                             "   AND hrcx02=hrby04) WHERE hrby11='0' AND hrby01='",g_hrbx.hrbx01,"'"
                   PREPARE ins_s8 FROM l_sql
                   EXECUTE ins_s8
                   
                   LET l_sql="UPDATE hrby_file SET hrby09=(SELECT hrbw01 FROM hrbw_file", 
                             " WHERE rownum=1 AND hrbw05<=hrby05 AND hrbw02=hrby04 ",
                             "   AND (hrbw06 IS NULL OR  hrbw06>=hrby05)) WHERE hrby11='0'",
                             "   AND hrby09 IS NULL AND hrby01='",g_hrbx.hrbx01,"'"
                   PREPARE ins_s9 FROM l_sql
                   EXECUTE ins_s9
                   
                   LET l_sql="UPDATE hrby_file SET hrby11='3' WHERE hrby01='",g_hrbx.hrbx01,"' AND hrby09 IS NULL AND hrby11='0'"
                   PREPARE ins_s10 FROM l_sql
                   EXECUTE ins_s10
                   
                   LET l_sql="UPDATE hrby_file SET hrby11='1' WHERE hrby01='",g_hrbx.hrbx01,"' AND hrby11='0'"
                   PREPARE ins_s11 FROM l_sql
                   EXECUTE ins_s11
                      
                   IF l_hrbu.hrbu29>0 THEN 
                      LET l_sql="UPDATE hrby_file SET hrby10=(SELECT hrbua03 FROM hrbua_file",
                                " WHERE hrbua01=hrby03 AND hrbua02=hrby07 ) WHERE hrby01='",g_hrbx.hrbx01,"'"
                   ELSE 
                      LET l_sql="UPDATE hrby_file SET hrby10=(SELECT hrbv04 FROM hrbv_file",
                                " WHERE hrbv01=hrby03 ) WHERE hrby01='",g_hrbx.hrbx01,"'",
                                "   AND hrby11<>'2'"
                   END IF 
                   PREPARE ins_s12 FROM l_sql
                   EXECUTE ins_s12
                   
                   
                   LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                             "( SELECT hrby09||hrby05 FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
                   PREPARE upd_s1 FROM l_sql
                   EXECUTE upd_s1
                   
                   LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                             "( SELECT hrby09||(hrby05+1) FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
                   PREPARE upd_s2 FROM l_sql
                   EXECUTE upd_s2
                   
                   LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                             "( SELECT hrby09||(hrby05-1) FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
                   PREPARE upd_s3 FROM l_sql
                   EXECUTE upd_s3      
                   LET l_a=l_file1.getLength()
                   FOR l_b=l_a TO 1 STEP -1
                       IF l_file2[l_b,l_b]='/' THEN 
                          EXIT FOR
                       END IF 
                   END FOR 
                   LET l_b=l_b+1
                   LET l_hrbx07=l_file2[l_b,l_a]
                   SELECT max(hrby02) INTO l_hrbx08 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
                   IF cl_null(l_hrbx08) THEN LET l_hrbx08=0 END IF 
                   UPDATE hrbx_file SET hrbx07=l_hrbx07,hrbx08=l_hrbx08 WHERE hrbx01=g_hrbx.hrbx01
                   DISPLAY l_hrbx07 TO hrbx07
                   DISPLAY l_hrbx08 TO hrbx08
                   CALL cl_err( '数据采集完毕','!', 1 )
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
       
       SELECT * INTO g_hrbx.* FROM hrbx_file
       WHERE hrbx01=g_hrbx.hrbx01
       
       CALL i038_show()
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------
