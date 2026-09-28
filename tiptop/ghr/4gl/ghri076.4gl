# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri076.4gl
# Descriptions...: 
# Date & Author..: 05/07/13 by zhangbo

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrdh         RECORD LIKE hrdh_file.*    
DEFINE g_hrdh_t       RECORD LIKE hrdh_file.*             
DEFINE g_sql         STRING,                      
       g_wc          STRING,                     
       g_wc2         STRING
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
 
   OPEN WINDOW i076_w WITH FORM "ghr/42f/ghri076"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_set_combo_items("hrdh02",NULL,NULL)
   CALL cl_set_combo_items("hrdh03",NULL,NULL)
   #参数类别
   CALL i076_get_items('605') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdh02",l_name,l_items)
   #参数类型
   CALL i076_get_items('606') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdh03",l_name,l_items)
     
      
   LET g_forupd_sql =" SELECT * FROM hrdh_file ",
                      "  WHERE hrdh01 = ? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i076_cl CURSOR FROM g_forupd_sql
      
   CALL cl_ui_init() 
   CALL i076_menu()
   CLOSE WINDOW i076_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i076_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i076_get_items_pre FROM l_sql
       DECLARE i076_get_items CURSOR FOR i076_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i076_get_items INTO l_hrag06,l_hrag07
          CASE p_hrag01
          	 WHEN '605'
          	      IF l_hrag06 != '002' THEN
          	      	 CONTINUE FOREACH
          	      END IF
          	 WHEN '606'
          	      IF l_hrag06 !='002' AND l_hrag06 != '003' AND l_hrag06 !='004' THEN
          	      	 CONTINUE FOREACH
          	      END IF
          END CASE 	      		       		 
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
	
FUNCTION i076_curs()
    CLEAR FORM
    INITIALIZE g_hrdh.* TO NULL
    CONSTRUCT BY NAME g_wc ON                              
        hrdh02,hrdh03,hrdh06,hrdh07,
        hrdh09,hrdh08,hrdh11

        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrdh07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa10"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdh.hrdh07
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdh07
                 NEXT FIELD hrdh07
             
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrchuser', 'hrchgrup')

    LET g_sql = "SELECT DISTINCT hrdh01 FROM hrdh_file",                       #
                " WHERE ",g_wc CLIPPED,
                "   AND hrdh02='002' ",
                "   AND (hrdh03='002' OR hrdh03='003' OR hrdh03='004') ",
                " ORDER BY hrdh01"
    PREPARE i076_prepare FROM g_sql
    DECLARE i076_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i076_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrdh01) FROM hrdh_file",
                " WHERE ",g_wc CLIPPED,
                "   AND hrdh02='002' ",
                "   AND (hrdh03='002' OR hrdh03='003' OR hrdh03='004') "
    PREPARE i076_precount FROM g_sql
    DECLARE i076_count CURSOR FOR i076_precount
END FUNCTION	
	
FUNCTION i076_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        #add by zhangbo130906---begin
        ON ACTION xzcsll
           LET g_action_choice="xzcsll"
           IF cl_chk_act_auth() THEN
              CALL cl_cmdrun_wait("ghrq076")
           END IF 
        #add by zhangbo130906---end

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i076_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i076_q()
            END IF

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i076_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i076_r()
            END IF

       #ON ACTION reproduce
       #     LET g_action_choice="reproduce"
       #     IF cl_chk_act_auth() THEN
       #          CALL i076_copy()
       #     END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        
        ON ACTION next
            CALL i076_fetch('N')

        ON ACTION previous
            CALL i076_fetch('P')
        
        ON ACTION jump
            CALL i076_fetch('/')

        ON ACTION first
            CALL i076_fetch('F')

        ON ACTION last
            CALL i076_fetch('L')

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

        #mark by zhangbo130906---begin
        #ON ACTION related_document
        #   LET g_action_choice="related_document"
        #   IF cl_chk_act_auth() THEN
        #      IF g_hrdh.hrdh01 IS NOT NULL THEN
        #         LET g_doc.column1 = "hrdh01"
        #         LET g_doc.value1 = g_hrdh.hrdh01
        #         CALL cl_doc()
        #      END IF
        #   END IF
        #mark by zhangbo130906---end
    END MENU
    
END FUNCTION
	
