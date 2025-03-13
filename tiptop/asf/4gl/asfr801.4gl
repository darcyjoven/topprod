# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfr801.4gl
# Desc/riptions..: 工單變更列印
# Input parameter:
# Return code....:
# Date & Author..: 2003/03/19 By Hjwang (Ref. apmr910.4gl)
# Modify.........: No.MOD-4B0278 04/11/25 By Carol 由asft801列印時應直接帶出目前的變更單據進行列印。不需讓使用者再行輸入。
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: NO.TQC-5A0038 05/10/14 By Rosayu 料件/品名/規格放大,品名規格移到下一行
# Modify.........: NO.TQC-5A0038 05/11/08 By kim 報表表頭品名往下移
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0007 06/12/11 By johnray 修改報表格式
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B70222 11/07/29 By Carrier 加入tm.a选项判断
# Modify.........: No.TQC-C70081 12/07/12 By fengrui 修正群組與使用者權限
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm        RECORD                     # Print condition RECORD
          wc        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(500)# Where condition
          a         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          b         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          more      LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
                END RECORD
 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
 DEFINE   g_snb01         LIKE snb_file.snb01   #MOD-4B0278 add
 DEFINE   g_snb02         LIKE snb_file.snb02   #MOD-4B0278 add
MAIN
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   #TQC-610080-begin
   ##MOD-4B0278 modify
   #LET g_snb01 = ARG_VAL(1)
   #LET g_snb02 = ARG_VAL(2)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(3)
   #LET g_rep_clas = ARG_VAL(4)
   #LET g_template = ARG_VAL(5)
   ##No.FUN-570264 ---end---
 
   #IF cl_null(g_snb01) THEN
   # Prog. Version..: '5.30.06-13.03.12(0,0)                 # Input print condition
   #ELSE
   #   LET tm.wc = "snb01 = '",g_snb01 CLIPPED,"' AND snb02 = ",g_snb02 CLIPPED
   #   LET tm.a = '3'
   #   LET tm.b = 'Y'
   #   LET g_rlang = g_lang
   #   CALL asfr801()                    # Read data and create out-file
   #END IF
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r801_tm(0,0)              # Input print condition
      ELSE CALL asfr801()                 # Read data and create out-file
   END IF
   #TQC-610080-end
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
# Description: 讀入批次執行條件
FUNCTION r801_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
 
    DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW r801_w AT p_row,p_col WITH FORM "asf/42f/asfr801"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_opmsg('p')
 
#   INITIALIZE tm.* TO NULL			# Default condition
    LET g_pdate   = g_today
    LET g_rlang   = g_lang
    LET g_bgjob   = 'N'
    LET g_copies  = '1'
    LET tm.a      = '1'
    LET tm.b      = 'N'
    LET tm.more   = 'N'
 
    WHILE TRUE
        CONSTRUCT BY NAME tm.wc ON snb01,snb022,snb02
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
           CLOSE WINDOW r801_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM
        END IF
 
        IF tm.wc=" 1=1 " THEN
           CALL cl_err(' ','9046',0)
           CONTINUE WHILE
        END IF
 
        # Condition
        DISPLAY BY NAME tm.a,tm.b,tm.more
 
        INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
           AFTER FIELD a
              IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL
                 THEN NEXT FIELD a
              END IF
 
           AFTER FIELD b
              IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
                 THEN NEXT FIELD b
              END IF
 
           AFTER FIELD more
              IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
                 THEN NEXT FIELD more
              END IF
              IF tm.more = 'Y' THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
              END IF
 
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
 
           ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
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
            CLOSE WINDOW r801_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
        END IF
 
        IF g_bgjob = 'Y' THEN
 
            #get exec cmd (fglgo xxxx)
            SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='asfr801'
 
            IF SQLCA.sqlcode OR l_cmd IS NULL THEN
                CALL cl_err('asfr801','9031',1)
            ELSE
                # time fglgo xxxx p1 p2 p3
                LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
 
                LET l_cmd = l_cmd CLIPPED
                           ," '",g_pdate  CLIPPED,"'"
                           ," '",g_towhom CLIPPED,"'"
                           ," '",g_lang   CLIPPED,"'"
                           ," '",g_bgjob  CLIPPED,"'"
                           ," '",g_prtway CLIPPED,"'"
                           ," '",g_copies CLIPPED,"'"
                           ," '",tm.wc    CLIPPED,"'"
                           ," '",tm.b     CLIPPED,"'"
                           ," '",tm.a     CLIPPED,"'"
                          ," '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                           " '",g_template CLIPPED,"'"            #No.FUN-570264
 
                # Execute cmd at later time
                CALL cl_cmdat('asfr801',g_time,l_cmd)
            END IF
 
            CLOSE WINDOW r801_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
        END IF
 
        CALL cl_wait()
        CALL asfr801()
        ERROR ""
 
    END WHILE
    CLOSE WINDOW r801_w
 
