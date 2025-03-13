# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abgr030.4gl
# Descriptions...: 部門人工成本預算明細表
# Date & Author..: 02/12/13 By qazzaq
# Modify.........: No.FUN-510025 05/01/12 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-860016 08/06/17 By TSD.Wind 傳統報表轉Crystal Report
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-990268 09/10/19 By sabrina 這支程式使用的是bgv_file而不是bgo_file 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    tm     RECORD
                 more    LIKE type_file.chr1,     #No.FUN-680061  VARCHAR(01),
                 bgv01   LIKE bgv_file.bgv01,
                 bgv02   LIKE bgv_file.bgv02,
                 #bgv04  LIKE bgv_file.bgv04,
                 wc      STRING                   #No.TQC-630166
                 END RECORD
DEFINE  bgv04_t  LIKE bgv_file.bgv04,    #部門
        bgv07_t  LIKE bgv_file.bgv07,    #職等
        bgv08_t  LIKE bgv_file.bgv08,    #職級
        bgv06_t  LIKE bgv_file.bgv06,    #直/間接
        bgs02_t  LIKE bgs_file.bgs02     #費用項目說明
 
DEFINE  g_i      LIKE type_file.num5     #No.FUN-680061   SMALLINT
DEFINE   l_table      STRING,    #FUN-860016 add
         g_sql        STRING,    #FUN-860016 add
         g_str        STRING     #FUN-860016 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
 
