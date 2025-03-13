# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apmg200.4gl
# Descriptions...: 廠商資料表
# Input parameter:
# Date & Author..: 91/09/12 By Lin
# Modify.........: No.FUN-550091 05/05/25 By Smapmin 加印地區
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-650056 06/05/12 By Nicola 報表無寬度修改
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690025 06/09/15 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti 
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0079 06/10/31 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0089 06/11/07 By xumin報表調整
# Modify.........: No.FUN-710091 07/02/14 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.CHI-830006 08/05/08 By claire 子報表寫法調整
# Modify.........: No.MOD-880162 08/08/21 By Smapmin 性質/狀況欄位列印有誤
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50018 11/06/07 By xumm CR轉GRW
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-C40019 12/04/10 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/05/03 By yangtt GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500)  # Where condition
                state   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)    # 交易統計均為0者是否列印
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)    #Input more condition(Y/N)
              END RECORD,
          g_azm03        LIKE type_file.num5,   #No.FUN-680136 SMALLINT   # 季別
          g_aza17        LIKE aza_file.aza17    # 本國幣別
 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
#No.FUN-710091  --begin
DEFINE l_table           STRING
DEFINE l_table1          STRING
DEFINE l_table2          STRING
DEFINE g_sql             STRING
DEFINE g_str             STRING
#No.FUN-710091  --end  
###GENGRE###START
TYPE sr1_t RECORD
    pmc01 LIKE pmc_file.pmc01,
    pmc03 LIKE pmc_file.pmc03,
    pmc02 LIKE pmc_file.pmc02,
    pmc30 LIKE pmc_file.pmc30,
    pmc05 LIKE pmc_file.pmc05,
    pmc05_d LIKE type_file.chr8,
    pmc06 LIKE pmc_file.pmc06,
    gea02 LIKE gea_file.gea02,
    pmc07 LIKE pmc_file.pmc07,
    geb02 LIKE geb_file.geb02,
    pmc04 LIKE pmc_file.pmc04,
    pmc04_d LIKE pmc_file.pmc03,
    pmc17 LIKE pmc_file.pmc17,
    pmc908 LIKE pmc_file.pmc908,
    pmc081 LIKE pmc_file.pmc081,
    pmc082 LIKE pmc_file.pmc082,
    pmc091 LIKE pmc_file.pmc091,
    pmc092 LIKE pmc_file.pmc092,
    pmc093 LIKE pmc_file.pmc093,
    pmc094 LIKE pmc_file.pmc094,
    pmc095 LIKE pmc_file.pmc095,
    pmc52 LIKE pmc_file.pmc52,
    pmc53 LIKE pmc_file.pmc53,
    pmc55 LIKE pmc_file.pmc55,
    nmt02 LIKE nmt_file.nmt02,
    pmc56 LIKE pmc_file.pmc56,
    pmc10 LIKE pmc_file.pmc10,
    pmc11 LIKE pmc_file.pmc11,
    pmc12 LIKE pmc_file.pmc12,
    pmc40 LIKE pmc_file.pmc40,
    pmc41 LIKE pmc_file.pmc41,
    pmc42 LIKE pmc_file.pmc42,
    pmc43 LIKE pmc_file.pmc43,
    pmc44 LIKE pmc_file.pmc44,
    pmc13 LIKE pmc_file.pmc13,
    pmc13_d LIKE zaa_file.zaa08,
    pmc22 LIKE pmc_file.pmc22,
    azi02 LIKE azi_file.azi02,
    pmc17_1 LIKE pmc_file.pmc17,
    pma02 LIKE pma_file.pma02,
    pma03 LIKE pma_file.pma03,
    pma04 LIKE pma_file.pma04,
    pmc18 LIKE pmc_file.pmc18,
    pmc19 LIKE pmc_file.pmc19,
    pmc20 LIKE pmc_file.pmc20,
    pmc21 LIKE pmc_file.pmc21,
    pmc15 LIKE pmc_file.pmc15,
    pmc16 LIKE pmc_file.pmc16,
    pmc24 LIKE pmc_file.pmc24,
    pmc25 LIKE pmc_file.pmc25,
    pmc26 LIKE pmc_file.pmc26,
    pmc27 LIKE pmc_file.pmc27,
    pmc28 LIKE pmc_file.pmc28,
    pme031_1 LIKE pme_file.pme031,
    pme032_1 LIKE pme_file.pme032,
    pme033_1 LIKE pme_file.pme033,
    pme034_1 LIKE pme_file.pme034,
    pme035_1 LIKE pme_file.pme035,
    pme031_2 LIKE pme_file.pme031,
    pme032_2 LIKE pme_file.pme032,
    pme033_2 LIKE pme_file.pme033,
    pme034_2 LIKE pme_file.pme034,
    pme035_2 LIKE pme_file.pme035,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD

TYPE sr2_t RECORD
    pmd01 LIKE pmd_file.pmd01,
    pmd02 LIKE pmd_file.pmd02,
    pmd03 LIKE pmd_file.pmd03,
    pmd04 LIKE pmd_file.pmd04,
    pmd05 LIKE pmd_file.pmd05,
    pmd06 LIKE pmd_file.pmd06
END RECORD

TYPE sr3_t RECORD
    pmg01 LIKE pmg_file.pmg01,
    pmg02 LIKE pmg_file.pmg02,
    pmg03 LIKE pmg_file.pmg03
