# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: abgr503.4gl
# Descriptions...: 銷售預算表
# Date & Author..: 02/12/27 by qazzaq
# Modify ........: 03/10/15 by Jukey
# Modify.........: No.TQC-5B0050 05/11/08 By Smapmin 調整報表
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680025 06/08/24 By cheunl voucher型報表轉template1
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-870151 08/08/19 By xiaofeizhu  匯率調整為用azi07取位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C40159 12/04/20 By Elise abgr503 重新還原
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD
           wc      STRING,                  #No.TQC-630166
           s       LIKE type_file.chr3,     #No.FUN-680061 VARCHAR(3)
           t       LIKE type_file.chr3,     #No.FUN-680061 VARCHAR(3)
           u       LIKE type_file.chr3,     #No.FUN-680061 VARCHAR(3)
           bgm01   LIKE bgm_file.bgm01,
           bgm02   LIKE bgm_file.bgm02,
           more    LIKE type_file.chr1      #No.FUN-680061 VARCHAR(1)
           END RECORD
DEFINE    g_dash1_1  LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(300)
DEFINE    g_orderA ARRAY[3] OF LIKE type_file.chr20     #No.FUN-680061 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5    #No.FUN-680061 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
   LET g_trace  = 'N'
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bgm01 = ARG_VAL(8)   #TQC-610054
   LET tm.bgm02 = ARG_VAL(9)   #TQC-610054
   LET tm.s     = ARG_VAL(10)
   LET tm.t     = ARG_VAL(11)
   LET tm.u     = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r503_tm(0,0)                # Input print condition
      ELSE CALL r503()                      # Read data and create out-file
END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r503_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680061 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-680061 VARCHAR(100)
 
   #UI
       LET p_row = 3 LET p_col = 18
 
   OPEN WINDOW r503_w AT p_row,p_col
        WITH FORM "abg/42f/abgr503" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.s    = '123'
   LET tm.u    = '   '
   LET tm.t    = '   '
#TQC-5B0050
   LET tm2.s1 = '1'
   LET tm2.s2 = '2'
   LET tm2.s3 = '3'
   LET tm2.u1 = 'N'
   LET tm2.u2 = 'N'
   LET tm2.u3 = 'N'
   LET tm2.t1 = 'N'
   LET tm2.t2 = 'N'
   LET tm2.t3 = 'N'
#END TQC-5B0050
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bgm012,bgm014,bgm013,bgm015
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
      CLOSE WINDOW r503_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
INPUT BY NAME
                 #UI
                 tm.bgm01,tm.bgm02,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more
     WITHOUT DEFAULTS HELP 1
 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bgm02
         IF tm.bgm02<0 THEN
            NEXT FIELD bgm02
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
CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
      #UI
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
      CLOSE WINDOW r503_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='abgr503'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr503','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bgm01 CLIPPED,"'",   #TQC-610054
                         " '",tm.bgm01 CLIPPED,"'",   #TQC-610054
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('abgr503',g_time,l_cmd)
      END IF
      CLOSE WINDOW r503_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r503()
   ERROR ""
END WHILE
   CLOSE WINDOW r503_w
END FUNCTION
 
FUNCTION r503()
DEFINE l_name    LIKE type_file.chr20    #No.FUN-680061 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0056
DEFINE l_sql     LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(1000)   
DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF LIKE bgm_file.bgm014      #No.FUN-680061 VARCHAR(10)
DEFINE l_ima01   LIKE ima_file.ima01
DEFINE sr        RECORD order1 LIKE bgm_file.bgm012,   #No.FUN-680061 VARCHAR(20)
                        order2 LIKE bgm_file.bgm014,   #No.FUN-680061 VARCHAR(20)
                        order3 LIKE bgm_file.bgm013,   #No.FUN-680061 VARCHAR(20)
                        bgm01 LIKE bgm_file.bgm01,     #年度
                        bgm02 LIKE bgm_file.bgm02,     #地區
                        bgm012 LIKE bgm_file.bgm012,   #地區
                        bgm014 LIKE bgm_file.bgm014,   #客戶編號
                        occ02  LIKE occ_file.occ02,    #客戶簡稱
                        bgm013 LIKE bgm_file.bgm013,   #業務員
                        gen02  LIKE gen_file.gen02,    #業務員
                        bgm015 LIKE bgm_file.bgm015,   #部門
                        gem02  LIKE gem_file.gem02,    #業務員
                        bgm016 LIKE bgm_file.bgm016,   #幣別
                        bgm017 LIKE bgm_file.bgm017,   #產品別
                        ima021 LIKE ima_file.ima021,
                        ima02  LIKE ima_file.ima02,
                        ima25  LIKE ima_file.ima25,
                        bgm08  LIKE bgm_file.bgm08,    #
                        bgm08_fac  LIKE bgm_file.bgm08_fac,     #
                        bgm03  LIKE bgm_file.bgm03,    #期別
                        bgm04  LIKE bgm_file.bgm04,    #預算銷量
                        bga05  LIKE bga_file.bga05,    #匯率
                        bgm05  LIKE bgm_file.bgm05,    #預算銷售單價
                        totsum LIKE bgm_file.bgm05,    #金額
                        azi07 LIKE azi_file.azi07     #No.FUN-870151
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05
#      FROM zz_file WHERE zz01 = 'abgr503'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 75 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash1_1[g_i,g_i] = '-' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bgmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bgmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bgmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bgmuser', 'bgmgrup')
     #End:FUN-980030
 
