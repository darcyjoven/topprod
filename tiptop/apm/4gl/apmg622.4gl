# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apmg622.4gl
# Descriptions...: 採購收貨統計分析表
# Input parameter:
# Date & Author..: 93/02/10 By Keith
# Modify.........: No.FUN-4C0095 05/01/05 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6A0089 06/11/07 By xumin 對品名截位供應商編號及簡稱列印
# Modify.........: No.FUN-720010 07/02/08 By TSD.Hazel 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程
# Modify.........: No.TQC-950170 09/06/08 By destiny 程式可能會有溢出問題 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/29 By vealxu 製造功能優化-平行制程
# Modify.........: No.TQC-B10253 11/02/11 By lilingyu 產生報表資料的sql 語句錯誤,漏寫了pmn012
# Modify.........: No.TQC-C30176 12/03/09 By suncx l_buf類型定義錯誤 
# Modify.........: No.MOD-C70096 12/07/09 By Elise 修正重新計算收貨量、入庫量、驗退量
# Modify.........: No.FUN-C70089 12/07/20 By qiaozy 服飾版GR添加
# Modify.........: No.TQC-D10063 13/01/16 By jt_chen 調整slk行業別的子報表名稱

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	       #wc   VARCHAR(500),	     	# Where condition   #TQC-630166 mark
		wc  	STRING,	     	        # Where condition   #TQC-630166
                bdate   LIKE type_file.dat,     #No.FUN-680136 DATE 
                edate   LIKE type_file.dat,     #No.FUN-680136 DATE
                a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)  
              END RECORD,
          g_today1  LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          g_year    LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          g_season  LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          g_month   LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          g_month1  LIKE aba_file.aba18     #No.FUN-680136 VARCHAR(2)
   DEFINE g_i       LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
   DEFINE l_table   STRING,                 ### FUN-720010 ###
          g_str     STRING,                 ### FUN-720010 ###
          g_sql     STRING                  ### FUN-720010 ###
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE pmn_file.pmn40,
    pmn04 LIKE pmn_file.pmn04,
    pmn041 LIKE pmn_file.pmn041,
    ima25 LIKE ima_file.ima25,
    pmm09 LIKE pmm_file.pmm09,
    pmn20 LIKE pmn_file.pmn20,
    rvb07 LIKE rvb_file.rvb07,
    rvv171 LIKE rvv_file.rvv17,
    rvv172 LIKE rvv_file.rvv17,
    rvv173 LIKE rvv_file.rvv17,
    pmc03 LIKE pmc_file.pmc03,
    ima021 LIKE ima_file.ima021,
    pmh02 LIKE pmh_file.pmh02
END RECORD
###GENGRE###END
#FUN-C70089---ADD---STR---
TYPE sr2_t RECORD
    agd03_1  LIKE agd_file.agd03,
    agd03_2  LIKE agd_file.agd03,  
    agd03_3  LIKE agd_file.agd03,
    agd03_4  LIKE agd_file.agd03,
    agd03_5  LIKE agd_file.agd03,
    agd03_6  LIKE agd_file.agd03,
    agd03_7  LIKE agd_file.agd03,
    agd03_8  LIKE agd_file.agd03,
    agd03_9  LIKE agd_file.agd03,
    agd03_10 LIKE agd_file.agd03,
    agd03_11 LIKE agd_file.agd03,
    agd03_12 LIKE agd_file.agd03,
    agd03_13 LIKE agd_file.agd03,
    agd03_14 LIKE agd_file.agd03,
    agd03_15 LIKE agd_file.agd03,
    pmnslk04    LIKE pmnslk_file.pmnslk04
END RECORD

TYPE sr3_t RECORD
    imx01    LIKE imx_file.imx01, 
    number1  LIKE type_file.num5,
    number11 LIKE type_file.num5,
    number12 LIKE type_file.num5,
    number13 LIKE type_file.num5,
    number2  LIKE type_file.num5,
    number21 LIKE type_file.num5,
    number22 LIKE type_file.num5,
    number23 LIKE type_file.num5,
    number3  LIKE type_file.num5,
    number31 LIKE type_file.num5,
    number32 LIKE type_file.num5,
    number33 LIKE type_file.num5,
    number4  LIKE type_file.num5,
    number41 LIKE type_file.num5,
    number42 LIKE type_file.num5,
    number43 LIKE type_file.num5,
    number5  LIKE type_file.num5,
    number51 LIKE type_file.num5,
    number52 LIKE type_file.num5,
    number53 LIKE type_file.num5,
    number6  LIKE type_file.num5,
    number61 LIKE type_file.num5,
    number62 LIKE type_file.num5,
    number63 LIKE type_file.num5,
    number7  LIKE type_file.num5,
    number71 LIKE type_file.num5,
    number72 LIKE type_file.num5,
    number73 LIKE type_file.num5,
    number8  LIKE type_file.num5,
    number81 LIKE type_file.num5,
    number82 LIKE type_file.num5,
    number83 LIKE type_file.num5,
    pmnslk04 LIKE pmnslk_file.pmnslk04,
    pmm09    LIKE pmm_file.pmm09
END RECORD
DEFINE l_table1    STRING 
DEFINE l_table2    STRING

#FUN-C70089---ADD----END---

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
 
## *** FUN-720010 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Hazel  *** ##
    LET g_sql = "order1.pmn_file.pmn40, ",
                "pmn04.pmn_file.pmn04,",     #料號
                "pmn041.pmn_file.pmn041,",   #品名
                "ima25.ima_file.ima25,",     #庫存單位
                "pmm09.pmm_file.pmm09,",     #供應廠商
                "pmn20.pmn_file.pmn20,",     #訂購量
                "rvb07.rvb_file.rvb07,",     #收貨數量
                "rvv171.rvv_file.rvv17,",    #入庫量
                "rvv172.rvv_file.rvv17,",    #驗退量
                "rvv173.rvv_file.rvv17,",    #倉退量
                "pmc03.pmc_file.pmc03, ",    #簡稱
                "ima021.ima_file.ima021,",   #規格 
                "pmh02.pmh_file.pmh02 "      #主要供應商編號
 
    LET l_table = cl_prt_temptable('apmg622',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#FUN-C70089---ADD----STR---
    LET g_sql="agd03_1.agd_file.agd03,agd03_2.agd_file.agd03,",
             "agd03_3.agd_file.agd03,agd03_4.agd_file.agd03,",
             "agd03_5.agd_file.agd03,agd03_6.agd_file.agd03,",
             "agd03_7.agd_file.agd03,agd03_8.agd_file.agd03,",
             "agd03_9.agd_file.agd03,agd03_10.agd_file.agd03,",
             "agd03_11.agd_file.agd03,agd03_12.agd_file.agd03,",
             "agd03_13.agd_file.agd03,agd03_14.agd_file.agd03,",
             "agd03_15.agd_file.agd03,pmnslk04.pmnslk_file.pmnslk04"
   LET l_table1 = cl_prt_temptable('apmg6221',g_sql) CLIPPED 
   IF l_table1 = -1 THEN 
      EXIT PROGRAM 
   END IF 
   LET g_sql="imx01.imx_file.imx01,number1.type_file.num5,",
             "number11.type_file.num5,number12.type_file.num5,number13.type_file.num5,", 
             "number2.type_file.num5,number21.type_file.num5,",
             "number22.type_file.num5,number23.type_file.num5,number3.type_file.num5,",
             "number31.type_file.num5,number32.type_file.num5,number33.type_file.num5,",
             "number4.type_file.num5,number41.type_file.num5,",
             "number42.type_file.num5,number43.type_file.num5,number5.type_file.num5,",
             "number51.type_file.num5,number52.type_file.num5,number53.type_file.num5,",
             "number6.type_file.num5,number61.type_file.num5,",
             "number62.type_file.num5,number63.type_file.num5,number7.type_file.num5,",
             "number71.type_file.num5,number72.type_file.num5,number73.type_file.num5,",
             "number8.type_file.num5,",
             "number81.type_file.num5,number82.type_file.num5,number83.type_file.num5,",
             "pmnslk04.pmnslk_file.pmnslk04,pmm09.pmm_file.pmm09"
   LET l_table2 = cl_prt_temptable('apmg6222',g_sql) CLIPPED 
   IF l_table2 = -1 THEN 
      EXIT PROGRAM 
   END IF
#FUN-C70089---ADD----END---    
    #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
                " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? , ?, ",
                "        ?, ?, ? )"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#FUN-C70089--ADD----STR----
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? , ?, ",
                "        ?, ?, ?, ?, ?,   ? )"
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
    END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-A50009 mod
                " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? , ?, ",
                "        ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?, ",
                "        ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ?, ?)"
    PREPARE insert_prep2 FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep2:',status,1) EXIT PROGRAM
    END IF
#FUN-C70089----ADD---END---    
#----------------------------------------------------------CR (1) ------------#
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       #If background job sw is off
      CALL g622_tm(0,0)             		# Input print condition
   ELSE 	                               	# Read data and create out-file
      CALL g622()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION g622_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW g622_w AT p_row,p_col WITH FORM "apm/42f/apmg622"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
   IF s_industry('slk') AND g_azw.azw04='2' THEN 
      CALL cl_set_comp_visible("more",FALSE)  #FUN-C700789---ADD---
   ELSE
      CALL cl_set_comp_visible("more",TRUE)
   END IF
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.a     = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmn04,pmm09
#No.FUN-570243 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               #FUN-C70089----ADD----STR---
               IF s_industry('slk') AND g_azw.azw04='2' THEN
                  LET g_qryparam.form = "q_pmnslk04"
               ELSE
               #FUN-C70089---ADD------END---
                  LET g_qryparam.form = "q_ima"
               END IF   #FUN-C70089---ADD--
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
#No.FUN-570243 --end--
 
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
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW g622_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM 
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.bdate,tm.edate,tm.a,tm.more
   INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         IF tm.edate<tm.bdate THEN NEXT FIELD bdate END IF
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
            NEXT FIELD a
         END IF
      AFTER FIELD more
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
      CLOSE WINDOW g622_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmg622'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmg622','9031',1)
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
                         " '",tm.bdate,"'",
                         " '",tm.edate,"'",
                         " '",tm.a    ,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmg622',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW g622_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g622()
   ERROR ""
