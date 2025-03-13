# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri048.4gl
# Descriptions...: 
# Date & Author..: 03/21/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_hrch_h,g_hrch_h_t RECORD 
        hrch01   LIKE hrch_file.hrch01,    
        hraa12   LIKE hraa_file.hraa12,    
        hrch02   LIKE hrch_file.hrch02,    
        hrchoriu LIKE hrch_file.hrchoriu,  
        hrchuser LIKE hrch_file.hrchuser,  
        hrchmodu LIKE hrch_file.hrchmodu,  
        hrchorig LIKE hrch_file.hrchorig,  
        hrchgrup LIKE hrch_file.hrchgrup,  
        hrchdate LIKE hrch_file.hrchdate
            END RECORD
DEFINE 
     g_hrch           DYNAMIC ARRAY OF RECORD    
        hrch03  LIKE hrch_file.hrch03,
        hrat02  LIKE hrat_file.hrat02,
        hrat04  LIKE hrat_file.hrat04,
        hrao02  LIKE hrao_file.hrao02,
        hrat05  LIKE hrat_file.hrat05,
        hras04  LIKE hras_file.hras04,
        hrch08  LIKE hrch_file.hrch08,
        hrch15  LIKE hrch_file.hrch15,
        hrch17  LIKE hrch_file.hrch17,
        hrch13  LIKE hrch_file.hrch13,
        hrch14  LIKE hrch_file.hrch14,
        hrch04  LIKE hrch_file.hrch04,
        hrch06  LIKE hrch_file.hrch06,
        hrch07  LIKE hrch_file.hrch07,
        hrch09  LIKE hrch_file.hrch09,
        hrch20  LIKE hrch_file.hrch20,
        hrch10  LIKE hrch_file.hrch10,
        hrch21  LIKE hrch_file.hrch21,
        hrch11  LIKE hrch_file.hrch11,
        hrch22  LIKE hrch_file.hrch22,
        hrch12  LIKE hrch_file.hrch12,
        hrch18  LIKE hrch_file.hrch18
          
                    END RECORD,
    g_hrch_t         RECORD                 
        hrch03  LIKE hrch_file.hrch03,
        hrat02  LIKE hrat_file.hrat02,
        hrat04  LIKE hrat_file.hrat04,
        hrao02  LIKE hrao_file.hrao02,
        hrat05  LIKE hrat_file.hrat05,
        hras04  LIKE hras_file.hras04,
        hrch08  LIKE hrch_file.hrch08,
        hrch15  LIKE hrch_file.hrch15,
        hrch17  LIKE hrch_file.hrch17,
        hrch13  LIKE hrch_file.hrch13,
        hrch14  LIKE hrch_file.hrch14,
        hrch04  LIKE hrch_file.hrch04,
        hrch06  LIKE hrch_file.hrch06,
        hrch07  LIKE hrch_file.hrch07,
        hrch09  LIKE hrch_file.hrch09,
        hrch20  LIKE hrch_file.hrch20,
        hrch10  LIKE hrch_file.hrch10,
        hrch21  LIKE hrch_file.hrch21,
        hrch11  LIKE hrch_file.hrch11,
        hrch22  LIKE hrch_file.hrch22,
        hrch12  LIKE hrch_file.hrch12,
        hrch18  LIKE hrch_file.hrch18
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 
 
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5      
DEFINE g_str        STRING 
DEFINE g_msg        LIKE type_file.chr1000
DEFINE g_argv1      LIKE hrch_file.hrch01
DEFINE g_argv2      LIKE hrch_file.hrch02
DEFINE g_argv3      LIKE hrch_file.hrch03


MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
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
    
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    
     
    
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)
    LET g_argv2=ARG_VAL(3)
   
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i048_w AT p_row,p_col WITH FORM "ghr/42f/ghri048"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    LET g_forupd_sql =" SELECT hrch01 FROM hrch_file ",
                      "  WHERE hrch01 = ? AND hrch02 = ? ",
                      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i048_lock_u CURSOR FROM g_forupd_sql
    
    LET g_action_choice=""
    LET g_hrch_h.hrch01=''
    LET g_hrch_h.hrch02='' 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2=" hrch01='",g_argv1,"' AND hrch02 = ",g_argv2," AND hrch03 = ",g_argv3
       CALL i048_q()
    END IF

    CALL i048_menu()

    CLOSE WINDOW i048_w                 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i048_menu()
 
   WHILE TRUE
      CALL i048_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i048_q()
            END IF
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i048_a()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "i048_import"
            IF cl_chk_act_auth() THEN
                 CALL i048_import()
            END IF             
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i048_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "ghri048_a"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_hrch_h.hrch01) AND NOT cl_null(g_hrch_h.hrch02) THEN 
                  CALL i048_gen()
               END IF
            END IF
              
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document"
            IF cl_chk_act_auth() AND l_ac != 0 THEN
               IF g_hrch_h.hrch01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrch01"
                  LET g_doc.value1 = g_hrch_h.hrch01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrch),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i048_q()
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  
   CALL g_hrch.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i048_b_askkey()
   IF INT_FLAG THEN                            
      LET INT_FLAG = 0
      RETURN
   END IF

   #LET g_sql=" SELECT DISTINCT hrch01,hrch02 FROM hrch_file ",#mark by zhangbo130910
   LET g_sql=" SELECT DISTINCT hrch01,hrch02 FROM hrch_file,hrat_file ",    #add by zhangbo130910
              "  WHERE ",g_wc2 CLIPPED,
              "    AND hrch03=hratid ",                                     #add by zhangbo130910
              "  ORDER BY hrch01,hrch02"
    PREPARE i048_prepare FROM g_sql
    DECLARE i048_curs
      SCROLL CURSOR WITH HOLD FOR i048_prepare

    #LET g_sql=" SELECT COUNT(DISTINCT hrch01||hrch02) FROM hrch_file ",    #mark by zhangbo130910
    LET g_sql=" SELECT COUNT(DISTINCT hrch01||hrch02) FROM hrch_file,hrat_file ",  #add by zhangbo130910
              "  WHERE ",g_wc2 CLIPPED,
              "    AND hrch03=hratid "                                             #add by zhangbo130910
    PREPARE i048_count_prepare FROM g_sql
    DECLARE i048_count CURSOR FOR i048_count_prepare

    OPEN i048_count
    FETCH i048_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt 
    OPEN i048_curs
    IF SQLCA.SQLCODE THEN                         
       CALL cl_err('',SQLCA.SQLCODE,0)
       INITIALIZE g_hrch_h.hrch01 TO NULL                 
    ELSE
       CALL i048_fetch('F')                 
    END IF
    
END FUNCTION 
 
FUNCTION i048_fetch(p_flag)                  
DEFINE   p_flag   LIKE type_file.chr1,         
         l_abso   LIKE type_file.num10         

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i048_curs INTO g_hrch_h.hrch01,g_hrch_h.hrch02
      WHEN 'P' FETCH PREVIOUS i048_curs INTO g_hrch_h.hrch01,g_hrch_h.hrch02
      WHEN 'F' FETCH FIRST    i048_curs INTO g_hrch_h.hrch01,g_hrch_h.hrch02
      WHEN 'L' FETCH LAST     i048_curs INTO g_hrch_h.hrch01,g_hrch_h.hrch02
      WHEN '/'
         IF (NOT g_no_ask) THEN          
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlp
                   CALL cl_cmdask()

                ON ACTION help
                   CALL cl_show_help()

                ON ACTION about
                   CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i048_curs INTO g_hrch_h.hrch01,g_hrch_h.hrch02
         LET g_no_ask = FALSE    
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrch_h.hrch01,SQLCA.sqlcode,0)
      INITIALIZE g_hrch_h.hrch01 TO NULL  
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          
      END CASE
        
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
   END IF
   CALL i048_show()
END FUNCTION
 
