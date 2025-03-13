# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abxr300.4gl
# Descriptions...: 原料帳列印作業
# Date & Author..: 2006/10/24 By kim
 
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.MOD-840234 08/04/24 By mike 此單據為出口單據，應只印外銷，
#                                                 內銷報單號及日期應空白
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0004 10/07/14 By dxfwo 报表改写由CR产出
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD                # Print condition RECORD
                    wc      STRING,      # Where condition
                    bdate   LIKE type_file.dat,        #起始供需日期
                    edate   LIKE type_file.dat,        #截止供需日期
                    mdate   LIKE type_file.dat,        #製表日期
                    a       LIKE type_file.num5,    #起始頁數
                    b       LIKE type_file.chr1,  #列印格式
                    d       LIKE type_file.chr1,  #僅列印保稅料件
                    e       LIKE type_file.chr1,  #各料期初為零且當期無異動要印否
                    f       LIKE type_file.chr1,  #各料本期結存為零要印否
                    g       LIKE type_file.chr1,  #明細列印否
                    s       LIKE type_file.chr2,  #排列順序項目
                    u       LIKE type_file.chr2,  #小計
                    t       LIKE type_file.chr2,  #跳頁
                    more    LIKE type_file.chr1   # Input more condition(Y/N)
                   END RECORD
DEFINE g_i         LIKE type_file.num10
DEFINE g_msg       LIKE type_file.chr1000
DEFINE g_sum1      LIKE bxj_file.bxj06, #存倉數量
       g_sum2      LIKE bxj_file.bxj06, #出倉數量
       g_sum3      LIKE bxj_file.bxj06, #出口數量
       g_sum4      LIKE bxj_file.bxj06  #內銷數量
DEFINE g_sm,g_em   LIKE type_file.num10
#FUN-9B0004 By dxfwo ---start---                                                                                                    
DEFINE l_table        STRING                                                                                                        
DEFINE g_str          STRING                                                                                                        
DEFINE g_sql          STRING                                                                                                        
#FUN-9B0004 By dxfwo ----end----
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   #FUN-9B0004 By dxfwo ---start---                                                                                                 
   ## *** 与 Crystal Reports 串联段 - <<<< 产生Temp Table >>>> CR11 *** ##                                                          
   #1.建立主要报表table                                                                                                             
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
               "bxz102.bxz_file.bxz102,",                                                                                           
               "flag.ima_file.imaacti,",                                                                                            
               "sum1_2.bnf_file.bnf08,",                                                                                            
               "sum2_2.bnf_file.bnf09,",                                                                                            
               "sum3_2.bnf_file.bnf21,",                                                                                            
               "sum4_2.bnf_file.bnf22,",                                                                                            
               "sum1_3.bnf_file.bnf08,",
               "sum2_3.bnf_file.bnf09,",                                                                                            
               "sum3_3.bnf_file.bnf21,",                                                                                            
               "sum4_3.bnf_file.bnf22"                                                                                              
   LET l_table = cl_prt_temptable('abxr300',g_sql) CLIPPED   # 产生Temp Table                                                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table产生                                                       
                                                                                                                                    
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,                                                                          
               " VALUES(?,?,?,?,?,?,?,?,?,?,                                                                                        
                        ?,?,?,?,?,?,?,?,?,?,                                                                                        
                        ?,?,?,?,?,?,?,?,?,?,                                                                                        
                        ?,?,?,?,?,?,?,?,?,?,                                                                                        
                        ?,?,?,?) "                                                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
   #------------------------------ CR (1) ------------------------------#                                                           
   #FUN-9B0004 By dxfwo ----end----
 
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
   LET tm.a     = ARG_VAL(11)
   LET tm.b     = ARG_VAL(12)
   LET tm.d     = ARG_VAL(13)
   LET tm.e     = ARG_VAL(14)
   LET tm.f     = ARG_VAL(15)
   LET tm.g     = ARG_VAL(16)
   LET tm.s     = ARG_VAL(17)
   LET tm.u     = ARG_VAL(18)
   LET tm.t     = ARG_VAL(19)
   LET tm.more  = ARG_VAL(20)
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
 
   CALL r300_create()

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add-- 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r300_tm(4,17)                    # Input print condition
   ELSE
      CALL r300()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
   DROP TABLE abxr300_tmp
END MAIN
 
