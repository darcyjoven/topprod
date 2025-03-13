# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr904.4gl
# Desc/riptions..: Purchase Order
# Date & Author..: No.FUN-6C0005 06/12/05 By Rainy  ref.apmr900
# Modify.........: No.FUN-710091 07/02/24 By xufeng 報表輸出至Crystal Reports功能 
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740057 07/04/14 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.TQC-740276 07/04/20 By wujie 特別說明單身"在後"印出來的位置錯誤
# Modify.........: No.FUN-740225 07/06/05 By Sarah 列印最近採購紀錄最大筆數功能有問題
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.CHI-790029 07/10/03 By jamie 特別說明改用新的子報表寫法 
# Modify.........: No.CHI-7A0017 07/10/11 By jamie 報表印不出來 l_sql導致
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60083 10/06/12 By Carrier 连接符修改 & SQL调整
# Modify.........: No:MOD-A60126 10/07/30 By Smapmin 增加判斷是否列印請購單號/廠商料件編號
# Modify.........: No.FUN-A80011 10/08/03 By yinhy 畫面條件選項增加一個選項，Print Additional Description For Vendor Item No.
# Modify.........: No:CHI-A80032 10/09/01 By Summer 採購單單號增加開窗
# Modify.........: No:MOD-AC0119 10/12/21 By Smapmin 修改變數定義型態
# Modify.........: No:FUN-B90050 11/09/05 By lujh 程序撰寫規範修正
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
   DEFINE g_zaa04_value  LIKE zaa_file.zaa04
   DEFINE g_zaa10_value  LIKE zaa_file.zaa10
   DEFINE g_zaa11_value  LIKE zaa_file.zaa11
   DEFINE g_zaa17_value  LIKE zaa_file.zaa17   
   DEFINE g_seq_item    LIKE type_file.num5   	
END GLOBALS
 
   DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,	# Where condition 	  #No.FUN-680136 VARCHAR(500)
              a       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    	        b      	LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1) 
    	        c     	LIKE type_file.num5,    #No.FUN-680136 SMALLINT
              d       LIKE type_file.chr1,    #FUN-740057 add           #列印公司對內全名
              e       LIKE type_file.chr1,    #FUN-740057 add           #列印公司對外全名
              f       LIKE type_file.chr1,    #FUN-A80011 add           #列印額外品名規格
              more    LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1) 
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
   DEFINE   g_cnt       LIKE type_file.num10    #No.FUN-680136 INTEGER
   DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
   DEFINE   g_sma115    LIKE sma_file.sma115
   DEFINE   g_sma116    LIKE sma_file.sma116
   DEFINE   g_rlang_2   LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1) 
   #No.FUN-710091   --begin
   DEFINE   g_sql      STRING
   DEFINE   g_str      STRING
   DEFINE   l_table    STRING
   DEFINE   l_table1   STRING
   DEFINE   l_table2   STRING
   DEFINE   l_table3   STRING
   DEFINE   l_table4   STRING
   DEFINE   l_table5   STRING   #CHI-790029 add
   DEFINE   l_table6   STRING   #FUN-A80011 add
   #No.FUN-710091   --end  
 
