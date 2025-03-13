# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asdr450.4gl
# Descriptions...: 單位成本表
# Date & Author..: 99/12/28 By Eric
# Modify.........: No.FUN-510037 05/01/21 By pengu 報表轉XML
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: NO.FUN-690122 06/10/13 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-850091 08/05/20 By lutingting報表轉為使用CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_tta08   LIKE tta_file.tta08,   # DECIMAL(14,2),
          g_tta09   LIKE tta_file.tta09,   #DECIMAL(14,2),
          g_tta10   LIKE tta_file.tta10,   #DECIMAL(14,2),
          g_tta11   LIKE tta_file.tta11,   #DECIMAL(14,2),
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_str           STRING            #No.FUN-850091
DEFINE   g_sql           STRING            #No.FUN-850091
DEFINE   l_table         STRING            #No.FUN-850091
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #NO.FUN-690122 by baogui
 
   #No.FUN-850091----start--
   LET g_sql = "tta02.tta_file.tta02,",
               "tta03.tta_file.tta03,",
               "tta08.tta_file.tta08,",
               "rmf351.rmf_file.rmf35,", 
               "tta09.tta_file.tta09,",
               "rmf352.rmf_file.rmf35,", 
               "tta10.tta_file.tta10,",
               "rmf353.rmf_file.rmf35,", 
               "tta11.tta_file.tta11,",
               "rmf354.rmf_file.rmf35,", 
               "l_amt.tta_file.tta08,",
               "rmf355.tta_file.tta08" 
   LET l_table = cl_prt_temptable('asdr450',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
       CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF                          
   #No.FUN-850091--end
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610079-begin
   LET tm.year= ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610079-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr450_tm(4,14)        # Input print condition
      ELSE CALL asdr450()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
END MAIN
 
FUNCTION asdr450_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 35
   OPEN WINDOW asdr450_w AT p_row,p_col
        WITH FORM "asd/42f/asdr450" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.year  = YEAR(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON tta02 
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
  
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
 
     INPUT BY NAME tm.year,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD year
           IF cl_null(tm.year) OR tm.year < 0 THEN
              NEXT FIELD year
           END IF
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
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
         WHERE zz01='asdr450'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr450','9031',1)  
           
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
                           " '",tm.year CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
  
           CALL cl_cmdat('asdr450',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asdr450_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asdr450()
     ERROR ""
   END WHILE
   CLOSE WINDOW asdr450_w
END FUNCTION
 
FUNCTION asdr450()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(400)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_ima06   LIKE type_file.chr1,         #No.FUN-690010CHAR(01),
          last_y    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          last_m    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_date    LIKE type_file.dat,          #No.FUN-690010DATE,
          l_ima73   LIKE type_file.dat,          #No.FUN-690010DATE,
          l_ima74   LIKE type_file.dat,          #No.FUN-690010DATE,
          l_cnt     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          sr RECORD LIKE tta_file.*
#No.FUN-850091---start--
   DEFINE           l_s1      LIKE rmf_file.rmf35      
   DEFINE           l_s2      LIKE rmf_file.rmf35       
   DEFINE           l_s3      LIKE rmf_file.rmf35       
   DEFINE           l_s4      LIKE rmf_file.rmf35       
   DEFINE           l_s5      LIKE tta_file.tta08
   DEFINE           l_amt     LIKE tta_file.tta08 
   
   CALL cl_del_data(l_table)
   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asdr450'
#No.FUN-850091--end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT SUM(tta08),SUM(tta09),SUM(tta10),SUM(tta11)
       INTO g_tta08,g_tta09,g_tta10,g_tta11 FROM tta_file
      WHERE tta01=tm.year
 
     LET l_sql = "SELECT * FROM tta_file ",
                 "WHERE tta01='",tm.year,"' AND ",tm.wc CLIPPED
     PREPARE asdr450_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
       EXIT PROGRAM  
          
       
     END IF
     DECLARE asdr450_curs1 CURSOR FOR asdr450_prepare1
     #CALL cl_outnam('asdr450') RETURNING l_name    #No.FUN-850091
     #START REPORT asdr450_rep TO l_name            #No.FUN-850091
     LET g_pageno = 0
     LET l_cnt=1
     FOREACH asdr450_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #No.FUN-850091---start--
       LET l_s1=(sr.tta08*100)/g_tta08
       LET l_s2=(sr.tta09*100)/g_tta09
       LET l_s3=(sr.tta10*100)/g_tta10
       LET l_s4=(sr.tta11*100)/g_tta11
       LET l_amt=(sr.tta08+sr.tta09+sr.tta10+sr.tta11)
       LET l_s5=l_amt/sr.tta03    
       EXECUTE insert_prep USING
           sr.tta02,sr.tta03,sr.tta08,l_s1,sr.tta09,l_s2,sr.tta10,l_s3,
           sr.tta11,l_s4,l_amt,l_s5   
       #OUTPUT TO REPORT asdr450_rep(sr.*)
       #No.FUN-850091---end
       LET l_cnt=l_cnt+1
     END FOREACH 
     
     #No.FUN-850091---start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'tta02')
        RETURNING tm.wc
     END IF
     
     LET g_str = tm.wc,";",tm.year,";",g_azi03,";",g_azi04
     
     CALL cl_prt_cs3('asdr450','asdr450',g_sql,g_str)
     #FINISH REPORT asdr450_rep 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-850091--end
END FUNCTION
 
#No.FUN-850091----start--
#REPORT asdr450_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
#          l_s1      LIKE rmf_file.rmf35,       #No.FUN-690010decimal(06,2) ,
#          l_s2      LIKE rmf_file.rmf35,       #No.FUN-690010decimal(06,2) ,
#          l_s3      LIKE rmf_file.rmf35,       #No.FUN-690010decimal(06,2) ,
#          l_s4      LIKE rmf_file.rmf35,       #No.FUN-690010decimal(06,2) ,
#          l_s5      LIKE tta_file.tta08,
#          l_t1      LIKE tta_file.tta03,
#          l_t2      LIKE tta_file.tta08,
#          l_t3      LIKE tta_file.tta09,
#          l_t4      LIKE tta_file.tta10,
#          l_t5      LIKE tta_file.tta11,
#          l_amt     LIKE tta_file.tta08,
#          sr RECORD LIKE tta_file.*
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.tta02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#
#      LET g_head1=g_x[10] CLIPPED,tm.year USING '&&&&'
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#            g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#            g_x[39] clipped,g_x[40] clipped,g_x[41] clipped,g_x[42] clipped
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      LET l_s1=(sr.tta08*100)/g_tta08
#      LET l_s2=(sr.tta09*100)/g_tta09
#      LET l_s3=(sr.tta10*100)/g_tta10
#      LET l_s4=(sr.tta11*100)/g_tta11
#      LET l_amt=(sr.tta08+sr.tta09+sr.tta10+sr.tta11)
#      LET l_s5=l_amt/sr.tta03
#     PRINT COLUMN g_c[31],sr.tta02,
#           COLUMN g_c[32],cl_numfor(sr.tta03,32,0), 
#           COLUMN g_c[33],cl_numfor(sr.tta08,33,g_azi03),
#           COLUMN g_c[34],l_s1 USING '---&.&&',
#           COLUMN g_c[35],cl_numfor(sr.tta09,35,g_azi03), 
#           COLUMN g_c[36],l_s2 USING '---&.&&',
#           COLUMN g_c[37],cl_numfor(sr.tta10,37,g_azi03), 
#           COLUMN g_c[38],l_s3 USING '---&.&&',
#           COLUMN g_c[39],cl_numfor(sr.tta11,39,g_azi03), 
#           COLUMN g_c[40],l_s4 USING '---&.&&',
#           COLUMN g_c[41],cl_numfor(l_amt,41,g_azi04),
#           COLUMN g_c[42],cl_numfor(l_s5,42,g_azi03) 
#
#ON LAST ROW
#      LET l_t1 = SUM(sr.tta03)
#      LET l_t2 = SUM(sr.tta08)
#      LET l_t3 = SUM(sr.tta09)
#      LET l_t4 = SUM(sr.tta10)
#      LET l_t5 = SUM(sr.tta11)
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN g_c[31],g_x[16] clipped,
#            COLUMN g_c[32],cl_numfor(l_t1,32,0), 
#            COLUMN g_c[33],cl_numfor(l_t2,33,g_azi03),
#            COLUMN g_c[35],cl_numfor(l_t3,35,g_azi03),
#            COLUMN g_c[37],cl_numfor(l_t4,37,g_azi03),
#            COLUMN g_c[39],cl_numfor(l_t5,39,g_azi03), 
#            COLUMN g_c[41],cl_numfor((l_t2+l_t3+l_t4+l_t5),41,g_azi04) 
#
#      PRINT g_dash[1,g_len] CLIPPED
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len] CLIPPED
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT 
#No.FUN-850091
#No.FUN-870144
