# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri078.4gl
# Descriptions...: 
# Date & Author..: 06/09/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_hrdk     RECORD LIKE   hrdk_file.*
DEFINE  g_hrdk_t   RECORD LIKE   hrdk_file.*
DEFINE  g_hrdk_b  DYNAMIC ARRAY OF RECORD
        hrdk01_b    LIKE   hrdk_file.hrdk01,
        hrdk02_b    LIKE   hrdk_file.hrdk02,
        hrdk02_1_b  LIKE   hraa_file.hraa12,
        hrdk03_b    LIKE   hrdk_file.hrdk03,
        hrdk04_b    LIKE   hrdk_file.hrdk04,
        hrdk05_b    LIKE   hrdk_file.hrdk05,
        hrdk06_b    LIKE   hrdk_file.hrdk06,
        hrdk21_b    LIKE   hrdk_file.hrdk21,
        hrdk07_b    LIKE   hrdk_file.hrdk07,
        hrdk08_b    LIKE   hrdk_file.hrdk08,
        hrdk13_b    LIKE   hrdk_file.hrdk13,
        hrdk15_b    LIKE   hrdk_file.hrdk15
                  END RECORD
DEFINE  g_type     LIKE   hrdh_file.hrdh02
DEFINE  g_forupd_sql        STRING
DEFINE  g_before_input_done LIKE type_file.num5
DEFINE  g_rec_b,l_ac             LIKE type_file.num5
DEFINE  g_wc   STRING
DEFINE  g_sql  STRING
DEFINE  g_row_count  LIKE type_file.num5
DEFINE  g_curs_index LIKE type_file.num5
DEFINE  g_jump       LIKE type_file.num10
DEFINE  g_no_ask     LIKE type_file.num5
DEFINE  g_str        STRING
DEFINE  g_msg        LIKE type_file.chr1000
DEFINE  g_chr        LIKE type_file.chr1
DEFINE  g_flag       LIKE type_file.chr1
DEFINE  g_bp_flag    LIKE type_file.chr1                     
DEFINE  g_key         LIKE type_file.chr100
                    
MAIN
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
    DEFINE l_name   STRING
    DEFINE l_items  STRING
    DEFINE l_str    LIKE  type_file.chr10


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
  
   LET l_str= ASCII 65
   LET g_key=ASCII 65
 
   INITIALIZE g_hrdk.* TO NULL

   LET g_forupd_sql = "SELECT * FROM hrdk_file WHERE hrdk01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i078_cl CURSOR FROM g_forupd_sql                 
   
   LET p_row=15
   LET p_col=10
   OPEN WINDOW i078_w AT p_row,p_col 
     WITH FORM "ghr/42f/ghri078"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()

   CALL cl_set_comp_visible("hrdk10",FALSE)    #add by zhangbo130906
   
   CALL cl_set_combo_items("hrdk04",NULL,NULL)
   CALL cl_set_combo_items("hrdk05",NULL,NULL)
   CALL cl_set_combo_items("hrdk13",NULL,NULL)
   CALL cl_set_combo_items("hrdk21",NULL,NULL)    #add by zhangbo130828
   CALL cl_set_combo_items("hrdk04_b",NULL,NULL)
   CALL cl_set_combo_items("hrdk05_b",NULL,NULL)
   CALL cl_set_combo_items("hrdk13_b",NULL,NULL)
   CALL cl_set_combo_items("hrdk21_b",NULL,NULL)    #add by zhangbo130828
   
   #计税方式
   CALL i078_get_items('604') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdk04",l_name,l_items)
   #进位方式
   CALL i078_get_items('603') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdk05",l_name,l_items)
   #项目分类
   CALL i078_get_items('650') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdk13",l_name,l_items)

   #add by zhangbo130828----begin
   #薪资收入分类
   CALL i078_get_items('655') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdk21",l_name,l_items)
   #add by zhangbo130828----end
   #计税方式
   CALL i078_get_items('604') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdk04_b",l_name,l_items)
   #进位方式
   CALL i078_get_items('603') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdk05_b",l_name,l_items)
   #项目分类
   CALL i078_get_items('650') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdk13_b",l_name,l_items)

   #add by zhangbo130828----begin
   #薪资收入分类
   CALL i078_get_items('655') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdk21_b",l_name,l_items)
   #add by zhangbo130828----end
   
   LET g_action_choice=""
   CALL i078_menu()
 
   CLOSE WINDOW i078_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN

FUNCTION i078_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i078_get_items_pre FROM l_sql
       DECLARE i078_get_items CURSOR FOR i078_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i078_get_items INTO l_hrag06,l_hrag07
             		       		 
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

