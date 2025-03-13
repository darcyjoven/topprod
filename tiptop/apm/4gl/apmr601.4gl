# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr601.4gl
# Descriptions...: 採購單簽核狀況列印
# Input parameter:
# Date & Author..: 91/10/22 By May
# Modify.........: No.FUN-4B0024 04/11/03 By Smapmin 採購單號開窗
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-650044 06/05/15 By Echo 憑證類的報表因報表寬度(p_zz)為0或NULL,導致報表當掉
# Modify.........: No.MOD-660133 06/06/30 By Ray 增加新欄位pmm40t(含稅總金額)
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	       #wc   VARCHAR(500),		# Where condition            #TQC-630166 mark
		wc  	STRING,		        # Where condition            #TQC-630166
                azc03   LIKE azc_file.azc03,
                a       LIKE type_file.chr1,    # No.FUN-680136 VARCHAR(1)      # 交易統計均為0者是否列印
   		more	LIKE type_file.chr1     # No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_azm03       LIKE type_file.num5,    # No.FUN-680136 SMALLINT              # 季別
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_total        LIKE pmn_file.pmn44    # MOD-530190
 
   DEFINE  g_i           LIKE type_file.num5    # count/index for any purpose #No.FUN-680136 SMALLINT
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
 
 
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#------------No.TQC-610085 modify
  #LET tm.azc03 = ARG_VAL(8)
   LET tm.a = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
#------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r601_tm(0,0)		        # Input print condition
      ELSE CALL apmr601()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r601_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	 LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd	 	 LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r601_w AT p_row,p_col WITH FORM "apm/42f/apmr601"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
  #LET g_prtway= "Q"
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION controlp    #FUN-4B0024
       IF INFIELD(pmm01) THEN
          CALL cl_init_qry_var()
          LET g_qryparam.state ="c"
          LET g_qryparam.form ="q_pmn6"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO pmm01
          NEXT FIELD pmm01
       END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW r601_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.a,tm.more 		# Condition
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
          IF tm.a IS NULL OR tm.a NOT MATCHES '[YN]' THEN
             NEXT FIELD a
          END IF
      AFTER FIELD more      #輸入其它特殊列印條件
           IF tm.more  IS NULL  OR tm.more NOT MATCHES '[YN]' THEN
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
      LET INT_FLAG = 0 CLOSE WINDOW r601_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr601'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr601','9031',1)
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
                        #" '",tm.azc03 CLIPPED,"'",           #No.TQC-610085 mark
                         " '",tm.a CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr601',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r601_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr601()
   ERROR ""
END WHILE
   CLOSE WINDOW r601_w
END FUNCTION
 
FUNCTION apmr601()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job   #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT                 #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,  		        # RDSQL STATEMENT                 #TQC-630166
          l_za05	LIKE type_file.chr1000,         #No.FUN-680136 VARCHAR(40)
          sr              RECORD
                                  pmm01   LIKE pmm_file.pmm01,    #採購單號
                                  pmm02   LIKE pmm_file.pmm02,    #單據性質
                                  pmm09   LIKE pmm_file.pmm09,    #供應廠商
                                  pmmsign LIKE pmm_file.pmmsign,  #簽核等級
                                  pmm22   LIKE pmm_file.pmm22,    #幣別
                                  pmm40   LIKE pmm_file.pmm40,    #總金額
                                  pmm40t  LIKE pmm_file.pmm40t,   #含稅總金額    #MOD-660133
                                  pmm04   LIKE pmm_file.pmm04,    # 日期
                                  pmmdays LIKE pmm_file.pmmdays,  #簽核天數
                                  pmmprit LIKE pmm_file.pmmprit,  #簽核優先等級
                                  days    LIKE type_file.num5,    #No.FUN-680136 SMALLINT 
                                  pmmsseq LIKE pmm_file.pmmsseq,  #已簽
                                  pmmsmax LIKE pmm_file.pmmsmax,  #應簽
                                  pmn02   LIKE pmn_file.pmn02,    #項次
                                  pmn04   LIKE pmn_file.pmn04,    #料件編號
                                  pmn44   LIKE pmn_file.pmn44,    #本幣單位
                                  pmn07   LIKE pmn_file.pmn07,    #採購單位
                                  pmn33   LIKE pmn_file.pmn33,    #交貨日
                                  pmn20   LIKE pmn_file.pmn20,    #採購量
                                  azc01   LIKE azc_file.azc01     #簽核等級
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr601'
     #TQC-650044 
     #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 88 END IF   #No.FUN-550060
     #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #END TQC-650044 
 
     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
       FROM azi_file                 #幣別檔小數位數讀取
      WHERE azi01=g_aza.aza17
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT  ",
                 " pmm01,pmm02,pmm09,pmmsign,pmm22,pmm40,pmm40t,pmm04,pmmdays,",      #MOD-660133
                 " pmmprit,0,pmmsseq,",
                 "  pmmsmax,pmn02,pmn04,pmn44,pmn07, ",
                 " pmn33,pmn20 ",
                 "  FROM pmm_file,pmn_file",
                 "  WHERE pmmmksg = 'Y' AND pmm25 !='6' ",
                 " AND pmm25 !='9' AND pmmsseq != pmmsmax ",
                 "  AND pmm01=pmn01 ",
                 "  AND ",tm.wc CLIPPED
     PREPARE r601_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r601_cs  CURSOR FOR r601_prepare
