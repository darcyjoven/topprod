# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: afar260.4gl
# Desc/riptions..: 固定資產財簽二折舊費用兩期比較彙總表
# Date & Author..: 12/01/11 FUN-BB0046 By Sakura

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item    LIKE type_file.num5
END GLOBALS

    DEFINE tm  RECORD                           # Print condition RECORD
                wc      STRING,                 # Where condition
                wc2     STRING,                 # Where condition
                yyyy    LIKE type_file.num5,                 # 資料年度
                mm      LIKE type_file.num5,                 # 資料月份
                yy1     LIKE type_file.num5,                 # 比較年度
                m1      LIKE type_file.num5,                 # 比較月份
                difcost LIKE type_file.num5,                 # 差異金額大於
                a       LIKE type_file.chr1,
                s       LIKE type_file.chr3,                  # Order by sequence
                t       LIKE type_file.chr3,                  # Eject sw
                c       LIKE type_file.chr3,                  # subtotal
                more    LIKE type_file.chr1                   # Input more condition(Y/N)
                END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20   # Report Heading & prompt
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE   g_head1         LIKE type_file.chr1000
DEFINE   l_table     STRING 
DEFINE   g_sql       STRING 
DEFINE   g_str       STRING 


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

   LET g_sql = "order1.faj_file.faj06,",    
               "order2.faj_file.faj06, ", 
               "faj02.faj_file.faj02,  ",    #財編
               "faj022.faj_file.faj022,",    #附號
               "faj04.faj_file.faj04,  ",    #主類別
               "faj05.faj_file.faj05,  ",    #次類別
               "faj06.faj_file.faj06,  ",    #中文名稱
               "faj07.faj_file.faj07,  ",    #英文名稱
               "type.type_file.chr1,   ",    
               "fbn03.fbn_file.fbn03,  ",    #年度
               "fbn04.fbn_file.fbn04,  ",    #月份
               "fbn05.fbn_file.fbn05,  ",    #分攤方式
               "fbn06.fbn_file.fbn06,  ",    #部門
               "fbn07.fbn_file.fbn07,  ",    #折舊金額
               "fbn09.fbn_file.fbn09,  ",    #被攤部門
               "fbn14.fbn_file.fbn14,  ",    #成本
               "fbn15.fbn_file.fbn15,  ",    #累折
               "pre_d.fbn_file.fbn15,  ",    #前期折舊
               "curr_d.fbn_file.fbn15, ",    #本期折舊
               "curr.fbn_file.fbn15,   ",    #本月折舊
               "curr_val.fbn_file.fbn15,",   #帳面價值
               "curr_val2.fbn_file.fbn15,",
               "fbn17.fbn_file.fbn17,   ",
               "fab02.fab_file.fab02,   ",
               "gem02.gem_file.gem02,   ",
               "azi03.azi_file.azi03,   ",
               "azi04.azi_file.azi04,   ",
               "azi05.azi_file.azi05    "

   LET l_table = cl_prt_temptable('afar260',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
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
      THEN CALL r260_tm(0,0)            # Input print condition
      ELSE CALL afar260()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r260_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,
            l_cmd         LIKE type_file.chr1000,
            lc_qbe_sn     LIKE gbm_file.gbm01

   LET p_row = 4 LET p_col = 16

   OPEN WINDOW r260_w AT p_row,p_col WITH FORM "afa/42f/afar260"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.a    = '1'
   LET tm.s    = '12'
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
         LET INT_FLAG = 0 CLOSE WINDOW r260_w 
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
         LET INT_FLAG = 0 CLOSE WINDOW r260_w 
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
         LET INT_FLAG = 0 CLOSE WINDOW r260_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar260'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar260','9031',1)
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
            CALL cl_cmdat('afar260',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r260_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar260()
      ERROR ""
   END WHILE

   CLOSE WINDOW r260_w
END FUNCTION
 
FUNCTION afar260()
   DEFINE l_sql         STRING,               # RDSQL STATEMENT
          l_order       ARRAY[6] OF   LIKE faj_file.faj06,
          sr            RECORD order1 LIKE faj_file.faj06,
                               order2 LIKE faj_file.faj06,
                               faj02  LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,   #附號
                               faj04  LIKE faj_file.faj04,    #主類別
                               faj05  LIKE faj_file.faj05,    #次類別
                               faj06  LIKE faj_file.faj06,    #中文名稱
                               faj07  LIKE faj_file.faj07     #英文名稱
                        END RECORD,
          sr2           RECORD
                               type      LIKE type_file.chr1,    #年度
                               fbn03     LIKE fbn_file.fbn03,    #年度
                               fbn04     LIKE fbn_file.fbn04,    #月份
                               fbn05     LIKE fbn_file.fbn05,    #分攤方式
                               fbn06     LIKE fbn_file.fbn06,    #部門
                               fbn07     LIKE fbn_file.fbn07,    #折舊金額
                               fbn09     LIKE fbn_file.fbn09,    #被攤部門
                               fbn14     LIKE fbn_file.fbn14,    #成本
                               fbn15     LIKE fbn_file.fbn15,    #累折
                               pre_d     LIKE fbn_file.fbn15,    #前期折舊
                               curr_d    LIKE fbn_file.fbn15,    #本期折舊
                               curr      LIKE fbn_file.fbn15,    #本月折舊
                               curr_val  LIKE fbn_file.fbn15,    #帳面價值
                               curr_val2 LIKE fbn_file.fbn15,
                               fbn17     LIKE fbn_file.fbn17
                        END RECORD
     DEFINE l_fab02           LIKE fab_file.fab02,
            l_gem02           LIKE gem_file.gem02 

     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'afar260'

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')


     LET l_sql = "SELECT '','',faj02,faj022,faj04,faj05,faj06,faj07 ",
                 " FROM faj_file",
                 " WHERE ",tm.wc
     PREPARE r260_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
           
     END IF
     DECLARE r260_cs1 CURSOR FOR r260_prepare1

     #--->取每筆資產本年度月份折舊(資料年月)
     LET l_sql = " SELECT '1',fbn03, fbn04, fbn05, fbn06,  fbn07,",
                 " fbn09, fbn14, fbn15,0,fbn08,0,0,0,fbn17 ",
                 " FROM fbn_file ",
                 " WHERE fbn01 = ? AND fbn02 = ? ",
                 "   AND fbn03 = ", tm.yyyy," AND fbn04=",tm.mm,
                 "   AND (fbn041 = '1' OR fbn041 = '0') ",
                 "   AND ",tm.wc2
     CASE
       WHEN tm.a = '1' #--->分攤前
        LET l_sql = l_sql clipped ," AND fbn05 != '3' " clipped
       WHEN tm.a = '2' #--->分攤後
        LET l_sql = l_sql clipped ," AND fbn05 != '2' " clipped
       OTHERWISE EXIT CASE
     END CASE
     PREPARE r260_prefbn  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
           
     END IF
     DECLARE r260_csfbn CURSOR FOR r260_prefbn

     #--->取每筆資產本年度月份折舊(比較年月)
     LET l_sql = " SELECT '2',fbn03, fbn04, fbn05, fbn06, fbn07,",
                 " fbn09, fbn14, fbn15,0,fbn08,0,0,0,fbn17 ",
                 " FROM fbn_file ",
                 " WHERE fbn01 = ? AND fbn02 = ? ",
                 "   AND fbn03 = ", tm.yy1," AND fbn04=",tm.m1,
                 "   AND (fbn041 = '1' OR fbn041 = '0') ",
                 "   AND ",tm.wc2
     CASE
       WHEN tm.a = '1' #--->分攤前
        LET l_sql = l_sql clipped ," AND fbn05 != '3' " clipped
       WHEN tm.a = '2' #--->分攤後
        LET l_sql = l_sql clipped ," AND fbn05 != '2' " clipped
       OTHERWISE EXIT CASE
     END CASE

     PREPARE r260_prefbn2  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
           
     END IF
     DECLARE r260_csfbn2 CURSOR FOR r260_prefbn2

     LET g_pageno = 0

     FOREACH r260_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       #--->篩選部門(資料年月)
       FOREACH r260_csfbn
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r260_csfbn:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr2.fbn07) THEN LET sr2.fbn07 = 0 END IF
          #--->本月折舊
          LET sr2.curr = sr2.fbn07
          IF cl_null(sr2.curr) THEN LET sr2.curr = 0 END IF

          SELECT SUM(fbn15),SUM(fbn17)
            INTO sr2.fbn15,sr2.fbn17   FROM fbn_file
           WHERE fbn01 = sr.faj02
             AND fbn02 = sr.faj022
             AND fbn03 = sr2.fbn03
             AND fbn04 = sr2.fbn04
             AND fbn06 = sr2.fbn06
          IF cl_null(sr2.fbn15) THEN LET sr2.fbn15 = 0 END IF
          IF cl_null(sr2.fbn17) THEN LET sr2.fbn17 = 0 END IF
          #--->前期折舊 = (累折 - 本期折舊)
          LET sr2.pre_d   = sr2.fbn15 - sr2.curr_d
          IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
          #--->帳面價值 = (成本 - 累折)
          LET sr2.curr_val = sr2.fbn14-sr2.fbn15
          IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
          #--->資產淨額 = (帳面價值 - 減值準備)
          LET sr2.curr_val2 = sr2.curr_val - sr2.fbn17
          IF cl_null(sr2.curr_val2) THEN LET sr2.curr_val2 = 0 END IF
          
           FOR g_i = 1 TO 2
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                                          LET g_descripe[g_i]=g_x[15]
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
                                          LET g_descripe[g_i]=g_x[16]
                 OTHERWISE LET l_order[g_i] = '-'
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]

          #-->主類別名稱
          SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
          IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
          #-->部門名稱
          SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr2.fbn06
          IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF

          EXECUTE insert_prep USING
                  sr.order1,sr.order2,sr.faj02,sr.faj022,
                  sr.faj04,sr.faj05,sr.faj06,sr.faj07,
                  sr2.type,sr2.fbn03,sr2.fbn04,sr2.fbn05,sr2.fbn06,sr2.fbn07,
                  sr2.fbn09,sr2.fbn14,sr2.fbn15,sr2.pre_d,sr2.curr_d,sr2.curr,
                  sr2.curr_val,sr2.curr_val2,sr2.fbn17,
                  l_fab02,l_gem02,g_azi03,g_azi04,g_azi05
       END FOREACH

       #--->篩選部門(比較年月)
       FOREACH r260_csfbn2
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r260_csfbn:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr2.fbn07) THEN LET sr2.fbn07 = 0 END IF
          LET sr2.curr = sr2.fbn07
           FOR g_i = 1 TO 2
            CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj04
                                          LET g_descripe[g_i]=g_x[15]
                 WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj05
                                          LET g_descripe[g_i]=g_x[16]
                 WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
                                          LET g_descripe[g_i]=g_x[17]
                 WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
                                          LET g_descripe[g_i]=g_x[21]
                 WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj06
                                          LET g_descripe[g_i]=g_x[18]
                 WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr2.fbn06
                                          LET g_descripe[g_i]=g_x[19]
                 OTHERWISE LET l_order[g_i] = '-'
            END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]

         #-->主類別名稱
         SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01=sr.faj04
         IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
         #-->部門名稱
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr2.fbn06
         IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF

         EXECUTE insert_prep USING
                 sr.order1,sr.order2,sr.faj02,sr.faj022,
                 sr.faj04,sr.faj05,sr.faj06,sr.faj07,
                 sr2.type,sr2.fbn03,sr2.fbn04,sr2.fbn05,sr2.fbn06,sr2.fbn07,
                 sr2.fbn09,sr2.fbn14,sr2.fbn15,sr2.pre_d,sr2.curr_d,sr2.curr,
                 sr2.curr_val,sr2.curr_val2,sr2.fbn17,
                 l_fab02,l_gem02,g_azi03,g_azi04,g_azi05
       END FOREACH
    END FOREACH

    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06')
            RETURNING tm.wc
       CALL cl_wcchp(tm.wc2,'fbn06')
            RETURNING tm.wc2
       LET g_str = tm.wc CLIPPED,' ',tm.wc2
    ELSE
       LET g_str = " "
    END IF 

    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 

    #            p1          p2          p3        p4         p5
    LET g_str = g_str,";",tm.yyyy,";",tm.mm,";",tm.yy1,";",tm.m1,";",
    #                        p6          p7            p8       
                          tm.difcost,";",tm.s[1,1],";",tm.s[2,2],";",
    #                        p9          p10         
                          tm.t,";",tm.c
    CALL cl_prt_cs3('afar260','afar260',g_sql,g_str)

END FUNCTION

#Patch....NO:FUN-BB0046 <> #