#FUN-6C0005
MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)   #FUN-740057 add
   LET tm.e  = ARG_VAL(12)   #FUN-740057 add
   LET tm.f  = ARG_VAL(13)   #FUN-A80011 add
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_xml.subject = ARG_VAL(17)
   LET g_xml.body = ARG_VAL(18)
   LET g_xml.recipient = ARG_VAL(19)
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   IF cl_null(g_rlang) THEN
      LET g_rlang=g_lang
   END IF
   LET g_rlang_2 = g_rlang  
   #No.FUN-710091  --begin
   LET g_sql = "pmm01.pmm_file.pmm01,",   
               "smydesc.smy_file.smydesc,", 
               "pmm04.pmm_file.pmm04,",  
               "pmc081.pmc_file.pmc081,", 
               "pmc091.pmc_file.pmc091,", 
               "pmc10.pmc_file.pmc10 ,", 
               "pmc11.pmc_file.pmc11 ,", 
               "pma02.pma_file.pma02,",  
               "pmm41.pmm_file.pmm41,",  
               "oah02.oah_file.oah02,",  
               "gec02.gec_file.gec02,",  
               "pmm09.pmm_file.pmm09,",  
               "pmm10.pmm_file.pmm10,",  
               "pmm11.pmm_file.pmm11,",  
               "pmm22.pmm_file.pmm22,",  
               "pmn02.pmn_file.pmn02,",  
               "pmn04.pmn_file.pmn04,",  
               "pmn041.pmn_file.pmn041,", 
               "pmn07.pmn_file.pmn07,",
               "pmn20.pmn_file.pmn20,",  
               "pmn31.pmn_file.pmn31,",  
               "pmn88.pmn_file.pmn88,",  
               "pmn33.pmn_file.pmn33,",  
               "pmn15.pmn_file.pmn15,",  
               "pmn14.pmn_file.pmn14,",  
               "pmn24.pmn_file.pmn24,",  
               "pmn25.pmn_file.pmn25,",  
               "pmn06.pmn_file.pmn06,",  
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "pmc911.pmc_file.pmc911,",
               "pmn31t.pmn_file.pmn31t,",  
               "pmn88t.pmn_file.pmn88t,",  
               "pmn08.pmn_file.pmn08,",   
               "pmn09.pmn_file.pmn09,",  
               "pmn80.pmn_file.pmn80,",   
               "pmn82.pmn_file.pmn82,",  
               "pmn83.pmn_file.pmn83,",  
               "pmn85.pmn_file.pmn85,",  
               "pmn86.pmn_file.pmn86,",  
               "pmn87.pmn_file.pmn87,",
               "pme031.pme_file.pme031,",
               "pme032.pme_file.pme032,",
               "pme0311.pme_file.pme031,",
               "pme0322.pme_file.pme032,",
               "ima021.ima_file.ima021,",
               "l_str2.type_file.chr1000,",
               "sma115.sma_file.sma115,",
               "sma116.sma_file.sma116,",
               "l_count.type_file.num5,",        #No.FUN-A80011 add
               "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
              "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
              "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
    LET l_table = cl_prt_temptable('apmr904',g_sql) CLIPPED
    IF  l_table = -1 THEN EXIT PROGRAM END IF
   
    LET g_sql = "pmo01.pmo_file.pmo01,",
                "pmo061.pmo_file.pmo06"
    LET l_table1 = cl_prt_temptable('apmr9041',g_sql) CLIPPED
    IF  l_table1 = -1 THEN EXIT PROGRAM END IF
        
    LET g_sql = "pmo01.pmo_file.pmo01,", 
                "pmn02.pmn_file.pmn02,",     #No.TQC-740276 
                "pmo062.pmo_file.pmo06"
    LET l_table2 = cl_prt_temptable('apmr9042',g_sql) CLIPPED
    IF  l_table2 = -1 THEN EXIT PROGRAM END IF
    
    LET g_sql = "pmo01.pmo_file.pmo01,", 
                "pmn02.pmn_file.pmn02,",     #No.TQC-740276 
                "pmo063.pmo_file.pmo06"
    LET l_table3 = cl_prt_temptable('apmr9043',g_sql) CLIPPED
    IF  l_table3 = -1 THEN EXIT PROGRAM END IF
    
    LET g_sql = "pmo01.pmo_file.pmo01,", 
                "pmo064.pmo_file.pmo06"
    LET l_table4 = cl_prt_temptable('apmr9044',g_sql) CLIPPED
    IF  l_table4 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-710091  --end  
 
   #str CHI-790029 add
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
    LET l_table5 = cl_prt_temptable('apmr9045',g_sql) CLIPPED
    IF  l_table5 = -1 THEN EXIT PROGRAM END IF
   #end CHI-790029 add
    #No.FUN-A80011 --start
    LET g_sql = "pmq01.pmq_file.pmq01,", 
                "pmq02.pmq_file.pmq02,", 
                "pmq03.pmq_file.pmq03,", 
                "pmq04.pmq_file.pmq04,", 
                "pmq05.pmq_file.pmq05,",
                "pmm01.pmm_file.pmm01,",
                "pmn02.pmn_file.pmn02"
    LET l_table6 = cl_prt_temptable('apmr9046',g_sql) CLIPPED
    IF  l_table6 = -1 THEN EXIT PROGRAM END IF
    #No.FUN-A80011 --end
    
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)    # If background job sw is off
      THEN CALL r904_tm(0,0)		# Input print condition
      ELSE CALL apmr904()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION r904_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,         
       l_cmd          LIKE type_file.chr1000        
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r904_w AT p_row,p_col WITH FORM "apm/42f/apmr904"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 'N'
   LET tm.b    = 'N'
   LET tm.c    = 0
   LET tm.d    = 'Y'   #FUN-740057 add
   LET tm.e    = 'Y'   #FUN-740057 add
   LET tm.f    = 'N'   #FUN-A80011 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_rlang_2 = g_rlang            #FUN-560229
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm12
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      #CHI-A80032 add --start--
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(pmm01)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_pmm15"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmm01
                NEXT FIELD pmm01
         END CASE
      #CHI-A80032 add --end--

      ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r904_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.more WITHOUT DEFAULTS   #FUN-740057 add tm.d,tm.e #FUN-A80011 add tm.f
      BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[YN]" THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES "[YN]" THEN
            NEXT FIELD b
         END IF
      #str FUN-740057 add
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES "[YN]" THEN
            NEXT FIELD d
         END IF
      AFTER FIELD e
         IF cl_null(tm.e) OR tm.e NOT MATCHES "[YN]" THEN
            NEXT FIELD e
         END IF
      #end FUN-740057 add
      #No.FUN-A80011 --start
      AFTER FIELD f
         IF cl_null(tm.f) OR tm.f NOT MATCHES "[YN]" THEN
            NEXT FIELD f
         END IF
      #No.FUN-A80011 --end
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
                 LET g_rlang_2 = g_rlang        
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r904_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr904'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr904','9031',1)
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
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",         
                         " '",g_rep_clas CLIPPED,"'",        
                         " '",g_template CLIPPED,"'"        
         CALL cl_cmdat('apmr904',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r904_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr904()
   ERROR ""
END WHILE
   CLOSE WINDOW r904_w
END FUNCTION
 
FUNCTION apmr904()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	# Used time for running the job   #No.FUN-680136 VARCHAR(8)
#          l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000) 
          l_sql        STRING,       #NO.FUN-910082
          l_chr		LIKE type_file.chr1,    
          l_za05	LIKE type_file.chr1000, 
          l_zaa08       LIKE zaa_file.zaa08,  
          l_flag        LIKE type_file.chr1,    #FUN-740225 add
          l_count  LIKE type_file.num5,    #No.FUN-A80011 add
          sr   RECORD
                     pmm01     LIKE pmm_file.pmm01,    #採購單號
                     smydesc   LIKE smy_file.smydesc,  #單別說明
                     pmm04     LIKE pmm_file.pmm04,    #採購日期
                     pmc081    LIKE pmc_file.pmc081,   #供應商全名
                     pmc091    LIKE pmc_file.pmc091,   #供應商地址   #MOD-AC0119
                     pmc10     LIKE pmc_file.pmc10 ,   #供應商電話
                     pmc11     LIKE pmc_file.pmc11 ,   #供應商傳真
                     pma02     LIKE pma_file.pma02,    #付款條件
                     pmm41     LIKE pmm_file.pmm41,    #價格條件
                     pnz02     LIKE pnz_file.pnz02,    #價格條件說明 #FUN-930113
                     gec02     LIKE gec_file.gec02,    #稅別
                     pmm09     LIKE pmm_file.pmm09,    #廠商編號
                     pmm10     LIKE pmm_file.pmm10,    #送貨地址
                     pmm11     LIKE pmm_file.pmm11,    #帳單地址
                     pmm22     LIKE pmm_file.pmm22,    #幣別
                     pmn02     LIKE pmn_file.pmn02,    #項次
                     pmn04     LIKE pmn_file.pmn04,    #料件編號
                     pmn041    LIKE pmn_file.pmn041,   #品名規格
                     pmn07     LIKE pmn_file.pmn07,    #單位
                     pmn20     LIKE pmn_file.pmn20,    #數量
                     pmn31     LIKE pmn_file.pmn31,    #未稅單價
                     pmn88     LIKE pmn_file.pmn88,    #未稅金額
                     pmn33     LIKE pmn_file.pmn33,    #交貨日
                     pmn15     LIKE pmn_file.pmn15,    #提前交貨
                     pmn14     LIKE pmn_file.pmn14,    #部份交貨
                     pmn24     LIKE pmn_file.pmn24,    #請購單號
                     pmn25     LIKE pmn_file.pmn25,    #請購項次
                     pmn06     LIKE pmn_file.pmn06,    #廠商料號
                     azi03     LIKE azi_file.azi03,
                     azi04     LIKE azi_file.azi04,
                     azi05     LIKE azi_file.azi05,
                     pmc911    LIKE pmc_file.pmc911,
                     pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
                     pmn88t    LIKE pmn_file.pmn88t,   #含稅金額
                     pmn08     LIKE pmn_file.pmn08,       
                     pmn09     LIKE pmn_file.pmn09,        
                     pmn80     LIKE pmn_file.pmn80,         
                     pmn82     LIKE pmn_file.pmn82,          
                     pmn83     LIKE pmn_file.pmn83,           
                     pmn85     LIKE pmn_file.pmn85,            
                     pmn86     LIKE pmn_file.pmn86,    #計價單位 
                     pmn87     LIKE pmn_file.pmn87     #計價數量  
               END RECORD,
          #str FUN-740225 add
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
                     gfe03     LIKE gfe_file.gfe03     #No.FUN-A80011
               END RECORD,
          #No.FUN-A80011--start
          sr2  RECORD
              pmq01    LIKE pmq_file.pmq01,
              pmq02    LIKE pmq_file.pmq02,
              pmq03    LIKE pmq_file.pmq03,
              pmq04    LIKE pmq_file.pmq04,
              pmq05    LIKE pmq_file.pmq05
              END RECORD,
          #No.FUN-A80011--end  
          sr1_gfe03            LIKE gfe_file.gfe03
          #end FUN-740225 add
     DEFINE l_sum_pmn88        LIKE pmn_file.pmn88,    #FUN-740225 add
            l_sum_pmn88t       LIKE pmn_file.pmn88t    #FUN-740225 add
     DEFINE l_i,l_cnt          LIKE type_file.num5     #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE l_zab05            LIKE zab_file.zab05     #FUN-610028
     #No.FUN-710091  --begin
     DEFINE l_pme031           LIKE pme_file.pme031
     DEFINE l_pme032           LIKE pme_file.pme032
     DEFINE l_pme0311          LIKE pme_file.pme031
     DEFINE l_pme0322          LIKE pme_file.pme032
     DEFINE l_ima021           LIKE ima_file.ima021
     DEFINE l_pmo06            LIKE pmo_file.pmo06
     DEFINE l_str2             LIKE type_file.chr1000
     DEFINE l_ima906           LIKE ima_file.ima906
     DEFINE l_pmn85            LIKE pmn_file.pmn85
     DEFINE l_pmn82            LIKE pmn_file.pmn82
     DEFINE l_pmn20            LIKE pmn_file.pmn20
     #No.FUN-710091  --end  
     DEFINE l_zo12             LIKE zo_file.zo12   #FUN-740057 add
     DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
 
     CALL g_zaa_dyn.clear()           
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   
     #No.FUN-710091  --begin
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
     #str FUN-740057 add
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='1'   #公司對外全名
     IF cl_null(l_zo12) THEN
        SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='0'
     END IF
     #end FUN-740057 add
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039 
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)       #CHI-790029 add
     CALL cl_del_data(l_table2)       #CHI-790029 add
     CALL cl_del_data(l_table3)       #CHI-790029 add
     CALL cl_del_data(l_table4)       #CHI-790029 add
     CALL cl_del_data(l_table5)       #CHI-790029 add
     CALL cl_del_data(l_table6)       #FUN-A80011 add
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"  #No.FUN-A80011 加一个?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90050
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-780049
                 " VALUES(?,?)"
     PREPARE insert1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90050
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?)"     #No.TQC-740276
     PREPARE insert2 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert2:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90050
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?)"     #No.TQC-740276
     PREPARE insert3 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert3:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90050
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,  #TQC-780049
                 " VALUES(?,?)"
     PREPARE insert4 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert4:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90050
        EXIT PROGRAM
     END IF
     #No.FUN-710091  --end 
 
     #str CHI-790029 add
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
     PREPARE insert5 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert5:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90050
        EXIT PROGRAM
     END IF
     #end CHI-790029 add
     
     #No.FUN-A80011--start
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
     PREPARE insert_prep6 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep6:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B90050
        EXIT PROGRAM
     END IF
     #No.FUN-A80011--end
 
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
 
     LET g_rlang = g_rlang_2  #CHI-7A0017 mod   
 
     LET l_sql = "SELECT pmm01,smydesc,pmm04,pmc081,pmc091,pmc10,pmc11,",
                 "       pma02,pmm41,pnz02,", #FUN-930113 oah-->pnz
                 "       gec02,pmm09,pmm10,pmm11,pmm22,pmn02,pmn04,pmn041,",
                 "       pmn07,pmn20,pmn31,pmn88,pmn33,pmn15,",
                 "       pmn14,pmn24,pmn25,pmn06,azi03,azi04,azi05,pmc911, ",
                 "       pmn31t,pmn88t,pmn08,pmn09,pmn80,pmn82,pmn83,pmn85,",
                 "       pmn86,pmn87",   #FUN-560229
                 #No.MOD-A60083  --Begin
                 "  FROM pmm_file LEFT OUTER JOIN smy_file ON pmm01 like smy_file.smyslip || '-%' ",
                 "                LEFT OUTER JOIN pmc_file ON pmc01 = pmm09 ",
                 "                LEFT OUTER JOIN azi_file ON pmm22 = azi01 ",
                 "                LEFT OUTER JOIN pma_file ON pmm20 = pma01 ",
                 "                LEFT OUTER JOIN gec_file ON pmm21 = gec01 AND gec011 = '1' ",
                #"                LEFT OUTER JOIN oah_file ON pmm41 = oah01,pmn_file",
                 "                LEFT OUTER JOIN pnz_file ON pmm41 = pnz01,pmn_file",
                 " WHERE pmm01 = pmn01 ",
                 "   AND pmm18 !='X' ",
                 "   AND pmmacti='Y' ",
                 "   AND pmm02 !='BKR' ",        
                 "   AND ",tm.wc CLIPPED,
                 "   ORDER BY pmm01,pmn02"    #No.FUN-710091 add
                 #No.MOD-A60083  --#End 
 
     PREPARE r904_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r904_cs1 CURSOR FOR r904_prepare1
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
#    LET g_rlang = g_rlang_2     #CHI-7A0017 mark
#    CALL cl_outnam('apmr904') RETURNING l_name    #No.FUN-710091
#str CHI-790029 mark
#    IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    
#       LET g_zaa[40].zaa06 = "N"
#    ELSE
#       LET g_zaa[40].zaa06 = "Y"
#    END IF
#    IF tm.a = 'Y' THEN
#       LET g_zaa[57].zaa06 = "N"
#    ELSE
#       LET g_zaa[57].zaa06 = "Y"
#    END IF
#    IF tm.b = 'Y' THEN
#       LET g_zaa[63].zaa06 = "N"
#    ELSE
#       LET g_zaa[63].zaa06 = "Y"
#    END IF
#end CHI-790029 mark
#    CALL cl_prt_pos_len()   #No.FUN-710091
 
