# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr901.4gl
# Desc/riptions...: 採購單列印(橫式)
# Input parameter:
# Return code....:
# Date & Author..: 91/10/04 By MAY
# Modify ........: 93/11/02 By Fiona
# Modify ........: No:9559 04/05/19 By Melody 未按幣別取位
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or LIKE type_file.num20_6
# Modify.........: No.FUN-540027 05/05/31 By Elva  增印pmn88t,pmn31t
# Modify.........: No.FUN-550114 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580004 05/08/08 By jackie 轉XML，雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-5B0059 06/01/03 By Sarah 當(cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)時才CALL r901_tm()
# Modify.........: No.FUN-610028 06/01/11 By Sarah 畫面的語言變更時,報表內容表頭不需跟著變,因為要列印的語言別是跟著apmi600的慣用語言走的(pmc911)
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-640042 06/04/08 By Sarah 增加列印「規格」欄位
# Modify.........: No.MOD-640172 06/04/09 By day  去掉抓取za資料部分 ,頁尾標簽打兩次
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改       
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6A0086 06/11/13 By baogui 加CLIPPED
# Modify.........: No.CHI-6A0025 06/11/16 By Smapmin 修改報表列印條件
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.TQC-6C0041 06/12/08 By ray 報表格式修改
# Modify.........: No.FUN-710091 07/02/18 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740276 07/04/20 By wujie 特別說明單身"在後"印出來的位置錯誤
# Modify.........: No.FUN-740222 07/04/27 By Sarah apmr901 特別說明列印功能有問題，已暫時關閉，per檔選擇功能也請先隱藏，待功能研發完成，再行開放。
# Modify.........: No.MOD-740291 07/05/02 By Sarah 在4gl裡先將合計(sum_pmn88,sum_pmn88t)計算好
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.CHI-790029 07/10/02 By jamie 特別說明使用新的子報表寫法
# Modify.........: No.FUN-7B0142 07/12/12 By jamie 不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.FUN-840058 08/05/06 By Dido 統編,電話,傳真調為供應商資料
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu  匯率調整為用azi07取位
# Modify.........: No.MOD-930316 09/04/02 By Smapmin 數量未取位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0441 09/12/28 By sherry 列印次數沒有更新
# Modify.........: No:FUN-A80065 10/08/11 By yinhy 畫面條件選項增加四個條件，1.列印請購單號 2.列印廠商料號 3.料件最近採購記錄列印最大筆數 4.列印額外品名規格
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-940043 11/10/14 By huangtao CR報表列印EF簽核圖檔 OR TIPTOP自訂簽核欄位
# Modify.........: No:TQC-BC0196 11/12/30 By zhangll 審核人由編號改為名稱顯示
# Modify.........: No:TQC-C10039 12/01/12 By minpp  CR报表列印TIPTOP与EasyFlow签核图片修改
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17     #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5   	#No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD		                # Print condition RECORD
              #wc      LIKE type_file.chr1000,  # Where condition   #TQC-630166 mark 	#No.FUN-680136 VARCHAR(500) 
               wc      STRING,                  # Where condition   #TQC-630166
              #a       LIKE type_file.chr1,     # No.FUN-680136 VARCHAR(1)                                           #FUN-740222 mark
              #b       LIKE type_file.chr1,  	# print gkf_file detail(Y/N)     	#No.FUN-680136 VARCHAR(1)    #FUN-740222 mark
   	           a       LIKE type_file.chr1,     # No.FUN-A80065 VARCHAR(1)                                           #FUN-740222 mark
               b       LIKE type_file.chr1,     # No.FUN-A80065 VARCHAR(1)
               c       LIKE type_file.chr1,     # No.FUN-A80065 VARCHAR(1)                                           #FUN-740222 mark
               d       LIKE type_file.chr1,     # No.FUN-A80065 VARCHAR(1)
   	           more    LIKE type_file.chr1      # Input more condition(Y/N) 	        #No.FUN-680136 VARCHAR(1) 
              END RECORD,
          g_aza17      LIKE aza_file.aza17,     # 本國幣別
          g_head_flg   LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1) 
          g_pmm01      LIKE pmm_file.pmm01,     #No.FUN-540027 #No.FUN-680136 VARCHAR(16) 
          g_total      LIKE pmn_file.pmn31,     #MOD-530190
          g_total1     LIKE pmn_file.pmn88t     #No.FUN-540027
   DEFINE g_i          LIKE type_file.num5      #count/index for any purpose   #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
   DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680136 INTEGER
   DEFINE g_sma115     LIKE sma_file.sma115
   DEFINE g_sma116     LIKE sma_file.sma116
#No.FUN-580004 --end--
#No.FUN-710091  --begin
   DEFINE g_sql        STRING
   DEFINE g_str        STRING
   DEFINE l_table      STRING
   DEFINE l_table1     STRING
   DEFINE l_table2     STRING
   DEFINE l_table3     STRING
   DEFINE l_table4     STRING