FUNCTION i048_b_askkey()
  DEFINE l_wc            STRING  #160818 add by zhangtn
  
    CLEAR FORM
    CALL g_hrch.clear()
    IF cl_null(g_argv1) THEN
       INITIALIZE g_hrch_h.* TO NULL
      CONSTRUCT g_wc2 ON hrch01,hrch02,hrchoriu,hrchorig,hrchuser,hrchgrup,hrchmodu,
                         hrchdate,hrch03,hrat02,hrat04,hrat05,hrch08,hrch15,hrch17,
                         hrch13,hrch14,hrch04,hrch06,hrch07,hrch09,hrch20,hrch10,hrch21,hrch11,hrch22,hrch12,hrch18                     
           FROM hrch01,hrch02,hrchoriu,hrchorig,hrchuser,hrchgrup,hrchmodu,hrchdate,                               
                s_hrch[1].hrch03,s_hrch[1].hrat02,s_hrch[1].hrat04,s_hrch[1].hrat05,
                s_hrch[1].hrch08,s_hrch[1].hrch15,s_hrch[1].hrch17,s_hrch[1].hrch13,
                s_hrch[1].hrch14,s_hrch[1].hrch04,s_hrch[1].hrch06,s_hrch[1].hrch07,
                s_hrch[1].hrch09,s_hrch[1].hrch20,s_hrch[1].hrch10,s_hrch[1].hrch21,
                s_hrch[1].hrch11,s_hrch[1].hrch22,s_hrch[1].hrch12,s_hrch[1].hrch18
                
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
    
        ON ACTION CONTROLP
           CASE 
              WHEN INFIELD(hrch01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrch01
                 NEXT FIELD hrch01 
              WHEN INFIELD(hrch03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrch03
                 NEXT FIELD hrch03
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat05
                 NEXT FIELD hrat05            
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
    END IF  
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrchuser', 'hrchgrup')
    LET g_wc2 = cl_replace_str(g_wc2,'hrch03','hrat01')
#    CALL cl_get_hrzxa(g_user) RETURNING l_wc #160818 add by zhangtn
#    LET g_wc2 = g_wc2 CLIPPED," AND ",l_wc CLIPPED #160818 add by zhangtn 
    
    IF INT_FLAG THEN RETURN END IF
                
END FUNCTION  
 
FUNCTION i048_b_fill(p_wc2)              
 
    DEFINE p_wc2           STRING
       
    LET g_sql = "SELECT hrat01,hrat02,hrat04,'',hrat05,'',hrch08,hrch15,hrch17,hrch13,hrch14,hrch04,",
                "       hrch06,hrch07,hrch09,hrch20,hrch10,hrch21,hrch11,hrch22,hrch12,hrch18",
                "  FROM hrch_file,hrat_file",
                " WHERE ", p_wc2 CLIPPED,
                "   AND hrch01='",g_hrch_h.hrch01,"'", 
                "   AND hrch02=",g_hrch_h.hrch02,
                "   AND hrch03 = hratid ",
                " ORDER BY hrat01" 
    
    PREPARE i048_pb FROM g_sql
    DECLARE hrch_curs CURSOR FOR i048_pb
 
    CALL g_hrch.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrch_curs INTO g_hrch[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF    
        SELECT hrao02 INTO g_hrch[g_cnt].hrao02 FROM hrao_file WHERE hrao01 = g_hrch[g_cnt].hrat04        
       # SELECT hrap06 INTO g_hrch[g_cnt].hras04 FROM hrap_file WHERE hrap05 = g_hrch[g_cnt].hrat05 AND hrap01 = g_hrch[g_cnt].hrat04        
        select hras04 into g_hrch[g_cnt].hras04 FROM hras_file where hras01=g_hrch[g_cnt].hrat05
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrch.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION


FUNCTION i048_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrch TO s_hrch.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
     
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY    
         
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DISPLAY    

      ON ACTION ghri048_a
         LET g_action_choice = "ghri048_a"
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION first                            
         CALL i048_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
           ACCEPT DISPLAY                   

      ON ACTION previous                         
         CALL i048_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                   

      ON ACTION jump                             
         CALL i048_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                   

      ON ACTION next                             
         CALL i048_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                   

      ON ACTION last                             
         CALL i048_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION i048_import
         LET g_action_choice = 'i048_import'
         EXIT DISPLAY 
      ON ACTION about                     
         CALL cl_about()                  
   
      ON ACTION related_document   
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel    
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
  
      AFTER DISPLAY
         CONTINUE DISPLAY  
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION   
 
FUNCTION i048_show()            
  SELECT DISTINCT hrch01,hraa12,hrch02,hrchoriu,hrchorig,hrchuser,hrchgrup,hrchmodu,hrchdate 
    INTO g_hrch_h.hrch01,g_hrch_h.hraa12,g_hrch_h.hrch02,g_hrch_h.hrchoriu,g_hrch_h.hrchuser,g_hrch_h.hrchmodu,g_hrch_h.hrchorig,g_hrch_h.hrchgrup,g_hrch_h.hrchdate
    FROM hrch_file LEFT JOIN hraa_file ON (hraa01 = hrch01) 
   WHERE hrch01=g_hrch_h.hrch01
     AND hrch02=g_hrch_h.hrch02             
   DISPLAY g_hrch_h.hrch01,g_hrch_h.hraa12,g_hrch_h.hrch02,g_hrch_h.hrchoriu,g_hrch_h.hrchuser,g_hrch_h.hrchmodu,g_hrch_h.hrchorig,g_hrch_h.hrchgrup,g_hrch_h.hrchdate
        TO hrch01,hraa12,hrch02,hrchoriu,hrchorig,hrchuser,hrchgrup,hrchmodu,hrchdate
   CALL i048_b_fill(g_wc2)                    
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i048_a()
DEFINE l_n    LIKE   type_file.num5                            
   MESSAGE ""
   CALL g_hrch.clear()
   INITIALIZE g_hrch_h.hrch01 TO NULL
   INITIALIZE g_hrch_h.hrch02 TO NULL
   LET g_hrch_h.hrchoriu = g_user
   LET g_hrch_h.hrchorig = g_grup
   LET g_hrch_h.hrchuser = g_user
   LET g_hrch_h.hrchgrup = g_grup
   LET g_hrch_h.hrchdate = g_today
   CLEAR FORM
   CALL cl_opmsg('a')
   

   WHILE TRUE                     
      CALL i048_i("a")                       

      IF INT_FLAG THEN                            
         INITIALIZE g_hrch_h.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      ELSE 
         LET g_rec_b=0
         LET l_n=0
         SELECT COUNT(*) INTO l_n FROM hrch_file WHERE hrch01=g_hrch_h.hrch01
         IF l_n>0 THEN
            CALL i048_b_fill(" 1=1")
         ELSE
            CALL g_hrch.clear()
         END IF    
         #CALL i048_b()    
      END IF
      LET g_hrch_h_t.*=g_hrch_h.* 
      EXIT WHILE
   END WHILE
           
END FUNCTION 
 
FUNCTION i048_i(p_cmd)                       
   DEFINE   p_cmd        LIKE type_file.chr1    
   DEFINE   l_count      LIKE type_file.num5  
   DEFINE   l_str        STRING 
   DEFINE   l_n,l_i      LIKE type_file.num5
   DEFINE   l_check      STRING
   DEFINE   l_date       LIKE type_file.chr10 

   DISPLAY g_hrch_h.hrch01,g_hrch_h.hrch02 TO hrch01,hrch02   
   CALL cl_set_head_visible("","YES")   
   INPUT g_hrch_h.hrch01,g_hrch_h.hrch02 WITHOUT DEFAULTS FROM hrch01,hrch02 
   
      AFTER FIELD hrch01
          IF NOT cl_null(g_hrch_h.hrch01) THEN
            LET l_count = 0
             SELECT count(*) INTO l_count FROM hraa_file WHERE hraa01 = g_hrch_h.hrch01 AND hraaacti = 'Y'
             IF l_count = 0 OR cl_null(l_count) THEN
                CALL cl_err(g_hrch_h.hrch01,'ghr-001',0)
                LET g_hrch_h.hraa12= ''
                NEXT FIELD hrch03
             END IF
             SELECT hraa12 INTO g_hrch_h.hraa12 FROM hraa_file WHERE hraa01 = g_hrch_h.hrch01
             DISPLAY BY NAME g_hrch_h.hraa12
          END IF
           
      AFTER INPUT 
         IF INT_FLAG THEN
            RETURN
         END IF
         IF g_hrch_h.hrch01 IS NULL THEN
            NEXT FIELD hrch01
         END IF
                
      ON ACTION controlp
         CASE
             WHEN INFIELD(hrch01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hraa01"
             LET g_qryparam.default1 = g_hrch_h.hrch01
             CALL cl_create_qry() RETURNING g_hrch_h.hrch01
             DISPLAY g_hrch_h.hrch01 TO hrch01
             NEXT FIELD hrch01
         END CASE 
             
      ON ACTION controlf                  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

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
END FUNCTION   

 
FUNCTION i048_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1  
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrat01,hrat02,hrat04,'',hrat05,'',hrch08,hrch15,hrch17,hrch13,hrch14,hrch04,hrch06,hrch07,hrch09,hrch20,hrch10,hrch21,hrch11,hrch22,hrch12,hrch18",
                       "  FROM hrat_file,hrch_file WHERE hrch01=? AND hrch02=? AND hratid = hrch03 AND hrat01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i048_bcl CURSOR FROM g_forupd_sql      
      
    INPUT ARRAY g_hrch WITHOUT DEFAULTS FROM s_hrch.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF  
     
    BEFORE ROW
       LET p_cmd='' 
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'            
       LET l_n  = ARR_COUNT()
 
       IF g_rec_b>=l_ac THEN
          BEGIN WORK
          LET p_cmd='u'                       
          LET g_hrch_t.* = g_hrch[l_ac].*   
          OPEN i048_bcl USING g_hrch_h.hrch01,g_hrch_h.hrch02,g_hrch_t.hrch03
          IF STATUS THEN
             CALL cl_err("OPEN i048_bcl:", STATUS, 1)
             LET l_lock_sw = "Y"
          ELSE 
             FETCH i048_bcl INTO g_hrch[l_ac].* 
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_hrch_t.hrch03,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
          END IF
          SELECT hrao02 INTO g_hrch[l_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrch[l_ac].hrat04        
          SELECT hrap06 INTO g_hrch[l_ac].hras04 FROM hrap_file WHERE hrap05 = g_hrch[l_ac].hrat05 AND hrap01 = g_hrch[l_ac].hrat04
          DISPLAY BY NAME g_hrch[l_ac].hrao02,g_hrch[l_ac].hras04
          CALL cl_show_fld_cont()      
       END IF  
         
               
     
       ON CHANGE hrch11                        
        IF NOT cl_null(g_hrch[l_ac].hrch11) THEN
           LET g_hrch[l_ac].hrch12 = g_hrch[l_ac].hrch09 + g_hrch[l_ac].hrch10 + g_hrch[l_ac].hrch11 
           LET g_hrch[l_ac].hrch15 = g_hrch[l_ac].hrch04 + g_hrch[l_ac].hrch12
           SELECT g_hrch[l_ac].hrch15 - hrch16 INTO g_hrch[l_ac].hrch17 FROM hrch_file,hrat_file
            WHERE hrch01 = g_hrch_h.hrch01
              AND hrch02 = g_hrch_h.hrch02
              AND hrch03 = hratid
              AND hrat01 = g_hrch[l_ac].hrch03
        ELSE
           LET g_hrch[l_ac].hrch12 = g_hrch[l_ac].hrch09 + g_hrch[l_ac].hrch10
           LET g_hrch[l_ac].hrch15 = g_hrch[l_ac].hrch04 + g_hrch[l_ac].hrch12
           SELECT g_hrch[l_ac].hrch15 - hrch16 INTO g_hrch[l_ac].hrch17 FROM hrch_file,hrat_file
            WHERE hrch01 = g_hrch_h.hrch01
              AND hrch02 = g_hrch_h.hrch02
              AND hrch03 = hratid
              AND hrat01 = g_hrch[l_ac].hrch03
        END IF 
        DISPLAY BY NAME g_hrch[l_ac].hrch12,g_hrch[l_ac].hrch15,g_hrch[l_ac].hrch17
 
     ON ROW CHANGE
        IF INT_FLAG THEN             
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_hrch[l_ac].* = g_hrch_t.*
           CLOSE i048_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_hrch[l_ac].hrch03,-263,0)
           LET g_hrch[l_ac].* = g_hrch_t.*
        ELSE
          
           UPDATE hrch_file SET hrch11=g_hrch[l_ac].hrch11,
                                hrch12=g_hrch[l_ac].hrch12,
                                hrch15=g_hrch[l_ac].hrch15,
                                hrch17=g_hrch[l_ac].hrch17,
                                hrch18=g_hrch[l_ac].hrch18,
                                hrchmodu=g_user,
                                hrchdate=g_today 
                          WHERE hrch01 = g_hrch_h.hrch01
                            AND hrch02 = g_hrch_h.hrch02
                            AND hrch03 = (SELECT hratid FROM hrat_file WHERE hrat01 = g_hrch_t.hrch03)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","hrch_file",g_hrch_h.hrch01,g_hrch_t.hrch03,SQLCA.sqlcode,"","",1)
              ROLLBACK WORK    
              LET g_hrch[l_ac].* = g_hrch_t.*
           END IF
        END IF   
      
                  
      AFTER ROW
         LET l_ac = ARR_CURR()            
         LET l_ac_t = l_ac                
      
         IF INT_FLAG THEN                 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrch[l_ac].* = g_hrch_t.*
            END IF
            CLOSE i048_bcl                
            ROLLBACK WORK                 
            EXIT INPUT
         END IF
         CLOSE i048_bcl                
         COMMIT WORK      
       
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
    
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
      
    CLOSE i048_bcl
    COMMIT WORK
    CALL i048_b_fill(" 1=1")
END FUNCTION 
 
FUNCTION i048_gen()
DEFINE l_sql       STRING
DEFINE l_hrcf      RECORD LIKE hrcf_file.*
DEFINE l_hrcf02    STRING
DEFINE l_hratid    LIKE hrat_file.hratid
DEFINE l_hrat01    LIKE hrat_file.hrat01
DEFINE l_hrat02    LIKE hrat_file.hrat02
DEFINE l_hrat25    LIKE hrat_file.hrat25
DEFINE l_hrch13    LIKE hrch_file.hrch13
DEFINE l_hrat39    LIKE hrat_file.hrat39
DEFINE l_hrch19    LIKE hrch_file.hrch19
DEFINE l_hrch20    LIKE hrch_file.hrch20
DEFINE l_hrch21    LIKE hrch_file.hrch21
DEFINE l_hrch      RECORD LIKE hrch_file.*
DEFINE l_hrch_t    RECORD LIKE hrch_file.*
DEFINE l_hrch19_t  LIKE hrch_file.hrch19
DEFINE l_id        LIKE hrch_file.hrch19
DEFINE l_area      LIKE type_file.num5
DEFINE l_hrcg03_b  LIKE hrcg_file.hrcg03
DEFINE l_hrcg03_a  LIKE hrcg_file.hrcg03

DEFINE l_hrat      RECORD LIKE hrat_file.*
DEFINE l_hrat04_t  LIKE hrat_file.hrat04
DEFINE l_date      LIKE type_file.dat
DEFINE l_count     LIKE type_file.num5
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_minus1    LIKE type_file.num5
DEFINE l_minus2    LIKE type_file.num5
DEFINE l_minus3    LIKE type_file.num5
DEFINE l_flag1     LIKE type_file.chr1
DEFINE l_flag2     LIKE type_file.chr1
DEFINE l_flag3     LIKE type_file.chr1
DEFINE l_year      LIKE type_file.num5
DEFINE l_month     LIKE type_file.num5
DEFINE l_day       LIKE type_file.num5
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_hrch09    LIKE type_file.num15_3
DEFINE l_hrch10    LIKE type_file.num15_3
DEFINE l_hrch09_t  LIKE hrch_file.hrch09
DEFINE l_hrch10_t  LIKE hrch_file.hrch10
DEFINE l_today     LIKE type_file.dat
DEFINE l_a         LIKE type_file.num5
DEFINE l_flag4     LIKE type_file.num5

# add by yinbq 20140426  begin
   SELECT MAX(hrch19)+1 INTO l_id FROM hrch_file
   if cl_null(l_id) then let l_id=1 end if 
   SELECT COUNT(*) INTO l_a FROM hrat_file WHERE YEAR(hrat25) < g_hrch_h.hrch02 AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=g_hrch_h.hrch02 
#add by yinbq 20150104 for 暂时移除公司条件过滤(圣奥个案，全集团使用统一的参数）
#   	AND hrat03=g_hrch_h.hrch01
#add by yinbq 20150104 for 暂时移除公司条件过滤(圣奥个案，全集团使用统一的参数）
#   CALL cl_progress_bar(l_a)
#add by yinbq 20150104 for 暂时移除公司条件过滤(圣奥个案，全集团使用统一的参数）
#   LET l_sql = "select * from hrcf_file where hrcf01='0000' ORDER BY hrcf02 DESC"
   LET l_sql = "select * from hrcf_file where hrcf01='",g_hrch_h.hrch01,"' ORDER BY hrcf02 DESC"
#add by yinbq 20150104 for 暂时移除公司条件过滤(圣奥个案，全集团使用统一的参数）
   LET l_hrcf02="' '"
   PREPARE get_hrcf FROM l_sql
   DECLARE get_hrcf_c CURSOR FOR get_hrcf
   FOREACH get_hrcf_c INTO l_hrcf.*
      IF NOT cl_null(l_hrcf.hrcf02) OR l_hrcf.hrcf02 <> ' ' THEN 
         #优先处理特定部门的年假
         LET l_hrcf02 = l_hrcf02 , ",'",l_hrcf.hrcf02,"'"
         IF (cl_null(l_hrcf.hrcf04) OR l_hrcf.hrcf04='N') AND (cl_null(l_hrcf.hrcf05) OR l_hrcf.hrcf05='N') THEN 
            CASE l_hrcf.hrcf03 #工龄起算日期等员工信息的取值
               WHEN '001'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrat25,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                       " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
               WHEN '002'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrat26,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                       " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
               WHEN '003'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrat38,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                       " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
               WHEN '004'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrbf08,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN (SELECT hrbf02 , min(hrbf08) hrbf08 FROM hrbf_file WHERE hrbfacti = 'Y' GROUP BY hrbf02 ) thrbf ON thrbf.hrbf02=hratid",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                       " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
               WHEN '005'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrat36,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                       " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
            END CASE
         ELSE 
            IF l_hrcf.hrcf04='Y' THEN
               CASE l_hrcf.hrcf03 #工龄起算日期等员工信息的取值
                  WHEN '001'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrat25)-",l_hrcf.hrcf06,"),1,last_day(hrat25)+1,-1,TRUNC(hrat25)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
                  WHEN '002'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrat26)-",l_hrcf.hrcf06,"),1,last_day(hrat26)+1,-1,TRUNC(hrat26)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
                  WHEN '003'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrat38)-",l_hrcf.hrcf06,"),1,last_day(hrat38)+1,-1,TRUNC(hrat38)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
                  WHEN '004'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrbf08)-",l_hrcf.hrcf06,"),1,last_day(hrbf08)+1,-1,TRUNC(hrbf08)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN (SELECT hrbf02 , min(hrbf08) hrbf08 FROM hrbf_file WHERE hrbfacti = 'Y' GROUP BY hrbf02 ) thrbf ON thrbf.hrbf02=hratid",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
                  WHEN '005'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrat36)-",l_hrcf.hrcf06,"),1,last_day(hrat36)+1,-1,TRUNC(hrat36)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
               END CASE
            END IF 
            IF l_hrcf.hrcf05='Y' THEN 
               CASE l_hrcf.hrcf03 #工龄起算日期等员工信息的取值
                  WHEN '001'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrat25)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
                  WHEN '002'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrat26)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
                  WHEN '003'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrat38)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
                  WHEN '004'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrbf08)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN (SELECT hrbf02 , min(hrbf08) hrbf08 FROM hrbf_file WHERE hrbfacti = 'Y' GROUP BY hrbf02 ) thrbf ON thrbf.hrbf02=hratid",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
                  WHEN '005'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrat36)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,"",
                                          " AND hrat03='",g_hrch_h.hrch01,"' AND hrat04='",l_hrcf.hrcf02,"'"
               END CASE
            END IF 
         END IF 
         PREPARE get_emp FROM l_sql
         DECLARE get_emp_c CURSOR FOR get_emp
         FOREACH get_emp_c INTO l_hratid,l_hrat01,l_hrat02,l_hrat25,l_hrch13,l_hrat39,l_hrch19,l_hrch20,l_hrch21
            #CALL cl_progressing(l_hrat01||'  '||l_hrat02||'  ')
            INITIALIZE l_hrch.* TO NULL
            LET l_hrch.hrch01=g_hrch_h.hrch01
            LET l_hrch.hrch02=g_hrch_h.hrch02
            LET l_hrch.hrch03=l_hratid
            LET l_hrch.hrch04=0
            IF l_hrcf.hrcf27='Y' THEN
               #未休法定年假结转本年
               LET l_hrch.hrch04=l_hrch.hrch04+l_hrch20
            END IF 
            IF l_hrcf.hrcf28='Y' THEN
               #未休福利年假结转本年
               LET l_hrch.hrch04=l_hrch.hrch04+l_hrch21
            END IF 
            IF NOT cl_null(l_hrcf.hrcf29) THEN
               #结转周期
               CASE l_hrcf.hrcf03
                  WHEN '001' SELECT to_date(g_hrch_h.hrch02||'0131','yyyymmdd') INTO l_hrch.hrch07 FROM dual
                  WHEN '002' SELECT to_date(g_hrch_h.hrch02||'0301','yyyymmdd')-1 INTO l_hrch.hrch07 FROM dual
                  WHEN '003' SELECT to_date(g_hrch_h.hrch02||'0331','yyyymmdd') INTO l_hrch.hrch07 FROM dual
                  WHEN '004' SELECT to_date(g_hrch_h.hrch02||'0630','yyyymmdd') INTO l_hrch.hrch07 FROM dual
                  WHEN '005' SELECT to_date(g_hrch_h.hrch02||'1231','yyyymmdd') INTO l_hrch.hrch07 FROM dual
               END CASE 
            END IF 
            #工龄计算
            IF YEAR(l_hrch13)>=g_hrch_h.hrch02 THEN 
               #员工工龄起算年与当年年度相同
               LET l_hrch.hrch08=0
            ELSE 
               IF YEAR(l_hrch13) = g_hrch_h.hrch02 - 1 THEN 
                  #员工工龄起算年与当年年度相差一年
                  LET l_hrch.hrch08=1
               ELSE  
                  #员工工龄起算年与当年年度相差数年
                  LET l_hrch.hrch08=g_hrch_h.hrch02-YEAR(l_hrch13)
               END IF 
            END IF 
            IF l_hrcf.hrcf07='Y' THEN #工龄要求累加承认工龄
               LET l_hrch.hrch08 = l_hrch.hrch08 + l_hrat39
            END IF 