#NO.CHI-6A0004 --START
#    SELECT azi03,azi04,azi05
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#      FROM azi_file
#     WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
     IF cl_null(tm.bgm01) OR cl_null(tm.bgm02) THEN
  LET l_sql = "SELECT '','','',bgm01,bgm02,                      ",
                 "  bgm012, bgm014, occ02, bgm013, gen02,bgm015,",
                 "  gem02 , bgm016, bgm017,'','','',bgm08,bgm08_fac, ",
                 "  bgm03,bgm04,'', bgm05,'','' ",  #No.FUN-870151 add azi07
                 " FROM bgm_file, OUTER occ_file, ",
                 "      OUTER gen_file, OUTER gem_file",
                 " WHERE ",tm.wc CLIPPED,
                 " AND bgm_file.bgm014= occ_file.occ01 ",
                 " AND bgm_file.bgm013= gen_file.gen01 ",
                 " AND bgm_file.bgm015= gem_file.gem01 "
     ELSE
  LET l_sql = "SELECT '','','',bgm01,bgm02,                      ",
                 "      bgm012, bgm014, occ02, bgm013, gen02,bgm015,",
                 "      gem02 , bgm016, bgm017,'','','',bgm08,bgm08_fac,",
                 "      bgm03,bgm04,'', bgm05,'','' ",  #No.FUN-870151 add azi07
                 " FROM bgm_file, OUTER occ_file, ",
                 "      OUTER gen_file, OUTER gem_file",
                 " WHERE bgm01 ='",tm.bgm01 CLIPPED,"'",
                 " AND   bgm02 ='",tm.bgm02 CLIPPED,"'",
                 " AND ",tm.wc CLIPPED,
                 " AND bgm_file.bgm014= occ_file.occ01 ",
                 " AND bgm_file.bgm013= gen_file.gen01 ",
                 " AND bgm_file.bgm015= gem_file.gem01 "
     LET l_sql = l_sql CLIPPED,
                 " ORDER BY bgm01,bgm02,bgm03,bgm012,bgm014,bgm013,bgm015,bgm016,bgm017"
     END IF
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r503_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM
     END IF
     DECLARE r503_curs1 CURSOR FOR r503_prepare1
     CALL cl_outnam('abgr503') RETURNING l_name
     START REPORT r503_rep TO l_name
     LET g_pageno = 0
     FOREACH r503_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
         CALL s_bga05(sr.bgm01,sr.bgm02,sr.bgm03,sr.bgm016)
         RETURNING sr.bga05
         SELECT ima021,ima02 INTO sr.ima021,sr.ima02
           FROM ima_file
                WHERE ima01 = sr.bgm017
         IF cl_null(sr.ima021) AND cl_null(sr.ima02) THEN
            SELECT oba02 INTO sr.ima02 FROM oba_file WHERE oba01 = sr.bgm017
         END IF
 
         LET l_ima01=''
         SELECT ima01 INTO l_ima01 FROM ima_file
          WHERE ima01=sr.bgm017
         IF cl_null(l_ima01) THEN
            SELECT bgg06 INTO l_ima01 FROM bgg_file
             WHERE bgg01=sr.bgm01
               AND bgg02=sr.bgm017
         END IF
         SELECT ima25 INTO sr.ima25 FROM ima_file
          WHERE ima01=l_ima01
          
         #No.FUN-870151---Begin
         SELECT azi07 INTO sr.azi07 FROM azi_file
          WHERE azi01=sr.bgm016
         #No.FUN-870151---End          
 
         LET sr.totsum = sr.bgm04 * sr.bgm05 * sr.bga05
       IF g_trace='Y' THEN
             DISPLAY sr.bgm012, sr.bgm014
          END IF
          FOR g_i = 1 TO 3
              CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bgm012
                                            LET g_orderA[g_i]= g_x[18]
                   WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.bgm014
                                            LET g_orderA[g_i]= g_x[19]
                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.bgm013
                                            LET g_orderA[g_i]= g_x[20]
                   WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.bgm015
                                            LET g_orderA[g_i]= g_x[21]
                   OTHERWISE LET l_order[g_i]  = '-'
                             LET g_orderA[g_i] = ' '          #清為空白
              END CASE
          END FOR
          LET sr.order1 = l_order[1]
          LET sr.order2 = l_order[2]
          LET sr.order3 = l_order[3]
          OUTPUT TO REPORT r503_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r503_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r503_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1                   #No.FUN-680061  VARCHAR(1)
