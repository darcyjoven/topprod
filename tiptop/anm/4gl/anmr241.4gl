# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: anmr241.4gl
# Descriptions...: 客戶應收票據帳齡分析表
# Date & Author..: 94/05/21  By  Felicity  Tseng
#                    增加選項(1).原幣 (2).本幣
# Modify.........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-830031 08/03/27 By Carol l_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,    #TQC-630166
		       bdate   LIKE type_file.dat,    #No.FUN-680107 DATE
           c       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
           more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
           END RECORD,
	   m_azi05     LIKE azi_file.azi05,
	   m_tot1      LIKE nmh_file.nmh32,
	   m_tot2      LIKE nmh_file.nmh32,
	   m_tot3      LIKE nmh_file.nmh32,
	   m_tot4      LIKE nmh_file.nmh32,
	   m_tot5      LIKE nmh_file.nmh32
 
DEFINE   g_i     LIKE type_file.num5       #count/index for any purpose   #No.FUN-680107 SMALLINT
#No.FUN-580010  --begin
#DEFINE   g_dash          VARCHAR(400)  #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.c      = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r241_tm(0,0)
      ELSE CALL r241()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r241_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5      #No.FUN-680107 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000   #TQC-830031-modify  #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW r241_w AT p_row,p_col
        WITH FORM "anm/42f/anmr241"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today
   LET tm.c    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh15,nmh16,nmh17,nmh12,nmh04
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
      CLOSE WINDOW r241_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   DISPLAY BY NAME tm.more
   INPUT BY NAME tm.bdate,tm.c,tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
	  AFTER FIELD bdate
		 IF cl_null(tm.bdate) THEN
			LET tm.bdate = g_today
			NEXT FIELD tm.bdate
		 END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES '[12]' THEN
            NEXT FIELD c
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
      ON ACTION CONTROLG CALL cl_cmdask()
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
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
      CLOSE WINDOW r241_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='anmr241'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr241','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.c CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr241',g_time,l_cmd)
      END IF
      CLOSE WINDOW r241_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r241()
   ERROR ""
END WHILE
   CLOSE WINDOW r241_w
END FUNCTION
 
FUNCTION r241()
DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
#       l_time       LIKE type_file.chr8        #No.FUN-6A0082
       l_sql     LIKE type_file.chr1000,		     #No.FUN-680107 VARCHAR(1200)
       l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
       l_nmh05   LIKE nmh_file.nmh05,
       sr        RECORD
          nmh15 LIKE nmh_file.nmh15,	         #客戶
       	  nmh32 LIKE nmh_file.nmh32,	         #金額
       	  nmh02 LIKE nmh_file.nmh02,	         #金額
	  days  LIKE type_file.num5                  #No.FUN-680107	SMALLINT	#票齡
                 END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr241'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT nmh15, nmh32,nmh02, nmh05 ",
                 " FROM nmh_file ",
                 " WHERE ", tm.wc CLIPPED,
                 "   AND nmh04 <= '",tm.bdate,"'",
                 "   AND nmh38 <> 'X '",
                 "   AND (nmh35 IS NULL OR nmh35 > '",tm.bdate,"')"
#    LET l_sql = l_sql CLIPPED," ORDER BY apa01"
     PREPARE r241_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r241_curs1 CURSOR FOR r241_prepare1
#    LET l_name = 'anmr241.out'
     CALL cl_outnam('anmr241') RETURNING l_name
     START REPORT r241_rep TO l_name
	 SELECT azi05
		FROM azi_file
		WHERE azi01 = g_aza.aza17
     LET g_pageno = 0
     LET m_tot1 = 0 LET m_tot2 = 0 LET m_tot3 = 0 LET m_tot4 = 0
     LET m_tot5 = 0
     FOREACH r241_curs1 INTO sr.nmh15, sr.nmh32,sr.nmh02, l_nmh05
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          IF cl_null(sr.nmh32) OR sr.nmh32 = 0 THEN CONTINUE FOREACH END IF
          IF cl_null(sr.nmh02) OR sr.nmh02 = 0 THEN CONTINUE FOREACH END IF
          IF tm.c='1' THEN
             LET sr.nmh32=sr.nmh02
          END IF
	  LET sr.days = tm.bdate - l_nmh05
          OUTPUT TO REPORT r241_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r241_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r241_rep(sr)