END FUNCTION
 
FUNCTION asfr801()
 
   DEFINE l_name	LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0090
   DEFINE l_sql 	LIKE type_file.chr1000       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
   DEFINE l_chr		LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   DEFINE l_za05	LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(40)
 
   DEFINE sr1   RECORD  LIKE snb_file.*,
          sr2   RECORD  LIKE sna_file.*,
          sr3   RECORD
          sfb02         LIKE sfb_file.sfb02,    # 工單型態
          sfb04         LIKE sfb_file.sfb04,    # 工單狀態
          sfb05         LIKE sfb_file.sfb05,    # 料件編號
          ima02         LIKE ima_file.ima02,    # 品名規格
          ima02_03b     LIKE ima_file.ima02,    # 變更前料號品名規格
          ima02_03a     LIKE ima_file.ima02     # 變更後料號品名規格
          END RECORD
 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr801'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     #只能使用自己的資料
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #         LET tm.wc = tm.wc clipped," AND pnauser = '",g_user,"'"
     #     END IF
 
     #只能使用相同群的資料
     #     IF g_priv3='4' THEN
     #         LET tm.wc = tm.wc clipped," AND pnagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pnagrup IN ",cl_chk_tgrup_list()
     #     END IF
     #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pnauser', 'pnagrup')  #TQC-C70081 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('snbuser', 'snbgrup')   #TQC-C70081 add 
     #End:FUN-980030
 
 
     LET l_sql = " SELECT snc05,snc06 FROM snc_file ",
                 "  WHERE snc01 = ? AND snc02 = ? ",
                 "  ORDER BY snc05 "
     PREPARE r801_pr2 FROM l_sql
     DECLARE r801_cs2 CURSOR FOR r801_pr2
     IF SQLCA.SQLCODE THEN
        CALL cl_err('prepare:#2',sqlca.sqlcode,1)
     END IF
 
     LET l_sql = " SELECT snb_file.*,sna_file.*,sfb02,sfb04,sfb05,ima02 ",
                  "   FROM snb_file,OUTER sna_file,sfb_file,OUTER ima_file ", #MOD-4B0278 modify
                 "  WHERE snb_file.snb01=sna_file.sna01 AND snb_file.snb02=sna_file.sna02 ",
                 "    AND snb01=sfb01 AND sfb_file.sfb05=ima_file.ima01 ",
                 "    AND ",tm.wc CLIPPED
     #No.TQC-B70222  --Begin
     IF tm.a = '1' THEN LET l_sql = l_sql CLIPPED," AND snb99 = '2'" END IF
     IF tm.a = '2' THEN LET l_sql = l_sql CLIPPED," AND (snb99<> '2' OR snb99 is null) " END IF
     #No.TQC-B70222  --End

     PREPARE r801_pr1 FROM l_sql
 
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        RETURN
     END IF
 
     DECLARE r801_cs1 CURSOR FOR r801_pr1
 
     LET l_name = 'asfr801.out'
 
     CALL cl_outnam('asfr801') RETURNING l_name
 
     START REPORT r801_rep TO l_name
 
     LET g_pageno = 0
 
     FOREACH r801_cs1 INTO sr1.*,sr2.*,sr3.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT ima02 INTO sr3.ima02_03b FROM ima_file
        WHERE sr2.sna03b=ima01
       SELECT ima02 INTO sr3.ima02_03a FROM ima_file
        WHERE sr2.sna03a=ima01
       OUTPUT TO REPORT r801_rep(sr1.*,sr2.*,sr3.*)
     END FOREACH
 
     FINISH REPORT r801_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
 