#---FUN-860016 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bgv03.bgv_file.bgv03,",    #月份
              "bgv04.bgv_file.bgv04,",    #部門
              "bgv07.bgv_file.bgv07,",    #職等
              "bgv08.bgv_file.bgv08,",    #職級
              "bgv06.bgv_file.bgv06,",    #直/間接
              "bgs02.bgs_file.bgs02,",    #費用項目說明
              "bgv10.bgv_file.bgv10,",    #金額
              "m1.bgv_file.bgv10,",
              "m2.bgv_file.bgv10,",
              "m3.bgv_file.bgv10,",
              "m4.bgv_file.bgv10,",
              "m5.bgv_file.bgv10,",
              "m6.bgv_file.bgv10,",
              "m7.bgv_file.bgv10,",
              "m8.bgv_file.bgv10,",
              "m9.bgv_file.bgv10,",
              "m10.bgv_file.bgv10,",
              "m11.bgv_file.bgv10,",
              "m12.bgv_file.bgv10,",
              "l_gem02.gem_file.gem02"
 
                                          #20 items
  LET l_table = cl_prt_temptable('abgr030',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
              "        ?,?,?,?,?) "
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-860016 add ---end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
   LET g_trace  = 'N'
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bgv01 = ARG_VAL(8)   #TQC-610054
   LET tm.bgv02 = ARG_VAL(9)   #TQC-610054
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF NOT cl_null(tm.wc) THEN
      CALL r030()
   ELSE
      CALL r030_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r030_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
 
DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680061  SMALLINT
DEFINE l_cmd         LIKE type_file.chr1000  #No.FUN-680061  VARCHAR(1000)
 
      LET p_row = 5 LET p_col = 13
   OPEN WINDOW r030_w AT p_row,p_col
        WITH FORM "abg/42f/abgr030"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_rlang = g_lang
   LET g_pdate = g_today
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bgv04 HELP 1            #組QBE
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
 IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
        IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r030_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
INPUT BY NAME tm.bgv01,tm.bgv02,tm.more
      WITHOUT DEFAULTS HELP 1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bgv01
         IF cl_null(tm.bgv01) THEN
            LET tm.bgv01=' '
         END IF
 
      AFTER FIELD bgv02
         IF cl_null(tm.bgv02) OR (tm.bgv02<0) THEN
            NEXT FIELD bgv02
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
 
        ON ACTION CONTROLG
CALL cl_cmdask()
      ON ACTION CONTROLT LET g_trace = 'Y'
   AFTER INPUT
#      LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
#      LET tm.t = tm2.t1,tm2.t2,tm2.t3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r030_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='abgr030'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr030','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bgv01 CLIPPED,"'",   #TQC-610054
                         " '",tm.bgv02 CLIPPED,"'",   #TQC-610054
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr030',g_time,l_cmd)
      END IF
      CLOSE WINDOW r030_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r030()
   ERROR ""
END WHILE
   CLOSE WINDOW r030_w
END FUNCTION
 
FUNCTION r030()
DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061   VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0056
DEFINE l_sql     LIKE type_file.chr1000  #No.FUN-680061   VARCHAR(1000)
DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061   VARCHAR(40)
DEFINE l_t       LIKE type_file.chr1     #No.FUN-680061   VARCHAR(1)
DEFINE l_order   ARRAY[5] OF LIKE cre_file.cre08       #No.FUN-680061    ARRAY[5] OF VARCHAR(10)
DEFINE sr        RECORD
                     bgv03     LIKE bgv_file.bgv03,    #月份
                     bgv04     LIKE bgv_file.bgv04,    #部門
                     bgv07     LIKE bgv_file.bgv07,    #職等
                     bgv08     LIKE bgv_file.bgv08,    #職級
                     bgv06     LIKE bgv_file.bgv06,    #直/間接
                     bgs02     LIKE bgs_file.bgs02,    #費用項目說明
                     bgv10     LIKE bgv_file.bgv10,    #金額
                     m1        LIKE bgv_file.bgv10,
                     m2        LIKE bgv_file.bgv10,
                     m3        LIKE bgv_file.bgv10,
                     m4        LIKE bgv_file.bgv10,
                     m5        LIKE bgv_file.bgv10,
                     m6        LIKE bgv_file.bgv10,
                     m7        LIKE bgv_file.bgv10,
                     m8        LIKE bgv_file.bgv10,
                     m9        LIKE bgv_file.bgv10,
                     m10       LIKE bgv_file.bgv10,
                     m11       LIKE bgv_file.bgv10,
                     m12       LIKE bgv_file.bgv10
                 END RECORD
 
#FUN-860016 add---START
DEFINE l_gem02    LIKE gem_file.gem02
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-860016 add---END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bgouser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bgogrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bgogrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bgouser', 'bgogrup')  #MOD-990268 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bgvuser', 'bgvgrup')  #MOD-990268 add
     #End:FUN-980030
 
  LET l_sql = " SELECT bgv03,bgv04,bgv07,bgv08,bgv06,bgs02,bgv10, ",
                 "        0,0,0,0,0,0,0,0,0,0,0,0 ", #FUN-860016
                 " FROM bgv_file,bgs_file",
                 " WHERE bgv01 ='",tm.bgv01 ,"'",
                 "   AND bgv02 =",tm.bgv02 CLIPPED,
                 "   AND bgv05=bgs01 ",
                 "   AND ",tm.wc CLIPPED
 
     LET l_sql = l_sql CLIPPED," ORDER BY bgv04,bgv07,bgv08,bgv06,bgs02 "
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r030_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
     END IF
     DECLARE r030_curs1 CURSOR FOR r030_prepare1
     FOREACH r030_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        CASE
           WHEN sr.bgv03 =1
                LET sr.m1 = sr.bgv10
           WHEN sr.bgv03 =2
                LET sr.m2 = sr.bgv10
           WHEN sr.bgv03 =3
                LET sr.m3 = sr.bgv10
           WHEN sr.bgv03 =4
                LET sr.m4 = sr.bgv10
           WHEN sr.bgv03 =5
                LET sr.m5 = sr.bgv10
           WHEN sr.bgv03 =6
                LET sr.m6 = sr.bgv10
           WHEN sr.bgv03 =7
                LET sr.m7 = sr.bgv10
           WHEN sr.bgv03 =8
                LET sr.m8 = sr.bgv10
           WHEN sr.bgv03 =9
                LET sr.m9 = sr.bgv10
           WHEN sr.bgv03 =10
                LET sr.m10 = sr.bgv10
           WHEN sr.bgv03 =11
                LET sr.m11 = sr.bgv10
           WHEN sr.bgv03 =12
                LET sr.m12 = sr.bgv10
        END CASE
 
        #---FUN-860016 add---START
        LET l_gem02 = NULL
        SELECT gem02 INTO l_gem02 FROM gem_file
           WHERE gem01 = sr.bgv04
                                               
        EXECUTE insert_prep USING   sr.bgv03, sr.bgv04, sr.bgv07, sr.bgv08,
                                    sr.bgv06, sr.bgs02, sr.bgv10, sr.m1,
                                    sr.m2,    sr.m3,    sr.m4,    sr.m5, 
                                    sr.m6,    sr.m7,    sr.m8,    sr.m9,
                                    sr. m10,  sr.m11,   sr.m12,   l_gem02
 
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-860016 add---END
 
     END FOREACH
 
  #FUN-860016  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bgv04,bgv07,bgv08,bgv06,bgs02"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bgv04')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str,";",g_azi04
    CALL cl_prt_cs3('abgr030','abgr030',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-860016  ----end---
 
END FUNCTION
#No.FUN-870144 
