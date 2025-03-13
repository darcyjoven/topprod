# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: atmr219.4gl
# Descriptions...: 債權系列明細表
# Date & Author..: 06/04/06  By Elva
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-850152 08/05/29 By ChenMoyna 舊報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
                 wc       STRING,      # Where condition 
                 a        LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)       # 打印產品明細
                 more     LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD 
#No.FUN-850152 --Begin
   DEFINE g_str LIKE type_file.chr1000
   DEFINE #g_sql LIKE type_file.chr1000
          g_sql    STRING     #NO.FUN-910082
   DEFINE l_table  STRING     #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
#No.FUN-850152
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
#No.FUN-850152 --Begin
   LET g_sql="tqh01.tqh_file.tqh01,",
             "tqa02a.tqa_file.tqa02,",
             "tqh02.tqh_file.tqh02,",
             "tqa02b.tqa_file.tqa02,",
             "tqhacti.tqh_file.tqhacti,",
             "ima01.ima_file.ima01,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021"
   LET l_table=cl_prt_temptable('atmr219',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
#No.FUN-850152
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r219_tm(0,0)
   ELSE
      CALL r219()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r219_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680120 SMALLINT
          l_flag       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW r219_w AT p_row,p_col
     WITH FORM "atm/42f/atmr219"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tqh01,tqh02
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
           IF INFIELD(tqh01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqa1"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 ='20'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tqh01
              NEXT FIELD tqh01
           END IF
           IF INFIELD(tqh02) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqa1"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 ='3'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO tqh02
              NEXT FIELD tqh02
           END IF
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         CLOSE WINDOW r219_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
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
         CLOSE WINDOW r219_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='atmr219'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('atmr219','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('atmr219',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r219_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r219()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r219_w
 
END FUNCTION
 
 
FUNCTION r219()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680120 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,        #No.FUN-680120 VARCHAR(300)
          sr        RECORD
                       tqh01   LIKE tqh_file.tqh01,
                       tqa02a  LIKE tqa_file.tqa02,
                       tqh02   LIKE tqh_file.tqh02,
                       tqa02b  LIKE tqa_file.tqa02,
                       tqhacti LIKE tqh_file.tqhacti, 
                       ima01   LIKE ima_file.ima01,
                       ima02   LIKE ima_file.ima02,
                       ima021  LIKE ima_file.ima021
                    END RECORD
 
#No.FUN-850152 --Begin
   LET g_sql=" INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
       EXIT PROGRAM
   END IF
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='atmr219'
#No.FUN-850152 --End
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND tqhuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND tqhgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND tqhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tqhuser', 'tqhgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT tqh01,'',tqh02,'',tqhacti,ima01,ima02,ima021 ",
               "  FROM tqh_file,OUTER ima_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND ima_file.ima1006=tqh_file.tqh02 ",
               " ORDER BY tqh01,tqh02,ima01 "
   PREPARE r219_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   DECLARE r219_curs1 CURSOR FOR r219_prepare1
#No.FUN-850152 --Begin
#  CALL cl_outnam('atmr219') RETURNING l_name
#  START REPORT r219_rep TO l_name
 
#  LET g_pageno = 0
#No.FUN-850152 --End
   FOREACH r219_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT tqa02 INTO sr.tqa02a 
        FROM tqa_file
       WHERE tqa01=sr.tqh01
         AND tqa03='20'
 
      SELECT tqa02 INTO sr.tqa02b 
        FROM tqa_file
       WHERE tqa01=sr.tqh02
         AND tqa03='3'
#No.FUN-850152 --Begin
#     OUTPUT TO REPORT r219_rep(sr.*)
      EXECUTE insert_prep USING sr.*
#No.FUN-850152 --End
   END FOREACH
 
#No.FUN-850152 --Begin
#  FINISH REPORT r219_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'tqh01,tqh02')
                RETURNING tm.wc
   ELSE
        LET tm.wc=""
   END IF
   LET g_str=tm.wc,';',tm.a
   CALL cl_prt_cs1('atmr219','atmr219',g_sql,g_str)
 
#No.FUN-850152 --End
 
END FUNCTION
 
REPORT r219_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          sr       RECORD
                       tqh01   LIKE tqh_file.tqh01,
                       tqa02a  LIKE tqa_file.tqa02,
                       tqh02   LIKE tqh_file.tqh02,
                       tqa02b  LIKE tqa_file.tqa02,
                       tqhacti LIKE tqh_file.tqhacti, 
                       ima01   LIKE ima_file.ima01,
                       ima02   LIKE ima_file.ima02,
                       ima021  LIKE ima_file.ima021
                   END RECORD 
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.tqh01,sr.tqh02,sr.ima01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.tqh02
         PRINT COLUMN g_c[31],sr.tqh01,
               COLUMN g_c[32],sr.tqa02a,
               COLUMN g_c[33],sr.tqh02,
               COLUMN g_c[34],sr.tqa02b,
               COLUMN g_c[35],sr.tqhacti
 
      ON EVERY ROW
         IF tm.a = 'Y' THEN
            PRINT COLUMN g_c[33],sr.ima01,
                  COLUMN g_c[34],sr.ima02,
                  COLUMN g_c[35],sr.ima021 
         END IF
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     
            CALL cl_wcchp(tm.wc,'tqh01,tqh02') RETURNING tm.wc
            PRINT g_dash[1,g_len]
            CALL cl_prt_pos_wc(tm.wc)
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
#No.FUN-870144
