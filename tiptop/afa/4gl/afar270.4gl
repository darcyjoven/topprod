# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: afar270.4gl
# Desc/riptions...: 固定資產財簽二折舊費用兩期比較明細表
# Date & Author..: 12/01/11 FUN-BB0046 By Sakura
# Modify.........: No:CHI-C60010 12/06/12 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:FUN-C90088 12/12/18 By Belle 列印年限需有回溯功能

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item    LIKE type_file.num5         
END GLOBALS

DEFINE tm         RECORD                           # Print condition RECORD
                   wc      STRING,                 # Where condition
                   wc2     STRING,                 # Where condition
                   yyyy    LIKE type_file.num5,    # 資料年度           
                   mm      LIKE type_file.num5,    # 資料月份           
                   yy1     LIKE type_file.num5,    # 比較年度           
                   m1      LIKE type_file.num5,    # 比較月份           
                   difcost LIKE type_file.num5,    # 差異金額大於       
                   a       LIKE type_file.chr1,
                   s       LIKE type_file.chr3,    # Order by sequence
                   t       LIKE type_file.chr3,    # Eject sw
                   c       LIKE type_file.chr3,    # subtotal
                   more    LIKE type_file.chr1     # Input more condition(Y/N)
                  END RECORD 
DEFINE g_descripe ARRAY[3] OF LIKE type_file.chr20 # Report Heading & prompt
DEFINE g_i        LIKE type_file.num5     #count/index for any purpose          
DEFINE g_head1    LIKE type_file.chr1000
DEFINE l_table    STRING                  
DEFINE g_str      STRING                  
DEFINE g_sql      STRING                  
DEFINE g_bdate    LIKE type_file.dat      
DEFINE g_edate    LIKE type_file.dat      
DEFINE g_fap661   LIKE fap_file.fap661    
DEFINE g_fap10    LIKE fap_file.fap10     
DEFINE g_fap54_7  LIKE fap_file.fap54     
DEFINE g_fap561   LIKE fap_file.fap56     
DEFINE g_fap57    LIKE fap_file.fap57     
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_azi05_1  LIKE azi_file.azi05,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>  *** ##
   LET g_sql = "faj02.faj_file.faj02,",    #財編
               "faj022.faj_file.faj022,",  #附號
               "faj04.faj_file.faj04,",    #主類別
               "faj05.faj_file.faj05,",    #次類別
               "faj06.faj_file.faj06,",    #中文名稱
               "faj07.faj_file.faj07,",    #英文名稱
               "faj262.faj_file.faj262,",  #入帳日期
               "faj292.faj_file.faj292,",  #耐用年限
               "type.type_file.chr1,",
               "fbn03.fbn_file.fbn03,",    #年度
               "fbn04.fbn_file.fbn04,",    #月份
               "fbn05.fbn_file.fbn05,",    #分攤方式
               "fbn06.fbn_file.fbn06,",    #部門
               "gem02.gem_file.gem02,",    #部門名稱
               "fbn07.fbn_file.fbn07,",    #折舊金額
               "fbn09.fbn_file.fbn09,",    #被攤部門
               "l_cost.fbn_file.fbn14,", 
               "l_acct_d.fbn_file.fbn14,", 
               "l_curr_val.fbn_file.fbn14,",
               "l_curr_val2.fbn_file.fbn14,",
               "l_curr_1.fbn_file.fbn14,",
               "l_curr_2.fbn_file.fbn14,",
               "l_diff.fbn_file.fbn14,",
               "l_fab02.fab_file.fab02,",
               "g_azi04.azi_file.azi04,",    
               "g_azi05.azi_file.azi05 "    

   LET l_table = cl_prt_temptable('afar270',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#

   LET g_pdate  = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.yyyy= ARG_VAL(9)
   LET tm.mm  = ARG_VAL(10)
   LET tm.yy1 = ARG_VAL(11)
   LET tm.m1  = ARG_VAL(12)
   LET tm.difcost = ARG_VAL(13)
   LET tm.a   = ARG_VAL(14)
   LET tm.s   = ARG_VAL(15)
   LET tm.t   = ARG_VAL(16)
   LET tm.c   = ARG_VAL(17)
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)

   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL r270_tm(0,0)            # Input print condition
      ELSE CALL afar270()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r270_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         
            l_cmd         LIKE type_file.chr1000,
            lc_qbe_sn     LIKE gbm_file.gbm01

   LET p_row = 4 LET p_col = 16

   OPEN WINDOW r270_w AT p_row,p_col WITH FORM "afa/42f/afar270"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.a    = '1'
   LET tm.s    = '16'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.difcost = 0
   LET tm.yyyy = g_faa.faa072
   LET tm.mm   = g_faa.faa082
   LET tm.yy1  = g_faa.faa072
   LET tm.m1   = g_faa.faa082
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.c[1,1]
   LET tm2.u2   = tm.c[2,2]
   LET tm2.u3   = tm.c[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj022,faj06
         
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r270_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME tm.wc2 ON fbn06
         
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         

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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r270_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      INPUT BY NAME
            tm.yyyy,tm.mm,tm.yy1,tm.m1,tm.difcost,tm.a,
            tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
            tm2.u1,tm2.u2,tm2.u3,tm.more
            WITHOUT DEFAULTS
         
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
          
         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN   
               NEXT FIELD mm
            END IF
         AFTER FIELD m1
            IF cl_null(tm.m1) OR tm.m1<1 OR tm.m1>12 THEN
               NEXT FIELD m1
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()        # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.c = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW r270_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar270'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar270','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.wc2 CLIPPED,"'",
                        " '",tm.yyyy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.yy1  CLIPPED,"'",
                        " '",tm.m1   CLIPPED,"'",
                        " '",tm.difcost CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('afar270',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r270_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar270()
      ERROR ""
   END WHILE

   CLOSE WINDOW r270_w
END FUNCTION
 
FUNCTION afar270()
   DEFINE l_sql         STRING,
          l_cnt1,l_cnt2 LIKE type_file.num5,
          l_fbn06       LIKE fbn_file.fbn06,     #部門          
          sr            RECORD
                         order1 LIKE faj_file.faj06,     
                         order2 LIKE faj_file.faj06,     
                         order3 LIKE faj_file.faj06,     
                         faj02  LIKE faj_file.faj02,     #財編
                         faj022 LIKE faj_file.faj022,    #附號
                         faj04  LIKE faj_file.faj04,     #主類別
                         faj05  LIKE faj_file.faj05,     #次類別
                         faj06  LIKE faj_file.faj06,     #中文名稱
                         faj07  LIKE faj_file.faj07,     #英文名稱
                         faj262  LIKE faj_file.faj262,   #入帳日期
                         faj292  LIKE faj_file.faj292,   #耐用年限
                         faj142  LIKE faj_file.faj142,   #本幣成本          
                         faj1412 LIKE faj_file.faj1412,  #調整成本          
                         faj592  LIKE faj_file.faj592,   #銷帳成本          
                         faj322  LIKE faj_file.faj322,   #累積折舊          
                         faj1012 LIKE faj_file.faj1012,  #已提列減值準備    
                         faj342  LIKE faj_file.faj342,   #折畢再提          
                         faj20  LIKE faj_file.faj20,     #保管部門          
                         faj232  LIKE faj_file.faj232,   #分攤方式          
                         faj242  LIKE faj_file.faj242    #分攤部門/分攤類別
                        END RECORD,
          sr2           RECORD
                         type   LIKE type_file.chr1,     #年度
                         fbn03  LIKE fbn_file.fbn03,     #年度
                         fbn04  LIKE fbn_file.fbn04,     #月份
                         fbn05  LIKE fbn_file.fbn05,     #分攤方式
                         fbn06  LIKE fbn_file.fbn06,     #部門
                         gem02  LIKE gem_file.gem02,     #部門名稱
                         fbn07  LIKE fbn_file.fbn07,     #折舊金額
                         fbn09  LIKE fbn_file.fbn09,     #被攤部門
                         fbn14  LIKE fbn_file.fbn14,     #成本
                         fbn15  LIKE fbn_file.fbn15,     #累折
                         pre_d  LIKE fbn_file.fbn15,     #前期折舊
                         curr_d LIKE fbn_file.fbn15,     #本期折舊
                         curr   LIKE fbn_file.fbn15,     #本月折舊
                         curr_val LIKE fbn_file.fbn15,   #帳面價值
                         curr_val2 LIKE fbn_file.fbn15,
                         fbn17  LIKE fbn_file.fbn17
                        END RECORD

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#

   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

   CALL s_azn01(tm.yyyy,tm.mm) RETURNING g_bdate,g_edate
   
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')

   LET l_sql = "SELECT '','','',",
               "       faj02,faj022,faj04,faj05,faj06,faj07,faj262,faj292 ",
               "      ,faj142,faj1412,faj592,faj322,faj1012,faj342,faj20,faj232,faj242 ",
               "  FROM faj_file",
               " WHERE ",tm.wc
   PREPARE r270_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r270_cs1 CURSOR FOR r270_prepare1

   #--->取每筆分攤資產折舊
   LET l_sql = " SELECT fbn06 ",
               "  FROM fbn_file ",
               " WHERE fbn01 = ? AND fbn02 = ? ",
               "   AND fbn03 = ", tm.yyyy," AND fbn04=",tm.mm,
               "   AND (fbn041='1' OR fbn041='0') ",   
               "   AND fbn05 = '3' ", 
               "   AND ",tm.wc2
   PREPARE r270_prefbn  FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r270_csfbn CURSOR FOR r270_prefbn   

   FOREACH r270_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF

      LET l_cnt1 = 0   LET l_cnt2 = 0
      LET l_sql = " SELECT COUNT(*) ",
                  "  FROM fbn_file ",
                  " WHERE fbn01 = ? AND fbn02 = ? ",
                  "   AND fbn03 = ? AND fbn04 = ? ",
                  "   AND ",tm.wc2,
                  "   AND (fbn041='1' OR fbn041='0') " 
      CASE
         WHEN tm.a = '1' #--->分攤前
            LET l_sql = l_sql clipped ," AND fbn05 != '3' " CLIPPED
         WHEN tm.a = '2' #--->分攤後
            LET l_sql = l_sql clipped ," AND fbn05 != '2' " CLIPPED
         OTHERWISE EXIT CASE
      END CASE
      PREPARE r270_pcntfbn  FROM l_sql
      DECLARE r270_cscntfbn SCROLL CURSOR FOR r270_pcntfbn
      OPEN r270_cscntfbn USING sr.faj02,sr.faj022,tm.yyyy,tm.mm
      FETCH r270_cscntfbn INTO l_cnt1
      CLOSE r270_cscntfbn
      OPEN r270_cscntfbn USING sr.faj02,sr.faj022,tm.yy1,tm.m1
      FETCH r270_cscntfbn INTO l_cnt2
      CLOSE r270_cscntfbn
      IF cl_null(l_cnt1) THEN LET l_cnt1=0 END IF
      IF cl_null(l_cnt2) THEN LET l_cnt2=0 END IF

      IF l_cnt1 > 0 OR l_cnt2 > 0  THEN
         IF l_cnt1 > 1 OR l_cnt2 > 1 THEN
            FOREACH r270_csfbn USING sr.faj02,sr.faj022 INTO l_fbn06 
               CALL afar270_fbn(sr.*,l_fbn06,'Y')
            END FOREACH
         ELSE
            CALL afar270_fbn(sr.*,'','N')
         END IF
      END IF
   END FOREACH

   LET g_str = '' 
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06') 
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str ,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";"
                         ,tm.c,";",tm.yyyy,";",tm.mm,";",tm.yy1,";",tm.m1 
   IF g_aza.aza26 = '2' THEN
      CALL cl_prt_cs3('afar270','afar270_1',l_sql,g_str)
   ELSE 
      CALL cl_prt_cs3('afar270','afar270',l_sql,g_str)
   END IF 
   #------------------------------ CR (4) ------------------------------#

END FUNCTION

FUNCTION afar270_fbn(sr,p_fbn06,p_flag)
   DEFINE sr            RECORD
                         order1  LIKE faj_file.faj06,
                         order2  LIKE faj_file.faj06,
                         order3  LIKE faj_file.faj06,
                         faj02   LIKE faj_file.faj02,      #財編
                         faj022  LIKE faj_file.faj022,     #附號
                         faj04   LIKE faj_file.faj04,      #主類別
                         faj05   LIKE faj_file.faj05,      #次類別
                         faj06   LIKE faj_file.faj06,      #中文名稱
                         faj07   LIKE faj_file.faj07,      #英文名稱
                         faj262   LIKE faj_file.faj262,    #入帳日期
                         faj292   LIKE faj_file.faj292,    #耐用年限
                         faj142   LIKE faj_file.faj142,    #本幣成本
                         faj1412  LIKE faj_file.faj1412,   #調整成本
                         faj592   LIKE faj_file.faj592,    #銷帳成本
                         faj322   LIKE faj_file.faj322,    #累積折舊
                         faj1012  LIKE faj_file.faj1012,   #已提列減值準備
                         faj342   LIKE faj_file.faj342,    #折畢再提
                         faj20   LIKE faj_file.faj20,      #保管部門
                         faj232   LIKE faj_file.faj232,    #分攤方式
                         faj242   LIKE faj_file.faj242     #分攤部門/分攤類別
                        END RECORD,
          l_fbn03       LIKE fbn_file.fbn03,   #折舊年度
          l_fbn04       LIKE fbn_file.fbn04,   #折舊月份
          l_curr_1      LIKE fbn_file.fbn07,   #本月折舊(資料年月)
          l_curr_2      LIKE fbn_file.fbn07,   #本月折舊(比較年月) 
          l_cost        LIKE fbn_file.fbn14,   #成本
          l_acct_d      LIKE fbn_file.fbn15,   #累折
          l_fbn17       LIKE fbn_file.fbn15,   #減值準備
          l_fbn06       LIKE fbn_file.fbn06,
          l_fbn07       LIKE fbn_file.fbn07,
          l_fbn09       LIKE fbn_file.fbn09,
          l_fab02       LIKE fab_file.fab02, 
          l_gem02       LIKE gem_file.gem02, 
          l_type        LIKE type_file.chr1,
          l_diff        LIKE fbn_file.fbn14,
          l_curr_val    LIKE fbn_file.fbn14,
          l_curr_val2   LIKE fbn_file.fbn14,
          l_difcost     LIKE fbn_file.fbn14,
          p_fbn06       LIKE fbn_file.fbn06,
          p_flag        LIKE type_file.chr1,
          l_sql         STRING          
   DEFINE l_fap932      LIKE fap_file.fap932    #FUN-C90088
   #FUN-C90088--B--
   LET l_sql = " SELECT fap932 FROM fap_file"
              ,"  WHERE fap03 ='9'"
              ,"    AND fap02 = ? AND fap021= ? AND fap04 < ?"
              ,"  ORDER BY fap04 desc"
   PREPARE r270_p01 FROM l_sql
   DECLARE r270_c01 SCROLL CURSOR WITH HOLD FOR r270_p01
   #FUN-C90088--E--

   #成本
   #成本=目前成本+調整成本-銷帳成本-(大於當期(調整)-大於當期(前一次調整))-
   #     大於當期(改良)+大於當期(銷帳成本)
   CALL afar270_cal(sr.faj02,sr.faj022)
   LET l_cost=sr.faj142+sr.faj1412-sr.faj592-(g_fap661-g_fap10)-g_fap54_7+g_fap561

   #本月折舊(資料年月),累計折舊,減值準備
   LET l_curr_1 = 0   LET l_acct_d = 0   LET l_fbn17 = 0
   IF p_flag = 'N' THEN   
      SELECT SUM(fbn07),SUM(fbn15),SUM(fbn17)
        INTO l_curr_1,l_acct_d,l_fbn17
        FROM fbn_file
       WHERE fbn01 = sr.faj02 AND fbn02 = sr.faj022
         AND fbn03 = tm.yyyy AND fbn04 = tm.mm 
         AND fbn041 in ('0','1')
         AND fbn05 in ('1','2')
   ELSE
      LET l_sql = " SELECT fbn07,fbn14,fbn15,fbn17 ",
                  "  FROM fbn_file ",
                  " WHERE fbn01 = ? AND fbn02 = ? ",
                  "   AND fbn03 = ",tm.yyyy," AND fbn04 = ",tm.mm,
                  "   AND (fbn041='1' OR fbn041='0') ",   
                  "   AND fbn05 = '3' ", 
                  "   AND fbn06 = ? " 
      PREPARE r270_pfbn01  FROM l_sql
      DECLARE r270_cfbn01 SCROLL CURSOR FOR r270_pfbn01
      OPEN r270_cfbn01 USING sr.faj02,sr.faj022,p_fbn06
      FETCH r270_cfbn01 INTO l_curr_1,l_cost,l_acct_d,l_fbn17
      CLOSE r270_cfbn01
   END IF       
      
   IF SQLCA.sqlcode OR cl_null(l_curr_1) THEN
      LET l_fbn03 = 0   LET l_fbn04 = 0
      IF sr.faj342 = 'Y' THEN   #折畢再提,不考慮年度往前抓最後一期折舊年月
         IF p_flag = 'N' THEN      
            SELECT MAX(fbn03),MAX(fbn04) INTO l_fbn03,l_fbn04 FROM fbn_file
             WHERE fbn01 = sr.faj02 AND fbn02 = sr.faj022
               AND fbn03*12+fbn04 <= tm.yyyy*12+tm.mm
               AND fbn041 in ('0','1')
               AND fbn05 in ('1','2')
         ELSE
            LET l_sql = " SELECT MAX(fbn03),MAX(fbn04) ",
                        "  FROM fbn_file ",
                        " WHERE fbn01 = ? AND fbn02 = ? ",
                        "   AND fbn03*12+fbn04 <= ",tm.yyyy*12+tm.mm,
                        "   AND (fbn041='1' OR fbn041='0') ",   
                        "   AND fbn05 = '3' ", 
                        "   AND fbn06 = ? " 
            PREPARE r270_pfbn02  FROM l_sql
            DECLARE r270_cfbn02 SCROLL CURSOR FOR r270_pfbn02
            OPEN r270_cfbn02 USING sr.faj02,sr.faj022,p_fbn06
            FETCH r270_cfbn02 INTO l_fbn03,l_fbn04 
            CLOSE r270_cfbn02
         END IF            
      ELSE                    #無折畢再提,抓當年最後一期折舊年月
         IF p_flag = 'N' THEN      
            SELECT MAX(fbn03),MAX(fbn04) INTO l_fbn03,l_fbn04 FROM fbn_file
             WHERE fbn01 = sr.faj02 AND fbn02 = sr.faj022
               AND fbn03 = tm.yyyy  AND fbn04 < tm.mm
               AND fbn041 in ('0','1')
               AND fbn05 in ('1','2')
         ELSE
            LET l_sql = " SELECT MAX(fbn03),MAX(fbn04) ",
                        "  FROM fbn_file ",
                        " WHERE fbn01 = ? AND fbn02 = ? ",
                        "   AND fbn03 = ",tm.yyyy," AND fbn04 < ",tm.mm,
                        "   AND (fbn041='1' OR fbn041='0') ",   
                        "   AND fbn05 = '3' ", 
                        "   AND fbn06 = ? " 
            PREPARE r270_pfbn03  FROM l_sql
            DECLARE r270_cfbn03 SCROLL CURSOR FOR r270_pfbn03
            OPEN r270_cfbn03 USING sr.faj02,sr.faj022,p_fbn06
            FETCH r270_cfbn03 INTO l_fbn03,l_fbn04 
            CLOSE r270_cfbn03
         END IF            
      END IF
      IF cl_null(l_fbn03) THEN LET l_fbn03 = 0 END IF
      IF cl_null(l_fbn04) THEN LET l_fbn04 = 0 END IF

      IF SQLCA.sqlcode OR l_fbn04 = 0 THEN
         IF p_flag = 'N' THEN      
            SELECT MIN(fbn03),MIN(fbn04) INTO l_fbn03,l_fbn04 FROM fbn_file
             WHERE fbn01 = sr.faj02 AND fbn02 = sr.faj022
               AND fbn03*12+fbn04 >= tm.yyyy*12+tm.mm
               AND fbn041 = '0'
               AND fbn05 in ('1','2')
         ELSE
            LET l_sql = " SELECT MIN(fbn03),MIN(fbn04) ",
                        "  FROM fbn_file ",
                        " WHERE fbn01 = ? AND fbn02 = ? ",
                        "   AND fbn03*12+fbn04 >= ",tm.yyyy*12+tm.mm,
                        "   AND fbn041 ='0' ",   
                        "   AND fbn05 = '3' ", 
                        "   AND fbn06 = ? " 
            PREPARE r270_pfbn04  FROM l_sql
            DECLARE r270_cfbn04 SCROLL CURSOR FOR r270_pfbn04
            OPEN r270_cfbn04 USING sr.faj02,sr.faj022,p_fbn06
            FETCH r270_cfbn04 INTO l_fbn03,l_fbn04 
            CLOSE r270_cfbn04
         END IF               
         IF cl_null(l_fbn03) THEN LET l_fbn03 = 0 END IF
         IF cl_null(l_fbn04) THEN LET l_fbn04 = 0 END IF
         IF l_fbn03 != 0 AND l_fbn04 != 0 THEN
            IF p_flag = 'N' THEN         
               #資料年月這個月份前都還沒有開始提列折舊,抓看看有沒有開帳的資料
               SELECT SUM(fbn15),SUM(fbn17) INTO l_acct_d,l_fbn17 FROM fbn_file
                WHERE fbn01 = sr.faj02 AND fbn02 = sr.faj022
                  AND fbn03 = l_fbn03 AND fbn04= l_fbn04
                  AND fbn041= '0'
                  AND fbn05 in ('1','2')
            ELSE
               LET l_sql = " SELECT SUM(fbn15),SUM(fbn17) ",
                           "  FROM fbn_file ",
                           " WHERE fbn01 = ? AND fbn02 = ? ",
                           "   AND fbn03 = ",l_fbn03," AND fbn04 = ",l_fbn04,
                           "   AND fbn041 ='0' ",   
                           "   AND fbn05 = '3' ", 
                           "   AND fbn06 = ? " 
               PREPARE r270_pfbn05  FROM l_sql
               DECLARE r270_cfbn05 SCROLL CURSOR FOR r270_pfbn05
               OPEN r270_cfbn05 USING sr.faj02,sr.faj022,p_fbn06
               FETCH r270_cfbn05 INTO l_acct_d,l_fbn17 
               CLOSE r270_cfbn05
            END IF
		 END IF
      ELSE
         IF p_flag = 'N' THEN      
            SELECT SUM(fbn15),SUM(fbn17) INTO l_acct_d,l_fbn17 FROM fbn_file
             WHERE fbn01 = sr.faj02 AND fbn02 = sr.faj022
               AND fbn03 = l_fbn03 AND fbn04= l_fbn04
               AND fbn05 in ('1','2')
         ELSE
            LET l_sql = " SELECT SUM(fbn15),SUM(fbn17) ",
                        "  FROM fbn_file ",
                        " WHERE fbn01 = ? AND fbn02 = ? ",
                        "   AND fbn03 = ",l_fbn03," AND fbn04 = ",l_fbn04,
                        "   AND fbn05 = '3' ", 
                        "   AND fbn06 = ? " 
            PREPARE r270_pfbn06  FROM l_sql
            DECLARE r270_cfbn06 SCROLL CURSOR FOR r270_pfbn06
            OPEN r270_cfbn06 USING sr.faj02,sr.faj022,p_fbn06
            FETCH r270_cfbn06 INTO l_acct_d,l_fbn17 
            CLOSE r270_cfbn06
         END IF               
      END IF
   END IF 
   IF cl_null(l_curr_1) THEN LET l_curr_1 = 0 END IF
   IF cl_null(l_acct_d) THEN LET l_acct_d = 0 END IF
   IF cl_null(l_fbn17)  THEN LET l_fbn17 = 0  END IF

   #本月折舊(比較年月)
   LET l_curr_2 = 0
   IF p_flag = 'N' THEN   
      SELECT SUM(fbn07) INTO l_curr_2 FROM fbn_file
       WHERE fbn01 = sr.faj02 AND fbn02 = sr.faj022
         AND fbn03 = tm.yy1 AND fbn04 = tm.m1
         AND fbn041 in ('0','1')
         AND fbn05 in ('1','2')
   ELSE
      LET l_sql = " SELECT fbn07 ",
                  "  FROM fbn_file ",
                  " WHERE fbn01 = ? AND fbn02 = ? ",
                  "   AND fbn03 = ",tm.yy1," AND fbn04 = ",tm.m1,
                  "   AND (fbn041='1' OR fbn041='0') ",   
                  "   AND fbn05 = '3' ", 
                  "   AND fbn06 = ? " 
      PREPARE r270_pfbn07  FROM l_sql
      DECLARE r270_cfbn07 SCROLL CURSOR FOR r270_pfbn07
      OPEN r270_cfbn07 USING sr.faj02,sr.faj022,p_fbn06
      FETCH r270_cfbn07 INTO l_curr_2 
      CLOSE r270_cfbn07
   END IF         
   IF cl_null(l_curr_2) THEN LET l_curr_2 = 0 END IF

   #-->差異(資料年月)(比較年月)
   LET l_diff = l_curr_1 - l_curr_2
   IF l_diff < 0 THEN
      LET l_difcost = l_diff * -1
   ELSE
      LET l_difcost = l_diff
   END IF

   #帳面價值
   LET l_curr_val = l_cost - l_acct_d

   #資產淨額
   LET l_curr_val2= l_curr_val - l_fbn17

   IF l_difcost >= tm.difcost THEN
      #主類別名稱
      SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
      IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF

      #部門
      IF sr.faj232 = '1' THEN
         LET l_fbn06 = sr.faj242   # 單一部門  -> 折舊部門
      ELSE
         LET l_fbn06 = p_fbn06    # 多部門分攤-> 保管部門
      END IF
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_fbn06

      LET l_type=' '
      LET l_fbn07=0
      LET l_fbn09=0

     #CHI-C60010---str---
      SELECT aaa03 INTO g_faj143 FROM aaa_file
       WHERE aaa01 = g_faa.faa02c
      IF NOT cl_null(g_faj143) THEN
       SELECT azi04,azi05 INTO g_azi04_1,g_azi05_1 FROM azi_file
        WHERE azi01 = g_faj143
      END IF
     #CHI-C60010---end---
      #FUN-C90088--B--
      #耐用年限回溯
      LET l_fap932 = ""
      OPEN r270_c01 USING sr.faj02 ,sr.faj022,g_edate
      FETCH FIRST r270_c01 INTO l_fap932
      IF NOT cl_null(l_fap932) THEN LET sr.faj292 = l_fap932 END IF
      #FUN-C90088--E--  

      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
      EXECUTE insert_prep USING 
         sr.faj02,sr.faj022,sr.faj04,sr.faj05  ,sr.faj06,
         sr.faj07,sr.faj262 ,sr.faj292,l_type    ,l_fbn03,
         l_fbn04 ,sr.faj232 ,l_fbn06 ,l_gem02   ,l_fbn07,
         l_fbn09 ,l_cost   ,l_acct_d,l_curr_val,l_curr_val2,
         l_curr_1,l_curr_2 ,l_diff  ,l_fab02   ,
         #g_azi04,g_azi05       #CHI-C60010 mark
         g_azi04_1,g_azi05_1    #CHI-C60010
      #------------------------------ CR (3) ------------------------------#
   END IF
END FUNCTION

FUNCTION afar270_cal(p_faj02,p_faj022)
   DEFINE p_faj02      LIKE faj_file.faj02,
          p_faj022     LIKE faj_file.faj022 

   LET g_fap661  = 0 
   LET g_fap10   = 0  
   LET g_fap54_7 = 0
   LET g_fap561  = 0 
   LET g_fap57   = 0 

   #----調整(金額)
   SELECT SUM(fap661),SUM(fap10) INTO g_fap661,g_fap10 FROM fap_file
    WHERE fap03 = '9'
      AND fap02 = p_faj02 AND fap021 = p_faj022
      AND fap04 > g_edate
   #----改良(金額)
   SELECT SUM(fap54) INTO g_fap54_7 FROM fap_file
    WHERE fap03 = '7'
      AND fap02 = p_faj02 AND fap021 = p_faj022
      AND fap04 > g_edate
   #----銷帳成本
   SELECT SUM(fap56) INTO g_fap561 FROM fap_file
    WHERE fap03 in ('4','5','6','7','8','9')
      AND fap02 = p_faj02 AND fap021 = p_faj022
      AND fap04 > g_edate
   #----銷帳累折
   SELECT SUM(fap57) INTO g_fap57 FROM fap_file
    WHERE fap03 in ('2','4','5','6')
      AND fap02 = p_faj02 AND fap021 = p_faj022
      AND fap04 BETWEEN g_bdate AND g_edate

   IF cl_null(g_fap661)  THEN LET g_fap661 = 0  END IF
   IF cl_null(g_fap10)   THEN LET g_fap10 = 0   END IF
   IF cl_null(g_fap54_7) THEN LET g_fap54_7 = 0 END IF
   IF cl_null(g_fap561)  THEN LET g_fap561 = 0  END IF
   IF cl_null(g_fap57)   THEN LET g_fap57 = 0   END IF
   
END FUNCTION

#Patch....NO:FUN-BB0046 <> #
