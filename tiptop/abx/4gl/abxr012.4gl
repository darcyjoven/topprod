# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr012.4gl
# Descriptions...: 區內事業交易申報書售出憑證
# Date & Author..: 2006/10/18 By kim
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/19 By TSD.hoho 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD                # Print condition RECORD
                    wc      STRING,               # Where condition
                    yy      LIKE type_file.num5,              #申報年度
                    mm      LIKE type_file.num5,              #申報月份
                    name1   LIKE gen_file.gen02,  #出售保稅業務人員
                    kk      LIKE type_file.chr1,           #明細列印否
                    bdate   LIKE type_file.dat,
                    no      LIKE type_file.chr20,          #編號
                    aa      LIKE type_file.chr1,           #列印區分
                    s       LIKE type_file.chr2,           #排列順序項目
                    u       LIKE type_file.chr2,           #小計
                    more    LIKE type_file.chr1            # Input more condition(Y/N)
                   END RECORD
DEFINE g_zo06      LIKE zo_file.zo06
 
DEFINE   l_table      STRING,    #FUN-850089 add
         g_str        STRING,    #FUN-850089 add
         g_sql        STRING     #FUN-850089 add
 
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
 
---FUN-850089 add ---start
## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
 LET g_sql = "bxi03.bxi_file.bxi03,",
             "ima1916.ima_file.ima1916,",
             "occ02.occ_file.occ02,",
             "occ1707.occ_file.occ1707,",
             "occ11.occ_file.occ11,",
             "occ28.occ_file.occ28,",
             "occ1708.occ_file.occ1708,",
             "bxi02.bxi_file.bxi02,",
             "bxj04.bxj_file.bxj04,",
             "ima02.ima_file.ima02,",
             "bxj05.bxj_file.bxj05,",
             "bxj06.bxj_file.bxj06,",
             "bxj15.bxj_file.bxj15,",
             "bnd04.bnd_file.bnd04,",
             "ima1914.ima_file.ima1914,",
             "ima021.ima_file.ima021,",
             "bxj20.bxj_file.bxj20,",
             "bxi04.bxi_file.bxi04,",
             "bxj10.bxj_file.bxj10,",
             "bxe02.bxe_file.bxe02,",
             "bxe03.bxe_file.bxe03,",
             "bxi06.bxi_file.bxi06"
 LET l_table = cl_prt_temptable('abxr012',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
 LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?,?,?,?, ?,?)"
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1)
    EXIT PROGRAM
 END IF