#No.FUN-710091  --end 
   DEFINE l_table5     STRING                  #No.FUN-A80065 
   DEFINE l_table6     STRING                  #No.FUN-A80065 

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
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.a  = ARG_VAL(8)   #FUN-740222 mark
  #LET tm.b  = ARG_VAL(9)   #FUN-740222 mark
   #No.FUN-A80065 --start--
   LET tm.a  = ARG_VAL(8)   
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)   
   LET tm.d  = ARG_VAL(11)
   #No.FUN-A80065 --end--
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_rlang) THEN
      LET g_rlang=g_lang
   END IF
 
   #No.FUN-710091   --begin
   LET g_sql = "pmm01.pmm_file.pmm01,",
               "pmm02.pmm_file.pmm02,",
               "pmm03.pmm_file.pmm03,",
               "pmm04.pmm_file.pmm04,",
               "pmm09.pmm_file.pmm09,",
               "pmm12.pmm_file.pmm12,",  
               "pmm13.pmm_file.pmm13,",  
               "pmm14.pmm_file.pmm14,",  
               "pmm15.pmm_file.pmm15,",  
               "pmm16.pmm_file.pmm16,",  
               "pmm17.pmm_file.pmm17,",  
               "pmm41.pmm_file.pmm41,",  
               "pmm20.pmm_file.pmm20,",  
               "pmm22.pmm_file.pmm22,",  
               "pmm42.pmm_file.pmm42,",  
               "pmn02.pmn_file.pmn02,",
               "pmn04.pmn_file.pmn04,",
               "pmn041.pmn_file.pmn041,",
               "pmn07.pmn_file.pmn07,",
               "pmn15.pmn_file.pmn15,",
               "pmn20.pmn_file.pmn20,",
               "pmn64.pmn_file.pmn64,",
               "pmn31.pmn_file.pmn31,",
               "pmn33.pmn_file.pmn33,",
               "pmn44.pmn_file.pmn44,",
               "pmn41.pmn_file.pmn41,",
               "pmn88.pmn_file.pmn88,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07,",    #No.FUN-870151
               "pmm10.pmm_file.pmm10,",
               "pmm43.pmm_file.pmm43,",
               "pmm11.pmm_file.pmm11,",
               "pmmprno.pmm_file.pmmprno,",
               "pmn31t.pmn_file.pmn31t,",
               "pmn88t.pmn_file.pmn88t,",
               "pmn80.pmn_file.pmn80,",
               "pmn82.pmn_file.pmn82,",
               "pmn83.pmn_file.pmn83,",
               "pmn85.pmn_file.pmn85,",
               "pmn86.pmn_file.pmn86,",
               "pmn87.pmn_file.pmn87,",
               "pmn24.pmn_file.pmn24,",    #No.FUN-A80065
               "pmn25.pmn_file.pmn25,",    #No.FUN-A80065
               "pmn06.pmn_file.pmn06,",    #No.FUN-A80065
               "sum_pmn88.pmn_file.pmn88,",     #MOD-740291 add
               "sum_pmn88t.pmn_file.pmn88t,",   #MOD-740291 add
               "pmc081.pmc_file.pmc081,",
               "pmc082.pmc_file.pmc082,",
               "pmc091.pmc_file.pmc091,",
               "pmc092.pmc_file.pmc092,",
               "pmc093.pmc_file.pmc093,",
               "pmc094.pmc_file.pmc094,",
               "pmc095.pmc_file.pmc095,",
               "pme031.pme_file.pme031,",
               "pme032.pme_file.pme032,",
               "pme033.pme_file.pme033,",
               "pme034.pme_file.pme034,",
               "pme035.pme_file.pme035,",
               "pme0311.pme_file.pme031,",
               "pme0322.pme_file.pme032,",
               "pme0333.pme_file.pme033,",
               "pme0344.pme_file.pme034,",
               "pme0355.pme_file.pme035,",
               "zo041.zo_file.zo041,",
               "zo042.zo_file.zo042,",
              #"zo06.zo_file.zo06,",       #FUN-840058   
               "zo05.zo_file.zo05,",
               "zo09.zo_file.zo09,",   
               "pmc24.pmc_file.pmc24,",    #FUN-840058
               "pmc10.pmc_file.pmc10,",    #FUN-840058
               "pmc11.pmc_file.pmc11,",    #FUN-840058
               "ima021.ima_file.ima021,",
               "pma02.pma_file.pma02,",
               "gen02.gen_file.gen02,",
               "gen02_2.gen_file.gen02,",  #TQC-BC0196 add 審核人
               "sma115.sma_file.sma115,",  #No.TQC-740276
               "sma116.sma_file.sma116,",  #No.TQC-740276
               "gfe03.gfe_file.gfe03,",      #MOD-930316
               "l_count.type_file.num5,",    #No.FUN-A80065
               "sign_type.type_file.chr1,", #FUN-940043 add
               "sign_img.type_file.blob,",  #FUN-940043 add
               "sign_show.type_file.chr1,",   #FUN-940043 add
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

   LET l_table = cl_prt_temptable('apmr901',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   #單據前說明
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmo061.pmo_file.pmo06"
   LET l_table1 = cl_prt_temptable('apmr9011',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
 
   #項次前說明
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmn02.pmn_file.pmn02,",     #No.TQC-740276 
               "pmo062.pmo_file.pmo06"
   LET l_table2 = cl_prt_temptable('apmr9012',g_sql) CLIPPED
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF
 
 
   #項次後說明
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmn02.pmn_file.pmn02,",     #No.TQC-740276 
               "pmo063.pmo_file.pmo06"
   LET l_table3 = cl_prt_temptable('apmr9013',g_sql) CLIPPED
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF
 
   #單據後說明
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmo064.pmo_file.pmo06"
   LET l_table4 = cl_prt_temptable('apmr9014',g_sql) CLIPPED
   IF  l_table4 = -1 THEN EXIT PROGRAM END IF
         
   #No.FUN-710091   --end  
   #No.FUN-A80065   --start--
   #最近採購記錄
    LET g_sql = "pmm01.pmm_file.pmm01,",
                "pmn04.pmn_file.pmn04,",
                "azi03.azi_file.azi03,",
                "azi04.azi_file.azi04,",
                "sr1_pmm04.pmm_file.pmm04,",
                "sr1_pmm01.pmm_file.pmm01,",
                "sr1_pmc03.pmc_file.pmc03,",
                "sr1_pmn20.pmn_file.pmn20,",
                "sr1_pmn07.pmn_file.pmn07,",
                "sr1_pmm22.pmm_file.pmm22,",
                "sr1_pmn31.pmn_file.pmn31,",
                "sr1_pmn88.pmn_file.pmn88,",
                "sr1_pmn31t.pmn_file.pmn31t,",
                "sr1_pmn88t.pmn_file.pmn88t,",
                "sr1_gfe03.gfe_file.gfe03"
    LET l_table5 = cl_prt_temptable('apmr9015',g_sql) CLIPPED
    IF  l_table5 = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "pmq01.pmq_file.pmq01,", 
                "pmq02.pmq_file.pmq02,", 
                "pmq03.pmq_file.pmq03,", 
                "pmq04.pmq_file.pmq04,", 
                "pmq05.pmq_file.pmq05,",
                "pmm01.pmm_file.pmm01,",
                "pmn02.pmn_file.pmn02"
    LET l_table6 = cl_prt_temptable('apmr9016',g_sql) CLIPPED
    IF  l_table6 = -1 THEN EXIT PROGRAM END IF
    #No.FUN-A80065   --end--
  #start FUN-5B0059
  #IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)	# If background job sw is off
  #end FUN-5B0059
      THEN CALL r901_tm(0,0)		# Input print condition
      ELSE CALL apmr901()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r901_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,      #No.FUN-680136 SMALLINT
       l_cmd         LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r901_w AT p_row,p_col WITH FORM "apm/42f/apmr901"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  #LET tm.a     = 'N'   #FUN-740222 mark
  #LET tm.b     = 'N'   #FUN-740222 mark
   LET tm.a    = 'N'    #No.FUN-A80065
   LET tm.b    = 'N'    #No.FUN-A80065 
   LET tm.c    = 0      #No.FUN-A80065
   LET tm.d    = 'N'    #No.FUN-A80065
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
  #DISPLAY BY NAME tm.b,tm.a,tm.more # Condition   #FUN-740222 mark
   DISPLAY BY NAME tm.more # Condition             #FUN-740222
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm09
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
      LET INT_FLAG = 0 CLOSE WINDOW r901_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
 
  #INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS   #FUN-740222 mark
   INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.more WITHOUT DEFAULTS      #FUN-740222  #FUN-A80065 add a,b,c,d
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
     #str FUN-740222 mark
     #AFTER FIELD a
     #   IF tm.a NOT MATCHES '[YN]'  OR tm.a IS NULL
     #      THEN NEXT FIELD a
     #   END IF
     #AFTER FIELD b
     #   IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
     #      THEN NEXT FIELD b
     #   END IF
     #end FUN-740222 mark
      #No.FUN-A80028  --start--
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[YN]" THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES "[YN]" THEN
            NEXT FIELD b
         END IF
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES "[YN]" THEN
            NEXT FIELD d
         END IF
      #No.FUN-A80028  --end--
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]'  OR tm.more IS NULL
            THEN NEXT FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW r901_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr901'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr901','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                        #" '",tm.a CLIPPED,"'",   #FUN-740222 mark
                        #" '",tm.b CLIPPED,"'" ,  #FUN-740222 mark
                         " '",tm.a CLIPPED,"'",   #No.FUN-A80065
                         " '",tm.b CLIPPED,"'" ,  #No.FUN-A80065
                         " '",tm.c CLIPPED,"'"  , #No.FUN-A80065
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr901',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r901_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr901()
   ERROR ""
END WHILE
   CLOSE WINDOW r901_w
END FUNCTION
 
FUNCTION apmr901()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	# Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,		        # RDSQL STATEMENT   #TQC-630166
          l_chr		LIKE type_file.chr1,    # No.FUN-680136 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, # No.FUN-680136 VARCHAR(40)
          l_zaa08       LIKE zaa_file.zaa08,    # FUN-610028
          i             LIKE type_file.num5,    # No.FUN-680136 SMALLINT
          l_count LIKE type_file.num5,    #No.FUN-A80065 add
          sr   RECORD
                  pmm01 LIKE pmm_file.pmm01,	# 單號
                  pmm02 LIKE pmm_file.pmm02,	# 單據類別
                  pmm03 LIKE pmm_file.pmm03, 	# 更動序號
                  pmm04 LIKE pmm_file.pmm04, 	# 單據日期
                  pmm09 LIKE pmm_file.pmm09,	# 廠商編號
                  pmm12 LIKE pmm_file.pmm12,    # 採購員
                  pmm13 LIKE pmm_file.pmm13,    # 請購部門
                  pmm14 LIKE pmm_file.pmm14,    # 收貨部門
                  pmm15 LIKE pmm_file.pmm15,    # 確認人
                  pmm16 LIKE pmm_file.pmm16,    # 運送方式
                  pmm17 LIKE pmm_file.pmm17,    # 代理商
                  pmm41 LIKE pmm_file.pmm41,    # 價格條件
                  pmm20 LIKE pmm_file.pmm20,    # 付款方式
                  pmm22 LIKE pmm_file.pmm22,    # 弊別
                  pmm42 LIKE pmm_file.pmm42,    # 匯率
                  pmn02 LIKE pmn_file.pmn02,	# 項次
                  pmn04 LIKE pmn_file.pmn04,	# 料件編號
                  pmn041 LIKE pmn_file.pmn041,	# 品名規格
                  pmn07 LIKE pmn_file.pmn07,	# 單位
                  pmn15 LIKE pmn_file.pmn15,	# 提前交貨
                  pmn20 LIKE pmn_file.pmn20,	# 訂購量
                  pmn64 LIKE pmn_file.pmn64,	# 課稅否
                  pmn31 LIKE pmn_file.pmn31,	# 單價
                  pmn33 LIKE pmn_file.pmn33,	#
                  pmn44 LIKE pmn_file.pmn44,	#
                  pmn41 LIKE pmn_file.pmn41,	#委外工單
                 # g_pmn LIKE pmn_file.pmn31,    #MOD-530190  #No.FUN-540027
                  pmn88 LIKE pmn_file.pmn88,    #未稅金額 #No.FUN-540027
                  azi03 LIKE azi_file.azi03,	#
                  azi04 LIKE azi_file.azi04,	#
                  azi05 LIKE azi_file.azi05,	#
                  azi07 LIKE azi_file.azi07,	#No.FUN-870151
                  pmm10 LIKE pmm_file.pmm10,	#
                  pmm43 LIKE pmm_file.pmm43,	#
                  pmm11 LIKE pmm_file.pmm11,	#
                  pmmprno LIKE pmm_file.pmmprno,#已列印否
                  pmn31t  LIKE pmn_file.pmn31t, #含稅單價 #No.FUN-540027
                  pmn88t  LIKE pmn_file.pmn88t, #含稅金額 #No.FUN-540027
#No.FUN-580004 --start--
                  pmn80 LIKE pmn_file.pmn80,
                  pmn82 LIKE pmn_file.pmn82,
                  pmn83 LIKE pmn_file.pmn83,
                  pmn85 LIKE pmn_file.pmn85,
                  pmn86 LIKE pmn_file.pmn86,
                  pmn87 LIKE pmn_file.pmn87,
                  pmn24     LIKE pmn_file.pmn24,    #請購單號  #No.FUN-A80065
                  pmn25     LIKE pmn_file.pmn25,    #請購項次  #No.FUN-A80065
                  pmn06     LIKE pmn_file.pmn06    #廠商料號  #No.FUN-A80065                
        END RECORD,
     #No.FUN-A80065  --start-- 
     sr1  RECORD
                  pmm04     LIKE pmm_file.pmm04,
                  pmm01     LIKE pmm_file.pmm01,
                  pmc03     LIKE pmc_file.pmc03,
                  pmn20     LIKE pmn_file.pmn20,
                  pmn07     LIKE pmn_file.pmn07,
                  pmm22     LIKE pmm_file.pmm22,
                  pmn31     LIKE pmn_file.pmn31,
                  pmn88     LIKE pmn_file.pmn88,
                  pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
                  pmn88t    LIKE pmn_file.pmn88t,    #含稅金額
                  gfe03     LIKE gfe_file.gfe03
          END RECORD,
        
     sr2  RECORD
                  pmq01    LIKE pmq_file.pmq01,
                  pmq02    LIKE pmq_file.pmq02,
                  pmq03    LIKE pmq_file.pmq03,
                  pmq04    LIKE pmq_file.pmq04,
                  pmq05    LIKE pmq_file.pmq05
         END RECORD,
         sr1_gfe03            LIKE gfe_file.gfe03
     #No.FUN-A80065  --end--  
     DEFINE l_sum_pmn88        LIKE pmn_file.pmn88,    #MOD-740291 add
            l_sum_pmn88t       LIKE pmn_file.pmn88t    #MOD-740291 add
     DEFINE l_i,l_cnt   LIKE type_file.num5    #No.FUN-680136 SMALLINT
     DEFINE l_zaa02     LIKE zaa_file.zaa02
#No.FUN-580004 --end--
     DEFINE l_zab05     LIKE zab_file.zab05    #FUN-610028
#No.FUN-710091  --begin
     DEFINE l_sql1     STRING
     DEFINE l_sql2     STRING
     DEFINE l_sql3     STRING
     DEFINE l_sql4     STRING
     DEFINE l_sql5     STRING
     DEFINE l_pmo06   LIKE pmo_file.pmo06
     DEFINE l_pmc081  LIKE pmc_file.pmc081
     DEFINE l_pmc082  LIKE pmc_file.pmc082
     DEFINE l_pmc091  LIKE pmc_file.pmc091
     DEFINE l_pmc092  LIKE pmc_file.pmc092
     DEFINE l_pmc093  LIKE pmc_file.pmc093
     DEFINE l_pmc094  LIKE pmc_file.pmc094
     DEFINE l_pmc095  LIKE pmc_file.pmc095
     DEFINE l_pme031  LIKE pme_file.pme031
     DEFINE l_pme032  LIKE pme_file.pme032
     DEFINE l_pme033  LIKE pme_file.pme033
     DEFINE l_pme034  LIKE pme_file.pme034
     DEFINE l_pme035  LIKE pme_file.pme035
     DEFINE lb_pme031 LIKE pme_file.pme031
     DEFINE lb_pme032 LIKE pme_file.pme032
     DEFINE lb_pme033 LIKE pme_file.pme033
     DEFINE lb_pme034 LIKE pme_file.pme034
     DEFINE lb_pme035 LIKE pme_file.pme035
     DEFINE l_zo041   LIKE zo_file.zo041
     DEFINE l_zo042   LIKE zo_file.zo042
     DEFINE l_zo05    LIKE zo_file.zo05
    #DEFINE l_zo06    LIKE zo_file.zo06     #FUN-840058
     DEFINE l_zo09    LIKE zo_file.zo09
     DEFINE l_pmc10   LIKE pmc_file.pmc10   #FUN-840058
     DEFINE l_pmc11   LIKE pmc_file.pmc11   #FUN-840058
     DEFINE l_pmc24   LIKE pmc_file.pmc24   #FUN-840058
     DEFINE l_ima021  LIKE ima_file.ima021
     DEFINE l_pmm20   LIKE pma_file.pma02
     DEFINE l_gen02   LIKE gen_file.gen02
     DEFINE l_gen02_2 LIKE gen_file.gen02  #TQC-BC0196 add 審核人
     DEFINE l_gfe03   LIKE gfe_file.gfe03   #MOD-930316
#No.FUN-710091  --end
     DEFINE l_pmm01    LIKE pmm_file.pmm01   #MOD-9C0441
#TQC-C10039--MARK--STR
   #FUN-B940043 START
     DEFINE l_img_blob         LIKE type_file.blob
#    DEFINE l_ii               INTEGER 
#    DEFINE l_key              RECORD 
#           v1                 LIKE pmm_file.pmm01
#           END RECORD 
   #FUN-B940043 END
#TQC-C10039--MARK--END   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #FUN-810029 add
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr901'
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR  #No.MOD-640172
#No.CHI-6A0004------Begin------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004-----End--------
#No.FUN-710091  --begin
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1)       #CHI-790029 add
     CALL cl_del_data(l_table2)       #CHI-790029 add
     CALL cl_del_data(l_table3)       #CHI-790029 add
     CALL cl_del_data(l_table4)       #CHI-790029 add
     CALL cl_del_data(l_table5)       #FUN-A80065 add
     CALL cl_del_data(l_table6)       #FUN-A80065 add

     LOCATE l_img_blob IN MEMORY      #FUN-B940043 add
     
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?,?)" #TQC-C10039 ADD 1? #FUN-B940043 add 3? #MOD-740291#FUN-840058 add ?,?  #FUN-870151 Add ?   #MOD-930316 add ?  #FUN-A80065 add 4個? #TQC-BC0196 add ?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF 
 
     #單據前備註
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-780049
                 " VALUES(?,?)"
     PREPARE insert1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
 
 
     #項次前備註
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?)"      #No.TQC-740276
     PREPARE insert2 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert2:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
 
     #項次後備註
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?)"      #No.TQC-740276
     PREPARE insert3 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert3:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
  
     #單據後備註
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,  #TQC-780049
                 " VALUES(?,?)"
     PREPARE insert4 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert4:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     
     #No.FUN-A80065  --start--
     #最近採購記錄
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
     PREPARE insert5 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert5:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     #廠商料號品名規格額外說明
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
     PREPARE insert_prep6 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep6:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     #No.FUN-A80065  --end--
 
