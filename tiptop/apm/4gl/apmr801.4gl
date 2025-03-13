# Prog. Version..: '5.30.06-13.03.18(00001)'     #
#
# Pattern name...: apmr801.4gl
# Desc/riptions...: 已驗未入庫清單
# Date & Author..: 102/02/23 By Sakura #FUN-CC0018 於原報表增加選項是否列印qc料件判定結果，獨立為cr報表
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD				# Print condition RECORD 
          wc  	STRING,		        # Where condition
          e     LIKE type_file.chr1,
          more	LIKE type_file.chr1 # Input more condition(Y/N)
              END RECORD
DEFINE g_cnt         LIKE type_file.num10
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose
DEFINE g_sql         STRING
DEFINE g_str         STRING
DEFINE l_table       STRING
DEFINE l_table1       STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)

   LET g_sql = "rva01.rva_file.rva01,",   #收貨單號
               "rvb02.rvb_file.rvb02,",   #項次
               "rva06.rva_file.rva06,",  #收貨日期
               "rvb05.rvb_file.rvb05,",   #料號
               "pmn041.pmn_file.pmn041,",  #品名
               "ima021.ima_file.ima021,",  #規格
               "rvb04.rvb_file.rvb04,",   #採購單號
               "rvb03.rvb_file.rvb03,",   #採購項次
               "rvb07.rvb_file.rvb07,",   #收貨量
               "rvb33.rvb_file.rvb33,",   #允收量
               "rvb30.rvb_file.rvb30,",   #入庫量
               "rvb29.rvb_file.rvb29,",   #退貨量
               "pmn63.pmn_file.pmn63,",   #急料否
               "rva05.rva_file.rva05,",   #供應廠商 
               "pmc03.pmc_file.pmc03"     #供应商名称           
 
   LET l_table = cl_prt_temptable('apmr801',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF

   #子報表 
   LET g_sql = "qco01.qco_file.qco01,",   #來源單號 
               "qco02.qco_file.qco02,",   #來源項次
               "qco05.qco_file.qco05,",   #分批序號
               "qco04.qco_file.qco04,",   #項次
               "qco03.qco_file.qco03,",   #判斷結果編碼
               "qcl02.qcl_file.qcl02,",   #結果說明
               "qco07.qco_file.qco07,",   #倉庫
               "qco08.qco_file.qco08,",   #儲位
               "qco09.qco_file.qco09,",   #批號
               "qco10.qco_file.qco10,",   #單位
               "qco11.qco_file.qco11,",   #數量
               "qco19.qco_file.qco19,",   #對成品轉換率
               "qco20.qco_file.qco20"    #已轉入庫量                
   LET l_table1 = cl_prt_temptable('apmr8011',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r801_tm(0,0)		    # Input print condition
      ELSE CALL apmr801()		        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r801_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd		LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r801_w AT p_row,p_col WITH FORM "apm/42f/apmr801"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.e = 'N'
 
WHILE TRUE
   DISPLAY BY NAME  tm.more  # Condition
   CONSTRUCT BY NAME  tm.wc ON rva05,rva01,rvb05,rva06,rvb04
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             
     ON ACTION CONTROLP
        CASE WHEN INFIELD(rva05)      #供應廠商
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_qcs3"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rva05 
                  NEXT FIELD rva05 
             WHEN INFIELD(rvb05)   #料號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima00"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvb05
               NEXT FIELD rvb05
        END CASE            

     ON ACTION locale
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
      LET INT_FLAG = 0 CLOSE WINDOW r801_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
#UI
   INPUT BY NAME tm.e,tm.more WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL  THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER FIELD e
         IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN NEXT FIELD e END IF         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
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
      LET INT_FLAG = 0 CLOSE WINDOW r801_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr801'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr801','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"
         CALL cl_cmdat('apmr801',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r801_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr801()
   ERROR ""
END WHILE
   CLOSE WINDOW r801_w
END FUNCTION
 
FUNCTION apmr801()
   DEFINE       
          l_sql 	STRING,		                # RDSQL STATEMENT
          sr            RECORD 
                                  rva01  LIKE rva_file.rva01,   #收貨單號
                                  rvb02  LIKE rvb_file.rvb02,   #項次
                                  rva06  LIKE rva_file.rva06,   #收貨日期
                                  rvb05  LIKE rvb_file.rvb05,   #料號
                                  pmn041 LIKE pmn_file.pmn041,  #品名
                                  
                                  ima021 LIKE ima_file.ima021,  #規格
                                  rvb04  LIKE rvb_file.rvb04,   #採購單號
                                  rvb03  LIKE rvb_file.rvb03,   #採購項次
                                  rvb07  LIKE rvb_file.rvb07,   #收貨量
                                  rvb33  LIKE rvb_file.rvb33,   #允收量

                                  rvb30  LIKE rvb_file.rvb30,   #入庫量
                                  rvb29  LIKE rvb_file.rvb29,   #退貨量
                                  pmn63  LIKE pmn_file.pmn63,   #急料否
                                  rva05  LIKE rva_file.rva05,   #供應廠商
                                  pmc03  LIKE pmc_file.pmc03
                        END RECORD,
         sr1            RECORD 
                                 qco01  LIKE qco_file.qco01,   #來源單號
                                 qco02  LIKE qco_file.qco02,   #來源項次
                                 qco05  LIKE qco_file.qco05,   #分批序號
                                 qco04  LIKE qco_file.qco04,   #項次
                                 qco03  LIKE qco_file.qco03,   #判斷結果編碼
                                 qcl02  LIKE qcl_file.qcl02,   #結果說明
                                 qco07  LIKE qco_file.qco07,   #倉庫
                                 qco08  LIKE qco_file.qco08,   #儲位
                                 qco09  LIKE qco_file.qco09,   #批號
                                 qco10  LIKE qco_file.qco10,   #單位
                                 qco11  LIKE qco_file.qco11,   #數量
                                 qco19  LIKE qco_file.qco19,   #對成品轉換率
                                 qco20  LIKE qco_file.qco20    #已轉入庫量
                       END RECORD

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)    

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')

     LET l_sql = " SELECT  rva01,rvb02,rva06,rvb05,pmn041,ima021,rvb04,rvb03,",
                 "         rvb07,rvb33,rvb30,rvb29,pmn63,rva05,pmc03 ",                                                                                                 
                 " FROM rva_file,rvb_file,pmn_file,ima_file,pmc_file ",  #str---add by huanglf160804                                                                             
                 "        WHERE rva01 = rvb01 ",                                                                                           
                 "          AND rvb03 = pmn02 ",                                                                                       
                 "          AND rvb04 = pmn01 ",                                                                                       
                 "          AND rvb04 = pmn01 ",
                 "          AND rva05 = pmc01 ",                     
                 "          AND rvb39 = 'Y' ",                                                                 
                 "          AND rvaconf <> 'X' ",                                                                                           
                 "          AND rvb33 <> rvb30 ",
                 "          AND rvb05 = ima01 ",
                 "          AND ",tm.wc                   
     LET l_sql = l_sql CLIPPED ," ORDER BY  rva01,rvb02,rva06"
     PREPARE r801_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r801_curs1 CURSOR FOR r801_prepare1     
 
     FOREACH r801_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF        

       IF tm.e ='Y' THEN
          LET l_sql=" SELECT qco01,qco02,qco05,qco04,qco03,qcl02,qco07,qco08,qco09,qco10,",
                    "         qco11,qco19,qco20 FROM qco_file,qcl_file ",
                    "  WHERE qco03 = qcl01 ",
                    "    AND qco01 = '",sr.rva01 CLIPPED,"'",  #收貨單號
                    "    AND qco02 = '",sr.rvb02 CLIPPED,"'"   #項次
          PREPARE r801_prepare2 FROM l_sql
          DECLARE r801_curs2 CURSOR FOR r801_prepare2
          FOREACH r801_curs2 INTO sr1.*
             IF STATUS THEN EXIT FOREACH END IF
             EXECUTE  insert_prep1 USING sr1.qco01,sr1.qco02,sr1.qco05,sr1.qco04,sr1.qco03,sr1.qcl02,sr1.qco07,sr1.qco08,
                                         sr1.qco09,sr1.qco10,sr1.qco11,sr1.qco19,sr1.qco20
          END FOREACH
       END IF
       
       EXECUTE insert_prep USING sr.rva01,sr.rvb02,sr.rva06,sr.rvb05,sr.pmn041,sr.ima021,sr.rvb04,
                                 sr.rvb03,sr.rvb07,sr.rvb33,sr.rvb30,sr.rvb29,sr.pmn63,sr.rva05,sr.pmc03               
     END FOREACH    
     LET g_str = ''
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'rva05,rva01,rvb05,rva06,rvb04') RETURNING tm.wc
     END IF
     LET g_str=tm.wc ,";",tm.e
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",                                                         
                 "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED       
     CALL cl_prt_cs3('apmr801','apmr801',l_sql,g_str)
END FUNCTION
#FUN-CC0018
