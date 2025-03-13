# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: anmr110.4gl
# Descriptions...: 應付票據作廢/撤票/退票明細表
# Input parameter:
# Return code....:
# Date & Author..: 00/06/22  By  Brendan
# Modify.........: No.FUN-4C0098 04/12/24 By pengu 報表轉XML
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6C0174 06/12/28 By Rayven 報表格式調整
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0010 09/11/02 By wujie 5.2SQL标准语法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING, #TQC-630166
              wc1     STRING, #TQC-630166
              type    LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
              bdate   LIKE type_file.dat,      #No.FUN-680107 DATE
              edate   LIKE type_file.dat,      #No.FUN-680107 DATE
              more    LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
              END RECORD
   DEFINE g_counter   LIKE type_file.num10     #No.FUN-680107 INTEGER
 
DEFINE   g_i        LIKE type_file.num5        #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.wc1   = ARG_VAL(8)   #TQC-610058
   LET tm.bdate = ARG_VAL(9)   #TQC-610058
   LET tm.edate = ARG_VAL(10)   #TQC-610058
   LET tm.type  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r110_tm(0,0)           # Input print condition
      ELSE CALL r110()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r110_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_cmd        LIKE type_file.chr1000       #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r110_w AT p_row,p_col
        WITH FORM "anm/42f/anmr110"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate =g_today
   LET tm.edate =g_today
   LET tm.type    = '4'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
#No.+119 010514 by linda
#   CONSTRUCT BY NAME tm.wc ON nmd03,nmd07,nmd06,nmd08
   CONSTRUCT BY NAME tm.wc ON nmd03
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
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
		
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   CONSTRUCT BY NAME tm.wc1 ON nmd07,nmd06,nmd08
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
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
		
#No.+119 ..end
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r110_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' AND tm.wc1=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.more
                 WITHOUT DEFAULTS
      AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
               CALL cl_err(0,'anm-003',0)
               NEXT FIELD bdate
            END IF
            IF NOT cl_null(tm.edate) THEN
            IF tm.bdate > tm.edate THEN      #截止日期不可小於起始日期
               CALL cl_err(0,'anm-091',0)
               LET tm.bdate = g_today
               LET tm.edate = g_today
               DISPLAY BY NAME tm.bdate, tm.edate
               NEXT FIELD bdate
            END IF
            END IF
 
      AFTER FIELD edate
            IF cl_null(tm.edate) THEN
               CALL cl_err(0,'anm-003',0)
               NEXT FIELD edate
            END IF
            IF tm.bdate > tm.edate THEN      #截止日期不可小於起始日期
               CALL cl_err(0,'anm-091',0)
               LET tm.bdate = g_today
               LET tm.edate = g_today
               DISPLAY BY NAME tm.bdate, tm.edate
               NEXT FIELD bdate
            END IF
 
      AFTER FIELD type
         IF cl_null(tm.type) AND tm.type NOT MATCHES '[1234]' THEN
            NEXT FIELD type
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#     ON ACTION CONTROLP CALL r110_wc()   # Input detail Where Condition
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr110 '
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr110 ','9031',1)
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
                         " '",tm.wc1 CLIPPED,"'",   #TQC-610058
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr110 ',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r110_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r110()
   ERROR ""
END WHILE
   CLOSE WINDOW r110_w
END FUNCTION
 
FUNCTION r110()
   DEFINE l_name    LIKE type_file.chr20         #No.FUN-680107 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0082
   DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(1400)
   DEFINE l_za05    LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(40)
   DEFINE l_nmd12   LIKE nmd_file.nmd12          #No.FUN-680107 VARCHAR(30)
   DEFINE l_wc      LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(300)
   DEFINE    sr            RECORD
                                  nmd03 LIKE nmd_file.nmd03, #銀行別
                                  nmd02 LIKE nmd_file.nmd02, #票據編號
                                  nma02 LIKE nma_file.nma02, #銀行簡稱
                                  nmo02 LIKE nmo_file.nmo02, #票別說明
                                  nmd13 LIKE nmd_file.nmd13, #異動日期
                                  nmd08 LIKE nmd_file.nmd08, #廠商編號
                                  nmd24 LIKE nmd_file.nmd24, #廠商簡稱
                                  nmd12 LIKE nmd_file.nmd12, #異動情況
                                  count LIKE type_file.num5  #No.FUN-680107 SMALLINT
                           END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc1 = tm.wc1 clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc1 = tm.wc1 clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc1 = tm.wc1 clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
 
     CASE tm.type
       WHEN '1' LET l_nmd12 = '9'
       WHEN '2' LET l_nmd12 = '6'
       WHEN '3' LET l_nmd12 = '7'
       WHEN '4' LET l_nmd12 = '679'
     END CASE
 
     IF tm.type = '2' OR tm.type = '3' THEN
         LET l_sql = "SELECT nmd03, nmd02, nma02, nmo02,",
                     " nmd13, nmd08, nmd24, nmd12,0 ",
                     "  FROM nmd_file,",
                     " nma_file,nmo_file",
                     " WHERE nmd03 = nma01 ", 
                     "   AND nmd06 = nmo01 ",
                     "   AND nmd30 <> 'X' ",
                     "   AND nmd12 IN ",cl_parse(l_nmd12 CLIPPED),
                     "   AND nmd13 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                     "   AND ", tm.wc CLIPPED,
                     "   AND ", tm.wc1 CLIPPED,  #No.+119 010514
                     " ORDER BY 1, 2"
     ELSE
       LET l_wc = tm.wc
       FOR g_i = 1 to length(l_wc)
           IF l_wc[g_i,g_i+4] = 'nmd03' THEN
              LET l_wc[g_i,g_i+4] = 'nnz01'
              EXIT FOR
           END IF
       END FOR
