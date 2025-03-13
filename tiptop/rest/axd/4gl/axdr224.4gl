# Prog. Version..: '5.10.00-08.01.04(00006)'     #
# Pattern name...: axdr224.4gl
# Descriptions...: 集團間銷售預測與實際對比表
# Date & Author..: 04/03/30 By Carrier
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義,放寬ima02
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: No:FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/29 By zhuying 欄位形態定義為LIKE
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/14 By xumin 報表表頭格式修改
# Modify.........: No:FUN-740082 07/05/23 By TSD.liquor 報表改Crystal report
# Modify.........: No:TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法

DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition        #No.FUN-680108 VARCHAR(600)
              a       LIKE type_file.chr1,        #No.FUN-680108 VARCHAR(1)
              b       LIKe type_file.chr1,        #No.FUN-680108 VARCHAR(1)
              bdate   LIKE type_file.num10,      #No.FUN-680108 INTEGER
              edate   LIKE type_file.num10,       #No.FUN-680108 INTEGER
              more    LIKE type_file.chr1         # Input more condition(Y/N) #No.FUN-680108 VARCHAR(1)
              END RECORD,
          l_line  LIKE type_file.chr1000, #輸入打印報表頭的橫線     #No.FUN-680108 VARCHAR(129)
          g_obd04 LIKE type_file.chr1000, #報表頭的l_line上的coc03  #No.FUN-680108 VARCHAR(129)
          g_ogb   LIKE type_file.chr1000, #報表頭的l_line上的coc03  #No.FUN-680108 VARCHAR(129)
          g_value LIKE type_file.chr1000, #on every row中的金額數   #No.FUn-680108 VARCHAR(129)
          g_t     LIKE type_file.num5,    #(7-((g_cnt+1) mod 7 ))+g_cnt #No.FUN-680108 SMALLINT
          g_f_no  LIKE type_file.num5,    #No.FUN-680108 SMALLINT
           g_sql  string,        # RDSQL STATEMENT  #No:FUN-580092 HCN   
          g_cnt   LIKe type_file.num5,    #No.FUN-680108 SMALLINT
          g_obd   ARRAY[200] OF RECORD #coc03組合的矩陣
                  obd04 LIKE obd_file.obd04,
                  ogb   LIKE ogb_file.ogb12
                  END RECORD