FUNCTION i078_curs()

    CLEAR FORM
    INITIALIZE g_hrdk.* TO NULL
    CONSTRUCT BY NAME g_wc ON                              
        hrdk02,hrdk03,hrdk04,hrdk05,hrdk06,
        hrdk07,hrdk08,hrdk09,hrdk10,hrdk11,hrdk12,hrdk13,hrdk21,     #mod by zhangbo130828---add hrdk21
        hrdk22                                                       #add by zhangbo130911
        
        BEFORE CONSTRUCT                                    
           CALL cl_qbe_init()                               

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrdk02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa10"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdk.hrdk02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdk02
                 NEXT FIELD hrdk02

              #add by zhangbo130911---begin
              WHEN INFIELD(hrdk22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrds01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrdk.hrdk22
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdk22
                 NEXT FIELD hrdk22
              #add by zhangbo130911---end

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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrdkuser', 'hrdkgrup')  #
                                                                     #

    LET g_sql = "SELECT hrdk01 FROM hrdk_file ",                       #
                " WHERE ",g_wc CLIPPED, " ORDER BY TO_NUMBER(hrdk01)"     #mod by zhangbo130922
    PREPARE i078_prepare FROM g_sql
    DECLARE i078_cs                                                  # 
        SCROLL CURSOR WITH HOLD FOR i078_prepare

    LET g_sql = "SELECT COUNT(DISTINCT hrdk01) FROM hrdk_file WHERE ",g_wc CLIPPED
    PREPARE i078_precount FROM g_sql
    DECLARE i078_count CURSOR FOR i078_precount
END FUNCTION 
	
FUNCTION i078_menu()
    DEFINE l_cmd    STRING

    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
        
        ON ACTION item_list
           LET g_action_choice = ""  #MOD-8A0193 add
           CALL i078_b_menu()   #MOD-8A0193
           LET g_action_choice = ""  #MOD-8A0193 add   
           
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i078_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i078_q()
            END IF       

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i078_u()
            END IF

        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i078_r()
            END IF 
            	
        ON ACTION edit_fml
           LET g_action_choice="edit_fml"
           IF cl_chk_act_auth() THEN
              CALL i078_edit()
           END IF  
            	
        ON ACTION formula_edit
           LET g_action_choice="formula_edit"
           IF cl_chk_act_auth() THEN
              CALL i078_formula_edit()
           END IF   	  	

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
            
        ON ACTION next
            CALL i078_fetch('N')

        ON ACTION previous
            CALL i078_fetch('P')    

        ON ACTION jump
            CALL i078_fetch('/')

        ON ACTION first
            CALL i078_fetch('F')

        ON ACTION last
            CALL i078_fetch('L')

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
        
        #mark by zhangbo130909---begin  
        #ON ACTION related_document
        #   LET g_action_choice="related_document"
        #   IF cl_chk_act_auth() THEN
        #      IF g_hrdk.hrdk01 IS NOT NULL THEN
        #         LET g_doc.column1 = "hrdk01"
        #         LET g_doc.value1 = g_hrdk.hrdk01
        #         CALL cl_doc()
        #      END IF
        #   END IF
        #mark by zhangbo130909---end 
           	
    END MENU

END FUNCTION	 
	
FUNCTION i078_a()
DEFINE l_success    LIKE   type_file.num5
DEFINE l_no         LIKE   type_file.num5	

    CLEAR FORM                                   #
    INITIALIZE g_hrdk.* LIKE hrdk_file.*
    INITIALIZE g_type TO NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_hrdk.hrdkuser = g_user
        LET g_hrdk.hrdkoriu = g_user
        LET g_hrdk.hrdkorig = g_grup
        LET g_hrdk.hrdkgrup = g_grup               #
        LET g_hrdk.hrdkdate = g_today
        LET g_hrdk.hrdkacti = 'Y'
        LET g_hrdk.hrdk07 = 'N'
        LET g_hrdk.hrdk08 = 'N'
        LET g_hrdk.hrdk09 = 'N'
        LET g_hrdk.hrdk11 = 'N'
        CALL i078_i("a")                         #
        IF INT_FLAG THEN                         #
            INITIALIZE g_hrdk.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        	
        IF g_hrdk.hrdk03 IS NULL THEN              #
            CONTINUE WHILE
        END IF
        	
        SELECT MAX(to_number(hrdk01)) INTO l_no FROM hrdk_file   #mod by zhangbo130912
        IF cl_null(l_no) THEN                                    #mod by zhangbo130912
        	 LET g_hrdk.hrdk01=1
        ELSE
           #LET l_no=g_hrdk.hrdk01                               #mark by zhangbo130912
           LET l_no=l_no+1 
        	 LET g_hrdk.hrdk01=l_no
        END IF
        	
        LET g_hrdk.hrdk16="res" CLIPPED,g_hrdk.hrdk01		 	  	 
        
        SELECT F_TRANS_PINYIN_CAPITAL(g_hrdk.hrdk03) INTO g_hrdk.hrdk19 FROM DUAL    #add by zhangbo130821
        IF cl_null(g_hrdk.hrdk19) THEN                                               #add by zhangbo130821
           LET g_hrdk.hrdk19=g_hrdk.hrdk03                                           #add by zhangbo130821
        END IF                                                                       #add by zhangbo130821
        
 	
        INSERT INTO hrdk_file VALUES(g_hrdk.*)     
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrdk_file",g_hrdk.hrdk01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
            CONTINUE WHILE
        ELSE
            SELECT hrdk01 INTO g_hrdk.hrdk01 FROM hrdk_file WHERE hrdk01 = g_hrdk.hrdk01
            CALL i078_b_fill(g_wc)
        END IF
        EXIT WHILE
    END WHILE
    	
END FUNCTION

#关键字---#
#参数-----$
#参数值---&
#包含项---？
#结果-----|
FUNCTION i078_i(p_cmd)

   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_input       LIKE type_file.chr1
   DEFINE l_n           LIKE type_file.num5
   DEFINE l_hrdk02_1    LIKE hraa_file.hraa12
   DEFINE l_sql         STRING
   DEFINE l_pos         LIKE type_file.num5
   DEFINE l_len,l_len1    LIKE type_file.num5
   DEFINE l_para        LIKE hrdh_file.hrdh06
   DEFINE l_name        LIKE type_file.chr1000
   DEFINE l_include     LIKE hrdk_file.hrdk03
   DEFINE l_str         STRING
   DEFINE l_hrds02      LIKE hrds_file.hrds02      #add by zhangbo130911
    
   DISPLAY BY NAME g_hrdk.hrdk02,g_hrdk.hrdk03,g_hrdk.hrdk04,
           g_hrdk.hrdk05,g_hrdk.hrdk06,g_hrdk.hrdk07,
           g_hrdk.hrdk08,g_hrdk.hrdk09,g_hrdk.hrdk10,
           g_hrdk.hrdk11,g_hrdk.hrdk12,g_hrdk.hrdk13,g_hrdk.hrdk21,     #mod by zhangbo130828---add hrdk21 
           g_hrdk.hrdk22,                                               #add by zhangbo130911
           g_hrdk.hrdk15
   
   INPUT BY NAME
      g_hrdk.hrdk02,g_hrdk.hrdk03,g_hrdk.hrdk04,
      g_hrdk.hrdk05,g_hrdk.hrdk06,g_hrdk.hrdk07,g_hrdk.hrdk08,
      g_hrdk.hrdk09,g_hrdk.hrdk10,g_hrdk.hrdk11,g_hrdk.hrdk12,
      g_hrdk.hrdk13,g_hrdk.hrdk21,         #mod by zhangbo130828---add hrdk21
      g_hrdk.hrdk22                        #add by zhangbo130911
   WITHOUT DEFAULTS 
   
      BEFORE INPUT  
          LET l_input='N'
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE          
          IF g_hrdk.hrdk09='N' THEN
          	 CALL cl_set_comp_entry("hrdk10",FALSE)
                 CALL cl_set_comp_entry("hrdk22",FALSE)          #add by zhangbo130911
                 CALL cl_set_comp_required("hrdk22",FALSE)       #add by zhangbo130911 
          ELSE
          	 CALL cl_set_comp_entry("hrdk10",TRUE)
                 CALL cl_set_comp_entry("hrdk22",TRUE)          #add by zhangbo130911
                 CALL cl_set_comp_required("hrdk22",TRUE)       #add by zhangbo130911
          END IF
          
          IF g_hrdk.hrdk11='N' THEN
          	 CALL cl_set_comp_entry("hrdk12",FALSE)
          ELSE
          	 CALL cl_set_comp_entry("hrdk12",TRUE)
          END IF 		 	 
      
      AFTER FIELD hrdk02
         IF NOT cl_null(g_hrdk.hrdk02) THEN
         	  LET l_n=0
         	  SELECT COUNT(*) INTO l_n FROM hraa_file WHERE hraa01=g_hrdk.hrdk02
         	                                            AND hraaacti='Y'
         	  IF l_n=0 THEN
         	  	 CALL cl_err(g_hrdk.hrdk02,'',0)
         	  	 NEXT FIELD hrdk02
         	  END IF
         	  	
         	  SELECT hraa12 INTO l_hrdk02_1 FROM hraa_file WHERE hraa01=g_hrdk.hrdk02
         	  DISPLAY l_hrdk02_1 TO hrdk02_1 	
         	                                           	  	
         END IF
         	
      AFTER FIELD hrdk03
         IF NOT cl_null(g_hrdk.hrdk03) THEN
         	  IF g_hrdk.hrdk03 != g_hrdk_t.hrdk03 OR g_hrdk_t.hrdk03 IS NULL THEN
         	     LET l_n=0
         	     SELECT COUNT(*) INTO l_n FROM hrdk_file WHERE hrdk03=g_hrdk.hrdk03
         	     IF l_n>0 THEN
         	     	  CALL cl_err('已设置该计算项','!',0)
         	     	  NEXT FIELD hrdk03
         	     END IF
         	  END IF
         END IF	  	    		     	
         
      AFTER FIELD hrdk09
         IF NOT cl_null(g_hrdk.hrdk09) THEN
            IF g_hrdk.hrdk09='N' THEN
         	   LET g_hrdk.hrdk10=''
                   LET g_hrdk.hrdk22=''              #add by zhangbo130911
                   LET l_hrds02=''                   #add by zhangbo130911 
          	   CALL cl_set_comp_entry("hrdk10",FALSE)
                   CALL cl_set_comp_entry("hrdk22",FALSE)          #add by zhangbo130911
                   CALL cl_set_comp_required("hrdk22",FALSE)       #add by zhangbo130911
          	   DISPLAY BY NAME g_hrdk.hrdk10
                   DISPLAY BY NAME g_hrdk.hrdk22                   #add by zhangbo130911 
                   DISPLAY l_hrds02 TO hrds02                      #add by zhangbo130911
            ELSE
          	   CALL cl_set_comp_entry("hrdk10",TRUE)
                   CALL cl_set_comp_entry("hrdk22",TRUE)          #add by zhangbo130911
                   CALL cl_set_comp_required("hrdk22",TRUE)       #add by zhangbo130911
            END IF
         END IF

      #add by zhangbo130911---begin
      AFTER FIELD hrdk22 
         IF NOT cl_null(g_hrdk.hrdk22) THEN
            LET l_n=0
            SELECT COUNT(*) INTO l_n FROM hrds_file WHERE hrds01=g_hrdk.hrdk22
            IF l_n=0 THEN
               CALL cl_err('无此福利项','!',0)
               NEXT FIELD hrdk22
            END IF

            SELECT hrds02 INTO l_hrds02 FROM hrds_file WHERE hrds01=g_hrdk.hrdk22
            DISPLAY l_hrds02 TO hrds02

         END IF
      #add by zhangbo130911---end  
         	
      AFTER FIELD hrdk11
         IF NOT cl_null(g_hrdk.hrdk11) THEN
         	  IF g_hrdk.hrdk11='N' THEN
         	  	 LET g_hrdk.hrdk12=''
          	   CALL cl_set_comp_entry("hrdk12",FALSE)
          	   DISPLAY BY NAME g_hrdk.hrdk12
            ELSE
          	   CALL cl_set_comp_entry("hrdk12",TRUE)
            END IF
         END IF 
         	
         	      
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF    

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrdk02)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa10"
              LET g_qryparam.default1 = g_hrdk.hrdk02
              CALL cl_create_qry() RETURNING g_hrdk.hrdk02
              DISPLAY BY NAME g_hrdk.hrdk02
              NEXT FIELD hrdk02

           #add by zhangbo130911---begin
           WHEN INFIELD(hrdk22)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrds01"
              LET g_qryparam.default1 = g_hrdk.hrdk22
              CALL cl_create_qry() RETURNING g_hrdk.hrdk22
              DISPLAY BY NAME g_hrdk.hrdk22
              NEXT FIELD hrdk22
           #add by zhangbo130911---end
           
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

