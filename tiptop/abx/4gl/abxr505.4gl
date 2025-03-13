# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxr505.4gl
# Descriptions...: 保稅機器設備異動明細表
# Date & Author..: 2006/10/16 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-850089 08/05/16 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                 # Print condition RECORD
           wc      STRING,    # Where condition
           more    LIKE type_file.chr1         #其它特殊列印條件 
           END RECORD
DEFINE   l_table      STRING,    #FUN-850089 add
         g_sql        STRING,    #FUN-850089 add
         g_str        STRING     #FUN-850089 add
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate   = ARG_VAL(1)     #  command line
   LET g_towhom  = ARG_VAL(2)
   LET g_rlang   = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)
   LET g_prtway  = ARG_VAL(5)
   LET g_copies  = ARG_VAL(6)
   LET tm.wc     = ARG_VAL(7)
   LET tm.more   = ARG_VAL(8)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("abx")) THEN
      EXIT PROGRAM
   END IF
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bzp01.bzp_file.bzp01,",       #單據單號
              "bzp02.bzp_file.bzp02,",       #單據項次
              "bzp04.bzp_file.bzp04,",       #性質
              "bzp09.bzp_file.bzp09,",       #確認日期
              "bzp03.bzp_file.bzp03,",       #異動日期
              "bzp06.bzp_file.bzp06,",       #機器設備編號
              "bza02.bza_file.bza02,",       #機器設備中文名稱
              "bza04.bza_file.bza04,",       #機器設備規格
              "bzb03.bzb_file.bzb03,",       #保管部門
              "gem02.gem_file.gem02,",       #部門名稱
              "bzb04.bzb_file.bzb04,",       #保管人
              "gen02.gen_file.gen02,",       #員工姓名
              "bzp08.bzp_file.bzp08 "        #異動數量
                                          #13 items
  LET l_table = cl_prt_temptable('abxr505',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   IF NOT cl_null(tm.wc) THEN
      CALL r505()
   ELSE
      CALL r505_tm(0,0)
   END IF 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add-- 
END MAIN
 
FUNCTION r505_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 5 LET p_col = 5
 
   OPEN WINDOW r505_w AT p_row,p_col WITH FORM "abx/42f/abxr505"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
         #QBE
      CONSTRUCT BY NAME tm.wc ON bzp01,bzp03,bzp09,bzp04
 
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bzp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="cq_bzp01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO bzp01
                  NEXT FIELD bzp01
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r505_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      #INPUT
      INPUT BY NAME tm.more WITHOUT DEFAULTS
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
 
         ON ACTION CONTROLG 
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
         CLOSE WINDOW r505_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='abxr505'
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
            CALL cl_err('abxr505','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'"
 
            CALL cl_cmdat('abxr505',g_time,l_cmd)
         END IF
         CLOSE WINDOW r505_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r505()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r505_w
END FUNCTION
 
FUNCTION r505()
   DEFINE l_name   LIKE type_file.chr20,     # External(Disk) file name
#         l_time   LIKE type_file.chr8       #No.FUN-6A0062
          l_sql    STRING                    # RDSQL STATEMENT
   
   DEFINE sr       RECORD
                   bzp01   LIKE bzp_file.bzp01,  #異動單號
                   bzp02   LIKE bzp_file.bzp02,  #項次
                   bzp04   LIKE bzp_file.bzp04,  #異動性質
                   bzp09   LIKE bzp_file.bzp09,  #確認日期
                   bzp03   LIKE bzp_file.bzp03,  #單據日期
                   bzp06   LIKE bzp_file.bzp06,  #機器設備編號
                   bza02   LIKE bza_file.bza02,  #機器設備名稱
                   bza04   LIKE bza_file.bza04,  #機器設備規格
                   bzb03   LIKE bzb_file.bzb03,  #保管部門
                   gem02      LIKE gem_file.gem02,
                   bzb04   LIKE bzb_file.bzb04,  #保管人
                   gen02      LIKE gen_file.gen02,
                   bzp08   LIKE bzp_file.bzp08  #異動數量
                   END RECORD
 
#FUN-850089 add---START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr505',g_time,1) RETURNING g_time
   #No.FUN-B80082--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND bzhuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND bzhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   LET l_sql = "SELECT bzp01,bzp02,bzp04,bzp09,",
               "       bzp03,bzp06,bza02, ",
               "       bza04,bzb03,gem02,bzb04,gen02,bzp08 ",
               " FROM bzp_file ,bza_file , bzb_file, ",
               "      OUTER gem_file,OUTER gen_file",
               " WHERE bzb01 = bzp06 ",
               "   AND bza01 = bzb01 AND bzb02 = bzp07 ",
               "   AND gen_file.gen01 = bzb_file.bzb04 AND gem_file.gem01 = bzb_file.bzb03 ",
               "   AND ", tm.wc CLIPPED,
               " ORDER BY bzp04,bzp06,bzp09"  #FUN-850089 add bzp04 使CR報表排序能夠一致
 
   PREPARE r505_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
      EXIT PROGRAM
   END IF
   DECLARE r505_curs1 CURSOR FOR r505_prepare1
 
   FOREACH r505_curs1 INTO sr.*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
     END IF
      #---FUN-850089 add---START
       EXECUTE insert_prep USING sr.bzp01, sr.bzp02, sr.bzp04, sr.bzp09,
                                 sr.bzp03, sr.bzp06, sr.bza02, sr.bza04,
                                 sr.bzb03, sr.gem02, sr.bzb04, sr.gen02, 
                                 sr.bzp08 
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-850089 add---END
   END FOREACH
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bzp04,bzp06,bzp09 "
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bzp01,bzp03,bzp09,bzp04')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str
    CALL cl_prt_cs3('abxr505','abxr505',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---

   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr505',g_time,2) RETURNING g_time
   #No.FUN-B80082--mark--End-----
END FUNCTION
#No.FUN-870144
