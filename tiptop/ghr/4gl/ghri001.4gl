# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri001.4gl
# Descriptions...: 
# Date & Author..: 03/19/13 by zhangbo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrao    RECORD LIKE hrao_file.*
DEFINE  g_hrao_t  RECORD LIKE hrao_file.*
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_wc      STRING
DEFINE  g_sql     STRING
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask             LIKE type_file.num5
DEFINE g_chr                LIKE type_file.chr1
DEFINE g_cnt                LIKE type_file.num5
DEFINE g_argv1              LIKE hrao_file.hrao01
DEFINE g_hrao01             LIKE hrao_file.hrao01
DEFINE g_flag               LIKE type_file.chr1
DEFINE g_n,g_n1  LIKE type_file.num5
DEFINE g_bp_flag             LIKE type_file.chr10
DEFINE g_rec_b,l_ac          LIKE type_file.num5
DEFINE g_hrao_b  DYNAMIC  ARRAY OF RECORD
       hrao00_b               LIKE hrao_file.hrao00,
       hraa02_b               LIKE hraa_file.hraa02,
       hrao06_b               LIKE hrao_file.hrao06,
       hrao06_1_b             LIKE hrao_file.hrao02,
       hrao01_b               LIKE hrao_file.hrao01,
       hrao09_b               LIKE hrao_file.hrao09,
       hrao02_b               LIKE hrao_file.hrao02,
       hrao10_b               LIKE hrao_file.hrao10,
       hrao10_1_b             LIKE hrao_file.hrao02,
       hrao03_b               LIKE hrao_file.hrao03,
       hrao04_b               LIKE hrao_file.hrao04,
       hrao07_b               LIKE hrao_file.hrao07,
       hrao05_b               LIKE hrao_file.hrao05,
       hrao08_b               LIKE hrao_file.hrao08,
       hraoud02_b             LIKE hrao_file.hraoud02,
       hrao11_b               LIKE hrao_file.hrao11,
       hrao12_b               LIKE hrao_file.hrao12,
       hrao13_b               LIKE hrao_file.hrao13
               END RECORD
DEFINE g_hrao_b_t   DYNAMIC  ARRAY OF RECORD
       hrao00_b               LIKE hrao_file.hrao00,
       hraa02_b               LIKE hraa_file.hraa02,
       hrao06_b               LIKE hrao_file.hrao06,
       hrao06_1_b             LIKE hrao_file.hrao02,
       hrao01_b               LIKE hrao_file.hrao01,
       hrao09_b               LIKE hrao_file.hrao09,
       hrao02_b               LIKE hrao_file.hrao02,
       hrao10_b               LIKE hrao_file.hrao10,
       hrao10_1_b             LIKE hrao_file.hrao02,
       hrao03_b               LIKE hrao_file.hrao03,
       hrao04_b               LIKE hrao_file.hrao04,
       hrao07_b               LIKE hrao_file.hrao07,
       hrao05_b               LIKE hrao_file.hrao05,
       hrao08_b               LIKE hrao_file.hrao08,
       hraoud02_b             LIKE hrao_file.hraoud02,
       hrao11_b               LIKE hrao_file.hrao11,
       hrao12_b               LIKE hrao_file.hrao12,
       hrao13_b               LIKE hrao_file.hrao13
               END RECORD
       
MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
    DEFINE l_length_test    STRING               #add by zhangbo130609 
    DEFINE l_str_test       STRING               #add by zhangbo130619  
    DEFINE l_str_buf        base.StringBuffer    #add by zhangbo130609
    DEFINE l_length         LIKE type_file.num5  #add by zhangbo130609
    DEFINE l_success        LIKE type_file.num5  #add by zhangbo130609
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
   
   LET g_argv1 = ARG_VAL(1)
   
   #just test string function
   LET l_str_buf = base.StringBuffer.create() #add by zhangbo130609
   LET l_length_test="#一二三四#"                 #add by zhangbo130609
   CALL l_str_buf.append(l_length_test)        #add by zhangbo130609
   LET l_length=l_length_test.getLength()     #add by zhangbo130609
   CALL l_str_buf.replace('二','2',0)         #add by zhangbo130609
   #CALL cl_fml_trans_desc(l_length_test) RETURNING l_length_test,l_success     #add by zhangbo130609
   LET l_str_test=l_length_test.substring(1,3)          #add by zhangbo130619  

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   INITIALIZE g_hrao.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrao_file WHERE hrao01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i001_cl CURSOR FROM g_forupd_sql                 
   
   OPEN WINDOW i001_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri001"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   CALL cl_set_label_justify("i001_w","right")
   LET g_action_choice=""
   
   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" hrao01='",g_argv1,"'"
      CALL i001_q()
   END IF

   CALL cl_set_combo_items("hraoud02",NULL,NULL)
   CALL i001_get_items('202') RETURNING l_name,l_items
   CALL cl_set_combo_items("hraoud02",l_name,l_items)
   CALL i001_menu()

 
   CLOSE WINDOW i001_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i001_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET l_sql=" SELECT hrag06,hrag06||':'||hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i001_get_items_pre FROM l_sql
       DECLARE i001_get_items CURSOR FOR i001_get_items_pre
       LET l_name=''
       LET l_items=''
       FOREACH i001_get_items INTO l_hrag06,l_hrag07
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