FUNCTION i076_a()
DEFINE l_no     LIKE    type_file.chr10        #add by zhangbo130724

    CLEAR FORM                                   #
    INITIALIZE g_hrdh.* LIKE hrdh_file.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrdh.hrdh02 = '002'
    	LET g_hrdh.hrdh08 = 0
        LET g_hrdh.hrdh10 = 'N'
        LET g_hrdh.hrdhuser = g_user
        LET g_hrdh.hrdhoriu = g_user
        LET g_hrdh.hrdhorig = g_grup
        LET g_hrdh.hrdhgrup = g_grup               #
        LET g_hrdh.hrdhdate = g_today
        LET g_hrdh.hrdhacti = 'Y'
        CALL i076_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrdh.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        
        SELECT MAX(hrdh01) INTO g_hrdh.hrdh01 FROM hrdh_file 
        IF cl_null(g_hrdh.hrdh01) THEN
        	 LET g_hrdh.hrdh01=1
        ELSE
        	 LET g_hrdh.hrdh01=g_hrdh.hrdh01+1
        END IF
        
        #add by zhangbo130724---begin
        LET l_no=g_hrdh.hrdh01
        CASE g_hrdh.hrdh03
           WHEN '002' LET g_hrdh.hrdh12="hrdr",l_no
           WHEN '003' LET g_hrdh.hrdh12="hrdpb",l_no
           WHEN '004' LET g_hrdh.hrdh12="hrdh",l_no
        END CASE              
        #add by zhangbo130724---end  
      
        SELECT F_TRANS_PINYIN_CAPITAL(g_hrdh.hrdh06) INTO g_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
		 	 
        INSERT INTO hrdh_file VALUES(g_hrdh.*)     #
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdh_file",g_hrdh.hrdh01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrdh01 INTO g_hrdh.hrdh01 FROM hrdh_file WHERE hrdh01 = g_hrdh.hrdh01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
	
FUNCTION i076_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hrdh07_1    LIKE hraa_file.hraa12
   DEFINE l_sql         STRING

   DISPLAY BY NAME
      g_hrdh.hrdh02,g_hrdh.hrdh03,g_hrdh.hrdh07,
      g_hrdh.hrdh06,g_hrdh.hrdh09,g_hrdh.hrdh08,g_hrdh.hrdh11

   INPUT BY NAME
      g_hrdh.hrdh02,g_hrdh.hrdh03,g_hrdh.hrdh07,
      g_hrdh.hrdh06,g_hrdh.hrdh09,g_hrdh.hrdh08,g_hrdh.hrdh11
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          IF g_hrdh.hrdh03 = '003' THEN
          	 CALL cl_set_comp_entry("hrdh08",TRUE)
          ELSE
          	 LET g_hrdh.hrdh08=0
          	 DISPLAY BY NAME g_hrdh.hrdh08
          	 CALL cl_set_comp_entry("hrdh08",FALSE)
          END IF

      ON CHANGE hrdh03
         IF g_hrdh.hrdh03 = '003' THEN
            CALL cl_set_comp_entry("hrdh08",TRUE)
         ELSE
            LET g_hrdh.hrdh08=0
            DISPLAY BY NAME g_hrdh.hrdh08
            CALL cl_set_comp_entry("hrdh08",FALSE)
         END IF
          	 
           
      
      AFTER FIELD hrdh07
         IF NOT cl_null(g_hrdh.hrdh07) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=g_hrdh.hrdh07
         	                                            AND hraaacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err('无此公司编号','!',0)
         	  	 NEXT FIELD hrdh07
         	  END IF
         	  
         	  SELECT hraa12 INTO l_hrdh07_1 FROM hraa_file WHERE hraa01=g_hrdh.hrdh07
         	  DISPLAY l_hrdh07_1 TO hrdh07_1	
         	           	    	
         END IF
         	
     AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
        

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrdh07)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa10"
              LET g_qryparam.default1 = g_hrdh.hrdh07
              CALL cl_create_qry() RETURNING g_hrdh.hrdh07
              DISPLAY BY NAME g_hrdh.hrdh07
              NEXT FIELD hrdh07   

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
	
FUNCTION i076_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdh.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i076_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i076_count
    FETCH i076_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i076_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdh.hrdh01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdh.* TO NULL
    ELSE
        CALL i076_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i076_fetch(p_flhrdh)
    DEFINE p_flhrdh         LIKE type_file.chr1

    CASE p_flhrdh
        WHEN 'N' FETCH NEXT     i076_cs INTO g_hrdh.hrdh01
        WHEN 'P' FETCH PREVIOUS i076_cs INTO g_hrdh.hrdh01
        WHEN 'F' FETCH FIRST    i076_cs INTO g_hrdh.hrdh01
        WHEN 'L' FETCH LAST     i076_cs INTO g_hrdh.hrdh01
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
            FETCH ABSOLUTE g_jump i076_cs INTO g_hrdh.hrdh01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdh.hrdh01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdh.* TO NULL
        LET g_hrdh.hrdh01 = NULL
        RETURN
    ELSE
      CASE p_flhrdh
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrdh.* FROM hrdh_file    
       WHERE hrdh01 = g_hrdh.hrdh01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrdh_file",g_hrdh.hrdh01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i076_show()                 
    END IF
