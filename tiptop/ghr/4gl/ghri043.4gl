# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri043.4gl
# Descriptions...: 
# Date & Author..: 05/07/13 by zhangbo

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrcc         RECORD LIKE hrcc_file.*    
DEFINE g_hrcc_t       RECORD LIKE hrcc_file.*             
DEFINE g_sql         STRING,                      
       g_wc          STRING,                     
       g_wc2         STRING
DEFINE g_hrcd        DYNAMIC ARRAY OF RECORD
           hrcd02    LIKE hrcc_file.hrcc04,
           hrcd03    LIKE type_file.chr5,
           hrcd04    LIKE hrcc_file.hrcc04,
           hrcd05    LIKE type_file.chr5,
           hrbm05    LIKE hrbm_file.hrbm05,
           hrbm06    LIKE hrbm_file.hrbm06,
           hrcd12    LIKE type_file.chr300
                     END RECORD,
       g_rec_b      LIKE type_file.num5,
       l_ac         LIKE type_file.num5
DEFINE g_hrcc_1      DYNAMIC ARRAY OF RECORD
           hrcc01_1  LIKE hrcc_file.hrcc01,
           hrcc02_1  LIKE hrcc_file.hrcc02,
           hrcc07_1  LIKE hrcc_file.hrcc07,
           hrat02_1  LIKE hrat_file.hrat02,
           hrao02_1  LIKE hrao_file.hrao02,
           hras04_1  LIKE hras_file.hras04,
           hrcc04_1  LIKE hrcc_file.hrcc04,
           hrcc05_1  LIKE hrcc_file.hrcc05,
           hrcc03_1  LIKE hrcc_file.hrcc03,
           hrcc08_1  LIKE hrcc_file.hrcc08,
           hrcc09_1  LIKE hrcc_file.hrcc09,
           hrcc10_1  LIKE hrcc_file.hrcc10,
           hrcc06_1  LIKE hrcc_file.hrcc06,
           hrcc11_1  LIKE hrcc_file.hrcc11
                     END RECORD,
       g_rec_b1      LIKE type_file.num5,
       l_ac1         LIKE type_file.num5                         
DEFINE g_hrcc_lock   RECORD LIKE hrcc_file.*             
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
DEFINE g_generate          LIKE type_file.chr1

MAIN
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
 
   OPEN WINDOW i043_w WITH FORM "ghr/42f/ghri043"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_label_justify("i043_w","right")
      
   CALL cl_set_combo_items("hrcc10",NULL,NULL)
   CALL cl_set_combo_items("dw_yx",NULL,NULL)
   CALL cl_set_combo_items("dw_wx",NULL,NULL)
   CALL cl_set_combo_items("hrbm06",NULL,NULL)
   CALL cl_set_combo_items("hrcc10_1",NULL,NULL)
   CALL i043_get_items() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrcc10",l_name,l_items)
   CALL cl_set_combo_items("dw_yx",l_name,l_items)
   CALL cl_set_combo_items("dw_wx",l_name,l_items)
   CALL cl_set_combo_items("hrbm06",l_name,l_items)
   CALL cl_set_combo_items("hrcc10_1",l_name,l_items)  
      
   LET g_forupd_sql =" SELECT * FROM hrcc_file ",
                      "  WHERE hrcc01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i043_cl CURSOR FROM g_forupd_sql
      
   CALL cl_ui_init() 
   
   CALL i043_menu()
   CLOSE WINDOW i043_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i043_get_items()
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='504'",
                 "  ORDER BY hrag06"
       PREPARE i043_get_items_pre FROM l_sql
       DECLARE i043_get_items CURSOR FOR i043_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i043_get_items INTO l_hrag06,l_hrag07
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

FUNCTION i043_curs()
  IF gs_wc IS NULL THEN
    CLEAR FORM
    INITIALIZE g_hrcc.* TO NULL
    CONSTRUCT BY NAME g_wc ON                              
        hrcc02,hrcc03,hrcc04,hrcc05,hrcc06,
        hrcc07,hrcc08,hrcc09,hrcc10,hrcc11

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrcc02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrcc.hrcc02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcc02
                 NEXT FIELD hrcc02
                 
              WHEN INFIELD(hrcc07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrcc.hrcc07
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcc07
                 NEXT FIELD hrcc03
                 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrccuser', 'hrccgrup')
    CALL cl_replace_str(g_wc,'hrcc07','hrat01') RETURNING g_wc
 ELSE
    LET g_wc=gs_wc
 END IF
    LET g_sql = "SELECT DISTINCT hrcc01 FROM hrcc_file,hrat_file ",                       #
                " WHERE ",g_wc CLIPPED, 
                "   AND hratid=hrcc07 ",
                " ORDER BY hrcc01"
    PREPARE i043_prepare FROM g_sql
    DECLARE i043_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i043_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrcc01) FROM hrcc_file,hrat_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND hratid=hrcc07 "
    PREPARE i043_precount FROM g_sql
    DECLARE i043_count CURSOR FOR i043_precount
END FUNCTION
 
FUNCTION i043_menu()
   WHILE TRUE
      CALL i043_bp("G")
      
      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN 
         SELECT hrcc_file.*
           INTO g_hrcc.*
           FROM hrcc_file
          WHERE hrcc01=g_hrcc_1[l_ac1].hrcc01_1
      END IF

      IF g_action_choice != "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i043_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
      END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i043_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET gs_wc=NULL
               CALL i043_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i043_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i043_u('u')
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i043_copy()
            END IF
         
         WHEN "ghri043_a"
            IF cl_chk_act_auth() THEN
               CALL i043_gen()
               CALL i043_show()
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
 
