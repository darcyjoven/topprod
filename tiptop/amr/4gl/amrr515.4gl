# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amrr515.4gl
# Descriptions...: MRP交期提前參照表
# Input parameter: 
# Return code....: 
# Date & Author..: 09/04/22 By Carrier #FUN-940112
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #No.FUN-940112
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc      STRING,                    # Where condition
              ver_no  LIKE mss_file.mss_v,       
              edate   LIKE type_file.dat,        
              more    LIKE type_file.chr1        # Input more condition(Y/N)   #NO.FUN-680082 VARCHAR(1)        
              END RECORD
   DEFINE  g_sql      STRING       
   DEFINE  g_str      STRING       
   DEFINE  l_table    STRING       
   
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CONTINUE
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
   
   LET g_sql = "mss01.mss_file.mss01,", 
               "ima02.ima_file.ima02,", 
               "ima021.ima_file.ima021,", 
               "ima25.ima_file.ima25,", 
               "mss03.mss_file.mss03,", 
               "mss072.mss_file.mss072,",
               "mss071.mss_file.mss071,",
               "mst04.mst_file.mst04,", 
               "mst06.mst_file.mst06,", 
               "mst061.mst_file.mst061,",
               "mst08.mst_file.mst08,",
               "sw.type_file.chr1"
   LET l_table = cl_prt_temptable('amrr515',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF
 
   LET g_trace = 'N'                # default trace off
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ver_no = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   IF cl_null(g_bgjob) OR g_bgjob='N'    # If background job sw is off
      THEN CALL amrr515_tm(0,0)          # Input print condition
      ELSE CALL amrr515()                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION amrr515_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 13 END IF
 
   OPEN WINDOW amrr515_w AT p_row,p_col WITH FORM "amr/42f/amrr515"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON mss01,ima67,mss02,ima08,ima43
 
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
          ON ACTION controlp                                                                                              
             IF INFIELD(mss01) THEN                                                                                                  
                CALL cl_init_qry_var()                                                                                               
                LET g_qryparam.form = "q_ima"                                                                                       
                LET g_qryparam.state = "c"                                                                                           
                CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
                DISPLAY g_qryparam.multiret TO mss01                                                                                 
                NEXT FIELD mss01                                                                                                     
             END IF  
 
          ON ACTION locale
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW amrr515_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
         EXIT PROGRAM
      END IF
 
      DISPLAY BY NAME tm.ver_no,tm.edate,tm.more 
      INPUT BY NAME tm.ver_no,tm.edate,tm.more WITHOUT DEFAULTS
 
          BEFORE INPUT
              CALL cl_qbe_display_condition(lc_qbe_sn)
 
          AFTER FIELD more
             IF tm.more = 'Y'
                THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                    g_bgjob,g_time,g_prtway,g_copies)
                          RETURNING g_pdate,g_towhom,g_rlang,
                                    g_bgjob,g_time,g_prtway,g_copies
             END IF
 
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
           CLOSE WINDOW amrr515_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
           EXIT PROGRAM
        END IF
        IF g_bgjob = 'Y' THEN
           SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01='amrr515'
           IF SQLCA.sqlcode OR l_cmd IS NULL THEN
              CALL cl_err('amrr515','9031',1)
           ELSE
              LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
              LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                              " '",g_pdate CLIPPED,"'",
                              " '",g_towhom CLIPPED,"'",
                              " '",g_lang CLIPPED,"'",
                              " '",g_bgjob CLIPPED,"'",
                              " '",g_prtway CLIPPED,"'",
                              " '",g_copies CLIPPED,"'",
                              " '",tm.wc CLIPPED,"'",
                              " '",tm.ver_no CLIPPED,"'",
                              " '",tm.edate CLIPPED,"'",
                              " '",g_rep_user CLIPPED,"'",          
                              " '",g_rep_clas CLIPPED,"'",           
                              " '",g_template CLIPPED,"'"           
              IF g_trace = 'Y' THEN ERROR l_cmd END IF
              CALL cl_cmdat('amrr515',g_time,l_cmd)    # Execute cmd at later time
           END IF
           CLOSE WINDOW amrr515_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
           EXIT PROGRAM
        END IF
        CALL cl_wait()
        CALL amrr515()
        ERROR ""
   END WHILE
   CLOSE WINDOW amrr515_w