#add by yinbq 20150104 for 圣奥个案，年假天数设置只存在集团公司信息，去除公司过滤条件
#            SELECT nvl(hrcg03,0)/l_hrcf.hrcf19,nvl(hrcg04,0)/l_hrcf.hrcf19 INTO l_hrch.hrch09,l_hrch.hrch10 FROM hrcg_file WHERE hrcg01 = l_hrch.hrch01 AND hrcg02 = l_hrch.hrch08
            SELECT nvl(hrcg03,0)/l_hrcf.hrcf19,nvl(hrcg04,0)/l_hrcf.hrcf19 INTO l_hrch.hrch09,l_hrch.hrch10 FROM hrcg_file WHERE hrcg02 = l_hrch.hrch08
#add by yinbq 20150104 for 圣奥个案，年假天数设置只存在集团公司信息，去除公司过滤条件
            IF SQLCA.sqlcode THEN
               CALL cl_err("当前计算公司没有工龄年假天数设置",'!',1)
               ROLLBACK WORK
               RETURN 
            END IF 
            IF YEAR(l_hrat25) = g_hrch_h.hrch02 - 1 THEN 
               #处理首次获得年假的折算逻辑
               IF l_hrcf.hrcf16='Y' THEN #法定年假的折算
                  IF l_hrcf.hrcf18='001' THEN #按天折算
                     SELECT to_date(g_hrch_h.hrch02||'0101','yyyymmdd') - l_hrch13 INTO l_area FROM dual 
                     CASE l_hrcf.hrcf20 
                        WHEN '001' SELECT l_area*l_hrch.hrch09/365 INTO l_hrch.hrch09 FROM dual
                        WHEN '002' SELECT ROUND(l_area*l_hrch.hrch09/365) INTO l_hrch.hrch09 FROM dual
                        WHEN '003' SELECT Floor(l_area*l_hrch.hrch09/365) INTO l_hrch.hrch09 FROM dual
                        WHEN '004' SELECT CEIL(l_area*l_hrch.hrch09/365) INTO l_hrch.hrch09 FROM dual
                     END CASE 
                  ELSE IF l_hrcf.hrcf18='002' THEN #按月折算
                        SELECT MONTHS_BETWEEN(to_date(g_hrch_h.hrch02||'0101','yyyymmdd') , l_hrch13) INTO l_area FROM dual 
                        CASE l_hrcf.hrcf20 
                           WHEN '001' SELECT l_area*l_hrch.hrch09/12 INTO l_hrch.hrch09 FROM dual
                           WHEN '002' SELECT ROUND(l_area*l_hrch.hrch09/12) INTO l_hrch.hrch09 FROM dual
                           WHEN '003' SELECT Floor(l_area*l_hrch.hrch09/12) INTO l_hrch.hrch09 FROM dual
                           WHEN '004' SELECT CEIL(l_area*l_hrch.hrch09/12) INTO l_hrch.hrch09 FROM dual
                        END CASE 
                     END IF 
                  END IF 
               END IF 
               IF l_hrcf.hrcf21='N' THEN #法定年假的折算
                  IF l_hrcf.hrcf18='001' THEN #按天折算
                     SELECT to_date(g_hrch_h.hrch02||'0101','yyyymmdd') - l_hrch13 INTO l_area FROM dual 
                     CASE l_hrcf.hrcf20 
                        WHEN '001' SELECT l_area*l_hrch.hrch10/365 INTO l_hrch.hrch10 FROM dual
                        WHEN '002' SELECT ROUND(l_area*l_hrch.hrch10/365) INTO l_hrch.hrch10 FROM dual
                        WHEN '003' SELECT Floor(l_area*l_hrch.hrch10/365) INTO l_hrch.hrch10 FROM dual
                        WHEN '004' SELECT CEIL(l_area*l_hrch.hrch10/365) INTO l_hrch.hrch10 FROM dual
                     END CASE 
                  ELSE IF l_hrcf.hrcf18='002' THEN #按月折算
                        SELECT MONTHS_BETWEEN(to_date(g_hrch_h.hrch02||'0101','yyyymmdd') , l_hrch13) INTO l_area FROM dual 
                        CASE l_hrcf.hrcf20 
                           WHEN '001' SELECT l_area*l_hrch.hrch10/12 INTO l_hrch.hrch10 FROM dual
                           WHEN '002' SELECT ROUND(l_area*l_hrch.hrch10/12) INTO l_hrch.hrch10 FROM dual
                           WHEN '003' SELECT Floor(l_area*l_hrch.hrch10/12) INTO l_hrch.hrch10 FROM dual
                           WHEN '004' SELECT CEIL(l_area*l_hrch.hrch10/12) INTO l_hrch.hrch10 FROM dual
                        END CASE 
                     END IF 
                  END IF 
               END IF 
            ELSE 
               IF YEAR(l_hrat25) < g_hrch_h.hrch02 - 1 AND  l_hrcf.hrcf17='Y' THEN 
                  #员工入司超过一年，即不再是第一次获得年假  并且  年假天数变更时折算逻辑
                  SELECT a.hrcg03,b.hrcg03,INTO l_hrcg03_b,l_hrcg03_a FROM hrcg_file a
                     LEFT JOIN hrcg_file b ON b.hrcg01=a.hrcg01 AND b.hrcg02=a.hrcg02+1
                     WHERE a.hrcg03<>b.hrcg03 AND b.hrcg02=l_hrch.hrch08
                  IF SQLCA.SQLCODE = 0 THEN #如果当年年假天数与上一年相比有发生变化
                     IF l_hrcf.hrcf18='001' THEN #按天折算
                        SELECT to_date(g_hrch_h.hrch02||'0101','yyyymmdd') - l_hrch13 INTO l_area FROM dual 
                        CASE l_hrcf.hrcf20 
                           WHEN '001' SELECT (l_area*l_hrch.hrch09+l_hrcg03_b*(365-l_area))/365 INTO l_hrch.hrch09 FROM dual
                           WHEN '002' SELECT ROUND((l_area*l_hrch.hrch09+l_hrcg03_b*(365-l_area))/365) INTO l_hrch.hrch09 FROM dual
                           WHEN '003' SELECT Floor((l_area*l_hrch.hrch09+l_hrcg03_b*(365-l_area))/365) INTO l_hrch.hrch09 FROM dual
                           WHEN '004' SELECT CEIL((l_area*l_hrch.hrch09+l_hrcg03_b*(365-l_area))/365) INTO l_hrch.hrch09 FROM dual
                        END CASE 
                     ELSE IF l_hrcf.hrcf18='002' THEN #按月折算
                           SELECT MONTHS_BETWEEN(to_date(g_hrch_h.hrch02||'0101','yyyymmdd') , l_hrch13) INTO l_area FROM dual 
                           CASE l_hrcf.hrcf20 
                              WHEN '001' SELECT (l_area*l_hrch.hrch09+l_hrcg03_b*(12-l_area))/12 INTO l_hrch.hrch09 FROM dual
                              WHEN '002' SELECT ROUND((l_area*l_hrch.hrch09+l_hrcg03_b*(12-l_area))/12) INTO l_hrch.hrch09 FROM dual
                              WHEN '003' SELECT Floor((l_area*l_hrch.hrch09+l_hrcg03_b*(12-l_area))/12) INTO l_hrch.hrch09 FROM dual
                              WHEN '004' SELECT CEIL((l_area*l_hrch.hrch09+l_hrcg03_b*(12-l_area))/12) INTO l_hrch.hrch09 FROM dual
                           END CASE
                        END IF  
                     END IF 
                  END IF 
               END IF 
            END IF 
            
           
            IF l_hrcf.hrcf25='Y' OR YEAR(l_hrch13) = g_hrch_h.hrch02 - 1 THEN  #第一年生效日期为入司日期
               SELECT to_date(g_hrch_h.hrch02||to_char(l_hrch13,'mmdd'),'yyyymmdd') INTO l_hrch.hrch13 FROM dual
            ELSE
               SELECT to_date(g_hrch_h.hrch02||'0101','yyyymmdd') INTO l_hrch.hrch13 FROM dual
            END IF
            SELECT to_date(g_hrch_h.hrch02||'1231','yyyymmdd') INTO l_hrch.hrch14 FROM dual
            IF  cl_null(l_hrch.hrch09) THEN LET l_hrch.hrch09 = 0 END IF
            IF NOT cl_null(l_hrch19) AND l_hrch19>0 THEN 
               #已计算过年假
               SELECT * INTO l_hrch_t.* FROM hrch_file WHERE hrch19=l_hrch19  
               LET l_hrch.hrchmodu = g_user
               LET l_hrch.hrchdate = g_today
               UPDATE hrch_file SET 
                  hrch01=l_hrch.hrch01,
                  hrch02=l_hrch.hrch02,
                  hrch03=l_hrch.hrch03,
                  hrch04=l_hrch.hrch04,
                  hrch06=l_hrch.hrch04-l_hrch_t.hrch05,
                  hrch07=l_hrch.hrch07,
                  hrch08=l_hrch.hrch08,
                  hrch09=l_hrch.hrch09,
                  hrch10=l_hrch.hrch10,
                  hrch12=l_hrch.hrch09+l_hrch.hrch10+l_hrch_t.hrch11,
                  hrch13=l_hrch.hrch13,
                  hrch15=l_hrch.hrch04+l_hrch.hrch09+l_hrch.hrch10+l_hrch_t.hrch11,
                  hrch17=l_hrch.hrch04+l_hrch.hrch09+l_hrch.hrch10+l_hrch_t.hrch11-l_hrch_t.hrch16,
                  hrch20=l_hrch.hrch09-l_hrch_t.hrch09+l_hrch_t.hrch20,
                  hrch21=l_hrch.hrch10-l_hrch_t.hrch10+l_hrch_t.hrch21,
                  hrch22=l_hrch.hrch11-l_hrch_t.hrch11+l_hrch_t.hrch22,
                  hrchmodu=l_hrch.hrchmodu,
                  hrchdate=l_hrch.hrchdate
               WHERE hrch19=l_hrch19
               IF SQLCA.sqlcode THEN
                  CALL cl_err("更新年假计划失败",'!',1)
                  ROLLBACK WORK
                  RETURN 
               END IF
            ELSE
               LET l_hrch.hrch19=l_id
               LET l_hrch.hrch05=0
               LET l_hrch.hrch06=l_hrch.hrch04
               LET l_hrch.hrch11=0
               LET l_hrch.hrch12=l_hrch.hrch09+l_hrch.hrch10
               LET l_hrch.hrch15=l_hrch.hrch12+l_hrch.hrch04
               LET l_hrch.hrch16=0
               LET l_hrch.hrch17=l_hrch.hrch15
               LET l_hrch.hrch18=" "
               LET l_hrch.hrch20=l_hrch.hrch09
               LET l_hrch.hrch21=l_hrch.hrch10
               LET l_hrch.hrch22=l_hrch.hrch11
               LET l_hrch.hrchuser = g_user
               LET l_hrch.hrchoriu = g_user
               LET l_hrch.hrchorig = g_grup 
               LET l_hrch.hrchgrup = g_grup    
               LET l_hrch.hrchmodu = g_user
               LET l_hrch.hrchdate = g_today
               INSERT INTO hrch_file VALUES (l_hrch.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err("添加年假计划失败",'!',1)
                  ROLLBACK WORK
                  RETURN 
               END IF
               LET l_id=l_id+1 
            END IF 
         END FOREACH 
      ELSE 
         IF (cl_null(l_hrcf.hrcf04) OR l_hrcf.hrcf04='N') AND (cl_null(l_hrcf.hrcf05) OR l_hrcf.hrcf05='N') THEN 
            IF l_hrcf02 = "' '" THEN 
               LET l_hrcf02=''
            ELSE
               LET l_hrcf02="AND NOT EXISTS(SELECT 1 FROM hrao_file WHERE hrao01=hrat04 AND hrao01 IN (",l_hrcf02,")"
            END IF 
            CASE l_hrcf.hrcf03 #工龄起算日期等员工信息的取值
               WHEN '001'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrat25,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
               WHEN '002'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrat26,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
               WHEN '003'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrat38,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE hrat39>0 or (YEAR(hrat38) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
               WHEN '004'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrbf08,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN (SELECT hrbf02 , min(hrbf08) hrbf08 FROM hrbf_file WHERE hrbfacti = 'Y' GROUP BY hrbf02 ) thrbf ON thrbf.hrbf02=hratid",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
               WHEN '005'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,hrat36,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                       " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                       " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                       " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
            END CASE
         ELSE 
            IF l_hrcf.hrcf04='Y' THEN
               CASE l_hrcf.hrcf03 #工龄起算日期等员工信息的取值
                  WHEN '001'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrat25)-",l_hrcf.hrcf06,"),1,last_day(hrat25)+1,-1,TRUNC(hrat25)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                  WHEN '002'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrat26)-",l_hrcf.hrcf06,"),1,last_day(hrat26)+1,-1,TRUNC(hrat26)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                  WHEN '003'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrat38)-",l_hrcf.hrcf06,"),1,last_day(hrat38)+1,-1,TRUNC(hrat38)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE hrat39>0 or (YEAR(hrat38) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                  WHEN '004'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrbf08)-",l_hrcf.hrcf06,"),1,last_day(hrbf08)+1,-1,TRUNC(hrbf08)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN (SELECT hrbf02 , min(hrbf08) hrbf08 FROM hrbf_file WHERE hrbfacti = 'Y' GROUP BY hrbf02 ) thrbf ON thrbf.hrbf02=hratid",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                  WHEN '005'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,DECODE(SIGN(DAY(hrat36)-",l_hrcf.hrcf06,"),1,last_day(hrat36)+1,-1,TRUNC(hrat36)),NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                          " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                          " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                          " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
               END CASE
            ELSE 
               IF l_hrcf.hrcf05='Y' THEN 
                  CASE l_hrcf.hrcf03 #工龄起算日期等员工信息的取值
                     WHEN '001'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrat25)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                             " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                             " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                             " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                     WHEN '002'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrat26)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                             " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                             " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                             " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                     WHEN '003'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrat38)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                             " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                             " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                             " WHERE hrat39>0 or (YEAR(hrat38) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                     WHEN '004'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrbf08)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                             " LEFT JOIN (SELECT hrbf02 , min(hrbf08) hrbf08 FROM hrbf_file WHERE hrbfacti = 'Y' GROUP BY hrbf02 ) thrbf ON thrbf.hrbf02=hratid",
                                             " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                             " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                             " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                     WHEN '005'  LET l_sql = "SELECT hratid,hrat01,hrat02,hrat25,last_day(hrat36)+1,NVL(hrat39,0),NVL(t.hrch19,0),NVL(y.hrch20,0),NVL(y.hrch21,0) FROM hrat_file ",
                                             " LEFT JOIN hrch_file t ON t.hrch01='",g_hrch_h.hrch01,"' AND t.hrch02=",g_hrch_h.hrch02," AND t.hrch03=hratid",
                                             " LEFT JOIN hrch_file y ON y.hrch01='",g_hrch_h.hrch01,"' AND y.hrch02=",g_hrch_h.hrch02,"-1 AND y.hrch03=hratid",
                                             " WHERE hrat39>0 or (YEAR(hrat25) < ",g_hrch_h.hrch02," AND YEAR(NVL(hrat77,to_date('20991231','yyyymmdd')))>=",g_hrch_h.hrch02,")"
                                       #,""," AND hrat03='",g_hrch_h.hrch01,"'"
                  END CASE
               END IF 
            END IF 
         END IF 
         PREPARE get_emp1 FROM l_sql
         DECLARE get_emp_c1 CURSOR FOR get_emp1
         FOREACH get_emp_c1 INTO l_hratid,l_hrat01,l_hrat02,l_hrat25,l_hrch13,l_hrat39,l_hrch19,l_hrch20,l_hrch21
