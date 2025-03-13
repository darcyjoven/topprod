# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr100.4gl
# Descriptions...: 產品清單
# Date & Author..: 95/01/23 By Danny
# Modify.........: No.MOD-4A0037 04/10/18 By Mandy ima133 由CHAR(15) 改為CHAR(20) 的影響
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-560264 05/10/20 By Smapmin 新增開窗功能
# Modify.........: NO.FUN-5B0105 05/12/27 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-5A0060 06/06/15 By Sarah 增加列印ima021規格
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
            #  wc      VARCHAR(500),        # Where condition
              wc     STRING,     #TQC-630166    # Where condition
              s      LIKE type_file.chr3,          #No.FUN-680137  VARCHAR(3)        # Order by sequence
              t      LIKE type_file.chr3,          #No.FUN-680137  VARCHAR(3)        # Eject sw
              more   LIKE type_file.chr1           #No.FUN-680137  VARCHAR(1)         # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_head1         STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL axmr100_tm(0,0)        # Input print condition
   ELSE
      CALL axmr100()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 13
 
   OPEN WINDOW axmr100_w AT p_row,p_col WITH FORM "axm/42f/axmr100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s3  = '3'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima131,ima06,ima09,ima10,ima11,
                              ima12,ima133,ima134
 
 
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
 
