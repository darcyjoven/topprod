# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr230.4gl
# Descriptions...: 現金收支明細帳列印作業
# Modify.........: No.FUN-4C0098 04/12/29 By pengu 報表轉XML
# Modify.........: NO.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600)
              bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
              edate   LIKE type_file.dat,    #No.FUN-680107 DATE
              s       LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)
              t       LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD,
           g_dash_1   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(132)
          
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_head1      STRING
MAIN
#     DEFINE    l_time   LIKE type_file.chr8       #No.FUN-6A0082
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r230_tm(0,0)
   ELSE CALL r230()
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r230_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,      #No.FUN-680107 SMALLINT
          l_t          LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000    #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r230_w AT p_row,p_col
        WITH FORM "anm/42f/anmr230"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.s = '21'
   LET tm.t = ' '
   LET tm.more = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nme14, nme15,nme01
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
      LET INT_FLAG = 0 CLOSE WINDOW r230_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.more
                 WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            CALL cl_err(0, 'anm-003' ,0)
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN
            CALL cl_err(0, 'anm-003' ,0)
            NEXT FIELD edate
         END IF
         IF tm.bdate > tm.edate THEN    # 截止日期不可小於起始日期
            CALL cl_err(0, 'anm-091' ,0)
            LET tm.bdate = g_today
            LET tm.edate = g_today
            DISPLAY BY NAME tm.bdate, tm.edate
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD more
         IF CL_NULL(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
            LET tm.more = 'N' NEXT FIELD more
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
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
      LET INT_FLAG = 0 CLOSE WINDOW r230_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr230'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('anmr230','9031',1)   
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr230',g_time,l_cmd)
      END IF
      CLOSE WINDOW r230_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   IF tm.more = 'Y' THEN
      CALL r230_1()
   ELSE
      CALL r230()
   END IF
   ERROR ""
END WHILE
   CLOSE WINDOW r230_w
END FUNCTION
 
FUNCTION r230()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,		    # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          l_order   ARRAY[2] OF LIKE nme_file.nme15,  #No.FUN-680107 ARRY[2] OF VARCHAR(30)
          sr               RECORD order1 LIKE nme_file.nme15, #No.FUN-680107 VARCHAR(20)
                                  order2 LIKE nme_file.nme15, #No.FUN-680107 VARCHAR(20)
                           nme01 LIKE nme_file.nme01,         #銀行編號
                           nme03 LIKE nme_file.nme03,         #異 動 碼
                           nme04 LIKE nme_file.nme04,         #金    額
                           nme05 LIKE nme_file.nme05,         #摘    要
                           nme08 LIKE nme_file.nme08,         #本幣金額
                           nme15 LIKE nme_file.nme15,         #部門編號
                           nme14 LIKE nme_file.nme14,         #現金變動碼
                           nml02 LIKE nml_file.nml02,         #現金變動碼說明
                           nme16 LIKE nme_file.nme16,         #傳票日期
                           nmc03 LIKE nmc_file.nmc03          #存提別
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmeuser', 'nmegrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT '','',",
                 " nme01, nme03, nme04, nme05, nme08, nme15, nme14, nml02,",
                 " nme16, nmc03",
"                  FROM nme_file LEFT OUTER JOIN nml_file ON nme14 = nml01 ",
"                                LEFT OUTER JOIN nmc_file ON nme03 = nmc01,",
"                       nma_file ",
"                  WHERE nme01 = nma01",
"                    AND ", tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED,
         " AND nme16 BETWEEN '", tm.bdate,"' AND '",tm.edate,"'"
     PREPARE r230_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r230_curs CURSOR FOR r230_prepare
     CALL cl_outnam('anmr230') RETURNING l_name
 
     START REPORT r230_rep TO l_name
     LET g_pageno = 0
     FOREACH r230_curs INTO sr.*
       message '=>',sr.nme14,sr.nme15
       CALL ui.Interface.refresh()
       IF STATUS != 0 THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
       END IF
       FOR g_i = 1 TO 2
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.nme14
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.nme15
           END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
 
       OUTPUT TO REPORT r230_rep(sr.*)
     END FOREACH
     FINISH REPORT r230_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r230_rep(sr)
     DEFINE l_last_sw      LIKE type_file.chr1,               #No.FUN-680107 VARCHAR(1)
          sr               RECORD order1 LIKE nme_file.nme15, #No.FUN-680107 VARCHAR(20)
                                  order2 LIKE nme_file.nme15, #No.FUN-680107 VARCHAR(20)
                           nme01 LIKE nme_file.nme01,         #銀行編號
                           nme03 LIKE nme_file.nme03,         #異 動 碼
                           nme04 LIKE nme_file.nme04,         #金    額
                           nme05 LIKE nme_file.nme05,         #摘    要
                           nme08 LIKE nme_file.nme08,         #本幣金額
                           nme15 LIKE nme_file.nme15,         #部門編號
                           nme14 LIKE nme_file.nme14,         #現金變動碼
                           nml02 LIKE nml_file.nml02,         #現金變動碼說明
                           nme16 LIKE nme_file.nme16,         #傳票日期
                           nmc03 LIKE nmc_file.nmc03          #存提別
                        END RECORD,
      l_gem02      LIKE gem_file.gem02,
      l_debit      LIKE nme_file.nme04,
      l_credit     LIKE nme_file.nme04,
      l_rest       LIKE nme_file.nme04,
      l_gsum_1     LIKE nme_file.nme04,
      l_gsum_2     LIKE nme_file.nme04,
      l_tsum_1     LIKE nme_file.nme08,   #No.FUN-680107 DEC(15,3)
      l_tsum_2     LIKE nme_file.nme08,   #No.FUN-680107 DEC(15,3)
      l_nme15      LIKE nme_file.nme15,   #No.FUN-680107 INTEGER
      l_nme14      LIKE nme_file.nme14,   #No.FUN-680107 INTEGER
      l_chr        LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line   #No.MOD-580242
 
   ORDER BY sr.order1,sr.order2
   FORMAT
   PAGE HEADER
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0110
        LET g_pageno=g_pageno+1
        LET pageno_total=PAGENO USING '<<<',"/pageno"
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6A0110
        PRINT g_head CLIPPED,pageno_total
        LET g_head1= g_x[5] CLIPPED,tm.bdate,' - ',tm.edate
        #PRINT g_head1                                          #FUN-660060 remark 
        PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1  #FUN-660060
        IF g_pageno = 1 THEN
           CALL r230_cntrest() RETURNING l_rest  #計算期初餘額
           IF cl_null(l_rest)  THEN LET l_rest = 0  END IF
           PRINT g_x[9] CLIPPED,cl_numfor(l_rest,32,g_azi05)
        ELSE
           PRINT ''
        END IF
        PRINT g_dash[1,g_len]
        PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
        PRINT g_dash1
        LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
        IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
           SKIP TO TOP OF PAGE
        END IF
        LET l_gem02 = ''
        SELECT gem02 INTO l_gem02 FROM gem_file
         WHERE gem01=sr.nme15
        IF tm.s[1,1] ='2' THEN
           PRINT g_x[11] CLIPPED,sr.nme15 CLIPPED,l_gem02 CLIPPED
           PRINT
        ELSE
            PRINT COLUMN 01, sr.nme14,' ', sr.nml02 CLIPPED
            PRINT
        END IF
        LET l_gsum_1 = 0
        LET l_gsum_2 = 0
 
   BEFORE GROUP OF sr.order2
        IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9) THEN
           SKIP TO TOP OF PAGE
        END IF
        LET l_gem02 = ''
        SELECT gem02 INTO l_gem02 FROM gem_file
         WHERE gem01=sr.nme15
        IF tm.s[2,2] ='2' THEN
            PRINT COLUMN 02,g_x[11] CLIPPED,sr.nme15
        ELSE
            PRINT COLUMN 02,sr.nme14,' ', sr.nml02 CLIPPED
        END IF
        LET l_debit = 0
        LET l_credit = 0
 
   ON EVERY ROW
        PRINT COLUMN g_c[31], sr.nme16,      #列印明細
              COLUMN g_c[32], sr.nme05[1,20] CLIPPED;
              IF NOT cl_null(sr.nme05[21,40]) THEN
                 PRINT ' '
                 PRINT COLUMN g_c[33],sr.nme05[21,40];
              END IF
        CASE WHEN sr.nmc03 = '1'
                PRINT COLUMN g_c[34],cl_numfor(sr.nme08,34,g_azi04)
             WHEN sr.nmc03 = '2'
                PRINT COLUMN g_c[34], cl_numfor(sr.nme08,34,g_azi04)
           OTHERWISE   LET sr.nme08= 0
                PRINT ''
        END CASE
        LET l_tsum_1 = SUM(sr.nme08) WHERE sr.nmc03 = '1'
        LET l_tsum_2 = SUM(sr.nme08) WHERE sr.nmc03 = '2'
 
  AFTER GROUP OF sr.order1
        LET l_gsum_1 = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '1'
        LET l_gsum_2 = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '2'
        IF cl_null(l_gsum_1)  THEN LET l_gsum_1 = 0  END IF
        IF cl_null(l_gsum_2)  THEN LET l_gsum_2 = 0  END IF
        IF tm.s[1,1] = '2' THEN
           PRINT COLUMN g_c[31],g_x[14] CLIPPED, #部門別小計
                 COLUMN g_c[32],cl_numfor(l_gsum_1,32,g_azi05),
                 COLUMN g_c[33],cl_numfor(l_gsum_2,33,g_azi05),
                 COLUMN g_c[34],cl_numfor(l_gsum_1-l_gsum_2,34,g_azi05)
           PRINT g_dash2   #g_dash_1[1,g_len]
        ELSE
           PRINT COLUMN g_c[31],g_x[12] CLIPPED, #現金變動別小計
                 COLUMN g_c[32],cl_numfor(l_gsum_1,32,g_azi05),
                 COLUMN g_c[33],cl_numfor(l_gsum_2,33,g_azi05),
                 COLUMN g_c[34],cl_numfor(l_gsum_1-l_gsum_2,34,g_azi05)
           PRINT g_dash2    #g_dash_1[1,g_len]
        END IF
  AFTER GROUP OF sr.order2
        LET l_debit  = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '1'
        LET l_credit = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '2'
        IF cl_null(l_debit)  THEN LET l_debit = 0  END IF
        IF cl_null(l_credit) THEN LET l_credit = 0  END IF
        IF tm.s[2,2] = '2' THEN
           PRINT COLUMN g_c[31],g_x[14] CLIPPED,  #部門別小計
                 COLUMN g_c[32],cl_numfor(l_debit,32,g_azi05),
                 COLUMN g_c[33],cl_numfor(l_credit,33,g_azi05),
                 COLUMN g_c[34],cl_numfor(l_debit-l_credit,34,g_azi05)
           PRINT
        ELSE
           PRINT COLUMN g_c[31],g_x[12] CLIPPED, #現金變動別小計
                 COLUMN g_c[32],cl_numfor(l_debit,32,g_azi05),
                 COLUMN g_c[33],cl_numfor(l_credit,33,g_azi05),
                 COLUMN g_c[34],cl_numfor(l_debit-l_credit,34,g_azi05)
           PRINT
        END IF
   ON LAST ROW
        PRINT COLUMN g_c[31],g_x[10] CLIPPED,'(TWD)',  #總計(TWD)
              COLUMN g_c[32],cl_numfor(l_tsum_1,32,g_azi05),
              COLUMN g_c[33],cl_numfor(l_tsum_2,33,g_azi05)
        IF cl_null(l_tsum_1) THEN LET l_tsum_1 =0 END IF
        IF cl_null(l_tsum_2) THEN LET l_tsum_2 =0 END IF
        LET l_rest = l_rest + l_tsum_1 - l_tsum_2
        PRINT COLUMN g_c[33],g_x[13] CLIPPED,
              COLUMN g_c[34],cl_numfor(l_rest,34,g_azi05)
        LET l_last_sw = 'y'
        PRINT g_dash[1,g_len]
        PRINT '(anmr230)', COLUMN (g_len-9),g_x[7] CLIPPED    #(結 束)
   PAGE TRAILER
        IF l_last_sw = 'n' THEN
	   PRINT g_dash[1,g_len]
           PRINT '(anmr230)', COLUMN (g_len-9),g_x[6] CLIPPED #(接下頁)
           ELSE SKIP 2 LINE
        END IF