REPORT r801_rep(sr1,sr2,sr3)
   DEFINE sr1   RECORD  LIKE snb_file.*,
          sr2   RECORD  LIKE sna_file.*,
          sr3   RECORD
          sfb02         LIKE sfb_file.sfb02,    # 工單型態
          sfb04         LIKE sfb_file.sfb04,    # 工單狀態
          sfb05         LIKE sfb_file.sfb05,    # 料件編號
          ima02         LIKE ima_file.ima02,    # 品名規格
          ima02_03b     LIKE ima_file.ima02,    # 變更前料號品名規格
          ima02_03a     LIKE ima_file.ima02     # 變更後料號品名規格
          END RECORD
   DEFINE
    l_snc05  LIKE snc_file.snc05,
    l_snc06  LIKE snc_file.snc06,
    l_swich  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_str    LIKE ima_file.ima34,          #No.FUN-680121 VARCHAR(30)
    l_last_sw LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr1.snb01,sr1.snb02,sr2.sna04
 
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      #對外單據不需列印FROM
#No.TQC-6B0007 -- begin --
#      PRINT ' '
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#
#      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_today,' ',TIME,
             COLUMN (g_len-FGL_WIDTH(g_user)-15),'FROM:',g_user CLIPPED,
             COLUMN g_len-8,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED
#No.TQC-6B0007 -- end --
      PRINT g_x[11] CLIPPED,sr1.snb04,1 SPACES;
       CASE sr1.snb04
            WHEN '1' LET l_str=g_x[12] CLIPPED
            WHEN '2' LET l_str=g_x[13] CLIPPED
       END CASE
      PRINT l_str CLIPPED,
            COLUMN 35,g_x[14] CLIPPED,sr1.snb022,
            COLUMN 56,g_x[15] CLIPPED,sr1.snb02 USING '##'
#            COLUMN 88,g_x[3] CLIPPED,g_pageno USING '<<<'    #No.TQC-6B0007
      PRINT g_dash[1,g_len]
      PRINT g_x[16] CLIPPED,sr1.snb01
            #COLUMN 35,g_x[17] CLIPPED,sr3.sfb05 CLIPPED,1 SPACES,sr3.ima02 #TQC-5A0038 mark
      PRINT g_x[17] CLIPPED,sr3.sfb05 CLIPPED #TQC-5A0038 add
      PRINT g_x[62] CLIPPED,sr3.ima02  #TQC-5A0038 add
      PRINT g_x[18] CLIPPED,sr3.sfb02 USING '##',1 SPACES;
       CASE sr3.sfb02
            WHEN '1' LET l_str=g_x[20] CLIPPED
            WHEN '5' LET l_str=g_x[21] CLIPPED
            WHEN '7' LET l_str=g_x[22] CLIPPED
            WHEN '8' LET l_str=g_x[23] CLIPPED
            WHEN '11' LET l_str=g_x[24] CLIPPED
            WHEN '13' LET l_str=g_x[25] CLIPPED
            WHEN '15' LET l_str=g_x[26] CLIPPED
       END CASE
      PRINT l_str CLIPPED,
            COLUMN 35,g_x[19] CLIPPED,sr3.sfb04,1 SPACES;
       CASE sr3.sfb04
            WHEN '1' LET l_str=g_x[27] CLIPPED
            WHEN '2' LET l_str=g_x[28] CLIPPED
            WHEN '3' LET l_str=g_x[29] CLIPPED
            WHEN '4' LET l_str=g_x[30] CLIPPED
            WHEN '5' LET l_str=g_x[31] CLIPPED
            WHEN '6' LET l_str=g_x[32] CLIPPED
            WHEN '7' LET l_str=g_x[33] CLIPPED
            WHEN '8' LET l_str=g_x[34] CLIPPED
       END CASE
      PRINT l_str CLIPPED
      PRINT ' '
   IF sr1.snb04='2' THEN
      SKIP 5 LINES
   ELSE
      PRINT g_x[35] CLIPPED,cl_numfor(sr1.snb08b,14,3),
            COLUMN 35,g_x[36] CLIPPED,sr1.snb13b,
            COLUMN 56,g_x[37] CLIPPED,sr1.snb15b
      PRINT g_x[38] CLIPPED,
            COLUMN 17,cl_numfor(sr1.snb08a,14,3) CLIPPED,
            COLUMN 44,sr1.snb13a,
            COLUMN 65,sr1.snb15a
      PRINT ' '
      PRINT g_x[39] CLIPPED,
            COLUMN 22,sr1.snb82b,
            COLUMN 35,g_x[40] CLIPPED,sr1.snb98b
      PRINT g_x[38] CLIPPED,
            COLUMN 22,sr1.snb82a,
            COLUMN 44,sr1.snb98a
   END IF
      PRINT g_x[53] CLIPPED,g_x[53] CLIPPED,g_x[61] CLIPPED
 
   IF sr1.snb04='1' AND (sr2.sna10!='4' OR (sr2.sna10='4' AND tm.b='N'))  THEN
      SKIP 2LINE
   ELSE
      PRINT g_x[41],g_x[42],g_x[58] CLIPPED
      PRINT g_x[43],g_x[44],g_x[59] CLIPPED
   END IF
   LET l_last_sw = 'n'           #FUN-550124
 
