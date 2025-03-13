# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axmg558.4gl
# Descriptions...: INVOICE
# Date & Author..: No.FUN-C90100 12/09/21 By xianghui

 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17 
  DEFINE g_seq_item     LIKE type_file.num5 
END GLOBALS
 
DEFINE tm  RECORD                              # Print condition RECORD
            wc      STRING,                    # No.FUN-680137 VARCHAR(500)  # Where condition
            more    LIKE type_file.chr1000     # Input more condition(Y/N)
           END RECORD,
       g_po_no,g_ctn_no1,g_ctn_no2  LIKE type_file.chr20      

DEFINE g_sma115     LIKE sma_file.sma115
DEFINE g_sma116     LIKE sma_file.sma116
DEFINE l_table      STRING
DEFINE l_table1     STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE i            LIKE type_file.num5
DEFINE j            LIKE type_file.num5
DEFINE l_str1,l_str2,l_str3 LIKE type_file.chr1000
DEFINE g_zo042      LIKE zo_file.zo042
DEFINE g_zo05       LIKE zo_file.zo05  
DEFINE g_zo09       LIKE zo_file.zo09  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ofa01.ofa_file.ofa01,     ofa02.ofa_file.ofa02,",
               "ofa16.ofa_file.ofa16,",
               "ofa23.ofa_file.ofa23,     ofb14t.ofb_file.ofb14t,",
               "oag02.oag_file.oag02,     ofa0453.ofa_file.ofa0453,",   
               "ofa0454.ofa_file.ofa0454, ofa0455.ofa_file.ofa0455,",
               "oac02_1.oac_file.oac02,   oac02_2.oac_file.oac02,",
               "ged02.ged_file.ged02,     ofa49.ofa_file.ofa49,",               
               "ofa61.ofa_file.ofa61,     zo042.zo_file.zo042,",             
               "zo05.zo_file.zo05,        zo09.zo_file.zo09,",
               "str1.type_file.chr1000,   str2.type_file.chr1000,",
               "ocf101.ocf_file.ocf101,   ocf102.ocf_file.ocf102,",
               "ocf103.ocf_file.ocf103,   ocf104.ocf_file.ocf104,",
               "ocf105.ocf_file.ocf105,   ocf106.ocf_file.ocf106,",
               "ocf107.ocf_file.ocf107,   ocf108.ocf_file.ocf108,",
               "ocf109.ocf_file.ocf109,   ocf110.ocf_file.ocf110,",
               "ocf111.ocf_file.ocf111,   ocf112.ocf_file.ocf112,",
               "ocf201.ocf_file.ocf201,   ocf202.ocf_file.ocf202,",
               "ocf203.ocf_file.ocf203,   ocf204.ocf_file.ocf204,",
               "ocf205.ocf_file.ocf205,   ocf206.ocf_file.ocf206,",
               "ocf207.ocf_file.ocf207,   ocf208.ocf_file.ocf208,",
               "ocf209.ocf_file.ocf209,   ocf210.ocf_file.ocf210,",
               "ocf211.ocf_file.ocf211,   ocf212.ocf_file.ocf212"
   LET l_table = cl_prt_temptable('axmr558',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                        
      EXIT PROGRAM 
   END IF                  # Temp Table產生


   LET g_sql = "ofa01.ofa_file.ofa01,ofb06.ofb_file.ofb06,     ofa23.ofa_file.ofa23,",
               "ofb13.ofb_file.ofb13,     ofb14t.ofb_file.ofb14t,",             
               "ofb916.ofb_file.ofb916,   ofb917.ofb_file.ofb917,",
               "str1.type_file.chr1000,   str2.type_file.chr1000"
   LET l_table1 = cl_prt_temptable('axmr5581',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                        
      EXIT PROGRAM 
   END IF                  # Temp Table產生

   
   ##------------------------------ CR (1) ------------------------------#
   LET g_zo042= NULL  
   LET g_zo05 = NULL  
   LET g_zo09 = NULL 
   SELECT zo042,zo05,zo09 INTO g_zo042,g_zo05,g_zo09  
     FROM zo_file WHERE zo01='1'
   IF cl_null(g_zo042) THEN
      SELECT zo042 INTO g_zo042 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo05) THEN
      SELECT zo05 INTO g_zo05 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo09) THEN
      SELECT zo09 INTO g_zo09 FROM zo_file WHERE zo01='0'
   END IF
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  
   IF cl_null(tm.wc) THEN
      CALL axmr558_tm(0,0)             # Input print condition
   ELSE 
      CALL axmr558()                        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION axmr558_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      
