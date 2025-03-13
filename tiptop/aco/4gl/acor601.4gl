# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: acor601.4gl
# Descriptions...: 供應商轉廠記錄明細表
# Date & Author..: 00/09/26 By Mandy
# Modify.........: No.FUN-510042 05/01/20 By pengu 報表轉XML
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-840238 08/04/30 By TSD.lucasyeh 傳統報表轉CR報表
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-C80041 12/12/21 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                                        # Print condition RECORD
              wc      STRING,                       # Where condition No.TQC-630166
              bdate   LIKE type_file.dat,          #No.FUN-680069 DATE # 申請起始日期
              edate   LIKE type_file.dat,          #No.FUN-680069 DATE # 申請截止日期
              more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # 是否輸入其它特殊列印條件?
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING   #FUN-840238 add
DEFINE   g_str           STRING   #FUN-840238 add
DEFINE   l_table         STRING   #FUN-840238 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
#FUN-840238 ----START----  add
    LET g_sql = "cnm01.cnm_file.cnm01,",
                "cnm02.cnm_file.cnm02,",
                "cnm04.cnm_file.cnm04,",
                "cnm05.cnm_file.cnm05,",
                "cnm06.cnm_file.cnm06,",
                "cnm07.cnm_file.cnm07,",
                "cnm08.cnm_file.cnm08,",
                "cnn04.cnn_file.cnn04,",
                "cob02.cob_file.cob02,",
                "cob021.cob_file.cob021,",
                "cnn05.cnn_file.cnn05,",
                "cnn051.cnn_file.cnn051,",
                "cnn06.cnn_file.cnn06,",
                "cnn07.cnn_file.cnn07,",
                "cnn08.cnn_file.cnn08,",
                "l_mod1.cnn_file.cnn05,",
                "l_mod2.cnn_file.cnn08,",
                "order1.cnb_file.cnb04,",
                "azi03.azi_file.azi03,",
                "azi04.azi_file.azi04,",
                "qsdate.type_file.dat,",
                "qedate.type_file.dat" 
 
 LET  l_table = cl_prt_temptable('acor601',g_sql) CLIPPED
 IF l_table=-1 THEN EXIT PROGRAM END IF
 
 LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
             " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?, ?,?)"
 
 PREPARE insert_prep FROM g_sql
 
 IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
 END IF 
 #------------------------------ CR (1) ------------------------------#
#FUN-840238 -----END----- add
 
   LET g_pdate   = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom  = ARG_VAL(2)
   LET g_rlang   = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)
   LET g_prtway  = ARG_VAL(5)
   LET g_copies  = ARG_VAL(6)
   LET tm.wc     = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
#---------------No.TQC-610082 modify
  #LET tm.more   = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
#---------------No.TQC-610082 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
       THEN CALL acor601_tm(0,0)        # Input print condition
       ELSE CALL acor601()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor601_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680069 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW acor601_w AT p_row,p_col WITH FORM "aco/42f/acor601"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL            # Default condition
    LET tm.more  = 'N'
    LET tm.bdate = g_today
    LET tm.edate = g_today
    LET g_pdate  = g_today
    LET g_rlang  = g_lang
    LET g_bgjob  = 'N'
    LET g_copies = '1'
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON cnm01,cnm04,cnm05
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
        CLOSE WINDOW acor601_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
    END IF
    IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.bdate,tm.edate,tm.more      # Condition
    INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
                NEXT FIELD bdate
            END IF
        AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
                NEXT FIELD edate
            END IF
        AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
                NEXT FIELD more
            END IF
            IF tm.more = "Y" THEN
                CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                               g_bgjob,g_time,g_prtway,g_copies)
                     RETURNING g_pdate,g_towhom,g_rlang,
                               g_bgjob,g_time,g_prtway,g_copies
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
        CLOSE WINDOW acor601_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01 = 'acor601'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('acor601','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'",          #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('acor601',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW acor601_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
    END IF
    CALL cl_wait() #作業中,請稍後...
    CALL acor601() #製作報表
    ERROR ""
END WHILE
    CLOSE WINDOW acor601_w
END FUNCTION
 
FUNCTION acor601()
    DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20)  # External(Disk) file name