END WHILE
CLOSE WINDOW g622_w
END FUNCTION
 
FUNCTION g622()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)
          l_sql 	STRING,	     	              #RDSQL STATEMENT   #TQC-630166
          l_chr		LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
         #l_buf         LIKE type_file.chr1000,       #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)   #TQC-C30176 mark
         #l_buf         STRING,                       #TQC-630166
          l_buf         STRING,                       #TQC-C30176 add
          l_i,l_j       LIKE type_file.num5,          #No.FUN-680136 SMALLINT
         #l_wc          LIKE type_file.chr1000,       #TQC-630166 mark   #No.FUN-680136 VARCHAR(1000)
          l_wc          STRING,       #TQC-630166
          l_za05	LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          l_rvu00       LIKE rvu_file.rvu00,
          sr           RECORD
                        order1   LIKE pmn_file.pmn40,        #No.FUN-680136 VARCHAR(24)
                        pmn04    LIKE pmn_file.pmn04,        #料件編號
                        pmn041   LIKE pmn_file.pmn041,       #FUN-4C0095
                        ima25    LIKE ima_file.ima25,        #庫存單位
                        pmm09    LIKE pmm_file.pmm09,        #供應廠商
                        pmn20    LIKE pmn_file.pmn20,        #訂購量
                        rvb07    LIKE rvb_file.rvb07,        #收貨量
                        rvv171   LIKE rvv_file.rvv17,        #入庫量
                        rvv172   LIKE rvv_file.rvv17,        #驗退量
                        rvv173   LIKE rvv_file.rvv17,        #倉退量
                        pmc03    LIKE pmc_file.pmc03,        #FUN-720010簡稱
                        ima021   LIKE ima_file.ima021,       #FUN-720010規格 
                        pmh02    LIKE pmh_file.pmh02         #FUN-720010主要供應商編號
                        END RECORD
   DEFINE               l_pmm02  LIKE pmm_file.pmm02,   #No.CHI-8C0017
                        l_pmn18  LIKE pmn_file.pmn18,   #No.CHI-8C0017  
                        l_pmn41  LIKE pmn_file.pmn41,   #No.CHI-8C0017
                        l_pmn43  LIKE pmn_file.pmn43,   #No.CHI-8C0017
                        l_pmh21  LIKE pmh_file.pmh21,   #No.CHI-8C0017
                        l_pmh22  LIKE pmh_file.pmh22,   #No.CHI-8C0017
                        l_cnt    LIKE type_file.num5   #No.CHI-8C0017                        
   DEFINE               l_pmn012 LIKE pmn_file.pmn012  #No.FUN-A60027  
   DEFINE               l_program LIKE type_file.chr10 
   #FUN-C70089----ADD-----STR------
   DEFINE sr1        RECORD
                  agd03_1      LIKE agd_file.agd03,
                  agd03_2      LIKE agd_file.agd03,
                  agd03_3      LIKE agd_file.agd03,
                  agd03_4      LIKE agd_file.agd03,
                  agd03_5      LIKE agd_file.agd03,
                  agd03_6      LIKE agd_file.agd03,
                  agd03_7      LIKE agd_file.agd03,
                  agd03_8      LIKE agd_file.agd03,
                  agd03_9      LIKE agd_file.agd03,
                  agd03_10      LIKE agd_file.agd03,
                  agd03_11      LIKE agd_file.agd03,
                  agd03_12      LIKE agd_file.agd03,
                  agd03_13      LIKE agd_file.agd03,
                  agd03_14      LIKE agd_file.agd03,
                  agd03_15      LIKE agd_file.agd03
                  END RECORD
   DEFINE l_num_t        RECORD
                  number1       LIKE type_file.num5,
                  number11      LIKE type_file.num5,
                  number12      LIKE type_file.num5,
                  number13      LIKE type_file.num5,
                  number2       LIKE type_file.num5,
                  number21      LIKE type_file.num5,
                  number22      LIKE type_file.num5,
                  number23      LIKE type_file.num5,
                  number3       LIKE type_file.num5,
                  number31      LIKE type_file.num5,
                  number32      LIKE type_file.num5,
                  number33      LIKE type_file.num5,
                  number4       LIKE type_file.num5,
                  number41      LIKE type_file.num5,
                  number42      LIKE type_file.num5,
                  number43      LIKE type_file.num5,
                  number5       LIKE type_file.num5,
                  number51      LIKE type_file.num5,
                  number52      LIKE type_file.num5,
                  number53      LIKE type_file.num5,
                  number6       LIKE type_file.num5,
                  number61      LIKE type_file.num5,
                  number62      LIKE type_file.num5,
                  number63      LIKE type_file.num5,
                  number7       LIKE type_file.num5,
                  number71      LIKE type_file.num5,
                  number72      LIKE type_file.num5,
                  number73      LIKE type_file.num5,
                  number8       LIKE type_file.num5,
                  number81      LIKE type_file.num5,
                  number82      LIKE type_file.num5,
                  number83      LIKE type_file.num5       
                  END RECORD
                  
   DEFINE l_pmn04    LIKE pmn_file.pmn04
   DEFINE l_imx_t  RECORD
       agd03_1  LIKE agd_file.agd03,
       agd03_2  LIKE agd_file.agd03,  
       agd03_3  LIKE agd_file.agd03,
       agd03_4  LIKE agd_file.agd03,
       agd03_5  LIKE agd_file.agd03,
       agd03_6  LIKE agd_file.agd03,
       agd03_7  LIKE agd_file.agd03,
       agd03_8  LIKE agd_file.agd03,
       agd03_9  LIKE agd_file.agd03,
       agd03_10 LIKE agd_file.agd03,
       agd03_11 LIKE agd_file.agd03,
       agd03_12 LIKE agd_file.agd03,
       agd03_13 LIKE agd_file.agd03,
       agd03_14 LIKE agd_file.agd03,
       agd03_15 LIKE agd_file.agd03
                END RECORD

   DEFINE l_n           LIKE type_file.num5
   DEFINE l_ima151      LIKE ima_file.ima151
   DEFINE  l_num   DYNAMIC ARRAY OF RECORD
                 number  LIKE pmn_file.pmn20,
                 number1 LIKE rvb_file.rvb07,
                 number2 LIKE rvv_file.rvv17,
                 number3 LIKE rvv_file.rvv17
                END RECORD
