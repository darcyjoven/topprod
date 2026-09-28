# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri063.4gl
# Descriptions...: 
# Date & Author..: 03/19/13 by zhangbo


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE  g_hrcw    RECORD LIKE hrcw_file.*
DEFINE  g_hrcw_t  RECORD LIKE hrcw_file.*
DEFINE  g_hrcw_b  DYNAMIC ARRAY OF RECORD
          hrcw01    LIKE   hrcw_file.hrcw01,
          hrcw05    LIKE   hrcw_file.hrcw05,
          hrcw02    LIKE   hrcw_file.hrcw02,
          hrcw03    LIKE   hrcw_file.hrcw03,
          hrcw04    LIKE   hrcw_file.hrcw04,
          hrcw06    LIKE   hrcw_file.hrcw06,
          hrcw07    LIKE   hrcw_file.hrcw07
                  END RECORD
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_hrcw01            LIKE hrcw_file.hrcw01
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
 
   INITIALIZE g_hrcw.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrcw_file WHERE hrcw01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i063_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i063_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri063"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   CALL cl_set_comp_visible("hrcw01_b",FALSE)   
 
   CALL cl_set_combo_items("hrcw05",NULL,NULL)
   CALL cl_set_combo_items("hrcw05_b",NULL,NULL)
   CALL i063_get_items('701') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrcw05",l_name,l_items)
   CALL cl_set_combo_items("hrcw05_b",l_name,l_items)
     
   LET g_action_choice=""
   CALL i063_menu()
 
   CLOSE WINDOW i063_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i063_get_items(p_hrag01)
DEFINE p_hrag01 LIKE hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i063_get_items_pre FROM l_sql
       DECLARE i063_get_items CURSOR FOR i063_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i063_get_items INTO l_hrag06,l_hrag07
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

FUNCTION i063_curs()

    CLEAR FORM
    INITIALIZE g_hrcw.* TO NULL
    CONSTRUCT BY NAME g_wc ON                              
        hrcw02,hrcw03,hrcw04,hrcw05,hrcw06,
        hrcw07,hrcw08,hrcw09

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcwuser', 'hrcwgrup')  #
                                                                     #

    LET g_sql = "SELECT hrcw01 FROM hrcw_file ",                       #
                " WHERE ",g_wc CLIPPED, " ORDER BY hrcw05,hrcw01"
    PREPARE i063_prepare FROM g_sql
    DECLARE i063_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i063_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrcw01) FROM hrcw_file WHERE ",g_wc CLIPPED
    PREPARE i063_precount FROM g_sql
    DECLARE i063_count CURSOR FOR i063_precount
END FUNCTION
	
FUNCTION i063_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i063_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i063_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i063_q()
            END IF  

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i063_u()
            END IF


        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i063_r()
            END IF            		

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
            
        ON ACTION next
            CALL i063_fetch('N')

        ON ACTION previous
            CALL i063_fetch('P')    

        ON ACTION jump
            CALL i063_fetch('/')

        ON ACTION first
            CALL i063_fetch('F')

        ON ACTION last
            CALL i063_fetch('L')

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
              IF g_hrcw.hrcw01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrcw01"
                 LET g_doc.value1 = g_hrcw.hrcw01
                 CALL cl_doc()
              END IF
           END IF
           	
        ON ACTION exporttoexcel   #No.FUN-4B0020
           LET g_action_choice = 'exporttoexcel'
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcw_b),'','')
           END IF   	
    END MENU

END FUNCTION

FUNCTION i063_a()
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING	
DEFINE l_no         LIKE type_file.chr10
DEFINE l_sql        STRING
DEFINE l_hrcw01     LIKE  hrcw_file.hrcw01

    CLEAR FORM                                   #
    INITIALIZE g_hrcw.* LIKE hrcw_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrcw.hrcwuser = g_user
        LET g_hrcw.hrcworiu = g_user
        LET g_hrcw.hrcworig = g_grup
        LET g_hrcw.hrcwgrup = g_grup               #
        LET g_hrcw.hrcwdate = g_today
        LET g_hrcw.hrcwacti = 'Y'
        LET g_hrcw.hrcw08 = 'N'

        CALL i063_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrcw.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        	
        LET l_year=YEAR(g_today) USING "&&&&"
        LET l_month=MONTH(g_today) USING "&&"
        LET l_day=DAY(g_today) USING "&&"
        LET l_year=l_year.trim()
        LET l_month=l_month.trim()
        LET l_day=l_day.trim()
        LET g_hrcw.hrcw01=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
        LET l_hrcw01=g_hrcw.hrcw01,"%"
        LET l_sql="SELECT MAX(hrcw01) FROM hrcw_file",
                  " WHERE hrcw01 LIKE '",l_hrcw01,"'"
        PREPARE i063_hrcw01 FROM l_sql
        EXECUTE i063_hrcw01 INTO g_hrcw.hrcw01
        IF cl_null(g_hrcw.hrcw01) THEN 
           LET g_hrcw.hrcw01=l_hrcw01[1,8],'0001'
        ELSE
           LET l_no=g_hrcw.hrcw01[9,12]
           LET l_no=l_no+1 USING "&&&&"
           LET g_hrcw.hrcw01=l_hrcw01[1,8],l_no
        END IF
        	
        INSERT INTO hrcw_file VALUES(g_hrcw.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcw_file",g_hrcw.hrcw01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrcw01 INTO g_hrcw.hrcw01 FROM hrcw_file WHERE hrcw01 = g_hrcw.hrcw01
            CALL i063_b_fill(g_wc)
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION

FUNCTION i063_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   
   DISPLAY BY NAME
      g_hrcw.hrcw02,g_hrcw.hrcw03,g_hrcw.hrcw04,
      g_hrcw.hrcw05,g_hrcw.hrcw06,g_hrcw.hrcw07,g_hrcw.hrcw08,
      g_hrcw.hrcw09

   INPUT BY NAME
      g_hrcw.hrcw02,g_hrcw.hrcw03,g_hrcw.hrcw04,
      g_hrcw.hrcw05,g_hrcw.hrcw06,g_hrcw.hrcw07,g_hrcw.hrcw08,
      g_hrcw.hrcw09
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
         	    	    	 		                     	  	                    	  	   	 	                                             	    		  	      	

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

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

FUNCTION i063_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrcw.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i063_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i063_count
    FETCH i063_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i063_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcw.hrcw01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcw.* TO NULL
    ELSE
        CALL i063_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i063_b_fill(g_wc)
    END IF
END FUNCTION

FUNCTION i063_fetch(p_flhrcw)
    DEFINE p_flhrcw         LIKE type_file.chr1

    CASE p_flhrcw
        WHEN 'N' FETCH NEXT     i063_cs INTO g_hrcw.hrcw01
        WHEN 'P' FETCH PREVIOUS i063_cs INTO g_hrcw.hrcw01
        WHEN 'F' FETCH FIRST    i063_cs INTO g_hrcw.hrcw01
        WHEN 'L' FETCH LAST     i063_cs INTO g_hrcw.hrcw01
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
            FETCH ABSOLUTE g_jump i063_cs INTO g_hrcw.hrcw01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrcw.hrcw01,SQLCA.sqlcode,0)
        INITIALIZE g_hrcw.* TO NULL
        LET g_hrcw.hrcw01 = NULL
        RETURN
    ELSE
      CASE p_flhrcw
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrcw.* FROM hrcw_file    
       WHERE hrcw01 = g_hrcw.hrcw01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrcw_file",g_hrcw.hrcw01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i063_show()                 
    END IF
