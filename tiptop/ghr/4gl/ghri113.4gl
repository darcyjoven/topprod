# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri114.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrbs_h       RECORD
           hrbs01     LIKE hrbs_file.hrbs01,    
           hrbs02     LIKE hrbs_file.hrbs02,
           hrbs03     LIKE hrbs_file.hrbs03,
           hrbs04     LIKE hrbs_file.hrbs04,
           hrbs05     LIKE hrbs_file.hrbs05
           END RECORD,
       g_hrbs_h_t       RECORD
           hrbs01     LIKE hrbs_file.hrbs01,    
           hrbs02     LIKE hrbs_file.hrbs02,
           hrbs03     LIKE hrbs_file.hrbs03,
           hrbs04     LIKE hrbs_file.hrbs04,
           hrbs05     LIKE hrbs_file.hrbs05
           END RECORD,         
       g_hrbs         DYNAMIC ARRAY OF RECORD 
           hrbs06     LIKE hrbs_file.hrbs06,    
           hrbs07     LIKE hrbs_file.hrbs07,    
           hrbsa03    LIKE hrbsa_file.hrbsa03,    
           hrbs08     LIKE hrbs_file.hrbs08,    
           hrbs09     LIKE hrbs_file.hrbs09,    
           hrbs10     LIKE hrbs_file.hrbs10,    
           hrbs11     LIKE hrbs_file.hrbs11,    
           hrbs12     LIKE hrbs_file.hrbs12,    
           hrbs13     LIKE hrbs_file.hrbs13,    
           hrbs14     LIKE hrbs_file.hrbs14,    
           hrbs15     LIKE hrbs_file.hrbs15,    
           hrbsacti   LIKE hrbs_file.hrbsacti    
           END RECORD,
       g_hrbs_t       RECORD
           hrbs06     LIKE hrbs_file.hrbs06,    
           hrbs07     LIKE hrbs_file.hrbs07,    
           hrbsa03    LIKE hrbsa_file.hrbsa03,    
           hrbs08     LIKE hrbs_file.hrbs08,    
           hrbs09     LIKE hrbs_file.hrbs09,    
           hrbs10     LIKE hrbs_file.hrbs10,    
           hrbs11     LIKE hrbs_file.hrbs11,    
           hrbs12     LIKE hrbs_file.hrbs12,    
           hrbs13     LIKE hrbs_file.hrbs13,    
           hrbs14     LIKE hrbs_file.hrbs14,    
           hrbs15     LIKE hrbs_file.hrbs15,    
           hrbsacti   LIKE hrbs_file.hrbsacti                     
           END RECORD,
       g_sql         STRING,                      
       g_wc          STRING,                     
       g_wc2         STRING,                    
       g_rec_b       LIKE type_file.num5,      
       l_ac          LIKE type_file.num5
DEFINE g_hrbs_lock   RECORD LIKE hrbs_file.*             
DEFINE g_forupd_sql        STRING               
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5  
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_msg               STRING

