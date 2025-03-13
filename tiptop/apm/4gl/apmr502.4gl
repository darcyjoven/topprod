# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: apmr502.4gl
# Descriptions...: 料件採購明細列印
# Input parameter:
# Date & Author..: 91/11/07 By May
# Modify.........: 99/04/16 By Carol:modify s_pmmsta()
# Modify.........: No.FUN-4C0095 05/01/03 By Mandy 報表修正
# Modify.........: No.FUN-510026 05/01/13 By CoCo 匯率呼叫cl_numfor來format
# Modify.........: No.FUN-580004 05/08/08 By day 報表轉xml
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-840039 08/04/18 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B10173 11/01/18 By lilingyu 輸入完QBE條件後,報錯"foreach字符串轉換日期錯誤"
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004-begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5   #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004-end
 
   DEFINE tm  RECORD				# Print condition RECORD
	   #	wc   VARCHAR(500),		# Where condition 
		wc  	STRING,	        	#TQC-630166  # Where condition
   		y   	LIKE type_file.chr1   , #No.FUN-680136 VARCHAR(1)  # Input more condition(Y/N)
   		t   	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  # Input more condition(Y/N)
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  # Input more condition(Y/N)
              END RECORD,
          g_azm03        LIKE type_file.num5,   #No.FUN-680136 SMALLINT # 季別
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_total        LIKE tlf_file.tlf18    #No.FUN-680136 DECIMAL(13,3)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115      #No.FUN-580004
DEFINE   g_sql           STRING     #NO.FUN-840039
DEFINE   g_str           STRING     #NO.FUN-840039
DEFINE   l_table         STRING     #NO.FUN-840039
DEFINE   l_table1        STRING     #NO.FUN-840039
DEFINE   l_table2        STRING     #NO.FUN-840039
DEFINE   l_table3        STRING     #NO.FUN-840039
DEFINE   l_table4        STRING     #NO.FUN-840039
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
   #No.FUN-840039----BEGIN----
   LET g_sql =  "pmm01.pmm_file.pmm01,",
                "pmm04.pmm_file.pmm04,",
                "pmm03.pmm_file.pmm03,",
                "pmm08.pmm_file.pmm08,",
                "pmm09.pmm_file.pmm09,",
                "pmm10.pmm_file.pmm10,",
                "pmm11.pmm_file.pmm11,",
                "pmm16.pmm_file.pmm16,",
                "pmm17.pmm_file.pmm17,",
                "pmm20.pmm_file.pmm20,",
                "pmm21.pmm_file.pmm21,",
                "pmm22.pmm_file.pmm22,",
                "pmm25.pmm_file.pmm25,",
                "pmm42.pmm_file.pmm42,",
                "pmc03.pmc_file.pmc03,",
                "pmc15.pmc_file.pmc15,",
                "pmc081.pmc_file.pmc081,",
                "pmc082.pmc_file.pmc082,",
                "pmc091.pmc_file.pmc091,",
                "pmc092.pmc_file.pmc092,",
                "pmc093.pmc_file.pmc093,",
                "pmc094.pmc_file.pmc094,",
                "pmc095.pmc_file.pmc095,",
                "pmc10.pmc_file.pmc10,",
                "pmc11.pmc_file.pmc11,",
                "pmc12.pmc_file.pmc12,",
                "pmc13.pmc_file.pmc13,",
                "pmc16.pmc_file.pmc16,",
                "pmc17.pmc_file.pmc17,",
                "pmc18.pmc_file.pmc18,",
                "pmc19.pmc_file.pmc19,",
                "pmc20.pmc_file.pmc20,",
                "pmc21.pmc_file.pmc21,",
                "pmc22.pmc_file.pmc22,",
                "pmc24.pmc_file.pmc24,",
                "pmc26.pmc_file.pmc26,",
                "pmc27.pmc_file.pmc27,",
                "pmc28.pmc_file.pmc28,",
                "pmc40.pmc_file.pmc40,",
                "pmc41.pmc_file.pmc41,",
                "pmc42.pmc_file.pmc42,",
                "pmc43.pmc_file.pmc43,",
                "pmc55.pmc_file.pmc55,",
                "pmc14.pmc_file.pmc14,",
                "pmmprno.pmm_file.pmmprno,",
                "pmc44.pmc_file.pmc44,",                               
                "gem02.gem_file.gem02,",
                "gen02.gen_file.gen02,",
                "gem02_1.gem_file.gem02,",
                "gen02_1.gen_file.gen02,",
                "pme031_1.pme_file.pme031,",
                "pme032_1.pme_file.pme032,",
                "pme033_1.pme_file.pme033,",
                "pme034_1.pme_file.pme034,",
                "pme035_1.pme_file.pme035,",
                "pme031_2.pme_file.pme031,",
                "pme032_2.pme_file.pme032,",
                "pme033_2.pme_file.pme033,",
                "pme034_2.pme_file.pme034,",
                "pme035_2.pme_file.pme035,",
                "pme031_3.pme_file.pme031,",
                "pme032_3.pme_file.pme032,",
                "pme033_3.pme_file.pme033,",
                "pme034_3.pme_file.pme034,",
                "pme035_3.pme_file.pme035,",
                "pme031_4.pme_file.pme031,",
                "pme032_4.pme_file.pme032,",
                "pme033_4.pme_file.pme033,",
                "pme034_4.pme_file.pme034,",
                "pme035_4.pme_file.pme035,",
                "pmn02.pmn_file.pmn02,",
                "pmn25.pmn_file.pmn25,",
                "pmn04.pmn_file.pmn04,",
                "pmn07.pmn_file.pmn07,",
                "pmn011.pmn_file.pmn011,",
                "pmn31.pmn_file.pmn31,",
                "pmn20.pmn_file.pmn20,",
                "str2.type_file.chr1000,",
                "ima02.ima_file.ima02,",
                "l_pmm25.ze_file.ze03,",
                "ima021.ima_file.ima021,",
                "pmn44.pmn_file.pmn44,",
                "pmn51.pmn_file.pmn51,",
                "pmn53.pmn_file.pmn53,",
                "pmn55.pmn_file.pmn55,",
                "pmn50.pmn_file.pmn50,",
                "azi03.azi_file.azi03"
   LET l_table = cl_prt_temptable('apmr502',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmo03.pmo_file.pmo03,",
               "pmo04.pmo_file.pmo04,",
               "pmo06.pmo_file.pmo06"
 
   LET l_table1 = cl_prt_temptable('apmr502_1',g_sql)                                                                               
   IF l_table1 = -1 THEN EXIT PROGRAM END IF 
   #NO.FUN-840039----END----
 
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r502_tm(0,0)		        # Input print condition
      ELSE CALL apmr502()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r502_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 16
 
   OPEN WINDOW r502_w AT p_row,p_col WITH FORM "apm/42f/apmr502"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET tm.y    = '5'
   LET g_pdate = g_today
   LET g_rlang = g_lang
#  LET g_prtway= "Q"
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm09,pmm12
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
      LET INT_FLAG = 0 CLOSE WINDOW r502_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME  tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more      #輸入其它特殊列印條件
         IF tm.more  NOT MATCHES '[YN]' OR tm.more IS NULL  THEN
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
      LET INT_FLAG = 0 CLOSE WINDOW r502_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr502'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr502','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmr502',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r502_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr502()
   ERROR ""
END WHILE
   CLOSE WINDOW r502_w
END FUNCTION
 
FUNCTION apmr502()
   DEFINE l_name	LIKE type_file.chr20, 	    # External(Disk) file name      #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	    # Used time for running the job #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	    # RDSQL STATEMENT               #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,     #No.FUN-680136 VARCHAR(40)

          sr              RECORD
                                  pmm01  LIKE pmm_file.pmm01,
                                  pmm02  LIKE pmm_file.pmm02,
                                  pmm04  LIKE pmm_file.pmm04,
                                  pmm03  LIKE pmm_file.pmm03,
                                  pmm08  LIKE pmm_file.pmm08,
                                  pmm09  LIKE pmm_file.pmm09,
                                  pmm10  LIKE pmm_file.pmm10,
                                  pmm11  LIKE pmm_file.pmm11,                                 
                                  pmm12  LIKE pmm_file.pmm12,
                                  pmm13  LIKE pmm_file.pmm13,
                                  pmm14  LIKE pmm_file.pmm14,
                                  pmm15  LIKE pmm_file.pmm15,                                 
                                  pmm16  LIKE pmm_file.pmm16,
                                  pmm17  LIKE pmm_file.pmm17,
                                  pmm20  LIKE pmm_file.pmm20,
                                  pmm21  LIKE pmm_file.pmm21,
                                  pmm22  LIKE pmm_file.pmm22,
                                  pmm25  LIKE pmm_file.pmm25,
                                  pmm42  LIKE pmm_file.pmm42,
                                  pmc03  LIKE pmc_file.pmc03,
                                  pmc15  LIKE pmc_file.pmc15,
                                  pmc081 LIKE pmc_file.pmc081,
                                  pmc082 LIKE pmc_file.pmc082,
                                  pmc091 LIKE pmc_file.pmc091,
                                  pmc092 LIKE pmc_file.pmc092,
                                  pmc093 LIKE pmc_file.pmc093,
                                  pmc094 LIKE pmc_file.pmc094,
                                  pmc095 LIKE pmc_file.pmc095,
                                  pmc10  LIKE pmc_file.pmc10,
                                  pmc11  LIKE pmc_file.pmc11,
                                  pmc12  LIKE pmc_file.pmc12,
                                  pmc13  LIKE pmc_file.pmc13,
                                  pmc16  LIKE pmc_file.pmc16,
                                  pmc17  LIKE pmc_file.pmc17,
                                  pmc18  LIKE pmc_file.pmc18,
                                  pmc19  LIKE pmc_file.pmc19,
                                  pmc20  LIKE pmc_file.pmc20,
                                  pmc21  LIKE pmc_file.pmc21,
                                  pmc22  LIKE pmc_file.pmc22,
                                  pmc24  LIKE pmc_file.pmc24,
                                  pmc26  LIKE pmc_file.pmc26,
                                  pmc27  LIKE pmc_file.pmc27,
                                  pmc28  LIKE pmc_file.pmc28,
#                                 pmc30  LIKE pmc_file.pmc30,      #TQC-B10173 
                                  pmc40  LIKE pmc_file.pmc40,
                                  pmc41  LIKE pmc_file.pmc41,
                                  pmc42  LIKE pmc_file.pmc42,
                                  pmc43  LIKE pmc_file.pmc43,
                                  pmc55  LIKE pmc_file.pmc55,
                                  pmc14  LIKE pmc_file.pmc14,
                                  pmmprno LIKE pmm_file.pmmprno,
                                  pmc44  LIKE pmc_file.pmc44,
                                  pmm18  LIKE pmm_file.pmm18
                                 ,pmmmksg  LIKE pmm_file.pmmmksg      
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5      #No.FUN-580004   #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580004
     #NO.FUN-840039----BEGIN----
     DEFINE l_pme031_1    LIKE pme_file.pme031,
            l_pme032_1    LIKE pme_file.pme032,
            l_pme033_1    LIKE pme_file.pme033,
            l_pme034_1    LIKE pme_file.pme034,
            l_pme035_1    LIKE pme_file.pme035,
            l_pme031_2    LIKE pme_file.pme031,
            l_pme032_2    LIKE pme_file.pme032,
            l_pme033_2    LIKE pme_file.pme033,
            l_pme034_2    LIKE pme_file.pme034,
            l_pme035_2    LIKE pme_file.pme035,
            l_pme031_3    LIKE pme_file.pme031,
            l_pme032_3    LIKE pme_file.pme032,
            l_pme033_3    LIKE pme_file.pme033,
            l_pme034_3    LIKE pme_file.pme034,
            l_pme035_3    LIKE pme_file.pme035,
            l_pme031_4    LIKE pme_file.pme031,
            l_pme032_4    LIKE pme_file.pme032,
            l_pme033_4    LIKE pme_file.pme033,
            l_pme034_4    LIKE pme_file.pme034,
            l_pme035_4    LIKE pme_file.pme035,
            l_gem02       LIKE gem_file.gem02,
            l_gen02       LIKE gen_file.gen02,
            l_gem02_1       LIKE gem_file.gem02,
            l_gen02_1       LIKE gen_file.gen02,
            l_pmn02       LIKE pmn_file.pmn02,
            #l_sql1        LIKE type_file.chr1000, 
            #l_sql2        LIKE type_file.chr1000,
            l_sql1        STRING,       #NO.FUN-910082
            l_sql2        STRING,       #NO.FUN-910082 
            l_str2       LIKE type_file.chr1000,
            l_ac          LIKE type_file.num5,
            sr1             RECORD
                                  pmm22  LIKE pmm_file.pmm22,
                                  pmn02  LIKE pmn_file.pmn02,
                                  pmn25  LIKE pmn_file.pmn25,
                                  pmn04  LIKE pmn_file.pmn04,
                                  pmn07  LIKE pmn_file.pmn07,
                                  pmn011 LIKE pmn_file.pmn011,
                                  pmn31  LIKE pmn_file.pmn31,
                                  pmn20  LIKE pmn_file.pmn20,
                                  ima02  LIKE ima_file.ima02,
                                  ima021  LIKE ima_file.ima021, #FUN-4C0095
                                  pmn44  LIKE pmn_file.pmn44,
                                  pmn51  LIKE pmn_file.pmn51,
                                  pmn53  LIKE pmn_file.pmn53,
                                  pmn55  LIKE pmn_file.pmn55,
                                  pmn50  LIKE pmn_file.pmn50,
                                  pmn16  LIKE pmn_file.pmn16,
                                  pmn80  LIKE pmn_file.pmn80,
                                  pmn82  LIKE pmn_file.pmn82,
                                  pmn83  LIKE pmn_file.pmn83,
                                  pmn85  LIKE pmn_file.pmn85
                          END RECORD,
          l_status      LIKE type_file.chr1,
          l_ima021     LIKE ima_file.ima021,
          l_ima906     LIKE ima_file.ima906,
          l_pmn85      STRING,
          l_pmn82      STRING,
          l_pmn20      STRING,
          l_pmm25       LIKE ze_file.ze03,
          l_ima02     LIKE ima_file.ima02
     #NO.FUN-840039----END------
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT sma115 INTO g_sma115 FROM sma_file  #No.FUN-580004
 
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
 
     #NO.FUN-840039----BEGIN---
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               " ?, ?, ?, ?, ?)"                                                                                                                            
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM                                                                                                                 
     END IF
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                
               " VALUES(?, ?, ?, ?)"                                                                                                   
     PREPARE insert_prep1 FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep1:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM                                                                                                                
     END IF
 
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     #NO.FUN-840039----END----
     LET l_sql = " SELECT ",
                 " pmm01,pmm02,pmm04,pmm03,pmm08,pmm09,pmm10,pmm11,",
                 " pmm12,pmm13,pmm14,pmm15,",      #TQC-B10173 add
                 " pmm16,pmm17,pmm20,pmm21,",
                 " pmm22,pmm25,pmm42,pmc03,pmc15,pmc081,pmc082,",
                 " pmc091,pmc092,pmc093,pmc094,pmc095,pmc10,pmc11,pmc12,",
                 " pmc13,pmc16,pmc17,pmc18,pmc19,pmc20,pmc21,",
                 " pmc22,pmc24,pmc26,pmc27,pmc28,pmc40,pmc41,pmc42,",
                 " pmc43,pmc55,pmc14,pmmprno,pmc44,pmm18,pmmmksg ",      #TQC-B10173 add pmmmksg
                 " FROM pmm_file,pmc_file",
                 " WHERE pmc01 = pmm09  ",
                 "  AND pmm18 <> 'X' AND ",tm.wc CLIPPED
     LET l_sql = l_sql CLIPPED, ' ORDER BY pmm01 '
     PREPARE r502_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r502_cs  CURSOR FOR r502_prepare
#    LET l_name = 'apmr502.out'
#    CALL cl_outnam('apmr502') RETURNING l_name    #NO.FUN-840039
 
#No.FUN-580004-begin
#NO.FUN-840039----GEGIN---mark---
#     IF g_sma115 = "Y" THEN  #是否顯示單位注解
#            LET g_zaa[90].zaa06 = "N"
#     ELSE
#            LET g_zaa[90].zaa06 = "Y"
#     END IF
#     CALL cl_prt_pos_len()
#NO.FUN-840039----END-----------------
#No.FUN-580004-end
#     START REPORT r502_rep TO l_name     #NO.FUN-840039
#     LET g_pageno = 0                    #NO.FUN-840039
 
     FOREACH r502_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.pmm01 IS NULL THEN LET sr.pmm01 = ' ' END IF
 
       #NO.FUN-840039----begin----
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.pmm13
       IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.pmm15
       IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
       
       SELECT gem02 INTO l_gem02_1 FROM gem_file WHERE gem01 = sr.pmm14
       IF SQLCA.sqlcode THEN LET l_gem02_1 = NULL END IF
       SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = sr.pmm12
       IF SQLCA.sqlcode THEN LET l_gen02_1 = NULL END IF
 
       CALL get_pme_file(sr.pmm10,'0','2') 
              RETURNING l_pme031_1,l_pme032_1,l_pme033_1,l_pme034_1,l_pme035_1    
       CALL get_pme_file(sr.pmm10,'1','2')                                                                                          
              RETURNING l_pme031_2,l_pme032_2,l_pme033_2,l_pme034_2,l_pme035_2
       CALL get_pme_file(sr.pmc15,'0','2')                                                                                          
              RETURNING l_pme031_3,l_pme032_3,l_pme033_3,l_pme034_3,l_pme035_3
       CALL get_pme_file(sr.pmc15,'1','2')                                                                                          
              RETURNING l_pme031_4,l_pme032_4,l_pme033_4,l_pme034_4,l_pme035_4
      
       #CALL get_pmm_file(sr.pmm01,sr.pmm02,sr.pmm18,sr.pmmmksg)
       LET l_sql1 = " SELECT ",
                    " pmm22,pmn02,pmn25,pmn04,pmn07,pmn011,pmn31,pmn20,",
                    " ima02,ima021,pmn44,pmn51,pmn53,",  
                    " pmn55,pmn50,pmn16,pmn80,pmn82,pmn83,pmn85 ", 
                    " FROM pmm_file,pmn_file,ima_file ",
                    " WHERE pmm01=pmn01 AND pmn01 = '",sr.pmm01,"'",
                    " AND pmn04 = ima01"
      IF sr.pmm02 = 'BKR' THEN
         LET l_sql1  =  l_sql1 CLIPPED," AND pmn011 = 'REG ' ",
                     " ORDER BY pmn02"
      ELSE  
         LET l_sql1 = l_sql1 CLIPPED , " ORDER BY pmn02"  
      END IF
      LET l_ac = 1
      PREPARE r502_pre1  FROM l_sql1
      iF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  
         EXIT PROGRAM 
      END IF
      DECLARE r502_cs1 CURSOR FOR r502_pre1
      FOREACH r502_cs1 INTO sr1.*
         IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
         IF SQLCA.sqlcode = 100 THEN LET l_status = 'N' ELSE LET  l_status ='Y'END IF
         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 
              FROM azi_file 
                WHERE azi01=sr1.pmm22
         SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr1.pmn04
         IF g_sma115 = "Y" THEN
              CASE l_ima906
	            WHEN "2"
	                CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85
	                LET l_str2 = l_pmn85 , sr1.pmn83  CLIPPED
	                IF cl_null(sr1.pmn85) OR sr1.pmn85  = 0 THEN
	                    CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82
	                    LET l_str2 = l_pmn82,sr1.pmn80  CLIPPED
	                ELSE
	                   IF NOT cl_null(sr1.pmn82) AND sr1.pmn82 > 0 THEN
	                      CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82
	                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82,sr1.pmn80  CLIPPED
	                   END IF
	                END IF
	            WHEN "3"
	                IF NOT cl_null(sr1.pmn85) AND sr1.pmn85 > 0 THEN
	                    CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85
	                    LET l_str2 = l_pmn85  , sr1.pmn83  CLIPPED
	                END IF
             END CASE
         END IF
         CALL s_pmmsta('pmm',sr1.pmn16,sr.pmm18,sr.pmmmksg)
                         RETURNING l_pmm25
         EXECUTE insert_prep USING 
            sr.pmm01,sr.pmm04,sr.pmm03,sr.pmm08,                                                      
            sr.pmm09,sr.pmm10,sr.pmm11,sr.pmm16,sr.pmm17,
            sr.pmm20,sr.pmm21,sr.pmm22,sr.pmm25,sr.pmm42,                                                         
            sr.pmc03,sr.pmc15,sr.pmc081,sr.pmc082,sr.pmc091,
            sr.pmc092,sr.pmc093,sr.pmc094,sr.pmc095,sr.pmc10,
            sr.pmc11,sr.pmc12,sr.pmc13,sr.pmc16,sr.pmc17,
            sr.pmc18,sr.pmc19,sr.pmc20,sr.pmc21,sr.pmc22,
            sr.pmc24,sr.pmc26,sr.pmc27,sr.pmc28,sr.pmc40,
            sr.pmc41,sr.pmc42,sr.pmc43,sr.pmc55,sr.pmc14,
            sr.pmmprno,sr.pmc44,l_gem02,l_gen02,l_gem02_1,
            l_gen02_1,l_pme031_1,l_pme032_1,l_pme033_1,l_pme034_1,
            l_pme035_1,l_pme031_2,l_pme032_2,l_pme033_2,l_pme034_2,
            l_pme035_2,l_pme031_3,l_pme032_3,l_pme033_3,l_pme034_3,
            l_pme035_3,l_pme031_4,l_pme032_4,l_pme033_4,l_pme034_4,
            l_pme035_4,sr1.pmn02,sr1.pmn25,sr1.pmn04,sr1.pmn07,
            sr1.pmn011,sr1.pmn31,sr1.pmn20,l_str2,l_ima02,
            l_pmm25,l_ima021,sr1.pmn44,sr1.pmn51,sr1.pmn53,
            sr1.pmn55,sr1.pmn50,t_azi03 
       END FOREACH 
       CALL insert_pmo_file(sr.pmm01)
       #NO.FUN-840039----end------
     END FOREACH
     #NO.FUN-840039----begin--------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", 
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,           
                 "   WHERE pmo03 =0 AND pmo04='1'","|",                             
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,           
                 "   WHERE pmo03!=0 AND pmo04='0'","|",                             
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,           
                 " WHERE pmo03!=0 AND pmo04='1'","|",                             
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,           
                 " WHERE pmo03 =0 AND pmo04='1'" 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm09,pmm12')
            RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('apmr502','apmr502',g_sql,g_str)
     #NO.FUN-840039----end----
#     FINISH REPORT r502_rep                       #NO.FUN-840039 
#     ERROR ' '                                    #NO.FUN-840039
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #NO.FUN-840039
END FUNCTION
#NO.FUN-840039------BEGIN-----
#desc:根據采購單號p_pmm01得到采購單特別說明的資料，并記錄到臨時表中
FUNCTION insert_pmo_file(p_pmm01)              
   DEFINE p_pmm01       LIKE pmm_file.pmm01,
          g_pmo03       LIKE pmo_file.pmo03,
          l_cunt        LIKE type_file.num5,
          l_sql2        STRING,
          l_status      LIKE type_file.chr1,
          sr2           RECORD
                            pmo01  LIKE pmo_file.pmo01,
                            pmo03  LIKE pmo_file.pmo03,
                            pmo04  LIKE pmo_file.pmo04,
                            pmo06  LIKE pmo_file.pmo06
                        END RECORD          
   LET l_sql2 = " SELECT ",
                 " pmo01,pmo03,pmo04,pmo06 ",
                 " FROM pmo_file",
                 " WHERE pmo01 = '", p_pmm01,"' AND pmo02 = '1'",
                 " ORDER BY pmo03"
     LET g_pmo03 = 1000
     LET l_cunt   = 0
     PREPARE r502_pre2  FROM l_sql2
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r502_cs2 CURSOR FOR r502_pre2
     FOREACH r502_cs2 INTO sr2.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF SQLCA.sqlcode = 100 THEN
          LET l_status = 'N'
       ELSE 
          LET  l_status ='Y'
       END IF
       
       LET  l_cunt = l_cunt + 1
       LET g_pmo03 = sr2.pmo03
       EXECUTE insert_prep1 USING sr2.pmo01,sr2.pmo03,sr2.pmo04,sr2.pmo06
     END FOREACH  
END FUNCTION 
#由p_pmm01,p_pmm02作為條件來獲取pmm_file中的資料，并處理
#FUNCTION get_pmm_file(p_pmm01,p_pmm02,p_pmm18,p_pmmmksg)
#  DEFINE p_pmm01     LIKE pmm_file.pmm01,
#         p_pmm02     LIKE pmm_file.pmm02,
#         p_pmm18     LIKE pmm_file.pmm18,
#         p_pmmmksg   LIKE pmm_file.pmmmksg,
#         sr1          RECORD
#                                 pmn01  LIKE pmn_file.pmn01,
#                                 pmm22  LIKE pmm_file.pmm22,
#                                 pmn02  LIKE pmn_file.pmn02,
#                                 pmn25  LIKE pmn_file.pmn25,
#                                 pmn04  LIKE pmn_file.pmn04,
#                                 pmn07  LIKE pmn_file.pmn07,
#                                 pmn011 LIKE pmn_file.pmn011,
#                                 pmn31  LIKE pmn_file.pmn31,
#                                 pmn20  LIKE pmn_file.pmn20,
#                                 ima02  LIKE ima_file.ima02,
#                                 ima021  LIKE ima_file.ima021,
#                                 pmn44  LIKE pmn_file.pmn44,
#                                 pmn51  LIKE pmn_file.pmn51,
#                                 pmn53  LIKE pmn_file.pmn53,
#                                 pmn55  LIKE pmn_file.pmn55,
#                                 pmn50  LIKE pmn_file.pmn50,
#                                 pmn16  LIKE pmn_file.pmn16,
#                                 pmn80  LIKE pmn_file.pmn80,
#                                 pmn82  LIKE pmn_file.pmn82,
#                                 pmn83  LIKE pmn_file.pmn83,
#                                 pmn85  LIKE pmn_file.pmn85
#                         END RECORD
#  DEFINE   l_str2       LIKE type_file.chr1000,
#           l_ima906     LIKE ima_file.ima906,
#           l_pmn85      STRING,
#           l_pmn82      STRING,
#           l_sql1       STRING,
#           l_status     STRING,
#           l_pmm25      LIKE pmm_file.pmm25,
#           l_ima021     LIKE ima_file.ima021,
#           l_ima02      LIKE ima_file.ima02
#  LET l_sql1 = " SELECT pmn01",                                                                                                     
#               " pmm22,pmn02,pmn25,pmn04,pmn07,pmn011,pmn31,pmn20,",  
#               " ima02,ima021,pmn44,pmn51,pmn53,",                                                                
#               " pmn55,pmn50,pmn16,pmn80,pmn82,pmn83,pmn85 ",                                                 
#               " FROM pmm_file,pmn_file,ima_file ",                                                                            
#               " WHERE pmm01=pmn01 AND pmn01 = '",p_pmm01,"'",                                                                
#               " AND pmn04 = ima01" 
#  IF p_pmm02 = 'BKR' THEN                                                                                                      
#     LET l_sql1  =  l_sql1 CLIPPED," AND pmn011 = 'REG ' ",                                                                     
#                    " ORDER BY pmn02"                                                                                           
#  ELSE                                                                                                                          
#     LET l_sql1 = l_sql1 CLIPPED , " ORDER BY pmn02"                                                                            
#  END IF                                                                                                                        
#  PREPARE r502_pre1  FROM l_sql1                                                                                                
#  IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)                                                            
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119                                                              
#     EXIT PROGRAM                                                                                                               
#  END IF                                                                                                                        
#  DECLARE r502_cs1 CURSOR FOR r502_pre1
#  FOREACH r502_cs1 INTO sr1.*
#     IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
#     IF SQLCA.sqlcode = 100 THEN LET l_status = 'N' ELSE LET  l_status ='Y'END IF        
#     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 
#         FROM azi_file 
#            WHERE azi01=sr1.pmm22
 
#     SELECT ima021 INTO l_ima906 FROM ima_file WHERE ima01=sr1.pmn04
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#              CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85
#              LET l_str2 = l_pmn85 , sr1.pmn83  CLIPPED
#              IF cl_null(sr1.pmn85) OR sr1.pmn85  = 0 THEN
#                 CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82
#                 LET l_str2 = l_pmn82,sr1.pmn80  CLIPPED
#              ELSE
#                 IF NOT cl_null(sr1.pmn82) AND sr1.pmn82 > 0 THEN
#                    CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82
#                    LET l_str2 = l_str2 CLIPPED,',',l_pmn82,sr1.pmn80  CLIPPED
#                 END IF
#              END IF
#           WHEN "3"
#              IF NOT cl_null(sr1.pmn85) AND sr1.pmn85 > 0 THEN
#                 CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85
#                 LET l_str2 = l_pmn85  , sr1.pmn83  CLIPPED
#              END IF
#        END CASE
#     END IF
#     CALL s_pmmsta('pmm',sr1.pmn16,p_pmm18,p_pmmmksg)
#                        RETURNING l_pmm25
#     EXECUTE insert_prep1 USING sr1.pmn01,sr1.pmn02,sr1.pmn25,sr1.pmn04,                                                          
#           sr1.pmn07,sr1.pmn011,sr1.pmn31,sr1.pmn20,l_ima02,l_ima021,                                                              
#           l_pmm25,sr1.pmn44,sr1.pmn51,sr1.pmn53,sr1.pmn55,sr1.pmn50,t_azi03
#  END FOREACH
#END FUNCTION
#由p_var1,p_var2做為條件獲取pme_file資料
FUNCTION get_pme_file(p_var1,p_var2,p_var3)
    DEFINE  p_var3,p_var2   LIKE pme_file.pme02
    DEFINE  p_var1          LIKE pmm_file.pmm10
    DEFINE  l_pme031        LIKE pme_file.pme031,
            l_pme032        LIKE pme_file.pme032,
            l_pme033        LIKE pme_file.pme033,
            l_pme034        LIKE pme_file.pme034,
            l_pme035        LIKE pme_file.pme035
    SELECT pme031,pme032,pme033,pme034,pme035 INTO                                                                               
              l_pme031,l_pme032,l_pme033,l_pme034,l_pme035                                                                
              FROM pme_file WHERE pme01 = p_var1                                                                                  
              AND (pme02 = p_var2 OR pme02 = p_var3)                                                                                      
    IF SQLCA.sqlcode THEN                                                                                                        
       LET l_pme031 = NULL                                                                                                   
       LET l_pme032 = NULL                                                                                                   
       LET l_pme033 = NULL                                                                                                   
       LET l_pme034 = NULL                                                                                                   
       LET l_pme035 = NULL                                                                                                   
    END IF
    RETURN l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
END FUNCTION
#NO.FUN-840039----END-----
REPORT r502_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,                 #No.FUN-680136 VARCHAR(1)
          l_pmn02       ARRAY[40] of LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_ac          LIKE type_file.num5,                 #No.FUN-680136 SMALLINT
          l_sql1        LIKE type_file.chr1000,              #No.FUN-680136 VARCHAR(1000)
          l_sql2        LIKE type_file.chr1000,              #No.FUN-680136 VARCHAR(1000)
          l_pmm25       LIKE ze_file.ze03,                   #No.FUN-680136 VARCHAR(12)
          l_status      LIKE type_file.chr1,                 #No.FUN-680136 VARCHAR(1)
          l_cunt        LIKE type_file.num5,                 #No.FUN-680136 SMALLINT
          l_gem02       LIKE gem_file.gem02,
          l_gen02       LIKE gen_file.gen02,
          l_pme031_1    LIKE pme_file.pme031,
          l_pme032_1    LIKE pme_file.pme032,
          l_pme033_1    LIKE pme_file.pme033,
          l_pme034_1    LIKE pme_file.pme034,
          l_pme035_1    LIKE pme_file.pme035,
          l_pme031_2    LIKE pme_file.pme031,
          l_pme032_2    LIKE pme_file.pme032,
          l_pme033_2    LIKE pme_file.pme033,
          l_pme034_2    LIKE pme_file.pme034,
          l_pme035_2    LIKE pme_file.pme035,
          g_pmo03       LIKE pmo_file.pmo03,
          sr1             RECORD
                                  pmm22  LIKE pmm_file.pmm22,
                                  pmn02  LIKE pmn_file.pmn02,
                                  pmn25  LIKE pmn_file.pmn25,
                                  pmn04  LIKE pmn_file.pmn04,
                                  pmn07  LIKE pmn_file.pmn07,
                                  pmn011 LIKE pmn_file.pmn011,
                                  pmn31  LIKE pmn_file.pmn31,
                                  pmn20  LIKE pmn_file.pmn20,
                                  ima02  LIKE ima_file.ima02,
                                  ima021  LIKE ima_file.ima021, #FUN-4C0095
                                  pmn44  LIKE pmn_file.pmn44,
                                  pmn51  LIKE pmn_file.pmn51,
                                  pmn53  LIKE pmn_file.pmn53,
                                  pmn55  LIKE pmn_file.pmn55,
                                  pmn50  LIKE pmn_file.pmn50,
                                  pmn16  LIKE pmn_file.pmn16,
                                  #No.FUN-580004-begin
                                  pmn80  LIKE pmn_file.pmn80,
                                  pmn82  LIKE pmn_file.pmn82,
                                  pmn83  LIKE pmn_file.pmn83,
                                  pmn85  LIKE pmn_file.pmn85
                                  #No.FUN-580004-end
                          END RECORD,
          sr2             RECORD
                                  pmo03  LIKE pmo_file.pmo03,
                                  pmo04  LIKE pmo_file.pmo04,
                                  pmo06  LIKE pmo_file.pmo06
                          END RECORD,
          sr              RECORD
                                  pmm01  LIKE pmm_file.pmm01,
                                  pmm02  LIKE pmm_file.pmm02,
                                  pmm04  LIKE pmm_file.pmm04,
                                  pmm03  LIKE pmm_file.pmm03,
                                  pmm08  LIKE pmm_file.pmm08,
                                  pmm09  LIKE pmm_file.pmm09,
                                  pmm10  LIKE pmm_file.pmm10,
                                  pmm11  LIKE pmm_file.pmm11,               
                                 pmm12  LIKE pmm_file.pmm12,
                                 pmm13  LIKE pmm_file.pmm13,
                                 pmm14  LIKE pmm_file.pmm14,
                                 pmm15  LIKE pmm_file.pmm15,                    
                                  pmm16  LIKE pmm_file.pmm16,
                                  pmm17  LIKE pmm_file.pmm17,
                                  pmm20  LIKE pmm_file.pmm20,
                                  pmm21  LIKE pmm_file.pmm21,
                                  pmm22  LIKE pmm_file.pmm22,
                                  pmm25  LIKE pmm_file.pmm25,
                                  pmm42  LIKE pmm_file.pmm42,
                                  pmc03  LIKE pmc_file.pmc03,
                                  pmc15  LIKE pmc_file.pmc15,
                                  pmc081 LIKE pmc_file.pmc081,
                                  pmc082 LIKE pmc_file.pmc082,
                                  pmc091 LIKE pmc_file.pmc091,
                                  pmc092 LIKE pmc_file.pmc092,
                                  pmc093 LIKE pmc_file.pmc093,
                                  pmc094 LIKE pmc_file.pmc094,
                                  pmc095 LIKE pmc_file.pmc095,
                                  pmc10  LIKE pmc_file.pmc10,
                                  pmc11  LIKE pmc_file.pmc11,
                                  pmc12  LIKE pmc_file.pmc12,
                                  pmc13  LIKE pmc_file.pmc13,
                                  pmc16  LIKE pmc_file.pmc16,
                                  pmc17  LIKE pmc_file.pmc17,
                                  pmc18  LIKE pmc_file.pmc18,
                                  pmc19  LIKE pmc_file.pmc19,
                                  pmc20  LIKE pmc_file.pmc20,
                                  pmc21  LIKE pmc_file.pmc21,
                                  pmc22  LIKE pmc_file.pmc22,
                                  pmc24  LIKE pmc_file.pmc24,
                                  pmc26  LIKE pmc_file.pmc26,
                                  pmc27  LIKE pmc_file.pmc27,
                                  pmc28  LIKE pmc_file.pmc28,
#                                 pmc30  LIKE pmc_file.pmc30,   #TQC-B10173 
                                  pmc40  LIKE pmc_file.pmc40,
                                  pmc41  LIKE pmc_file.pmc41,
                                  pmc42  LIKE pmc_file.pmc42,
                                  pmc43  LIKE pmc_file.pmc43,
                                  pmmprno LIKE pmm_file.pmmprno,
                                  pmc44  LIKE pmc_file.pmc44,
                                  pmm18  LIKE pmm_file.pmm18
                                 ,pmmmksg  LIKE pmm_file.pmmmksg  
                        END RECORD
#No.FUN-580004-begin
DEFINE   l_str2       LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(100)
         l_ima021     LIKE ima_file.ima021,
         l_ima906     LIKE ima_file.ima906,
         l_pmn85      STRING,
         l_pmn82      STRING,
         l_pmn20      STRING
#No.FUN-580004-end
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmm01
  FORMAT
   PAGE HEADER
      PRINT  COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      LET g_pageno = g_pageno + 1
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
      PRINT ' '
      PRINT g_x[2] CLIPPED,g_today,'  ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
      PRINT g_dash[1,g_len] CLIPPED
      LET l_last_sw = 'n'
 
BEFORE GROUP  OF sr.pmm01
      IF  (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
ON EVERY ROW
      PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 51,g_x[12] CLIPPED,
            sr.pmm04
      IF sr.pmmprno > 0 THEN PRINT COLUMN 11,g_x[13] CLIPPED;
      ELSE PRINT COLUMN 11,g_x[14] CLIPPED; END IF
      PRINT COLUMN 51,g_x[15] CLIPPED,sr.pmm08
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.pmm13
      IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.pmm15
      IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
      PRINT g_x[16] CLIPPED,l_gem02,COLUMN 26,g_x[17] CLIPPED,
            l_gen02,COLUMN 51,g_x[18] CLIPPED,sr.pmm20
      LET l_gem02 = NULL
      LET l_gen02 = NULL
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.pmm14
      IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.pmm12
      IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
      PRINT g_x[19] CLIPPED,l_gem02,COLUMN 26,g_x[20] CLIPPED,
            l_gen02,COLUMN 51,g_x[21] CLIPPED,sr.pmm21
      LET l_gem02 = NULL
      LET l_gen02 = NULL
 
      PRINT g_x[22] CLIPPED,sr.pmm22,COLUMN 26,g_x[23] CLIPPED,sr.pmm42
 
      PRINT g_x[27] CLIPPED,sr.pmm16,COLUMN 26,g_x[28] CLIPPED,sr.pmm17
       CALL s_pmmsta('pmm',sr.pmm25,sr.pmm18,sr.pmmmksg) RETURNING l_pmm25
       PRINT g_x[32] CLIPPED,l_pmm25
       PRINT g_x[33] CLIPPED,sr.pmm10,COLUMN 42,g_x[34] CLIPPED,sr.pmm11
       SELECT pme031,pme032,pme033,pme034,pme035 INTO
              l_pme031_1,l_pme032_1,l_pme033_1,l_pme034_1,l_pme035_1
              FROM pme_file WHERE pme01 = sr.pmm10
              AND (pme02 = '0' OR pme02 = '2')
       IF SQLCA.sqlcode THEN LET l_pme031_1 = NULL
            LET l_pme032_1 = NULL
            LET l_pme033_1 = NULL
            LET l_pme034_1 = NULL
            LET l_pme035_1 = NULL
       END IF
       SELECT pme031,pme032,pme033,pme034,pme035 INTO
              l_pme031_2,l_pme032_2,l_pme033_2,l_pme034_2,l_pme035_2
              FROM pme_file WHERE pme01 = sr.pmm10
              AND (pme02 = '1' OR pme02 = '2')
       IF SQLCA.sqlcode THEN LET l_pme031_2 = NULL
            LET l_pme032_2 = NULL
            LET l_pme033_2 = NULL
            LET l_pme034_2 = NULL
            LET l_pme035_2 = NULL
       END IF
       PRINT COLUMN 10,l_pme031_1,COLUMN 51,l_pme031_2
       PRINT COLUMN 10,l_pme032_1,COLUMN 51,l_pme032_2
       PRINT COLUMN 10,l_pme033_1,COLUMN 51,l_pme033_2
       PRINT COLUMN 10,l_pme034_1,COLUMN 51,l_pme034_2
       PRINT COLUMN 10,l_pme035_1,COLUMN 51,l_pme035_2
       LET l_pme031_1 = NULL
       LET l_pme032_1 = NULL
       LET l_pme033_1 = NULL
       LET l_pme034_1 = NULL
       LET l_pme035_1 = NULL
       LET l_pme031_2 = NULL
       LET l_pme032_2 = NULL
       LET l_pme033_2 = NULL
       LET l_pme034_2 = NULL
       LET l_pme035_2 = NULL
       SKIP 1 LINE
       PRINT g_x[35] CLIPPED,sr.pmm09,' ',sr.pmc03,
             COLUMN 42,g_x[36] CLIPPED,sr.pmc15
       SELECT pme031,pme032,pme033,pme034,pme035 INTO
              l_pme031_1,l_pme032_1,l_pme033_1,l_pme034_1,l_pme035_1
              FROM pme_file WHERE pme01 = sr.pmc15
              AND (pme02 = '0' OR pme02 = '2')
       IF SQLCA.sqlcode THEN LET l_pme031_1 = NULL
            LET l_pme032_1 = NULL
            LET l_pme033_1 = NULL
            LET l_pme034_1 = NULL
            LET l_pme035_1 = NULL
       END IF
       SELECT pme031,pme032,pme033,pme034,pme035 INTO
              l_pme031_2,l_pme032_2,l_pme033_2,l_pme034_2,l_pme035_2
              FROM pme_file WHERE pme01 =  sr.pmc15
              AND (pme02 = '1' OR pme02 = '2')
       IF SQLCA.sqlcode THEN LET l_pme031_2 = NULL
            LET l_pme032_2 = NULL
            LET l_pme033_2 = NULL
            LET l_pme034_2 = NULL
            LET l_pme035_2 = NULL
       END IF
       PRINT COLUMN 10,sr.pmc081,COLUMN 51,l_pme031_1
       PRINT COLUMN 10,sr.pmc082,COLUMN 51,l_pme032_1
       PRINT g_x[37] CLIPPED,COLUMN 10,sr.pmc091,COLUMN 51,l_pme033_1
       PRINT COLUMN 10,sr.pmc092,COLUMN 51,l_pme034_1
       PRINT COLUMN 10,sr.pmc093,COLUMN 51,l_pme035_1
       PRINT COLUMN 10,sr.pmc094,COLUMN 42,g_x[38] CLIPPED,sr.pmc16
       PRINT COLUMN 10,sr.pmc095,COLUMN 51,l_pme031_2
       PRINT g_x[39] CLIPPED,COLUMN 10,sr.pmc10,COLUMN 51,l_pme032_2
       PRINT g_x[40] CLIPPED,COLUMN 10,sr.pmc11,COLUMN 51,l_pme033_2
       PRINT g_x[41] CLIPPED,COLUMN 10,sr.pmc12,COLUMN 51,l_pme034_2
       PRINT COLUMN 51,l_pme035_2
       LET l_pme031_1 = NULL
       LET l_pme032_1 = NULL
       LET l_pme033_1 = NULL
       LET l_pme034_1 = NULL
       LET l_pme035_1 = NULL
       LET l_pme031_2 = NULL
       LET l_pme032_2 = NULL
       LET l_pme033_2 = NULL
       LET l_pme034_2 = NULL
       LET l_pme035_2 = NULL
       PRINT g_x[42] CLIPPED;
       IF sr.pmc13 = '0' THEN
            PRINT COLUMN 10,g_x[43] CLIPPED;
       END IF
       IF sr.pmc13 = '1' THEN
            PRINT COLUMN 10,g_x[44] CLIPPED;
       END IF
       IF sr.pmc13 = '2' THEN
            PRINT COLUMN 10,g_x[45] CLIPPED;
       END IF
       IF sr.pmc13 = '3' THEN
            PRINT COLUMN 10,g_x[46] CLIPPED;
       END IF
       IF sr.pmc13 = '4' THEN
            PRINT COLUMN 10,g_x[47] CLIPPED;
       END IF
       PRINT COLUMN 28,g_x[48] CLIPPED,sr.pmc20,COLUMN 51,g_x[49] CLIPPED,
             sr.pmc17
       PRINT g_x[50] CLIPPED,sr.pmc18,COLUMN 28,g_x[51] CLIPPED,sr.pmc19,
             COLUMN 51,g_x[52] CLIPPED,sr.pmc24
       PRINT g_x[53] CLIPPED,sr.pmc21,COLUMN 28,g_x[54] CLIPPED,sr.pmc22
       PRINT g_x[55] CLIPPED,sr.pmc21,COLUMN 28,g_x[56] CLIPPED
       PRINT g_x[57] CLIPPED ,sr.pmc26
       PRINT g_x[58] CLIPPED ,sr.pmc27
       PRINT g_x[59] CLIPPED ,sr.pmc28
       PRINT g_x[60] CLIPPED ,sr.pmc40,COLUMN 28,g_x[62] CLIPPED,
             sr.pmc41,COLUMN 51,g_x[63] CLIPPED,sr.pmc42
       PRINT g_x[61] CLIPPED ,sr.pmc43,COLUMN 28,g_x[64] CLIPPED,
             sr.pmc44
      IF  (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
       LET l_sql1 = " SELECT ",
                    " pmm22,pmn02,pmn25,pmn04,pmn07,pmn011,pmn31,pmn20,",
                    " ima02,ima021,pmn44,pmn51,pmn53,", #FUN-4C0095
                    " pmn55,pmn50,pmn16,pmn80,pmn82,pmn83,pmn85 ",  #No.FUN-580004
                    " FROM pmm_file,pmn_file,ima_file ",
                    " WHERE pmm01=pmn01 AND pmn01 = '",sr.pmm01,"'",
                    " AND pmn04 = ima01"
     IF sr.pmm02 = 'BKR' THEN
        LET l_sql1  =  l_sql1 CLIPPED," AND pmn011 = 'REG ' ",
                    " ORDER BY pmn02"
     ELSE  LET l_sql1 = l_sql1 CLIPPED , " ORDER BY pmn02"  END IF
     LET l_ac = 1
     PREPARE r502_pre11  FROM l_sql1
     iF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r502_cs22 CURSOR FOR r502_pre11
#No.FUN-580004-begin
     FOREACH r502_cs22 INTO sr1.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF SQLCA.sqlcode = 100 THEN LET l_status = 'N' ELSE LET  l_status ='Y'END IF
       IF LINENO  < 9 THEN
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,
                COLUMN 60,g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
             PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINTX name=H1 g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                         g_x[89],g_x[90]
          PRINTX name=H2 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95]
          PRINTX name=H3 g_x[96],g_x[97]
          PRINT g_dash1
        END IF
       IF LINENO >57 THEN
       #  SKIP TO TOP OF PAGE
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 60,
                g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINTX name=H1 g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                         g_x[89],g_x[90]
          PRINTX name=H2 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95]
          PRINTX name=H3 g_x[96],g_x[97]
          PRINT g_dash1
       ELSE
       IF LINENO  < 9 THEN
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 60,
                g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINTX name=H1 g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                         g_x[89],g_x[90]
          PRINTX name=H2 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95]
          PRINTX name=H3 g_x[96],g_x[97]
          PRINT g_dash1
         END IF
         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05    #No.CHI-6A0004
           FROM azi_file                 #幣別檔小數位數讀取
          WHERE azi01=sr1.pmm22
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr1.pmn04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85
                LET l_str2 = l_pmn85 , sr1.pmn83  CLIPPED
                IF cl_null(sr1.pmn85) OR sr1.pmn85  = 0 THEN
                    CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82
                    LET l_str2 = l_pmn82,sr1.pmn80  CLIPPED
                ELSE
                   IF NOT cl_null(sr1.pmn82) AND sr1.pmn82 > 0 THEN
                      CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82,sr1.pmn80  CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr1.pmn85) AND sr1.pmn85 > 0 THEN
                    CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85
                    LET l_str2 = l_pmn85  , sr1.pmn83  CLIPPED
                END IF
         END CASE
      ELSE
      END IF
 
          PRINTX name=D1
                COLUMN g_c[83],sr1.pmn02 USING '####',
                COLUMN g_c[84],sr1.pmn25 USING '####',
                COLUMN g_c[85],sr1.pmn04 CLIPPED,
                COLUMN g_c[86],sr1.pmn07 CLIPPED,
                COLUMN g_c[87],sr1.pmn011 CLIPPED,
                COLUMN g_c[88],cl_numfor(sr1.pmn31,88,t_azi03),  #No.CHI-6A0004
                COLUMN g_c[89],cl_numfor(sr1.pmn20,89,3),
                COLUMN g_c[90],l_str2 CLIPPED
          CALL s_pmmsta('pmm',sr1.pmn16,sr.pmm18,sr.pmmmksg)
                         RETURNING l_pmm25
   #每列印一行即做一判斷是否已跳頁是否列印第二張單據的單頭
       IF LINENO  < 9 THEN
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,
                COLUMN 60,g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINTX name=H1 g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                         g_x[89],g_x[90]
          PRINTX name=H2 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95]
          PRINTX name=H3 g_x[96],g_x[97]
          PRINT g_dash1
         END IF