DEFINE  l_imx   DYNAMIC ARRAY OF RECORD
                imx01    LIKE type_file.chr10
                END RECORD
DEFINE  l_sql2  STRING
DEFINE  l_imx02 LIKE imx_file.imx02
DEFINE  l_imx01 LIKE imx_file.imx01
DEFINE  l_agd04 LIKE agd_file.agd04
DEFINE  l_agd03 LIKE agd_file.agd03
DEFINE  l_ps    LIKE sma_file.sma46
DEFINE  l_ima01 LIKE ima_file.ima01
DEFINE  l_wc1   STRING
DEFINE  l_wc2   STRING
DEFINE  l_wc3   STRING
DEFINE  l_n1   LIKE type_file.num5
DEFINE  l_n2   LIKE type_file.num5 
   #FUN-C70089----ADD-----END------
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1) #FUN-C70089---ADD--
     CALL cl_del_data(l_table2) #FUN-C70089---ADD--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720010 add ###
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
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
 
     #計算訂購量(pmn_file)
     #FUN-C70089----ADD-----STR----
     IF s_industry('slk') AND g_azw.azw04='2' THEN
        LET tm.wc = cl_replace_str(tm.wc,"pmn04","pmnslk04")
        LET l_sql = "SELECT ' ',pmnslk04,pmnslk041,ima25,pmm09,SUM(pmnslk20), ",
                 "       0,0,0,0,'','','',pmm02,'','','','' ",
                 " FROM pmm_file,pmnslk_file LEFT OUTER JOIN ima_file ON pmnslk04 = ima01",
                 " WHERE pmnslk04 = ima_file.ima01 AND pmm01 = pmnslk01  AND " ,
                 " pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND pmm18 <> 'X' AND ",tm.wc CLIPPED,
                 " GROUP BY pmnslk04,pmnslk041,ima25,pmm09,pmm02 "
     ELSE            
     #FUN-C70089------ADD----END---
        LET l_sql = "SELECT ' ',pmn04,pmn041,ima25,pmm09,SUM(pmn20*pmn09), ",
                 "       0,0,0,0,'','','',pmm02,pmn18,pmn41,pmn43,pmn012 ",            #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43  #FUN-A60027 add pmn012
                 " FROM pmm_file,pmn_file LEFT OUTER JOIN ima_file ON pmn04 = ima01",
                 " WHERE pmn04 = ima_file.ima01 AND pmm01 = pmn01  AND " ,
                 " pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND pmm18 <> 'X' AND ",tm.wc CLIPPED,
                 " GROUP BY pmn04,pmn041,ima25,pmm09,pmm02,pmn18,pmn41,pmn43,pmn012 "  #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43 
     END IF  #FUN-C70089---ADD---
     #TQC-B10253 add pmn012
     PREPARE g622_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
 
     DECLARE g622_cs1 CURSOR FOR g622_prepare1
 
     LET g_pageno = 0
     LET l_cnt = 0                                    #CHI-8C0017
     FOREACH g622_cs1 INTO sr.*,l_pmm02,l_pmn18,l_pmn41,l_pmn43,l_pmn012                  #CHI-8C0017 Add l_pmm02,l_pmn18,l_pmn41,l_pmn43  #FUN-A60027 add l_pmn012
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET sr.order1 = tm.a 
       IF tm.a='1' THEN
          LET sr.pmm09=' '
       END IF

       #計算收貨量、入庫量、驗退量(rvb07)
      #MOD-C70096---add-S---
      #FUN-C70089----ADD----STR---
#       LET l_wc1=null
#       LET l_wc1=tm.wc
#       IF s_industry('slk') AND g_azw.azw04='2' THEN
#          LET l_wc1 = cl_replace_str(l_wc1,"pmnslk04","rvbslk05")
#          LET l_sql="SELECT SUM(rvbslk07),SUM(rvbslk30),SUM(rvbslk29) ",
#                    "  FROM rvbslk_file ",
#                    "  LEFT OUTER JOIN ima_file ",
#                    "    ON (rvbslk_file.rvbslk05 = ima_file.ima01) ",
#                    "       ,rva_file ",
#                    " WHERE rva01 = rvbslk01 ",
#                    "   AND rva06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
#                    "   AND rvaconf <> 'X' ",
#                    "   AND ",l_wc1 CLIPPED
#       ELSE   
#       #FUN-C70089-----ADD----END---
#       LET l_wc1 = cl_replace_str(l_wc1,"pmn04","rvb05")
##       LET tm.wc = cl_replace_str(tm.wc,"pmn04","rvb05")
#       LET l_sql="SELECT SUM(rvb07),SUM(rvb30),SUM(rvb29) ",
#                 "  FROM rvb_file ",
#                 "  LEFT OUTER JOIN ima_file ",
#                 "    ON (rvb_file.rvb05 = ima_file.ima01) ",
#                 "       ,rva_file ",
#                 " WHERE rva01 = rvb01 ",
#                 "   AND rva06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
#                 "   AND rvaconf <> 'X' ",
##                 "   AND ",tm.wc CLIPPED
#                 "   AND ",l_wc1 CLIPPED
#       END IF      #FUN-C70089-----ADD--       
#       PREPARE rvb07_cs FROM l_sql
#       EXECUTE rvb07_cs INTO sr.rvb07,sr.rvv171,sr.rvv172
#       #FUN-C70089----ADD----STR---
#       IF s_industry('slk') AND g_azw.azw04='2' THEN
#          LET l_wc1 = cl_replace_str(l_wc1,"rvbslk05","rvvslk31")
#          LET l_sql="SELECT SUM(rvvslk17) ",
#                 "  FROM rvvslk_file ",
#                 "  LEFT OUTER JOIN ima_file ",
#                 "    ON (rvvslk_file.rvvslk31 = ima_file.ima01) ",
#                 "       ,rvu_file ",
#                 " WHERE rvvslk01 = rvu01 ",
#                 "   AND rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
#                 "   AND rvu00='3' ",
#                 "   AND rvuconf <> 'X' ",
#                 "   AND ",l_wc1 CLIPPED
#       ELSE 
#       LET l_wc1 = cl_replace_str(l_wc1,"rvb05","rvv31")
#       #FUN-C70089----ADD----end--- 
#             
##       LET tm.wc = cl_replace_str(tm.wc,"rvb05","rvv31")
#       LET l_sql="SELECT SUM(rvv17) ",
#                 "  FROM rvv_file ",
#                 "  LEFT OUTER JOIN ima_file ",
#                 "    ON (rvv_file.rvv31 = ima_file.ima01) ",
#                 "       ,rvu_file ",
#                 " WHERE rvv01 = rvu01 ",
#                 "   AND rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
#                 "   AND rvu00='3' ",
#                 "   AND rvuconf <> 'X' ",
##                 "   AND ",tm.wc CLIPPED
#                 "   AND ",l_wc1 CLIPPED
#       END IF   #FUN-C70089----ADD--        
#       PREPARE rvv_cs FROM l_sql
#       EXECUTE rvv_cs INTO sr.rvv173

       IF sr.rvb07=sr.rvv171 AND (sr.rvv172<>0 OR sr.rvv173<>0) THEN
          LET sr.rvv171=sr.rvv171-sr.rvv172
          LET sr.rvv171=sr.rvv171-sr.rvv173
       END IF
      #MOD-C70096---add-E---

       IF cl_null(sr.pmn20) THEN LET sr.pmn20 = 0 END IF 
       IF cl_null(sr.rvb07) THEN LET sr.rvb07 = 0 END IF 
       IF cl_null(sr.rvv171) THEN LET sr.rvv171 = 0 END IF 
       IF cl_null(sr.rvv172) THEN LET sr.rvv172 = 0 END IF 
       IF cl_null(sr.rvv173) THEN LET sr.rvv173 = 0 END IF 
       #取得pmc03
       #CHI-8C0017--Begin--#                             
       IF l_pmm02='SUB' THEN
          LET l_pmh22='2'
          #NO,TQC-910033  --begin--
          IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
             LET l_pmh21 =' '
          ELSE
          #NO.TQC-910033 --end--
            IF NOT cl_null(l_pmn18) THEN
             SELECT sgm04 INTO l_pmh21 FROM sgm_file
              WHERE sgm01=l_pmn18
                AND sgm02=l_pmn41
                AND sgm03=l_pmn43
                AND sgm012 = l_pmn012   #FUN-A60076
            ELSE
             SELECT ecm04 INTO l_pmh21 FROM ecm_file 
              WHERE ecm01=l_pmn41
                AND ecm03=l_pmn43
                AND ecm012 = l_pmn012   #FUN-A60027
            END IF
          END IF         #NO.TQC-910033
       ELSE
          LET l_pmh22='1'
          LET l_pmh21=' '
       END IF
       #CHI-8C0017--End--#       
       SELECT pmh02 INTO sr.pmh02 FROM pmh_file   
        WHERE pmh01=sr.pmn04