#No.FUN-710091  --end  
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT  ",
                 "  pmm01, pmm02, pmm03,  pmm04, pmm09, pmm12, pmm13 ,",
                 "  pmm14, pmm15, pmm16,  pmm17, pmm41, pmm20 ,",
                 "  pmm22, pmm42, pmn02,  pmn04, pmn041, pmn07 ,",
                 "  pmn15,  pmn20, pmn64, pmn31, pmn33, pmn44, ",
                 #No.FUN-540027  --begin
             #   "  pmn41, '',azi03,azi04,azi05, pmm10, pmm43, pmm11, pmmprno ",
                #"  pmn41, pmn88,azi03,azi04,azi05, pmm10, pmm43, pmm11, ",      #No.FUN-870151
                 "  pmn41, pmn88,azi03,azi04,azi05,azi07, pmm10, pmm43, pmm11, ",#No.FUN-870151                 
                 "  pmmprno ,pmn31t,pmn88t, pmn80,pmn82,pmn83,pmn85,pmn86,pmn87, ",   #No.FUN-580004
                 #No.FUN-540027  --end
                 "  pmn24, pmn25,pmn06 ",  #No.FUN-A80065
                 #"  FROM pmm_file,pmn_file, OUTER azi_file",   #CHI-6A0025
                 "  FROM pmm_file LEFT OUTER JOIN azi_file ON pmm22 = azi01 LEFT OUTER JOIN gec_file ON gec01 = pmm21 AND gec011='1',pmn_file ",   #CHI-6A0025
                 "  WHERE pmm01 = pmn01 " ,
                 "  AND pmm18 <> 'X' AND ",tm.wc
     LET  g_total = 0
     LET  g_total1= 0    #No.FUN-540027
     PREPARE r901_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r901_cs1 CURSOR FOR r901_prepare1
#TQC-C10039--MARK--STR--
     #FUN-940043  START
#    LET l_sql = "SELECT  ",
#                "  pmm01",
#                "  FROM pmm_file LEFT OUTER JOIN azi_file ON pmm22 = azi01 LEFT OUTER JOIN gec_file ON gec01 = pmm21 AND gec011='1',pmn_file ",
#                "  WHERE pmm01 = pmn01 " ,
#                "  AND pmm18 <> 'X' AND ",tm.wc,
#                "GROUP BY pmm01"
#    LET  g_total = 0
#    LET  g_total1= 0    #No.FUN-540027
#    PREPARE r901_prepare5 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('r901_prepare5:',SQLCA.sqlcode,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#       EXIT PROGRAM
#          
#    END IF
#    DECLARE r901_cs5 CURSOR FOR r901_prepare5
#    #FUN-940043  END 
#TQC-C10039--MARK--END--     
#    LET l_name = 'apmr901.out'  #No.MOD-640172
#    CALL cl_outnam('apmr901') RETURNING l_name    #No.FUN-710091  
#No.FUN-580004  --start
     IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
            LET g_zaa[73].zaa06 = "Y"
            LET g_zaa[75].zaa06 = "Y"
            LET g_zaa[67].zaa06 = "N"
            LET g_zaa[68].zaa06 = "N"
     ELSE
            LET g_zaa[67].zaa06 = "Y"
            LET g_zaa[68].zaa06 = "Y"
            LET g_zaa[73].zaa06 = "N"
            LET g_zaa[75].zaa06 = "N"
     END IF
     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
            LET g_zaa[74].zaa06 = "N"
            LET g_zaa[80].zaa06 = "N"
     ELSE
            LET g_zaa[74].zaa06 = "Y"
            LET g_zaa[80].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
#No.FUN-580004 --end
#    START REPORT r901_rep TO l_name    #No.FUN-710091 
    #CALL r901_cur()
 
    #start FUN-610028
#No.MOD-640172--begin
     #改變報表表頭標題(By語言別)
#    DECLARE r901_za_cur CURSOR FOR
#            SELECT za02,za05 FROM za_file
#             WHERE za01 = 'apmr901' AND za03 = g_rlang
#No.MOD-640172--end
 
     #改變報表內容表頭標題(By語言別)
     DECLARE r901_zaa_cur CURSOR FOR
             SELECT zaa02,zaa08 FROM zaa_file
              WHERE zaa01 = 'apmr901' AND zaa03 = g_rlang
    #end FUN-610028
 
    #LET g_pageno = 0
 
     FOREACH r901_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       INITIALIZE g_pmm01 TO NULL
       IF sr.pmn31 IS NULL THEN LET sr.pmn31=0  END IF
      #No.FUN-540027  --begin
       IF sr.pmn88 IS NULL THEN LET sr.pmn88=0  END IF
       IF sr.pmn31t IS NULL THEN LET sr.pmn31t=0  END IF
       IF sr.pmn88t IS NULL THEN LET sr.pmn88t=0  END IF
      #No.FUN-540027  --end
       IF sr.pmn20 IS NULL THEN LET sr.pmn20=0  END IF
      #LET sr.g_pmn =  sr.pmn31 * sr.pmn20   #No.FUN-540027
 
       #str MOD-740291 add
       SELECT SUM(pmn88),SUM(pmn88t) INTO l_sum_pmn88,l_sum_pmn88t
         FROM pmn_file
        WHERE pmn01=sr.pmm01
       IF cl_null(l_sum_pmn88)  THEN LET l_sum_pmn88=0  END IF
       IF cl_null(l_sum_pmn88t) THEN LET l_sum_pmn88t=0 END IF
       #end MOD-740291 add
 
       ## Bug No: 7252
      #FUN-7B0142---mark---str---
      #IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN
      #     SELECT pmc911 INTO g_rlang
      #       FROM pmc_file
      #      WHERE sr.pmm09 = pmc01
      #END IF
      #FUN-7B0142---mark---end---
       SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
       ##
      
     #CHI-790029---mark---str--
     ##start FUN-610028
     ##No.MOD-640172--begin
     # #改變報表表頭標題(By語言別)
     # #FOREACH r901_za_cur INTO g_i,l_za05
     # #        LET g_x[g_i] = l_za05
     # #END FOREACH
 
     # #改變報表內容表頭標題(By語言別)
     # FOREACH r901_zaa_cur INTO g_i,l_zaa08
     #    LET g_zaa[g_i].zaa08 = l_zaa08
     # END FOREACH
     # #No.MOD-640172--end  
 
     # #重抓g_memo
     # DECLARE zab_cur CURSOR FOR
     #  SELECT zab05 FROM zab_file
     #   WHERE zab01 = g_zaa[39].zaa08 AND zab04 = g_rlang AND zab03 = '1'
     # FOREACH zab_cur INTO l_zab05
     #    IF SQLCA.SQLCODE THEN LET l_zab05=' ' END IF
     # END FOREACH
     # LET g_memo = l_zab05
     ##end FUN-610028
     #CHI-790029---mark---end--
 
      #OUTPUT TO REPORT r901_rep(sr.*)       #No.FUN-710091
      #No.FUN-710091  --begin
       LET l_sql1 =" SELECT pmo06  FROM pmo_file    WHERE",
                   " pmo01='",sr.pmm01,"' AND     pmo02 = '1' "
 
      #str FUN-740222 mark
      #IF tm.a='Y' THEN
      #   LET l_sql2 = l_sql1 CLIPPED," AND  pmo03 ='0'"," AND pmo04 = '0'"
      #   PREPARE r901_prepare2 FROM l_sql2
      #   DECLARE r901_note_cur2  CURSOR FOR r901_prepare2
      #   FOREACH r901_note_cur2 INTO l_pmo06
      #      EXECUTE insert1 USING sr.pmm01,l_pmo06 
      #   END FOREACH
      #END IF
      #
      #IF tm.b = 'Y' THEN
      #項次前備註
      #CHI-790029---unmark---str---
          LET l_sql3 = l_sql1 CLIPPED,
                       " AND  pmo03 ='",sr.pmn02,"'  AND pmo04 = '0'"
