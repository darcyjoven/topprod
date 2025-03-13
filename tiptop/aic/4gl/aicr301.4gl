# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aicr301.4gl
# Descriptions...: 工單資料列印
# Date & Author..: 12/04/11 By bart (FUN-C30291)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         
            wc     STRING,                 
            more   LIKE type_file.chr1     
           END RECORD
DEFINE g_count     LIKE type_file.num5     
DEFINE g_i         LIKE type_file.num5     
DEFINE g_msg       LIKE type_file.chr1000  
DEFINE g_po_no     LIKE oea_file.oea10    
DEFINE g_ctn_no1,g_ctn_no2   LIKE type_file.chr20       
DEFINE g_sql       STRING                                                       
DEFINE l_table     STRING                                                       
DEFINE l_str       STRING   

 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)

 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc

   LET g_rpt_name = ARG_VAL(11)  
     
   LET g_sql ="sfa03.sfa_file.sfa03,sfa05.sfa_file.sfa05,",
              "sfa12.sfa_file.sfa12,sfaa32.sfaa_file.sfaa32,",
              "sfb05.sfb_file.sfb05,sfb08.sfb_file.sfb08,",
              "sfb15.sfb_file.sfb15,sfb82.sfb_file.sfb82,",
              "pmm01.pmm_file.pmm01,pmm04.pmm_file.pmm04,",
              "pme031.pme_file.pme031,sfbiicd09.sfbi_file.sfbiicd09,",
              "sfbiicd11.sfbi_file.sfbiicd11,sfbiicd12.sfbi_file.sfbiicd12,",
              "sfbiicd18.sfbi_file.sfbiicd18,pmc03.pmc_file.pmc03,",
              "pmc10.pmc_file.pmc10,pmc11.pmc_file.pmc11,",
              "pmc091.pmc_file.pmc091,ima55.ima_file.ima55,",
              "imaicd16.imaicd_file.imaicd16,idb15.idb_file.idb15,",
              "ecd02.ecd_file.ecd02"

   LET l_table = cl_prt_temptable('aicr301',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?) " 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL aicr301_tm(0,0)        # Input print condition
   ELSE
      CALL aicr301()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION aicr301_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    