#    LET l_name = 'apmr601.out'
 
     CALL cl_outnam('apmr601') RETURNING l_name
 
     #TQC-650044 
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 88 END IF   #No.FUN-550060
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #END TQC-650044 
 
     START REPORT r601_rep TO l_name
     FOREACH r601_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       LET sr.azc01=sr.pmmsign
       IF sr.pmm01  IS NULL THEN LET sr.pmm01 = ' ' END IF
        CALL s_gdays(sr.pmm04+sr.pmmdays) RETURNING sr.days
       OUTPUT TO REPORT r601_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r601_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r601_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
          l_pmc03     LIKE pmc_file.pmc03,
          l_azd04     LIKE azd_file.azd04,
          l_gen02     LIKE gen_file.gen02,
         #l_sql1      LIKE type_file.chr1000,#TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)
          l_sql1      STRING,                #TQC-630166
          tmp         RECORD
                           azc02   LIKE azc_file.azc02,    #順序
                           azc03   LIKE azc_file.azc03     # 簽核人員
                      END RECORD,
          sr          RECORD
                           pmm01   LIKE pmm_file.pmm01,    #採購單號
                           pmm02   LIKE pmm_file.pmm02,    #單據性質
                           pmm09   LIKE pmm_file.pmm09,    #供應廠商
                           pmmsign LIKE pmm_file.pmmsign,  #簽核等級
                           pmm22   LIKE pmm_file.pmm22,    #幣別
                           pmm40   LIKE pmm_file.pmm40,    #總金額
                           pmm40t  LIKE pmm_file.pmm40t,   #含稅總金額    #MOD-660133
                           pmm04   LIKE pmm_file.pmm04,    # 日期
                           pmmdays LIKE pmm_file.pmmdays,  #簽核天數
                           pmmprit LIKE pmm_file.pmmprit,  #簽核優先等級
                           days    LIKE type_file.num5,    #No.FUN-680136 SMALINT
                           pmmsseq LIKE pmm_file.pmmsseq,  #已簽
                           pmmsmax LIKE pmm_file.pmmsmax,  #應簽
                           pmn02   LIKE pmn_file.pmn02,    #項次
                           pmn04   LIKE pmn_file.pmn04,    #料件編號
                           pmn44   LIKE pmn_file.pmn44,    #本幣單位
                           pmn07   LIKE pmn_file.pmn07,    #採購單位
                           pmn33   LIKE pmn_file.pmn33,    #交貨日
                           pmn20   LIKE pmn_file.pmn20,    #採購量
                           azc01   LIKE azc_file.azc01     #簽核等級
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.days,sr.pmmprit,sr.pmm01
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      PRINT g_x[2] CLIPPED,g_today,'  ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      PRINT g_x[11] CLIPPED,g_x[12] CLIPPED
      PRINT COLUMN 60,g_x[13] CLIPPED
      PRINT '---------------- -------- ---------- ----------  --------  ---------';
      PRINT '  ------------------ ------------------'
      LET l_last_sw = 'n'
 