#                      " AND pmo03 ='1' AND  pmo05 ='",sr.pmn02,"'  AND pmo04 = '0'"      #No.TQC-740276
          PREPARE r901_prepare3 FROM l_sql3
          DECLARE r901_note_cur3 CURSOR FOR r901_prepare3
          FOREACH r901_note_cur3 INTO l_pmo06
             EXECUTE insert2 USING sr.pmm01,sr.pmn02,l_pmo06       #No.TQC-740276
          END FOREACH
      #CHI-790029---unmark---end---
      #END IF
      #
      #IF tm.b = 'Y' THEN
 
      #項次後備註
      #CHI-790029---unmark---str---
          LET l_sql4 = l_sql1 CLIPPED,
                       " AND  pmo03 ='",sr.pmn02,"'  AND pmo04 = '1'"
#                      " AND pmo03 ='1' AND  pmo05 ='",sr.pmn02,"'  AND pmo04 = '1'"      #No.TQC-740276
          PREPARE r901_prepare4 FROM l_sql4
          DECLARE r901_note_cur4 CURSOR FOR r901_prepare4
          FOREACH r901_note_cur4 INTO l_pmo06
             EXECUTE insert3 USING sr.pmm01,sr.pmn02,l_pmo06          #No.TQC-740276
          END FOREACH
      #CHI-790029---unmark---end---
      #END IF
      #
      #IF tm.a='Y' THEN
      #   LET l_sql5 = l_sql1 CLIPPED," AND  pmo03 ='0'"," AND pmo04 = '1'"
      #   PREPARE r901_prepare5 FROM l_sql5
      #   DECLARE r901_note_cur5 CURSOR FOR r901_prepare5
      #   FOREACH r901_note_cur5 INTO l_pmo06
      #      EXECUTE insert4 USING sr.pmm01,l_pmo06
      #   END FOREACH
      #END IF
      #end FUN-740222 mark
       
       SELECT pmc081,pmc082,pmc091,pmc092,pmc093,pmc094,pmc095,pmc10,pmc11,pmc24  #FUN-840058
         INTO l_pmc081,l_pmc082,l_pmc091,
              l_pmc092,l_pmc093,l_pmc094,l_pmc095,l_pmc10,l_pmc11,l_pmc24         #FUN-840058
       FROM pmc_file WHERE sr.pmm09 = pmc01
       IF SQLCA.sqlcode THEN 
          LET  l_pmc081 = NULL
          LET  l_pmc082 = NULL
          LET  l_pmc091 = NULL
          LET  l_pmc092 = NULL
          LET  l_pmc093 = NULL
          LET  l_pmc094 = NULL
          LET  l_pmc095 = NULL
          LET  l_pmc10  = NULL   #FUN-840058
          LET  l_pmc11  = NULL   #FUN-840058
          LET  l_pmc24  = NULL   #FUN-840058
       END IF
       
       SELECT pme031,pme032,pme033,pme034,pme035
       INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
       FROM pme_file
       WHERE pme01=sr.pmm10 AND ( pme02 ='0' OR pme02= '2')
       IF SQLCA.sqlcode THEN LET  l_pme031 = NULL
           LET l_pme032 = NULL
           LET l_pme033 = NULL
           LET l_pme034 = NULL
           LET l_pme035 = NULL
        END IF
       SELECT pme031,pme032,pme033,pme034,pme035
       INTO lb_pme031,lb_pme032,lb_pme033,lb_pme034,lb_pme035
       FROM pme_file
       WHERE sr.pmm11=pme01 AND (pme02 = '1' OR pme02 = '2')
       IF SQLCA.sqlcode THEN LET  lb_pme031 = NULL
           LET lb_pme032 = NULL
           LET lb_pme033 = NULL
           LET lb_pme034 = NULL
           LET lb_pme035 = NULL
        END IF
  
      #SELECT  zo041,zo042,zo09,zo05,zo06            #FUN-840058
      #  INTO l_zo041,l_zo042,l_zo09,l_zo05 ,l_zo06  #FUN-840058
       SELECT  zo041,zo042,zo09,zo05                 #FUN-840058
         INTO l_zo041,l_zo042,l_zo09,l_zo05          #FUN-840058
         FROM zo_file WHERE zo01 = g_rlang
       IF SQLCA.sqlcode THEN LET l_zo041 = NULL
          LET l_zo042 = NULL
          LET l_zo09 = NULL
          LET l_zo05 = NULL
         #LET l_zo06 = NULL                         #FUN-840058
       END IF
       SELECT pma02 INTO l_pmm20 FROM pma_file WHERE pma01 = sr.pmm20
       IF SQLCA.sqlcode THEN LET l_pmm20 = sr.pmm20 END IF
       
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE sr.pmm12=gen01
       IF SQLCA.sqlcode THEN LET l_gen02 = sr.pmm12 END IF
     
       #TQC-BC0196 add 審核人
       LET l_gen02_2 = ''
       SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE sr.pmm15=gen01
       IF SQLCA.sqlcode OR cl_null(l_gen02_2) THEN LET l_gen02_2 = sr.pmm15 END IF
       #TQC-BC0196 add--end 審核人

       SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.pmn04
       IF STATUS THEN LET l_ima021 = '' END IF
 
       #-----MOD-930316---------
       LET l_gfe03=0
       SELECT gfe03 INTO l_gfe03 FROM gfe_file
        WHERE gfe01 = sr.pmn86
       #-----END MOD-930316-----
       #No.FUN-A80065  --start--   #额外品名規格              
       IF tm.d = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM pmq_file
             WHERE pmq01=sr.pmn04 AND pmq02=sr.pmm09
          IF l_count !=0  THEN
            DECLARE pmq_cur CURSOR FOR
            SELECT * FROM pmq_file    
              WHERE pmq01=sr.pmn04 AND pmq02=sr.pmm09 
            ORDER BY pmq04                                        
            FOREACH pmq_cur INTO sr2.*                            
              EXECUTE insert_prep6 USING sr2.pmq01,sr2.pmq02,sr2.pmq03,sr2.pmq04,sr2.pmq05,sr.pmm01,sr.pmn02
            INITIALIZE sr2.* TO NULL
            END FOREACH
          END IF
        END IF 
       #No.FUN-A80065 --end-- 
       EXECUTE insert_prep USING 
               sr.*,l_sum_pmn88,l_sum_pmn88t,l_pmc081,l_pmc082,   
                                #MOD-740291 add l_sum_pmn88,l_sum_pmn88t
               l_pmc091,l_pmc092,l_pmc093,l_pmc094,l_pmc095,
               l_pme031,l_pme032,l_pme033,l_pme034,l_pme035,
               lb_pme031,lb_pme032,lb_pme033,lb_pme034,lb_pme035,
              #l_zo041,l_zo042,l_zo06,l_zo05,l_zo09,                  #FUN-840058
               l_zo041,l_zo042,l_zo05,l_zo09,l_pmc24,l_pmc10,l_pmc11, #FUN-840058
               l_ima021,l_pmm20,l_gen02,l_gen02_2,g_sma.sma115,g_sma.sma116,l_gfe03,l_count,  #No.TQC-740276   #MOD-930316 #TQC-BC0196 add l_gen02_2
               "",l_img_blob,"N",""  #FUN-940043 add  #TQC-C10039 ADD ""
        
       #No.FUN-A80065  --start--   #列印最近採購紀錄最大筆數功能
        IF tm.c > 0 THEN
          DECLARE pmn_cur CURSOR FOR
             SELECT pmm04,pmm01,pmc03,pmn20,pmn07,pmm22,pmn31,
                    pmn88,pmn31t,pmn88t
               FROM pmm_file, pmn_file, OUTER pmc_file
              WHERE pmn04 = sr.pmn04 AND pmn01=pmm01 AND pmm09=pmc_file.pmc01
              ORDER BY pmm04 DESC
          LET g_cnt=0
          FOREACH pmn_cur INTO sr1.*
             IF STATUS THEN CALL cl_err('pmn_cur',STATUS,1) EXIT FOREACH END IF
             LET g_cnt = g_cnt + 1 IF g_cnt > tm.c THEN EXIT FOREACH END IF
 
             LET sr1_gfe03=0
             SELECT gfe03 INTO sr1_gfe03 FROM gfe_file WHERE gfe01=sr1.pmn07
             EXECUTE insert5 USING
                sr.pmm01,sr.pmn04,sr.azi03,sr.azi04,sr1.*
             INITIALIZE sr1.* TO NULL
          END FOREACH
       END IF  
       #No.FUN-A80065  --end--  
     END FOREACH
 
 
      #   LET l_sql2 = l_sql1 CLIPPED," AND  pmo03 ='0'"," AND pmo04 = '0'"
      #   PREPARE r901_prepare2 FROM l_sql2
      #   DECLARE r901_note_cur2  CURSOR FOR r901_prepare2
      #   FOREACH r901_note_cur2 INTO l_pmo06
      #      EXECUTE insert1 USING sr.pmm01,l_pmo06 
      #   END FOREACH
 
      #   LET l_sql5 = l_sql1 CLIPPED," AND  pmo03 ='0'"," AND pmo04 = '1'"
      #   PREPARE r901_prepare5 FROM l_sql5
      #   DECLARE r901_note_cur5 CURSOR FOR r901_prepare5
      #   FOREACH r901_note_cur5 INTO l_pmo06
      #      EXECUTE insert4 USING sr.pmm01,l_pmo06
      #   END FOREACH
 
  #str CHI-790029 add
   #處理單據前、後特別說明
   LET l_sql = "SELECT pmm01 FROM pmm_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY pmm01"
   PREPARE r901_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE r901_cs2 CURSOR FOR r901_prepare2
 
   FOREACH r901_cs2 INTO sr.pmm01
      #額外備註-單據前備註 
      DECLARE pmo_cur CURSOR FOR
         SELECT pmo06 FROM pmo_file
          WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='0'
      FOREACH pmo_cur INTO l_pmo06
         EXECUTE insert1 USING sr.pmm01,l_pmo06   #No.TQC-740276    #CHI-790029 mod
      END FOREACH
     
      #額外備註-單據後備註 
      DECLARE pmo_cur4 CURSOR FOR
       SELECT pmo06 FROM pmo_file
        WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='1'
      FOREACH pmo_cur4 INTO l_pmo06
         EXECUTE insert4 USING sr.pmm01,l_pmo06   #No.TQC-740276    #CHI-790029 mod
      END FOREACH
   END FOREACH
  #end CHI-790029 add
 
    #CHI-790029 mark
    #LET g_sql ="SELECT A.*,B.pmo061,C.pmo062,D.pmo063,E.pmo064",
    #         #TQC-730088
    #         # " FROM ",l_table CLIPPED," A,",l_table1 CLIPPED," B,",
    #         #         l_table2 CLIPPED," C,",l_table3 CLIPPED," D,",
    #         #         l_table4 CLIPPED," E ",
    #           " FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A,",
    #                    g_cr_db_str CLIPPED,l_table1 CLIPPED," B,",    
    #                     #No.TQC-740276
    #                    g_cr_db_str CLIPPED,l_table2 CLIPPED," C,",
    #                    g_cr_db_str CLIPPED,l_table3 CLIPPED," D,",  
    #                     #No.TQC-740276    
    #                    g_cr_db_str CLIPPED,l_table4 CLIPPED," E ",
    #           " WHERE A.pmm01 = B.pmo01(+)",      #No.TQC-740276
    #           "  AND  A.pmm01 = C.pmo01(+)",      #No.TQC-740276
    #           "  AND  A.pmn02 = C.pmn02(+)",      #No.TQC-740276
    #           "  AND  A.pmm01 = D.pmo01(+)",      #No.TQC-740276
    #           "  AND  A.pmn02 = D.pmn02(+)",      #No.TQC-740276
    #           "  AND  A.pmm01 = E.pmo01(+)"       #No.TQC-740276
    #CHI-790029 mark
 
  #str CHI-790029 mod
  #修改成新的子報表的寫法(可組一句主要SQL,五句子報表SQL)
  #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED
   LET g_str =tm.wc,";",tm.a,";",tm.b,";",tm.d,";",tm.c
   IF g_zz05 = 'Y' THEN   #是否列印列印條件
      CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm09')   #FUN-810029 mod
           RETURNING tm.wc
   END IF
  #end CHI-790029 mod