DEFINE sr           RECORD order1 LIKE bgm_file.bgm012,   #No.FUN-680061 VARCHAR(20)
                           order2 LIKE bgm_file.bgm014,   #No.FUN-680061 VARCHAR(20)
                           order3 LIKE bgm_file.bgm013,   #No.FUN-680061 VARCHAR(20)
                           bgm01 LIKE bgm_file.bgm01,     #年度
                           bgm02 LIKE bgm_file.bgm02,     #期別
                           bgm012 LIKE bgm_file.bgm012,   #地區
                           bgm014 LIKE bgm_file.bgm014,   #客戶編號
                           occ02  LIKE occ_file.occ02,    #客戶簡稱
                           bgm013 LIKE bgm_file.bgm013,   #業務員
                           gen02  LIKE gen_file.gen02,    #業務員
                           bgm015 LIKE bgm_file.bgm015,	  #部門
                           gem02  LIKE gem_file.gem02,	  #業務員
                           bgm016 LIKE bgm_file.bgm016,	  #幣別
                           bgm017 LIKE bgm_file.bgm017,	  #產品別
                           ima021 LIKE ima_file.ima021,
                           ima02  LIKE ima_file.ima02,
                           ima25  LIKE ima_file.ima25,
                           bgm08  LIKE bgm_file.bgm08,    #
                           bgm08_fac  LIKE bgm_file.bgm08_fac,     #
                           bgm03  LIKE bgm_file.bgm03,    #期別
                           bgm04  LIKE bgm_file.bgm04,    #預算銷量
                           bga05  LIKE bga_file.bga05,    #匯率
                           bgm05  LIKE bgm_file.bgm05,    #預算銷售單價
                           totsum LIKE bgm_file.bgm05,    #金額
                           azi07 LIKE azi_file.azi07     #No.FUN-870151
                         END RECORD,
		l_rowno LIKE bgm_file.bgm05,    #No.FUN-680061 SMALLINT
		l_amt_1 LIKE type_file.num20_6, #No.FUN-680061 DEC(14,2)
		l_amt_2 LIKE type_file.num20_6, #No.FUN-680061 DEC(20,6)
		l_amt_3 LIKE type_file.num20_6  #No.FUN-680061 DEC(20,6)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,
           sr.bgm01,sr.bgm02,sr.bgm012,sr.bgm014,sr.bgm013,sr.bgm015,sr.bgm016,sr.bgm017,sr.bgm03
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company))/2)+1 ,g_company
#No.FUN-680025 --------------------start ---------------------------------
#     PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company       
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#No.FUN-680025 ---------------------end ------------------------------------
      LET g_pageno = g_pageno + 1                                                                                                   
      LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
      PRINT g_head CLIPPED,pageno_total
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]                   #No.FUN-680025
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] 
      PRINT ' '
#     PRINT g_dash
#     LET g_pageno = g_pageno + 1                                       #No.FUN-680025
      PRINT COLUMN 01,g_x[16] CLIPPED,sr.bgm01,
            COLUMN 11,g_x[17] CLIPPED,sr.bgm02 
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]                                              #No.FUN-680025
      PRINT g_x[18] CLIPPED,':',sr.bgm012,                                                                                          
            COLUMN  31,g_x[19] CLIPPED,':',sr.bgm014 CLIPPED,sr.occ02                                                               
      PRINT g_x[20] CLIPPED,':',sr.bgm013 CLIPPED,sr.gen02,                                                                         
            COLUMN  31,g_x[21] CLIPPED,':',sr.bgm015 CLIPPED,sr.gem02,                                                              
            COLUMN  60,g_x[22] CLIPPED,sr.bgm016 CLIPPED                                                                            
