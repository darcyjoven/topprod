# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr370.4gl
# Descriptions...: 報價客戶成交率一覽表列印
# Date & Author..: 00/03/07 By Carol
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-890011 08/10/14 By xiaofeizhu 原抓取occ_file部份也要加判斷抓取ofd_file
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(500)             # Where condition
              bdate   LIKE type_file.dat,           #No.FUN-680137 DATE
              edate   LIKE type_file.dat,           #No.FUN-680137 DATE
              more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000     #No.FUN-680137 VARCHAR(72)
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
 
   INITIALIZE tm.* TO NULL            # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.bdate=g_today
  #LET tm.edate=g_today
  #LET tm.wc = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.bdate= ARG_VAL(8)
   LET tm.edate= ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(tm.wc)
      THEN CALL axmr370_tm(0,0)             # Input print condition
      ELSE LET tm.wc="oqt01= '",tm.wc CLIPPED,"'"
           CALL axmr370()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr370_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 15
 
   OPEN WINDOW axmr370_w AT p_row,p_col WITH FORM "axm/42f/axmr370"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bdate=g_today
   LET tm.edate=g_today
 #--------------No.TQC-610089 end
 
 
   CALL cl_opmsg('p')
WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oqt04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
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
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        #CALL cl_dynamic_locale()
         LET g_action_choice = "locale"
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW axmr370_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
           
     END IF
 
     IF tm.wc=" 1=1" THEN
        CALL cl_err('','9046',0) CONTINUE WHILE
     END IF
 
     DISPLAY BY NAME tm.bdate,tm.edate,tm.more
 
  #UI
   INPUT BY NAME tm.bdate,tm.edate,tm.more  WITHOUT DEFAULTS
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr370_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr370'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr370','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                       #------------No.TQC-610089 modify
                         " '",tm.bdate CLIPPED,"'"  ,
                         " '",tm.edate CLIPPED,"'"  ,
                       #------------No.TQC-610089 end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr370',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr370_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr370()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr370_w
END FUNCTION
 
FUNCTION axmr370()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137  VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    oqt04    LIKE oqt_file.oqt04,
                    a        LIKE type_file.num10,         #No.FUN-680137 INTEGER
                    b        LIKE type_file.num10          #No.FUN-680137 INTEGER
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oqtuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oqtgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oqtgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oqtuser', 'oqtgrup')
     #End:FUN-980030
 
     LET l_sql="SELECT UNIQUE oqt04,0,0 FROM oqt_file ",
               " WHERE oqt02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
               "   AND oqtconf = 'Y' ", #mandy01/08/06 要為已確認的報價單
               "   AND ",tm.wc CLIPPED,
               " ORDER BY 1 "
     PREPARE axmr370_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE axmr370_curs1 CURSOR FOR axmr370_prepare1
 
     CALL cl_outnam('axmr370') RETURNING l_name
     START REPORT axmr370_rep TO l_name
 
     LET g_pageno = 0
     FOREACH axmr370_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
       #---------------------------------------
       SELECT COUNT(*) INTO sr.a FROM oqt_file
          WHERE oqt04=sr.oqt04
            AND oqt02 BETWEEN tm.bdate AND tm.edate
            AND oqtconf = 'Y' #mandy 01/08/06 要已確認的資料
 
       SELECT COUNT(*) INTO sr.b FROM oea_file,oqt_file
          WHERE oea03=sr.oqt04 AND oea11='5'
            AND oea12=oqt01
            AND oeaconf = 'Y' #mandy 01/08/06 要已確認的資料
       #---------------------------------------
 
       OUTPUT TO REPORT axmr370_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axmr370_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axmr370_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,          #No.FUN-680137  VARCHAR(1)
          sr        RECORD
                    oqt04    LIKE oqt_file.oqt04,
                    a        LIKE type_file.num10,         #No.FUN-680137 INTEGER
                    b        LIKE type_file.num10          #No.FUN-680137 INTEGER
                    END RECORD,
          l_rate    LIKE oad_file.oad041,        #No.FUN-680137 DEC(6,2)
          l_occ02   LIKE occ_file.occ02
   DEFINE l_cnt     LIKE type_file.num5           #No.FUN-890011
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.oqt04
#FUN-4C0096 modify
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
     #NO.FUN-890011--Add--Begin--# 
      SELECT COUNT(*) INTO l_cnt FROM occ_file WHERE occ01=sr.oqt04              
      IF l_cnt <> 0 THEN
        SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oqt04
      ELSE
        SELECT ofd02 INTO l_occ02 FROM ofd_file WHERE ofd01=sr.oqt04
      END IF
     #NO.FUN-890011--Add--End--#                 
#     SELECT occ02 INTO l_occ02 FROM occ_file                                      #FUN-890011 Mark  
#      WHERE occ01=sr.oqt04                                                        #FUN-890011 Mark   
      IF sr.a IS NULL OR sr.a=0 THEN
         LET l_rate=0
      ELSE
         LET l_rate=sr.b/sr.a*100
      END IF
      PRINT COLUMN g_c[31],sr.oqt04 CLIPPED,
            COLUMN g_c[32],l_occ02 CLIPPED,
            COLUMN g_c[33],sr.a USING '#######&',
            COLUMN g_c[34],sr.b USING '#######&',
            COLUMN g_c[35],l_rate USING '##&.&&'
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #No.TQC-6A0091
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0091
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
