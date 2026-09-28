# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri201.4gl
# Descriptions...: 
# Date & Author..: 13/09/05 by jiangxt

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE g_hree              RECORD LIKE hree_file.*
DEFINE g_hree_t            RECORD LIKE hree_file.*
DEFINE g_forupd_sql        STRING
DEFINE g_wc,g_sql          STRING
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_rec_b             LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_msg               STRING
DEFINE g_hreea             DYNAMIC ARRAY OF RECORD
          hree05    LIKE hree_file.hree05,
          hree05_1  LIKE hral_file.hral02,
          hree01    LIKE hree_file.hree01,
          hrai04    LIKE hrai_file.hrai04,
          hree02    LIKE hree_file.hree02,
          hrdk03    LIKE hrdk_file.hrdk03,
          hree03    LIKE hree_file.hree03,
          aag02     LIKE aag_file.aag02,
          hree04    LIKE hree_file.hree04
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
 
   INITIALIZE g_hree.* TO NULL
   
   LET g_forupd_sql = "SELECT * FROM hree_file WHERE hree01=? AND hree02=? AND hree03=? AND hree05=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i201_cl CURSOR FROM g_forupd_sql                 
   
   OPEN WINDOW i201_w AT 2,4
     WITH FORM "ghr/42f/ghri201"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   
   LET g_action_choice=""
   CALL i201_menu()

 
   CLOSE WINDOW i201_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i201_curs()

    CLEAR FORM
    INITIALIZE g_hree.* TO NULL
    CONSTRUCT BY NAME g_wc ON hree05,hree01,hree02,hree03,hree04

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
           	  WHEN INFIELD(hree05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hral01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hree05
                 NEXT FIELD hree05
              WHEN INFIELD(hree01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrai03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hree01
                 NEXT FIELD hree01
                 
              WHEN INFIELD(hree02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrdk01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hree02
                 NEXT FIELD hree02
                 
             WHEN INFIELD(hree03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '00'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hree03
                 NEXT FIELD hree03

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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hreeuser', 'hreegrup')  

    LET g_sql = "SELECT hree01,hree02,hree03,hree05 FROM hree_file WHERE ",g_wc CLIPPED, 
                " ORDER BY hree01,hree02,hree03"
    PREPARE i201_prepare FROM g_sql
    DECLARE i201_cs SCROLL CURSOR WITH HOLD FOR i201_prepare

    LET g_sql = "SELECT COUNT(*) FROM hree_file WHERE ",g_wc CLIPPED
    PREPARE i201_precount FROM g_sql
    DECLARE i201_count CURSOR FOR i201_precount
END FUNCTION
	
FUNCTION i201_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i201_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i201_q()
            END IF

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i201_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i201_r()
            END IF
           
        ON ACTION HELP
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
            
        ON ACTION next
            CALL i201_fetch('N')

        ON ACTION previous
            CALL i201_fetch('P')    

        ON ACTION jump
            CALL i201_fetch('/')

        ON ACTION first
            CALL i201_fetch('F')

        ON ACTION last
            CALL i201_fetch('L')

        ON ACTION item_list
            CALL i201_list_fill()
            
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
    END MENU
    
END FUNCTION	
	
FUNCTION i201_a()

    CLEAR FORM     
    INITIALIZE g_hree.* LIKE hree_file.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hree.hreeacti = 'Y'
        LET g_hree.hreeuser = g_user
        LET g_hree.hreeoriu = g_user
        LET g_hree.hreeorig = g_grup
        LET g_hree.hreegrup = g_grup 
        LET g_hree.hreemodu = g_user
        LET g_hree.hreedate = g_today

        CALL i201_i("a")                  
        IF INT_FLAG THEN            
            INITIALIZE g_hree.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF

        INSERT INTO hree_file VALUES(g_hree.*)     
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hree_file",g_hree.hree01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i201_show()
        EXIT WHILE
    END WHILE
END FUNCTION	

FUNCTION i201_i(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_n      LIKE type_file.num5
DEFINE l_s      LIKE type_file.num5
DEFINE l_hrai04 LIKE hrai_file.hrai04
DEFINE l_hrdk03 LIKE hrdk_file.hrdk03
DEFINE l_aag02  LIKE aag_file.aag02
DEFINE l_hral02 LIKE hral_file.hral02
   
   INPUT BY NAME
      g_hree.hree05,g_hree.hree01,g_hree.hree02,g_hree.hree03,g_hree.hree04
      WITHOUT DEFAULTS

      BEFORE INPUT 
         IF p_cmd='u' THEN 
            LET g_hree_t.*=g_hree.*
         END IF 
      AFTER FIELD hree05
         IF NOT cl_null(g_hree.hree05) THEN
         SELECT COUNT(*) INTO l_n FROM hral_file WHERE hral01=g_hree.hree05
         IF l_n=0 THEN
            CALL cl_err('资料不存在，请重新录入','!',0)
            NEXT FIELD hree05
         ELSE
            SELECT hral02 INTO l_hral02 FROM hral_file WHERE hral01=g_hree.hree05
            DISPLAY l_hral02 TO hree05_1
         END IF
          
         END IF   
         IF NOT cl_null(g_hree.hree05) AND NOT cl_null(g_hree.hree01) THEN
         	 SELECT COUNT(*) INTO l_s FROM hrai_file WHERE hrai03=g_hree.hree01 AND hrai01= g_hree.hree05
         	 IF l_s='0' THEN 
         	 	CALL cl_err('资料不存在，请重新录入','!',0)
         	 	LET g_hree.hree05=' '
         	 	LET g_hree.hree01=' '
            NEXT FIELD hree05
         	 END IF 
         END IF 
      AFTER FIELD hree01
         IF NOT cl_null(g_hree.hree01) THEN
         SELECT COUNT(*) INTO l_n FROM hrai_file WHERE hrai03=g_hree.hree01 
         IF l_n=0 THEN
            CALL cl_err('资料不存在，请重新录入','!',0)
            NEXT FIELD hree01
         ELSE
            SELECT hrai04 INTO l_hrai04 FROM hrai_file WHERE hrai03=g_hree.hree01
            DISPLAY l_hrai04 TO hrai04
         END IF 
         END IF 
         IF NOT cl_null(g_hree.hree05) AND NOT cl_null(g_hree.hree01) THEN
         	 SELECT COUNT(*) INTO l_s FROM hrai_file WHERE hrai03=g_hree.hree01 AND hrai01= g_hree.hree05
         	 IF l_s='0' THEN 
         	 	CALL cl_err('资料不存在，请重新录入','!',0)
         	 	LET g_hree.hree05=' '
         	 	LET g_hree.hree01=' '
            NEXT FIELD hree01
         	 END IF 
         END IF	  		                                           
      AFTER FIELD hree02
         IF NOT cl_null(g_hree.hree02) THEN
         SELECT COUNT(*) INTO l_n FROM hrdk_file WHERE hrdk01=g_hree.hree02
         IF l_n=0 THEN
            CALL cl_err('资料不存在，请重新录入','!',0)
            NEXT FIELD hree02
         ELSE
            SELECT hrdk03 INTO l_hrdk03 FROM hrdk_file WHERE hrdk01=g_hree.hree02
            DISPLAY l_hrdk03 TO hrdk03
         END IF
         END IF 

      AFTER FIELD hree03
         IF NOT cl_null(g_hree.hree03) THEN
         SELECT COUNT(*) INTO l_n FROM aag_file WHERE aag00='00' AND aag01=g_hree.hree03
         IF l_n=0 THEN
            CALL cl_err('资料不存在，请重新录入','!',0)
            NEXT FIELD hree03
         ELSE
            SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag00='00' AND aag01=g_hree.hree03
            DISPLAY l_aag02 TO aag02
         END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

      ON ACTION controlp
         CASE
         	 WHEN INFIELD(hree05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hral01"
              CALL cl_create_qry() RETURNING g_hree.hree05
              DISPLAY BY NAME g_hree.hree05
              NEXT FIELD hree05
           WHEN INFIELD(hree01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrai03"
              IF NOT cl_null(g_hree.hree05) THEN
                LET g_qryparam.where = " hrai01=",g_hree.hree05," "
              END IF
              CALL cl_create_qry() RETURNING g_hree.hree01
              DISPLAY BY NAME g_hree.hree01
              NEXT FIELD hree01
           
           WHEN INFIELD(hree02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrdk01"
              CALL cl_create_qry() RETURNING g_hree.hree02
              DISPLAY BY NAME g_hree.hree02
              NEXT FIELD hree02

              
           WHEN INFIELD(hree03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aag"
              LET g_qryparam.arg1='00'
              CALL cl_create_qry() RETURNING g_hree.hree03
              DISPLAY BY NAME g_hree.hree03
              NEXT FIELD hree03
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
	
FUNCTION i201_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hree.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i201_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i201_count
    FETCH i201_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i201_cs                           
    IF SQLCA.sqlcode THEN
        INITIALIZE g_hree.* TO NULL
    ELSE
        CALL i201_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION	
	
FUNCTION i201_fetch(p_flhree)
DEFINE p_flhree         LIKE type_file.chr1

    CASE p_flhree
        WHEN 'N' FETCH NEXT     i201_cs INTO g_hree.hree01,g_hree.hree02,g_hree.hree03,g_hree.hree05
        WHEN 'P' FETCH PREVIOUS i201_cs INTO g_hree.hree01,g_hree.hree02,g_hree.hree03,g_hree.hree05
        WHEN 'F' FETCH FIRST    i201_cs INTO g_hree.hree01,g_hree.hree02,g_hree.hree03,g_hree.hree05
        WHEN 'L' FETCH LAST     i201_cs INTO g_hree.hree01,g_hree.hree02,g_hree.hree03,g_hree.hree05
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
            FETCH ABSOLUTE g_jump i201_cs INTO g_hree.hree01,g_hree.hree02,g_hree.hree03,g_hree.hree05
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        INITIALIZE g_hree.* TO NULL
        RETURN
    ELSE
      CASE p_flhree
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF

    SELECT * INTO g_hree.* FROM hree_file    
       WHERE hree01 = g_hree.hree01
         AND hree02 = g_hree.hree02
         AND hree03 = g_hree.hree03
         AND hree05 = g_hree.hree05
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hree_file",g_hree.hree01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i201_show()                 
    END IF
END FUNCTION

FUNCTION i201_show()
DEFINE l_hrai04     LIKE hrai_file.hrai04
DEFINE l_hrdk03     LIKE hrdk_file.hrdk03
DEFINE l_aag02      LIKE aag_file.aag02
DEFINE l_hral02 LIKE hral_file.hral02

    DISPLAY BY NAME g_hree.hree05,g_hree.hree01,g_hree.hree02,g_hree.hree03,
                    g_hree.hree04,g_hree.hreeacti,
                    g_hree.hreeuser,g_hree.hreegrup,g_hree.hreemodu,
                    g_hree.hreedate,g_hree.hreeorig,g_hree.hreeoriu
                    
    SELECT hrai04 INTO l_hrai04 FROM hrai_file WHERE hrai03=g_hree.hree01
    SELECT hral02 INTO l_hral02 FROM hral_file WHERE hral01=g_hree.hree05
    SELECT hrdk03 INTO l_hrdk03 FROM hrdk_file WHERE hrdk01=g_hree.hree02
    SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag00='00' AND aag01=g_hree.hree03
    DISPLAY l_hral02 TO hree05_1
    DISPLAY l_hrai04 TO hrai04
    DISPLAY l_hrdk03 TO hrdk03
    DISPLAY l_aag02 TO aag02
    
    CALL cl_show_fld_cont()
END FUNCTION	
	
FUNCTION i201_u()
    IF g_hree.hree01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i201_cl USING g_hree.hree01,g_hree.hree02,g_hree.hree03,g_hree.hree05
    IF STATUS THEN
       CALL cl_err("OPEN i201_cl:", STATUS, 1)
       CLOSE i201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i201_cl INTO g_hree.*    
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hree.hree01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i201_show()                      
    WHILE TRUE
        CALL i201_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hree.*=g_hree_t.*
            CALL i201_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hree.hreemodu=g_user
        LET g_hree.hreedate=g_today

        UPDATE hree_file SET hree_file.* = g_hree.*    
         WHERE hree01 = g_hree_t.hree01
           AND hree02 = g_hree_t.hree02
           AND hree03 = g_hree_t.hree03
           AND hree05 = g_hree_t.hree05

        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hree_file",g_hree.hree01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF 
        CALL i201_show()	
        EXIT WHILE
    END WHILE
    CLOSE i201_cl
    COMMIT WORK
END FUNCTION	
	
FUNCTION i201_r()
DEFINE l_n   LIKE   type_file.num5

    IF g_hree.hree01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i201_cl USING g_hree.hree01,g_hree.hree02,g_hree.hree03,g_hree.hree05
    IF STATUS THEN
       CALL cl_err("OPEN i201_cl:", STATUS, 0)
       CLOSE i201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i201_cl INTO g_hree.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hree.hree01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i201_show()
   	 
    IF cl_delete() THEN
       DELETE FROM hree_file WHERE hree01 = g_hree.hree01 AND hree02=g_hree.hree02 AND hree03=g_hree.hree03 AND hree05=g_hree.hree05
       CLEAR FORM
       OPEN i201_count
       IF STATUS THEN
          CLOSE i201_cl
          CLOSE i201_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i201_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i201_cl
          CLOSE i201_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i201_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i201_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i201_fetch('/')
       END IF
    END IF	
    CLOSE i201_cl
    COMMIT WORK
END FUNCTION	
		
FUNCTION i201_list_fill()
   LET g_sql = "SELECT hree05,hral02,hree01,hrai04,hree02,hrdk03,hree03,aag02,hree04",
               "  FROM hree_file LEFT OUTER JOIN hrai_file ON hrai03=hree01",
               "                 LEFT OUTER JOIN hrdk_file ON hrdk01=hree02",
               "                 LEFT OUTER JOIN hral_file ON hral01=hree05",
               "                 LEFT OUTER JOIN aag_file ON aag00='00' AND aag01=hree03",
               " ORDER BY hree01,hree02,hree03"
   PREPARE i201_get_hree_p FROM g_sql
   DECLARE i201_get_hree_c CURSOR FOR i201_get_hree_p
   CALL g_hreea.clear()
   LET g_cnt = 1

   FOREACH i201_get_hree_c INTO g_hreea[g_cnt].*
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
   CALL g_hreea.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hreea TO s_hree.* ATTRIBUTE(COUNT=g_rec_b)
         
      ON ACTION EXIT 
         EXIT PROGRAM 
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION MAIN
         CALL i201_show()
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION 