FUNCTION i043_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1    

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
   
   DISPLAY ARRAY g_hrcd TO s_hrcd.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
         
      ON ACTION ghri043_a
         LET g_action_choice="ghri043_a"
         EXIT DIALOG   
         
      ON ACTION first
         CALL i043_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION previous
         CALL i043_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG  
      ON ACTION jump
         CALL i043_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION next
         CALL i043_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION last
         CALL i043_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG

       ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about         
         CALL cl_about()     
      AFTER DISPLAY
         CONTINUE DIALOG
      #&include "qry_string.4gl" 
   END DISPLAY
   
   DISPLAY ARRAY g_hrcc_1 TO s_hrcc_1.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         CALL i043_hrcd_fill(g_hrcc_1[l_ac1].hrcc01_1) 
         
       ON ACTION main
         LET g_bp_flag = 'Page1'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL i043_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DIALOG
      
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i043_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DIALOG
              
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG

      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
      
      ON ACTION ghri043_a
         LET g_action_choice="ghri043_a"
         EXIT DIALOG   
         
      ON ACTION first
         CALL i043_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION previous
         CALL i043_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG  
      ON ACTION jump
         CALL i043_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION next
         CALL i043_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      ON ACTION last
         CALL i043_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
      
       ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
         
      ON ACTION cancel
         LET INT_FLAG=FALSE      
         LET g_action_choice="exit"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about         
         CALL cl_about()     
      AFTER DISPLAY
         CONTINUE DIALOG
      #&include "qry_string.4gl" 
   END DISPLAY
   
   END DIALOG
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i043_a()
DEFINE l_hratid   LIKE   hrat_file.hratid
DEFINE l_hrcc RECORD LIKE hrcc_file.* 

    CLEAR FORM                                   #
    INITIALIZE g_hrcc.* LIKE hrcc_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrcc.hrccuser = g_user
        LET g_hrcc.hrccoriu = g_user
        LET g_hrcc.hrccorig = g_grup
        LET g_hrcc.hrccgrup = g_grup               #
        LET g_hrcc.hrccdate = g_today
        LET g_hrcc.hrcc04 = g_today
        #LET g_hrcc.hrcc10='001'
        SELECT to_date('9999/12/31','yyyy/mm/dd') 
          INTO g_hrcc.hrcc05
          FROM DUAL  
        LET g_hrcc.hrcc06 = 'N'
        LET g_hrcc.hrcc08 = 0
        CALL i043_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrcc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrcc.hrcc02 IS NULL THEN              #
            CONTINUE WHILE
        END IF
         
        SELECT MAX(hrcc01)+1 INTO g_hrcc.hrcc01
         FROM hrcc_file WHERE 1=1
        IF g_hrcc.hrcc01 IS NULL OR g_hrcc.hrcc01=0 THEN
          LET g_hrcc.hrcc01=1
        END IF
        LET l_hrcc.* = g_hrcc.* 
        SELECT hratid INTO l_hrcc.hrcc07 FROM hrat_file
         WHERE hrat01=g_hrcc.hrcc07    
        INSERT INTO hrcc_file VALUES(l_hrcc.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcc_file",g_hrcc.hrcc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrcc01 INTO g_hrcc.hrcc01 FROM hrcc_file WHERE hrcc01 = g_hrcc.hrcc01
            #CALL i043_b_fill(g_wc)
        END IF
        EXIT WHILE
    END WHILE
     
END FUNCTION
 
FUNCTION i043_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hrbm05      LIKE hrbm_file.hrbm05
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hrao02      LIKE hrao_file.hrao02
   DEFINE l_hras04      LIKE hras_file.hras04
   DEFINE l_hrbm04      LIKE hrbm_file.hrbm04
   DEFINE l_dwyx,l_dwwx LIKE hrcc_file.hrcc10

   
   DISPLAY BY NAME
      g_hrcc.hrcc02,g_hrcc.hrcc03,g_hrcc.hrcc04,
      g_hrcc.hrcc05,g_hrcc.hrcc06,g_hrcc.hrcc07,g_hrcc.hrcc08,
      g_hrcc.hrcc09,g_hrcc.hrcc10,g_hrcc.hrcc11

   INPUT BY NAME
      g_hrcc.hrcc02,g_hrcc.hrcc03,g_hrcc.hrcc07,
      g_hrcc.hrcc04,g_hrcc.hrcc05,g_hrcc.hrcc08,g_hrcc.hrcc09,
      g_hrcc.hrcc06,g_hrcc.hrcc10,g_hrcc.hrcc11
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i043_set_entry(p_cmd)
          CALL i043_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          
      
      AFTER FIELD hrcc02
         IF NOT cl_null(g_hrcc.hrcc02) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrbm_file WHERE hrbm03=g_hrcc.hrcc02
                                                      AND hrbm02='010'
                                                      
            IF l_n=0 THEN
              CALL cl_err('无此特殊假项目','!',0)
              NEXT FIELD hrcc02
            END IF
            
            IF g_hrcc.hrcc02 != g_hrcc_t.hrcc02 
              OR g_hrcc_t.hrcc02 IS NULL THEN                                          
               IF NOT cl_null(g_hrcc.hrcc04) 
                 AND NOT cl_null(g_hrcc.hrcc07) THEN
                 SELECT COUNT(*) INTO l_n FROM hrcc_file,hrat_file
                 WHERE hrcc02=g_hrcc.hrcc02
                   AND hrcc04=g_hrcc.hrcc04
                   AND hratid=hrcc07
                   AND hrat01=g_hrcc.hrcc07
                IF l_n>0 THEN
                  CALL cl_err(g_hrcc.hrcc02,-239,0)
                  NEXT FIELD hrcc02
                END IF
              END IF
            END IF 
             
            SELECT hrbm06,hrbm04 INTO g_hrcc.hrcc10,l_hrbm04 
              FROM hrbm_file
             WHERE hrbm03=g_hrcc.hrcc02
            LET l_dwyx=g_hrcc.hrcc10
            LET l_dwwx=g_hrcc.hrcc10 
            DISPLAY BY NAME g_hrcc.hrcc10
            DISPLAY l_hrbm04 TO hrbm04
            DISPLAY l_dwyx TO dw_yx
            DISPLAY l_dwwx TO dw_wx
                         
         END IF 
                      
      AFTER FIELD hrcc03
         IF NOT cl_null(g_hrcc.hrcc03) THEN
            IF NOT cl_null(g_hrcc.hrcc02) THEN
              LET l_hrbm05=0
              LET l_n=0
              SELECT hrbm05 INTO l_hrbm05 FROM hrbm_file
               WHERE hrbm03=g_hrcc.hrcc02
              LET l_n = g_hrcc.hrcc03 mod l_hrbm05
              IF l_n !=0 THEN
                 CALL cl_err('累计给休必须是核算量的倍数','!',0)
                 NEXT FIELD hrcc03
              END IF
            END IF
            LET g_hrcc.hrcc09=g_hrcc.hrcc03-g_hrcc.hrcc08
            IF g_hrcc.hrcc09<0 THEN
              CALL cl_err('累计给休减去已休不可小于0','!',0)
                         NEXT FIELD hrcc03
                  END IF
            DISPLAY BY NAME g_hrcc.hrcc09                                                           
         END IF                 
                                                                                              
      AFTER FIELD hrcc04
         IF g_hrcc.hrcc04 IS NOT NULL THEN
            IF g_hrcc.hrcc05 IS NOT NULL THEN
              IF g_hrcc.hrcc04>g_hrcc.hrcc05 THEN
                 CALL cl_err('开始日期不能大于结束日期','!',0)
                 NEXT FIELD hrcc04
              END IF
            END IF
            IF g_hrcc.hrcc04 != g_hrcc_t.hrcc04 
              OR g_hrcc_t.hrcc04 IS NULL THEN                                          
               IF NOT cl_null(g_hrcc.hrcc02) 
                 AND NOT cl_null(g_hrcc.hrcc07) THEN
                 SELECT COUNT(*) INTO l_n FROM hrcc_file,hrat_file
                 WHERE hrcc02=g_hrcc.hrcc02
                   AND hratid=hrcc07
                   AND hrcc04=g_hrcc.hrcc04
                   AND hrat01=g_hrcc.hrcc07
                IF l_n>0 THEN
                  CALL cl_err(g_hrcc.hrcc04,-239,0)
                  NEXT FIELD hrcc04
                END IF
              END IF
            END IF  
                     
         END IF
          
      AFTER FIELD hrcc05
         IF NOT cl_null(g_hrcc.hrcc05) THEN
            IF NOT cl_null(g_hrcc.hrcc04) THEN
              IF g_hrcc.hrcc05<g_hrcc.hrcc04 THEN
                 CALL cl_err('开始日期不能大于结束日期','!',0)
                 NEXT FIELD hrcc05
              END IF
            END IF       
         END IF        
          
      AFTER FIELD hrcc07
         IF NOT cl_null(g_hrcc.hrcc07) THEN
            
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrat_file 
             WHERE hrat01=g_hrcc.hrcc07
            IF l_n=0 THEN
              CALL cl_err('无此员工编号','!',0)
              NEXT FIELD hrcc07
            END IF
            
            IF g_hrcc.hrcc07 != g_hrcc_t.hrcc07 
              OR g_hrcc_t.hrcc07 IS NULL THEN                                          
               IF NOT cl_null(g_hrcc.hrcc02) 
                 AND NOT cl_null(g_hrcc.hrcc04) THEN
                 SELECT COUNT(*) INTO l_n FROM hrcc_file,hrat_file
                 WHERE hrcc02=g_hrcc.hrcc02
                   AND hratid=hrcc07
                   AND hrcc04=g_hrcc.hrcc04
                   AND hrat01=g_hrcc.hrcc07
                IF l_n>0 THEN
                  CALL cl_err(g_hrcc.hrcc07,-239,0)
                  NEXT FIELD hrcc07
                END IF
              END IF
            END IF  
             
            SELECT hrat02 INTO l_hrat02 FROM hrat_file
             WHERE hrat01=g_hrcc.hrcc07
            SELECT hrao02 INTO l_hrao02 FROM hrat_file,hrao_file
             WHERE hrat01=g_hrcc.hrcc07
               AND hrat04=hrao01
            SELECT hras04 INTO l_hras04 FROM hrat_file,hras_file
             WHERE hrat01=g_hrcc.hrcc07
               AND hras01=hrat05
            
            DISPLAY l_hrat02 TO hrat02
            DISPLAY l_hrao02 TO hrao02
            DISPLAY l_hras04 TO hras04 
                    
                                                                 
         END IF 
                                                                                                                                        
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrcc02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrbm03"
              LET g_qryparam.default1 = g_hrcc.hrcc02
              LET g_qryparam.arg1='010'
              CALL cl_create_qry() RETURNING g_hrcc.hrcc02
              DISPLAY BY NAME g_hrcc.hrcc02
              NEXT FIELD hrcc02
           
           WHEN INFIELD(hrcc07)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = g_hrcc.hrcc07
              CALL cl_create_qry() RETURNING g_hrcc.hrcc07
              DISPLAY BY NAME g_hrcc.hrcc07
              NEXT FIELD hrcc07
              
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
 
FUNCTION i043_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrcc.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i043_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i043_count
    FETCH i043_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i043_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcc.hrcc01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcc.* TO NULL
    ELSE
        CALL i043_fetch('F')              
        CALL i043_b_fill(g_wc)
    END IF
END FUNCTION 

FUNCTION i043_fetch(p_flhrcc)
    DEFINE p_flhrcc         LIKE type_file.chr1

    CASE p_flhrcc
        WHEN 'N' FETCH NEXT     i043_cs INTO g_hrcc.hrcc01
        WHEN 'P' FETCH PREVIOUS i043_cs INTO g_hrcc.hrcc01
        WHEN 'F' FETCH FIRST    i043_cs INTO g_hrcc.hrcc01
        WHEN 'L' FETCH LAST     i043_cs INTO g_hrcc.hrcc01
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
            FETCH ABSOLUTE g_jump i043_cs INTO g_hrcc.hrcc01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcc.hrcc01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcc.* TO NULL
        LET g_hrcc.hrcc01 = NULL
        RETURN
    ELSE
      CASE p_flhrcc
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrcc.* FROM hrcc_file    
       WHERE hrcc01 = g_hrcc.hrcc01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrcc_file",g_hrcc.hrcc01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i043_show()                 
    END IF
END FUNCTION
 
FUNCTION i043_show()
DEFINE l_hrbm04       LIKE   hrbm_file.hrbm04
DEFINE l_hrat02       LIKE   hrat_file.hrat02
DEFINE l_hrao02       LIKE   hrao_file.hrao02
DEFINE l_hras04       LIKE   hras_file.hras04
DEFINE l_dwyx,l_dwwx LIKE   hrcc_file.hrcc10
    
    LET g_hrcc_t.*=g_hrcc.*
    SELECT hrat01 INTO g_hrcc.hrcc07 FROM hrat_file
     WHERE hratid=g_hrcc.hrcc07
    DISPLAY BY NAME g_hrcc.hrcc02,g_hrcc.hrcc03,
                    g_hrcc.hrcc04,g_hrcc.hrcc05,
                    g_hrcc.hrcc06,g_hrcc.hrcc07,
                    g_hrcc.hrcc08,g_hrcc.hrcc09,
                    g_hrcc.hrcc10,g_hrcc.hrcc11
    SELECT hrbm04 INTO l_hrbm04 FROM hrbm_file
     WHERE hrbm03=g_hrcc.hrcc02                
    SELECT hrat02 INTO l_hrat02 FROM hrat_file 
     WHERE hrat01=g_hrcc.hrcc07
    SELECT hrao02 INTO l_hrao02 FROM hrat_file,hrao_file
     WHERE hrat01=g_hrcc.hrcc07
       AND hrat04=hrao01
    SELECT hras04 INTO l_hras04 FROM hrat_file,hras_file
     WHERE hrat01=g_hrcc.hrcc07
       AND hrat05=hras01
    LET l_dwyx=g_hrcc.hrcc10
    LET l_dwwx=g_hrcc.hrcc10
    DISPLAY l_hrbm04 TO hrbm04
    DISPLAY l_hrat02 TO hrat02
    DISPLAY l_hrao02 TO hrao02
    DISPLAY l_hras04 TO hras04
    DISPLAY l_dwyx TO dw_yx
    DISPLAY l_dwwx TO dw_wx     
    CALL i043_hrcd_fill(g_hrcc.hrcc01)   
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION i043_u(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
DEFINE l_hrcc  RECORD LIKE  hrcc_file.*
    IF g_hrcc.hrcc01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF    
        
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i043_cl USING g_hrcc.hrcc01
    IF STATUS THEN
       CALL cl_err("OPEN i043_cl:", STATUS, 1)
       CLOSE i043_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i043_cl INTO g_hrcc.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcc.hrcc01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i043_show()                          
    WHILE TRUE
        CALL i043_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrcc.*=g_hrcc_t.*
            CALL i043_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrcc.hrccmodu=g_user
        LET g_hrcc.hrccdate=g_today
 
        LET l_hrcc.*=g_hrcc.*
        SELECT hratid INTO l_hrcc.hrcc07 FROM hrat_file WHERE hrat01=g_hrcc.hrcc07

        UPDATE hrcc_file SET hrcc_file.* = l_hrcc.*    
            WHERE hrcc01 = g_hrcc_t.hrcc01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrcc_file",g_hrcc.hrcc01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        LET g_hrcc.*=l_hrcc.*
        CALL i043_show() 
        EXIT WHILE
    END WHILE
    CLOSE i043_cl
    COMMIT WORK
    IF p_cmd='u' THEN
       CALL i043_b_fill(g_wc)
    END IF
END FUNCTION 
 
FUNCTION i043_r()
    IF g_hrcc.hrcc01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i043_cl USING g_hrcc.hrcc01
    IF STATUS THEN
       CALL cl_err("OPEN i043_cl:", STATUS, 0)
       CLOSE i043_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i043_cl INTO g_hrcc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcc.hrcc01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i043_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrcc01"
       LET g_doc.value1 = g_hrcc.hrcc01
       CALL cl_del_doc()
       
       DELETE FROM hrcc_file WHERE hrcc01 = g_hrcc.hrcc01
       
       CLEAR FORM
       OPEN i043_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i043_cl
          CLOSE i043_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i043_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i043_cl
          CLOSE i043_count
          COMMIT WORK
          CALL i043_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i043_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i043_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i043_fetch('/')
       END IF
    END IF
    CLOSE i043_cl
    COMMIT WORK
    CALL i043_b_fill(g_wc)
END FUNCTION 
 
FUNCTION i043_copy()
    DEFINE l_newno07         LIKE hrcc_file.hrcc07
    DEFINE l_oldno07         LIKE hrcc_file.hrcc07
    DEFINE p_cmd             LIKE type_file.chr1
    DEFINE l_input           LIKE type_file.chr1
    DEFINE l_n               LIKE type_file.num5
    DEFINE l_hrcc01          LIKE hrcc_file.hrcc01
    DEFINE l_hrcc01_o        LIKE hrcc_file.hrcc01
    DEFINE l_hratid          LIKE hrat_file.hratid
    

    IF g_hrcc.hrcc01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF

    LET l_input='N'
    LET g_before_input_done = FALSE
    LET g_before_input_done = TRUE

    INPUT l_newno07 FROM hrcc07
    
       
        AFTER FIELD hrcc07
           IF NOT cl_null(l_newno07) THEN
              LET l_n=0 
              SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=l_newno07
              IF l_n=0 THEN
                CALL cl_err('无此员工编号','!',0)
                NEXT FIELD hrcc07
              END IF
              
              IF l_newno07=g_hrcc.hrcc07 THEN
                CALL cl_err('请选择不同员工','!','0')
                NEXT FIELD hrcc07
              END IF 

              LET l_n=0
              SELECT COUNT(*) INTO l_n FROM hrcc_file WHERE hrcc07=l_newno07
                                                        AND hrcc02=g_hrcc.hrcc02
                                                        AND hrcc04=g_hrcc.hrcc04
              IF l_n>0 THEN
                 CALL cl_err("此员工在此日期已维护过此特殊假","!",0)
                 NEXT FIELD hrcc07
              END IF    
            
           END IF   
               

        ON ACTION controlp                        
           IF INFIELD(hrcc07) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = l_newno07
              CALL cl_create_qry() RETURNING l_newno07
              DISPLAY l_newno07 TO hrcc07
           END IF
   

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

    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_hrcc.hrcc07
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM hrcc_file
        WHERE hrcc01=g_hrcc.hrcc01
        INTO TEMP x
    SELECT MAX(hrcc01)+1 INTO l_hrcc01 FROM hrcc_file WHERE 1=1
    IF l_hrcc01 IS NULL OR l_hrcc01=0 THEN
      LET l_hrcc01=1
    END IF
  
    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=l_newno07
       
    UPDATE x
        SET hrcc01=l_hrcc01,
            hrcc07=l_hratid,
            hrcc08=0,
            hrcc09=hrcc03,         
            hrccuser=g_user,   
            hrccgrup=g_grup,
            hrccoriu=g_user,   
            hrccmodu=NULL,     
            hrccdate=NULL   

    INSERT INTO hrcc_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","hrcc_file",g_hrcc.hrcc01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno07,') O.K'
        LET l_hrcc01_o = g_hrcc.hrcc01
        LET l_oldno07=g_hrcc.hrcc07
        LET g_hrcc.hrcc07=l_newno07
        SELECT hrcc_file.* INTO g_hrcc.* FROM hrcc_file
               WHERE hrcc01 = l_hrcc01 
        CALL i043_show()      
        CALL i043_u('y')
        SELECT hrcc_file.* INTO g_hrcc.* FROM hrcc_file
               WHERE hrcc01 = l_hrcc01_o
    END IF
    LET g_hrcc.hrcc07 = l_oldno07
    CALL i043_show()
END FUNCTION
 
PRIVATE FUNCTION i043_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrcc02,hrcc03,hrcc04,hrcc05,hrcc06,hrcc07,hrcc11",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i043_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   DEFINE   l_n       LIKE type_file.num5
   IF p_cmd = 'u' THEN
      LET l_n=0
      SELECT COUNT(*) INTO l_n FROM hrcd_file
       WHERE hrcd10=g_hrcc.hrcc01
         AND hrcd11='4'
      IF l_n>0 THEN   
         CALL cl_set_comp_entry("hrcc02,hrcc4,hrcc05,hrcc06,hrcc07,hrcc11",FALSE)
      END IF 

      IF g_action_choice="reproduce" THEN 
          CALL cl_set_comp_entry("hrcc07",FALSE)
      END IF 
   END IF
END FUNCTION
 
FUNCTION i043_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
  
        CALL g_hrcc_1.clear()
        
        LET l_sql=" SELECT hrcc01,hrcc02,hrcc07,'','','',hrcc04,hrcc05,",
                  "        hrcc03,hrcc08,hrcc09,hrcc10,hrcc06,hrcc11",
                  "   FROM hrcc_file,hrat_file ",
                  "  WHERE ",p_wc CLIPPED,
                  "    AND hratid=hrcc07",
                  "  ORDER BY hrcc01 "
                  
        PREPARE i043_b_pre FROM l_sql
        DECLARE i043_b_cs CURSOR FOR i043_b_pre
        
        LET l_i=1
        
        FOREACH i043_b_cs INTO g_hrcc_1[l_i].*
        
           SELECT hrat01 INTO g_hrcc_1[l_i].hrcc07_1 FROM hrat_file
            WHERE hratid=g_hrcc_1[l_i].hrcc07_1
           
           SELECT hrat02 INTO g_hrcc_1[l_i].hrat02_1 FROM hrat_file
            WHERE hrat01=g_hrcc_1[l_i].hrcc07_1
           
           SELECT hrao02 INTO g_hrcc_1[l_i].hrao02_1 FROM hrat_file,hrao_file
            WHERE hrat04=hrao01
              AND hrat01=g_hrcc_1[l_i].hrcc07_1
              
           SELECT hras04 INTO g_hrcc_1[l_i].hras04_1 FROM hrat_file,hras_file
            WHERE hrat01=g_hrcc_1[l_i].hrcc07_1
              AND hras01=hrat05    
                            
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrcc_1.deleteElement(l_i)
        LET g_rec_b1 = l_i - 1

END FUNCTION   
 
FUNCTION i043_hrcd_fill(p_hrcc01)
DEFINE p_hrcc01   LIKE   hrcc_file.hrcc01 
DEFINE l_i        LIKE   type_file.num5 
DEFINE l_sql      STRING
DEFINE l_hrbm05   LIKE   hrbm_file.hrbm05
DEFINE l_hrbm06   LIKE   hrbm_file.hrbm06
    CALL g_hrcd.clear()

    SELECT hrbm05,hrbm06 INTO l_hrbm05,l_hrbm06 
      FROM hrbm_file,hrcc_file
     WHERE hrcc01=p_hrcc01
       AND hrcc02=hrbm03
       AND hrbm02='010'  
   
    LET l_sql=" SELECT DISTINCT hrcda05,hrcda06,hrcda07,hrcda08,'','',hrcda15 ",
              "   FROM hrcda_file,hrcdb_file ",
             #"  WHERE hrcda02='",p_hrcc01,"'",
              "  WHERE hrcda01=hrcdb02 ",
              "    AND hrcda02=hrcdb01 ",
              "    AND hrcdb03= ",p_hrcc01,
              "    AND hrcda17='1' ",
              "  ORDER BY hrcda05 DESC,hrcda07 DESC "  

    PREPARE i043_hrcda_pre FROM l_sql
    DECLARE i043_hrcda_cs CURSOR FOR i043_hrcda_pre

    LET l_i=1

    FOREACH i043_hrcda_cs INTO g_hrcd[l_i].*

        LET g_hrcd[l_i].hrbm05=l_hrbm05
        LET g_hrcd[l_i].hrbm06=l_hrbm06

        LET l_i=l_i+1

    END FOREACH

    CALL g_hrcd.deleteElement(l_i)
    LET g_rec_b = l_i - 1

    #LET g_hrcd[l_i].hrcd02=g_today
    #LET g_hrcd[l_i].hrcd03=TIME
    #LET g_hrcd[l_i].hrcd04=g_today
    #LET g_hrcd[l_i].hrcd05=TIME
    #LET g_rec_b=l_i
END FUNCTION  

FUNCTION i043_gen()
DEFINE l_hrcc     RECORD LIKE   hrcc_file.*
DEFINE l_n           LIKE type_file.num5
DEFINE l_hrbm05      LIKE hrbm_file.hrbm05
DEFINE l_hrbm04      LIKE hrbm_file.hrbm04
DEFINE l_dwyx,l_dwwx LIKE hrcc_file.hrcc10
DEFINE l_sql         STRING
DEFINE   li_k                    LIKE type_file.num5
DEFINE   li_i_r                  LIKE type_file.num5
DEFINE   lr_err       DYNAMIC ARRAY OF RECORD
            line    STRING,
            key1    STRING,
            err     STRING
       END RECORD
DEFINE l_hrat01     LIKE   hrat_file.hrat01       

       LET g_generate='Y'
       LET gs_wc=NULL
       CLEAR FORM
       INITIALIZE l_hrcc.* TO NULL
       
       WHILE TRUE

       INPUT l_hrcc.hrcc02,l_hrcc.hrcc03,l_hrcc.hrcc04,
             l_hrcc.hrcc05,l_hrcc.hrcc06,l_hrcc.hrcc11
         WITHOUT DEFAULTS FROM hrcc02,hrcc03,hrcc04,hrcc05,hrcc06,hrcc11
         
       BEFORE INPUT
          IF cl_null(l_hrcc.hrcc04) THEN
             LET l_hrcc.hrcc04=g_today
          END IF
          IF cl_null(l_hrcc.hrcc05) THEN
             SELECT to_date('9999/12/31','yyyy/mm/dd') 
               INTO l_hrcc.hrcc05
               FROM DUAL
          END IF
          IF cl_null(l_hrcc.hrcc06) THEN
             LET l_hrcc.hrcc06='N'
          END IF
          LET l_hrcc.hrcc08=0
          #LET l_hrcc.hrcc10='001'
          
          DISPLAY l_hrcc.hrcc04 TO hrcc04
          DISPLAY l_hrcc.hrcc05 TO hrcc05
          DISPLAY l_hrcc.hrcc06 TO hrcc06
          DISPLAY l_hrcc.hrcc08 TO hrcc08
          
       AFTER FIELD hrcc02
          IF NOT cl_null(l_hrcc.hrcc02) THEN
            LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrbm_file WHERE hrbm03=l_hrcc.hrcc02
                                                      AND hrbm02='010'
                                                      
             IF l_n=0 THEN
               CALL cl_err(g_hrcc.hrcc02,'',0)
               NEXT FIELD hrcc02
             END IF
             
             SELECT hrbm06,hrbm04 INTO l_hrcc.hrcc10,l_hrbm04 
               FROM hrbm_file
              WHERE hrbm03=l_hrcc.hrcc02
             LET l_dwyx=l_hrcc.hrcc10
             LET l_dwwx=l_hrcc.hrcc10 
             DISPLAY l_hrcc.hrcc10 TO hrcc10
             DISPLAY l_hrbm04 TO hrbm04
             DISPLAY l_dwyx TO dw_yx
             DISPLAY l_dwwx TO dw_wx
                         
          END IF
           
          AFTER FIELD hrcc03
             IF NOT cl_null(l_hrcc.hrcc03) THEN
                IF NOT cl_null(l_hrcc.hrcc02) THEN
                  LET l_hrbm05=0
                  LET l_n=0
                  SELECT hrbm05 INTO l_hrbm05 FROM hrbm_file
                   WHERE hrbm03=l_hrcc.hrcc02
                  LET l_n = l_hrcc.hrcc03 mod l_hrbm05
                  IF l_n !=0 THEN
                    CALL cl_err('累计给休必须是核算量的倍数','!',0)
                    NEXT FIELD hrcc03
                  END IF
                END IF
                LET l_hrcc.hrcc09=l_hrcc.hrcc03-l_hrcc.hrcc08
                IF l_hrcc.hrcc09<0 THEN
                  CALL cl_err('累计给休减去已休不可小于0','!',0)
                   NEXT FIELD hrcc03                                                           
                END IF
                DISPLAY l_hrcc.hrcc09 TO hrcc09 
             END IF
              
          AFTER FIELD hrcc04
            IF l_hrcc.hrcc04 IS NOT NULL THEN
               IF l_hrcc.hrcc05 IS NOT NULL THEN
                 IF l_hrcc.hrcc04>l_hrcc.hrcc05 THEN
                    CALL cl_err('开始日期不能大于结束日期','!',0)
                    NEXT FIELD hrcc04
                 END IF
               END IF
            
            END IF
          
         AFTER FIELD hrcc05
            IF NOT cl_null(l_hrcc.hrcc05) THEN
               IF NOT cl_null(l_hrcc.hrcc04) THEN
                 IF l_hrcc.hrcc05<l_hrcc.hrcc04 THEN
                    CALL cl_err('开始日期不能大于结束日期','!',0)
                    NEXT FIELD hrcc05
                 END IF
               END IF       
            END IF 
             
             
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            ELSE
               IF cl_null(l_hrcc.hrcc02) THEN
               NEXT FIELD hrcc02
               END IF
            
               IF cl_null(l_hrcc.hrcc04) THEN
                 NEXT FIELD hrcc04
               END IF
            END IF
             
         ON ACTION controlp
            CASE
              WHEN INFIELD(hrcc02)
              CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrbm03"
               LET g_qryparam.default1 = l_hrcc.hrcc02
               LET g_qryparam.arg1='010'  
               CALL cl_create_qry() RETURNING l_hrcc.hrcc02
               DISPLAY l_hrcc.hrcc02 TO hrcc02
               NEXT FIELD hrcc02
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
       
       CALL i043_sel()
       
       IF INT_FLAG THEN
          LET INT_FLAG=0
          DROP TABLE i043_tmp
          #RETURN
          CONTINUE WHILE
       ELSE
          EXIT WHILE
       END IF
       
      
       END WHILE
       
       LET l_n=0
       LET l_sql=" SELECT COUNT(*) FROM i043_tmp WHERE ",gs_wc

       PREPARE i043_sel_count FROM l_sql
       EXECUTE i043_sel_count INTO l_n

       IF l_n=0 THEN
          DROP TABLE i043_tmp
          RETURN
       END IF
       
       
       LET g_success='Y'
       LET li_k=1
       
       BEGIN WORK
       
        
       LET l_sql=" SELECT hrat01 FROM i043_tmp WHERE ",gs_wc
       
       PREPARE i043_sel_pre FROM l_sql 
       DECLARE i043_sel CURSOR FOR i043_sel_pre
       
       FOREACH i043_sel INTO l_hrat01
          SELECT MAX(hrcc01)+1 INTO l_hrcc.hrcc01 FROM hrcc_file
          IF l_hrcc.hrcc01 IS NULL OR l_hrcc.hrcc01=0 THEN
            LET l_hrcc.hrcc01=1
          END IF
          
          SELECT hratid INTO l_hrcc.hrcc07 FROM hrat_file WHERE hrat01=l_hrat01
          INSERT INTO hrcc_file VALUES (l_hrcc.*)
          IF SQLCA.sqlcode THEN  
            LET g_success='N'
            LET lr_err[li_k].line=li_k
            LET lr_err[li_k].key1=l_hrat01
            LET lr_err[li_k].err=SQLCA.sqlcode
            LET li_k=li_k+1
            CONTINUE FOREACH
          END IF 
       
       END FOREACH
       
       DROP TABLE i043_tmp
       
       IF lr_err.getLength() > 0 THEN
          ROLLBACK WORK
          CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"序号|工号|错误描述")
          #CALL i043_show()
       ELSE
          COMMIT WORK
          LET gs_wc=gs_wc," AND hrcc02='",l_hrcc.hrcc02,"' AND hrcc04='",l_hrcc.hrcc04,"'" 
          CALL i043_q()  
       END IF       
        
END FUNCTION
 
FUNCTION i043_sel()
DEFINE   l_sql      STRING
DEFINE   i          LIKE   type_file.num5
#DEFINE   gs_wc      STRING
DEFINE   lc_qbe_sn  LIKE gbm_file.gbm01
DEFINE   l_hrat   DYNAMIC ARRAY OF RECORD
            sel      LIKE type_file.chr1,
            hrat01   LIKE hrat_file.hrat01,
            hrat02   LIKE hrat_file.hrat02,
            hrat03   LIKE hrat_file.hrat03,
            hraa12   LIKE hraa_file.hraa12,
            hrat04   LIKE hrat_file.hrat04,
            hrao02   LIKE hrao_file.hrao02,
            hrat05   LIKE hrat_file.hrat05,
            hras04   LIKE hras_file.hras04
                 END RECORD
DEFINE   p_row,p_col  LIKE type_file.num5
DEFINE l_allow_insert  LIKE type_file.num5
DEFINE l_allow_deLETe  LIKE type_file.num5  
DEFINE l_check         LIKE type_file.chr1 
       
      LET gs_wc=NULL        
       
       DROP TABLE i043_tmp
      
      SELECT hrat01,hrat02,hrat03,hrat04,hrat05 FROM hrat_file
       WHERE hratconf='Y'
      INTO TEMP i043_tmp
      
      IF STATUS THEN 
         CALL cl_err('ins i043_tmp:',STATUS,1) 
         RETURN 
      END IF 
       
      LET p_row=3   LET p_col=6

       OPEN WINDOW i043_m_w AT p_row,p_col WITH FORM "ghr/42f/ghri043_m"
              ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("ghri043_m")
      
      WHILE TRUE
      CLEAR FORM
      LET l_check='N'

      CONSTRUCT gs_wc ON hrat01,hrat02,hrat03,hrat04,hrat05
           FROM s_hrat[1].hrat01,s_hrat[1].hrat02,s_hrat[1].hrat03,
                s_hrat[1].hrat04,s_hrat[1].hrat05

      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
                      

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
               

       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121

       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121

       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()

     END CONSTRUCT

     IF INT_FLAG THEN
         DELETE FROM i043_tmp
         CLOSE WINDOW i043_m_w
         RETURN
     END IF 
      
     LET l_sql=" SELECT 'N',hrat01,hrat02,hrat03,'',hrat04,'',hrat05,'' ",
               "   FROM i043_tmp ",
               "  WHERE ",gs_wc CLIPPED,
               "  ORDER BY hrat01,hrat02"


      PREPARE i043_m_pre FROM l_sql
      DECLARE i043_m_cs CURSOR FOR i043_m_pre

      LET i=1
      CALL l_hrat.clear()
      FOREACH i043_m_cs INTO l_hrat[i].*
        
        SELECT hraa12 INTO l_hrat[i].hraa12 FROM hraa_file 
         WHERE hraa01=l_hrat[i].hrat03
         
        SELECT hrao02 INTO l_hrat[i].hrao02 FROM hrao_file 
         WHERE hrao01=l_hrat[i].hrat04
         
        SELECT hras04 INTO l_hrat[i].hras04 FROM hras_file 
         WHERE hras01=l_hrat[i].hrat05
         
         
        LET i=i+1

      END FOREACH
      
      CALL l_hrat.deleteElement(i)
      LET i=i-1

      INPUT ARRAY l_hrat WITHOUT DEFAULTS FROM s_hrat.*
            ATTRIBUTE(COUNT=i,MAXCOUNT=i,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_deLETe,APPEND ROW=l_allow_insert)

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         FOR g_cnt=1 TO i
            IF l_hrat[g_cnt].sel='Y' AND l_hrat[g_cnt].sel IS NOT NULL
               AND l_hrat[g_cnt].sel <>' ' THEN
               CONTINUE FOR
            END IF
            IF l_hrat[g_cnt].hrat01 IS NULL THEN CONTINUE FOR END IF

            DELETE FROM i043_tmp WHERE hrat01=l_hrat[g_cnt].hrat01

         END FOR
               
      ON ACTION reconstruct
         LET l_check='Y'
         EXIT INPUT

      END INPUT

      IF l_check='Y' THEN
         CALL l_hrat.clear()
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF

      END WHILE
      
      CLOSE WINDOW i043_m_w
      
END FUNCTION      