MAIN
   OPTIONS                              
      INPUT NO WRAP
   DEFER INTERRUPT                     
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i113_w WITH FORM "ghr/42f/ghri113"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   LET g_forupd_sql =" SELECT * FROM hrbs_file ",
                      "  WHERE hrbs01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i113_lock_u CURSOR FROM g_forupd_sql
      
   CALL cl_ui_init() 
   CALL i113_menu()
   CLOSE WINDOW i113_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i113_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   
   CLEAR FORM 
   CALL g_hrbs.clear()
   CALL cl_set_head_visible("","YES")    
   INITIALIZE g_hrbs_h.* TO NULL     
   CONSTRUCT BY NAME g_wc ON hrbs05,hrbs03,hrbs01,hrbs02,hrbs04 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()  
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbs05)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hraa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbs05 
               NEXT FIELD hrbs05
            
            WHEN INFIELD(hrbs03)             
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrbr01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbs03 
               NEXT FIELD hrbs03
                  
            OTHERWISE EXIT CASE
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
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrbsuser', 'hrbsgrup')
   IF INT_FLAG THEN
      RETURN
   END IF

   CONSTRUCT g_wc2 ON hrbs06,hrbs07,hrbs08,hrbs09,hrbs10,hrbs11,hrbs12,
                      hrbs13,hrbs14,hrbs15,hrbsacti
           FROM s_hrbs[1].hrbs06,s_hrbs[1].hrbs07,s_hrbs[1].hrbs08,s_hrbs[1].hrbs09,
                s_hrbs[1].hrbs10,s_hrbs[1].hrbs11,s_hrbs[1].hrbs12,s_hrbs[1].hrbs13,
                s_hrbs[1].hrbs14,s_hrbs[1].hrbs15,s_hrbs[1].hrbsacti
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)  
      ON ACTION CONTROLP
         CASE            
         WHEN INFIELD(hrbs07)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_hrbsa02"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO hrbs07                  
            NEXT FIELD hrbs07
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
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql = "SELECT DISTINCT hrbs01,hrbs02,hrbs03,hrbs04,hrbs05 FROM hrbs_file ",
               " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED, 
               " ORDER BY hrbs01"
   PREPARE i113_prepare FROM g_sql
   DECLARE i113_cs SCROLL CURSOR WITH HOLD FOR i113_prepare 
   LET g_sql="SELECT COUNT(DISTINCT hrbs01) FROM hrbs_file WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   PREPARE i113_precount FROM g_sql
   DECLARE i113_count CURSOR FOR i113_precount
END FUNCTION
	
FUNCTION i113_menu()
   WHILE TRUE
      CALL i113_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i113_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i113_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i113_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i113_u()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i113_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i113_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbs TO s_hrbs.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
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
      ON ACTION first
         CALL i113_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i113_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY  
      ON ACTION jump
         CALL i113_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i113_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i113_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
       ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about         
         CALL cl_about()     
      AFTER DISPLAY
         CONTINUE DISPLAY
      #&include "qry_string.4gl" 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
FUNCTION i113_a()
DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE ls_doc      STRING
   MESSAGE ""
   CLEAR FORM
   CALL g_hrbs.clear()
   LET g_wc = NULL
   LET g_wc2= NULL 
   IF s_shut(0) THEN
      RETURN
   END IF
   INITIALIZE g_hrbs_h.*  TO NULL      
   WHILE TRUE
      CALL i113_i("a")      
      IF INT_FLAG THEN     
         INITIALIZE g_hrbs_h.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_hrbs_h.hrbs01) OR cl_null(g_hrbs_h.hrbs02) THEN 
         CONTINUE WHILE
      END IF
      LET g_rec_b = 0
      CALL i113_b_fill(' 1=1') 
      CALL i113_b() 
      EXIT WHILE
   END WHILE
END FUNCTION
	
