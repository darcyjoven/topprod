# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abgr504.4gl
# Descriptions...: 生產預算資料明細表
# Date & Author..: yuening 031015
# Modify.........: No.FUN-580010 05/08/09 By yoyo 憑証類報表原則修改
# Modify.........: No.TQC-660030 06/06/07 By Smapmin 輸入前給予預設值
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                           # Print condition RECORD
              wc      LIKE type_file.chr1000,  #No.FUN-680061 VARCHAR(700)
              bgn01   LIKE bgn_file.bgn01,     
              bgn02   LIKE bgn_file.bgn02,
              s       LIKE type_file.chr3,     #No.FUN-680061 VARCHAR(3)
              t       LIKE type_file.chr3,     #No.FUN-680061 VARCHAR(3)
              u       LIKE type_file.chr3,     #No.FUN-680061 VARCHAR(3)
              more    LIKE type_file.chr1      #No.FUN-680061 VARCHAR(1)
              END RECORD,
           g_sql     string,                 # RDSQL STATEMENT  #No.FUN-580092 HCN
       g_tot_bal  LIKE type_file.num20_6  #No.FUN-680061  DEC(20,6)
 
DEFINE    g_orderA ARRAY[3] OF LIKE type_file.chr20   #No.FUN-680061 VARCHAR(20)
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose    #No.FUN-680061  SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   WHENEVER ERROR CONTINUE
     WHENEVER ERROR CONTINUE
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
#  SELECT azi03,azi04 INTO g_azi03,g_azi04 FROM azi_file WHERE azi01=g_aza.aza17  #NO.CHI-6A0004
   LET g_trace = 'N'                # default trace off
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bgn01=ARG_VAL(8)
   LET tm.bgn02=ARG_VAL(9)
LET tm.s  = ARG_VAL(10)
LET tm.t  = ARG_VAL(11)
LET tm.u  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r504_tm(0,0)                # Input print condition
      ELSE CALL r504()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION r504_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680061 SMALLINT
       l_cmd          LIKE type_file.chr1000   #No.FUN-680061 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 14
   OPEN WINDOW r504_w AT p_row,p_col
        WITH FORM "abg/42f/abgr504" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #-----TQC-660030---------
   LET tm2.s1 = '1'
   LET tm2.s2 = '2'
   LET tm2.s3 = '3'
   LET tm2.t1 = 'N'
   LET tm2.t2 = 'N'
   LET tm2.t3 = 'N'
   LET tm2.u1 = 'N'
   LET tm2.u2 = 'N'
   LET tm2.u3 = 'N'
   #-----END TQC-660030-----
WHILE TRUE
CONSTRUCT BY NAME tm.wc ON bgn012,bgn013,bgn014
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
      LET INT_FLAG = 0 CLOSE WINDOW r504_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
INPUT BY NAME tm.bgn01,tm.bgn02,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more WITHOUT DEFAULTS HELP 1   #TQC-660030
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLT LET g_trace = 'Y'    # Trace on
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
      LET INT_FLAG = 0 CLOSE WINDOW r504_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   # get exec cmd (fglgo xxxx)
             WHERE zz01='abgr504'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abgr504','9031',1)
      ELSE
         LET tm.wc=cl_wcsub(tm.wc)
         LET l_cmd = l_cmd CLIPPED,         # (at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bgn01 CLIPPED,"'",   #TQC-610054
                         " '",tm.bgn02 CLIPPED,"'",   #TQC-610054
                      " '",tm.s CLIPPED,"'",
                      " '",tm.t CLIPPED,"'",
                      " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('abgr504',g_time,l_cmd) # Execute cmd at later time
      END IF
      CLOSE WINDOW r504_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r504()
   ERROR ""
END WHILE
   CLOSE WINDOW r504_w
END FUNCTION
 