#------------------------------ CR (1) ------------------------------#
 
 
   LET g_pdate  = ARG_VAL(1)    # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.yy    = ARG_VAL(8)
   LET tm.mm    = ARG_VAL(9)
   LET tm.name1 = ARG_VAL(10)
   LET tm.kk    = ARG_VAL(11)
   LET tm.bdate = ARG_VAL(12)
   LET tm.no    = ARG_VAL(13)
   LET tm.aa    = ARG_VAL(14)
   LET tm.s     = ARG_VAL(15)
   LET tm.u     = ARG_VAL(16)
   LET tm.more  = ARG_VAL(17)
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL abxr012_tm(4,17)                    # Input print condition
   ELSE
      CALL abxr012()                           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION abxr012_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   OPEN WINDOW abxr012_w AT p_row,p_col
        WITH FORM "abx/42f/abxr012"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.kk    = 'Y'
   LET tm.bdate = g_today
   LET tm.aa    = '1'
   LET tm.s     = '21'
   LET tm.more  = 'N'
   SELECT gen02 INTO tm.name1 FROM gen_file WHERE gen01 = g_user
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bxj04,ima1916,bxi08,bxi03
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(bxj04)      #料件編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bxj04
                   NEXT FIELD bxj04
              WHEN INFIELD(ima1916)  #保稅群組代碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bxe01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima1916
                   NEXT FIELD ima1916
              WHEN INFIELD(bxi08)      #保稅異動原因代碼
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bxr"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bxi08
                   NEXT FIELD bxi08
              WHEN INFIELD(bxi03)      #客戶代號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_occ"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bxi03
                   NEXT FIELD bxi03
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW abxr012_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.yy,tm.mm,tm.name1,tm.kk,tm.bdate,tm.no,tm.aa,
                      tm2.s1,tm2.s2,tm2.u1,tm2.u2,tm.more
      INPUT BY NAME tm.yy,tm.mm,tm.name1,tm.kk,tm.bdate,tm.no,tm.aa,
                    tm2.s1,tm2.s2,tm2.u1,tm2.u2,tm.more
                    WITHOUT DEFAULTS
         AFTER FIELD yy 
            IF tm.yy < 0 THEN 
               CALL cl_err('','aim-391',0)
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
            IF tm.mm < 1 OR tm.mm > 12 THEN
               CALL cl_err('','aom-580',0)
               NEXT FIELD mm
            END IF
 
         AFTER FIELD kk
            IF tm.kk NOT MATCHES "[YN]" THEN
               NEXT FIELD kk
            END IF
 
         AFTER FIELD aa
            IF tm.aa NOT MATCHES "[123]" THEN
               NEXT FIELD aa
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
 
         AFTER FIELD s1
            IF NOT cl_null(tm2.s1) THEN
               IF tm2.s1 NOT MATCHES "[12]" THEN
                  NEXT FIELD s1
               END IF
            END IF
 
         AFTER FIELD s2
            IF NOT cl_null(tm2.s2) THEN
               IF tm2.s2 NOT MATCHES "[1]" THEN
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
 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0 
               CLOSE WINDOW abxr012_w
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
               EXIT PROGRAM
            END IF
            IF NOT cl_null(tm2.s1) THEN
               IF tm2.s1 NOT MATCHES "[12]" THEN
                  NEXT FIELD s1
               END IF
            END IF
            IF NOT cl_null(tm2.s2) THEN
               IF tm2.s2 NOT MATCHES "[1]" THEN
                  NEXT FIELD s2
               END IF
            END IF
            IF tm2.u1 NOT MATCHES "[YN]" THEN
               NEXT FIELD u1
            END IF
            IF tm2.u2 NOT MATCHES "[YN]" THEN
               NEXT FIELD u2
            END IF
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.u = tm2.u1,tm2.u2
            IF tm.mm < 1 OR tm.mm > 12 THEN
               CALL cl_err('','aom-580',0)
               NEXT FIELD mm
            END IF
            IF tm.yy < 0 THEN 
               CALL cl_err('','aim-391',0)
               NEXT FIELD yy
            END IF
            IF cl_null(tm.kk) THEN 
               NEXT FIELD kk
            END IF
            IF cl_null(tm.aa) THEN 
               NEXT FIELD aa
            END IF
            IF cl_null(tm2.s1[1,1]) AND tm2.u1 = 'Y' THEN
               CALL cl_err('','mfg0037',0)
               NEXT FIELD s1
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
         CLOSE WINDOW abxr012_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='abxr012'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abxr012','9031',1)
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
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.name1 CLIPPED,"'",
                         " '",tm.kk CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.no CLIPPED,"'",
                         " '",tm.aa CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.more CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'" 
            CALL cl_cmdat('abxr012',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW abxr012_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abxr012()
      ERROR ""
   END WHILE
   CLOSE WINDOW abxr012_w
END FUNCTION
 
FUNCTION abxr012()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     STRING,            # RDSQL STATEMENT
          sr        RECORD
                       bxi03      LIKE bxi_file.bxi03,
                       ima1916  LIKE ima_file.ima1916,
                       occ02      LIKE occ_file.occ02,
                       occ1707  LIKE occ_file.occ1707,
                       occ11      LIKE occ_file.occ11,
                       occ28      LIKE occ_file.occ28,
                       occ1708  LIKE occ_file.occ1708,
                       bxi02      LIKE bxi_file.bxi02,
                       bxj04      LIKE bxj_file.bxj04,
                       ima02      LIKE ima_file.ima02,
                       bxj05      LIKE bxj_file.bxj05,
                       bxj06      LIKE bxj_file.bxj06,
                       bxj15      LIKE bxj_file.bxj15,
                       bnd04      LIKE bnd_file.bnd04,
                       ima1914  LIKE ima_file.ima1914,
                       ima021     LIKE ima_file.ima021,
                       bxj20  LIKE bxj_file.bxj20,
                       bxi04      LIKE bxi_file.bxi04,
                       bxj10      LIKE bxj_file.bxj10,
                       bxe02  LIKE bxe_file.bxe02,
                       bxe03  LIKE bxe_file.bxe03,
                       bxi06      LIKE bxi_file.bxi06
                    END RECORD
 
#FUN-850089 add---START
DEFINE l_sql2    STRING
## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
  
   #No.FUN-B80082--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----

   SELECT zo02,zo06 INTO g_company,g_zo06
     FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2 = '4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc CLIPPED," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3 = '4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc CLIPPED," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   LET l_sql = "SELECT bxi03,ima1916,occ02,occ1707,occ11, ",
               "       occ28,occ1708,bxi02,bxj04,ima02,bxj05,bxj06, ",
               "       bxj15,'',ima1914,ima021,bxj20,bxi04,bxj10,",
               "       bxe02,bxe03,bxi06 ",
               "  FROM bxi_file, bxj_file, ima_file, ",
               "       OUTER occ_file, OUTER bxe_file ",
               " WHERE bxi01 = bxj01 ",
               "   AND bxj04 = ima01 ",
               "   AND bxi_file.bxi03 = occ_file.occ01 ",
               "   AND ima_file.ima1916 = bxe_file.bxe01 ",
               "   AND ",tm.wc CLIPPED
 
   IF tm.aa = "1" THEN 
      LET l_sql = l_sql CLIPPED, " AND bxi06='2' "   #銷貨時(出庫)
   END IF 
   IF tm.aa = "2" THEN 
      LET l_sql = l_sql CLIPPED, " AND bxi06='1' "   #銷退時(入庫)
   END IF 
   IF tm.yy IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED, " AND bxi11 = ",tm.yy
   END IF
   IF tm.mm IS NOT NULL THEN
      LET l_sql = l_sql CLIPPED, " AND bxi12 = ",tm.mm
   END IF
 
   PREPARE abxr012_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   DECLARE abxr012_curs1 CURSOR FOR abxr012_prepare1
 
   LET g_pageno = 0
 
   FOREACH abxr012_curs1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT bnd04 INTO sr.bnd04 FROM bnd_file
       WHERE bnd01 = sr.bxj04 
         AND bnd02 = (SELECT MAX(bnd02) FROM bnd_file
                       WHERE bnd01 = sr.bxj04 AND bnd02 <= sr.bxi02)
      IF sr.bxj06 IS NULL THEN LET sr.bxj06 = 0 END IF
      IF sr.bxj15 IS NULL THEN LET sr.bxj15 = 0 END IF
      IF sr.bxj20 IS NULL THEN LET sr.bxj20 = 0 END IF
      IF tm.aa MATCHES '[23]' THEN   #銷退以負數
         IF sr.bxi06 ='1' THEN 
            LET sr.bxj06 = sr.bxj06 * -1
            LET sr.bxj15 = sr.bxj15 * -1
         END IF 
      END IF 
 
     #---FUN-850089 add---START
      EXECUTE insert_prep USING sr.bxi03,sr.ima1916,sr.occ02,
                                sr.occ1707,sr.occ11,sr.occ28,  sr.occ1708,
                                sr.bxi02,  sr.bxj04,sr.ima02,  sr.bxj05,
                                sr.bxj06,  sr.bxj15,sr.bnd04,  sr.ima1914,
                                sr.ima021, sr.bxj20,sr.bxi04,  sr.bxj10,
                                sr.bxe02,  sr.bxe03,sr.bxi06
      IF SQLCA.sqlcode  THEN
         CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
      END IF
     #---FUN-850089 add---END
 
   END FOREACH
 
 #FUN-850089  ---start---
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
   LET l_sql2= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'bxj04,ima1916,bxi08,bxi03')
           RETURNING g_str
   ELSE
      LET g_str = ''
   END IF
              
               #P1               #P2               #P3
   LET g_str = g_str,";",        tm.s[1,1],";",    tm.u[1,1],";",
               #P4               #P5               #P6
               g_bxz.bxz100,";", g_bxz.bxz101,";", g_bxz.bxz102,";",
               #P7               #P8               #P9
               g_bxz.bxz104,";", g_zo06,";",       tm.bdate,";",
               #P10              #P11              #P12
               tm.no,";",        tm.yy,";",        tm.mm,";",
               #P13              #P14
               tm.name1,";",     tm.kk
   CALL cl_prt_cs3('abxr012','abxr012',l_sql2,g_str)
   #------------------------------ CR (4) ------------------------------#
 #FUN-850089  ----end---
   #No.FUN-B80082--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0062
   #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
