# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abxr503.4gl
# Descriptions...: 保稅機器設備盤存清冊
# Date & Author..: 2006/10/14 By kim
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
# Modify.........: No.FUN-850089 08/05/28 By TSD.Ken 傳統報表轉Crystal Report
# Modify.........: No.FUN-890101 08/09/24 By dxfwo  CR 追單到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-BB0035 11/11/12 By johung 修正bze01/bzf03開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                               # Print condition RECORD
           wc    STRING,
           year  LIKE type_file.num5,                      # 盤點年度
           s     LIKE type_file.chr1,                   # 不同部門須跳頁否
           c     LIKE type_file.chr1                    # 是否列印盤點數量
           END RECORD
DEFINE g_i LIKE type_file.num5   #count/index for any purpose
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
  LET g_sql ="bze01.bze_file.bze01,",
             "bzf02.bzf_file.bzf02,",
             "bzb03.bzb_file.bzb03,",
             "bzb04.bzb_file.bzb04,",
             "bzf03.bzf_file.bzf03,",
             "bza02.bza_file.bza02,",
             "bza03.bza_file.bza03,",
             "bza04.bza_file.bza04,",
             "bzb06.bzb_file.bzb06,",
             "bza05.bza_file.bza05,",
             "bza06.bza_file.bza06,",
             "bza08.bza_file.bza08,",
             "bzf07.bzf_file.bzf07,",
             "bza09.bza_file.bza09,",
             "bza10.bza_file.bza10, ",
             "bzf05.bzf_file.bzf05, ",
             "bzf06.bzf_file.bzf06, ",
             "bzf08.bzf_file.bzf08, ",
             "gem02.gem_file.gem02,",
             "gen02.gen_file.gen02"
 
  LET l_table = cl_prt_temptable('abxr503',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?)" #20 items
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
  #---FUN-850089 add ---end
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80082--add--
   CALL r503_tm(0,0)             # Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
END MAIN
 