END FUNCTION			
	
FUNCTION i076_show()
DEFINE l_hrdh07_1     LIKE     hraa_file.hraa12
    LET g_hrdh_t.* = g_hrdh.*
    DISPLAY BY NAME g_hrdh.hrdh02,g_hrdh.hrdh03,g_hrdh.hrdh06,g_hrdh.hrdh07,
                    g_hrdh.hrdh09,g_hrdh.hrdh08,g_hrdh.hrdh11
    SELECT hraa12 INTO l_hrdh07_1 FROM hraa_file WHERE hraa01=g_hrdh.hrdh07
    DISPLAY l_hrdh07_1 TO hrdh07_1
    
    CALL cl_show_fld_cont()
END FUNCTION
	
FUNCTION i076_u()
    IF g_hrdh.hrdh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_hrdh.hrdh10='Y' THEN
    	 CALL cl_err('该参数已启用,不可更改','!',0)
    	 RETURN
    END IF	
    SELECT * INTO g_hrdh.* FROM hrdh_file WHERE hrdh01=g_hrdh.hrdh01
    IF g_hrdh.hrdhacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i076_cl USING g_hrdh.hrdh01
    IF STATUS THEN
       CALL cl_err("OPEN i076_cl:", STATUS, 1)
       CLOSE i076_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i076_cl INTO g_hrdh.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdh.hrdh01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i076_show()                          
    WHILE TRUE
        CALL i076_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdh.*=g_hrdh_t.*
            CALL i076_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        LET g_hrdh.hrdhmodu=g_user
        LET g_hrdh.hrdhdate=g_today	

        SELECT F_TRANS_PINYIN_CAPITAL(g_hrdh.hrdh06) INTO g_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821

        UPDATE hrdh_file SET hrdh_file.* = g_hrdh.*    
            WHERE hrdh01 = g_hrdh_t.hrdh01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdh_file",g_hrdh.hrdh01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
#20150122 add by yinbq for 调整薪资公式中的引用项目，确保薪资公式中的中文显示与调整后的名称一致
        UPDATE hrdka_file SET hrdka05=(SELECT hrdh06 FROM hrdh_file WHERE hrdh12=hrdka04)
        WHERE EXISTS (SELECT 1 FROM hrdh_file WHERE hrdh12=hrdka04 AND hrdka05<>hrdh06)
#20150122 add by yinbq for 调整薪资公式中的引用项目，确保薪资公式中的中文显示与调整后的名称一致
        CALL i076_show()	
        EXIT WHILE
    END WHILE
    CLOSE i076_cl
    COMMIT WORK
END FUNCTION
	

FUNCTION i076_r()
DEFINE l_n LIKE type_file.num5 
    IF g_hrdh.hrdh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    	
    IF g_hrdh.hrdh10='Y' THEN
    	 CALL cl_err('该参数已启用,不可更改','!',0)
    	 RETURN
    END IF
    		 	
    BEGIN WORK

    OPEN i076_cl USING g_hrdh.hrdh01
    IF STATUS THEN
       CALL cl_err("OPEN i076_cl:", STATUS, 0)
       CLOSE i076_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i076_cl INTO g_hrdh.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdh.hrdh01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i076_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrdh01"
       LET g_doc.value1 = g_hrdh.hrdh01

       CALL cl_del_doc()
       
       SELECT COUNT(*) INTO l_n FROM hrdka_file WHERE hrdka04=g_hrdh.hrdh12
       IF l_n > 0 THEN
          CALL cl_err('正在使用的参数不能删除','!',1) 
       ELSE
          DELETE FROM hrdh_file WHERE hrdh01 = g_hrdh.hrdh01
       END IF

       CLEAR FORM
       OPEN i076_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i076_cl
          CLOSE i076_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i076_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i076_cl
          CLOSE i076_count
          COMMIT WORK
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i076_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i076_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i076_fetch('/')
       END IF
    END IF
    CLOSE i076_cl
    COMMIT WORK
END FUNCTION	
	
				 
      