#No.CHI-6A0004-----------Begin----------
#         SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#           FROM azi_file                 #幣別檔小數位數讀取
#          WHERE azi01=g_aza.aza17
#No.CHI-6A0004-----------End------------
          PRINTX name=D2 COLUMN g_c[92],sr1.ima02 CLIPPED,
                COLUMN g_c[93],l_pmm25 CLIPPED,
                COLUMN g_c[94],cl_numfor(sr1.pmn44,94,t_azi03),   #No.CHI-6A0004
                COLUMN g_c[95],cl_numfor(sr1.pmn53,95,3)
          PRINTX name=D3 COLUMN g_c[96],sr1.ima021 CLIPPED
       IF LINENO  < 9 THEN
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 60,
                g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINTX name=H1 g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                         g_x[89],g_x[90]
          PRINTX name=H2 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95]
          PRINTX name=H3 g_x[96],g_x[97]
          PRINT g_dash1
         END IF
        # PRINT g_x[75] CLIPPED,sr1.pmn53 USING '-------&.&&&',
          PRINT COLUMN 01,g_x[72] CLIPPED,cl_numfor(sr1.pmn50,15,3),
                COLUMN 25,g_x[73] CLIPPED,cl_numfor(sr1.pmn51,15,3),
                COLUMN 49,g_x[77] CLIPPED,cl_numfor(sr1.pmn55,15,3)
       IF LINENO  < 9 THEN
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 60,
                g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINTX name=H1 g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                         g_x[89],g_x[90]
          PRINTX name=H2 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95]
          PRINTX name=H3 g_x[96],g_x[97]
          PRINT g_dash1
         END IF
       IF LINENO  < 9 THEN
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 60,
                g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINTX name=H1 g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                         g_x[89],g_x[90]
          PRINTX name=H2 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95]
          PRINTX name=H3 g_x[96],g_x[97]
          PRINT g_dash1
         END IF
       IF LINENO  < 9 THEN
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 60,
                g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINTX name=H1 g_x[83],g_x[84],g_x[85],g_x[86],g_x[87],g_x[88],
                         g_x[89],g_x[90]
          PRINTX name=H2 g_x[91],g_x[92],g_x[93],g_x[94],g_x[95]
          PRINTX name=H3 g_x[96],g_x[97]
          PRINT g_dash1
         END IF
         PRINT g_dash2[1,g_len]
       END IF
    END FOREACH
