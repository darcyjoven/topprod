# Prog. Version..: '5.30.06-13.04.09(00008)'     #
#
# Pattern name...: almi860.4gl
# Descriptions...: 廣告位基本資料維護作業
# Date & Author..: FUN-960081 08/08/04 By dxfwo  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/25 by dxfwo 有INFO页签的，在CONSTRUCT的时候要把 oriu和orig两个栏位开放
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:MOD-B10146 11/01/21 By huangtao 取消簽核功能
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960081 
DEFINE g_lsb                RECORD LIKE lsb_file.*,
       g_lsb_t              RECORD LIKE lsb_file.*,
       g_lsb01_t            LIKE lsb_file.lsb01,
       g_a                  varchar(20),    
       g_b                  varchar(20),    
       g_v                  varchar(20),   
       g_wc                 string,        
       g_sql                STRING
 
DEFINE g_forupd_sql         STRING         #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done  SMALLINT       
DEFINE g_chr                VARCHAR(1)
DEFINE g_chr2               VARCHAR(1)
DEFINE g_chr3               VARCHAR(1)
DEFINE g_cnt                INTEGER
DEFINE g_i                  SMALLINT       #count/index for any purpose
DEFINE g_msg                VARCHAR(72)
DEFINE g_curs_index         INTEGER
DEFINE g_row_count          INTEGER       
DEFINE g_jump               INTEGER      
DEFINE g_no_ask            SMALLINT     
DEFINE g_time               VARCHAR(8)  
 
MAIN
 IF FGL_GETENV("FGLGUI")<>"0" THEN
    OPTIONS
        INPUT NO WRAP
 END IF
    DEFER INTERRUPT                   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   INITIALIZE g_lsb.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM lsb_file WHERE lsb01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i860_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i860_w WITH FORM "alm/42f/almi860"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   LET g_lsb.lsbstore = g_plant
   LET g_action_choice = ""
   CALL i860_menu()
 
   CLOSE WINDOW i860_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i860_curs()
DEFINE ls STRING
DEFINE p_cmd        VARCHAR(1),
       l_rtz13   LIKE rtz_file.rtz13,  #FUN-A80148 add
       l_lmb03   LIKE lmb_file.lmb03,
       l_lmc04   LIKE lmc_file.lmc04
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON               
        lsb01,lsbstore,lsblegal, 
        lsb03,lsb04,
        lsb05,lsb06,lsb07,lsb08,
        lsb09,lsb10,lsb11,
#        lsb12,lsb13,lsb14,lsb15,                        #MOD-B10146 mark
        lsb12,lsb13,                                     #MOD-B10146
        lsb16,lsb17,lsb18,lsbuser,
        lsbgrup,lsbcrat,lsbmodu,
        lsbacti,lsbdate,lsboriu,lsborig    #No.FUN-9B0136
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lsb01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsb01"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lsbstore IN ",g_auth," " #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsb01
                 NEXT FIELD lsb01
              WHEN INFIELD(lsbstore)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsbstore"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lsbstore IN ",g_auth," " #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsbstore
                 NEXT FIELD lsbstore
              WHEN INFIELD(lsblegal)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form = "q_lsblegal"
                 LET g_qryparam.where = " lsbstore IN ",g_auth," " #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsblegal
                 NEXT FIELD lsblegal
              WHEN INFIELD(lsb03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsb03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lsbstore IN ",g_auth," " #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsb03
                 NEXT FIELD lsb03                 
              WHEN INFIELD(lsb04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_lsb04"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = " lsbstore IN ",g_auth," " #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsb04
                 NEXT FIELD lsb04
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                      
    #        LET g_wc = g_wc clipped," AND lsbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                     
    #        LET g_wc = g_wc clipped," AND lsbgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN       
    #        LET g_wc = g_wc clipped," AND lsbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lsbuser', 'lsbgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT lsb01 FROM lsb_file ", 
        " WHERE ",g_wc CLIPPED,
        "   AND lsbstore IN ",g_auth CLIPPED,    #No.FUN-A10060
        " ORDER BY lsb01"
    PREPARE i860_prepare FROM g_sql
    DECLARE i860_cs                               # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i860_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM lsb_file ",
        " WHERE ",g_wc CLIPPED, 
        "   AND lsbstore IN ",g_auth CLIPPED     #No.FUN-A10060
    PREPARE i860_precount FROM g_sql
    DECLARE i860_count CURSOR FOR i860_precount
END FUNCTION
 
FUNCTION i860_menu()
 
   DEFINE l_cmd  VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i860_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i860_q()
            END IF
        ON ACTION next
            CALL i860_fetch('N')
        ON ACTION previous
            CALL i860_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsb.lsbstore,g_plant) THEN               
                 CALL i860_u()
#              END IF   
            END IF
#       ON ACTION invalid
#           LET g_action_choice="invalid"
#           IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsb.lsbstore,g_plant) THEN
#                CALL i860_x()
#                CALL i860_field_pic()
#              END IF   
#           END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsb.lsbstore,g_plant) THEN
                 CALL i860_r()
#              END IF   
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lsb.lsbstore,g_plant) THEN 
                 CALL i860_copy()
#              END IF   
            END IF
                        
#      ON ACTION output
#           LET g_action_choice="output"
#           IF cl_chk_act_auth()
#              THEN CALL i860_out()
#           END IF
 
#       ON ACTION ef_approval         #ワ瞄 
#           LET g_action_choice="ef_approval"
#           IF cl_chk_act_auth() THEN
# #            IF cl_chk_mach_auth(g_lsb.lsbstore,g_plant) THEN 
#                 CALL i860_ef()
# #            END IF 
#           END IF
 
        ON ACTION confirm 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsb.lsbstore,g_plant) THEN
               CALL i860_y()         
#             END IF  
            END IF
              CALL i860_field_pic()
 
        ON ACTION undo_confirm      
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsb.lsbstore,g_plant) THEN 
               CALL i860_unconfirm()
               CALL i860_field_pic()
#             END IF  
            END IF
 
 
        ON ACTION volid 
            LET g_action_choice="volid"
            IF cl_chk_act_auth() THEN