{
#获取包含项	
FUNCTION i078_get_include()
DEFINE l_sql        STRING
DEFINE l_cnt        LIKE  type_file.num5
DEFINE l_i          LIKE  type_file.num5
DEFINE l_hrdk13     LIKE  hrdk_file.hrdk13
DEFINE l_hrag07     LIKE  hrag_file.hrag07

       CALL g_include.clear()
       LET l_cnt=1
       LET l_i=1
       
       LET l_sql=" SELECT DISTINCT hrdk13,hrag07 FROM hrdk_file,hrag_file ",
                 "  WHERE hrag01='650' ",
                 "    AND hrag06=hrdk13",
                 "    ORDER BY hrdk13 "
       PREPARE i078_inc_pre1 FROM l_sql
       DECLARE i078_inc1 CURSOR FOR i078_inc_pre1
       
       LET l_sql=" SELECT hrdk01,hrdk03 FROM hrdk_file WHERE hrdk13 = ? ",
                 "  ORDER BY hrdk01 "
       PREPARE i078_inc_pre2 FROM l_sql
       DECLARE i078_inc2 CURSOR FOR i078_inc_pre2          
       
       FOREACH i078_inc1 INTO l_hrdk13,l_hrag07
       
          LET g_include[l_cnt].id=''
          LET g_include[l_cnt].items=l_hrag07
          LET l_cnt=l_cnt+1
          
          FOREACH i078_inc2 USING l_hrdk13 INTO g_include[l_cnt].id,
                                               g_include[l_cnt].items
                            #USING l_hrdk13
             
             LET l_cnt=l_cnt+1
          END FOREACH
          
       END FOREACH        
       
       CALL g_include.deleteElement(l_cnt)   
       LET l_cnt=l_cnt-1
       LET g_rec_b3=l_cnt   
                    
END FUNCTION                 

#获取参数列
FUNCTION i078_get_para(p_type)
DEFINE  p_type     LIKE    hrdh_file.hrdh02
DEFINE  l_sql      STRING
DEFINE  l_cnt      LIKE    type_file.num5
          
        CALL g_para.clear()        

        LET l_sql=" SELECT hrdh12,hrdh06 FROM hrdh_file WHERE hrdh02='",p_type,"'",
                  "  ORDER BY hrdh01 "
        PREPARE i078_para_pre FROM l_sql
        DECLARE i078_para CURSOR FOR i078_para_pre
        
        LET l_cnt=1
        FOREACH i078_para INTO g_para[l_cnt].hrdh12,g_para[l_cnt].hrdh06
           
           LET l_cnt=l_cnt+1
           
        END FOREACH
        
        CALL g_para.deleteElement(l_cnt)   
        LET l_cnt=l_cnt-1
        LET g_rec_b1=l_cnt               
                          
END FUNCTION
	
#获取参数值
FUNCTION i078_get_val(p_name)       
DEFINE  p_name     LIKE    hrdh_file.hrdh06
END FUNCTION
	
#根据定义的规则,替换关键字,参数等,
#同时得到参数id,以"|"隔开
FUNCTION i078_get_formula()
DEFINE  l_str_buf          base.StringBuffer
DEFINE  l_start,l_end      LIKE type_file.num5
DEFINE  l_str              STRING
DEFINE  l_para             LIKE type_file.chr1000
DEFINE  lc_sub,lc_desc     LIKE type_file.chr1000
DEFINE  ls_sub            STRING
DEFINE  tok base.StringTokenizer
DEFINE  l_check     STRING
DEFINE  l_flag      LIKE  type_file.chr1
DEFINE  l_value     LIKE  type_file.chr1000
        
        #获取公式内容
        LET l_str=g_hrdk.hrdk15
        LET l_str_buf = base.StringBuffer.create()
        CALL l_str_buf.append(l_str)
        
        #查找并替换关键字,标识为#
        LET l_start = l_str_buf.getIndexOf('#',1)
        IF l_start > 0 THEN
           LET l_end = l_str_buf.getIndexOf('#',l_start+1)
        END IF
        WHILE ( l_end > 0 )
           LET lc_sub = l_str_buf.SubString(l_start+1,l_end-1)

           #如果##中间没有内容报错
           IF LENGTH(lc_sub CLIPPED) = 0 THEN
              CALL cl_err("##中间未包含关键字","!",1)
              RETURN '','',FALSE
           END IF

           LET lc_desc = ''
           
           CASE lc_sub
           	  WHEN "如果"          LET lc_desc="IF"
           	  WHEN "那么"          LET lc_desc="THEN"
           	  WHEN "否则"          LET lc_desc="ELSE"
           	  WHEN "如果完"        LET lc_desc="END IF"
           	  WHEN "并"            LET lc_desc="AND"
           	  WHEN "或"            LET lc_desc="OR"
           	  WHEN "非"            LET lc_desc="NOT"
           	  WHEN "分情况开始"    LET lc_desc="CASE"
           	  WHEN "分支条件"      LET lc_desc="WHEN"
           	  WHEN "分情况结束"    LET lc_desc="END CASE"
           	  
           END CASE   
           IF NOT lc_desc CLIPPED IS NULL THEN
              CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),
                                     lc_desc CLIPPED,0)
              
           ELSE
              CALL cl_err("没有此关键字","!",1)  
              RETURN '','',FALSE
           END IF

           LET l_start = l_str_buf.getIndexOf('#',1)
           LET l_end = l_str_buf.getIndexOf('#',l_start+1)
        END WHILE
        	
        IF (( l_start > 0 )AND( l_end = 0 )) THEN
           CALL cl_err("#必须成对出现","!",1)   #“#”必須成對出現
           RETURN '','',FALSE
        END IF
        
        #查找并替换参数,标识符为$
        LET l_start = l_str_buf.getIndexOf('$',1)
        IF l_start > 0 THEN
           LET l_end = l_str_buf.getIndexOf('$',l_start+1)
        END IF
        
        LET l_para=''
        	
        WHILE ( l_end > 0 )
           LET lc_sub = l_str_buf.SubString(l_start+1,l_end-1)

           #如果$$中间没有内容报错
           IF LENGTH(lc_sub CLIPPED) = 0 THEN
              CALL cl_err("$$中间未包含参数","!",1)
              RETURN '','',FALSE
           END IF

           LET lc_desc = ''
           SELECT hrdh12 INTO lc_desc FROM hrdh_file WHERE hrdh06=lc_sub
           
           IF NOT lc_desc CLIPPED IS NULL THEN           	  
           	  IF NOT cl_null(l_para) THEN
           	  	 #相同的参数只记录一次
           	  	 LET l_flag='Y'
           	  	 LET l_check=l_para
           	  	 LET l_check=l_check.trim()
           	  	 LET tok = base.StringTokenizer.create(l_check,"|")
           	  	 WHILE tok.hasMoreTokens()
                    LET l_value=tok.nextToken()
                    IF l_value=lc_desc THEN
                    	 LET l_flag='N'
                    	 EXIT WHILE
                    END IF	 
                 END WHILE
                 
                 IF l_flag='Y' THEN	
           	  	    LET l_para=l_para CLIPPED,"|",lc_desc
           	  	 END IF   
           	  ELSE
           	  	 LET l_para=lc_desc
           	  END IF	 	 
           	  	 
              CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),
                                     lc_desc CLIPPED,0)
           ELSE
              CALL cl_err("没有此参数","!",1)  
              RETURN '','',FALSE
           END IF

           LET l_start = l_str_buf.getIndexOf('$',1)
           LET l_end = l_str_buf.getIndexOf('$',l_start+1)
        END WHILE
        	
        IF (( l_start > 0 )AND( l_end = 0 )) THEN
           CALL cl_err("$必须成对出现","!",1)   #"$"必須成對出現
           RETURN '','',FALSE
        END IF
        	
        #查找并替换参数值,标识符为&
        LET l_start = l_str_buf.getIndexOf('&',1)
        IF l_start > 0 THEN
           LET l_end = l_str_buf.getIndexOf('&',l_start+1)
        END IF
        	
        WHILE ( l_end > 0 )
           LET lc_sub = l_str_buf.SubString(l_start+1,l_end-1)

           #如果$$中间没有内容报错
           IF LENGTH(lc_sub CLIPPED) = 0 THEN
              CALL cl_err("&&中间未包含参数","!",1)
              RETURN '','',FALSE
           END IF
           
           #取参数值逻辑还未给定,先MARK
           #LET lc_desc = ''
           #SELECT hrdh12 INTO lc_desc FROM hrdh_file WHERE hrdh06=lc_sub
           #
           #IF NOT lc_desc CLIPPED IS NULL THEN	 	 
           #	  	 
           #   CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),
           #                          lc_desc CLIPPED,0)
           #ELSE
           #   CALL cl_err("没有此参数","!",1)  
           #   RETURN '','',FALSE
           #END IF
           
           LET l_start = l_str_buf.getIndexOf('&',1)
           LET l_end = l_str_buf.getIndexOf('&',l_start+1)
        END WHILE
        	
        IF (( l_start > 0 )AND( l_end = 0 )) THEN
           CALL cl_err("&必须成对出现","！",1)   #"&"必須成對出現
           RETURN '','',FALSE
        END IF	
       
        #查找并替换包含项,标识符为？
        LET l_start = l_str_buf.getIndexOf('?',1)
        IF l_start > 0 THEN
           LET l_end = l_str_buf.getIndexOf('?',l_start+1)
        END IF
        	
        WHILE ( l_end > 0 )
           #LET lc_sub = l_str_buf.SubString(l_start+1,l_end-1)
           LET lc_sub = l_str_buf.SubString(l_start,l_end)
           LET ls_sub = l_str_buf.SubString(l_start+1,l_end-1)
           LET ls_sub = ls_sub.trim()
           LET lc_sub = ls_sub

           #如果$$中间没有内容报错
           IF LENGTH(lc_sub CLIPPED) = 0 THEN
              CALL cl_err("??中间未包含包含项","!",1)
              RETURN '','',FALSE
           END IF
           
           
           LET lc_desc = ''
           SELECT hrdk16 INTO lc_desc FROM hrdk_file WHERE hrdk03=lc_sub
           
           IF NOT lc_desc CLIPPED IS NULL THEN	 	 
           	  	 
              CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),
                                     lc_desc CLIPPED,0)
           ELSE
              CALL cl_err("没有此包含项","!",1)  
              RETURN '','',FALSE
           END IF
           
           LET l_start = l_str_buf.getIndexOf('?',1)
           LET l_end = l_str_buf.getIndexOf('?',l_start+1)
        END WHILE
        	
        IF (( l_start > 0 )AND( l_end = 0 )) THEN
           CALL cl_err("?必须成对出现","!",1)   #"?"必須成對出現
           RETURN '','',FALSE
        END IF
        	
        #查找并替换结果,标识符为|
        LET l_start = l_str_buf.getIndexOf('|',1)
        IF l_start > 0 THEN
           LET l_end = l_str_buf.getIndexOf('|',l_start+1)
        END IF
        	
        WHILE ( l_end > 0 )
           LET lc_sub = l_str_buf.SubString(l_start+1,l_end-1)

           #如果$$中间没有内容报错
           IF LENGTH(lc_sub CLIPPED) = 0 THEN
              CALL cl_err("||中间未包含包含项","!",1)
              RETURN '','',FALSE
           END IF
           	
           IF lc_sub != '结果' THEN
           	  CALL cl_err("||中间的值不是'结果' ","!",1)
              RETURN '','',FALSE
           END IF	
           
           LET lc_desc=g_hrdk.hrdk16
           
           IF NOT lc_desc CLIPPED IS NULL THEN	 	 
           	  	 
              CALL l_str_buf.replace(l_str_buf.subString(l_start,l_end),
                                     lc_desc CLIPPED,0)
           ELSE
              CALL cl_err("没有此结果","!",1)  
              RETURN '','',FALSE
           END IF
           
           LET l_start = l_str_buf.getIndexOf('|',1)
           LET l_end = l_str_buf.getIndexOf('|',l_start+1)
        END WHILE
        	
        IF (( l_start > 0 )AND( l_end = 0 )) THEN
           CALL cl_err("|必须成对出现","!",1)   #"?"必須成對出現
           RETURN '','',FALSE
        END IF		

        #将"[","]"替换为单引号"'"
        LET l_start = l_str_buf.getIndexOf('[',1)
        IF l_start>0 THEN
           CALL l_str_buf.replace("[","'",0)
        END IF
        
        LET l_start = l_str_buf.getIndexOf(']',1)
        IF l_start>0 THEN
           CALL l_str_buf.replace("]","'",0)
        END IF
	
        RETURN l_str_buf.toString(),l_para,TRUE	
           	