#No.FUN-570243  --start-
     ON ACTION CONTROLP
        IF INFIELD(ima01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima01
           NEXT FIELD ima01
        END IF
        IF INFIELD(ima133) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima133
           NEXT FIELD ima133
        END IF
#FUN-560264
        CASE
           WHEN INFIELD(ima131)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_oba"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima131
                   NEXT FIELD ima131
           WHEN INFIELD(ima06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_imz"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima06
                   NEXT FIELD ima06
           WHEN INFIELD(ima09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azf"
                   LET g_qryparam.arg1 = 'D'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima09
                   NEXT FIELD ima09
           WHEN INFIELD(ima10)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azf"
                   LET g_qryparam.arg1 = 'D'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima10
                   NEXT FIELD ima10
           WHEN INFIELD(ima11)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azf"
                   LET g_qryparam.arg1 = 'D'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima11
                   NEXT FIELD ima11
           WHEN INFIELD(ima12)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_azf"
                   LET g_qryparam.arg1 = 'D'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima12
                   NEXT FIELD ima12
           WHEN INFIELD(ima134)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_obe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ima134
                   NEXT FIELD ima134
        END CASE
#END FUN-560264
#No.FUN-570243 --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
 
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
     INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more  WITHOUT DEFAULTS #HELP 1
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
 
        AFTER INPUT
           LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
           LET tm.t = tm2.t1,tm2.t2,tm2.t3
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr100','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr100()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr100_w
END FUNCTION
 
FUNCTION axmr100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680137 VARCHAR(1000)
          l_chr        LIKE type_file.chr1,       #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_xml     LIKE aab_file.aab01,          #No.FUN-680137 VARCHAR(24)
          l_order    ARRAY[5] OF LIKE ima_file.ima01,                #No.FUN-680137 VARCHAR(40) #FUN-5B0105 20->40
          sr               RECORD order1 LIKE ima_file.ima01,        #No.FUN-680137 VARCHAR(40) #FUN-5B0105 20->40
                                  order2 LIKE ima_file.ima01,        #No.FUN-680137 VARCHAR(40) #FUN-5B0105 20->40
                                  order3 LIKE ima_file.ima01,        #No.FUN-680137 VARCHAR(40) #FUN-5B0105 20->40
                                  ima01  LIKE ima_file.ima01,
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,   #FUN-5A0060 add
                                  ima31  LIKE ima_file.ima31,
                                  ima131 LIKE ima_file.ima131,
                                  ima06  LIKE ima_file.ima06,
                                  ima09  LIKE ima_file.ima09,
                                  ima10  LIKE ima_file.ima10,
                                  ima11  LIKE ima_file.ima11,
                                  ima12  LIKE ima_file.ima12,
                                  ima133  LIKE ima_file.ima133,
                                  ima134 LIKE ima_file.ima134,
                                  ima130 LIKE ima_file.ima130
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 "       ima01,ima02,ima021,ima31,ima131,ima06,",   #FUN-5A0060 add ima021
                 "       ima09,ima10,ima11,ima12,ima133,ima134,ima130",
                 "  FROM ima_file ",
                 " WHERE ",tm.wc,
                 " ORDER BY ima01 "
 
     PREPARE axmr100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
     END IF
     DECLARE axmr100_curs1 CURSOR FOR axmr100_prepare1
 
     CALL cl_outnam('axmr100') RETURNING l_name
 
     START REPORT axmr100_rep TO l_name
 
     LET g_pageno = 0
     FOREACH axmr100_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima131
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima06
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.ima09
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ima10
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ima11
               WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.ima12
               WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.ima133
               WHEN tm.s[g_i,g_i] = '9' LET l_order[g_i] = sr.ima134
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       OUTPUT TO REPORT axmr100_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axmr100_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axmr100_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,          #No.FUN-680137  VARCHAR(1)
          sr               RECORD order1 LIKE ima_file.ima01,        #No.FUN-680137 VARCHAR(40) #FUN-5B0105 20->40
                                  order2 LIKE ima_file.ima01,        #No.FUN-680137 VARCHAR(40) #FUN-5B0105 20->40
                                  order3 LIKE ima_file.ima01,        #No.FUN-680137 VARCHAR(40) #FUN-5B0105 20->40
                                  ima01  LIKE ima_file.ima01,
                                  ima02  LIKE ima_file.ima02,
                                  ima021 LIKE ima_file.ima021,   #FUN-5A0060 add
                                  ima31  LIKE ima_file.ima31,
                                  ima131 LIKE ima_file.ima131,
                                  ima06  LIKE ima_file.ima06,
                                  ima09  LIKE ima_file.ima09,
                                  ima10  LIKE ima_file.ima10,
                                  ima11  LIKE ima_file.ima11,
                                  ima12  LIKE ima_file.ima12,
                                  ima133  LIKE ima_file.ima133,
                                  ima134 LIKE ima_file.ima134,
                                  ima130 LIKE ima_file.ima130
                        END RECORD,
      l_chr        LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No>TQC-6A0091
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
 
      PRINT g_dash[1,g_len]                              #FUN-4C0096
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],     #FUN-4C0096
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43]   #FUN-5A0060 add g_x[43]
      PRINT g_dash1                                      #FUN-4C0096
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
#FUN-4C0096
      PRINT COLUMN g_c[31],sr.ima01[1,30],  #No.TQC-6A0091
            COLUMN g_c[32],sr.ima02[1,30],  #No.TQC-6A0091
            COLUMN g_c[43],sr.ima021[1,30],   #FUN-5A0060 add  #No.TQC-6A0091
            COLUMN g_c[33],sr.ima31,
            COLUMN g_c[34],sr.ima131,
            COLUMN g_c[35],sr.ima06,
            COLUMN g_c[36],sr.ima09,
            COLUMN g_c[37],sr.ima10,
            COLUMN g_c[38],sr.ima11,
            COLUMN g_c[39],sr.ima12,
            COLUMN g_c[40],sr.ima133[1,30],   #No.TQC-6A0091
            COLUMN g_c[41],sr.ima134[1,10],
            COLUMN g_c[42],sr.ima130 #MOD-4A0037
##
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'ima01,ima131,ima06,ima133,ima134') RETURNING tm.wc
         PRINT g_dash1                         #FUN-4C0096
     #         IF tm.wc[001,120] > ' ' THEN            # for 132
     #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
     #         IF tm.wc[121,240] > ' ' THEN
     #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
     #         IF tm.wc[241,300] > ' ' THEN
     #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]                              #FUN-4C0096
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED,
            COLUMN g_len-9,g_x[7] CLIPPED     #FUN-4C0096  #No.TQC-6A0091
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]                              #FUN-4C0096
         PRINT g_x[4] CLIPPED,
               COLUMN g_len-9, g_x[6] CLIPPED  #FUN-4C0096  #No.TQC-6A0091
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
