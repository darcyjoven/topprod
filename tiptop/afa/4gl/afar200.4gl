# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: afar200.4gl
# Desc/riptions...: 固定資產財簽二折舊費用明細表
# Date & Author..: 11/09/02 FUN-B80134 By Sakura
# Modify.........: No:MOD-C50193 12/06/07 By Polly 當月有提折舊且做銷帳，也需列印出來
# Modify.........: No.CHI-C60010 12/06/14 By wangrr 財簽二欄位需依財簽二幣別做取位
   
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
                s       LIKE type_file.chr3,                  # Order by sequence
                t       LIKE type_file.chr3,                  # Eject sw
                c       LIKE type_file.chr3,                  # subtotal
                a       LIKE type_file.chr1,                  # 1.明細 2.彙總
                b       LIKE type_file.chr1,                  # 1.管理部門 2.被分攤部門
                more    LIKE type_file.chr1                   # Input more condition(Y/N)
                END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20   # Report Heading & prompt
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
DEFINE   g_head1         LIKE type_file.chr1000
DEFINE   l_table         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING

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
   LET g_sql = "faj02.faj_file.faj02,",
               "faj022.faj_file.faj022,",
               "faj04.faj_file.faj04,",
               "faj05.faj_file.faj05,",
               "faj06.faj_file.faj06,",
               "faj07.faj_file.faj07,",
               "faj142.faj_file.faj142,",
               "faj20.faj_file.faj20,",
               "faj232.faj_file.faj232,",
               "faj242.faj_file.faj242,",
               "faj262.faj_file.faj262,",
               "faj292.faj_file.faj292,",
               "fbn03.fbn_file.fbn03,",
               "fbn04.fbn_file.fbn04,",
               "fbn05.fbn_file.fbn05,",
               "fbn06.fbn_file.fbn06,",
               "fbn07.fbn_file.fbn07,",
               "fbn09.fbn_file.fbn09,",
               "fbn14.fbn_file.fbn14,",
               "fbn15.fbn_file.fbn15,",
               "pre_d.fbn_file.fbn15,",
               "curr_d.fbn_file.fbn15,",
               "curr.fbn_file.fbn15,",
               "curr_val.fbn_file.fbn15,",
               "cost.fbn_file.fbn15,",
               "fbn17.fbn_file.fbn17"
   LET l_table = cl_prt_temptable('afar200',g_sql) CLIPPED                                                                          
   IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                          
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                              
             " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                           
             "        ?,?,?,?,?, ?,?,?,?,?,",                                                                                           
             "        ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                              
   END IF                                 

   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.yyyy  = ARG_VAL(9)
   LET tm.mm    = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)
   LET tm.t  = ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)
   LET tm.a  = ARG_VAL(14)
   LET tm.b  = ARG_VAL(15)
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)

   IF cl_null(g_bgjob) OR g_bgjob = 'N' # If background job sw is off
      THEN CALL r200_tm(0,0)            # Input print condition
      ELSE CALL afar200()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r200_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,
            l_cmd         LIKE type_file.chr1000,
            lc_qbe_sn     LIKE gbm_file.gbm01

   LET p_row = 4 LET p_col = 14

   OPEN WINDOW r200_w AT p_row,p_col WITH FORM "afa/42f/afar200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '123'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.a    = '1'
   LET tm.b    = '1'
   LET tm.yyyy = g_faa.faa072
   LET tm.mm   = g_faa.faa082
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
         LET INT_FLAG = 0 CLOSE WINDOW r200_w 
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
         LET INT_FLAG = 0 CLOSE WINDOW r200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      INPUT BY NAME
            tm.yyyy,tm.mm,tm.a,tm.b,tm2.s1,tm2.s2,tm2.s3,
            tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.more
            WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN
               NEXT FIELD mm
            END IF
            
         AFTER FIELD a
            IF tm.a NOT MATCHES "[12]" OR tm.a IS NULL THEN
               NEXT FIELD a
            ELSE
               IF tm.a = '1' THEN 
                  LET tm.b = '1' 
               END IF
               IF tm.a = '2' THEN 
                  LET tm.b = '2' 
               END IF
               DISPLAY BY NAME tm.b
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
            
         ON ACTION CONTROLR
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
         LET INT_FLAG = 0 CLOSE WINDOW r200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar200'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar200','9031',1)
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
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.c CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_rpt_name CLIPPED,"'"
            CALL cl_cmdat('afar200',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar200()
      ERROR ""
   END WHILE

   CLOSE WINDOW r200_w
END FUNCTION

FUNCTION afar200()
   DEFINE l_name        LIKE type_file.chr20,                 # External(Disk) file name
          l_sql         STRING,
          l_chr         LIKE type_file.chr1,
          l_flag        LIKE type_file.chr1,
          l_za05        LIKE type_file.chr1000,
          l_order       ARRAY[6] OF LIKE faj_file.faj06,
          sr            RECORD order1 LIKE faj_file.faj06,
                               order2 LIKE faj_file.faj06,
                               order3 LIKE faj_file.faj06,
                               faj02  LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,   #附號
                               faj04  LIKE faj_file.faj04,    #主類別
                               faj05  LIKE faj_file.faj05,    #次類別
                               faj06  LIKE faj_file.faj06,    #中文名稱
                               faj07  LIKE faj_file.faj07,    #英文名稱
                               faj142  LIKE faj_file.faj142,
                               faj20  LIKE faj_file.faj20,    #保管部門
                               faj232  LIKE faj_file.faj232,    #分攤方式
                               faj242  LIKE faj_file.faj242,    #分攤部門(類別)
                               faj262  LIKE faj_file.faj262,    #入帳日期
                               faj292  LIKE faj_file.faj292     #耐用年限
                        END RECORD,
          sr2           RECORD
                               fbn03    LIKE fbn_file.fbn03,    #年度
                               fbn04    LIKE fbn_file.fbn04,    #月份
                               fbn05    LIKE fbn_file.fbn05,    #分攤方式
                               fbn06    LIKE fbn_file.fbn06,    #部門
                               fbn07    LIKE fbn_file.fbn07,    #折舊金額
                               fbn09    LIKE fbn_file.fbn09,    #被攤部門
                               fbn14    LIKE fbn_file.fbn14,    #成本
                               fbn15    LIKE fbn_file.fbn15,    #累折
                               pre_d    LIKE fbn_file.fbn15,    #前期折舊
                               curr_d   LIKE fbn_file.fbn15,    #本期折舊
                               curr     LIKE fbn_file.fbn15,    #本月折舊
                               curr_val LIKE fbn_file.fbn15,    #帳面價值
                               cost     LIKE fbn_file.fbn15,
                               fbn17    LIKE fbn_file.fbn17
                        END RECORD
   DEFINE l_i,l_cnt     LIKE type_file.num5
   DEFINE l_zaa02       LIKE zaa_file.zaa02
   DEFINE l_fbn03       LIKE type_file.chr4
   DEFINE l_fbn04       LIKE type_file.chr2
   DEFINE l_fbn03_fbn04 LIKE type_file.chr6
   DEFINE l_faj272       LIKE type_file.chr6
   DEFINE l_count       LIKE type_file.num5
   DEFINE l_azi04  LIKE azi_file.azi04   #CHI-C60010 add
   DEFINE l_azi05  LIKE azi_file.azi05   #CHI-C60010 add
  #-------------------MOD-C50193--------------(S)
   DEFINE l_faj27       LIKE type_file.chr6
   DEFINE l_adj_fbn07   LIKE fbn_file.fbn07,
          l_adj_fbn07_1 LIKE fbn_file.fbn07,
          l_adj_fap54   LIKE fap_file.fap54,
          l_curr_fbn07  LIKE fbn_file.fbn07,
          l_pre_fbn15   LIKE fbn_file.fbn15
  #-------------------MOD-C50193--------------(E)

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_del_data(l_table)

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')

    #LET l_faj272 = tm.yyyy||(tm.mm USING '&&')    #MOD-C50193 mark
     LET l_faj27  = tm.yyyy||(tm.mm USING '&&')    #MOD-C50193 add
     LET l_faj272 = tm.yyyy||tm.mm                 #MOD-C50193 add

     LET l_sql = "SELECT '','','',",
                 " faj02,faj022,faj04,faj05,faj06,faj07,faj142,faj20,",
                 " faj232,faj242,faj262,faj292",
                 " FROM faj_file",
                 " WHERE ",tm.wc CLIPPED,
                 " AND fajconf = 'Y'",
                 " AND faj282 <> '0'",
                #" AND faj272 <= '",l_faj272,"'",                     #MOD-C50193 mark
                 " AND faj272 <= '",l_faj27,"'",                      #MOD-C50193 add
                 " AND (faj02 NOT IN (SELECT fap02 FROM fap_file ",
                 "      WHERE (YEAR(fap04)||MONTH(fap04)) <= '",l_faj272,"'",       
                 "      AND fap772 IN ('5','6') ",
                 "      AND fap021 = faj022) ",
                 "      OR faj02 IN (SELECT fbn01 FROM fbn_file ",
                 "      WHERE fbn03 = ",tm.yyyy," AND fbn04 = ",tm.mm,
                 "        AND fbn07 > 0 AND fbn02 =faj022)) "
     PREPARE r200_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r200_cs1 CURSOR FOR r200_prepare1

     #--->取每筆資產本年度月份折舊
     LET l_sql = " SELECT fbn03, fbn04, fbn05, fbn06, fbn07,",
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
     PREPARE r200_prefbn  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r200_csfbn CURSOR FOR r200_prefbn

     LET l_sql = "SELECT SUM(fbn15),SUM(fbn17) FROM fbn_file ",
                 " WHERE fbn01 = ? AND fbn02 = ? ",
                 "   AND fbn03 = ", tm.yyyy," AND fbn04=",tm.mm,
                 "   AND (fbn041 = '1' OR fbn041 = '0')",
                 "   AND fbn06 = ? "
     CASE
        WHEN tm.a = '1' #--->分攤前
           LET l_sql = l_sql CLIPPED ," AND fbn05 != '3' " CLIPPED
        WHEN tm.a = '2' #--->分攤後
           LET l_sql = l_sql CLIPPED ," AND fbn05 != '2' " CLIPPED
        OTHERWISE EXIT CASE
     END CASE
     PREPARE r200_presum FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('presum:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE r200_cssum CURSOR FOR r200_presum

     IF g_aza.aza26 = '2' THEN
        LET l_name = 'afar200'
     ELSE
        LET l_name = 'afar200_1'
     END IF

     FOREACH r200_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_flag = 'Y'

      #上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT count(*) INTO l_count FROM fap_file
        WHERE fap02=sr.faj02 AND fap021=sr.faj022  
          AND fap772 IN ('5','6') 
         #AND (YEAR(fap04)||MONTH(fap04)) <= l_faj272    #MOD-C50193 mark
          AND (YEAR(fap04)||MONTH(fap04)) < l_faj272     #MOD-C50193 add
     #--------------------MOD-C50193------------------------(M)
     ##上線前已銷帳者，應不可印出
     # IF l_count=0 THEN
     #    SELECT COUNT(*) INTO l_count FROM faj_file
     #     WHERE faj02=sr.faj02 AND faj022=sr.faj022
     #       AND faj432='6' 
     #       AND (YEAR(faj100)||MONTH(faj100)) <= l_faj272
     # END IF
     #--------------------MOD-C50193------------------------(M)
       IF l_count > 0 THEN 
          CONTINUE FOREACH 
       END IF
       #--->篩選部門
       INITIALIZE sr2.* TO NULL
       FOREACH r200_csfbn USING sr.faj02,sr.faj022
          INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r200_csfbn:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET l_flag = 'N'
          OPEN r200_cssum USING sr.faj02,sr.faj022,sr2.fbn06
          FETCH r200_cssum INTO sr2.fbn15,sr2.fbn17

          IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF
          IF cl_null(sr2.fbn07) THEN LET sr2.fbn07 = 0 END IF
          IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
          IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
          IF cl_null(sr2.fbn14) THEN LET sr2.fbn14 = 0 END IF
          IF cl_null(sr2.fbn15) THEN LET sr2.fbn15 = 0 END IF
          IF cl_null(sr2.fbn17) THEN LET sr2.fbn17 = 0 END IF
         #---------------------------MOD-C50193---------------------(S)
          CALL r200_chk_adj(sr.faj02,sr.faj022,sr2.fbn15,tm.mm)
             RETURNING l_adj_fbn07,l_adj_fbn07_1,l_adj_fap54
          LET sr2.fbn07 = sr2.fbn07 + l_adj_fbn07_1
          LET sr2.fbn15 = sr2.fbn15
          LET sr2.curr_d = sr2.curr_d
          LET sr2.fbn14 = sr2.fbn14
         #---------------------------MOD-C50193---------------------(E)
          #--->本月折舊
          LET sr2.curr = sr2.fbn07
          #--->前期折舊 = (累折 - 本期累折)
          IF YEAR(sr.faj262) = tm.yyyy AND MONTH(sr.faj262) = tm.mm THEN
             LET sr2.pre_d = 0
          ELSE
                LET sr2.pre_d = sr2.fbn15 - sr2.curr_d       
          END IF
          
          #--->帳面價值 = (成本 - 累積折舊)
          LET sr2.curr_val = sr2.fbn14-sr2.fbn15
          #--->資產淨額 = (帳面價值 - 減值準備)
          LET sr2.cost = sr2.curr_val - sr2.fbn17
          
          EXECUTE insert_prep USING
             sr.faj02, sr.faj022, sr.faj04, sr.faj05,    sr.faj06,
             sr.faj07, sr.faj142,  sr.faj20, sr.faj232,    sr.faj242,
             sr.faj262, sr.faj292,  sr2.fbn03,sr2.fbn04,   sr2.fbn05,
             sr2.fbn06,sr2.fbn07, sr2.fbn09,sr2.fbn14,   sr2.fbn15,
             sr2.pre_d,sr2.curr_d,sr2.curr, sr2.curr_val,sr2.cost,
             sr2.fbn17
       END FOREACH
       
       IF l_flag ='Y' THEN
          #--->若已折畢,抓取每筆資產最後一次折舊資料
          LET l_sql = " SELECT MAX(fbn03*100+fbn04) FROM fbn_file ",
                      " WHERE fbn01 = ? AND fbn02 = ?",
                      "   AND (fbn041 = '1' OR fbn041 = '0') ",
                      "   AND (fbn03*100+fbn04) < ?",                                   #MOD-C50193 add
                      "   AND ",tm.wc2
          PREPARE pre_fbn03_fbn04 FROM l_sql
         #EXECUTE pre_fbn03_fbn04 USING sr.faj02,sr.faj022 INTO l_fbn03_fbn04           #MOD-C50193 mark
          EXECUTE pre_fbn03_fbn04 USING sr.faj02,sr.faj022,l_faj27 INTO l_fbn03_fbn04   #MOD-C50193 add
          LET l_fbn03 = l_fbn03_fbn04[1,4]
          LET l_fbn04 = l_fbn03_fbn04[5,6]
 
          IF l_fbn03 = tm.yyyy THEN
             LET l_sql = " SELECT fbn03, fbn04, fbn05, fbn06, 0,",
                         " fbn09, fbn14, fbn15,0,fbn08,0,0,0,fbn17 "
          ELSE
             LET l_sql = " SELECT fbn03, fbn04, fbn05, fbn06, 0,",
                         " fbn09, fbn14, fbn15,fbn08,0,0,0,0,fbn17 "
          END IF
 
          LET l_sql = l_sql CLIPPED,
                      " FROM fbn_file ",
                      " WHERE fbn01 = ? AND fbn02 = ? ",
                      "   AND fbn03 = ? AND fbn04 = ? ",
                      "   AND (fbn041 = '1' OR fbn041 = '0') ",
                      "   AND ",tm.wc2
          CASE
             WHEN tm.a = '1' #--->分攤前
                LET l_sql = l_sql clipped ," AND fbn05 != '3' " clipped
             WHEN tm.a = '2' #--->分攤後
                LET l_sql = l_sql clipped ," AND fbn05 != '2' " clipped
             OTHERWISE EXIT CASE
          END CASE
          PREPARE r200_prefbn2  FROM l_sql
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time
             EXIT PROGRAM
          END IF
          DECLARE r200_csfbn2 CURSOR FOR r200_prefbn2

          FOREACH r200_csfbn2 USING sr.faj02,sr.faj022,l_fbn03,l_fbn04
             INTO sr2.*
             IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF
             IF cl_null(sr2.fbn07) THEN LET sr2.fbn07 = 0 END IF
             IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF
             IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF
             IF cl_null(sr2.fbn14) THEN LET sr2.fbn14 = 0 END IF
             IF cl_null(sr2.fbn15) THEN LET sr2.fbn15 = 0 END IF
             IF cl_null(sr2.fbn17) THEN LET sr2.fbn17 = 0 END IF
            #---------------------------MOD-C50193---------------------(S)
             LET l_adj_fbn07 = 0
             LET l_adj_fap54 = 0
             CALL r200_chk_adj(sr.faj02,sr.faj022,sr2.fbn15,l_fbn04)
                RETURNING l_adj_fbn07,l_adj_fbn07_1,l_adj_fap54
             LET sr2.fbn15 = sr2.fbn15 + l_adj_fbn07
             LET sr2.fbn07 = sr2.fbn07 + l_adj_fbn07_1
             LET sr2.curr_d = sr2.curr_d + l_adj_fbn07
             LET sr2.fbn14 = sr2.fbn14 + l_adj_fap54
            #---------------------------MOD-C50193---------------------(E)
             #--->本月折舊
             LET sr2.curr = sr2.fbn07
             #--->前期折舊 = (累折 - 本期累折)
             IF YEAR(sr.faj262) = tm.yyyy AND MONTH(sr.faj262) = tm.mm THEN
                LET sr2.pre_d = 0
             ELSE
                   LET sr2.pre_d = sr2.fbn15 - sr2.curr_d
             END IF
             #--->帳面價值 = (成本 - 累積折舊)
             LET sr2.curr_val = sr2.fbn14-sr2.fbn15
             #--->資產淨額 = (帳面價值 - 減值準備)
             LET sr2.cost = sr2.curr_val - sr2.fbn17
             
             EXECUTE insert_prep USING
                sr.faj02, sr.faj022, sr.faj04, sr.faj05,    sr.faj06,
                sr.faj07, sr.faj142,  sr.faj20, sr.faj232,    sr.faj242,
                sr.faj262, sr.faj292,  sr2.fbn03,sr2.fbn04,   sr2.fbn05,
                sr2.fbn06,sr2.fbn07, sr2.fbn09,sr2.fbn14,   sr2.fbn15,
                sr2.pre_d,sr2.curr_d,sr2.curr, sr2.curr_val,sr2.cost,
                sr2.fbn17
          END FOREACH
       END IF
    END FOREACH

    IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj022,faj06')                                                                 
       RETURNING tm.wc                                                                                                             
    END IF
#CHI-C60010--add--str--#財簽二帳套對應的幣別小數位數
    IF g_faa.faa31='Y' THEN
       SELECT azi04,azi05 INTO l_azi04,l_azi05 FROM azi_file,aaa_file
        WHERE azi01=aaa03 AND aaa01=g_faa.faa02c
    END IF
#CHI-C60010--add--end                                                                                                                         
    LET g_str = tm.wc,";",tm.yyyy,";",tm.mm,";",tm.s[1,1],";",                                                 
               #tm.s[2,2],";",tm.s[3,3],";",g_azi04,";",g_azi05,";",  #CHI-C60010 mark
                tm.s[2,2],";",tm.s[3,3],";",l_azi04,";",l_azi05,";",  #CHI-C60010 add
                tm.c[1,1],";",tm.c[2,2],";",tm.c[3,3],";",                                             
                tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.b
                                                                                                             
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
    CALL cl_prt_cs3('afar200',l_name,g_sql,g_str)
END FUNCTION
#---------------------------MOD-C50193---------------------(S)
#判斷是否要回傳調整金額
FUNCTION r200_chk_adj(p_faj02,p_faj022,p_fbn15,p_fbn04)
   DEFINE p_faj02       LIKE faj_file.faj02,
          p_faj022      LIKE faj_file.faj022,
          p_fbn15       LIKE fbn_file.fbn15,
          l_adj_fbn07   LIKE fbn_file.fbn07,
          l_adj_fbn07_1 LIKE fbn_file.fbn07,
          l_adj_fap54   LIKE fap_file.fap54,
          l_curr_fbn07  LIKE fbn_file.fbn07,
          l_pre_fbn15   LIKE fbn_file.fbn15,
          l_cnt         LIKE type_file.num5,
          p_fbn04       LIKE type_file.num5,
          l_yy          LIKE type_file.num5

   LET l_cnt = 0
   LET l_adj_fbn07 = 0
   SELECT COUNT(*) INTO l_cnt FROM fbn_file
    WHERE fbn01 = p_faj02 AND fbn02 = p_faj022
      AND fbn03 = tm.yyyy AND fbn04 = tm.mm
      AND fbn041 = '1'

  #調整折舊

   LET p_fbn04 = p_fbn04 + 1
   LET l_yy = tm.yyyy
   IF p_fbn04 = '13' THEN
      LET p_fbn04 = '1'
      LET l_yy = l_yy + 1
   END IF

   #調整本期折舊
   SELECT SUM(fbn07) INTO l_adj_fbn07 FROM fbn_file
    WHERE fbn01 = p_faj02 AND fbn02 = p_faj022
      AND fbn03 = l_yy
      AND fbn04 BETWEEN p_fbn04 AND tm.mm
      AND fbn041 = '2'

   #調整折舊
   SELECT fbn07 INTO l_adj_fbn07_1 FROM fbn_file
    WHERE fbn01 = p_faj02 AND fbn02 = p_faj022
      AND fbn03 = tm.yyyy AND fbn04 = tm.mm
      AND fbn041 = '2'

   IF cl_null(l_adj_fbn07) THEN LET l_adj_fbn07 = 0 END IF
   IF cl_null(l_adj_fbn07_1) THEN LET l_adj_fbn07_1 = 0 END IF


  #調整成本
   SELECT fap54 INTO l_adj_fap54 FROM fap_file
    WHERE fap02 = p_faj02 AND fap021 = p_faj022
      AND YEAR(fap04) = tm.yyyy AND MONTH(fap04) = tm.mm
   IF cl_null(l_adj_fap54) THEN LET l_adj_fap54 = 0 END IF

   IF l_cnt > 0 THEN
      IF g_aza.aza26 <> '2' THEN
         LET l_adj_fbn07 = 0
         LET l_adj_fap54 = 0
      ELSE
         #大陸版有可能先折舊再調整
         SELECT fbn15 INTO l_pre_fbn15 FROM fbn_file
          WHERE fbn01 = p_faj02 AND fbn02 = p_faj022
            AND fbn041 = '1'
            AND fbn03 || fbn04 IN (
                  SELECT MAX(fbn03) || MAX(fbn04) FROM fbn_File
                   WHERE fbn01 = p_faj02 AND fbn02 = p_faj022
                     AND ((fbn03 < tm.yyyy) OR (fbn03 = tm.yyyy AND fbn04 < tm.mm))
                     AND fbn041 = '1')

         SELECT fbn07 INTO l_curr_fbn07 FROM fbn_file
          WHERE fbn01 = p_faj02 AND fbn02 = p_faj022
            AND fbn03 = tm.yyyy AND fbn04 = tm.mm
            AND fbn041 = '1'
         IF cl_null(l_curr_fbn07) THEN LET l_curr_fbn07 = 0 END IF

         IF p_fbn15 = (l_pre_fbn15 + l_curr_fbn07 + l_adj_fbn07) THEN
            LET l_adj_fbn07 = 0
            LET l_adj_fap54 = 0
         END IF
      END IF
   END IF
   RETURN l_adj_fbn07,l_adj_fbn07_1,l_adj_fap54
END FUNCTION
#---------------------------MOD-C50193---------------------(E)
#Patch....NO:FUN-B80134#