#     PRINT g_x[23] CLIPPED,sr.bgm017 CLIPPED,' ',sr.ima02 CLIPPED,' ',sr.ima021   #TQC-5B0050                                      
      PRINT g_x[23] CLIPPED,sr.bgm017 CLIPPED   #TQC-5B0050                                                                         
      PRINT COLUMN 8,sr.ima02 CLIPPED   #TQC-5B0050                                                                                 
      PRINT COLUMN 8,sr.ima021   #TQC-5B0050                                                                                        
      PRINT g_x[25] CLIPPED,sr.bgm08  CLIPPED,  #No.8563                                                                            
            COLUMN  15,g_x[26] CLIPPED,sr.ima25,                                                                                    
            COLUMN  31,g_x[27] CLIPPED,sr.bgm08_fac USING '###&.&&&'                                                                
#     PRINT g_dash1_1[1,g_len]                                                                                                      
      PRINT g_dash2                                                               #No.FUN-680025                                    
#     PRINT g_x[11] CLIPPED,COLUMN 56,g_x[24] CLIPPED
      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]                    #No.FUN-680025                                    
 #    PRINT g_dash[1,g_len]                                                       #No.FUN-680025                                    
      PRINT g_dash1                                                                                                                 
      LET l_amt_1 =0 LET l_amt_2 =0                                                                                                 
      LET l_amt_3 =0
      LET l_last_sw = 'n'
 
 
#  BEFORE GROUP OF sr.bgm02              #No.FUN-680025 
#     SKIP TO TOP OF PAGE                #No.FUN-680025 
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' 
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' 
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' 
         THEN SKIP TO TOP OF PAGE 
      END IF
 
#No.FUN-680025 ------------------------start ----------------------------------------
    #BEFORE GROUP OF sr.bgm017
    # PRINT g_x[18] CLIPPED,':',sr.bgm012,
    #       COLUMN  31,g_x[19] CLIPPED,':',sr.bgm014 CLIPPED,sr.occ02
    # PRINT g_x[20] CLIPPED,':',sr.bgm013 CLIPPED,sr.gen02,
    #       COLUMN  31,g_x[21] CLIPPED,':',sr.bgm015 CLIPPED,sr.gem02,
    #       COLUMN  60,g_x[22] CLIPPED,sr.bgm016 CLIPPED
#   # PRINT g_x[23] CLIPPED,sr.bgm017 CLIPPED,' ',sr.ima02 CLIPPED,' ',sr.ima021   #TQC-5B0050
    # PRINT g_x[23] CLIPPED,sr.bgm017 CLIPPED   #TQC-5B0050
    # PRINT COLUMN 8,sr.ima02 CLIPPED   #TQC-5B0050
    # PRINT COLUMN 8,sr.ima021   #TQC-5B0050
    # PRINT g_x[25] CLIPPED,sr.bgm08  CLIPPED,  #No.8563
    #       COLUMN  15,g_x[26] CLIPPED,sr.ima25,
    #       COLUMN  31,g_x[27] CLIPPED,sr.bgm08_fac USING '###&.&&&'
#   # PRINT g_dash1_1[1,g_len]
    # PRINT g_dash2                                                             
#   # PRINT g_x[11] CLIPPED,COLUMN 56,g_x[24] CLIPPED                         
    # PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]               
 #  # PRINT g_dash[1,g_len]                                                
    # PRINT g_dash1
    # LET l_amt_1 =0 LET l_amt_2 =0
    # LET l_amt_3 =0
#No.FUN-680025 -----------------------end ------------------
 
   ON EVERY ROW
       IF g_trace = 'Y' THEN
          DISPLAY sr.bgm012,sr.bgm014,sr.bgm013,sr.bgm015,sr.bgm017
       END IF
#No.FUN-680025  --------------------start-------------------
#     PRINT sr.bgm03 USING '&&',
#           COLUMN   4,sr.bgm04 USING '###,###,##&.#&',
#           COLUMN  20,sr.bga05 USING '####.###&',
#           COLUMN  31,sr.bgm05 USING '#,###,###,##&.#&',
#           COLUMN  49,sr.totsum USING '#,###,###,##&.#&'
#No.FUN-680025 --------------end ----------------------------
      PRINTX name = D1 COLUMN  g_c[31],sr.bgm03 USING '&&',
                       COLUMN  g_c[32],sr.bgm05 USING '#,###,###,###,##&.#&',   
                      #COLUMN  g_c[33],sr.bga05 USING '###,###,###,###.###&', #No.FUN-870151  
                       COLUMN  g_c[33],cl_numfor(sr.bga05,33,sr.azi07) ,      #No.FUN-870151   
                       COLUMN  g_c[34],sr.bgm04 USING '#,###,##&.#&', 
                       COLUMN  g_c[35],sr.totsum USING '#,###,###,###,##&.#&'
   LET  l_rowno = l_rowno+1
 
   AFTER GROUP OF sr.bgm017
         LET l_amt_2 = GROUP SUM(sr.totsum)
         PRINT ' '
         PRINTX name = S1 COLUMN g_c[34],g_x[24] CLIPPED,g_x[14] CLIPPED,        #No.FUN-680025
                          COLUMN g_c[35],l_amt_2 USING '#,###,###,###,##&.#&'        #No.FUN-680025 
