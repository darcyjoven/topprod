# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr310.4gl
# Desc/riptions...: 未核準請購單列印
# Input parameter:
# Return code....:
# Date & Author..: 91/10/18 By MAY
# Modify....2.0版: 95/11/07 By Danny (加查詢簽核人員)
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4C0095 05/01/06 By Mandy 報表轉XML
# Modify.........: NO.TQC-5B0037 05/11/07 by rosayu 報表結束定位點修改
# Modify.........: No.TQC-610085 06/04/04 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-870161 08/07/14 By Cockroach  pmk07沒有用到，暫時隱藏 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				    # Print condition RECORD
	#	wc   VARCHAR(500),	      	    # Where condition
		wc  	STRING,		            #TQC-630166            # Where condition
   		azc03 	 LIKE azc_file.azc03,
   		more	 LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
          g_aza17        LIKE aza_file.aza17        # 本國幣別
   DEFINE   g_cnt        LIKE type_file.num10       #No.FUN-680136 INTEGER
   DEFINE   g_i          LIKE type_file.num5        #count/index for any purpose  #No.FUN-680136 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
    IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
       CALL cl_err(g_sma.sma31,'mfg0032',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
    END IF
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.azc03= ARG_VAL(8)
#--------------No.TQC-610085 modify
  #LET tm.more= ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
#--------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r310_tm(0,0)		# Input print condition
      ELSE CALL apmr310()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r310_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW r310_w AT p_row,p_col WITH FORM "apm/42f/apmr310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   LET g_action_choice = ""
   CLEAR FORM
#   CONSTRUCT BY NAME tm.wc ON pmk01,pmk07,pmksign      #MOD-870161 MARK
   CONSTRUCT BY NAME tm.wc ON pmk01,pmksign             #MOD-870161 ADD
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
   IF g_action_choice = "locale" THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more  # Condition
   INPUT BY NAME tm.azc03,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD azc03 #mandy test
      #    IF cl_null(tm.azc03) THEN
      #         CALL cl_err('','mfg2726',0)
      #         NEXT FIELD azc03
      #    ELSE
      #       SELECT COUNT(*) INTO g_cnt FROM azb_file
      #        WHERE azb01=tm.azc03
      #       IF g_cnt = 0 THEN
      #         CALL cl_err('','mfg0017',0)
      #         NEXT FIELD azc03
      #       END IF
      #    END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
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
      #95/11/07 by danny (加查詢簽核人員)
      ON ACTION CONTROLP
         CASE WHEN INFIELD(azc03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_gen' #FUN-4C0095
              LET g_qryparam.default1 = tm.azc03
              CALL cl_create_qry() RETURNING tm.azc03
               DISPLAY BY NAME tm.azc03         #No.MOD-490371
              NEXT FIELD azc03
         END CASE
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr310'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr310','9031',1)
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
                         " '",tm.azc03 CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'"  ,         #No.TQC-610085 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr310',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr310()
   ERROR ""
END WHILE
   CLOSE WINDOW r310_w
END FUNCTION
 
FUNCTION apmr310()
   DEFINE l_name	LIKE type_file.chr20, 	     # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	     # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	     # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE za_file.za05,           #No.FUN-680136 VARCHAR(40)
          sr               RECORD
                                  pmk01 LIKE pmk_file.pmk01,	# 單號
                                  pmk02 LIKE pmk_file.pmk02, 	# 請購單性質
                                  pmk04 LIKE pmk_file.pmk04,    # 請購日期
                                  pmk09 LIKE pmk_file.pmk09,    # FUN-4C0095
                                  pmc03 LIKE pmc_file.pmc03,    # 供應廠商
                                  pmksseq LIKE pmk_file.pmksseq,# 已簽核順序
                                  pmksmax LIKE pmk_file.pmksmax,# 應簽核順序
                                  pmk22 LIKE pmk_file.pmk22,    # 幣別
                                  pmk40 LIKE pmk_file.pmk40,    # 總金額
                                  pmkprit LIKE pmk_file.pmkprit,#優先等級
                                  days  LIKE type_file.num5     #No.FUN-680136 SMALLINT
                        END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004---------Begin-----------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004--------End-------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
     #End:FUN-980030
 
 
        LET l_sql = "SELECT ",                      #組合查詢句子
            " pmk01,pmk02,pmk04,pmk09,pmc03,pmksseq,pmksmax,",
           #" pmk22,pmk40,pmkprit,(pmk04+pmkdays)-to_date(?)?", #mandy test
            " pmk22,pmk40,pmkprit,pmkdays ",
            " FROM pmk_file,OUTER(pmc_file) ",
            " WHERE pmksign IS NOT NULL AND",
            " pmkmksg='Y' AND",
            " pmk25='0' AND pmkacti='Y'",
            " AND pmk_file.pmk09 = pmc_file.pmc01 ",
            " AND pmk18 != 'X' AND ",tm.wc CLIPPED #mandy test
            #-[這一句話很重要]-----------------------------------------------
            #去選擇單據時, 加這一句條件, 可以得到該使用者該簽核而未簽核的單據
           #" AND pmksseq=(SELECT (azc02 - 1)", #mandy test
           #" FROM azc_file WHERE azc01=pmksign AND azc03='",tm.azc03,"')"
     LET l_sql = l_sql CLIPPED ," ORDER BY pmk01"
     PREPARE r310_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        RETURN
     END IF
     DECLARE r310_cs1 CURSOR FOR r310_prepare1
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        RETURN
     END IF
     CALL cl_outnam('apmr310') RETURNING l_name
     START REPORT r310_rep TO l_name
    #FOREACH r310_cs1  USING g_today INTO sr.* #mandy test
     FOREACH r310_cs1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF cl_null(sr.pmksseq) OR sr.pmksseq = ' ' THEN
          LET sr.pmksseq = 0
       END IF
       OUTPUT TO REPORT r310_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r310_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r310_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
          l_tail      LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
          l_pmc03     LIKE pmc_file.pmc03,
          l_gen02     LIKE gen_file.gen02,
          sr               RECORD
                                  pmk01 LIKE pmk_file.pmk01,	# 單號
                                  pmk02 LIKE pmk_file.pmk02, 	# 請購單性質
                                  pmk04 LIKE pmk_file.pmk04,    # 請購日期
                                  pmk09 LIKE pmk_file.pmk09,    # FUN-4C0095
                                  pmc03 LIKE pmc_file.pmc03,    # 供應廠商
                                  pmksseq LIKE pmk_file.pmksseq,# 已簽核順序
                                  pmksmax LIKE pmk_file.pmksmax,# 應簽核順序
                                  pmk22 LIKE pmk_file.pmk22,    # 幣別
                                  pmk40 LIKE pmk_file.pmk40,    # 總金額
                                  pmkprit LIKE pmk_file.pmkprit,#優先等級
                                  days  LIKE type_file.num5     #No.FUN-680136 SMALLINT
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmk01
  FORMAT
   PAGE HEADER
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = tm.azc03
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT ' ',g_x[11] CLIPPED,tm.azc03,'     ',g_x[12] CLIPPED,l_gen02
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
ON EVERY ROW
         PRINT COLUMN g_c[31],sr.pmk01,
               COLUMN g_c[32],sr.pmk02,
               COLUMN g_c[33],sr.pmk04,
               COLUMN g_c[34],sr.pmk09,
               COLUMN g_c[35],sr.pmc03,
               COLUMN g_c[36],sr.pmksseq USING '&',
               COLUMN g_c[37],sr.pmksmax USING '#',
               COLUMN g_c[38],sr.pmk22,
               COLUMN g_c[39],sr.pmkprit,
               COLUMN g_c[40],sr.days
         LET sr.pmk40 = 0
  #      LET sr.pmk41 = 0
      LET l_last_sw = 'n'
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash
#             IF tm.wc[001,070] > ' ' THEN			# for 80
#	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
# 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN			# for 132
#		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
       END IF
       PRINT g_dash
       LET l_last_sw = 'y'
       #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[7] CLIPPED  #TQC-5B0037 mark
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #TQC-5B0037 add
 
PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash
             #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED  #TQC-5B0037 mark
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0037 add
        ELSE SKIP 2 LINES
     END IF
END REPORT
#Patch....NO.TQC-610036 <001> #
