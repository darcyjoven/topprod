# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicr034.4gl
# Descriptions...: Packing List
# Date & Author..: No.FUN-7B0073 08/01/09 by sherry

# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm           RECORD                         # Print condition RECORD
                     wc      LIKE type_file.chr1000,               # Where condition
                     imc02   LIKE imc_file.imc02,  # 品名規格額外說明類型   
                     a       LIKE type_file.chr1,             # 打印客戶料號           #FUN-5A0087 add
                     s       LIKE type_file.chr1,             # 打印順序  
                     more    LIKE type_file.chr1              # Input more condition(Y/N)
                    END RECORD,
       l_oao06      LIKE oao_file.oao06,
       x            LIKE type_file.chr5,
       y,z          LIKE type_file.chr1,
       tot_ctn	    LIKE type_file.num10,
       wk_i         LIKE type_file.num5,
       wk_array     DYNAMIC ARRAY OF RECORD
                     ogd11      LIKE ogd_file.ogd11,
                     ogd12b     LIKE ogd_file.ogd12b,
                     ogd12e     LIKE ogd_file.ogd12e
          	    END        RECORD,
       g_po_no,g_ctn_no1,g_ctn_no2 LIKE type_file.chr20,
       g_azi02	  LIKE azi_file.azi02,
       g_zo12	    LIKE zo_file.zo12
 
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_i          LIKE type_file.num5   #count/index for any purpose
DEFINE i            LIKE type_file.num5
DEFINE j            LIKE type_file.num5
 
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table1     STRING
DEFINE l_table2     STRING
DEFINE l_table3     STRING
DEFINE l_table4     STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.imc02= ARG_VAL(8)   
   LET tm.a    = ARG_VAL(9)   
   LET tm.s    = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
 
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF    
 
   LET g_sql = "ofa02.ofa_file.ofa02,",
               "ogd01.ogd_file.ogd01,",
               "ofa0351.ofa_file.ofa0351,",
               "ofa0352.ofa_file.ofa0352,",
               "ofa23.ofa_file.ofa23,",
               "ofa76.ofa_file.ofa76,",
               "ogd12b.ogd_file.ogd12b,",
               "ogd12e.ogd_file.ogd12e,",
               "ogd11.ogd_file.ogd11,",
               "ofb04.ofb_file.ofb04,",
               "ofb06.ofb_file.ofb06,",
               "ofb05.ofb_file.ofb05,",
               "ogd13.ogd_file.ogd13,",
               "ogd14t.ogd_file.ogd14t,",
               "ogd15t.ogd_file.ogd15t,",
               "tot_ogd13.ogd_file.ogd13,",                                         
               "l_ogd14t.ogd_file.ogd14t,",                                       
               "l_ogd15t.ogd_file.ogd15t,", 
               "ofa77.ofa_file.ofa77,",
               "zo12.zo_file.zo12,",
               "l_str.type_file.chr1000,",
               "l_str1.type_file.chr1000,",
               "l_str2.type_file.chr1000,",
               "ofa01.ofa_file.ofa01,",
               "ofb33.ofb_file.ofb33,",
               "tot_ctn.type_file.num10,",
               "ofa75.ofa_file.ofa75 "  
               
   LET l_table1 = cl_prt_temptable('aicr0341',g_sql) CLIPPED                    
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                
 
   LET g_sql = " oao01.oao_file.oao01,",                                        
               " oao03.oao_file.oao03,",                                        
               " oao05.oao_file.oao05,",                                        
               " oao06.oao_file.oao06 "                                       
                                                                                
   LET l_table2 = cl_prt_temptable('aicr0342',g_sql) CLIPPED                    
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " sfa01.sfa_file.sfa01,",                                        
               " sfa03.sfa_file.sfa03,",                                        
               " sfa30.sfa_file.sfa30,",                                        
               " sfa12.sfa_file.sfa12,",
               " sfa06.sfa_file.sfa06,",
               " ima02.ima_file.ima02 "                                       
                                                                                
   LET l_table3 = cl_prt_temptable('aicr0343',g_sql) CLIPPED                    
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " oao01.oao_file.oao01,",                                        
               " oao03.oao_file.oao03,",                                        
               " oao05.oao_file.oao05,",                                        
               " oao06_1.oao_file.oao06 "                                       
                                                                                
   LET l_table4 = cl_prt_temptable('aicr0344',g_sql) CLIPPED                    
   IF l_table4 = -1 THEN EXIT PROGRAM END IF          
                             
   LET g_zo12 = NULL
   SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='1'
   IF cl_null(g_zo12) THEN
      SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='0'
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044 
   IF cl_null(tm.wc) THEN
      CALL aicr034_tm(0,0)             # Input print condition
   ELSE 
      CALL aicr034()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION aicr034_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000
 
   LET p_row = 8 LET p_col = 17
 
   OPEN WINDOW aicr034_w AT p_row,p_col WITH FORM "aic/42f/aicr034"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a ='N'   
   LET tm.s ='1'   
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   CALL cl_opmsg('p')
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ofa01,ofa02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()                   
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ofa01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ofa"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ofa01
                    NEXT FIELD ofa01
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
         LET INT_FLAG = 0
         CLOSE WINDOW aicr034_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.imc02,tm.a,tm.s,tm.more WITHOUT DEFAULTS   
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW aicr034_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='aicr034'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aicr034','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'" ,
                            " '",tm.imc02 CLIPPED,"'" ,            
                            " '",tm.a CLIPPED,"'" ,                
                            " '",tm.s CLIPPED,"'" ,                
                            " '",g_rep_user CLIPPED,"'",           
                            " '",g_rep_clas CLIPPED,"'",           
                            " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('aicr034',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW aicr034_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aicr034()
      ERROR ""
   END WHILE
   CLOSE WINDOW aicr034_w