#    START REPORT r904_rep TO l_name    #No.FUN-710091
 
#str CHI-790029 mark
#     LET l_sql="SELECT zaa02,zaa08,zaa09,zaa14,zaa16 FROM zaa_file ",
#               "WHERE zaa01 = '",g_prog ,"' AND zaa03 = ? ",
#               "  AND zaa04 = '", g_zaa04_value,"' AND zaa10= '", g_zaa10_value , "'",
#               "  AND zaa11 = '",g_zaa11_value CLIPPED,"' AND zaa17= '",g_zaa17_value CLIPPED ,"'" 
#     PREPARE r904_zaa_pre FROM l_sql
#     DECLARE r904_zaa_cur CURSOR FOR r904_zaa_pre
 
#     LET l_sql = " SELECT zab05 from zab_file ",
#          "WHERE zab01= ? AND zab04= ? AND zab03 = ?"
#     PREPARE zab_prepare FROM l_sql
#end CHI-790029 mark
 
     LET g_pageno = 0
     FOREACH r904_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF cl_null(sr.pmn20) THEN LET sr.pmn20=0 END IF
       IF cl_null(sr.pmn31) THEN LET sr.pmn31=0 END IF
       IF cl_null(sr.pmn31t) THEN LET sr.pmn31t=0 END IF
       IF cl_null(sr.pmn88)   THEN LET sr.pmn88=0   END IF
       IF cl_null(sr.pmn88t)   THEN LET sr.pmn88t=0   END IF
 