BEFORE GROUP  OF sr.pmm01
#是否需顯示請購單料件的詳細資料
         IF tm.a = 'Y' THEN
              SKIP TO TOP OF PAGE
         END IF
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE sr.pmm09 = pmc01
         IF SQLCA.sqlcode THEN LET l_pmc03 =  NULL END IF
         PRINT sr.pmm01,
               COLUMN 18,sr.pmm02,
               COLUMN 27,sr.pmm09,
#              COLUMN 38,l_pmc03,
               COLUMN 38,l_pmc03 CLIPPED,           #No.FUN-550060
#              COLUMN 50,sr.pmmsign,
               COLUMN 50,sr.pmmsign CLIPPED,        #No.FUN-550060
               COLUMN 60,sr.pmm22,
               COLUMN 70,cl_numfor(sr.pmm40,18,g_azi04),
               COLUMN 89,cl_numfor(sr.pmm40t,18,g_azi04)      #MOD-660133
         PRINT COLUMN 62,sr.pmmsseq USING '-&','/',
               COLUMN 65,sr.pmmsmax USING "-&";
         LET l_sql1 =" SELECT azc02,azc03 FROM azc_file",
                     "  WHERE '",sr.azc01,"' = azc01",
                     " ORDER BY azc02"
# 找出此張單據應簽已簽的所有簽核人員
         PREPARE apmr310_pre1 FROM l_sql1
            IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
                 EXIT PROGRAM END IF
         DECLARE apmr310_cs2 CURSOR FOR apmr310_pre1
         FOREACH apmr310_cs2 INTO tmp.*
            IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH END IF
#找出此張單據已簽簽核人員的簽核日期
            SELECT azd04 INTO l_azd04 FROM azd_file WHERE sr.pmm01 = azd01 AND
                   azd02 = 3 AND tmp.azc03 = azd03
            IF SQLCA.sqlcode THEN LET l_azd04 = NULL END IF
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE tmp.azc03 = gen01
            IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
#已簽核的列印一'*'，和簽核日期
            IF sr.pmmsseq < tmp.azc02 THEN
               PRINT COLUMN 90,l_gen02
            END IF
#未簽核的只列印出員工名稱
            IF sr.pmmsseq > tmp.azc02 OR sr.pmmsseq = tmp.azc02  THEN
               PRINT COLUMN 69,l_azd04,
                     COLUMN 89 ,'*',
                     COLUMN 90,l_gen02
            END IF
         END FOREACH
      LET l_last_sw = 'n'
      IF tm.a = 'Y' THEN
         PRINT g_dash[1,g_len] CLIPPED
         PRINT g_x[14] CLIPPED,COLUMN 54,g_x[15] CLIPPED
         PRINT COLUMN 24,g_x[16] CLIPPED,
               COLUMN 85,g_x[17] CLIPPED
         PRINT '----- --------------------  --     --------   -------------  ---------------------------'
      END IF
   ON EVERY ROW
#是否需顯示請購單料件的詳細資料
      IF tm.a = 'Y' THEN
         PRINT sr.pmn02 USING '#####',
               COLUMN 07,sr.pmn04,
               COLUMN 46,sr.pmn20 USING "--,---,--&.&&&",
               COLUMN 73,cl_numfor(sr.pmn44,15,g_azi03)
         PRINT COLUMN 29,sr.pmn07,
               COLUMN 36,sr.pmn33;
#              sr.pmn20 USING "-,---,--&.&&&"  CLIPPED;
 
         LET g_total = sr.pmn20 * sr.pmn44
         PRINT COLUMN 70,cl_numfor(g_total,18,g_azi04) CLIPPED
      END IF
         LET l_last_sw = 'n'
 ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-201,240,300
         THEN PRINT g_dash[1,g_len]
             #TQC-630166
             #IF tm.wc[001,70] > ' ' THEN			# for 80
             #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
             #IF tm.wc[071,140] > ' ' THEN
             #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
             #IF tm.wc[141,210] > ' ' THEN
  	     #  PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
             #IF tm.wc[211,280] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
             CALL cl_prt_pos_wc(tm.wc)
             #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610036 <001,002> #
