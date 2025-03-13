# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: abxr601.4gl
# Descriptions...: 保稅成品帳(園區用)
# Date & Author..: 2012/01/05 FUN-BC0115 By Sakura
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD                # Print condition RECORD
                    wc      STRING,      # Where condition
                    bdate   LIKE type_file.dat,        #起始供需日期
                    edate   LIKE type_file.dat,        #截止供需日期
                    mdate   LIKE type_file.dat,        #製表日期
                    a       LIKE type_file.num5,    #起始頁數
                    d       LIKE type_file.chr1,  #僅列印保稅料件
                    e       LIKE type_file.chr1,  #各料期初為零且當期無異動要印否
                    f       LIKE type_file.chr1,  #各料本期結存為零要印否
                    more    LIKE type_file.chr1   # Input more condition(Y/N)
                   END RECORD
DEFINE g_i         LIKE type_file.num10
DEFINE g_msg       LIKE type_file.chr1000
DEFINE g_sum1      LIKE bxj_file.bxj06, #存倉數量
       g_sum2      LIKE bxj_file.bxj06, #出倉數量
       g_sum3      LIKE bxj_file.bxj06, #出口數量
       g_sum4      LIKE bxj_file.bxj06  #內銷數量
DEFINE g_sm,g_em   LIKE type_file.num10                                                                                             
DEFINE l_table        STRING                                                                                                        
DEFINE g_str          STRING                                                                                                        
DEFINE g_sql          STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
                                                                                              
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                          
   #1.建立主要報表table                                                                                                             
   LET g_sql = "ima01.ima_file.ima01,",                                                                                             
               "ima02.ima_file.ima02,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "ima1915.ima_file.ima1915,",                                                                                         
               "ima1916.ima_file.ima1916,",                                                                                         
               "bxe02.bxe_file.bxe02,",                                                                                             
               "bxe03.bxe_file.bxe03,",                                                                                             
               "bxe04.bxe_file.bxe04,",                                                                                             
               "bxe05.bxe_file.bxe05,",                                                                                             
               "bnf07.bnf_file.bnf07,",                                                                                             
               "bxj04.bxj_file.bxj04,",                                                                                             
               "bxj05.bxj_file.bxj05,",                                                                                             
               "bxj06.bxj_file.bxj06,",                                                                                             
               "bxj11.bxj_file.bxj11,",                                                                                             
               "bxj17.bxj_file.bxj17,",                                                                                             
               "bxj01.bxj_file.bxj01,",                                                                                             
               "bxi02.bxi_file.bxi02,",                                                                                             
               "bxi06.bxi_file.bxi06,",                                                                                             
               "bxi02a.bxi_file.bxi02,",                                                                                            
               "bxj01a.bxj_file.bxj01,",
               "num1.bxj_file.bxj06,",                                                                                              
               "bxi02b.bxi_file.bxi02,",                                                                                            
               "bxj01b.bxj_file.bxj01,",                                                                                            
               "num2.bxj_file.bxj06,",                                                                                              
               "bxj17a.bxj_file.bxj17,",                                                                                            
               "bxj11a.bxj_file.bxj11,",                                                                                            
               "num3.bxj_file.bxj06,",                                                                                              
               "bxj17b.bxj_file.bxj17,",                                                                                            
               "bxj11b.bxj_file.bxj11,",                                                                                            
               "num4.bxj_file.bxj06,",                                                                                              
               "bxj10.bxj_file.bxj10,",                                                                                             
               "bxj21.bxj_file.bxj21,",                                                                                             
               "bxz100.bxz_file.bxz100,",                                                                                           
               "bxz101.bxz_file.bxz101,",                                                                                           
               "bxz102.bxz_file.bxz102"                                                                                            
   LET l_table = cl_prt_temptable('abxr601',g_sql) CLIPPED   # 產生Temp Table                                                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                       
                                                                                                                                    
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,                                                                          
               " VALUES(?,?,?,?,? ,?,?,?,?,?,                                                                                        
                        ?,?,?,?,? ,?,?,?,?,?,                                                                                        
                        ?,?,?,?,? ,?,?,?,?,?,                                                                                        
                        ?,?,?,?,?) "                                                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
   #------------------------------ CR (1) ------------------------------#
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_pdate  = ARG_VAL(1)    # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.mdate = ARG_VAL(10)
   LET tm.d     = ARG_VAL(11)
   LET tm.e     = ARG_VAL(12)
   LET tm.f     = ARG_VAL(13)
   LET tm.more  = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
 
   CALL r601_create()
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r601_tm(4,17)                    # Input print condition
   ELSE
      CALL r601()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   DROP TABLE abxr601_tmp
