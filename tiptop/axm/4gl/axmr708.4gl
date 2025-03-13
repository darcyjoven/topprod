# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr708.4gl
# Descriptions...: 客戶狀態統計表
# Date & Author..: 02/12/10 By Leagh
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.MOD-590003 05/09/06 By jackie 修正報表不齊
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)    # Where condition
              more    LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)     # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
 
   INITIALIZE tm.* TO NULL                # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.wc = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL axmr708_tm(0,0)             # Input print condition
      ELSE CALL axmr708()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr708_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(400)
 
   LET p_row = 7 LET p_col = 18
 
   OPEN WINDOW axmr708_w AT p_row,p_col WITH FORM "axm/42f/axmr708"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofd01,gem01,ofd23,ofd22
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr708_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr708_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr708'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr708','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                        #" '",tm.more  CLIPPED,"'"  ,           #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr708',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr708_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr708()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr708_w
END FUNCTION
 
FUNCTION axmr708()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(600)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    gem01     LIKE gem_file.gem01,
                    gem02     LIKE gem_file.gem02,
                    ofd23     LIKE ofd_file.ofd23,
                    gen02     LIKE gen_file.gen02,
                    ofd22     LIKE ofd_file.ofd22,
                    ofd23_no  LIKE type_file.num10,       # No.FUN-680137 INTEGER
                    ofd01     LIKE ofd_file.ofd01,
                    ofd02     LIKE ofd_file.ofd02,
                    msg       LIKE ze_file.ze03         # No.FUN-680137 VARCHAR(4) #TQC-840066
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #         LET tm.wc = tm.wc CLIPPED," AND ofduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc CLIPPED," AND ofdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofduser', 'ofdgrup')
     #End:FUN-980030
 
     LET l_sql="SELECT gem01,gem02,ofd23,gen02,ofd22,0,ofd01,ofd02,' '",
"  FROM ofd_file LEFT OUTER JOIN gen_file LEFT OUTER JOIN gem_file ON gen_file.gen03 = gem_file.gem01 ON gen_file.gen01 = ofd_file.ofd23 WHERE ",tm.wc CLIPPED 
     PREPARE axmr708_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr708_curs1 CURSOR FOR axmr708_prepare1
 
     CALL cl_outnam('axmr708') RETURNING l_name
     START REPORT axmr708_rep TO l_name
 
     LET g_pageno = 0
     FOREACH axmr708_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CASE WHEN sr.ofd22 = '0' CALL cl_getmsg('axm-450',g_lang) RETURNING sr.msg 
            WHEN sr.ofd22 = '1' CALL cl_getmsg('axm-451',g_lang) RETURNING sr.msg 
            WHEN sr.ofd22 = '2' CALL cl_getmsg('axm-452',g_lang) RETURNING sr.msg 
            WHEN sr.ofd22 = '3' CALL cl_getmsg('axm-453',g_lang) RETURNING sr.msg 
            WHEN sr.ofd22 = '4' CALL cl_getmsg('axm-454',g_lang) RETURNING sr.msg 
            OTHERWISE
       END CASE
       LET sr.msg = sr.msg CLIPPED #TQC-840066
 
       OUTPUT TO REPORT axmr708_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axmr708_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axmr708_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          l_ofd23_no   LIKE type_file.num10,       # No.FUN-680137 INTEGER
          l_str        LIKE aaf_file.aaf03,        # No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    gem01    LIKE gem_file.gem01,
                    gem02    LIKE gem_file.gem02,
                    ofd23    LIKE ofd_file.ofd23,
                    gen02    LIKE gen_file.gen02,
                    ofd22    LIKE ofd_file.ofd22,
                    ofd23_no LIKE type_file.num10,   # No.FUN-680137 INTEGER
                    ofd01    LIKE ofd_file.ofd01,
                    ofd02    LIKE ofd_file.ofd02,
                    msg      LIKE ade_file.ade04     # No.FUN-680137 VARCHAR(4)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.gem01,sr.ofd23,sr.ofd22
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.gem01
      LET l_ofd23_no = 0
      SKIP TO TOP OF PAGE
 
   BEFORE GROUP OF sr.ofd23
      PRINT COLUMN g_c[31],sr.ofd23 CLIPPED,
            COLUMN g_c[32],sr.gen02 CLIPPED;
 
   BEFORE GROUP OF sr.ofd22
      IF cl_null(sr.ofd23) THEN
         SELECT COUNT(*) INTO sr.ofd23_no FROM ofd_file
         WHERE ofd23 IS NULL AND ofd22 = sr.ofd22
      ELSE
         SELECT COUNT(*) INTO sr.ofd23_no FROM ofd_file
         WHERE ofd23 = sr.ofd23 AND ofd22 = sr.ofd22
      END IF
      LET l_str = sr.ofd22 CLIPPED,' ',sr.msg CLIPPED
      PRINT COLUMN g_c[33],l_str CLIPPED,
            COLUMN g_c[34],sr.ofd23_no USING "##############&";    #No.MOD-59000
 
   ON EVERY ROW
      PRINT COLUMN g_c[35],sr.ofd01 CLIPPED,
            COLUMN g_c[36],sr.ofd02 CLIPPED
 
   AFTER GROUP OF sr.ofd23
      LET l_ofd23_no = GROUP SUM(sr.ofd23_no) + l_ofd23_no
      PRINT
      PRINT COLUMN g_c[33],g_x[09],
            COLUMN g_c[34],GROUP SUM(sr.ofd23_no) USING "##############&"   #No.MOD-590003
 
   AFTER GROUP OF sr.gem01
      PRINT
      PRINT COLUMN g_c[33],g_x[10],
            COLUMN g_c[34],l_ofd23_no USING "##############&"   #No.MOD-590003
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED    #No.MOD-590003
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED   #No.MOD-590003
         ELSE SKIP 2 LINE
      END IF
END REPORT