#       l_time           LIKE type_file.chr8        #No.FUN-6A0063
           l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200) 
           l_chr     LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           l_za05    LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(40)
           l_order   ARRAY[5] OF LIKE qcs_file.qcs03,  #No.FUN-680069 VARCHAR(10)
           sr        RECORD
                            cnm01   LIKE cnm_file.cnm01, #申請編號
                            cnm02   LIKE cnm_file.cnm02, #申請日期
                            cnm04   LIKE cnm_file.cnm04, #轉廠型態
                            cnm05   LIKE cnm_file.cnm05, #合同編號
                            cnm06   LIKE cnm_file.cnm06, #幣別
                            cnm07   LIKE cnm_file.cnm07, #轉出方公司編號
                            cnm08   LIKE cnm_file.cnm08, #轉入方廠商編號
                            cnn04   LIKE cnn_file.cnn04, #商品編號
                            cob02   LIKE cob_file.cob02, #貨物名稱規格
                            cob021  LIKE cob_file.cob021, #貨物名稱規格
                            cnn05   LIKE cnn_file.cnn05, #申請數量
                            cnn051  LIKE cnn_file.cnn051,#轉廠數量
                            cnn06   LIKE cnn_file.cnn06, #單位
                            cnn07   LIKE cnn_file.cnn07, #單價
                            cnn08   LIKE cnn_file.cnn08, #總值
                            l_mod1  LIKE cnn_file.cnn05, #餘數=(cnn05-cnn051)
                            l_mod2  LIKE cnn_file.cnn08, #餘數金額=餘數*cnn07
                            order1  LIKE cnb_file.cnb04, #No.FUN-680069 VARCHAR(20)
                            azi03   LIKE azi_file.azi03, #FUN-840238 Add
                            azi04   LIKE azi_file.azi04  #FUN-840238 Add
                     END RECORD
 
   #FUN-840238 ----START---- add
 
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
 
 
   #FUN-840238 -----END----- add
 
    SELECT zo02 INTO g_company FROM zo_file
        WHERE zo01 = g_rlang
    #Begin:FUN-980030
    #    IF g_priv2 = '4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND cnmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND cnmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND cnmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cnmuser', 'cnmgrup')
    #End:FUN-980030
 
    #抓取資料
    LET l_sql = "SELECT cnm01,cnm02,cnm04,cnm05,cnm06,cnm07, ",
                "   cnm08,cnn04,'','',cnn05,cnn051,cnn06,cnn07,cnn08, ",
                "   '','','' ",
                "  FROM cnm_file LEFT OUTER JOIN cnn_file ON cnm01 = cnn01",
                "  WHERE 1=1",
                "    AND cnmacti = 'Y' ",
                "    AND cnmconf <> 'X' ", #CHI-C80041
                "    AND cnm02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                "      AND ",tm.wc CLIPPED
  
     LET l_sql = l_sql CLIPPED, " ORDER BY cnm08,cnn04,cnm02 "
 
     PREPARE acor601_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
         EXIT PROGRAM
     END IF
     DECLARE acor601_curs1 CURSOR FOR acor601_prepare1
 
#    CALL cl_outnam('acor601') RETURNING l_name   #FUN-840238 mark
 
#    START REPORT acor601_rep TO l_name           #FUN-840238 mark
#    LET g_pageno = 0                             #FUN-840238 mark
 
     FOREACH acor601_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0  THEN
             CALL cl_err('foreach:curs1',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         SELECT cob02,cob021 INTO sr.cob02,sr.cob021 FROM cob_file
             WHERE cob01 = sr.cnn04
         IF sr.cnm04 = '1' OR sr.cnm04 = '2' THEN
             SELECT pmc03 INTO sr.order1 FROM pmc_file
                 WHERE pmc01 = sr.cnm08
         END IF
         IF sr.cnm04 = '3' OR sr.cnm04 = '4' THEN
             SELECT cnb04 INTO sr.order1 FROM cnb_file
                 WHERE cnb01 = sr.cnm07
         END IF
 
        #FUN-840238  ----START---- add
         SELECT azi03,azi04 INTO sr.azi03,sr.azi04 FROM azi_file
                WHERE azi01 = sr.cnm06
        #FUN-840238  -----END----- add
 
         LET sr.l_mod1 = sr.cnn05 - sr.cnn051  #餘數 = cnn05 - cnn051
         LET sr.l_mod2 = sr.l_mod1 * sr.cnn07  #餘數金額 = 餘數 * cnn07
#        OUTPUT TO REPORT acor601_rep(sr.*)  #FUN-840238 mark
 
   #FUN-840238  ----START---- add
 
     EXECUTE insert_prep USING sr.*,tm.bdate,tm.edate
    #------------------------------ CR (3) ------------------------------#
   #FUN-840238  -----END----- add
 
     END FOREACH
 
#FUN-840238  ----START---- add
    SELECT zz05 INTO g_zz05 FROM zz_file
        WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'cnm01,cnm04,cnm05') RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
 
     CALL cl_prt_cs3('acor601','acor601',l_sql,g_str) 
    #------------------------------ CR (4) ------------------------------#