FUNCTION r300_create()
   DROP TABLE abxr300_tmp
   CREATE TEMP TABLE abxr300_tmp(
     order1     LIKE bxj_file.bxj04,
     order2     LIKE bxj_file.bxj04,
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
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION r300_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   OPEN WINDOW r300_w AT p_row,p_col
        WITH FORM "abx/42f/abxr300"
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
   LET tm.a     = 1
   LET tm.b     = '2'
   LET tm.d     = 'N'
   LET tm.e     = 'N'
   LET tm.f     = 'Y'
   LET tm.g     = 'Y'
   LET tm.s     = '21'
   LET tm.u     = 'NY'
   LET tm.t     = 'NN'
   LET tm.more  = 'N'
   #default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01,ima1916
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(ima01)      #料件編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima01
                   NEXT FIELD ima01
              WHEN INFIELD(ima1916)  #保稅群組代碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bxe01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima1916
                   NEXT FIELD ima1916
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.bdate,tm.edate,tm.mdate,tm.a,tm.b,tm.d,
                      tm.e,tm.f,tm.g,
                      tm2.s1,tm2.s2,tm2.u1,tm2.u2,tm2.t1,tm2.t2,tm.more
      INPUT BY NAME tm.bdate,tm.edate,tm.mdate,tm.a,tm.b,tm.d,
                    tm.e,tm.f,tm.g,
                    tm2.s1,tm2.s2,tm2.u1,tm2.u2,tm2.t1,tm2.t2,tm.more
                    WITHOUT DEFAULTS
 
         AFTER FIELD edate
            IF NOT cl_null(tm.edate) AND NOT cl_null(tm.bdate) THEN
               IF tm.edate < tm.bdate THEN
                  CALL cl_err('','mfg9234',0)
                  NEXT FIELD bdate
               END IF
            END IF
 
         AFTER FIELD a 
            IF tm.a < 0 THEN 
               CALL cl_err('','aim-391',0)
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF tm.b NOT MATCHES "[12]" THEN
               NEXT FIELD b
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
 
         AFTER FIELD g
            IF tm.g NOT MATCHES "[YN]" THEN
               NEXT FIELD g
            END IF
 
         AFTER FIELD s1
            IF NOT cl_null(tm2.s1) THEN
               IF tm2.s1 NOT MATCHES "[12]" THEN
                  NEXT FIELD s1
               END IF
            END IF
 
         AFTER FIELD s2
            IF NOT cl_null(tm2.s2) THEN
               IF tm2.s2 NOT MATCHES "[12]" THEN
                  NEXT FIELD s2
               END IF
            END IF
 
         AFTER FIELD u1
            IF tm2.u1 NOT MATCHES "[YN]" THEN
               NEXT FIELD u1
            END IF
 
         AFTER FIELD u2
            IF tm2.u2 NOT MATCHES "[YN]" THEN
               NEXT FIELD u2
            END IF
 
         AFTER FIELD t1
            IF tm2.t1 NOT MATCHES "[YN]" THEN
               NEXT FIELD t1
            END IF
 
         AFTER FIELD t2
            IF tm2.t2 NOT MATCHES "[YN]" THEN
               NEXT FIELD t2
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
               CLOSE WINDOW r300_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
               EXIT PROGRAM
            END IF
            IF NOT cl_null(tm.edate) AND NOT cl_null(tm.bdate) THEN
               IF tm.edate < tm.bdate THEN
                  CALL cl_err('','mfg9234',0)
                  NEXT FIELD bdate
               END IF
            END IF
            IF NOT cl_null(tm2.s1) THEN
               IF tm2.s1 NOT MATCHES "[12]" THEN
                  NEXT FIELD s1
               END IF
            END IF
            IF NOT cl_null(tm2.s2) THEN
               IF tm2.s2 NOT MATCHES "[12]" THEN
                  NEXT FIELD s2
               END IF
            END IF
            IF tm2.u1 NOT MATCHES "[YN]" THEN
               NEXT FIELD u1
            END IF
            IF tm2.u2 NOT MATCHES "[YN]" THEN
               NEXT FIELD u2
            END IF
            IF tm2.t1 NOT MATCHES "[YN]" THEN
               NEXT FIELD t1
            END IF
            IF tm2.t2 NOT MATCHES "[YN]" THEN
               NEXT FIELD t2
            END IF
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.u = tm2.u1,tm2.u2
            LET tm.t = tm2.t1,tm2.t2
            IF tm.a < 0 THEN 
               CALL cl_err('','aim-391',0)
               NEXT FIELD a
            END IF
            IF tm.b NOT MATCHES "[12]" THEN
               NEXT FIELD b
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
            IF tm.g NOT MATCHES "[YN]" THEN
               NEXT FIELD g
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
         CLOSE WINDOW r300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='abxr300'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abxr300','9031',1)
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
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.g CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.more CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'" 
            CALL cl_cmdat('abxr300',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r300()
      ERROR ""
   END WHILE
   CLOSE WINDOW r300_w
END FUNCTION
 
FUNCTION r300()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     STRING,            # RDSQL STATEMENT
          l_order   ARRAY[3] OF LIKE bxj_file.bxj04,
          l_cnt     LIKE type_file.num5,
          l_bxr     RECORD LIKE bxr_file.*,
          l_yy,l_mm LIKE type_file.num5,
          #FUN-9B0004 By dxfwo  ---start---                                                                                         
          l_order1        LIKE bxj_file.bxj04,                                                                                      
          l_order2        LIKE bxj_file.bxj04,                                                                                      
          l_pre_ima01     LIKE ima_file.ima02,                                                                                      
          l_pre_ima1916   LIKE ima_file.ima1916,                                                                                    
          l_flag          LIKE type_file.chr1,                                                                                      
          sr_ima01    RECORD                                                                                                        
                       sum1     LIKE bnf_file.bnf08,                                                                                
                       sum2     LIKE bnf_file.bnf09,                                                                                
                       sum3     LIKE bnf_file.bnf21,                                                                                
                       sum4     LIKE bnf_file.bnf22                                                                                 
                       END RECORD,
          sr_ima1916    RECORD                                                                                                      
                       sum1     LIKE bnf_file.bnf08,                                                                                
                       sum2     LIKE bnf_file.bnf09,                                                                                
                       sum3     LIKE bnf_file.bnf21,                                                                                
                       sum4     LIKE bnf_file.bnf22                                                                                 
                       END RECORD,                                                                                                  
          #FUN-9B0004 By dxfwo ----end---- 

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
                       order1     LIKE bxj_file.bxj04,
                       order2     LIKE bxj_file.bxj04,
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
 
   #No.FUN-B80082--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End----- 

   #FUN-9B0004 By dxfwo ---start---                                                                                                 
   ## *** 与 Crystal Reports 串联段 - <<<< 清除暂存资料 >>>> CR11 *** ##                                                            
   CALL cl_del_data(l_table)                                                                                                        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                         
   #------------------------------ CR (2) ------------------------------#                                                           
   #FUN-9B0004 By dxfwo ----end---- 

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2 = '4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc CLIPPED," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3 = '4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc CLIPPED," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   LET l_sql = "SELECT ima01,ima02,ima021,ima1915,ima1916, ",
               "       bxe02,bxe03,bxe04,bxe05,0 ",
               "  FROM ima_file, OUTER bxe_file ",
               " WHERE ima_file.ima1916 = bxe_file.bxe01",
               "   AND (ima106='2' OR ima106='3') ",
               "   AND ", tm.wc CLIPPED
   IF tm.d = "Y" THEN 
      LET l_sql = l_sql CLIPPED, " AND ima15 = 'Y' "   #保稅
   END IF 

   #FUN-9B0004 By dxfwo ---start---                                                                                                 
   IF tm.b = '1' THEN LET l_sql = l_sql CLIPPED ," ORDER BY ima01" END IF                                                           
   IF tm.b = '2' THEN LET l_sql = l_sql CLIPPED ," ORDER BY ima1916,ima01" END IF                                                    
   #FUN-9B0004 By dxfwo ----end----

   PREPARE r300_pre_ima FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   DECLARE r300_ima_cs CURSOR FOR r300_pre_ima
#FUN-9B0004 mark begin    
#  CALL cl_outnam('abxr300') RETURNING l_name
#
#  IF tm.b = '1' THEN  #1:料號格式
#     START REPORT r300_rep1 TO l_name
#  ELSE                #2:保稅群組代碼格式
#     START REPORT r300_rep2 TO l_name
#  END IF
#FUN-9B0004 mark end
   LET g_pageno = tm.a - 1     #起始頁數
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
   LET l_pre_ima01   ='NULL'              #FUN-9B0004 By dxfwo  add                                                                 
   LET l_pre_ima1916 ='NULL'              #FUN-9B0004 By dxfwo  add 
 
   FOREACH r300_ima_cs INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH r300_ima_cs:',SQLCA.sqlcode,1)
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
      #FUN-9B0004 By dxfwo  ---start---                                                                                             
      IF l_pre_ima01 != sr.ima01 THEN                                                                                               
         SELECT SUM(bnf05),SUM(bnf06),SUM(bnf28),SUM(bnf10)                                                                         
           INTO sr_ima01.sum1,sr_ima01.sum2,sr_ima01.sum3,sr_ima01.sum4                                                             
           FROM bnf_file                                                                                                            
          WHERE bnf01 = sr.ima01                                                                                                    
            AND bnf03*12+bnf04 BETWEEN g_sm AND g_em                                                                                
                                                                                                                                    
          IF cl_null(sr_ima01.sum1) THEN LET sr_ima01.sum1 = 0 END IF                                                               
          IF cl_null(sr_ima01.sum2) THEN LET sr_ima01.sum2 = 0 END IF                                                               
          IF cl_null(sr_ima01.sum3) THEN LET sr_ima01.sum3 = 0 END IF                                                               
          IF cl_null(sr_ima01.sum4) THEN LET sr_ima01.sum4 = 0 END IF                                                               
      END IF                                                                                                                        
      IF cl_null(sr.ima1916) THEN LET sr.ima1916 =' ' END IF                                                                        
      IF l_pre_ima1916 != sr.ima1916 THEN                                                                                           
         SELECT SUM(bnf05),SUM(bnf06),SUM(bnf28),SUM(bnf10)                                                                         
           INTO sr_ima1916.sum1,sr_ima1916.sum2,sr_ima1916.sum3,sr_ima1916.sum4                                                     
           FROM bnf_file, ima_file                                                                                                  
          WHERE bnf01 = ima01                                                                                                       
            AND ima1916 = sr.ima1916                                                                                                
            AND bnf03*12+bnf04 BETWEEN g_sm AND g_em                                                                                
                                                                                                                                    
          IF cl_null(sr_ima1916.sum1) THEN LET sr_ima1916.sum1 = 0 END IF
          IF cl_null(sr_ima1916.sum2) THEN LET sr_ima1916.sum2 = 0 END IF                                                           
          IF cl_null(sr_ima1916.sum3) THEN LET sr_ima1916.sum3 = 0 END IF                                                           
          IF cl_null(sr_ima1916.sum4) THEN LET sr_ima1916.sum4 = 0 END IF                                                           
      END IF                                                                                                                        
      #FUN-9B0004 By dxfwo ----end---- 
      IF l_cnt = 0 THEN
         IF tm.f = 'Y' THEN
            FOR g_i = 1 TO 2
               CASE
                   WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima1916
                   OTHERWISE                LET l_order[g_i] = '-'
               END CASE
            END FOR
            LET sr1.order1 = l_order[1]
            LET sr1.order2 = l_order[2]
#FUN-9B0004 By dxfwo ---start---
#           IF tm.b = '1' THEN  #1:料號格式
#              OUTPUT TO REPORT r300_rep1(sr.*,sr1.*,0)
#           ELSE                #2:保稅群組代碼格式
#              OUTPUT TO REPORT r300_rep2(sr.*,sr1.*,0)
#           END IF
            IF (tm.b = '1' AND l_pre_ima01 != sr.ima01) OR                                                                          
               (tm.b = '2' AND l_pre_ima1916!= sr.ima1916) THEN                                                                     
              LET l_flag = '1'                                                                                                      
                                                                                                                                    
              EXECUTE insert_prep USING                                                                                             
                     sr.ima01, sr.ima02, sr.ima021, sr.ima1915, sr.ima1916,                                                         
                     sr.bxe02, sr.bxe03, sr.bxe04,  sr.bxe05,   sr.bnf07,                                                           
                     sr1.bxj04,sr1.bxj05,sr1.bxj06, sr1.bxj11,  sr1.bxj17,                                                          
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.bxi02a, sr1.bxj01a,                                                         
                     sr1.num1, sr1.bxi02b, sr1.bxj01b, sr1.num2, sr1.bxj17a,                                                        
                     sr1.bxj11a, sr1.num3, sr1.bxj17b, sr1.bxj11b, sr1.num4,                                                        
                     sr1.bxj10,sr1.bxj21,                                                                                           
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,                                                                        
                     l_flag,                                                                                                        
                     sr_ima01.sum1, sr_ima01.sum2, sr_ima01.sum3,                                                                   
                     sr_ima01.sum4,
                     sr_ima1916.sum1, sr_ima1916.sum2, sr_ima1916.sum3,                                                             
                     sr_ima1916.sum4                                                                                                
                                                                                                                                    
               LET l_pre_ima01 = sr.ima01                                                                                           
               LET l_pre_ima1916 = sr.ima1916                                                                                       
            END IF                                                                                                                  
                                                                                                                                    
            LET l_flag = '2'                                                                                                        
            EXECUTE insert_prep USING                                                                                               
                     sr.ima01, sr.ima02, sr.ima021, sr.ima1915, sr.ima1916,                                                         
                     sr.bxe02, sr.bxe03, sr.bxe04,  sr.bxe05,   sr.bnf07,                                                           
                     sr1.bxj04,sr1.bxj05,sr1.bxj06, sr1.bxj11,  sr1.bxj17,                                                          
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.bxi02a, sr1.bxj01a,                                                         
                     sr1.num1, sr1.bxi02b, sr1.bxj01b, sr1.num2, sr1.bxj17a,                                                        
                     sr1.bxj11a, sr1.num3, sr1.bxj17b, sr1.bxj11b, sr1.num4,                                                        
                     sr1.bxj10,sr1.bxj21,                                                                                           
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,                                                                        
                     l_flag,                                                                                                        
                     sr_ima01.sum1, sr_ima01.sum2, sr_ima01.sum3,                                                                   
                     sr_ima01.sum4,                                                                                                 
                     sr_ima1916.sum1, sr_ima1916.sum2,sr_ima1916.sum3,
                     sr_ima1916.sum4                                                                                                
            #FUN-9B0004 By dxfwo  -----end---- 
         END IF
      ELSE
         #計算各料累計數量(並塞入temp)
         DELETE FROM abxr300_tmp
         DECLARE r300_bxj_cs CURSOR FOR
            SELECT '','',bxj04,bxj05,bxj06,bxj11,bxj17,bxj01,bxi02,bxi06,
                   '','',0,'','',0,'','',0,'','',0,bxj10,bxj21,bxr_file.*
              FROM bxi_file, bxj_file, OUTER bxr_file
             WHERE bxi01 = bxj01
               AND bxiconf = 'Y'
               AND bxi02 BETWEEN tm.bdate AND tm.edate
               AND bxj04 = sr.ima01
               AND bxj_file.bxj21 = bxr_file.bxr01
         FOREACH r300_bxj_cs INTO sr1.*,l_bxr.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH r300_bxj_cs:',SQLCA.sqlcode,1)
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
            INSERT INTO abxr300_tmp VALUES(sr1.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               LET g_errno = SQLCA.SQLCODE
               IF cl_null(SQLCA.SQLCODE) THEN LET g_errno ='9052' END IF
               CALL cl_err('Ins abxr300_tmp:',g_errno,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
               EXIT PROGRAM
            END IF
         END FOREACH
         LET g_sum1 = 0    LET g_sum2 = 0
         LET g_sum3 = 0    LET g_sum4 = 0
         SELECT SUM(num1),SUM(num2),SUM(num3),SUM(num4)
           INTO g_sum1,g_sum2,g_sum3,g_sum4
           FROM abxr300_tmp
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
         DECLARE r300_tmp_cs CURSOR FOR
            SELECT * FROM abxr300_tmp
         FOREACH r300_tmp_cs INTO sr1.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH r300_tmp_cs:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            FOR g_i = 1 TO 2
               CASE
                   WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima1916
                   OTHERWISE                LET l_order[g_i] = '-'
               END CASE
            END FOR
            LET sr1.order1 = l_order[1]
            LET sr1.order2 = l_order[2]
#FUN-9B0004 By dxfwo ---start---   
#           IF tm.b = '1' THEN  #1:料號格式
#              OUTPUT TO REPORT r300_rep1(sr.*,sr1.*,1)
#           ELSE                #2:保稅群組代碼格式
#              OUTPUT TO REPORT r300_rep2(sr.*,sr1.*,1)
#           END IF
            #多塞入一笔资料在cr上用来显示"上期结转数量"                                                                             
            IF (tm.b = '1' AND l_pre_ima01 != sr.ima01) OR                                                                          
               (tm.b = '2' AND l_pre_ima1916!= sr.ima1916) THEN                                                                     
              LET l_flag = '1'                                                                                                      
              #No.MOD-920386 BY shiwuying --start--                                                                                 
              IF (tm.b = '2' AND l_pre_ima1916!= sr.ima1916) THEN                                                                   
                 SELECT SUM(bnf07) INTO sr.bnf07 FROM bnf_file,ima_file                                                             
                  WHERE bnf01 = ima01                                                                                               
                    AND bnf03 = l_yy                                                                                                
                    AND bnf04 = l_mm                                                                                                
                    AND ima1916 = sr.ima1916                                                                                        
              END IF                                                                                                                
              #No.MOD-920386 BY shiwuyin --end--                                                                                    
              EXECUTE insert_prep USING                                                                                             
                     sr.ima01, sr.ima02, sr.ima021, sr.ima1915, sr.ima1916,                                                         
                     sr.bxe02, sr.bxe03, sr.bxe04,  sr.bxe05,   sr.bnf07,                                                           
                     sr1.bxj04,sr1.bxj05,sr1.bxj06, sr1.bxj11,  sr1.bxj17,                                                          
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.bxi02a, sr1.bxj01a,                                                         
                     sr1.num1, sr1.bxi02b, sr1.bxj01b, sr1.num2, sr1.bxj17a,                                                        
                     sr1.bxj11a, sr1.num3, sr1.bxj17b, sr1.bxj11b, sr1.num4,                                                        
                     sr1.bxj10,sr1.bxj21,
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,                                                                        
                     l_flag,                                                                                                        
                     sr_ima01.sum1, sr_ima01.sum2,sr_ima01.sum3,                                                                    
                     sr_ima01.sum4,                                                                                                 
                     sr_ima1916.sum1, sr_ima1916.sum2,sr_ima1916.sum3,                                                              
                     sr_ima1916.sum4                                                                                                
               LET l_pre_ima01 = sr.ima01                                                                                           
               LET l_pre_ima1916 = sr.ima1916                                                                                       
                                                                                                                                    
            END IF                                                                                                                  
            LET l_flag ='2'                                                                                                         
              #No.MOD-920386 BY shiwuying --start--                                                                                 
              IF (tm.b = '2') THEN                                                                                                  
                 SELECT SUM(bnf07) INTO sr.bnf07 FROM bnf_file,ima_file                                                             
                  WHERE bnf01 = ima01                                                                                               
                    AND bnf03 = l_yy                                                                                                
                    AND bnf04 = l_mm                                                                                                
                    AND ima1916 = sr.ima1916                                                                                        
              END IF                                                                                                                
              #0No.MOD-920386 BY shiwuying --end--                                                                                  
              EXECUTE insert_prep USING
                     sr.ima01, sr.ima02, sr.ima021, sr.ima1915, sr.ima1916,                                                         
                     sr.bxe02, sr.bxe03, sr.bxe04,  sr.bxe05,   sr.bnf07,                                                           
                     sr1.bxj04,sr1.bxj05,sr1.bxj06, sr1.bxj11,  sr1.bxj17,                                                          
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.bxi02a, sr1.bxj01a,                                                         
                     sr1.num1, sr1.bxi02b, sr1.bxj01b, sr1.num2, sr1.bxj17a,                                                        
                     sr1.bxj11a, sr1.num3, sr1.bxj17b, sr1.bxj11b, sr1.num4,                                                        
                     sr1.bxj10,sr1.bxj21,                                                                                           
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,                                                                        
                     l_flag,                                                                                                        
                     sr_ima01.sum1, sr_ima01.sum2,sr_ima01.sum3,                                                                    
                     sr_ima01.sum4,                                                                                                 
                     sr_ima1916.sum1, sr_ima1916.sum2,sr_ima1916.sum3,                                                              
                     sr_ima1916.sum4                                                                                                
            #FUN-9B0004 By dxfwo ----end----
         END FOREACH
      LET l_pre_ima01 = sr.ima01             #FUN-9B0004                                                                            
      LET l_pre_ima1916 = sr.ima1916         #FUN-9B0004
      END IF
   END FOREACH

   #FUN-9B0004 By dxfwo ---start---                                                                                         
   #把flag = '1'的(多塞的那一行)数量都update为0 避免报表的加总出错                                                                  
   LET l_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ,                                                                     
               "          SET num1 = 0,num2 = 0,num3 = 0,num4 = 0",                                                                 
               "   WHERE flag = '1' "                                                                                               
   PREPARE update_pre from l_sql                                                                                                    
   EXECUTE update_pre                                                                                                               
                                                                                                                                    
                                                                                                                                    
   ## **** 与 Crystal Reports 串联段 - <<<< CALL cs3() >>>> FUN-720005 **** ##                                                      
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
   #是否列印选择条件                                                                                                                
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(tm.wc,'zu01')                                                                                                   
           RETURNING tm.wc                                                                                                          
      LET g_str = tm.wc                                                                                                             
   END IF                                                                                                                           
   LET g_str = g_str ,";",                                                                                                          
               tm.bdate USING "yyyy/mm/dd",";",     #p2                                                                             
               tm.edate USING "yyyy/mm/dd",";",     #p3                                                                             
               tm.mdate USING "yyyy/mm/dd" ,";",    #p4
               tm.a,";",                            #p5                                                                             
               tm.d,";",                            #p6                                                                             
               tm.g,";",                            #p7                                                                             
               tm.s[1,1],";",                       #p8                                                                             
               tm.s[2,2],";",                       #p9                                                                             
               tm.u[1,1],";",                       #p10                                                                            
               tm.u[2,2],";",                       #p11                                                                            
               tm.t[1,1],";",                       #p12                                                                            
               tm.t[2,2],";"                        #p13                                                                            
   IF tm.b = '1' THEN  #1:料号格式                                                                                                  
      CALL cl_prt_cs3('abxr300','abxr300',l_sql,g_str)                                                                              
   ELSE                #2:保税群组代码格式                                                                                          
      CALL cl_prt_cs3('abxr300','abxr300_1',l_sql,g_str)                                                                            
   END IF

#  IF tm.b = '1' THEN  #1:料號格式
#     FINISH REPORT r300_rep1
#  ELSE                #2:保稅群組代碼格式
#     FINISH REPORT r300_rep2
#  END IF
#
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #FUN-9B0004 By dxfwo ---end--- 

   #No.FUN-B80082--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----
END FUNCTION
 
#==================================================================
#1:料號格式
#==================================================================
#FUN-9B0004 mark start 
# REPORT r300_rep1(sr,sr1,p_cnt)
#  DEFINE l_last_sw LIKE type_file.chr1,
#         l_bnf07   LIKE bnf_file.bnf07,
#         p_cnt     LIKE type_file.num5,
#         sr        RECORD
#                      ima01      LIKE ima_file.ima01,
#                      ima02      LIKE ima_file.ima02,
#                      ima021     LIKE ima_file.ima021,
#                      ima1915    LIKE ima_file.ima1915,
#                      ima1916    LIKE ima_file.ima1916,
#                      bxe02      LIKE bxe_file.bxe02,
#                      bxe03      LIKE bxe_file.bxe03,
#                      bxe04      LIKE bxe_file.bxe04,
#                      bxe05      LIKE bxe_file.bxe05,
#                      bnf07      LIKE bnf_file.bnf07
#                   END RECORD,
#         sr1       RECORD
#                      order1     LIKE bxj_file.bxj04,
#                      order2     LIKE bxj_file.bxj04,
#                      bxj04      LIKE bxj_file.bxj04,
#                      bxj05      LIKE bxj_file.bxj05,
#                      bxj06      LIKE bxj_file.bxj06,
#                      bxj11      LIKE bxj_file.bxj11,
#                      bxj17      LIKE bxj_file.bxj17,
#                      bxj01      LIKE bxj_file.bxj01,
#                      bxi02      LIKE bxi_file.bxi02,
#                      bxi06      LIKE bxi_file.bxi06,
#                      bxi02a     LIKE bxi_file.bxi02, #存倉日期
#                      bxj01a     LIKE bxj_file.bxj01, #存倉單據號碼
#                      num1       LIKE bxj_file.bxj06, #存倉數量
#                      bxi02b     LIKE bxi_file.bxi02, #出倉日期
#                      bxj01b     LIKE bxj_file.bxj01, #出倉單據號碼
#                      num2       LIKE bxj_file.bxj06, #出倉數量
#                      bxj17a     LIKE bxj_file.bxj17, #外銷出廠日期
#                      bxj11a     LIKE bxj_file.bxj11, #外銷出口報單號碼
#                      num3       LIKE bxj_file.bxj06, #出口數量
#                      bxj17b     LIKE bxj_file.bxj17, #內銷補稅日期
#                      bxj11b     LIKE bxj_file.bxj11, #補稅報單號碼
#                      num4       LIKE bxj_file.bxj06, #內銷數量
#                      bxj10      LIKE bxj_file.bxj10,
#                      bxj21      LIKE bxj_file.bxj21
#                   END RECORD
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.ima01,sr1.order1,sr1.order2
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN 01, g_x[1] CLIPPED, g_bxz.bxz101
#     PRINT ''
#     LET g_msg = g_bxz.bxz100 CLIPPED," ",
#                 g_company CLIPPED," ",
#                 g_bxz.bxz102 CLIPPED
#     PRINT COLUMN (g_len-FGL_WIDTH(g_msg))/2 ,g_msg CLIPPED,
#           COLUMN 183, g_x[3] CLIPPED, g_bxz.bxz101 CLIPPED
#     PRINT COLUMN (g_len-FGL_WIDTH(g_x[2] CLIPPED))/2 ,g_x[2] CLIPPED
#     PRINT ''
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN  01, g_x[4] CLIPPED, tm.mdate USING 'yyyy/mm/dd',
#           COLUMN  71, g_x[5] CLIPPED, tm.bdate USING 'yyyy/mm/dd', " - ",
#                                       tm.edate USING 'yyyy/mm/dd',
#           COLUMN 215, g_x[6] CLIPPED, g_pageno USING '<<<<'
#     PRINT COLUMN  01, g_x[7] CLIPPED, sr.ima02 CLIPPED,
#           COLUMN  71, g_x[8] CLIPPED, sr.ima01 CLIPPED,
#           COLUMN 117, g_x[9] CLIPPED, sr.ima021 CLIPPED,
#           COLUMN 183, g_x[10] CLIPPED, sr1.bxj05 CLIPPED,
#           COLUMN 194, g_x[11] CLIPPED, sr.ima1915 CLIPPED
#     PRINT COLUMN 01, g_x[12] CLIPPED
#     PRINT COLUMN 01, g_x[13] CLIPPED
#     PRINT COLUMN 01, g_x[14] CLIPPED
#     PRINT COLUMN 01, g_x[15] CLIPPED
#     PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#                    g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#                    g_x[51],g_x[52],g_x[53],g_x[54],g_x[55]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.ima01
#     LET g_i = 0
#     LET l_bnf07 = sr.bnf07
#     SKIP TO TOP OF PAGE
#
#  BEFORE GROUP OF sr1.order1
#     IF tm.t[1,1] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
#
#  BEFORE GROUP OF sr1.order2
#     IF tm.t[2,2] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
#
#  ON EVERY ROW
#     IF g_i = 0 THEN
#        PRINTX name=D1
#               COLUMN g_c[41], '',
#               COLUMN g_c[42], '',
#               COLUMN g_c[43], '',
#               COLUMN g_c[44], '',
#               COLUMN g_c[45], '',
#               COLUMN g_c[46], g_x[17] CLIPPED,
#               COLUMN g_c[47], sr.bnf07 USING '-------&.&&&',
#               COLUMN g_c[48], '',
#               COLUMN g_c[49], '',
#               COLUMN g_c[50], '',
#               COLUMN g_c[51], '',
#               COLUMN g_c[52], '',
#               COLUMN g_c[53], '',
#               COLUMN g_c[54], '',
#               COLUMN g_c[55], ''
#     END IF
#     LET g_i = g_i + 1
#     IF p_cnt = 1 AND tm.g = 'Y' THEN
#        #帳面庫存數量
#        CASE sr1.bxi06
#             WHEN '1'  LET l_bnf07 = l_bnf07 + sr1.bxj06
#             WHEN '2'  LET l_bnf07 = l_bnf07 - sr1.bxj06
#        END CASE
#        PRINTX name=D1
#               COLUMN g_c[41], sr1.bxi02a USING 'yy/mm/dd',
#               COLUMN g_c[42], sr1.bxj01a;
#        IF sr1.num1 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[43], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[43], sr1.num1 USING '-------&.&&&';
#        END IF
#        PRINTX name=D1
#               COLUMN g_c[44], sr1.bxi02b USING 'yyyymmdd',
#               COLUMN g_c[45], sr1.bxj01b;
#        IF sr1.num2 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[46], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[46], sr1.num2 USING '-------&.&&&';
#        END IF
#        IF l_bnf07 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[47], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[47], l_bnf07  USING '-------&.&&&';
#        END IF
#        PRINTX name=D1
#               COLUMN g_c[48], sr1.bxj17a USING 'yyyymmdd',
#               COLUMN g_c[49], sr1.bxj11a,
#               COLUMN g_c[50], '';
#        IF sr1.num3 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[51], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[51], sr1.num3 USING '-------&.&&&';
#        END IF
#        PRINTX name=D1
#        #No.MOD-840234  --BEGIN
#               #COLUMN g_c[52], sr1.bxj17a USING 'yyyymmdd',
#               #COLUMN g_c[53], sr1.bxj11a;
#               COLUMN g_c[52], '',
#               COLUMN g_c[53], '';
#        #No.MOD-840234  --END
#        IF sr1.num4 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[54], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[54], sr1.num4 USING '-------&.&&&';
#        END IF
#        PRINTX name=D1  COLUMN g_c[55], sr1.bxj10
#     END IF
#
#  AFTER GROUP OF sr.ima01
#     #列印「料號本期累計數量] 
#     PRINT COLUMN 01,g_x[12] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[41], '',
#            COLUMN g_c[42], g_x[19] CLIPPED;
#     IF GROUP SUM(sr1.num1) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[43], GROUP SUM(sr1.num1) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[43], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[44], '',
#            COLUMN g_c[45], '';
#     IF GROUP SUM(sr1.num2) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[46], GROUP SUM(sr1.num2) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[46], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[47], '',
#            COLUMN g_c[48], '',
#            COLUMN g_c[49], '',
#            COLUMN g_c[50], '';
#     IF GROUP SUM(sr1.num3) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[51], GROUP SUM(sr1.num3) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[51], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[52], '',
#            COLUMN g_c[53], '';
#     IF GROUP SUM(sr1.num4) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[54], GROUP SUM(sr1.num4) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[54], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[55], ''
#     #列印「料號當年累計數量」
#     LET g_sum1 = 0   LET g_sum2 = 0
#     LET g_sum3 = 0   LET g_sum4 = 0
#     SELECT SUM(bnf05),SUM(bnf06),SUM(bnf28),SUM(bnf10)
#       INTO g_sum1,g_sum2,g_sum3,g_sum4
#       FROM bnf_file
#      WHERE bnf01 = sr.ima01
#        AND bnf03*12+bnf04 BETWEEN g_sm AND g_em
#     PRINT COLUMN 01,g_x[12] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[41], '',
#            COLUMN g_c[42], g_x[20] CLIPPED;
#     IF g_sum1 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[43], g_sum1 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[43], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[44], '',
#            COLUMN g_c[45], '';
#     IF g_sum2 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[46], g_sum2 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[46], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[47], '',
#            COLUMN g_c[48], '',
#            COLUMN g_c[49], '',
#            COLUMN g_c[50], '';
#     IF g_sum3 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[51], g_sum3 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[51], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[52], '',
#            COLUMN g_c[53], '';
#     IF g_sum4 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[54], g_sum4 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[54], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[55], ''
#
#  AFTER GROUP OF sr1.order1
#     #列印「小計累計數量」
#     IF tm.u[1,1] = 'Y' THEN
#        PRINT COLUMN 01,g_x[12] CLIPPED
#        CASE tm.s[1,1]
#             WHEN '1'  #料號
#                     PRINTX name=S1  COLUMN g_c[41], sr.ima01 CLIPPED;
#             WHEN '2'  #保稅群組代碼
#                     PRINTX name=S1  COLUMN g_c[41], sr.ima1916 CLIPPED;
#             OTHERWISE
#                     PRINTX name=S1  COLUMN g_c[41], '';
#        END CASE
#        PRINTX name=S1
#               COLUMN g_c[42], g_x[18] CLIPPED;
#        IF GROUP SUM(sr1.num1) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[43], GROUP SUM(sr1.num1) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[43], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[44], '',
#               COLUMN g_c[45], '';
#        IF GROUP SUM(sr1.num2) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[46], GROUP SUM(sr1.num2) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[46], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[47], '',
#               COLUMN g_c[48], '',
#               COLUMN g_c[49], '',
#               COLUMN g_c[50], '';
#        IF GROUP SUM(sr1.num3) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[51], GROUP SUM(sr1.num3) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[51], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[52], '',
#               COLUMN g_c[53], '';
#        IF GROUP SUM(sr1.num4) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[54], GROUP SUM(sr1.num4) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[54], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[55], ''
#        IF tm.s[1,1] = '2' THEN
#           PRINTX name=S1  COLUMN g_c[41], sr.bxe02 CLIPPED
#           PRINTX name=S1  COLUMN g_c[41], sr.bxe03 CLIPPED
#        END IF
#     END IF
#
#  AFTER GROUP OF sr1.order2
#     #列印「小計累計數量」
#     IF tm.u[2,2] = 'Y' THEN
#        PRINT COLUMN 01,g_x[12] CLIPPED
#        CASE tm.s[2,2]
#             WHEN '1'  #料號
#                     PRINTX name=S1  COLUMN g_c[41], sr.ima01 CLIPPED;
#             WHEN '2'  #保稅群組代碼
#                     PRINTX name=S1  COLUMN g_c[41], sr.ima1916 CLIPPED;
#             OTHERWISE
#                     PRINTX name=S1  COLUMN g_c[41], '';
#        END CASE
#        PRINTX name=S1
#               COLUMN g_c[42], g_x[18] CLIPPED;
#        IF GROUP SUM(sr1.num1) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[43], GROUP SUM(sr1.num1) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[43], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[44], '',
#               COLUMN g_c[45], '';
#        IF GROUP SUM(sr1.num2) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[46], GROUP SUM(sr1.num2) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[46], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[47], '',
#               COLUMN g_c[48], '',
#               COLUMN g_c[49], '',
#               COLUMN g_c[50], '';
#        IF GROUP SUM(sr1.num3) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[51], GROUP SUM(sr1.num3) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[51], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[52], '',
#               COLUMN g_c[53], '';
#        IF GROUP SUM(sr1.num4) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[54], GROUP SUM(sr1.num4) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[54], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[55], ''
#        IF tm.s[2,2] = '2' THEN
#           PRINTX name=S1  COLUMN g_c[41], sr.bxe02 CLIPPED
#           PRINTX name=S1  COLUMN g_c[41], sr.bxe03 CLIPPED
#        END IF
#     END IF
#
#  ON LAST ROW
#     LET l_last_sw = 'y'
#
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT COLUMN  01, g_x[12] CLIPPED
#        PRINT COLUMN  01, g_x[23] CLIPPED,
#              COLUMN 218, g_x[25] CLIPPED
#     ELSE
#        PRINT COLUMN  01, g_x[12] CLIPPED
#        PRINT COLUMN  01, g_x[23] CLIPPED,
#              COLUMN 218, g_x[24] CLIPPED
#     END IF
# END REPORT
 
#==================================================================
#2:保稅群組代碼格式
#==================================================================
# REPORT r300_rep2(ssr,ssr1,p_cnt1)
#  DEFINE l_last_sw1  LIKE type_file.chr1,
#         l_bnf071    LIKE bnf_file.bnf07,
#         p_cnt1      LIKE type_file.num5,
#         l_yy1,l_mm1 LIKE type_file.num5,
#         ssr         RECORD
#                      ima01      LIKE ima_file.ima01,
#                      ima02      LIKE ima_file.ima02,
#                      ima021     LIKE ima_file.ima021,
#                      ima1915    LIKE ima_file.ima1915,
#                      ima1916    LIKE ima_file.ima1916,
#                      bxe02      LIKE bxe_file.bxe02,
#                      bxe03      LIKE bxe_file.bxe03,
#                      bxe04      LIKE bxe_file.bxe04,
#                      bxe05      LIKE bxe_file.bxe05,
#                      bnf07      LIKE bnf_file.bnf07
#                     END RECORD,
#         ssr1        RECORD
#                      order1     LIKE bxj_file.bxj04,
#                      order2     LIKE bxj_file.bxj04,
#                      bxj04      LIKE bxj_file.bxj04,
#                      bxj05      LIKE bxj_file.bxj05,
#                      bxj06      LIKE bxj_file.bxj06,
#                      bxj11      LIKE bxj_file.bxj11,
#                      bxj17      LIKE bxj_file.bxj17,
#                      bxj01      LIKE bxj_file.bxj01,
#                      bxi02      LIKE bxi_file.bxi02,
#                      bxi06      LIKE bxi_file.bxi06,
#                      bxi02a     LIKE bxi_file.bxi02, #存倉日期
#                      bxj01a     LIKE bxj_file.bxj01, #存倉單據號碼
#                      num1       LIKE bxj_file.bxj06, #存倉數量
#                      bxi02b     LIKE bxi_file.bxi02, #出倉日期
#                      bxj01b     LIKE bxj_file.bxj01, #出倉單據號碼
#                      num2       LIKE bxj_file.bxj06, #出倉數量
#                      bxj17a     LIKE bxj_file.bxj17, #外銷出廠日期
#                      bxj11a     LIKE bxj_file.bxj11, #外銷出口報單號碼
#                      num3       LIKE bxj_file.bxj06, #出口數量
#                      bxj17b     LIKE bxj_file.bxj17, #內銷補稅日期
#                      bxj11b     LIKE bxj_file.bxj11, #補稅報單號碼
#                      num4       LIKE bxj_file.bxj06, #內銷數量
#                      bxj10      LIKE bxj_file.bxj10,
#                      bxj21      LIKE bxj_file.bxj21
#                     END RECORD
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY ssr.ima1916,ssr.ima01,ssr1.order1,ssr1.order2
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN 01, g_x[1] CLIPPED, g_bxz.bxz101
#     PRINT ''
#     LET g_msg = g_bxz.bxz100 CLIPPED," ",
#                 g_company CLIPPED," ",
#                 g_bxz.bxz102 CLIPPED
#     PRINT COLUMN (g_len-FGL_WIDTH(g_msg))/2 ,g_msg CLIPPED,
#           COLUMN 183, g_x[3] CLIPPED, g_bxz.bxz101 CLIPPED
#     PRINT COLUMN (g_len-FGL_WIDTH(g_x[2] CLIPPED))/2 ,g_x[2] CLIPPED
#     PRINT ''
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN  01, g_x[4] CLIPPED, tm.mdate USING 'yyyy/mm/dd',
#           COLUMN  71, g_x[5] CLIPPED, tm.bdate USING 'yyyy/mm/dd', " - ",
#                                       tm.edate USING 'yyyy/mm/dd',
#           COLUMN 215, g_x[6] CLIPPED, g_pageno USING '<<<<'
#     PRINT COLUMN  01, g_x[7] CLIPPED, ssr.bxe02 CLIPPED,
#           COLUMN  71, g_x[8] CLIPPED, ssr.ima1916 CLIPPED,
#           COLUMN 117, g_x[9] CLIPPED, ssr.bxe03 CLIPPED,
#           COLUMN 183, g_x[10] CLIPPED, ssr.bxe04 CLIPPED,
#           COLUMN 194, g_x[11] CLIPPED, ssr.bxe05 CLIPPED
#     PRINT COLUMN  01, g_x[12] CLIPPED
#     PRINT COLUMN  01, g_x[13] CLIPPED
#     PRINT COLUMN  01, g_x[14] CLIPPED
#     PRINT COLUMN  01, g_x[15] CLIPPED
#     PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
#                    g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#                    g_x[51],g_x[52],g_x[53],g_x[54],g_x[55] CLIPPED
#     PRINT g_dash1
#     LET l_last_sw1 = 'n'
#
#  BEFORE GROUP OF ssr.ima1916
#     LET g_i = 0
#     LET l_yy1 = YEAR(tm.bdate)
#     LET l_mm1 = MONTH(tm.bdate)
#     IF l_mm1 = 1 THEN
#        LET l_yy1 = l_yy1 - 1
#        LET l_mm1 = 12
#     ELSE
#        LET l_mm1 = l_mm1 - 1
#     END IF
#     LET l_bnf071 = 0
#     SELECT SUM(bnf07) INTO l_bnf071
#       FROM bnf_file, ima_file
#      WHERE bnf01 = ima01
#        AND ima1916 = ssr.ima1916
#        AND bnf03 = l_yy1
#        AND bnf04 = l_mm1
#     IF l_bnf071 IS NULL THEN LET l_bnf071 = 0 END IF
#     SKIP TO TOP OF PAGE
#
#  BEFORE GROUP OF ssr1.order1
#     IF tm.t[1,1] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
#
#  BEFORE GROUP OF ssr1.order2
#     IF tm.t[2,2] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
#
#  ON EVERY ROW
#     IF g_i = 0 THEN
#        PRINTX name=D1
#               COLUMN g_c[41], '',
#               COLUMN g_c[42], '',
#               COLUMN g_c[43], '',
#               COLUMN g_c[44], '',
#               COLUMN g_c[45], '',
#               COLUMN g_c[46], g_x[17] CLIPPED,
#               COLUMN g_c[47], l_bnf071 USING '-------&.&&&',
#               COLUMN g_c[48], '',
#               COLUMN g_c[49], '',
#               COLUMN g_c[50], '',
#               COLUMN g_c[51], '',
#               COLUMN g_c[52], '',
#               COLUMN g_c[53], '',
#               COLUMN g_c[54], '',
#               COLUMN g_c[55], ''
#     END IF
#     LET g_i = g_i + 1
#     IF p_cnt1 = 1 AND tm.g = 'Y' THEN
#        #帳面庫存數量
#        CASE ssr1.bxi06
#             WHEN '1'  LET l_bnf071 = l_bnf071 + ssr1.bxj06
#             WHEN '2'  LET l_bnf071 = l_bnf071 - ssr1.bxj06
#        END CASE
#        PRINTX name=D1
#               COLUMN g_c[41], ssr1.bxi02a USING 'yy/mm/dd',
#               COLUMN g_c[42], ssr1.bxj01a;
#        IF ssr1.num1 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[43], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[43], ssr1.num1 USING '-------&.&&&';
#        END IF
#        PRINTX name=D1
#               COLUMN g_c[44], ssr1.bxi02b USING 'yyyymmdd',
#               COLUMN g_c[45], ssr1.bxj01b;
#        IF ssr1.num2 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[46], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[46], ssr1.num2 USING '-------&.&&&';
#        END IF
#        IF l_bnf071 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[47], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[47], l_bnf071  USING '-------&.&&&';
#        END IF
#        PRINTX name=D1
#               COLUMN g_c[48], ssr1.bxj17a USING 'yyyymmdd',
#               COLUMN g_c[49], ssr1.bxj11a,
#               COLUMN g_c[50], '';
#        IF ssr1.num3 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[51], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[51], ssr1.num3 USING '-------&.&&&';
#        END IF
#        PRINTX name=D1
#        #No.MOD-840234  --begin
#               #COLUMN g_c[52], ssr1.bxj17a USING 'yyyymmdd',
#               #COLUMN g_c[53], ssr1.bxj11a;
#               COLUMN g_c[52], '',
#               COLUMN g_c[53], '';
#        #No.MOD-840234  --end
#        IF ssr1.num4 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[54], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[54], ssr1.num4 USING '-------&.&&&';
#        END IF
#        PRINTX name=D1  COLUMN g_c[55], ssr1.bxj10
#     END IF
#
#  AFTER GROUP OF ssr.ima1916
#     #列印「群組本期累計數量] 
#     PRINT COLUMN 01,g_x[12] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[41], '',
#            COLUMN g_c[42], g_x[21] CLIPPED;
#     IF GROUP SUM(ssr1.num1) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[43], GROUP SUM(ssr1.num1) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[43], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[44], '',
#            COLUMN g_c[45], '';
#     IF GROUP SUM(ssr1.num2) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[46], GROUP SUM(ssr1.num2) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[46], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[47], '',
#            COLUMN g_c[48], '',
#            COLUMN g_c[49], '',
#            COLUMN g_c[50], '';
#     IF GROUP SUM(ssr1.num3) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[51], GROUP SUM(ssr1.num3) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[51], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[52], '',
#            COLUMN g_c[53], '';
#     IF GROUP SUM(ssr1.num4) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[54], GROUP SUM(ssr1.num4) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[54], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[55], ''
#     #列印「群組當年累計數量」
#     LET g_sum1 = 0   LET g_sum2 = 0
#     LET g_sum3 = 0   LET g_sum4 = 0
#     SELECT SUM(bnf05),SUM(bnf06),SUM(bnf28),SUM(bnf10)
#       INTO g_sum1,g_sum2,g_sum3,g_sum4
#       FROM bnf_file, ima_file
#      WHERE bnf01 = ima01
#        AND ima1916 = ssr.ima1916
#        AND bnf03*12+bnf04 BETWEEN g_sm AND g_em
#     PRINT COLUMN 01,g_x[12] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[41], '',
#            COLUMN g_c[42], g_x[22] CLIPPED;
#     IF g_sum1 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[43], g_sum1 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[43], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[44], '',
#            COLUMN g_c[45], '';
#     IF g_sum2 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[46], g_sum2 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[46], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[47], '',
#            COLUMN g_c[48], '',
#            COLUMN g_c[49], '',
#            COLUMN g_c[50], '';
#     IF g_sum3 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[51], g_sum3 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[51], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[52], '',
#            COLUMN g_c[53], '';
#     IF g_sum4 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[54], g_sum4 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[54], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[55], ''
#
#  AFTER GROUP OF ssr.ima01
#     #列印「料號當年累計數量」
#     LET g_sum1 = 0   LET g_sum2 = 0
#     LET g_sum3 = 0   LET g_sum4 = 0
#     SELECT SUM(bnf05),SUM(bnf06),SUM(bnf28),SUM(bnf10)
#       INTO g_sum1,g_sum2,g_sum3,g_sum4
#       FROM bnf_file
#      WHERE bnf01 = ssr.ima01
#        AND bnf03*12+bnf04 BETWEEN g_sm AND g_em
#     PRINT COLUMN 01,g_x[12] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[41], '',
#            COLUMN g_c[42], g_x[20] CLIPPED;
#     IF g_sum1 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[43], g_sum1 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[43], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[44], '',
#            COLUMN g_c[45], '';
#     IF g_sum2 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[46], g_sum2 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[46], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[47], '',
#            COLUMN g_c[48], '',
#            COLUMN g_c[49], '',
#            COLUMN g_c[50], '';
#     IF g_sum3 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[51], g_sum3 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[51], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[52], '',
#            COLUMN g_c[53], '';
#     IF g_sum4 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[54], g_sum4 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[54], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[55], ''
#
#  AFTER GROUP OF ssr1.order1
#     #列印「小計累計數量」
#     IF tm.u[1,1] = 'Y' THEN
#        PRINT COLUMN 01,g_x[12] CLIPPED
#        CASE tm.s[1,1]
#             WHEN '1'  #料號
#                     PRINTX name=S1  COLUMN g_c[41], ssr.ima01 CLIPPED;
#             WHEN '2'  #保稅群組代碼
#                     PRINTX name=S1  COLUMN g_c[41], ssr.ima1916 CLIPPED;
#             OTHERWISE
#                     PRINTX name=S1  COLUMN g_c[41], '';
#        END CASE
#        PRINTX name=S1
#               COLUMN g_c[42], g_x[18] CLIPPED;
#        IF GROUP SUM(ssr1.num1) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[43], GROUP SUM(ssr1.num1) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[43], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[44], '',
#               COLUMN g_c[45], '';
#        IF GROUP SUM(ssr1.num2) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[46], GROUP SUM(ssr1.num2) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[46], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[47], '',
#               COLUMN g_c[48], '',
#               COLUMN g_c[49], '',
#               COLUMN g_c[50], '';
#        IF GROUP SUM(ssr1.num3) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[51], GROUP SUM(ssr1.num3) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[51], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[52], '',
#               COLUMN g_c[53], '';
#        IF GROUP SUM(ssr1.num4) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[54], GROUP SUM(ssr1.num4) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[54], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[55], ''
#        IF tm.s[1,1] = '2' THEN
#           PRINTX name=S1  COLUMN g_c[41], ssr.bxe02 CLIPPED
#           PRINTX name=S1  COLUMN g_c[41], ssr.bxe03 CLIPPED
#        END IF
#     END IF
#
#  AFTER GROUP OF ssr1.order2
#     #列印「小計累計數量」
#     IF tm.u[2,2] = 'Y' THEN
#        PRINT COLUMN 01,g_x[12] CLIPPED
#        CASE tm.s[2,2]
#             WHEN '1'  #料號
#                     PRINTX name=S1  COLUMN g_c[41], ssr.ima01 CLIPPED;
#             WHEN '2'  #保稅群組代碼
#                     PRINTX name=S1  COLUMN g_c[41], ssr.ima1916 CLIPPED;
#             OTHERWISE
#                     PRINTX name=S1  COLUMN g_c[41], '';
#        END CASE
#        PRINTX name=S1
#               COLUMN g_c[42], g_x[18] CLIPPED;
#        IF GROUP SUM(ssr1.num1) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[43], GROUP SUM(ssr1.num1) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[43], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[44], '',
#               COLUMN g_c[45], '';
#        IF GROUP SUM(ssr1.num2) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[46], GROUP SUM(ssr1.num2) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[46], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[47], '',
#               COLUMN g_c[48], '',
#               COLUMN g_c[49], '',
#               COLUMN g_c[50], '';
#        IF GROUP SUM(ssr1.num3) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[51], GROUP SUM(ssr1.num3) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[51], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[52], '',
#               COLUMN g_c[53], '';
#        IF GROUP SUM(ssr1.num4) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[54], GROUP SUM(ssr1.num4) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[54], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[55], ''
#        IF tm.s[2,2] = '2' THEN
#           PRINTX name=S1  COLUMN g_c[41], ssr.bxe02 CLIPPED
#           PRINTX name=S1  COLUMN g_c[41], ssr.bxe03 CLIPPED
#        END IF
#     END IF
#
#  ON LAST ROW
#     LET l_last_sw1 = 'y'
#
#  PAGE TRAILER
#     IF l_last_sw1 = 'n' THEN
#        PRINT COLUMN  01, g_x[12] CLIPPED
#        PRINT COLUMN  01, g_x[23] CLIPPED,
#              COLUMN 218, g_x[25] CLIPPED
#     ELSE
#        PRINT COLUMN  01, g_x[12] CLIPPED
#        PRINT COLUMN  01, g_x[23] CLIPPED,
#              COLUMN 218, g_x[24] CLIPPED
#     END IF
# END REPORT
#FUN-9B0004 mark end 
