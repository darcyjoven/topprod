# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: gapr110.4gl
# Descriptions...: 應付發票資料列印
# Date & Author..: 05/09/29 by zm
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690080 06/09/04 By douzh  零用金作業修改
 
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0095 06/11/13 By xumin 項次問題更改
# Modify.........: No.CHI-7C0003 07/12/04 By Smapmin 增加發票編號欄位
# Modify.........: No.MOD-960245 09/06/22 By mike 請調整gapr110.ora,將"    AND apk04 = pmc_file.pmc01 ",
#                                                 轉換成"    AND apk04 = pmc_file.pmc01 ",
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80049 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-C70173 12/07/16 By Polly QBE廠商編號改為廠商統一編號，並回傳統一編號回來
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm   RECORD
           #wc      VARCHAR(500), #TQC-630166
	    wc      STRING,
            s       LIKE type_file.chr3,     #NO FUN-690009 VARCHAR(03)
            t       LIKE type_file.chr3,     #NO FUN-690009 VARCHAR(03)
            u       LIKE type_file.chr3,     #NO FUN-690009 VARCHAR(03)
            more    LIKE type_file.chr1      #NO FUN-690009 VARCHAR(01)
        END RECORD,
        g_orderA    ARRAY[3] OF LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(12)
        g_i         LIKE type_file.num5,                 #NO FUN-690009 SMALLINT   #count/index for any purpose
        g_head1     STRING
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time         #FUN-B80049   ADD
 
  #-----TQC-610053---------
  LET g_pdate = ARG_VAL(1)
  LET g_towhom = ARG_VAL(2)
  LET g_rlang = ARG_VAL(3)
  LET g_bgjob = ARG_VAL(4)
  LET g_prtway = ARG_VAL(5)
  LET g_copies = ARG_VAL(6)
  LET tm.wc = ARG_VAL(7)
  LET tm.s  = ARG_VAL(8)
  LET tm.t  = ARG_VAL(9)
  LET tm.u  = ARG_VAL(10)
  LET g_rep_user = ARG_VAL(11)
  LET g_rep_clas = ARG_VAL(12)
  LET g_template = ARG_VAL(13)
  #-----END TQC-610053-----
 
   IF cl_null(tm.wc) THEN
      CALL r110_tm(0,0)
   ELSE
      CALL r110()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80049   ADD
END MAIN
 
