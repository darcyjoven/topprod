# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmr763.4gl
# Descriptions...: 客訴事件記錄表
# Date & Author..: 02/03/27 By Mandy
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 結束位置調整
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE 
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		     # Print condition RECORD
              wc     STRING,     # Where Condition
              type   LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
              more   LIKE type_file.chr1        # No.FUN-680137  VARCHAR(1)      # 特殊列印條件
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_head1         STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.type  = ARG_VAL(8)
#---------------No.TQC-610089 modify
  #LET tm.more  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
#---------------No.TQC-610089 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r763_tm(0,0)	
      ELSE CALL r763()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r763_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r763_w AT p_row,p_col WITH FORM "axm/42f/axmr763"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.type   = '3'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON ohc01,ohc02,ohc06
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
       LET INT_FLAG = 0
       CLOSE WINDOW r763_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
       EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
   END IF
   INPUT BY NAME tm.type,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD type
         IF tm.type NOT MATCHES'[0123]' THEN
             NEXT FIELD type
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      CLOSE WINDOW r763_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axmr763'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr763','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.type,"'",
                        #" '",tm.more,"'",                      #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axmr763',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r763_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r763()
   ERROR ""
END WHILE
   CLOSE WINDOW r763_w
END FUNCTION
 
FUNCTION r763()
   DEFINE l_name     LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8         #No.FUN-6A0094
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_order    ARRAY[3] of LIKE faj_file.faj02,      # No.FUN-680137 VARCHAR(10)
          sr         RECORD
                       ohc02    LIKE ohc_file.ohc02,
                       ohc01    LIKE ohc_file.ohc01,
                       ohc06    LIKE ohc_file.ohc06,
                       ohc061   LIKE ohc_file.ohc061,
                       ohc04    LIKE ohc_file.ohc04,
                       ohf05    LIKE ohf_file.ohf05,
                       gem02    LIKE gem_file.gem02,
                       ohc14    LIKE ohc_file.ohc14,
                       ohc11    LIKE ohc_file.ohc11,
                       gen02    LIKE gen_file.gen02
                     END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET l_sql = l_sql clipped," AND ohcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET l_sql = l_sql clipped," AND ohcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql clipped," AND ohcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET l_sql = l_sql CLIPPED,cl_get_extra_cond('ohcuser', 'ohcgrup')
     #End:FUN-980030
 
 
     LET l_sql = " SELECT ohc02,ohc01,ohc06,ohc061,ohc04,ohf05,gem02, ",
                 "        ohc14,ohc11,gen02 ",
                 "   FROM ohc_file,ohf_file,OUTER gem_file,OUTER gen_file ",
                 "  WHERE ",tm.wc CLIPPED,
                 "    AND ohf01 = ohc01",
                 "    AND ohf02 = '1' ", #類別==>1.調查結果
                 "    AND gem_file.gem01 = ohf_file.ohf05 ",
                 "    AND gen_file.gen01 = ohc_file.ohc11 ",
                 "    AND ohcconf != 'X' "
      IF tm.type MATCHES'[012]' THEN
          LET l_sql = l_sql CLIPPED," AND ohc03 ='",tm.type,"'"
      END IF
display 'l_sql:',l_sql
 
     PREPARE r763_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:r763_p',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE r763_c CURSOR FOR r763_p
 
     CALL cl_outnam('axmr763') RETURNING l_name
 
     START REPORT r763_rep TO l_name
 
     LET g_pageno = 0
 
     FOREACH r763_c INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       OUTPUT TO REPORT r763_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r763_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r763_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          sr         RECORD
                       ohc02    LIKE ohc_file.ohc02,
                       ohc01    LIKE ohc_file.ohc01,
                       ohc06    LIKE ohc_file.ohc06,
                       ohc061   LIKE ohc_file.ohc061,
                       ohc04    LIKE ohc_file.ohc04,
                       ohf05    LIKE ohf_file.ohf05,
                       gem02    LIKE gem_file.gem02,
                       ohc14    LIKE ohc_file.ohc14,
                       ohc11    LIKE ohc_file.ohc11,
                       gen02    LIKE gen_file.gen02
                     END RECORD,
          l_ohd03    LIKE ohd_file.ohd03
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
      ORDER BY sr.ohc02,sr.ohc01,sr.ohc06,sr.ohc04,sr.ohc14
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ''
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39],
            g_x[40],
            g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ohc02 #客訴日期
      PRINT COLUMN g_c[31],sr.ohc02;
 
   ON EVERY ROW
      PRINT COLUMN g_c[32],sr.ohc01,
            COLUMN g_c[33],sr.ohc06,
            COLUMN g_c[34],sr.ohc061,
            COLUMN g_c[35],sr.ohc04,
            COLUMN g_c[36],sr.ohf05,
            COLUMN g_c[37],sr.gem02,
            COLUMN g_c[38],sr.ohc14,
            COLUMN g_c[39],sr.ohc11,
            COLUMN g_c[40],sr.gen02;
 
      DECLARE ohd03_cur CURSOR FOR
         SELECT ohd03
           FROM ohd_file
          WHERE ohd01 = sr.ohc01
      LET g_i = 0
      FOREACH ohd03_cur INTO l_ohd03
          PRINT COLUMN g_c[41],l_ohd03
          LET g_i = g_i + 1
      END FOREACH
      IF g_i = 0 THEN
         PRINT ''
      END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
              #TQC-630166
              #IF tm.wc[001,120] > ' ' THEN			# for 132
       	#	 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
        #     IF tm.wc[121,240] > ' ' THEN
        #        PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
        #     IF tm.wc[241,300] > ' ' THEN
        #	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
                   #END TQC-630166
 
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4] CLIPPED, COLUMN (g_len-7), g_x[7] CLIPPED #No.TQC-5B0212
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED, COLUMN (g_len-7), g_x[6] CLIPPED #No.TQC-5B0212
         ELSE SKIP 2 LINE
      END IF
END REPORT