FUNCTION i001_curs()
#130613--for test
DEFINE tok base.StringTokenizer
DEFINE l_str,l_sql,l_wc       STRING
DEFINE l_value     LIKE  type_file.chr1000
DEFINE l_n         LIKE type_file.num5

    CLEAR FORM
    INITIALIZE g_hrao.* TO NULL
 IF g_argv1 IS NULL THEN
    CONSTRUCT BY NAME g_wc ON                              
        hrao00,hrao01,hrao02,hrao03,hrao04,hrao05,hrao06,
        hrao07,hrao08,hrao09,hrao10,hrao11,hrao12,hrao13,
        hraoud01,hraoud02,hraoud03,hraoud04,hraoud05,hraoud06,hraoud07,
        hraoud08,hraoud09,hraoud10,hraoud11,hraoud12,hraoud13,hraoud14,hraoud15,
        hraouser,hraogrup,hraomodu,hraodate,hraoacti,hraooriu,hraoorig

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrao00)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrao.hrao00
                 LET g_qryparam.construct = 'N'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao00

                 #130613---for test
                 LET l_str=g_qryparam.multiret CLIPPED
                 LET tok = base.StringTokenizer.create(l_str,"|")
                 IF NOT cl_null(l_str) THEN
                    WHILE tok.hasMoreTokens() 
                       LET l_value=tok.nextToken()
                    END WHILE
                 END IF                 

                 NEXT FIELD hrao00
                 
              WHEN INFIELD(hrao01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrao.hrao01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao01
                 NEXT FIELD hrao01
                 
             WHEN INFIELD(hrao06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrao.hrao06
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao06
                 NEXT FIELD hrao06
                 
             WHEN INFIELD(hrao10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrao.hrao10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao10
                 NEXT FIELD hrao10    
                        
             WHEN INFIELD(hrao11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao11"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrao.hrao11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao11
                 NEXT FIELD hrao11    
             
             WHEN INFIELD(hrao12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao12"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrao.hrao12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao12
                 NEXT FIELD hrao12                  
              WHEN INFIELD(hraoud04)   
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '658'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hraoud04
                 NEXT FIELD hraoud04
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
 END IF 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hraouser', 'hraogrup')  #
    LET l_wc = g_wc
    LET l_wc = cl_replace_str(l_wc,"'","")  #'                                                               #
    LET l_sql = " SELECT  instr('",l_wc,"','hraoacti')  FROM  dual "
    PREPARE i001_q_acti FROM l_sql
    EXECUTE i001_q_acti INTO l_n
    IF l_n = 0 THEN 
       LET g_wc = g_wc," AND hraoacti = 'Y' "
    END IF 
    LET g_sql = "SELECT hrao01 FROM hrao_file ",                       #
                " WHERE ",g_wc CLIPPED, " ORDER BY hrao01"
    PREPARE i001_prepare FROM g_sql
    DECLARE i001_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i001_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrao01) FROM hrao_file WHERE ",g_wc CLIPPED
    PREPARE i001_precount FROM g_sql
    DECLARE i001_count CURSOR FOR i001_precount
END FUNCTION
	
FUNCTION i001_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i001_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   
       

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i001_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i001_q()
            END IF

        ON ACTION next
            CALL i001_fetch('N')

        ON ACTION previous
            CALL i001_fetch('P')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i001_u()
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i001_x()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i001_r()
            END IF

       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i001_copy()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL i001_fetch('/')

        ON ACTION first
            CALL i001_fetch('F')

        ON ACTION last
            CALL i001_fetch('L')

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           #CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU

        ON ACTION about
           CALL cl_about()
           #add by zhuzw 20150121 start
#         ON ACTION item_list 
#            IF cl_chk_act_auth() THEN
#               CALL  i001_b_fill(g_wc)
#            END IF 
#            #add by zhuzw 20150121 end 
        ON ACTION close
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU

        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hrao.hrao01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrao01"
                 LET g_doc.value1 = g_hrao.hrao01
                 CALL cl_doc()
              END IF
           END IF
         ON ACTION ghr_import
            LET g_action_choice="ghr_import"
            IF cl_chk_act_auth() THEN
                 CALL i001_import()
            END IF
         
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            IF cl_chk_act_auth() THEN
            	 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrao_b),'','')
            END IF

        #zhangbo140414---test
        ON ACTION excel_down
           LET g_action_choice="excel_down"
           IF cl_chk_act_auth() THEN
              LET g_doc.column1 = "program"
              LET g_doc.value1 = "ghri001"
              CALL cl_doc()
           END IF 
        #zhangbo140414---test  
    END MENU
    CLOSE i001_cs
END FUNCTION

FUNCTION i001_b_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000

   WHILE TRUE

      CALL i001_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrao_file.*
           INTO g_hrao.*
           FROM hrao_file
          WHERE hrao01=g_hrao_b[l_ac].hrao01_b
            AND hrao03=g_hrao_b[l_ac].hrao03_b
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i001_fetch('/')
         END IF
         CALL cl_set_comp_visible("page4", FALSE)
        CALL cl_set_comp_visible("page3", FALSE)
        CALL cl_set_comp_visible("page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page4", TRUE)
         #CALL cl_set_comp_visible("page3", TRUE)
         CALL cl_set_comp_visible("page2", TRUE)
       END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
               CALL i001_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i001_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i001_u()
            END IF
            EXIT WHILE  	 	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrao_b),'','')
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

FUNCTION i001_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrao_b TO Record1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i001_fetch('/')
         END IF
         CALL cl_set_comp_visible("page3", FALSE)

         CALL cl_set_comp_visible("page2", FALSE)
         CALL cl_set_comp_visible("page4", FALSE)

         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page4", TRUE)
         CALL cl_set_comp_visible("page2", TRUE)
         #CALL cl_set_comp_visible("page3", TRUE)
         EXIT DISPLAY

      ON ACTION accept
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL i001_fetch('/')
         CALL cl_set_comp_visible("page3", FALSE)
        # CALL cl_set_comp_visible("page3", TRUE)
         CALL cl_set_comp_visible("page2", FALSE)
       #  CALL cl_set_comp_visible("page2", TRUE)
         CALL cl_set_comp_visible("page1", FALSE)
         
         CALL cl_set_comp_visible("page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page1", TRUE)
         CALL cl_set_comp_visible("page3", TRUE)
         CALL cl_set_comp_visible("page2", TRUE)
         CALL cl_set_comp_visible("page4", TRUE)
         EXIT DISPLAY

      ON ACTION first
         CALL i001_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i001_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i001_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i001_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i001_fetch('L')
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

 #     &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i001_a()
