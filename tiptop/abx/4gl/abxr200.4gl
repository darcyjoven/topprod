# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abxr200.4gl
# Descriptions...: 原料帳列印作業
# Date & Author..: 2006/10/24 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.MOD-840237 08/04/24 BY Sunyanchun 重新過單
# Modify.........: No.FUN-850089 08/05/28 By TSD.zeak 報表改寫由CR產出
# Modify.........: No.FUN-890101 08/09/25 By Cockroach 21-->31 CR 
# Modify.........: No.MOD-920386 09/03/11 By shiwuying 若列印格式選擇「2：保稅群組代碼格式」，則上期結轉數量應SUM同群組的bnf07
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30014 10/03/29 By Summer 保稅進口數(bxr11)或視同進口數(bxr12)只要其一不為0,報表中保稅進口數需顯示數量
# Modify.........: No:MOD-A70135 10/07/19 By Sarah 連續執行報表,資料年月的顯示會異常
# Modify.........: No:MOD-AA0033 10/10/08 By sabrina 若列印格式是1.料號格式時，單位應該抓bxj05，當bxj05抓不到資料時，再抓ima25
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
                    c       LIKE type_file.chr1,  #列印對象
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
DEFINE g_sum1      LIKE bxj_file.bxj06, #保稅進口數量
       g_sum2      LIKE bxj_file.bxj06, #非保稅進口數量
       g_sum3      LIKE bxj_file.bxj06, #廠內生產領用
       g_sum4      LIKE bxj_file.bxj06, #廠外加工領用
       g_sum5      LIKE bxj_file.bxj06, #外運
       g_sum6      LIKE bxj_file.bxj06, #其他
       g_sum7      LIKE bxj_file.bxj06, #退料數量
       g_sum8      LIKE bxj_file.bxj06, #帳面庫存數量
       g_sum9      LIKE bxj_file.bxj06, #出口數量
       g_sum10     LIKE bxj_file.bxj06  #報廢數量