#        PRINT COLUMN 36,g_x[24] CLIPPED,g_x[14] CLIPPED,             #No.FUN-680025 
#              COLUMN 49,l_amt_2 USING '#,###,###,###,##&.#&'             #No.FUN-680025 
         PRINT ' '
         PRINT ' '
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.bgm05)
         LET l_amt_2 = GROUP SUM(sr.totsum)
         PRINT ''
         PRINT g_orderA[1] CLIPPED,g_x[14]
#        PRINT   COLUMN   4,l_amt_1  USING '###,###,##&.#&',                    #No.FUN-680025 
#                COLUMN  49,l_amt_2 USING '#,###,###,###,##&.#&'                 #No.FUN-680025 
         PRINTX name = S1   COLUMN  g_c[32],l_amt_1  USING '#,###,###,###,##&.#&',         #No.FUN-680025 
                            COLUMN  g_c[35],l_amt_2 USING '#,###,###,###,##&.#&'              #No.FUN-680025 
	PRINT ''
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.bgm05)
         LET l_amt_2 = GROUP SUM(sr.totsum)
         PRINT ''
         PRINT g_orderA[2] CLIPPED,g_x[14]
#No.FUN-680025 ------------------------start -----------------------------------
         PRINTX name = S1   COLUMN  g_c[32],l_amt_1  USING '#,###,###,###,##&.#&',                                                                   
                            COLUMN  g_c[35],l_amt_2 USING '#,###,###,###,##&.#&'
#        PRINT   COLUMN   4,l_amt_1  USING '###,###,##&.#&',
#                COLUMN  49,l_amt_2 USING '#,###,###,##&.#&'
#No.FUN-680025 ----------------------------end --------------------------------
	PRINT ''
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_amt_1 = GROUP SUM(sr.bgm05)
         LET l_amt_2 = GROUP SUM(sr.totsum)
         PRINT ''
         PRINT g_orderA[3] CLIPPED,g_x[14]
#No.FUN-680025 ------------------start-------------------------------------
         PRINTX name = S1   COLUMN  g_c[32],l_amt_1  USING '#,###,###,###,##&.#&',                                                                   
                            COLUMN  g_c[35],l_amt_2 USING '#,###,###,###,##&.#&'
#        PRINT   COLUMN   4,l_amt_1  USING '###,###,##&.#&',
#                COLUMN  49,l_amt_2 USING '#,###,###,##&.#&'
#No.FUN-680025 ------------------------------end----------------------------
	PRINT ''
      END IF
 
   ON LAST ROW
         LET l_amt_1 =  SUM(sr.bgm05)
        #LET l_amt_2 = GROUP SUM(sr.totsum)  #MOD-C40159 mark
         LET l_amt_2 = SUM(sr.totsum)        #MOD-C40159
         PRINT ''
#No.FUN-680025 -----------------start------------------------
#        PRINT g_x[15]
#        PRINT   COLUMN   4,l_amt_1  USING '###,###,##&.#&',
#                COLUMN  49,l_amt_2 USING '#,###,###,##&.#&'
         PRINTX name = S1 g_x[15]   
         PRINTX name = S1   COLUMN  g_c[32],l_amt_1  USING '#,###,###,###,##&.#&',                                                                        
                            COLUMN  g_c[35],l_amt_2 USING '#,###,###,###,##&.#&'
#No.FUN-680025 -----------------------end---------------------------
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'bgm01,bgm02,bgm03,bgm04,bgm05')
              RETURNING tm.wc
#        PRINT g_dash[1,g_len]                      #No.FUN-680025
         PRINT g_dash                               #No.FUN-680025
         #No.TQC-630166 --start--
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
          CALL cl_prt_pos_wc(tm.wc)
          #No.TQC-630166 ---end---
      END IF
      PRINT g_dash                      #No.FUN-680025 
#     PRINT g_dash[1,g_len]             #No.FUN-680025 
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610035 <001,002,003> #
