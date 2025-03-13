# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aecg720.4gl
# Desc/riptions..: 工單變更列印 (copy from asfr803)
# Date & Author..: 11/12/27 By bart  No.FUN-BC0119
# Modify.........: No.TQC-C10034 12/01/18 By zhuhao CR報表簽核
# Modify.........: No.FUN-C60048 12/06/15 By nanbing CR转 GR

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm RECORD                        # Print condition RECORD
               wc     STRING,                       #Where condition
               a      LIKE type_file.chr1,          
               b      LIKE type_file.chr1,          
               more   LIKE type_file.chr1           
             END RECORD
 
 
DEFINE   g_i             LIKE type_file.num5   #count/index for any purpose
DEFINE   g_sgt01         LIKE sgt_file.sgt01   
DEFINE   g_sgt02         LIKE sgt_file.sgt02   
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                                                                            
DEFINE  l_str      STRING   
###GENGRE###START
TYPE sr1_t RECORD
    sgt01 LIKE sgt_file.sgt01,
    sgt02 LIKE sgt_file.sgt02,
    sgt03 LIKE sgt_file.sgt03,
    sgt04 LIKE sgt_file.sgt04,
    sgt05 LIKE sgt_file.sgt05,
    sgt06 LIKE sgt_file.sgt06,
    sgt07 LIKE sgt_file.sgt07,
    sgt08 LIKE sgt_file.sgt08,
    sgu03 LIKE sgu_file.sgu03,
    sgu04 LIKE sgu_file.sgu04,
    sgu05 LIKE sgu_file.sgu05,
    sgu06 LIKE sgu_file.sgu06,
    sgu07 LIKE sgu_file.sgu07,
    sgu08 LIKE sgu_file.sgu08,
    sgu09 LIKE sgu_file.sgu09,
    sgu10 LIKE sgu_file.sgu10,
    sgu11 LIKE sgu_file.sgu11,
    sgu12 LIKE sgu_file.sgu12,
    sgu13 LIKE sgu_file.sgu13,
    sgu14 LIKE sgu_file.sgu14,
    sgu15 LIKE sgu_file.sgu15,
    sgu16 LIKE sgu_file.sgu16,
    sgu17 LIKE sgu_file.sgu17,
    sgu18 LIKE sgu_file.sgu18,
    sgu20 LIKE sgu_file.sgu20,
    sgu22 LIKE sgu_file.sgu22,
    sgu23 LIKE sgu_file.sgu23,
    sgu24 LIKE sgu_file.sgu24,
    sgu25 LIKE sgu_file.sgu25,
    sgu26 LIKE sgu_file.sgu26,
    sgu27 LIKE sgu_file.sgu27,
    sgu28 LIKE sgu_file.sgu28,
    sgu29 LIKE sgu_file.sgu29,
    sgu30 LIKE sgu_file.sgu30,
    sgu31 LIKE sgu_file.sgu31,
    sgu32 LIKE sgu_file.sgu32,
    sgu33 LIKE sgu_file.sgu33,
    sgu34 LIKE sgu_file.sgu34,
    sgu35 LIKE sgu_file.sgu35,
    sgu36 LIKE sgu_file.sgu36,
    sgu37 LIKE sgu_file.sgu37,
    sgu39 LIKE sgu_file.sgu39,
    sgu41 LIKE sgu_file.sgu41,
    sgu42 LIKE sgu_file.sgu42,
    sgu012 LIKE sgu_file.sgu012,
    sgu014 LIKE sgu_file.sgu014,
    sgu015 LIKE sgu_file.sgu015,
    sgu016 LIKE sgu_file.sgu016,
    sgu43 LIKE sgu_file.sgu43,
    sgu44 LIKE sgu_file.sgu44,
    sgu45 LIKE sgu_file.sgu45,
    sgu46 LIKE sgu_file.sgu46,
    sgu47 LIKE sgu_file.sgu47,
    sgu48 LIKE sgu_file.sgu48,
    sgu49 LIKE sgu_file.sgu49,
    sgu50 LIKE sgu_file.sgu50,
    sgu51 LIKE sgu_file.sgu51,
    sgu52 LIKE sgu_file.sgu52,
    sgu53 LIKE sgu_file.sgu53,
    sgu54 LIKE sgu_file.sgu54,
    sfb02 LIKE sfb_file.sfb02,
    sfb04 LIKE sfb_file.sfb04,
    sfb05 LIKE sfb_file.sfb05,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    order1  LIKE type_file.chr1000,  #FUN-C60048 add
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000

