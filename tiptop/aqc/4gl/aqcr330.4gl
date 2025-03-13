# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aqcr330.4gl
# Descriptions...: QC檢驗記錄明細表
# Input parameter: 
# Return code....: 
# Date & Author..: FUN-A80122 10/08/23 By yinhy
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正

 
DATABASE ds
 
GLOBALS "../../config/top.global"  
 
DEFINE   tm        RECORD                          # Print condition RECORD
                   wc      STRING,                 # Where condition  
                   type    LIKE type_file.chr1,    # type  choice   VARCHAR(1)
                   more    LIKE type_file.chr1     # Input more condition(Y/N)  VARCHAR(1)
                   END RECORD
DEFINE   g_i       LIKE type_file.num5             #count/index for any purpose  SMALLINT
DEFINE   g_sql     STRING                          
DEFINE   g_str     STRING                          
DEFINE   l_table   STRING                          
DEFINE   l_table1  STRING                          
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   
   LET g_sql="qcs01.qcs_file.qcs01,",
             "qcs02.qcs_file.qcs02,",
             "qcs05.qcs_file.qcs05,",
             "qcs021.qcs_file.qcs021,",
             "pmn041.pmn_file.pmn041,",
             "qcs03.qcs_file.qcs03,",
             "pmc03.pmc_file.pmc03,",
             "qcs04.qcs_file.qcs04,",
             "qcs22.qcs_file.qcs22,",
             "qcs091.qcs_file.qcs091,",
             "qcs13.qcs_file.qcs13,",
             "qcs09.qcs_file.qcs09,",
             "qct04.qct_file.qct04,",
             "azf03.azf_file.azf03,",
             "qct11.qct_file.qct11,",
             "qct07.qct_file.qct07,",
             "qct08.qct_file.qct08,",
             "qct03.qct_file.qct03"
   LET l_table = cl_prt_temptable('aqcr330',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql="qctt01.qctt_file.qctt01,",
             "qctt02.qctt_file.qctt02,",
             "qctt021.qctt_file.qctt021,",
             "qctt03.qctt_file.qctt03,",
             "qctt04_1.qctt_file.qctt04,",
             "qctt04_2.qctt_file.qctt04,",
             "qctt04_3.qctt_file.qctt04"
   LET l_table1 = cl_prt_temptable('aqcr3301',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
             
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.type    = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL q330_tm()	             	# Input print condition
      ELSE CALL aqcr330()		          	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q330_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     
DEFINE l_cmd	     LIKE type_file.chr1000,   # VARCHAR(1000)
       l_j,l_n       LIKE type_file.num5,    # SMALLINT
       p_row,p_col   LIKE type_file.num5     # SMALLINT
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 17
   ELSE
       LET p_row = 4 LET p_col = 9
   END IF
   OPEN WINDOW q330_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr330" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.type    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
WHILE TRUE

   CONSTRUCT BY NAME tm.wc ON qcs04,qcs021,qcs03,qcs13,qct04,qct08                 

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

 
      ON ACTION locale
            #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
                                         
      ON ACTION controlp  
         CASE                                       
           WHEN INFIELD(qcs021) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs021
               NEXT FIELD qcs021                                                                                      
           WHEN INFIELD(qcs03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_qcs3"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs03
               NEXT FIELD qcs03
           WHEN INFIELD(qcs13)                                              
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qcs13
               NEXT FIELD qcs13
           WHEN INFIELD(qct04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_azf"
               LET g_qryparam.arg1 = "6"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO qct04
               NEXT FIELD qct04
          END CASE
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
 
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
  
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q330_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   
   DISPLAY BY NAME tm.type,tm.more 	# Condition
#UI
    INPUT BY NAME tm.type,tm.more WITHOUT DEFAULTS 
 
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
     
      AFTER FIELD type
         IF tm.type NOT MATCHES "[1-5]" OR tm.type IS NULL 
            THEN NEXT FIELD type
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
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
    
      ON ACTION qbe_save
          CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW q330_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aqcr330'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr330','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", 
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('aqcr330',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW q330_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aqcr330()
   ERROR ""
END WHILE
   CLOSE WINDOW q330_w
END FUNCTION
 
FUNCTION aqcr330()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-A80122 VARCHAR(20)   
          l_sql 	STRING,    		        
          l_za05	LIKE za_file.za05,              #No.FUN-A80122 VARCHAR(40)
          l_qctt  RECORD LIKE qctt_file.*,
          sr            RECORD 
                        qcs01      LIKE  qcs_file.qcs01,
                        qcs02      LIKE  qcs_file.qcs02,
                        qcs05      LIKE  qcs_file.qcs05,
                        qcs021     LIKE  qcs_file.qcs021,
                        pmn041     LIKE  pmn_file.pmn041,
                        qcs03      LIKE  qcs_file.qcs03,
                        pmc03      LIKE  pmc_file.pmc03,
                        qcs04      LIKE  qcs_file.qcs04,
                        qcs22      LIKE  qcs_file.qcs22,
                        qcs091     LIKE  qcs_file.qcs091,
                        qcs13      LIKE  qcs_file.qcs13,
                        qcs09      LIKE  qcs_file.qcs09,                        
                        qct04      LIKE  qct_file.qct04,
                        azf03      LIKE  azf_file.azf03,
                        qct11      LIKE  qct_file.qct11,
                        qct07      LIKE  qct_file.qct07,
                        qct08      LIKE  qct_file.qct08,	
                        qct03      LIKE  qct_file.qct03	
                        END RECORD,
           sr1          RECORD                       
                        qctt04_1   LIKE  qctt_file.qctt04,
                        qctt04_2   LIKE  qctt_file.qctt04,
                        qctt04_3   LIKE  qctt_file.qctt04
                        END RECORD,
           l_i          LIKE type_file.num5,    #No.FUN-A80122 SMALLINT
           l_a          LIKE type_file.num5,
           l_key        LIKE type_file.chr1,    #No.FUN-A80122 VARCHAR(1)
           l_status     LIKE type_file.chr1     #No.FUN-A80122 VARCHAR(1)
      
     CALL cl_del_data(l_table)                  
     CALL cl_del_data(l_table1)
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"    
     PREPARE insert_prep FROM g_sql                                              
     IF STATUS THEN                                                               
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM                        
     END IF
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
                " VALUES(?,?,?,?,?,  ?,?)"    
     PREPARE insert_prep1 FROM g_sql                                              
     IF STATUS THEN                                                               
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM                        
     END IF
    
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
 
     CALL g_zaa_dyn.clear()           
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
     CASE tm.type
         #FQC
         WHEN "2"
            LET tm.wc = cl_replace_str(tm.wc,'qcs','qcf')
            LET tm.wc = cl_replace_str(tm.wc,'qct','qcg')
         #PQC
         WHEN "3"
            LET tm.wc = cl_replace_str(tm.wc,'qcs','qcm')
            LET tm.wc = cl_replace_str(tm.wc,'qct','qcn')
     END CASE
     CASE tm.type
         WHEN "1"
            LET g_sql= "SELECT qcs01,qcs02,qcs05,qcs021,pmn041,",
                       " qcs03,pmc03,qcs04,qcs22,qcs091,",
                       " qcs13,qcs09,qct04,azf03,qct11,",
                       " qct07,qct08,qct03 ",														
                       " FROM qcs_file,qct_file,pmn_file,azf_file,rvb_file,pmc_file",													
                       " WHERE qct01=qcs01 AND qct02 =qcs02 AND qct021=qcs05",													
                       " AND rvb01=qcs01 AND rvb02=qcs02 AND pmn01=rvb04 AND pmn02=rvb03",										
                       " AND pmc01=qcs03",
                       " AND azf01=qct04 AND azf02='6'",												
                       " AND ",tm.wc 
         WHEN "2"														
            LET g_sql= "SELECT qcf01,0,qcf05,qcf021,ima02,",
                       " '','',qcf04,qcf22,qcf091,",
                       " qcf13,qcf09,qcg04,azf03,qcg11,",
                       " qcg07,qcg08,qcg03 ",														
                       " FROM qcf_file,qcg_file,ima_file,azf_file",	
                       " WHERE qcg01=qcf01 AND qcf021=ima01 AND azf01=qcg04 AND azf02='6'",																								
                       "  AND ",tm.wc
         WHEN "3"														
            LET g_sql= "SELECT qcm01,0,qcm05,qcm021,ima02,",
                       " '','',qcm04,qcm22,qcm091,",
                       " qcm13,qcm09,qcn04,azf03,qcn11,",
                       " qcn07,qcn08,qcn03 ",														
                       " FROM qcm_file,qcn_file,ima_file,azf_file",													
                       " WHERE qcn01=qcm01 AND qcm021=ima01 AND azf01=qcn04 AND azf02='6'",													     											
                       "  AND ",tm.wc
         OTHERWISE
             LET g_sql= "SELECT qcs01,qcs02,qcs05,qcs021,ima02,",
                       " qcs03,'',qcs04,qcs22,qcs091,",
                       " qcs13,qcs09,qct04,azf03,qct11,",
                       " qct07,qct08,qct03 ",														
                       " FROM qcs_file,qct_file,ima_file,azf_file",													
                       " WHERE qct01=qcs01 AND qcs021=ima01 AND qct02 =qcs02", 
                       " AND qct021=qcs05 AND azf01=qct04 AND azf02='6'",																								
                       " AND ",tm.wc                              
       END CASE  
    
       CASE tm.type
                    #IQC
                    WHEN "1"
                       LET g_sql = g_sql," AND qcs00 IN ('1','2','7')"
                    #OQC
                    WHEN "4"
                       LET g_sql = g_sql," AND qcs00 IN ('5','6')"
                    #倉庫QC
                    WHEN "5"
                       LET g_sql = g_sql," AND qcs00 IN ('A','B','C','D','E','F','G','H','Z')"
       END CASE
       
       PREPARE q330_prepare FROM g_sql
       IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM 
       END IF
       
       DECLARE q330_cs CURSOR FOR q330_prepare 
       FOREACH q330_cs INTO sr.*
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH 
         END IF
         CASE tm.type
             WHEN "2"
               LET g_sql = "SELECT qcgg01,0,0,qcgg03,qcgg04 FROM qcgg_file 
                            WHERE qcgg01='",sr.qcs01 CLIPPED,"' 
                            AND qcgg03=",sr.qct03 CLIPPED,""
             WHEN "3"
               LET g_sql = "SELECT qcnn01,0,0,qcnn03,qcnn04 FROM qcnn_file 
                            WHERE qcnn01='",sr.qcs01 CLIPPED,"'          
                            AND qcnn03=",sr.qct03 CLIPPED,""
             OTHERWISE
               LET g_sql = "SELECT qctt01,qctt02,qctt021,qctt03,qctt04 FROM qctt_file 
                            WHERE qctt01='",sr.qcs01 CLIPPED,"' 
                            AND qctt02=",sr.qcs02 CLIPPED," 
                            AND qctt021=",sr.qcs05 CLIPPED," 
                            AND qctt03=",sr.qct03 CLIPPED,""
       END CASE             
       PREPARE q330_prepare1 FROM g_sql
       IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM 
       END IF
       LET l_i = 0
       DECLARE q330_cs1 CURSOR FOR q330_prepare1 
       FOREACH q330_cs1 INTO l_qctt.*
         IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH 
         END IF
         #每三筆存一次
         IF l_i > 0 AND l_i MOD 3 = 0 THEN                 
             EXECUTE insert_prep1 USING sr.qcs01,sr.qcs02,sr.qcs05,sr.qct03,sr1.qctt04_1,sr1.qctt04_2,sr1.qctt04_3                           
             INITIALIZE sr1.* TO NULL
         END IF
         CASE l_i MOD 3
              WHEN 0 LET sr1.qctt04_1 = l_qctt.qctt04
              WHEN 1 LET sr1.qctt04_2 = l_qctt.qctt04 
              WHEN 2 LET sr1.qctt04_3 = l_qctt.qctt04 
         END CASE
         LET l_i = l_i + 1 
       END FOREACH  
       #最后一筆
       IF l_i > 0 THEN           
         EXECUTE insert_prep1 USING sr.qcs01,sr.qcs02,sr.qcs05,sr.qct03,sr1.qctt04_1,sr1.qctt04_2,sr1.qctt04_3                           
         INITIALIZE sr1.* TO NULL
         LET l_i = 0
       END IF
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc01 = sr.qcs03
         EXECUTE insert_prep USING sr.*
       END FOREACH
            
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                    
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'qcs04,qcs021,qcs03,qcs13,qct04,qct08')   
            RETURNING tm.wc                                                     
       LET g_str = tm.wc                                                        
    END IF
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED,"|",
                "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED 
    CALL cl_prt_cs3('aqcr330','aqcr330',l_sql,g_str)

END FUNCTION