DEFINE g_sm,g_em   LIKE type_file.num10
#FUN-850089 By TSD.zeak  ---start---  
DEFINE l_table        STRING                   
DEFINE g_str          STRING  
DEFINE g_sql          STRING                 
#FUN-850089 By TSD.zeak  ----end----  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #FUN-850089 By TSD.zeak  ---start---  
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
               "num1.bxj_file.bxj06,",   #保稅進口數量
               "num2.bxj_file.bxj06,",   #非保稅進口數量
               "num3.bxj_file.bxj06,",   #廠內生產領用
               "num4.bxj_file.bxj06,",   #廠外加工領用
               "num5.bxj_file.bxj06,",   #外運
               "num6.bxj_file.bxj06,",   #其他
               "num7.bxj_file.bxj06,",   #退料數量
               "num8.bxj_file.bxj06,",   #帳面庫存數量
               "num9.bxj_file.bxj06,",   #出口數量
               "num10.bxj_file.bxj06,",  #報廢數量
               "bxj11a.bxj_file.bxj11,", #內外銷報單號碼
               "bxj17a.bxj_file.bxj17,", #內外銷報單驗收日期
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
               "sum5_2.bnf_file.bnf23,",
               "sum6_2.bnf_file.bnf24,",
               "sum7_2.bnf_file.bnf25,",
               "sum8_2.bnf_file.bnf26,",
               "sum9_2.bnf_file.bnf27,",
               "sum1_3.bnf_file.bnf08,",
               "sum2_3.bnf_file.bnf09,",
               "sum3_3.bnf_file.bnf21,",
               "sum4_3.bnf_file.bnf22,",
               "sum5_3.bnf_file.bnf23,",
               "sum6_3.bnf_file.bnf24,",
               "sum7_3.bnf_file.bnf25,",
               "sum8_3.bnf_file.bnf26,",
               "sum9_3.bnf_file.bnf27"
                
 
   LET l_table = cl_prt_temptable('abxr200',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   #------------------------------ CR (1) ------------------------------#
   #FUN-850089 By TSD.zeak  ----end---- 
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   #MOD-840237
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
   LET tm.c     = ARG_VAL(13)
   LET tm.d     = ARG_VAL(14)
   LET tm.e     = ARG_VAL(15)
   LET tm.f     = ARG_VAL(16)
   LET tm.g     = ARG_VAL(17)
   LET tm.s     = ARG_VAL(18)
   LET tm.u     = ARG_VAL(19)
   LET tm.t     = ARG_VAL(20)
   LET tm.more  = ARG_VAL(21)
   LET g_rep_user = ARG_VAL(22)
   LET g_rep_clas = ARG_VAL(23)
   LET g_template = ARG_VAL(24)
 
   CALL r200_create()
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r200_tm(4,17)                    # Input print condition
   ELSE
      CALL r200()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
   DROP TABLE abxr200_tmp
END MAIN
 
FUNCTION r200_create()
   DROP TABLE abxr200_tmp
   CREATE TEMP TABLE abxr200_tmp(
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
     num1       LIKE bxj_file.bxj06,
     num2       LIKE bxj_file.bxj06,
     num3       LIKE bxj_file.bxj06,
     num4       LIKE bxj_file.bxj06,
     num5       LIKE bxj_file.bxj06,
     num6       LIKE bxj_file.bxj06,
     num7       LIKE bxj_file.bxj06,
     num8       LIKE bxj_file.bxj06,
     num9       LIKE bxj_file.bxj06,
     num10      LIKE bxj_file.bxj06,
     bxj11a     LIKE bxj_file.bxj11,
     bxj17a     LIKE bxj_file.bxj17,
     bxj10      LIKE bxj_file.bxj10,
     bxj21      LIKE bxj_file.bxj21)
   IF STATUS THEN
      CALL cl_err('create tmp',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
END FUNCTION
 
FUNCTION r200_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   OPEN WINDOW r200_w AT p_row,p_col
        WITH FORM "abx/42f/abxr200"
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
   LET tm.c     = '1'
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
         CLOSE WINDOW r200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.bdate,tm.edate,tm.mdate,tm.a,tm.b,tm.c,tm.d,
                      tm.e,tm.f,tm.g,
                      tm2.s1,tm2.s2,tm2.u1,tm2.u2,tm2.t1,tm2.t2,tm.more
      INPUT BY NAME tm.bdate,tm.edate,tm.mdate,tm.a,tm.b,tm.c,tm.d,
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
 
         AFTER FIELD c
            IF tm.c NOT MATCHES "[123]" THEN
               NEXT FIELD c
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
               CLOSE WINDOW r200_w
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
            IF tm.c NOT MATCHES "[123]" THEN
               NEXT FIELD c
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
         CLOSE WINDOW r200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='abxr200'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abxr200','9031',1)
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
                         " '",tm.c CLIPPED,"'",
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
            CALL cl_cmdat('abxr200',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r200()
      ERROR ""
   END WHILE
   CLOSE WINDOW r200_w
END FUNCTION
 
FUNCTION r200()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     STRING,            # RDSQL STATEMENT
          l_order   ARRAY[3] OF LIKE bxj_file.bxj04,
          l_cnt     LIKE type_file.num5,
          l_bxr     RECORD LIKE bxr_file.*,
          l_yy,l_mm LIKE type_file.num5,
          #FUN-850089 By TSD.zeak  ---start---  
          l_order1        LIKE bxj_file.bxj04,
          l_order2        LIKE bxj_file.bxj04,
          l_pre_ima01     LIKE ima_file.ima02,   
          l_pre_ima1916   LIKE ima_file.ima1916,
          l_flag          LIKE type_file.chr1,  
          sr_ima01    RECORD 
                       sum1     LIKE bnf_file.bnf08,
                       sum2     LIKE bnf_file.bnf09,
                       sum3     LIKE bnf_file.bnf21,
                       sum4     LIKE bnf_file.bnf22,
                       sum5     LIKE bnf_file.bnf23,
                       sum6     LIKE bnf_file.bnf24,
                       sum7     LIKE bnf_file.bnf25,
                       sum8     LIKE bnf_file.bnf26,
                       sum9     LIKE bnf_file.bnf27
                       END RECORD, 
          sr_ima1916    RECORD 
                       sum1     LIKE bnf_file.bnf08,
                       sum2     LIKE bnf_file.bnf09,
                       sum3     LIKE bnf_file.bnf21,
                       sum4     LIKE bnf_file.bnf22,
                       sum5     LIKE bnf_file.bnf23,
                       sum6     LIKE bnf_file.bnf24,
                       sum7     LIKE bnf_file.bnf25,
                       sum8     LIKE bnf_file.bnf26,
                       sum9     LIKE bnf_file.bnf27
                       END RECORD, 
          #FUN-850089 By TSD.zeak  ----end---- 
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
                       num1       LIKE bxj_file.bxj06, #保稅進口數量
                       num2       LIKE bxj_file.bxj06, #非保稅進口數量
                       num3       LIKE bxj_file.bxj06, #廠內生產領用
                       num4       LIKE bxj_file.bxj06, #廠外加工領用
                       num5       LIKE bxj_file.bxj06, #外運
                       num6       LIKE bxj_file.bxj06, #其他
                       num7       LIKE bxj_file.bxj06, #退料數量
                       num8       LIKE bxj_file.bxj06, #帳面庫存數量
                       num9       LIKE bxj_file.bxj06, #出口數量
                       num10      LIKE bxj_file.bxj06, #報廢數量
                       bxj11a     LIKE bxj_file.bxj11, #內外銷報單號碼
                       bxj17a     LIKE bxj_file.bxj17, #內外銷報單驗收日期
                       bxj10      LIKE bxj_file.bxj10,
                       bxj21      LIKE bxj_file.bxj21
                    END RECORD
 
   #No.FUN-B80082--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----

   #FUN-850089 By TSD.zeak  ---start---  
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ------------------------------#
   #FUN-850089 By TSD.zeak  ----end----  
 
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
               "   AND ", tm.wc CLIPPED
   IF tm.d = "Y" THEN 
      LET l_sql = l_sql CLIPPED, " AND ima15 = 'Y' "   #保稅
   END IF 
   CASE tm.c 
        WHEN '1'   #原料
                LET l_sql = l_sql CLIPPED, " AND ima106 = '1' "
        WHEN '2'   #物料
                LET l_sql = l_sql CLIPPED, " AND ima106 = '5' "
        WHEN '3'  #全部
                LET l_sql = l_sql CLIPPED, " AND (ima106='1' OR ima106='5') "
   END CASE
 
   #FUN-850089 By TSD.zeak  ---start--- 
   IF tm.b = '1' THEN LET l_sql = l_sql CLIPPED ," ORDER BY ima01" END IF 
   IF tm.b = '2' THEN LET l_sql = l_sql CLIPPED ," ORDER BY ima1916,ima01" END IF 
   #FUN-850089 By TSD.zeak  ----end----  
 
 
   PREPARE r200_pre_ima FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   DECLARE r200_ima_cs CURSOR FOR r200_pre_ima
 
#   CALL cl_outnam('abxr200') RETURNING l_name      #FUN-850089 
#FUN-850089 mark begin
#   IF tm.b = '1' THEN  #1:料號格式
#      START REPORT r200_rep1 TO l_name
#   ELSE                #2:保稅群組代碼格式
#      START REPORT r200_rep2 TO l_name
#   END IF
#FUN-850089 mark end
 
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
  
   LET l_pre_ima01   ='NULL'              #FUN-850089 By TSD.zeak  add
   LET l_pre_ima1916 ='NULL'              #FUN-850089 By TSD.zeak  add
 
   FOREACH r200_ima_cs INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH r200_ima_cs:',SQLCA.sqlcode,1)
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
 
      #FUN-850089 By TSD.zeak  ---start---  
      IF l_pre_ima01 != sr.ima01 THEN
         SELECT SUM(bnf08),SUM(bnf09),SUM(bnf21),SUM(bnf22),SUM(bnf23),
                SUM(bnf24),SUM(bnf25),SUM(bnf26),SUM(bnf27)
           INTO sr_ima01.sum1,sr_ima01.sum2,sr_ima01.sum3,sr_ima01.sum4,
                sr_ima01.sum5,sr_ima01.sum6,sr_ima01.sum7,sr_ima01.sum8,
                sr_ima01.sum9
           FROM bnf_file
          WHERE bnf01 = sr.ima01
            AND bnf03*12+bnf04 BETWEEN g_sm AND g_em
          
          IF cl_null(sr_ima01.sum1) THEN LET sr_ima01.sum1 = 0 END IF
          IF cl_null(sr_ima01.sum2) THEN LET sr_ima01.sum2 = 0 END IF
          IF cl_null(sr_ima01.sum3) THEN LET sr_ima01.sum3 = 0 END IF
          IF cl_null(sr_ima01.sum4) THEN LET sr_ima01.sum4 = 0 END IF
          IF cl_null(sr_ima01.sum5) THEN LET sr_ima01.sum5 = 0 END IF
          IF cl_null(sr_ima01.sum6) THEN LET sr_ima01.sum6 = 0 END IF
          IF cl_null(sr_ima01.sum7) THEN LET sr_ima01.sum7 = 0 END IF
          IF cl_null(sr_ima01.sum8) THEN LET sr_ima01.sum8 = 0 END IF
          IF cl_null(sr_ima01.sum9) THEN LET sr_ima01.sum9 = 0 END IF
      END IF
 
      IF cl_null(sr.ima1916) THEN LET sr.ima1916 =' ' END IF 
      IF l_pre_ima1916 != sr.ima1916 THEN
         SELECT SUM(bnf08),SUM(bnf09),SUM(bnf21),SUM(bnf22),SUM(bnf23),
                SUM(bnf24),SUM(bnf25),SUM(bnf26),SUM(bnf27)
           INTO sr_ima1916.sum1,sr_ima1916.sum2,sr_ima1916.sum3,sr_ima1916.sum4,
                sr_ima1916.sum5,sr_ima1916.sum6,sr_ima1916.sum7,sr_ima1916.sum8,
                sr_ima1916.sum9
           FROM bnf_file, ima_file
          WHERE bnf01 = ima01
            AND ima1916 = sr.ima1916
            AND bnf03*12+bnf04 BETWEEN g_sm AND g_em
          
          IF cl_null(sr_ima1916.sum1) THEN LET sr_ima1916.sum1 = 0 END IF
          IF cl_null(sr_ima1916.sum2) THEN LET sr_ima1916.sum2 = 0 END IF
          IF cl_null(sr_ima1916.sum3) THEN LET sr_ima1916.sum3 = 0 END IF
          IF cl_null(sr_ima1916.sum4) THEN LET sr_ima1916.sum4 = 0 END IF
          IF cl_null(sr_ima1916.sum5) THEN LET sr_ima1916.sum5 = 0 END IF
          IF cl_null(sr_ima1916.sum6) THEN LET sr_ima1916.sum6 = 0 END IF
          IF cl_null(sr_ima1916.sum7) THEN LET sr_ima1916.sum7 = 0 END IF
          IF cl_null(sr_ima1916.sum8) THEN LET sr_ima1916.sum8 = 0 END IF
          IF cl_null(sr_ima1916.sum9) THEN LET sr_ima1916.sum9 = 0 END IF
      END IF             
      #FUN-850089 By TSD.zeak  ----end---- 
 
 
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
#FUN-850089 By TSD.zeak  ---start---
#            IF tm.b = '1' THEN  #1:料號格式
#               OUTPUT TO REPORT r200_rep1(sr.*,sr1.*,0)
#            ELSE                #2:保稅群組代碼格式
#               OUTPUT TO REPORT r200_rep2(sr.*,sr1.*,0)
#            END IF
            #多塞入一筆資料在cr上用來顯示"上期結轉數量"
            IF (tm.b = '1' AND l_pre_ima01 != sr.ima01) OR
               (tm.b = '2' AND l_pre_ima1916!= sr.ima1916) THEN
              LET l_flag = '1'   
              SELECT ima25 INTO sr1.bxj05 FROM ima_file        #MOD-AA0033  add 
               WHERE ima01 = sr.ima01                          #MOD-AA0033  add  
 
              EXECUTE insert_prep USING
                     sr.ima01, sr.ima02, sr.ima021, sr.ima1915, sr.ima1916,
                     sr.bxe02, sr.bxe03, sr.bxe04,  sr.bxe05,   sr.bnf07,
                     sr1.bxj04,sr1.bxj05,sr1.bxj06, sr1.bxj11,  sr1.bxj17,
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.num1,   sr1.num2,
                     sr1.num3, sr1.num4, sr1.num5,  sr1.num6,   sr1.num7,
                     sr1.num8, sr1.num9, sr1.num10, sr1.bxj11a, sr1.bxj17a,
                     sr1.bxj10,sr1.bxj21,
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,
                     l_flag, 
                     sr_ima01.sum1, sr_ima01.sum2, sr_ima01.sum3,
                     sr_ima01.sum4, sr_ima01.sum5, sr_ima01.sum6,
                     sr_ima01.sum7, sr_ima01.sum8, sr_ima01.sum9,
                     sr_ima1916.sum1, sr_ima1916.sum2, sr_ima1916.sum3,
                     sr_ima1916.sum4, sr_ima1916.sum5, sr_ima1916.sum6,
                     sr_ima1916.sum7, sr_ima1916.sum8, sr_ima1916.sum9
       
                                        
               LET l_pre_ima01 = sr.ima01
               LET l_pre_ima1916 = sr.ima1916
            END IF
     
            LET l_flag = '2' 
            EXECUTE insert_prep USING
                     sr.ima01, sr.ima02, sr.ima021, sr.ima1915, sr.ima1916,
                     sr.bxe02, sr.bxe03, sr.bxe04,  sr.bxe05,   sr.bnf07,
                     sr1.bxj04,sr1.bxj05,sr1.bxj06, sr1.bxj11,  sr1.bxj17,
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.num1,   sr1.num2,
                     sr1.num3, sr1.num4, sr1.num5,  sr1.num6,   sr1.num7,
                     sr1.num8, sr1.num9, sr1.num10, sr1.bxj11a, sr1.bxj17a,
                     sr1.bxj10,sr1.bxj21,
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,
                     l_flag,
                     sr_ima01.sum1, sr_ima01.sum2, sr_ima01.sum3,
                     sr_ima01.sum4, sr_ima01.sum5, sr_ima01.sum6,
                     sr_ima01.sum7, sr_ima01.sum8, sr_ima01.sum9,
                     sr_ima1916.sum1, sr_ima1916.sum2,sr_ima1916.sum3,
                     sr_ima1916.sum4, sr_ima1916.sum5,sr_ima1916.sum6,
                     sr_ima1916.sum7, sr_ima1916.sum8, sr_ima1916.sum9
            #FUN-850089 By TSD.zeak  -----end----  
         END IF
      ELSE
         #計算各料累計數量(並塞入temp)
         DELETE FROM abxr200_tmp
         DECLARE r200_bxj_cs CURSOR FOR
            SELECT '','',bxj04,bxj05,bxj06,bxj11,bxj17,bxj01,bxi02,bxi06,
                   0,0,0,0,0,0,0,0,0,0,'','',bxj10,bxj21,bxr_file.*
              FROM bxi_file, bxj_file, OUTER bxr_file
             WHERE bxi01 = bxj01
               AND bxiconf = 'Y'
               AND bxi02 BETWEEN tm.bdate AND tm.edate
               AND bxj04 = sr.ima01
               AND bxj_file.bxj21 = bxr_file.bxr01
         FOREACH r200_bxj_cs INTO sr1.*,l_bxr.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH r200_bxj_cs:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            #保稅進口數量
            #str MOD-A30014 mod
            #保稅進口數(bxr11)或視同進口數(bxr12)只要其一不為0,
            #保稅進口數量就需顯示
            #LET sr1.num1 = l_bxr.bxr11 * sr1.bxj06
             IF l_bxr.bxr11 OR l_bxr.bxr12 THEN
                IF l_bxr.bxr11<>0 THEN
                   LET sr1.num1 = l_bxr.bxr11 * sr1.bxj06
                ELSE
                   LET sr1.num1 = l_bxr.bxr12 * sr1.bxj06
                END IF
             END IF
            #end MOD-A30014 mod
           #MOD-AA0033---add---start---
            IF cl_null(sr1.bxj05) THEN
               SELECT ima25 INTO sr1.bxj05 FROM ima_file
                WHERE ima01 = sr.ima01
            END IF
           #MOD-AA0033---add---end--- 
            IF sr1.num1 IS NULL THEN LET sr1.num1 = 0 END IF
            #非保稅進口數量
            LET sr1.num2 = l_bxr.bxr13 * sr1.bxj06
            IF sr1.num2 IS NULL THEN LET sr1.num2 = 0 END IF
            #廠內生產領用
            LET sr1.num3 = l_bxr.bxr21 * sr1.bxj06
            IF sr1.num3 IS NULL THEN LET sr1.num3 = 0 END IF
            #廠外加工領用
            LET sr1.num4 = l_bxr.bxr22 * sr1.bxj06
            IF sr1.num4 IS NULL THEN LET sr1.num4 = 0 END IF
            #外運
            IF l_bxr.bxr23 <> 0 OR l_bxr.bxr63 <> 0 THEN
               IF l_bxr.bxr23 <> 0 THEN
                  LET sr1.num5 = l_bxr.bxr23 * sr1.bxj06
               ELSE
                  LET sr1.num5 = l_bxr.bxr63 * sr1.bxj06
               END IF
            ELSE
               LET sr1.num5 = 0
            END IF
            IF sr1.num5 IS NULL THEN LET sr1.num5 = 0 END IF
            #其他
            IF l_bxr.bxr24 <> 0 THEN
               LET sr1.num6 = l_bxr.bxr24 * sr1.bxj06
            END IF
            IF sr1.num6 IS NULL THEN LET sr1.num6 = 0 END IF
            #退料數量
            LET sr1.num7 = l_bxr.bxr31 * sr1.bxj06
            IF sr1.num7 IS NULL THEN LET sr1.num7 = 0 END IF
            #出口數量
            IF l_bxr.bxr25 <> 0 OR l_bxr.bxr26 <> 0 THEN
               LET sr1.bxj11a = sr1.bxj11  #內外銷報單號碼
               LET sr1.bxj17a = sr1.bxj17  #內外銷報單驗收日期
               IF l_bxr.bxr25 <> 0 THEN
                  LET sr1.num9 = l_bxr.bxr25 * sr1.bxj06
               ELSE
                  LET sr1.num9 = l_bxr.bxr26 * sr1.bxj06
               END IF
            ELSE
               LET sr1.num9 = 0
            END IF
            IF sr1.num9 IS NULL THEN LET sr1.num9 = 0 END IF
            #報廢數量
            IF l_bxr.bxr41 <> 0 THEN
               LET sr1.num10 = l_bxr.bxr41 * sr1.bxj06
            END IF
            IF sr1.num10 IS NULL THEN LET sr1.num10 = 0 END IF
            INSERT INTO abxr200_tmp VALUES(sr1.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               LET g_errno = SQLCA.SQLCODE
               IF cl_null(SQLCA.SQLCODE) THEN LET g_errno ='9052' END IF
               CALL cl_err('Ins abxr200_tmp:',g_errno,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
               EXIT PROGRAM
            END IF
         END FOREACH
         LET g_sum1 = 0    LET g_sum2 = 0
         LET g_sum3 = 0    LET g_sum4 = 0
         LET g_sum5 = 0    LET g_sum6 = 0
         LET g_sum7 = 0    LET g_sum8 = 0
         LET g_sum9 = 0    LET g_sum10= 0
         SELECT SUM(num1),SUM(num2),SUM(num3),SUM(num4),SUM(num5),
                SUM(num6),SUM(num7),SUM(num8),SUM(num9),SUM(num10)
           INTO g_sum1,g_sum2,g_sum3,g_sum4,g_sum5,
                g_sum6,g_sum7,g_sum8,g_sum9,g_sum10
           FROM abxr200_tmp
         IF g_sum1 IS NULL THEN LET g_sum1 = 0 END IF
         IF g_sum2 IS NULL THEN LET g_sum2 = 0 END IF
         IF g_sum3 IS NULL THEN LET g_sum3 = 0 END IF
         IF g_sum4 IS NULL THEN LET g_sum4 = 0 END IF
         IF g_sum5 IS NULL THEN LET g_sum5 = 0 END IF
         IF g_sum6 IS NULL THEN LET g_sum6 = 0 END IF
         IF g_sum7 IS NULL THEN LET g_sum7 = 0 END IF
         IF g_sum8 IS NULL THEN LET g_sum8 = 0 END IF
         IF g_sum9 IS NULL THEN LET g_sum9 = 0 END IF
         IF g_sum10 IS NULL THEN LET g_sum10 = 0 END IF
         #IF 各料本期結存為零要印否 ='N' 且
         #   若各料累計數量的每個欄位為0者不為資料來源
         IF tm.f = 'N' AND g_sum1 = 0 AND g_sum2 = 0 AND g_sum3 = 0 AND 
            g_sum4 = 0 AND g_sum5 = 0 AND g_sum6 = 0 AND g_sum7 = 0 AND 
            g_sum9 = 0 AND g_sum10 = 0 THEN
            CONTINUE FOREACH
         END IF
         #塞入報表
         DECLARE r200_tmp_cs CURSOR FOR
            SELECT * FROM abxr200_tmp
         FOREACH r200_tmp_cs INTO sr1.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH r200_tmp_cs:',SQLCA.sqlcode,1)
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
           #MOD-AA0033---add---start---
            IF cl_null(sr1.bxj05) THEN
               SELECT ima25 INTO sr1.bxj05 FROM ima_file
                WHERE ima01 = sr.ima01
            END IF
           #MOD-AA0033---add---end--- 
#FUN-850089 By TSD.zeak ---start--- 
#            IF tm.b = '1' THEN  #1:料號格式
#               OUTPUT TO REPORT r200_rep1(sr.*,sr1.*,1)
#            ELSE                #2:保稅群組代碼格式
#               OUTPUT TO REPORT r200_rep2(sr.*,sr1.*,1)
#            END IF
            #多塞入一筆資料在cr上用來顯示"上期結轉數量"
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
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.num1,   sr1.num2,
                     sr1.num3, sr1.num4, sr1.num5,  sr1.num6,   sr1.num7,
                     sr1.num8, sr1.num9, sr1.num10, sr1.bxj11a, sr1.bxj17a,
                     sr1.bxj10,sr1.bxj21,
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,
                     l_flag,
                     sr_ima01.sum1, sr_ima01.sum2,sr_ima01.sum3,
                     sr_ima01.sum4, sr_ima01.sum5,sr_ima01.sum6,
                     sr_ima01.sum7, sr_ima01.sum8, sr_ima01.sum9,
                     sr_ima1916.sum1, sr_ima1916.sum2,sr_ima1916.sum3,
                     sr_ima1916.sum4, sr_ima1916.sum5,sr_ima1916.sum6,
                     sr_ima1916.sum7, sr_ima1916.sum8, sr_ima1916.sum9
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
                     sr1.bxj01,sr1.bxi02,sr1.bxi06, sr1.num1,   sr1.num2,
                     sr1.num3, sr1.num4, sr1.num5,  sr1.num6,   sr1.num7,
                     sr1.num8, sr1.num9, sr1.num10, sr1.bxj11a, sr1.bxj17a,
                     sr1.bxj10,sr1.bxj21,
                     g_bxz.bxz100,g_bxz.bxz101,g_bxz.bxz102,
                     l_flag,
                     sr_ima01.sum1, sr_ima01.sum2,sr_ima01.sum3,
                     sr_ima01.sum4, sr_ima01.sum5,sr_ima01.sum6,
                     sr_ima01.sum7, sr_ima01.sum8,sr_ima01.sum9,
                     sr_ima1916.sum1, sr_ima1916.sum2,sr_ima1916.sum3,
                     sr_ima1916.sum4, sr_ima1916.sum5,sr_ima1916.sum6,
                     sr_ima1916.sum7, sr_ima1916.sum8, sr_ima1916.sum9
            #FUN-850089 By TSD.zeak ----end---- 
         END FOREACH
      LET l_pre_ima01 = sr.ima01             #FUN-850089
      LET l_pre_ima1916 = sr.ima1916         #FUN-850089
      END IF
   END FOREACH
 
   #FUN-850089 By TSD.zeak      ---start---
   #把flag = '1'的(多塞的那一行)數量都update為0 避免報表的加總出錯
   LET l_sql = " UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED ,
               "          SET num1 = 0,num2 = 0,num3 = 0,num4 = 0,num5 = 0 ,",
               "              num6 = 0,num7 = 0,num8 = 0,num9 = 0,num10 = 0 ",
               "   WHERE flag = '1' "
   PREPARE update_pre from l_sql
   EXECUTE update_pre
 
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ""   #MOD-A70135 add
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'zu01')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str ,";",      
               tm.bdate USING "yyyy/mm"   ,";",     #p2
               tm.edate USING "yyyy/mm/dd",";",     #p3
               tm.mdate USING "yyyy/mm/dd" ,";",    #p4
               tm.a,";",                            #p5
               tm.c,";",                            #p6
               tm.g,";",                            #p7
               tm.s[1,1],";",                       #p8
               tm.s[2,2],";",                       #p9
               tm.u[1,1],";",                       #p10
               tm.u[2,2],";",                       #p11
               tm.t[1,1],";",                       #p12
               tm.t[2,2],";"                        #p13
 
   IF tm.b = '1' THEN  #1:料號格式
      CALL cl_prt_cs3('abxr200','abxr200',l_sql,g_str)   
   ELSE                #2:保稅群組代碼格式
      CALL cl_prt_cs3('abxr200','abxr200_1',l_sql,g_str)   
   END IF
#   IF tm.b = '1' THEN  #1:料號格式
#      FINISH REPORT r200_rep1
#   ELSE                #2:保稅群組代碼格式
#      FINISH REPORT r200_rep2
#   END IF
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #FUN-850089 By TSD.zeak      ---end---

   #No.FUN-B80082--mark--Begin---  
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----
END FUNCTION
 
#==================================================================
#1:料號格式
#==================================================================
#FUN-850089 mark start
#REPORT r200_rep1(sr,sr1,p_cnt)
#  DEFINE l_last_sw LIKE type_file.chr1,
#         l_bnf07   LIKE bnf_file.bnf07,
#         p_cnt     LIKE type_file.num5,
#         sr        RECORD
#                      ima01      LIKE ima_file.ima01,
#                      ima02      LIKE ima_file.ima02,
#                      ima021     LIKE ima_file.ima021,
#                      ima1915  LIKE ima_file.ima1915,
#                      ima1916  LIKE ima_file.ima1916,
#                      bxe02  LIKE bxe_file.bxe02,
#                      bxe03  LIKE bxe_file.bxe03,
#                      bxe04  LIKE bxe_file.bxe04,
#                      bxe05  LIKE bxe_file.bxe05,
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
#                      num1       LIKE bxj_file.bxj06, #保稅進口數量
#                      num2       LIKE bxj_file.bxj06, #非保稅進口數量
#                      num3       LIKE bxj_file.bxj06, #廠內生產領用
#                      num4       LIKE bxj_file.bxj06, #廠外加工領用
#                      num5       LIKE bxj_file.bxj06, #外運
#                      num6       LIKE bxj_file.bxj06, #其他
#                      num7       LIKE bxj_file.bxj06, #退料數量
#                      num8       LIKE bxj_file.bxj06, #帳面庫存數量
#                      num9       LIKE bxj_file.bxj06, #出口數量
#                      num10      LIKE bxj_file.bxj06, #報廢數量
#                      bxj11a     LIKE bxj_file.bxj11,
#                      bxj17a     LIKE bxj_file.bxj17,
#                      bxj10      LIKE bxj_file.bxj10,
#                      bxj21  LIKE bxj_file.bxj21
#                   END RECORD
 
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
#           COLUMN 190, g_x[2] CLIPPED, g_bxz.bxz101 CLIPPED
#     CASE tm.c
#          WHEN '1' LET g_msg = g_x[3] CLIPPED, g_x[4] CLIPPED, g_x[7] CLIPPED
#          WHEN '2' LET g_msg = g_x[3] CLIPPED, g_x[5] CLIPPED, g_x[7] CLIPPED
#          WHEN '3' LET g_msg = g_x[3] CLIPPED, g_x[6] CLIPPED, g_x[7] CLIPPED
#     END CASE
#     PRINT COLUMN (g_len-FGL_WIDTH(g_msg))/2 ,g_msg CLIPPED
#     PRINT ''
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN  01, g_x[8] CLIPPED, tm.mdate USING 'yyyy/mm/dd',
#           COLUMN  45, g_x[9] CLIPPED, YEAR(tm.bdate) USING '<<<<', "/",
#                                       MONTH(tm.bdate) USING '<<',
#           COLUMN 232, g_x[10] CLIPPED, g_pageno USING '<<<<'
#     PRINT COLUMN  01, g_x[11] CLIPPED, sr.ima01 CLIPPED,
#           COLUMN  45, g_x[12] CLIPPED, sr.ima02 CLIPPED,
#           COLUMN  95, g_x[13] CLIPPED, sr.ima021 CLIPPED,
#           COLUMN 136, g_x[14] CLIPPED, sr1.bxj05 CLIPPED,
#           COLUMN 190, g_x[15] CLIPPED, sr.ima1915 CLIPPED
#     PRINT COLUMN 01, g_x[16] CLIPPED
#     PRINT COLUMN 01, g_x[17] CLIPPED
#     PRINT COLUMN 01, g_x[18] CLIPPED
#     PRINT COLUMN 01, g_x[19] CLIPPED
#     PRINT COLUMN 01, g_x[20] CLIPPED
#     PRINTX name=H1 g_x[61],g_x[62],g_x[63],g_x[64],g_x[65],
#                    g_x[66],g_x[67],g_x[68],g_x[69],g_x[70],
#                    g_x[71],g_x[72],g_x[73],g_x[74],g_x[75],
#                    g_x[76],g_x[77]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.ima01
#     LET g_i = 0
#     LET l_bnf07 = sr.bnf07
#     SKIP TO TOP OF PAGE
 
#  BEFORE GROUP OF sr1.order1
#     IF tm.t[1,1] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr1.order2
#     IF tm.t[2,2] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#     IF g_i = 0 THEN
#        PRINTX name=D1
#               COLUMN g_c[61], '',
#               COLUMN g_c[62], '',
#               COLUMN g_c[63], '',
#               COLUMN g_c[64], '',
#               COLUMN g_c[65], '',
#               COLUMN g_c[66], '',
#               COLUMN g_c[67], '',
#               COLUMN g_c[68], '',
#               COLUMN g_c[69], '',
#               COLUMN g_c[70], '',
#               COLUMN g_c[71], g_x[21] CLIPPED,
#               COLUMN g_c[72], cl_numfor(sr.bnf07,72,3),
#               COLUMN g_c[73], '',
#               COLUMN g_c[74], '',
#               COLUMN g_c[75], '',
#               COLUMN g_c[76], '',
#               COLUMN g_c[77], ''
#     END IF
#     LET g_i = g_i + 1
#     IF p_cnt = 1 AND tm.g = 'Y' THEN
#        #帳面庫存數量
#        CASE sr1.bxi06
#             WHEN '1'  LET l_bnf07 = l_bnf07 + sr1.bxj06
#             WHEN '2'  LET l_bnf07 = l_bnf07 - sr1.bxj06
#        END CASE
#        PRINTX name=D1
#               COLUMN g_c[61], sr1.bxj11 CLIPPED,
#               COLUMN g_c[62], sr1.bxj17 USING 'yyyymmdd',
#               COLUMN g_c[63], sr1.bxj01,
#               COLUMN g_c[64], sr1.bxi02 USING 'yyyymmdd';
#        IF sr1.num1 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[65], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[65], sr1.num1 USING '-------&.&&&';
#        END IF
#        IF sr1.num2 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[66], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[66], sr1.num2 USING '-------&.&&&';
#        END IF
#        IF sr1.num3 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[67], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[67], sr1.num3 USING '-------&.&&&';
#        END IF
#        IF sr1.num4 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[68], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[68], sr1.num4 USING '-------&.&&&';
#        END IF
#        IF sr1.num5 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[69], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[69], sr1.num5 USING '-------&.&&&';
#        END IF
#        IF sr1.num6 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[70], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[70], sr1.num6 USING '-------&.&&&';
#        END IF
#        IF sr1.num7 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[71], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[71], sr1.num7 USING '-------&.&&&';
#        END IF
#        IF l_bnf07 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[72], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[72], l_bnf07  USING '-------&.&&&';
#        END IF
#        PRINTX name=D1
#               COLUMN g_c[73], sr1.bxj11a CLIPPED,
#               COLUMN g_c[74], sr1.bxj17a USING 'yyyymmdd';
#        IF sr1.num9 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[75], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[75], cl_numfor(sr1.num9,75,3);
#        END IF
#        IF sr1.num10 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[76], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[76], cl_numfor(sr1.num10,76,3);
#        END IF
#        PRINTX name=D1  COLUMN g_c[77], sr1.bxj10
#     END IF
 
#  AFTER GROUP OF sr.ima01
#     #列印「料號本期累計數量] 
#     PRINT COLUMN 01,g_x[16] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[61], '',
#            COLUMN g_c[62], '',
#            COLUMN g_c[63], g_x[23] CLIPPED,
#            COLUMN g_c[64], '';
#     IF GROUP SUM(sr1.num1) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[65], GROUP SUM(sr1.num1) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[65], '';
#     END IF
#     IF GROUP SUM(sr1.num2) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[66], GROUP SUM(sr1.num2) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[66], '';
#     END IF
#     IF GROUP SUM(sr1.num3) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[67], GROUP SUM(sr1.num3) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[67], '';
#     END IF
#     IF GROUP SUM(sr1.num4) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[68], GROUP SUM(sr1.num4) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[68], '';
#     END IF
#     IF GROUP SUM(sr1.num5) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[69], GROUP SUM(sr1.num5) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[69], '';
#     END IF
#     IF GROUP SUM(sr1.num6) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[70], GROUP SUM(sr1.num6) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[70], '';
#     END IF
#     IF GROUP SUM(sr1.num7) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[71], GROUP SUM(sr1.num7) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[71], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[72], '',
#            COLUMN g_c[73], '',
#            COLUMN g_c[74], '';
#     IF GROUP SUM(sr1.num9) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[75], GROUP SUM(sr1.num9) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[75], '';
#     END IF
#     IF GROUP SUM(sr1.num10) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[76], GROUP SUM(sr1.num10) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[76], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[77], ''
#     #列印「料號當年累計數量」
#     LET g_sum1 = 0   LET g_sum2 = 0
#     LET g_sum3 = 0   LET g_sum4 = 0
#     LET g_sum5 = 0   LET g_sum6 = 0
#     LET g_sum7 = 0
#     LET g_sum9 = 0   LET g_sum10= 0
#     SELECT SUM(bnf08),SUM(bnf09),SUM(bnf21),SUM(bnf22),SUM(bnf23),
#            SUM(bnf24),SUM(bnf25),SUM(bnf26),SUM(bnf27)
#       INTO g_sum1,g_sum2,g_sum3,g_sum4,g_sum5,
#            g_sum6,g_sum7,g_sum9,g_sum10
#       FROM bnf_file
#      WHERE bnf01 = sr.ima01
#        AND bnf03*12+bnf04 BETWEEN g_sm AND g_em
#     PRINT COLUMN 01,g_x[16] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[61], '',
#            COLUMN g_c[62], '',
#            COLUMN g_c[63], g_x[24] CLIPPED,
#            COLUMN g_c[64], '';
#     IF g_sum1 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[65], g_sum1 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[65], '';
#     END IF
#     IF g_sum2 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[66], g_sum2 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[66], '';
#     END IF
#     IF g_sum3 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[67], g_sum3 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[67], '';
#     END IF
#     IF g_sum4 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[68], g_sum4 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[68], '';
#     END IF
#     IF g_sum5 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[69], g_sum5 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[69], '';
#     END IF
#     IF g_sum6 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[70], g_sum6 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[70], '';
#     END IF
#     IF g_sum7 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[71], g_sum7 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[71], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[72], '',
#            COLUMN g_c[73], '',
#            COLUMN g_c[74], '';
#     IF g_sum9 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[75], g_sum9 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[75], '';
#     END IF
#     IF g_sum10 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[76], g_sum10 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[76], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[77], ''
 
#  AFTER GROUP OF sr1.order1
#     #列印「小計累計數量」
#     IF tm.u[1,1] = 'Y' THEN
#        PRINT COLUMN 01,g_x[16] CLIPPED
#        CASE tm.s[1,1]
#             WHEN '1'  #料號
#                     PRINTX name=S1  COLUMN g_c[61], sr.ima01 CLIPPED;
#             WHEN '2'  #保稅群組代碼
#                     PRINTX name=S1  COLUMN g_c[61], sr.ima1916 CLIPPED;
#             OTHERWISE
#                     PRINTX name=S1  COLUMN g_c[61], '';
#        END CASE
#        PRINTX name=S1
#               COLUMN g_c[62], '',
#               COLUMN g_c[63], g_x[22] CLIPPED,
#               COLUMN g_c[64], '';
#        IF GROUP SUM(sr1.num1) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[65], GROUP SUM(sr1.num1) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[65], '';
#        END IF
#        IF GROUP SUM(sr1.num2) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[66], GROUP SUM(sr1.num2) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[66], '';
#        END IF
#        IF GROUP SUM(sr1.num3) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[67], GROUP SUM(sr1.num3) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[67], '';
#        END IF
#        IF GROUP SUM(sr1.num4) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[68], GROUP SUM(sr1.num4) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[68], '';
#        END IF
#        IF GROUP SUM(sr1.num5) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[69], GROUP SUM(sr1.num5) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[69], '';
#        END IF
#        IF GROUP SUM(sr1.num6) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[70], GROUP SUM(sr1.num6) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[70], '';
#        END IF
#        IF GROUP SUM(sr1.num7) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[71], GROUP SUM(sr1.num7) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[71], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[72], '',
#               COLUMN g_c[73], '',
#               COLUMN g_c[74], '';
#        IF GROUP SUM(sr1.num9) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[75], GROUP SUM(sr1.num9) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[75], '';
#        END IF
#        IF GROUP SUM(sr1.num10) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[76], GROUP SUM(sr1.num10) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[76], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[77], ''
#        IF tm.s[1,1] = '2' THEN
#           PRINTX name=S1  COLUMN g_c[61], sr.bxe02 CLIPPED
#           PRINTX name=S1  COLUMN g_c[61], sr.bxe03 CLIPPED
#        END IF
#     END IF
 
#  AFTER GROUP OF sr1.order2
#     #列印「小計累計數量」
#     IF tm.u[2,2] = 'Y' THEN
#        PRINT COLUMN 01,g_x[16] CLIPPED
#        CASE tm.s[2,2]
#             WHEN '1'  #料號
#                     PRINTX name=S1  COLUMN g_c[61], sr.ima01 CLIPPED;
#             WHEN '2'  #保稅群組代碼
#                     PRINTX name=S1  COLUMN g_c[61], sr.ima1916 CLIPPED;
#             OTHERWISE
#                     PRINTX name=S1  COLUMN g_c[61], '';
#        END CASE
#        PRINTX name=S1
#               COLUMN g_c[62], '',
#               COLUMN g_c[63], g_x[22] CLIPPED,
#               COLUMN g_c[64], '';
#        IF GROUP SUM(sr1.num1) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[65], GROUP SUM(sr1.num1) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[65], '';
#        END IF
#        IF GROUP SUM(sr1.num2) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[66], GROUP SUM(sr1.num2) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[66], '';
#        END IF
#        IF GROUP SUM(sr1.num3) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[67], GROUP SUM(sr1.num3) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[67], '';
#        END IF
#        IF GROUP SUM(sr1.num4) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[68], GROUP SUM(sr1.num4) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[68], '';
#        END IF
#        IF GROUP SUM(sr1.num5) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[69], GROUP SUM(sr1.num5) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[69], '';
#        END IF
#        IF GROUP SUM(sr1.num6) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[70], GROUP SUM(sr1.num6) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[70], '';
#        END IF
#        IF GROUP SUM(sr1.num7) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[71], GROUP SUM(sr1.num7) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[71], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[72], '',
#               COLUMN g_c[73], '',
#               COLUMN g_c[74], '';
#        IF GROUP SUM(sr1.num9) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[75], GROUP SUM(sr1.num9) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[75], '';
#        END IF
#        IF GROUP SUM(sr1.num10) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[76], GROUP SUM(sr1.num10) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[76], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[77], ''
#        IF tm.s[2,2] = '2' THEN
#           PRINTX name=S1  COLUMN g_c[61], sr.bxe02 CLIPPED
#           PRINTX name=S1  COLUMN g_c[61], sr.bxe03 CLIPPED
#        END IF
#     END IF
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT COLUMN  01, g_x[16] CLIPPED
#        PRINT COLUMN  01, g_x[25] CLIPPED,
#              COLUMN 239, g_x[27] CLIPPED
#     ELSE
#        PRINT COLUMN  01, g_x[16] CLIPPED
#        PRINT COLUMN  01, g_x[25] CLIPPED,
#              COLUMN 239, g_x[26] CLIPPED
#     END IF
#END REPORT
 
##==================================================================
##2:保稅群組代碼格式
##==================================================================
#REPORT r200_rep2(ssr,ssr1,p_cnt1)
#  DEFINE l_last_sw1  LIKE type_file.chr1,
#         l_bnf071    LIKE bnf_file.bnf07,
#         p_cnt1      LIKE type_file.num5,
#         l_yy1,l_mm1 LIKE type_file.num5,
#         ssr         RECORD
#                      ima01      LIKE ima_file.ima01,
#                      ima02      LIKE ima_file.ima02,
#                      ima021     LIKE ima_file.ima021,
#                      ima1915  LIKE ima_file.ima1915,
#                      ima1916  LIKE ima_file.ima1916,
#                      bxe02  LIKE bxe_file.bxe02,
#                      bxe03  LIKE bxe_file.bxe03,
#                      bxe04  LIKE bxe_file.bxe04,
#                      bxe05  LIKE bxe_file.bxe05,
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
#                      num1       LIKE bxj_file.bxj06, #保稅進口數量
#                      num2       LIKE bxj_file.bxj06, #非保稅進口數量
#                      num3       LIKE bxj_file.bxj06, #廠內生產領用
#                      num4       LIKE bxj_file.bxj06, #廠外加工領用
#                      num5       LIKE bxj_file.bxj06, #外運
#                      num6       LIKE bxj_file.bxj06, #其他
#                      num7       LIKE bxj_file.bxj06, #退料數量
#                      num8       LIKE bxj_file.bxj06, #帳面庫存數量
#                      num9       LIKE bxj_file.bxj06, #出口數量
#                      num10      LIKE bxj_file.bxj06, #報廢數量
#                      bxj11a     LIKE bxj_file.bxj11,
#                      bxj17a     LIKE bxj_file.bxj17,
#                      bxj10      LIKE bxj_file.bxj10,
#                      bxj21  LIKE bxj_file.bxj21
#                     END RECORD
 
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
#           COLUMN 190, g_x[2] CLIPPED, g_bxz.bxz101 CLIPPED
#     CASE tm.c
#          WHEN '1' LET g_msg = g_x[3] CLIPPED, g_x[4] CLIPPED, g_x[7] CLIPPED
#          WHEN '2' LET g_msg = g_x[3] CLIPPED, g_x[5] CLIPPED, g_x[7] CLIPPED
#          WHEN '3' LET g_msg = g_x[3] CLIPPED, g_x[6] CLIPPED, g_x[7] CLIPPED
#     END CASE
#     PRINT COLUMN (g_len-FGL_WIDTH(g_msg))/2 ,g_msg CLIPPED
#     PRINT ''
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN  01, g_x[8] CLIPPED, tm.mdate USING 'yyyy/mm/dd',
#           COLUMN  45, g_x[9] CLIPPED, YEAR(tm.bdate) USING '<<<<', "/",
#                                       MONTH(tm.bdate) USING '<<',
#           COLUMN 232, g_x[10] CLIPPED, g_pageno USING '<<<<'
#     PRINT COLUMN  01, g_x[28] CLIPPED, ssr.ima1916 CLIPPED,
#           COLUMN  45, g_x[29] CLIPPED, ssr.bxe02 CLIPPED,
#           COLUMN  95, g_x[13] CLIPPED, ssr.bxe03 CLIPPED,
#           COLUMN 136, g_x[14] CLIPPED, ssr.bxe04 CLIPPED,
#           COLUMN 190, g_x[15] CLIPPED, ssr.bxe05 CLIPPED
#     PRINT COLUMN 01, g_x[16] CLIPPED
#     PRINT COLUMN 01, g_x[17] CLIPPED
#     PRINT COLUMN 01, g_x[18] CLIPPED
#     PRINT COLUMN 01, g_x[19] CLIPPED
#     PRINT COLUMN 01, g_x[20] CLIPPED
#     PRINTX name=H1 g_x[61],g_x[62],g_x[63],g_x[64],g_x[65],
#                    g_x[66],g_x[67],g_x[68],g_x[69],g_x[70],
#                    g_x[71],g_x[72],g_x[73],g_x[74],g_x[75],
#                    g_x[76],g_x[77] CLIPPED
#     PRINT g_dash1
#     LET l_last_sw1 = 'n'
 
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
 
#  BEFORE GROUP OF ssr1.order1
#     IF tm.t[1,1] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF ssr1.order2
#     IF tm.t[2,2] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#     IF g_i = 0 THEN
#        PRINTX name=D1
#               COLUMN g_c[61], '',
#               COLUMN g_c[62], '',
#               COLUMN g_c[63], '',
#               COLUMN g_c[64], '',
#               COLUMN g_c[65], '',
#               COLUMN g_c[66], '',
#               COLUMN g_c[67], '',
#               COLUMN g_c[68], '',
#               COLUMN g_c[69], '',
#               COLUMN g_c[70], '',
#               COLUMN g_c[71], g_x[21] CLIPPED,
#               COLUMN g_c[72], l_bnf071 USING '-------&.&&&',
#               COLUMN g_c[73], '',
#               COLUMN g_c[74], '',
#               COLUMN g_c[75], '',
#               COLUMN g_c[76], '',
#               COLUMN g_c[77], ''
#     END IF
#     LET g_i = g_i + 1
#     IF p_cnt1 = 1 AND tm.g = 'Y' THEN
#        #帳面庫存數量
#        CASE ssr1.bxi06
#             WHEN '1'  LET l_bnf071 = l_bnf071 + ssr1.bxj06
#             WHEN '2'  LET l_bnf071 = l_bnf071 - ssr1.bxj06
#        END CASE
#        PRINTX name=D1
#               COLUMN g_c[61], ssr1.bxj11 CLIPPED,
#               COLUMN g_c[62], ssr1.bxj17 USING 'yyyymmdd',
#               COLUMN g_c[63], ssr1.bxj01,
#               COLUMN g_c[64], ssr1.bxi02 USING 'yyyymmdd';
#        IF ssr1.num1 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[65], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[65], ssr1.num1 USING '-------&.&&&';
#        END IF
#        IF ssr1.num2 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[66], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[66], ssr1.num2 USING '-------&.&&&';
#        END IF
#        IF ssr1.num3 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[67], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[67], ssr1.num3 USING '-------&.&&&';
#        END IF
#        IF ssr1.num4 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[68], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[68], ssr1.num4 USING '-------&.&&&';
#        END IF
#        IF ssr1.num5 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[69], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[69], ssr1.num5 USING '-------&.&&&';
#        END IF
#        IF ssr1.num6 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[70], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[70], ssr1.num6 USING '-------&.&&&';
#        END IF
#        IF ssr1.num7 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[71], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[71], ssr1.num7 USING '-------&.&&&';
#        END IF
#        IF l_bnf071 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[72], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[72], l_bnf071  USING '-------&.&&&';
#        END IF
#        PRINTX name=D1
#               COLUMN g_c[73], ssr1.bxj11a CLIPPED,
#               COLUMN g_c[74], ssr1.bxj17a USING 'yyyymmdd';
#        IF ssr1.num9 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[75], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[75], ssr1.num9 USING '-------&.&&&';
#        END IF
#        IF ssr1.num10 = 0 THEN 
#           PRINTX name=D1  COLUMN g_c[76], '';
#        ELSE
#           PRINTX name=D1  COLUMN g_c[76], ssr1.num10 USING '-------&.&&&';
#        END IF
#        PRINTX name=D1  COLUMN g_c[77], ssr1.bxj10
#     END IF
 
#  AFTER GROUP OF ssr.ima1916
#     #列印「群組本期累計數量] 
#     PRINT COLUMN 01,g_x[16] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[61], '',
#            COLUMN g_c[62], '',
#            COLUMN g_c[63], g_x[30] CLIPPED,
#            COLUMN g_c[64], '';
#     IF GROUP SUM(ssr1.num1) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[65], GROUP SUM(ssr1.num1) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[65], '';
#     END IF
#     IF GROUP SUM(ssr1.num2) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[66], GROUP SUM(ssr1.num2) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[66], '';
#     END IF
#     IF GROUP SUM(ssr1.num3) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[67], GROUP SUM(ssr1.num3) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[67], '';
#     END IF
#     IF GROUP SUM(ssr1.num4) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[68], GROUP SUM(ssr1.num4) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[68], '';
#     END IF
#     IF GROUP SUM(ssr1.num5) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[69], GROUP SUM(ssr1.num5) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[69], '';
#     END IF
#     IF GROUP SUM(ssr1.num6) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[70], GROUP SUM(ssr1.num6) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[70], '';
#     END IF
#     IF GROUP SUM(ssr1.num7) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[71], GROUP SUM(ssr1.num7) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[71], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[72], '',
#            COLUMN g_c[73], '',
#            COLUMN g_c[74], '';
#     IF GROUP SUM(ssr1.num9) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[75], GROUP SUM(ssr1.num9) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[75], '';
#     END IF
#     IF GROUP SUM(ssr1.num10) <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[76], GROUP SUM(ssr1.num10) USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[76], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[77], ''
#     #列印「群組當年累計數量」
#     LET g_sum1 = 0   LET g_sum2 = 0
#     LET g_sum3 = 0   LET g_sum4 = 0
#     LET g_sum5 = 0   LET g_sum6 = 0
#     LET g_sum7 = 0
#     LET g_sum9 = 0   LET g_sum10= 0
#     SELECT SUM(bnf08),SUM(bnf09),SUM(bnf21),SUM(bnf22),SUM(bnf23),
#            SUM(bnf24),SUM(bnf25),SUM(bnf26),SUM(bnf27)
#       INTO g_sum1,g_sum2,g_sum3,g_sum4,g_sum5,
#            g_sum6,g_sum7,g_sum9,g_sum10
#       FROM bnf_file, ima_file
#      WHERE bnf01 = ima01
#        AND ima1916 = ssr.ima1916
#        AND bnf03*12+bnf04 BETWEEN g_sm AND g_em
#     PRINT COLUMN 01,g_x[16] CLIPPED
#     PRINTX name=S1
#            COLUMN g_c[61], '',
#            COLUMN g_c[62], '',
#            COLUMN g_c[63], g_x[31] CLIPPED,
#            COLUMN g_c[64], '';
#     IF g_sum1 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[65], g_sum1 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[65], '';
#     END IF
#     IF g_sum2 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[66], g_sum2 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[66], '';
#     END IF
#     IF g_sum3 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[67], g_sum3 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[67], '';
#     END IF
#     IF g_sum4 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[68], g_sum4 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[68], '';
#     END IF
#     IF g_sum5 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[69], g_sum5 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[69], '';
#     END IF
#     IF g_sum6 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[70], g_sum6 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[70], '';
#     END IF
#     IF g_sum7 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[71], g_sum7 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[71], '';
#     END IF
#     PRINTX name=S1
#            COLUMN g_c[72], '',
#            COLUMN g_c[73], '',
#            COLUMN g_c[74], '';
#     IF g_sum9 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[75], g_sum9 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[75], '';
#     END IF
#     IF g_sum10 <> 0 THEN
#        PRINTX name=S1
#               COLUMN g_c[76], g_sum10 USING '-------&.&&&';
#     ELSE
#        PRINTX name=S1  COLUMN g_c[76], '';
#     END IF
#     PRINTX name=S1  COLUMN g_c[77], ''
 
#  AFTER GROUP OF ssr.ima01
#     IF tm.g = 'Y' THEN
#        #列印「料號當年累計數量」
#        LET g_sum1 = 0   LET g_sum2 = 0
#        LET g_sum3 = 0   LET g_sum4 = 0
#        LET g_sum5 = 0   LET g_sum6 = 0
#        LET g_sum7 = 0
#        LET g_sum9 = 0   LET g_sum10= 0
#        SELECT SUM(bnf08),SUM(bnf09),SUM(bnf21),SUM(bnf22),SUM(bnf23),
#               SUM(bnf24),SUM(bnf25),SUM(bnf26),SUM(bnf27)
#          INTO g_sum1,g_sum2,g_sum3,g_sum4,g_sum5,
#               g_sum6,g_sum7,g_sum9,g_sum10
#          FROM bnf_file
#         WHERE bnf01 = ssr.ima01
#           AND bnf03*12+bnf04 BETWEEN g_sm AND g_em
#        PRINT COLUMN 01,g_x[16] CLIPPED
#        PRINTX name=S1
#               COLUMN g_c[61], '',
#               COLUMN g_c[62], '',
#               COLUMN g_c[63], g_x[24] CLIPPED,
#               COLUMN g_c[64], '';
#        IF g_sum1 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[65], g_sum1 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[65], '';
#        END IF
#        IF g_sum2 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[66], g_sum2 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[66], '';
#        END IF
#        IF g_sum3 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[67], g_sum3 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[67], '';
#        END IF
#        IF g_sum4 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[68], g_sum4 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[68], '';
#        END IF
#        IF g_sum5 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[69], g_sum5 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[69], '';
#        END IF
#        IF g_sum6 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[70], g_sum6 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[70], '';
#        END IF
#        IF g_sum7 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[71], g_sum7 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[71], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[72], '',
#               COLUMN g_c[73], '',
#               COLUMN g_c[74], '';
#        IF g_sum9 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[75], g_sum9 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[75], '';
#        END IF
#        IF g_sum10 <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[76], g_sum10 USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[76], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[77], ''
#     END IF
 
#  AFTER GROUP OF ssr1.order1
#     #列印「小計累計數量」
#     IF tm.u[1,1] = 'Y' THEN
#        PRINT COLUMN 01,g_x[16] CLIPPED
#        CASE tm.s[1,1]
#             WHEN '1'  #料號
#                     PRINTX name=S1  COLUMN g_c[61], ssr.ima01 CLIPPED;
#             WHEN '2'  #保稅群組代碼
#                     PRINTX name=S1  COLUMN g_c[61], ssr.ima1916 CLIPPED;
#             OTHERWISE
#                     PRINTX name=S1  COLUMN g_c[61], '';
#        END CASE
#        PRINTX name=S1
#               COLUMN g_c[62], '',
#               COLUMN g_c[63], g_x[22] CLIPPED,
#               COLUMN g_c[64], '';
#        IF GROUP SUM(ssr1.num1) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[65], GROUP SUM(ssr1.num1) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[65], '';
#        END IF
#        IF GROUP SUM(ssr1.num2) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[66], GROUP SUM(ssr1.num2) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[66], '';
#        END IF
#        IF GROUP SUM(ssr1.num3) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[67], GROUP SUM(ssr1.num3) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[67], '';
#        END IF
#        IF GROUP SUM(ssr1.num4) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[68], GROUP SUM(ssr1.num4) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[68], '';
#        END IF
#        IF GROUP SUM(ssr1.num5) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[69], GROUP SUM(ssr1.num5) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[69], '';
#        END IF
#        IF GROUP SUM(ssr1.num6) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[70], GROUP SUM(ssr1.num6) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[70], '';
#        END IF
#        IF GROUP SUM(ssr1.num7) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[71], GROUP SUM(ssr1.num7) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[71], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[72], '',
#               COLUMN g_c[73], '',
#               COLUMN g_c[74], '';
#        IF GROUP SUM(ssr1.num9) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[75], GROUP SUM(ssr1.num9) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[75], '';
#        END IF
#        IF GROUP SUM(ssr1.num10) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[76], GROUP SUM(ssr1.num10) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[76], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[77], ''
#        IF tm.s[1,1] = '2' THEN
#           PRINTX name=S1  COLUMN g_c[61], ssr.bxe02 CLIPPED
#           PRINTX name=S1  COLUMN g_c[61], ssr.bxe03 CLIPPED
#        END IF
#     END IF
 
#  AFTER GROUP OF ssr1.order2
#     #列印「小計累計數量」
#     IF tm.u[2,2] = 'Y' THEN
#        PRINT COLUMN 01,g_x[16] CLIPPED
#        CASE tm.s[2,2]
#             WHEN '1'  #料號
#                     PRINTX name=S1  COLUMN g_c[61], ssr.ima01 CLIPPED;
#             WHEN '2'  #保稅群組代碼
#                     PRINTX name=S1  COLUMN g_c[61], ssr.ima1916 CLIPPED;
#             OTHERWISE
#                     PRINTX name=S1  COLUMN g_c[61], '';
#        END CASE
#        PRINTX name=S1
#               COLUMN g_c[62], '',
#               COLUMN g_c[63], g_x[22] CLIPPED,
#               COLUMN g_c[64], '';
#        IF GROUP SUM(ssr1.num1) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[65], GROUP SUM(ssr1.num1) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[65], '';
#        END IF
#        IF GROUP SUM(ssr1.num2) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[66], GROUP SUM(ssr1.num2) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[66], '';
#        END IF
#        IF GROUP SUM(ssr1.num3) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[67], GROUP SUM(ssr1.num3) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[67], '';
#        END IF
#        IF GROUP SUM(ssr1.num4) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[68], GROUP SUM(ssr1.num4) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[68], '';
#        END IF
#        IF GROUP SUM(ssr1.num5) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[69], GROUP SUM(ssr1.num5) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[69], '';
#        END IF
#        IF GROUP SUM(ssr1.num6) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[70], GROUP SUM(ssr1.num6) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[70], '';
#        END IF
#        IF GROUP SUM(ssr1.num7) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[71], GROUP SUM(ssr1.num7) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[71], '';
#        END IF
#        PRINTX name=S1
#               COLUMN g_c[72], '',
#               COLUMN g_c[73], '',
#               COLUMN g_c[74], '';
#        IF GROUP SUM(ssr1.num9) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[75], GROUP SUM(ssr1.num9) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[75], '';
#        END IF
#        IF GROUP SUM(ssr1.num10) <> 0 THEN
#           PRINTX name=S1
#                  COLUMN g_c[76], GROUP SUM(ssr1.num10) USING '-------&.&&&';
#        ELSE
#           PRINTX name=S1  COLUMN g_c[76], '';
#        END IF
#        PRINTX name=S1  COLUMN g_c[77], ''
#        IF tm.s[2,2] = '2' THEN
#           PRINTX name=S1  COLUMN g_c[61], ssr.bxe02 CLIPPED
#           PRINTX name=S1  COLUMN g_c[61], ssr.bxe03 CLIPPED
#        END IF
#     END IF
 
#  ON LAST ROW
#     LET l_last_sw1 = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw1 = 'n' THEN
#        PRINT COLUMN  01, g_x[16] CLIPPED
#        PRINT COLUMN  01, g_x[25] CLIPPED,
#              COLUMN 239, g_x[27] CLIPPED
#     ELSE
#        PRINT COLUMN  01, g_x[16] CLIPPED
#        PRINT COLUMN  01, g_x[25] CLIPPED,
#              COLUMN 239, g_x[26] CLIPPED
#     END IF
#END REPORT
#FUN-850089 mark end
#No.FUN-890101  