#            CALL cl_progressing(l_hrat01||'  '||l_hrat02||'  ')
            INITIALIZE l_hrch.* TO NULL
            LET l_hrch.hrch01=g_hrch_h.hrch01
            LET l_hrch.hrch02=g_hrch_h.hrch02
            LET l_hrch.hrch03=l_hratid
            LET l_hrch.hrch04=0
            IF l_hrcf.hrcf27='Y' THEN
               #未休法定年假结转本年
               LET l_hrch.hrch04=l_hrch.hrch04+l_hrch20
            END IF 
            IF l_hrcf.hrcf28='Y' THEN
               #未休福利年假结转本年
               LET l_hrch.hrch04=l_hrch.hrch04+l_hrch21
            END IF 
            IF NOT cl_null(l_hrcf.hrcf29) THEN
               #结转周期
               CASE l_hrcf.hrcf03
                  WHEN '001' SELECT to_date(g_hrch_h.hrch02||'0131','yyyymmdd') INTO l_hrch.hrch07 FROM dual
                  WHEN '002' SELECT to_date(g_hrch_h.hrch02||'0301','yyyymmdd')-1 INTO l_hrch.hrch07 FROM dual
                  WHEN '003' SELECT to_date(g_hrch_h.hrch02||'0331','yyyymmdd') INTO l_hrch.hrch07 FROM dual
                  WHEN '004' SELECT to_date(g_hrch_h.hrch02||'0630','yyyymmdd') INTO l_hrch.hrch07 FROM dual
                  WHEN '005' SELECT to_date(g_hrch_h.hrch02||'1231','yyyymmdd') INTO l_hrch.hrch07 FROM dual
               END CASE 
            END IF 
            #工龄计算
            IF YEAR(l_hrch13)>=g_hrch_h.hrch02 THEN 
               #员工工龄起算年与当年年度相同
               LET l_hrch.hrch08=0
            ELSE 
               IF YEAR(l_hrch13) = g_hrch_h.hrch02 - 1 THEN 
                  #员工工龄起算年与当年年度相差一年
                  LET l_hrch.hrch08=1
               ELSE
                  #员工工龄起算年与当年年度相差数年
                  LET l_hrch.hrch08=g_hrch_h.hrch02-YEAR(l_hrch13)
               END IF 
            END IF 
            IF l_hrcf.hrcf07='Y' THEN #工龄要求累加承认工龄
               LET l_hrch.hrch08 = l_hrch.hrch08 + l_hrat39
            END IF 