END REPORT
 
#-------部門彙總列印-------------------------------------------------O
 
FUNCTION r230_1()
   DEFINE l_name    LIKE type_file.chr20,              # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,		         # RDSQL STATEMENT #No.FUN-680107 VARCHAR(600)
          l_chr     LIKE type_file.chr1,               #No.FUN-680107 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,            #No.FUN-680107 VARCHAR(40)
          l_order   ARRAY[3] OF LIKE nme_file.nme15,   #No.FUN-680107 ARRAY[3] OF VARCHAR(30)
          sr               RECORD
                           order1 LIKE nme_file.nme15, #No.FUN-680107 VARCHAR(20)
                           order2 LIKE nme_file.nme15, #No.FUN-680107 VARCHAR(20)
                           nme01 LIKE nme_file.nme01,  #銀行編號
                           nme03 LIKE nme_file.nme03,  #異 動 碼
                           nme04 LIKE nme_file.nme04,  #金    額
                           nme05 LIKE nme_file.nme05,  #摘    要
                           nme08 LIKE nme_file.nme08,  #本幣金額
                           nme15 LIKE nme_file.nme15,  #部門編號
                           nme14 LIKE nme_file.nme14,  #現金變動碼
                           nml02 LIKE nml_file.nml02,  #現金變動碼說明
                           nme16 LIKE nme_file.nme16,  #傳票日期
                           nmc03 LIKE nmc_file.nmc03   #存提別
                        END RECORD
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmegrup IN ",cl_chk_tgrup_list()
     #     END IF
     #End:FUN-980030
 
     LET l_sql = " SELECT '','',",
                 " nme01, nme03, nme04, nme05, nme08, nme15, nme14, nml02,",
                 " nme16, nmc03",
