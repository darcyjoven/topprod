# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri094
# Descriptions...: 薪酬报盘数据
# Date & Author..: 13/08/13 jiangxt

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_094           RECORD                  
            hrat03         LIKE hrat_file.hrat03,
            hrat01         LIKE hrat_file.hrat01,
            hrat02         LIKE hrat_file.hrat02,
            hrat13         LIKE hrat_file.hrat13,
            hrdn03         LIKE hrdn_file.hrdn03,
            hrdn04         LIKE hrdn_file.hrdn04,
            hrdn05         LIKE hrdn_file.hrdn05,
            hrdxa14        LIKE hrdxa_file.hrdxa14,
            hrdxa15        LIKE hrdxa_file.hrdxa15,
            hrdxa16        LIKE hrdxa_file.hrdxa16
                       END RECORD,
       g_094a          DYNAMIC ARRAY OF RECORD                  
            hrat03         LIKE hrat_file.hrat03,
            hrat01         LIKE hrat_file.hrat01,
            hrat02         LIKE hrat_file.hrat02,
            hrat13         LIKE hrat_file.hrat13,
            hrdn03         LIKE hrdn_file.hrdn03,
            hrdn04         LIKE hrdn_file.hrdn04,
            hrdn05         LIKE hrdn_file.hrdn05,
            hrdxa14        LIKE hrdxa_file.hrdxa14,
            hrdxa15        LIKE hrdxa_file.hrdxa15,
            hrdxa16        LIKE hrdxa_file.hrdxa16
                       END RECORD, 
       g_094b          DYNAMIC ARRAY OF RECORD                  
            hrat03         LIKE hrat_file.hrat03,
            hrat01         LIKE hrat_file.hrat01,
            hrat02         LIKE hrat_file.hrat02,
            hrat13         LIKE hrat_file.hrat13,
            hrdn03         LIKE hrdn_file.hrdn03,
            hrdn04         LIKE hrdn_file.hrdn04,
            hrdn05         LIKE hrdn_file.hrdn05,
            hrdxa14        LIKE hrdxa_file.hrdxa14,
            hrdxa15        LIKE hrdxa_file.hrdxa15,
            hrdxa16        LIKE hrdxa_file.hrdxa16        
                       END RECORD,   
       g_094c          DYNAMIC ARRAY OF RECORD                  
            hrat03         LIKE hrat_file.hrat03,
            hrat01         LIKE hrat_file.hrat01,
            hrat02         LIKE hrat_file.hrat02,
            hrat13         LIKE hrat_file.hrat13,
            hrdn03         LIKE hrdn_file.hrdn03,
            hrdn04         LIKE hrdn_file.hrdn04,
            hrdn05         LIKE hrdn_file.hrdn05,
            hrdxa14        LIKE hrdxa_file.hrdxa14,
            hrdxa15        LIKE hrdxa_file.hrdxa15,
            hrdxa16        LIKE hrdxa_file.hrdxa16          
                       END RECORD
DEFINE g_cnt1               LIKE type_file.num5,
       g_cnt2               LIKE type_file.num5,
       g_cnt3               LIKE type_file.num5
DEFINE g_flag_b             LIKE type_file.chr1
DEFINE g_sql                STRING
DEFINE g_hraa01             LIKE hraa_file.hraa01
DEFINE g_hrct11             LIKE hrct_file.hrct11
DEFINE g_sum1a              LIKE hrdxa_file.hrdxa14
DEFINE g_sum2a              LIKE hrdxa_file.hrdxa15
DEFINE g_sum3a              LIKE hrdxa_file.hrdxa16
DEFINE g_sum1b              LIKE hrdxa_file.hrdxa14
DEFINE g_sum2b              LIKE hrdxa_file.hrdxa15
DEFINE g_sum3b              LIKE hrdxa_file.hrdxa16
DEFINE g_sum1c              LIKE hrdxa_file.hrdxa14
DEFINE g_sum2c              LIKE hrdxa_file.hrdxa15
DEFINE g_sum3c              LIKE hrdxa_file.hrdxa16

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                                      #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081

   OPEN WINDOW i094_w WITH FORM "ghr/42f/ghri094"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL i094_menu()
   
   CLOSE WINDOW i094_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i094_cs()