DEFINE l_hraa12  LIKE hraa_file.hraa12 #add by zhuzw 20150429
    CLEAR FORM                                   #
    INITIALIZE g_hrao.* LIKE hrao_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrao.hrao05 = 'N'
    	LET g_hrao.hrao07 = 'N'
    	LET g_hrao.hrao08 = 'Y'
        LET g_hrao.hraouser = g_user
        LET g_hrao.hraooriu = g_user
        LET g_hrao.hraoorig = g_grup
        LET g_hrao.hraogrup = g_grup               #
        LET g_hrao.hraodate = g_today
        LET g_hrao.hraoacti = 'Y'
        LET g_hrao.hrao04=g_today
        CALL i001_i("a")                         #
        CALL i001_hrao09()
        DISPLAY BY NAME g_hrao.hrao09
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrao.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrao.hrao01 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        INSERT INTO hrao_file VALUES(g_hrao.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrao_file",g_hrao.hrao01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrao01 INTO g_hrao.hrao01 FROM hrao_file WHERE hrao01 = g_hrao.hrao01
            #add by zhuzw 20150429 start
            SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = g_hrao.hrao00
            INSERT INTO hrai_file VALUES(g_hrao.hrao00,l_hraa12,g_hrao.hrao01,g_hrao.hrao02,'','Y',g_user,g_grup,'',g_today,'','')
            #add by zhuzw 20150429 end 
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i001_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hraa12      LIKE hraa_file.hraa12
   DEFINE l_hrao06_1    LIKE hrao_file.hrao02
   DEFINE l_hrao10_1    LIKE hrao_file.hrao02
   DEFINE l_hraa10      LIKE hraa_file.hraa10
   DEFINE l_sql         STRING
   DEFINE l_pos         LIKE type_file.num5  

   DISPLAY BY NAME
      g_hrao.hrao00,g_hrao.hrao01,g_hrao.hrao02,g_hrao.hrao03,g_hrao.hrao04,
      g_hrao.hrao05,g_hrao.hrao06,g_hrao.hrao07,g_hrao.hrao08,g_hrao.hrao09,
      g_hrao.hrao10,g_hrao.hrao11,g_hrao.hrao12,g_hrao.hrao13,
      g_hrao.hraouser,g_hrao.hraogrup,g_hrao.hraomodu,g_hrao.hraodate,g_hrao.hraoacti,
      g_hrao.hraoud01,g_hrao.hraoud02,g_hrao.hraoud03,g_hrao.hraoud04,
      g_hrao.hraoud05,g_hrao.hraoud06,g_hrao.hraoud07,
      g_hrao.hraoud08,g_hrao.hraoud09,g_hrao.hraoud10,g_hrao.hraoud11,
      g_hrao.hraoud12,g_hrao.hraoud13,g_hrao.hraoud14,g_hrao.hraoud15

   INPUT BY NAME
      g_hrao.hrao00,g_hrao.hrao06,g_hrao.hrao01,g_hrao.hrao02,g_hrao.hrao10,
      g_hrao.hrao03,g_hrao.hrao07,g_hrao.hrao04,g_hrao.hrao05,g_hrao.hraoud02,#g_hrao.hrao09,
      g_hrao.hrao08,g_hrao.hrao11,g_hrao.hrao12,g_hrao.hrao13,
      g_hrao.hraoud01,g_hrao.hraoud03,g_hrao.hraoud04,
      g_hrao.hraoud05,g_hrao.hraoud06,g_hrao.hraoud07,
      g_hrao.hraoud08,g_hrao.hraoud09,g_hrao.hraoud10,g_hrao.hraoud11,
      g_hrao.hraoud12,g_hrao.hraoud13,g_hrao.hraoud14,g_hrao.hraoud15
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i001_set_entry(p_cmd)
          CALL i001_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF p_cmd='a' THEN
          	 SELECT hraa01 INTO g_hrao.hrao00 FROM hraa_file WHERE hraa10 IS NULL 
          	 #CALL i001_gen_pre(g_hrao.hrao00,'')
                 #LET g_hrao.hrao01=g_hrao01
                 CALL hr_gen_no('hrao_file','hrao01','004',g_hrao.hrao00,'') RETURNING g_hrao.hrao01,g_flag
                 IF g_flag='Y' THEN
                    CALL cl_set_comp_entry("hrao01",TRUE)
                 ELSE
                    CALL cl_set_comp_entry("hrao01",FALSE)
                 END IF
          	 DISPLAY BY NAME g_hrao.hrao00,g_hrao.hrao01
          END IF	 
      
      AFTER FIELD hrao00
         IF NOT cl_null(g_hrao.hrao00) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=g_hrao.hrao00
         	                                            AND hraaacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err(g_hrao.hrao00,'ghr-001',0)
         	  	 NEXT FIELD hrao00
         	  END IF
                  LET l_hraa12=''
         	  SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=g_hrao.hrao00
                  DISPLAY l_hraa12 TO hraa02
         	  IF p_cmd='a' THEN
         	   LET l_hraa10=''
          	   SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=g_hrao.hrao00 
          	   #CALL i001_gen_pre(g_hrao.hrao00,l_hraa10)
                   #LET g_hrao.hrao01=g_hrao01 
                   CALL hr_gen_no('hrao_file','hrao01','004',g_hrao.hrao00,l_hraa10) RETURNING g_hrao.hrao01,g_flag
                   IF g_flag='Y' THEN
                      CALL cl_set_comp_entry("hrao01",TRUE)
                   ELSE
                      CALL cl_set_comp_entry("hrao01",FALSE)
                   END IF
            END IF
            
          	DISPLAY BY NAME g_hrao.hrao00,g_hrao.hrao01	
         ELSE
         	  NEXT FIELD hrao00	  	
         END IF
         	
         	  		                                           
      AFTER FIELD hrao01
         IF g_hrao.hrao01 IS NOT NULL THEN 
         	  LET l_n=0
            SELECT count(*) INTO l_n FROM hrao_file WHERE hrao01 = g_hrao.hrao01
            IF l_n > 0 AND p_cmd = 'a' THEN                  
               CALL cl_err(g_hrao.hrao01,-239,1)
               LET g_hrao.hrao01 = g_hrao_t.hrao01
               DISPLAY BY NAME g_hrao.hrao01
               NEXT FIELD hrao01
            END IF
         END IF
      AFTER FIELD hrao02
         IF g_hrao.hrao00 IS NOT NULL AND g_hrao.hrao02 IS NOT NULL THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao00=g_hrao.hrao00 AND hrao02=g_hrao.hrao02 AND hrao01 != g_hrao.hrao01
 #          IF l_n > 0 THEN
 #              CALL cl_err("同一公司下生/失效的所有部门名称不得重复",'!',1)
 #              DISPLAY BY NAME g_hrao.hrao02
 #              NEXT FIELD hrao02
 #           END IF 
         END IF 

      {
      #for test by zhangbo130609
      AFTER FIELD hrao03
          LET l_pos=2
          NEXT FIELD hrao02
      BEFORE FIELD hrao02
         IF NOT cl_null(l_pos) THEN
            CALL FGL_DIALOG_SETCURSOR(l_pos)
         END IF

      AFTER FIELD hrao02
         LET l_pos=FGL_GETCURSOR()
      
      }

     
      AFTER FIELD hrao05
         IF g_hrao.hrao05='N' THEN
         	  CALL cl_set_comp_entry("hrao06",TRUE)
         	  CALL cl_set_comp_required("hrao06",TRUE)
         ELSE
         	  CALL cl_set_comp_entry("hrao06",FALSE)
         	  CALL cl_set_comp_required("hrao06",FALSE)
         	  LET g_hrao.hrao06=''
         END IF
         	
      BEFORE FIELD hrao06
         IF g_hrao.hrao05='N' THEN
         	  CALL cl_set_comp_entry("hrao06",TRUE)
         	  CALL cl_set_comp_required("hrao06",TRUE)
         ELSE
         	  CALL cl_set_comp_entry("hrao06",FALSE)
         	  CALL cl_set_comp_required("hrao06",FALSE)
         	  LET g_hrao.hrao06=''
         END IF
         	
      AFTER FIELD hrao06
         IF NOT cl_null(g_hrao.hrao06) THEN
         	  IF g_hrao.hrao06=g_hrao.hrao01 THEN
         	  	 CALL cl_err(g_hrao.hrao06,'ghr-002',0)
         	  	 NEXT FIELD hrao06 
         	  END IF
  
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao01=g_hrao.hrao06
                                                            AND hrao00=g_hrao.hrao00
         	  IF l_n=0 THEN
         	     CALL cl_err(g_hrao.hrao06,'ghr-003',0)
         	     NEXT FIELD hrao06
         	  END IF
         	  
         	  SELECT hrao02 INTO l_hrao06_1 FROM hrao_file WHERE hrao01=g_hrao.hrao06
         	  DISPLAY l_hrao06_1 TO hrao06_1	
         	  	
         END IF	
      
      AFTER FIELD hrao10
         IF NOT cl_null(g_hrao.hrao10) THEN
         	  IF g_hrao.hrao10=g_hrao.hrao01 THEN
         	  	 CALL cl_err(g_hrao.hrao10,'ghr-004',0)
         	  	 NEXT FIELD hrao10 
         	  END IF
         	  		 
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao01=g_hrao.hrao10
                                                            AND hrao00=g_hrao.hrao00
            IF l_n=0 THEN
         	     CALL cl_err(g_hrao.hrao10,'ghr-005',0)
       	  	   NEXT FIELD hrao10
         	  END IF
         	  
         	  SELECT hrao02 INTO l_hrao10_1 FROM hrao_file WHERE hrao01=g_hrao.hrao10
         	  DISPLAY l_hrao10_1 TO hrao10_1	
         	  	
         END IF	  	
      
      AFTER FIELD hrao11
         IF NOT cl_null(g_hrao.hrao11) THEN
            CALL cl_set_comp_entry("hrao12",TRUE)
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM azp_file WHERE azp01=g_hrao.hrao11
         	  IF l_n=0 THEN
         	  	 CALL cl_err(g_hrao.hrao11,'ghr-006',0)
         	  	 NEXT FIELD hrao11
         	  END IF
         ELSE
            LET g_hrao.hrao12=''
            CALL cl_set_comp_entry("hrao12",FALSE)
         END IF
      
      AFTER FIELD hrao12
         IF NOT cl_null(g_hrao.hrao12) THEN
         	  IF NOT cl_null(g_hrao.hrao11) THEN
         	  	 LET l_n=0
         	  	 LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(g_hrao.hrao11,'gem_file'),
         	  	           "  WHERE gem01='",g_hrao.hrao12,"'",
         	  	           "    AND gemacti='Y' "
         	  	           
         	  	 PREPARE i001_gem FROM l_sql
         	  	 EXECUTE i001_gem INTO l_n
         	  	 IF l_n=0 THEN
         	  	 	  CALL cl_err(g_hrao.hrao12,'ghr-007',0)
         	  	 	  NEXT FIELD hrao12
         	  	 END IF
         	  ELSE
         	     CALL cl_err(g_hrao.hrao11,'ghr-008',1)
         	     NEXT FIELD hrao11
         	  END IF
         END IF	  	    	    	 		            
         	  	                    	  	   	 	                                             	    		  	      	

     AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
     

     ON ACTION CONTROLO                        
       IF INFIELD(hrao01) THEN
          LET g_hrao.* = g_hrao_t.*
          CALL i001_show()
          NEXT FIELD hrao01
       END IF

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrao00)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = g_hrao.hrao00
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING g_hrao.hrao00
              DISPLAY BY NAME g_hrao.hrao00
              NEXT FIELD hrao00
           
           WHEN INFIELD(hrao06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.default1 = g_hrao.hrao06
              LET g_qryparam.arg1 = g_hrao.hrao00 
              CALL cl_create_qry() RETURNING g_hrao.hrao06
              DISPLAY BY NAME g_hrao.hrao06
              NEXT FIELD hrao06
              
           WHEN INFIELD(hrao10)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.default1 = g_hrao.hrao10
              LET g_qryparam.arg1 = g_hrao.hrao00 
              CALL cl_create_qry() RETURNING g_hrao.hrao10
              DISPLAY BY NAME g_hrao.hrao10
              NEXT FIELD hrao10
           
           WHEN INFIELD(hrao11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azp"
              LET g_qryparam.default1 = g_hrao.hrao11 
              CALL cl_create_qry() RETURNING g_hrao.hrao11
              DISPLAY BY NAME g_hrao.hrao11
              NEXT FIELD hrao11  
           
           WHEN INFIELD(hrao12)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.default1 = g_hrao.hrao12
              LET g_qryparam.plant = g_hrao.hrao11 
              CALL cl_create_qry() RETURNING g_hrao.hrao12
              DISPLAY BY NAME g_hrao.hrao12
              NEXT FIELD hrao12    
           WHEN INFIELD(hraoud04)   
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '658'
                 LET g_qryparam.form = "q_hrag06"
                 CALL cl_create_qry() RETURNING g_hrao.hraoud04
                 DISPLAY g_hrao.hraoud04 TO hraoud04
                 NEXT FIELD hraoud04
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

FUNCTION i001_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrao.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i001_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i001_count
    FETCH i001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i001_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrao.hrao01,SQLCA.sqlcode,0)
        INITIALIZE g_hrao.* TO NULL
    ELSE
        CALL i001_fetch('F')   
        CALL i001_b_fill(g_wc)           
    END IF
END FUNCTION

FUNCTION i001_fetch(p_flhrao)
    DEFINE p_flhrao         LIKE type_file.chr1

    CASE p_flhrao
        WHEN 'N' FETCH NEXT     i001_cs INTO g_hrao.hrao01
        WHEN 'P' FETCH PREVIOUS i001_cs INTO g_hrao.hrao01
        WHEN 'F' FETCH FIRST    i001_cs INTO g_hrao.hrao01
        WHEN 'L' FETCH LAST     i001_cs INTO g_hrao.hrao01
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
            FETCH ABSOLUTE g_jump i001_cs INTO g_hrao.hrao01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrao.hrao01,SQLCA.sqlcode,0)
        INITIALIZE g_hrao.* TO NULL
        LET g_hrao.hrao01 = NULL
        RETURN
    ELSE
      CASE p_flhrao
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrao.* FROM hrao_file    
       WHERE hrao01 = g_hrao.hrao01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrao_file",g_hrao.hrao01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i001_show()                 
    END IF
