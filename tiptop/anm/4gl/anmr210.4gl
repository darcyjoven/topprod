# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr210.4gl
# Descriptions...: 現金收支彙總表
# Date & Author..:
# Modify.........: No.FUN-4C0098 04/12/26 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(300)
              wc1     LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(100)
              bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
              edate   LIKE type_file.dat,    #No.FUN-680107 DATE
              a       LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_dash_1    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(132)
   g_gsum_1,g_gsum_2  LIKE type_file.num10   #No.FUN-680107 INTEGER
 
DEFINE   g_i        LIKE type_file.num5      #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
MAIN
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
   LET tm.wc1 = ARG_VAL(8)   #TQC-610058
   LET tm.bdate  = ARG_VAL(9)
   LET tm.edate  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r210_tm(0,0)
      ELSE CALL r210()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r210_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_t          LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(400)
          l_nme01      LIKE nme_file.nme01      #No.FUN-680107 VARCHAR(30)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r210_w AT p_row,p_col
        WITH FORM "anm/42f/anmr210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.a = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT tm.wc ON nme14, nme15 FROM nme14, nme15
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
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   CONSTRUCT tm.wc1 ON nma01 FROM nma01
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
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' AND tm.wc1 = ' 1=1' THEN CALL cl_err('','9046',0)
   CONTINUE WHILE END IF
 
   INPUT BY NAME tm.bdate,tm.edate,tm.a
                 WITHOUT DEFAULTS
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            CALL cl_err(0,'anm-003',0)
            NEXT FIELD bdate
         END IF
         IF NOT cl_null(tm.edate) THEN
         IF tm.bdate > tm.edate THEN      #截止日期不可小於起始日期
            CALL cl_err(0,'anm-091',0)
            LET tm.bdate = g_today
            LET tm.edate = g_today
            DISPLAY BY NAME tm.bdate, tm.edate
            NEXT FIELD bdate
         END IF
         END IF
 
      AFTER FIELD edate
         IF cl_null(tm.bdate) THEN
            CALL cl_err(0,'anm-003',0)
            NEXT FIELD edate
         END IF
         IF tm.bdate > tm.edate THEN      #截止日期不可小於起始日期
            CALL cl_err(0,'anm-091',0)
            LET tm.bdate = g_today
            LET tm.edate = g_today
            DISPLAY BY NAME tm.bdate, tm.edate
            NEXT FIELD bdate
         END IF
 
      AFTER FIELD a
         IF CL_NULL(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            LET tm.a = 'Y' NEXT FIELD a
         END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr210','9031',1)
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
                         " '",tm.wc1 CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr210',g_time,l_cmd)
      END IF
      CLOSE WINDOW r210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r210()
END WHILE
   CLOSE WINDOW r210_w
END FUNCTION
 
 
FUNCTION r210()
   DEFINE l_name    LIKE type_file.chr20,    # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,	 # RDSQL STATEMENT #No.FUN-680107 VARCHAR(600)
          l_sql_1   LIKE type_file.chr1000,	 # RDSQL STATEMENT #No.FUN-680107 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(40)
          l_nma01   LIKE nma_file.nma01,
          l_rest    LIKE nme_file.nme04,
          l_last_sw LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
          sr              RECORD
                           nme01 LIKE nme_file.nme01, #銀行編號
                           nme03 LIKE nme_file.nme03, #異動碼
                           nme04 LIKE nme_file.nme04, #金額
                           nme08 LIKE nme_file.nme08, #本幣金額
                           nme14 LIKE nme_file.nme14, #現金變動碼
                           nme15 LIKE nme_file.nme15, #部門編號
                           nme16 LIKE nme_file.nme16, #傳票日期
                           nml02 LIKE nml_file.nml02, #說明
                           nmc03 LIKE nmc_file.nmc03  #1:存 2:提
                      END RECORD
     DEFINE srr    RECORD  nma01 LIKE nma_file.nma01, #銀行編號
                           rest  LIKE nme_file.nme04  #金額
                   END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料O
     #        LET tm.wc = tm.wc clipped," AND nmeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND nmegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND nmegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmeuser', 'nmegrup')
     #End:FUN-980030
 
 
     LET l_sql = " SELECT nme01,nme03,nme04,nme08,nme14,nme15,nme16,",
                 " nml02,nmc03",
                 " FROM nme_file LEFT OUTER JOIN nmc_file ON nme03 = nmc01 LEFT OUTER JOIN nml_file ON nme14 = nml01,nma_file",
                 " WHERE nme01 = nma01",
                 " AND ", tm.wc1 CLIPPED,
                 " AND ", tm.wc CLIPPED,
                 " AND nme16 BETWEEN '", tm.bdate,"' AND '", tm.edate,"'"
 
 
     LET l_sql_1 = " SELECT nma01,0 FROM nma_file",
                    " WHERE ", tm.wc1 CLIPPED
     PREPARE r210_prepare1 FROM l_sql_1
     IF  SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
     END IF
     DECLARE r210_curs1 CURSOR FOR r210_prepare1
     LET l_rest = 0
     FOREACH r210_curs1 INTO srr.*
         message "=>",srr.nma01
         CALL ui.Interface.refresh()
         IF  STATUS != 0 THEN CALL cl_err('foreach1:',STATUS,1)
	     EXIT FOREACH
	 END IF
         CALL s_cntrest(srr.nma01,tm.bdate,'2','2')
              RETURNING srr.rest  #計算期初餘額
         IF srr.rest IS NULL THEN LET srr.rest = 0 END IF
         LET l_rest = l_rest + srr.rest
     END FOREACH
 
     PREPARE r210_prepare FROM l_sql
     IF  SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
     END IF
     DECLARE r210_curs CURSOR FOR r210_prepare
     CALL cl_outnam('anmr210') RETURNING l_name
     IF tm.a = 'N' THEN
        START REPORT r210_rep TO l_name
     ELSE
        START REPORT r210_all TO l_name
     END IF
 
     LET g_pageno = 0
     LET g_gsum_1 = 0  #總計收
     LET g_gsum_2 = 0  #總計支
     FOREACH r210_curs INTO sr.*
          message "=>",sr.nme14,sr.nme15,sr.nme01
          CALL ui.Interface.refresh()
          IF  STATUS != 0 THEN CALL cl_err('foreach:',STATUS,1)
	      EXIT FOREACH
	  END IF
 
          IF  tm.a = 'N' THEN
              OUTPUT TO REPORT r210_rep(sr.*, l_rest)
          ELSE
              OUTPUT TO REPORT r210_all(sr.*, l_rest)
          END IF
 
     END FOREACH
 
     IF tm.a = 'N' THEN
        FINISH REPORT r210_rep
     ELSE
        FINISH REPORT r210_all
     END IF
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r210_rep(sr,l_rest)
   DEFINE l_last_sw   LIKE type_file.chr1,            #No.FUN-680107 VARCHAR(1)
          l_rest      LIKE nme_file.nme04,
          sr               RECORD
                           nme01 LIKE nme_file.nme01, #銀行編號
                           nme03 LIKE nme_file.nme03, #異動碼
                           nme04 LIKE nme_file.nme04, #金額
                           nme08 LIKE nme_file.nme08, #本幣金額
                           nme14 LIKE nme_file.nme14, #現金變動碼
                           nme15 LIKE nme_file.nme15, #部門編號
                           nme16 LIKE nme_file.nme16, #傳票日期
                           nml02 LIKE nml_file.nml02, #說明
                           nmc03 LIKE nmc_file.nmc03  #1:存 2:提
                        END RECORD,
      l_gem02      LIKE gem_file.gem02,
      l_sum        LIKE nme_file.nme04,
      l_nme08_1    LIKE nme_file.nme04,
      l_nme08_2    LIKE nme_file.nme04,
      l_gsum_1     LIKE nme_file.nme04,
      l_gsum_2     LIKE nme_file.nme04,
      l_sum_1      LIKE nme_file.nme04,
      l_sum_2      LIKE nme_file.nme04,
      l_rest1      LIKE nme_file.nme04,
      l_nme14      LIKE nme_file.nme14,   #No.FUN-680107 INTEGER
      l_nme15      LIKE nme_file.nme15,   #No.FUN-680107 INTEGER
      l_flag       LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER BY sr.nme15,sr.nme14
  FORMAT
   PAGE HEADER
        #公司名稱
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
        LET g_pageno=g_pageno+1
        LET pageno_total=PAGENO USING '<<<',"/pageno"
        #報表名稱
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
        PRINT g_head CLIPPED,pageno_total
        LET g_head1= g_x[5] CLIPPED,tm.bdate,' - ',tm.edate
        #PRINT g_head1                         #FUN-660060 remark
        PRINT COLUMN (g_len-25)/2+1, g_head1   #FUN-660060
        IF g_pageno = 1 THEN #期初餘額
           PRINT g_x[9] CLIPPED,cl_numfor(l_rest,36,g_azi04)
           LET l_rest1=l_rest
        ELSE
           PRINT ''
        END IF
        PRINT g_dash[1,g_len]
        PRINT g_x[31] CLIPPED, g_x[32] CLIPPED, g_x[33] CLIPPED, g_x[34] CLIPPED,
              g_x[35] CLIPPED, g_x[36] CLIPPED
        PRINT g_dash1
        LET l_last_sw = 'n'
 
    BEFORE GROUP OF sr.nme15    #部門別
        LET l_gem02=''
        SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.nme15
        PRINT g_x[12] CLIPPED,sr.nme15 CLIPPED,' ',l_gem02 CLIPPED
        LET l_sum_1 = 0 #小計收
        LET l_sum_2 = 0 #小計支
        LET l_nme08_1 = 0 #小計收
        LET l_nme08_2 = 0 #小計支
 
    ON EVERY ROW
        LET l_gsum_1 = SUM(sr.nme08) WHERE sr.nmc03 = '1'
        LET l_gsum_2 = SUM(sr.nme08) WHERE sr.nmc03 = '2'
        IF cl_null(l_gsum_1) THEN LET l_gsum_1 = 0  END IF
        IF cl_null(l_gsum_2) THEN LET l_gsum_2 = 0  END IF
 
    AFTER GROUP OF sr.nme14
        LET l_nme08_1 = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '1' #小計
        LET l_nme08_2 = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '2'
        IF cl_null(l_nme08_1) THEN LET l_nme08_1 = 0  END IF
        IF cl_null(l_nme08_2) THEN LET l_nme08_2 = 0  END IF
        LET l_sum     = l_nme08_1 - l_nme08_2    #淨額
        LET l_rest1   = l_rest1 + l_sum
        PRINT COLUMN g_c[31], sr.nme14,
              COLUMN g_c[32], sr.nml02 CLIPPED,
              COLUMN g_c[33], cl_numfor(l_nme08_1,33,g_azi04),
              COLUMN g_c[34], cl_numfor(l_nme08_2,34,g_azi04),
              COLUMN g_c[35], cl_numfor(l_sum,35,g_azi04),
              COLUMN g_c[36], cl_numfor(l_rest1,36,g_azi04)
        LET l_nme08_1 = 0
        LET l_nme08_2 = 0
 
    AFTER GROUP OF sr.nme15
        LET l_sum_1 = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '1'
        LET l_sum_2 = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '2'
        IF cl_null(l_sum_1) THEN LET l_sum_1 = 0  END IF
        IF cl_null(l_sum_2) THEN LET l_sum_2 = 0  END IF
        LET l_sum   = l_sum_1 - l_sum_2    #淨額
        PRINT COLUMN g_c[31], g_x[13] CLIPPED,
              COLUMN g_c[33], cl_numfor(l_sum_1,33,g_azi05),
              COLUMN g_c[34], cl_numfor(l_sum_2,34,g_azi05),
              COLUMN g_c[35], cl_numfor(l_sum,35,g_azi05)
        SKIP 1 LINE
 
    ON LAST ROW
         PRINT g_dash_1[1,g_len]
         IF cl_null(l_gsum_1) THEN LET l_gsum_1 = 0 END IF
         IF cl_null(l_gsum_2) THEN LET l_gsum_2 = 0 END IF
         LET l_sum   = l_gsum_1 - l_gsum_2    #淨額
         PRINT COLUMN g_c[32], g_x[11] CLIPPED,
               COLUMN g_c[33], cl_numfor(l_gsum_1,33,g_azi05),
               COLUMN g_c[34], cl_numfor(l_gsum_2,34,g_azi05),
               COLUMN g_c[35], cl_numfor(l_sum,35,g_azi05)
         SKIP 1 LINE
         LET l_rest1 = l_rest + l_gsum_1 - l_gsum_2
         PRINT COLUMN g_c[35],g_x[15] CLIPPED,
               COLUMN g_c[36],cl_numfor(l_rest1,36,g_azi05)
 
         LET l_last_sw = 'y'
         PRINT g_dash[1,g_len]
         PRINT '(anmr210)' , COLUMN (g_len-9) ,g_x[7] CLIPPED
 
   PAGE TRAILER
         IF l_last_sw = 'n' THEN
	    PRINT g_dash[1,g_len]
            PRINT '(anmr210)' , COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
         END IF
END REPORT
 
------彙總---------
REPORT r210_all(sr,l_rest)
     DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
            l_rest       LIKE nme_file.nme04,
            sr           RECORD
                           nme01 LIKE nme_file.nme01, #銀行編號
                           nme03 LIKE nme_file.nme03, #異動碼
                           nme04 LIKE nme_file.nme04, #金額
                           nme08 LIKE nme_file.nme08, #本幣金額
                           nme14 LIKE nme_file.nme14, #現金變動碼
                           nme15 LIKE nme_file.nme15, #部門編號
                           nme16 LIKE nme_file.nme16, #傳票日期
                           nml02 LIKE nml_file.nml02, #說明
                           nmc03 LIKE nmc_file.nmc03  #1:存 2:提
                        END RECORD,
      l_debit      LIKE nme_file.nme04,
      l_credit     LIKE nme_file.nme04,
      l_gsum_1     LIKE nme_file.nme04,
      l_gsum_2     LIKE nme_file.nme04,
      l_nme08_1    LIKE nme_file.nme04,
      l_nme08_2    LIKE nme_file.nme04,
      l_crest      LIKE nme_file.nme04,
      l_grest      LIKE nme_file.nme04,
      l_nma01      LIKE nma_file.nma01,
      l_rest1      LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6)
      l_nme14      LIKE nme_file.nme14,   #No.FUN-680107 INTEGER
      l_nme15      LIKE nme_file.nme15,   #No.FUN-680107 INTEGER
      l_flag       LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.nme14
  FORMAT
   PAGE HEADER
        #公司名稱
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
        LET g_pageno=g_pageno+1
        LET pageno_total=PAGENO USING '<<<',"/pageno"
        LET g_head=g_head CLIPPED, pageno_total
        PRINT g_head
 
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
        LET g_head1= g_x[5] CLIPPED,tm.bdate,' - ',tm.edate
        #PRINT g_head1                      #FUN-660060 remark
        PRINT COLUMN (g_len-25)/2+1,g_head1 #FUN-660060
        IF g_pageno = 1 THEN
           PRINT g_x[9] CLIPPED,
                 COLUMN 10,cl_numfor(l_rest,36,g_azi05)
           LET l_grest = l_rest   #期初餘額
        ELSE
           PRINT ''
        END IF
 
        PRINT g_dash[1,g_len]
        PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
              g_x[35] CLIPPED,g_x[36] CLIPPED
        PRINT g_dash1
        LET l_last_sw = 'n'
 
    BEFORE GROUP OF sr.nme14
        LET l_gsum_1 = 0  #總計收
        LET l_gsum_2 = 0  #總計支
        LET l_nme08_1 = 0 #小計收
        LET l_nme08_2 = 0 #小計支
        LET l_crest = 0   #淨額
 
    ON EVERY ROW
 
    AFTER GROUP OF sr.nme14
        LET l_nme08_1 = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '1'
        LET l_nme08_2 = GROUP SUM(sr.nme08) WHERE sr.nmc03 = '2'
        IF  cl_null(l_nme08_1) THEN LET l_nme08_1 = 0 END IF
        IF  cl_null(l_nme08_2) THEN LET l_nme08_2 = 0 END IF
        LET l_crest = l_nme08_1 - l_nme08_2    #淨額
        LET l_grest = l_grest + l_crest        #餘額
        PRINT COLUMN g_c[31], sr.nme14,
              COLUMN g_c[32],sr.nml02 CLIPPED,
              COLUMN g_c[33], cl_numfor(l_nme08_1,33,g_azi04),
              COLUMN g_c[34], cl_numfor(l_nme08_2,34,g_azi04),
              COLUMN g_c[35], cl_numfor(l_crest,35,g_azi04),
              COLUMN g_c[36], cl_numfor(l_grest,36,g_azi04)
 
    ON LAST ROW
       LET l_gsum_1 = SUM(sr.nme08) WHERE sr.nmc03 = '1'
       LET l_gsum_2 = SUM(sr.nme08) WHERE sr.nmc03 = '2'
       IF cl_null(l_gsum_1) THEN LET l_gsum_1 = 0 END IF
       IF cl_null(l_gsum_2) THEN LET l_gsum_2 = 0 END IF
       LET l_crest = l_gsum_1 - l_gsum_2     #淨額
       PRINT g_dash[1,g_len]
       #PRINT g_dash1
       PRINT COLUMN g_c[32],g_x[11] CLIPPED,  #總計
             COLUMN g_c[33], cl_numfor(l_gsum_1,33,g_azi05),
             COLUMN g_c[34], cl_numfor(l_gsum_2,34,g_azi05),
             COLUMN g_c[35], cl_numfor(l_crest,35,g_azi05)
       LET l_rest1 = l_rest + l_gsum_1 - l_gsum_2
       PRINT COLUMN g_c[35],g_x[15] CLIPPED,
             COLUMN g_c[36],cl_numfor(l_rest1,36,g_azi05)
 
       LET l_last_sw = 'y'
       PRINT g_dash[1,g_len]
       PRINT '(anmr210)' , COLUMN (g_len-9) ,g_x[7] CLIPPED #(結束)
 
   PAGE TRAILER
       IF l_last_sw = 'n' THEN
           PRINT g_dash[1,g_len]
          PRINT '(anmr210)' , COLUMN (g_len-9),g_x[6] CLIPPED #(接下頁)
       ELSE SKIP 2 LINE
       END IF
END REPORT
 
 