FUNCTION r504()
   DEFINE l_name    LIKE type_file.chr20,     #No.FUN-680061 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0056
          l_sql     LIKE type_file.chr1000,   # RDSQL STATEMENT    #No.FUN-680061  VARCHAR(1500)
          l_chr        LIKE type_file.chr1,   #No.FUN-680061   VARCHAR(1)
          l_za05    LIKE type_file.chr1000,   #No.FUN-680061   VARCHAR(40)
          l_cnt     LIKE type_file.num5,      #No.FUN-680061   SMALLINT
          l_order    ARRAY[5] OF LIKE bgn_file.bgn014,    #No.FUN-680061  VARCHAR(20)  
       sr         RECORD
                         order1 LIKE bgn_file.bgn012,    #No.FUN-680061  VARCHAR(20)
                         order2 LIKE bgn_file.bgn013,    #No.FUN-680061  VARCHAR(20)
                         order3 LIKE bgn_file.bgn014,    #No.FUN-680061  VARCHAR(20)
                         bgn  RECORD LIKE bgn_file.*      #生產預算資料
                     END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bgnuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bgngrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bgngrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bgnuser', 'bgngrup')
     #End:FUN-980030
 
 
     IF cl_null(tm.bgn01) THEN
        LET l_sql = "SELECT ' ',' ',' ',bgn_file.*  FROM bgn_file ",
                    " WHERE ",tm.wc CLIPPED
     ELSE
        LET l_sql = "SELECT ' ',' ',' ',bgn_file.*  FROM bgn_file ",
                    " WHERE ",tm.wc CLIPPED,
                    " AND bgn01='",tm.bgn01,"' ",
                    " AND bgn02='",tm.bgn02,"' "
     END IF
 
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r504_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        RETURN
     END IF
     DECLARE r504_curs1 CURSOR FOR r504_prepare1
     CALL cl_outnam('abgr504') RETURNING l_name
     START REPORT r504_rep TO l_name
     LET g_pageno = 0
     FOREACH r504_curs1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
    IF g_trace='Y' THEN DISPLAY sr.bgn.bgn01,' ',sr.bgn.bgn02 END IF
       FOR g_i = 1 TO 3
           CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bgn.bgn012
                WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.bgn.bgn013
                WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.bgn.bgn014
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
 
       OUTPUT TO REPORT r504_rep(sr.*)
     END FOREACH
     FINISH REPORT r504_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r504_rep(sr)
   DEFINE l_ima01      LIKE ima_file.ima01
   DEFINE l_ima25      LIKE ima_file.ima25
   DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680061 VARCHAR(1)  
       sr           RECORD
                         order1 LIKE bgn_file.bgn012,   #No.FUN-680061 VARCHAR(20) 
                         order2 LIKE bgn_file.bgn013,   #No.FUN-680061 VARCHAR(20)  
                         order3 LIKE bgn_file.bgn014,   #No.FUN-680061 VARCHAR(20) 
                         bgn  RECORD LIKE bgn_file.*    #生產預算資料
                       END RECORD,
          l_chr        LIKE type_file.chr1              #No.FUN-680061  VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bgn.bgn01,sr.bgn.bgn02,sr.order1,sr.order2,sr.order3,
           sr.bgn.bgn012,sr.bgn.bgn013,sr.bgn.bgn014,sr.bgn.bgn03
  FORMAT
   PAGE HEADER
#No.FUN-580010--start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      LET g_pageno = g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT COLUMN 45,g_x[11] CLIPPED,sr.bgn.bgn01,' ',
            g_x[12] CLIPPED,sr.bgn.bgn02 USING '#####'
#NO.FUN-580010--end
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.bgn.bgn02
      SKIP TO TOP OF PAGE
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.bgn.bgn014
        LET l_ima01=''
        LET l_ima25=''
        SELECT ima01 INTO l_ima01 FROM ima_file
         WHERE ima01=sr.bgn.bgn014
        IF cl_null(l_ima01) THEN
           SELECT bgg06 INTO l_ima01 FROM bgg_file
            WHERE bgg01=sr.bgn.bgn01
              AND bgg02=sr.bgn.bgn014
        END IF
        SELECT ima25 INTO l_ima25 FROM ima_file
         WHERE ima01=l_ima01
 
      PRINT COLUMN 01,g_x[13] CLIPPED,COLUMN 10,sr.bgn.bgn013,
            COLUMN 31,g_x[14] CLIPPED,COLUMN 40,sr.bgn.bgn012
      PRINT COLUMN 01,g_x[15] CLIPPED,COLUMN 10,sr.bgn.bgn014
      PRINT g_x[22] CLIPPED,sr.bgn.bgn11  CLIPPED,  #No.8563
            COLUMN  15,g_x[23] CLIPPED,l_ima25 ,
            COLUMN  31,g_x[24] CLIPPED,sr.bgn.bgn11_fac USING '###&.&&&'
 
      PRINT g_dash2[1,g_len]       #No.FUN-580010