END FUNCTION

FUNCTION i063_show()

    LET g_hrcw_t.* = g_hrcw.*
    DISPLAY BY NAME g_hrcw.hrcw02,g_hrcw.hrcw03,
                    g_hrcw.hrcw04,g_hrcw.hrcw05,g_hrcw.hrcw06,
                    g_hrcw.hrcw07,g_hrcw.hrcw08,g_hrcw.hrcw09
    CALL cl_show_fld_cont()
END FUNCTION


FUNCTION i063_u()
    IF g_hrcw.hrcw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrcw.* FROM hrcw_file WHERE hrcw01=g_hrcw.hrcw01
    IF g_hrcw.hrcwacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i063_cl USING g_hrcw.hrcw01
    IF STATUS THEN
       CALL cl_err("OPEN i063_cl:", STATUS, 1)
       CLOSE i063_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i063_cl INTO g_hrcw.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcw.hrcw01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i063_show()                          
    WHILE TRUE
        CALL i063_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrcw.*=g_hrcw_t.*
            CALL i063_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrcw.hrcwmodu=g_user
        LET g_hrcw.hrcwdate=g_today	
        UPDATE hrcw_file SET hrcw_file.* = g_hrcw.*    
            WHERE hrcw01 = g_hrcw_t.hrcw01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrcw_file",g_hrcw.hrcw01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i063_show()	
        EXIT WHILE
    END WHILE
    CLOSE i063_cl
    COMMIT WORK
    CALL i063_b_fill(g_wc)
END FUNCTION


FUNCTION i063_r()
    IF g_hrcw.hrcw01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i063_cl USING g_hrcw.hrcw01
    IF STATUS THEN
       CALL cl_err("OPEN i063_cl:", STATUS, 0)
       CLOSE i063_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i063_cl INTO g_hrcw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcw.hrcw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i063_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrcw01"
       LET g_doc.value1 = g_hrcw.hrcw01
       CALL cl_del_doc()
       
       DELETE FROM hrcw_file WHERE hrcw01 = g_hrcw.hrcw01
       
       CLEAR FORM
       OPEN i063_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i063_cl
          CLOSE i063_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i063_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i063_cl
          CLOSE i063_count
          COMMIT WORK
          CALL i063_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i063_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i063_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i063_fetch('/')
       END IF
    END IF
    CLOSE i063_cl
    COMMIT WORK
    CALL i063_b_fill(g_wc)
END FUNCTION
	
FUNCTION i063_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrcw_b.clear()
        
        LET l_sql=" SELECT hrcw01,hrcw05,hrcw02,hrcw03,hrcw04,hrcw06,hrcw07 ",
                  "   FROM hrcw_file WHERE ",p_wc CLIPPED,
                  "  ORDER BY hrcw05,hrcw01 "
                  
        PREPARE i063_b_pre FROM l_sql
        DECLARE i063_b_cs CURSOR FOR i063_b_pre
        
        LET l_i=1
        
        FOREACH i063_b_cs INTO g_hrcw_b[l_i].*
              
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrcw_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrcw_b TO s_hrcw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION
	
FUNCTION i063_b_menu()
   DEFINE   l_priv1   LIKE zy_file.zy03,           # 使用者執行權限
            l_priv2   LIKE zy_file.zy04,           # 使用者資料權限
            l_priv3   LIKE zy_file.zy05            # 使用部門資料權限
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i063_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrcw_file.*
           INTO g_hrcw.*
           FROM hrcw_file
          WHERE hrcw01=g_hrcw_b[l_ac].hrcw01
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i063_fetch('/')
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
               CALL i063_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i063_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i063_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i063_u()
            END IF
            EXIT WHILE        	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcw_b),'','')
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


FUNCTION i063_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrcw_b TO s_hrcw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i063_fetch('/')
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
         CALL i063_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()           
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DISPLAY

      ON ACTION first
         CALL i063_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i063_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i063_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i063_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i063_fetch('L')
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
