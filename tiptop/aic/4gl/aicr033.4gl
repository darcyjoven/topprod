# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicr033.4gl
# Descriptions...: INVOICE 套表
# Date & Author..: No.FUN-7B0073 07/12/10 by sherry
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90044 11/09/05 By lujh 程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5
END GLOBALS
 
   DEFINE tm  RECORD                       #Print condition RECORD
              wc      LIKE type_file.chr1000,           #Where condition
              b       LIKE type_file.chr1,             #是否打印備注
              more    LIKE type_file.chr1             #Input more condition(Y/N)
              END RECORD,
          l_oao06    LIKE oao_file.oao06,
          x LIKE type_file.chr5,
          y,z LIKE type_file.chr1,
          g_po_no,g_ctn_no1,g_ctn_no2 LIKE type_file.chr20,
          g_azi02 LIKE type_file.chr20,
          g_zo12  LIKE type_file.chr50,
          g_no		LIKE type_file.num10,
          g_title LIKE type_file.chr30,
          g_sr		DYNAMIC ARRAY OF RECORD
          		ima01	LIKE ima_file.ima01,
          		ima02	LIKE ima_file.ima02
          		END RECORD,
          g_str1,g_str2,g_str3,g_str4  LIKE type_file.chr20,
          l_flag        LIKE type_file.chr1
 
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE   i               LIKE type_file.num5
DEFINE   j               LIKE type_file.num5
DEFINE   g_sma115        LIKE sma_file.sma115      
DEFINE   g_sma116        LIKE sma_file.sma116     
DEFINE   g_sql           STRING
DEFINE   l_table1        STRING
DEFINE   l_table2        STRING
DEFINE   l_table3        STRING
DEFINE   l_table4        STRING
DEFINE   l_table5        STRING
DEFINE   g_str           STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
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
               "ofa01.ofa_file.ofa01,",
               "ofa011.ofa_file.ofa011,",
               "ofa0351.ofa_file.ofa0351,",
               "ofa0352.ofa_file.ofa0352,",
               "ofa32.ofa_file.ofa32,",
               "oag02.oag_file.oag02,",
               "ofa0452.ofa_file.ofa0452,", 
               "ofb03.ofb_file.ofb03,",
               "ofb04.ofb_file.ofb04,",
               "ofb06.ofb_file.ofb06,",
               "ofb05.ofb_file.ofb05,",
               "ofb12.ofb_file.ofb12,",
               "ofb13.ofb_file.ofb13,",
               "ofb14.ofb_file.ofb14,",
               "ofb11.ofb_file.ofb11,",
               "ogbiicd02.ogbi_file.ogbiicd02,",
               "ofa10.ofa_file.ofa10,",
               "t_ofb12.ofb_file.ofb12,",
               "l_ofa23.ofa_file.ofa23,",
               "t_ofb14.ofb_file.ofb14,",
               "ofa23.ofa_file.ofa23,",
               "l_str1.type_file.chr1000,",
               "l_str2.type_file.chr1000,",
               "z.type_file.chr1,",
               "l_oga01.oga_file.oga01,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05 "     
   LET l_table1 = cl_prt_temptable('aicr0331',g_sql) CLIPPED                    
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                    
                                                                                
   LET g_sql = " oao01.oao_file.oao01,",                                        
               " oao03.oao_file.oao03,",                                        
               " oao05.oao_file.oao05,",                                        
               " oao06_1.oao_file.oao06 "                                         
                                                                                
   LET l_table2 = cl_prt_temptable('aicr0332',g_sql) CLIPPED                    
   IF l_table2 = -1 THEN EXIT PROGRAM END IF              
 
   LET g_sql = " oao01.oao_file.oao01,",                                        
               " oao03.oao_file.oao03,",                                        
               " oao05.oao_file.oao05,",                                        
               " oao06_2.oao_file.oao06 "                                       
                                                                                
   LET l_table3 = cl_prt_temptable('aicr0333',g_sql) CLIPPED                    
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " oao01.oao_file.oao01,",                                        
               " oao03.oao_file.oao03,",                                        
               " oao05.oao_file.oao05,",                                        
               " oao06_3.oao_file.oao06 "                                       
                                                                                
   LET l_table4 = cl_prt_temptable('aicr0334',g_sql) CLIPPED                    
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " l_ofa01.ofa_file.ofa01,",                                        
               " oaf01.oaf_file.oaf01,",                                        
               " oaf03.oaf_file.oaf03 "                                        
                                                                                
   LET l_table5 = cl_prt_temptable('aicr0335',g_sql) CLIPPED                    
   IF l_table5 = -1 THEN EXIT PROGRAM END IF         
                                                                                                                                                  
   LET g_zo12 = NULL
   SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='1'
   IF cl_null(g_zo12) THEN
      SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='0'
   END IF
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.b    = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B90044

   IF cl_null(tm.wc)
      THEN CALL aicr033_tm(0,0)             # Input print condition
      ELSE LET tm.wc="ofa01 ='",tm.wc CLIPPED,"'"
           CALL aicr033()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