END FUNCTION

FUNCTION i001_show()
DEFINE l_hrao06_1     LIKE     hrao_file.hrao02
DEFINE l_hrao10_1     LIKE     hrao_file.hrao02	
DEFINE l_hraa12       LIKE     hraa_file.hraa12
    LET g_hrao_t.* = g_hrao.*
    DISPLAY BY NAME g_hrao.hrao00,g_hrao.hrao01,g_hrao.hrao02,g_hrao.hrao03,
                    g_hrao.hrao04,g_hrao.hrao05,g_hrao.hrao06,g_hrao.hrao07,
                    g_hrao.hrao08,g_hrao.hrao09,g_hrao.hrao10,g_hrao.hrao11,
                    g_hrao.hrao12,g_hrao.hrao13,
                    g_hrao.hraouser,g_hrao.hraogrup,g_hrao.hraomodu,
                    g_hrao.hraodate,g_hrao.hraoacti,g_hrao.hraoorig,g_hrao.hraooriu,
                    g_hrao.hraoud01,g_hrao.hraoud02,g_hrao.hraoud03,g_hrao.hraoud04,
                    g_hrao.hraoud05,g_hrao.hraoud06,g_hrao.hraoud07,
                    g_hrao.hraoud08,g_hrao.hraoud09,g_hrao.hraoud10,g_hrao.hraoud11,
                    g_hrao.hraoud12,g_hrao.hraoud13,g_hrao.hraoud14,g_hrao.hraoud15
    SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01=g_hrao.hrao00
    SELECT hrao02 INTO l_hrao06_1 FROM hrao_file WHERE hrao01=g_hrao.hrao06
    SELECT hrao02 INTO l_hrao10_1 FROM hrao_file WHERE hrao01=g_hrao.hrao10
    DISPLAY l_hraa12 TO hraa02
    DISPLAY l_hrao06_1 TO hrao06_1
    DISPLAY l_hrao10_1 TO hrao10_1
    
    #CALL cl_show_fld_cont()