END FUNCTION
 
FUNCTION amrr515()
   DEFINE l_sql     LIKE type_file.chr1000      # RDSQL STATEMENT               #NO.FUN-680082 VARCHAR(1000)
   DEFINE mss       RECORD LIKE mss_file.*
   DEFINE mst       RECORD LIKE mst_file.* 
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_ima021  LIKE ima_file.ima021
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE sr        RECORD
                    mss01    LIKE mss_file.mss01,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,
                    ima25    LIKE ima_file.ima25,
                    mss03    LIKE mss_file.mss03,
                    mss072   LIKE mss_file.mss072,
                    mss071   LIKE mss_file.mss071,
                    mst04    LIKE mst_file.mst04,
                    mst06    LIKE mst_file.mst06,
                    mst061   LIKE mst_file.mst061,
                    mst08    LIKE mst_file.mst08,
                    sw       LIKE type_file.chr1
                    END RECORD
  
   DEFINE l_gen02  LIKE gen_file.gen02 
   DEFINE l_pono   LIKE pmm_file.pmm01 
   DEFINE l_prno   LIKE pmm_file.pmm01 
   DEFINE l_vender LIKE pmm_file.pmm09 
   DEFINE l_pmc03  LIKE pmc_file.pmc03 
  
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'amrr515' 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql = "SELECT mss_file.*,ima02,ima021,ima25 ",
               "  FROM mss_file, ima_file",
               " WHERE ",tm.wc,
               "   AND mss01=ima01 ",
               "   AND mss_v='",tm.ver_no CLIPPED,"'",
               "   AND mss03<='",tm.edate,"'",
               "   AND (mss071 > 0 OR mss072 > 0 )",
               "   ORDER BY mss01,mss02,mss03"
 
   PREPARE amrr515_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE amrr515_curs1 CURSOR FOR amrr515_prepare1
 
   LET l_sql = "SELECT * FROM mst_file ",
               " WHERE mst05 IN ('61','62','63','64','65')",
               "   AND mst_v = '",tm.ver_no CLIPPED,"'",
               "   AND mst01=? AND mst02=? ",
               "   AND mst03=? ",
               " ORDER BY mst06,mst061"
   PREPARE r515_premst  FROM l_sql
   IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM 
   END IF
   DECLARE r515_curmst CURSOR FOR r515_premst 
 
   FOREACH amrr515_curs1 INTO mss.*,l_ima02,l_ima021,l_ima25
       IF STATUS THEN 
          CALL cl_err('foreach:',STATUS,1) 
          EXIT FOREACH
       END IF
       INITIALIZE sr.* TO NULL
       LET sr.mss01 = mss.mss01
       LET sr.ima02 = l_ima02
       LET sr.ima021= l_ima021
       LET sr.ima25 = l_ima25
       IF mss.mss071 > 0 THEN
          LET sr.mss03 = mss.mss03
          LET sr.mss071 = mss.mss071
          LET sr.mss072 = 0
          FOREACH r515_curmst USING mss.mss01,mss.mss02,mss.mss03 INTO mst.*
             IF STATUS THEN 
                CALL cl_err('foreach:',STATUS,1) 
                EXIT FOREACH
             END IF
             LET sr.mst04 = mst.mst04
             LET sr.mst06 = mst.mst06
             LET sr.mst061= mst.mst061
             LET sr.mst08 = mst.mst08
             LET sr.sw = '2'
             EXECUTE insert_prep USING sr.*
          END FOREACH
       END IF
       IF mss.mss072 > 0 THEN
          LET sr.mss03 = mss.mss03
          LET sr.mss072 = mss.mss072
          LET sr.mss071 = 0 
          LET sr.mst04 = ''
          LET sr.mst06 = ''
          LET sr.mst061= 0
          LET sr.mst08 = 0
          LET sr.sw = '1'
          EXECUTE insert_prep USING sr.*
       END IF
     END FOREACH
     
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'mss01,ima67,mss02,ima08,ima43')
        RETURNING tm.wc
     END IF
     
     LET g_str = tm.wc,";",tm.ver_no,";",tm.edate
     
     CALL cl_prt_cs3('amrr515','amrr515',g_sql,g_str)
END FUNCTION
 