END RECORD
###GENGRE###END

MAIN
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-C60048 mark
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-C60048 mark
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13) 
 
   LET g_sql ="sgt01.sgt_file.sgt01,",
              "sgt02.sgt_file.sgt02,",
              "sgt03.sgt_file.sgt03,",
              "sgt04.sgt_file.sgt04,",
              "sgt05.sgt_file.sgt05,",
              "sgt06.sgt_file.sgt06,",
              "sgt07.sgt_file.sgt07,",
              "sgt08.sgt_file.sgt08,",
              "sgu03.sgu_file.sgu03,",
              "sgu04.sgu_file.sgu04,",
              "sgu05.sgu_file.sgu05,",
              "sgu06.sgu_file.sgu06,",
              "sgu07.sgu_file.sgu07,",
              "sgu08.sgu_file.sgu08,",
              "sgu09.sgu_file.sgu09,",
              "sgu10.sgu_file.sgu10,",
              "sgu11.sgu_file.sgu11,",
              "sgu12.sgu_file.sgu12,",
              "sgu13.sgu_file.sgu13,",
              "sgu14.sgu_file.sgu14,",
              "sgu15.sgu_file.sgu15,",
              "sgu16.sgu_file.sgu16,",
              "sgu17.sgu_file.sgu17,",
              "sgu18.sgu_file.sgu18,",
              "sgu20.sgu_file.sgu20,",
              "sgu22.sgu_file.sgu22,",
              "sgu23.sgu_file.sgu23,",
              "sgu24.sgu_file.sgu24,",
              "sgu25.sgu_file.sgu25,",
              "sgu26.sgu_file.sgu26,",
              "sgu27.sgu_file.sgu27,",
              "sgu28.sgu_file.sgu28,",
              "sgu29.sgu_file.sgu29,",
              "sgu30.sgu_file.sgu30,",
              "sgu31.sgu_file.sgu31,",
              "sgu32.sgu_file.sgu32,",
              "sgu33.sgu_file.sgu33,",
              "sgu34.sgu_file.sgu34,",
              "sgu35.sgu_file.sgu35,",
              "sgu36.sgu_file.sgu36,",
              "sgu37.sgu_file.sgu37,",
              "sgu39.sgu_file.sgu39,",
              "sgu41.sgu_file.sgu41,",
              "sgu42.sgu_file.sgu42,",
              "sgu012.sgu_file.sgu012,",
              "sgu014.sgu_file.sgu014,",
              "sgu015.sgu_file.sgu015,",
              "sgu016.sgu_file.sgu016,",
              "sgu43.sgu_file.sgu43,",
              "sgu44.sgu_file.sgu44,",
              "sgu45.sgu_file.sgu45,",
              "sgu46.sgu_file.sgu46,",
              "sgu47.sgu_file.sgu47,",
              "sgu48.sgu_file.sgu48,",
              "sgu49.sgu_file.sgu49,",
              "sgu50.sgu_file.sgu50,",
              "sgu51.sgu_file.sgu51,",
              "sgu52.sgu_file.sgu52,",
              "sgu53.sgu_file.sgu53,",
              "sgu54.sgu_file.sgu54,",             
              "sfb02.sfb_file.sfb02,",
              "sfb04.sfb_file.sfb04,",
              "sfb05.sfb_file.sfb05,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "order1.type_file.chr1000,", #FUN-C60048 add
             #TQC-C10034---add---begin
              "sign_type.type_file.chr1,",
              "sign_img.type_file.blob,",      
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000"
             #TQC-C10034---add---end
             
   LET l_table = cl_prt_temptable('aecg720',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
      EXIT PROGRAM END 
   IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r720_tm(0,0)              # Input print condition
      ELSE CALL aecg720()                 # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
END MAIN
 
# Description: 讀入批次執行條件
FUNCTION r720_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
 
    DEFINE p_row,p_col	LIKE type_file.num5
    DEFINE l_cmd        LIKE type_file.chr1000
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW r720_w AT p_row,p_col WITH FORM "aec/42f/aecg720"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
    CALL cl_opmsg('p')
 
#   INITIALIZE tm.* TO NULL			# Default condition
    LET g_pdate   = g_today
    LET g_rlang   = g_lang
    LET g_bgjob   = 'N'
    LET g_copies  = '1'
    LET tm.a      = '1'
    LET tm.b      = 'N'
    LET tm.more   = 'N'
 
    WHILE TRUE
       CONSTRUCT BY NAME tm.wc ON sgt01,sgt05,sgt02
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
          #FUN-BC0119  ---begin---
          ON ACTION controlp
            IF INFIELD(sgt01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.state    = "c"
               LET g_qryparam.form = "q_ecm8"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sgt01
               NEXT FIELD sgt01
            END IF
          #FUN-BC0119  ---end---
          ON ACTION locale
              #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
              LET g_action_choice = "locale"
              EXIT CONSTRUCT
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT

          ON ACTION CONTROLG
             CALL cl_cmdask()	# Command execution
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
           CLOSE WINDOW r720_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
           EXIT PROGRAM
        END IF
 
        IF tm.wc=" 1=1 " THEN
           CALL cl_err(' ','9046',0)
           CONTINUE WHILE
        END IF
 
        # Condition
        DISPLAY BY NAME tm.a,tm.b,tm.more
 
        INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
           BEFORE INPUT
              CALL cl_qbe_display_condition(lc_qbe_sn)
 
           AFTER FIELD a
              IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL
                 THEN NEXT FIELD a
              END IF
 
           AFTER FIELD b
              IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
                 THEN NEXT FIELD b
              END IF
 
           AFTER FIELD more
              IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
                 THEN NEXT FIELD more
              END IF
              IF tm.more = 'Y' THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
              END IF
 
           ON ACTION CONTROLZ
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG
              CALL cl_cmdask()	# Command execution
 
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
            CLOSE WINDOW r720_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
            EXIT PROGRAM
        END IF
 
        IF g_bgjob = 'Y' THEN
 
            #get exec cmd (fglgo xxxx)
            SELECT zz08 INTO l_cmd FROM zz_file	
            WHERE zz01='aecg720'
 
            IF SQLCA.sqlcode OR l_cmd IS NULL THEN
                CALL cl_err('aecg720','9031',1)
            ELSE
                # time fglgo xxxx p1 p2 p3
                LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
 
                LET l_cmd = l_cmd CLIPPED
                           ," '",g_pdate  CLIPPED,"'"
                           ," '",g_towhom CLIPPED,"'"
                           ," '",g_lang   CLIPPED,"'"
                           ," '",g_bgjob  CLIPPED,"'"
                           ," '",g_prtway CLIPPED,"'"
                           ," '",g_copies CLIPPED,"'"
                           ," '",tm.wc    CLIPPED,"'"
                           ," '",tm.b     CLIPPED,"'"
                           ," '",tm.a     CLIPPED,"'"
                           ," '",g_rep_user CLIPPED,"'",
                           " '",g_rep_clas CLIPPED,"'",
                           " '",g_template CLIPPED,"'" 
 
                # Execute cmd at later time
                CALL cl_cmdat('aecg720',g_time,l_cmd)
            END IF
 
            CLOSE WINDOW r720_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
            EXIT PROGRAM
        END IF
 
        CALL cl_wait()
        CALL aecg720()
        ERROR ""
 
    END WHILE
    CLOSE WINDOW r720_w
 
END FUNCTION
 
FUNCTION aecg720()
   DEFINE l_name	LIKE type_file.chr20   #External(Disk) file name
   DEFINE l_sql 	STRING
   DEFINE l_chr		LIKE type_file.chr1    
   DEFINE sr1   RECORD  LIKE sgt_file.*,
          sr2   RECORD  LIKE sgu_file.*,
          sr3   RECORD
                   sfb02      LIKE sfb_file.sfb02,    # 工單型態
                   sfb04      LIKE sfb_file.sfb04,    # 工單狀態
                   sfb05      LIKE sfb_file.sfb05,    # 料件編號
                   ima02      LIKE ima_file.ima02,    # 品名規格
                   ima021     LIKE ima_file.ima021,  
                   order1     LIKE type_file.chr1000 #FUN-C60048 add
                END RECORD
  #TQC-C10034--add--begin
   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY
  #TQC-C10034--add--end 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pnauser', 'pnagrup')
 
   LET l_sql = " SELECT sgt_file.*,sgu_file.*,sfb02,sfb04,sfb05,ima02,ima021 ",
               "   FROM sgt_file,OUTER sgu_file,sfb_file,OUTER ima_file ",
               "  WHERE sgt_file.sgt01=sgu_file.sgu01 AND sgt_file.sgt02=sgu_file.sgu02 ",
               "    AND sgt01=sfb01 AND sfb_file.sfb05=ima_file.ima01 ",
               "    AND ",tm.wc CLIPPED
               
   IF tm.a='1' THEN LET l_sql=l_sql CLIPPED,"   AND sgt08 = 'Y'" END IF
   IF tm.a='2' THEN LET l_sql=l_sql CLIPPED,"   AND sgt08!= 'Y'" END IF

   LET l_sql=l_sql CLIPPED," ORDER BY sgt01,sgt02,sgu04"   
 
   PREPARE r720_pr1 FROM l_sql
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE r720_cs1 CURSOR FOR r720_pr1
 
   CALL cl_del_data(l_table) 
   #CALL cl_del_data(l_table1) 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?) "   #TQC-C10034 add 4? #FUN-C60048 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)  #FUN-C60048 add
      EXIT PROGRAM
   END IF
 
   FOREACH r720_cs1 INTO sr1.*,sr2.*,sr3.*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF
     LET sr3.order1 = sr1.sgt01,sr1.sgt02 #FUN-C60048 add
     EXECUTE insert_prep USING sr1.sgt01,sr1.sgt02,sr1.sgt03,sr1.sgt04,sr1.sgt05,
                               sr1.sgt06,sr1.sgt07,sr1.sgt08,sr2.sgu03,
                               sr2.sgu04,sr2.sgu05,sr2.sgu06,sr2.sgu07,sr2.sgu08,
                               sr2.sgu09,sr2.sgu10,sr2.sgu11,sr2.sgu12,sr2.sgu13,
                               sr2.sgu14,sr2.sgu15,sr2.sgu16,sr2.sgu17,sr2.sgu18,
                               sr2.sgu20,sr2.sgu22,sr2.sgu23,sr2.sgu24,sr2.sgu25,
                               sr2.sgu26,sr2.sgu27,sr2.sgu28,sr2.sgu29,sr2.sgu30,
                               sr2.sgu31,sr2.sgu32,sr2.sgu33,
                               sr2.sgu34,sr2.sgu35,sr2.sgu36,sr2.sgu37,sr2.sgu39,
                               sr2.sgu41,sr2.sgu42,sr2.sgu012,sr2.sgu014,sr2.sgu015,
                               sr2.sgu016,sr2.sgu43,sr2.sgu44,sr2.sgu45,sr2.sgu46,
                               sr2.sgu47,sr2.sgu48,sr2.sgu49,sr2.sgu50,sr2.sgu51,
                               sr2.sgu52,sr2.sgu53,sr2.sgu54,sr3.sfb02,sr3.sfb04,  
                               sr3.sfb05,sr3.ima02,sr3.ima021,
                               sr3.order1, #FUN-C60048 add
                               "",  l_img_blob,   "N",""           #TQC-C10034  add
                               
 
   END FOREACH

###GENGRE###   LET l_sql = " SELECT * ",
###GENGRE###               "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
###GENGRE###               " ORDER BY sgt01,sgt02,sgu04 "

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'sgt01,sgt05,sgt02')                                        
      RETURNING tm.wc                                                           
   END IF                      
###GENGRE###   LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.b CLIPPED
  #TQC-C10034--add--begin
   LET g_cr_table = l_table
   LET g_cr_apr_key_f = "sgt01" 
  #TQC-C10034--add--end
   IF g_sma.sma541 = 'Y' THEN
###GENGRE###      CALL cl_prt_cs3('aecg720','aecg720_1',l_sql,l_str)
   # CALL aecg720_grdata()    ###GENGRE### #FUN-C60048 mark
      LET g_template = 'aecg720_2'  #FUN-C60048 add
      CALL aecg720_2_grdata()  #FUN-C60048 add
   ELSE
###GENGRE###      CALL cl_prt_cs3('aecg720','aecg720',l_sql,l_str)
   # CALL aecg720_grdata()    ###GENGRE### #FUN-C60048 mark 
      LET g_template = 'aecg720_1'  #FUN-C60048 add
      CALL aecg720_1_grdata()   #FUN-C60048 add
   END IF 
 
END FUNCTION
#No.FUN-BC0119



###GENGRE###START
FUNCTION aecg720_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY   #FUN-C60048
    CALL cl_gre_init_apr()          #FUN-C60048
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aecg720")
        IF handler IS NOT NULL THEN
            START REPORT aecg720_rep1 TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                       ," ORDER BY order1,sgu04" #FUN-C60048 add
            DECLARE aecg720_datacur1 CURSOR FROM l_sql
            FOREACH aecg720_datacur1 INTO sr1.*
                OUTPUT TO REPORT aecg720_rep1(sr1.*)
            END FOREACH
            FINISH REPORT aecg720_rep1
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aecg720_rep1(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-C60048 sta
    DEFINE l_sfb02_desc      STRING 
    DEFINE l_sfb04_desc      STRING 
    DEFINE l_sgu03_desc      STRING 
    DEFINE l_option          STRING
    DEFINE l_option1         STRING
    DEFINE l_option2         STRING
    DEFINE l_option3         STRING
    DEFINE l_display         STRING
    #FUN-C60048 end
   # ORDER EXTERNAL BY sr1.sgt01,sr1.sgt02,sr1.sgu04 #FUN-C60048 mark
    ORDER EXTERNAL BY sr1.order1, sr1.sgu04 #FUN-C60048 add
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
        BEFORE GROUP OF sr1.order1    
        #BEFORE GROUP OF sr1.sgt01 #FUN-C60048 mark
            LET l_lineno = 0
        
        #BEFORE GROUP OF sr1.sgt02#FUN-C60048 mark
        BEFORE GROUP OF sr1.sgu04

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-C60048 sta
            LET l_option = sr1.sfb02 USING '--,---,---,---,---,--&'
            LET l_option1 = cl_gr_getmsg("gre-064",g_lang,sr1.sfb02)
            LET l_sfb02_desc = l_option,' ',l_option1
            PRINTX l_sfb02_desc
            
            LET l_option2 = sr1.sfb04 USING '--,---,---,---,---,--&'
            LET l_option3 = cl_gr_getmsg("gre-065",g_lang,sr1.sfb04)
            LET l_sfb04_desc = l_option2,' ',l_option3
            PRINTX l_sfb04_desc
           
            LET l_sgu03_desc = cl_gr_getmsg("gre-282",g_lang,sr1.sgu03) 
            PRINTX l_sgu03_desc
            IF NOT cl_null(sr1.ima021) THEN
               LET l_display = 'Y' 
            ELSE
               LET l_display = 'N'
            END IF
            PRINTX l_display 
            #FUN-C60048 end
            PRINTX sr1.*

       # AFTER GROUP OF sr1.sgt01 #FUN-C60048 mark
       # AFTER GROUP OF sr1.sgt02 #FUN-C60048 mark
        AFTER GROUP OF sr1.order1 #FUN-C60048 add
        AFTER GROUP OF sr1.sgu04

        
        ON LAST ROW

END REPORT

#FUN-C60048 sta
FUNCTION aecg720_2_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY   #FUN-C60048
    CALL cl_gre_init_apr()          #FUN-C60048
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aecg720")
        IF handler IS NOT NULL THEN
            START REPORT aecg720_rep2 TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY order1,sgu04" #FUN-C60048 add
            DECLARE aecg720_datacur2 CURSOR FROM l_sql
            FOREACH aecg720_datacur2 INTO sr1.*
                OUTPUT TO REPORT aecg720_rep2(sr1.*)
            END FOREACH
            FINISH REPORT aecg720_rep2
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aecg720_rep2(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-C60048 sta
    DEFINE l_sfb02_desc      STRING 
    DEFINE l_sfb04_desc      STRING 
    DEFINE l_sgu03_desc      STRING 
    DEFINE l_option          STRING
    DEFINE l_option1         STRING
    DEFINE l_option2         STRING
    DEFINE l_option3         STRING
    DEFINE l_sgu04           STRING 
    DEFINE l_display         STRING
    #FUN-C60048 end

   # ORDER EXTERNAL BY sr1.sgt01,sr1.sgt02,sr1.sgu04 #FUN-C60048 mark
    ORDER EXTERNAL BY sr1.order1, sr1.sgu04 #FUN-C60048 add
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.order1    
        #BEFORE GROUP OF sr1.sgt01 #FUN-C60048 mark
            LET l_lineno = 0
            
        #BEFORE GROUP OF sr1.sgt02#FUN-C60048 mark
        BEFORE GROUP OF sr1.sgu04

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-C60048 sta
            LET l_sgu04 = sr1.sgu012,'/',sr1.sgu04,'/',sr1.sgu015
            PRINTX l_sgu04
            LET l_option = sr1.sfb02 USING '--,---,---,---,---,--&'
            LET l_option1 = cl_gr_getmsg("gre-064",g_lang,sr1.sfb02)
            LET l_sfb02_desc = l_option,' ',l_option1
            PRINTX l_sfb02_desc
            
            LET l_option2 = sr1.sfb04 USING '--,---,---,---,---,--&'
            LET l_option3 = cl_gr_getmsg("gre-065",g_lang,sr1.sfb04)
            LET l_sfb04_desc = l_option2,' ',l_option3
            PRINTX l_sfb04_desc
           
            LET l_sgu03_desc = cl_gr_getmsg("gre-282",g_lang,sr1.sgu03) 
            PRINTX l_sgu03_desc 
            IF NOT cl_null(sr1.ima021) THEN
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF
            PRINTX l_display 
            #FUN-C60048 end
            PRINTX sr1.*

       # AFTER GROUP OF sr1.sgt01 #FUN-C60048 mark
       # AFTER GROUP OF sr1.sgt02 #FUN-C60048 mark
        AFTER GROUP OF sr1.order1 #FUN-C60048 add
        AFTER GROUP OF sr1.sgu04

        
        ON LAST ROW

END REPORT
#FUN-C60048
###GENGRE###END