"                   FROM nme_file LEFT OUTER JOIN nml_file ON nme14 = nml01",
"                                 LEFT OUTER JOIN nmc_file ON nme03 = nmc01",
"                  WHERE ", tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED,
         " AND nme16 BETWEEN '", tm.bdate,"' AND '",tm.edate,"'"
 
     PREPARE r230_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r230_curs1 CURSOR FOR r230_prepare1
     CALL cl_outnam('anmr230') RETURNING l_name
 
     START REPORT r230_rep1 TO l_name
     LET g_pageno = 0
     FOREACH r230_curs1 INTO sr.*
         message '=>',sr.nme15,sr.nme14
         CALL ui.Interface.refresh()
         IF STATUS != 0 THEN
              CALL cl_err('foreach1:',STATUS,1)
              EXIT FOREACH
         END IF
         FOR g_i = 1 TO 2
             CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.nme14
                  WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.nme15
             END CASE
         END FOR
         LET sr.order1 = l_order[1]
         LET sr.order2 = l_order[2]
 
         OUTPUT TO REPORT r230_rep1(sr.*)
     END FOREACH
     FINISH REPORT r230_rep1
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r230_rep1(sr)
   DEFINE l_last_sw        LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          sr               RECORD
                           order1 LIKE type_file.chr20,  #No.FUN-680107
                           order2 LIKE type_file.chr20,  #No.FUN-680107
                           nme01 LIKE nme_file.nme01,         #銀行編號
                           nme03 LIKE nme_file.nme03,         #異 動 碼
                           nme04 LIKE nme_file.nme04,         #金    額
                           nme05 LIKE nme_file.nme05,         #摘    要
                           nme08 LIKE nme_file.nme08,         #本幣金額
                           nme15 LIKE nme_file.nme15,         #部門編號
                           nme14 LIKE nme_file.nme14,         #現金變動碼
                           nml02 LIKE nml_file.nml02,         #現金變動碼說明
                           nme16 LIKE nme_file.nme16,         #傳票日期
                           nmc03 LIKE nmc_file.nmc03          #存提別
                        END RECORD,
      l_gem02      LIKE gem_file.gem02,
      l_debit      LIKE nme_file.nme04,
      l_credit     LIKE nme_file.nme04,
      l_rest       LIKE nme_file.nme04,
      l_rest1      LIKE nme_file.nme08,   #No.FUN-680107 DEC(15,3)
      l_tsum_1     LIKE nme_file.nme08,   #No.FUN-680107 DEC(15,3)
      l_tsum_2     LIKE nme_file.nme08,   #No.FUN-680107 DEC(15,3)
      l_nme14      LIKE nme_file.nme14,   #No.FUN-680107 INTEGER
      l_chr        LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.nme14, sr.nme16
   FORMAT
   PAGE HEADER
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No.TQC-6A0110
        LET g_pageno=g_pageno+1
        LET pageno_total=PAGENO USING '<<<',"/pageno"