#             IF cl_chk_mach_auth(g_lsb.lsbstore,g_plant) THEN
               CALL i860_v()
               CALL i860_field_pic()
#             END IF  
            END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL i860_fetch('/')
        ON ACTION first
            CALL i860_fetch('F')
        ON ACTION last
            CALL i860_fetch('L')
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
 
         ON ACTION related_document    
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_lsb.lsb01 IS NOT NULL THEN
                 LET g_doc.column1 = "lsb01"
                 LET g_doc.value1 = g_lsb.lsb01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE i860_cs
END FUNCTION
 
 
FUNCTION i860_a()
   DEFINE    l_n             LIKE type_file.num5
#  DEFINE    l_tqa06         LIKE tqa_file.tqa06
#  SELECT tqa06 INTO l_tqa06 FROM tqa_file
#   WHERE tqa03 = '14'       	 
#     AND tqaacti = 'Y'
#     AND tqa01 IN(SELECT tqb03 FROM tqb_file
#    	              WHERE tqbacti = 'Y'
#    	                AND tqb09 = '2'
#    	                AND tqb01 = g_plant) 
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
#     CALL cl_err('','alm-600',1)
#     RETURN 
#  END IF 
   
   SELECT COUNT(*) INTO l_n FROM rtz_file
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'
    IF l_n < 1 THEN 
       CALL cl_err('','alm-606',1)
       RETURN 
    END IF
#############################   
    MESSAGE ""
    CLEAR FORM                              
    INITIALIZE g_lsb.* LIKE lsb_file.*
    INITIALIZE g_lsb_t.* LIKE lsb_file.*
    LET g_lsb01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lsb.lsbstore = g_plant
        LET g_lsb.lsblegal = g_legal
        LET g_lsb.lsb08 = '0'
        LET g_lsb.lsb10 = '0'
        LET g_lsb.lsb11 = '0'
        LET g_lsb.lsb14 = 'N'
        LET g_lsb.lsb15 = '0'
        LET g_lsb.lsb16 = 'N'        
        LET g_lsb.lsbuser = g_user
        LET g_lsb.lsboriu = g_user #FUN-980030
        LET g_lsb.lsborig = g_grup #FUN-980030
        LET g_lsb.lsbcrat = g_today
        LET g_lsb.lsbgrup = g_grup
        LET g_lsb.lsbacti = 'Y'
        LET g_lsb.lsbstore = g_plant
 
         CALL i860_i("a")                      
         IF INT_FLAG THEN                       
             INITIALIZE g_lsb.* TO NULL
             LET INT_FLAG = 0
             CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        
        IF g_lsb.lsb01 IS NULL THEN           
            CONTINUE WHILE
        END IF
#add by dxfwo---begin--
#       CALL i860_auno1()
#       RETURNING g_lsb.lsbstore
#       DISPLAY BY NAME g_lsb.lsbstore
#add by dxfwo---end------
        INSERT INTO lsb_file VALUES(g_lsb.*)      # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lsb_file",g_lsb.lsb01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
            SELECT lsb01 INTO g_lsb.lsb01 FROM lsb_file
                     WHERE lsb01 = g_lsb.lsb01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION

FUNCTION i860_i(p_cmd)
   DEFINE   p_cmd        VARCHAR(1),
            l_rtz13   LIKE rtz_file.rtz13,   #FUN-A80148 add
            l_lmb03   LIKE lmb_file.lmb03,
            l_lmc04   LIKE lmc_file.lmc04,
            l_maxno      VARCHAR(5),
            l_input      VARCHAR(1),
            l_n          SMALLINT
 
 
   DISPLAY BY NAME