DEFINE l_hraa02  LIKE hraa_file.hraa02

    CLEAR FORM
    LET g_hraa01=''
    LET g_hrct11=''
    INPUT g_hraa01,g_hrct11 WITHOUT DEFAULTS FROM hraa01,hrct11
    
       ON ACTION controlp
          CASE
            WHEN INFIELD(hraa01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              CALL cl_create_qry() RETURNING g_hraa01
              DISPLAY g_hraa01 TO hraa01
              NEXT FIELD hraa01
            WHEN INFIELD(hrct11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              LET g_qryparam.where=" hrct03='",g_hraa01,"' AND hrct06='Y'"
              CALL cl_create_qry() RETURNING g_hrct11
              DISPLAY g_hrct11 TO hrct11
              NEXT FIELD hrct11
          END CASE

       AFTER FIELD hraa01
          SELECT hraa02 INTO l_hraa02 FROM hraa_file WHERE hraa01=g_hraa01
          DISPLAY l_hraa02 TO hraa02

       BEFORE FIELD hrct11
          IF cl_null(g_hraa01) THEN NEXT FIELD hraa01 END IF 
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()
         
    END INPUT

END FUNCTION

FUNCTION i094_menu()

   WHILE TRUE
      CASE g_flag_b
         WHEN '2'
           CALL i094_bp2("G")
         WHEN '3'
           CALL i094_bp3("G")
         OTHERWISE
           CALL i094_bp1("G")
      END CASE 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i094_q()
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

FUNCTION i094_bp1(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_094a TO s_094a.* ATTRIBUTE(COUNT=g_cnt1)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(1,1)
                 
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY 
              
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about       
         CALL cl_about() 

      ON ACTION page2
         LET g_flag_b='2'
         CALL i094_show()
         EXIT DISPLAY

      ON ACTION page3
         LET g_flag_b='3'
         CALL i094_show()
         EXIT DISPLAY 
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")    

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i094_bp2(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_094b TO s_094b.* ATTRIBUTE(COUNT=g_cnt2)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(1,1)
                 
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY 
              
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about       
         CALL cl_about() 

      ON ACTION page1
         LET g_flag_b='1'
         CALL i094_show()
         EXIT DISPLAY

      ON ACTION page3
         LET g_flag_b='3'
         CALL i094_show()
         EXIT DISPLAY 

      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")    

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i094_bp3(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_094c TO s_094c.* ATTRIBUTE(COUNT=g_cnt3)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(1,1)
                 
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY 
              
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
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
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about       
         CALL cl_about() 

      ON ACTION page1
         LET g_flag_b='1'
         CALL i094_show()
         EXIT DISPLAY

      ON ACTION page2
         LET g_flag_b='2'
         CALL i094_show()
         EXIT DISPLAY 

      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")    

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i094_q()
    
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i094_cs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    CALL i094_b_fill()
    CALL i094_show()
END FUNCTION

FUNCTION i094_show()
    CASE g_flag_b
       WHEN '2'
          DISPLAY g_sum1b TO sum1
          DISPLAY g_sum2b TO sum2
          DISPLAY g_sum3b TO sum3
       WHEN '3'
          DISPLAY g_sum1c TO sum1
          DISPLAY g_sum2c TO sum2
          DISPLAY g_sum3c TO sum3
       OTHERWISE
          DISPLAY g_sum1a TO sum1
          DISPLAY g_sum2a TO sum2
          DISPLAY g_sum3a TO sum3
    END CASE 

END FUNCTION 

FUNCTION i094_b_fill()
DEFINE l_a,l_b   LIKE type_file.num5
DEFINE l_hratid  LIKE hrat_file.hratid
DEFINE l_hrdn09  LIKE hrdn_file.hrdn09
DEFINE l_hrdn10  LIKE hrdn_file.hrdn10
DEFINE l_hrdna05 LIKE hrdna_file.hrdna05
DEFINE l_hrdna06 LIKE hrdna_file.hrdna06
DEFINE l_hrct02  LIKE type_file.num5
DEFINE l_hrct02b LIKE type_file.num5
DEFINE l_hrct02e LIKE type_file.num5
DEFINE l_flag1   LIKE type_file.chr1
DEFINE l_flag2   LIKE type_file.chr1

   LET g_cnt1=1
   LET g_cnt2=1
   LET g_cnt3=1
   LET g_sum1a=0
   LET g_sum2a=0
   LET g_sum3a=0
   LET g_sum1b=0
   LET g_sum2b=0
   LET g_sum3b=0
   LET g_sum1c=0
   LET g_sum2c=0
   LET g_sum3c=0
   CALL g_094a.clear()
   CALL g_094b.clear()
   CALL g_094c.clear()
   #当前月
   SELECT hrct02 INTO l_hrct02 FROM hrct_file WHERE hrct11=g_hrct11
   #薪资信息
   LET g_sql = "SELECT hratid,hrat03,hrat01,hrat02,hrat14,'','','',hrdxa14,hrdxa15,hrdxa16",
               "  FROM hrat_file,hrdxa_file",
               " WHERE hratid = hrdxa02 AND hrdxa01=?",
               " ORDER BY hrat01"
   PREPARE i094_p1 FROM g_sql
   DECLARE i094_c1 CURSOR FOR i094_p1
   #银行帐号信息
   LET g_sql = "SELECT hrdn03,hrdn04,hrdn05,hrdn09,hrdn10 ",
               "  FROM hrdn_file",
               " WHERE hrdnacti='Y' AND hrdn02=?",
               " ORDER BY hrdn01"
   PREPARE i094_p2 FROM g_sql
   DECLARE i094_c2 CURSOR FOR i094_p2
   #共用信息
   LET g_sql = "SELECT hrdn03,hrdn04,hrdn05,hrdn09,hrdn10,hrdna05,hrdna06 ",
               "  FROM hrdn_file,hrdna_file",
               " WHERE hrdna01=hrdn01 AND hrdna07='Y' AND hrdnacti='Y' AND hrdna03=?",
               " ORDER BY hrdn01"
   PREPARE i094_p3 FROM g_sql
   DECLARE i094_c3 CURSOR FOR i094_p3
   
   FOREACH i094_c1 USING g_hrct11 INTO l_hratid,g_094.*  
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET l_flag1='Y'
       LET l_flag2='Y'
       #单身一
       SELECT count(*) INTO l_a FROM hrdn_file WHERE hrdn02=l_hratid
       IF l_a>0 THEN 
          FOREACH i094_c2 USING l_hratid INTO g_094.hrdn03,g_094.hrdn04,g_094.hrdn05,l_hrdn09,l_hrdn10
             SELECT hrct02 INTO l_hrct02b FROM hrct_file WHERE hrct11=l_hrdn09
             IF l_hrct02b>l_hrct02 THEN 
                EXIT FOREACH 
             END IF 
             SELECT hrct02 INTO l_hrct02e FROM hrct_file WHERE hrct11=l_hrdn10
             IF l_hrct02e<l_hrct02 THEN 
                EXIT FOREACH 
             END IF 
             LET g_094a[g_cnt1].*=g_094.*
             LET g_sum1a=g_sum1a+g_094.hrdxa14
             LET g_sum2a=g_sum2a+g_094.hrdxa15
             LET g_sum3a=g_sum3a+g_094.hrdxa16
             LET l_flag1='N'
             LET g_cnt1=g_cnt1+1
          END FOREACH 
       END IF 
       #单身二
       SELECT count(*) INTO l_b FROM hrdna_file WHERE hrdna03=l_hratid AND hrdna07='Y'
       IF l_b>0 THEN 
          FOREACH i094_c3 USING l_hratid INTO g_094.hrdn03,g_094.hrdn04,g_094.hrdn05,l_hrdn09,l_hrdn10,l_hrdna05,l_hrdna06
             SELECT hrct02 INTO l_hrct02b FROM hrct_file WHERE hrct11=l_hrdn09
             IF l_hrct02b>l_hrct02 THEN 
                EXIT FOREACH 
             END IF 
             SELECT hrct02 INTO l_hrct02e FROM hrct_file WHERE hrct11=l_hrdn10
             IF l_hrct02e<l_hrct02 THEN 
                EXIT FOREACH 
             END IF 
             SELECT hrct02 INTO l_hrct02b FROM hrct_file WHERE hrct11=l_hrnda05
             IF l_hrct02b>l_hrct02 THEN 
                EXIT FOREACH 
             END IF 
             SELECT hrct02 INTO l_hrct02e FROM hrct_file WHERE hrct11=l_hrdna06
             IF l_hrct02e<l_hrct02 THEN 
                EXIT FOREACH 
             END IF 
             LET g_094b[g_cnt2].*=g_094.*
             LET g_sum1b=g_sum1b+g_094.hrdxa14
             LET g_sum2b=g_sum2b+g_094.hrdxa15
             LET g_sum3b=g_sum3b+g_094.hrdxa16
             LET l_flag2='N'
             LET g_cnt2=g_cnt2+1
          END FOREACH 
       END IF 
       #单身三
       IF l_flag1='Y' AND l_flag2='Y' THEN 
          LET g_094.hrdn03=''     
          LET g_094.hrdn04=''
          LET g_094.hrdn05=''  
          LET g_094c[g_cnt3].*=g_094.*
          LET g_sum1c=g_sum1c+g_094.hrdxa14
          LET g_sum2c=g_sum2c+g_094.hrdxa15
          LET g_sum3c=g_sum3c+g_094.hrdxa16
          LET g_cnt3=g_cnt3+1
       END IF 
       
   END FOREACH
END FUNCTION