#         AND pmh21 = " "                                             #CHI-860042      #CHI-8C0017 Mark
#         AND pmh22 = '1'                                             #CHI-860042      #CHI-8C0017 Mark
          AND pmh21 = l_pmh21                                                          #CHI-8C0017
          AND pmh22 = l_pmh22                                                          #CHI-8C0017
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021          
       IF SQLCA.sqlcode THEN LET sr.pmh02 =  NULL END IF                
       IF tm.a='2' THEN
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01=sr.pmm09
           IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF
       ELSE
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01= sr.pmh02
          IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF               
       END IF               
       IF tm.a = '1' THEN 
#          LET sr.pmm09 = sr.pmh02   #FUN-C70089---MARK
#          IF cl_null(sr.pmm09) THEN #FUN-C70089---MARK
             LET sr.pmm09=' '
             LET sr.pmc03=' '
#          END IF                    #FUN-C70089---MARK---
       END IF 
       SELECT ima021 INTO sr.ima021 FROM ima_file
        WHERE ima01 = sr.pmn04 
       LET sr.pmc03 = sr.pmc03[1,10]
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
       EXECUTE insert_prep USING 
           sr.order1,sr.pmn04,sr.pmn041,sr.ima25,sr.pmm09,sr.pmn20,
           sr.rvb07,sr.rvv171,sr.rvv172,sr.rvv173,sr.pmc03,sr.ima021,sr.pmh02
       #------------------------------ CR (3) ------------------------------#       
     END FOREACH
     #計算收貨量(rvb_file)
     LET l_buf=tm.wc
     LET l_j=length(l_buf)
     #NO.TQC-950170--begin
#    FOR l_i=1 TO l_j
#        IF l_buf[l_i,l_i+4]='pmn04' THEN LET l_buf[l_i,l_i+4]='rvb05' END IF
#        IF l_buf[l_i,l_i+4]='pmm09' THEN LET l_buf[l_i,l_i+4]='rva05' END IF
#    END FOR
#FUN-C70089----ADD----STR---
     IF s_industry('slk') AND g_azw.azw04='2' THEN
        LET l_buf=cl_replace_str(l_buf,"pmnslk04","rvbslk05")
     ELSE    
#FUN-C70089-----ADD----END---     
     LET l_buf=cl_replace_str(l_buf,"pmn04","rvb05")  
     END IF     #FUN-C70089-----ADD-- 
     LET l_buf=cl_replace_str(l_buf,"pmm09","rva05")                                                                                
     #NO.TQC-950170--end
     LET l_wc = l_buf
#FUN-C70089----ADD----STR---
     IF s_industry('slk') AND g_azw.azw04='2' THEN
        LET l_sql = "SELECT ' ',rvbslk05,ima02,ima25,rva05,0,SUM(rvbslk07), ",
                 "       0,0,0,'','','',pmm02,'','','','' ",
                 " FROM rva_file,rvbslk_file LEFT OUTER JOIN ima_file ON rvbslk05=ima_file.ima01,pmm_file ",
                 " WHERE rva01 = rvbslk01 AND ",
                 " rvaconf !='X' AND ",
                 " rvbslk04 = pmm01 AND ",
                 " rva06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND ",l_wc CLIPPED,
                 " GROUP BY rvbslk05,ima02,ima25,rva05,pmm02 "
     ELSE 
#FUN-C70089----ADD----end-----     
     LET l_sql = "SELECT ' ',rvb05,ima02,ima25,rva05,0,SUM(rvb07*pmn09), ",
                 "       0,0,0,'','','',pmm02,pmn18,pmn41,pmn43,pmn012 ",                          #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43  #FUN-A60027 add pmn012
                 " FROM rva_file,rvb_file LEFT OUTER JOIN ima_file ON rvb05=ima_file.ima01 ,pmn_file,pmm_file ",               #CHI-8C0017 Add pmm_file
                 " WHERE rva01 = rvb01 AND ",
                 " rvaconf !='X' AND ",
                 " rvb04 = pmn01 AND rvb03 = pmn02 AND ",
                 " rvb04 = pmm01 AND ",                                                     #CHI-8C0017
                 " rva06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND ",l_wc CLIPPED,
                 " GROUP BY rvb05,ima02,ima25,rva05,pmm02,pmn18,pmn41,pmn43 " #add ima02    #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43
     END IF   #FUN-C70089----ADD---            
     PREPARE g622_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare 2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE g622_cs2 CURSOR FOR g622_prepare2
     LET l_cnt = 0                                    #CHI-8C0017
     FOREACH g622_cs2 INTO sr.*,l_pmm02,l_pmn18,l_pmn41,l_pmn43,l_pmn012                  #CHI-8C0017 Add l_pmm02,l_pmn18,l_pmn41,l_pmn43  #FUN-A60027 add l_pmn012
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach 2:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.pmn20) THEN LET sr.pmn20 = 0 END IF 
       IF cl_null(sr.rvb07) THEN LET sr.rvb07 = 0 END IF 
       IF cl_null(sr.rvv171) THEN LET sr.rvv171 = 0 END IF 
       IF cl_null(sr.rvv172) THEN LET sr.rvv172 = 0 END IF 
       IF cl_null(sr.rvv173) THEN LET sr.rvv173 = 0 END IF 
       IF tm.a='1' THEN
          LET sr.pmm09=' '
          LET sr.pmc03=' '   #FUN-C70089--ADD--
       END IF
       #取得pmc03
       #CHI-8C0017--Begin--#                             
       IF l_pmm02='SUB' THEN
          LET l_pmh22='2'
          #NO,TQC-910033  --begin--
          IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
             LET l_pmh21 =' '
          ELSE
          #NO.TQC-910033 --end--
            IF NOT cl_null(l_pmn18) THEN
             SELECT sgm04 INTO l_pmh21 FROM sgm_file
              WHERE sgm01=l_pmn18
                AND sgm02=l_pmn41
                AND sgm03=l_pmn43
                AND sgm012 = l_pmn012   #FUN-A60076  
            ELSE
             SELECT ecm04 INTO l_pmh21 FROM ecm_file 
              WHERE ecm01=l_pmn41
                AND ecm03=l_pmn43
                AND ecm012 = l_pmn012   #FUN-A60027
            END IF    
          END IF             #No.TQC-910033
       ELSE
          LET l_pmh22='1'
          LET l_pmh21=' '
       END IF
       #CHI-8C0017--End--#       
       SELECT pmh02 INTO sr.pmh02 FROM pmh_file   
        WHERE pmh01=sr.pmn04