FUNCTION r110_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,    #NO FUN-690009 SMALLINT
       l_cmd         LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(1000)
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW r110_w AT p_row,p_col WITH FORM "gap/42f/gapr110"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= 1
   LET tm.more = 'N'
   LET tm2.s1  = '2'
   LET tm2.s2  = '3'
   LET tm2.s3  = '1'
   LET tm2.u1  = 'N'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
 
   WHILE TRUE
      #CONSTRUCT BY NAME tm.wc ON apk01,apk04,apk05,apk11   #CHI-7C0003
      CONSTRUCT BY NAME tm.wc ON apk01,apk04,apk05,apk03,apk11   #CHI-7C0003
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            IF INFIELD(apk01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_m_apa5"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apk01
               NEXT FIELD apk01
            END IF
            IF INFIELD(apk04) THEN
               CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_pmc2"    #MOD-C70173 mark
               LET g_qryparam.form = "q_pmc5"    #MOD-C70173 add
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apk04
               NEXT FIELD apk04
            END IF
            IF INFIELD(apk11) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apk11
               NEXT FIELD apk11
            END IF
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION about
            CALL cl_about()
         ON ACTION help
            CALL cl_show_help()
         ON ACTION controlg
            CALL cl_cmdask()
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
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                    tm2.t1,tm2.t2,tm2.t3,
                    tm2.u1,tm2.u2,tm2.u3,
                    tm.more  WITHOUT DEFAULTS
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
         ON ACTION about
            CALL cl_about()
         ON ACTION help
            CALL cl_show_help()
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
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='gapr110'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('gapr110','9031',1)
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
                   " '",tm.s CLIPPED,"'",
                   " '",tm.t CLIPPED,"'",
                   " '",tm.u CLIPPED,"'",
                   " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                   " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                   " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('gapr110',g_time,l_cmd)
         END IF
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r110()
      ERROR ""
   END WHILE
   CLOSE WINDOW r110_w
END FUNCTION
 
FUNCTION r110()
   DEFINE   l_name    LIKE type_file.chr20,   #NO FUN-690009 VARCHAR(20)   # External(Disk) file name
#       l_time            LIKE type_file.chr8        #No.FUN-6A0097
            l_sql     LIKE type_file.chr1000, #NO FUN-690009 VARCHAR(1000) # RDSQL STATEMENT
            l_za05    LIKE type_file.chr1000, #NO FUN-690009 VARCHAR(40)
            l_order   ARRAY[5] OF  LIKE apk_file.apk04, #NO FUN-690009 VARCHAR(10)
            sr RECORD order1 LIKE apk_file.apk04,       #NO FUN-690009 VARCHAR(20)
                      order2 LIKE apk_file.apk04,       #NO FUN-690009 VARCHAR(20)
                      order3 LIKE apk_file.apk04,       #NO FUN-690009 VARCHAR(20)
                      apk01  LIKE apk_file.apk01,
                      apk02  LIKE apk_file.apk02,
                      apk04  LIKE apk_file.apk04,	
                      pmc03  LIKE pmc_file.pmc03,
                      apk05  LIKE apk_file.apk05,
                      apk03  LIKE apk_file.apk03,   #CHI-7C0003
                      apk11  LIKE apk_file.apk11,
                      apk29  LIKE apk_file.apk29,
                      apk08  LIKE apk_file.apk08,
                      apk07  LIKE apk_file.apk07,
                      apk06  LIKE apk_file.apk06
                  END RECORD
   
  # CALL cl_used('gapr110',g_time,1) RETURNING g_time         #No.FUN-6A0097    #FUN-B80049   MARK
   #No.FUN-BB0047--mark--Begin---
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time             #FUN-B80049    ADD
   #No.FUN-BB0047--mark--End-----
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                 #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND apkuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                 #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND apkgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND apkgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apkuser', 'apkgrup')
   #End:FUN-980030
 
 
   #LET l_sql = " SELECT '','','',apk01,apk02,apk04,pmc03,apk05,apk11,apk29,apk08,apk07,apk06 ",   #CHI-7C0003
   LET l_sql = " SELECT '','','',apk01,apk02,apk04,pmc03,apk05,apk03,apk11,apk29,apk08,apk07,apk06 ",   #CHI-7C0003
               "   FROM apk_file,apa_file,OUTER pmc_file",   
               "  WHERE apk01 = apa01 ",                     #No.FUN-690080
               "    AND apk04 = pmc_file.pmc01 ",                     #No.FUN-690080 #MOD-960245
               "    AND apkacti = 'Y' ",
               "    AND apa00 NOT IN ('13','17','25')",      #No.FUN-690080
               "    AND ", tm.wc CLIPPED
   PREPARE r110_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   DECLARE r110_curs1 CURSOR FOR r110_prepare1
   CALL cl_outnam('gapr110') RETURNING l_name
   START REPORT r110_rep TO l_name
   LET g_pageno = 0
   FOREACH r110_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      FOR g_i = 1 TO 3
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apk01
                                       LET g_orderA[g_i]= g_x[12]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apk04
                                       LET g_orderA[g_i]= g_x[13]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apk05 USING 'YYYYMMDD'
                                       LET g_orderA[g_i]= g_x[14]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apk03    #CHI-7C0003
                                       LET g_orderA[g_i]= g_x[16]   #CHI-7C0003
              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.apk11
                                       LET g_orderA[g_i]= g_x[15]
              OTHERWISE                LET l_order[g_i]  = '-'
                                       LET g_orderA[g_i] = ' '
         END CASE
      END FOR
      LET sr.order1 = l_order[1]
      LET sr.order2 = l_order[2]
      LET sr.order3 = l_order[3]
 
      OUTPUT TO REPORT r110_rep(sr.*)
   END FOREACH
 
   FINISH REPORT r110_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  # CALL cl_used('gapr110',g_time,2) RETURNING g_time     #No.FUN-6A0097    #FUN-B80049   MARK
   #No.FUN-BB0047--mark--Begin---
   # CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT r110_rep(sr)
   DEFINE   l_last_sw        LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
            sr RECORD order1 LIKE apk_file.apk04,     #NO FUN-690009 VARCHAR(20)
                      order2 LIKE apk_file.apk04,     #NO FUN-690009 VARCHAR(20)
                      order3 LIKE apk_file.apk04,     #NO FUN-690009 VARCHAR(20)
                      apk01  LIKE apk_file.apk01,
                      apk02  LIKE apk_file.apk02,
                      apk04  LIKE apk_file.apk04,	
                      pmc03  LIKE pmc_file.pmc03,
                      apk05  LIKE apk_file.apk05,
                      apk03  LIKE apk_file.apk03,   #CHI-7C0003
                      apk11  LIKE apk_file.apk11,
                      apk29  LIKE apk_file.apk29,
                      apk08  LIKE apk_file.apk08,
                      apk07  LIKE apk_file.apk07,
                      apk06  LIKE apk_file.apk06
                  END RECORD
 
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   ORDER BY sr.order1,sr.order2,sr.order3,sr.apk01
 
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
 
      LET g_head1 = g_x[11] CLIPPED,
                    g_orderA[1] CLIPPED,'-',
                    g_orderA[2] CLIPPED,'-',
                    g_orderA[3] CLIPPED
 
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41]   #CHI-7C0003
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
#      PRINT COLUMN g_c[31],sr.apk01,' - ',
      PRINT COLUMN g_c[31],sr.apk01, #TQC-6A0095 