#No.TQC-6A0110 -- begin --
#        LET g_head=g_head CLIPPED, pageno_total   #No.TQC-6A0110
#        PRINT g_head
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6A0110
        PRINT g_head CLIPPED,pageno_total
#No.TQC-6A0110 -- end --
        LET g_head1= g_x[5] CLIPPED,tm.bdate,' - ',tm.edate
        #PRINT g_head1                                         #FUN-660060 remark
        PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)+1, g_head1 #FUN-660060
        IF g_pageno = 1 THEN    #計算期初餘額
           CALL r230_cntrest() RETURNING l_rest
           IF cl_null(l_rest)  THEN LET l_rest = 0  END IF
           PRINT g_x[9] CLIPPED,COLUMN g_c[32],cl_numfor(l_rest,32,g_azi05)
        ELSE
           PRINT ''
        END IF
        PRINT g_dash[1,g_len]
        PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
        PRINT g_dash1
        LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nme14
        PRINT COLUMN 01, sr.nme14,' ', sr.nml02 CLIPPED
        LET l_debit = 0
        LET l_credit = 0
 
   ON EVERY ROW
        PRINT COLUMN g_c[31], sr.nme16,
              COLUMN g_c[32], sr.nme05[1,20] CLIPPED;
              IF NOT cl_null(sr.nme05[21,40]) THEN
                 PRINT ''   #換行
                 PRINT COLUMN g_c[33],sr.nme05[21,40];
              END IF
        CASE WHEN sr.nmc03 = '1'
                PRINT COLUMN g_c[34], cl_numfor(sr.nme08,34,g_azi05)
             WHEN sr.nmc03 = '2'
                PRINT COLUMN g_c[34], cl_numfor(sr.nme08,34,g_azi05)
        OTHERWISE   LET sr.nme08= 0
                    PRINT ''
        END CASE
        LET l_tsum_1 = SUM(sr.nme08) WHERE sr.nmc03 = '1'
        LET l_tsum_2 = SUM(sr.nme08) WHERE sr.nmc03 = '2'
 
  AFTER GROUP OF sr.nme14      #現金變動別小計
        LET l_debit  = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '1'
        LET l_credit = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '2'
        IF cl_null(l_debit)   THEN LET l_debit=0  END IF
        IF cl_null(l_credit)  THEN LET l_credit=0  END IF
 
        PRINT COLUMN g_c[31],g_x[12] CLIPPED,  #現金變動別小計
             COLUMN g_c[32],cl_numfor(l_debit,32,g_azi05),
             COLUMN g_c[33],cl_numfor(l_credit,33,g_azi05),
             COLUMN g_c[34],cl_numfor(l_debit-l_credit,34,g_azi05)
        PRINT g_dash1     #g_dash_1[1,g_len]
 
   ON LAST ROW
        PRINT COLUMN g_c[31],g_x[10] CLIPPED,    #總計
              COLUMN g_c[32],cl_numfor(l_tsum_1,32,g_azi05),
              COLUMN g_c[33],cl_numfor(l_tsum_2,33,g_azi05) ,
              COLUMN g_c[34],cl_numfor(l_tsum_1-l_tsum_2,34,g_azi05)
        IF cl_null(l_tsum_1) THEN LET l_tsum_1 =0 END IF
        IF cl_null(l_tsum_2) THEN LET l_tsum_2 =0 END IF
        LET l_rest = l_rest + l_tsum_1 - l_tsum_2