#add by yinbq 20150104 for 圣奥个案，年假天数设置只存在集团公司信息，去除公司过滤条件
#            SELECT nvl(hrcg03,0)/l_hrcf.hrcf19,nvl(hrcg04,0)/l_hrcf.hrcf19 INTO l_hrch.hrch09,l_hrch.hrch10 FROM hrcg_file WHERE hrcg01 = l_hrch.hrch01 AND hrcg02 = l_hrch.hrch08
            SELECT nvl(hrcg03,0)/l_hrcf.hrcf19,nvl(hrcg04,0)/l_hrcf.hrcf19 INTO l_hrch.hrch09,l_hrch.hrch10 FROM hrcg_file WHERE hrcg02 = l_hrch.hrch08
#add by yinbq 20150104 for 圣奥个案，年假天数设置只存在集团公司信息，去除公司过滤条件
            IF SQLCA.sqlcode THEN
               CALL cl_err("当前计算公司没有工龄年假天数设置",'!',1)
               ROLLBACK WORK
               RETURN 
            END IF 
            #IF YEAR(l_hrat25) = g_hrch_h.hrch02 - 1 THEN 
            IF YEAR(l_hrch13) = g_hrch_h.hrch02 - 1 THEN 
               #处理首次获得年假的折算逻辑
               IF l_hrcf.hrcf16='Y' THEN #法定年假的折算
                  IF l_hrcf.hrcf18='001' THEN #按天折算
                     SELECT to_date(YEAR(l_hrch13)||'1231','yyyymmdd') - l_hrch13 INTO l_area FROM dual 
                     CASE l_hrcf.hrcf20 
                        WHEN '001' SELECT l_area*l_hrch.hrch09/365 INTO l_hrch.hrch09 FROM dual
                        WHEN '002' SELECT ROUND(l_area*l_hrch.hrch09/365) INTO l_hrch.hrch09 FROM dual
                        WHEN '003' SELECT Floor(l_area*l_hrch.hrch09/365) INTO l_hrch.hrch09 FROM dual
                        WHEN '004' SELECT CEIL(l_area*l_hrch.hrch09/365) INTO l_hrch.hrch09 FROM dual
                     END CASE 
                  ELSE 
                     IF l_hrcf.hrcf18='002' THEN #按月折算
                        SELECT MONTHS_BETWEEN(to_date(g_hrch_h.hrch02||'0101','yyyymmdd') , l_hrch13) INTO l_area FROM dual 
                        CASE l_hrcf.hrcf20 
                           WHEN '001' SELECT l_area*l_hrch.hrch09/12 INTO l_hrch.hrch09 FROM dual
                           WHEN '002' SELECT ROUND(l_area*l_hrch.hrch09/12) INTO l_hrch.hrch09 FROM dual
                           WHEN '003' SELECT Floor(l_area*l_hrch.hrch09/12) INTO l_hrch.hrch09 FROM dual
                           WHEN '004' SELECT CEIL(l_area*l_hrch.hrch09/12) INTO l_hrch.hrch09 FROM dual
                        END CASE 
                     END IF 
                  END IF 
               END IF 
               IF l_hrcf.hrcf21='N' THEN #福利年假的折算
                  IF l_hrcf.hrcf18='001' THEN #按天折算
                     SELECT to_date(g_hrch_h.hrch02||'0101','yyyymmdd') - l_hrch13 INTO l_area FROM dual 
                     CASE l_hrcf.hrcf20 
                        WHEN '001' SELECT l_area*l_hrch.hrch10/365 INTO l_hrch.hrch10 FROM dual
                        WHEN '002' SELECT ROUND(l_area*l_hrch.hrch10/365) INTO l_hrch.hrch10 FROM dual
                        WHEN '003' SELECT Floor(l_area*l_hrch.hrch10/365) INTO l_hrch.hrch10 FROM dual
                        WHEN '004' SELECT CEIL(l_area*l_hrch.hrch10/365) INTO l_hrch.hrch10 FROM dual
                     END CASE 
                  ELSE IF l_hrcf.hrcf18='002' THEN #按月折算
                        SELECT MONTHS_BETWEEN(to_date(g_hrch_h.hrch02||'0101','yyyymmdd') , l_hrch13) INTO l_area FROM dual 
                        CASE l_hrcf.hrcf20 
                           WHEN '001' SELECT l_area*l_hrch.hrch10/12 INTO l_hrch.hrch10 FROM dual
                           WHEN '002' SELECT ROUND(l_area*l_hrch.hrch10/12) INTO l_hrch.hrch10 FROM dual
                           WHEN '003' SELECT Floor(l_area*l_hrch.hrch10/12) INTO l_hrch.hrch10 FROM dual
                           WHEN '004' SELECT CEIL(l_area*l_hrch.hrch10/12) INTO l_hrch.hrch10 FROM dual
                        END CASE 
                     END IF 
                  END IF 
               END IF 
            ELSE 
               IF YEAR(l_hrch13) < g_hrch_h.hrch02 - 1 AND  l_hrcf.hrcf17='Y' THEN 
                  #员工入司超过一年，即不再是第一次获得年假  并且  年假天数变更时折算逻辑
                  SELECT a.hrcg03,b.hrcg03 INTO l_hrcg03_b,l_hrcg03_a FROM hrcg_file a
                     LEFT JOIN hrcg_file b ON b.hrcg01=a.hrcg01 AND b.hrcg02=a.hrcg02+1
                     WHERE a.hrcg03<>b.hrcg03 AND b.hrcg02=l_hrch.hrch08
                  IF SQLCA.SQLCODE = 0 THEN #如果当年年假天数与上一年相比有发生变化
                     IF l_hrcf.hrcf18='001' THEN #按天折算
                        SELECT to_date(YEAR(l_hrch13)||'1231','yyyymmdd') - l_hrch13 INTO l_area FROM dual 
                        CASE l_hrcf.hrcf20 
                           WHEN '001' SELECT (l_area*l_hrch.hrch09+l_hrcg03_b*(365-l_area))/365 INTO l_hrch.hrch09 FROM dual
                           WHEN '002' SELECT ROUND((l_area*l_hrch.hrch09+l_hrcg03_b*(365-l_area))/365) INTO l_hrch.hrch09 FROM dual
                           WHEN '003' SELECT Floor((l_area*l_hrch.hrch09+l_hrcg03_b*(365-l_area))/365) INTO l_hrch.hrch09 FROM dual
                           WHEN '004' SELECT CEIL((l_area*l_hrch.hrch09+l_hrcg03_b*(365-l_area))/365) INTO l_hrch.hrch09 FROM dual
                        END CASE 
                     ELSE 
                        IF l_hrcf.hrcf18='002' THEN #按月折算
                           SELECT MONTHS_BETWEEN(to_date(g_hrch_h.hrch02||'0101','yyyymmdd') , l_hrch13) INTO l_area FROM dual 
                           CASE l_hrcf.hrcf20 
                              WHEN '001' SELECT (l_area*l_hrch.hrch09+l_hrcg03_b*(12-l_area))/12 INTO l_hrch.hrch09 FROM dual
                              WHEN '002' SELECT ROUND((l_area*l_hrch.hrch09+l_hrcg03_b*(12-l_area))/12) INTO l_hrch.hrch09 FROM dual
                              WHEN '003' SELECT Floor((l_area*l_hrch.hrch09+l_hrcg03_b*(12-l_area))/12) INTO l_hrch.hrch09 FROM dual
                              WHEN '004' SELECT CEIL((l_area*l_hrch.hrch09+l_hrcg03_b*(12-l_area))/12) INTO l_hrch.hrch09 FROM dual
                           END CASE 
                        END IF 
                     END IF 
                  END IF 
               END IF 
            END IF 
            IF l_hrcf.hrcf25='Y' OR YEAR(l_hrch13) = g_hrch_h.hrch02 - 1 THEN  #第一年生效日期为入司日期
               SELECT to_date(g_hrch_h.hrch02||to_char(l_hrch13,'mmdd'),'yyyymmdd') INTO l_hrch.hrch13 FROM dual
            ELSE
               SELECT to_date(g_hrch_h.hrch02||'0101','yyyymmdd') INTO l_hrch.hrch13 FROM dual
            END IF
            SELECT to_date(g_hrch_h.hrch02||'1231','yyyymmdd') INTO l_hrch.hrch14 FROM dual
            IF  cl_null(l_hrch.hrch09) THEN LET l_hrch.hrch09 = 0 END IF
            SELECT COUNT(*) INTO l_flag FROM hrch_file WHERE hrch01=l_hrch.hrch01 AND hrch02=l_hrch.hrch02 AND hrch03=l_hrch.hrch03
            IF NOT cl_null(l_flag) AND l_flag>0 THEN 
            #IF NOT cl_null(l_hrch.hrch09) AND l_hrch.hrch09>0 THEN 
               #已计算过年假
               SELECT * INTO l_hrch_t.* FROM hrch_file WHERE hrch19=l_hrch19  
               LET l_hrch.hrchmodu = g_user
               LET l_hrch.hrchdate = g_today
               UPDATE hrch_file SET 
                  hrch01=l_hrch.hrch01,
                  hrch02=l_hrch.hrch02,
                  hrch03=l_hrch.hrch03,
                  hrch04=l_hrch.hrch04,
                  hrch06=l_hrch.hrch04-l_hrch_t.hrch05,
                  hrch07=l_hrch.hrch07,
                  hrch08=l_hrch.hrch08,
                  hrch09=l_hrch.hrch09,
                  hrch10=l_hrch.hrch10,
                  hrch12=l_hrch.hrch09+l_hrch.hrch10+l_hrch_t.hrch11,
                  hrch13=l_hrch.hrch13,
                  hrch15=l_hrch.hrch04+l_hrch.hrch09+l_hrch.hrch10+l_hrch_t.hrch11,
                  hrch17=l_hrch.hrch04+l_hrch.hrch09+l_hrch.hrch10+l_hrch_t.hrch11-l_hrch_t.hrch16,
                  hrch20=l_hrch.hrch09-l_hrch_t.hrch09+l_hrch_t.hrch20,
                  hrch21=l_hrch.hrch10-l_hrch_t.hrch10+l_hrch_t.hrch21,
                  hrch22=l_hrch.hrch11-l_hrch_t.hrch11+l_hrch_t.hrch22,
                  hrchmodu=l_hrch.hrchmodu,
                  hrchdate=l_hrch.hrchdate
               WHERE hrch19=l_hrch19
               IF SQLCA.sqlcode THEN
                  CALL cl_err("更新年假计划失败",'!',1)
                  ROLLBACK WORK
                  RETURN 
               END IF
            ELSE
               LET l_hrch.hrch19=l_id
               LET l_hrch.hrch05=0
               LET l_hrch.hrch06=l_hrch.hrch04
               LET l_hrch.hrch11=0
               LET l_hrch.hrch12=l_hrch.hrch09+l_hrch.hrch10
               LET l_hrch.hrch15=l_hrch.hrch12+l_hrch.hrch04
               LET l_hrch.hrch16=0
               LET l_hrch.hrch17=l_hrch.hrch15
               LET l_hrch.hrch18=" "
               LET l_hrch.hrch20=l_hrch.hrch09
               LET l_hrch.hrch21=l_hrch.hrch10
               LET l_hrch.hrch22=l_hrch.hrch11
               LET l_hrch.hrchuser = g_user
               LET l_hrch.hrchoriu = g_user
               LET l_hrch.hrchorig = g_grup 
               LET l_hrch.hrchgrup = g_grup    
               LET l_hrch.hrchmodu = g_user
               LET l_hrch.hrchdate = g_today
               INSERT INTO hrch_file VALUES (l_hrch.*)
               IF SQLCA.sqlcode THEN
                  CALL cl_err("添加年假计划失败",'!',1)
                  ROLLBACK WORK
                  RETURN 
               END IF
               LET l_id=l_id+1 
            END IF 
         END FOREACH 
      END IF 
   END FOREACH
   CALL cl_err("年假数据产生完成",'!',1)
   CALL i048_show()