#      g_lsb.lsbstore,g_lsb.lsblegal,g_lsb.lsb08,g_lsb.lsb10,g_lsb.lsb11,g_lsb.lsb14,  #MOD-B10146 mark
#      g_lsb.lsb15,g_lsb.lsb16,g_lsb.lsb17,                                            #MOD-B10146 mark
      g_lsb.lsbstore,g_lsb.lsblegal,g_lsb.lsb08,g_lsb.lsb10,g_lsb.lsb11,               #MOD-B10146 
      g_lsb.lsb16,g_lsb.lsb17,                                                         #MOD-B10146
      g_lsb.lsb18,g_lsb.lsbuser,g_lsb.lsbgrup,
      g_lsb.lsbcrat,g_lsb.lsbacti,g_lsb.lsbdate
 
   CALL i860_lsbstore(p_cmd)
   INPUT BY NAME g_lsb.lsboriu,g_lsb.lsborig,
      g_lsb.lsb01,g_lsb.lsb03,g_lsb.lsb04,
      g_lsb.lsb05,g_lsb.lsb06,g_lsb.lsb07,g_lsb.lsb08,
      g_lsb.lsb09,g_lsb.lsb10,g_lsb.lsb11,g_lsb.lsb12,
      g_lsb.lsb13
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i860_set_entry(p_cmd)
          CALL i860_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
      
    IF g_lsb.lsb16 = 'Y' THEN                                                                                                       
        CALL cL_set_comp_entry("lsb03,lsb04,lsb05,lsb06,lsb08,lsb10,lsb11                                                     
        ",FALSE)                                                                                                                    
    ELSE                                                                                                                            
        CALL cL_set_comp_entry("lsb03,lsb04,lsb05,lsb06,lsb08,lsb10,lsb11                                                     
        ",TRUE)                                                                                                                     
    END IF
 
     AFTER FIELD lsb01
         IF g_lsb.lsb01 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lsb.lsb01 != g_lsb01_t)THEN
                 CALL i860_check_lsb01(g_lsb.lsb01) 
                  IF g_success = 'N' THEN                                               
                     LET g_lsb.lsb01 = g_lsb_t.lsb01                                                               
                    DISPLAY BY NAME g_lsb.lsb01                                                                     
                    NEXT FIELD lsb01                                                                                  
                  END IF
            END IF  
         ELSE
            CALL cl_err(g_lsb.lsb01,'alm-055',1)
            NEXT FIELD lsb01  
         END IF
 
#      AFTER FIELD lsbstore
#         IF g_lsb.lsbstore IS NOT NULL THEN
#            CALL s_alm_valid(g_lsb.lsbstore,g_lsb.lsb03,g_lsb.lsb04,'','')
#              RETURNING l_rtz13,l_lmb03,l_lmc04
#          
#            IF NOT cl_null(g_errno) THEN 
#               CALL cl_err(g_lsb.lsbstore,g_errno,1)
#               NEXT FIELD lsbstore 
#            ELSE
#            	  DISPLAY l_rtz13 TO FORMONLY.rtz13
#            	  DISPLAY l_lmb03 TO FORMONLY.lmb03
#            	  DISPLAY l_lmc04 TO FORMONLY.lmc04         	  
#            END IF
#         END IF
         
      AFTER FIELD lsb03
         IF g_lsb.lsb03 IS NOT NULL THEN
            CALL i860_lsb03(p_cmd)
          
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(g_lsb.lsb03,g_errno,1)
               NEXT FIELD lsb03        	  
            END IF
         END IF  
 
      BEFORE FIELD lsb04
         IF g_lsb.lsb03 IS NULL THEN 
           NEXT FIELD lsb03
         END IF    
 
      AFTER FIELD lsb04
         IF g_lsb.lsb04 IS NOT NULL THEN
            CALL i860_lsb04(p_cmd)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(g_lsb.lsb04,g_errno,1)
               NEXT FIELD lsb04 
            END IF
         END IF
         
      AFTER FIELD lsb08
        IF NOT cl_null(g_lsb.lsb08) THEN
           IF g_lsb.lsb08<0 THEN
             CALL cl_err('','alm-016',0)
             NEXT FIELD lsb08
           END IF
        END IF
        DISPLAY BY NAME g_lsb.lsb08
 
      AFTER FIELD lsb10
        IF NOT cl_null(g_lsb.lsb10) THEN
           IF g_lsb.lsb10<0 THEN
             CALL cl_err('','alm-061',0)
             NEXT FIELD lsb10
           END IF
        END IF
        DISPLAY BY NAME g_lsb.lsb10
      
      AFTER FIELD lsb11
        IF NOT cl_null(g_lsb.lsb11) THEN
           IF g_lsb.lsb11<0 THEN
             CALL cl_err('','alm-061',0)
             NEXT FIELD lsb11
           END IF
        END IF
        DISPLAY BY NAME g_lsb.lsb11        
    
      AFTER INPUT
         LET g_lsb.lsbuser = s_get_data_owner("lsb_file") #FUN-C10039
         LET g_lsb.lsbgrup = s_get_data_group("lsb_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lsb.lsb01  IS NULL THEN
               DISPLAY BY NAME g_lsb.lsb01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lsb01
            END IF
 
      ON ACTION CONTROLO                      
         IF INFIELD(lsb01) THEN
            LET g_lsb.* = g_lsb_t.*
            CALL i860_show()
            NEXT FIELD lsb01
         END IF
 
     ON ACTION controlp
        CASE
            WHEN INFIELD(lsbstore)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc"
#              LET g_qryparam.arg1 = g_plant_code
               LET g_qryparam.default1 = g_lsb.lsbstore
               LET g_qryparam.default2 = g_lsb.lsb03
               LET g_qryparam.default3 = g_lsb.lsb04
               LET g_qryparam.default4 = l_lmc04
               CALL cl_create_qry() 
                  RETURNING g_lsb.lsbstore,g_lsb.lsb03,g_lsb.lsb04,l_lmc04
               DISPLAY BY NAME g_lsb.lsbstore,g_lsb.lsb03,g_lsb.lsb04
               NEXT FIELD lsbstore
            WHEN INFIELD(lsb03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc001"
               LET g_qryparam.arg1 = g_lsb.lsbstore
               LET g_qryparam.default1 = g_lsb.lsb03
               CALL cl_create_qry() RETURNING g_lsb.lsb03
               DISPLAY BY NAME g_lsb.lsb03
               CALL i860_lsb03('d')
               NEXT FIELD lsb03
            WHEN INFIELD(lsb04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc002"
               LET g_qryparam.arg2 = g_lsb.lsbstore
               LET g_qryparam.arg1 = g_lsb.lsb03
               LET g_qryparam.default1 = g_lsb.lsb04
               CALL cl_create_qry() RETURNING g_lsb.lsb04
               DISPLAY BY NAME g_lsb.lsb04
               CALL i860_lsb04('d')
               NEXT FIELD lsb04
 
           OTHERWISE
              EXIT CASE
           END CASE
 
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
END FUNCTION
#add by dxfwo--begin--------
#FUNCTION i860_auno1()
#DEFINE p_no      LIKE tc_boo_file.tc_boo04
#DEFINE l_lsbstore   LIKE lsb_file.lsbstore
#DEFINE p1        VARCHAR(4)
#DEFINE p2        VARCHAR(6)
#DEFINE l_mallno  LIKE azp_file.azp01
#
#  SELECT azp01 INTO l_mallno FROM azp_file WHERE azp03 = g_dbs
#  LET p1 = l_mallno[1,3],'-'
#  SELECT MAX(lsbstore) INTO l_lsbstore FROM lsb_file   
#   WHERE SUBSTR(lsbstore,1,4) = p1
#  LET p2 = l_lsbstore[5,10]
#  IF l_lsbstore IS NULL THEN
#     LET p2 = '000001'
#  ELSE
#     LET p2 = p2+1 USING '&&&&&&'
#  END IF
#  LET p_no = p1,p2
#  RETURN p_no
#
#END FUNCTION
#add by dxfwo--end----------
FUNCTION i860_check_lsb01(p_cmd)
 DEFINE p_cmd    LIKE lsb_file.lsb01
 DEFINE l_count  LIKE type_file.num10
 
 SELECT COUNT(lsb01) INTO l_count FROM lsb_file
  WHERE lsb01 = p_cmd
  
 IF l_count > 0 THEN
    CALL cl_err(g_lsb.lsb01,'alm-054',1)
    DISPLAY '' TO lsb01 
    LET g_success = 'N'
 ELSE
 	  LET g_success = 'Y'   
 END IF 
 
END FUNCTION
 
#FUNCTION i860_lsbstore(p_cmd)
#DEFINE
#   p_cmd        VARCHAR(01),
#   l_rtz28      LIKE rtz_file.rtz28,
#   l_lmaacti    LIKE rtz_file.lmaacti,
#   l_rtz13      LIKE rtz_file.rtz13
#
#   LET g_errno=''
#   SELECT rtz13,rtz28,lmaacti
#     INTO l_rtz13,l_rtz28,l_lmaacti
#     FROM rtz_file
#    WHERE rtz01=g_lsb.lsbstore 
#   CASE
#       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
#                                LET l_rtz13=NULL
#       WHEN l_lmaacti='N'       LET g_errno='9028'
#       WHEN l_rtz28='N'         LET g_errno='alm-002'
#       OTHERWISE
#            LET g_errno=SQLCA.sqlcode USING '------'
#   END CASE
#   IF p_cmd='d' OR cl_null(g_errno)THEN
#      DISPLAY l_rtz13 TO FORMONLY.rtz13
#   END IF
#END FUNCTION
 
FUNCTION i860_lsb03(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_lmbstore LIKE lmb_file.lmbstore,
   l_lmb02    LIKE lmb_file.lmb02, 
   l_lmb03    LIKE lmb_file.lmb03,
   l_lmb06    LIKE lmb_file.lmb06,
   l_lmcstore LIKE lmc_file.lmcstore,
   l_lmc03    LIKE lmc_file.lmc03, 
   l_lmc04    LIKE lmc_file.lmc04,
   l_lmc07    LIKE lmc_file.lmc07
 
   LET g_errno=''
   SELECT lmb03,lmb06,lmbstore,lmb02
     INTO l_lmb03,l_lmb06,l_lmbstore,l_lmb02
     FROM lmb_file
    WHERE lmb02=g_lsb.lsb03 
      AND lmbstore=g_lsb.lsbstore
   CASE
       WHEN SQLCA.sqlcode=100      LET g_errno='aic-036'
                                   LET l_lmb03=NULL
       WHEN l_lmbstore <> g_lsb.lsbstore LET g_errno = 'alm-376'                          
       WHEN l_lmb06='N'            LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
  #SELECT lmc04,lmc07,lmcstore,lmc03
  #  INTO l_lmc04,l_lmc07,l_lmcstore,l_lmc03
  #  FROM lmc_file
  # WHERE lmc02=l_lmb02
  #   AND lmcstore = g_lsb.lsbstore 
         
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_lmb03 TO FORMONLY.lmb03
  #   LET g_lsb.lsb04 = l_lmc03
  #   DISPLAY BY NAME g_lsb.lsb04
  #   DISPLAY l_lmc04 TO FORMONLY.lmc04
   END IF
END FUNCTION
 
FUNCTION i860_lsb04(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_lmcstore LIKE lmc_file.lmcstore, 
   l_lmc04    LIKE lmc_file.lmc04,
   l_lmc07    LIKE lmc_file.lmc07
 
   LET g_errno=''
   SELECT lmc04,lmc07,lmcstore
     INTO l_lmc04,l_lmc07,l_lmcstore
     FROM lmc_file
    WHERE lmc03=g_lsb.lsb04 
      AND lmc02=g_lsb.lsb03 AND lmcstore=g_lsb.lsbstore
   CASE
       WHEN SQLCA.sqlcode=100     LET g_errno='alm-554'
                                  LET l_lmc04=NULL
       WHEN l_lmcstore<>g_lsb.lsbstore  LET g_errno = 'alm-376'                         
       WHEN l_lmc07='N'           LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_lmc04 TO FORMONLY.lmc04
   END IF
END FUNCTION
 
 
FUNCTION i860_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lsb.* TO NULL 
    MESSAGE ""
    CALL cl_msg("")
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i860_curs()                 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i860_count
    FETCH i860_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i860_cs                    
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,0)
        INITIALIZE g_lsb.* TO NULL
    ELSE
        CALL i860_fetch('F')       
    END IF
END FUNCTION
 
FUNCTION i860_fetch(p_flag)
    DEFINE
        p_flag          VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i860_cs INTO g_lsb.lsb01
        WHEN 'P' FETCH PREVIOUS i860_cs INTO g_lsb.lsb01
        WHEN 'F' FETCH FIRST    i860_cs INTO g_lsb.lsb01
        WHEN 'L' FETCH LAST     i860_cs INTO g_lsb.lsb01
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
            FETCH ABSOLUTE g_jump i860_cs INTO g_lsb.lsb01
            LET g_no_ask = FALSE      
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,0)
        INITIALIZE g_lsb.* TO NULL
        LET g_lsb.lsb01 = NULL 
        RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_lsb.* FROM lsb_file    
       WHERE lsb01 = g_lsb.lsb01
       
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lsb_file",g_lsb.lsb01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_lsb.lsbuser    
        LET g_data_group=g_lsb.lsbgrup
        CALL i860_show()                 
    END IF
END FUNCTION
 
FUNCTION i860_show()
DEFINE l_gen02 LIKE gen_file.gen02
#   LET g_lsb_t.* = g_lsb.*
    DISPLAY BY NAME g_lsb.lsbstore,g_lsb.lsblegal,g_lsb.lsb01,g_lsb.lsb03,g_lsb.lsb04,g_lsb.lsb05, g_lsb.lsboriu,g_lsb.lsborig,
                    g_lsb.lsb06,g_lsb.lsb07,g_lsb.lsb08,g_lsb.lsb09,g_lsb.lsb10,
#                    g_lsb.lsb11,g_lsb.lsb12,g_lsb.lsb13,g_lsb.lsb14,g_lsb.lsb15,               #MOD-B10146 mark
                    g_lsb.lsb11,g_lsb.lsb12,g_lsb.lsb13,                                        #MOD-B10146
                    g_lsb.lsb16,g_lsb.lsb17,g_lsb.lsb18,g_lsb.lsbuser,g_lsb.lsbgrup,
                    g_lsb.lsbcrat,g_lsb.lsbmodu,g_lsb.lsbacti,g_lsb.lsbdate
                    
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01= g_lsb.lsb17 
   DISPLAY l_gen02 TO g_lsb17                    
 
    CALL i860_lsbstore('d')
    CALL i860_lsbstore('d')
    CALL i860_lsb03('d')
    CALL i860_lsb04('d')
    CALL i860_field_pic()
    CALL cl_show_fld_cont()              
END FUNCTION
 
FUNCTION i860_u()
    IF g_lsb.lsb01  IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lsb.lsb16 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF   
    IF g_lsb.lsb16 = 'X' THEN 
       CALL cl_err(g_lsb.lsb01,'alm-134',1)
       RETURN
    END IF 
    SELECT * INTO g_lsb.* FROM lsb_file 
     WHERE lsb01=g_lsb.lsb01
#      AND plant_code = g_plant_code
       
    IF g_lsb.lsbacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
#   IF g_lsb.lsb16 = 'Y' THEN
#       CALL cL_set_comp_entry("lsb01,lsb03,lsb04,lsb05,lsb06,lsb08,lsb10,lsb11,
#       lsb14,lsb15,lsb16,lsb17,lsb18
#       ",FALSE)
#   ELSE
#       CALL cL_set_comp_entry("lsb01,lsb03,lsb04,lsb05,lsb06,lsb08,lsb10,lsb11,                                                    
#       lsb14,lsb15,lsb16,lsb17,lsb18                                                                                               
#       ",TRUE)         
#   END IF 
 
   IF g_lsb.lsb16='X' THEN          
      CALL cl_err('','alm-134',1)
      RETURN
   END IF       
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i860_cl USING g_lsb.lsb01
    IF STATUS THEN
       CALL cl_err("OPEN i860_cl:", STATUS, 1)
       CLOSE i860_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i860_cl INTO g_lsb.*        
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_lsb01_t = g_lsb.lsb01 
    LET g_lsb_t.*=g_lsb.*
    LET g_lsb.lsbmodu=g_user         
    LET g_lsb.lsbdate = g_today     
    IF g_lsb.lsb15 MATCHES '[Ss11WwRr]' THEN 
       LET g_lsb.lsb15 = '0'
    END IF    
    CALL i860_show()               
    WHILE TRUE
        CALL i860_i("u")          
        IF INT_FLAG THEN
            LET INT_FLAG = 0          
            LET g_lsb.*=g_lsb_t.*            
            CALL i860_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        IF g_lsb.* != g_lsb_t.* THEN                   
        UPDATE lsb_file SET lsb_file.* = g_lsb.*   
            WHERE lsb01 = g_lsb01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lsb_file",g_lsb.lsb01,"",SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        END IF 
        EXIT WHILE
    END WHILE
    CLOSE i860_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i860_x()
    IF g_lsb.lsb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lsb.lsb16 = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF  
    IF g_lsb.lsb16 = 'X' THEN 
       CALL cl_err('','alm-134',1)
       RETURN 
    END IF  
    IF g_lsb.lsb15 MATCHES '[Ss11WwRr]' THEN 
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF       
    BEGIN WORK
 
    OPEN i860_cl USING g_lsb.lsb01
    IF STATUS THEN
       CALL cl_err("OPEN i860_cl:", STATUS, 1)
       CLOSE i860_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i860_cl INTO g_lsb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i860_show()
    IF cl_exp(0,0,g_lsb.lsbacti) THEN
        LET g_chr=g_lsb.lsbacti
        IF g_lsb.lsbacti='Y' THEN
            LET g_lsb.lsbacti='N'
        ELSE
            LET g_lsb.lsbacti='Y'
        END IF
        UPDATE lsb_file
           SET lsbacti=g_lsb.lsbacti,
               lsbmodu=g_user,
               lsbdate=g_today
            WHERE lsb01=g_lsb.lsb01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,0)
            LET g_lsb.lsbacti=g_chr
        ELSE
           LET g_lsb.lsbmodu=g_user
           LET g_lsb.lsbdate=g_today
           DISPLAY BY NAME g_lsb.lsbacti,g_lsb.lsbmodu,g_lsb.lsbdate            
        END IF
    END IF
    CLOSE i860_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i860_r()
    IF g_lsb.lsb01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lsb.lsb16 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF  
    IF g_lsb.lsb16 = 'X' THEN 
       CALL cl_err(g_lsb.lsb01,'alm-134',1)
       RETURN 
    END IF   
    IF g_lsb.lsbacti = 'N' THEN
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF    
    IF g_lsb.lsb15 MATCHES '[Ss11WwRr]' THEN 
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF     
    BEGIN WORK
 
    OPEN i860_cl USING g_lsb.lsb01
    IF STATUS THEN
       CALL cl_err("OPEN i860_cl:", STATUS, 0)
       CLOSE i860_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i860_cl INTO g_lsb.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i860_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lsb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lsb.lsb01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lsb_file WHERE lsb01 = g_lsb.lsb01
#                             AND plant_code = g_plant_code
       CLEAR FORM
       OPEN i860_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i860_cs
          CLOSE i860_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i860_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i860_cs
          CLOSE i860_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i860_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i860_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE        
          CALL i860_fetch('/')
       END IF
    END IF
    CLOSE i860_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i860_copy()
    DEFINE
        l_newno1         LIKE lsb_file.lsb01,
        l_oldno1         LIKE lsb_file.lsb01,
        p_cmd            VARCHAR(1),
        l_n              SMALLINT,
        l_input          VARCHAR(1)
 
    IF g_lsb.lsb01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i860_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno1 FROM lsb01
 
        AFTER FIELD lsb01
         IF l_newno1 IS NOT NULL THEN
             CALL i860_check_lsb01(l_newno1)
             IF g_success = 'N' THEN                                                                                                
                  LET g_lsb.lsb01 = g_lsb_t.lsb01                                                                                     
                  DISPLAY BY NAME g_lsb.lsb01                                                                                         
                  NEXT FIELD lsb01                                                                                                    
              END IF  
         ELSE 
          	 CALL cl_err(l_newno1,'alm-055',1)
          	 NEXT FIELD lsb01    
         END IF
 
 
#add by dxfwo--begin-----------
#      	CALL i860_auno1()
#       RETURNING l_newno2
#       DISPLAY l_newno2 TO lsbstore
#add by dxfwo--end-------------
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
        DISPLAY BY NAME g_lsb.lsb01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM lsb_file
        WHERE lsb01=g_lsb.lsb01
        INTO TEMP x
    UPDATE x
        SET lsb01=l_newno1,   
            lsbacti='Y',     
            lsb16='N',
            lsb15='0',
            lsb17='',
            lsb18='',
            lsbuser=g_user, 
            lsbgrup=g_grup,
            lsbmodu=NULL,     
            lsbdate=NULL, 
            lsbcrat=g_today 
    INSERT INTO lsb_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lsb_file",g_lsb.lsb01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        MESSAGE 'ROW(',l_newno1,') O.K'
        LET l_oldno1 = g_lsb.lsb01
        LET g_lsb.lsb01 = l_newno1
        SELECT lsb_file.* INTO g_lsb.* FROM lsb_file
               WHERE lsb01 = l_newno1 
#                AND plant_code = g_plant_code
        CALL i860_u()
        UPDATE lsb_file SET lsbdate=NULL,lsbmodu = NULL
                      WHERE lsb01 = l_newno1
#                       AND plant_code = g_plant_code        
        #SELECT lsb_file.* INTO g_lsb.* FROM lsb_file  #FUN-C30027
        #       WHERE lsb01 = l_oldno1                 #FUN-C30027
#                AND plant_code = g_plant_code
    END IF
    #LET g_lsb.lsb01 = l_oldno1                        #FUN-C30027
    CALL i860_show()
END FUNCTION
 
#FUNCTION i860_out()
#    DEFINE
#        l_i             SMALLINT,
#        l_lsb           RECORD LIKE lsb_file.*,
#        l_gen           RECORD LIKE gen_file.*,
#        l_name          VARCHAR(20),           # External(Disk) file name
#        sr RECORD
#           lsb01 LIKE lsb_file.lsb01,
#           lsbstore LIKE lsb_file.lsbstore,
#           lsb06 LIKE lsb_file.lsb06,
#           gen02 LIKE gen_file.gen02,
#           gen03 LIKE gen_file.gen03,
#           gen04 LIKE gen_file.gen04,
#           gem02 LIKE gem_file.gem02
#           END RECORD,
#        l_za05          VARCHAR(40)
#
#    #BugNO:4137
#    IF g_wc IS NULL THEN LET g_wc=" lsb01='",g_lsb.lsb01,"'" END IF
#
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT lsb01,lsbstore,lsb06,gen02,gen03,gen04,gem02 ",
#              " FROM lsb_file, OUTER(gen_file, OUTER(gem_file)) ",
#              " WHERE gen_file.gen01= lsb01 AND gem_file.gem01 = gen_file.gen03 ",
#              "   AND ",g_wc CLIPPED
#    
##   IF cl_null(g_wc) THEN
##       LET g_sql = g_sql CLIPPED," lsb01='",g_lsb.lsb01,"'"
##   ELSE
##       LET g_sql = g_sql CLIPPED, " AND ",g_wc CLIPPED
##   END IF
#   
#
#    PREPARE i860_p1 FROM g_sql                # RUNTIME 晤祒
#    DECLARE i860_curo                         # SCROLL CURSOR
#         CURSOR FOR i860_p1
#
#    CALL cl_outnam('aooi860') RETURNING l_name
#    START REPORT i860_rep TO l_name
#
#    FOREACH i860_curo INTO sr.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i860_rep(sr.*)
#    END FOREACH
#
#    FINISH REPORT i860_rep
#
#    CLOSE i860_curo
#    ERROR ""
#    #CALL cl_prt(l_name,'g_prtway','g_copies',g_len)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#END FUNCTION
#
#REPORT i860_rep(sr)
#    DEFINE
#        l_trailer_sw    VARCHAR(1),
#        sr RECORD
#           lsb01 LIKE lsb_file.lsb01,
#           lsbstore LIKE lsb_file.lsbstore,
#           lsb06 LIKE lsb_file.lsb06,
#           gen02 LIKE gen_file.gen02,
#           gen03 LIKE gen_file.gen03,
#           gen04 LIKE gen_file.gen04,
#           gem02 LIKE gem_file.gem02
#           END RECORD
#   OUTPUT
#       TOP MARGIN 0
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN 6
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.lsb01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],sr.lsb01,
#                  COLUMN g_c[32],sr.gen02,
#                  COLUMN g_c[33],sr.gen03,
#                  COLUMN g_c[34],sr.gen04,
#                  COLUMN g_c[35],cl_numfor(sr.lsb06,35,g_azi04)
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#                  g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
#                      g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
 
 
FUNCTION i860_set_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lsb01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i860_set_no_entry(p_cmd)
   DEFINE   p_cmd     VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lsb01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i860_y()
 
   IF g_lsb.lsb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lsb.lsbacti = 'N' THEN
      CALL cl_err('','9028',0)      
      RETURN
   END IF
   IF g_lsb.lsb16 ='Y' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   IF g_lsb.lsb16 ='X' THEN
      CALL cl_err('','axr-103',0)      
      RETURN
   END IF
   IF g_lsb.lsb14 = 'Y'AND (cl_null(g_lsb.lsb15) OR  g_lsb.lsb15  ! = '1') THEN
      CALL cl_err('','alm-029',0)  
      RETURN
   END IF   
#    IF NOT cl_null(g_lsb.lsb15) THEN
#    LET g_lsb.lsb15 = '1'
#    LET g_lsb.lsb14 = 'Y' 
#    DISPLAY BY NAME g_lsb.lsb14,g_lsb.lsb15
#    END IF 
   IF NOT cl_confirm('alm-006') THEN 
        RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i860_cl USING g_lsb.lsb01
   IF STATUS THEN
       CALL cl_err("OPEN i860_cl:", STATUS, 1)
       CLOSE i860_cl
       ROLLBACK WORK
       RETURN
    END IF
    
    FETCH i860_cl INTO g_lsb.*          
     IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,0)      
       CLOSE i860_cl
       ROLLBACK WORK
       RETURN
     END IF    
    
    UPDATE lsb_file SET lsb16 = 'Y',
                        lsb17 = g_user, 
                        lsb18 = g_today  
                  WHERE lsb01 = g_lsb.lsb01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lsb_file",g_lsb.lsb01,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N' 
   ELSE 
      LET g_lsb.lsb16 = 'Y'
      LET g_lsb.lsb17 = g_user
      LET g_lsb.lsb18 = g_today
      DISPLAY BY NAME g_lsb.lsb16,g_lsb.lsb17,g_lsb.lsb18
      CALL cl_set_field_pic(g_lsb.lsb16,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i860_v()
   IF g_lsb.lsb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_lsb.lsb16 ='Y' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   IF g_lsb.lsbacti = 'N' THEN
      CALL cl_err('','9028',0)      
      RETURN
   END IF
   IF g_lsb.lsb15 MATCHES '[Ss11WwRr]' THEN 
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF    
 
   BEGIN WORK
 
   OPEN i860_cl USING g_lsb.lsb01
   IF STATUS THEN
       CALL cl_err("OPEN i860_cl:", STATUS, 1)
       CLOSE i860_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i860_cl INTO g_lsb.*             
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,0)
       CLOSE i860_cl
       ROLLBACK WORK
       RETURN
    END IF    
    
    IF g_lsb.lsb16 != 'X' THEN
       IF NOT cl_confirm('alm-085') THEN RETURN END IF
       LET g_lsb.lsb16 = 'X'
       CALL cl_set_field_pic("","","","","Y",g_lsb.lsbacti)
    ELSE
       IF g_lsb.lsb16 = 'X' THEN
          IF NOT cl_confirm('alm-086') THEN RETURN END IF
          LET g_lsb.lsb16 = 'N'
          CALL cl_set_field_pic("","","","","N",g_lsb.lsbacti)
       END IF
    END IF
    UPDATE lsb_file SET lsb16 = g_lsb.lsb16
                  WHERE lsb01 = g_lsb.lsb01
#                   AND plant_code = g_plant_code
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","lsb_file",g_lsb.lsb01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
       ROLLBACK WORK
       RETURN
    END IF
    CLOSE i860_cl
    COMMIT WORK
    DISPLAY BY NAME g_lsb.lsb16
END FUNCTION
 
FUNCTION i860_field_pic()
   DEFINE l_flag   VARCHAR(01)
 
   CASE
     #拸虴
     WHEN g_lsb.lsbacti = 'N' 
        CALL cl_set_field_pic("","","","","","N")
     #機瞄
     WHEN g_lsb.lsb16 = 'Y' 
        CALL cl_set_field_pic("Y","","","","","")
     #釬煙
     WHEN g_lsb.lsb16 = 'X' 
        CALL cl_set_field_pic("","","","","Y","")
     OTHERWISE
        CALL cl_set_field_pic("","","","","","")
   END CASE
END FUNCTION
 
FUNCTION i860_y_chk()
DEFINE l_str         VARCHAR(04)
 
   LET g_success = 'Y'
   IF g_lsb.lsb01 IS NULL  THEN RETURN END IF
    SELECT * INTO g_lsb.* FROM lsb_file 
     WHERE lsb01=g_lsb.lsb01
#      AND plant_code = g_plant_code
   IF g_lsb.lsb16='Y' THEN              
       CALL cl_err('','9023',0)
       LET g_success = 'N'
       RETURN
   END IF
   IF g_lsb.lsb16='X' THEN             
        CALL cl_err('','9024',0)
        LET g_success = 'N'
        RETURN
   END IF
END FUNCTION
 
#FUNCTION i860_y_upd()
#DEFINE l_gen02   LIKE gen_file.gen02
#   LET g_success = 'Y'
#
#   IF g_action_choice CLIPPED = "confirm" OR 
#      g_action_choice CLIPPED = "insert"     
#   THEN 
#      IF g_lsb.lsb14='Y' THEN           
#         IF g_lsb.lsb15 != '1' THEN
#            CALL cl_err('','aws-078',1)
#            LET g_success = 'N'
#            RETURN
#         END IF
#      END IF
#      IF NOT cl_confirm('axm-108') THEN RETURN END IF  
#   END IF
#
#   BEGIN WORK
#
#   OPEN i860_cl USING g_lsb_rowid
#   IF STATUS THEN
#      LET g_success = 'N'
#      CALL cl_err("OPEN i860_cl:", STATUS, 1)
#      CLOSE i860_cl
#      ROLLBACK WORK
#      RETURN
#   END IF
#
#   FETCH i860_cl INTO g_lsb.*            
#   IF SQLCA.sqlcode THEN
#      LET g_success = 'N'
#      CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,0)
#      CLOSE i860_cl
#      ROLLBACK WORK
#      RETURN
#   END IF 
#
##  CALL i860_y1()
#      IF g_success='Y' THEN
#         LET g_lsb.lsb15='1'            
#         LET g_lsb.lsb14='Y'           
#         LET g_lsb.lsb16='Y'
#         LET g_lsb.lsb17=g_user
#         LET g_lsb.lsb18=g_today
##  SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01= g_lsb.lsb16 
##  DISPLAY l_gen02 TO FORMONLY.aa
#         COMMIT WORK
##        CALL cl_flow_notify(g_lsb.lsb04,'Y')
#         DISPLAY BY NAME g_lsb.lsb14
#         DISPLAY BY NAME g_lsb.lsb15
#         DISPLAY BY NAME g_lsb.lsb16
#         DISPLAY BY NAME g_lsb.lsb17
#         DISPLAY BY NAME g_lsb.lsb18
#      ELSE
#         LET g_lsb.lsb16='N'
#         LET g_success = 'N'
#         ROLLBACK WORK
#      END IF
#   
#   SELECT * INTO g_lsb.* FROM lsb_file WHERE lsb04 = g_lsb.lsb04
#   IF g_lsb.lsb16='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
#   IF g_lsb.lsb15='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
#   CALL cl_set_field_pic(g_lsb.lsb16,g_chr2,"",g_chr3,g_chr,"")
#END FUNCTION
 
FUNCTION i860_unconfirm()
DEFINE l_n LIKE type_file.num5
   
    IF cl_null(g_lsb.lsb01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
   IF g_lsb.lsbacti='N' THEN
      CALL cl_err('','alm-049',0)
      RETURN
   END IF
   
   IF g_lsb.lsb16='N' THEN 
      CALL cl_err('','9025',0)
      RETURN
   END IF
 
   IF g_lsb.lsb16 ='X' THEN
      CALL cl_err('','axr-103',0)      
      RETURN
   END IF
  
   SELECT count(*) INTO l_n FROM lsc_file WHERE lsc04 = g_lsb.lsb01
#                                           AND plant_code=g_plant_code
   IF l_n > 0 THEN
      CALL cl_err('','alm-927',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('alm-008') THEN 
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i860_cl USING g_lsb.lsb01
   IF STATUS THEN
      CALL cl_err("OPEN i860_cl:", STATUS, 1)
      CLOSE i860_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i860_cl INTO g_lsb.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lsb.lsb01,SQLCA.sqlcode,0)      
      CLOSE i860_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   #UPDATE lsb_file SET lsb16 = 'N',lsb17 = '',lsb18 = ''        #CHI-D20015
   UPDATE lsb_file SET lsb16 = 'N',lsb17 = g_user,lsb18 =g_today #CHI-D20015
    WHERE lsb01 = g_lsb.lsb01
#     AND plant_code = g_plant_code
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lsb_file",g_lsb.lsb01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lsb.lsb16 = 'N'
      #CHI-D20015--modify--str--
      #LET g_lsb.lsb17 = ''
      #LET g_lsb.lsb18 = ''
      LET g_lsb.lsb17 = g_user
      LET g_lsb.lsb18 = g_today 
      #CHI-D20015--modify--end--
      LET g_lsb.lsbmodu = g_user
      LET g_lsb.lsbdate = g_today 
      DISPLAY BY NAME g_lsb.lsb16,g_lsb.lsb17,g_lsb.lsb18,g_lsb.lsbmodu,g_lsb.lsbdate
      CALL cl_set_field_pic(g_lsb.lsb16,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#MOD-B10146 -------------------mark
#FUNCTION i860_ef()
#  IF cl_null(g_lsb.lsb01) THEN 
#     CALL cl_err('','-400',0) 
#     RETURN 
#  END IF
#  
#  SELECT * INTO g_lsb.* FROM lsb_file
#   WHERE lsb01=g_lsb.lsb01
##     AND plant_code = g_plant_code
#  
#  IF g_lsb.lsbacti='N' THEN
#     CALL cl_err('','alm-131',0)
#     RETURN
#  END IF
#  
#  IF g_lsb.lsb16 ='Y' THEN    
#     CALL cl_err(g_lsb.lsb01,'alm-005',0)
#     RETURN
#  END IF
#  
#  IF g_lsb.lsb16='X' THEN 
#     CALL cl_err('','9024',0)
#     RETURN
#  END IF
#  
#  IF g_lsb.lsb15 MATCHES '[Ss1WwRr]' THEN 
#     CALL cl_err('','mfg3557',0)
#     RETURN
#  END IF
# 
#  IF g_lsb.lsb14='N' THEN 
#     CALL cl_err('','mfg3549',0)
#     RETURN
#  END IF
#
#  IF g_success = "N" THEN
#     RETURN
#  END IF
#
#  CALL aws_condition()     
#  IF g_success = 'N' THEN
#     RETURN
#  END IF
#
###########
## CALL aws_efcli2()
###########
#
#  IF aws_efcli2(base.TypeInfo.create(g_lsb),'','','','','')
#  THEN
#      LET g_success = 'Y'
#      LET g_lsb.lsb15 = 'S'
#      LET g_lsb.lsb14 = 'Y' 
##       DISPLAY BY NAME g_lsb.lsb14,g_lsb.lsb15                     #MOD-B10146 mark
#  ELSE
#      LET g_success = 'N'
#  END IF
#END FUNCTION
#MOD-B10146 ---------------------mark 

FUNCTION i860_lsbstore(p_cmd)                                                                                                       
 DEFINE p_cmd     LIKE type_file.chr1                                                                                               
 DEFINE l_rtz13   LIKE rtz_file.rtz13                                                                                               
 DEFINE l_azt02   LIKE azt_file.azt02                                                                                               
                                                                                                                                    
   IF p_cmd <> 'u' THEN                                                                                                             
      SELECT rtz13 INTO l_rtz13 FROM rtz_file                                                                                       
       WHERE rtz01 = g_lsb.lsbstore                                                                                                 
      SELECT azt02 INTO l_azt02 FROM azt_file                                                                                       
       WHERE azt01 = g_lsb.lsblegal                                                                                                 
      DISPLAY l_rtz13 TO FORMONLY.rtz13                                                                                             
      DISPLAY l_azt02 TO FORMONLY.azt02                                                                                             
   END IF                                                                                                                           
END FUNCTION
#FUNCTION i860_y1()
#   DEFINE l_cmd         VARCHAR(400)
#   DEFINE l_str         VARCHAR(04)
#   DEFINE l_pml         RECORD LIKE pml_file.*
#   DEFINE l_pml04       LIKE pml_file.pml04
#   DEFINE l_imaacti     LIKE ima_file.imaacti
#   DEFINE l_ima140      LIKE ima_file.ima140
#   DEFINE l_pml20       LIKE pml_file.pml20
#
#   IF g_lsb.lsb14='N' AND (g_lsb.lsb15='0' ) THEN
#      LET g_lsb.lsb15='1'
#   END IF
#
#
#   UPDATE lsb_file SET
#          lsb15=g_lsb.lsb15,
#          lsb16='Y',
#          lsb17=g_user,
#          lsb18=g_today
#    WHERE lsb01 = g_lsb.lsb01
#      AND plant_code = g_plant_code
#   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('upd lsb16',STATUS,1)
#      LET g_success = 'N' RETURN
#   END IF
# 
#END FUNCTION
#FUN-A60064 10/06/24 By wangxin 非T/S類table中的xxxplant替換成xxxstore