DEFINE l_last_sw   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_gem02	    LIKE gem_file.gem02,
       l_amt_1      LIKE nmh_file.nmh32,
       l_amt_2      LIKE nmh_file.nmh32,
       l_amt_3      LIKE nmh_file.nmh32,
       l_amt_4      LIKE nmh_file.nmh32,
       l_amt_5      LIKE nmh_file.nmh32,
       sr        RECORD
          nmh15 LIKE nmh_file.nmh15,	    #客戶
   	      nmh32 LIKE nmh_file.nmh32,	    #金額
       	  nmh02 LIKE nmh_file.nmh02,	    #金額
	  days  LIKE type_file.num5             #No.FUN-680107	SMALLINT	#票齡
                 END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.nmh15
  FORMAT
   PAGE HEADER
#No.FUN-580010  -begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[14] CLIPPED,tm.bdate
      PRINT g_dash
      LET g_zaa[33].zaa08 = '1 - ', g_nmz.nmz23 USING '###&',g_x[12] CLIPPED
      LET g_zaa[34].zaa08 = g_nmz.nmz23+1 USING '###&',g_x[12] CLIPPED,' -',
                            g_nmz.nmz24 USING '###&',g_x[12] CLIPPED
      LET g_zaa[35].zaa08 = g_nmz.nmz24+1 USING '###&',g_x[12] CLIPPED,' -',
                            g_nmz.nmz25 USING '###&',g_x[12] CLIPPED
      LET g_zaa[36].zaa08 = g_nmz.nmz25+1 USING '###&',g_x[12] CLIPPED,' -',
                            g_nmz.nmz26 USING '###&',g_x[12] CLIPPED
      LET g_zaa[37].zaa08 = g_nmz.nmz26 USING '###&',g_x[15]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINT g_dash1
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 32,g_x[14] CLIPPED,tm.bdate,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     PRINT ' ',g_x[11] CLIPPED,
#  	    COLUMN 24, '1 - ',
#    COLUMN 27, g_nmz.nmz23 USING '###&',g_x[12] CLIPPED,
#    COLUMN 34, g_nmz.nmz23+1 USING '###&',g_x[12] CLIPPED,' - ',
#    COLUMN 42, g_nmz.nmz24 USING '###&',g_x[12] CLIPPED,
#    COLUMN 49, g_nmz.nmz24+1 USING '###&',g_x[12] CLIPPED,' - ',
#    COLUMN 57, g_nmz.nmz25 USING '###&',g_x[12] CLIPPED,
#    COLUMN 64, g_nmz.nmz25+1 USING '###&',g_x[12] CLIPPED,' - ',
#          #No.B155 010505 by plum
#   #COLUMN 74, g_nmz.nmz26 USING '##&',g_x[12] CLIPPED
#    COLUMN 73, g_nmz.nmz26 USING '###&',g_x[12] CLIPPED,
#    COLUMN 82, g_nmz.nmz26 USING '###&',g_x[15] CLIPPED
#          #No.B155..end
#     PRINT ' -------- -------- -------------- -------------- ',
#		'-------------- --------------',
#		' --------------'
#No.FUN-580010  --end
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.nmh15
	  LET l_amt_1 = 0 LET l_amt_2 = 0
	  LET l_amt_3 = 0 LET l_amt_4 = 0  LET l_amt_5=0
	  SELECT gem02
		INTO l_gem02
		FROM gem_file
		WHERE gem01 = sr.nmh15
		IF SQLCA.SQLCODE THEN LET l_gem02 = ' ' END IF
#No.FUN-580010  -begin
#	  PRINT COLUMN 02, sr.nmh15,
#			COLUMN 11, l_gem02;
          PRINT COLUMN g_c[31], sr.nmh15,
                COLUMN g_c[32], l_gem02;
