# Prog. Version..: '5.30.06-13.03.20(00001)'     #
#
# Pattern name...: afar450.4gl
# Descriptions...: 固定資產稅簽折舊費用彙總表
# Date & Author..: 12/06/06 By Lori(FUN-C50088)
# Modify.........: No:MOD-CB0043 12/11/08 by Polly 調整抓取資產日期判斷
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                           # Print condition RECORD
                wc      STRING,
                fao06   LIKE fao_file.fao06,
                yyyy    LIKE type_file.num5,                 # 資料年度       #No.FUN-680070 SMALLINT
                mm      LIKE type_file.num5,                 # 資料月份       #No.FUN-680070 SMALLINT
                s       LIKE type_file.chr3,                  # Order by sequence       #No.FUN-680070 VARCHAR(3)
                t       LIKE type_file.chr3,                  # Eject sw       #No.FUN-680070 VARCHAR(3)
                c       LIKE type_file.chr3,                  # subtotal       #No.FUN-680070 VARCHAR(3)
                more    LIKE type_file.chr1                   # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
                END RECORD,
          g_descripe ARRAY[3] OF LIKE type_file.chr20,   # Report Heading & prompt   #No.FUN-680070 VARCHAR(15)
          g_bdate,g_edate   LIKE type_file.dat          #No.FUN-680070 DATE
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   g_sql           STRING                  #NO.FUN-7B0139       
DEFINE   g_str           STRING                  #NO.FUN-7B0139
DEFINE   l_table         STRING                  #NO.FUN-7B0139
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
   LET g_sql = "faj04.faj_file.faj04,",
               "l_fab02.fab_file.fab02,",
               "faj05.faj_file.faj05,",
               "l_fac02.fac_file.fac02,",
               "cost.fao_file.fao14,",
               "fap71.fap_file.fap71,",
               "curr.fao_file.fao15,",
               "acct.fao_file.fao15,",
               "curr_val.fao_file.fao15"
   LET l_table = cl_prt_temptable('afar450',g_sql) CLIPPED                                                                          
   IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                          
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                              
             " VALUES(?,?,?,?,?, ?,?,?,?)"                                                                                           
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                              
   END IF                          
 
   LET g_pdate    = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
   LET tm.fao06   = ARG_VAL(8)
   LET tm.yyyy    = ARG_VAL(9)
   LET tm.mm      = ARG_VAL(10)
   LET tm.s       = ARG_VAL(11)   
   LET tm.t       = ARG_VAL(12)
   LET tm.c       = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)

   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r450_tm(0,0)            # Input print condition
      ELSE CALL afar450()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r450_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
            lc_qbe_sn     LIKE gbm_file.gbm01          
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r450_w AT p_row,p_col WITH FORM "afa/42f/afar450"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '12'
   LET tm.c    = 'Y  '
   LET tm.t    = 'Y  '
   LET tm.yyyy = g_faa.faa07
   LET tm.mm   = g_faa.faa08
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.c[1,1]
   LET tm2.u2   = tm.c[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj02,faj06
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION locale
             CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION controlp
            CASE
               WHEN INFIELD(faj04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = 'q_fab'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO faj04
                  NEXT FIELD faj04
               WHEN INFIELD(faj05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = 'q_fac'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO faj05
                  NEXT FIELD faj05
               WHEN INFIELD(faj02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = 'q_faj03'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO faj02
                  NEXT FIELD faj02
               WHEN INFIELD(faj06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = 'q_faj04'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO faj06
                  NEXT FIELD faj06
            END CASE
      END CONSTRUCT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r450_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM

      END IF

      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF

      INPUT BY NAME tm.fao06,tm.yyyy,tm.mm,tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm2.u1,tm2.u2,tm.more
                    WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         AFTER FIELD mm
            IF cl_null(tm.mm) OR tm.mm<1 OR tm.mm>12 THEN
               NEXT FIELD mm
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

         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.t = tm2.t1,tm2.t2
            LET tm.c = tm2.u1,tm2.u2

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(fao06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_gem6'
                  LET g_qryparam.default1 = tm.fao06
                  CALL cl_create_qry() RETURNING tm.fao06
                  DISPLAY BY NAME tm.fao06
             
                  NEXT FIELD fao06               
            END CASE

         ON ACTION locale
            CALL cl_show_fld_cont()                   
            LET g_action_choice = "locale"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlz
            CALL cl_show_req_fields()

         ON ACTION controlg      
            CALL cl_cmdask()     
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r450_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
          WHERE zz01='afar450'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar450','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate  CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang  CLIPPED,"'", 
                        " '",g_bgjob  CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc    CLIPPED,"'",
                        " '",tm.fao06 CLIPPED,"'",
                        " '",tm.yyyy  CLIPPED,"'",
                        " '",tm.mm    CLIPPED,"'",
                        " '",tm.s     CLIPPED,"'",
                        " '",tm.t     CLIPPED,"'",
                        " '",tm.c     CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",           
                        " '",g_rep_clas CLIPPED,"'",           
                        " '",g_template CLIPPED,"'",           
                        " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('afar450',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW r450_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar450()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r450_w
END FUNCTION
 
FUNCTION afar450()
   DEFINE l_name        LIKE type_file.chr20,                # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_sql         STRING,  
          l_chr         LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_flag        LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,              #No.FUN-680070 VARCHAR(40)
          l_order       ARRAY[6] OF LIKE faj_file.faj04,     #No.FUN-680070 VARCHAR(20)
          sr            RECORD order1 LIKE faj_file.faj04,   #No.FUN-680070 VARCHAR(20)
                               order2 LIKE faj_file.faj04,   #No.FUN-680070 VARCHAR(20)
                               order3 LIKE faj_file.faj04,   #No.FUN-680070 VARCHAR(20)
                               faj02 LIKE faj_file.faj02,    #財編
                               faj022 LIKE faj_file.faj022,  #附號
                               faj04 LIKE faj_file.faj04,    #主類別
                               faj05 LIKE faj_file.faj05,    #次類別
                               faj06 LIKE faj_file.faj06,    #中文名稱
                               faj07 LIKE faj_file.faj07,    #英文名稱
                               faj14 LIKE faj_file.faj14,    #本幣成本
                               faj20 LIKE faj_file.faj20,    #保管部門
                               faj23 LIKE faj_file.faj23,    #分攤方式
                               faj24 LIKE faj_file.faj24,    #分攤部門(類別)
                               faj26 LIKE faj_file.faj26,    #入帳日期
                               faj64 LIKE faj_file.faj64,    #耐用年限
                               faj67 LIKE faj_file.faj67     #累積折舊
                        END RECORD,
          sr2           RECORD
                               fao03    LIKE fao_file.fao03,    #年度
                               fao04    LIKE fao_file.fao04,    #月份
                               fao05    LIKE fao_file.fao05,    #分攤方式
                               fao06    LIKE fao_file.fao06,    #部門
                               fao07    LIKE fao_file.fao07,    #折舊金額
                               fao09    LIKE fao_file.fao09,    #被攤部門
                               fao14    LIKE fao_file.fao14,    #成本
                               acct_d   LIKE fao_file.fao15,    #累積折舊
                               pre_d    LIKE fao_file.fao15,    #前期折舊
                               curr_d   LIKE fao_file.fao15,    #本期折舊
                               curr     LIKE fao_file.fao15,    #本月折舊
                               curr_val LIKE fao_file.fao15,    #帳面價值
                               fap71    LIKE fap_file.fap71,    #改良成本
                               cost     LIKE fao_file.fao14     #資產合計
                        END RECORD
   DEFINE l_faj27  LIKE faj_file.faj27   
   DEFINE l_faj272 LIKE type_file.chr6   
   DEFINE l_fab02  LIKE fab_file.fab02   
   DEFINE l_fac02  LIKE fac_file.fac02   
   DEFINE l_count  LIKE type_file.num5   
    
   DEFINE l_fao03       LIKE type_file.chr4                                        
   DEFINE l_fao04       LIKE type_file.chr2                                        
   DEFINE l_fao03_fao04 LIKE type_file.chr6                                        
   DEFINE l_fao15       LIKE fao_file.fao15                                        

   DEFINE l_cnt         LIKE type_file.num5,
          l_adj_fao07   LIKE fao_file.fao07,
          l_adj_fao07_1 LIKE fao_File.fao07,
          l_adj_fap71   LIKE fap_file.fap71

     CALL cl_del_data(l_table)                                   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'afar450' 
 
     LET l_faj27 = tm.yyyy||(tm.mm USING '&&')  
     LET l_faj272 = tm.yyyy||tm.mm              

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')

     LET l_sql = "SELECT '','','',",
                 " faj02,faj022,faj04,faj05,faj06,faj07,faj14+faj141-faj59,",
                 " faj20,faj23,faj24,faj26,faj64,faj67",
                 " FROM faj_file", 
                 " WHERE fajconf = 'Y'",
                 "   AND ",tm.wc CLIPPED,
                 "   AND faj61 <> '0'",
                 " AND faj27 <= '",l_faj27,"'",
                 " AND (faj02 NOT IN (SELECT fap02 FROM fap_file ",
                #"      WHERE LTRIM(RTRIM(YEAR(fap04))) ||LTRIM(RTRIM(MONTH(fap04))) <= '",l_faj272,"'",                      #MOD-CB0043 mark
                 "      WHERE ((YEAR(fap04) < ",tm.yyyy,") OR (YEAR(fap04) = ",tm.yyyy," AND MONTH(fap04) < ",tm.mm,"))",     #MOD-CB0043 add
                 "      AND fap77 IN ('5','6') AND fap021 = faj022) ", 
                 "      OR faj02 IN (SELECT fao01 FROM fao_file ",
                 "      WHERE fao03 = ",tm.yyyy," AND fao04 = ",tm.mm,
                 "        AND fao07 > 0 AND fao02 =faj022) ) " 
     
     PREPARE r450_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE r450_cs1 CURSOR FOR r450_prepare1
 
     #--->取每筆資產本年度月份折舊
     LET l_sql = " SELECT fao03, fao04, fao05, fao06, fao07,",
                 " fao09, fao14, fao15,0,fao08,0,0,0,0",
                 " FROM fao_file ",
                 " WHERE fao01 = ? AND fao02 = ? ",
                 "   AND fao03 = ", tm.yyyy," AND fao04=",tm.mm,
                 "   AND (fao041 = '1' OR fao041 = '0') ", 
                 "   AND fao05 != '3' "
     IF NOT cl_null(tm.fao06) THEN
        LET l_sql = l_sql CLIPPED,"   AND fao06 = '",tm.fao06,"'"
     END IF
     
     PREPARE r450_prefao  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE r450_csfao CURSOR FOR r450_prefao
 
     CALL s_azn01(tm.yyyy,tm.mm) RETURNING g_bdate,g_edate
 
 
     FOREACH r450_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET l_flag = 'Y'
       IF cl_null(sr.faj05) THEN LET sr.faj05 = ' ' END IF
      #上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT count(*) INTO l_count FROM fap_file
        WHERE fap02=sr.faj02 AND fap021=sr.faj022
          AND fap77 IN ('5','6')
         #AND (YEAR(fap04)||MONTH(fap04)) < l_faj272                                           #MOD-CB0043 mark
          AND ((YEAR(fap04) < tm.yyyy) OR (YEAR(fap04) = tm.yyyy AND MONTH(fap04) < tm.mm))    #MOD-CB0043 add
       IF l_count > 0 THEN
          CONTINUE FOREACH
       END IF
       #--->篩選部門
       INITIALIZE sr2.* TO NULL
       FOREACH r450_csfao
       USING sr.faj02,sr.faj022
       INTO sr2.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('r450_csfao:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET l_flag = 'N'
          IF cl_null(sr2.fao07) THEN LET sr2.fao07 =0 END IF
          IF cl_null(sr2.fao14) THEN LET sr2.fao14 =0 END IF
          IF cl_null(sr2.acct_d) THEN LET sr2.acct_d =0 END IF
          IF cl_null(sr2.curr_d) THEN LET sr2.curr_d =0 END IF
 
          SELECT SUM(fao15) INTO sr2.acct_d FROM fao_file
           WHERE fao01 = sr.faj02
             AND fao02 = sr.faj022
             AND fao03 = sr2.fao03
             AND fao04 = sr2.fao04
             AND (fao041 = '1' OR fao041 = '0') 
             AND fao05 != '3'
          IF cl_null(sr2.acct_d) THEN LET sr2.acct_d =0 END IF

          LET l_adj_fao07 = 0
          LET l_adj_fap71 = 0
          CALL r300_chk_adj(sr.faj02,sr.faj022,sr2.acct_d)
             RETURNING l_adj_fao07,l_adj_fao07_1,l_adj_fap71
          LET sr2.fao07 = sr2.fao07 + l_adj_fao07_1
          LET sr2.fao14 = sr2.fao14 + l_adj_fap71
          LET sr2.acct_d = sr2.acct_d + l_adj_fao07

          #--->本月折舊
          LET sr2.curr = sr2.fao07
 
          #--->前期折舊 = (累折 - 本期折舊)
          LET sr2.pre_d = sr2.acct_d - sr2.curr_d
 
          #--->未折減額  = (成本 - 累期折舊)
          LET sr2.curr_val = sr2.fao14- sr2.acct_d
 
          #--->改良成本
          SELECT SUM(fap71) INTO sr2.fap71 FROM fap_file
             WHERE fap03 IN ('7')
               AND fap02=sr.faj02 AND fap021=sr.faj022
               AND fap04 between g_bdate AND  g_edate
          IF cl_null(sr2.fap71) THEN LET sr2.fap71=0  END IF
 
          #--->資產合計  = 成本 - 改良成本
          LET sr2.cost   = sr2.fao14 - sr2.fap71

          SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01= sr.faj04
          IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
          SELECT fac02 INTO l_fac02 FROM fac_file WHERE fac01= sr.faj05
          IF SQLCA.sqlcode THEN LET l_fac02 = ' ' END IF
          EXECUTE insert_prep USING
             sr.faj04,l_fab02,sr.faj05,l_fac02,sr2.cost,sr2.fap71,
             sr2.curr,sr2.acct_d,sr2.curr_val
                                       
       END FOREACH
       IF l_flag ='Y' THEN
          #--->若已折毕,抓取每笔资产最後一次折旧资料                            
          LET l_sql = " SELECT MAX(fao03*100+fao04) FROM fao_file ",   
                      "  WHERE fao01 = ? AND fao02 = ?",                        
                      "   AND (fao041 = '1' OR fao041 = '0') ",
                      "   AND fao05 != '3' " 

          IF NOT cl_null(tm.fao06) THEN
             LET l_sql = l_sql CLIPPED, " AND fao06 = '",tm.fao06,"'"
          END IF
                                  
          PREPARE pre_fao03_fao04 FROM l_sql                                    
          EXECUTE pre_fao03_fao04 USING sr.faj02,sr.faj022 INTO l_fao03_fao04   
          LET l_fao03 = l_fao03_fao04[1,4]                                      
          LET l_fao04 = l_fao03_fao04[5,6]                                      
                                                                                
          IF l_fao03 = tm.yyyy THEN                                             
             LET l_sql = " SELECT fao03, fao04, fao05, fao06, 0,",              
                         " fao09, fao14, fao15,0,fao08,0,0,0,fao17 "            
          ELSE                                                                  
             LET l_sql = " SELECT fao03, fao04, fao05, fao06, 0,",              
                         " fao09, fao14, fao15,fao08,0,0,0,0,fao17 "            
          END IF       
                                              
          LET l_sql = l_sql CLIPPED,                                            
                      " FROM fao_file ",                                        
                      " WHERE fao01 = ? AND fao02 = ? ",                        
                      "   AND fao03 = ? AND fao04 = ? ",                        
                      "   AND (fao041 = '1' OR fao041 = '0') ",
                      "   AND fao05 != '3' "                                   

          IF NOT cl_null(tm.fao06) THEN
             LET l_sql = l_sql CLIPPED, " AND fao06 = '",tm.fao06,"'"
          END IF

          PREPARE r300_prefao2  FROM l_sql                                      
          IF SQLCA.sqlcode != 0 THEN                                            
             CALL cl_err('prepare:',SQLCA.sqlcode,1)                            
             CALL cl_used(g_prog,g_time,2) RETURNING g_time       
             EXIT PROGRAM                                                       
          END IF                                                                
          DECLARE r300_csfao2 CURSOR FOR r300_prefao2                           
                                                                                
          FOREACH r300_csfao2 USING sr.faj02,sr.faj022,l_fao03,l_fao04          
             INTO sr2.*                                                         
             IF cl_null(sr2.curr_d) THEN LET sr2.curr_d = 0 END IF              
             IF cl_null(sr2.pre_d) THEN LET sr2.pre_d = 0 END IF                
             IF cl_null(sr2.curr_val) THEN LET sr2.curr_val = 0 END IF          
             IF cl_null(sr2.fao07) THEN LET sr2.fao07 = 0 END IF
             IF cl_null(sr2.fao14) THEN LET sr2.fao14 = 0 END IF                
                                                                                
             LET l_adj_fao07 = 0
             LET l_adj_fap71 = 0
             CALL r300_chk_adj(sr.faj02,sr.faj022,sr2.acct_d)
                RETURNING l_adj_fao07,l_adj_fao07_1,l_adj_fap71
             LET sr2.fao07 = sr2.fao07 + l_adj_fao07_1
             LET sr2.fao14 = sr2.fao14 + l_adj_fap71
             LET sr2.acct_d = sr2.acct_d + l_adj_fao07

             #累积折旧                                                          
             LET sr2.acct_d = sr.faj67                                          
             IF cl_null(sr2.acct_d) THEN LET sr2.acct_d =0 END IF               
                                                                                
             #--->本月折旧                                                      
             LET sr2.curr = sr2.fao07                                           
                                                                                
             #--->前期折旧 = (累折 - 本期累折)                                  
             IF YEAR(sr.faj26) = tm.yyyy AND MONTH(sr.faj26) = tm.mm THEN       
                LET sr2.pre_d = 0                                               
             ELSE                                                               
                LET sr2.pre_d = sr2.acct_d - sr2.curr_d             
             END IF                                                             
                                                                                
             #--->未折减额  = (成本 - 累期折旧)                                 
             LET sr2.curr_val = sr2.fao14 - sr2.acct_d                          
                                                                                
             #--->改良成本                                                      
             SELECT SUM(fap71) INTO sr2.fap71 FROM fap_file
                WHERE fap03 matches '[7]'                                       
                  AND fap02=sr.faj02 AND fap021=sr.faj022                       
                  AND fap04 between g_bdate AND  g_edate                        
             IF cl_null(sr2.fap71) THEN LET sr2.fap71=0  END IF                 
                                                                                
             #--->资产合计  = 成本 - 改良成本                                   
             LET sr2.cost   = sr2.fao14 - sr2.fap71                             
                                                                                
             SELECT fab02 INTO l_fab02 FROM fab_file WHERE fab01= sr.faj04
             IF SQLCA.sqlcode THEN LET l_fab02 = ' ' END IF
             SELECT fac02 INTO l_fac02 FROM fac_file WHERE fac01= sr.faj05
             IF SQLCA.sqlcode THEN LET l_fac02 = ' ' END IF
    
             EXECUTE insert_prep USING
                sr.faj04,l_fab02,sr.faj05,l_fac02,sr2.cost,sr2.fap71,
                sr2.curr,sr2.acct_d,sr2.curr_val
          END FOREACH    #No.MOD-A70018
        END IF
    END FOREACH
 
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               

     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'faj04,faj05,faj02,faj06,fao06')
        RETURNING tm.wc
     END IF

     LET g_str = tm.wc,";",tm.fao06,";",
                 tm.yyyy,";",tm.mm,";",tm.t[1,1],";",tm.t[2,2],";",
                 tm.s[1,1],";",tm.s[2,2],";",
                 g_azi04,";",g_azi05,";",tm.c[1,1],";",tm.c[2,2]
     CALL cl_prt_cs3('afar450','afar450',g_sql,g_str)
END FUNCTION

#判斷是否要回傳調整金額
FUNCTION r300_chk_adj(p_faj02,p_faj022,p_fao15)
   DEFINE p_faj02       LIKE faj_file.faj02,
          p_faj022      LIKE faj_file.faj022,
          p_fao15       LIKE fao_file.fao15,
          l_adj_fao07   LIKE fao_file.fao07,
          l_adj_fao07_1 LIKE fao_file.fao07,
          l_adj_fap71   LIKE fap_file.fap71,
          l_curr_fao07  LIKE fao_file.fao07,
          l_pre_fao15   LIKE fao_file.fao15,
          l_cnt         LIKE type_file.num5

   LET l_cnt = 0
   LET l_adj_fao07 = 0
   SELECT COUNT(*) INTO l_cnt FROM fao_file
    WHERE fao01 = p_faj02 AND fao02 = p_faj022
      AND fao03 = tm.yyyy AND fao04 = tm.mm
      AND fao041 = '1'

   #調整折舊
   SELECT fao07 INTO l_adj_fao07 FROM fao_file
    WHERE fao01 = p_faj02 AND fao02 = p_faj022
      AND fao03 = tm.yyyy AND fao04 = tm.mm
      AND fao041 = '2'
   IF cl_null(l_adj_fao07) THEN LET l_adj_fao07 = 0 END IF
   LET l_adj_fao07_1 = l_adj_fao07
   #調整成本
   SELECT fap71 INTO l_adj_fap71 FROM fap_file
    WHERE fap02 = p_faj02 AND fap021 = p_faj022
      AND YEAR(fap04) = tm.yyyy AND MONTH(fap04) = tm.mm
   IF cl_null(l_adj_fap71) THEN LET l_adj_fap71 = 0 END IF

   IF l_cnt > 0 THEN
      IF g_aza.aza26 <> '2' THEN
         LET l_adj_fao07 = 0
         LET l_adj_fap71 = 0
      ELSE
         #大陸版有可能先折舊再調整
         SELECT fao15 INTO l_pre_fao15 FROM fao_file
          WHERE fao01 = p_faj02 AND fao02 = p_faj022
            AND fao041 = '1'                      
            AND fao03 || fao04 IN (               
                  SELECT MAX(fao03) || MAX(fao04) FROM fao_File
                   WHERE fao01 = p_faj02 AND fao02 = p_faj022
                     AND ((fao03 < tm.yyyy) OR (fao03 = tm.yyyy AND fao04 < tm.mm))
                     AND fao041 = '1')

         SELECT fao07 INTO l_curr_fao07 FROM fao_file
          WHERE fao01 = p_faj02 AND fao02 = p_faj022
            AND fao03 = tm.yyyy AND fao04 = tm.mm
            AND fao041 = '1'
         IF cl_null(l_curr_fao07) THEN LET l_curr_fao07 = 0 END IF

         IF p_fao15 = (l_pre_fao15 + l_curr_fao07 + l_adj_fao07) THEN
            LET l_adj_fao07 = 0
            LET l_adj_fap71 = 0
         END IF
      END IF
   END IF   
   RETURN l_adj_fao07,l_adj_fao07_1,l_adj_fap71
END FUNCTION
#FUN-C50088