# add by yinbq 20140426  end
END FUNCTION 
FUNCTION i048_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD
         hrch01  LIKE hrch_file.hrch01,
         hrch02  LIKE hrch_file.hrch02,
         hrch03  LIKE hrch_file.hrch03,
         hrch04  LIKE hrch_file.hrch04,
         hrch05  LIKE hrch_file.hrch05,
         hrch06  LIKE hrch_file.hrch06,
         hrch07  LIKE hrch_file.hrch07,
         hrch18  LIKE hrch_file.hrch18
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
   CALL s_showmsg_init()

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
                    
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrch01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hrch02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrch03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrch04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrch06])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrch07])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrch18])
                IF NOT cl_null(sr.hrch01) AND NOT cl_null(sr.hrch02) AND NOT cl_null(sr.hrch03) AND NOT cl_null(sr.hrch04) AND  NOT cl_null(sr.hrch06)
                	  THEN
                	 IF i > 1 THEN

                     SELECT hratid INTO sr.hrch03  FROM hrat_file WHERE hrat01=sr.hrch03
                      LET sr.hrch05=0
                    SELECT COUNT(*) INTO l_flag FROM hrch_file WHERE hrch01=sr.hrch01 AND hrch02=sr.hrch02 AND hrch03=sr.hrch03  
                    IF l_flag>0 THEN 
                       UPDATE hrch_file SET hrch04=sr.hrch04,hrch05=sr.hrch05,hrch06=sr.hrch06,hrch07=sr.hrch07,hrch18=sr.hrch18
                       WHERE hrch01=sr.hrch01 AND hrch02=sr.hrch02 AND hrch03=sr.hrch03  
                       UPDATE hrch_file SET hrch15=nvl(hrch04,0) + nvl(hrch09,0) +nvl(hrch11,0) + nvl(hrch10,0) ,hrch17=nvl(hrch06,0) + nvl(hrch20,0) +nvl(hrch21,0) + nvl(hrch22,0)
                       WHERE hrch01=sr.hrch01 AND hrch02=sr.hrch02 AND hrch03=sr.hrch03  
                       UPDATE hrch_file SET hrch16 = hrch15 - hrch17
                       WHERE hrch01=sr.hrch01 AND hrch02=sr.hrch02 AND hrch03=sr.hrch03                         
#                    INSERT INTO hrch_file(hrch01,hrch02,hrch03,hrch04,hrch05,hrch07,hrch08,hrch09,hrch10,hrch11,hrchconf,hrchacti,hrchuser,hrchgrup,hrchdate,hrchorig,hrchoriu)
#                      VALUES (sr.hrch01,sr.hrch02,sr.hrch03,sr.hrch04,sr.hrch05,sr.hrch07,sr.hrch08,sr.hrch09,sr.hrch10,sr.hrch11,sr.hrchconf,'Y',g_user,g_grup,g_today,g_grup,g_user)
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("ins","hrch_file",sr.hrch01,'',SQLCA.sqlcode,"","",1)
                       LET g_success  = 'N'
                       CONTINUE FOR
                    END IF
                  ELSE CALL cl_err( '该员工年假未计算','!', 1 )
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

#       SELECT * INTO g_hrch.* FROM hrch_file
#       WHERE hrch01=sr.hrch01
#       CALL i048_show()
   END IF

END FUNCTION

