# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: atmr304.4gl
# Descriptions...: 庫戶庫存異動單
# Date & Author..: #FUN-B50056  11/05/13 By lixiang  

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                    # Print condition RECORD
              wc      STRING,           # Where condition
              TYPE    LIKE type_file.chr1,               
              more    LIKE type_file.chr1         
              END RECORD
DEFINE g_sql   STRING                       
DEFINE l_table STRING                       
DEFINE g_str   STRING
DEFINE g_tus01 LIKE tus_file.tus01                       
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql="tus01.tus_file.tus01,tus02.tus_file.tus02,tus05.tus_file.tus05,gem02.gem_file.gem02,tus06.tus_file.tus06,",
             "tus11.tus_file.tus11,tus03.tus_file.tus03,occ02.occ_file.occ02,tus04.tus_file.tus04,occ02_2.occ_file.occ02,", 
             "tut02.tut_file.tut02,tut08.tut_file.tut08,tut03.tut_file.tut03,ima02.ima_file.ima02,",
             "tut05.tut_file.tut05,tut04.tut_file.tut04,tut06.tut_file.tut06"  
 
   LET l_table = cl_prt_temptable('atmr304',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   LET tm.wc = ARG_VAL(1) 
   LET g_pdate = ARG_VAL(2)               # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   IF cl_null(tm.wc) THEN
      CALL atmr304_tm(0,0)     
   ELSE 
      CALL atmr304()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION atmr304_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01       
DEFINE p_row,p_col     LIKE type_file.num5,      
       l_cmd           LIKE type_file.chr1000     
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW atmr304_w AT p_row,p_col WITH FORM "atm/42f/atmr304"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   LET tm.type  = '5'   
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_copies= '1'
   LET g_bgjob = 'N'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON tus01,tus03,tus09,tus02

         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
    ON ACTION CONTROLP
       CASE WHEN INFIELD(tus01)      #異動單號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_tus01_1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tus01
               NEXT FIELD tus01
            WHEN INFIELD(tus03)      
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tus03
               NEXT FIELD tus03
            WHEN INFIELD(tus09)      
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tus09
               NEXT FIELD tus09
            OTHERWISE EXIT CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW atmr304_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = '1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.type,tm.more         # Condition
 
   INPUT BY NAME tm.type,tm.more
         WITHOUT DEFAULTS
     
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD type
        IF tm.type NOT MATCHES '[12345]' THEN 
           NEXT FIELD TYPE
        END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
         
      AFTER INPUT
         IF INT_FLAG THEN 
            EXIT INPUT
         END IF
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLG 
         CALL cl_cmdask()     # Command execution
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmr304_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='atmr304'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr304','9031',1)
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
         CALL cl_cmdat('atm304',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW atmr304_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr304()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr304_w
END FUNCTION
 
FUNCTION atmr304()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_time    LIKE type_file.chr8,          # Used time for running the job   
          l_sql     STRING,                       
          l_chr     LIKE type_file.chr1,          
          l_za05    LIKE za_file.za05,           
          sr        RECORD 
                     tus01   LIKE tus_file.tus01,
                     tus02   LIKE tus_file.tus02,
                     tus05   LIKE tus_file.tus05,
                     gem02   LIKE gem_file.gem02,
                     tus06   LIKE tus_file.tus06,
                     tus11   LIKE tus_file.tus11,
                     tus03   LIKE tus_file.tus03,
                     occ02   LIKE occ_file.occ02,
                     tus04   LIKE tus_file.tus04,
                     occ02_2 LIKE occ_file.occ02,
                     tut02   LIKE tut_file.tut02,
                     tut08   LIKE tut_file.tut08,
                     tut03   LIKE tut_file.tut03,
                     ima02   LIKE ima_file.ima02,
                     tut05   LIKE tut_file.tut05,
                     tut04   LIKE tut_file.tut04,
                     tut06   LIKE tut_file.tut06
                    END RECORD
 
     CALL cl_del_data(l_table)                     
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
 
     LET l_sql=" SELECT tus01,tus02,tus05,'',tus06,tus11,tus03,'',tus04,'',", 
               "        tut02,tut08,tut03,ima02,tut05,tut04,tut06",   
               " FROM tus_file,tut_file LEFT JOIN ima_file ON tut03 = ima01",   #FUN-A10007 add
               " WHERE tus01 = tut01 AND tus08 = '1' "

     IF tm.type='1' THEN 
         LET l_sql=l_sql CLIPPED," AND tusconf='N' "
     END IF
     IF tm.type='2' THEN 
         LET l_sql=l_sql CLIPPED," AND tusconf='Y' AND tuspost='N' "
     END IF
     IF tm.type='3' THEN 
         LET l_sql=l_sql CLIPPED," AND tuspost='Y' "
     END IF     
     IF tm.type='4' THEN 
         LET l_sql=l_sql CLIPPED," AND tusconf='X' "
     END IF
    
     LET l_sql=l_sql CLIPPED," AND ",tm.wc CLIPPED," ORDER BY tus01,tut02"

     PREPARE atmr304_p1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE atmr304_c1 CURSOR FOR atmr304_p1
                                 
     LET g_success='Y'
     BEGIN WORK
     FOREACH atmr304_c1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          EXIT PROGRAM 
       END IF
       SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.tus05
       SELECT occ02 INTO sr.occ02 FROM occ_file WHERE occ01=sr.tus03   
       SELECT occ02 INTO sr.occ02_2 FROM occ_file WHERE occ01=sr.tus04
       
       EXECUTE insert_prep USING sr.tus01,sr.tus02,sr.tus05,sr.gem02,sr.tus06,
                                 sr.tus11,sr.tus03,sr.occ02,sr.tus04,sr.occ02_2,
                                 sr.tut02,sr.tut08,sr.tut03,sr.ima02,sr.tut05,
                                 sr.tut04,sr.tut06
     END FOREACH

     IF g_success = 'Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK 
     END IF

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'tus01')
          RETURNING tm.wc
     LET g_str = tm.wc
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3('atmr304','atmr304',l_sql,g_str)
END FUNCTION
#FUN-B50056 ---end---