FUNCTION r503_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
 
   LET p_row = 5 LET p_col = 5
   OPEN WINDOW r503_w AT p_row,p_col
        WITH FORM "abx/42f/abxr503" 
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   WHILE TRUE
      LET tm.year = year(g_today)
      LET tm.s    = "N"
      LET tm.c    = "N"
 
      CONSTRUCT BY NAME tm.wc ON bze01,bze02,bzf03,bzb03,bzb04
 
      ON ACTION locale
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bze01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
              #LET g_qryparam.form ="cq_bze01"   #MOD-BB0035 mark
               LET g_qryparam.form ="q_bze01"    #MOD-BB0035
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bze01
               NEXT FIELD bze01
 
            WHEN INFIELD(bzf03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
              #LET g_qryparam.form ="cq_bza1"   #MOD-BB0035 mark
               LET g_qryparam.form ="q_bza1"    #MOD-BB0035
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bzf03
               NEXT FIELD bzf03
            WHEN INFIELD(bzb03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bzb03
               NEXT FIELD bzb03
            WHEN INFIELD(bzb04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bzb04
               NEXT FIELD bzb04
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bzeuser', 'bzegrup') #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r503_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.year,tm.s,tm.c                 # Condition
 
      INPUT BY NAME tm.year,tm.s,tm.c WITHOUT DEFAULTS
         AFTER FIELD s
            IF cl_null(tm.s) OR tm.s NOT MATCHES "[YN]" THEN
               NEXT FIELD s
            END IF
   
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
               NEXT FIELD c
            END IF
 
         ON ACTION locale
             CALL cl_dynamic_locale()
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r503_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80082--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r503()
      ERROR ""
   END WHILE
   CLOSE WINDOW r503_w
END FUNCTION
 
FUNCTION r503()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name
#         l_time    LIKE type_file.chr8          #No.FUN-6A0062
          l_sql     STRING,
          sr    RECORD 
              bze01    LIKE bze_file.bze01,
              bzf02    LIKE bzf_file.bzf02,
              bzb03    LIKE bzb_file.bzb03,
              bzb04    LIKE bzb_file.bzb04,
              bzf03    LIKE bzf_file.bzf03,
              bza02    LIKE bza_file.bza02,
              bza03    LIKE bza_file.bza03,
              bza04    LIKE bza_file.bza04,
              bzb06    LIKE bzb_file.bzb06,
              bza05    LIKE bza_file.bza05,
              bza06    LIKE bza_file.bza06,
              bza08    LIKE bza_file.bza08,
              bzf07    LIKE bzf_file.bzf07,
              bza09    LIKE bza_file.bza09,
              bza10    LIKE bza_file.bza10, 
              bzf05    LIKE bzf_file.bzf05, 
              bzf06    LIKE bzf_file.bzf06, 
              bzf08    LIKE bzf_file.bzf08, 
              gem02    LIKE gem_file.gem02,
              gen02    LIKE gen_file.gen02
                END RECORD
 
#FUN-850089 add---START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr503',g_time,1) RETURNING g_time
   #No.FUN-B80082--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#   CALL cl_outnam('abxr503') RETURNING l_name    #No.FUN-890101
#   START REPORT r503_rep TO l_name               #No.FUN-890101
   LET g_pageno = 0 
#   SELECT azi03 INTO g_azi03 FROM azi_file WHERE azi01=g_aza.aza17      #No.CHI-6A0004 mark
 
   LET l_sql = " SELECT bze01,bzf02,bzb03,bzb04,bzf03,bza02,bza03,bza04,",
               "        bzb06,bza05,bza06,bza08,bzf07,bza09,bza10,bzf05,",
               "        bzf06,bzf08",
               " FROM bze_file,bza_file,bzf_file, bzb_file ",
               " WHERE bza01=bzb01 AND bza01=bzf03 AND bze01=bzf01 ",
               " AND bzb02=bzf04 AND bze04='",tm.year,"' AND ",tm.wc CLIPPED,
               " ORDER By bzb03,bze01,bzf02 "
                 
   PREPARE r503_pb FROM l_sql
   DECLARE r503_curs1 CURSOR FOR r503_pb
 
   FOREACH r503_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) 
         EXIT FOREACH 
      END IF
      IF cl_null(sr.bzf05) THEN LET sr.bzf05 =0  END IF
      IF cl_null(sr.bzf06) THEN LET sr.bzf06 =0  END IF
      IF cl_null(sr.bzf07) THEN LET sr.bzf07 =0  END IF
      IF cl_null(sr.bza09) THEN LET sr.bza09 =0  END IF
      IF cl_null(sr.bza10) THEN LET sr.bza10 =0  END IF
 
      SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01=sr.bzb03
      IF STATUS THEN LET sr.gem02= ' ' END IF
 
      SELECT gen02 INTO sr.gen02 FROM gen_file WHERE gen01=sr.bzb04
      IF STATUS THEN LET sr.gen02= ' ' END IF
      #FUN-850089  ---start---
      EXECUTE insert_prep USING sr.*
      #FUN-850089  ---end---
      
#      OUTPUT TO REPORT r503_rep(sr.*)            #No.FUN-890101
   END FOREACH
 
#   FINISH REPORT r503_rep                        #No.FUN-890101  
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-890101  
   #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'bze01,bze02,bzf03,bzb03,bzb04')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
 
    LET g_str = g_str,";",tm.year,";",tm.s,";",tm.c,";",g_azi03
 
    CALL cl_prt_cs3('abxr503','abxr503',l_sql,g_str)
   #---FUN-850089 add---END

   #No.FUN-B80082--mark--Begin---
   #CALL cl_used('abxr503',g_time,2) RETURNING g_time
   #No.FUN-B80082--mark--End-----
END FUNCTION
 
#REPORT r503_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,
#          l_sum        LIKE type_file.num20_6,
#          l_bzb03      LIKE bzb_file.bzb03,
#          sr    RECORD bze01    LIKE bze_file.bze01,
#                       bzf02    LIKE bzf_file.bzf02,
#                       bzb03    LIKE bzb_file.bzb03,
#                       bzb04    LIKE bzb_file.bzb04,
#                       bzf03    LIKE bzf_file.bzf03,
#                       bza02    LIKE bza_file.bza02,
#                       bza03    LIKE bza_file.bza03,
#                       bza04    LIKE bza_file.bza04,
#                       bzb06    LIKE bzb_file.bzb06,
#                       bza05    LIKE bza_file.bza05,
#                       bza06    LIKE bza_file.bza06,
#                       bza08    LIKE bza_file.bza08,
#                       bzf07    LIKE bzf_file.bzf07,
#                       bza09    LIKE bza_file.bza09,
#                       bza10    LIKE bza_file.bza10, 
#                       bzf05    LIKE bzf_file.bzf05, 
#                       bzf06    LIKE bzf_file.bzf06, 
#                       bzf08    LIKE bzf_file.bzf08, 
#                       gem02    LIKE gem_file.gem02,
#                       gen02    LIKE gen_file.gen02
#                END RECORD
#
#   OUTPUT TOP MARGIN g_top_margin
#          LEFT MARGIN    g_left_margin
#          BOTTOM MARGIN g_bottom_margin
#          PAGE LENGTH    g_page_line
#   ORDER BY sr.bzb03,sr.bze01,sr.bzf02
#
#   FORMAT
#   PAGE HEADER 
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash
#      PRINTX name = H1 g_x[31] CLIPPED,g_x[32] CLIPPED,
#                       g_x[33] CLIPPED,g_x[34] CLIPPED,
#                       g_x[35] CLIPPED,g_x[36] CLIPPED,
#                       g_x[37] CLIPPED,g_x[38] CLIPPED,
#                       g_x[39] CLIPPED,g_x[40] CLIPPED,
#                       g_x[41] CLIPPED,g_x[42] CLIPPED
#      PRINTX name = H2 g_x[43] CLIPPED,g_x[44] CLIPPED,
#                       g_x[45] CLIPPED,g_x[46] CLIPPED,
#                       g_x[47] CLIPPED,g_x[48] CLIPPED,
#                       g_x[49] CLIPPED,g_x[50] CLIPPED,
#                       g_x[51] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.bzb03
#      IF tm.s ='Y' THEN
#         SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      PRINTX name = D1 COLUMN g_c[31],sr.bze01 CLIPPED,
#                       COLUMN g_c[32],sr.bzb03 CLIPPED,
#                       COLUMN g_c[33],sr.gem02 CLIPPED,
#                       COLUMN g_c[34],sr.bzf03 CLIPPED,
#                       COLUMN g_c[35],sr.bza02 CLIPPED,
#                       COLUMN g_c[36],sr.bza04 CLIPPED;
#
#      CASE WHEN sr.bza05 ='1'
#              PRINTX name = D1 COLUMN g_c[37],g_x[12] CLIPPED;
#           WHEN sr.bza05 ='2'
#              PRINTX name = D1 COLUMN g_c[37],g_x[13] CLIPPED;
#           OTHERWISE
#              PRINTX name = D1 '    ';
#      END CASE
#
#            LET l_sum = (sr.bza10/sr.bza09)*sr.bzf05
#      PRINTX name = D1 COLUMN g_c[38],sr.bza08 CLIPPED,
#                       COLUMN g_c[39],sr.bzf05 USING '##########';
#
#            IF tm.c ='N' THEN
#               PRINTX name = D1 COLUMN g_c[40],'__________';
#            ELSE
#               PRINTX name = D1 COLUMN g_c[40],sr.bzf07 USING '##########';
#            END IF
#
#      PRINTX name = D1 COLUMN g_c[41],cl_numfor(l_sum,41,g_azi03),
#                       COLUMN g_c[42],sr.bzf08 CLIPPED
#
#      PRINTX name = D2 COLUMN g_c[43],sr.bzf02 USING '####',
#                       COLUMN g_c[44],sr.bzb04 CLIPPED,
#                       COLUMN g_c[45],sr.gen02 CLIPPED,
#                       COLUMN g_c[46],"",
#                       COLUMN g_c[47],sr.bza03 CLIPPED,
#                       COLUMN g_c[48],sr.bzb06 CLIPPED,
#                       COLUMN g_c[49],sr.bza06 CLIPPED,
#                       COLUMN g_c[50],"",
#                       COLUMN g_c[51],sr.bzf06 USING '##########'
#
#   ON LAST ROW
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#          PRINT g_dash
#          PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[5] CLIPPED
#      ELSE
#          SKIP 2 LINE
#      END IF
#        
#END REPORT