END FUNCTION	
}

	
FUNCTION i078_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrdk.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i078_curs()                      
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN i078_count
    FETCH i078_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i078_cs                           
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdk.hrdk03,SQLCA.sqlcode,0)
        INITIALIZE g_hrdk.* TO NULL
    ELSE
        CALL i078_fetch('F')              # 讀出TEMP第一筆並顯示
        CALL i078_b_fill(g_wc)
    END IF
END FUNCTION
	
FUNCTION i078_fetch(p_flhrdk)
    DEFINE p_flhrdk         LIKE type_file.chr1
    DEFINE l_str            STRING               #for test
    
    #for test
    LET l_str="res20:=FN_GETLASTVALUE('res08')"
    CALL cl_replace_str(l_str,'FN_GETLASTVALUE(','FN_GETLASTVALUE(p_hrat01,p_hrct11,') RETURNING l_str

    CASE p_flhrdk
        WHEN 'N' FETCH NEXT     i078_cs INTO g_hrdk.hrdk01
        WHEN 'P' FETCH PREVIOUS i078_cs INTO g_hrdk.hrdk01
        WHEN 'F' FETCH FIRST    i078_cs INTO g_hrdk.hrdk01
        WHEN 'L' FETCH LAST     i078_cs INTO g_hrdk.hrdk01
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
            FETCH ABSOLUTE g_jump i078_cs INTO g_hrdk.hrdk01
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrdk.hrdk01,SQLCA.sqlcode,0)
        INITIALIZE g_hrdk.* TO NULL
        LET g_hrdk.hrdk01 = NULL
        RETURN
    ELSE
      CASE p_flhrdk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrdk.* FROM hrdk_file    
       WHERE hrdk01 = g_hrdk.hrdk01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrdk_file",g_hrdk.hrdk01,"",SQLCA.sqlcode,"","",0)
    ELSE
        CALL i078_show()                 
    END IF