#      OUTPUT TO REPORT r904_rep(sr.*)   #No.FUN-710091
       
       #No.FUN-710091  --begin
       SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
                                                   WHERE pme01=sr.pmm10
       IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
 
       SELECT pme031,pme032 INTO l_pme0311,l_pme0322 FROM pme_file
                                                  WHERE pme01=sr.pmm11
       IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
      
       #CHI-790029 add str
      
       #額外備註-項次前備註
       DECLARE pmo_cur2 CURSOR FOR
          SELECT pmo06 FROM pmo_file
           WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='0'
          #WhERE pmo01=sr.pmm01 AND pmo03='1' AND pmo05=sr.pmn02 AND pmo04='0'   #CHI-790029 mark #No.TQC-740276
       FOREACH pmo_cur2 INTO l_pmo06
          EXECUTE insert2 USING sr.pmm01,sr.pmn02,l_pmo06     #No.TQC-740276
       END FOREACH
       
       #額外備註-項次後備註
       DECLARE pmo_cur3 CURSOR FOR
        SELECT pmo06 FROM pmo_file
         WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='1'
        #WHERE pmo01=sr.pmm01 AND pmo03='1' AND pmo05 =sr.pmn02 AND pmo04='1'   #CHI-790029 mark #No.TQC-740276
       FOREACH pmo_cur3 INTO l_pmo06
          EXECUTE insert3 USING sr.pmm01,sr.pmn02,l_pmo06     #No.TQC-740276
       END FOREACH
              
       #CHI-790029 add end
       SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                          WHERE ima01=sr.pmn04
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
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
       ELSE
       END IF
       IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
            #IF sr.pmn80 <> sr.pmn86 THEN  #TQC-6C0136
             IF sr.pmn07 <> sr.pmn86 THEN  #TQC-6C0136
                CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
                LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
             END IF
       END IF
       #No.FUN-A80011 --start 额外品名規格       
       IF tm.f = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM pmq_file
             WHERE pmq01=sr.pmn04 AND pmq02=sr.pmm09
          IF l_count !=0  THEN
            DECLARE pmq_cur CURSOR FOR
            SELECT * FROM pmq_file    
              WHERE pmq01=sr.pmn04 AND pmq02=sr.pmm09 
            ORDER BY pmq04                                        
            FOREACH pmq_cur INTO sr2.*                            
              EXECUTE insert_prep6 USING sr2.pmq01,sr2.pmq02,sr2.pmq03,sr2.pmq04,sr2.pmq05,sr.pmm01,sr.pmn02
            END FOREACH
          END IF
        END IF 
       #No.FUN-A80011 --end 
       #str CHI-790029 add
        EXECUTE insert_prep USING 
                sr.*,
                l_pme031,l_pme032,
