# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri045.4gl
# Descriptions...: 员工出差信息维护作业
# Date & Author..: 13/06/06 By yeap1
 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE  g_hrcec03         LIKE hrcec_file.hrcec03    #查询条件
DEFINE  g_hrcec05         LIKE hrcec_file.hrcec05
DEFINE  g_hrcec15         LIKE hrcec_file.hrcec15


DEFINE 
     g_ccmx           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrcec02      LIKE hrcec_file.hrcec02, #项次
        choose       LIKE type_file.chr1,     #选择
        hrcec16      LIKE hrcec_file.hrcec16, #撤消状态
        hrcec04      LIKE hrcec_file.hrcec04, #工号
        hrat02       LIKE hrat_file.hrat02,   #姓名
        hrat17       LIKE hrat_file.hrat17,   #性别
        hrat04       LIKE hrat_file.hrat04,   #部门
        hrat05       LIKE hrat_file.hrat05,   #职位
        hrcec05      LIKE hrcec_file.hrcec05, #开始日期
        hrcec06      LIKE hrcec_file.hrcec06, #开始时间  
        hrcec07      LIKE hrcec_file.hrcec07, #结束日期
        hrcec08      LIKE hrcec_file.hrcec08, #结束时间
        hrcec03      LIKE hrcec_file.hrcec03, #假勤项目编号
        hrcec09      LIKE hrcec_file.hrcec09, #出差时长
        hrcec10      LIKE hrcec_file.hrcec10, #单位
        hrcec15      LIKE hrcec_file.hrcec15  #备注
                    END RECORD,
     g_ccmx_t           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)备份
        hrcec02      LIKE hrcec_file.hrcec02, #项次
        choose       LIKE type_file.chr1,     #选择
        hrcec16      LIKE hrcec_file.hrcec16, #撤消状态
        hrcec04      LIKE hrcec_file.hrcec04, #工号
        hrat02       LIKE hrat_file.hrat02,   #姓名
        hrat17       LIKE hrat_file.hrat17,   #性别
        hrat04       LIKE hrat_file.hrat04,   #部门
        hrat05       LIKE hrat_file.hrat05,   #职位
        hrcec05      LIKE hrcec_file.hrcec05, #开始日期
        hrcec06      LIKE hrcec_file.hrcec06, #开始时间  
        hrcec07      LIKE hrcec_file.hrcec07, #结束日期
        hrcec08      LIKE hrcec_file.hrcec08, #结束时间
        hrcec03      LIKE hrcec_file.hrcec03,   #假勤项目编号
        hrcec09      LIKE hrcec_file.hrcec09, #出差时长
        hrcec10      LIKE hrcec_file.hrcec10, #单位
        hrcec15      LIKE hrcec_file.hrcec15  #备注
                    END RECORD,
    g_wc,g_sql     STRING,                           #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,
    l_ac            LIKE type_file.num5,              #ç®åèççARRAY CNT  #No.FUN-680102 SMALLINT
    g_account       LIKE type_file.num5               #No.FUN-680102 SMALLINT               #FUN-670032 æè¨ç¶­è­·
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_forupd_gbo_sql     STRING                  #FOR UPDATE SQL   #FUN-920138
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680102 INTEGER
DEFINE g_before_input_done  LIKE type_file.num5     #FUN-570110   #No.FUN-680102 SMALLINT
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE l_massage            STRING                  #No.FUN-760083
DEFINE g_str                STRING                  #No.FUN-760083
DEFINE g_u_flag             LIKE type_file.chr1     #FUN-870101 add 
 
MAIN
    OPTIONS                                #æ¹è®ä¸äºç³»çµ±é è¨­å¼
        INPUT NO WRAP
    DEFER INTERRUPT                        #æ·åä¸­æ·éµ, ç±ç¨å¼èç
 
 WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF


   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081
   INITIALIZE g_hrcec03 TO NULL
   INITIALIZE g_hrcec05 TO NULL
   INITIALIZE g_hrcec15 TO NULL
 
    OPEN WINDOW i045a_w WITH FORM "ghr/42f/ghri045a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
  
  CALL cl_set_comp_visible('choose',FALSE)
  CALL i045a_menu()
  CLOSE WINDOW i045a_w                 #çµæç«é¢

  CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN

 
FUNCTION i045a_menu()#gai
 
   WHILE TRUE
      CALL i045a_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i045a_q()
            END IF
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "renyuan"
            IF cl_chk_act_auth() THEN
            CALL cl_set_comp_visible('choose',TRUE)
            CALL i045a_b()
            CALL i045a_select_data() 
            CALL i045a_b_fill(g_wc)
            CALL cl_set_comp_visible('choose',FALSE)
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i045a_q()
      CALL i045a_b_askkey()
END FUNCTION
 