#FUN-840238  -----END----- add
 
#    FINISH REPORT acor601_rep    #FUN-840238  mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-840238 mark
 
END FUNCTION
 
#FUN-840238  ----START---- mark
{
REPORT acor601_rep(sr)
    DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           sr           RECORD
                            cnm01   LIKE cnm_file.cnm01, #申請編號
                            cnm02   LIKE cnm_file.cnm02, #申請日期
                            cnm04   LIKE cnm_file.cnm04, #轉廠型態
                            cnm05   LIKE cnm_file.cnm05, #合同編號
                            cnm06   LIKE cnm_file.cnm06, #幣別
                            cnm07   LIKE cnm_file.cnm07, #轉出方公司編號
                            cnm08   LIKE cnm_file.cnm08, #轉入方廠商編號
                            cnn04   LIKE cnn_file.cnn04, #商品編號
                            cob02   LIKE cob_file.cob02, #貨物名稱規格
                            cob021  LIKE cob_file.cob021, #貨物名稱規格
                            cnn05   LIKE cnn_file.cnn05, #申請數量
                            cnn051  LIKE cnn_file.cnn051,#轉廠數量
                            cnn06   LIKE cnn_file.cnn06, #單位
                            cnn07   LIKE cnn_file.cnn07, #單價
                            cnn08   LIKE cnn_file.cnn08, #總值
                            l_mod1  LIKE cnn_file.cnn05, #餘數=(cnn05-cnn051)
                            l_mod2  LIKE cnn_file.cnn08, #餘數金額=餘數*cnn07
                            order1  LIKE cnb_file.cnb04  #No.FUN-680069 VARCHAR(20)
                        END RECORD
    OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
    ORDER BY sr.order1,sr.cnn04,sr.cnm02
    FORMAT
    PAGE HEADER
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
        LET g_pageno=g_pageno+1
        LET pageno_total=PAGENO USING '<<<',"/pageno"
        PRINT g_head CLIPPED,pageno_total
 
        LET g_head1=g_x[11] CLIPPED,tm.bdate,' - ',tm.edate
        PRINT g_head1
        PRINT g_dash[1,g_len]
        PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[44],
              g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
              g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
              g_x[43] CLIPPED
        PRINT g_dash1
        LET l_last_sw = 'n'
    BEFORE GROUP OF sr.order1
         IF sr.cnm04 = '1' OR sr.cnm04 = '2' THEN
            PRINT COLUMN g_c[31],sr.cnm08;
         ELSE
            IF sr.cnm04 = '3' OR sr.cnm04 = '4' THEN
               PRINT COLUMN g_c[31],sr.cnm07;
            END IF
         END IF
        PRINT COLUMN g_c[32],sr.order1[1,10];
 
    ON EVERY ROW
        SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file WHERE azi01=sr.cnm06
        PRINT COLUMN g_c[33],sr.cnn04,
              COLUMN g_c[34],sr.cob02,
              COLUMN g_c[44],sr.cob021,
              COLUMN g_c[35],sr.cnm02,
              COLUMN g_c[36],sr.cnm01[1,10],
              COLUMN g_c[37],sr.cnm06,
              COLUMN g_c[38],sr.cnn06,
              COLUMN g_c[39],cl_numfor(sr.cnn05,39,3),
              COLUMN g_c[40],cl_numfor(sr.cnn08,40,t_azi04),
              COLUMN g_c[41],cl_numfor(sr.cnn051,41,3),
              COLUMN g_c[42],cl_numfor(sr.l_mod1,42,3),
              COLUMN g_c[43],cl_numfor(sr.l_mod2,43,t_azi04)
    ON LAST ROW
        PRINT ''
        IF g_zz05 = 'Y' THEN
            CALL cl_wcchp(tm.wc,'cnm01,cnm04,cnm05')
                 RETURNING tm.wc
            PRINT g_dash[1,g_len]
                #No.TQC-630166 --start--
#               IF tm.wc[001,120] > ' ' THEN
#                   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#               IF tm.wc[121,240] > ' ' THEN
#                   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#               IF tm.wc[241,300] > ' ' THEN
#                   PRINT COLUMN 10,     tm.wc[241,200] CLIPPED END IF
                CALL cl_prt_pos_wc(tm.wc)
                #No.TQC-630166 ---end---
        END IF
        PRINT g_dash[1,g_len]
        LET l_last_sw = 'y'
        PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
    PAGE TRAILER
        IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
        ELSE
            SKIP 2 LINE
        END IF
END REPORT  }
#No.FUN-870144
#FUN-840238    -----END----- mark
