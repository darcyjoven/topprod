# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapr820.4gl
# Descriptions...: 信用狀償還預估明細表列印
# Date & Author..: 93/02/05  By  Felicity  Tseng
# Modify.........: No.FUN-4C0097 05/01/05 By Nicola 報表架構修改
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/30 By hellen 本原幣取位修改
# Modify.........: No.TQC-6C0172 06/12/27 By wujie 調整“接下頁/結束”位置
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 #wc      LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(600)
                 wc      STRING,   #TQC-630166
                 s       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3), 
                 t       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),
                 u       LIKE type_file.chr3,        # No.FUN-690028 VARCHAR(3),
                 more    LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
              END RECORD,
#         g_orderA    ARRAY[3] OF VARCHAR(10)  #排序名稱
          g_orderA    ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(16)  #No.FUN-550030
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
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r820_tm(0,0)
   ELSE
      CALL r820()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r820_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW r820_w AT p_row,p_col
     WITH FORM "aap/42f/aapr820"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '324'
   LET tm.u    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON alh11,alh08,alh06,alh01,alh05,alh10,alh04
 
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
         CLOSE WINDOW r820_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,tm.more WITHOUT DEFAULTS
 
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
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.u = tm2.u1,tm2.u2,tm2.u3
 
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
         CLOSE WINDOW r820_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr820'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr820','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr820',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r820_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r820()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r820_w
 
END FUNCTION
 
FUNCTION r820()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          #l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
          l_sql     STRING,      # RDSQL STATEMENT   #TQC-630166
          l_order   ARRAY[5] OF LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(16),          #No.FUN-550030
          sr        RECORD order1   LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(16),      #No.FUN-550030
                           order2   LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(16),      #No.FUN-550030
                           order3   LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(16),      #No.FUN-550030
                           alh      RECORD LIKE alh_file.*,
                           used_amt LIKE alh_file.alh14,
                           pmc03    LIKE pmc_file.pmc03
                    END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND alhuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND alhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND alhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alhuser', 'alhgrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT '','','',alh_file.*,0,pmc03",
               " FROM alh_file, OUTER pmc_file",
               " WHERE alh_file.alh05=pmc_file.pmc01 ",
               "   AND alh14>alh76",
               "   AND ", tm.wc CLIPPED
 
   PREPARE r820_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE r820_curs1 CURSOR FOR r820_prepare1
 
   CALL cl_outnam('aapr820') RETURNING l_name
   START REPORT r820_rep TO l_name
 
   LET g_pageno = 0
 
   FOREACH r820_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET sr.alh.alh14 = sr.alh.alh14 - sr.alh.alh76
      LET sr.alh.alh16 = sr.alh.alh16 - sr.alh.alh77
      LET sr.used_amt  = sr.alh.alh14 * sr.alh.alh18
 
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.alh.alh11
                                       LET g_orderA[g_i]= g_x[10]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.alh.alh08 USING 'YYYYMMDD'
                                       LET g_orderA[g_i]= g_x[11]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.alh.alh06
                                       LET g_orderA[g_i]= g_x[12]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.alh.alh01
                                       LET g_orderA[g_i]= g_x[13]
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.alh.alh05
                                       LET g_orderA[g_i]= g_x[14]
              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.alh.alh10
                                       LET g_orderA[g_i]= g_x[15]
              OTHERWISE LET l_order[g_i]  = '-'
                        LET g_orderA[g_i] = ' '          #清為空白
         END CASE
      END FOR
 
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
      IF sr.order3 IS NULL THEN LET sr.order3 = ' '  END IF
 
      OUTPUT TO REPORT r820_rep(sr.*)
 
   END FOREACH
 
   FINISH REPORT r820_rep
 
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 # CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055    #FUN-B80105 MARK
 
END FUNCTION
 