#.......期末餘額
        PRINT COLUMN g_c[33],g_x[13] CLIPPED,COLUMN g_c[34],cl_numfor(l_rest,34,g_azi05)
        LET l_last_sw = 'y'
        PRINT g_dash[1,g_len]
        PRINT '(anmr230)', COLUMN (g_len-9),g_x[7] CLIPPED    #(結 束)
   PAGE TRAILER
        IF l_last_sw = 'n' THEN
	   PRINT g_dash[1,g_len]
           PRINT '(anmr230)', COLUMN (g_len-9),g_x[6] CLIPPED   #(接下頁)
         ELSE SKIP 2 LINE
        END IF
END REPORT
 
#--------------期初餘額----------------------------------------------------
FUNCTION r230_cntrest()
   DEFINE l_year    LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_mon     LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_bdate,l_edate  LIKE type_file.dat,     #No.FUN-680107 DATE
          l_debit   LIKE nme_file.nme04,
          l_credit  LIKE nme_file.nme04,
          l_rest    LIKE nme_file.nme04
 
   SELECT azn02,azn04 INTO l_year,l_mon FROM azn_file WHERE azn01=tm.bdate
   IF STATUS THEN RETURN 0 END IF
   SELECT MIN(azn01),MAX(azn01) INTO l_bdate,l_edate FROM azn_file
          WHERE azn02=l_year AND azn04=l_mon
   LET l_mon=l_mon-1
   IF l_mon=0 THEN
      LET l_year=l_year-1
      IF g_aza.aza02='2' THEN LET l_mon=13 ELSE LET l_mon=12 END IF
   END IF
 
   LET l_rest =0
   SELECT SUM(nmp19) INTO l_rest FROM nmp_file
          WHERE nmp02=l_year AND nmp03=l_mon
   IF STATUS AND STATUS !=100 THEN 
#     CALL cl_err('get nmp error!',STATUS,0) #FUN-660148
      CALL cl_err3("sel","nmp_file",l_year,l_mon,STATUS,"","get nmp error!",0) #FUN-660148
   END IF
 
   LET l_debit=0 LET l_credit=0
   SELECT SUM(nme08) INTO l_debit FROM nme_file, nmc_file
          WHERE nmc01=nme03 AND nmc03='1'
          AND nme16>=l_bdate AND nme16< tm.bdate
   SELECT SUM(nme08) INTO l_credit FROM nme_file, nmc_file
          WHERE nmc01=nme03 AND nmc03='2'
          AND nme16>= l_bdate AND nme16<tm.bdate
   IF STATUS THEN 
#     CALL cl_err('get nme error!',STATUS,0) #FUN-660148
      CALL cl_err3("sel","nme_file,nmc_file","","",STATUS,"","get nme error!",0) #FUN-660148
   END IF
 
   IF cl_null(l_debit) THEN LET l_debit =0 END IF
   IF cl_null(l_credit) THEN LET l_credit =0 END IF
   LET l_rest = l_rest +l_debit-l_credit
   RETURN l_rest
END FUNCTION