FUNCTION i113_u()

   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrbs_h.hrbs01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrbs_h_t.*=g_hrbs_h.*
   
   BEGIN WORK
   OPEN i113_lock_u USING g_hrbs_h.hrbs01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE i113_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i113_lock_u INTO g_hrbs_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gae01 LOCK:",SQLCA.sqlcode,1)
      CLOSE i113_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL i113_i("u")
      IF INT_FLAG THEN
         LET g_hrbs_h.*=g_hrbs_h_t.*
         DISPLAY BY NAME g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                         g_hrbs_h.hrbs03,g_hrbs_h.hrbs04,
                         g_hrbs_h.hrbs05
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE hrbs_file SET hrbs01 = g_hrbs_h.hrbs01,
                           hrbs02 = g_hrbs_h.hrbs02, 
                           hrbs03 = g_hrbs_h.hrbs03,
                           hrbs04 = g_hrbs_h.hrbs04,
                           hrbs05 = g_hrbs_h.hrbs05
       WHERE hrbs01 = g_hrbs_h_t.hrbs01
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("upd","hrbs_file",g_hrbs_h_t.hrbs01,'',SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION	
 
FUNCTION i113_i(p_cmd)
DEFINE  p_cmd          LIKE type_file.chr1
DEFINE  l_num          LIKE type_file.num5
DEFINE  l_hrbs05_desc  LIKE hraa_file.hraa12   
DEFINE  l_hrbs03_desc  LIKE hrbr_file.hrbr02  
 
   IF s_shut(0) THEN
      RETURN
   END IF
   DISPLAY BY NAME g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                   g_hrbs_h.hrbs03,g_hrbs_h.hrbs04,
                   g_hrbs_h.hrbs05        
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_hrbs_h.hrbs05,g_hrbs_h.hrbs03,
                 g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                 g_hrbs_h.hrbs04 
      WITHOUT DEFAULTS 
      
      AFTER FIELD hrbs01
         IF NOT cl_null(g_hrbs_h.hrbs01) THEN
         	  IF g_hrbs_h.hrbs01 != g_hrbs_h_t.hrbs01 OR
         	  	 g_hrbs_h_t.hrbs01 IS NULL THEN 
               LET l_num = 0        
               SELECT COUNT(*) INTO l_num FROM hrbs_file WHERE hrbs01 = g_hrbs_h.hrbs01
               IF l_num>0 THEN
               	  CALL cl_err(g_hrbs_h.hrbs01,-239,0)
               	  NEXT FIELD hrbs01
               END IF	  
            END IF
         END IF   
         		
      AFTER FIELD hrbs02
         IF NOT cl_null(g_hrbs_h.hrbs02) THEN
            IF g_hrbs_h.hrbs02 != g_hrbs_h_t.hrbs02 OR
         	  	 g_hrbs_h_t.hrbs02 IS NULL THEN 
               LET l_num = 0        
               SELECT COUNT(*) INTO l_num FROM hrbs_file WHERE hrbs02 = g_hrbs_h.hrbs02
               IF l_num>0 THEN
               	  CALL cl_err(g_hrbs_h.hrbs02,-239,0)
               	  NEXT FIELD hrbs02
               END IF	  
            END IF
         END IF
         	
      AFTER FIELD hrbs03
         IF NOT cl_null(g_hrbs_h.hrbs03) THEN
         	  LET l_num=0
         	  SELECT COUNT(*) INTO l_num FROM hrbr_file
         	   WHERE hrbr01=g_hrbs_h.hrbs03
         	  IF l_num=0 THEN
         	  	 CALL cl_err('无此银行编码','!',0)
         	  	 NEXT FIELD hrbs03
         	  END IF
         	  	
         	  SELECT hrbr02 INTO l_hrbs03_desc FROM hrbr_file
         	   WHERE hrbr01=g_hrbs_h.hrbs03
         	  DISPLAY l_hrbs03_desc TO hrbs03_desc  	
         END IF
       
      AFTER FIELD hrbs05
         IF NOT cl_null(g_hrbs_h.hrbs05) THEN
         	  LET l_num=0
         	  SELECT COUNT(*) INTO l_num FROM hraa_file
         	   WHERE hraa01=g_hrbs_h.hrbs05
         	  IF l_num=0 THEN
         	  	 CALL cl_err('无此公司编码','!',0)
         	  	 NEXT FIELD hrbs05
         	  END IF
         	  	
         	  SELECT hraa12 INTO l_hrbs05_desc FROM hraa_file
         	   WHERE hraa01=g_hrbs_h.hrbs05
         	  DISPLAY l_hrbs05_desc TO hrbs05_desc  	
         END IF  	
         		  		      	
         	
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrbs05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.default1 = g_hrbs_h.hrbs05
               CALL cl_create_qry() RETURNING g_hrbs_h.hrbs05 
               DISPLAY BY NAME g_hrbs_h.hrbs05
               NEXT FIELD hrbs05
            WHEN INFIELD(hrbs03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrbr01"
               LET g_qryparam.default1 = g_hrbs_h.hrbs03
               CALL cl_create_qry() RETURNING g_hrbs_h.hrbs03 
               DISPLAY BY NAME g_hrbs_h.hrbs03
               NEXT FIELD hrbs03
                
            OTHERWISE EXIT CASE
          END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about   
         CALL cl_about() 
      ON ACTION help    
         CALL cl_show_help()
   END INPUT
END FUNCTION	

FUNCTION i113_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gae   RECORD LIKE gae_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_hrbs_h.hrbs01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM hrbs_file
       WHERE hrbs01 = g_hrbs_h.hrbs01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","hrbs_file",g_hrbs_h.hrbs01,'',SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_hrbs.clear()
         OPEN i113_count
         FETCH i113_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i113_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i113_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE           #No.FUN-6A0080
            CALL i113_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
	
FUNCTION i113_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hrbs.clear()
   DISPLAY ' ' TO FORMONLY.cn3
   CALL i113_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_hrbs_h.* TO NULL
      RETURN
   END IF
   OPEN i113_cs      
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hrbs_h.* TO NULL
   ELSE
      OPEN i113_count
      FETCH i113_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i113_fetch('F')             
   END IF
END FUNCTION
 
FUNCTION i113_fetch(p_flag)
DEFINE  p_flag        LIKE type_file.chr1 
DEFINE  l_hrbs05_desc LIKE hraa_file.hraa12    
DEFINE  l_hrbs03_desc LIKE hrbr_file.hrbr02    
   CASE p_flag
      WHEN 'N' FETCH NEXT     i113_cs INTO g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                                           g_hrbs_h.hrbs03,g_hrbs_h.hrbs04,
                                           g_hrbs_h.hrbs05
      WHEN 'P' FETCH PREVIOUS i113_cs INTO g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                                           g_hrbs_h.hrbs03,g_hrbs_h.hrbs04,
                                           g_hrbs_h.hrbs05 
      WHEN 'F' FETCH FIRST    i113_cs INTO g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                                           g_hrbs_h.hrbs03,g_hrbs_h.hrbs04,
                                           g_hrbs_h.hrbs05 
      WHEN 'L' FETCH LAST     i113_cs INTO g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                                           g_hrbs_h.hrbs03,g_hrbs_h.hrbs04,
                                           g_hrbs_h.hrbs05 
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
      FETCH ABSOLUTE g_jump i113_cs INTO g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                                         g_hrbs_h.hrbs03,g_hrbs_h.hrbs04,
                                         g_hrbs_h.hrbs05 
      LET g_no_ask = FALSE 
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrbs_h.hrbs01,SQLCA.sqlcode,0)
      INITIALIZE g_hrbs_h.* TO NULL     
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      DISPLAY g_curs_index TO FORMONLY.cn1          
   END IF
   DISPLAY BY NAME g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,
                   g_hrbs_h.hrbs03,g_hrbs_h.hrbs04,
                   g_hrbs_h.hrbs05
   SELECT hraa12 INTO l_hrbs05_desc FROM hraa_file WHERE hraa01 = g_hrbs_h.hrbs05 
   SELECT hrbr02 INTO l_hrbs03_desc FROM hrbr_file WHERE hrbr01 = g_hrbs_h.hrbs03 
   DISPLAY l_hrbs05_desc TO hrbs05_desc 
   DISPLAY l_hrbs03_desc TO hrbs03_desc 
   CALL i113_b_fill(g_wc2)
END FUNCTION
	
FUNCTION i113_b()
DEFINE     l_ac_t          LIKE type_file.num5,     
           l_n             LIKE type_file.num5,    
           l_cnt           LIKE type_file.num5,   
           l_lock_sw       LIKE type_file.chr1,  
           p_cmd           LIKE type_file.chr1, 
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5
DEFINE     l_i             LIKE type_file.num5
           
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrbs_h.hrbs01) OR cl_null(g_hrbs_h.hrbs02) THEN
      RETURN
   END IF
   CALL cl_opmsg('b')
   LET g_forupd_sql = "SELECT hrbs06,hrbs07,'',hrbs08,hrbs09,hrbs10,hrbs11,",
                      "       hrbs12,hrbs13,hrbs14,hrbs15,hrbsacti ", 
                      "  FROM hrbs_file",
                      "  WHERE hrbs01 =? AND hrbs06 = ? ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i113_bcl CURSOR FROM g_forupd_sql
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   INPUT ARRAY g_hrbs WITHOUT DEFAULTS FROM s_hrbs.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
      BEFORE INPUT
         DISPLAY "BEFORE INPUT!"
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      BEFORE ROW
         DISPLAY "BEFORE ROW!"
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'     
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_hrbs_t.* = g_hrbs[l_ac].*
            OPEN i113_bcl USING g_hrbs_h.hrbs01,g_hrbs_t.hrbs06
            IF STATUS THEN
               CALL cl_err("OPEN i113_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i113_bcl INTO g_hrbs[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_hrbs_t.hrbs06,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               	
               SELECT hrbsa03 INTO g_hrbs[l_ac].hrbsa03 FROM hrbsa_file
         	      WHERE hrbsa02=g_hrbs[l_ac].hrbs07	
            END IF 
         END IF
         	
      BEFORE INSERT
         DISPLAY "BEFORE INSERT!"
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_hrbs[l_ac].* TO NULL
         LET g_hrbs[l_ac].hrbs09='N'
         LET g_hrbs[l_ac].hrbs12='N'
         LET g_hrbs[l_ac].hrbs13='N'
         LET g_hrbs[l_ac].hrbsacti='Y' 
         SELECT MAX(hrbs06)+1 INTO g_hrbs[l_ac].hrbs06 FROM hrbs_file 
          WHERE hrbs01=g_hrbs_h.hrbs01
         IF cl_null(g_hrbs[l_ac].hrbs06) THEN 
         	  LET g_hrbs[l_ac].hrbs06=1
         END IF  
         LET g_hrbs_t.* = g_hrbs[l_ac].*  
         CALL cl_show_fld_cont()        
         NEXT FIELD hrbs07
         
      AFTER INSERT
         DISPLAY "AFTER INSERT!"
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO hrbs_file(hrbs01,hrbs02,hrbs03,hrbs04,hrbs05,hrbs06,hrbs07,hrbs08,
                               hrbs09,hrbs10,hrbs11,hrbs12,hrbs13,hrbs14,hrbs15,hrbsacti,
                               hrbsuser,hrbsgrup,hrbsoriu,hrbsorig)
                        VALUES(g_hrbs_h.hrbs01,g_hrbs_h.hrbs02,g_hrbs_h.hrbs03,
                               g_hrbs_h.hrbs04,g_hrbs_h.hrbs05,g_hrbs[l_ac].hrbs06,
                               g_hrbs[l_ac].hrbs07,g_hrbs[l_ac].hrbs08,g_hrbs[l_ac].hrbs09,
                               g_hrbs[l_ac].hrbs10,g_hrbs[l_ac].hrbs11,g_hrbs[l_ac].hrbs12,
                               g_hrbs[l_ac].hrbs13,g_hrbs[l_ac].hrbs14,g_hrbs[l_ac].hrbs15,
                               g_hrbs[l_ac].hrbsacti,g_user,g_grup,g_user,g_grup)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrbs_file",g_hrbs_h.hrbs01,g_hrbs[l_ac].hrbs06,SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         	
      AFTER FIELD hrbs07
         IF NOT cl_null(g_hrbs[l_ac].hrbs07) THEN
         	  LET l_i=0
         	  SELECT COUNT(*) INTO l_i FROM hrbsa_file
         	   WHERE hrbsa02=g_hrbs[l_ac].hrbs07
         	  IF l_i=0 THEN
         	     CALL cl_err('尚未维护此字段,请检查','!',0)
         	     NEXT FIELD hrbs07
         	  END IF
         	  
         	  SELECT hrbsa03 INTO g_hrbs[l_ac].hrbsa03 FROM hrbsa_file
         	   WHERE hrbsa02=g_hrbs[l_ac].hrbs07
         	  DISPLAY BY NAME g_hrbs[l_ac].hrbsa03 
         END IF	  	 	   
         	     	
          	
      BEFORE DELETE          
         DISPLAY "BEFORE DELETE"
         IF g_hrbs_t.hrbs06 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM hrbs_file
             WHERE hrbs01 = g_hrbs_h.hrbs01
               AND hrbs06 = g_hrbs_t.hrbs06
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","hrbs_file",g_hrbs_h.hrbs01,g_hrbs_t.hrbs06,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
         
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_hrbs[l_ac].* = g_hrbs_t.*
            CLOSE i113_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrbs[l_ac].hrbs06,-263,1)
            LET g_hrbs[l_ac].* = g_hrbs_t.*
         ELSE
            UPDATE hrbs_file SET hrbs07 = g_hrbs[l_ac].hrbs07,
                                 hrbs08 = g_hrbs[l_ac].hrbs08,
                                 hrbs09 = g_hrbs[l_ac].hrbs09,
                                 hrbs10 = g_hrbs[l_ac].hrbs10,
                                 hrbs11 = g_hrbs[l_ac].hrbs11,
                                 hrbs12 = g_hrbs[l_ac].hrbs12,
                                 hrbs13 = g_hrbs[l_ac].hrbs13,
                                 hrbs14 = g_hrbs[l_ac].hrbs14,
                                 hrbs15 = g_hrbs[l_ac].hrbs15,
                                 hrbsacti = g_hrbs[l_ac].hrbsacti,
                                 hrbsmodu = g_user,
                                 hrbsdate = g_today
             WHERE hrbs01=g_hrbs_h.hrbs01
               AND hrbs03=g_hrbs_t.hrbs06
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","hrbs_file",g_hrbs_h.hrbs01,g_hrbs_t.hrbs06,SQLCA.sqlcode,"","",1)
               LET g_hrbs[l_ac].* = g_hrbs_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
         	
      AFTER ROW
         DISPLAY  "AFTER ROW!!"
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_hrbs[l_ac].* = g_hrbs_t.*
            END IF
            CLOSE i113_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION controlp
         CASE 
            WHEN INFIELD(hrbs07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrbsa02"
               LET g_qryparam.default1 = g_hrbs[l_ac].hrbs07              
               CALL cl_create_qry() RETURNING g_hrbs[l_ac].hrbs07              
               DISPLAY BY NAME g_hrbs[l_ac].hrbs07
               NEXT FIELD hrbs07
            OTHERWISE 
               EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about     
         CALL cl_about() 
      ON ACTION help    
         CALL cl_show_help() 
      ON ACTION controls    
         CALL cl_set_head_visible("","AUTO")    
   END INPUT
   CLOSE i113_bcl
   COMMIT WORK
   CALL i113_b_fill(" 1=1 ")
END FUNCTION
	
FUNCTION i113_b_fill(p_wc2)
DEFINE p_wc2   STRING
   LET g_sql = "SELECT hrbs06,hrbs07,'',hrbs08,hrbs09,hrbs10,",
               "       hrbs11,hrbs12,hrbs13,hrbs14,hrbs15,hrbsacti ",
               " FROM hrbs_file",   
               " WHERE hrbs01 = '",g_hrbs_h.hrbs01,"'"   
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   PREPARE i113_pb FROM g_sql
   DECLARE hrbs_cs CURSOR FOR i113_pb
   CALL g_hrbs.clear()
   LET g_cnt = 1
   FOREACH hrbs_cs INTO g_hrbs[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       SELECT hrbsa03 INTO g_hrbs[g_cnt].hrbsa03 FROM hrbsa_file
        WHERE hrbsa02=g_hrbs[g_cnt].hrbs07	
       	
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrbs.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION			