#TQC-C10039--MARK--STR  
   #FUN-940043  START
   LET g_cr_table = l_table
#  LET g_cr_gcx01 = "asmi300"
   LET g_cr_apr_key_f = "pmm01"

#  LET l_ii = 1

#  CALL g_cr_apr_key.clear()  

#  FOREACH r901_cs5 INTO l_key.* 
#    LET g_cr_apr_key[l_ii].v1 = l_key.v1
#    LET l_ii = l_ii + 1 
#  END FOREACH

#  #FUN-940043  END 
#TQC-C10039--MARK--END   
    #CALL cl_prt_cs3('apmr901',g_sql,g_str)  #TQC-730088
     CALL cl_prt_cs3('apmr901','apmr901',g_sql,g_str)
    #No.FUN-710091  --end  
    #MOD-9C0441---Begin
    LET l_sql = "SELECT DISTINCT pmm01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    PREPARE r901_p3 FROM l_sql
    DECLARE r901_c3 CURSOR FOR r901_p3
    FOREACH r901_c3 INTO l_pmm01
       UPDATE pmm_file SET pmmprno = pmmprno + 1
                     WHERE pmm01 = l_pmm01
       IF sqlca.sqlerrd[3]=0 THEN
          CALL cl_err3("upd","pmm_file",l_pmm01,'',STATUS,"","upd pmmprno",1)
       END IF
    END FOREACH
    #MOD-9C0441---End                    
    #FINISH REPORT r901_rep      #No.FUN-710091 
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #No.FUN-710091 
END FUNCTION
 
