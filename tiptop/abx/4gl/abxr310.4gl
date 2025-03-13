# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr310.4gl
# Descriptions...: 內銷按月彙報報表
# Date & Author..: 96/11/20 By STAR 
# Modify.........: 05/02/24 By cate 報表標題標準化
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc     LIKE type_file.chr1000,   # Where condition            #No.FUN-680062 VARCHAR(1000) 
              more   LIKE type_file.chr1       # Input more condition(Y/N)  #No.FUN-680062 VARCHAR(1) 
              END RECORD,
          g_bxr02       LIKE bxr_file.bxr02
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   
IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL abxr310_tm(4,15)        # Input print condition
      ELSE CALL abxr310()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr310_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062  smallint
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062  VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 7 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW abxr310_w AT p_row,p_col
        WITH FORM "abx/42f/abxr310" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON bnb02,bnb04
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r310_w 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
   EXIT PROGRAM 
   END IF
IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS 
   
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
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr310'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr310','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
                     
         CALL cl_cmdat('abxr310',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr310()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr310_w
END FUNCTION
 
FUNCTION abxr310()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name   #No.FUN-680062  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT        #No.FUN-680062 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
          l_bnb14   LIKE bnb_file.bnb14,
          l_sfa03   LIKE sfa_file.sfa03,
          sr               RECORD 
                                  bxj11  LIKE bxj_file.bxj11,
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb05  LIKE bnb_file.bnb05,
                                  bnb06  LIKE bnb_file.bnb06,
                                  bnc03  LIKE bnc_file.bnc03,
                                  bnc04  LIKE bnc_file.bnc04,
                                  bnc06  LIKE bnc_file.bnc06,
                                  bnc05  LIKE bnc_file.bnc05,
                                  bnc10  LIKE bnc_file.bnc10
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ' ',bnb01,bnb04,bnb05,bnb06, ",
                 " bnc03,bnc04,bnc06,bnc05,bnc10 ",
                 "  FROM bnb_file,bnc_file ",
                 " WHERE bnb01=bnc01 ",
                 "   AND ",tm.wc CLIPPED
#No.CHI-6A0004-begin
#     SELECT azi03,azi04,azi05 
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004-end
 
     PREPARE abxr310_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr310_curs1 CURSOR FOR abxr310_prepare1
 
      CALL cl_outnam('abxr310') RETURNING l_name
 
     START REPORT abxr310_rep TO l_name
     LET g_pageno = 0
     FOREACH abxr310_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
#      IF cl_null(sr.bxj11) THEN CONTINUE FOREACH END IF
       OUTPUT TO REPORT abxr310_rep(sr.*)
     END FOREACH
 
     FINISH REPORT abxr310_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT abxr310_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
          l_flag       LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
          l_print      LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)
          l_imc03      LIKE imc_file.imc03,
          l_imc04      LIKE imc_file.imc04,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          sr               RECORD 
                                  bxj11  LIKE bxj_file.bxj11,
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb04  LIKE bnb_file.bnb04,
                                  bnb05  LIKE bnb_file.bnb05,
                                  bnb06  LIKE bnb_file.bnb06,
                                  bnc03  LIKE bnc_file.bnc03,
                                  bnc04  LIKE bnc_file.bnc04,
                                  bnc06  LIKE bnc_file.bnc06,
                                  bnc05  LIKE bnc_file.bnc05,
                                  bnc10  LIKE bnc_file.bnc10
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bnb05,sr.bnb01,sr.bnb04
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[13] clipped,sr.bxj11  #報單號碼
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_flag = 'n'
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.bnb05
      SKIP TO TOP OF PAGE 
 
   BEFORE GROUP OF sr.bnb01
      PRINT COLUMN g_c[31],sr.bnb01;
 
   BEFORE GROUP OF sr.bnb04
      PRINT COLUMN g_c[32],sr.bnb04;
 
   ON EVERY ROW
      LET l_print='N'
     #     IF l_flag != 'y' THEN 
              SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
                  WHERE ima01=sr.bnc03
              IF SQLCA.sqlcode THEN 
                  LET l_ima02 = NULL 
                  LET l_ima021 = NULL 
              END IF
 
              PRINT COLUMN g_c[33],sr.bnc03,
                    COLUMN g_c[34],l_ima02,
                    COLUMN g_c[35],l_ima021,
                    COLUMN g_c[36],cl_numfor(sr.bnc06,36,0),
                    COLUMN g_c[37],sr.bnc05,
                    COLUMN g_c[38],cl_numfor(sr.bnc10,38,0)
              LET l_flag = 'y'
     #     END IF 
     #     LET l_print='Y'
      
     #LET l_flag = 'n'
     #PRINT COLUMN 54,sr.bnc03[1,12],
     #                     sr.bnc06 USING '#####&',' ',
     #                     sr.bnc05 
     
   AFTER GROUP OF sr.bnb05
      PRINT g_dash2
      PRINT COLUMN g_c[35],g_x[20] clipped,   #合計
            COLUMN g_c[36],cl_numfor(GROUP SUM(sr.bnc06),36,0),
            COLUMN g_c[38],cl_numfor(GROUP SUM(sr.bnc10),38,0)
                                           
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
 
END REPORT
