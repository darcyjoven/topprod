# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfr320.4gl
# Descriptions...: 工單退料預計表列印
# Date & Author..: 91/11/27 By Keith
# Modify.........: NO.FUN-510040 05/02/15 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0061 05/11/02 By Pengu 1.報表缺品名或規格
# Modify.........: No.TQC-5B0111 05/11/12 By Carol 單頭品名規格欄位放大,位置調整
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50156 10/05/26 By Carrier MOD-9B0174 追单
# Modify.........: No.FUN-A60027 10/06/10 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60095 10/07/28 By jan 修正FUN-A60027的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
#             wc      VARCHAR(600),       # 工單編號、型態、狀態範圍   #TQC-630166
              wc      STRING,          # 工單編號、型態、狀態範圍   #TQC-630166
                                       # WHERE CONDITION
              more    LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件(Y|N)
              END RECORD
 
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610080-begin
   #LET tm.more  = ARG_VAL(8)  
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(9)
   #LET g_rep_clas = ARG_VAL(10)
   #LET g_template = ARG_VAL(11)
   ##No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #TQC-610080-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL asfr320_tm()        # Input print condition
   ELSE
      CALL asfr320()           # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr320_tm()
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sta          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 6 LET p_col = 20
   OPEN WINDOW asfr320_w AT p_row,p_col
        WITH FORM "asf/42f/asfr320"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfb01,sfb02,sfb04
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
        EXIT WHILE
     END IF
 
     IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
     DISPLAY BY NAME tm.more      # Condition
     INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD more
           IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
              NEXT FIELD more
           END IF
           IF tm.more = "Y" THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()           # COMMAND EXECUTION
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
        EXIT WHILE
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                    WHERE zz01='asfr320'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr320','9031',1)
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
                          #" '",tm.more CLIPPED,"'",            #TQC-610080 
                           " '",g_rep_user CLIPPED,"'",         #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",         #No.FUN-570264
                           " '",g_template CLIPPED,"'"          #No.FUN-570264
 
           CALL cl_cmdat('asfr320',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asfr320_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asfr320()
     ERROR ""
   END WHILE
   CLOSE WINDOW asfr320_w
 
END FUNCTION
 
FUNCTION asfr320()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166         #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT  #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,        #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                       sfb01 LIKE sfb_file.sfb01,
                       sfb05 LIKE sfb_file.sfb05,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb18 LIKE sfb_file.sfb18,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb17 LIKE sfb_file.sfb17,
                       sfb08 LIKE sfb_file.sfb08,
                       ima55 LIKE ima_file.ima55,
                       sfa11 LIKE sfa_file.sfa11,
                       sfa26 LIKE sfa_file.sfa26,
                       sfa03 LIKE sfa_file.sfa03,
                       sfa12 LIKE sfa_file.sfa12,
                       sfa05 LIKE sfa_file.sfa05,
                       sfa06 LIKE sfa_file.sfa06,
                       sfa25 LIKE sfa_file.sfa25,
                       sfa062 LIKE sfa_file.sfa062,
                       sfa063 LIKE sfa_file.sfa062,
                       sfb09 LIKE sfb_file.sfb09,
                       sfb10 LIKE sfb_file.sfb10,
                       sfb11 LIKE sfb_file.sfb11,
                       sfb12 LIKE sfb_file.sfb12,
                       sfa161 LIKE sfa_file.sfa161
                    END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file
                  WHERE zo01 = g_rlang
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file
#                  WHERE zz01 = 'asfr320'
  #IF g_len = 0 OR g_len IS NULL THEN
#       LET g_len = 79
  #END IF
#   FOR g_i = 1 TO g_len
#       LET g_dash[g_i,g_i] = '='
#   END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
 
   LET l_sql =
               "SELECT sfb01,sfb05,sfb13,sfb18,sfb15,sfb17,sfb08,ima55,",
              #" sfa11,sfa26,sfa03,sfa12,sfa05,",          #FUN-A60027
              #" sfa06,sfa25,sfa062,sfa063,",              #FUN-A60027
               " sfa11,sfa26,sfa03,sfa12,SUM(sfa05),",     #FUN-A60027
               " SUM(sfa06),SUM(sfa25),SUM(sfa062),SUM(sfa063),",  #FUN-A60027
               " sfb09,sfb10,sfb11,sfb12,sfa161",
               " FROM sfb_file,sfa_file,ima_file",
               " WHERE sfb05 = ima01",
               " AND sfb01 = sfa01",
               " AND sfa05 > 0 AND sfb87!='X' ",
               " AND ",tm.wc CLIPPED,
               " GROUP BY sfb01,sfb05,sfb13,sfb18,sfb15,sfb17,sfb08,",   #FUN-A60027  #FUN-A60095
               "          ima55,sfa11,sfa26,sfa03,sfa12,sfb09,sfb10,",   #FUN-A60027  #FUN-A60095
               "          sfb11,sfb12,sfa161 ",                          #FUN-A60027  #FUN-A60095
               " ORDER BY 1,11 "
 
   PREPARE asfr320_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
   END IF
   DECLARE asfr320_curs1 CURSOR FOR asfr320_prepare1
 
   CALL cl_outnam('asfr320') RETURNING l_name
   START REPORT asfr320_rep TO l_name
 
   LET g_pageno = 0
   FOREACH asfr320_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0  THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      IF sr.sfa05 IS NULL THEN
         LET sr.sfa05 = 0
      END IF
      IF sr.sfa06 IS NULL THEN
         LET sr.sfa06 = 0
      END IF
      IF sr.sfa25 IS NULL THEN
         LET sr.sfa25 = 0
      END IF
      IF sr.sfa062 IS NULL THEN
         LET sr.sfa062 = 0
      END IF
      IF sr.sfb09 IS NULL THEN
         LET sr.sfb09 = 0
      END IF
      IF sr.sfb10 IS NULL THEN
         LET sr.sfb10 = 0
      END IF
      IF sr.sfb11 IS NULL THEN
         LET sr.sfb11 = 0
      END IF
      IF sr.sfb12 IS NULL THEN
         LET sr.sfb12 = 0
      END IF
      OUTPUT TO REPORT asfr320_rep(sr.*)
   END FOREACH
   FINISH REPORT asfr320_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT asfr320_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_qty     LIKE sfa_file.sfa05,
          l_back    LIKE sfa_file.sfa05,
          l_val     LIKE sfa_file.sfa05,
          l_qty1    LIKE sfa_file.sfa05,
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_pt,l_flag   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_count   LIKE type_file.num5,              #No.FUN-680121 SMALLINT
          l_mark    LIKE type_file.num5,              #No.FUN-680121 SMALLINT
          l_sfa11     STRING,
          sr        RECORD
                       sfb01 LIKE sfb_file.sfb01,
                       sfb05 LIKE sfb_file.sfb05,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb18 LIKE sfb_file.sfb18,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb17 LIKE sfb_file.sfb17,
                       sfb08 LIKE sfb_file.sfb08,
                       ima55 LIKE ima_file.ima55,
                       sfa11 LIKE sfa_file.sfa11,
                       sfa26 LIKE sfa_file.sfa26,
                       sfa03 LIKE sfa_file.sfa03,
                       sfa12 LIKE sfa_file.sfa12,
                       sfa05 LIKE sfa_file.sfa05,
                       sfa06 LIKE sfa_file.sfa06,
                       sfa25 LIKE sfa_file.sfa25,
                       sfa062 LIKE sfa_file.sfa062,
                       sfa063 LIKE sfa_file.sfa062,
                       sfb09 LIKE sfb_file.sfb09,
                       sfb10 LIKE sfb_file.sfb10,
                       sfb11 LIKE sfb_file.sfb11,
                       sfb12 LIKE sfb_file.sfb12,
                       sfa161 LIKE sfa_file.sfa161
                       END RECORD
   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line   #No.MOD-580242
 
   ORDER BY sr.sfb01
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
   #--------- No.FUN-5A0061 modify
      LET l_ima02=' '
      LET l_ima021=' '
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
             WHERE ima01=sr.sfb05
      IF SQLCA.sqlcode THEN
         LET l_ima02 = ' '
         LET l_ima021 = ' '
      END IF
#TQC-5B0111 &051112
#     PRINT g_x[10] CLIPPED,sr.sfb01,COLUMN 52,g_x[11] CLIPPED,sr.sfb13
#     PRINT g_x[14] CLIPPED,sr.sfb05,COLUMN 52,g_x[15] CLIPPED,sr.sfb18
#     PRINT g_x[19] ,l_ima02 CLIPPED,COLUMN 52,g_x[20],l_ima021 CLIPPED
#     PRINT g_x[12] CLIPPED,sr.sfb15,COLUMN 52,g_x[16] CLIPPED,sr.sfb17
 
      PRINT g_x[10] CLIPPED,sr.sfb01 CLIPPED,COLUMN 72,g_x[11] CLIPPED,sr.sfb13
      PRINT g_x[14] CLIPPED,sr.sfb05 CLIPPED,COLUMN 72,g_x[12] CLIPPED,sr.sfb15
      PRINT g_x[19] CLIPPED,l_ima02  CLIPPED,COLUMN 72,g_x[15] CLIPPED,sr.sfb18
      PRINT g_x[20] CLIPPED,l_ima021 CLIPPED,COLUMN 72,g_x[16] CLIPPED,sr.sfb17
      PRINT g_x[13] CLIPPED,sr.sfb08 USING '<<<<<<<<&.--','/',sr.ima55,
#     COLUMN 52,g_x[17] CLIPPED,sr.sfb09+sr.sfb10+sr.sfb11+sr.sfb12
      COLUMN 72,g_x[17] CLIPPED,sr.sfb09+sr.sfb10+sr.sfb11+sr.sfb12
               USING '<<<<<<<<&.--'
#TQC-5B0111 &051112  -end
   #--------end
 
      PRINT g_dash2
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINTX name=H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
      PRINT g_dash1
 
   BEFORE GROUP OF sr.sfb01
      IF  (PAGENO > 1 OR LINENO > 6)
         THEN SKIP TO TOP OF PAGE
      END IF
      LET l_qty = 0
      LET l_count = 0
      LET l_mark = 0
      LET l_pt = "N"
   ON EVERY ROW
      NEED 2 LINES
      LET l_count = l_count + 1
      LET l_mark = l_mark + 1
      LET l_val =(sr.sfb09+sr.sfb10+sr.sfb11+sr.sfb12)*sr.sfa161
      LET l_back = sr.sfa06 + sr.sfa062 -sr.sfa063 - l_val
      IF l_back < 0 THEN
         LET l_back = 0
      END IF
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.sfa03
      IF SQLCA.sqlcode THEN
         LET l_ima02 = ' '
         LET l_ima021 = ' '
      END IF
      IF l_back > 0 THEN
         IF cl_null(sr.sfa161) OR sr.sfa161=0 THEN    #Modify by Jackson
            LET sr.sfa161=1 END IF
            LET l_sfa11= sr.sfa11,'/',sr.sfa26
         PRINTX name=D1 COLUMN g_c[31],l_sfa11,
               COLUMN g_c[32],sr.sfa03,
               COLUMN g_c[33],sr.sfa12,
               COLUMN g_c[34],sr.sfa05 USING '--------&.--',
               COLUMN g_c[35],sr.sfa06 USING '--------&.--',
               COLUMN g_c[36],sr.sfa25 USING '------&.--',
               COLUMN g_c[37],sr.sfa062 USING '-------&.--'
         PRINTX name=D2 COLUMN g_c[38],' ',
               COLUMN g_c[39],l_ima02,
               COLUMN g_c[40],l_ima021,
               COLUMN g_c[41],sr.sfa05-sr.sfa06 USING '--------&.--',
              #---------------------No:TQC-A50156 modify                        
               COLUMN g_c[42],l_back USING '------&.--',                        
               COLUMN g_c[43],sr.sfa063 USING '-------&.--'                     
              #---------------------No:TQC-A50156 end 
         IF l_count = 1 THEN
            LET l_qty = l_back / sr.sfa161
            IF l_qty < 0 THEN
               LET l_qty = 0
            END IF
         END IF
         IF l_count > 1 THEN
            LET l_qty1 = l_back / sr.sfa161
            IF l_qty1 < 0 THEN
               LET l_qty1 = 0
            END IF
         END IF
         IF l_count > 1 AND l_qty > l_qty1 THEN
            LET l_qty = l_qty1
         END IF
      END IF
  AFTER GROUP OF sr.sfb01
      PRINT g_dash2
      PRINT COLUMN g_c[32],g_x[9] CLIPPED,l_qty
ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
          CALL cl_wcchp(tm.wc,'sfb01,sfb02,sfb04')
                  RETURNING tm.wc
          PRINT g_dash[1,g_len]
#TQC-630166-start
          CALL cl_prt_pos_wc(tm.wc) 
#         IF tm.wc[001,070] > ' ' THEN            # for 80
#             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#         IF tm.wc[071,140] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#         IF tm.wc[141,210] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#         IF tm.wc[211,280] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#TQC-630166-end
      END IF
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
          PRINT g_dash[1,g_len]
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 2 LINE
      END IF
END REPORT