DEFINE    g_yy            LIKE type_file.num5,    #No.FUN-680108 SMALLINT  
          g_mm            LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          g_wk            LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          g_xx            LIKE type_file.num5     #No.FUN-680108 SMALLINT
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE    g_str           STRING                  #No.FUN-0704008 TSD.liquor add
DEFINE    l_table         STRING                  #No.FUN-0704008 TSD.liquor add
MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
   #TQC-610088-begin
   #INITIALIZE tm.* TO NULL                # Default condition
   #LET tm.more = 'N'
   #LET tm.a    = '1'
   #LET tm.b    = 'N'
   #TQC-610088-end
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   #TQC-610088-begin
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   LET tm.bdate= ARG_VAL(10)
   LET tm.edate= ARG_VAL(11)
  #LET tm.wc   = ARG_VAL(11)
   #TQC-610088-end
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No:FUN-570264 ---end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF

   #FUN-740082 TSD.liquor add start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> 2007/05/23 TSD.liquor *** ##
   LET g_sql = "obc01.obc_file.obc01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "obc02.obc_file.obc02,",
               "obc03.obc_file.obc03,",
               "obc021.obc_file.obc021,",
               "f_no.type_file.num5,",
               "t_no.type_file.num5,",
               "obd04_s.zaa_file.zaa08,",
               "value_s.zaa_file.zaa08,",
               "line.zaa_file.zaa08,",
               "ogb.zaa_file.zaa08"  
   LET l_table = cl_prt_temptable('axdr224',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,           #No.TQC-780054
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, #No.TQC-780054
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,  ?, ?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #end FUN-740082 add

   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axdr224_tm(0,0)
      ELSE CALL axdr224()
   END IF

END MAIN

FUNCTION axdr224_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680108 SMALLINT
       l_log          LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
       l_cmd          LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(400)

      LET p_row = 5 LET p_col = 12
   OPEN WINDOW axdr224_w AT p_row,p_col
        WITH FORM "axd/42f/axdr224"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a    = '1'
   CALL r224_obc021()
   LET tm.b    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'

 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON obc01 HELP 1

      #No:FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No:FUN-580031 ---end---

      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
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

#No.FUN-570243  --start-
      ON ACTION CONTROLP
            IF INFIELD(obc01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO obc01
               NEXT FIELD obc01
            END IF
#No.FUN-570243 --end--
      #No:FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No:FUN-580031 ---end---

 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axdr224_w EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.bdate,tm.edate,tm.b,tm.more WITHOUT DEFAULTS HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
         END IF
         CALL r224_obc021()
         DISPLAY tm.edate To edate

      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF

      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
         CALL r224_date(tm.bdate)
         IF l_log = '0' THEN
             CALL cl_err('','axd-085',0)
             NEXT FIELD bdate
         END IF

      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         CALL r224_date(tm.edate)
         IF l_log = '0' THEN
             CALL cl_err('','axd-085',0)
             NEXT FIELD bdate
         END IF
         IF tm.bdate > tm.edate THEN NEXT FIELD bdate END IF

      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG CALL cl_cmdask()

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

      #No:FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 ---end---

  END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axdr224_w EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axdr224'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr224','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                        #" '",tm.more  CLIPPED,"'",             #TQC-610088
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264

         CALL cl_cmdat('axdr224',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axdr224_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axdr224()
   ERROR ""
END WHILE
   CLOSE WINDOW axdr224_w
END FUNCTION

FUNCTION r224_date(l_date)
DEFINE l_date   LIKE  obc_file.obc021
DEFINE l_log    LIKE type_file.chr1          #No.FUN-680108 VARCHAR(01) 

    LET l_log ='1'
    IF tm.a MATCHES '[12]' THEN
        IF l_date > 999999 OR l_date < 100001 THEN
           LET l_log = '0'
        END IF
        LET g_yy = l_date/100
        IF tm.a = '1' THEN
            LET g_mm = l_date-g_yy*100
            IF g_mm = 0  THEN
                LET l_log = '0'
            END IF
        ELSE
                LET g_wk = l_date-g_yy*100
                IF g_wk = 0 THEN
                    LET l_log = '0'
                END IF
            END IF
        END IF
    IF tm.a = '3' THEN
        IF l_date > 99999999 OR l_date < 10000001 THEN
            LET l_log = '0'
        END IF
        LET g_yy = l_date/10000
        LET g_xx = l_date - g_yy*10000
        LET g_mm = g_xx/100
        LET g_xx = g_xx - g_mm * 100
        IF (g_mm = 0 OR g_xx =0) THEN
            LET l_log = '0'
        END IF
    END IF
    IF g_mm > 12 OR g_wk > 53 OR g_xx > 3 THEN
        LET l_log = '0'
    END IF
END FUNCTION

FUNCTION r224_obc021()
DEFINE l_yy  LIKE type_file.num5,      #No.FUN-680108 SMALLINT 
       l_mm  LIKE type_file.num5,      #No.FUN-680108 SMALLINT
       l_xx  LIKE type_file.num5,      #No.FUN-680108 SMALLINT
       l_wk  LIKE type_file.num5       #No.FUN-680108 SMALLINT
 
    LET l_yy = YEAR(g_today)
    LET l_mm = MONTH(g_today)
    LET l_xx = DAY(g_today)
    LET l_wk = 1
    IF l_xx < 11 THEN
        LET l_xx = 1
    ELSE
        IF l_xx < 21 THEN LET l_xx = 2
            ELSE LET l_xx = 3
        END IF
    END IF
    CASE tm.a
       WHEN  '1' LET tm.bdate = l_yy*100+l_mm
                 LET tm.edate = tm.bdate
       WHEN  '2' LET tm.bdate = l_yy*100+l_wk
                 LET tm.edate = tm.bdate
       WHEN  '3' LET tm.bdate = (l_yy*100+l_mm)*100+l_xx
                 LET tm.edate = tm.bdate
       OTHERWISE LET tm.bdate = ' '
                 LET tm.edate = tm.bdate
    END CASE
END FUNCTION

FUNCTION axdr224()
   DEFINE l_name        LIKE type_file.chr1000, # External(Disk) file name       #No.FUN-680108 VARCHAR(50)
          l_name1       LIKE type_file.chr1000, #NO.FUN-680108 VARCHAR(50)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0091
          l_sql         LIKE type_file.chr1000, # RDSQL STATEMENT        #No.FUN-680108 VARCHAR(900)
          l_za05        LIKE za_file.za05,      # MOD-4B0067
          l_i,l_j       LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          l_len,l_len1  LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          l_space1      LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          l_space2      LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          l_space4      LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          l_report      LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          l_num_obd04   LIKE type_file.num5,    #No.FUN-680108 SMALLINT
          l_obc01       LIKE obc_file.obc01,
          l_obd12       LIKE obd_file.obd12,
          l_tot         LIKE ogb_file.ogb12,
          sr            RECORD
                               obc01   LIKE obc_file.obc01,
                               ima02   LIKE ima_file.ima02,
                               ima021  LIKE ima_file.ima021,
                               obc02   LIKE obc_file.obc02,
                               obc03   LIKE obc_file.obc03,
                               obc021  LIKE obc_file.obc021,
                               f_no    LIKE type_file.num5,    #No.FUN-680108 SMALLINT  #起始
                               t_no    LIKE type_file.num5,    #No.FUN-680108 SMALLINT  #本次共有多少
             #                 obd04_s LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(129)
             #                 value_s LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(129)
             #                 line    LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(129)
             #                 ogb     LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(129)
                               obd04_s LIKE zaa_file.zaa08,  #TQC-6A0095
                               value_s LIKE zaa_file.zaa08,  #TQC-6A0095
                               line    LIKE zaa_file.zaa08,  #TQC-6A0095
                               ogb     LIKE zaa_file.zaa08   #TQC-6A0095
                        END RECORD

     #str FUN-740084 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740084 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     #end FUN-740084 add

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axdr224'

#####sr丟到report   on every row 的內容
     LET l_sql = "SELECT UNIQUE obc01,ima02,ima021,obc02,obc03,obc021,0,COUNT(*),'','','',''",
                 "  FROM obc_file,ima_file,obd_file ",
                 " WHERE obc01 = ima01 AND obc01 = obd01 ",
                 "   AND obc02 = obd02 AND obc021 = obd021 ",
                 "   AND obc02 = '",tm.a,"'",
                 "   AND obcacti = 'Y' AND obcconf = 'Y' ",
                 "   AND obc01 = ? ",
                 "   AND ",tm.wc CLIPPED,
#                 "   AND obd04 BETWEEN ",tm.bdate," AND ",tm.edate,
                 "   AND obc021 BETWEEN ",tm.bdate," AND ",tm.edate,
                 " GROUP BY obc01,ima02,ima021,obc02,obc03,obc021 ",
                 " ORDER BY obc01,obc021 "

     PREPARE axdr224_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) EXIT PROGRAM END IF
     DECLARE axdr224_curs1 CURSOR FOR axdr224_prepare1

####select unique item no of obc_file
     LET l_sql=" SELECT UNIQUE obc01 FROM obc_file,obd_file ",
               "  WHERE obc02 = '",tm.a,"' AND obc01=obd01 ",
               "    AND obc02 = obd02 AND obc021 = obd021 ",
               "    AND obcacti = 'Y' AND obcconf = 'Y' ",
#               "    AND obd04 BETWEEN ",tm.bdate," AND ",tm.edate,
               "    AND obc021 BETWEEN ",tm.bdate," AND ",tm.edate,
               "    AND ",tm.wc CLIPPED
     PREPARE axdr224_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) EXIT PROGRAM END IF
     DECLARE axdr224_curs2 CURSOR FOR axdr224_prepare2

     CALL cl_outnam('axdr224') RETURNING l_name
     LET g_len = 120
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     LET g_pageno = 0

     FOREACH axdr224_curs2 INTO l_obc01
         IF SQLCA.sqlcode  THEN
            CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
         END IF
         FOR l_i = 1 TO 200
             INITIALIZE g_obd[l_i] TO NULL
         END FOR
         DECLARE obd04_curs CURSOR FOR
          SELECT UNIQUE obd04 FROM obd_file,obc_file
           WHERE obd01=l_obc01 AND obd02=tm.a
#             AND obd04 BETWEEN tm.bdate AND tm.edate
             AND obc021 BETWEEN tm.bdate AND tm.edate
             AND obd01=obc01 AND obd02=obc02 AND obd021=obc021
             AND obcacti = 'Y' AND obcconf = 'Y'
           ORDER BY obd04
         LET l_i = 1
         FOREACH obd04_curs INTO g_obd[l_i].obd04
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
            END IF
            CALL r224_ogb(l_obc01,g_obd[l_i].obd04) RETURNING l_tot
            IF cl_null(l_tot) THEN LET l_tot=0 END IF
            LET g_obd[l_i].ogb=l_tot
            LET l_i = l_i + 1
         END FOREACH
         LET g_cnt = l_i - 1   #obd04總數

####g_t=8-(g_cnt mod 8) + g_cnt 多出的1指的是最后打印的小計
         LET l_i = g_cnt / 8
         IF g_cnt MOD 8 = 0 THEN
            LET g_t = g_cnt
         ELSE
            LET g_t = (l_i + 1) * 8
         END IF
         FOR l_i = 1 TO g_t STEP 8   #每次8個obd04
             LET g_obd04=''
             LET g_ogb  =''
             LET l_line = '--------'
             LET l_space1 = 0
             FOR l_j = 0 TO 7 #組g_obd04,l_line
                 LET g_obd04=g_obd04 CLIPPED,' ',l_space1 SPACES,
                             g_obd[l_i+l_j].obd04 USING "<<<<<<<<"
                 LET g_ogb  =g_ogb   CLIPPED,' ',
                             g_obd[l_i+l_j].ogb   USING "##,###,##&.&&&"
                 LET l_len = 0
                 LET l_space1 = 0
                 LET l_len  = LENGTH(g_obd[l_i+l_j].obd04)
                 LET l_space1 = 14 - l_len
                 IF l_len <>0 THEN
                    LET l_line = l_line CLIPPED,' --------------'
                 END IF
             END FOR
             FOREACH axdr224_curs1 USING l_obc01 INTO sr.*
                 IF SQLCA.sqlcode  THEN
                    CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
                 END IF
                 LET g_value = ''
                 LET l_obd12 = 0
                 LET l_space4=0
                 FOR l_j = 0 TO 7
                     LET l_obd12=0
                     LET g_f_no=1
                     #當前obd01,obd02,obd021,obd04的obd12,obd07
                     SELECT obd12 INTO l_obd12 FROM obd_file
                      WHERE obd01 =sr.obc01  AND obd02=tm.a
                        AND obd021=sr.obc021 AND obd04=g_obd[l_i+l_j].obd04
                     IF SQLCA.sqlcode=100 THEN LET g_f_no=0 END IF
                     IF cl_null(l_obd12) THEN LET l_obd12 = 0 END IF
                     #不打多余的0
                     IF l_i + l_j <= g_cnt THEN
                        IF g_f_no = 1 THEN
                           LET g_value = g_value CLIPPED,l_space4 SPACES,
                                         l_obd12 USING " --,---,--&.&&&"
                           LET l_space4=0
                        ELSE
                           LET l_space4=l_space4+15
                        END IF
                     END IF
                 END FOR
                 LET sr.value_s = g_value
                 LET sr.obd04_s = g_obd04
                 LET sr.ogb  = g_ogb
                 LET sr.line = l_line
                 #str FUN-740015 add
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-740015 *** ##
                   EXECUTE insert_prep USING 
                     sr.obc01,sr.ima02,sr.ima021,sr.obc02,sr.obc03,sr.obc021,
                     sr.f_no,sr.t_no,sr.obd04_s,sr.value_s,sr.line,sr.ogb
                 #------------------------------ CR (3) ------------------------------#
                 #end FUN-740084 add
             END FOREACH
         END FOR
     END FOREACH

     #str FUN-740084 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-740084 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'obc01')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,';',tm.a,';',tm.b
     CALL cl_prt_cs3('axdr224','axdr224',l_sql,g_str)  
     #------------------------------ CR (4) ------------------------------#
     #end FUN-740084 add
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT axdr224_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,                 #No.FUN-680108 VARCHAR(1)
          sr        RECORD
                      obc01   LIKE obc_file.obc01,
                      ima02   LIKE ima_file.ima02,
                      ima021  LIKE ima_file.ima021,
                      obc02   LIKE obc_file.obc02,
                      obc03   LIKE obc_file.obc03,
                      obc021  LIKE obc_file.obc021,
                      f_no    LIKE type_file.num5,     #No.FUN-680108 SMALLINT  #起始
                      t_no    LIKE type_file.num5,     #No.FUN-680108 SMALLINT   #本次共有多少
    #                 obd04_s LIKE type_file.chr1000,  #No.FUN-680108 VARCHAR(129)
    #                 value_s LIKE type_file.chr1000,  #No.FUN-680108 VARCHAR(129)
    #                 line    LIKE type_file.chr1000,  #No.FUN-680108 VARCHAR(129)
    #                 ogb     LIKE type_file.chr1000   #No.FUN-680108 VARCHAR(129)
                               obd04_s LIKE zaa_file.zaa08,  #TQC-6A0095
                               value_s LIKE zaa_file.zaa08,  #TQC-6A0095
                               line    LIKE zaa_file.zaa08,  #TQC-6A0095
                               ogb     LIKE zaa_file.zaa08   #TQC-6A0095
                    END RECORD,
          l_j       LIKE type_file.num5,     #No.FUN-680108 SMALLINT
          l_tmp     LIKE type_file.num5,     #No.FUN-680108 SMALLINT
          l_desc    LIKE type_file.chr20     #No.FUN-680108 VARCHAR(20)
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.obc01,sr.obd04_s,sr.obc021

  FORMAT
   PAGE HEADER
         PRINT
         PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
         IF g_towhom IS NULL OR g_towhom = ' ' THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
         END IF
#         PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED   #TQC-6A0095
#         PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED  #TQC-6A0095
#         PRINT ' '  #TQC-6A0095
         PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#               COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
               COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'    #TQC-6A0095
         PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED  #TQC-6A0095
         PRINT ' '   #TQC-6A0095
         PRINT g_dash[1,g_len]

         LET l_last_sw = 'n'

   BEFORE GROUP OF sr.obc01
         IF tm.b='Y' THEN SKIP TO TOP OF PAGE END IF
         CASE tm.a
              WHEN '1'  CALL cl_getmsg('axm-024',g_lang) RETURNING l_desc
              WHEN '2'  CALL cl_getmsg('axm-025',g_lang) RETURNING l_desc
              WHEN '3'  CALL cl_getmsg('axm-026',g_lang) RETURNING l_desc
         END CASE
         PRINT COLUMN  1,g_x[11] CLIPPED,sr.obc01 CLIPPED,
 #MOD-4B0067(BEGIN)
               COLUMN 61,g_x[12] CLIPPED,sr.obc02 CLIPPED,' ',l_desc CLIPPED,
               COLUMN 84,g_x[13] CLIPPED,sr.obc03 CLIPPED  #TQC-6A0095
         PRINT COLUMN 01,g_x[16] CLIPPED,sr.ima02 CLIPPED
         PRINT COLUMN 01,g_x[17] CLIPPED,sr.ima021 CLIPPED
         PRINT
 #MOD-4B0067(END)
   BEFORE GROUP OF sr.obd04_s
         PRINT COLUMN  1,g_x[14] CLIPPED,COLUMN 9,sr.obd04_s CLIPPED  #TQC-6A0095
         PRINT COLUMN  1,sr.line CLIPPED

   ON EVERY ROW
         PRINT COLUMN  1,sr.obc021 USING "<<<<<<<<",
               COLUMN  9,sr.value_s CLIPPED  #TQC-6A0095

   AFTER GROUP OF sr.obd04_s
         PRINT
#         PRINT g_x[15] CLIPPED,sr.ogb[2,129]
         PRINT g_x[15] CLIPPED,sr.ogb[2,100]   #TQC-6A0095
         PRINT

   AFTER GROUP OF sr.obc01
         PRINT

   ON LAST ROW
        PRINT g_dash[1,g_len] CLIPPED
        LET l_last_sw = 'y'
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED

   PAGE TRAILER
        IF l_last_sw = 'n' THEN
           PRINT g_dash[1,g_len] CLIPPED
           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINE
        END IF
END REPORT

FUNCTION r224_ogb(p_obc01,p_obd04)
DEFINE p_obc01    LIKE obc_file.obc01
DEFINE p_obd04    LIKE obd_file.obd04
DEFINE l_adi01    LIKE adi_file.adi01
DEFINE l_adi02    LIKE adi_file.adi02
DEFINE l_adi18    LIKE adi_file.adi18
DEFINE l_oga03    LIKE oga_file.oga03
DEFINE l_ogb01    LIKE ogb_file.ogb01
DEFINE l_ogb03    LIKE ogb_file.ogb03
DEFINE l_tot      LIKE ogb_file.ogb12
DEFINE l_ogb15    LIKE ogb_file.ogb15
DEFINE l_ogb16    LIKE ogb_file.ogb16
DEFINE l_dbs      LIKE azp_file.azp03
DEFINE l_ima25    LIKE ima_file.ima25   #庫存單位
DEFINE l_fac      LIKE ima_file.ima31_fac #No.FUN-680108 DEC(16,8)
DEFINE l_i,l_cnt  LIKE type_file.num5     #No.FUN-680108 SMALLINT
DEFINE l_flag     LIKE type_file.num5     #No.FUN-680108 SMALLINT
DEFINE l_obd      ARRAY[200] OF RECORD #coc03組合的矩陣
                  obd021 LIKE obd_file.obd021,
                  obd03  LIKE obd_file.obd03
                  END RECORD

   LET l_tot=0
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=p_obc01
   IF SQLCA.sqlcode THEN    #庫存單位有error
      LET l_tot=0 RETURN
   END IF

   FOR l_i = 1 TO 200
       INITIALIZE l_obd[l_i] TO NULL
   END FOR
   DECLARE obd021_3_cur CURSOR FOR
    SELECT obd021,obd03 FROM obd_file
     WHERE obd01=p_obc01 AND obd02=tm.a AND obd04=p_obd04
   LET l_i=1
   FOREACH obd021_3_cur INTO l_obd[l_i].*
      IF SQLCA.sqlcode  THEN
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
      END IF
      LET l_i=l_i+1
   END FOREACH
   LET l_cnt=l_i-1

   #部份條件為撥入時的內容,如果撥入有改變那麼這里也要改變
   DECLARE ogb_curs CURSOR FOR
    SELECT UNIQUE oga03,ogb01,ogb03,ogb31,ogb32,ogb15,ogb16
      FROM oga_file,ogb_file
     WHERE oga01=ogb01 AND oga00 ='1' AND oga08='1'   AND oga09 IN ('2','8') #No.FUN-610020
       AND oga65 ='N'     #No.FUN-610020
       AND oga20='Y'   AND oga903='Y' AND ogaconf='Y' AND oga30='N'
       AND ogapost='Y' AND ogb04=p_obc01
   FOREACH ogb_curs INTO l_oga03,l_ogb01,l_ogb03,
                         l_adi01,l_adi02,l_ogb15,l_ogb16
       IF SQLCA.sqlcode  THEN
          CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
       END IF
       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=l_oga03
       IF SQLCA.sqlcode THEN
          CONTINUE FOREACH
       END IF
       LET l_flag=0
       FOR l_i=1 TO l_cnt
           LET g_sql="SELECT * FROM ",l_dbs CLIPPED,".adi_file",
                     " WHERE adi01='",l_adi01,"' AND adi02=",l_adi02,
                     "   AND adi18='",tm.a,"' AND adi19=",l_obd[l_i].obd021,
                     "   AND adi20=",l_obd[l_i].obd03,
                     "   AND adi05='",p_obc01,"'"
           PREPARE r224_ogb_1 FROM g_sql
           IF SQLCA.sqlcode THEN
              CALL cl_err('select adi',SQLCA.sqlcode,1)
           END IF
           EXECUTE r224_ogb_1
           IF SQLCA.sqlerrd[3]>0 THEN LET l_flag=1 END IF
       END FOR
       IF l_flag=0 THEN CONTINUE FOREACH END IF   #沒應對應撥入單
       IF cl_null(l_ogb16) THEN LET l_ogb16=0 END IF
       CALL s_umfchk(p_obc01,l_ogb15,l_ima25) RETURNING g_cnt,l_fac
       IF g_cnt=1 THEN
          CALL cl_err('','abm-731',0)
          LET l_fac=1
       END IF
       LET l_tot=l_tot+l_ogb16*l_fac
   END FOREACH
   RETURN l_tot
END FUNCTION
#Patch....NO:TQC-610037 <001,002,003,004> #
