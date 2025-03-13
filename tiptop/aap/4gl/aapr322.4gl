# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapr322.4gl
# Descriptions...: 付款總表
# Date & Author..: 93/01/14  By  Felicity  Tseng
# Modify.........: No.FUN-4C0097 04/12/28 By Nicola 報表架構修改
#                                                   增加列印員工姓名gen02
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間
#
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/10 By baogui 結束位置調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-B20014 11/02/12 By lilingyu SQL增加apf00<>'32' or apf00<>'36'的條件
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
                 #wc       LIKE type_file.chr1000,     # Where condition   #TQC-630166  #No.FUN-690028 VARCHAR(600)
                 wc       STRING,      # Where condition   #TQC-630166
                 b_date   LIKE type_file.dat,          # 起始日期  #No.FUN-690028 DATE
                 e_date   LIKE type_file.dat,          # 截止日期  #No.FUN-690028 DATE
                 more     LIKE type_file.chr1          # No.FUN-690028 VARCHAR(1)          # Input more condition(Y/N)
              END RECORD,
          g_amt_1      LIKE aph_file.aph05,
          g_amt_2      LIKE aph_file.aph05,
          g_amt_3      LIKE aph_file.aph05,
          g_amt_4      LIKE aph_file.aph05
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b_date  = ARG_VAL(8)
   LET tm.e_date  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r322_tm(0,0)
   ELSE
      CALL r322()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r322_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_flag       LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW r322_w AT p_row,p_col
     WITH FORM "aap/42f/aapr322"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.e_date = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apf04,apf06
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
         CLOSE WINDOW r322_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.b_date,tm.e_date,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD b_date
            IF tm.b_date IS NULL OR tm.b_date = ' ' THEN
               NEXT FIELD b_date
            END IF
 
         AFTER FIELD e_date
            IF tm.e_date IS NULL OR tm.e_date = ' ' THEN
               NEXT FIELD e_date
            END IF
            IF tm.e_date < tm.b_date THEN
               CALL cl_err('','aap-100',0)
               NEXT FIELD b_date
            END IF
 
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
            LET l_flag='N'
            IF tm.b_date IS NULL OR tm.b_date = ' ' THEN
               DISPLAY BY NAME tm.b_date
               LET l_flag='Y'
            END IF
            IF tm.e_date IS NULL OR tm.e_date = ' ' THEN
               DISPLAY BY NAME tm.e_date
               LET l_flag='Y'
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD b_date
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
         CLOSE WINDOW r322_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr322'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr322','9031',1)
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
                        " '",tm.b_date CLIPPED,"'",
                        " '",tm.e_date CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr322',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r322_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r322()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r322_w
 
END FUNCTION
 
 
FUNCTION r322()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql     STRING,      # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_order   ARRAY[2] OF LIKE zaa_file.zaa08,      # No.FUN-690028 VARCHAR(10),
          sr        RECORD
                       apf04 LIKE apf_file.apf04, #付款單單頭檔
                       apf06 LIKE apf_file.apf06,
                       apf01 LIKE apf_file.apf01,
                       azi03 LIKE azi_file.azi03,
                       azi04 LIKE azi_file.azi04,
                       azi05 LIKE azi_file.azi05,
                       gen02 LIKE gen_file.gen02
                    END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apfuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apfuser', 'apfgrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT apf04,apf06,apf01,azi03,azi04,azi05 ",
               "  FROM apf_file LEFT OUTER JOIN azi_file",
               " ON azi01 = apf06 WHERE apf41='Y' ",  #幣別
               " AND apf02 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"' ",
               " AND (apf00 <> '32' OR apf00 <> '36')",        #FUN-B20014
               " AND ", tm.wc CLIPPED
   PREPARE r322_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r322_curs1 CURSOR FOR r322_prepare1
 
   CALL cl_outnam('aapr322') RETURNING l_name
   START REPORT r322_rep TO l_name
 
   LET g_pageno = 0
   LET g_amt_1 = 0
   LET g_amt_2 = 0
   LET g_amt_3 = 0
   LET g_amt_4 = 0
 
   FOREACH r322_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT gen02 INTO sr.gen02
        FROM gen_file
       WHERE gen01 = sr.apf04
 
      IF cl_null(sr.azi03) THEN LET sr.azi03 = 0 END IF
      IF cl_null(sr.azi04) THEN LET sr.azi04 = 0 END IF
      IF cl_null(sr.azi05) THEN LET sr.azi05 = 0 END IF
 
      OUTPUT TO REPORT r322_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT r322_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105  MARK
END FUNCTION
 