#No.FUN-580004-end
        IF  (PAGENO > 1 OR LINENO > 9)
           THEN SKIP TO TOP OF PAGE
        END IF
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 60,
                g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINT g_x[81] CLIPPED
          PRINT '----  -  -----------------------------------------------'
      LET l_sql2 = " SELECT ",
                   " pmo03,pmo04,pmo06 ",
                   " FROM pmo_file",
                   " WHERE pmo01 = '", sr.pmm01,"' AND pmo02 = '1'",
                   " ORDER BY pmo03"
        LET g_pmo03 = 1000
     LET l_cunt   = 0
     PREPARE r502_prep2  FROM l_sql2
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r502_csr2 CURSOR FOR r502_prep2
     FOREACH r502_csr2 INTO sr2.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF SQLCA.sqlcode = 100 THEN
          LET l_status = 'N'
      ELSE LET  l_status ='Y'END IF
       IF LINENO >57 THEN
        IF  (PAGENO > 1 OR LINENO > 9) THEN
           SKIP TO TOP OF PAGE
        END IF
          PRINT g_x[11] CLIPPED,sr.pmm01,'-',sr.pmm03,COLUMN 60,
                g_x[12] CLIPPED,sr.pmm04
          IF sr.pmmprno > 0 THEN
              PRINT COLUMN 10,g_x[13] CLIPPED;
          ELSE PRINT COLUMN 10,g_x[14] CLIPPED;
          END IF
          PRINT COLUMN 60,g_x[15] CLIPPED ,sr.pmm08
          PRINT g_dash[1,g_len] CLIPPED
          PRINT g_x[81] CLIPPED
          PRINT '----  -  -----------------------------------------------'
        ELSE
         IF g_pmo03 = 1000 OR g_pmo03 != sr2.pmo03 THEN
              PRINT sr2.pmo03 USING '####','  ',sr2.pmo04;
         END IF
         PRINT COLUMN 10,sr2.pmo06
         LET  l_cunt = l_cunt + 1
       END IF
       LET g_pmo03 = sr2.pmo03
      END FOREACH
      IF l_cunt = 0 THEN PRINT COLUMN 10,g_x[82] CLIPPED END IF
 
 
 AFTER GROUP OF sr.pmm01
      LET g_pageno = 0
 ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-201,240,300
         THEN PRINT g_dash[1,g_len]
         #    IF tm.wc[001,70] > ' ' THEN			# for 80
         #       PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #    IF tm.wc[071,140] > ' ' THEN
         #       PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #    IF tm.wc[141,210] > ' ' THEN
  	 #      PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #    IF tm.wc[211,280] > ' ' THEN
  	 #       PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
		#TQC-630166
		CALL cl_prt_pos_wc(tm.wc)
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
#Patch....NO.TQC-610036 <001> #
#FUN-870144
