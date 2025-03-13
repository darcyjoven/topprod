# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr940.4gl
# Descriptions...: 供應商評核底稿列印
# Date & Author..: FUN-720041 07/03/15 By yiting
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(500)	# Where condition
                pmc01   LIKE pmc_file.pmc01,
                pmc02   LIKE pmc_file.pmc02,   #FUN-720041
                yy      LIKE type_file.chr4,
                mm      LIKE type_file.chr2,
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  	# Input more condition(Y/N)
              END RECORD
 
   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose    #No.FUN-680136 SMALLINT
   DEFINE g_date        LIKE type_file.chr6
   DEFINE #g_sql         LIKE type_file.chr1000
          g_sql        STRING       #NO.FUN-910082  
   DEFINE g_ppe07_tot    LIKE ppe_file.ppe07
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
   IF tm.wc IS NULL OR tm.wc=' '
      THEN CALL r940_tm(0,0)	
      ELSE CALL apmr940()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r940_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
   DEFINE l_c1          LIKE type_file.num5
   DEFINE l_c2          LIKE type_file.num5
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r940_w AT p_row,p_col WITH FORM "apm/42f/apmr940"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
WHILE TRUE
   LET g_pageno = 0
   CONSTRUCT BY NAME tm.wc ON pmc01,pmc02
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
        CASE 
            WHEN INFIELD(pmc01)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_pmc"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc01
                  NEXT FIELD pmc01
            WHEN INFIELD(pmc02)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_pmy"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmc02
                  NEXT FIELD pmc02
        END CASE
 
     ON ACTION locale
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF tm.wc IS NULL OR tm.wc=' ' THEN LET tm.wc=' 1=1 ' END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r940_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   LET tm.yy = year(g_today)
   LET tm.mm = month(g_today)
   IF tm.mm < 10 AND length(tm.mm) < 2 THEN
       LET tm.mm = '0',tm.mm CLIPPED
   END IF
   DISPLAY BY NAME tm.yy,tm.mm 		# Condition
   INPUT BY NAME  tm.yy,tm.mm WITHOUT DEFAULTS
 
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy < 0 THEN NEXT FIELD yy END IF
         
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r940_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL apmr940()
   ERROR ""
END WHILE
   CLOSE WINDOW r940_w
END FUNCTION
 