#      LET l_sql = "SELECT nmd03, nmd02, nma02, nmo02, nmd13, ",
       LET l_sql = "SELECT nmd03 nmd03, nmd02 nmd02, nma02 nma02, nmo02 nmo02, nmd13 nmd13, ",  #No.FUN-9B0010
               " nmd08 nmd08, nmd24 nmd24, nmd12 nmd12,0 ",
               "  FROM nmd_file ",
               "  LEFT OUTER JOIN nma_file ON nmd03=nma01,nmo_file",
               " WHERE nmd06 = nmo_file.nmo01 ",
               "   AND nmd30 <> 'X' ",
               "   AND nmd12 IN ",cl_parse(l_nmd12 CLIPPED),
               "   AND nmd13 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
               "   AND ", tm.wc CLIPPED,
               "   AND ", tm.wc1 CLIPPED,
               " UNION ",
               "SELECT nnz01, nnz02, nma02,'',nnzdate, '', '', ' ',0 ",
               "  FROM nnz_file LEFT OUTER JOIN nma_file ON nnz01=nma01 ",
               " WHERE ",
                   "  nnz02 NOT IN ",
                   "  ( SELECT nmd02 FROM nmd_file WHERE nmd12 = '9' ) ",
                   "   AND nnzdate BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                   "   AND ", l_wc CLIPPED,
#                  " ORDER BY 1, 2"
                   " ORDER BY nmd03,nmd02"    #No.FUN-9B0010
     END IF
     PREPARE r110_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r110_curs1 CURSOR FOR r110_prepare1
 