#REPORT r901_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#          l_last_sw2    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#		  l_pmm20       LIKE pma_file.pma02,
#          l_ima08       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#          l_ima37       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#          l_dash        LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#         #TQC-630166
#         #l_str         LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(50)
#         #l_sql1	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#         #l_sql2	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#         #l_sql3	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#         #l_sql4	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#         #l_sql5	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#         #l_sql6	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#         #l_sql7	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#         #l_sql8	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#         #l_sql9	LIKE type_file.chr1000, # RDSQL STATEMENT       #No.FUN-680136 VARCHAR(1000)
#          l_str         STRING,
#          l_sql1	STRING,              # RDSQL STATEMENT
#          l_sql2	STRING,              # RDSQL STATEMENT
#          l_sql3	STRING,              # RDSQL STATEMENT
#          l_sql4	STRING,              # RDSQL STATEMENT
#          l_sql5	STRING,              # RDSQL STATEMENT
#          l_sql6	STRING,              # RDSQL STATEMENT
#          l_sql7	STRING,              # RDSQL STATEMENT
#          l_sql8	STRING,              # RDSQL STATEMENT
#          l_sql9	STRING,              # RDSQL STATEMENT
#         #END TQC-630166
#          l_pmm41       LIKE type_file.chr1000,# RDSQL STATEMENT 	#No.FUN-680136 VARCHAR(1000)
#          l_pmn         LIKE pmn_file.pmn31,   #MOD-530190
#          l_pmn20       LIKE pmn_file.pmn20,   #BUg-530190
#          l_pmn31       LIKE pmn_file.pmn31,   #MOD-530190
#          l_gem02  LIKE gem_file.gem02,  	
#          lb_pme031 LIKE pme_file.pme031,      #送貨帳單地址
#          lb_pme032 LIKE pme_file.pme032, 	
#          lb_pme033 LIKE pme_file.pme033, 	
#          lb_pme034 LIKE pme_file.pme034, 	
#          lb_pme035 LIKE pme_file.pme035, 	
#          l_zo02   LIKE  zo_file.zo02,         #公司基本資料
#          l_zo041  LIKE  zo_file.zo041,  	
#          l_zo042  LIKE  zo_file.zo042,  	
#          l_zo0412 LIKE  zo_file.zo042,  	
#          l_zo05   LIKE  zo_file.zo05,   	
#          l_zo06   LIKE  zo_file.zo06,   	
#          l_zo09   LIKE  zo_file.zo09,   	
#          l_pme031 LIKE pme_file.pme031,       #送貨帳單地址
#          l_pme032 LIKE pme_file.pme032, 	
#          l_pme033 LIKE pme_file.pme033, 	
#          l_pme034 LIKE pme_file.pme034, 	
#          l_pme035 LIKE pme_file.pme035, 	
#          l_pmc03 LIKE pmc_file.pmc03, 	
#          l_pmc081 LIKE pmc_file.pmc081,       #公司全名
#          l_pmc082 LIKE pmc_file.pmc082, 	
#          l_pmc091 LIKE pmc_file.pmc091,       #正式地址
#          l_pmc092 LIKE pmc_file.pmc092, 	
#          l_pmc093 LIKE pmc_file.pmc093, 	
#          l_pmc094 LIKE pmc_file.pmc094, 	
#          l_pmc095 LIKE pmc_file.pmc095, 	
#          l_pmo06  LIKE pmo_file.pmo06,  	
#          l_gen02  LIKE gen_file.gen02,  	
#          l_ima02       LIKE ima_file.ima02,   #No.FUN-680136 VARCHAR(30)
#          l_pmc02       LIKE pmc_file.pmc02,    #No.FUN-680136 VARCHAR(4)
#          l_imc04       LIKE imc_file.imc04,
#          l_pmn121      LIKE pmn_file.pmn121,
#          l_pmn122      LIKE pmn_file.pmn122,
#          l_pmn123      LIKE pmn_file.pmn123,
#          l_count       LIKE type_file.num5,    #No.FUN-680136 SMALLINT
#          l_rec         LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
#    	  l1_ima02      LIKE ima_file.ima02,
#    	  l_n           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
#          l_pageno      LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
#          l_money,l_sub LIKE pmn_file.pmn31,    #MOD-530190
#          sr   RECORD
#                  pmm01 LIKE pmm_file.pmm01,	# 單號
#                  pmm02 LIKE pmm_file.pmm02,	# 單據類別
#                  pmm03 LIKE pmm_file.pmm03, 	# 更動序號
#                  pmm04 LIKE pmm_file.pmm04, 	# 單據日期
#                  pmm09 LIKE pmm_file.pmm09,	# 廠商編號
#                  pmm12 LIKE pmm_file.pmm12,    # 採購員
#                  pmm13 LIKE pmm_file.pmm13,    # 請購部門
#                  pmm14 LIKE pmm_file.pmm14,    # 收貨部門
#                  pmm15 LIKE pmm_file.pmm15,    # 確認人
#                  pmm16 LIKE pmm_file.pmm16,    # 運送方式
#                  pmm17 LIKE pmm_file.pmm17,    # 代理商
#                  pmm41 LIKE pmm_file.pmm41,    # 價格條件
#                  pmm20 LIKE pmm_file.pmm20,    # 付款方式
#                  pmm22 LIKE pmm_file.pmm22,    # 弊別
#                  pmm42 LIKE pmm_file.pmm42,    # 匯率
#                  pmn02 LIKE pmn_file.pmn02,	# 項次
#                  pmn04 LIKE pmn_file.pmn04,	# 料件編號
#                  pmn041 LIKE pmn_file.pmn041,	# 品名規格
#                  pmn07 LIKE pmn_file.pmn07,	# 單位
#                  pmn15 LIKE pmn_file.pmn15,	# 提前交貨
#                  pmn20 LIKE pmn_file.pmn20,	# 訂購量
#                  pmn64 LIKE pmn_file.pmn64,	# 課稅否
#                  pmn31 LIKE pmn_file.pmn31,	# 單價
#                  pmn33 LIKE pmn_file.pmn33,	#
#                  pmn44 LIKE pmn_file.pmn44,	#
#                  pmn41 LIKE pmn_file.pmn41,	#委外工單
#                #  g_pmn LIKE pmn_file.pmn31,    #MOD-530190 #No.FUN-540027
#                  pmn88 LIKE pmn_file.pmn88,    #未稅金額 #No.FUN-540027
#                  azi03 LIKE azi_file.azi03,	#
#                  azi04 LIKE azi_file.azi04,	#
#                  azi05 LIKE azi_file.azi05,	#
#                  pmm10 LIKE pmm_file.pmm10,	#
#                  pmm43 LIKE pmm_file.pmm43,	#
#                  pmm11 LIKE pmm_file.pmm11,	#
#                  pmmprno LIKE pmm_file.pmmprno,# 已列印否
#                  pmn31t  LIKE pmn_file.pmn31t, #含稅單價 #No.FUN-540027
#                  pmn88t  LIKE pmn_file.pmn88t, #含稅金額 #No.FUN-540027
##No.FUN-580004 --start--
#                  pmn80     LIKE    pmn_file.pmn80,
#                  pmn82     LIKE    pmn_file.pmn82,
#                  pmn83     LIKE    pmn_file.pmn83,
#                  pmn85     LIKE    pmn_file.pmn85,
#                  pmn86     LIKE    pmn_file.pmn86,
#                  pmn87     LIKE    pmn_file.pmn87
#        END RECORD
#  DEFINE l_ima906       LIKE ima_file.ima906
## DEFINE l_str2         LIKE type_file.chr1000  #TQC-630166 mark #No.FUN-680136 VARCHAR(100)
#  DEFINE l_str2         STRING      #TQC-630166
#  DEFINE l_pmn85        STRING
#  DEFINE l_pmn82        STRING
##No.FUN-580004 --end--
#  DEFINE l_ima021       LIKE ima_file.ima021   #FUN-640042 add
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
### No 2346  modify 98/07/06 ------------
## ORDER BY sr.pmm01
#  ORDER BY sr.pmm01,sr.pmn02
##### ------------------------------
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
##No.TQC-6C0041 --begin
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED     #TQC-6A0086    
##     LET g_pageno = g_pageno + 1
##     LET pageno_total = PAGENO USING '<<<'
##     PRINT g_head CLIPPED,pageno_total
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED     #TQC-6A0086    
#      PRINT
##No.TQC-6C0041 --end
#      SELECT  zo041,zo042,zo09,zo05,zo06
#        INTO l_zo041,l_zo042,l_zo09,l_zo05 ,l_zo06
#        FROM zo_file WHERE zo01 = g_rlang
#      IF SQLCA.sqlcode THEN LET l_zo041 = NULL
#         LET l_zo042 = NULL
#         LET l_zo09 = NULL
#         LET l_zo05 = NULL
#         LET l_zo06 = NULL
#      END IF
#      PRINT g_dash[1,g_len]
#      IF NOT cl_null(sr.pmm03) THEN
#         PRINT g_x[11] CLIPPED,' ',sr.pmm01,'-',sr.pmm03,COLUMN 67,
#               g_company CLIPPED
#      ELSE
#         PRINT g_x[11] CLIPPED,' ',sr.pmm01,COLUMN 67,
#               g_company CLIPPED
#      END IF
#      IF sr.pmmprno>0 THEN
#        PRINT COLUMN 10,' ',g_x[12] CLIPPED;
#      ELSE PRINT ' ';
#      END IF
#      PRINT COLUMN 67 ,l_zo041
#      PRINT g_x[13] CLIPPED,' ',sr.pmm04,COLUMN 67,l_zo042
#      PRINT ' ',COLUMN 67,g_x[14]  CLIPPED,l_zo05
#      LET l_sql1 =" SELECT pmo06  FROM pmo_file    WHERE",
#                  " pmo01='",sr.pmm01,"' AND     pmo02 = '1' "
#      LET l_sql6 = "SELECT imc04 FROM imc_file ",
#                   " WHERE imc01 = '",sr.pmn04 ,"'"
#      LET l_rec = 0
### No 2347  modify 98/07/06 ------------
#      LET g_head_flg='N'
### -------------------------------------
#      LET l_last_sw2='n'
# 
#   BEFORE GROUP OF sr.pmm01
#      IF  PAGENO > 1 OR LINENO > 9
#              THEN SKIP TO TOP OF PAGE
#      END IF
#      LET l_last_sw = 'y'
#      LET l_rec = 0
#      LET l_sub = 0
#
#   ON EVERY ROW
##公司基本資料，每張單號的第一頁才需要印
#      IF (g_pageno < 1 OR g_pageno = 1)  AND l_rec < 1 THEN
#      SELECT pmc03,pmc081,pmc082,pmc091,pmc092,pmc093,pmc094,pmc095
#          INTO l_pmc03,l_pmc081,l_pmc082,l_pmc091,
#          l_pmc092,l_pmc093,l_pmc094,l_pmc095
#      FROM pmc_file WHERE sr.pmm09 = pmc01
#      IF SQLCA.sqlcode THEN LET l_1mc03 = NULL
#         LET  l_pmc081 = NULL
#         LET  l_pmc082 = NULL
#         LET  l_pmc091 = NULL
#         LET  l_pmc092 = NULL
#         LET  l_pmc093 = NULL
#         LET  l_pmc094 = NULL
#         LET  l_pmc095 = NULL
#      END IF
#      SELECT pme031,pme032,pme033,pme034,pme035
#      INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
#      FROM pme_file
#      WHERE pme01=sr.pmm10 AND ( pme02 ='0' OR pme02= '2')
#      IF SQLCA.sqlcode THEN LET  l_pme031 = NULL
#          LET l_pme032 = NULL
#          LET l_pme033 = NULL
#          LET l_pme034 = NULL
#          LET l_pme035 = NULL
#       END IF
#      SELECT pme031,pme032,pme033,pme034,pme035
#      INTO lb_pme031,lb_pme032,lb_pme033,lb_pme034,lb_pme035
#      FROM pme_file
#      WHERE sr.pmm11=pme01 AND (pme02 = '1' OR pme02 = '2')
#      IF SQLCA.sqlcode THEN LET  lb_pme031 = NULL
#          LET lb_pme032 = NULL
#          LET lb_pme033 = NULL
#          LET lb_pme034 = NULL
#          LET lb_pme035 = NULL
#       END IF
#      PRINT COLUMN 1 ,g_x[17] CLIPPED,' ',sr.pmm09;
#      PRINT COLUMN 67,g_x[15]  CLIPPED,l_zo09
#      PRINT 09 SPACES,l_pmc081 CLIPPED,COLUMN 67,g_x[16]  CLIPPED,l_zo06    #TQC-6A0086
#      PRINT 09 SPACES,l_pmc082 CLIPPED,COLUMN 45,'-----------',g_x[19] CLIPPED,
#          '-----------',' ','-----------',g_x[20] CLIPPED,'-----------'
## 當無送貨地址或帳單地址時，需列印'同廠商地址'
#
#      IF cl_null(l_pme031) AND cl_null(l_pme032) AND cl_null(l_pme033) AND
#         cl_null(l_pme034) AND cl_null(l_pme035) THEN
#         LET l_pme031 = g_x[58] CLIPPED
#      END IF
#      IF cl_null(lb_pme031) AND cl_null(lb_pme032) AND cl_null(lb_pme033) AND
#         cl_null(lb_pme034) AND cl_null(lb_pme035) THEN
#         LET lb_pme031 = g_x[48] CLIPPED
#      END IF
#      PRINT 09 SPACES,l_pmc091 CLIPPED,COLUMN 45,l_pme031 CLIPPED,COLUMN 76,lb_pme031 CLIPPED   #TQC-6A0086
#      IF NOT cl_null(l_pmc092) OR NOT cl_null(l_pme032) OR
#         NOT cl_null(lb_pme032) THEN
#         PRINT 09 SPACES,l_pmc092 CLIPPED,COLUMN 45,l_pme032 CLIPPED,COLUMN 76,lb_pme032 CLIPPED  #TQC-6A0086
#      END IF
#      IF NOT cl_null(l_pmc093) OR cl_null(l_pme033) OR
#         NOT cl_null(lb_pme033) THEN
#         PRINT 09 SPACES,l_pmc093 CLIPPED,COLUMN 45,l_pme033 CLIPPED,COLUMN 76,lb_pme033 CLIPPED     #TQC-6A0086
#      END IF
#      IF NOT cl_null(l_pmc094) OR NOT cl_null(l_pme034) OR
#         NOT cl_null(lb_pme034) THEN
#         PRINT 09 SPACES,l_pmc094 CLIPPED,COLUMN 45,l_pme034 CLIPPED,COLUMN 76,lb_pme034 CLIPPED   #TQC-6A0086
#      END IF
#      IF NOT cl_null(l_pmc095) OR NOT cl_null(l_pme035) OR
#         NOT cl_null(lb_pme035) THEN
#         PRINT 09 SPACES,l_pmc095 CLIPPED,COLUMN 45,l_pme035 CLIPPED,COLUMN 76,lb_pme035 CLIPPED    #TQC-6A0086
#      END IF
#      PRINT g_dash[1,g_len]
## 列印請購部門及確認人
## 若員工代碼有相對的員工資料則列印員工姓名，否則就列印員工代碼即可
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE sr.pmm13=gem01
#      IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE sr.pmm15=gen01
#      IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
#	  SELECT pma02 INTO l_pmm20 FROM pma_file WHERE pma01 = sr.pmm20
#	  IF SQLCA.sqlcode THEN LET l_pmm20 = sr.pmm20 END IF
#      IF NOT cl_null(l_gem02) THEN
#         IF NOT cl_null(l_gen02) THEN
#            PRINT g_x[23] CLIPPED,' ',sr.pmm22 ,COLUMN 30,
#                  g_x[27] CLIPPED,' ',l_pmm20 ,COLUMN 70,
#                  g_x[21] CLIPPED,' ',l_gem02,COLUMN 90,
#                  g_x[22] CLIPPED,' ',l_gen02
#         ELSE
#            IF NOT cl_null(sr.pmm15) THEN
#               PRINT g_x[23] CLIPPED,' ',sr.pmm22,COLUMN 30,
#                     g_x[27] CLIPPED,' ',l_pmm20 CLIPPED,COLUMN 70,
#                     g_x[21] CLIPPED,' ',l_gem02,COLUMN 90,
#                     g_x[22] CLIPPED,' ',sr.pmm15
#            ELSE
#               PRINT g_x[23] CLIPPED,' ',sr.pmm22,COLUMN 30,
#                     g_x[27] CLIPPED,' ',l_pmm20 CLIPPED,COLUMN 70,
#                     g_x[21] CLIPPED,' ',l_gem02
#            END IF
#         END IF
#      ELSE
#         IF NOT cl_null(sr.pmm13) THEN
#            IF l_gen02 IS  NOT NULL THEN
#               PRINT g_x[23] CLIPPED,' ',sr.pmm22 ,COLUMN 30,
#                     g_x[27] CLIPPED,' ',l_pmm20 CLIPPED ,COLUMN 70,
#                     g_x[21] CLIPPED,' ',sr.pmm13,COLUMN 90,
#                     g_x[22] CLIPPED,' ',l_gen02
#            ELSE
#               IF NOT cl_null(sr.pmm15) THEN
#                  PRINT g_x[23] CLIPPED,' ',sr.pmm22,COLUMN 30,
#                        g_x[27] CLIPPED,' ',l_pmm20 CLIPPED,COLUMN 70,
#                        g_x[21] CLIPPED,' ',sr.pmm13,COLUMN 90,
#                        g_x[22] CLIPPED,' ',sr.pmm15
#               ELSE
#                  PRINT g_x[23] CLIPPED,' ',sr.pmm22,COLUMN 30,
#                        g_x[27] CLIPPED,' ',l_pmm20 CLIPPED,COLUMN 70,
#                        g_x[21] CLIPPED,' ',sr.pmm13
#               END IF
#            END IF
#         ELSE
#            IF NOT cl_null(l_gen02) THEN
#               PRINT g_x[23] CLIPPED,' ',sr.pmm22 ,COLUMN 30,
#                     g_x[27] CLIPPED,' ',l_pmm20 CLIPPED ,COLUMN 70,
#                     g_x[22] CLIPPED,' ',l_gen02
#            ELSE
#               IF NOT cl_null(sr.pmm15) THEN
#                  PRINT g_x[23] CLIPPED,' ',sr.pmm22,COLUMN 30,
#                        g_x[27] CLIPPED,' ',l_pmm20 CLIPPED,COLUMN 70,
#                        g_x[22] CLIPPED,' ',sr.pmm15
#               ELSE
#                  PRINT g_x[23] CLIPPED,' ',sr.pmm22,COLUMN 25,
#                        g_x[27] CLIPPED,' ',l_pmm20 CLIPPED
#               END IF
#            END IF
#         END IF
#      END IF
## 列印採購部門及採購員
## 若員工代碼有相對的員工資料則列印員工姓名，否則就列印員工代碼即可
#       SELECT gem02 INTO l_gem02 FROM gem_file WHERE sr.pmm14=gem01
#       IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF
#       SELECT gen02 INTO l_gen02 FROM gen_file WHERE sr.pmm12=gen01
#       IF SQLCA.sqlcode THEN LET l_gen02 = NULL END IF
#       SELECT oah02 INTO l_pmm41 FROM oah_file WHERE oah01=sr.pmm41
#       IF NOT cl_null(l_gem02) THEN
#           IF NOT cl_null(l_gen02) THEN
#              PRINT g_x[24] CLIPPED,' ',sr.pmm42 ,
#                    COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED ,
#                    COLUMN 70,g_x[25] CLIPPED,' ',l_gem02 CLIPPED,
#                    COLUMN 90,g_x[26] CLIPPED,' ',l_gen02 CLIPPED
#           ELSE
#              IF NOT cl_null(sr.pmm12) THEN
#                 PRINT g_x[24] CLIPPED,' ',sr.pmm42,
#                       COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED ,
#                       COLUMN 70,g_x[25] CLIPPED,' ',l_gem02 CLIPPED,
#                       COLUMN 90,g_x[26] CLIPPED,' ',sr.pmm12 CLIPPED
#              ELSE
#                 PRINT g_x[24] CLIPPED,' ',sr.pmm42 ,
#                       COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED ,
#                       COLUMN 70,g_x[25] CLIPPED,' ',l_gem02 CLIPPED
#              END IF
#           END IF
#       ELSE
#          IF NOT cl_null(sr.pmm14) THEN
#             IF NOT cl_null(l_gen02) THEN
#                PRINT g_x[24] CLIPPED,' ',sr.pmm42 ,
#                      COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED ,
#                      COLUMN 70,g_x[25] CLIPPED,' ',sr.pmm14 CLIPPED,
#                      COLUMN 90,g_x[26] CLIPPED,' ',l_gen02 CLIPPED
#             ELSE
#                IF NOT cl_null(sr.pmm12) THEN
#                   PRINT g_x[24] CLIPPED,' ',sr.pmm42,
#                         COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED ,
#                         COLUMN 70,g_x[25] CLIPPED,' ',sr.pmm14 CLIPPED,
#                         COLUMN 90,g_x[26] CLIPPED,' ',sr.pmm12 CLIPPED
#                ELSE
#                   PRINT g_x[24] CLIPPED,' ',sr.pmm42 ,
#                         COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED ,
#                         COLUMN 70,g_x[25] CLIPPED,' ',sr.pmm14 CLIPPED
#                END IF
#             END IF
#          ELSE
#             IF NOT cl_null(l_gen02) THEN
#                PRINT g_x[24] CLIPPED,' ',sr.pmm42 ,
#                      COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED ,
#                      COLUMN 70,g_x[26] CLIPPED,' ',l_gen02 CLIPPED
#             ELSE
#                IF NOT cl_null(sr.pmm12) THEN
#                   PRINT g_x[24] CLIPPED,' ',sr.pmm42,
#                         COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED ,
#                         COLUMN 70,g_x[26] CLIPPED,' ',sr.pmm12 CLIPPED
#                ELSE
#                   PRINT g_x[24] CLIPPED,' ',sr.pmm42,
#                         COLUMN 30,g_x[30] CLIPPED,' ',l_pmm41 CLIPPED
#                END IF
#             END IF
#          END IF
#       END IF
#{
##FOB 條件組合STRING
#       IF sr.pmm41 = 0 THEN
#           LET l_pmm41 ='     '
#       END IF
#       IF sr.pmm41 = 1  THEN
#           LET l_pmm41 = g_x[34] CLIPPED,g_x[35] CLIPPED
#       END IF
#       IF sr.pmm41 = 2  THEN
#           LET l_pmm41 = g_x[36] CLIPPED
#       END IF
#       IF sr.pmm41 = 3  THEN
#           LET l_pmm41 = g_x[34] CLIPPED, g_x[37] CLIPPED
#       END IF
#}
#      PRINT g_x[31] CLIPPED,' ',sr.pmm43 USING "<<<<&.<<",'% '
#    #       COLUMN 35,l_pmm41 CLIPPED;
#      IF NOT cl_null(sr.pmm16) THEN
#         PRINT COLUMN 61,g_x[28] CLIPPED,' ',sr.pmm16;
#      END IF
#      IF NOT cl_null(sr.pmm17) THEN
#         PRINT COLUMN 84,g_x[29] CLIPPED,' ',sr.pmm17
#      ELSE
#         PRINT ' '
#      END IF
# 
#      IF tm.a='Y' THEN
#      LET l_sql2 = l_sql1 CLIPPED," AND  pmo03 ='0'"," AND pmo04 = '0'"
#      PREPARE r901_prepare2 FROM l_sql2
#      DECLARE r901_note_cur2  CURSOR FOR r901_prepare2
#      LET l_count = 0
#      LET l_dash = 'Y'
#      FOREACH r901_note_cur2 INTO l_pmo06
#        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#           THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
#           IF l_dash='Y' THEN PRINT  g_dash[1,g_len] END IF
#           PRINT l_pmo06
#      LET  l_dash ='N'
#      END FOREACH
#      END IF
#
### No 2347  modify 98/07/06 ------------
##No.FUN-580004 --start--
#       IF g_head_flg='N' THEN
#           PRINTX name=H1 g_x[69],g_x[70],g_x[71],g_x[72],g_x[74],g_x[73],g_x[75],g_x[67],g_x[68],g_x[76],g_x[77],g_x[78] #TQC-5B0034
#           PRINTX name=H2 g_x[84],g_x[83],g_x[79],g_x[86],g_x[80],g_x[87],g_x[81],g_x[82]  #TQC-5B0034
#           PRINTX name=H3 g_x[88],g_x[89]   #FUN-640042 add
#           PRINT g_dash1
#          LET g_head_flg='Y'
#       END IF
### -------------------------------------
#     ELSE   # from on every row
#       IF l_pageno != g_pageno THEN
### No 2347  modify 98/07/06 ------------
#       IF g_head_flg='N' THEN
#          PRINT g_dash[1,g_len]
#          PRINTX name=H1 g_x[69],g_x[70],g_x[71],g_x[72],g_x[74],g_x[73],g_x[75],g_x[67],g_x[68],g_x[76],g_x[77],g_x[78] #TQC-5B0034
#          PRINTX name=H2 g_x[84],g_x[83],g_x[79],g_x[86],g_x[80],g_x[87],g_x[81],g_x[82]  #TQC-5B0034
#          PRINT g_dash1
#          LET g_head_flg='Y'
#       END IF
### -------------------------------------
#       END IF
#     END IF
#      LET l_pageno = g_pageno
#
#      IF tm.b = 'Y' THEN
#         LET l_sql3 = l_sql1 CLIPPED,
#                      " AND  pmo03 ='",sr.pmn02,"'  AND pmo04 = '0'"
#         PREPARE r901_prepare3 FROM l_sql3
#         DECLARE r901_note_cur3 CURSOR FOR r901_prepare3
#         LET l_rec   = l_rec+1
#         FOREACH r901_note_cur3 INTO l_pmo06
#           IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#              THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                   EXIT FOREACH END IF
#              PRINT l_pmo06
#         END FOREACH
#      END IF
#      LET l_rec=l_rec+1
### No 2347  modify 98/07/06 ------------
#      PRINT '';
#      IF g_head_flg='N' THEN
#         PRINT g_dash[1,g_len]
#         PRINTX name=H1 g_x[69],g_x[70],g_x[71],g_x[72],g_x[74],g_x[73],g_x[75],g_x[67],g_x[68],g_x[76],g_x[77],g_x[78] #TQC-5B0034
#         PRINTX name=H2 g_x[84],g_x[83],g_x[79],g_x[86],g_x[80],g_x[87],g_x[81],g_x[82]  #TQC-5B0034
#         PRINT g_dash1
#         LET g_head_flg='Y'
#      END IF
#
##No.FUN-580004 --start--
#      SELECT ima906 INTO l_ima906 FROM ima_file
#                         WHERE ima01=sr.pmn04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
#                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
#                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
#                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
#                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
#                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
#                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
#                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
#                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
#           #IF sr.pmn80 <> sr.pmn86 THEN     #No.TQC-6B0137  mark
#            IF sr.pmn07 <> sr.pmn86 THEN     #NO.TQC-6B0137  mod
#               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
#               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
#            END IF
#      END IF
#      PRINTX name=D1
#            COLUMN g_c[69],sr.pmn02 USING "####", #項次
#            COLUMN g_c[70],sr.pmn04 CLIPPED,  #FUN-5B0014 [1,20],    #料件編號
#            COLUMN g_c[71],sr.pmn33,   #交期
#            COLUMN g_c[72],sr.pmn15,   #提前交貨
#            COLUMN g_c[73],sr.pmn20 USING "----------&.&&&", #訂購量
#            COLUMN g_c[74],l_str2 CLIPPED, #單位注解No.FUN-580004
#            COLUMN g_c[75],sr.pmn07,   #單位
#            COLUMN g_c[67],sr.pmn86,
#            COLUMN g_c[68],sr.pmn87 USING "----------&.&&&",
#            COLUMN g_c[76],cl_numfor(sr.pmn31,76,sr.azi03) CLIPPED, #單價  #No:9559
#            #No.FUN-540027  --begin
#         #  COLUMN g_c[77],cl_numfor(sr.g_pmn,77,sr.azi04) CLIPPED, #金額  #No:9559
#            COLUMN g_c[77],cl_numfor(sr.pmn88,77,sr.azi04) CLIPPED, #未稅金額
#            #No.FUN-540027  --end
#            COLUMN g_c[78],sr.pmn64    #稅否
#      IF l_count = 0  THEN
##         PRINT 5 SPACES,sr.pmn041;
#      #No.FUN-540027  --begin
#      PRINTX name=D2
#            COLUMN g_c[83],sr.pmn041,
#            COLUMN g_c[81],cl_numfor(sr.pmn31t,81,sr.azi03) CLIPPED, #含稅單價  #No:9559
#            COLUMN g_c[82],cl_numfor(sr.pmn88t,82,sr.azi04) CLIPPED  #含稅金額
#      #No.FUN-540027  --end
#         LET l_count = 0
#      ELSE  
#         LET l_count = 0
#      END IF
#     #start FUN-640042 add
#      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.pmn04
#      IF STATUS THEN LET l_ima021 = '' END IF
#      PRINTX name=D3
#            COLUMN g_c[89],l_ima021 CLIPPED
#     #end FUN-640042 add
#      IF tm.b = 'Y' THEN
#      LET l_sql4 = l_sql1 CLIPPED,
#                   " AND  pmo03 ='",sr.pmn02,"'  AND pmo04 = '1'"
#      PREPARE r901_prepare4 FROM l_sql4
#      DECLARE r901_note_cur4 CURSOR FOR r901_prepare4
#      LET l_count = 0
#      FOREACH r901_note_cur4 INTO l_pmo06
#        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#           THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
#           PRINT l_pmo06
#      END FOREACH
#      END IF
#
#   AFTER GROUP OF sr.pmm01
#       #No.FUN-540027  --begin
#    #  LET g_total = GROUP SUM(sr.pmn20 *sr.pmn31)
#       LET g_total = GROUP SUM(sr.pmn88)
#       LET g_total1= GROUP SUM(sr.pmn88t)
#       #No.FUN-540027  --end
#       LET g_total = g_total +  l_sub
#       NEED 4 LINES   #No.FUN-540027
#       IF l_pageno != g_pageno THEN
#       PRINT g_dash[1,g_len]
#       PRINTX name=H1 g_x[69],g_x[70],g_x[71],g_x[72],g_x[74],g_x[73],g_x[75],g_x[67],g_x[68],g_x[76],g_x[77],g_x[78] #TQC-5B0034
#       PRINTX name=H2 g_x[84],g_x[83],g_x[79],g_x[86],g_x[80],g_x[87],g_x[81],g_x[82]  #TQC-5B0034
#       PRINT g_dash1
#       LET l_pageno = g_pageno
#       END IF
#       #No.FUN-540027  --begin
#       PRINTX name=S1 COLUMN g_c[76],g_x[38] CLIPPED,'(',sr.pmm22,'):' CLIPPED,
#                      COLUMN g_c[77],cl_numfor(g_total,82,sr.azi05)
#       PRINTX name=S2 COLUMN g_c[81],g_x[60] CLIPPED,'(',sr.pmm22,'):' CLIPPED,
#                      COLUMN g_c[82],cl_numfor(g_total1,82,sr.azi05)
#       #No.FUN-540027  --end
#       LET l_count = 0
#       LET l_rec= 0
#       IF tm.a='Y' THEN
#       LET l_sql5 = l_sql1 CLIPPED," AND  pmo03 ='0'"," AND pmo04 = '1'"
#       PREPARE r901_prepare5 FROM l_sql5
#       DECLARE r901_note_cur5 CURSOR FOR r901_prepare5
#       FOREACH r901_note_cur5 INTO l_pmo06
#        IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#           THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
#           PRINT l_pmo06
#      END FOREACH
#      END IF
#      NEED 2 LINES
#       IF l_pageno != g_pageno THEN
#       PRINT g_dash[1,g_len]
#       PRINTX name=H1 g_x[69],g_x[70],g_x[71],g_x[72],g_x[74],g_x[73],g_x[75],g_x[67],g_x[68],g_x[76],g_x[77],g_x[78] #TQC-5B0034
#       PRINTX name=H2 g_x[84],g_x[83],g_x[79],g_x[86],g_x[80],g_x[87],g_x[81],g_x[82]  #TQC-5B0034
#       PRINT g_dash1
#       LET l_pageno = g_pageno
#       END IF
#      PRINT g_x[49] CLIPPED,g_x[50] CLIPPED
#      PRINT g_x[51] CLIPPED,g_x[52] CLIPPED
#      SKIP 1 LINE
#      NEED 2 LINES
#       IF l_pageno != g_pageno THEN
#       PRINT g_dash[1,g_len]
#       PRINTX name=H1 g_x[69],g_x[70],g_x[71],g_x[72],g_x[74],g_x[73],g_x[75],g_x[67],g_x[68],g_x[76],g_x[77],g_x[78] #TQC-5B0034
#       PRINTX name=H2 g_x[84],g_x[83],g_x[79],g_x[86],g_x[80],g_x[87],g_x[81],g_x[82]  #TQC-5B0034
#       PRINT g_dash1
#       LET l_pageno = g_pageno
#       END IF
#     #FUN_550114
#     # PRINT COLUMN 49,g_x[39] CLIPPED,' ',g_x[40] CLIPPED
#     # PRINT COLUMN 49,
#     #       '         --------         --------         --------'
#     #END FUN_550114
#      UPDATE pmm_file SET pmmprno=pmmprno+1 WHERE pmm01 = sr.pmm01
#      LET g_pageno = 0
#      #LET l_last_sw='y'
##No.FUN-580004 ---end--
#ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN
#              PRINT g_dash[1,g_len]
#             #TQC-630166
#             #IF tm.wc[001,120] > ' ' THEN			# for 132
# 	     #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             #IF tm.wc[121,240] > ' ' THEN
# 	     #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             #IF tm.wc[241,300] > ' ' THEN
# 	     #	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#             #END TQC-630166
#      END IF
#      LET l_last_sw = 'y'
#      LET l_last_sw2 = 'y'
#
#   PAGE TRAILER
### FUN-550114
#     IF l_last_sw = 'n'
#     THEN
#            PRINT COLUMN (g_len-FGL_WIDTH(g_x[6]))/2, g_x[6]
#     ELSE
#            PRINT ' '
#     END IF
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
##            PRINT g_x[39]  #No.MOD-640172
#             PRINT g_memo
#         ELSE
##            PRINT          #No.MOD-640172
#             PRINT
#         END IF
#      ELSE
##            PRINT g_x[39]  #No.MOD-640172
#             PRINT g_memo
#      END IF
### END FUN-550114
#
#END REPORT
# 
##Patch....NO.TQC-610036 <001> #