END FUNCTION


FUNCTION i001_u()
    IF g_hrao.hrao01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrao.* FROM hrao_file WHERE hrao01=g_hrao.hrao01
    IF g_hrao.hraoacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i001_cl USING g_hrao.hrao01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_hrao.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrao.hrao01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i001_show()                          
    WHILE TRUE
        CALL i001_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrao.*=g_hrao_t.*
            CALL i001_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrao.hraomodu=g_user
        LET g_hrao.hraodate=g_today	
        IF g_hrao_t.hrao06 <> g_hrao.hrao06  THEN 
           CALL i001_hrao09()
           DISPLAY BY NAME g_hrao.hrao09
        END IF 
        UPDATE hrao_file SET hrao_file.* = g_hrao.*    
            WHERE hrao01 = g_hrao_t.hrao01
        UPDATE hrap_file SET hrap02=g_hrao.hrao02 WHERE hrap01=g_hrao.hrao01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrao_file",g_hrao.hrao01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        ELSE 
        	 #add by zhuzw 20150429 str
           IF g_hrao_t.hrao02 != g_hrao.hrao02 THEN 
              UPDATE hrai_file SET hrai04 = g_hrao.hrao02 
               WHERE hrai03= g_hrao.hrao01
           END IF 
        	 #add end 
        END IF
        CALL i001_show()	
        EXIT WHILE
    END WHILE
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION

FUNCTION i001_x()
    IF g_hrao.hrao01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i001_cl USING g_hrao.hrao01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 1)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_hrao.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrao.hrao01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i001_show()
    IF cl_exp(0,0,g_hrao.hraoacti) THEN
        LET g_chr = g_hrao.hraoacti
        IF g_hrao.hraoacti='Y' THEN
            LET g_hrao.hraoacti='N'
        ELSE
            LET g_hrao.hraoacti='Y'
        END IF
        UPDATE hrao_file
            SET hraoacti=g_hrao.hraoacti
            WHERE hrao01=g_hrao.hrao01
            
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrao.hrao01,SQLCA.sqlcode,0)
            LET g_hrao.hraoacti = g_chr    
        END IF
        #add by zhuzw 20150429 str    
        UPDATE hrai_file
            SET hraiacti=g_hrao.hraoacti
            WHERE hrai03=g_hrao.hrao01   
        #add end          
        DISPLAY BY NAME g_hrao.hraoacti
    END IF
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION

FUNCTION i001_r()
DEFINE l_n    LIKE  type_file.num5
    
    LET l_n=0
    SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao06=g_hrao.hrao01
    IF l_n>0 THEN
       CALL cl_err('已有该部门的下级部门,不可删除该部门','!',0)
       RETURN
    END IF
   
    IF g_hrao.hrao01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK

    OPEN i001_cl USING g_hrao.hrao01
    IF STATUS THEN
       CALL cl_err("OPEN i001_cl:", STATUS, 0)
       CLOSE i001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i001_cl INTO g_hrao.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrao.hrao01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i001_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrao01"
       LET g_doc.value1 = g_hrao.hrao01

       CALL cl_del_doc()
       DELETE FROM hrao_file WHERE hrao01 = g_hrao.hrao01
       DELETE FROM hrai_file WHERE hrai03= g_hrao.hrao01 #add by zhuzw 20150429
       CLEAR FORM
       OPEN i001_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i001_cl
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i001_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i001_cl
          CLOSE i001_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i001_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i001_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i001_fetch('/')
       END IF
    END IF
    CLOSE i001_cl
    COMMIT WORK
END FUNCTION

