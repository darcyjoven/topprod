# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asdr460.4gl
# Descriptions...: 直接材料明細表
# Date & Author..: 99/12/28 By Eric
# Modify.........: FUN-510037 05/01/21 By pengu 報表轉XML
# Modify.........: FUN-530270 05/03/25 By Carol compile 有問題,報表列印加表頭
# Modify.........: FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: NO.FUN-690122 06/10/13 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-850091 08/05/22 By lutingting報表轉為使用CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds 
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              more    LIKE type_file.chr1         #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_tta     RECORD LIKE tta_file.*,
          g_ttb     RECORD LIKE ttb_file.*,
 #MOD-530270 modify
          g_tta08   LIKE tta_file.tta08,      # DECIMAL(14,2)
          g_tta09   LIKE tta_file.tta09,      # DECIMAL(14,2)
          g_tta10   LIKE tta_file.tta10,      # DECIMAL(14,2)
          g_tta11   LIKE tta_file.tta11,      # DECIMAL(14,2)
##
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_str           STRING              #No.FUN-850091
DEFINE   g_sql           STRING              #No.FUN-850091
DEFINE   l_table         STRING              #No.FUN-850091
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.year = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #NO.FUN-690122 by baogui
   
   #No.FUN-850046-------start--
   LET g_sql = "ttb02.ttb_file.ttb02,",  
               "ttb03.ttb_file.ttb03,",  
               "tta03.tta_file.tta03,",  
               "ima02.ima_file.ima02,",  
               "ima021.ima_file.ima021,",
               "ttb05.ttb_file.ttb05,",  
               "ttb08.ttb_file.ttb08,",  
               "ttb04.ttb_file.ttb04"    
   LET l_table = cl_prt_temptable('asdr460',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES (?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql   
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF          
   #No.FUN-850046--end
 
  IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL asdr460_tm(4,12)                    # Input print condition
  ELSE
     CALL asdr460()                           # Read data and create out-file
  END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
END MAIN
 
FUNCTION asdr460_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
 
   DEFINE p_row,p_col  LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 35
   OPEN WINDOW asdr460_w AT p_row,p_col WITH FORM "asd/42f/asdr460" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
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
           IF tm.year < 0 THEN
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
         WHERE zz01='asdr460'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asdr460','9031',1)   
           
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
  
           CALL cl_cmdat('asdr460',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asdr460_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asdr460()
     ERROR ""
   END WHILE
   CLOSE WINDOW asdr460_w
END FUNCTION
 
FUNCTION asdr460()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
           g_sql     string,        # RDSQL STATEMENT  #No.FUN-580092 HCN
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
  DEFINE   l_ima02   LIKE ima_file.ima02      #No.FUN-850091
  DEFINE   l_ima021  LIKE ima_file.ima021     #No.FUN-850091
 
     CALL cl_del_data(l_table)           #No.FUN-850091
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asdr460'   #No.FUN-850091     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT ttb_file.* FROM tta_file,ttb_file",
                 " WHERE tta01='",tm.year,"' ",
                 " AND tta01=ttb01 AND tta02=ttb02 AND ",tm.wc CLIPPED
 
     PREPARE asdr460_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #NO.FUN-690122 by baogui
       EXIT PROGRAM   
          
       
     END IF
     DECLARE asdr460_curs1 CURSOR FOR asdr460_prepare1
     #CALL cl_outnam('asdr460') RETURNING l_name   #No.FUN-850091
     #START REPORT asdr460_rep TO l_name      #No.FUN-850091
     LET g_pageno = 0
     FOREACH asdr460_curs1 INTO g_ttb.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       #No.FUN-850091--start--
       #-->取生產數量
       SELECT tta03 INTO g_tta.tta03 FROM tta_file 
        WHERE tta01=tm.year AND tta02=g_ttb.ttb02
        IF SQLCA.sqlcode THEN LET g_tta.tta03 = ' ' END IF       
 
       #-->取品名,規格
       SELECT ima02,ima021 INTO l_ima02,l_ima021  
         FROM ima_file WHERE ima01=g_ttb.ttb03
       IF SQLCA.sqlcode THEN
          LET l_ima02 = ' ' 
          LET l_ima021= ' '   
       END IF
       
       EXECUTE insert_prep USING
          g_ttb.ttb02,g_ttb.ttb03,g_tta.tta03,l_ima02,l_ima021,
          g_ttb.ttb05,g_ttb.ttb08,g_ttb.ttb04
       #OUTPUT TO REPORT asdr460_rep(g_ttb.*)
       #No.FUN-850091--end
     END FOREACH 
     
     #No.FUN-850091----start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'tta02')
        RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.year,";",g_azi03,";",g_azi04
     
     CALL cl_prt_cs3('asdr460','asdr460',g_sql,g_str)
     #FINISH REPORT asdr460_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-850091--end
END FUNCTION
 
#No.FUN-850091----start--
#REPORT asdr460_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
#          l_ima02   LIKE ima_file.ima02,
#          l_ima021  LIKE ima_file.ima021,   #FUN-5A0059
#          l_s1      LIKE ttb_file.ttb08 ,
#          l_s2      LIKE ttb_file.ttb08 ,
#          l_t1      LIKE ttb_file.ttb08 ,
#          sr RECORD LIKE ttb_file.*
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.ttb02,sr.ttb03
#  FORMAT
#   PAGE HEADER
##FUN-530270 add
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
###
#      LET g_head1=g_x[10] CLIPPED,tm.year USING '&&&&'
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#            g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#            g_x[39] clipped
#           ,g_x[40] clipped   #FUN-5A0059
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.ttb02  #產品分類
#      #-->取生產數量
#      SELECT tta03 INTO g_tta.tta03 FROM tta_file 
#       WHERE tta01=tm.year AND tta02=sr.ttb02
#       IF SQLCA.sqlcode THEN LET g_tta.tta03 = ' ' END IF
#      PRINT COLUMN g_c[31],sr.ttb02,
#            COLUMN g_c[32],cl_numfor(g_tta.tta03,32,0);
#
#   ON EVERY ROW
#     #-->取品名,規格
#    #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
#     SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059 
#       FROM ima_file WHERE ima01=sr.ttb03
#     IF SQLCA.sqlcode THEN
#        LET l_ima02 = ' ' 
#        LET l_ima021= ' '   #FUN-5A0059 
#     END IF
#
#     LET l_s1=sr.ttb08/sr.ttb05
#     LET l_s2=l_s1*sr.ttb04
#     PRINT COLUMN g_c[33],sr.ttb03,
#           COLUMN g_c[34],l_ima02,
#          #start FUN-5A0059
#           COLUMN g_c[35],l_ima021,
#           COLUMN g_c[36],cl_numfor(sr.ttb05,36,0),
#           COLUMN g_c[37],cl_numfor(l_s1,37,g_azi03),
#           COLUMN g_c[38],cl_numfor(sr.ttb08,38,g_azi04),
#           COLUMN g_c[39],cl_numfor(sr.ttb04,39,0), 
#           COLUMN g_c[40],cl_numfor(l_s2,40,g_azi04) 
#          #end FUN-5A0059
#
#ON LAST ROW
#      LET l_t1 = SUM(sr.ttb08)
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN g_c[32],g_x[16] clipped,
#            COLUMN g_c[38],cl_numfor(l_t1,38,g_azi04)   #FUN-5A0059 
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
#No.FUN-850091--end
#No.FUN-870144
