# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abxr102.4gl
# Descriptions...: 廠外加工貨品出廠紀錄表憑證列印作業
# Date & Author..: 2006/10/19 By kim
 
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/21 by TSD.lucasyeh 轉crystal報表
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A80022 10/08/04 By sabrina 工單的部門廠商欄位沒輸入時，無法跑出報表
#                                                    將sfb82改抓pmm09
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD                # Print condition RECORD
                    wc      STRING,      # Where condition
                    more    LIKE type_file.chr1   # Input more condition(Y/N)
                   END RECORD
DEFINE g_msg       LIKE type_file.chr1000
DEFINE g_sql       STRING,                  #FUN-850089 add
       g_str       STRING,                  #FUN-850089 add
       l_table     STRING                   #FUN-850089 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
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
   LET tm.more  = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
 
#---FUN-850089 add---start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR1 *** ##
   LET g_sql = "sfb01.sfb_file.sfb01,",     #編號
               "sfb04.sfb_file.sfb04,",     #結案碼
               "sfb05.sfb_file.sfb05,",     #產品品號
               "sfb08.sfb_file.sfb08,",     #預計生產數量
               "sfb09.sfb_file.sfb09,",     #進廠數量
               "sfb81.sfb_file.sfb81,",     #工單日期
               "sfb82.sfb_file.sfb82,",     #加工廠商名稱
               "bnb01.bnb_file.bnb01,",     #放行單號
               "bnb02.bnb_file.bnb02,",     #日期
               "bnb90.bnb_file.bnb90,",     #管理局核准文號
               "bnd01.bnd_file.bnd01,",     #主件料號(BOM的)
               "bne08.bne_file.bne08,",     #組成用量
               "bne10.bne_file.bne10,",     #實用數量 
               "bne11.bne_file.bne11,",     #損耗數
               "bnc03.bnc_file.bnc03,",     #材料品號
               "bnc05.bnc_file.bnc05,",     #單位
               "bnc06.bnc_file.bnc06,",     #申請出廠總數量
               "ima02a.ima_file.ima02,",    #產品品名(sfb05)
               "ima021a.ima_file.ima021,",  #產品規格(sfb05)
               "ima55a.ima_file.ima55,",    #單位    (sfb05)
               "pmc03.pmc_file.pmc03,",     #廠商名稱
               "ima02b.ima_file.ima02,",    #產品品名(bnc03)
               "ima021b.ima_file.ima021"    #產品規格(bnc03)
                                            #23 items
 
   LET l_table = cl_prt_temptable('abxr102',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
#---FUN-850089 add----end-
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add-- 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r102_tm(4,17)                       # Input print condition
   ELSE
      CALL r102()                              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION r102_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   OPEN WINDOW r102_w AT p_row,p_col
        WITH FORM "abx/42f/abxr102"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.more  = 'N'
 
   WHILE TRUE
     #CONSTRUCT BY NAME tm.wc ON sfb82,sfb81,bnb02,sfb01        #MOD-A80022 mark         
      CONSTRUCT BY NAME tm.wc ON pmm09,sfb81,bnb02,sfb01        #MOD-A80022 add 
         ON ACTION CONTROLP
            CASE
               #WHEN INFIELD(sfb82)         #MOD-A80022 mark
                WHEN INFIELD(pmm09)         #MOD-A80022 add
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc2"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                    #MOD-A80022---modify---start---
                    #DISPLAY g_qryparam.multiret TO sfb82
                    #NEXT FIELD sfb82
                     DISPLAY g_qryparam.multiret TO pmm09 
                     NEXT FIELD pmm09
                    #MOD-A80022---modify---end---
                WHEN INFIELD(sfb01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_sfb703"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb01
                     NEXT FIELD sfb01
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.more
      INPUT BY NAME tm.more WITHOUT DEFAULTS
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
               CLOSE WINDOW r102_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
               EXIT PROGRAM
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
         CLOSE WINDOW r102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='abxr102'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abxr102','9031',1)
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
                         " '",tm.more CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'" 
            CALL cl_cmdat('abxr102',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r102()
      ERROR ""
   END WHILE
   CLOSE WINDOW r102_w
END FUNCTION
 
FUNCTION r102()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     STRING,            # RDSQL STATEMENT
          sr        RECORD
                          sfb01     LIKE sfb_file.sfb01,     #編號
                          sfb04     LIKE sfb_file.sfb04,     #結案碼
                          sfb05     LIKE sfb_file.sfb05,     #產品品號
                          sfb08     LIKE sfb_file.sfb08,     #預計生產數量
                          sfb09     LIKE sfb_file.sfb09,     #進廠數量
                          sfb81     LIKE sfb_file.sfb81,     #工單日期
                          sfb82     LIKE sfb_file.sfb82,     #加工廠商名稱
                          bnb01     LIKE bnb_file.bnb01,     #放行單號
                          bnb02     LIKE bnb_file.bnb02,     #日期
                          bnb90  LIKE bnb_file.bnb90,  #管理局核准文號
                          bnd01     LIKE bnd_file.bnd01,     #主件料號(BOM的)
                          bne08     LIKE bne_file.bne08,     #組成用量
                          bne10     LIKE bne_file.bne10,     #實用數量
                          bne11     LIKE bne_file.bne11,     #損耗數
                          bnc03     LIKE bnc_file.bnc03,     #材料品號
                          bnc05     LIKE bnc_file.bnc05,     #單位
                          bnc06     LIKE bnc_file.bnc06,     #申請出廠總數量
                          ima02a    LIKE ima_file.ima02,     #產品品名(sfb05)
                          ima021a   LIKE ima_file.ima021,    #產品規格(sfb05)
                          ima55a    LIKE ima_file.ima55,     #單位    (sfb05)
                          pmc03     LIKE pmc_file.pmc03,     #廠商名稱
                          ima02b    LIKE ima_file.ima02,     #產品品名(bnc03)
                          ima021b   LIKE ima_file.ima021     #產品規格(bnc03)
                    END RECORD

   #No.FUN-B80082--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----
 
#--FUN-850089 add---start
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#--FUN-850089 add----end-
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    LET l_sql = "SELECT sfb01,sfb04,sfb05,sfb08,sfb09,    ", 
               #"       sfb81,sfb82,bnb01,bnb02,bnb90, ",       #MOD-A80022 mark
                "       sfb81,pmm09,bnb01,bnb02,bnb90, ",       #MOD-A80022 add
                "       bnd01,bne08,bne10,bne11,bnc03,    ",
                "       bnc05,SUM(bnc06),'','','','','',''",
                "  FROM sfb_file,bnb_file,bnc_file,       ",
                "       bnd_file,bne_file,pmm_file,pmn_file ",   #MOD-A80022 add
                " WHERE sfb01=bnb16  AND sfb02='7'        ",
                "   AND bnb03='1'    AND sfb05=bnd01      ",
                "   AND bnb01=bnc01  AND bnc03=bne05      ",
                "   AND bnd02<=bnb02                      ",
                "   AND (bnd03 IS NULL OR bnd03>bnb02)    ",
                "   AND bne01=bnd01                       ",
                "   AND bne02=bnd02                       ",
                "   AND sfb01=pmn41 AND pmm01=pmn01       ",         #MOD-A80022 add
                "   AND ",tm.wc CLIPPED,
                " GROUP BY sfb01,sfb04,sfb05,sfb08,sfb09,    ",
               #"          sfb81,sfb82,bnb01,bnb02,bnb90, ",        #MOD-A80022 mark
                "          sfb81,pmm09,bnb01,bnb02,bnb90, ",        #MOD-A80022 add
                "          bnd01,bne08,bne10,bne11,bnc03,bnc05 "
   PREPARE r102_pre_ima FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   DECLARE r102_ima_cs CURSOR FOR r102_pre_ima
 
   FOREACH r102_ima_cs INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH r102_ima_cs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT ima02,ima021,ima55
        INTO sr.ima02a,sr.ima021a,sr.ima55a
        FROM ima_file
       WHERE ima01 = sr.sfb05
      SELECT ima02,ima021
        INTO sr.ima02b,sr.ima021b
        FROM ima_file
       WHERE ima01 = sr.bnc03
      SELECT pmc03 INTO sr.pmc03
        FROM pmc_file
       WHERE pmc01 = sr.sfb82
 
#FUN-850089 add---start
      EXECUTE insert_prep USING sr.*
      IF SQLCA.sqlcode  THEN
             CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
      END IF
      ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
#FUN-850089 add---end--
 
   END FOREACH
 
#---FUN-850089 add---start
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",g_bxz.bxz100,";",g_bxz.bxz101,";",g_bxz.bxz102,";",g_bxz.bxz105
     CALL cl_prt_cs3('abxr102','abxr102',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
#---FUN-850089 add----end-

   #No.FUN-B80082--mark--Begin--- 
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
