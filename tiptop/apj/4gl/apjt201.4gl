# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apjt201.4gl
# Descriptions...: 活動明細資料維護
# Date & Author..: No.FUN-790025 07/11/19 By Cockroach
# Modify.........: No.TQC-840009 08/04/03 By Cockroach t200新增資料串t201時pjk27應直接附值為0
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A40010 10/04/07 By Summer 從apjt200串過來時,要可以修改 
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
DEFINE g_pjk            RECORD LIKE pjk_file.*,
       g_pjk_t          RECORD LIKE pjk_file.*,  #
       g_pjk_o          RECORD LIKE pjk_file.*,  #
       g_pjj04          LIKE pjj_file.pjj04,
       g_wc             STRING,                 
       g_sql            STRING,                  #
       g_forupd_sql     STRING              #SELECT ...FOR UPDATE  SQL
 
 
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_chr                 LIKE pjk_file.pjkacti        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_curs_index          LIKE type_file.num10      
DEFINE g_row_count           LIKE type_file.num10        
DEFINE g_jump                LIKE type_file.num10       
DEFINE mi_no_ask             LIKE type_file.num5          
 
DEFINE g_argv1              LIKE pjj_file.pjj01
DEFINE g_argv2              LIKE pjk_file.pjk02
 
MAIN
    DEFINE p_row,p_col     LIKE type_file.num5           
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                               
  
    IF (NOT cl_user()) THEN                     #
      EXIT PROGRAM                              #
    END IF
    
    
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    
   INITIALIZE g_pjk.* TO NULL  
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_pjk.pjk01=g_argv1
   LET g_pjk.pjk02=g_argv2   
   
#   LET g_forupd_sql = "SELECT * FROM pjk_file WHERE pjk01 = ? AND pjk02 = ? FOR UPDATE "
   LET g_forupd_sql = "SELECT * FROM pjk_file WHERE pjk01 = ? AND pjk02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t201_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW t201 AT p_row,p_col WITH FORM "apj/42f/apjt201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              
 
   CALL cl_ui_init()
#   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
    IF NOT cl_null(g_argv1) THEN 
#      IF  NOT cl_null(g_argv2) THEN  
       CALL t201_q()
#       CALL t201_show()
   END IF
#       SELECT pjk_file.* INTO g_pjk_rowid,g_pjk.* 
#         FROM pjk_file
#        WHERE pjk01 = g_argv1 AND pjk02 = g_argv2
#      ELSE
#        SELECT pjk_file.* INTO g_pjk_rowid,g_pjk.* 
#         FROM pjk_file
#        WHERE pjk01 = g_argv1 
#      END IF  
 
#   IF NOT cl_null(g_argv1) AND cl_null(g_argv2) THEN
#            CALL t201_q()
#   END IF
#   IF NOT cl_null(g_argv2) THEN 
#      CALL cl_set_act_visible("modify,delete,invalid",FALSE)
#      CALL cl_set_act_visible("confirm,undo_confirm",FALSE)
#   END IF
   LET g_action_choice = ""
   CALL t201_menu()
 
   CLOSE WINDOW t201_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time       
END MAIN
 
FUNCTION t201_curs()
      DEFINE ls      STRING
      CLEAR FORM
      
      IF NOT cl_null(g_argv1) THEN
         LET g_wc=" pjk01 = '",g_argv1 CLIPPED,"' " 
         IF NOT cl_null(g_argv2) THEN
           LET g_wc=" pjk01= '",g_argv1 CLIPPED,"' AND pjk02= '",g_argv2 CLIPPED,"'"