　　　　　　　　l_pme0311,l_pme0322,
                l_ima021,l_str2,g_sma.sma115,g_sma.sma116,l_count,  #No.FUN-A80011 add l_count
                "",l_img_blob, "N",""  #TQC-C10039 ADD "",l_img_blob, "N",""
       #end CHI-790029 add
 
       #str FUN-740225 add   #列印最近採購紀錄最大筆數功能
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
 
            #str CHI-790029 add
             EXECUTE insert5 USING
                sr.pmm01,sr.pmn04,sr.azi03,sr.azi04,sr1.*
            #end CHI-790029 add
       
             INITIALIZE sr1.* TO NULL
          END FOREACH
       END IF      
       #No.FUN-710091  --end       
      END FOREACH
 
  #str CHI-790029 add
   #處理單據前、後特別說明
   LET l_sql = "SELECT pmm01 FROM pmm_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY pmm01"
   PREPARE r904_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE r904_cs2 CURSOR FOR r904_prepare2
 
   FOREACH r904_cs2 INTO sr.pmm01
       #額外備註-單據前備註
       DECLARE pmo_cur CURSOR FOR
          SELECT pmo06 FROM pmo_file
           WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='0'
       FOREACH pmo_cur INTO l_pmo06
          EXECUTE insert1 USING sr.pmm01,l_pmo06
       END FOREACH
 
       #額外備註-單據後備註
       DECLARE pmo_cur4 CURSOR FOR
        SELECT pmo06 FROM pmo_file
         WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='1'
       FOREACH pmo_cur4 INTO l_pmo06
          EXECUTE insert4 USING sr.pmm01,l_pmo06
       END FOREACH 
      
   END FOREACH
  #end CHI-790029 add
 
  #str CHI-790029 add
  #修改成新的子報表的寫法(可組一句主要SQL,五句子報表SQL)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED
  #end CHI-790029 add
 
   IF g_zz05='Y' THEN           #FUN-740057 add 
      CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm12') RETURNING tm.wc 
   ELSE 
      LET tm.wc = '' 
   END IF   #FUN-740057 add
   LET g_str = tm.wc
   LET g_str = g_str,";",tm.d,";",tm.e,";",l_zo12   #FUN-740057 add
                    ,";",tm.c   #FUN-740225 add tm.c
                    ,";",g_zo.zo041,";",g_zo.zo05,";",g_zo.zo09   #FUN-810029 add
                    ,";",tm.a,";",tm.b,";",tm.f CLIPPED #MOD-A60126  #FUN-A80011 add tm.f
  #CALL cl_prt_cs3('apmr904',g_sql,g_str)   #TQC-730088
   LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
   LET g_cr_apr_key_f = "pmm01"       #報表主鍵欄位名稱  #TQC-C10039
   CALL cl_prt_cs3('apmr904','apmr904',g_sql,g_str)
  #No.FUN-710091   --end
 
#    FINISH REPORT r904_rep   #No.FUN-710091
 
   LET g_rlang = g_rlang_2       
 
    #NO.FUN-710091  mark --begin
    #IF g_bgjob='Y' AND g_prtway = 'J' THEN
    # CALL r904_jmail(l_name)
    #ELSE
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)  
    #END IF
    #NO.FUN-710091  mark --end 
END FUNCTION
 