END RECORD
###GENGRE###END

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
#--------------No.TQC-610085 modify
   LET tm.state  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#--------------No.TQC-610085 end
   #No.FUN-710091  --begin
   LET g_sql= "pmc01.pmc_file.pmc01,",
              "pmc03.pmc_file.pmc03,",
              "pmc02.pmc_file.pmc02,",
              "pmc30.pmc_file.pmc30,",
              "pmc05.pmc_file.pmc05,",
              "pmc05_d.type_file.chr8,",
              "pmc06.pmc_file.pmc06,",
              "gea02.gea_file.gea02,",
              "pmc07.pmc_file.pmc07,",
              "geb02.geb_file.geb02,",
              "pmc04.pmc_file.pmc04,",
              "pmc04_d.pmc_file.pmc03,",
              "pmc17.pmc_file.pmc17,",
              "pmc908.pmc_file.pmc908,",
              "pmc081.pmc_file.pmc081,",
              "pmc082.pmc_file.pmc082,",
              "pmc091.pmc_file.pmc091,",
              "pmc092.pmc_file.pmc092,",
              "pmc093.pmc_file.pmc093,",
              "pmc094.pmc_file.pmc094,",
              "pmc095.pmc_file.pmc095,",
              "pmc52.pmc_file.pmc52,",
              "pmc53.pmc_file.pmc53,",
              "pmc55.pmc_file.pmc55,",
              "nmt02.nmt_file.nmt02,",
              "pmc56.pmc_file.pmc56,",
              "pmc10.pmc_file.pmc10,",
              "pmc11.pmc_file.pmc11,",
              "pmc12.pmc_file.pmc12,",
              "pmc40.pmc_file.pmc40,",
              "pmc41.pmc_file.pmc41,",
              "pmc42.pmc_file.pmc42,",
              "pmc43.pmc_file.pmc43,",
              "pmc44.pmc_file.pmc44,",
              "pmc13.pmc_file.pmc13,",
              "pmc13_d.zaa_file.zaa08,",
              "pmc22.pmc_file.pmc22,",
              "azi02.azi_file.azi02,",
              "pmc17_1.pmc_file.pmc17,",
              "pma02.pma_file.pma02,",
              "pma03.pma_file.pma03,",
              "pma04.pma_file.pma04,",
              "pmc18.pmc_file.pmc18,",
              "pmc19.pmc_file.pmc19,",
              "pmc20.pmc_file.pmc20,",
              "pmc21.pmc_file.pmc21,",
              "pmc15.pmc_file.pmc15,",
              "pmc16.pmc_file.pmc16,",
              "pmc24.pmc_file.pmc24,",
              "pmc25.pmc_file.pmc25,",
              "pmc26.pmc_file.pmc26,",
              "pmc27.pmc_file.pmc27,",
              "pmc28.pmc_file.pmc28,",
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
              "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
              "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
              "sign_show.type_file.chr1,",                       #FUN-C40019 add
              "sign_str.type_file.chr1000"                       #FUN-C40019 add
   LET l_table = cl_prt_temptable('apmg200',g_sql) CLIPPED
   IF  l_table = -1 THEN 
      
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
       EXIT PROGRAM
   END IF
  #LET g_sql ="pmc01.pmc_file.pmc01,",   #CHI-830006 mark
   LET g_sql ="pmd01.pmd_file.pmd01,",   #CHI-830006 
              "pmd02.pmd_file.pmd02,",
              "pmd03.pmd_file.pmd03,",   #CHI-830006 add ,
              "pmd04.pmd_file.pmd04,",   #CHI-830006 add
              "pmd05.pmd_file.pmd05,",   #CHI-830006 add
              "pmd06.pmd_file.pmd06"     #CHI-830006 add
   LET l_table1 = cl_prt_temptable('apmg2001',g_sql) CLIPPED
   IF  l_table1 = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
       EXIT PROGRAM
   END IF
  #LET g_sql ="pmc01.pmc_file.pmc01,",   #CHI-830006 mark
   LET g_sql ="pmg01.pmg_file.pmg01,",   #CHI-830006
              "pmg02.pmg_file.pmg02,",   #CHI-830006 add
              "pmg03.pmg_file.pmg03"
   LET l_table2 = cl_prt_temptable('apmg2002',g_sql) CLIPPED
   IF  l_table2 = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
       EXIT PROGRAM 
   END IF
   #No.FUN-710091  --end  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL apmg200_tm(0,0)		        # Input print condition
      ELSE CALL apmg200()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
END MAIN
 
FUNCTION apmg200_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01       #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000)
          l_azn02   LIKE azn_file.azn02,
          l_azn03   LIKE azn_file.azn03,
          l_azn04   LIKE azn_file.azn04
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW apmg200_w AT p_row,p_col WITH FORM "apm/42f/apmg200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
#  CALL cl_getmsg('mfg3059',g_lang) RETURNING g_msg	# 顯示操作方法
   DISPLAY g_msg CLIPPED AT 2,1
   INITIALIZE tm.* TO NULL		         	# Default condition
   LET tm.more = 'N'
   LET tm.state  = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
#  LET g_prtway= "Q"
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmc01,pmc02,pmc03
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
      LET INT_FLAG = 0 CLOSE WINDOW apmg200_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more,tm.state     #Condition
   INPUT BY NAME tm.state,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD state             #是否列印廠商重要資料
         IF tm.state  NOT MATCHES'[YN]' THEN
            NEXT FIELD state
         END IF
      AFTER FIELD more              #是否輸入其它列印條件
         IF tm.more   NOT MATCHES'[YN]' THEN
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
      LET INT_FLAG = 0 CLOSE WINDOW apmg200_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmg200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmg200','9031',1)
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
                         " '",tm.state CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmg200',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW apmg200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmg200()
   ERROR ""
END WHILE
   CLOSE WINDOW apmg200_w
END FUNCTION
 
FUNCTION apmg200()
   DEFINE l_name	LIKE type_file.chr20, 	 	 # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	 	 # Used time for running the job   #No.FUN-680136 VARCHAR(8)
      #   l_pmc01       LIKE apm_file.apm08,             # No.FUN-680136 VARCHAR(10)   #No.TQC-6A0079
          l_pmc02       LIKE pmc_file.pmc02,             # No.FUN-680136 VARCHAR(4)    #TQC-840066
          #l_sql 	LIKE type_file.chr1000,		 # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)
          l_sql        STRING,       #NO.FUN-910082
          l_za05	LIKE za_file.za05,               #No.FUN-680136 VARCHAR(40)
#No.FUN-710091  --begin
          #l_sqlr1       LIKE type_file.chr1000,
          #l_sqlr2	LIKE type_file.chr1000, 
          #l_sqlr3	LIKE type_file.chr1000, 
          #l_sqlr31	LIKE type_file.chr1000, 
          #l_sqlr32 	LIKE type_file.chr1000, 
          #l_sqlr4	LIKE type_file.chr1000, 
          #l_sqlr5	LIKE type_file.chr1000,
          l_sqlr1,l_sqlr2,l_sqlr3,l_sqlr31,l_sqlr32,l_sqlr4,_sqlr5        STRING,       #NO.FUN-910082 
          l_pmc03       LIKE pmc_file.pmc03,
          l_pmg02       LIKE pmg_file.pmg02,            #CHI-830006 add
          l_pmg03       LIKE pmg_file.pmg03,
          l_geo02       LIKE geo_file.geo02,        
#No.FUN-710091  --end  
          sr            RECORD
                        pmc01    LIKE pmc_file.pmc01,    #廠商編號
                        pmc03    LIKE pmc_file.pmc03,    #廠商簡稱
                        pmc02    LIKE pmc_file.pmc02,    #廠商分類
                        pmc30    LIKE pmc_file.pmc30,    #廠商性質   #No.FUN-680136 VARCHAR(10)
                        pmc05    LIKE pmc_file.pmc05,    #狀況
                        pmc05_d  LIKE type_file.chr8,    #狀況說明   #No.FUN-680136 VARCHAR(8)
                        pmc06    LIKE pmc_file.pmc06,    #區域
                        gea02    LIKE gea_file.gea02,    #區域名稱
                        pmc07    LIKE pmc_file.pmc07,    #國別
                        geb02    LIKE geb_file.geb02,    #國別名稱
                        pmc04    LIKE pmc_file.pmc04,    #付款廠商
                        pmc04_d  LIKE pmc_file.pmc03,    #付款廠商簡稱
                        pmc17    LIKE pmc_file.pmc17,    #付款方式
                        pmc908   LIKE pmc_file.pmc908    #地區編號   #FUN-550091
                        END RECORD,