REPORT r820_rep(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr         RECORD order1   LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                            order2   LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                            order3   LIKE alh_file.alh01,      # No.FUN-690028 VARCHAR(16),    #No.FUN-550030
                            alh      RECORD LIKE alh_file.*,
                            used_amt LIKE alh_file.alh14,
                            pmc03    LIKE pmc_file.pmc03
                     END RECORD
#         l_azi03    LIKE azi_file.azi03,  #NO.CHI-6A0004
#         l_azi04    LIKE azi_file.azi04,  #NO.CHI-6A0004
#         l_azi05    LIKE azi_file.azi05   #NO.CHI-6A0004
   DEFINE g_head1    STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.alh.alh11,sr.order2,sr.order3,sr.alh.alh01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,
                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
               g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order3
         IF tm.t[3,3] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      ON EVERY ROW
         SELECT azi03,azi04,azi05,azi07   #No.FUN-870151 add azi07
#          INTO l_azi03,l_azi04,l_azi05   #NO.CHI-6A0004
           INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
                ,t_azi07                  #No.FUN-870151 add azi07
           FROM azi_file
          WHERE azi01=sr.alh.alh11
 
         PRINT COLUMN g_c[31],sr.alh.alh11,
               COLUMN g_c[32],sr.alh.alh08,
               COLUMN g_c[33],sr.alh.alh05,
               COLUMN g_c[34],sr.alh.alh06,
               COLUMN g_c[35],sr.pmc03,
               COLUMN g_c[36],sr.alh.alh10,
               COLUMN g_c[37],sr.alh.alh03,
               COLUMN g_c[38],sr.alh.alh01,
               COLUMN g_c[39],sr.alh.alh02,
#              COLUMN g_c[40],cl_numfor(sr.alh.alh14,40,l_azi04),   #NO.CHI-6A0004
               COLUMN g_c[40],cl_numfor(sr.alh.alh14,40,t_azi04),   #NO.CHI-6A0004
              #COLUMN g_c[41],sr.alh.alh15 USING '#####.####',      #No.FUN-870151
               COLUMN g_c[41],cl_numfor(sr.alh.alh15,41,t_azi07),   #No.FUN-870151
               COLUMN g_c[42],cl_numfor(sr.alh.alh16,42,g_azi04),
               COLUMN g_c[43],cl_numfor(sr.used_amt,43,g_azi04)
 
      AFTER GROUP OF sr.alh.alh11
         IF tm.u[1,1] = 'Y' THEN
            PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+g_w[40]+2]
            PRINT COLUMN g_c[38],g_x[16]CLIPPED,
                  COLUMN g_c[39],sr.alh.alh11,
#                 COLUMN g_c[40],cl_numfor(GROUP SUM(sr.alh.alh14),40,l_azi05)
                  COLUMN g_c[40],cl_numfor(GROUP SUM(sr.alh.alh14),40,t_azi05)
            PRINT
         END IF
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            PRINT COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+g_w[43]+7]
            PRINT COLUMN g_c[36],g_orderA[1] CLIPPED,
                  COLUMN g_c[37],sr.order1 CLIPPED,
                  COLUMN g_c[38],g_x[16] CLIPPED,
                  COLUMN g_c[42],cl_numfor(GROUP SUM(sr.alh.alh16),42,g_azi05),
                  COLUMN g_c[43],cl_numfor(GROUP SUM(sr.used_amt),43,g_azi05)
            PRINT
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            PRINT COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+g_w[43]+7]
            PRINT COLUMN g_c[36],g_orderA[2] CLIPPED,
                  COLUMN g_c[38],g_x[16] CLIPPED,
#                 COLUMN g_c[40],cl_numfor(GROUP SUM(sr.alh.alh14),40,l_azi05),   #NO.CHI-6A0004
                  COLUMN g_c[40],cl_numfor(GROUP SUM(sr.alh.alh14),40,t_azi05),   #NO.CHI-6A0004
                  COLUMN g_c[42],cl_numfor(GROUP SUM(sr.alh.alh16),42,g_azi05),
                  COLUMN g_c[43],cl_numfor(GROUP SUM(sr.used_amt),43,g_azi05)
            PRINT
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            PRINT COLUMN g_c[36],g_dash2[1,g_w[36]+g_w[37]+g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+g_w[43]+7]
            PRINT COLUMN g_c[36],g_orderA[3] CLIPPED,
                  COLUMN g_c[38],g_x[16] CLIPPED,
#                 COLUMN g_c[40],cl_numfor(GROUP SUM(sr.alh.alh14),40,l_azi05),   #NO.CHI-6A0004
                  COLUMN g_c[40],cl_numfor(GROUP SUM(sr.alh.alh14),40,t_azi05),   #NO.CHI-6A0004
                  COLUMN g_c[42],cl_numfor(GROUP SUM(sr.alh.alh16),42,g_azi05),
                  COLUMN g_c[43],cl_numfor(GROUP SUM(sr.used_amt),43,g_azi05)
            PRINT
         END IF
 
      ON LAST ROW
         PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+g_w[40]+g_w[41]+g_w[42]+g_w[43]+5]
         PRINT COLUMN g_c[38],g_x[17] CLIPPED,
               COLUMN g_c[42],cl_numfor(SUM(sr.alh.alh16),42,g_azi05),
               COLUMN g_c[43],cl_numfor(SUM(sr.used_amt),43,g_azi05)
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'alh01,alh02,alh03,alh04,alh05') RETURNING tm.wc
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
#        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[43],g_x[7] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED                 #No.TQC-6C0172
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[43],g_x[6] CLIPPED
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED              #No.TQC-6C0172
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