{
#FUN-560229
REPORT r904_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,   	 
          l_dash        LIKE type_file.chr1,   	 
          l_count       LIKE type_file.num5,    
	  l_n           LIKE type_file.num5,   
          l_zaa08       LIKE zaa_file.zaa08,   
          l_zaa09       LIKE zaa_file.zaa09,   
          l_zaa14       LIKE zaa_file.zaa14,   
          l_zaa16       LIKE zaa_file.zaa16,    
          l_memo        LIKE zab_file.zab05,    
          l_zaa08_trim  STRING,                
          l_sql 	LIKE type_file.chr1000,	 
          sr   RECORD
                     pmm01     LIKE pmm_file.pmm01,    #採購單號
                     smydesc   LIKE smy_file.smydesc,  #單別說明
                     pmm04     LIKE pmm_file.pmm04,    #採購日期
                     pmc081    LIKE pmc_file.pmc081,   #供應商全名
                     pmc091    LIKE pmc_file.pmc091,   #供應商地址   #MOD-AC0119
                     pmc10     LIKE pmc_file.pmc10 ,   #供應商電話
                     pmc11     LIKE pmc_file.pmc11 ,   #供應商傳真
                     pma02     LIKE pma_file.pma02,    #付款條件
                     pmm41     LIKE pmm_file.pmm41,    #價格條件
                     oah02     LIKE oah_file.oah02,    #價格條件說明
                     gec02     LIKE gec_file.gec02,    #稅別
                     pmm09     LIKE pmm_file.pmm09,    #廠商代碼
                     pmm10     LIKE pmm_file.pmm10,    #送貨地址
                     pmm11     LIKE pmm_file.pmm11,    #帳單地址
                     pmm22     LIKE pmm_file.pmm22,    #幣別
                     pmn02     LIKE pmn_file.pmn02,    #項次
                     pmn04     LIKE pmn_file.pmn04,    #料件編號
                     pmn041    LIKE pmn_file.pmn041,   #品名規格
                     pmn07     LIKE pmn_file.pmn07,    #單位
                     pmn20     LIKE pmn_file.pmn20,    #數量
                     pmn31     LIKE pmn_file.pmn31,    #未稅單價
                     pmn88     LIKE pmn_file.pmn88,    #未稅金額
                     pmn33     LIKE pmn_file.pmn33,    #交貨日
                     pmn15     LIKE pmn_file.pmn15,    #提前交貨
                     pmn14     LIKE pmn_file.pmn14,    #部份交貨
                     pmn24     LIKE pmn_file.pmn24,    #請購單號
                     pmn25     LIKE pmn_file.pmn25,    #請購項次
                     pmn06     LIKE pmn_file.pmn06,    #廠商料號
                     azi03     LIKE azi_file.azi03,
                     azi04     LIKE azi_file.azi04,
                     azi05     LIKE azi_file.azi05,
                     pmc911    LIKE pmc_file.pmc911,
                     pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
                     pmn88t    LIKE pmn_file.pmn88t,   #含稅金額
                     pmn08     LIKE pmn_file.pmn08,           
                     pmn09     LIKE pmn_file.pmn09,          
                     pmn80     LIKE pmn_file.pmn80,         
                     pmn82     LIKE pmn_file.pmn82,        
                     pmn83     LIKE pmn_file.pmn83,       
                     pmn85     LIKE pmn_file.pmn85,      
                     pmn86     LIKE pmn_file.pmn86,    #計價單位 
                     pmn87     LIKE pmn_file.pmn87     #計價數量
        END RECORD,
        sr1          RECORD
                     pmm04     LIKE pmm_file.pmm04,
                     pmm01     LIKE pmm_file.pmm01,
                     pmc03     LIKE pmc_file.pmc03,
                     pmn20     LIKE pmn_file.pmn20,
                     pmn07     LIKE pmn_file.pmn07,
                     pmm22     LIKE pmm_file.pmm22,
                     pmn31     LIKE pmn_file.pmn31,
                     #No.FUN-540027  --begin
                     pmn88     LIKE pmn_file.pmn88,
                     pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
                     pmn88t    LIKE pmn_file.pmn88t,   #含稅金額
                     pmn08     LIKE pmn_file.pmn08,               
                     pmn09     LIKE pmn_file.pmn09,               
                     pmn80     LIKE pmn_file.pmn80,              
                     pmn82     LIKE pmn_file.pmn82,            
                     pmn83     LIKE pmn_file.pmn83,              
                     pmn85     LIKE pmn_file.pmn85,               
                     pmn86     LIKE pmn_file.pmn86,    #計價單位  
                     pmn87     LIKE pmn_file.pmn87     #計價數量  
                     END RECORD,
        l_pmo06      LIKE pmo_file.pmo06,
        l_pme031     LIKE pme_file.pme031,
        l_pme032     LIKE pme_file.pme032,
        l_ima021     LIKE ima_file.ima021,      
        l_ima906     LIKE ima_file.ima906,      
        l_flag       LIKE type_file.chr1,       
        l_tot        LIKE type_file.num5,       
        l_str        LIKE ima_file.ima01, 	 
        l_str2       LIKE type_file.chr1000,	 
        l_totamt     LIKE pmm_file.pmm40,       
        l_totamt1    LIKE pmn_file.pmn88t,      
        l_pmn85      STRING,
        l_pmn82      STRING,
        l_pmn20      STRING,
        l_pmn24      STRING,
        l_pmn06      STRING
 DEFINE l_zab05      LIKE zab_file.zab05        
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmm01,sr.pmn02
  FORMAT
   PAGE HEADER
      #MOD-640173
      IF g_pageno=0 AND (g_rlang <> sr.pmc911) THEN
         IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN
             LET g_rlang = sr.pmc911
         END IF
         SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
         OPEN r904_zaa_cur USING g_rlang
         FOREACH r904_zaa_cur INTO g_i,l_zaa08,l_zaa09,l_zaa14,l_zaa16
           IF l_zaa09 = '1' THEN
              IF l_zaa14 = "H" OR l_zaa14 = "I" THEN              ##報表備註
                 IF l_zaa16 = "Y" THEN
                    IF l_zaa14 = "H" THEN
                       LET g_memo_pagetrailer = 1
                    ELSE
                       LET g_memo_pagetrailer = 0
                    END IF
                    EXECUTE zab_prepare USING l_zaa08,g_rlang,'1' INTO l_zab05
                    EXECUTE zab_prepare USING l_zaa08,g_rlang,'2' INTO l_memo  
                    IF l_zab05 IS NOT NULL OR l_memo IS NOT NULL THEN
                        LET l_zaa08 = l_zab05
                        LET g_memo = l_memo CLIPPED
                    END IF
                 ELSE
                    LET g_memo_pagetrailer = 0
                    LET l_zaa08 = ""
                    LET g_memo =  ""
                 END IF
              END IF
              LET l_zaa08_trim = l_zaa08
              LET g_x[g_i] = l_zaa08_trim.trimRight()
           ELSE
              LET g_zaa[g_i].zaa08 = l_zaa08
           END IF
        END FOREACH
      ELSE
         SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
      END IF
 
      
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2)+1,g_company CLIPPED  #MOD-640173
      PRINT ' '
      PRINT COLUMN ((g_len-FGL_WIDTH(g_zo.zo041))/2)+1,g_zo.zo041
      PRINT COLUMN ((g_len-FGL_WIDTH(g_zo.zo042))/2)+1,g_zo.zo042
      LET l_str=g_x[28] CLIPPED,g_zo.zo05,' ',g_x[29] CLIPPED,g_zo.zo09
      PRINT COLUMN ((g_len-FGL_WIDTH(l_str))/2)+1,l_str
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED,
            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
      IF g_pageno=1 THEN
         PRINT ' '
         PRINT ' '
         SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
                                                    WHERE pme01=sr.pmm10
         IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
         PRINT g_x[11] CLIPPED,sr.pmm01,' ',sr.smydesc CLIPPED
         PRINT g_x[12] CLIPPED,sr.pmm04 CLIPPED
         PRINT g_x[16] CLIPPED,l_pme031 CLIPPED ,l_pme032 CLIPPED 
         SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
                                                    WHERE pme01=sr.pmm11
         IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
         PRINT g_x[17] CLIPPED,l_pme031 CLIPPED ,l_pme032 CLIPPED 
         PRINT g_x[13] CLIPPED,sr.pmm09
         PRINT "" #MOD-5A0381 add
      ELSE
         PRINT g_x[11] CLIPPED,sr.pmm01,' ',sr.smydesc CLIPPED 
         PRINT g_dash[1,g_len]
 
         CALL cl_prt_pos_dyn()                        
 
         #FUN-560229
         PRINTX name=H1 g_x[38],g_x[39],g_x[40]
         PRINTX name=H2 g_x[41],g_x[42],g_x[43]
         PRINTX name=H3 g_x[44],g_x[45],g_x[46]
         PRINTX name=H4 g_x[47],g_x[48],g_x[58],g_x[49],
                        g_x[50],g_x[51],g_x[52]
         PRINTX name=H5 g_x[53],g_x[54],g_x[59],g_x[55],
                        g_x[56],g_x[57]
         PRINT g_dash1
      END IF
 