#         AND pmh21 = " "                                             #CHI-860042      #CHI-8C0017 Mark
#         AND pmh22 = '1'                                             #CHI-860042      #CHI-8C0017 Mark
          AND pmh21 = l_pmh21                                                          #CHI-8C0017
          AND pmh22 = l_pmh22                                                          #CHI-8C0017
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021          
       IF SQLCA.sqlcode THEN LET sr.pmh02 =  NULL END IF                
       IF tm.a='2' THEN
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01=sr.pmm09
           IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF
       ELSE
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01= sr.pmh02
          IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF               
       END IF               
       SELECT ima021 INTO sr.ima021 FROM ima_file
        WHERE ima01 = sr.pmn04 
       LET sr.pmc03 = sr.pmc03[1,10]
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
       EXECUTE insert_prep USING 
           sr.order1,sr.pmn04,sr.pmn041,sr.ima25,sr.pmm09,sr.pmn20,
           sr.rvb07,sr.rvv171,sr.rvv172,sr.rvv173,sr.pmc03,sr.ima021,sr.pmh02
       #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
     #計算入/退量(rvv_file)
     LET l_buf=tm.wc
     #TQC-C30176 modify begin------------------------------
     #LET l_j=length(l_buf)
     #FOR l_i=1 TO l_j
     #   IF l_buf[l_i,l_i+4]='pmn04' THEN LET l_buf[l_i,l_i+4]='rvv31' END IF
     #   IF l_buf[l_i,l_i+4]='pmm09' THEN LET l_buf[l_i,l_i+4]='rvu04' END IF
     #END FOR
     #FUN-C70089-----ADD----STR---
     IF s_industry('slk') AND g_azw.azw04='2' THEN
        LET l_buf=cl_replace_str(l_buf,"pmnslk04","rvvslk31")
     ELSE    
     #FUN-C70089----ADD-----END---
     LET l_buf=cl_replace_str(l_buf,"pmn04","rvv31")
     END IF   #FUN-C70089----ADD--
     LET l_buf=cl_replace_str(l_buf,"pmm09","rvu04")
     #TQC-C30176 modify end--------------------------------
     LET l_wc = l_buf
     #FUN-C70089-----ADD----STR---
     IF s_industry('slk') AND g_azw.azw04='2' THEN
        LET l_sql = "SELECT ' ',rvvslk31,rvvslk031,ima25,rvu04,0,0,SUM(rvvslk17*rvvslk35_fac),",
                 "       0,0,'','','',rvu00,pmm02,'','','','' ",
                 " FROM rvu_file,rvvslk_file LEFT OUTER JOIN ima_file ON rvvslk31=ima_file.ima01 ,rvbslk_file,pmm_file ",
                 " WHERE rvu01 = rvvslk01  AND " ,
                 " rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND rvvslk04 = rvbslk01 AND rvvslk05 = rvbslk02 ",
                 " AND rvbslk04 = pmm01 ",
                 " AND rvuconf !='X' AND ",l_wc CLIPPED,
                 " GROUP BY rvvslk31,rvvslk031,ima25,rvu04,rvu00,pmm02 " 
     ELSE 
     #FUN-C70089-----ADD----end---
     LET l_sql = "SELECT ' ',rvv31,rvv031,ima25,rvu04,0,0,SUM(rvv17*rvv35_fac),", #FUN-4C0095 add rvv031
                 "       0,0,'','','',rvu00,pmm02,pmn18,pmn41,pmn43,pmn012 ",                 #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43  #FUN-A60027 add pmn012 
                 " FROM rvu_file,rvv_file LEFT OUTER JOIN ima_file ON rvv31=ima_file.ima01 ,rvb_file,pmm_file,pmn_file ",#CHI-8C0017 Add rvb_file,pmn_file,pmm_file
                 " WHERE rvu01 = rvv01  AND " ,
                 " rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 " AND rvv04 = rvb01 AND rvv05 = rvb02 ",                              #CHI-8C0017
                 " AND rvb04 = pmn01 AND rvb03 = pmn02 ",                              #CHI-8C0017
                 " AND rvb04 = pmm01 ",                                                #CHI-8C0017
                 " AND rvuconf !='X' AND ",l_wc CLIPPED,
                 " GROUP BY rvv31,rvv031,ima25,rvu04,rvu00,pmm02,pmn18,pmn41,pmn43 " #add rvv031 #FUN-4C0095  #CHI-8C0017 Add ,pmm02,pmn18,pmn41,pmn43
     END IF #FUN-C70089-----ADD--
     PREPARE g622_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare 3:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE g622_cs3 CURSOR FOR g622_prepare3
     LET l_cnt = 0                                    #CHI-8C0017
     FOREACH g622_cs3 INTO sr.*,l_rvu00,l_pmm02,l_pmn18,l_pmn41,l_pmn43,l_pmn012                #CHI-8C0017 Add l_pmm02,l_pmn18,l_pmn41,l_pmn43  #FUN-A60027 add l_pmn012
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach 3:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF l_rvu00='2' THEN
          LET sr.rvv172 = sr.rvv171
          LET sr.rvv171 = 0
       END IF
       IF l_rvu00='3' THEN
          LET sr.rvv173 = sr.rvv171
          LET sr.rvv171 = 0
       END IF
       IF cl_null(sr.pmn20) THEN LET sr.pmn20 = 0 END IF 
       IF cl_null(sr.rvb07) THEN LET sr.rvb07 = 0 END IF 
       IF cl_null(sr.rvv171) THEN LET sr.rvv171 = 0 END IF 
       IF cl_null(sr.rvv172) THEN LET sr.rvv172 = 0 END IF 
       IF cl_null(sr.rvv173) THEN LET sr.rvv173 = 0 END IF 
 
       IF tm.a='1' THEN
          LET sr.pmm09=' '
          LET sr.pmc03=' '   #FUN-C70089---ADD-----
       END IF
 
       #取得pmc03
       #CHI-8C0017--Begin--#                               
       IF l_pmm02='SUB' THEN
          LET l_pmh22='2'
          #NO,TQC-910033  --begin--
          IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
             LET l_pmh21 =' '
          ELSE
          #NO.TQC-910033 --end--
            IF NOT cl_null(l_pmn18) THEN
             SELECT sgm04 INTO l_pmh21 FROM sgm_file
              WHERE sgm01=l_pmn18
                AND sgm02=l_pmn41
                AND sgm03=l_pmn43
                AND sgm012 = l_pmn012   #FUN-A60076
            ELSE
             SELECT ecm04 INTO l_pmh21 FROM ecm_file 
              WHERE ecm01=l_pmn41
                AND ecm03=l_pmn43
                AND ecm012 = l_pmn012   #FUN-A60027 
            END IF
          END IF       #No.TQC-910033  
       ELSE
          LET l_pmh22='1'
          LET l_pmh21=' '
       END IF
       #CHI-8C0017--End--#       
       SELECT pmh02 INTO sr.pmh02 FROM pmh_file   
        WHERE pmh01=sr.pmn04