END FUNCTION
 
FUNCTION aicr034()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name
          l_time    LIKE type_file.chr8 ,         # Used time for running the job
          l_sql     STRING,
          l_ogd01   LIKE ogd_file.ogd01,  
          l_za05    LIKE za_file.za05,
          ofa       RECORD LIKE ofa_file.*,
          ofb       RECORD LIKE ofb_file.*,
          ogd       RECORD LIKE ogd_file.*,
          ocf       RECORD LIKE ocf_file.*,
          sr        RECORD
                    oea10	LIKE oea_file.oea10,
                    oah02	LIKE oah_file.oah02,
                    oag02	LIKE oag_file.oag02,
                    oac02	LIKE oac_file.oac02,
                    oac02_2	LIKE oac_file.oac02,
                    ogd12b	LIKE ogd_file.ogd12b  
                    END RECORD
  DEFINE l_str1,l_str2 LIKE type_file.chr1000                                              
  DEFINE l_str         LIKE type_file.chr1000                                                   
  DEFINE l_ima02       LIKE ima_file.ima02                                                    
  DEFINE l_imc04       LIKE imc_file.imc04                                                    
  DEFINE sfa30_t       LIKE sfa_file.sfa30                                                    
  DEFINE sfa30_p       LIKE sfa_file.sfa30                                                    
  DEFINE tot_ogd13     LIKE   ogd_file.ogd13                                   
  DEFINE oao           RECORD LIKE oao_file.*                                  
  DEFINE oaf           RECORD LIKE oaf_file.*                                  
  DEFINE wk_ima02      LIKE   ima_file.ima02                                   
  DEFINE wk_ima25      LIKE   ima_file.ima25                                   
  DEFINE l_ogd14t      LIKE ogd_file.ogd14t                                    
  DEFINE l_ogd15t      LIKE ogd_file.ogd15t                                    
  DEFINE l_ogd16t      LIKE ogd_file.ogd16t                                    
  DEFINE sfa       RECORD LIKE sfa_file.*
 
     CALL cl_del_data(l_table1)                                                 
     CALL cl_del_data(l_table2)                                                 
     CALL cl_del_data(l_table3)                                                 
     CALL cl_del_data(l_table4)                                                 
                                                                                
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,           
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                   
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,? )"                      
     PREPARE insert_prep FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM                       
     END IF                                                                     
                                                                                
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,           
                 " VALUES(?,?,?,? )        "                                    
     PREPARE insert_prep1 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM                      
     END IF                                                                     
                                                                                
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,           
                 " VALUES(?,?,?,?,?,? )        "  
     PREPARE insert_prep2 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM                      
     END IF                                                                     
                                                                                
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,           
                 " VALUES(?,?,?,? )        "                                    
     PREPARE insert_prep3 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep3:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM                      
     END IF            
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time   #FUN-B90044   MARK
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的數據
     #         LET tm.wc = tm.wc clipped," AND ofauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的數據
     #         LET tm.wc = tm.wc clipped," AND ofagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #群組權限
     #         LET tm.wc = tm.wc clipped," AND ofagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT ofa_file.*,ofb_file.*, ",
               "       ocf_file.*,oea10,oah02,oag02,a.oac02,b.oac02,ogd12b ",
               "  FROM ofa_file,ofb_file, ",
               "       OUTER ocf_file,   OUTER oea_file,",
               "       OUTER oah_file,   OUTER oag_file,",
               "       OUTER oac_file a, OUTER oac_file b, ",
               "       OUTER ogd_file ",   
               " WHERE ofa01=ofb01 ",
               "   AND ",tm.wc CLIPPED,
               "   AND ofaconf !='X' ", 
               "   AND ofa_file.ofa04=ocf_file.ocf01 AND ofa_file.ofa44=ocf_file.ocf02",
               "   AND ofb_file.ofb31=oea_file.oea01 AND ofa_file.ofa31=oah_file.oah01 AND ofa_file.ofa32=oag_file.oag01",
               "   AND ofa_file.ofa41=a.oac01 AND ofa_file.ofa42=b.oac01 ",
               "   AND ofb_file.ofb34=ogd_file.ogd01 AND ofb_file.ofb35=ogd_file.ogd03 "   
     IF tm.s = '1' THEN
        LET l_sql = l_sql , " ORDER BY ofa01,ofb04"
     ELSE
        LET l_sql = l_sql , " ORDER BY ofa01,ogd12b"
     END IF
     PREPARE aicr034_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM
     END IF
     DECLARE aicr034_curs1 CURSOR FOR aicr034_prepare1
 
     FOREACH aicr034_curs1 INTO ofa.*, ofb.*, ocf.*, sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF ofa.ofa0352 IS NULL THEN
          LET ofa.ofa0352 = ofa.ofa0353 LET ofa.ofa0353 = ofa.ofa0354
          LET ofa.ofa0354 = ofa.ofa0355 LET ofa.ofa0355 = NULL
       END IF
       IF ofa.ofa0452 IS NULL THEN
          LET ofa.ofa0452 = ofa.ofa0453 LET ofa.ofa0453 = ofa.ofa0454
          LET ofa.ofa0454 = ofa.ofa0455 LET ofa.ofa0455 = NULL
       END IF
       
       DECLARE oao_c1 CURSOR FOR
        SELECT * FROM oao_file
         WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05=1
         ORDER BY 3
      FOREACH oao_c1 INTO oao.*
         EXECUTE insert_prep1 USING oao.oao01,oao.oao03,oao.oao05,oao.oao06 
      END FOREACH
      
         LET tot_ctn=0
         FOR    wk_i = 1  TO 20
           INITIALIZE  wk_array[wk_i].*  TO NULL
         END    FOR
         LET    wk_i = 0
  
      LET l_imc04 = NULL
      SELECT imc04 INTO l_imc04 FROM imc_file
       WHERE imc01=ofb.ofb04 AND imc02='1' AND imc03='1'
      #"打印品名規格額外說明類型"若有錄入，則印在"Description"中，
      #若不錄入則印品名規格
      IF NOT cl_null(tm.imc02) THEN
         SELECT imc04 INTO ofb.ofb06 FROM imc_file
          WHERE imc01=ofb.ofb04 AND imc02=tm.imc02 AND imc03='1'
      END IF
     #"打印客戶料號"若勾選，則在"Item No."中印客戶料號，若否，則印原來的產品編號
      IF tm.a = 'Y' THEN LET ofb.ofb04=ofb.ofb11 END IF
      IF ofb.ofb11 IS NULL THEN
         SELECT obk03 INTO ofb.ofb11 FROM obk_file
          WHERE obk01=ofb.ofb04 AND obk02=ofa.ofa03
      END IF
      CASE WHEN ofa.ofa71='1' LET ofb.ofb11=NULL
           WHEN ofa.ofa71='2' LET ofb.ofb04=ofb.ofb11 LET ofb.ofb11=NULL
      END CASE
      DECLARE ogd_cur CURSOR FOR
         SELECT * FROM ogd_file
          WHERE ogd01 = ofa.ofa011
            AND ogd03 = ofb.ofb03
      FOREACH ogd_cur INTO ogd.*
 
         IF ogd.ogd04=1 THEN
            DECLARE oao_c2 CURSOR FOR
              SELECT * FROM oao_file
               WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND oao05=1
               ORDER BY 3
         END IF
         IF NOT cl_null(ogd.ogd12b) THEN
            CALL cnt_ogd10(ogd.ogd11,ogd.ogd12b,ogd.ogd12e,ogd.ogd10)
         END IF
      END FOREACH    
      
      IF ofb.ofb33 IS NOT NULL THEN
         DECLARE sfa_c CURSOR FOR
           SELECT sfa_file.*,ima02
             FROM sfa_file, OUTER ima_file
           WHERE sfa01=ofb.ofb33 AND sfa03=ima_file.ima01 
             ORDER BY sfa30,sfa03
         LET sfa30_t=NULL
         FOREACH sfa_c INTO sfa.*, l_ima02
            IF sfa.sfa30=sfa30_t
               THEN LET sfa30_p=NULL
               ELSE LET sfa30_p=sfa.sfa30 LET sfa30_t=sfa.sfa30
            END IF
            EXECUTE insert_prep2 USING sfa.sfa01,sfa.sfa03,sfa30_p,sfa.sfa12,
                                       sfa.sfa06,l_ima02
         END FOREACH
      END IF  
      
      IF ofa.ofa75='1' THEN LET l_str='PALLETS' ELSE LET l_str='CARTONS' END IF
      SELECT SUM(ogd14t),SUM(ogd15t),SUM(ogd16t) INTO l_ogd14t,l_ogd15t,l_ogd16t
        FROM ogd_file
       WHERE ogd01 = ofa.ofa011      
       
      CALL cl_say(tot_ctn,80) RETURNING l_str1,l_str2    
      
      DECLARE oao_c4 CURSOR FOR
        SELECT * FROM oao_file
         WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05=2
         ORDER BY 3
        FOREACH oao_c4 INTO oao.* 
          EXECUTE insert_prep3 USING oao.oao01,oao.oao03,oao.oao05,oao.oao06
        END FOREACH
       EXECUTE insert_prep USING ofa.ofa02,ogd.ogd01,ofa.ofa0351,ofa.ofa0352,
                                 ofa.ofa23,ofa.ofa76,ogd.ogd12b,ogd.ogd12e,
                                 ogd.ogd11,ofb.ofb04,ofb.ofb06,
                                 ofb.ofb05,ogd.ogd13,
                                 ogd.ogd14t,ogd.ogd15t,tot_ogd13,l_ogd14t,
                                 l_ogd15t,ofa.ofa77,g_zo12,l_str,l_str1,l_str2,
                                 ofa.ofa01,ofb.ofb33,tot_ctn,ofa.ofa75
     END FOREACH
 
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'ofa01,ofa02')                                        
        RETURNING tm.wc                                                         
   END IF                                                                       
   LET g_str = tm.wc,";",g_zo12                                                  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",     
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",     
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",     
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED
   CALL cl_prt_cs3('aicr034','aicr034',g_sql,g_str)   
   #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818      #FUN-B90044   MARK