#No.FUN-580010--start
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
      PRINT g_dash1
#No.FUN-580010--end
 
 
   ON EVERY ROW
      IF g_trace = 'Y' THEN
         DISPLAY sr.bgn.bgn01,sr.bgn.bgn02
      END IF
#No.FUN-580010--start
      PRINTX name=D1
            COLUMN g_c[31],sr.bgn.bgn03 USING '&&',
            COLUMN g_c[32],cl_numfor(sr.bgn.bgn04,32,0),
            COLUMN g_c[33],cl_numfor(sr.bgn.bgn05,33,g_azi04),
            COLUMN g_c[34],cl_numfor(sr.bgn.bgn06,34,g_azi04),
            COLUMN g_c[35],cl_numfor(sr.bgn.bgn07,35,g_azi04),
            COLUMN g_c[36],cl_numfor(sr.bgn.bgn08,36,g_azi04)
#No.FUn-580010--end
   AFTER GROUP OF sr.bgn.bgn014
      PRINT ''
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1]='Y' THEN
#No.FUN-580010--start
         PRINT g_dash2[1,g_len]
         PRINTX name=S1 COLUMN g_c[31],g_x[18] CLIPPED;
         PRINT COLUMN g_c[32],cl_numfor(GROUP SUM(sr.bgn.bgn04),32,0),
               COLUMN g_c[33],cl_numfor(GROUP SUM(sr.bgn.bgn05),33,g_azi04),
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.bgn.bgn06),34,g_azi04),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bgn.bgn07),35,g_azi04),
               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.bgn.bgn08),36,g_azi04)
#No.FUN-580010--end
         PRINT ''
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2]='Y' THEN
#No.FUN-580010--start
         PRINT g_dash2[1,g_len]
         PRINTX name=S1 COLUMN g_c[31],g_x[19] CLIPPED,
               COLUMN g_c[32],cl_numfor(GROUP SUM(sr.bgn.bgn04),32,0),
               COLUMN g_c[33],cl_numfor(GROUP SUM(sr.bgn.bgn05),33,g_azi04),
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.bgn.bgn06),34,g_azi04),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bgn.bgn07),35,g_azi04),
               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.bgn.bgn08),36,g_azi04)
#No.FUN-580010--end
         PRINT ''
      END IF
 
   AFTER GROUP OF sr.order3
#No.FUN-580010--start
      IF tm.u[3,3]='Y' THEN
         PRINT g_dash2[1,g_len]
         PRINTX name=S1 COLUMN g_c[31],g_x[20] CLIPPED;
         PRINT COLUMN g_c[32],cl_numfor(GROUP SUM(sr.bgn.bgn04),32,0),
               COLUMN g_c[33],cl_numfor(GROUP SUM(sr.bgn.bgn05),33,g_azi04),
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.bgn.bgn06),34,g_azi04),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bgn.bgn07),35,g_azi04),
               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.bgn.bgn08),36,g_azi04)
#No.FUN-580010--end
         PRINT ''
      END IF
 
   AFTER GROUP OF sr.bgn.bgn02 #年度合計
         PRINT g_dash2[1,g_len]
         PRINTX name=S1 COLUMN g_c[31],g_x[21] CLIPPED;
         PRINT COLUMN g_c[32],cl_numfor(GROUP SUM(sr.bgn.bgn04),32,0),
               COLUMN g_c[33],cl_numfor(GROUP SUM(sr.bgn.bgn05),33,g_azi04),
               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.bgn.bgn06),34,g_azi04),
               COLUMN g_c[35],cl_numfor(GROUP SUM(sr.bgn.bgn07),35,g_azi04),
               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.bgn.bgn08),36,g_azi04)
#No.FUN-580010--end
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
      IF l_last_sw = 'y' THEN
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
#Patch....NO.TQC-610035 <> #