BEFORE GROUP OF sr1.snb01
   IF PAGENO > 1 OR LINENO > 9 THEN
      SKIP TO TOP OF PAGE
   END IF
BEFORE GROUP OF sr1.snb02
   IF PAGENO > 1 OR LINENO > 9 THEN
      SKIP TO TOP OF PAGE
   END IF
ON EVERY ROW
   IF sr1.snb04='1' AND (sr2.sna10!='4' OR (sr2.sna10='4' AND tm.b='N'))  THEN
      SKIP 9 LINE
   ELSE
      PRINT g_x[45],g_x[46],g_x[60] CLIPPED
      PRINT COLUMN 03,sr2.sna04 USING '###',
            COLUMN 10,g_x[47] CLIPPED,sr2.sna10,1 SPACES;
       CASE sr2.sna10
            WHEN '1' LET l_str=g_x[54] CLIPPED
            WHEN '2' LET l_str=g_x[55] CLIPPED
            WHEN '3' LET l_str=g_x[56] CLIPPED
            WHEN '4' LET l_str=g_x[57] CLIPPED
       END CASE
      PRINT l_str CLIPPED,
            COLUMN 47,g_x[48] CLIPPED,sr2.sna50
      PRINT COLUMN 03,g_x[49] CLIPPED,sr2.sna03b,
            COLUMN 31,sr2.sna08b,
            COLUMN 44,sr2.sna12b,
            COLUMN 49,sr2.sna26b,
            COLUMN 58,cl_numfor(sr2.sna28b,5,3),
            COLUMN 65,cl_numfor(sr2.sna05b,14,3),
            COLUMN 81,cl_numfor(sr2.sna06b,14,3)
      PRINT COLUMN 10,sr2.sna27b,
            COLUMN 39,sr2.sna11b,
            COLUMN 41,cl_numfor(sr2.sna100b,5,3),
            COLUMN 49,cl_numfor(sr2.sna161b,14,3),
            COLUMN 65,cl_numfor(sr2.sna062b,14,3),
            COLUMN 81,cl_numfor(sr2.sna07b,14,3)
      PRINT COLUMN 10,sr3.ima02_03b
      PRINT COLUMN 03,g_x[50] CLIPPED,sr2.sna03a,
            COLUMN 31,sr2.sna08a,
            COLUMN 44,sr2.sna12a,
            COLUMN 49,sr2.sna26a,
            COLUMN 58,cl_numfor(sr2.sna28a,5,3),
            COLUMN 65,cl_numfor(sr2.sna05a,14,3),
            COLUMN 81,cl_numfor(sr2.sna06a,14,3)
      PRINT COLUMN 10,sr2.sna27a,
            COLUMN 39,sr2.sna11a,
            COLUMN 41,cl_numfor(sr2.sna100a,5,3),
            COLUMN 49,cl_numfor(sr2.sna161a,14,3),
            COLUMN 65,cl_numfor(sr2.sna062a,14,3),
            COLUMN 81,cl_numfor(sr2.sna07a,14,3)
      PRINT COLUMN 10,sr3.ima02_03a
   END IF
 
AFTER GROUP OF sr1.snb02
   LET l_swich=1
   LET l_snc05=0
   LET l_snc06=' '
   SKIP 1 LINE
   FOREACH r801_cs2 USING sr1.snb01,sr1.snb02
     INTO l_snc05,l_snc06
     IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
     IF l_swich=1 THEN
        PRINT COLUMN 03,g_x[22] CLIPPED;
     END IF
     PRINT COLUMN 08,l_snc06
     LET l_swich=l_swich+1
   END FOREACH
 
## FUN-550124
ON LAST ROW
      LET l_last_sw = 'y'
 
PAGE TRAILER
        PRINT g_dash[1,g_len]
      #  PRINT COLUMN 02,g_x[51] CLIPPED,
      #        COLUMN 41,g_x[52] CLIPPED
#No.TQC-6B0007 -- begin --                                                      
      IF l_last_sw = 'n'                                                        
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED     
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED     
      END IF                                                                    
#No.TQC-6B0007 -- end --
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[51]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[51]
             PRINT g_memo
      END IF
## END FUN-550124
 
END REPORT
 
#Patch....NO.TQC-610037 <001> #