FUNCTION i001_copy()

    DEFINE l_newno00         LIKE hrao_file.hrao00
    DEFINE l_newno01         LIKE hrao_file.hrao01
    DEFINE l_newno05         LIKE hrao_file.hrao05
    DEFINE l_newno06         LIKE hrao_file.hrao06
    DEFINE l_oldno00         LIKE hrao_file.hrao00
    DEFINE l_oldno01         LIKE hrao_file.hrao01
    DEFINE l_oldno05         LIKE hrao_file.hrao05
    DEFINE l_oldno06         LIKE hrao_file.hrao06
    DEFINE p_cmd             LIKE type_file.chr1
    DEFINE l_input           LIKE type_file.chr1
    DEFINE l_hraa10          LIKE hraa_file.hraa10
    DEFINE l_n               LIKE type_file.num5

    IF g_hrao.hrao01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF

    LET l_input='N'
    LET g_before_input_done = FALSE
    LET g_before_input_done = TRUE

    INPUT l_newno00,l_newno01,l_newno05,l_newno06 FROM hrao00,hrao01,hrao05,hrao06
    
    BEFORE INPUT
       LET l_newno00=g_hrao.hrao00
       LET l_hraa10=''
       LET l_newno05='N'
       SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=l_newno00 
       #CALL i001_gen_pre(l_newno00,'')
       #LET l_newno01=g_hrao01
       CALL hr_gen_no('hrao_file','hrao01','004',g_hrao.hrao00,l_hraa10) RETURNING l_newno01,g_flag
       IF g_flag='Y' THEN
          CALL cl_set_comp_entry("hrao01",TRUE)
       ELSE
          CALL cl_set_comp_entry("hrao01",FALSE)
       END IF
       DISPLAY l_newno00 TO hrao00
       DISPLAY l_newno01 TO hrao01
       DISPLAY l_newno05 TO hrao05
       
        AFTER FIELD hrao00
           IF NOT cl_null(l_newno00) THEN
         	    LET l_n=0
         	    SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=l_newno00
         	                                              AND hraaacti='Y'
         	    IF l_n=0 THEN
         	  	   CALL cl_err(l_newno00,'ghr-001',0)
         	  	   NEXT FIELD hrao00
         	    END IF
         	  
         	  	LET l_hraa10=''
          	  SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=l_newno00 
          	  #CALL i001_gen_pre(l_newno00,l_hraa10)
                  #LET l_newno01=g_hrao01
                  CALL hr_gen_no('hrao_file','hrao01','004',g_hrao.hrao00,l_hraa10) RETURNING l_newno01,g_flag
                  IF g_flag='Y' THEN
                     CALL cl_set_comp_entry("hrao01",TRUE)
                  ELSE
                     CALL cl_set_comp_entry("hrao01",FALSE)
                  END IF
              DISPLAY l_newno00 TO hrao00
              DISPLAY l_newno01 TO hrao01	
           ELSE
         	    NEXT FIELD hrao00	  	
           END IF   

        AFTER FIELD hrao01
           IF l_newno01 IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM hrao_file WHERE hrao01 = l_newno01
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno01,-239,0)
                 NEXT FIELD hrao01
              END IF
              
           END IF
           	
        AFTER FIELD hrao05
           IF l_newno05='N' THEN
           	  CALL cl_set_comp_entry("hrao06",TRUE)
           	  CALL cl_set_comp_required("hrao06",TRUE)
           ELSE
           	  CALL cl_set_comp_entry("hrao06",FALSE)
           	  CALL cl_set_comp_required("hrao06",FALSE)
           	  LET l_newno06=''
           END IF
           	
        BEFORE FIELD hrao06
           IF l_newno05='N' THEN
         	    CALL cl_set_comp_entry("hrao06",TRUE)
         	    CALL cl_set_comp_required("hrao06",TRUE)
           ELSE
         	    CALL cl_set_comp_entry("hrao06",FALSE)
         	    CALL cl_set_comp_required("hrao06",FALSE)
         	    LET l_newno06=''
           END IF
         	
        AFTER FIELD hrao06
           IF NOT cl_null(l_newno06) THEN
         	    IF l_newno06=l_newno01 THEN
         	  	   CALL cl_err(l_newno06,'ghr-002',0)
         	  	   NEXT FIELD hrao06 
         	    END IF
  
         	    LET l_n=0
         	    SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao01=l_newno06
                                                        AND hrao00=l_newno00
         	    IF l_n=0 THEN
         	       CALL cl_err(l_newno06,'ghr-003',0)
         	       NEXT FIELD hrao06
         	    END IF
         	  	
           END IF	
              		  	     	

        ON ACTION controlp                        
           IF INFIELD(hrao00) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = g_hrao.hrao00
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING l_newno00
              DISPLAY l_newno00 TO hrao00
           END IF
           	
           IF INFIELD(hrao06) THEN
           	  CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.default1 = g_hrao.hrao06
              LET g_qryparam.arg1 = l_newno00 
              CALL cl_create_qry() RETURNING l_newno06
              DISPLAY l_newno06 TO hrao06
              NEXT FIELD hrao06 	
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
        DISPLAY BY NAME g_hrao.hrao00,g_hrao.hrao01,g_hrao.hrao05,g_hrao.hrao06
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM hrao_file
        WHERE hrao01=g_hrao.hrao01
        INTO TEMP x
    UPDATE x
        SET hrao00=l_newno00,
            hrao01=l_newno01,
            hrao05=l_newno05,
            hrao06=l_newno06,    
            hraoacti='Y',      
            hraouser=g_user,   
            hraogrup=g_grup,   
            hraomodu=NULL,     
            hraodate=g_today   

    INSERT INTO hrao_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","hrao_file",g_hrao.hrao01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
    ELSE
        MESSAGE 'ROW(',l_newno01,') O.K'
        LET l_oldno00 = g_hrao.hrao00
        LET l_oldno01 = g_hrao.hrao01
        LET l_oldno05 = g_hrao.hrao05
        LET l_oldno06 = g_hrao.hrao06
        LET g_hrao.hrao00 = l_newno00
        LET g_hrao.hrao01 = l_newno01
        LET g_hrao.hrao05 = l_newno05
        LET g_hrao.hrao06 = l_newno06
        SELECT hrao_file.* INTO g_hrao.* FROM hrao_file
               WHERE hrao01 = l_newno
        CALL i001_u()
        SELECT hrao_file.* INTO g_hrao.* FROM hrao_file
               WHERE hrao01 = l_oldno
    END IF
    LET g_hrao.hrao00 = l_oldno00
    LET g_hrao.hrao01 = l_oldno01
    LET g_hrao.hrao05 = l_oldno05
    LET g_hrao.hrao06 = l_oldno06
    CALL i001_show()
END FUNCTION


PRIVATE FUNCTION i001_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("hrao00,hrao01,hrao05",TRUE)
   END IF
END FUNCTION


PRIVATE FUNCTION i001_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

    DEFINE l_n         LIKE type_file.num5
   SELECT count(*) INTO l_n FROM hrao_file WHERE hrao06 = g_hrao.hrao01
   IF p_cmd = 'u' AND g_chkey = 'N' AND l_n > 0 THEN
      CALL cl_set_comp_entry("hrao00,hrao01",FALSE)
      CALL cl_err("部门下存在子部门不能修改部门的所属公司",'!',0)
   ELSE 
      CALL cl_set_comp_entry("hrao00,hrao01",TRUE)
   END IF
END FUNCTION
	
FUNCTION i001_gen_pre(p_hraa01,p_hraa10)
DEFINE p_hraa01     LIKE 	  hraa_file.hraa01
DEFINE p_hraa10     LIKE    hraa_file.hraa10
DEFINE l_hram       RECORD LIKE   hram_file.*
DEFINE l_hraa10     LIKE    hraa_file.hraa10
DEFINE l_hrao01     LIKE    hrao_file.hrao01
  
       IF cl_null(p_hraa01) THEN RETURN END IF
       	 
       INITIALIZE l_hram.* TO NULL  
       SELECT * INTO l_hram.* FROM hram_file WHERE hram02=p_hraa01 AND hram12='Y'
                                               AND hram01='004'
       IF NOT cl_null(l_hram.hram01) AND l_hram.hram12='Y' THEN
       	  CALL i001_gen(l_hram.*)
       ELSE
       	  SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01=p_hraa10 AND hraaacti='Y'       	    	                                             
          CALL i001_gen_pre(p_hraa10,l_hraa10)
       END IF
       	