DEFINE p_row,p_col    LIKE type_file.num5,      
       l_cmd          LIKE type_file.chr1000 
 
   LET p_row = 6 LET p_col = 17
 
 
   OPEN WINDOW axmr558_w AT p_row,p_col WITH FORM "axm/42f/axmr558"
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr558_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION CONTROLZ
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr558_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr558'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr558','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",   
                         " '",g_rep_clas CLIPPED,"'",    
                         " '",g_template CLIPPED,"'",   
                         " '",g_rpt_name CLIPPED,"'"    
         CALL cl_cmdat('axmr558',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr558_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr558()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr558_w
END FUNCTION
 
FUNCTION axmr558()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  
          l_sql     STRING,                      
          l_za05    LIKE type_file.chr1000,      
          l_ofa       RECORD LIKE ofa_file.*,
          l_ofb       RECORD LIKE ofb_file.*,
          l_ocf       RECORD LIKE ocf_file.*,
          l_ofb12   LIKE ofb_file.ofb12,
          l_oag02   LIKE oag_file.oag02,       
          l_oac02_1 LIKE oac_file.oac02,
          l_oac02_2 LIKE oac_file.oac02,
          l_ged02   LIKE ged_file.ged02
   DEFINE l_found    LIKE type_file.num5,    
          l_imc04    LIKE ooc_file.ooc02,     
          t_imc04    LIKE imc_file.imc04,     #品名規格額外說明資料
          oao        RECORD LIKE oao_file.*,
          l_ima0102  LIKE type_file.chr1000,
          l_ogd      RECORD LIKE ogd_file.*,
          l_ima02_1  LIKE ima_file.ima02,
          l_sfa      RECORD LIKE sfa_file.*,
          l_ima02_2  LIKE ima_file.ima02,
          l_oaf03    LIKE oaf_file.oaf03,     #說明
          l_ofb915   STRING,
          l_ofb912   STRING,
          t_ofb12    STRING,
          t_ofb14    LIKE ofb_file.ofb14,
          l_ofb14t   LIKE ofb_file.ofb14t
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   #------------------------------ CR (2) ------------------------------#
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"     

   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                           
      CALL cl_gre_drop_temptable(l_table)       
      EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF 
   
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmr558'
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
 
   LET l_sql="SELECT DISTINCT ofa01,ofa02,ofa10,ofa16,ofa23,ofa32,ofa0453,ofa0454,",
#            "                ofa0455,ofa41,ofa42,ofa43,ofa45,ofa45,ofa49,ofa61,ocf_file.*",
             "                ofa0455,ofa41,ofa42,ofa43,ofa45,ofa45,ofa49,ofa61,",
             "                oag02,a.oac02,b.oac02,ged02,ocf_file.*",
             "  FROM ofa_file LEFT OUTER JOIN ocf_file ON ocf01=ofa04 AND ocf02=ofa44 ",
             "                LEFT OUTER JOIN oag_file ON oag02=ofa32 ",
             "                LEFT OUTER JOIN oac_file a ON a.oac01=ofa41",
             "                LEFT OUTER JOIN oac_file b ON b.oac01=ofa42",
             "                LEFT OUTER JOIN ged_file ON ged01=ofa43",
             " WHERE ofaconf !='X' ",
             "   AND ",tm.wc CLIPPED
   PREPARE axmr558_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   #先chech金額是否超過20億,因為cl_say超過20億,會掛
   LET l_sql="SELECT SUM(ofb12*ofb13) FROM ofa_file,ofb_file",
             " WHERE ofa01=ofb01 ",
             "   AND ",tm.wc CLIPPED,
             "   AND ofaconf !='X' ",
             " GROUP BY ofa01"
   PREPARE axmr558_chk_say_sql FROM l_sql
   DECLARE axmr558_chk_say_cur CURSOR FOR axmr558_chk_say_sql
   OPEN axmr558_chk_say_cur
   IF SQLCA.sqlcode THEN
      LET l_ofb12=0
   ELSE
      FOREACH axmr558_chk_say_cur INTO l_ofb12
         IF l_ofb12>=2000000000 THEN
            CALL cl_err('chk say','axm-550',1)   #金額過大,無法列印
            RETURN
         END IF
      END FOREACH
   END IF
   DECLARE axmr558_curs1 CURSOR FOR axmr558_prepare1
 
   FOREACH axmr558_curs1 INTO l_ofa.ofa01,l_ofa.ofa02,l_ofa.ofa10,l_ofa.ofa16,l_ofa.ofa23,l_ofa.ofa32,
                              l_ofa.ofa0453,l_ofa.ofa0454,l_ofa.ofa0455,l_ofa.ofa41,
                              l_ofa.ofa42,l_ofa.ofa43,l_ofa.ofa45,l_ofa.ofa46,l_ofa.ofa49,l_ofa.ofa61,
                              l_oag02,l_oac02_1,l_oac02_2,l_ged02,l_ocf.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
#     SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01 = l_ofa.ofa32
#     SELECT oac02 INTO l_oac02_1 FROM oac_file WHERE oac01 = l_ofa.ofa41
#     SELECT oac02 INTO l_oac02_2 FROM oac_file WHERE oac01 = l_ofa.ofa42
#     SELECT ged02 INTO l_ged02   FROM ged_file WHERE ged01 = l_ofa.ofa43

      SELECT SUM(ofb14t) INTO l_ofb14t FROM ofb_file 
       WHERE ofb01 = l_ofa.ofa01

      LET t_ofb14 = 0
      SELECT SUM(ofb14t) INTO t_ofb14 FROM ofb_file WHERE ofb01=l_ofa.ofa01
      IF cl_null(t_ofb14) THEN LET t_ofb14 = 0 END IF 
      CALL cl_say(t_ofb14,80) RETURNING l_str1,l_str2
      #客戶嘜頭檔
      LET g_po_no=l_ofa.ofa10 LET g_ctn_no1=l_ofa.ofa45 LET g_ctn_no2=l_ofa.ofa46 
      LET l_ocf.ocf101=ocf_c(l_ocf.ocf101) LET l_ocf.ocf201=ocf_c(l_ocf.ocf201)
      LET l_ocf.ocf102=ocf_c(l_ocf.ocf102) LET l_ocf.ocf202=ocf_c(l_ocf.ocf202)
      LET l_ocf.ocf103=ocf_c(l_ocf.ocf103) LET l_ocf.ocf203=ocf_c(l_ocf.ocf203)
      LET l_ocf.ocf104=ocf_c(l_ocf.ocf104) LET l_ocf.ocf204=ocf_c(l_ocf.ocf204)
      LET l_ocf.ocf105=ocf_c(l_ocf.ocf105) LET l_ocf.ocf205=ocf_c(l_ocf.ocf205)
      LET l_ocf.ocf106=ocf_c(l_ocf.ocf106) LET l_ocf.ocf206=ocf_c(l_ocf.ocf206)
      LET l_ocf.ocf107=ocf_c(l_ocf.ocf107) LET l_ocf.ocf207=ocf_c(l_ocf.ocf207)
      LET l_ocf.ocf108=ocf_c(l_ocf.ocf108) LET l_ocf.ocf208=ocf_c(l_ocf.ocf208)
      LET l_ocf.ocf109=ocf_c(l_ocf.ocf109) LET l_ocf.ocf209=ocf_c(l_ocf.ocf209)
      LET l_ocf.ocf110=ocf_c(l_ocf.ocf110) LET l_ocf.ocf210=ocf_c(l_ocf.ocf210)
      LET l_ocf.ocf111=ocf_c(l_ocf.ocf111) LET l_ocf.ocf211=ocf_c(l_ocf.ocf211)
      LET l_ocf.ocf112=ocf_c(l_ocf.ocf112) LET l_ocf.ocf212=ocf_c(l_ocf.ocf212)
 
      EXECUTE insert_prep USING
         l_ofa.ofa01  ,l_ofa.ofa02  ,l_ofa.ofa16  ,l_ofa.ofa23,l_ofb14t,
         l_oag02  ,l_ofa.ofa0453,l_ofa.ofa0454,l_ofa.ofa0455,
         l_oac02_1    ,l_oac02_2    ,l_ged02      ,l_ofa.ofa49  ,
         l_ofa.ofa61  ,g_zo042      ,g_zo05       ,g_zo09       ,
         l_str1       ,l_str2       ,
         l_ocf.ocf101 ,l_ocf.ocf102 ,l_ocf.ocf103 ,l_ocf.ocf104 ,
         l_ocf.ocf105 ,l_ocf.ocf106 ,l_ocf.ocf107 ,l_ocf.ocf108 ,
         l_ocf.ocf109 ,l_ocf.ocf110 ,l_ocf.ocf111 ,l_ocf.ocf112 ,
         l_ocf.ocf201 ,l_ocf.ocf202 ,l_ocf.ocf203 ,l_ocf.ocf204 ,
         l_ocf.ocf205 ,l_ocf.ocf206 ,l_ocf.ocf207 ,l_ocf.ocf208 ,
         l_ocf.ocf209 ,l_ocf.ocf210 ,l_ocf.ocf211 ,l_ocf.ocf212 

   END FOREACH
      LET l_sql="SELECT ofa01,ofb_file.* ",
                "  FROM ofa_file,ofb_file ",
                " WHERE ofa01=ofb01 ",
              # "   AND ofa01 = '",l_ofa.ofa01,"'",
                "   AND ",tm.wc CLIPPED,
                "   AND ofaconf !='X' "                            #不要作廢的資料
      PREPARE axmr558_prepare2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE axmr558_curs2 CURSOR FOR axmr558_prepare2
      FOREACH axmr558_curs2 INTO l_ofa.ofa01,l_ofb.*
         LET t_ofb14 = 0
         SELECT SUM(ofb14t) INTO t_ofb14 FROM ofb_file WHERE ofb01=l_ofa.ofa01
         IF cl_null(t_ofb14) THEN LET t_ofb14 = 0 END IF 
         CALL cl_say(t_ofb14,80) RETURNING l_str1,l_str2
 
        EXECUTE insert_prep1 USING
           l_ofa.ofa01,l_ofb.ofb06,l_ofa.ofa23,l_ofb.ofb13,l_ofb.ofb14t,l_ofb.ofb916,
           l_ofb.ofb917,l_str1,l_str2

      END FOREACH
  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ofa01,ofa02') RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF
   LET g_str = tm.wc,";",g_sma.sma115,";",g_sma.sma116
   CALL cl_prt_cs3('axmr558','axmr558',g_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
FUNCTION ocf_c(str)
  DEFINE str	 LIKE occ_file.occ46 
  # 把麥頭內'PPPPPP'字串改為 P/O NO (l_ofa.ofa10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO (l_ofa.ofa45)
  # 把麥頭內'DDDDDD'字串改為 CTN NO (l_ofa.ofa46)
  FOR i=1 TO 20
     LET j=i+5
     IF str[i,j]='PPPPPP' THEN LET str[i,40]=g_po_no   END IF
     IF str[i,j]='CCCCCC' THEN LET str[i,j] =g_ctn_no1 END IF  
     IF str[i,j]='DDDDDD' THEN LET str[i,j] =g_ctn_no2 END IF 
  END FOR
  RETURN str
END FUNCTION
#FUN-C90100--------精簡程式-----