DEFINE p_row,p_col    LIKE type_file.num5,      
       l_dir          LIKE type_file.chr1,      
       l_cmd          LIKE type_file.chr1000     
 
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW aicr301_w AT p_row,p_col WITH FORM "aic/42f/aicr301"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition
  LET tm.more = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON sfb01,sfb81,sfb05,sfb82

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION CONTROLP      
          CASE
             WHEN INFIELD(sfb01) 
                CALL cl_init_qry_var()
                LET g_qryparam.state    = "c"
                LET g_qryparam.form     = "q_sfb012"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb01
                NEXT FIELD sfb01
                
             WHEN INFIELD(sfb05) 
                CALL q_sel_ima(TRUE, "q_ima18","","","","","","","",'')  RETURNING  g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb05
                NEXT FIELD sfb05

             WHEN INFIELD(sfb82) 
                CALL cl_init_qry_var()
                LET g_qryparam.state    = "c"
                LET g_qryparam.form     = "q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sfb82
                NEXT FIELD sfb82                
            OTHERWISE
              EXIT CASE
          END CASE
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                 
          EXIT CONSTRUCT
  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
  
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
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.more                 
    INPUT BY NAME tm.more WITHOUT DEFAULTS   
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)

 
       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='aicr301'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aicr301','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",         
                         " '",g_rep_clas CLIPPED,"'",         
                         " '",g_template CLIPPED,"'",          
                         " '",g_rpt_name CLIPPED,"'"           
          CALL cl_cmdat('aicr301',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW aicr301_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL aicr301()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW aicr301_w
END FUNCTION
 
FUNCTION aicr301()
   DEFINE cr        RECORD                        
                     sfa03     LIKE sfa_file.sfa03,
                     sfaa05    LIKE sfaa_file.sfaa05,
                     sfaa12    LIKE sfaa_file.sfaa12,
                     sfaa30    LIKE sfaa_file.sfaa30,
                     sfaa31    LIKE sfaa_file.sfaa31,
                     sfaa32    LIKE sfaa_file.sfaa32,
                     sfb01     LIKE sfb_file.sfb01,
                     sfb05     LIKE sfb_file.sfb05,
                     sfb08     LIKE sfb_file.sfb08,
                     sfb15     LIKE sfb_file.sfb15,
                     sfb82     LIKE sfb_file.sfb82,
                     sfbiicd09 LIKE sfbi_file.sfbiicd09,
                     sfbiicd11 LIKE sfbi_file.sfbiicd11,
                     sfbiicd12 LIKE sfbi_file.sfbiicd12,
                     sfbiicd18 LIKE sfbi_file.sfbiicd18,
                     pmc03     LIKE pmc_file.pmc03,
                     pmc10     LIKE pmc_file.pmc10,
                     pmc11     LIKE pmc_file.pmc11,
                     pmc091    LIKE pmc_file.pmc091
                    END RECORD        
   DEFINE l_sql       STRING                                     
   DEFINE l_sfaa32    LIKE sfaa_file.sfaa32,
          l_pmm01     LIKE pmm_file.pmm01,
          l_pmm04     LIKE pmm_file.pmm04,
          l_pmm10     LIKE pmm_file.pmm10,
          l_pme031    LIKE pme_file.pme031,
          l_ima55     LIKE ima_file.ima55,
          l_imaicd16  LIKE imaicd_file.imaicd16,
          l_idb15     LIKE idb_file.idb15,
          l_ecd02     LIKE ecd_file.ecd02,
          l_idb15_r   LIKE idb_file.idb15   

   CALL cl_del_data(l_table)

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')

   LET l_sql=
      "SELECT sfa03,sfaa05,sfaa12,sfaa30,sfaa31,sfaa32,sfb01,sfb05,sfb08,sfb15,sfb82,",
      "       sfbiicd09,sfbiicd11,sfbiicd12,sfbiicd18,pmc03,pmc10,pmc11,pmc091",
      " FROM sfa_file ",
      " INNER JOIN sfb_file ON sfb01 = sfa01 ",
      " LEFT OUTER JOIN sfbi_file ON sfbi01 = sfb01 ",
      " LEFT OUTER JOIN pmc_file ON pmc01 = sfb82 ",
      " LEFT OUTER JOIN sfaa_file ON sfaa01 = sfa01 AND sfaa03 = sfa03 AND sfaa08 = sfa08 ",
      "  AND sfaa12 = sfa12 AND sfaa27 = sfa27 AND sfaa012 = sfa012 AND sfaa013 = sfa013 ",
      "  AND sfb02 IN ('7','8') ",
      " WHERE ",tm.wc CLIPPED
      
   PREPARE aicr301_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
   END IF
   DECLARE aicr301_curs CURSOR FOR aicr301_prepare
 
   FOREACH aicr301_curs INTO cr.*  
      SELECT MAX(pmn01) INTO l_pmm01 FROM pmn_file WHERE pmn41=cr.sfb01
      IF cl_null(l_pmm01) THEN 
         SELECT pmm01 INTO l_pmm01 FROM pmm_file WHERE pmm01=cr.sfb01
      END IF 
      
      IF NOT cl_null(l_pmm01) THEN 
      
         SELECT pmm04,pmm10 INTO l_pmm04,l_pmm10 FROM pmm_file WHERE pmm01 = l_pmm01
      
         IF cl_null(l_pmm10) THEN
            LET l_pme031 = NULL 
         ELSE 
            SELECT pme031 INTO l_pme031 FROM pme_file WHERE pme01 = l_pmm10
         END IF 
      
         SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01 = cr.sfb05

         SELECT imaicd16 INTO l_imaicd16 FROM imaicd_file WHERE imaicd00 = cr.sfa03

         SELECT ecd02 INTO l_ecd02 FROM ecd_file WHERE ecd01 = cr.sfbiicd09

         DECLARE aicr301_idb15 CURSOR FOR 
          SELECT idb15 FROM idb_file
           WHERE idb01 = cr.sfa03
             AND idb02 = cr.sfaa30
             AND idb03 = cr.sfaa31
             AND idb04 = cr.sfaa32
             AND idb07 = cr.sfb01
       
          LET l_idb15_r = NULL 
          FOREACH aicr301_idb15 INTO l_idb15
             IF NOT cl_null(l_idb15) THEN 
                IF cl_null(l_idb15_r) THEN
                   LET l_idb15_r = l_idb15
                ELSE
                   LET l_idb15_r = l_idb15_r,",",l_idb15
                END IF 
             END IF 
          END FOREACH 

         EXECUTE insert_prep USING
                 cr.sfa03,cr.sfaa05,cr.sfaa12,cr.sfaa32,cr.sfb05,cr.sfb08,cr.sfb15,cr.sfb82,
                 l_pmm01,l_pmm04,l_pme031,cr.sfbiicd09,cr.sfbiicd11,cr.sfbiicd12,cr.sfbiicd18,
                 cr.pmc03,cr.pmc10,cr.pmc11,cr.pmc091,l_ima55,l_imaicd16,l_idb15_r,l_ecd02
      END IF 
   END FOREACH

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                 
 
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'sfb01,sfb81,sfb05,sfb82')  
      RETURNING tm.wc                                                           
   ELSE
      LET tm.wc = ''
   END IF                      
 
   LET l_str = tm.wc CLIPPED      

     CALL cl_prt_cs3('aicr301','aicr301',l_sql,l_str)
 
END FUNCTION
#FUN-C30291