#No.FUN-710091  --begin
          t1            RECORD
                        pmc081   LIKE pmc_file.pmc081,   #名稱
                        pmc082   LIKE pmc_file.pmc082,   #名稱
                        pmc091   LIKE pmc_file.pmc091,   #地址第一行
                        pmc092   LIKE pmc_file.pmc092,   #地址第二行
                        pmc093   LIKE pmc_file.pmc093,   #地址第三行
                        pmc094   LIKE pmc_file.pmc094,   #地址第四行
                        pmc095   LIKE pmc_file.pmc095,   #地址第五行
                        pmc52    LIKE pmc_file.pmc52,    #發票地址
                        pmc53    LIKE pmc_file.pmc53,    #寄票地址
                        pmc55    LIKE pmc_file.pmc55,    #匯款銀行(代號)
                        nmt02    LIKE nmt_file.nmt02,    #匯款銀行(明稱)
                        pmc56    LIKE pmc_file.pmc56,    #匯款帳號
                        pmc10    LIKE pmc_file.pmc10,    #電話
                        pmc11    LIKE pmc_file.pmc11,    #傳真
                        pmc12    LIKE pmc_file.pmc12,    #電傳
                        pmc40    LIKE pmc_file.pmc40,    #最近下單日
                        pmc41    LIKE pmc_file.pmc41,    #最近交貨日
                        pmc42    LIKE pmc_file.pmc42,    #最近退貨日
                        pmc43    LIKE pmc_file.pmc43,    #最近傳票日
                        pmc44    LIKE pmc_file.pmc44,    #最近付款日
                        pmc13    LIKE pmc_file.pmc13,    #VAT 特性
                        pmc13_d  LIKE zaa_file.zaa08,    #特性說明  #No.FUN-680136 VARCHAR(12)
                        pmc22    LIKE pmc_file.pmc22,    #幣別
                        azi02    LIKE azi_file.azi02,    #幣別說明
                        pmc17    LIKE pmc_file.pmc17,    #付款方式
                        pma02    LIKE pma_file.pma02,    #付款條件
                        pma03    LIKE pma_file.pma03,    #付款天數
                        pma04    LIKE pma_file.pma04,    #折扣率
                        pmc18    LIKE pmc_file.pmc18,    #ABC 等級
                        pmc19    LIKE pmc_file.pmc19,    #交貨等級
                        pmc20    LIKE pmc_file.pmc20,    #品質等級
                        pmc21    LIKE pmc_file.pmc21,    #價格等級
                        pmc15    LIKE pmc_file.pmc15,    #送貨地址
                        pmc16    LIKE pmc_file.pmc16,    #帳單地址
                        pmc24    LIKE pmc_file.pmc24,    #統一編號
                        pmc25    LIKE pmc_file.pmc25,    #付款行事曆別
                        pmc26    LIKE pmc_file.pmc26,    #應付帳款會計科目
                        pmc27    LIKE pmc_file.pmc27,    #應付票據會計科目
                        pmc28    LIKE pmc_file.pmc28     #預付費用會計科目
                        END RECORD,
          t2            RECORD             #送貨地址
                        pme031   LIKE pme_file.pme031,
                        pme032   LIKE pme_file.pme032,
                        pme033   LIKE pme_file.pme033,
                        pme034   LIKE pme_file.pme034,
                        pme035   LIKE pme_file.pme035
                        END RECORD,
          t3            RECORD             #帳單地址
                        pme031   LIKE pme_file.pme031,
                        pme032   LIKE pme_file.pme032,
                        pme033   LIKE pme_file.pme033,
                        pme034   LIKE pme_file.pme034,
                        pme035   LIKE pme_file.pme035
                        END RECORD,
          t4            RECORD          #聯絡人資料
                        pmd02    LIKE pmd_file.pmd02,
                        pmd03    LIKE pmd_file.pmd03,
                        pmd04    LIKE pmd_file.pmd04, #CHI-830006 add,
                        pmd05    LIKE pmd_file.pmd05, #CHI-830006 add
                        pmd06    LIKE pmd_file.pmd06  #CHI-830006
                        END RECORD
