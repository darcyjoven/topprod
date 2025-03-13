# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aapr125.4gl
# Descriptions...: 廠商應付帳款明細表列印作業
# Date & Author..: 97/08/27  By  Kitty
# Modify.........: No.FUN-4C0097 04/12/24 By Nicola 報表架構修改
#                                                   增加印列廠商編號apa05
# Modify.........: No.TQC-5B0043 05/11/08 By Smapmin 調整報表
# Modify.........: No.TQC-610098 06/01/23 By Smapmin 未付金額需扣除留置金額
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/09 By baogui 結束位置調整
# Modify.........: No.MOD-720128 07/05/04 By Smapmin 原幣未付金額不需扣除留置金額.
#                                                    增加留置金額欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000,  #TQC-630166  #No.FUN-690028 VARCHAR(600)
              wc      STRING,   #TQC-630166
              h       LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
              more    LIKE type_file.chr1         # No.FUN-690028 VARCHAR(01)
           END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.h  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r125_tm(0,0)
   ELSE
      CALL r125()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r125_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW r125_w AT p_row,p_col
     WITH FORM "aap/42f/aapr125"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.h    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON apa06,apa13,apa02,apa01,apa05,apa19,apa54
 
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
         CLOSE WINDOW r125_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.h,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD h
            IF cl_null(tm.h) OR tm.h NOT MATCHES '[123]' THEN
               NEXT FIELD h
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
         CLOSE WINDOW r125_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aapr125'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr125','9031',1)
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
                        " '",tm.h CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aapr125',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW r125_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r125()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r125_w
 
END FUNCTION
 
FUNCTION r125()
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#DEFINE l_time    LIKE type_file.chr8            # Used time for running the job  #No.FUN-690028 VARCHAR(8)
#DEFINE l_sql     LIKE type_file.chr1000      # RDSQL STATEMENT   #TQC-630166  #No.FUN-690028 VARCHAR(1200)
DEFINE l_sql     STRING       # RDSQL STATEMENT   #TQC-630166
DEFINE sr        RECORD apa00  LIKE apa_file.apa00,
                        apa06  LIKE apa_file.apa06,
                        apa07  LIKE apa_file.apa07,
                        apa13  LIKE apa_file.apa13,
                        apa02  LIKE apa_file.apa02,
                        apa01  LIKE apa_file.apa01,
                        apa08  LIKE apa_file.apa08,
                        apa05  LIKE apa_file.apa05,
                        pmc03  LIKE pmc_file.pmc03,
                        apa34f LIKE apa_file.apa34f,
                        apa20  LIKE apa_file.apa20,   #MOD-720128
                        apa19  LIKE apa_file.apa19,
                        apa11  LIKE apa_file.apa11,
                        apa12  LIKE apa_file.apa12,
                        apa24  LIKE apa_file.apa24,
                        azi04  LIKE azi_file.azi04,
                        azi05  LIKE azi_file.azi05
                        END RECORD
 
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
     #     END IF
 
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT apa00, apa06, apa07, apa13, apa02, apa01,",
                 #" apa08, apa05,pmc03, apa34f-apa35f, apa19, apa11,",   #TQC-610098
                 #" apa08, apa05,pmc03, apa34f-apa35f-apa20, apa19, apa11,",   #TQC-610098   #MOD-720128
                 " apa08, apa05,pmc03, apa34f-apa35f,apa20, apa19, apa11,",    #MOD-720128
                 " apa12, apa24,azi04, azi05 ",
                 " FROM apa_file, OUTER azi_file, OUTER pmc_file ",
                 " WHERE apa_file.apa13 = azi_file.azi01 AND apa_file.apa05 = pmc_file.pmc01 ",
                 #" AND apa34f > apa35f AND apa42 = 'N'",   #TQC-610098
                 " AND apa34f > apa35f+apa20 AND apa42 = 'N'",   #TQC-610098
                 " AND ", tm.wc CLIPPED
 
     IF tm.h='1' THEN
        LET l_sql = l_sql CLIPPED," AND apa41='Y' "
     END IF
 
     IF tm.h='2' THEN
        LET l_sql=l_sql CLIPPED," AND apa41='N' "
     END IF
 
     PREPARE r125_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r125_curs1 CURSOR FOR r125_prepare1
 
     CALL cl_outnam('aapr125') RETURNING l_name
     START REPORT r125_rep TO l_name
 
     LET g_pageno = 0
 
     FOREACH r125_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        IF sr.apa00[1,1] = '2' THEN
           LET sr.apa34f= sr.apa34f * -1
        END IF
 
        IF cl_null(sr.azi04) THEN
           LET sr.azi04 = 0
        END IF
 
        IF cl_null(sr.azi05) THEN
           LET sr.azi05 = 0
        END IF
 
        OUTPUT TO REPORT r125_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r125_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
 
