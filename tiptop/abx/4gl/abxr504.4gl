# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr504.4gl
# Descriptions...: 保稅機器設備外送收回狀況表
# Date & Author..: 2006/10/16 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/26 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                     # Print condition RECORD
           wc      STRING,     # Where condition
           a       LIKE type_file.chr1,
           bdate   LIKE type_file.dat,
           edate   LIKE type_file.dat,
           more    LIKE type_file.chr1         # Input more condition(Y/N)
           END RECORD
DEFINE   l_table      STRING,    #FUN-850089 add
         g_sql        STRING,    #FUN-850089 add
         g_str        STRING     #FUN-850089 add
 
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
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bzh01.bzh_file.bzh01,",       #外送單號
              "bzh02.bzh_file.bzh02,",       #單據日期
              "bzi03.bzi_file.bzi03,",       #機器設備編號
              "bza02.bza_file.bza02,",       #機器設備中文名稱
              "bza04.bza_file.bza04,",       #機器設備規格
              "bzb03.bzb_file.bzb03,",       #保管部門
              "bzb04.bzb_file.bzb04,",       #保管人
              "gem02.gem_file.gem02,",       #部門名稱
              "gen02.gen_file.gen02,",       #員工姓名
              "bzi05.bzi_file.bzi05,",       #外送數量
              "bzi08.bzi_file.bzi08,",       #已回收數量
              "bzi0508.type_file.num20_6,",  #未收回數量
              "bzi06.bzi_file.bzi06,",       #外送地點
              "bzi07.bzi_file.bzi07,",       #已預計收回日
              "bzi09.bzi_file.bzi09,",       #備註
              "bzi02.bzi_file.bzi02 "        #項次
                                          #16 items
  LET l_table = cl_prt_temptable('abxr504',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
   LET g_pdate   = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom  = ARG_VAL(2)
   LET g_rlang   = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)
   LET g_prtway  = ARG_VAL(5)
   LET g_copies  = ARG_VAL(6)
   LET tm.wc     = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.a      = ARG_VAL(10)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
      CALL r504_tm(0,0)        # Input print condition
   ELSE 
      CALL r504()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION r504_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 5 LET p_col = 5
 
   OPEN WINDOW r504_w AT p_row,p_col WITH FORM "abx/42f/abxr504"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a     = '3'
   LET tm.more  = 'N'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      #QBE
      CONSTRUCT BY NAME tm.wc ON bzh01,bzh02,bzi03,bzb03,
                                 bzb04,bzi07
         ON ACTION CONTROLP
            CASE 
               WHEN INFIELD(bzh01)      #外送單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_bzh01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzh01
                  NEXT FIELD bzh01
 
               WHEN INFIELD(bzi03)      #機器設備編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_bza1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzi03
                  NEXT FIELD bzi03
               WHEN INFIELD(bzb03)      #保管部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzb03
                  NEXT FIELD bzb03
               WHEN INFIELD(bzb04)      #保管人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzb04
                  NEXT FIELD bzb04
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bzhuser', 'bzhgrup') #FUN-980030
 
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r504_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
        CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      #INPUT
      INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.more WITHOUT DEFAULTS
         AFTER FIELD edate          #edate 不可小於 bdate
            IF NOT cl_null(tm.edate) THEN
               IF tm.bdate > tm.edate THEN
                  NEXT FIELD bdate
               END IF
            END IF
 
         AFTER FIELD a
            IF tm.a NOT MATCHES '[123]' THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD more
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
         CLOSE WINDOW r504_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      #延遲作業
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='abxr504'
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
            CALL cl_err('abxr504','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.a     CLIPPED,"'",
                        " '",tm.bdate CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.more  CLIPPED,"'"
            CALL cl_cmdat('abxr504',g_time,l_cmd)
         END IF
         CLOSE WINDOW r504_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r504()
      ERROR ""
   END WHILE
   CLOSE WINDOW r504_w
END FUNCTION
 
FUNCTION r504()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name
#         l_time    LIKE type_file.chr8          #No.FUN-6A0062
          l_sql     STRING,                      # RDSQL STATEMENT
          sr   RECORD
               bzh01   LIKE bzh_file.bzh01,  #外送單號
               bzi02   LIKE bzi_file.bzi02,  #項次
               bzh02   LIKE bzh_file.bzh02,  #單據日期
               bzi03   LIKE bzi_file.bzi03,  #機器設備編號
               bza02   LIKE bza_file.bza02,  #機器設備名稱
               bza04   LIKE bza_file.bza04,  #機器設備規格
               bzb03   LIKE bzb_file.bzb03,  #保管部門
               gem02      LIKE gem_file.gem02,
               bzb04   LIKE bzb_file.bzb04,  #保管人
               gen02      LIKE gen_file.gen02,
               bzi05   LIKE bzi_file.bzi05,  #外送數量
               bzi08   LIKE bzi_file.bzi08,  #收回數量
               bzi0508 LIKE type_file.num20_6,              #未收回數量
               bzi06   LIKE bzi_file.bzi06,  #外送地點
               bzi07   LIKE bzi_file.bzi07,  #預計收回日
               bzi09   LIKE bzi_file.bzi09   #備註
               END RECORD
 
#FUN-850089 add---START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr504',g_time,1) RETURNING g_time
   #No.FUN-B80082--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND bzhuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND bzhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   LET l_sql = "SELECT bzh01,bzi02,bzh02,bzi03,bza02,",
               "       bza04,bzb03,gem02,bzb04,gen02,bzi05,",
               "       bzi08,0,bzi06,bzi07,bzi09 ",
               "  FROM bzh_file,bzi_file,",
               "       bzb_file,bza_file,",
               "       OUTER gem_file,OUTER gen_file ",
               " WHERE bzh01 = bzi01 ",
               "   AND bzb01 = bzi03 ",
               "   AND bzb02 = bzi04 ",
               "   AND bza01 = bzb01 ",
               "   AND gem_file.gem01 = bzb_file.bzb03 ",
               "   AND gen_file.gen01 = bzb_file.bzb04 ",
               "   AND bzh06 !='X' ",
               "   AND bzh02 BETWEEN '",tm.bdate,"'","AND '",tm.edate,"'",
               "   AND ", tm.wc CLIPPED
 
   IF tm.a='1' THEN
      LET l_sql = l_sql CLIPPED," AND bzh06='Y' "
   END IF
   IF tm.a='2' THEN
      LET l_sql = l_sql CLIPPED," AND bzh06='N' "
   END IF
 
   PREPARE r504_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   DECLARE r504_curs1 CURSOR FOR r504_prepare1
 
   FOREACH r504_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
      IF cl_null(sr.bzi05) THEN LET sr.bzi05 = 0 END IF
      IF cl_null(sr.bzi08) THEN LET sr.bzi08 = 0 END IF
      LET sr.bzi0508 = sr.bzi05 - sr.bzi08  #未收回數量
      #---FUN-850089 add---START
       EXECUTE insert_prep USING sr.bzh01, sr.bzh02, sr.bzi03, sr.bza02,
                                 sr.bza04, sr.bzb03, sr.bzb04, sr.gem02,
                                 sr.gen02, sr.bzi05, sr.bzi08, sr.bzi0508, 
                                 sr.bzi06, sr.bzi07, sr.bzi09, sr.bzi02 
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-850089 add---END
   END FOREACH
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bzh01,bzi02 "
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bzh01,bzh02,bzi03,bzb03,bzb04,bzi07')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str,";",
                tm.bdate USING 'YYYY/MM/DD',";",
                tm.edate USING 'YYYY/MM/DD'
    CALL cl_prt_cs3('abxr504','abxr504',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---

   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr504',g_time,2) RETURNING g_time
   #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
