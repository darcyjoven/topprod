# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfr820.4gl
# Descriptions...: Run Card品質異常報告表
# Date & Author..: 00/08/21 By Mandy
#
# Modify.........: NO.FUN-550067 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-550124 05/05/30 By echo   新增報表備註
# Modify.........: NO.TQC-5A0038 05/10/14 By Rosayu 1.料號放大 2.機台編號,型態移到品名規格下
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                # Print condition RECORD
              wc       STRING,                      # Where condition  #NO.TQC-630166 
#              wc      VARCHAR(600),                   # Where condition
              more     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件?
              END RECORD,
          g_dash1_1    LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
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
  #LET tm.more  = ARG_VAL(8)   #TQC-610080 以下順序調整
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL asfr820_tm(0,0)        # Input print condition
      ELSE CALL asfr820()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr820_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN
      LET p_row = 5 LET p_col = 12
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW asfr820_w AT p_row,p_col WITH FORM "asf/42f/asfr820"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shh01,shh02,shh031,shh03
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
      CLOSE WINDOW asfr820_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
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
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = "Y" THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG
             CALL cl_cmdask()    # Command execution
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
      CLOSE WINDOW asfr820_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr820'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr820','9031',1)
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
                        #" '",tm.more CLIPPED,"'",              #TQC-610080
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('asfr820',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW asfr820_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr820()
   ERROR ""
END WHILE
CLOSE WINDOW asfr820_w
END FUNCTION
 
FUNCTION asfr820()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,        #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                       shh01  LIKE shh_file.shh01,
                       shh02  LIKE shh_file.shh02,
                       shh021 LIKE shh_file.shh021,
                       shh022 LIKE shh_file.shh022,
                       shh031 LIKE shh_file.shh031,
                       shh03  LIKE shh_file.shh03,
                       shh04  LIKE shh_file.shh04,
                       sfb05  LIKE sfb_file.sfb05,
                       shh05  LIKE shh_file.shh05,
                       ima02  LIKE ima_file.ima02,
                       ima021 LIKE ima_file.ima021,
                       shh06  LIKE shh_file.shh06,
                       shh07  LIKE shh_file.shh07,
                       shh111 LIKE shh_file.shh111,
                       shh112 LIKE shh_file.shh112,
                       shh113 LIKE shh_file.shh113,
                       shh131 LIKE shh_file.shh131,
                       shh132 LIKE shh_file.shh132,
                       shh142 LIKE shh_file.shh142,
                       shh143 LIKE shh_file.shh143,
                       shh151 LIKE shh_file.shh151,
                       shh152 LIKE shh_file.shh152,
                       shh161 LIKE shh_file.shh161,
                       shh162 LIKE shh_file.shh162,
                       shh163 LIKE shh_file.shh163,
                       shh164 LIKE shh_file.shh164,
                       shh165 LIKE shh_file.shh165,
                       shh171 LIKE shh_file.shh171,
                       shh172 LIKE shh_file.shh172,
                       shh173 LIKE shh_file.shh173,
                       shh174 LIKE shh_file.shh174,
                       shh175 LIKE shh_file.shh175,
                       shh101 LIKE shh_file.shh101,
                       shh10  LIKE shh_file.shh10 ,
                       shh121 LIKE shh_file.shh121,
                       shh12  LIKE shh_file.shh12,
                       shh141 LIKE shh_file.shh141,
                       shh14  LIKE shh_file.shh14,
                       shh08  LIKE shh_file.shh08
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file
               WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file
                   WHERE zz01 = 'asfr820'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     FOR g_i = 1 TO g_len LET g_dash1_1[g_i,g_i] = '-' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND shhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND shhgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND shhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shhuser', 'shhgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT shh01, shh02, shh021, shh022, shh031,shh03 , shh04, sfb05, ",
                 "       shh05, ima02, ima021, shh06 , shh07 ,shh111,shh112,",
                 "      shh113, shh131,shh132, shh142, shh143,shh151,shh152,",
                 "      shh161, shh162,shh163, shh164, shh165,shh171,shh172,",
                 "      shh173, shh174, shh175,shh101, shh10 ,shh121,shh12 ,",
                 "      shh141, shh14 , shh08 ",
                 "  FROM shh_file,sfb_file, OUTER ima_file ",
                 " WHERE shh01 = shh01",
                 "   AND sfb01 = shh03",
                 "   AND shh031 IS NOT NULL AND shh031 <> ' '",
                 "   AND sfb_file.sfb05 = ima_file.ima01 AND shh14!='X' ",
                 "   AND ",tm.wc CLIPPED," ORDER BY shh01"
     PREPARE asfr820_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
     END IF
     DECLARE asfr820_curs1 CURSOR FOR asfr820_prepare1
 
     CALL cl_outnam('asfr820') RETURNING l_name
     START REPORT asfr820_rep TO l_name
 
     LET g_pageno = 0
     FOREACH asfr820_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0  THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       OUTPUT TO REPORT asfr820_rep(sr.*)
     END FOREACH
 
     FINISH REPORT asfr820_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT asfr820_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          exhaust      LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
          l_sfe06      LIKE sfe_file.sfe06,
          l_sfe16      LIKE sfe_file.sfe16,
          sr           RECORD
                       shh01  LIKE shh_file.shh01,
                       shh02  LIKE shh_file.shh02,
                       shh021 LIKE shh_file.shh021,
                       shh022 LIKE shh_file.shh022,
                       shh031 LIKE shh_file.shh031,
                       shh03  LIKE shh_file.shh03,
                       shh04  LIKE shh_file.shh04,
                       sfb05  LIKE sfb_file.sfb05,
                       shh05  LIKE shh_file.shh05,
                       ima02  LIKE ima_file.ima02,
                       ima021 LIKE ima_file.ima021,
                       shh06  LIKE shh_file.shh06,
                       shh07  LIKE shh_file.shh07,
                       shh111 LIKE shh_file.shh111,
                       shh112 LIKE shh_file.shh112,
                       shh113 LIKE shh_file.shh113,
                       shh131 LIKE shh_file.shh131,
                       shh132 LIKE shh_file.shh132,
                       shh142 LIKE shh_file.shh142,
                       shh143 LIKE shh_file.shh143,
                       shh151 LIKE shh_file.shh151,
                       shh152 LIKE shh_file.shh152,
                       shh161 LIKE shh_file.shh161,
                       shh162 LIKE shh_file.shh162,
                       shh163 LIKE shh_file.shh163,
                       shh164 LIKE shh_file.shh164,
                       shh165 LIKE shh_file.shh165,
                       shh171 LIKE shh_file.shh171,
                       shh172 LIKE shh_file.shh172,
                       shh173 LIKE shh_file.shh173,
                       shh174 LIKE shh_file.shh174,
                       shh175 LIKE shh_file.shh175,
                       shh101 LIKE shh_file.shh101,
                       shh10  LIKE shh_file.shh10 ,
                       shh121 LIKE shh_file.shh121,
                       shh12  LIKE shh_file.shh12,
                       shh141 LIKE shh_file.shh141,
                       shh14  LIKE shh_file.shh14,
                       shh08  LIKE shh_file.shh08
                       END RECORD
  DEFINE l_gen02_1  LIKE gen_file.gen02
  DEFINE l_gen02_2  LIKE gen_file.gen02
  DEFINE l_gen02_3  LIKE gen_file.gen02
  DEFINE l_gem02_1  LIKE gem_file.gem02
  DEFINE l_gem02_2  LIKE gem_file.gem02
  DEFINE l_ecd02    LIKE ecd_file.ecd02
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.shh01
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF cl_null(g_towhom) THEN
          PRINT '';
      ELSE
          PRINT 'TO:',g_towhom;
      END IF
 
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      #PRINT g_x[2] CLIPPED,g_pdate USING "yy/mm/dd",' ',TIME, #FUN-570250 mark
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME, #FUN-570250 add
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.shh01
      SKIP TO TOP OF PAGE
      SELECT ecd02 INTO l_ecd02 FROM ecd_file WHERE ecd01=sr.shh05
#No.FUN-550067 --start--
      PRINT g_x[11] CLIPPED, sr.shh01 ,COLUMN 27,g_x[12] CLIPPED, sr.shh02 ,
            #COLUMN 47,g_x[13] CLIPPED, sr.shh021, #TQC-5A0038 mark
            COLUMN 50,g_x[13] CLIPPED, sr.shh021,  #TQC-5A0038 add
            #COLUMN 66,g_x[14] CLIPPED, sr.shh022  #TQC-5A0038 mark
            COLUMN 69,g_x[14] CLIPPED, sr.shh022   #TQC-5A0038 add
      PRINT g_x[15] CLIPPED, sr.shh03 CLIPPED, COLUMN 27,g_x[16] CLIPPED, sr.shh04 CLIPPED, #TQC-5A0038 mark
            #COLUMN 47,g_x[17] CLIPPED, sr.shh05,' ',l_ecd02 #TQC-5A0038 mark
            COLUMN 50,g_x[17] CLIPPED, sr.shh05,' ',l_ecd02  #TQC-5A0038 add
      PRINT g_x[38] CLIPPED, sr.shh031
      #PRINT g_x[18] CLIPPED, sr.sfb05 CLIPPED, COLUMN 47,g_x[19] CLIPPED, sr.shh06 #TQC-5A0038 mark
      PRINT g_x[18] CLIPPED, sr.sfb05 CLIPPED, COLUMN 50,g_x[19] CLIPPED, sr.shh06  #TQC-5A0038 add
      #PRINT g_x[20] CLIPPED, sr.ima02 CLIPPED, COLUMN 47,g_x[21] CLIPPED, sr.shh07 #TQC-5A0038 mark
      PRINT g_x[20] CLIPPED, sr.ima02 CLIPPED  #TQC-5A0038 add
      #PRINT COLUMN 10,sr.ima021 CLIPPED, COLUMN 47,g_x[35] CLIPPED,sr.shh08,' ';   #TQC-5A0038 mark
      PRINT COLUMN 10,sr.ima021 CLIPPED  #TQC-5A0038 add
      PRINT g_x[21] CLIPPED, sr.shh07 CLIPPED,COLUMN 50,g_x[35] CLIPPED,sr.shh08,' ';  #TQC-5A0038 add
#No.FUN-550067 ---end--
      IF sr.shh08='1' THEN PRINT g_x[36] ELSE PRINT g_x[37] END IF
      PRINT g_dash1_1[1,g_len]
 
   ON EVERY ROW
      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01=sr.shh101
      SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01=sr.shh121
      SELECT gen02 INTO l_gen02_3 FROM gen_file WHERE gen01=sr.shh141
      SELECT gem02 INTO l_gem02_1 FROM gem_file WHERE gem01=sr.shh10
      SELECT gem02 INTO l_gem02_2 FROM gem_file WHERE gem01=sr.shh12
 
      PRINT g_x[22]
      PRINT COLUMN 5,sr.shh111
      PRINT COLUMN 5,sr.shh112
      PRINT COLUMN 5,sr.shh113
      PRINT
      PRINT COLUMN 40,g_x[23] CLIPPED,l_gen02_1 CLIPPED ,   #No.FUN-550067
            COLUMN 60,g_x[24] CLIPPED,l_gem02_1
      PRINT g_dash1_1[1,g_len]
 
      PRINT g_x[25]
      PRINT COLUMN 5,sr.shh131
      PRINT COLUMN 5,sr.shh132
      PRINT COLUMN 40,g_x[26] CLIPPED,l_gen02_2 CLIPPED,   #No.FUN-550067
            COLUMN 60,g_x[27] CLIPPED,l_gem02_2
      PRINT g_dash1_1[1,g_len]
 
      PRINT g_x[28]
      PRINT COLUMN 5,sr.shh161
      PRINT COLUMN 5,sr.shh162
      PRINT COLUMN 5,sr.shh163
      PRINT COLUMN 5,sr.shh164
      PRINT COLUMN 5,sr.shh165
      PRINT g_dash1_1[1,g_len]
 
      PRINT g_x[29]
      PRINT COLUMN 5,sr.shh171
      PRINT COLUMN 5,sr.shh172
      PRINT COLUMN 5,sr.shh173
      PRINT COLUMN 5,sr.shh174
      PRINT COLUMN 5,sr.shh175
      PRINT g_dash1_1[1,g_len]
 
      PRINT g_x[30]
      PRINT COLUMN 5,sr.shh151
      PRINT COLUMN 5,sr.shh152
      PRINT g_dash1_1[1,g_len]
 
      PRINT COLUMN 5,g_x[31]  CLIPPED,sr.shh14,
            COLUMN 17,g_x[32] CLIPPED,l_gen02_3,
            COLUMN 36,g_x[33] CLIPPED,sr.shh142,
            COLUMN 55,g_x[34] CLIPPED,sr.shh143
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfh01,sfh04,shh02')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
#NO.TQC-630166 start-
#         IF tm.wc[001,070] > ' ' THEN            # for 80
#              PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#         IF tm.wc[071,140] > ' ' THEN
#              PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#         IF tm.wc[141,210] > ' ' THEN
#              PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#         IF tm.wc[211,280] > ' ' THEN
#              PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
          CALL cl_prt_pos_wc(tm.wc)
#NO.TQC-6310166 
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
## FUN-550124
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[9]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[9]
             PRINT g_memo
      END IF
## END FUN-550124
 
END REPORT
#Patch....NO.TQC-610037 <001,002,003,004,005,006,007,008> #