#            COLUMN g_c[32],sr.apk02 USING '###&',#FUN-590118
            COLUMN g_c[32],cl_numfor(sr.apk02,4,0),  #TQC-6A0095
            COLUMN g_c[33],sr.apk04,
            COLUMN g_c[34],sr.pmc03,
            COLUMN g_c[35],sr.apk05,
            COLUMN g_c[36],sr.apk11,
            COLUMN g_c[37],sr.apk29 USING '#&.&&',
            COLUMN g_c[38],cl_numfor(sr.apk08,38,g_azi04),
            COLUMN g_c[39],cl_numfor(sr.apk07,39,g_azi04),
            COLUMN g_c[40],cl_numfor(sr.apk06,40,g_azi04),
            COLUMN g_c[41],sr.apk03   #CHI-7C0003
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         PRINT ''
	 PRINT COLUMN g_c[37],g_x[9] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.apk08),38,g_azi05),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.apk07),39,g_azi05),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.apk06),40,g_azi05)
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         PRINT ''
	 PRINT COLUMN g_c[37],g_x[9] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.apk08),38,g_azi05),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.apk07),39,g_azi05),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.apk06),40,g_azi05)
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         PRINT ''
	 PRINT COLUMN g_c[37],g_x[9] CLIPPED,
               COLUMN g_c[38],cl_numfor(GROUP SUM(sr.apk08),38,g_azi05),
               COLUMN g_c[39],cl_numfor(GROUP SUM(sr.apk07),39,g_azi05),
               COLUMN g_c[40],cl_numfor(GROUP SUM(sr.apk06),40,g_azi05)
      END IF
 
   ON LAST ROW
      PRINT ''
      PRINT COLUMN g_c[37],g_x[10] CLIPPED,
               COLUMN g_c[38],cl_numfor(SUM(sr.apk08),38,g_azi05),
               COLUMN g_c[39],cl_numfor(SUM(sr.apk07),39,g_azi05),
               COLUMN g_c[40],cl_numfor(SUM(sr.apk06),40,g_azi05)
 
      IF g_zz05 = 'Y' THEN
         #CALL cl_wcchp(tm.wc,'apk01,apk04,apk05,apk11')   #CHI-7C0003
         CALL cl_wcchp(tm.wc,'apk01,apk04,apk05,apk03,apk11')   #CHI-7C0003
            RETURNING tm.wc
         PRINT g_dash[1,g_len]
	 #TQC-630166
         #IF tm.wc[001,070] > ' ' THEN
         #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED
         #END IF
         #IF tm.wc[071,140] > ' ' THEN
         #   PRINT COLUMN 10,tm.wc[071,140] CLIPPED
         #END IF
         #IF tm.wc[141,210] > ' ' THEN
         #   PRINT COLUMN 10,tm.wc[141,210] CLIPPED
         #END IF
         #IF tm.wc[211,280] > ' ' THEN
         #   PRINT COLUMN 10,tm.wc[211,280] CLIPPED
         #END IF
          CALL cl_prt_pos_wc(tm.wc)
         #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED,
            COLUMN (g_len-9),g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,
               COLUMN (g_len-9),g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