#    LET l_name = 'anmr110 .out'
     CALL cl_outnam('anmr110') RETURNING l_name
     START REPORT r110_rep TO l_name
     LET g_pageno = 0
     LET g_counter = 0
     FOREACH r110_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          LET sr.count = 1
          OUTPUT TO REPORT r110_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r110_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r110_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   DEFINE l_cnt         LIKE type_file.chr20    #No.FUN-680107 VARCHAR(10)
   DEFINE l_count       ARRAY[04] OF LIKE type_file.num5     #No.FUN-680107 ARRAY[04] OF LIKE SMALLINT
   DEFINE l_column      LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE    sr            RECORD
                                  nmd03 LIKE nmd_file.nmd03, #銀行別
                                  nmd02 LIKE nmd_file.nmd02, #票據編號
                                  nma02 LIKE nma_file.nma02, #銀行簡稱
                                  nmo02 LIKE nmo_file.nmo02, #票別說明
                                  nmd13 LIKE nmd_file.nmd13, #異動日期
                                  nmd08 LIKE nmd_file.nmd08, #廠商編號
                                  nmd24 LIKE nmd_file.nmd24, #廠商簡稱
                                  nmd12 LIKE nmd_file.nmd12, #異動情況
                                  count LIKE type_file.num5  #No.FUN-680107 SMALLINT
                           END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.nmd03, sr.nmd02  #銀行別, 票號
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      IF tm.type=1 THEN
         LET g_i = tm.type
      ELSE
         LET g_i=tm.type+2
      END IF
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[g_i]
      PRINT g_head CLIPPED,pageno_total
      LET g_head1= g_x[7] CLIPPED, tm.bdate,'-',tm.edate
      #PRINT g_head1                        #FUN-660060 remark
      PRINT COLUMN ((g_len-FGL_WIDTH(g_head1)-10))/2+1, g_head1  #FUN-660060
      PRINT g_dash[1,g_len] CLIPPED
      PRINT ''
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nmd03
#      IF tm.d = 'Y' AND (PAGENO > 1 OR LINENO >9 )THEN
#         SKIP TO TOP OF PAGE
#      END IF
      LET g_counter = g_counter + 1
      IF g_counter != 1 THEN
      END IF
      PRINT COLUMN g_c[31],sr.nmd03;
 
   ON EVERY ROW
      PRINT COLUMN g_c[32], sr.nma02,
            COLUMN g_c[33], sr.nmo02,
            COLUMN g_c[34], sr.nmd02,
            COLUMN g_c[35], sr.nmd13,
            COLUMN g_c[36], sr.nmd08,
            COLUMN g_c[37], sr.nmd24
 
   AFTER GROUP OF sr.nmd03
      PRINT ''
      PRINT COLUMN g_c[31], g_x[16] CLIPPED;
      LET l_count[1] = GROUP SUM(sr.count) WHERE sr.nmd12 = '9'
      LET l_count[2] = GROUP SUM(sr.count) WHERE sr.nmd12 = '6'
      LET l_count[3] = GROUP SUM(sr.count) WHERE sr.nmd12 = '7'
      LET l_count[4] = GROUP SUM(sr.count) WHERE sr.nmd12 = ' '
      FOR g_i = 1 TO 4
          IF l_count[g_i] IS NULL THEN LET l_count[g_i] = 0 END IF
      END FOR
      LET l_column = 14
      IF tm.type = '2' OR tm.type = '4' THEN
         LET l_cnt=l_count[2] USING '###&',g_x[22] CLIPPED
         PRINT COLUMN g_c[32],g_x[18] CLIPPED,
               COLUMN g_c[33],l_cnt
      END IF
      IF tm.type = '1' OR tm.type = '4' THEN
         IF tm.type = '4' THEN LET l_column = 29 END IF
            LET l_cnt=l_count[1] USING '###&',g_x[22] CLIPPED
            PRINT COLUMN g_c[32],g_x[19] CLIPPED,
                  COLUMN g_c[33],l_cnt
              LET l_cnt=l_count[4] USING '###&',g_x[22] CLIPPED
              PRINT COLUMN g_c[32],g_x[20] CLIPPED,
                    COLUMN g_c[33],l_cnt
      END IF
      IF tm.type = '3' OR tm.type = '4' THEN
         IF tm.type = '4' THEN LET l_column = 67 END IF
            LET l_cnt=l_count[3] USING '###&',g_x[22] CLIPPED
            PRINT COLUMN g_c[32],g_x[21] CLIPPED,
                  COLUMN g_c[33],l_cnt
      END IF
      PRINT g_dash1
      PRINT ''
 
   ON LAST ROW
      #PRINT g_dash_1[1,g_len]
      # PRINT g_dash1
      PRINT g_x[17] CLIPPED;
      LET l_count[1] = SUM(sr.count) WHERE sr.nmd12 = '9'
      LET l_count[2] = SUM(sr.count) WHERE sr.nmd12 = '6'
      LET l_count[3] = SUM(sr.count) WHERE sr.nmd12 = '7'
      LET l_count[4] = SUM(sr.count) WHERE sr.nmd12 = ' '
      FOR g_i = 1 TO 4
          IF l_count[g_i] IS NULL THEN LET l_count[g_i] = 0 END IF
      END FOR
      LET l_column = 14
      IF tm.type = '2' OR tm.type = '4' THEN
         LET l_cnt=l_count[2] USING '###&',g_x[22] CLIPPED
         PRINT COLUMN g_c[32],g_x[18] CLIPPED,
               COLUMN g_c[33],l_cnt
      END IF
      IF tm.type = '1' OR tm.type = '4' THEN
         IF tm.type = '4' THEN LET l_column = 29 END IF
            LET l_cnt=l_count[1] USING '###&',g_x[22] CLIPPED
            PRINT COLUMN g_c[32],g_x[19] CLIPPED,
                  COLUMN g_c[33],l_cnt
              LET l_cnt=l_count[4] USING '###&',g_x[22] CLIPPED
              PRINT COLUMN g_c[32],g_x[20] CLIPPED,
                    COLUMN g_c[33],l_cnt
      END IF
      IF tm.type = '3' OR tm.type = '4' THEN
         IF tm.type = '4' THEN LET l_column = 67 END IF
            LET l_cnt=l_count[3] USING '###&',g_x[22] CLIPPED
            PRINT COLUMN g_c[32],g_x[21] CLIPPED,
                  COLUMN g_c[33],l_cnt
      END IF
      PRINT ''
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280 / (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len] CLIPPED
         #TQC-630166 Start
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        #     IF tm.wc[001,120] > ' ' THEN            # for 132
#        #PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#        #     IF tm.wc[121,240] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#        #     IF tm.wc[241,300] > ' ' THEN
#        #PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         
         CALL cl_prt_pos_wc(tm.wc)
         ##TQC-630166 End
      END IF
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[8] CLIPPED,g_x[9] CLIPPED, COLUMN(g_len-9), g_x[11] CLIPPED  #No.TQC-6C0174
      PRINT #No.TQC-6C0174
      LET l_last_sw = 'y'
      PRINT g_x[13] CLIPPED,
            COLUMN 32, g_x[14] CLIPPED,
            COLUMN 58, g_x[15] CLIPPED
 
    PAGE TRAILER
       IF l_last_sw = 'n'
          THEN PRINT g_dash[1,g_len] CLIPPED
               PRINT g_x[8] CLIPPED,g_x[9] CLIPPED, COLUMN(g_len-9), g_x[10] CLIPPED  #No.TQC-6C0174
               PRINT #No.TQC-6C0174
               PRINT g_x[13] CLIPPED,
                     COLUMN 32, g_x[14] CLIPPED,
                     COLUMN 58, g_x[15] CLIPPED
#         ELSE SKIP 2 LINE  #No.TQC-6C0174 mark
          ELSE SKIP 4 LINE  #No.TQC-6C0174
       END IF
END REPORT