FUNCTION i045a_b()  #gai
DEFINE     l_ac_t          LIKE type_file.num5,                #æªåæ¶çARRAY CNT  #No.FUN-680102 SMALLINT
           l_n             LIKE type_file.num5,                #æª¢æ¥éè¤ç¨  #No.FUN-680102 SMALLINT
           l_lock_sw       LIKE type_file.chr1,                #å®èº«éä½å¦  #No.FUN-680102 VARCHAR(1)
           p_cmd           LIKE type_file.chr1,                #èççæ  #No.FUN-680102 VARCHAR(1)
           l_allow_insert  LIKE type_file.chr1,                # Prog. Version..: '5.30.05-13.01.08(01),          #å¯æ°å¢å¦
           l_allow_delete  LIKE type_file.chr1,                # Prog. Version..: '5.30.05-13.01.08(01),          #å¯åªé¤å¦
           l_cnt           LIKE type_file.num10                #No.FUN-680102 INTEGER #FUN-670032

    LET g_action_choice = ""    #No:MOD-A60184 add
    IF s_shut(0) THEN
    	 RETURN
    END IF
    	
    CALL cl_opmsg('b')
 
    IF g_rec_b=0 THEN
       RETURN
    END IF 
    INPUT ARRAY g_ccmx WITHOUT DEFAULTS FROM s_ccmx.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED) 
    BEFORE INPUT    
	     #栏位开闭控制
	     LET p_cmd = 'a'
	     LET g_before_input_done = FALSE
      CALL i045a_set_entry(p_cmd)
      CALL i045a_set_no_entry(p_cmd)
       LET g_before_input_done = TRUE
          
          ON ACTION cancel   
               EXIT INPUT
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION controlg
             CALL cl_cmdask()
 
          ON ACTION help
             CALL cl_show_help()
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
     END INPUT
     
END FUNCTION

FUNCTION i045a_select_data()
	DEFINE  l_hrcec16         LIKE hrcec_file.hrcec16
	DEFINE  l_hrbm03          LIKE hrbm_file.hrbm03
	

      
   FOR g_i = 1 TO g_rec_b
      IF g_ccmx[g_i].choose = "Y" THEN
      	LET l_massage = '   ',g_ccmx[g_i].hrat02,' ( ',g_ccmx[g_i].hrcec04,' ) ','   ',g_ccmx[g_i].hrcec05 
      	SELECT hrbm03 
      	  INTO l_hrbm03
      	  FROM hrbm_file
      	 WHERE hrbm04 = g_ccmx[g_i].hrcec03
      	 
      	SELECT hratid INTO g_ccmx[g_i].hrcec04 FROM hrat_file WHERE hrat01 = g_ccmx[g_i].hrcec04 	  
 
        SELECT hrcec16 INTO l_hrcec16 FROM hrcec_file
         WHERE hrcec03 = l_hrbm03  
           AND hrcec02 = g_ccmx[g_i].hrcec02
      	   AND hrcec04 = g_ccmx[g_i].hrcec04
           
         IF l_hrcec16 = "Y" THEN
            IF cl_confirm2('ghr-108',l_massage) THEN 
      	       UPDATE hrcec_file
      	          SET hrcec16 = "N"
      	        WHERE hrcec03 = l_hrbm03 
      	          AND hrcec04 = g_ccmx[g_i].hrcec04 
                  AND hrcec02 = g_ccmx[g_i].hrcec02
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","hrcec_file",g_ccmx[g_i].hrcec04,"",SQLCA.sqlcode,"","",1) 
                      CONTINUE FOR 
                   ELSE
                   	  UPDATE hrce_file
                         SET hrcemodu = g_user,
                             hrcedate = g_today
                       WHERE hrce02 = g_ccmx[g_i].hrcec03
                   END IF
            END IF 
         ELSE 
             IF  cl_confirm2('ghr-109',l_massage) THEN 
                 UPDATE hrcec_file
      	            SET hrcec16 = "Y"
      	          WHERE hrcec03 = l_hrbm03  
      	            AND hrcec04 = g_ccmx[g_i].hrcec04
                    AND hrcec02 = g_ccmx[g_i].hrcec02
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","hrcec_file",g_ccmx[g_i].hrcec04,"",SQLCA.sqlcode,"","",1) 
                        CONTINUE FOR 
                     ELSE
                   	    UPDATE hrce_file
                           SET hrcemodu = g_user,
                               hrcedate = g_today
                         WHERE hrce02 = g_ccmx[g_i].hrcec03
                   END IF
             END IF 	
         END IF
            DISPLAY BY NAME g_ccmx[g_i].hrcec16
            LET g_ccmx[g_i].choose = "N"
      END IF 
   END FOR 
	
END FUNCTION 
 
