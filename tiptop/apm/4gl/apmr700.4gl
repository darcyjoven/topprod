# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr700.4gl
# Descriptions...: 採購單價統計作業
# Input parameter:
# Date & Author..: 91/11/04 By May
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號開窗
# Modify.........: No.FUN-4C0095 04/12/28 By Mandy 報表轉XML
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-580004 05/08/08 By jackie 雙單位報表修改
# Modify.........: No.TQC-5B0212 05/11/30 By kevin 採購項次靠右對齊
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-670100 06/07/24 By Mandy 採購價差原本為pmn31*pmm42 - pmn30 改為pmn44-pmn30
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.TQC-6C0139 06/12/25 By Mandy 標準金額/採購金額/價差金額有誤
# Modify.........: No.FUN-720010 07/02/09 By TSD.Michelle 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5   #No.FUN-680136 #SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD				# Print condition RECORD
	       #wc   VARCHAR(500),		# Where condition   #TQC-630166 mark
		wc  	STRING,		        # Where condition   #TQC-630166
   		more	LIKE type_file.chr1   #No.FUN-680136 #CHAR(1) 		# Input more condition(Y/N)
              END RECORD,
          g_azm03        LIKE type_file.num5,   #No.FUN-680136 #SMALLINT,              # 季別
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_pmm04       LIKE pmm_file.pmm04
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
DEFINE   l_table        STRING,                 ### FUN-720010 ###
         g_str          STRING,                 ### FUN-720010 ###
         g_sql          STRING                  ### FUN-720010 ###
 
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
 
