# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr502.4gl
# Descriptions...: 年度機器設備結算報表
# Date & Author..: 2006/10/14 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/28 By TSD.Ken 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                # Print condition RECORD
           wc       STRING,           
           bzg01 LIKE bzg_file.bzg01,   # 結算年度
           more     LIKE type_file.chr1                   # Input more condition(Y/N)
           END RECORD
DEFINE g_count       LIKE type_file.num10
DEFINE g_i           LIKE type_file.num5   #count/index for any purpose
   DEFINE   l_table              STRING,    #FUN-850089 add
            g_sql                STRING,    #FUN-850089 add
            g_str                STRING     #FUN-850089 add
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bzg01.bzg_file.bzg01,",
              "bzg02.bzg_file.bzg02,",
              "bzg03.bzg_file.bzg03,",
              "bzg04.bzg_file.bzg04,",
              "bzg05.bzg_file.bzg05,",
              "bzg06.bzg_file.bzg06,",
              "bzg07.bzg_file.bzg07,",
              "bzg08.bzg_file.bzg08,",
              "bzg09.bzg_file.bzg09,",
              "bzg10.bzg_file.bzg10,",
              "bza02.bza_file.bza02,",
              "bza03.bza_file.bza03,",
              "bza04.bza_file.bza04,",
              "m01.bzg_file.bzg09,", #盤盈-虧
              "m02.bzg_file.bzg09,", #應補稅數
              "cnt.type_file.chr1000"   #序號-g_count
 
  LET l_table = cl_prt_temptable('abxr502',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?)" #16 items
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
  #---FUN-850089 add ---end
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc= ARG_VAL(1)
   LET tm.bzg01= ARG_VAL(2) 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF cl_null(tm.wc) THEN
      CALL r502_tm(0,0)             # Input print condition
   ELSE
      LET tm.wc="bzg02 ='",tm.wc CLIPPED,"'"
      CALL r502()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION r502_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,
          l_cmd        LIKE type_file.chr1000
 
   LET p_row = 5 LET p_col = 5
 
   OPEN WINDOW r502_w AT p_row,p_col WITH FORM "abx/42f/abxr502"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
    CALL cl_opmsg('p')
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bzg02
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bzg02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_bza1"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzg02
                  NEXT FIELD bzg02
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bzguser', 'bzggrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r502_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      INPUT BY NAME tm.bzg01,tm.more WITHOUT DEFAULTS
         AFTER FIELD more
            IF tm.more NOT MATCHES '[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r502_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='abxr502'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abxr502','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.bzg01 CLIPPED,"'" ,
                        " '",tm.more CLIPPED,"'"
            CALL cl_cmdat('abxr502',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r502_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r502()
      ERROR ""
   END WHILE
   CLOSE WINDOW r502_w
END FUNCTION
 
FUNCTION r502()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name
#         l_time    LIKE type_file.chr8          #No.FUN-6A0062
          l_sql     STRING,  
          sr        RECORD
                    bzg01   LIKE bzg_file.bzg01,
                    bzg02   LIKE bzg_file.bzg02,
                    bzg03   LIKE bzg_file.bzg03,
                    bzg04   LIKE bzg_file.bzg04,
                    bzg05   LIKE bzg_file.bzg05,
                    bzg06   LIKE bzg_file.bzg06,
                    bzg07   LIKE bzg_file.bzg07,
                    bzg08   LIKE bzg_file.bzg08,
                    bzg09   LIKE bzg_file.bzg09,
                    bzg10   LIKE bzg_file.bzg10,
                    bza02   LIKE bza_file.bza02,
                    bza03   LIKE bza_file.bza03,
                    bza04   LIKE bza_file.bza04
                    END RECORD
 
#FUN-850089 add---START
   DEFINE m01   LIKE bzg_file.bzg08
   DEFINE m02   LIKE bzg_file.bzg09
   DEFINE l_cnt SMALLINT
   DEFINE l_str_cnt LIKE type_file.chr1000
#FUN-850089 add---END
 
#FUN-850089 add---START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr502',g_time,1) RETURNING g_time
   #No.FUN-B80082--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND bzguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND bzggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   LET l_sql="SELECT bzg01,bzg02,bzg03,bzg04,bzg05,bzg06,bzg07,",
             "       bzg08,bzg09,bzg10,bza02,bza03,bza04",
             "  FROM bzg_file,bza_file ",
             " WHERE bzg02=bza01 ",
             "   AND bzg01=",tm.bzg01 CLIPPED,
             "   AND ",tm.wc CLIPPED,
             "   AND bzgacti ='Y' " #有效資料
   PREPARE r502_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   DECLARE r502_curs1 CURSOR FOR r502_prepare1
   LET g_pageno = 0
   LET g_count = 1
 
   #FUN-850089  ---start---
   LET l_cnt = 1
   #FUN-850089  ---end---
   
   FOREACH r502_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      #FUN-850089  ---start---
      IF sr.bzg09 > sr.bzg08 THEN
         LET m01 = sr.bzg09-sr.bzg08 #盤盈數
         LET m02 = 0                 #盤虧應補稅數
      ELSE
         LET m01 = 0                 #盤虧應補稅數
         LET m02 = sr.bzg08-sr.bzg09 #盤盈數
      END IF
     
      LET l_str_cnt = l_cnt USING '&&&&' 
      EXECUTE insert_prep USING sr.*, m01, m02, l_str_cnt
      LET l_cnt = l_cnt + 1
      #FUN-850089  ---end---
 
   END FOREACH
 
   #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bzg02')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
 
    LET g_str = g_str
 
    CALL cl_prt_cs3('abxr502','abxr502',l_sql,g_str)
   #---FUN-850089 add---END
 
   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr502',g_time,2) RETURNING g_time
   #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