#No.FUN-710091  --end  
     DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add

 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004-----------Begin------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004-----------End------ 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND pmcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
     #End:FUN-980030
     #No.FUN-710091  --begin
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
   
     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?)"   #FUN-C40019 add 4?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,   #TQC-780049
                 " VALUES(?,?,?,?,?,?)"   #CHI-830006 add ?,?
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,   #TQC-780049
                 " VALUES(?,?,?)"   #CHI-830006 add ?
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep2:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)   #FUN-B50018  add
        EXIT PROGRAM
     END IF
     #No.FUN-710091  --end  
 
 
     #廠商編號
     LET l_sql = "SELECT pmc01,pmc03,pmc02,pmc30,pmc05,' ',pmc06, ",
                 #"       gea02,pmc07,geb02,pmc04,' ',pmc17 ",   #FUN-550091
                 "       gea02,pmc07,geb02,pmc04,' ',pmc17,pmc908 ",   #FUN-550091
            #    " FROM pmc_file ,OUTER gea_file, OUTER geb_file",   #FUN-C50003 mark
            #    " WHERE pmc_file.pmc06=gea_file.gea01 AND pmc_file.pmc07=geb_file.geb01 AND ",   #FUN-C50003 mark
                 " FROM pmc_file LEFT OUTER JOIN gea_file ON pmc06=gea01",          #FUN-C50003 add
                 "               LEFT OUTER JOIN geb_file ON pmc07=geb01",          #FUN-C50003 add
                 " WHERE (pmcacti = 'Y' OR pmcacti IS NULL) ",                      #FUN-C50003 add
            #    "       (pmcacti = 'Y' OR pmcacti IS NULL) ",                      #FUN-C50003 mark
                 " AND ",tm.wc ,
                 " ORDER BY 3,1 "
 
     PREPARE apmg200_prepare  FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM 
     END IF
     DECLARE apmg200_cs  CURSOR FOR apmg200_prepare
 
    #CALL cl_outnam('apmg200') RETURNING l_name #No.FUN-710091
     #-----No.MOD-650056-----
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmg200'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #-----No.MOD-650056 END-----
    #START REPORT apmg200_rep TO l_name  #No.FUN-710091
     LET g_pageno = 0

     #FUN-C50003-----add----str---
      #送貨地址 帳單地址
      LET l_sqlr3 = "SELECT pme031,pme032,pme033,pme034,pme035 ",
                    "  FROM pme_file ",
                    " WHERE pme01= ? "

      #送貨地址
      LET l_sqlr31=l_sqlr3 CLIPPED," AND (pme02='0' OR pme02='2') "
      PREPARE apmg200_pr3  FROM l_sqlr31
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
          THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
          EXIT PROGRAM
          END IF
      DECLARE apmg200_prt3  CURSOR FOR apmg200_pr3

      #帳單地址
      LET l_sqlr32=l_sqlr3 CLIPPED," AND (pme02='1' OR pme02='2') "
      PREPARE apmg200_pr4   FROM l_sqlr32
      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100
          THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
          EXIT PROGRAM
          END IF
      DECLARE apmg200_prt4  CURSOR FOR apmg200_pr4

     #聯絡人
      LET l_sqlr4 = "SELECT pmd02,pmd03,pmd04,pmd05,pmd06 ",   #CHI-830006 add pmd05,pmd06
                    "  FROM pmd_file ",
                    " WHERE pmd01= ?"
      PREPARE apmg200_pr5   FROM l_sqlr4
      IF SQLCA.sqlcode != 0  AND SQLCA.sqlcode != 100
          THEN CALL cl_err('prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
          EXIT PROGRAM
          END IF
      DECLARE apmg200_prt5  CURSOR FOR apmg200_pr5

      DECLARE apmg200_prt6  CURSOR FOR
         SELECT pmg03,pmg02           
           FROM pmg_file  WHERE pmg01=?
     #FUN-C50003-----add----end---
 
     FOREACH apmg200_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
       END IF
       #-----MOD-880162---------
       #CASE                   # 廠商性質
       #   WHEN sr.pmc30='1' LET sr.pmc30=g_x[89] CLIPPED
       #   WHEN sr.pmc30='2' LET sr.pmc30=g_x[90] CLIPPED
       #   WHEN sr.pmc30='3' LET sr.pmc30=g_x[91] CLIPPED
       #END CASE
       #CASE                    # 廠商狀況
       ##  WHEN sr.pmc05='0' LET sr.pmc05_d=g_x[92] CLIPPED No.FUN-690025
       ##  WHEN sr.pmc05='1' LET sr.pmc05_d=g_x[93] CLIPPED NO.FUN-690025
       ##  WHEN sr.pmc05='2' LET sr.pmc05_d=g_x[94] CLIPPED NO.FUN-690025
       #   WHEN sr.pmc05='1' LET sr.pmc05_d=g_x[92] CLIPPED
       #   WHEN sr.pmc05='0' LET sr.pmc05_d=g_x[93] CLIPPED
       #   WHEN sr.pmc05='3' LET sr.pmc05_d=g_x[94] CLIPPED
       #END CASE
       #-----END MOD-880162-----
       #付款廠商簡稱
       IF sr.pmc04 IS NOT NULL THEN
          SELECT pmc03 INTO sr.pmc04_d
            FROM pmc_file
           WHERE pmc01=sr.pmc04
       END IF
      #    OUTPUT TO REPORT apmg200_rep(sr.*)   #No.FUN-710091  
      #No.FUN-710091  --begin
      #組合SQL,名稱 地址 電話 傳真 電傳 VAT特性 FOB條件 幣別
      #        付款條件 評鑑等級 ......
      LET l_sqlr1 = "SELECT pmc081,pmc082,pmc091,pmc092,pmc093, ",
                    "       pmc094,pmc095,pmc52,pmc53,pmc55,nmt02,pmc56,",
                    "       pmc10,pmc11,pmc12,pmc40,",
                    "       pmc41,pmc42,pmc43,pmc44,pmc13,' ',",
                    "       pmc22,' ',pmc17,pma02,pma03,pma04,",
                    "       pmc18,pmc19,pmc20,pmc21,pmc15,pmc16,",
                    "       pmc24,pmc25,pmc26,pmc27,pmc28 ",
                #   " FROM pmc_file ,OUTER pma_file,OUTER nmt_file",         #FUN-C50003 mark 
                #   " WHERE pmc01= ? AND pmc_file.pmc17=pma_file.pma01 ",    #FUN-C50003 mark
                #   "   AND pmc_file.pmc55=nmt_file.nmt01"                   #FUN-C50003 mark
                    " FROM pmc_file LEFT OUTER JOIN pma_file ON pmc17=pma01",#FUN-C50003 add
                    "               LEFT OUTER JOIN nmt_file ON pmc55=nmt01",#FUN-C50003 add
                    " WHERE pmc01= ?"                                        #FUN-C50003 add
 
      IF sr.pmc17 IS NOT NULL AND sr.pmc01 != ' ' THEN
          LET l_sqlr1=l_sqlr1 CLIPPED,
                    " AND pma01= '",sr.pmc17,"'"
      END IF
     #FUN-C50003-----mark---str---
     ##送貨地址 帳單地址
     #LET l_sqlr3 = "SELECT pme031,pme032,pme033,pme034,pme035 ",
     #              "  FROM pme_file ",
     #              " WHERE pme01= ? "
     #FUN-C50003-----mark---end---
      PREPARE apmg200_psr1   FROM l_sqlr1
      IF SQLCA.sqlcode != 0  AND SQLCA.sqlcode !=100
           THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
           CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
           EXIT PROGRAM 
           END IF
      DECLARE apmg200_psrt1  CURSOR FOR apmg200_psr1
 
       OPEN apmg200_psrt1  USING sr.pmc01
       FETCH apmg200_psrt1  INTO t1.*
       IF t1.pmc22 IS NOT NULL THEN
          SELECT azi02  INTO t1.azi02
            FROM azi_file WHERE azi01= t1.pmc22
       END IF
      CLOSE apmg200_psrt1
       # VAT 特性
       CASE
          WHEN t1.pmc13='0' LET t1.pmc13_d=g_x[77] CLIPPED
          WHEN t1.pmc13='1' LET t1.pmc13_d=g_x[78] CLIPPED
          WHEN t1.pmc13='2' LET t1.pmc13_d=g_x[79] CLIPPED
          WHEN t1.pmc13='3' LET t1.pmc13_d=g_x[80] CLIPPED
          WHEN t1.pmc13='4' LET t1.pmc13_d=g_x[81] CLIPPED
       END CASE
 
     #FUN-C50003-----mark---str---
     ##送貨地址
     #LET l_sqlr31=l_sqlr3 CLIPPED," AND (pme02='0' OR pme02='2') "
     #PREPARE apmg200_pr3  FROM l_sqlr31
     #IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
     #    THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
     #    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
     #    CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
     #    EXIT PROGRAM 
     #    END IF
     #DECLARE apmg200_prt3  CURSOR FOR apmg200_pr3
     #FUN-C50003-----mark---end---
      IF t1.pmc15 IS NOT NULL THEN
       OPEN apmg200_prt3  USING t1.pmc15
       FETCH apmg200_prt3  INTO t2.*
      END IF
      CLOSE apmg200_prt3
 
     #FUN-C50003-----mark---str---
     ##帳單地址
     #LET l_sqlr32=l_sqlr3 CLIPPED," AND (pme02='1' OR pme02='2') "
     #PREPARE apmg200_pr4   FROM l_sqlr32
     #IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100
     #    THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
     #    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
     #    CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
     #    EXIT PROGRAM 
     #    END IF
     #DECLARE apmg200_prt4  CURSOR FOR apmg200_pr4
     #FUN-C50003-----mark---end---
      IF t1.pmc15 IS NOT NULL THEN
       OPEN apmg200_prt4  USING t1.pmc16
       FETCH apmg200_prt4  INTO t3.*
      END IF
      CLOSE apmg200_prt4
 
      IF t1.pmc15 IS NULL  OR (t2.pme031 IS NULL AND t2.pme032 IS NULL
         AND t2.pme033 IS NULL AND t2.pme034 IS NULL AND t2.pme034 IS NULL)
      THEN LET t2.pme031=g_x[95] END IF
      IF t1.pmc16 IS NULL  OR (t3.pme031 IS NULL AND t3.pme032 IS NULL
         AND t3.pme033 IS NULL AND t3.pme034 IS NULL AND t3.pme034 IS NULL)
      THEN LET t3.pme031=g_x[95] END IF
 
     #FUN-C50003-----mark---str---
  #  #聯絡人
     #LET l_sqlr4 = "SELECT pmd02,pmd03,pmd04,pmd05,pmd06 ",   #CHI-830006 add pmd05,pmd06
     #              "  FROM pmd_file ",
     #              " WHERE pmd01= '",sr.pmc01,"'"
     #PREPARE apmg200_pr5   FROM l_sqlr4
     #IF SQLCA.sqlcode != 0  AND SQLCA.sqlcode != 100
     #    THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
     #    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
     #    CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
     #    EXIT PROGRAM 
     #    END IF
     #DECLARE apmg200_prt5  CURSOR FOR apmg200_pr5
     #FUN-C50003-----mark---end---
      FOREACH apmg200_prt5 USING sr.pmc01 INTO t4.*     #FUN-C50003 add USING sr.pmc01
           EXECUTE insert_prep1 USING sr.pmc01,t4.*
      END FOREACH
  
     #FUN-C50003-----mark---str---
     #DECLARE apmg200_prt6  CURSOR FOR
     #   SELECT pmg03,pmg02                       #CHI-830006 add pmg02
     #     FROM pmg_file  WHERE pmg01=sr.pmc01
     #FUN-C50003-----mark---end---
      FOREACH apmg200_prt6 USING sr.pmc01 INTO l_pmg03,l_pmg02   #CHI-830006 add l_pmg02   #FUN-C50003 add USING sr.pmc01
           EXECUTE insert_prep2 USING sr.pmc01,l_pmg02,l_pmg03  #CHI-830006 add l_pmg02
      END FOREACH
      EXECUTE insert_prep USING sr.*,t1.*,t2.*,t3.*,          #No.FUN-710091
                                "",l_img_blob,"N",""    #FUN-C40019 add
      #No.FUN-710091  --end  
 
     END FOREACH

     LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
     LET g_cr_apr_key_f = "pmc01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
     #CHI-830006-begin-modify
     ##No.FUN-710091  --begin
     #LET g_sql ="SELECT A.*,B.*,C.*",
   ##TQC-730088# "  FROM ",l_table CLIPPED," A,",
     #         #           l_table1 CLIPPED," B,",
     #         #           l_table2 CLIPPED," C",
     #           "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A,",
     #                     g_cr_db_str CLIPPED,l_table1 CLIPPED," B,",
     #                     g_cr_db_str CLIPPED,l_table2 CLIPPED," C ",
     #           " WHERE A.pmc01 = B.pmc01(+)",
     #           "   AND A.pmc01 = C.pmc01(+)" 
###GENGRE###     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED  
     #CHI-830006-end-modify
     CALL cl_wcchp(tm.wc,'pmc01,pmc02,pmc03') RETURNING  tm.wc
###GENGRE###     LET g_str = tm.wc,";",tm.state
   # CALL cl_prt_cs3("apmg200",g_sql,g_str)   #TQC-730088
###GENGRE###     CALL cl_prt_cs3("apmg200",'apmg200',g_sql,g_str)
    CALL apmg200_grdata()    ###GENGRE###
     #No.FUN-710091  --end  
 
    #FINISH REPORT apmg200_rep   #No.FUN-710091  
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710091 
END FUNCTION
#No.FUN-710091  --begin
#REPORT apmg200_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#          l_i           LIKE type_file.num5,    #No.FUN-680136 SMALLINT
#          l_sqlr1       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000) # RDSQL STATEMENT
#          l_sqlr2	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000) # RDSQL STATEMENT 
#          l_sqlr3	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000) # RDSQL STATEMENT 
#          l_sqlr31	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000) # RDSQL STATEMENT 
#          l_sqlr32 	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000) # RDSQL STATEMENT 
#          l_sqlr4	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000) # RDSQL STATEMENT 
#          l_sqlr5	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(1000) # RDSQL STATEMENT 
#          l_pmc03  LIKE pmc_file.pmc03,
#          l_pmg03  LIKE pmg_file.pmg03,
#          l_geo02  LIKE geo_file.geo02,         #FUN-550091
#          sr            RECORD
#                        pmc01    LIKE pmc_file.pmc01,    #廠商編號
#                        pmc03    LIKE pmc_file.pmc03,    #廠商簡稱
#                        pmc02    LIKE pmc_file.pmc02,    #廠商分類
#                     #  pmc30    LINK pmc_file.pmc30,    #廠商性質
#                        pmc30    LIKE pmc_file.pmc30,    #廠商性質   #No.FUN-680136 VARCHAR(10)
#                        pmc05    LIKE pmc_file.pmc05,    #狀況
#                        pmc05_d  LIKE type_file.chr8,    #狀況說明   #No.FUN-680136 VARCHAR(8)
#                        pmc06    LIKE pmc_file.pmc06,    #區域
#                        gea02    LIKE gea_file.gea02,    #區域名稱
#                        pmc07    LIKE pmc_file.pmc07,    #國別
#                        geb02    LIKE geb_file.geb02,    #國別名稱
#                        pmc04    LIKE pmc_file.pmc04,    #付款廠商
#                        pmc04_d  LIKE pmc_file.pmc03,    #付款廠商簡稱
#                        pmc17    LIKE pmc_file.pmc17,    #付款方式
#                        pmc908   LIKE pmc_file.pmc908    #地區編號
#                        END RECORD,
#          t1            RECORD
#                        pmc081   LIKE pmc_file.pmc081,   #名稱
#                        pmc082   LIKE pmc_file.pmc082,   #名稱
#                        pmc091   LIKE pmc_file.pmc091,   #地址第一行
#                        pmc092   LIKE pmc_file.pmc092,   #地址第二行
#                        pmc093   LIKE pmc_file.pmc093,   #地址第三行
#                        pmc094   LIKE pmc_file.pmc094,   #地址第四行
#                        pmc095   LIKE pmc_file.pmc095,   #地址第五行
#                        pmc52    LIKE pmc_file.pmc52,    #發票地址
#                        pmc53    LIKE pmc_file.pmc53,    #寄票地址
#                        pmc55    LIKE pmc_file.pmc55,    #匯款銀行(代號)
#                        nmt02    LIKE nmt_file.nmt02,    #匯款銀行(明稱)
#                        pmc56    LIKE pmc_file.pmc56,    #匯款帳號
#                        pmc10    LIKE pmc_file.pmc10,    #電話
#                        pmc11    LIKE pmc_file.pmc11,    #傳真
#                        pmc12    LIKE pmc_file.pmc12,    #電傳
#                        pmc40    LIKE pmc_file.pmc40,    #最近下單日
#                        pmc41    LIKE pmc_file.pmc41,    #最近交貨日
#                        pmc42    LIKE pmc_file.pmc42,    #最近退貨日
#                        pmc43    LIKE pmc_file.pmc43,    #最近傳票日
#                        pmc44    LIKE pmc_file.pmc44,    #最近付款日
#                        pmc13    LIKE pmc_file.pmc13,    #VAT 特性
#                        pmc13_d  LIKE zaa_file.zaa08,    #特性說明  #No.FUN-680136 VARCHAR(12)
#                        pmc22    LIKE pmc_file.pmc22,    #幣別
#                        azi02    LIKE azi_file.azi02,    #幣別說明
#                        pmc17    LIKE pmc_file.pmc17,    #付款方式
#                        pma02    LIKE pma_file.pma02,    #付款條件
#                        pma03    LIKE pma_file.pma03,    #付款天數
#                        pma04    LIKE pma_file.pma04,    #折扣率
#                        pmc18    LIKE pmc_file.pmc18,    #ABC 等級
#                        pmc19    LIKE pmc_file.pmc19,    #交貨等級
#                        pmc20    LIKE pmc_file.pmc20,    #品質等級
#                        pmc21    LIKE pmc_file.pmc21,    #價格等級
#                        pmc15    LIKE pmc_file.pmc15,    #送貨地址
#                        pmc16    LIKE pmc_file.pmc16,    #帳單地址
#                        pmc24    LIKE pmc_file.pmc24,    #統一編號
#                        pmc25    LIKE pmc_file.pmc25,    #付款行事曆別
#                        pmc26    LIKE pmc_file.pmc26,    #應付帳款會計科目
#                        pmc27    LIKE pmc_file.pmc27,    #應付票據會計科目
#                        pmc28    LIKE pmc_file.pmc28     #預付費用會計科目
#                        END RECORD,
#          t2            RECORD             #送貨地址
#                        pme031   LIKE pme_file.pme031,
#                        pme032   LIKE pme_file.pme032,
#                        pme033   LIKE pme_file.pme033,
#                        pme034   LIKE pme_file.pme034,
#                        pme035   LIKE pme_file.pme035
#                        END RECORD,
#          t3            RECORD             #帳單地址
#                        pme031   LIKE pme_file.pme031,
#                        pme032   LIKE pme_file.pme032,
#                        pme033   LIKE pme_file.pme033,
#                        pme034   LIKE pme_file.pme034,
#                        pme035   LIKE pme_file.pme035
#                        END RECORD,
#          t4            RECORD          #聯絡人資料
#                        pmd02    LIKE pmd_file.pmd02,
#                        pmd03    LIKE pmd_file.pmd03,
#                        pmd04    LIKE pmd_file.pmd04
#                        END RECORD
#
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pmc02,sr.pmc01
#  FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_today,'  ',TIME,
#            COLUMN g_len-10,g_x[3] CLIPPED,g_pageno USING '<<<'
#   #        COLUMN (g_len-FGL_WIDTH(g_user)-5),g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.pmc01
#      LET l_last_sw = 'n'
#      IF PAGENO >1 OR LINENO > 9 THEN
#         LET l_last_sw = 'y'  #判斷是否印完一個廠商資料
#         SKIP TO TOP OF PAGE
#      END IF
#      INITIALIZE t1.* TO NULL
#      INITIALIZE t2.* TO NULL
#      INITIALIZE t3.* TO NULL
#      INITIALIZE t4.* TO NULL
#
#   ON EVERY ROW
#      #廠商編號
#      SELECT geo02 INTO l_geo02 FROM geo_file WHERE geo01=sr.pmc908
#      PRINT COLUMN 01,g_x[11] CLIPPED,
#            COLUMN 11,sr.pmc01,
#            COLUMN 43,g_x[23] CLIPPED,
#            COLUMN 55,sr.pmc06,
#            COLUMN 60,sr.gea02
#      PRINT COLUMN 01,g_x[12] CLIPPED,
#            COLUMN 11,sr.pmc03,
#            COLUMN 43,g_x[24] CLIPPED,
#            COLUMN 55,sr.pmc07,
#            COLUMN 60,sr.geb02
#      PRINT COLUMN 01,g_x[13] CLIPPED,
#            COLUMN 11,sr.pmc02,
#            COLUMN 43,g_x[100] CLIPPED,   #FUN-550091
#            COLUMN 55,sr.pmc908,   #FUN-550091
#            COLUMN 60,l_geo02   #FUN-550091
#      PRINT COLUMN 01,g_x[14] CLIPPED,
#            COLUMN 11,sr.pmc30,
#            COLUMN 45,g_x[25] CLIPPED,
#            COLUMN 55,sr.pmc04
#      SELECT pmc03 INTO sr.pmc04_d     #付款廠商的簡稱
#        FROM pmc_file
#       WHERE pmc01=sr.pmc04
#      PRINT COLUMN 01,g_x[15] CLIPPED,
#            COLUMN 11,sr.pmc05,
#            COLUMN 13,sr.pmc05_d,
#            COLUMN 45,g_x[12] CLIPPED,
#            COLUMN 55,sr.pmc04_d
#      #組合SQL,名稱 地址 電話 傳真 電傳 VAT特性 FOB條件 幣別
#      #        付款條件 評鑑等級 ......
#      LET l_sqlr1 = "SELECT pmc081,pmc082,pmc091,pmc092,pmc093, ",
#                    "       pmc094,pmc095,pmc52,pmc53,pmc55,nmt02,pmc56,",
#                    "       pmc10,pmc11,pmc12,pmc40,",
#                    "       pmc41,pmc42,pmc43,pmc44,pmc13,' ',",
#                    "       pmc22,' ',pmc17,pma02,pma03,pma04,",
#                    "       pmc18,pmc19,pmc20,pmc21,pmc15,pmc16,",
#                    "       pmc24,pmc25,pmc26,pmc27,pmc28 ",
#                    " FROM pmc_file ,OUTER pma_file,OUTER nmt_file",
#                    " WHERE pmc01= ? AND pmc17=pma01 ",
#                    "   AND pmc55=nmt01"
# 
#      IF sr.pmc17 IS NOT NULL AND sr.pmc01 != ' ' THEN
#          LET l_sqlr1=l_sqlr1 CLIPPED,
#                    " AND pma01= '",sr.pmc17,"'"
#      END IF
#      #送貨地址 帳單地址
#      LET l_sqlr3 = "SELECT pme031,pme032,pme033,pme034,pme035 ",
#                    "  FROM pme_file ",
#                    " WHERE pme01= ? "
#      PREPARE apmg200_psr1   FROM l_sqlr1
#      IF SQLCA.sqlcode != 0  AND SQLCA.sqlcode !=100
#           THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#           EXIT PROGRAM 
#           END IF
#      DECLARE apmg200_psrt1  CURSOR FOR apmg200_psr1
# 
#       OPEN apmg200_psrt1  USING sr.pmc01
#       FETCH apmg200_psrt1  INTO t1.*
#       IF t1.pmc22 IS NOT NULL THEN
#          SELECT azi02  INTO t1.azi02
#            FROM azi_file WHERE azi01= t1.pmc22
#       END IF
#      CLOSE apmg200_psrt1
#       # VAT 特性
#       CASE
#          WHEN t1.pmc13='0' LET t1.pmc13_d=g_x[77] CLIPPED
#          WHEN t1.pmc13='1' LET t1.pmc13_d=g_x[78] CLIPPED
#          WHEN t1.pmc13='2' LET t1.pmc13_d=g_x[79] CLIPPED
#          WHEN t1.pmc13='3' LET t1.pmc13_d=g_x[80] CLIPPED
#          WHEN t1.pmc13='4' LET t1.pmc13_d=g_x[81] CLIPPED
#       END CASE
#
#      SKIP 1 LINE
#      # 列印名稱 電話  地址 ...
#      PRINT COLUMN 01,g_x[16] CLIPPED,
#     #       COLUMN 11,t1.pmc081,
#            COLUMN 11,t1.pmc081[1,30],  #No.TQC-6A0089
#            COLUMN 43,g_x[26] CLIPPED,
#            COLUMN 55,t1.pmc10
#   #   PRINT COLUMN 11,t1.pmc082,
#      PRINT COLUMN 11,t1.pmc082[1,30],   #No.TQC-6A0089
#            COLUMN 43,g_x[27] CLIPPED,
#            COLUMN 55,t1.pmc11
#      PRINT COLUMN 01,g_x[17] CLIPPED,
#            COLUMN 11,t1.pmc091,
#            COLUMN 43,g_x[28] CLIPPED,
#            COLUMN 55,t1.pmc12
#      PRINT COLUMN 11,t1.pmc092
#      PRINT COLUMN 11,t1.pmc093,COLUMN 43,g_x[29] CLIPPED,
#            COLUMN 55,t1.pmc40
#      PRINT COLUMN 11,t1.pmc094,COLUMN 43,g_x[30] CLIPPED,
#            COLUMN 55,t1.pmc41
#      PRINT COLUMN 11,t1.pmc095,COLUMN 43,g_x[31] CLIPPED,
#            COLUMN 55,t1.pmc42
#      PRINT COLUMN 01,g_x[96] CLIPPED,
#            COLUMN 11,t1.pmc52
#      PRINT COLUMN 01,g_x[97] CLIPPED,
#            COLUMN 11,t1.pmc53
#      SKIP 1 LINE
#      # 列印 VAT 特性,FOB 條件,付款條件
#      PRINT COLUMN 01,g_x[18] CLIPPED,
#            COLUMN 11,t1.pmc13,
#            COLUMN 22,t1.pmc13_d,
#            COLUMN 43,g_x[32] CLIPPED,
#            COLUMN 55,t1.pmc17
#      PRINT COLUMN 01,g_x[20] CLIPPED,
#            COLUMN 11,t1.pmc22,
#            COLUMN 16,t1.azi02,
#            COLUMN 55,t1.pma02
#      PRINT COLUMN 43,g_x[33] CLIPPED,COLUMN 55,t1.pma03
#      PRINT COLUMN 43,g_x[34] CLIPPED,COLUMN 55,t1.pma04 USING "###.##",' %'
#      PRINT COLUMN 43,g_x[98] CLIPPED,COLUMN 55,t1.pmc55
#      PRINT COLUMN 55,t1.nmt02 CLIPPED
#      PRINT COLUMN 43,g_x[99] CLIPPED,COLUMN 55,t1.pmc56
#      SKIP 1 LINE
#      #評鑑等級
#      PRINT COLUMN 01,g_x[21] CLIPPED,
#            COLUMN 11,t1.pmc18,
#            COLUMN 15,g_x[22] CLIPPED,' ',t1.pmc19,
#            COLUMN 43,g_x[37] CLIPPED,' ',t1.pmc20,
#            COLUMN 63,g_x[38] CLIPPED,' ',t1.pmc21
#      SKIP 1 LINE
#
#      PRINT COLUMN 09,g_x[39] CLIPPED,' ',t1.pmc15,
#            COLUMN 43,g_x[41] CLIPPED,' ',t1.pmc16
#      PRINT COLUMN 09,g_x[59] CLIPPED,COLUMN 43,g_x[59] CLIPPED
#      #送貨地址
#      LET l_sqlr31=l_sqlr3 CLIPPED," AND (pme02='0' OR pme02='2') "
#      PREPARE apmg200_pr3  FROM l_sqlr31
#      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode !=100
#          THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#          EXIT PROGRAM 
#          END IF
#      DECLARE apmg200_prt3  CURSOR FOR apmg200_pr3
#      IF t1.pmc15 IS NOT NULL THEN
#       OPEN apmg200_prt3  USING t1.pmc15
#       FETCH apmg200_prt3  INTO t2.*
#      END IF
#      CLOSE apmg200_prt3
#
#      #帳單地址
#      LET l_sqlr32=l_sqlr3 CLIPPED," AND (pme02='1' OR pme02='2') "
#      PREPARE apmg200_pr4   FROM l_sqlr32
#      IF SQLCA.sqlcode != 0 AND SQLCA.sqlcode != 100
#          THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#          EXIT PROGRAM 
#          END IF
#      DECLARE apmg200_prt4  CURSOR FOR apmg200_pr4
#      IF t1.pmc15 IS NOT NULL THEN
#       OPEN apmg200_prt4  USING t1.pmc16
#       FETCH apmg200_prt4  INTO t3.*
#      END IF
#      CLOSE apmg200_prt4
#
#      IF t1.pmc15 IS NULL  OR (t2.pme031 IS NULL AND t2.pme032 IS NULL
#         AND t2.pme033 IS NULL AND t2.pme034 IS NULL AND t2.pme034 IS NULL)
#      THEN LET t2.pme031=g_x[95] END IF
#      IF t1.pmc16 IS NULL  OR (t3.pme031 IS NULL AND t3.pme032 IS NULL
#         AND t3.pme033 IS NULL AND t3.pme034 IS NULL AND t3.pme034 IS NULL)
#      THEN LET t3.pme031=g_x[95] END IF
#      PRINT COLUMN 09,t2.pme031, COLUMN 43,t3.pme031
#      PRINT COLUMN 09,t2.pme032, COLUMN 43,t3.pme032
#      PRINT COLUMN 09,t2.pme033, COLUMN 43,t3.pme033
#      PRINT COLUMN 09,t2.pme034, COLUMN 43,t3.pme034
#      PRINT COLUMN 09,t2.pme035, COLUMN 43,t3.pme035
#      SKIP 1 LINE
# 
#  #   聯絡人
#      LET l_sqlr4 = "SELECT pmd02,pmd03,pmd04 ",
#                    "  FROM pmd_file ",
#                    " WHERE pmd01= '",sr.pmc01,"'"
#      PREPARE apmg200_pr5   FROM l_sqlr4
#      IF SQLCA.sqlcode != 0  AND SQLCA.sqlcode != 100
#          THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#          EXIT PROGRAM 
#          END IF
#      DECLARE apmg200_prt5  CURSOR FOR apmg200_pr5
#      PRINT COLUMN 4,g_x[54] CLIPPED,COLUMN 26,g_x[56] CLIPPED,
#            COLUMN 45,g_x[58] CLIPPED
#      PRINT COLUMN 4,g_x[55] CLIPPED,'  ',g_x[57] CLIPPED,'  ',g_x[59] CLIPPED
#      FOREACH apmg200_prt5 INTO t4.*
#         IF LINENO > 57 THEN    #判斷聯絡人資料是否跳頁印
#             SKIP TO TOP OF PAGE
#             PRINT g_x[11] CLIPPED,' ',sr.pmc01,COLUMN 43,g_x[23] CLIPPED,
#                   ' ',sr.pmc06, ' ',sr.gea02
#             PRINT g_x[12] CLIPPED,' ',sr.pmc03,COLUMN 43,g_x[24] CLIPPED,
#                   ' ', sr.pmc07, ' ',sr.geb02
#             #PRINT g_x[13] CLIPPED,' ',sr.pmc02   #FUN-550091
#             PRINT g_x[13] CLIPPED,' ',sr.pmc02,COLUMN 43,g_x[100] CLIPPED,   #FUN-550091
#                   ' ', sr.pmc908, ' ',l_geo02   #FUN-550091
#             PRINT g_x[14] CLIPPED,' ',sr.pmc30,
#                   COLUMN 45,g_x[25] CLIPPED,' ',sr.pmc04
#             PRINT g_x[15] CLIPPED,' ',sr.pmc05,' ',sr.pmc05_d,
#                   COLUMN 45,g_x[12] CLIPPED,' ',sr.pmc04_d
#             PRINT COLUMN 4,g_x[54] CLIPPED,COLUMN 26,g_x[56] CLIPPED,
#                   COLUMN 45,g_x[58] CLIPPED
#             PRINT COLUMN 4,g_x[55] CLIPPED,'  ',g_x[57] CLIPPED,
#                          '  ',g_x[59] CLIPPED
#         ELSE
#             PRINT COLUMN 04,t4.pmd02,
#                   COLUMN 26,t4.pmd03,
#                   COLUMN 48,t4.pmd04
#         END IF
#      END FOREACH
#     IF tm.state = 'Y' THEN
#      IF LINENO > 40 THEN   #判斷跳頁
#         SKIP TO TOP OF PAGE
#         PRINT g_x[11] CLIPPED,' ',sr.pmc01,COLUMN 43,g_x[23] CLIPPED,
#               ' ',sr.pmc06, ' ',sr.gea02
#         PRINT g_x[12] CLIPPED,' ',sr.pmc03,COLUMN 43,g_x[24] CLIPPED,
#               ' ',sr.pmc07, ' ',sr.geb02
#         #PRINT g_x[13] CLIPPED,' ',sr.pmc02   #FUN-550091
#         PRINT g_x[13] CLIPPED,' ',sr.pmc02,COLUMN 43,g_x[100] CLIPPED,   #FUN-550091
#               ' ', sr.pmc908, ' ',l_geo02   #FUN-550091
#         PRINT g_x[14] CLIPPED,' ',sr.pmc30,COLUMN 45,g_x[25] CLIPPED,
#              ' ',sr.pmc04
#         PRINT g_x[15] CLIPPED,' ',sr.pmc05,' ',sr.pmc05_d,
#               COLUMN 45,g_x[12] CLIPPED,' ',sr.pmc04_d
#      END IF
#   #  重要備註
#      SKIP 1 LINE
#      DECLARE apmg200_prt6  CURSOR FOR
#         SELECT pmg03
#           FROM pmg_file  WHERE pmg01=sr.pmc01
#      PRINT g_x[60] CLIPPED;
#      FOREACH apmg200_prt6 INTO l_pmg03
#         PRINT COLUMN 11,l_pmg03
#      END FOREACH
#     END IF
#
#   AFTER GROUP OF sr.pmc01
#      LET g_pageno = 0
#      LET l_last_sw = 'y'
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#    IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
### FUN-550114
#     PRINT ''
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[101]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[101]
#            PRINT g_memo
#     END IF
### END FUN-550114
#
#END REPORT
#No.FUN-710091  --end
#Patch....NO.TQC-610036 <001,002> #

###GENGRE###START
FUNCTION apmg200_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("apmg200")
        IF handler IS NOT NULL THEN
            START REPORT apmg200_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY pmc01"
            DECLARE apmg200_datacur1 CURSOR FROM l_sql
            FOREACH apmg200_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg200_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg200_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg200_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_pma03    STRING            #FUN-B50018---add
    DEFINE l_pmv05_d  STRING            #FUN-B50018---add
    DEFINE l_pmc30_d  STRING            #FUN-B50018---add
    DEFINE l_sql      STRING            #FUN-B50018---add

    
    ORDER EXTERNAL BY sr1.pmc01,sr1.pme031_1
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.pmc01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.pme031_1

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50018------add---------str-----------
            IF sr1.pma03 = '2' OR  sr1.pma03 = '3' OR sr1.pma03 = '5' OR sr1.pma03 = '6' THEN
               LET l_pma03 = cl_gr_getmsg("gre-081",g_lang,sr1.pma03)
            ELSE
               LET l_pma03 = ' '
            END IF
            PRINTX l_pma03

            IF NOT cl_null(sr1.pmc05) THEN
               LET l_pmv05_d = cl_gr_getmsg("gre-082",g_lang,sr1.pmc05)
            END IF
            PRINTX l_pmv05_d

            IF NOT cl_null(sr1.pmc30) THEN
               LET l_pmc30_d = cl_gr_getmsg("gre-083",g_lang,sr1.pmc30)
            END IF
            PRINTX l_pmc30_d

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE pmd01 = '",sr1.pmc01 CLIPPED,"'"
            START REPORT apmg200_subrep01
            DECLARE apmg200_repcur1 CURSOR FROM l_sql
            FOREACH apmg200_repcur1 INTO sr2.*
                OUTPUT TO REPORT apmg200_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT apmg200_subrep01

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE pmg01 = '",sr1.pmc01 CLIPPED,"'"
            START REPORT apmg200_subrep02
            DECLARE apmg200_repcur2 CURSOR FROM l_sql
            FOREACH apmg200_repcur2 INTO sr3.*
                OUTPUT TO REPORT apmg200_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT apmg200_subrep02
            #FUN-B50018--------add--------end-----------


            PRINTX sr1.*

        AFTER GROUP OF sr1.pmc01
        AFTER GROUP OF sr1.pme031_1

        
        ON LAST ROW

END REPORT
#FUN-B50018-------add---------str-----------
REPORT apmg200_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT


REPORT apmg200_subrep02(sr3)
    DEFINE sr3 sr3_t
    DEFINE l_n              LIKE type_file.num5
 
    ORDER EXTERNAL BY sr3.pmg01

    FORMAT
        BEFORE GROUP OF sr3.pmg01
            LET l_n = 0

        ON EVERY ROW
            LET l_n = l_n + 1
            PRINTX l_n
            PRINTX sr3.*
END REPORT
#FUN-B50018-------add-------end-----------
###GENGRE###END