END FUNCTION
 
FUNCTION ocf_c(str)
  DEFINE str LIKE type_file.chr30
        
  # 把麥頭內'PPPPPP'字符串改為 P/O NO (ofa.ofa10)
  # 把麥頭內'CCCCCC'字符串改為 CTN NO (ofa.ofa45)
  # 把麥頭內'DDDDDD'字符串改為 CTN NO (ofa.ofa46)
  LET g_ctn_no1=g_ctn_no1 USING "######"
  LET g_ctn_no2=g_ctn_no2 USING "######"
  FOR i=1 TO 25
    IF str[i,i+5]='PPPPPP' THEN LET str[i,30]=g_po_no     END IF
    IF str[i,i+5]='CCCCCC' THEN LET str[i,i+5]=g_ctn_no1  END IF
    IF str[i,i+5]='DDDDDD' THEN LET str[i,i+5]=g_ctn_no2  END IF
  END FOR
  RETURN str
END FUNCTION
 
FUNCTION cnt_ogd10(wk_ogd11,wk_ogd12b,wk_ogd12e,wk_ogd10)
   DEFINE wk_ogd11   LIKE ogd_file.ogd11,
          wk_ogd12b  LIKE ogd_file.ogd12b,
          wk_ogd12b_1  LIKE ogd_file.ogd12b,
          wk_ogd12b_2  LIKE ogd_file.ogd12b,
          wk_ogd12b_3  LIKE ogd_file.ogd12b,
          wk_ogd12e  LIKE ogd_file.ogd12e,
          wk_ogd12e_1  LIKE ogd_file.ogd12e,
          wk_ogd12e_2  LIKE ogd_file.ogd12e,
          wk_ogd12e_3  LIKE ogd_file.ogd12e,
          wk_ogd10   LIKE ogd_file.ogd10,
          wk_j       LIKE type_file.num5,
          sw_esit    LIKE type_file.chr1
   IF wk_ogd11 IS NULL THEN
      LET wk_ogd11 = ' '
   END    IF
   IF  wk_ogd12b_1 NOT MATCHES '[A-z]' AND
       wk_ogd12b_2 NOT MATCHES '[A-z]' AND
       wk_ogd12b_3 NOT MATCHES '[A-z]' THEN
       LET wk_ogd12b  = wk_ogd12b USING '&&&'
   END IF
   IF  wk_ogd12e_1 NOT MATCHES '[A-z]' AND
       wk_ogd12e_2 NOT MATCHES '[A-z]' AND
       wk_ogd12e_3 NOT MATCHES '[A-z]' THEN
       LET wk_ogd12e  = wk_ogd12e USING '&&&'
   END IF
   LET sw_esit    = 'N'
   IF     wk_i     =   0    THEN
      LET wk_i     =   wk_i +    1
      LET wk_array[wk_i].ogd11   = wk_ogd11
      LET wk_array[wk_i].ogd12b  = wk_ogd12b  USING '&&&'
      LET wk_array[wk_i].ogd12e  = wk_ogd12e  USING '&&&'
      LET tot_ctn    =    tot_ctn   + wk_ogd10
   ELSE
      FOR wk_j     =   1    TO   wk_i
          IF wk_ogd11  =    wk_array[wk_j].ogd11 THEN
             IF   (wk_ogd12b  >= wk_array[wk_j].ogd12b  AND
                   wk_ogd12b  <= wk_array[wk_j].ogd12e) AND
                  (wk_ogd12e  >= wk_array[wk_j].ogd12b  AND
                   wk_ogd12e  <= wk_array[wk_j].ogd12e) THEN
                   LET sw_esit = 'Y'
                   EXIT FOR
              ELSE
                   LET sw_esit = 'N'
              END  IF
          END IF
      END FOR
      IF  sw_esit  =  'N'   THEN
          LET wk_i =  wk_i  +  1
          LET wk_array[wk_i].ogd11   = wk_ogd11
          LET wk_array[wk_i].ogd12b  = wk_ogd12b  USING '&&&'
          LET wk_array[wk_i].ogd12e  = wk_ogd12e  USING '&&&'
          LET tot_ctn  =  tot_ctn  + wk_ogd10
      END IF
      LET sw_esit    = 'N'
    END   IF
END FUNCTION
#Patch....NO.TQC-610037 <> #
 