FUNCTION i045a_b_askkey() #gai
	DEFINE l_hrbm04   LIKE hrbm_file.hrbm04
 
    CLEAR FORM
   CALL g_ccmx.clear()
 
    CONSTRUCT g_wc ON hrcec03,hrcec05,hrcec15,hrcec04
         FROM g_hrcec03,g_hrcec05,g_hrcec15,s_ccmx[1].hrcec04
 
       BEFORE CONSTRUCT
           CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(g_hrcec03)
                  CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_hrbm03"
                   LET g_qryparam.arg1 = "005"
                   LET g_qryparam.default1 = g_hrcec03
                  CALL cl_create_qry() RETURNING g_hrcec03
                  DISPLAY g_hrcec03 TO FORMONLY.g_hrcec03
                  NEXT FIELD g_hrcec03
             WHEN INFIELD(hrcec04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_ccmx[1].hrcec04
              CALL cl_create_qry() RETURNING g_ccmx[1].hrcec04
              DISPLAY BY NAME g_ccmx[1].hrcec04
              NEXT FIELD hrcec04
            OTHERWISE
                EXIT CASE
         END CASE 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED  
   	 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      LET g_rec_b = 0    
      RETURN
   END IF

    CALL i045a_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i045a_b_fill(p_wc2)             #gai
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680102 VARCHAR(200)
DEFINE l_hrao02        LIKE hrao_file.hrao02
DEFINE l_hras04        LIKE hras_file.hras04
DEFINE l_hrat17        LIKE hrat_file.hrat17
DEFINE l_hrat01        LIKE hrat_file.hrat01   #added by yeap NO.130806
DEFINE l_hrcec03        LIKE hrcec_file.hrcec03
DEFINE l_hrcec10        LIKE hrcec_file.hrcec10
 
    LET g_sql =
        "SELECT  hrcec02,'',hrcec16,hrcec04,'','','','',hrcec05,hrcec06,hrcec07,hrcec08,",
        "hrcec03,hrcec09,hrcec10,hrcec15",
        " FROM hrcec_file",
        " WHERE ", p_wc2 CLIPPED,                 
        " ORDER BY hrcec04"
    PREPARE i045a_pb FROM g_sql
    DECLARE ccmx_curs CURSOR FOR i045a_pb
 
    CALL g_ccmx.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    MESSAGE "Searching!" 
    FOREACH ccmx_curs INTO g_ccmx[g_cnt].*
        LET g_rec_b = g_rec_b + 1
        IF STATUS THEN
         	  CALL cl_err('foreach:',STATUS,1)
         	  EXIT FOREACH 
         END IF
            LET g_ccmx[g_cnt].choose = "N"
            LET l_hrcec03 = g_ccmx[g_cnt].hrcec03
            LET l_hrcec10 = g_ccmx[g_cnt].hrcec10
            
        	SELECT hrat02,hrat04,hrat17,hrat05,hrat01
        	  INTO g_ccmx[g_cnt].hrat02,l_hrao02,l_hrat17,l_hras04,l_hrat01   #added l_hrat01 by yeap NO.130806
        	  FROM hrat_file
        	 WHERE hratid = g_ccmx[g_cnt].hrcec04
        	 
        	SELECT hrao02
        	  INTO g_ccmx[g_cnt].hrat04
        	  FROM hrao_file
        	 WHERE hrao01 = l_hrao02
        	 
        	SELECT hras04
        	  INTO g_ccmx[g_cnt].hrat05
        	  FROM hras_file
        	 WHERE hras01 = l_hras04
        	 
        	SELECT hrag07
        	  INTO g_ccmx[g_cnt].hrat17
        	  FROM hrag_file
        	 WHERE hrag06 = l_hrat17 
        	   AND hrag01 = 333 
        	  
        	SELECT hrbm04
        	  INTO g_ccmx[g_cnt].hrcec03
        	  FROM hrbm_file
        	 WHERE hrbm03 = l_hrcec03
        	 
        	SELECT hrag07
        	  INTO g_ccmx[g_cnt].hrcec10
        	  FROM hrag_file
        	 WHERE hrag06 = l_hrcec10 
        	   AND hrag01 = 504
        	        	    
        	  
        	DISPLAY BY NAME g_ccmx[g_cnt].choose,g_ccmx[g_cnt].hrat02,g_ccmx[g_cnt].hrat04,g_ccmx[g_cnt].hrat17,g_ccmx[g_cnt].hrat05
        	DISPLAY g_ccmx[g_cnt].hrcec03 TO hrbm04
        	
        	   LET g_ccmx[g_cnt].hrcec04 = l_hrat01   #added by yeap NO.130806
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
     CALL g_ccmx.deleteElement(g_cnt)
     
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i045a_bp(p_ud)#gai
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G"THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ccmx TO s_ccmx.* ATTRIBUTE(COUNT=g_rec_b)
   BEFORE ROW
      LET l_ac = ARR_CURR()
     CALL cl_show_fld_cont() 
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close 
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION renyuan
         LET g_action_choice="renyuan"
         EXIT DISPLAY
 
      ON ACTION tuichu
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 

                                                        
FUNCTION i045a_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a'THEN                          
     CALL cl_set_comp_entry("choose",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i045a_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' THEN          
     CALL cl_set_comp_entry("hrcec03,hrcec04,hrcec05,hrcec06,hrcec07,hrcec08,hrcec09,hrcec10",FALSE)
     CALL cl_set_comp_entry("hrcec15,hrcec16,hrat02,hrat17,hrat05,hrat04",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    