BEFORE GROUP OF sr.pmm01
      SKIP TO TOP OF PAGE
      LET l_flag = 'N'
      PRINT COLUMN 10,sr.pmc081
      PRINT COLUMN 10,sr.pmc091
      PRINT COLUMN 6,g_x[28] CLIPPED,sr.pmc10
      PRINT COLUMN 6,g_x[29] CLIPPED,sr.pmc11
      PRINT g_x[14] CLIPPED,sr.pma02,
            COLUMN 52,g_x[18] CLIPPED,sr.gec02 #MOD-590494 48->52
      PRINT g_x[15] CLIPPED,sr.pmm41,' ',sr.oah02 CLIPPED, 
            COLUMN 52,g_x[19] CLIPPED,sr.pmm22  #MOD-590494 48->52
      #-->單頭備註(前)
      DECLARE pmo_cur CURSOR FOR
         SELECT pmo06 FROM pmo_file
          WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='0'
      FOREACH pmo_cur INTO l_pmo06
          IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
          IF NOT cl_null(l_pmo06) THEN PRINT l_pmo06 END IF
      END FOREACH
      PRINT g_dash[1,g_len]
 
      CALL cl_prt_pos_dyn()                        #MOD-640173
         PRINTX name=H1 g_x[38],g_x[39],g_x[40]
         PRINTX name=H2 g_x[41],g_x[42],g_x[43]
         PRINTX name=H3 g_x[44],g_x[45],g_x[46]
         PRINTX name=H4 g_x[47],g_x[48],g_x[58],g_x[49],
                        g_x[50],g_x[51],g_x[52]
         PRINTX name=H5 g_x[53],g_x[54],g_x[59],g_x[55],
                        g_x[56],g_x[57]
      PRINT g_dash1
 
      #END FUN-560229
 