END FUNCTION
	
FUNCTION i001_gen(p_hram)	       	   
DEFINE  p_hram      RECORD LIKE   hram_file.*
DEFINE  l_check     LIKE    type_file.chr1000
DEFINE  l_check1    LIKE    type_file.chr1000
DEFINE  l_check2    LIKE    type_file.chr1000
DEFINE  l_str       STRING
DEFINE  l_str2      STRING
DEFINE  l_str3      STRING
DEFINE  l_length    LIKE    type_file.num5
DEFINE  l_hrao01    LIKE    hrao_file.hrao01
DEFINE  l_sql       STRING
DEFINE  l_format    STRING     
DEFINE i            LIKE type_file.num5
     LET g_hrao01=''
     LET l_str=''
	   CASE p_hram.hram09
	     WHEN 'N'    LET l_str2=''
	   	 WHEN 'Y'    IF p_hram.hram10='1' THEN LET l_str2=' ' END IF
	   	 	           IF p_hram.hram10='2' THEN LET l_str2='_' END IF 		
	   END CASE
	   	
	     IF NOT cl_null(p_hram.hram03) THEN
	     	  LET l_str=l_str.trim()
	     	  LET l_str=l_str CLIPPED,p_hram.hram03
	     END IF
	     	
	     IF p_hram.hram05='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,p_hram.hram06
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,p_hram.hram06
	     	  END IF	     
	     END IF
	     	
	     IF p_hram.hram07='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,'MM'
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,'MM'
	     	  END IF	     
	     END IF
	     	
	     IF p_hram.hram08='Y' THEN
	     	  LET l_str=l_str.trim()
	     	  IF cl_null(l_str) THEN	     	  
	     	     LET l_str=l_str CLIPPED,'DD'
	     	  ELSE
	     	  	 LET l_str=l_str CLIPPED,l_str2,'DD'
	     	  END IF	     
	     END IF
	     	
	     LET l_str=l_str.trim()
	     LET l_check=l_str CLIPPED,l_str2,"%"
	     IF l_str2 IS NULL THEN
	     	  LET l_check1=l_str CLIPPED," %"
	     	  LET l_check2=l_str CLIPPED,"_%"
	        LET l_length=l_str.getLength()+p_hram.hram04
	     ELSE
	     	  LET l_length=l_str.getLength()+p_hram.hram04+1
	     END IF	     
       
       IF l_str2 IS NOT NULL THEN
          LET l_sql=" SELECT MAX(hrao01) FROM hrao_file WHERE hrao01 LIKE '",l_check,"'",
                    "                                     AND length(hrao01)=",l_length
       ELSE
       	  LET l_sql=" SELECT MAX(hrao01) FROM hrao_file WHERE hrao01 LIKE '",l_check,"'",
       	            #"                                     AND hrao01 NOT LIKE '",l_check1,"'",
       	            #"                                     AND hrao01 NOT LIKE '",l_check2,"'",
                    "                                     AND instr(hrao01,'_')=0 ",
                    "                                     AND instr(hrao01,' ')=0 ", 
                    "                                     AND length(hrao01)=",l_length
       END IF             
       	                	        
       PREPARE i001_gen_pre FROM l_sql
       EXECUTE i001_gen_pre INTO l_hrao01
       
       IF NOT cl_null(l_hrao01) THEN
          LET l_hrao01=l_hrao01[l_length-p_hram.hram04+1,l_length]
          LET l_hrao01=l_hrao01+1
          LET l_format = ''
          FOR i = 1 TO p_hram.hram04
              LET l_format = l_format,"&" 
          END FOR   
          LET l_hrao01 = l_hrao01 USING l_format
          LET l_hrao01=l_str CLIPPED,l_str2,l_hrao01         
       ELSE
       	  LET l_hrao01=l_str CLIPPED,l_str2,p_hram.hram15
       END IF
       	
       LET l_sql=" SELECT substr('",l_hrao01,"',1,",l_length,") FROM DUAL"
       
       PREPARE i001_gen FROM l_sql
       EXECUTE i001_gen INTO l_hrao01
       
       IF p_hram.hram11='Y' THEN
       	  CALL cl_set_comp_entry("hrao01",TRUE)
       ELSE
       	  CALL cl_set_comp_entry("hrao01",FALSE)
       END IF	  	   
       
       LET g_hrao01=l_hrao01
END FUNCTION	 	  	    
FUNCTION i001_hrao09()
DEFINE l_n  LIKE type_file.num5
DEFINE l_hraa10 LIKE hraa_file.hraa10
   SELECT hraa10 INTO l_hraa10 FROM hraa_file
    WHERE hraa01 = g_hrao.hrao00
   IF cl_null(l_hraa10) THEN 
      IF g_hrao.hrao05 = 'Y' THEN
         LET g_hrao.hrao09 = 0 
      ELSE 
         CALL i001_hrao09_1(g_hrao.hrao06,1) 
         LET g_hrao.hrao09 = g_n     
      END IF       
   ELSE 
      CALL i001_hrao09_2(l_hraa10,0) 
      IF g_hrao.hrao05 = 'Y' THEN
         LET g_hrao.hrao09 = g_n1 + 1 
      ELSE 
       	 LET g_n1 = g_n1 + 1
         CALL i001_hrao09_1(g_hrao.hrao06,g_n1) 
         LET g_hrao.hrao09 = g_n     
      END IF        
   END IF
END FUNCTION         			
FUNCTION i001_hrao09_1(p_hrao06,p_n)
DEFINE p_n      LIKE type_file.num5
DEFINE l_hrao05 LIKE hrao_file.hrao05
DEFINE p_hrao06,l_hrao06 LIKE hrao_file.hrao06
   SELECT hrao05,hrao06 INTO l_hrao05,l_hrao06 FROM hrao_file
    WHERE hrao01 = p_hrao06
   IF l_hrao05 = 'Y' THEN  
      LET g_n = p_n + 1
      RETURN 
   ELSE 
      LET p_n = p_n + 1
      CALL i001_hrao09_1(l_hrao06,p_n)       
   END IF  
END FUNCTION 
FUNCTION i001_hrao09_2(p_hraa01,p_n1)
DEFINE p_n1      LIKE type_file.num5
DEFINE p_hraa01 LIKE hraa_file.hraa01
DEFINE l_hraa10 LIKE hraa_file.hraa10
   SELECT hraa10 INTO l_hraa10 FROM hraa_file
    WHERE hraa01 = p_hraa01
   IF cl_null(l_hraa10) THEN 
      LET g_n1 = p_n1
      RETURN 
   ELSE 
      LET p_n1 = p_n1 + 1
      CALL i001_hrao09_2(l_hraa10,p_n1)       
   END IF  
