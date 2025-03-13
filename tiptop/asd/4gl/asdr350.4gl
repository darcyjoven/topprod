# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: asdr350.4gl
# Descriptions...: 生產量值彙總表
# Date & Author..: 99/07/07 By Eric
# Modify.........: No.FUN-510037 05/02/16 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610079 06/02/09 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
 
 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: NO.FUN-850090 08/05/20 By zhaijie老報表修改為CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改	
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(300),    # Where condition
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              type    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
              more    LIKE type_file.chr1         #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_prdate  LIKE type_file.chr1000,      #No.FUN-690010CHAR(50),
          g_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          g_month   LIKE type_file.num5          #No.FUN-690010SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
#NO.FUN-850090--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-850090--END---
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80062    ADD

#NO.FUN-850090--start--
   LET g_sql ="stn03.stn_file.stn03,",
               "q01.stn_file.stn04,",
               "a01.stn_file.stn05,",
               "q02.stn_file.stn04,",
               "a02.stn_file.stn05,",
               "q03.stn_file.stn04,",
               "a03.stn_file.stn05,",
               "q04.stn_file.stn04,",
               "a04.stn_file.stn05,",
               "q05.stn_file.stn04,",
               "a05.stn_file.stn05,",
               "q06.stn_file.stn04,",
               "a06.stn_file.stn05,",
               "q07.stn_file.stn04,",
               "a07.stn_file.stn05,",
               "q08.stn_file.stn04,",
               "a08.stn_file.stn05,",
               "q09.stn_file.stn04,",
               "a09.stn_file.stn05,",
               "q10.stn_file.stn04,",
               "a10.stn_file.stn05,",
               "q11.stn_file.stn04,",
               "a11.stn_file.stn05,",
               "q12.stn_file.stn04,",
               "a12.stn_file.stn05"
   LET l_table = cl_prt_temptable('asdr350',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF           
#NO.FUN-850090---end--
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610079-begin
   LET tm.yea = ARG_VAL(8)
   LET tm.type= ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610079-end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asdr350_tm(4,14)        # Input print condition
      ELSE CALL asdr350()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
END MAIN
 
FUNCTION asdr350_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW asdr350_w AT p_row,p_col WITH FORM "asd/42f/asdr350" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   
   LET tm.yea  = YEAR(g_today) 
   LET tm.type = '1'
   LET tm.more = 'N' 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON stn03 
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
 
     INPUT BY NAME tm.yea,tm.type,tm.more
      WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD yea
           IF tm.yea IS NULL OR tm.yea=0 THEN
              NEXT FIELD yea
           END IF
        AFTER FIELD type
           IF tm.type IS NULL OR tm.type NOT MATCHES '[123]' THEN
              NEXT FIELD type
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
         WHERE zz01='asdr350'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('asdr350','9031',1)   
          
           CONTINUE WHILE 
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
                           " '",tm.yea  CLIPPED,"'",            #TQC-610079
                           " '",tm.type CLIPPED,"'",            #TQC-610079
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
  
           CALL cl_cmdat('asdr350',g_time,l_cmd)    # Execute cmd at later time
           EXIT WHILE   
        END IF
     END IF
 
     CALL cl_wait()
     CALL asdr350()
     ERROR ""
 
   END WHILE
 
   CLOSE WINDOW asdr350_w
END FUNCTION
 
FUNCTION asdr350()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(900)
           g_sql     string,        # RDSQL STATEMENT  #No.FUN-580092 HCN
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_stv05   like stv_file.stv05 ,
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          l_i       LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_year    LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_month   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
          l_stn03   LIKE stn_file.stn03,
          l_ima131  LIKE ima_file.ima131,
          l_sta07   LIKE sta_file.sta07,
          l_stn     RECORD LIKE stn_file.*,
          sr DYNAMIC ARRAY OF RECORD 
             stn04     LIKE ccq_file.ccq03,       #No.FUN-690010decimal(13,2),       #生產數量
             stn05     LIKE ccq_file.ccq03        #No.FUN-690010decimal(13,2)        #生產成本
             END RECORD,
          ss RECORD
             stn03     LIKE stn_file.stn03,
             q01       LIKE stn_file.stn04,
             a01       LIKE stn_file.stn05,
             q02       LIKE stn_file.stn04,
             a02       LIKE stn_file.stn05,
             q03       LIKE stn_file.stn04,
             a03       LIKE stn_file.stn05,
             q04       LIKE stn_file.stn04,
             a04       LIKE stn_file.stn05,
             q05       LIKE stn_file.stn04,
             a05       LIKE stn_file.stn05,
             q06       LIKE stn_file.stn04,
             a06       LIKE stn_file.stn05,
             q07       LIKE stn_file.stn04,
             a07       LIKE stn_file.stn05,
             q08       LIKE stn_file.stn04,
             a08       LIKE stn_file.stn05,
             q09       LIKE stn_file.stn04,
             a09       LIKE stn_file.stn05,
             q10       LIKE stn_file.stn04,
             a10       LIKE stn_file.stn05,
             q11       LIKE stn_file.stn04,
             a11       LIKE stn_file.stn05,
             q12       LIKE stn_file.stn04,
             a12       LIKE stn_file.stn05
             END RECORD
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     CALL cl_del_data(l_table)                                   #NO.FUN-850090
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asdr350' #NO.FUN-850090
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT UNIQUE stn03 FROM stn_file",
                 " WHERE stn01=",tm.yea,
                 "   AND ",tm.wc CLIPPED," ORDER BY stn03"
 
     PREPARE asdr350_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
       EXIT PROGRAM   
        
     END IF
     DECLARE asdr350_curs1 CURSOR FOR asdr350_prepare1
 
#     CALL cl_outnam('asdr350') RETURNING l_name            #NO.FUN-850090
 
#     START REPORT asdr350_rep TO l_name                    #NO.FUN-850090
#     LET g_pageno = 0                                      #NO.FUN-850090
     FOREACH asdr350_curs1 INTO l_stn03
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       FOR l_i=1 to 12
           LET sr[l_i].stn04=0
           LET sr[l_i].stn05=0
       END FOR
       DECLARE r350_c2 CURSOR FOR
        SELECT * FROM stn_file WHERE stn01=tm.yea AND stn03=l_stn03
       FOREACH r350_c2 INTO l_stn.*
           LET l_i=l_stn.stn02
           #-->含重工  
           IF tm.type='1' THEN
              LET sr[l_i].stn04=l_stn.stn04
              LET sr[l_i].stn05=l_stn.stn05
           END IF
           #-->不含重工
           IF tm.type='2' THEN
              LET sr[l_i].stn04=l_stn.stn06
              LET sr[l_i].stn05=l_stn.stn07
           END IF
       END FOREACH
       LET ss.stn03=l_stn03
       LET ss.q01= sr[01].stn04 
       LET ss.a01= sr[01].stn05 
       LET ss.q02= sr[02].stn04 
       LET ss.a02= sr[02].stn05 
       LET ss.q03= sr[03].stn04 
       LET ss.a03= sr[03].stn05 
       LET ss.q04= sr[04].stn04 
       LET ss.a04= sr[04].stn05 
       LET ss.q05= sr[05].stn04 
       LET ss.a05= sr[05].stn05 
       LET ss.q06= sr[06].stn04 
       LET ss.a06= sr[06].stn05 
       LET ss.q07= sr[07].stn04 
       LET ss.a07= sr[07].stn05 
       LET ss.q08= sr[08].stn04 
       LET ss.a08= sr[08].stn05 
       LET ss.q09= sr[09].stn04 
       LET ss.a09= sr[09].stn05 
       LET ss.q10= sr[10].stn04 
       LET ss.a10= sr[10].stn05 
       LET ss.q11= sr[11].stn04 
       LET ss.a11= sr[11].stn05 
       LET ss.q12= sr[12].stn04 
       LET ss.a12= sr[12].stn05 
#       OUTPUT TO REPORT asdr350_rep(ss.*)                  #NO.FUN-850090
#NO.FUN-850090---start----
       EXECUTE insert_prep USING
         ss.stn03,ss.q01,ss.a01,ss.q02,ss.a02,ss.q03,ss.a03,ss.q04,ss.a04,
         ss.q05,ss.a05,ss.q06,ss.a06,ss.q07,ss.a07,ss.q08,ss.a08,ss.q09,
         ss.a09,ss.q10,ss.a10,ss.q11,ss.a11,ss.q12,ss.a12
#NO.FUN-850090----end---
     END FOREACH
#     FINISH REPORT asdr350_rep                             #NO.FUN-850090
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
#NO.FUN-850090--start-----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'stn03 ')
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.type,";",tm.yea,";",g_azi04,";",g_azi05
     CALL cl_prt_cs3('asdr350','asdr350',g_sql,g_str) 
#NO.FUN-850090----end----
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850090
END FUNCTION
#NO.FUN-850090
#REPORT asdr350_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#          l_stn03   LIKE stn_file.stn03,
#          l_sfb RECORD LIKE sfb_file.* ,
#          l_amtq,l_sumq LIKE stn_file.stn04,
#          l_amta,l_suma LIKE stn_file.stn05,
#          sr RECORD
#             stn03     LIKE stn_file.stn03,
#             q01       LIKE stn_file.stn04,
#             a01       LIKE stn_file.stn05,
#             q02       LIKE stn_file.stn04,
#             a02       LIKE stn_file.stn05,
#             q03       LIKE stn_file.stn04,
#             a03       LIKE stn_file.stn05,
#             q04       LIKE stn_file.stn04,
#             a04       LIKE stn_file.stn05,
#             q05       LIKE stn_file.stn04,
#             a05       LIKE stn_file.stn05,
#             q06       LIKE stn_file.stn04,
#             a06       LIKE stn_file.stn05,
#             q07       LIKE stn_file.stn04,
#             a07       LIKE stn_file.stn05,
#             q08       LIKE stn_file.stn04,
#             a08       LIKE stn_file.stn05,
#             q09       LIKE stn_file.stn04,
#             a09       LIKE stn_file.stn05,
#             q10       LIKE stn_file.stn04,
#             a10       LIKE stn_file.stn05,
#             q11       LIKE stn_file.stn04,
#             a11       LIKE stn_file.stn05,
#             q12       LIKE stn_file.stn04,
#             a12       LIKE stn_file.stn05
#             END RECORD,
#          tt RECORD
#             q01       LIKE stn_file.stn04,
#             a01       LIKE stn_file.stn05,
#             q02       LIKE stn_file.stn04,
#             a02       LIKE stn_file.stn05,
#             q03       LIKE stn_file.stn04,
#             a03       LIKE stn_file.stn05,
#             q04       LIKE stn_file.stn04,
#             a04       LIKE stn_file.stn05,
#             q05       LIKE stn_file.stn04,
#             a05       LIKE stn_file.stn05,
#             q06       LIKE stn_file.stn04,
#             a06       LIKE stn_file.stn05,
#             q07       LIKE stn_file.stn04,
#             a07       LIKE stn_file.stn05,
#             q08       LIKE stn_file.stn04,
#             a08       LIKE stn_file.stn05,
#             q09       LIKE stn_file.stn04,
#             a09       LIKE stn_file.stn05,
#             q10       LIKE stn_file.stn04,
#             a10       LIKE stn_file.stn05,
#             q11       LIKE stn_file.stn04,
#             a11       LIKE stn_file.stn05,
#             q12       LIKE stn_file.stn04,
#             a12       LIKE stn_file.stn05
#             END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY sr.stn03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      IF tm.type='1' THEN
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      ELSE
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[21]))/2)+1,g_x[21]
#      END IF
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1=g_x[10] CLIPPED,tm.yea USING '&&&&'
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped,
#            g_x[35] clipped,g_x[36] clipped,g_x[37] clipped,g_x[38] clipped,
#            g_x[39] clipped,g_x[40] clipped,g_x[41] clipped,g_x[42] clipped,
#            g_x[43] clipped,g_x[44] clipped,g_x[45] clipped
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#      LET l_amtq = sr.q01+sr.q02+sr.q03+sr.q04+sr.q05+sr.q06+
#                   sr.q07+sr.q08+sr.q09+sr.q10+sr.q11+sr.q12
#      LET l_amta = sr.a01+sr.a02+sr.a03+sr.a04+sr.a05+sr.a06+
#                   sr.a07+sr.a08+sr.a09+sr.a10+sr.a11+sr.a12 
#     PRINT COLUMN g_c[31],sr.stn03;
#     #-->列印數量
#     PRINT column g_c[32],g_x[17] clipped,
#           COLUMN g_c[33],cl_numfor(sr.q01 ,33,0),
#           COLUMN g_c[34],cl_numfor(sr.q02 ,34,0),
#           COLUMN g_c[35],cl_numfor(sr.q03 ,35,0),
#           COLUMN g_c[36],cl_numfor(sr.q04 ,36,0),
#           COLUMN g_c[37],cl_numfor(sr.q05 ,37,0),
#           COLUMN g_c[38],cl_numfor(sr.q06 ,38,0),
#           COLUMN g_c[39],cl_numfor(sr.q07 ,39,0),
#           COLUMN g_c[40],cl_numfor(sr.q08 ,40,0),
#           COLUMN g_c[41],cl_numfor(sr.q09 ,41,0),
#           COLUMN g_c[42],cl_numfor(sr.q10 ,42,0),
#           COLUMN g_c[43],cl_numfor(sr.q11 ,43,0),
#           COLUMN g_c[44],cl_numfor(sr.q12 ,44,0),
#           COLUMN g_c[45],cl_numfor(l_amtq ,45,0)
#
#     #-->列印金額
#     PRINT column g_c[32],g_x[18] clipped,
#           COLUMN g_c[33],cl_numfor(sr.a01 ,33,g_azi04),
#           COLUMN g_c[34],cl_numfor(sr.a02 ,34,g_azi04),
#           COLUMN g_c[35],cl_numfor(sr.a03 ,35,g_azi04),
#           COLUMN g_c[36],cl_numfor(sr.a04 ,36,g_azi04),
#           COLUMN g_c[37],cl_numfor(sr.a05 ,37,g_azi04),
#           COLUMN g_c[38],cl_numfor(sr.a06 ,38,g_azi04),
#           COLUMN g_c[39],cl_numfor(sr.a07 ,39,g_azi04),
#           COLUMN g_c[40],cl_numfor(sr.a08 ,40,g_azi04),
#           COLUMN g_c[41],cl_numfor(sr.a09 ,41,g_azi04),
#           COLUMN g_c[42],cl_numfor(sr.a10 ,42,g_azi04),
#           COLUMN g_c[43],cl_numfor(sr.a11 ,43,g_azi04),
#           COLUMN g_c[44],cl_numfor(sr.a12 ,44,g_azi04),
#           COLUMN g_c[45],cl_numfor(l_amta ,45,g_azi04)
#
#   ON LAST ROW
#            LET tt.q01=SUM(sr.q01) 
#            LET tt.a01=SUM(sr.a01) 
#            LET tt.q02=SUM(sr.q02) 
#            LET tt.a02=SUM(sr.a02) 
#            LET tt.q03=SUM(sr.q03) 
#            LET tt.a03=SUM(sr.a03) 
#            LET tt.q04=SUM(sr.q04) 
#            LET tt.a04=SUM(sr.a04) 
#            LET tt.q05=SUM(sr.q05) 
#            LET tt.a05=SUM(sr.a05) 
#            LET tt.q06=SUM(sr.q06) 
#            LET tt.a06=SUM(sr.a06) 
#            LET tt.q07=SUM(sr.q07) 
#            LET tt.a07=SUM(sr.a07) 
#            LET tt.q08=SUM(sr.q08) 
#            LET tt.a08=SUM(sr.a08) 
#            LET tt.q09=SUM(sr.q09) 
#            LET tt.a09=SUM(sr.a09) 
#            LET tt.q10=SUM(sr.q10) 
#            LET tt.a10=SUM(sr.a10) 
#            LET tt.q11=SUM(sr.q11) 
#            LET tt.a11=SUM(sr.a11) 
#            LET tt.q12=SUM(sr.q12) 
#            LET tt.a12=SUM(sr.a12) 
#      LET l_sumq = tt.q01+tt.q02+tt.q03+tt.q04+tt.q05+tt.q06+
#                   tt.q07+tt.q08+tt.q09+tt.q10+tt.q11+tt.q12 
#      LET l_suma = tt.a01+tt.a02+tt.a03+tt.a04+tt.a05+tt.a06+
#                   tt.a07+tt.a08+tt.a09+tt.a10+tt.a11+tt.a12 
#
#     PRINT g_dash[1,g_len]
#     PRINT COLUMN g_c[31],g_x[20] clipped, 
#           column g_c[32],g_x[17] clipped,
#           COLUMN g_c[33],cl_numfor(tt.q01 ,33,0),
#           COLUMN g_c[34],cl_numfor(tt.q02 ,34,0),
#           COLUMN g_c[35],cl_numfor(tt.q03 ,35,0),
#           COLUMN g_c[36],cl_numfor(tt.q04 ,36,0),
#           COLUMN g_c[37],cl_numfor(tt.q05 ,37,0),
#           COLUMN g_c[38],cl_numfor(tt.q06 ,38,0),
#           COLUMN g_c[39],cl_numfor(tt.q07 ,39,0),
#           COLUMN g_c[40],cl_numfor(tt.q08 ,40,0),
#           COLUMN g_c[41],cl_numfor(tt.q09 ,41,0),
#           COLUMN g_c[42],cl_numfor(tt.q10 ,42,0),
#           COLUMN g_c[43],cl_numfor(tt.q11 ,43,0),
#           COLUMN g_c[44],cl_numfor(tt.q12 ,44,0),
#           COLUMN g_c[45],cl_numfor(l_sumq ,45,0)
#
#     PRINT column g_c[32],g_x[18] clipped,
#           COLUMN g_c[33],cl_numfor(tt.a01 ,33,g_azi05),
#           COLUMN g_c[34],cl_numfor(tt.a02 ,34,g_azi05),
#           COLUMN g_c[35],cl_numfor(tt.a03 ,35,g_azi05),
#           COLUMN g_c[36],cl_numfor(tt.a04 ,36,g_azi05),
#           COLUMN g_c[37],cl_numfor(tt.a05 ,37,g_azi05),
#           COLUMN g_c[38],cl_numfor(tt.a06 ,38,g_azi05),
#           COLUMN g_c[39],cl_numfor(tt.a07 ,39,g_azi05),
#           COLUMN g_c[40],cl_numfor(tt.a08 ,40,g_azi05),
#           COLUMN g_c[41],cl_numfor(tt.a09 ,41,g_azi05),
#           COLUMN g_c[42],cl_numfor(tt.a10 ,42,g_azi05),
#           COLUMN g_c[43],cl_numfor(tt.a11 ,43,g_azi05),
#           COLUMN g_c[44],cl_numfor(tt.a12 ,44,g_azi05),
#           COLUMN g_c[45],cl_numfor(l_suma ,45,g_azi05)
#
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
#NO.FUN-850090--end--mark--