END FUNCTION
	
FUNCTION i078_show()
DEFINE l_hrdk02_1     LIKE     hraa_file.hraa12
DEFINE l_hrds02       LIKE     hrds_file.hrds02     #add by zhangbo130911

    LET g_hrdk_t.* = g_hrdk.*
    DISPLAY BY NAME g_hrdk.hrdk02,g_hrdk.hrdk03,g_hrdk.hrdk04,
            g_hrdk.hrdk05,g_hrdk.hrdk06,g_hrdk.hrdk07,
            g_hrdk.hrdk08,g_hrdk.hrdk09,g_hrdk.hrdk10,
            g_hrdk.hrdk11,g_hrdk.hrdk12,g_hrdk.hrdk13,g_hrdk.hrdk21,      #mod by zhangbo130828---add hrdk21
            g_hrdk.hrdk15

    SELECT hraa12 INTO l_hrdk02_1 FROM hraa_file WHERE hraa01=g_hrdk.hrdk02                                                                 
    DISPLAY l_hrdk02_1 TO hrdk02_1

    SELECT hrds02 INTO l_hrds02 FROM hrds_file WHERE hrds01=g_hrdk.hrdk22   #add by zhangbo130911
    DISPLAY l_hrds02 TO hrds02                                              #add by zhangbo130911

    CALL cl_show_fld_cont()