END FUNCTION 
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i001_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 131021 shenran 
#=================================================================#
FUNCTION i001_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrao00  LIKE hrao_file.hrao00,
         hrao01  LIKE hrao_file.hrao01,
         hrao02  LIKE hrao_file.hrao02,
         hrao03  LIKE hrao_file.hrao03,
         hrao04  LIKE hrao_file.hrao04,
         hrao06  LIKE hrao_file.hrao06,
         hrao10  LIKE hrao_file.hrao10,
         hrao05  LIKE hrao_file.hrao05,
         hrao08  LIKE hrao_file.hrao08,
         hrao11  LIKE hrao_file.hrao11,
         hrao12  LIKE hrao_file.hrao12,
         hrao13  LIKE hrao_file.hrao13
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

DEFINE l_hraa10 LIKE hraa_file.hraa10


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
                FOR i = 1 TO iRow                                               
                                                                                           
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrao00])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hrao01])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrao02])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrao03])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrao04])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrao06])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrao10])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[sr.hrao05])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[sr.hrao08])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[sr.hrao11])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',13).Value'],[sr.hrao12])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',14).Value'],[sr.hrao13])
                IF NOT cl_null(sr.hrao00) AND NOT cl_null(sr.hrao01) AND NOT cl_null(sr.hrao02)
                	 AND NOT cl_null(sr.hrao04) THEN 
                	 IF i > 1 THEN
                	 	#begin WORK
                	 	
                    INSERT INTO hrao_file(hrao00,hrao01,hrao02,hrao03,hrao04,hrao06,hrao10,hrao05,hrao08,hrao11,hrao12,hrao13,hraoacti,hraouser,hraogrup,hraodate,hraoorig,hraooriu)
                      VALUES (sr.hrao00,sr.hrao01,sr.hrao02,sr.hrao03,sr.hrao04,sr.hrao06,sr.hrao10,sr.hrao05,sr.hrao08,sr.hrao11,sr.hrao12,sr.hrao13,'Y',g_user,g_grup,g_today,g_grup,g_user)
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrao_file",sr.hrao01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    ELSE
 
                    END IF 
                    
                    
                    IF (cl_null(sr.hrao05) OR sr.hrao05<>'Y') AND cl_null(sr.hrao06) THEN 
                         CALL cl_err3("ins","hrao_file",sr.hrao01,'','没有上级部门时则为直属部门',"","",1)   
                         LET g_success  = 'N'
                         CONTINUE FOR 
                     ELSE
                     	 IF NOT cl_null(sr.hrao06) AND sr.hrao05='Y' THEN 
                     	 	  CALL cl_err3("ins","hrao_file",sr.hrao01,'','存在上级部门时则不为直属部门',"","",1)   
                          LET g_success  = 'N'
                          CONTINUE FOR 
                        ELSE 
                          #COMMIT WORK 
                     	    SELECT * INTO g_hrao.* FROM hrao_file
                          WHERE hrao01=sr.hrao01
#                             SELECT hraa10 INTO l_hraa10 FROM hraa_file
#    WHERE hraa01 = sr.hrao00
#   IF cl_null(l_hraa10) THEN 
#      IF sr.hrao05 = 'Y' THEN
#         LET g_hrao.hrao09 = 0 
#      ELSE 
#         CALL i001_hrao09_1(sr.hrao06,1) 
#         LET g_hrao.hrao09 = g_n     
#      END IF       
#   ELSE 
#      CALL i001_hrao09_2(l_hraa10,0) 
#      IF sr.hrao05 = 'Y' THEN
#         LET g_hrao.hrao09 = g_n1 + 1 
#      ELSE 
#       	 LET g_n1 = g_n1 + 1
#         CALL i001_hrao09_1(sr.hrao06,g_n1) 
#         LET g_hrao.hrao09 = g_n     
#      END IF        
#   END IF
                          UPDATE hrao_file SET hrao09=g_hrao.hrao09
                          WHERE hrao01=sr.hrao01
                       END IF 
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
       
       SELECT * INTO g_hrao.* FROM hrao_file
       WHERE hrao01=sr.hrao01
       CALL i001_show()
   END IF 

END FUNCTION 
#TQC-AC0326 add --------------------end-----------------------

FUNCTION i001_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrao_b.clear()
        
        LET l_sql=" SELECT hrao00,'',hrao06,'',hrao01,hrao09,hrao02, ",
                  "        hrao10,'',hrao03,hrao04,hrao07,hrao05,hrao08, ",
                  "        hraoud02,hrao11,hrao12,hrao13",
                  "   FROM hrao_file WHERE ",p_wc CLIPPED,
                  "  ORDER BY hrao01 "
                  
        PREPARE i001_b_pre FROM l_sql
        DECLARE i001_b_cs CURSOR FOR i001_b_pre
        
        LET l_i=1
        
        FOREACH i001_b_cs INTO g_hrao_b[l_i].*
           
           SELECT hraa12 INTO g_hrao_b[l_i].hraa02_b FROM hraa_file
           WHERE hraa01=g_hrao_b[l_i].hrao00_b

           SELECT hrao02 INTO g_hrao_b[l_i].hrao06_1_b FROM hrao_file 
           WHERE hrao01=g_hrao_b[l_i].hrao06_b
              
           SELECT hrao02 INTO g_hrao_b[l_i].hrao10_1_b FROM hrao_file 
           WHERE hrao01=g_hrao_b[l_i].hrao10_b
           SELECT hrag07 INTO g_hrao_b[l_i].hraoud02_b FROM hrag_file 
            WHERE hrag01 = '202'
              AND hrag06 = g_hrao_b[l_i].hraoud02_b
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrao_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrao_b TO Record1.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY
          EXIT DISPLAY    
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#         
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#      
#      ON ACTION cancel
#         LET INT_FLAG=FALSE     
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#
#      ON ACTION ACCEPT 
#      	 LET l_ac = ARR_CURR()
#         LET g_jump = l_ac
#         LET g_no_ask = TRUE 
#         CALL i001_fetch('/')
#         CALL cl_set_act_visible("item_list", FALSE)
#         CALL cl_set_act_visible("p1", FALSE)
#         CALL cl_set_act_visible("p2", FALSE)
#         CALL ui.interface.refresh()
#         CALL cl_set_act_visible("item_list",TRUE)
#         CALL cl_set_act_visible("p1", TRUE)
#         CALL cl_set_act_visible("p2", TRUE)
#        # LET g_flag_b='1'
#         EXIT DISPLAY 
#         
#      AFTER DISPLAY
#         CONTINUE DISPLAY
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
