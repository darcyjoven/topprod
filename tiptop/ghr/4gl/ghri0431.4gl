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
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
   OPEN WINDOW i043_w WITH FORM "ghr/42f/ghri043"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
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
    CALL cl_replace_str(g_wc,'hrcc07','hrat01') RETURNING g_wc
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
          WHERE hrcc01=g_hrcc_1[l_ac].hrcc01_1
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
               CALL i043_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i043_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i043_u()
            END IF
         
         WHEN "piliang"
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
         
      ON ACTION piliang
         LET g_action_choice="piliang"
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
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
         CALL i043_hrcd_fill() 
         
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
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
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
      
      ON ACTION piliang
         LET g_action_choice="piliang"
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
        LET g_hrcc.hrcc10='001'
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
            CALL i043_b_fill(g_wc)
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
              CALL cl_err(g_hrcc.hrcc02,'',0)
            #  NEXT FIELD hrcc02
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
             
            #SELECT hrbm06,hrbm04 INTO g_hrcc.hrcc10,l_hrbm04 
            #  FROM hrbm_file
            # WHERE hrbm03=g_hrcc.hrcc02
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
                 CALL cl_err('绱