#         AND pmh21 = " "                                             #CHI-860042      #CHI-8C0017 Mark
#         AND pmh22 = '1'                                             #CHI-860042      #CHI-8C0017 Mark
          AND pmh21 = l_pmh21                                                          #CHI-8C0017
          AND pmh22 = l_pmh22                                                          #CHI-8C0017
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021          
       IF SQLCA.sqlcode THEN LET sr.pmh02 =  NULL END IF                
       IF tm.a='2' THEN
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01=sr.pmm09
           IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF
       ELSE
          SELECT pmc03 INTO sr.pmc03 FROM pmc_file
           WHERE pmc01= sr.pmh02
          IF SQLCA.sqlcode THEN LET sr.pmc03 = NULL END IF               
       END IF               
       SELECT ima021 INTO sr.ima021 FROM ima_file
        WHERE ima01 = sr.pmn04 
       LET sr.pmc03 = sr.pmc03[1,10]
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720010 *** ##
       EXECUTE insert_prep USING 
           sr.order1,sr.pmn04,sr.pmn041,sr.ima25,sr.pmm09,sr.pmn20,
           sr.rvb07,sr.rvv171,sr.rvv172,sr.rvv173,sr.pmc03,sr.ima021,sr.pmh02
       #------------------------------ CR (3) ------------------------------#
     END FOREACH
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
#FUN-C70089-------ADD------STR------
     IF tm.a='1' THEN 
        LET l_wc2 = "SELECT pmn04,max(pmm09),sum(pmn20),sum(rvb07),sum(rvv171),sum(rvv172),sum(rvv173) ",
                 "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," GROUP BY pmn04 ",
                 "  ORDER BY pmn04 "
     ELSE             
        LET l_wc2 = "SELECT pmn04,pmm09,sum(pmn20),sum(rvb07),sum(rvv171),sum(rvv172),sum(rvv173) ",
                    "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," GROUP BY pmn04,pmm09 ",
                    "  ORDER BY pmn04,pmm09 "
     END IF               
     PREPARE apmg622_slk_pre1 FROM l_wc2
     DECLARE apmg622_slk_cs1  CURSOR FOR apmg622_slk_pre1
     FOREACH apmg622_slk_cs1 INTO sr.pmn04,sr.pmm09,sr.pmn20,sr.rvb07,sr.rvv171,sr.rvv172,sr.rvv173
        SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr.pmn04
      IF l_ima151='Y' AND (sr.pmn20!=0  OR sr.rvb07!=0 OR sr.rvv171!=0  OR sr.rvv173!=0) THEN
         LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",sr.pmn04,"'",
               "   AND imx02=agd02",
               "   AND agd01 IN ",
               " (SELECT ima941 FROM ima_file WHERE ima01='",sr.pmn04,"')",
               " ORDER BY agd04"
           PREPARE g410_slk_sr2_pre FROM l_sql
           DECLARE g410_slk_sr2_cs CURSOR FOR g410_slk_sr2_pre 
           LET l_imx02 = NULL 
           INITIALIZE l_imx_t.* TO NULL
           FOR l_i = 1 TO 15
               LET l_imx[l_i].imx01 =NULL
           END FOR   
           LET l_i = 1
            
           FOREACH g410_slk_sr2_cs INTO l_imx02,l_agd04
              LET l_imx[l_i].imx01=' '
              SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
               WHERE agd01 = ima941 AND agd02 = l_imx02 
                 AND ima01 = sr.pmn04 
              LET l_i = l_i + 1
           END FOREACH 
           FOR l_i = 1 TO 15 
              IF cl_null(l_imx[l_i].imx01) THEN
                 LET l_imx[l_i].imx01 = ' '
              END IF
           END FOR 
           LET l_imx_t.agd03_1 = l_imx[1].imx01
           LET l_imx_t.agd03_2 = l_imx[2].imx01
           LET l_imx_t.agd03_3 = l_imx[3].imx01
           LET l_imx_t.agd03_4 = l_imx[4].imx01
           LET l_imx_t.agd03_5 = l_imx[5].imx01
           LET l_imx_t.agd03_6 = l_imx[6].imx01
           LET l_imx_t.agd03_7 = l_imx[7].imx01
           LET l_imx_t.agd03_8 = l_imx[8].imx01
           LET l_imx_t.agd03_9 = l_imx[9].imx01
           LET l_imx_t.agd03_10 = l_imx[10].imx01
           LET l_imx_t.agd03_11 = l_imx[11].imx01
           LET l_imx_t.agd03_12 = l_imx[12].imx01
           LET l_imx_t.agd03_13 = l_imx[13].imx01
           LET l_imx_t.agd03_14 = l_imx[14].imx01
           LET l_imx_t.agd03_15 = l_imx[15].imx01
           EXECUTE insert_prep1 USING 
           l_imx_t.*,sr.pmn04
