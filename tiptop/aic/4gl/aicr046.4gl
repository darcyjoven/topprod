# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicr046.4gl
# Descriptions...: 已發出委外采購單檢核表
# Date & Author..: No.FUN-7B0075 07/12/25 By Sunyanchun
# Modify.........: No.TQC-950072 09/05/14 BY ve007 含有sfbiicd09 的條件拿掉
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A40038 10/05/06 By liuxqa modify sql
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	STRING,		        # Where condition
           	more	LIKE type_file.chr1   	# Input more condition(Y/N)
              END RECORD
 
   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose
   DEFINE g_str         STRING
   DEFINE g_sql         STRING
   DEFINE l_table       STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF NOT s_industry("icd") THEN                                                
      CALL cl_err('','aic-999',1)                                               
      EXIT PROGRAM                                                              
   END IF
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
   
   LET g_sql = "pmm01.pmm_file.pmm01,",
               "pmm09.pmm_file.pmm09,",
               "pmm22.pmm_file.pmm22,",
               "pmn02.pmn_file.pmn02,",
               "pmn04.pmn_file.pmn04,",
               "pmn041.pmn_file.pmn041,",
               "pmn20.pmn_file.pmn20,",
               "pmn31.pmn_file.pmn31,",
               "pmm04.pmn_file.pmn04,",
               "pmn33.pmn_file.pmn33,",
               "pmniicd16.pmni_file.pmniicd16,",
               "sfb22.sfb_file.sfb22,",
               "sfb221.sfb_file.sfb221,",
               "pmniicd15.pmni_file.pmniicd15,",
               "pmn41.pmn_file.pmn41,",
               "pmniicd11.pmni_file.pmniicd11,",
               "pmniicd18.pmni_file.pmniicd18,",
               "sfb06.sfb_file.sfb06,",
               "sfb08.sfb_file.sfb08,",
               "sfb82.sfb_file.sfb82,",
               "azi03.azi_file.azi03,",
               "ima021.ima_file.ima021,",
               "ima021_1.ima_file.ima021,",
               "pmc03.pmc_file.pmc03,",
               "pmc03_1.pmc_file.pmc03,",
               "pmc03_2.pmc_file.pmc03,",
               "ima02.ima_file.ima02"
 
   LET l_table = cl_prt_temptable('aicr046',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN      # If background job sw is off
      CALL r046_tm(0,0)		                  # Input print condition
      ELSE CALL apmr046()			  # Read data and create out-file
   END IF
   #NO.FUN-7B0075---begin
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   #NO.FUN-7B0075---end
END MAIN
 
FUNCTION r046_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_cmd		LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r046_w AT p_row,p_col WITH FORM "aic/42f/aicr046"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r046_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM        
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more 		# Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r046_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM        
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr046'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr046','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'", 
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'" 
         CALL cl_cmdat('apmr046',g_time,l_cmd)	             # Execute cmd at later time
      END IF
      CLOSE WINDOW r046_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr046()
   ERROR ""
END WHILE
   CLOSE WINDOW r046_w
END FUNCTION
 
FUNCTION apmr046()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name
          l_time	LIKE type_file.chr8,  	      # Used time for running the job
          l_sql 	STRING,		              # RDSQL STATEMENT
          l_za05	LIKE type_file.chr1000,
          t_azi03       LIKE azi_file.azi03,
          l_ima021      LIKE ima_file.ima021,
          l_ima021_1    LIKE ima_file.ima021,
          l_pmc03       LIKE pmc_file.pmc03,
          l_pmc03_1     LIKE pmc_file.pmc03,
          l_pmc03_2     LIKE pmc_file.pmc03,
          l_ima02       LIKE ima_file.ima02,
          sr            RECORD
                               pmm01    LIKE pmm_file.pmm01,
                               pmm09    LIKE pmm_file.pmm09,
                               pmm22    LIKE pmm_file.pmm22,
                               pmn02    LIKE pmn_file.pmn02,
                               pmn04    LIKE pmn_file.pmn04,
                               pmn041   LIKE pmn_file.pmn041,
                               pmn20    LIKE pmn_file.pmn20,
                               pmn31    LIKE pmn_file.pmn31,
                               pmm04    LIKE pmn_file.pmn04,
                               pmn33    LIKE pmn_file.pmn33,
                               pmniicd16  LIKE pmni_file.pmniicd16,
                               sfb22    LIKE sfb_file.sfb22,
                               sfb221    LIKE sfb_file.sfb221,
                               pmniicd15  LIKE pmni_file.pmniicd15,
                               pmn41    LIKE pmn_file.pmn41,
                               pmniicd11  LIKE pmni_file.pmniicd11,
                               pmniicd18  LIKE pmni_file.pmniicd18,
                               sfb06    LIKE sfb_file.sfb06,
                               sfb08    LIKE sfb_file.sfb08,
                               sfb82    LIKE sfb_file.sfb82
                        END RECORD
           
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                          
               "  ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?)"                                                                                                
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
   LET g_sql = "SELECT pmm01,sfb22,pmn41 ",
               #" FROM pmm_file,OUTER pmni_file ",  #CHI-A40038 mark
               " FROM pmm_file LEFT OUTER JOIN pmni_file ON pmm01 = pmniicd01 ", #CHI-A40038 mod
               #" WHERE pmm_file.pmm01=pmni_file.pmniicd01 ",  #CHI-A40038 mark
               " WHERE pmniicd02='44' "   #CHI-A40038 mod
   PREPARE insert_prept FROM g_sql
   LET l_sql = "SELECT DISTINCT",
                 " pmm01,pmm09,pmm22,pmn02,pmn04,pmn041,pmn20,pmn31",
                 ",pmm04,pmn33,pmniicd16,sfb22,sfb221,pmniicd15,pmn41",
                 ",pmniicd11,pmniicd18,sfb06,sfb08,sfb82 ",
                 "  FROM pmm_file,pmn_file LEFT OUTER JOIN pmni_file ON pmn01=pmniicd01 ,",
                 "sfb_file LEFT OUTER JOIN sfbi_file ON sfb01=sfbiicd01 ", #AND sfbiicd09 in ('30','40','50','51')",   #No.TQC-950072
                 " WHERE pmm01 = pmn01 AND pmm01=sfb01 ",
                 " AND pmn011 = 'SUB' ",
                 " AND sfb02='7' ",
                 " AND pmn16 IN ('2') AND ",tm.wc 
   PREPARE r730_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM        
   END IF
   DECLARE r730_curs1 CURSOR FOR r730_prepare1
   FOREACH r730_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01=sr.pmm22
       IF cl_null(t_azi03) THEN 
          LET t_azi03 = 0
       END IF
       SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.pmn04
       IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
       END IF
       SELECT ima02,ima021 INTO l_ima02,l_ima021_1 FROM ima_file WHERE ima01=sr.pmniicd15
       IF SQLCA.sqlcode THEN
          LET l_ima021_1 = NULL
       END IF
 
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.pmm09
       IF SQLCA.sqlcode THEN
          LET l_pmc03 = NULL
       END IF
       SELECT pmc03 INTO l_pmc03_1 FROM pmc_file WHERE pmc01=sr.pmniicd18
       IF SQLCA.sqlcode THEN
          LET l_pmc03_1 = NULL
       END IF
       SELECT pmc03 INTO l_pmc03_2 FROM pmc_file WHERE pmc01=sr.sfb82
       IF SQLCA.sqlcode THEN
          LET l_pmc03_2 = NULL
       END IF
       EXECUTE insert_prep USING
                  sr.pmm01,sr.pmm09,sr.pmm22,sr.pmn02,sr.pmn04,
                  sr.pmn041,sr.pmn20,sr.pmn31,sr.pmm04,sr.pmn33,
                  sr.pmniicd16,sr.sfb22,sr.sfb221,sr.pmniicd15,sr.pmn41,
                  sr.pmniicd11,sr.pmniicd18,sr.sfb06,sr.sfb08,sr.sfb82,
                  t_azi03,l_ima021,l_ima021_1,l_pmc03,l_pmc03_1,l_pmc03_2,l_ima02
   END FOREACH
   LET l_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str= ''
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
   IF g_zz05 = 'Y' THEN                                                                                                          
      CALL cl_wcchp(tm.wc,'pmm01') RETURNING tm.wc 
      LET g_str = tm.wc
   END IF
   LET g_str =g_str,";",g_azi07
   CALL cl_prt_cs3('aicr046','aicr046',l_sql,g_str)    
END FUNCTION