END FUNCTION	
	
FUNCTION i078_u()
DEFINE   l_success  LIKE  type_file.num5
DEFINE   l_hrdk20   LIKE  hrdk_file.hrdk20     #add by zhangbo130916

	
    IF g_hrdk.hrdk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    #add by zhangbo130916---begin
    SELECT hrdk20 INTO l_hrdk20 FROM hrdk_file WHERE hrdk01=g_hrdk.hrdk01
    IF l_hrdk20='Y' THEN
       CALL cl_err("此计算项正在编辑公式,请编辑完成后再更改","!",0)
       RETURN
    END IF
    #add by zhangbo130916---end

    
    SELECT * INTO g_hrdk.* FROM hrdk_file WHERE hrdk01=g_hrdk.hrdk01

    CALL cl_opmsg('u')
    BEGIN WORK

    OPEN i078_cl USING g_hrdk.hrdk01
    IF STATUS THEN
       CALL cl_err("OPEN i078_cl:", STATUS, 1)
       CLOSE i078_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i078_cl INTO g_hrdk.*               #
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdk.hrdk01,SQLCA.sqlcode,1)
        RETURN
    END IF              
    CALL i078_show()                          
    WHILE TRUE
        CALL i078_i("u")        		 	                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrdk.*=g_hrdk_t.*
            CALL i078_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF

        LET g_hrdk.hrdkmodu=g_user
        LET g_hrdk.hrdkdate=g_today	

        LET g_hrdk.hrdk19=''                                                         #add by zhangbo130821
        SELECT F_TRANS_PINYIN_CAPITAL(g_hrdk.hrdk03) INTO g_hrdk.hrdk19 FROM DUAL    #add by zhangbo130821
        IF cl_null(g_hrdk.hrdk19) THEN                                               #add by zhangbo130821
           LET g_hrdk.hrdk19=g_hrdk.hrdk03                                           #add by zhangbo130821
        END IF                                                                       #add by zhangbo130821

        UPDATE hrdk_file SET hrdk_file.* = g_hrdk.*    
            WHERE hrdk01 = g_hrdk_t.hrdk01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrdk_file",g_hrdk.hrdk01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i078_show()	
        EXIT WHILE
    END WHILE
    CLOSE i078_cl
    COMMIT WORK
    CALL i078_b_fill(g_wc)
END FUNCTION			

FUNCTION i078_r()
DEFINE   l_n  LIKE  type_file.num5

    IF g_hrdk.hrdk01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i078_cl USING g_hrdk.hrdk01
    IF STATUS THEN
       CALL cl_err("OPEN i078_cl:", STATUS, 0)
       CLOSE i078_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i078_cl INTO g_hrdk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrdk.hrdk01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i078_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrdk01"
       LET g_doc.value1 = g_hrdk.hrdk01
       CALL cl_del_doc()

       SELECT COUNT(*) INTO l_n FROM hrdka_file WHERE hrdka01<>g_hrdk.hrdk01 AND hrdka04=g_hrdk.hrdk16
       IF l_n > 0 THEN 
          CALL cl_err('薪资公式被其他公式引用,不能被删除','!',1)
       ELSE
          DELETE FROM hrdk_file WHERE hrdk01 = g_hrdk.hrdk01
          DELETE FROM hrdka_file WHERE hrdka01 = g_hrdk.hrdk01      #add by zhangbo131115
       END IF 
       CLEAR FORM
       OPEN i078_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE i078_cl
          CLOSE i078_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i078_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i078_cl
          CLOSE i078_count
          COMMIT WORK
          CALL i078_b_fill(g_wc)
          RETURN
       END IF
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i078_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i078_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i078_fetch('/')
       END IF
    END IF 
    CLOSE i078_cl
    COMMIT WORK
    CALL i078_b_fill(g_wc)
END FUNCTION
	
FUNCTION i078_edit()
DEFINE l_msg  LIKE type_file.chr1000
DEFINE l_hrdk20  LIKE   hrdk_file.hrdk20    
    
    IF cl_null(g_hrdk.hrdk01) THEN
    	 CALL cl_err('请先维护基本资料再编辑公式','!',1)
    	 RETURN
    END IF

    SELECT hrdk20 INTO l_hrdk20 FROM hrdk_file WHERE hrdk01=g_hrdk.hrdk01

    IF l_hrdk20='Y' THEN
       CALL cl_err('已有用户在编辑此公式,请稍后再编辑','!','1')
       RETURN
    ELSE
       UPDATE hrdk_file SET hrdk20='Y' WHERE hrdk01=g_hrdk.hrdk01
    END IF
    	
    LET l_msg="p_textedit '",g_hrdk.hrdk01,"'"
    CALL cl_cmdrun_wait(l_msg)

    UPDATE hrdk_file SET hrdk20=l_hrdk20 WHERE hrdk01=g_hrdk.hrdk01

    #No:150304----------
    UPDATE HRDKA_FILE
    SET HRDKA05 = (SELECT HRDK03 FROM HRDK_FILE WHERE 'res' || HRDK01 = HRDKA04)
        WHERE EXISTS (SELECT 1 FROM HRDK_FILE
         WHERE 'res' || HRDK01 = HRDKA04  AND HRDKA05 <> HRDK03)
           AND NOT EXISTS (SELECT 1 FROM hred_file WHERE HRDKA05 = hred02)
           
    #No:150304----------
           
    
           
    SELECT * INTO g_hrdk.* FROM hrdk_file WHERE hrdk01=g_hrdk.hrdk01
    CALL i078_show()		 	
END FUNCTION
	