END FUNCTION
 
REPORT r125_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE sr           RECORD apa00  LIKE apa_file.apa00,
                           apa06  LIKE apa_file.apa06,
                           apa07  LIKE apa_file.apa07,
                           apa13  LIKE apa_file.apa13,
                           apa02  LIKE apa_file.apa02,
                           apa01  LIKE apa_file.apa01,
                           apa08  LIKE apa_file.apa08,
                           apa05  LIKE apa_file.apa05,
                           pmc03  LIKE pmc_file.pmc03,
                           apa34f LIKE apa_file.apa34f,
                           apa20  LIKE apa_file.apa20,   #MOD-720128
                           apa19  LIKE apa_file.apa19,
                           apa11  LIKE apa_file.apa11,
                           apa12  LIKE apa_file.apa12,
                           apa24  LIKE apa_file.apa24,
                           azi04  LIKE azi_file.azi04,
                           azi05  LIKE azi_file.azi05
                        END RECORD
DEFINE l_apr02      LIKE apr_file.apr02     # 帳款類別名稱
DEFINE l_pma02      LIKE pma_file.pma02     # 付款內容
DEFINE l_amt_1      LIKE apa_file.apa34f
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.apa06,sr.apa07,sr.apa13
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
               #g_x[37],g_x[38],g_x[39],g_x[40]   #MOD-720128
               g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]   #MOD-720128
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.apa13
         PRINT COLUMN g_c[31],g_x[9],
               COLUMN g_c[32],sr.apa06 CLIPPED,
               COLUMN g_c[33],sr.apa07 CLIPPED,
               COLUMN g_c[35],g_x[10],
               COLUMN g_c[36],sr.apa13 CLIPPED
         PRINT ''
 
      ON EVERY ROW
         SELECT pma02 INTO l_pma02 FROM pma_file
          WHERE pma01=sr.apa11
         PRINT COLUMN g_c[31],sr.apa02,
               COLUMN g_c[32],sr.apa01,
               COLUMN g_c[33],sr.apa08,
               COLUMN g_c[34],sr.apa05,
               COLUMN g_c[35],sr.pmc03,
               COLUMN g_c[36],cl_numfor(sr.apa34f,36,sr.azi04),
               #-----MOD-720128---------
               #COLUMN g_c[37],sr.apa19,
               #COLUMN g_c[38],l_pma02,
               #COLUMN g_c[39],sr.apa12,
               #COLUMN g_c[40],sr.apa24 USING '##&'
               COLUMN g_c[37],cl_numfor(sr.apa20,37,sr.azi04),
               COLUMN g_c[38],sr.apa19,
               COLUMN g_c[39],l_pma02,
               COLUMN g_c[40],sr.apa12,
               COLUMN g_c[41],sr.apa24 USING '##&'
               #-----END MOD-720128-----
 
      AFTER GROUP OF sr.apa13
         LET l_amt_1 = GROUP SUM(sr.apa34f)
         PRINT ''
         PRINT COLUMN g_c[35],g_x[11],
               COLUMN g_c[36],cl_numfor(l_amt_1,36,sr.azi05)
         PRINT g_dash[1,g_len]
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'apa06,apa13,apa02,apa01,apa05,apa19,apa54') RETURNING tm.wc
            #TQC-630166
            #IF tm.wc[001,070] > ' ' THEN            # for 80
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
            #         COLUMN g_c[32],tm.wc[001,070] CLIPPED
            #END IF
            PRINT g_dash[1,g_len] CLIPPED
            CALL cl_prt_pos_wc(tm.wc)
            #END TQC-630166
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[40],g_x[7] CLIPPED   #TQC-5B0043
     #   PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[39],g_x[7] CLIPPED   #TQC-5B0043   #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED   #TQC-5B0043   #TQC-6A0088
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[40],g_x[6] CLIPPED   #TQC-5B0043
#           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[39],g_x[6] CLIPPED   #TQC-5B0043     #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED   #TQC-5B0043     #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