ON EVERY ROW
      #-->單身備註(前)
      DECLARE pmo_cur2 CURSOR FOR
         SELECT pmo06 FROM pmo_file
          WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='0'
      FOREACH pmo_cur2 INTO l_pmo06
          IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
          IF NOT cl_null(l_pmo06) THEN PRINT COLUMN 4,l_pmo06 END IF
      END FOREACH
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.pmn04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
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
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN    
            IF sr.pmn80 <> sr.pmn86 THEN
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
            END IF
      END IF
      #-->單身備註(後)
      DECLARE pmo_cur3 CURSOR FOR
       SELECT pmo06 FROM pmo_file
        WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='1'
      FOREACH pmo_cur3 INTO l_pmo06
          IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
          IF NOT cl_null(l_pmo06) THEN PRINTX name=D1 COLUMN g_x[39],l_pmo06 CLIPPED END IF #No.FUN-540027
      END FOREACH
      LET l_pmn24 = ""
      LET l_pmn06 = ""
      IF tm.a = 'Y' AND NOT cl_null(sr.pmn24) THEN
          LET l_pmn24 = sr.pmn24 CLIPPED,'-',sr.pmn25 USING '<<<<<' 
      END IF
      IF tm.b = 'Y' AND NOT cl_null(sr.pmn06) THEN
          LET l_pmn06 = sr.pmn06 CLIPPED  
      END IF
      PRINTX name=D1
             COLUMN g_c[38],sr.pmn02 CLIPPED USING "###&", 
             COLUMN g_c[39],sr.pmn04 CLIPPED,      
             COLUMN g_c[40],l_pmn06 CLIPPED
      PRINTX name=D2
             COLUMN g_c[42],sr.pmn041 CLIPPED,
             COLUMN g_c[43],sr.pmn15 CLIPPED
      PRINTX name=D3
             COLUMN g_c[45],l_ima021 CLIPPED,
             COLUMN g_c[46],sr.pmn14 CLIPPED
      PRINTX name=D4
             COLUMN g_c[48],sr.pmn07 CLIPPED,
             COLUMN g_c[58],sr.pmn86 CLIPPED,
             COLUMN g_c[49],cl_numfor(sr.pmn31,49,sr.azi03),
             COLUMN g_c[50],cl_numfor(sr.pmn88,50,sr.azi04), 
             COLUMN g_c[51],sr.pmn33 CLIPPED,
             COLUMN g_c[52],l_pmn24 CLIPPED
      PRINTX name=D5
             COLUMN g_c[54],cl_numfor(sr.pmn20,54,2),
             COLUMN g_c[59],cl_numfor(sr.pmn87,59,2),
             COLUMN g_c[55],cl_numfor(sr.pmn31t,55,sr.azi03),
             COLUMN g_c[56],cl_numfor(sr.pmn88t,56,sr.azi04),
             COLUMN g_c[57],l_str2 CLIPPED
      #END FUN-560229
 
      #No.FUN-540027  --end
      IF tm.c > 0 THEN
        DECLARE pmn_cur CURSOR FOR
               #No.FUN-540027 --begin
               SELECT pmm04,pmm01,pmc03,pmn20,pmn07,pmm22,pmn31,#pmn20*pmn31
                      pmn88,pmn31t,pmn88t
               #No.FUN-540027 --end
                 FROM pmm_file, pmn_file, OUTER pmc_file
                WHERE pmn04 = sr.pmn04 AND pmn01=pmm01 AND pmm09=pmc01
                ORDER BY pmm04 DESC
        LET g_cnt=0
        FOREACH pmn_cur INTO sr1.*
          IF STATUS THEN CALL cl_err('pmn_cur',STATUS,1) EXIT FOREACH END IF
          LET g_cnt=g_cnt+1
          IF g_cnt > tm.c THEN EXIT FOREACH END IF
          IF g_cnt = 1 THEN
          #No.FUN-540027 --begin
             PRINT g_x[25] CLIPPED,COLUMN 56,g_x[26] CLIPPED
             PRINT COLUMN 66,g_x[32] CLIPPED   #No.FUN-540027
             PRINT '---------- ---------------- ---------- --------------- ',
                   '---- ---- --------------- ------------------'
          END IF
          IF cl_null(sr1.pmn31) THEN LET sr1.pmn31=0 END IF
          IF cl_null(sr1.pmn31t) THEN LET sr1.pmn31t=0 END IF
          IF cl_null(sr1.pmn88) THEN LET sr1.pmn88=0   END IF
          IF cl_null(sr1.pmn88t) THEN LET sr1.pmn88t=0 END IF
          PRINT COLUMN 01,sr1.pmm04 CLIPPED,
                COLUMN 12,sr1.pmm01 CLIPPED,
                COLUMN 29,sr1.pmc03 CLIPPED,
                COLUMN 40,cl_numfor(sr1.pmn20,15,3) ,
                COLUMN 56,sr1.pmn07 CLIPPED,
                COLUMN 61,sr1.pmm22 CLIPPED,
                COLUMN 66,cl_numfor(sr1.pmn31,15,sr.azi03),
                COLUMN 82,cl_numfor(sr1.pmn88,18,sr.azi04)
          PRINT COLUMN 66,cl_numfor(sr1.pmn31t,15,sr.azi03),
                COLUMN 82,cl_numfor(sr1.pmn88t,18,sr.azi04)
        END FOREACH
      END IF
 
AFTER GROUP OF sr.pmm01
      LET l_totamt=GROUP SUM(sr.pmn88)  #No.FUN-540027
      LET l_totamt1=GROUP SUM(sr.pmn88t)  #No.FUN-540027
      PRINT ''
      PRINTX name=S1
            COLUMN g_c[55],g_x[27] CLIPPED,
            COLUMN g_c[56],cl_numfor(l_totamt,56,sr.azi05)
      PRINTX name=S1
            COLUMN g_c[55],g_x[33] CLIPPED,
            COLUMN g_c[56],cl_numfor(l_totamt1,56,sr.azi05)
      PRINT g_dash[1,g_len]
      SELECT COUNT(*) INTO g_cnt FROM pmo_file
        WHERE pmo01 = sr.pmm01 AND pmo03 = 0
          AND pmo04 = '1'
      LET l_tot = LINENO+ g_cnt
      DECLARE pmo_cur4 CURSOR FOR
       SELECT pmo06 FROM pmo_file
        WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='1'
      FOREACH pmo_cur4 INTO l_pmo06
          IF SQLCA.SQLCODE THEN LET l_pmo06=' ' END IF
          IF NOT cl_null(l_pmo06) THEN PRINT l_pmo06  CLIPPED END IF  
          IF l_tot = 58 AND LINENO = 57 THEN LET l_flag = 'Y' END IF 
      END FOREACH
      LET l_flag='Y'
      LET g_pageno=0
 
PAGE TRAILER
     IF l_flag = 'N' THEN
        IF g_memo_pagetrailer THEN
            PRINT g_x[30]  
            PRINT g_memo
        ELSE
            PRINT          
            PRINT
        END IF
     ELSE
            PRINT g_x[30]  
            PRINT g_memo
     END IF
END REPORT
 
FUNCTION r904_jmail(l_name)
   DEFINE l_name       LIKE type_file.chr20 	
   DEFINE l_cmd	       LIKE type_file.chr1000  #No.FUN-660067 add 
 
   CALL cl_trans_xml(g_xml_rep,"T")
   LET l_cmd = "cp ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED," ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
   RUN l_cmd
   LET l_cmd = FGL_GETENV("DS4GL"),"/bin/addcr ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
   RUN l_cmd
   LET g_xml.attach = FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
 
   CALL cl_jmail()
   LET l_cmd = "rm ",g_xml.attach CLIPPED
   RUN l_cmd
END FUNCTION
}
 