FUNCTION apmr940()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,       # No.FUN-680136 VARCHAR(40)
          sr            RECORD
                        pmc01  LIKE pmc_file.pmc01,
                        pmy02  LIKE pmy_file.pmy02,
                        pmc02  LIKE pmc_file.pmc02,
                        pmc03  LIKE pmc_file.pmc03
                        END RECORD
                        
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr940'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 230 END IF            
 
     LET g_date = tm.yy,tm.mm
     LET g_sql = "SELECT DISTINCT pmc01,pmy02,pmc02,pmc03 ",
                 "  FROM pmc_file,pmy_file,ppe_file",
                 " WHERE pmy01 = pmc02 ",
                 "   AND pmc01 = ppe02 ",
                 "   AND ppe01 = '",g_date,"'",
                 "   AND ",tm.wc,
                 " ORDER BY pmc01,pmc02"
     PREPARE r940_pmc_p FROM g_sql
     DECLARE r940_pmc_c CURSOR FOR r940_pmc_p
     CALL cl_outnam('apmr940') RETURNING l_name
     START REPORT r940_rep TO l_name
     FOREACH r940_pmc_c INTO sr.pmc01,sr.pmy02,sr.pmc02,sr.pmc03
          IF SQLCA.SQLCODE < 0 THEN 
              EXIT FOREACH 
          END IF
          OUTPUT TO REPORT r940_rep(sr.*)
     END FOREACH
     FINISH REPORT r940_rep
     ERROR ' '
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r940_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_sql         LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(1000)
          l_gem02       LIKE gem_file.gem02,
          sr            RECORD
                        pmc01  LIKE pmc_file.pmc01,
                        pmy02  LIKE pmy_file.pmy02,
                        pmc02  LIKE pmc_file.pmc02,
                        pmc03  LIKE pmc_file.pmc03
                        END RECORD
   DEFINE l_ppe03       LIKE ppe_file.ppe03                   
   DEFINE l_ppa03       LIKE ppa_file.ppa03                   
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_column      LIKE type_file.num5
   DEFINE l_cnt_1       LIKE type_file.num5
   DEFINE l_column_1    LIKE type_file.num5
   DEFINE l_ppe06       LIKE ppe_file.ppe06
   DEFINE l_ppe06_tot   LIKE ppe_file.ppe06
   DEFINE l_ppecnt      LIKE type_file.num5
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmc01,sr.pmc02
  FORMAT
   PAGE HEADER
      #--計算出本張報表寬度，依評核項目而定---
      LET l_column = 84
      LET g_sql = "SELECT COUNT(*) FROM ppe_file",
                  " WHERE ppe01 = '",g_date,"'",
                  "   AND ppe02 = '",sr.pmc01,"'",
                  " ORDER BY ppe03 "
      PREPARE p921_ppecnt_p FROM g_sql
      DECLARE p921_ppecnt_c SCROLL CURSOR FOR p921_ppecnt_p
      OPEN p921_ppecnt_c
      FETCH p921_ppecnt_c INTO l_ppecnt
      IF l_ppecnt > 0 THEN 
          LET l_column = l_column + (20 * l_ppecnt)
      END IF
      LET g_len = l_column + 30
      #----------------------------------------
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      PRINT COLUMN g_len-10,g_x[3] CLIPPED,g_pageno USING '<<<'
      FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
      FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '-' END FOR
      PRINT g_dash2[1,g_len]
      LET l_last_sw = 'n'
 
   BEFORE GROUP  OF sr.pmc01
      SKIP TO TOP OF PAGE
      LET l_cnt = 0
      LET l_column = 0
      PRINT g_x[11] CLIPPED,
            COLUMN 11,g_x[12] CLIPPED,
            COLUMN 52,g_x[13] CLIPPED,
            COLUMN 63,g_x[14] CLIPPED;
      #依apmt940資料抓出評核項目
      LET g_sql = "SELECT ppe03 FROM ppe_file",
                  " WHERE ppe01 = '",g_date,"'",
                  "   AND ppe02 = '",sr.pmc01,"'",
                  " ORDER BY ppe03 "
      PREPARE r940_ppe_p1 FROM g_sql
      DECLARE r940_ppe_c1 CURSOR FOR r940_ppe_p1
      LET l_column = 84
      LET l_cnt = 1
      FOREACH r940_ppe_c1 INTO l_ppe03
          IF SQLCA.SQLCODE < 0 THEN 
              EXIT FOREACH 
          END IF
          SELECT ppa03 INTO l_ppa03
            FROM ppa_file
           WHERE ppa02 = l_ppe03
          IF l_cnt = 1 THEN
              PRINT COLUMN l_column, l_ppa03;
          ELSE
              LET l_column = l_column + 20
              PRINT COLUMN l_column,l_ppa03;
          END IF
          LET l_cnt = l_cnt + 1
      END FOREACH
      LET l_column = l_column + 20
      PRINT COLUMN l_column,g_x[15] CLIPPED;
      LET l_column = l_column + 12
      PRINT COLUMN l_column,g_x[16] CLIPPED
      PRINT g_dash[1,g_len]
 
   ON EVERY ROW
      PRINT COLUMN 1,sr.pmc02 CLIPPED,
            COLUMN 11,sr.pmy02 CLIPPED,
            COLUMN 52,sr.pmc01 CLIPPED,
            COLUMN 63,sr.pmc03 CLIPPED;
      LET g_sql = "SELECT ppe06 FROM ppe_file",
                  " WHERE ppe01 = '",g_date,"'",
                  "   AND ppe02 = '",sr.pmc01,"'",
                  " ORDER BY ppe03 "
      PREPARE r940_ppe_p FROM g_sql
      DECLARE r940_ppe_c CURSOR FOR r940_ppe_p
      LET l_column_1 = 84
      LET l_cnt_1 = 1
      FOREACH r940_ppe_c INTO l_ppe06
          IF SQLCA.SQLCODE < 0 THEN 
              EXIT FOREACH 
          END IF
          IF l_cnt_1 = 1 THEN
              PRINT COLUMN l_column_1, l_ppe06;
          ELSE
              LET l_column_1 = l_column_1 + 20
              PRINT COLUMN l_column_1,l_ppe06;
          END IF
          LET l_cnt_1 = l_cnt_1 +1 
      END FOREACH
      LET l_column_1 = l_column_1 + 20
      LET l_ppe06_tot = 0 
      SELECT SUM(ppe06) INTO l_ppe06_tot
        FROM ppe_file
       WHERE ppe01 = g_date
         AND ppe02 = sr.pmc01
      PRINT COLUMN l_column_1,l_ppe06_tot USING '###.&#';
 
      #--修正之後總分----
      LET g_ppe07_tot = 0 
      LET l_column_1 = l_column_1 + 12
      SELECT SUM(ppe07) INTO g_ppe07_tot   #修正之後總分
        FROM ppe_file
       WHERE ppe01 = g_date
         AND ppe02 = sr.pmc01
      IF cl_null(g_ppe07_tot) THEN LET g_ppe07_tot = 0 END IF 
      PRINT COLUMN l_column_1,g_ppe07_tot USING '##&.&#'
 
   ON LAST ROW
      PRINT g_dash2[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED 
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN
              PRINT g_dash2[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED      #No.TQC-6B0095
         ELSE SKIP 2 LINE
      END IF
END REPORT