FUNCTION i078_formula_edit()
DEFINE l_msg  LIKE type_file.chr1000
DEFINE l_hrdk20  LIKE   hrdk_file.hrdk20    
    
    IF cl_null(g_hrdk.hrdk01) THEN
    	 CALL cl_err('请先维护基本资料再编辑公式','!',1)
    	 RETURN
    END IF

    SELECT hrdk20 INTO l_hrdk20 FROM hrdk_file WHERE hrdk01=g_hrdk.hrdk01

    IF l_hrdk20='Y' THEN
       CALL cl_err('已有用户在编辑此公式,请稍后再编辑','!','1')
       RETURN
    ELSE
       UPDATE hrdk_file SET hrdk20='Y' WHERE hrdk01=g_hrdk.hrdk01
    END IF
    	
    LET l_msg="p_formulaedit '",g_hrdk.hrdk01,"'"
    CALL cl_cmdrun_wait(l_msg)

    UPDATE hrdk_file SET hrdk20=l_hrdk20 WHERE hrdk01=g_hrdk.hrdk01
    
    SELECT * INTO g_hrdk.* FROM hrdk_file WHERE hrdk01=g_hrdk.hrdk01
    CALL i078_show()		 	
END FUNCTION		

{	
FUNCTION i078_gen_hrdk15(p_str,p_pos)
DEFINE  l_len,l_len1    LIKE   type_file.num5
DEFINE  p_str           STRING
DEFINE  p_pos           LIKE   type_file.num5
DEFINE  l_sql           STRING	
DEFINE  l_str1,l_str2   LIKE  type_file.chr1000		
	       
	       LET l_str1=''
	       LET l_str2=''
	       LET l_len=0
         LET l_len1=0	
         #LET l_str="#AND#"
         IF g_hrdk.hrdk15 IS NULL THEN LET g_hrdk.hrdk15='' END IF
         LET l_sql="SELECT LENGTH('",g_hrdk.hrdk15 CLIPPED,"') FROM DUAL "
         PREPARE i078_fun_1 FROM l_sql
         EXECUTE i078_fun_1 INTO l_len
         LET l_sql="SELECT LENGTH('",p_str CLIPPED,"') FROM DUAL "
         PREPARE i078_fun_2 FROM l_sql
         EXECUTE i078_fun_2 INTO l_len1
         IF cl_null(l_len) THEN LET l_len=0 END IF
         IF cl_null(l_len1) THEN LET l_len1=0 END IF
         IF l_len < p_pos THEN LET l_len = p_pos END IF
         IF p_pos = 1 THEN
            LET g_hrdk.hrdk15 = p_str CLIPPED,g_hrdk.hrdk15 CLIPPED
         ELSE
         	  
            LET l_sql="SELECT substr('",g_hrdk.hrdk15,"',1,",p_pos-1,")||'",p_str CLIPPED,
                      "'||substr('",g_hrdk.hrdk15,"',",p_pos,",",l_len,")",
                      "  FROM DUAL "
            PREPARE i078_get_fun FROM l_sql
            EXECUTE i078_get_fun INTO g_hrdk.hrdk15
            #LET l_sql=" SELECT substr('",g_hrdk.hrdk15,"',1,",p_pos-1,") FROM DUAL"
            #PREPARE i078_get_fun1 FROM l_sql
            #EXECUTE i078_get_fun1 INTO l_str1
            #LET l_sql=" SELECT substr('",g_hrdk.hrdk15,"',",p_pos,",",l_len,") FROM DUAL"
            #PREPARE i078_get_fun2 FROM l_sql
            #EXECUTE i078_get_fun2 INTO l_str2
            #LET g_hrdk.hrdk15=l_str1,p_str CLIPPED,l_str2
         END IF   
            
         LET p_pos=p_pos+l_len1
         
         DISPLAY BY NAME g_hrdk.hrdk15
				                                                             
         RETURN g_hrdk.hrdk15,p_pos
         
END FUNCTION	

FUNCTION i078_date_fun()	
DEFINE p_row,p_col   LIKE type_file.num5
DEFINE l_date    DYNAMIC ARRAY OF RECORD 
         name    LIKE    type_file.chr100,
         des     LIKE    type_file.chr1000
                 END RECORD
DEFINE l_rec_b           LIKE type_file.num5
DEFINE i,l_ac_date,l_n        LIKE type_file.num5
DEFINE l_str             STRING 
                
       CALL l_date.clear()
       LET l_str=''
       
       LET p_row = 11 LET p_col = 3
       OPEN WINDOW i078_date AT p_row,p_col WITH FORM "ghr/42f/ghri078_date"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       
      
       CALL cl_ui_locale("ghri078_date")
       
       LET l_date[1].name="YEAR()"
       LET l_date[1].des="YEAR(日期):取日期的年"
       LET l_date[2].name="MONTH()"
       LET l_date[2].des="MONTH(日期):取日期的月"
       LET l_date[3].name="DAY()"
       LET l_date[3].des="DAY(日期):取日期的日"
       LET l_date[4].name="QUARTER()"
       LET l_date[4].des="QUARTER(日期):取日期所在的季度值"
       LET l_date[5].name="WEEK()"
       LET l_date[5].des="WEEK(日期):取日期在本年第几周"
       LET l_date[6].name="WEEKDAY()"
       LET l_date[6].des="WEEKDAY(日期):取日期是星期几"
       LET l_date[7].name="TODAY()"
       LET l_date[7].des="TODAY():取今天的日期"
       LET l_date[8].name="AGE()"
       LET l_date[8].des="AGE(日期):计算日期日到现在的年龄"
       LET l_date[9].name="MONTHAGE()"
       LET l_date[9].des="MONTHAGE(日期):计算日期月到现在的年龄"
       LET l_date[10].name="WORKAGE()"
       LET l_date[10].des="WORKAGE(日期):计算日期年份到现在年份的工龄"
       LET l_date[11].name="YEARS(,)"
       LET l_date[11].des="YEARS(日期1,日期2):计算日期2月到日期1的年数"                 	
		   LET l_date[12].name="MONTHS(,)"
       LET l_date[12].des="MONTHS(日期1,日期2):计算日期2月到日期1的月数"
       LET l_date[13].name="DAYS(,)"
       LET l_date[13].des="DAYS(日期1,日期2):计算日期2月到日期1的天数"
	     LET l_date[14].name="QUARTERS(,)"
       LET l_date[14].des="QUARTERS(日期1,日期2):计算日期2月到日期1的季度数"
       LET l_date[15].name="WEEKS(,)"
       LET l_date[15].des="WEEKS(日期1,日期2):计算日期2月到日期1的周数"
       LET l_date[16].name="DIFFDATE(,,1)"
       LET l_date[16].des="DIFFDATE(开始日期,结束日期,返回类型):根据返回类型,在日期区间内取值\n",
                          "返回类型=1:返回两个日期中间隔天数;\n",
                          "返回类型=2:返回两个日期中间隔的工作天数(从标准薪资日历中取区间,去假日);\n",
                          "返回类型=3:返回两个日期中间隔的工作天数(从标准薪资日历中取区间,去节假日);\n",
                          "返回类型=4:返回日历中两个日期中间隔的天数(去周六、周日);\n",
                          "返回类型=5:返回两个日期中间隔的工作天数(从考勤企业行事历中取区间,去假日);\n",
                          "返回类型=6:返回两个日期中间隔的工作天数(从考勤企业行事历中取区间,去节、假日);\n",
                          "注:如果开始日期或结束日期的值为空，则返回-9999;如果开始日期大于结束日期,则返回 -1"
                          
       LET l_rec_b=16
       
       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY l_date TO s_fun.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)

       BEFORE ROW
         LET l_ac_date = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf  
 
       ON ACTION accept
         LET l_str=l_date[l_ac_date].name
         EXIT DISPLAY
          
       END DISPLAY
       CALL cl_set_act_visible("accept,cancel", TRUE)
       CLOSE WINDOW i078_date
       
       RETURN l_str
       