END MAIN
 
FUNCTION r601_create()
   DROP TABLE abxr601_tmp
   CREATE TEMP TABLE abxr601_tmp(
     bxj04      LIKE bxj_file.bxj04,
     bxj05      LIKE bxj_file.bxj05,
     bxj06      LIKE bxj_file.bxj06,
     bxj11      LIKE bxj_file.bxj11,
     bxj17      LIKE bxj_file.bxj17,
     bxj01      LIKE bxj_file.bxj01,
     bxi02      LIKE bxi_file.bxi02,
     bxi06      LIKE bxi_file.bxi06,
     bxi02a     LIKE bxi_file.bxi02,
     bxj01a     LIKE bxj_file.bxj01,
     num1       LIKE bxj_file.bxj06,
     bxi02b     LIKE bxi_file.bxi02,
     bxj01b     LIKE bxj_file.bxj01,
     num2       LIKE bxj_file.bxj06,
     bxj17a     LIKE bxj_file.bxj17,
     bxj11a     LIKE bxj_file.bxj11,
     num3       LIKE bxj_file.bxj06,
     bxj17b     LIKE bxj_file.bxj17,
     bxj11b     LIKE bxj_file.bxj11,
     num4       LIKE bxj_file.bxj06,
     bxj10      LIKE bxj_file.bxj10,
     bxj21      LIKE bxj_file.bxj21)
   IF STATUS THEN
      CALL cl_err('create tmp',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION r601_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   OPEN WINDOW r601_w AT p_row,p_col
        WITH FORM "abx/42f/abxr601"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.mdate = g_today
   LET tm.d     = 'N'
   LET tm.e     = 'N'
   LET tm.f     = 'Y'
   LET tm.more  = 'N'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(ima01)      #料件編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima01
                   NEXT FIELD ima01
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
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.bdate,tm.edate,tm.mdate,tm.d,
                      tm.e,tm.f,tm.more
      INPUT BY NAME tm.bdate,tm.edate,tm.mdate,tm.d,
                    tm.e,tm.f,tm.more
                    WITHOUT DEFAULTS
 
         AFTER FIELD edate
            IF NOT cl_null(tm.edate) AND NOT cl_null(tm.bdate) THEN
               IF tm.edate < tm.bdate THEN
                  CALL cl_err('','mfg9234',0)
                  NEXT FIELD bdate
               END IF
            END IF
 
         AFTER FIELD d
            IF tm.d NOT MATCHES "[YN]" THEN
               NEXT FIELD d
            END IF
 
         AFTER FIELD e
            IF tm.e NOT MATCHES "[YN]" THEN
               NEXT FIELD e
            END IF
 
         AFTER FIELD f
            IF tm.f NOT MATCHES "[YN]" THEN
               NEXT FIELD f
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0 
               CLOSE WINDOW r601_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time
               EXIT PROGRAM
            END IF
            IF NOT cl_null(tm.edate) AND NOT cl_null(tm.bdate) THEN
               IF tm.edate < tm.bdate THEN
                  CALL cl_err('','mfg9234',0)
                  NEXT FIELD bdate
               END IF
            END IF
            IF tm.d NOT MATCHES "[YN]" THEN
               NEXT FIELD d
            END IF
            IF tm.e NOT MATCHES "[YN]" THEN
               NEXT FIELD e
            END IF
            IF tm.f NOT MATCHES "[YN]" THEN
               NEXT FIELD f
            END IF
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD more
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
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='abxr601'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abxr601','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.mdate CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.more CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'" 
            CALL cl_cmdat('abxr601',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r601()
      ERROR ""
   END WHILE
   CLOSE WINDOW r601_w
END FUNCTION
 
FUNCTION r601()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
          l_sql     STRING,            # RDSQL STATEMENT
          l_cnt     LIKE type_file.num5,
          l_bxr     RECORD LIKE bxr_file.*,
          l_yy,l_mm LIKE type_file.num5,
          sr        RECORD
                       ima01      LIKE ima_file.ima01,
                       ima02      LIKE ima_file.ima02,
                       ima021     LIKE ima_file.ima021,
                       ima1915    LIKE ima_file.ima1915,
                       ima1916    LIKE ima_file.ima1916,
                       bxe02      LIKE bxe_file.bxe02,
                       bxe03      LIKE bxe_file.bxe03,
                       bxe04      LIKE bxe_file.bxe04,
                       bxe05      LIKE bxe_file.bxe05,
                       bnf07      LIKE bnf_file.bnf07
                    END RECORD,
          sr1       RECORD
                       bxj04      LIKE bxj_file.bxj04,
                       bxj05      LIKE bxj_file.bxj05,
                       bxj06      LIKE bxj_file.bxj06,
                       bxj11      LIKE bxj_file.bxj11,
                       bxj17      LIKE bxj_file.bxj17,
                       bxj01      LIKE bxj_file.bxj01,
                       bxi02      LIKE bxi_file.bxi02,
                       bxi06      LIKE bxi_file.bxi06,
                       bxi02a     LIKE bxi_file.bxi02, #存倉日期
                       bxj01a     LIKE bxj_file.bxj01, #存倉單據號碼
                       num1       LIKE bxj_file.bxj06, #存倉數量
                       bxi02b     LIKE bxi_file.bxi02, #出倉日期
                       bxj01b     LIKE bxj_file.bxj01, #出倉單據號碼
                       num2       LIKE bxj_file.bxj06, #出倉數量
                       bxj17a     LIKE bxj_file.bxj17, #外銷出廠日期
                       bxj11a     LIKE bxj_file.bxj11, #外銷出口報單號碼
                       num3       LIKE bxj_file.bxj06, #出口數量
                       bxj17b     LIKE bxj_file.bxj17, #內銷補稅日期
                       bxj11b     LIKE bxj_file.bxj11, #補稅報單號碼
                       num4       LIKE bxj_file.bxj06, #內銷數量
                       bxj10      LIKE bxj_file.bxj10,
                       bxj21      LIKE bxj_file.bxj21
                    END RECORD
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                             
   CALL cl_del_data(l_table)                                                                                                        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                         
   #------------------------------ CR (2) ------------------------------#

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   LET l_sql = "SELECT ima01,ima02,ima021,ima1915,ima1916, ",
               "       bxe02,bxe03,bxe04,bxe05,0 ",
               "  FROM ima_file, OUTER bxe_file ",
               " WHERE ima_file.ima1916 = bxe_file.bxe01",
               "   AND (ima106='2' OR ima106='3') ",
               "   AND ", tm.wc CLIPPED
   IF tm.d = "Y" THEN 
      LET l_sql = l_sql CLIPPED, " AND ima15 = 'Y' "   #保稅
   END IF

   PREPARE r601_pre_ima FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r601_ima_cs CURSOR FOR r601_pre_ima
   LET l_yy = YEAR(tm.bdate)
   LET l_mm = MONTH(tm.bdate)
   IF l_mm = 1 THEN
      LET l_yy = l_yy - 1
      LET l_mm = 12
   ELSE
      LET l_mm = l_mm - 1
   END IF
   LET g_sm = YEAR(tm.bdate) * 12 + 1
   LET g_em = YEAR(tm.edate) * 12 + MONTH(tm.edate)
 
   FOREACH r601_ima_cs INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH r601_ima_cs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE sr1.* TO NULL
      #上期結轉數量
      LET sr.bnf07 = 0
      SELECT SUM(bnf07) INTO sr.bnf07 FROM bnf_file
       WHERE bnf01 = sr.ima01
         AND bnf03 = l_yy
         AND bnf04 = l_mm
      IF sr.bnf07 IS NULL THEN LET sr.bnf07 = 0 END IF
      #當期任何異動資料筆數(bxj_file)
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM bxi_file, bxj_file
       WHERE bxi01 = bxj01
         AND bxiconf = 'Y'
         AND bxi02 BETWEEN tm.bdate AND tm.edate
         AND bxj04 = sr.ima01
      IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
      #IF 各料期初為零且當期無異動要印否='N' 且
      #   上期結轉數量(bnf07)=0且該料號當期無任何異動資料(bxj_file)不為資料來源
      IF tm.e = 'N' AND sr.bnf07 = 0 AND l_cnt = 0 THEN
         CONTINUE FOREACH
      END IF                                                                                                                     
      IF cl_null(sr.ima1916) THEN LET sr.ima1916 =' ' END IF
      IF l_cnt = 0 THEN
         IF tm.f = 'Y' THEN                                                                                                
                                                                                                                                    
              EXECUTE insert_prep USING                                                                                             
                     sr.ima01, sr.ima02, sr.ima021, sr.ima1915, sr.ima1916,                                                         
                     sr.bxe02, sr.bxe03, sr.bxe04,  sr.bxe05,   sr.bnf07,                                                           
                     sr1.bxj04,sr1.bxj05,sr1.bxj06, sr1.bxj11,  sr1.bxj17,                                                          
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.bxi02a, sr1.bxj01a,                                                         
                     sr1.num1, sr1.bxi02b, sr1.bxj01b, sr1.num2, sr1.bxj17a,                                                        
                     sr1.bxj11a, sr1.num3, sr1.bxj17b, sr1.bxj11b, sr1.num4,                                                        
                     sr1.bxj10,sr1.bxj21,                                                                                           
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102
         END IF                    
      ELSE
         #計算各料累計數量(並塞入temp)
         DELETE FROM abxr601_tmp
         DECLARE r601_bxj_cs CURSOR FOR
            SELECT bxj04,bxj05,bxj06,bxj11,bxj17,bxj01,bxi02,bxi06,
                   '','',0,'','',0,'','',0,'','',0,bxj10,bxj21,bxr_file.*
              FROM bxi_file, bxj_file, OUTER bxr_file
             WHERE bxi01 = bxj01
               AND bxiconf = 'Y'
               AND bxi02 BETWEEN tm.bdate AND tm.edate
               AND bxj04 = sr.ima01
               AND bxj_file.bxj21 = bxr_file.bxr01
         FOREACH r601_bxj_cs INTO sr1.*,l_bxr.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH r601_bxj_cs:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF sr1.bxi06 = '1' THEN       #存倉
               LET sr1.bxi02a = sr1.bxi02
               LET sr1.bxj01a = sr1.bxj01
               LET sr1.num1   = sr1.bxj06
            END IF
            IF sr1.num1 IS NULL THEN LET sr1.num1 = 0 END IF
            IF sr1.bxi06 = '2' THEN       #出倉
               LET sr1.bxi02b = sr1.bxi02
               LET sr1.bxj01b = sr1.bxj01
               LET sr1.num2   = sr1.bxj06
            END IF
            IF sr1.num2 IS NULL THEN LET sr1.num2 = 0 END IF
            #外銷
            IF l_bxr.bxr61 <> 0 OR l_bxr.bxr62 <> 0 THEN
               LET sr1.bxj11a = sr1.bxj11
               LET sr1.bxj17a = sr1.bxj17
               CASE sr1.bxi06
                    WHEN '1'  LET sr1.num3 = sr1.bxj06 * -1
                    WHEN '2'  LET sr1.num3 = sr1.bxj06
               END CASE
            END IF
            IF sr1.num3 IS NULL THEN LET sr1.num3 = 0 END IF
            #內銷
            IF l_bxr.bxr63 <> 0 THEN
               LET sr1.bxj11b = sr1.bxj11
               LET sr1.bxj17b = sr1.bxj17
               CASE sr1.bxi06
                    WHEN '1'  LET sr1.num4 = sr1.bxj06 * -1
                    WHEN '2'  LET sr1.num4 = sr1.bxj06
               END CASE
            END IF
            IF sr1.num4 IS NULL THEN LET sr1.num4 = 0 END IF
            INSERT INTO abxr601_tmp VALUES(sr1.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               LET g_errno = SQLCA.SQLCODE
               IF cl_null(SQLCA.SQLCODE) THEN LET g_errno ='9052' END IF
               CALL cl_err('Ins abxr601_tmp:',g_errno,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time
               EXIT PROGRAM
            END IF
         END FOREACH
         LET g_sum1 = 0    LET g_sum2 = 0
         LET g_sum3 = 0    LET g_sum4 = 0
         SELECT SUM(num1),SUM(num2),SUM(num3),SUM(num4)
           INTO g_sum1,g_sum2,g_sum3,g_sum4
           FROM abxr601_tmp
         IF g_sum1 IS NULL THEN LET g_sum1 = 0 END IF
         IF g_sum2 IS NULL THEN LET g_sum2 = 0 END IF
         IF g_sum3 IS NULL THEN LET g_sum3 = 0 END IF
         IF g_sum4 IS NULL THEN LET g_sum4 = 0 END IF
         #IF 各料本期結存為零要印否 ='N' 且
         #   若各料累計數量的每個欄位為0者不為資料來源
         IF tm.f = 'N' AND 
            g_sum1 = 0 AND g_sum2 = 0 AND g_sum3 = 0 AND g_sum4 = 0 THEN
            CONTINUE FOREACH
         END IF
         #塞入報表
         DECLARE r601_tmp_cs CURSOR FOR
            SELECT * FROM abxr601_tmp
         FOREACH r601_tmp_cs INTO sr1.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH r601_tmp_cs:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
              EXECUTE insert_prep USING                                                                                             
                     sr.ima01, sr.ima02, sr.ima021, sr.ima1915, sr.ima1916,                                                         
                     sr.bxe02, sr.bxe03, sr.bxe04,  sr.bxe05,   sr.bnf07,                                                           
                     sr1.bxj04,sr1.bxj05,sr1.bxj06, sr1.bxj11,  sr1.bxj17,                                                          
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.bxi02a, sr1.bxj01a,                                                         
                     sr1.num1, sr1.bxi02b, sr1.bxj01b, sr1.num2, sr1.bxj17a,                                                        
                     sr1.bxj11a, sr1.num3, sr1.bxj17b, sr1.bxj11b, sr1.num4,                                                        
                     sr1.bxj10,sr1.bxj21,
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102
         END FOREACH
      END IF
   END FOREACH                                                                                                             

   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##                                                      
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
   #是否列印選擇條件                                                                                                                
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(tm.wc,'zu01')                                                                                                   
           RETURNING tm.wc                                                                                                          
      LET g_str = tm.wc                                                                                                             
   END IF                                                                                                                           
   LET g_str = g_str ,";",                                                                                                          
               tm.bdate USING "yyyy/mm/dd",";",     #p2                                                                             
               tm.edate USING "yyyy/mm/dd",";",     #p3                                                                             
               tm.mdate USING "yyyy/mm/dd" ,";",    #p4                                                                           
               tm.d,";"                             #p5                                                                                                                                                                 
      CALL cl_prt_cs3('abxr601','abxr601',l_sql,g_str)                                                                            
END FUNCTION   
#FUN-BC0115