#No.FUN-580010  -end
 
   ON EVERY ROW
	  WHILE TRUE
		IF sr.days <= g_nmz.nmz23 THEN
			LET l_amt_1 = l_amt_1 + sr.nmh32
			LET m_tot1 = m_tot1 + sr.nmh32
 			EXIT WHILE
		END IF
		IF sr.days > g_nmz.nmz23  AND sr.days <= g_nmz.nmz24 THEN
			LET l_amt_2 = l_amt_2 + sr.nmh32
			LET m_tot2 = m_tot2 + sr.nmh32
 			EXIT WHILE
		END IF
		IF sr.days > g_nmz.nmz24  AND sr.days <= g_nmz.nmz25 THEN
			LET l_amt_3 = l_amt_3 + sr.nmh32
			LET m_tot3 = m_tot3 + sr.nmh32
 			EXIT WHILE
		END IF
		IF sr.days > g_nmz.nmz25  AND sr.days <= g_nmz.nmz26 THEN
			LET l_amt_4 = l_amt_4 + sr.nmh32
			LET m_tot4 = m_tot4 + sr.nmh32
 			EXIT WHILE
		END IF
               #No.B155 010505 by plum
		IF sr.days > g_nmz.nmz26 THEN
			LET l_amt_5 = l_amt_5 + sr.nmh32
			LET m_tot5 = m_tot5 + sr.nmh32
 			EXIT WHILE
		END IF
               #No.B155 ..end
		EXIT WHILE
	  END WHILE
 
   AFTER GROUP OF sr.nmh15
#No.FUN-580010 --begin
#	  PRINT COLUMN 20, cl_numfor(l_amt_1,13,g_azi05) CLIPPED,
#			COLUMN 35, cl_numfor(l_amt_2,13,g_azi05) CLIPPED,
#			COLUMN 50, cl_numfor(l_amt_3,13,g_azi05) CLIPPED,
#                       #No.B155 010505 by plum
#		       #COLUMN 65, cl_numfor(l_amt_4,13,g_azi05) CLIPPED
#			COLUMN 65, cl_numfor(l_amt_4,13,g_azi05) CLIPPED ,
#			COLUMN 80, cl_numfor(l_amt_5,13,g_azi05) CLIPPED
#                       #No.B155 ..end
          PRINT COLUMN g_c[33], cl_numfor(l_amt_1,33,g_azi05) CLIPPED,
                COLUMN g_c[34], cl_numfor(l_amt_2,34,g_azi05) CLIPPED,
                COLUMN g_c[35], cl_numfor(l_amt_3,35,g_azi05) CLIPPED,
                COLUMN g_c[36], cl_numfor(l_amt_4,36,g_azi05) CLIPPED,
                COLUMN g_c[37], cl_numfor(l_amt_5,37,g_azi05) CLIPPED
#No.FUN-580010 --end
 
   ON LAST ROW
      PRINT
#No.FUN-580010 --begin
#     PRINT COLUMN 13, g_x[13] CLIPPED,
#		COLUMN 20, cl_numfor(m_tot1,13,g_azi05) CLIPPED,
#		COLUMN 35, cl_numfor(m_tot2,13,g_azi05) CLIPPED,
#		COLUMN 50, cl_numfor(m_tot3,13,g_azi05) CLIPPED,
#                      #No.B155 010505 by plum
#	       #COLUMN 65, cl_numfor(m_tot4,13,g_azi05) CLIPPED
#		COLUMN 65, cl_numfor(m_tot4,13,g_azi05) CLIPPED,
#		COLUMN 80, cl_numfor(m_tot5,13,g_azi05) CLIPPED
#                      #No.B155..end
      PRINT COLUMN g_c[32], g_x[13] CLIPPED,
            COLUMN g_c[33], cl_numfor(m_tot1,33,g_azi05) CLIPPED,
            COLUMN g_c[34], cl_numfor(m_tot2,34,g_azi05) CLIPPED,
            COLUMN g_c[35], cl_numfor(m_tot3,35,g_azi05) CLIPPED,
            COLUMN g_c[36], cl_numfor(m_tot4,36,g_azi05) CLIPPED,
            COLUMN g_c[37], cl_numfor(m_tot5,37,g_azi05) CLIPPED
#No.FUN-580010 --end
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,241,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         PRINT g_dash
         #TQC-630166 Start
         #     IF tm.wc[001,070] > ' ' THEN            # for 80
         #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #     IF tm.wc[071,140] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #     IF tm.wc[141,210] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #     IF tm.wc[211,280] > ' ' THEN
         # PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
 
          CALL cl_prt_pos_wc(tm.wc)
         #TQC-630166 End
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,241] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,241] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610036 <> #