## *** FUN-720010 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Martin  *** ##
    LET g_sql = "pmn01.pmn_file.pmn01,",
                "pmn02.pmn_file.pmn02,",
                "pmn04.pmn_file.pmn04,",
                "pmn07.pmn_file.pmn07,",
                "pmn20.pmn_file.pmn20,",
                "pmn24.pmn_file.pmn24,",
                "pmn30.pmn_file.pmn30,",
                "pmn44.pmn_file.pmn44,",
                "pmm01.pmm_file.pmm01,",
                "pmm04.pmm_file.pmm04,",
                "pmm09.pmm_file.pmm09,",
                "pmn041.pmn_file.pmn041,",
                "ima08.ima_file.ima08,",
                "pmm22.pmm_file.pmm22,",
                "pmm20.pmm_file.pmm20,",
                "pmn31.pmn_file.pmn31,",
                "pmm42.pmm_file.pmm42,",
                "l_pmn01.pmn_file.pmn31,",
                "l_pmn02.pmn_file.pmn31,",
                "l_pmn03.pmn_file.pmn31,",
                "pmc03.pmc_file.pmc03,",
                "pma02.pma_file.pma02,",
                "pmn80.pmn_file.pmn80,",
                "pmn82.pmn_file.pmn82,",
                "pmn83.pmn_file.pmn83,",
                "pmn85.pmn_file.pmn85,",
                "l_ima021.ima_file.ima021,",
                "l_str2.type_file.chr1000,",
                "g_azi03.azi_file.azi03,",
                "g_azi04.azi_file.azi04 " 
               
 
    LET l_table = cl_prt_temptable('apmr700',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ? , ?, ? , ?, ",
                "        ?, ?, ?, ?, ?, ?, ? , ?, ? , ?, ",
                "        ?, ?, ? ,?, ? ,?, ? , ?, ? , ?)"
 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#----------------------------------------------------------CR (1) ------------#
 
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
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r700_tm(0,0)		        # Input print condition
      ELSE CALL apmr700()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r700_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r700_w AT p_row,p_col WITH FORM "apm/42f/apmr700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.more 		# Condition
   CONSTRUCT BY NAME tm.wc ON pmn04,pmn24,pmm01,pmm04,pmm09
     #--No.FUN-4B0022-------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
       CASE WHEN INFIELD(pmn04)      #料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ima1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmn04
                 NEXT FIELD pmn04
       OTHERWISE EXIT CASE
       END CASE
     #--END---------------
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
      LET INT_FLAG = 0 CLOSE WINDOW r700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more      #輸入其它特殊列印條件
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command epmnecution
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
      LET INT_FLAG = 0 CLOSE WINDOW r700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apmr700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr700','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,	#(at time fglgo pmnpmnpmnpmn p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr700',g_time,l_cmd)	# Epmnecute cmd at later time
      END IF
      CLOSE WINDOW r700_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr700()
   ERROR ""
END WHILE
   CLOSE WINDOW r700_w
END FUNCTION
 
FUNCTION apmr700()
   DEFINE l_name	LIKE type_file.chr20, 	      # Epmnternal(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job        #No.FUN-680136 VARCHAR(8))
         #l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT   #TQC-630166 mark        #No.FUN-680136
          l_sql 	STRING,		              # RDSQL STATEMENT   #TQC-630166
          l_za05	LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
         #--> FUN-720010 add -----------------------------------------------------
          l_ima021      LIKE ima_file.ima021,
          l_pmn85       STRING,
          l_pmn82       STRING,
          l_pmn20       STRING,
         #l_str2        STRING,
          l_str2        LIKE type_file.chr1000, 
          pstr2         LIKE type_file.chr1, #是否有單位註解
          pdbunit       LIKE type_file.chr1, #N:採購單位、訂購量 Y:計價單位、計價數量      
          l_ima906      LIKE ima_file.ima906,
         #--> FUN-720010 end -----------------------------------------------------
          sr              RECORD
                                  pmn01  LIKE pmn_file.pmn01,
                                  pmn02  LIKE pmn_file.pmn02,
                                  pmn04  LIKE pmn_file.pmn04,
                                  pmn07  LIKE pmn_file.pmn07,
                                  pmn20  LIKE pmn_file.pmn20,
                                  pmn24  LIKE pmn_file.pmn24,
                                  pmn30  LIKE pmn_file.pmn30,
                                  pmn44  LIKE pmn_file.pmn44,
                                  pmm01  LIKE pmm_file.pmm01,
                                  pmm04  LIKE pmm_file.pmm04,
                                  pmm09  LIKE pmm_file.pmm09,
                                  pmn041 LIKE pmn_file.pmn041,
                                  ima08  LIKE ima_file.ima08,
                                  pmm22  LIKE pmm_file.pmm22,
                                  pmm20  LIKE pmm_file.pmm20,
                                  pmn31  LIKE pmn_file.pmn31,
                                  pmm42  LIKE pmm_file.pmm42,
                                   l_pmn1 LIKE pmn_file.pmn31, #MOD-530190
                                   l_pmn2 LIKE pmn_file.pmn31, #MOD-530190
                                   l_pmn3 LIKE pmn_file.pmn31, #MOD-530190
                                  pmc03  LIKE pmc_file.pmc03,
                                  pma02  LIKE pma_file.pma02,
#No.FUN-580004 --start--
                                  pmn80 LIKE pmn_file.pmn80,
                                  pmn82 LIKE pmn_file.pmn82,
                                  pmn83 LIKE pmn_file.pmn83,
                                  pmn85 LIKE pmn_file.pmn85,
                                  pmn86 LIKE pmn_file.pmn86,
                                  pmn87 LIKE pmn_file.pmn87
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE i                  LIKE type_file.num5          #No.FUN-680136 SMALLINT
#No.FUN-580004 --end--
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
     #------------------------------ CR (2) ------------------------------#
 
#No.CHI-6A0004-------Begin-----     
#     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#       FROM azi_file                 #幣別檔小數位數讀取
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004-------End------
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
 
     LET g_pmm04 = NULL
     LET l_sql = " SELECT ",
                 " pmn01,pmn02,pmn04,pmn07,pmn20,pmn24,pmn30,",
                 " pmn44,pmm01,pmm04,pmm09,pmn041,ima08,pmm22,pmm20,",
                 " pmn31,pmm42,'','','',pmc03,pma02, ",
                 " pmn80,pmn82,pmn83,pmn85,pmn86,pmn87 ",  #No.FUN-580004
                 " FROM pmn_file,pmm_file,OUTER (ima_file,pmc_file,pma_file)",
                 " WHERE ima_file.ima01 = pmn_file.pmn04 ",
                 "  AND pmn01 = pmm01 ",
                 "  AND pmc_file.pmc01 = pmm_file.pmm09 ",
                 "  AND pma_file.pma01 = pmm_file.pmm20 ",
                 "  AND pmm18 <> 'X' AND ",tm.wc CLIPPED ,
                 " ORDER BY pmm04 "
     PREPARE r700_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE r700_cs  CURSOR FOR r700_prepare
#No.FUN-580004  --start
     IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
            LET g_zaa[39].zaa06 = "Y"
            LET g_zaa[40].zaa06 = "Y"
            LET g_zaa[48].zaa06 = "N"
            LET g_zaa[49].zaa06 = "N"
 
            LET pdbunit = "N"   ##FUN-720010 add 是否使用計價單位
     ELSE
            LET g_zaa[39].zaa06 = "N"
            LET g_zaa[40].zaa06 = "N"
            LET g_zaa[48].zaa06 = "Y"
            LET g_zaa[49].zaa06 = "Y"
 
            LET pdbunit = "Y"   #FUN-720010 add 是否使用計價單位
 
     END IF
     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
            LET g_zaa[47].zaa06 = "N"
            LET pstr2 = "N"  #FUN-720010 add 單位註解
     ELSE
            LET g_zaa[47].zaa06 = "Y"
            LET pstr2 = "Y"  #FUN-720010 add 單位註解
     END IF
#No.FUN-580004 --end
 
     FOREACH r700_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr.pmm04 IS NULL THEN LET sr.pmm04 = ' ' END IF
       IF sr.pmn04 IS NULL THEN LET sr.pmn04 = ' ' END IF
       IF sr.pmn30 IS NULL THEN LET sr.pmn30 = 0 END IF
       IF sr.pmn31 IS NULL THEN LET sr.pmn31 = 0 END IF
       IF sr.pmn44 IS NULL THEN LET sr.pmn44 = 0 END IF
     #TQC-6C0139-----------------mod------str-------
     # LET sr.l_pmn1 = sr.pmn20 * sr.pmn30
     # LET sr.l_pmn2 = sr.pmn20 * sr.pmn44
      #LET sr.l_pmn3 = sr.pmn20 * (sr.pmn31*sr.pmm42-sr.pmn30) #MOD-670100 mark
     # LET sr.l_pmn3 = sr.pmn20 * (sr.pmn44-sr.pmn30)          #MOD-670100 mod
       LET sr.l_pmn1 = sr.pmn87 * sr.pmn30
       LET sr.l_pmn2 = sr.pmn87 * sr.pmn44
       LET sr.l_pmn3 = sr.pmn87 * (sr.pmn44-sr.pmn30)          #MOD-670100 mod
     #TQC-6C0139-----------------mod------end-------
 
     #--> FUN-720010 add ------------------------------------------------------------
      ## 規格 
      LET l_ima021 = NULL
      SELECT ima021 INTO l_ima021 FROM ima_file
       WHERE ima01=sr.pmn04
      IF SQLCA.sqlcode THEN
          LET l_ima021 = NULL
      END IF
    
      ##
      LET l_ima906 = NULL
      LET l_str2 = ""
 
      SELECT ima906 INTO l_ima906 FROM ima_file
       WHERE ima01=sr.pmn04
      IF g_sma115 = "Y" THEN  #使用雙單位
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                END IF
         END CASE
      END IF
 
      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
           #IF sr.pmn80 <> sr.pmn86 THEN     #NO.TQC-6B0137  mark
            IF sr.pmn07 <> sr.pmn86 THEN     #NO.TQC-6B0137  mod
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
            END IF
      ELSE
         ## 使用計價單位
         LET sr.pmn07 = sr.pmn86  #計價單位
         LET sr.pmn20 = sr.pmn20  #計價數量
      END IF
 
     #--> FUN-720010 end ---------------------------------------------------------
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
       EXECUTE insert_prep USING 
               sr.pmn01,sr.pmn02,sr.pmn04,sr.pmn07,sr.pmn20,
               sr.pmn24,sr.pmn30,sr.pmn44,sr.pmm01,sr.pmm04,
               sr.pmm09,sr.pmn041,sr.ima08,sr.pmm22,sr.pmm20,
               sr.pmn31,sr.pmm42,sr.l_pmn1,sr.l_pmn2,sr.l_pmn3,
               sr.pmc03,sr.pma02,sr.pmn80,sr.pmn82,sr.pmn83,
               sr.pmn85,l_ima021,l_str2,g_azi03,g_azi04
     END FOREACH
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = ''
     #是否列印選擇條件
     #IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pmn04,pmn24,pmm01,pmm04,pmm09') 
             RETURNING tm.wc
        LET g_str = tm.wc
     #END IF
 
     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
        LET pdbunit = 'Y'    #多單位
        LET pstr2 = 'Y'
        LET g_str = g_str,";",pdbunit,";",pstr2
        CALL cl_prt_cs3('apmr700','apmr700_1',l_sql,g_str)   #FUN-710080 modify
     ELSE 
        LET pdbunit = 'N'  
        LET pstr2 = 'N'
        LET g_str = g_str,";",pdbunit,";",pstr2
        CALL cl_prt_cs3('apmr700','apmr700',l_sql,g_str)     #FUN-710080 modify
     END IF 
    
     #------------------------------ CR (4) ------------------------------#
END FUNCTION