END FUNCTION	
	
FUNCTION i078_dec_fun()		   	   
DEFINE p_row,p_col   LIKE type_file.num5
DEFINE l_dec    DYNAMIC ARRAY OF RECORD 
         name    LIKE    type_file.chr100,
         des     LIKE    type_file.chr1000
                 END RECORD
DEFINE l_rec_b           LIKE type_file.num5
DEFINE i,l_ac_dec,l_n        LIKE type_file.num5
DEFINE l_str             STRING

       LET l_str=''
       CALL l_dec.clear()
       
       LET p_row = 11 LET p_col = 3
       OPEN WINDOW i078_date AT p_row,p_col WITH FORM "ghr/42f/ghri078_date"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
       
      
       CALL cl_ui_locale("ghri078_date")
       
       LET l_dec[1].name="FLOOR()"
       LET l_dec[1].des="取整:FLOOR(数值):向下取数值的整数部分,如123.45返回123;-123.45返回-124"
       LET l_dec[2].name="ROUND(,)"
       LET l_dec[2].des="四舍五入:ROUND(数值,保留小数位数):按保留的小数位数四舍五入"
       LET l_dec[3].name="MOD(,)"
       LET l_dec[3].des="取余:MOD(除数,被除数):取除数除以被除数的余数" 	
       LET l_dec[4].name="POWER(,)"
       LET l_dec[4].des="幂:POWER(底数,幂):计算底数的幂次方的值"
       LET l_dec[5].name="SANQI()"
       LET l_dec[5].des="三舍七入:SANQI(数值):三舍七入,其他为0.5"	
       
       
       LET l_rec_b=5
       
       CALL cl_set_act_visible("accept,cancel", FALSE)
       DISPLAY ARRAY l_dec TO s_fun.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)

       BEFORE ROW
         LET l_ac_dec = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf  
 
       ON ACTION accept
         LET l_str=l_dec[l_ac_dec].name
         EXIT DISPLAY
          
       END DISPLAY
       CALL cl_set_act_visible("accept,cancel", TRUE)
       CLOSE WINDOW i078_date
       
       RETURN l_str                                                             

END FUNCTION   
}
	
FUNCTION i078_b_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5
		
        CALL g_hrdk_b.clear()
        
        LET l_sql=" SELECT hrdk01,hrdk02,'',hrdk03,hrdk04,hrdk05,hrdk06,hrdk21,hrdk07,hrdk08,hrdk13,hrdk15 ",
                  "   FROM hrdk_file WHERE ",p_wc CLIPPED,
                  "  ORDER BY TO_NUMBER(hrdk01) "
        PREPARE i078_b_pre FROM l_sql
        DECLARE i078_b_cs CURSOR FOR i078_b_pre
        
        LET l_i=1
        
        FOREACH i078_b_cs INTO g_hrdk_b[l_i].*
        
           SELECT hraa12 INTO g_hrdk_b[l_i].hrdk02_1_b FROM hraa_file
            WHERE hraa01=g_hrdk_b[l_i].hrdk02_b 
           
              
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrdk_b.deleteElement(l_i)
        LET g_rec_b = l_i - 1
        DISPLAY ARRAY g_hrdk_b TO s_hrdk_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
           BEFORE DISPLAY
              EXIT DISPLAY
        END DISPLAY

END FUNCTION                  


FUNCTION i078_b_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000


   WHILE TRUE

      CALL i078_bp("G")

      IF NOT cl_null(g_action_choice) AND l_ac>0 THEN #將清單的資料回傳到主畫面
         SELECT hrdk_file.*
           INTO g_hrdk.*
           FROM hrdk_file
          WHERE hrdk01=g_hrdk_b[l_ac].hrdk01_b 
      END IF

      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'Page1'
         LET l_ac = ARR_CURR()
         LET g_jump = l_ac
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL i078_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page2", TRUE)
       END IF

      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
               CALL i078_a()
            END IF
            EXIT WHILE

        WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i078_q()
            END IF
            EXIT WHILE

        WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i078_r()
            END IF

        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i078_u()
            END IF
            EXIT WHILE

#        WHEN "invalid"
#            IF cl_chk_act_auth() THEN
#               CALL i078_x()
#               CALL i078_show()
#            END IF
#            	
        WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_hrdk.hrdk01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrdk01"
                  LET g_doc.value1 = g_hrdk.hrdk01
                  CALL cl_doc()
               END IF
            END IF    	 	

        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdk_b),'','')
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


FUNCTION i078_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdk_b TO s_hrdk_b.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
             CALL i078_fetch('/')
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
         CALL i078_fetch('/')
         CALL cl_set_comp_visible("Page2", FALSE)
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page2", TRUE)
         EXIT DISPLAY

      ON ACTION first
         CALL i078_fetch('F')
         CONTINUE DISPLAY

      ON ACTION previous
         CALL i078_fetch('P')
         CONTINUE DISPLAY

      ON ACTION jump
         CALL i078_fetch('/')
         CONTINUE DISPLAY

      ON ACTION next
         CALL i078_fetch('N')
         CONTINUE DISPLAY

      ON ACTION last
         CALL i078_fetch('L')
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
      
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY 
   
      AFTER DISPLAY
         CONTINUE DISPLAY

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
        
        			 