#            LET g_wc=g_wc clipped,"' AND pjma02= '",g_argv2 CLIPPED,"'"
         END IF
      ELSE
        INITIALIZE g_pjk.* TO NULL
 
        CONSTRUCT BY NAME g_wc ON                 
        pjk01,pjk02,pjk03,pjk27,
        pjk05,pjk07,pjk11,pjk25,pjk13,pjk06,pjk08,pjk12,pjk26,        
        pjk09,pjk10,
        pjk14,pjk16,pjk18,pjk20,pjk22,pjk30,
        pjk15,pjk17,pjk19,pjk21,pjk23,pjk28,
        pjk24,pjk29,
	pjkuser,pjkgrup,pjkmodu,pjkdate,pjkacti
             
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(pjk01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjj"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pjk.pjk01
                 LET g_qryparam.default1 = g_pjk.pjk02   
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk01
	         NEXT FIELD pjk01
                                
              WHEN INFIELD(pjk02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjj1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pjk.pjk02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk02
	         NEXT FIELD pjk02
                 
              WHEN INFIELD(pjk05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pjk.pjk05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk05
	         NEXT FIELD pjk05                                  
                 
              WHEN INFIELD(pjk11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb2"
                 LET g_qryparam.state = "c"
#                 LET g_qryparam.arg1 = 'pjj04'
                 LET g_qryparam.default1 = g_pjk.pjk11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk11
	         NEXT FIELD pjk11
                 
              WHEN INFIELD(pjk25)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pjk.pjk25
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk25
	         NEXT FIELD pjk25                 
                 
              WHEN INFIELD(pjk26)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pjk.pjk26
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk26
	         NEXT FIELD pjk26
                 
              WHEN INFIELD(pjk09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjw"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pjk.pjk09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk09
	         NEXT FIELD pjk09                 
                 
              WHEN INFIELD(pjk10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjw"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pjk.pjk10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk10
	         NEXT FIELD pjk10
                 
              WHEN INFIELD(pjk29)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pjk.pjk29
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk29
	         NEXT FIELD pjk29
                                                  
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN    
    #        LET g_wc = g_wc clipped," AND pjkuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN   
    #        LET g_wc = g_wc clipped," AND pjkgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND pjkgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjkuser', 'pjkgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT pjk01,pjk02 FROM pjk_file ",  #
        " WHERE ",g_wc CLIPPED, " ORDER BY pjk01,pjk02"
    PREPARE t201_prepare FROM g_sql
    DECLARE t201_cs SCROLL CURSOR WITH HOLD FOR t201_prepare    # SCROLL CURSOR
        
    LET g_sql="SELECT COUNT(*) FROM pjk_file WHERE ",g_wc CLIPPED
    PREPARE t201_precount FROM g_sql
    DECLARE t201_count CURSOR FOR t201_precount
END FUNCTION
 
FUNCTION t201_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000      
    MENU ""
      BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF NOT cl_null(g_argv2) THEN                                                 
           #CALL cl_set_act_visible("modify,delete,invalid",FALSE) #No.CHI-A40010 mark                  
            CALL cl_set_act_visible("delete,invalid",FALSE)        #No.CHI-A40010            
            CALL cl_set_act_visible("confirm,undo_confirm",FALSE)                     
           END IF  
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN              
		CALL t201_q()
            END IF
        ON ACTION next
            CALL t201_fetch('N')
            
        ON ACTION previous
            CALL t201_fetch('P')
            
        ON ACTION modify       
           LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t201_u()
            END IF
            
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t201_x()
            END IF
            
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t201_r()
            END IF 
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN                                                                
               CALL t201_out()              
            END IF
 
        ON ACTION help
            CALL cl_show_help()
            
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
  
        ON ACTION jump
            CALL t201_fetch('/')
        ON ACTION first
            CALL t201_fetch('F')
        ON ACTION last
            CALL t201_fetch('L')
     
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
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
           EXIT MENU
                            
        ON ACTION confirm            
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                CALL t201_y()
           END IF 
        ON ACTION undo_confirm       
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t201_z()
            END IF
 
    END MENU
    CLOSE t201_cs
END FUNCTION
 
 
 
 
FUNCTION t201_pjk01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_pjj02    LIKE pjj_file.pjj02,
   l_pjjacti  LIKE pjj_file.pjjacti
 
   LET g_errno=''
   SELECT UNIQUE pjj02,pjj04,pjjacti
     INTO l_pjj02,g_pjj04,l_pjjacti   
     FROM pjj_file           
    WHERE pjj01=g_pjk.pjk01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-048'
                                LET l_pjj02=NULL
                               
       WHEN l_pjjacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pjj02 TO FORMONLY.pjj02
   END IF       
END FUNCTION
 
FUNCTION t201_pjk02(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_pjk03    LIKE pjk_file.pjk03,
   l_pjkacti  LIKE pjk_file.pjkacti
   LET g_errno=''
   SELECT UNIQUE pjk03,pjkacti  
     INTO l_pjk03,l_pjkacti   
     FROM pjk_file                    
    WHERE pjk_file.pjk01 = g_pjk.pjk01 AND pjk_file.pjk02=g_pjk.pjk02 
 
 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-049'    
                                LET l_pjk03=NULL
                               
       WHEN l_pjkacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pjk03 TO FORMONLY.pjk03
   END IF       
END FUNCTION
 
FUNCTION t201_pjk05(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_gem02    LIKE gem_file.gem02,
   l_gemacti  LIKE gen_file.genacti   
   
   LET g_errno=''
   SELECT UNIQUE gem02,gemacti
     INTO l_gem02,l_gemacti
     FROM gem_file
     WHERE gem01=g_pjk.pjk05 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-061'
                                LET l_gem02=NULL                              
       WHEN l_gemacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN       
 
      DISPLAY l_gem02 TO FORMONLY.gem02
 
   END IF
END FUNCTION
 
FUNCTION t201_pjk11(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_pjb03    LIKE pjb_file.pjb03,
   l_pjbacti  LIKE pjb_file.pjbacti
 
   LET g_errno=''
   SELECT UNIQUE pjb03,pjbacti
     INTO l_pjb03,l_pjbacti
     FROM pjb_file,pjj_file
    WHERE pjb01=g_pjj04 AND pjb02=g_pjk.pjk11
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-060'
                                LET l_pjb03=NULL
                               
       WHEN l_pjbacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pjb03 TO FORMONLY.pjb03
   END IF       
END FUNCTION
 
FUNCTION t201_pjk25(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_gen02    LIKE gen_file.gen02,
   l_genacti  LIKE gen_file.genacti
 
   LET g_errno=''
   SELECT UNIQUE gen02,genacti
     INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01=g_pjk.pjk25 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-062'
                                LET l_gen02=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF     
   
END FUNCTION
 
FUNCTION t201_pjk26(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_gemacti  LIKE gen_file.genacti,
   l_gem02_2    LIKE gem_file.gem02
   
   LET g_errno=''
   SELECT UNIQUE gem02,gemacti
     INTO l_gem02_2,l_gemacti
     FROM gem_file
     WHERE gem01=g_pjk.pjk26 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-061'
                                LET l_gem02_2=NULL                              
       WHEN l_gemacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN       
 
      DISPLAY l_gem02_2 TO FORMONLY.gem02_2
   END IF
END FUNCTION
 
FUNCTION t201_pjk09(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_pjwacti  LIKE pjw_file.pjwacti,
   l_pjw02    LIKE pjw_file.pjw02
   
   LET g_errno=''
   SELECT UNIQUE pjw02,pjwacti
     INTO l_pjw02,l_pjwacti
     FROM pjw_file
     WHERE pjw01=g_pjk.pjk09 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-063'
                                LET l_pjw02=NULL                              
       WHEN l_pjwacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN       
 
      DISPLAY l_pjw02 TO FORMONLY.pjw02
   END IF
END FUNCTION
 
FUNCTION t201_pjk10(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_pjwacti  LIKE pjw_file.pjwacti,
   l_pjw02_2    LIKE pjw_file.pjw02
   
   LET g_errno=''
   SELECT UNIQUE pjw02,pjwacti
     INTO l_pjw02_2,l_pjwacti
     FROM pjw_file
     WHERE pjw01=g_pjk.pjk10 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-063'
                                LET l_pjw02_2=NULL                              
       WHEN l_pjwacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN       
 
      DISPLAY l_pjw02_2 TO FORMONLY.pjw02_2
   END IF
END FUNCTION
 
FUNCTION t201_pjk29(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          
   l_gen02_2    LIKE gen_file.gen02,
   l_genacti  LIKE gen_file.genacti
 
   LET g_errno=''
   SELECT UNIQUE gen02,genacti
     INTO l_gen02_2,l_genacti
     FROM gen_file
    WHERE gen01=g_pjk.pjk29 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-062'
                                LET l_gen02_2=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02_2 TO FORMONLY.gen02_2
   END IF     
   
END FUNCTION
 
 
 
FUNCTION t201_i(p_cmd)
   DEFINE   p_cmd       LIKE type_file.chr1,          
            l_gen02     LIKE gen_file.gen02,
            l_gen02_2   LIKE gen_file.gen02,
            l_gem02     LIKE gem_file.gem02,
            l_gem02_2   LIKE gem_file.gem02,
            l_pjw02     LIKE pjw_file.pjw02,
            l_pjw02_2   LIKE pjw_file.pjw02,
            l_pjb03     LIKE pjb_file.pjb03,
            l_input     LIKE type_file.chr1,          
            l_n         LIKE type_file.num5,
            l_n1        LIKE type_file.num5,
            l_n2        LIKE type_file.num5,
            l_n4        LIKE type_file.num5,
            l_rate      LIKE pjk_file.pjk15   
            
            
            
            
                
   DISPLAY BY NAME g_pjk.pjk01,g_pjk.pjk02,g_pjk.pjk03,g_pjk.pjk05,#,g_pjk.pjk04
                   g_pjk.pjk06,g_pjk.pjk07,g_pjk.pjk08,g_pjk.pjk09,g_pjk.pjk10,
                   g_pjk.pjk11,g_pjk.pjk12,g_pjk.pjk13,g_pjk.pjk14,g_pjk.pjk15,
                   g_pjk.pjk16,g_pjk.pjk17,g_pjk.pjk18,g_pjk.pjk19,g_pjk.pjk20,
                   g_pjk.pjk21,g_pjk.pjk22,g_pjk.pjk23,g_pjk.pjk24,g_pjk.pjk25,
                   g_pjk.pjk26,g_pjk.pjk27,g_pjk.pjk28,g_pjk.pjk29,g_pjk.pjk30,
                   g_pjk.pjkuser,g_pjk.pjkgrup,
                   g_pjk.pjkmodu,g_pjk.pjkdate,g_pjk.pjkacti
 
   INPUT BY NAME
      g_pjk.pjk05,g_pjk.pjk11,g_pjk.pjk25,g_pjk.pjk13,
      g_pjk.pjk06,g_pjk.pjk12,g_pjk.pjk26,
      g_pjk.pjk09,g_pjk.pjk10,
      g_pjk.pjk14,g_pjk.pjk16,
      g_pjk.pjk15,g_pjk.pjk17
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          IF cl_null(g_pjk.pjkacti) THEN LET g_pjk.pjkacti = 'Y'     END IF
          IF cl_null(g_pjk.pjkgrup) THEN LET g_pjk.pjkgrup = g_grup  END IF
          IF cl_null(g_pjk.pjkuser) THEN LET g_pjk.pjkuser = g_user  END IF
          IF cl_null(g_pjk.pjkdate) THEN LET g_pjk.pjkdate = g_today END IF
          CALL t201_set_entry(p_cmd)
          CALL t201_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
     
 
     AFTER FIELD pjk05
        DISPLAY "AFTER FIELD pjk05"
        IF NOT cl_null(g_pjk.pjk05) THEN
           IF g_pjk_t.pjk05 IS NULL OR (g_pjk.pjk05 <> g_pjk_t.pjk05) THEN 
              CALL t201_pjk05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('pjk05:',g_errno,0)
                 LET g_pjk.pjk05 =g_pjk_t.pjk05 
                 DISPLAY g_pjk.pjk05 TO pjk05   
                 NEXT FIELD pjk05 
              END IF                                          
           END IF
        END IF 
 
       
      AFTER FIELD pjk09
        DISPLAY "AFTER FIELD pjk09"
        IF NOT cl_null(g_pjk.pjk09) THEN
           IF g_pjk_t.pjk09 IS NULL OR (g_pjk.pjk09 <> g_pjk_t.pjk09) THEN 
              CALL t201_pjk09('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('pjk09:',g_errno,0)
                 LET g_pjk.pjk09 =g_pjk_t.pjk09 
                 DISPLAY g_pjk.pjk09 TO pjk09  
                 NEXT FIELD pjk09 
              END IF                                            
           END IF
        END IF                    
 
      AFTER FIELD pjk10
        DISPLAY "AFTER FIELD pjk10"
        IF NOT cl_null(g_pjk.pjk10) THEN
           IF g_pjk_t.pjk10 IS NULL OR (g_pjk.pjk10 <> g_pjk_t.pjk10) THEN 
              CALL t201_pjk10('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('pjk10:',g_errno,0)
                 LET g_pjk.pjk10 =g_pjk_t.pjk10 
                 DISPLAY g_pjk.pjk10 TO pjk10   
                 NEXT FIELD pjk10 
              END IF                                            
           END IF
        END IF                    
          
     AFTER FIELD pjk11
        DISPLAY "AFTER FIELD pjk11"
        IF NOT cl_null(g_pjk.pjk11) THEN
           IF g_pjk_t.pjk11 IS NULL OR (g_pjk.pjk11 <> g_pjk_t.pjk11) THEN 
              CALL t201_pjk11('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('pjk11:',g_errno,0)
                 LET g_pjk.pjk11 =g_pjk_t.pjk11 
                 DISPLAY g_pjk.pjk11 TO pjk11  
                 NEXT FIELD pjk11                                          
              END IF
           END IF   
        END IF           
 
          
      AFTER FIELD pjk12
        DISPLAY "AFTER FIELD pjk12"
        IF NOT cl_null(g_pjk.pjk12) THEN
           IF g_pjk_t.pjk12 IS NULL OR (g_pjk.pjk12 <> g_pjk_t.pjk12) THEN 
              IF (g_pjk.pjk12 < 1) OR (g_pjk.pjk12 > 100) THEN
                  CALL cl_err('pjk12','apj-064',0)
                  LET g_pjk.pjk12 =g_pjk_t.pjk12
                  DISPLAY g_pjk.pjk12 TO pjk12
                  NEXT FIELD pjk12               
              END IF                    
           END IF
        END IF
          
    AFTER FIELD pjk13
        DISPLAY "AFTER FIELD pjk13"
        IF cl_null(g_pjk.pjk13) THEN 
           LET g_pjk.pjk13='N'
           DISPLAY BY NAME g_pjk.pjk13
         ELSE
           IF g_pjk.pjk13 matches'[YN]' THEN             
              DISPLAY BY NAME g_pjk.pjk13
           END IF
         END IF
   
      AFTER FIELD pjk14
        DISPLAY "AFTER FIELD pjk14"
        IF NOT cl_null(g_pjk.pjk14) THEN
          IF g_pjk_t.pjk14 IS NULL OR (g_pjk.pjk14 <> g_pjk_t.pjk14) THEN       
            IF g_pjk.pjk14 < 0 THEN
               CALL cl_err('pjk14','apj-036',0)
               LET g_pjk.pjk14 =g_pjk_t.pjk14
               DISPLAY g_pjk.pjk14 TO pjk14
               NEXT FIELD pjk14
            END IF
          END IF  
         END IF  
   
      AFTER FIELD pjk15
        DISPLAY "AFTER FIELD pjk15"
        IF NOT cl_null(g_pjk.pjk15) THEN
          IF g_pjk_t.pjk15 IS NULL OR (g_pjk.pjk15 <> g_pjk_t.pjk15) THEN
            IF g_pjk.pjk15 < 0 THEN
               CALL cl_err('pjk15','apj-036',0)
               LET g_pjk.pjk15 =g_pjk_t.pjk15
               DISPLAY g_pjk.pjk15 TO pjk15
               NEXT FIELD pjk15
            END IF
          END IF  
         END IF     
   
   AFTER FIELD pjk16                           
       DISPLAY "AFTER FIELD pjk16"
       IF NOT cl_null(g_pjk.pjk16) THEN
          IF g_pjk_t.pjk16 IS NULL OR (g_pjk.pjk16 <> g_pjk_t.pjk16) THEN      
             IF g_pjk.pjk16 < g_today THEN
                CALL cl_err(g_pjk.pjk16,"apj-043",0)
                LET g_pjk.pjk16 =g_pjk_t.pjk16  
                NEXT FIELD pjk16
             END IF 
             IF NOT cl_null(g_pjk.pjk17) THEN        
                IF g_pjk.pjk16>g_pjk.pjk17 THEN
                   CALL cl_err(g_pjk.pjk17,"apj-044",0)  
                   LET g_pjk.pjk16 =g_pjk_t.pjk16 
                   NEXT FIELD pjk16             
                END IF
             END IF 
             DISPLAY g_pjk.pjk16 TO pjk16        
          END IF       
       END IF   
   
   
    AFTER FIELD pjk17
        DISPLAY "AFTER FIELD pjk17"
        IF NOT cl_null(g_pjk.pjk17) THEN
          IF g_pjk_t.pjk17 IS NULL OR (g_pjk.pjk17 <> g_pjk_t.pjk17) THEN      
          IF g_pjk.pjk16>g_pjk.pjk17 THEN
              CALL cl_err(g_pjk.pjk17,"apj-044",0)
              LET g_pjk.pjk17 =g_pjk_t.pjk17
              DISPLAY g_pjk.pjk17 TO pjk17
              NEXT FIELD pjk17  
          END IF
       END IF  
     END IF   
 
     AFTER FIELD pjk25
        DISPLAY "AFTER FIELD pjk25"
        IF NOT cl_null(g_pjk.pjk25) THEN
          IF g_pjk_t.pjk25 IS NULL OR (g_pjk.pjk25 <> g_pjk_t.pjk25) THEN 
            CALL t201_pjk25('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('pjk25:',g_errno,0)
               LET g_pjk.pjk25 =g_pjk_t.pjk25 
               DISPLAY g_pjk.pjk25 TO pjk25   
               NEXT FIELD pjk25                                        
            END IF
          END IF
        END IF  
        
     AFTER FIELD pjk26
        DISPLAY "AFTER FIELD pjk26"
        IF NOT cl_null(g_pjk.pjk26) THEN
          IF g_pjk_t.pjk26 IS NULL OR (g_pjk.pjk26 <> g_pjk_t.pjk26) THEN 
           CALL t201_pjk26('a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('pjk26:',g_errno,0)
              LET g_pjk.pjk26 =g_pjk_t.pjk26 
              DISPLAY g_pjk.pjk26 TO pjk26   
              NEXT FIELD pjk26                                        
           END IF
         END IF  
        END IF         
        
#     AFTER FIELD pjk29
#        DISPLAY "AFTER FIELD pjk05"
#        IF g_pjk.pjk05 IS NOT NULL THEN
#           CALL t201_pjk05('a')
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err('pjk05:',g_errno,0)
#              LET g_pjk.pjk05 =g_pjk_t.pjk05 
#              DISPLAY g_pjk.pjk05 TO pjk05   
#              NEXT FIELD pjk05                                        
#           END IF
#        END IF         
        
      AFTER INPUT
         LET g_pjk.pjkuser = s_get_data_owner("pjk_file") #FUN-C10039
         LET g_pjk.pjkgrup = s_get_data_group("pjk_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF (g_pjk.pjk01 IS NULL) OR (g_pjk.pjk02 IS NULL)  THEN
               DISPLAY BY NAME g_pjk.pjk01,g_pjk.pjk02
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD pjk01
            END IF
            IF l_input='Y' THEN
               NEXT FIELD pjk02
            END IF  
   
 
      ON ACTION CONTROLO                        
         IF INFIELD(pjk01) OR INFIELD(pjk02) THEN
            LET g_pjk.* = g_pjk_t.*
            CALL t201_show()
            NEXT FIELD pjk01
#            NEXT FIELD pjk05
            
         END IF
 
 
           ON ACTION controlp
           CASE
                 
              WHEN INFIELD(pjk05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"                 
                 LET g_qryparam.default1 = g_pjk.pjk05
                 CALL cl_create_qry() RETURNING  g_pjk.pjk05
                 DISPLAY BY NAME g_pjk.pjk05
                 CALL t201_pjk05('a')
	         NEXT FIELD pjk05                                  
                 
              WHEN INFIELD(pjk11)
                SELECT UNIQUE pjj04
                  INTO g_pjj04   
                  FROM pjj_file           
                 WHERE pjj01=g_pjk.pjk01
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb2"
                 LET g_qryparam.arg1 = g_pjj04
                 LET g_qryparam.default1 = g_pjk.pjk11
                 CALL cl_create_qry() RETURNING  g_pjk.pjk11
                 DISPLAY BY NAME g_pjk.pjk11
                 CALL t201_pjk11('a')
	         NEXT FIELD pjk11
                 
              WHEN INFIELD(pjk25)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_pjk.pjk25
                 CALL cl_create_qry() RETURNING g_pjk.pjk25
                 DISPLAY BY NAME g_pjk.pjk25
                 CALL t201_pjk25('a')
	         NEXT FIELD pjk25                 
                 
              WHEN INFIELD(pjk26)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_pjk.pjk26
                 CALL cl_create_qry() RETURNING g_pjk.pjk26
                 DISPLAY BY NAME g_pjk.pjk26
                 CALL t201_pjk26('a')
	         NEXT FIELD pjk26
                 
              WHEN INFIELD(pjk09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjw"
                 LET g_qryparam.default1 = g_pjk.pjk09
                 CALL cl_create_qry() RETURNING g_pjk.pjk09
                 DISPLAY BY NAME g_pjk.pjk09
                 CALL t201_pjk09('a')
	         NEXT FIELD pjk09                 
                 
              WHEN INFIELD(pjk10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjw"
                 LET g_qryparam.default1 = g_pjk.pjk10
                 CALL cl_create_qry() RETURNING g_pjk.pjk10
                 DISPLAY BY NAME g_pjk.pjk10
                 CALL t201_pjk10('a')
	         NEXT FIELD pjk10
                 
 
              
              OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
		RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
   END INPUT
 
END FUNCTION  
 
FUNCTION t201_q()
##CKP
    
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
   # INITIALIZE g_pjk.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
       
    CALL t201_curs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t201_count
    FETCH t201_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t201_cs                          
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,0)
        INITIALIZE g_pjk.* TO NULL
    ELSE
        CALL t201_fetch('F')              
    END IF
END FUNCTION 
                   
 
 
FUNCTION t201_fetch(p_flpjk)
    DEFINE
        p_flpjk         LIKE type_file.chr1           
    CASE p_flpjk
        WHEN 'N' FETCH NEXT     t201_cs INTO g_pjk.pjk01,g_pjk.pjk02  
        WHEN 'P' FETCH PREVIOUS t201_cs INTO g_pjk.pjk01,g_pjk.pjk02
        WHEN 'F' FETCH FIRST    t201_cs INTO g_pjk.pjk01,g_pjk.pjk02
        WHEN 'L' FETCH LAST     t201_cs INTO g_pjk.pjk01,g_pjk.pjk02
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
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
          FETCH ABSOLUTE g_jump t201_cs INTO g_pjk.pjk01,g_pjk.pjk02 
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,0)
        INITIALIZE g_pjk.* TO NULL  
        RETURN
    ELSE
      CASE p_flpjk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_pjk.* FROM pjk_file   
      WHERE pjk01 = g_pjk.pjk01 AND pjk02 = g_pjk.pjk02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pjk_file",g_pjk.pjk01,"",SQLCA.sqlcode,"","",0)  
    ELSE
#TQC-840009 --add--
        IF g_pjk.pjk27 IS NULL THEN 
           LET g_pjk.pjk27 = '0'
           UPDATE pjk_file SET (pjk27)=('0')  WHERE pjk01 = g_pjk.pjk01 AND pjk02 = g_pjk.pjk02
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","pjk_file",g_pjk.pjk01,"",STATUS,"","",1) 
           END IF
        END IF   
#TQC-840009 --end--
        LET g_data_owner=g_pjk.pjkuser           
        LET g_data_group=g_pjk.pjkgrup
        CALL t201_show()                  
    END IF
END FUNCTION
 
FUNCTION t201_show()
DEFINE l_n      LIKE type_file.num5
 
   LET g_pjk_t.* = g_pjk.* 
           
   DISPLAY BY NAME g_pjk.pjk01,g_pjk.pjk02,g_pjk.pjk03,g_pjk.pjk05,#,g_pjk.pjk04
                   g_pjk.pjk06,g_pjk.pjk07,g_pjk.pjk08,g_pjk.pjk09,g_pjk.pjk10,
                   g_pjk.pjk11,g_pjk.pjk12,g_pjk.pjk13,g_pjk.pjk14,g_pjk.pjk15,
                   g_pjk.pjk16,g_pjk.pjk17,g_pjk.pjk18,g_pjk.pjk19,g_pjk.pjk20,
                   g_pjk.pjk21,g_pjk.pjk22,g_pjk.pjk23,g_pjk.pjk24,g_pjk.pjk25,
                   g_pjk.pjk26,g_pjk.pjk27,g_pjk.pjk28,g_pjk.pjk29,g_pjk.pjk30,
                   g_pjk.pjkuser,g_pjk.pjkgrup,
                   g_pjk.pjkmodu,g_pjk.pjkdate,g_pjk.pjkacti
 
   CALL t201_pjk01('d') 
   CALL t201_pjk02('d')
   CALL t201_pjk05('d')
   CALL t201_pjk11('d')
   CALL t201_pjk25('d')
   CALL t201_pjk26('d')
   CALL t201_pjk09('d')
   CALL t201_pjk10('d')
   CALL t201_pjk29('d')
   
   CALL cl_show_fld_cont()                   
          
END FUNCTION
 
FUNCTION t201_u()
DEFINE  l_mid  LIKE type_file.num5
 
    IF (g_pjk.pjk01 IS NULL) OR (g_pjk.pjk02 IS NULL)  THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    SELECT * INTO g_pjk.* FROM pjk_file WHERE pjk01=g_pjk.pjk01 AND pjk02=g_pjk.pjk02 
    IF g_pjk.pjkacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    IF g_pjk.pjk27 <> '0'  THEN
       CALL cl_err('','anm-105',0)
       RETURN
    END IF    
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pjk_t.pjk01 = g_pjk.pjk01
    LET g_pjk_t.pjk02 = g_pjk.pjk02
    BEGIN WORK
 
    OPEN t201_cl USING g_pjk.pjk01,g_pjk.pjk02 
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_pjk.*            
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
    LET g_pjk.pjkmodu=g_user              
    LET g_pjk.pjkdate = g_today           
                          
    WHILE TRUE
        CALL t201_i("u")                  
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pjk.*=g_pjk_t.*
            CALL t201_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        UPDATE pjk_file SET pjk_file.* = g_pjk.*  
           WHERE pjk01 = g_pjk.pjk01 AND pjk02 = g_pjk.pjk02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pjk_file",g_pjk.pjk01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t201_cl
    COMMIT WORK
    CALL t201_show()
END FUNCTION
 
FUNCTION t201_out()
  DEFINE  l_cmd    LIKE  type_file.chr1000
      IF cl_null(g_wc) AND NOT cl_null(g_pjk.pjk01) AND NOT cl_null(g_pjk.pjk02) THEN                                      
         LET g_wc ="pjk01='",g_pjk.pjk01,"' AND pjk02='",g_pjk.pjk02,"'"                                                   
      END IF                                                                                                               
      IF cl_null(g_wc) THEN                                                                                                
         CALL cl_err('','9057',0)                                                                                          
         RETURN                                                                                                            
      END IF                                                                                                               
      LET l_cmd = 'p_query "apjt201" "',g_wc CLIPPED,'"'                                                                   
      CALL cl_cmdrun(l_cmd)   
END FUNCTION
 
                                               
FUNCTION t201_x()
  DEFINE l_flag    LIKE  type_file.chr1   #檢查狀態
    IF (g_pjk.pjk01 IS NULL) OR (g_pjk.pjk02 IS NULL) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
   
    OPEN t201_cl USING g_pjk.pjk01 , g_pjk.pjk02   
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_pjk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t201_show()
    IF cl_exp(0,0,g_pjk.pjkacti) THEN
        LET g_chr=g_pjk.pjkacti
        IF g_pjk.pjkacti='N' THEN
            LET g_pjk.pjkacti='Y'
        ELSE
           IF g_pjk.pjk27 <> '0' THEN
              CALL cl_err('','apj-066',1)   
           ELSE 
              CALL s_wbs_frontchk('',g_pjk.pjk02,'2') RETURNING l_flag 
              IF l_flag ='1' THEN
                 CALL cl_err(g_pjk.pjk02,'apj-065',1) 
              ELSE 
                LET g_pjk.pjkacti='N'    
              END IF 
          END IF
       END IF
            
 
        UPDATE pjk_file
            SET pjkacti=g_pjk.pjkacti
            WHERE pjk01 = g_pjk.pjk01 AND pjk02 = g_pjk.pjk02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,0)
            LET g_pjk.pjkacti=g_chr
        END IF
        DISPLAY BY NAME g_pjk.pjkacti
    END IF
    CLOSE t201_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t201_r()
    IF g_pjk.pjk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t201_cl USING g_pjk.pjk01 ,g_pjk.pjk02   
    IF g_pjk.pjk27 <> '0'  THEN
       CALL cl_err('','anm-105',1)
       RETURN
    END IF
       
    IF g_pjk.pjkacti = 'N' THEN
       CALL cl_err('','aic-201',1)
	RETURN
    END IF
 
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 0)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_pjk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t201_show()
    IF cl_delete() THEN
       DELETE FROM pjk_file WHERE pjk01 = g_pjk.pjk01 AND pjk02 = g_pjk.pjk02
       CLEAR FORM
       OPEN t201_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t201_cs
          CLOSE t201_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t201_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t201_cs
          CLOSE t201_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t201_cs
       IF g_row_count>0 THEN
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t201_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 
          CALL t201_fetch('/')
       END IF
       END IF
    END IF
    CLOSE t201_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION t201_y()
DEFINE l_cnt  LIKE type_file.num5        
 
   IF cl_null(g_pjk.pjk01) THEN 
        CALL cl_err('','apj-003',0) 
        RETURN 
   END IF
   
   IF g_pjk.pjkacti='N' THEN
        CALL cl_err('','9027',1)
        RETURN
   END IF
###########
   
   IF g_pjk.pjk27 <> '0' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
###########   
   
   IF NOT cl_confirm('apj-067') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t201_cl USING g_pjk.pjk01,g_pjk.pjk02  
   IF STATUS THEN
      CALL cl_err("OPEN t201_cl:", STATUS, 1)
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t201_cl INTO g_pjk.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,0)      
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE pjk_file SET (pjk27)=('1')  WHERE pjk01 = g_pjk.pjk01 AND pjk02 = g_pjk.pjk02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pjk_file",g_pjk.pjk01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pjk_file",g_pjk.pjk01,"","9050","","",1) 
         LET g_success = 'N'
      ELSE
         LET g_pjk.pjk27 = '1'
         DISPLAY BY NAME g_pjk.pjk27
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t201_z()
 
   IF cl_null(g_pjk.pjk01) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF
 
   IF g_pjk.pjkacti='N' THEN
        CALL cl_err('','9027',1)
        RETURN
   END IF
   
   IF g_pjk.pjk27 <> '1' THEN
      CALL cl_err('','9002',0)
      RETURN
   END IF
 
 
   IF NOT cl_confirm('apj-068') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t201_cl USING g_pjk.pjk01 , g_pjk.pjk02    
   IF STATUS THEN
      CALL cl_err("OPEN t201_cl:", STATUS, 1)
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t201_cl INTO g_pjk.*            
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,0)     
      CLOSE t201_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE pjk_file SET(pjk27)=('0') WHERE pjk01 = g_pjk.pjk01 AND pjk02 = g_pjk.pjk02
   IF SQLCA.sqlcode  THEN
     
      CALL cl_err3("upd","pjk_file",g_pjk.pjk01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         
         CALL cl_err3("upd","pjk_file",g_pjk.pjk01,"","9050","","",1) 
         LET g_success = 'N'
      ELSE
         LET g_pjk.pjk27 = '0'
         DISPLAY BY NAME g_pjk.pjk27
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t201_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("g_pjk.pjk01",TRUE)
         CALL cl_set_comp_entry("g_pjk.pjk02",TRUE)
         CALL cl_set_comp_entry("g_pjk.pjk27,g_pjk.pjk05,   
                               g_pjk.pjk06,g_pjk.pjk11,g_pjk.pjk12,
                               g_pjk.pjk25,g_pjk.pjk26,g_pjk.pjk09,
                               g_pjk.pjk10,g_pjk.pjk14,g_pjk.pjk15,
                               g_pjk.pjk16,g_pjk.pjk17",TRUE) # g_pjk.pjk02,
     END IF
 
END FUNCTION
 
FUNCTION t201_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("g_pjk.pjk01",FALSE)
       CALL cl_set_comp_entry("g_pjk.pjk02",FALSE)
       
       CALL cl_set_comp_entry("g_pjk.pjk27,g_pjk.pjk05,
                               g_pjk.pjk06,g_pjk.pjk11,g_pjk.pjk12,
                               g_pjk.pjk25,g_pjk.pjk26,g_pjk.pjk09,
                               g_pjk.pjk10,g_pjk.pjk14,g_pjk.pjk15,
                               g_pjk.pjk16,g_pjk.pjk17",TRUE) #g_pjk.pjk02,
    END IF
 
END FUNCTION
#No.FUN-790025