#子報表2
           LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
                " WHERE imx00 = '",sr.pmn04,"'",
               "   AND imx01=agd02",
               "   AND agd01 IN ",
               " (SELECT ima940 FROM ima_file WHERE ima01='",sr.pmn04,"')",
               " ORDER BY agd04"
           PREPARE g410_slk_colslk_pre FROM l_sql
           DECLARE g410_slk_colslk_cs CURSOR FOR g410_slk_colslk_pre
           LET l_imx01 = NULL

           FOREACH g410_slk_colslk_cs INTO l_imx01,l_agd04
              SELECT agd03 INTO l_agd03 FROM agd_file,ima_file
               WHERE agd01 = ima940 AND agd02 = l_imx01
                 AND ima01 = sr.pmn04 
   
              LET l_sql2 = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
                   " WHERE imx00 = '",sr.pmn04,"'",
                   "   AND imx02=agd02",
                   "   AND agd01 IN ",
                   " (SELECT ima941 FROM ima_file WHERE ima01='",sr.pmn04,"')",
                   " ORDER BY agd04"
              PREPARE g410_slk_sr3_pre FROM l_sql2
              DECLARE g410_slk_sr3_cs CURSOR FOR g410_slk_sr3_pre
              LET l_imx02 = NULL
              LET l_i = 1
              FOR l_i = 1 TO 15
                  LET l_num[l_i].number =NULL
              END FOR
              LET l_i = 1
              FOREACH g410_slk_sr3_cs INTO l_imx02,l_agd04
                 LET l_imx[l_i].imx01=' ' 
                 SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
                  WHERE agd01 = ima941 AND agd02 = l_imx02
                    AND ima01 = sr.pmn04
          
                 SELECT sma46 INTO l_ps FROM sma_file
                 IF cl_null(l_ps) THEN LET l_ps = ' ' END IF
                 LET l_ima01 = sr.pmn04,l_ps,l_imx01,l_ps,l_imx02
                 IF tm.a='1' THEN
                    SELECT count(*) INTO l_n 
                      FROM pmn_file,pmm_file,pmnslk_file,pmni_file
                     WHERE pmn04=l_ima01 AND pmm01=pmn01 AND pmmplant=g_plant
                       AND pmn01=pmni01 AND pmn02=pmni02
                       AND pmnslk01=pmni01 AND pmnslk02=pmnislk03
                    SELECT count(*) INTO l_n1 
                      FROM rvb_file,rva_file,rvbslk_file,rvbi_file
                     WHERE rvb04=l_ima01 AND rva01=rvb01 AND rvbplant=g_plant
                       AND rvb01=rvbi01 AND rvb02=rvbi02
                       AND rvbslk01=rvbi01 AND rvbslk02=rvbislk02
                    SELECT count(*) INTO l_n2 
                      FROM rvv_file,rvu_file,rvvslk_file,rvvi_file
                     WHERE rvv31=l_ima01 AND rvv01=rvu01 AND rvvplant=g_plant
                       AND rvv01=rvvi01 AND rvv02=rvvi02
                       AND rvvslk01=rvvi02 AND rvvslk02=rvvislk02 
                 ELSE   
                    SELECT count(*) INTO l_n FROM pmn_file,pmm_file,pmnslk_file,pmni_file 
                     WHERE pmn04=l_ima01 AND pmm01=pmn01 
                       AND pmm09=sr.pmm09 AND pmmplant=g_plant
                       AND pmn01=pmni01 AND pmn02=pmni02
                       AND pmnslk01=pmni01 AND pmnslk02=pmnislk03
                    SELECT count(*) INTO l_n1 FROM rvb_file,rva_file,rvbslk_file,rvbi_file
                     WHERE rvb04=l_ima01 AND rva01=rvb01 
                       AND rva05=sr.pmm09 AND rvbplant=g_plant
                       AND rvb01=rvbi01 AND rvb02=rvbi02
                       AND rvbslk01=rvbi01 AND rvbslk02=rvbislk02
                    SELECT count(*) INTO l_n2 FROM rvv_file,rvu_file,rvvslk_file,rvvi_file
                     WHERE rvv31=l_ima01 AND rvv01=rvu01 
                       AND rvu04=sr.pmm09 AND rvvplant=g_plant
                       AND rvv01=rvvi01 AND rvv02=rvvi02
                       AND rvvslk01=rvvi02 AND rvvslk02=rvvislk02
                       
                 END IF   
                 IF (l_n>0 OR l_n1>0 OR l_n2>0) THEN
                    IF tm.a='1' THEN
                       SELECT SUM(pmn20) INTO l_num[l_i].number FROM pmn_file,pmm_file,pmnslk_file,pmni_file 
                        WHERE pmn04=l_ima01 AND pmm01=pmn01
                          AND pmn01=pmni01 AND pmn02=pmni02
                          AND pmnslk01=pmni01 AND pmnslk02=pmnislk03
                          AND pmm04 BETWEEN tm.bdate AND tm.edate
                          AND pmm18<>'X'
                          AND pmmplant=g_plant
                       SELECT SUM(rvb07),SUM(rvb30) INTO l_num[l_i].number1,l_num[l_i].number2  
                         FROM rvb_file,rva_file,rvbslk_file,rvbi_file
                        WHERE rva01 = rvb01
                          AND rvb01=rvbi01 AND rvb02=rvbi02
                          AND rvbslk01=rvbi01 AND rvbslk02=rvbislk02
                          AND rva06 BETWEEN tm.bdate AND tm.edate
                          AND rvaconf <> 'X'
                          AND rvb05=l_ima01 
                          AND rvbplant=g_plant
                       SELECT SUM(rvv17) INTO l_num[l_i].number3 
                         FROM rvv_file,rvu_file,rvvslk_file,rvvi_file
                        WHERE rvv01 = rvu01
                          AND rvv01=rvvi01 AND rvv02=rvvi02
                          AND rvvslk01=rvvi02 AND rvvslk02=rvvislk02 
                          AND rvu03 BETWEEN tm.bdate AND tm.edate
                          AND rvu00='3'
                          AND rvuconf <> 'X' AND rvv31=l_ima01
                          AND rvvplant=g_plant
                    ELSE       
                       SELECT SUM(pmn20) INTO l_num[l_i].number FROM pmn_file,pmm_file,pmnslk_file,pmni_file 
                        WHERE pmn04=l_ima01 AND pmm01=pmn01 AND pmm09=sr.pmm09
                          AND pmn01=pmni01 AND pmn02=pmni02
                          AND pmnslk01=pmni01 AND pmnslk02=pmnislk03
                          AND pmm04 BETWEEN tm.bdate AND tm.edate
                          AND pmm18<>'X'
                          AND pmmplant=g_plant
                          
                       SELECT SUM(rvb07),SUM(rvb30) INTO l_num[l_i].number1,l_num[l_i].number2  
                         FROM rvb_file,rva_file,rvbslk_file,rvbi_file
                        WHERE rva01 = rvb01
                          AND rvb01=rvbi01 AND rvb02=rvbi02
                          AND rvbslk01=rvbi01 AND rvbslk02=rvbislk02
                          AND rva06 BETWEEN tm.bdate AND tm.edate
                          AND rvaconf <> 'X'
                          AND rvb05=l_ima01 AND rva05=sr.pmm09
                          AND rvbplant=g_plant
                       SELECT SUM(rvv17) INTO l_num[l_i].number3 FROM rvv_file,rvu_file,rvvslk_file,rvvi_file
                        WHERE rvv01 = rvu01
                          AND rvv01=rvvi01 AND rvv02=rvvi02
                          AND rvvslk01=rvvi02 AND rvvslk02=rvvislk02
                          AND rvu03 BETWEEN tm.bdate AND tm.edate
                          AND rvu00='3'
                          AND rvuconf <> 'X' AND rvv31=l_ima01 AND rvu04=sr.pmm09
                          AND rvvplant=g_plant
                    END IF      
                 ELSE
                    LET l_num[l_i].number=0
                    LET l_num[l_i].number1=0
                    LET l_num[l_i].number2=0
                    LET l_num[l_i].number3=0
                 END IF     
                 LET l_i=l_i+1   
                 LET l_imx02=null
              END FOREACH
              LET l_num_t.number1=l_num[1].number
              LET l_num_t.number11=l_num[1].number1
              LET l_num_t.number12=l_num[1].number2
              LET l_num_t.number13=l_num[1].number3
              LET l_num_t.number2=l_num[2].number
              LET l_num_t.number21=l_num[2].number1 
              LET l_num_t.number22=l_num[2].number2
              LET l_num_t.number23=l_num[2].number3
              LET l_num_t.number3=l_num[3].number
              LET l_num_t.number31=l_num[3].number1 
              LET l_num_t.number32=l_num[3].number2
              LET l_num_t.number33=l_num[3].number3
              LET l_num_t.number4=l_num[4].number
              LET l_num_t.number41=l_num[4].number1
              LET l_num_t.number42=l_num[4].number2
              LET l_num_t.number43=l_num[4].number3
              LET l_num_t.number5=l_num[5].number
              LET l_num_t.number51=l_num[5].number1
              LET l_num_t.number52=l_num[5].number2
              LET l_num_t.number53=l_num[5].number3
              LET l_num_t.number6=l_num[6].number
              LET l_num_t.number61=l_num[6].number1 
              LET l_num_t.number62=l_num[6].number2
              LET l_num_t.number63=l_num[6].number3
              LET l_num_t.number7=l_num[7].number
              LET l_num_t.number71=l_num[7].number1
              LET l_num_t.number72=l_num[7].number2
              LET l_num_t.number73=l_num[7].number3
              LET l_num_t.number8=l_num[8].number
              LET l_num_t.number81=l_num[8].number1
              LET l_num_t.number82=l_num[8].number2
              LET l_num_t.number83=l_num[8].number3 
              IF cl_null(l_num_t.number1) THEN LET l_num_t.number1=0 END IF
              IF cl_null(l_num_t.number11) THEN LET l_num_t.number11=0 END IF
              IF cl_null(l_num_t.number12) THEN LET l_num_t.number12=0 END IF
              IF cl_null(l_num_t.number13) THEN LET l_num_t.number13=0 END IF
              IF cl_null(l_num_t.number2) THEN LET l_num_t.number2=0 END IF
              IF cl_null(l_num_t.number21) THEN LET l_num_t.number21=0 END IF
              IF cl_null(l_num_t.number22) THEN LET l_num_t.number22=0 END IF
              IF cl_null(l_num_t.number23) THEN LET l_num_t.number23=0 END IF
              IF cl_null(l_num_t.number3) THEN LET l_num_t.number3=0 END IF
              IF cl_null(l_num_t.number31) THEN LET l_num_t.number31=0 END IF
              IF cl_null(l_num_t.number32) THEN LET l_num_t.number32=0 END IF
              IF cl_null(l_num_t.number33) THEN LET l_num_t.number33=0 END IF
              IF cl_null(l_num_t.number4) THEN LET l_num_t.number4=0 END IF
              IF cl_null(l_num_t.number41) THEN LET l_num_t.number41=0 END IF
              IF cl_null(l_num_t.number42) THEN LET l_num_t.number42=0 END IF
              IF cl_null(l_num_t.number43) THEN LET l_num_t.number43=0 END IF
              IF cl_null(l_num_t.number5) THEN LET l_num_t.number5=0 END IF
              IF cl_null(l_num_t.number51) THEN LET l_num_t.number51=0 END IF
              IF cl_null(l_num_t.number52) THEN LET l_num_t.number52=0 END IF
              IF cl_null(l_num_t.number53) THEN LET l_num_t.number53=0 END IF
              IF cl_null(l_num_t.number6) THEN LET l_num_t.number6=0 END IF
              IF cl_null(l_num_t.number61) THEN LET l_num_t.number61=0 END IF
              IF cl_null(l_num_t.number62) THEN LET l_num_t.number62=0 END IF
              IF cl_null(l_num_t.number63) THEN LET l_num_t.number63=0 END IF
              IF cl_null(l_num_t.number7) THEN LET l_num_t.number7=0 END IF
              IF cl_null(l_num_t.number71) THEN LET l_num_t.number71=0 END IF
              IF cl_null(l_num_t.number72) THEN LET l_num_t.number72=0 END IF
              IF cl_null(l_num_t.number73) THEN LET l_num_t.number73=0 END IF
              IF cl_null(l_num_t.number8) THEN LET l_num_t.number8=0 END IF
              IF cl_null(l_num_t.number81) THEN LET l_num_t.number81=0 END IF
              IF cl_null(l_num_t.number82) THEN LET l_num_t.number82=0 END IF
              IF cl_null(l_num_t.number83) THEN LET l_num_t.number83=0 END IF
              IF  l_num_t.number1=0 AND l_num_t.number11=0 AND
              l_num_t.number12=0 AND l_num_t.number2=0 AND
              l_num_t.number21=0 AND l_num_t.number22=0 AND 
              l_num_t.number3=0 AND l_num_t.number13=0 AND
              l_num_t.number31=0 AND l_num_t.number23=0 AND
              l_num_t.number32=0 AND l_num_t.number33=0 AND
              l_num_t.number4=0 AND l_num_t.number43=0 AND
              l_num_t.number41=0 AND l_num_t.number53=0 AND
              l_num_t.number42=0 AND l_num_t.number63=0 AND
              l_num_t.number5=0 AND l_num_t.number73=0 AND
              l_num_t.number51=0 AND l_num_t.number8=0 AND
              l_num_t.number52=0 AND l_num_t.number81=0 AND
              l_num_t.number6=0 AND l_num_t.number82=0 AND
              l_num_t.number61=0 AND l_num_t.number83=0 AND
              l_num_t.number62=0 AND
              l_num_t.number7=0 AND
              l_num_t.number71=0 AND
              l_num_t.number72=0 THEN
                 CONTINUE FOREACH
              ELSE 
                 EXECUTE insert_prep2 USING 
                 l_imx01,l_num_t.*,sr.pmn04,sr.pmm09
              END IF 
          END FOREACH
        END IF    
     END FOREACH 
     