REPORT r322_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr       RECORD
                      apf04 LIKE apf_file.apf04, #付款單單頭檔
                      apf06 LIKE apf_file.apf06,
                      apf01 LIKE apf_file.apf01,
                      azi03 LIKE azi_file.azi03,
                      azi04 LIKE azi_file.azi04,
                      azi05 LIKE azi_file.azi05,
                      gen02 LIKE gen_file.gen02
                   END RECORD,
          sr1      RECORD
                      aph05_1 LIKE aph_file.aph05,
                      aph05_2 LIKE aph_file.aph05,
                      aph05_3 LIKE aph_file.aph05,
                      aph05_4 LIKE aph_file.aph05
                   END RECORD,
      l_amt_1      LIKE aph_file.aph05,
      l_amt_2      LIKE aph_file.aph05,
      l_amt_3      LIKE aph_file.aph05,
      l_amt_4      LIKE aph_file.aph05,
      l_chr        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE g_head1  STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.apf04
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[11] CLIPPED,tm.b_date,g_x[13] CLIPPED,tm.e_date
         #PRINT g_head1                       #FUN-660060 remark
         PRINT COLUMN (g_len-25)/2+1,g_head1  #FUN-660060
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.apf04
         LET l_amt_1 = 0
         LET l_amt_2 = 0
         LET l_amt_3 = 0
         LET l_amt_4 = 0
 
      ON EVERY ROW
         SELECT sum(aph05) INTO sr1.aph05_1
           FROM aph_file
          WHERE aph01 = sr.apf01
            AND aph03 = '1'                   # 1.支票類
         IF cl_null(sr1.aph05_1) THEN LET sr1.aph05_1 = 0 END IF
 
         SELECT sum(aph05) INTO sr1.aph05_2
           FROM aph_file
          WHERE aph01 = sr.apf01
            AND aph03 = '2'                   # 2.現金類
         IF cl_null(sr1.aph05_2) THEN LET sr1.aph05_2 = 0 END IF
 
         SELECT sum(aph05) INTO sr1.aph05_3
           FROM aph_file
          WHERE aph01 = sr.apf01
            AND aph03 = '3'                   # 3.其它類
         IF cl_null(sr1.aph05_3) THEN LET sr1.aph05_3 = 0 END IF
 
         SELECT sum(aph05) INTO sr1.aph05_4
           FROM aph_file
          WHERE aph01 = sr.apf01
            AND (aph03 = '6'                  # 6.折讓沖帳
             OR  aph03 = '7'                  # 7.C.M.沖帳
             OR  aph03 = '8'                  # 8.預付沖帳
             OR  aph03 = '9')                 # 9.暫付沖帳 85-09-25
         IF cl_null(sr1.aph05_4) THEN LET sr1.aph05_4 = 0 END IF
 
         PRINT COLUMN g_c[31],sr.apf04,
               COLUMN g_c[32],sr.gen02,
               COLUMN g_c[33],sr.apf06,
               COLUMN g_c[34],cl_numfor(sr1.aph05_1,34,g_azi04), # 支票付款
               COLUMN g_c[35],cl_numfor(sr1.aph05_2,35,g_azi04), # 現金付款
               COLUMN g_c[36],cl_numfor(sr1.aph05_3,36,g_azi04), # 其他付款
               COLUMN g_c[37],cl_numfor(sr1.aph05_4,37,g_azi04)  # AT帳付款
 
         LET l_amt_1 =l_amt_1 + sr1.aph05_1
         LET l_amt_2 =l_amt_2 + sr1.aph05_2
         LET l_amt_3 =l_amt_3 + sr1.aph05_3
         LET l_amt_4 =l_amt_4 + sr1.aph05_4
         LET g_amt_1 =g_amt_1 + sr1.aph05_1
         LET g_amt_2 =g_amt_2 + sr1.aph05_2
         LET g_amt_3 =g_amt_3 + sr1.aph05_3
         LET g_amt_4 =g_amt_4 + sr1.aph05_4
 
      AFTER GROUP OF sr.apf04
         PRINT ''
         PRINT COLUMN g_c[32],g_x[10] CLIPPED,
               COLUMN g_c[33],g_x[11] CLIPPED,
               COLUMN g_c[34],cl_numfor(l_amt_1,34,g_azi05),
               COLUMN g_c[35],cl_numfor(l_amt_2,35,g_azi05),
               COLUMN g_c[36],cl_numfor(l_amt_3,36,g_azi05),
               COLUMN g_c[37],cl_numfor(l_amt_4,37,g_azi05)
         PRINT ''
 
      ON LAST ROW
         PRINT COLUMN g_c[33],g_x[12] CLIPPED,
               COLUMN g_c[34],cl_numfor(g_amt_1,34,g_azi05),
               COLUMN g_c[35],cl_numfor(g_amt_2,35,g_azi05),
               COLUMN g_c[36],cl_numfor(g_amt_3,36,g_azi05),
               COLUMN g_c[37],cl_numfor(g_amt_4,37,g_azi05)
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apf01,apf02,apf03,apf04,apf05') RETURNING tm.wc
            PRINT g_dash[1,g_len]
            #TQC-630166
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            #IF tm.wc[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
            #END IF
            #IF tm.wc[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
            #END IF
            #IF tm.wc[211,280] > ' ' THEN
            #   PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
            #END IF
            CALL cl_prt_pos_wc(tm.wc)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[7] CLIPPED      #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED      #TQC-6A0088
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[37],g_x[6] CLIPPED    #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED    #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