END MAIN
 
FUNCTION aicr033_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col LIKE type_file.num5,
          l_cmd       LIKE type_file.chr1000
 
   LET p_row = 6 LET p_col = 17
 
   OPEN WINDOW aicr033_w AT p_row,p_col WITH FORM "aic/42f/aicr033"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
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
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
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
      CLOSE WINDOW aicr033_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   LET tm.b='Y'  #DEFAULT 不打印備注
 
   INPUT BY NAME tm.b,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
	  AFTER FIELD b  #是否打印備注
            IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
          AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
          AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            LET l_flag='N'
            IF cl_null(tm.b) THEN LET l_flag='Y' END IF
            IF l_flag='Y' THEN NEXT FIELD a END IF
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG CALL cl_cmdask()    # Command execution   
 
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
      CLOSE WINDOW aicr033_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='aicr033'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aicr033','9031',1)
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
                         " '",tm.b  CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'"  ,           
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"            
         CALL cl_cmdat('aicr033',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aicr033_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aicr033()
   ERROR ""
END WHILE
   CLOSE WINDOW aicr033_w
END FUNCTION
 
FUNCTION aicr033()
  DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name
         l_time    LIKE type_file.chr8,         # Used time for running the job
         #l_sql     LIKE type_file.chr1000,
         l_sql      STRING,     #NO.FUN-910082
         ofa       RECORD LIKE ofa_file.*,
         ofb       RECORD LIKE ofb_file.*,
         sr        RECORD
                    occ231 LIKE occ_file.occ231,
                    occ232 LIKE occ_file.occ232,
                    occ233 LIKE occ_file.occ233,
                    occ241 LIKE occ_file.occ241,
                    occ242 LIKE occ_file.occ242,
                    occ243 LIKE occ_file.occ243,
                    occ29  LIKE occ_file.occ29,
                    occ292 LIKE occ_file.occ292,
                    oah02  LIKE oah_file.oah02,
                    oag02  LIKE oag_file.oag02,
                    oga02  LIKE oga_file.oga02,
                    ogbiicd02  LIKE ogbi_file.ogbiicd02,
                    ima138 LIKE ima_file.ima138
                    END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5               
     DEFINE l_zaa02            LIKE zaa_file.zaa02     
     DEFINE l_str1,l_str2  LIKE type_file.chr1000       
     DEFINE l_oga01        LIKE oga_file.oga01
     DEFINE l_ofa01        LIKE ofa_file.ofa01                                      
     DEFINE l_ima02        LIKE ima_file.ima02                                                    
     DEFINE l_ima021       LIKE ima_file.ima021                                             
     DEFINE t_ofb12        LIKE ofb_file.ofb12                                     
     DEFINE t_ofb14        LIKE ofb_file.ofb14,                                    
            l_ofb05        LIKE ofb_file.ofb05,                                    
            l_ofa23        LIKE ofa_file.ofa23                                     
     DEFINE l_found        LIKE type_file.num5                                                
     DEFINE oao            RECORD LIKE oao_file.*                                  
     DEFINE oaf            RECORD LIKE oaf_file.*                                  
     DEFINE l_oao          RECORD LIKE oao_file.*                                  
DEFINE   l_str3       LIKE type_file.chr1000,                                             
         l_ima906     LIKE ima_file.ima906,                                     
         l_ofb915     STRING,                                                   
         l_ofb912     STRING,                                                   
         l_ofb12      STRING                                                    
  DEFINE t_ofb917     LIKE ofb_file.ofb917    
 
     CALL cl_del_data(l_table1)                                                 
     CALL cl_del_data(l_table2)                                                 
     CALL cl_del_data(l_table3)                                                 
     CALL cl_del_data(l_table4)                                                 
     CALL cl_del_data(l_table5)                                                 
                                                                                
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,           
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                   
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"                          
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
                 " VALUES(?,?,?,? )        "                                    
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
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,           
                 " VALUES(?,?,? )        "                                    
     PREPARE insert_prep4 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep4:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
        EXIT PROGRAM                      
     END IF   
                                                                                
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  
    
    # CALL cl_used(g_prog,l_time,1) RETURNING l_time    #FUN-B90044   MARK
     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
 
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                   #只能使用自己的數據
  #     LET tm.wc = tm.wc clipped," AND ofauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                   #只能使用相同群的數據
  #     LET tm.wc = tm.wc clipped," AND ofagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    
  #     LET tm.wc = tm.wc clipped," AND ofagrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
  #End:FUN-980030
 
  LET l_sql="SELECT ofa_file.*, ofb_file.* ",
            "  FROM ofa_file,ofb_file ",
            " WHERE ofa01=ofb01 ",
            "   AND ",tm.wc CLIPPED,
            "   AND ofaconf !='X' "
 
  PREPARE aicr033_prepare1 FROM l_sql
  IF SQLCA.sqlcode != 0 THEN
     CALL cl_err('prepare1:',SQLCA.sqlcode,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90044
     EXIT PROGRAM
  END IF
  DECLARE aicr033_curs1 CURSOR FOR aicr033_prepare1
 
  FOREACH aicr033_curs1 INTO ofa.*, ofb.*
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
    SELECT occ231,occ232,occ233,occ241,occ242,occ243,occ29,occ292
      INTO sr.occ231,sr.occ232,sr.occ233,sr.occ241,sr.occ242,
           sr.occ243,sr.occ29 ,sr.occ292
     FROM occ_file WHERE occ01 = ofa.ofa03
 
    SELECT oah02 INTO sr.oah02 FROM oah_file
     WHERE oah01 = ofa.ofa31
 
    SELECT oag02 INTO sr.oag02 FROM oag_file
     WHERE oag01 = ofa.ofa32
 
    SELECT oga02 INTO sr.oga02 FROM oga_file	
     WHERE oga01 = ofa.ofa011 AND (oga09 = '1' OR oga09='5') 
 
    SELECT ima138 INTO sr.ima138 FROM ima_file
     WHERE ima01 = ofb.ofb04
 
    IF ofa.ofa0352 IS NULL THEN #帳款客戶全名
       LET ofa.ofa0352 = ofa.ofa0353 LET ofa.ofa0353 = ofa.ofa0354
       LET ofa.ofa0354 = ofa.ofa0355 LET ofa.ofa0355 = NULL
    END IF
    IF ofa.ofa0452 IS NULL THEN #送貨客戶全名
       LET ofa.ofa0452 = ofa.ofa0453 LET ofa.ofa0453 = ofa.ofa0454
       LET ofa.ofa0454 = ofa.ofa0455 LET ofa.ofa0455 = NULL
    END IF
    LET t_ofb12 = 0
    LET t_ofb917= 0  
     LET t_ofb14 = 0
     
     #打印備注
     IF tm.b='Y' THEN
        DECLARE oao_c2 CURSOR FOR
         SELECT * FROM oao_file
          WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND oao05='1'
          ORDER BY 3
        FOREACH oao_c2 INTO oao.*
        EXECUTE insert_prep1 USING oao.oao01,oao.oao03,oao.oao05,oao.oao06
        END FOREACH
     END IF
 
     CASE WHEN ofa.ofa71='1' LET ofb.ofb11=NULL
          WHEN ofa.ofa71='2' LET ofb.ofb04=ofb.ofb11 LET ofb.ofb11=NULL
     END CASE
     IF cl_null(ofa.ofa10) THEN
        SELECT oea10 INTO ofa.ofa10 FROM oea_file WHERE oea01=ofb.ofb31
     END IF
     SELECT azi03,azi04,azi05
       INTO t_azi03,t_azi04,t_azi05          #幣種檔案小數位數讀取
       FROM azi_file
      WHERE azi01=ofa.ofa23
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=ofb.ofb04
      LET l_str3 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(ofb.ofb915) RETURNING l_ofb915
                LET l_str3 = l_ofb915,ofb.ofb913 CLIPPED
                IF cl_null(ofb.ofb915) OR ofb.ofb915 = 0 THEN
                    CALL cl_remove_zero(ofb.ofb912) RETURNING l_ofb912
                    LET l_str3 = l_ofb912,ofb.ofb910 CLIPPED
                ELSE
                   IF NOT cl_null(ofb.ofb912) AND ofb.ofb912 > 0 THEN
                      CALL cl_remove_zero(ofb.ofb912) RETURNING l_ofb912
                      LET l_str3 = l_str3 CLIPPED,',',l_ofb912,ofb.ofb910 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(ofb.ofb915) AND ofb.ofb915 > 0 THEN
                    CALL cl_remove_zero(ofb.ofb915) RETURNING l_ofb915
                    LET l_str3 = l_ofb915 , ofb.ofb913 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN    
            IF ofb.ofb910 <> ofb.ofb916 THEN
               CALL cl_remove_zero(ofb.ofb12) RETURNING l_ofb12
               LET l_str3 = l_str3 CLIPPED,"(",l_ofb12,ofb.ofb05 CLIPPED,")"
            END IF
      END IF
      SELECT ogbiicd02 INTO sr.ogbiicd02 FROM ogb_file,ogbi_file 
        WHERE ogb01=ofb.ofb34 AND ogb03=ofb.ofb35 AND ogbi01 = ogb01
 
      LET t_ofb12 = t_ofb12 + ofb.ofb12
      LET t_ofb917= t_ofb917+ ofb.ofb917  
      LET t_ofb14 = t_ofb14 + ofb.ofb14
      LET l_ofb05 = ofb.ofb05
      LET l_ofa23 = ofa.ofa23
 
      #打印備注
      IF tm.b='Y' THEN
         DECLARE oao_c3 CURSOR FOR
          SELECT * FROM oao_file
           WHERE oao01=l_oga01   AND oao03=ofb.ofb03 AND oao05='2'
           ORDER BY 3
         FOREACH oao_c3 INTO oao.*
            EXECUTE insert_prep2 USING oao.oao01,oao.oao03,oao.oao05,oao.oao06
         END FOREACH
      END IF  
      
      CALL cl_say(t_ofb14,80) RETURNING l_str1,l_str2
      SELECT azi02 INTO g_azi02 FROM azi_file WHERE azi01=ofa.ofa23
      IF SQLCA.SQLCODE THEN LET g_azi02='  ' END IF
      
      #打印備注
      IF tm.b='Y' THEN
         DECLARE oao_c4 CURSOR FOR
          SELECT * FROM oao_file
           WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05='2'
           ORDER BY 3
         FOREACH oao_c4 INTO oao.* 
           EXECUTE insert_prep3 USING oao.oao01,oao.oao03,oao.oao05,oao.oao06 
         END FOREACH
      END IF
    
      DECLARE oaf_c CURSOR FOR
         SELECT * FROM oaf_file
          WHERE (oaf01=ofa.ofa741 OR oaf01=ofa.ofa742 OR oaf01=ofa.ofa743)
          ORDER BY 1,2
         FOREACH oaf_c INTO oaf.*
          EXECUTE insert_prep4 USING l_ofa01,oaf.oaf01,oaf.oaf03
         END FOREACH
 
    EXECUTE insert_prep USING ofa.ofa02,ofa.ofa01,ofa.ofa011,ofa.ofa0351,
                              ofa.ofa0352,ofa.ofa32,sr.oag02,
                              ofa.ofa0452,ofb.ofb03,ofb.ofb04,ofb.ofb06,
                              ofb.ofb05,ofb.ofb12,ofb.ofb13,ofb.ofb14,ofb.ofb11,
                              sr.ogbiicd02,ofa.ofa10,t_ofb12,l_ofa23,t_ofb14,
                              ofa.ofa23,l_str1,l_str2,z,l_oga01,t_azi03,t_azi04,
                              t_azi05      
  END FOREACH
 
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'ofa01,ofa02')                         
        RETURNING tm.wc                                                         
   END IF                                                                       
   LET g_str = tm.wc,";",tm.b
   IF tm.b = 'Y' THEN
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",  
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",       
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED  
   ELSE 
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   END IF
   CALL cl_prt_cs3('aicr033','aicr033',g_sql,g_str)       
   # CALL cl_used(g_prog,l_time,2) RETURNING l_time    #FUN-B90044   MARK
END FUNCTION
 
FUNCTION ocf_c(str)
  DEFINE str LIKE type_file.chr1000
  # 把麥頭內'PPPPPP'字符串改為 P/O NO (ofa.ofa10)
  # 把麥頭內'CCCCCC'字符串改為 CTN NO (ofa.ofa45)
  # 把麥頭內'DDDDDD'字符串改為 CTN NO (ofa.ofa46)
  FOR i=1 TO 20
    LET j=i+5
    IF str[i,j]='PPPPPP' THEN LET str[i,30]=g_po_no   RETURN str END IF
    IF str[i,j]='CCCCCC' THEN LET str[i,30]=g_ctn_no1 RETURN str END IF
    IF str[i,j]='DDDDDD' THEN LET str[i,30]=g_ctn_no2 RETURN str END IF
  END FOR
  RETURN str
END FUNCTION
 
#Patch....NO.FUN-7B0073