#FUN-C70089-------ADD------END------
     LET g_str = ''
     #IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pmn04,pmm09') 
             RETURNING tm.wc
        LET g_str = tm.wc
     #END IF
###GENGRE###     LET g_str = g_str,";",tm.a,";",tm.bdate,";",tm.edate
###GENGRE###     CALL cl_prt_cs3('apmg622','apmg622',l_sql,g_str)   #FUN-710080 modify
    IF s_industry('slk') AND g_azw.azw04='2' THEN
       LET g_template="apmg622_slk"
       CALL apmg622_slk_grdata()
    ELSE 
       LET g_template="apmg622"
       
       CALL apmg622_grdata()    ###GENGRE###
    END IF 
    
#    LET g_prog=l_program
     #------------------------------ CR (4) ------------------------------#
END FUNCTION


###GENGRE###START
FUNCTION apmg622_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
#    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("apmg622")
        IF handler IS NOT NULL THEN
            START REPORT apmg622_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        "  ORDER BY pmn04,pmm09 "
         
            DECLARE apmg622_datacur1 CURSOR FROM l_sql
            FOREACH apmg622_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg622_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg622_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg622_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_pmn20_1_sum LIKE pmn_file.pmn20
    DEFINE l_rvb07_2_sum LIKE rvb_file.rvb07
    DEFINE l_rvv172_3_sum LIKE rvv_file.rvv17
    DEFINE l_rvv171_4_sum LIKE rvv_file.rvv17
    DEFINE l_rvv173_5_sum LIKE rvv_file.rvv17
    DEFINE l_display      LIKE type_file.chr1 
    
    ORDER EXTERNAL BY sr1.pmm09,sr1.pmn04,sr1.ima25
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
             
        BEFORE GROUP OF sr1.pmm09 
        BEFORE GROUP OF sr1.pmn04
        BEFORE GROUP OF sr1.ima25
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_display='N'
            PRINTX l_display  

            PRINTX sr1.*

        AFTER GROUP OF sr1.pmm09    
        AFTER GROUP OF sr1.pmn04
            
            LET l_rvv173_5_sum = GROUP SUM(sr1.rvv173)

            PRINTX l_rvv173_5_sum
            LET l_rvv171_4_sum = GROUP SUM(sr1.rvv171)
            PRINTX l_rvv171_4_sum
            LET l_rvv172_3_sum = GROUP SUM(sr1.rvv172)
            PRINTX l_rvv172_3_sum
            LET l_rvb07_2_sum = GROUP SUM(sr1.rvb07)
            PRINTX l_rvb07_2_sum
            LET l_pmn20_1_sum = GROUP SUM(sr1.pmn20)
            PRINTX l_pmn20_1_sum
        AFTER GROUP OF sr1.ima25

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C70089------ADD-----STR------
FUNCTION apmg622_slk_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
#    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("apmg622")
        IF handler IS NOT NULL THEN
            START REPORT apmg622_slk_rep TO XML HANDLER handler
#            IF tm.a='1' THEN
#               LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
#                           "  ORDER BY pmn04 "
#            ELSE  
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        "  ORDER BY pmn04,pmm09 "
         
#            END IF
            DECLARE apmg622_slk_datacur1 CURSOR FROM l_sql
            FOREACH apmg622_slk_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg622_slk_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg622_slk_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg622_slk_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_pmn20_1_sum LIKE pmn_file.pmn20
    DEFINE l_rvb07_2_sum LIKE rvb_file.rvb07
    DEFINE l_rvv172_3_sum LIKE rvv_file.rvv17
    DEFINE l_rvv171_4_sum LIKE rvv_file.rvv17
    DEFINE l_rvv173_5_sum LIKE rvv_file.rvv17
    DEFINE l_display      LIKE type_file.chr1 
    #FUN-C70089----ADD----STR---
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_display1         LIKE type_file.chr1 
    DEFINE l_ima151          LIKE ima_file.ima151
    DEFINE l_sql             STRING
    #FUN-C70089----ADD-----END---- 
    
    ORDER EXTERNAL BY sr1.pmm09,sr1.pmn04,sr1.ima25
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
             
        BEFORE GROUP OF sr1.pmm09 
        BEFORE GROUP OF sr1.pmn04
        BEFORE GROUP OF sr1.ima25
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_display='N'
            PRINTX l_display  

            PRINTX sr1.*

        AFTER GROUP OF sr1.pmm09    
        AFTER GROUP OF sr1.pmn04
            
            LET l_rvv173_5_sum = GROUP SUM(sr1.rvv173)

            PRINTX l_rvv173_5_sum
            LET l_rvv171_4_sum = GROUP SUM(sr1.rvv171)
            PRINTX l_rvv171_4_sum
            LET l_rvv172_3_sum = GROUP SUM(sr1.rvv172)
            PRINTX l_rvv172_3_sum
            LET l_rvb07_2_sum = GROUP SUM(sr1.rvb07)
            PRINTX l_rvb07_2_sum
            LET l_pmn20_1_sum = GROUP SUM(sr1.pmn20)
            PRINTX l_pmn20_1_sum
            
            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr1.pmn04
            IF l_ima151='Y' AND (sr1.pmn20!=0  OR sr1.rvb07!=0  OR sr1.rvv171!=0 OR  sr1.rvv173!=0) THEN
               LET l_display1 = 'Y'
            ELSE 
               LET l_display1 = 'N'
            END IF 
            PRINTX l_display1   
            LET l_sql = "SELECT distinct * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE pmnslk04 = '",sr1.pmn04 CLIPPED,"'"
               START REPORT apmg622_slk_subrep01                       #TQC-D10063 add slk_
               DECLARE apmg622_repcur1 CURSOR FROM l_sql
               FOREACH apmg622_repcur1 INTO sr2.*
                  OUTPUT TO REPORT apmg622_slk_subrep01(sr2.*)         #TQC-D10063 add slk_
               END FOREACH
               FINISH REPORT apmg622_slk_subrep01                      #TQC-D10063 add slk_

#子報表2       
               IF tm.a='1' THEN
                  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                              " WHERE pmnslk04 = '",sr1.pmn04 CLIPPED,"'" 
               ELSE  
               LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE pmnslk04 = '",sr1.pmn04 CLIPPED,"'",
                        " AND pmm09 = ",sr1.pmm09 CLIPPED
               END IF
               START REPORT apmg622_slk_subrep02                       #TQC-D10063 add slk_
               DECLARE apmg622_repcur2 CURSOR FROM l_sql
               FOREACH apmg622_repcur2 INTO sr3.*
                   OUTPUT TO REPORT apmg622_slk_subrep02(sr3.*,sr2.*)  #TQC-D10063 add slk_
               END FOREACH
               FINISH REPORT apmg622_slk_subrep02                      #TQC-D10063 add slk_
        AFTER GROUP OF sr1.ima25

        
        ON LAST ROW

END REPORT
REPORT apmg622_slk_subrep01(sr2)       #TQC-D10063 add slk_
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*

END REPORT
REPORT apmg622_slk_subrep02(sr3,sr2)   #TQC-D10063 add slk_
    DEFINE sr3 sr3_t
    DEFINE sr2 sr2_t
    DEFINE l_color  LIKE agd_file.agd03

    FORMAT
        ON EVERY ROW
        SELECT agd03 INTO l_color FROM agd_file,ima_file
           WHERE agd01 = ima940 AND agd02 = sr3.imx01
             AND ima01 = sr3.pmnslk04
            PRINTX l_color 
            PRINTX sr3.*
            PRINTX sr2.*

END REPORT
#FUN-C70089------ADD-----END------
