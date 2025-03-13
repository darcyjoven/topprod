# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr410.4gl
# Descriptions...: 請購轉採購清單
# Input parameter:
# Return code....:
# Date & Author..: 91/10/20 By Nora
# Modify.........: 99/04/15 By Carol:modify s_pmmsta()
# Modify.........: No.8459 03/10/13 By Melody 將pmk08改pmn01
# Modify.........: No.FUN-4C0095 04/12/31 By Mandy 報表轉XML
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-550060 05/05/31 By yoyo  單據編號加大
# Modify.........: No.FUN-580004 05/08/03 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 報表名稱和製表日期的行位置應對調
# Modify.........: No.TQC-5B0140 05/11/18 By Rosayu 修改報表結束定為點
# Modify.........: No.MOD-540173 06/01/06 By Mandy 表頭列印排列順序的資料,在第二頁後就會列出重覆的資料,原因是不能在PAGE HEADER 給定 g_x[19]的資料
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.FUN-660129 06/06/20 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.TQC-6C0136 06/12/22 By rainy 使用計價單位時金額有誤問題調整
# Modify.........: No.FUN-840021 08/04/09 By xiaofeizhu 報表輸出改為CR
# Modify.........: No.MOD-870161 08/07/14 By Cockroach  pmk07沒有用到，暫時隱藏
# Modify.........: No.FUN-870151 08/08/18 By xiaofeizhu 匯率調整為用azi07取位
# Modify.........: No.CHI-950035 09/08/14 By Smapmin 將子報表的方式改為使用一個主報表
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-C90195 12/09/27 By jt_chen 改用tw.wc去串權限
# Modify.........: No.TQC-D10041 13/01/09 BY xuxz 添加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17    #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD		               # Print condition RECORD
            #  wc     VARCHAR(500),               # Where Condition
              wc      STRING,                  #TQC-630166       # Where Condition
              s       LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)
              amt_sw  LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
              more    LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
              END RECORD,
          g_minus     LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(109)
DEFINE   g_i          LIKE type_file.num5      #count/index for any purpose   #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
DEFINE   g_cnt        LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE   g_sma115     LIKE sma_file.sma115
DEFINE   g_sma116     LIKE sma_file.sma116
#No.FUN-580004 --end--
 
#No.FUN-840021 --Add--Begin--
DEFINE   l_table1        STRING                                                                                                     
#DEFINE   l_table2        STRING   #CHI-950035                                                                                                  
DEFINE   g_str           STRING                                                                                                     
DEFINE   g_sql           STRING
#No.FUN-840021 --Add--End--
 
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
 
#No.FUN-840021 --Add--Begin--
#--------------------------CR(1)--------------------------------#                                                                   
   LET g_sql = " pmk01.pmk_file.pmk01,",
               " pmk03.pmk_file.pmk03,",
               " pmk02.pmk_file.pmk02,",
               " pmk09.pmk_file.pmk09,",
               " pmk22.pmk_file.pmk22,",
               " pmk42.pmk_file.pmk42,",
               " pml02.pml_file.pml02,",
               " pml04.pml_file.pml04,",
               " ima08.ima_file.ima08,",
               " pml33.pml_file.pml33,",
               " pml34.pml_file.pml34,",
               " pml35.pml_file.pml35,",
               " pml20.pml_file.pml20,",
               " pml20_u.pml_file.pml20,",
               " pml20_um.pml_file.pml44,",
               " pmc03.pmc_file.pmc03,",
               " pml041.pml_file.pml041,",
               " pml18.pml_file.pml18,",
               " pml44.pml_file.pml44,",
               " pml21.pml_file.pml21,",
               " pml21_m.pml_file.pml44,",
               " pmk04.pmk_file.pmk04,",
               " pmk07.pmk_file.pmk07,",
               " pmk12.pmk_file.pmk12,",
               " pmn01.pmn_file.pmn01,",
               " l_ima021.ima_file.ima021,",
               " t_azi03.azi_file.azi03,",
               " t_azi04.azi_file.azi04,",
               " t_azi07.azi_file.azi07,", #No.FUN-870151  
               #-----CHI-950035---------
               " pmn01_1.pmn_file.pmn01,",                                                                                            
               " pmn02.pmn_file.pmn02,",
               " pmm22.pmm_file.pmm22,",
               " pmm42.pmm_file.pmm42,",
               " pmn07.pmn_file.pmn07,",
               " pmn04.pmn_file.pmn04,",
               " pmn041.pmn_file.pmn041,",
               " ima08_1.ima_file.ima08,",
               " pmn33.pmn_file.pmn33,",
               " pmn20.pmn_file.pmn20,",
               " pmn20_m.pmn_file.pmn44,",
               " pmn44.pmn_file.pmn44,",
               " pmn16.type_file.chr10,",
               " pmn86.pmn_file.pmn86,",
               " pmn87.pmn_file.pmn87,",
               " l_ima021_1.ima_file.ima021,",
               " l_str2.type_file.chr1000,",
               " pmn24.pmn_file.pmn24,",
               " pmn25.pmn_file.pmn25,",
               " t_azi03_1.azi_file.azi03,",                                                                                          
               " t_azi04_1.azi_file.azi04,",
               " t_azi07_1.azi_file.azi07" 
               #-----END CHI-950035-----
 
   LET l_table1 = cl_prt_temptable('apmr4101',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   #-----CHI-950035---------
   #LET g_sql = " pmn01.pmn_file.pmn01,",                                                                                            
   #            " pmn02.pmn_file.pmn02,",
   #            " pmm22.pmm_file.pmm22,",
   #            " pmm42.pmm_file.pmm42,",
   #            " pmn07.pmn_file.pmn07,",
   #            " pmn04.pmn_file.pmn04,",
   #            " pmn041.pmn_file.pmn041,",
   #            " ima08.ima_file.ima08,",
   #            " pmn33.pmn_file.pmn33,",
   #            " pmn20.pmn_file.pmn20,",
   #            " pmn20_m.pmn_file.pmn44,",
   #            " pmn44.pmn_file.pmn44,",
   #            " pmn16.type_file.chr10,",
   #            " pmn86.pmn_file.pmn86,",
   #            " pmn87.pmn_file.pmn87,",
   #            " l_ima021_1.ima_file.ima021,",
   #            " l_str2.type_file.chr1000,",
   #            " pmn24.pmn_file.pmn24,",
   #            " pmn25.pmn_file.pmn25,",
   #            " t_azi03_1.azi_file.azi03,",                                                                                          
   #            " t_azi04_1.azi_file.azi04,",
   #            " t_azi07_1.azi_file.azi07" #No.FUN-870151
   #
   #LET l_table2 = cl_prt_temptable('apmr4102',g_sql) CLIPPED                                                                        
   #IF l_table2 = -1 THEN EXIT PROGRAM END IF
   #-----END CHI-950035-----
 
#--------------------------CR(1)--------------------------------#
#No.FUN-840021 --Add--End--
 
    IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
       CALL cl_err(g_sma.sma31,'mfg0032',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
    END IF
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.s     = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r410_tm(0,0)	
      ELSE CALL r410()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r410_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r410_w AT p_row,p_col WITH FORM "apm/42f/apmr410"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s      = '123'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
 
WHILE TRUE
#   CONSTRUCT BY NAME  tm.wc ON pmk01,pmk04,pmk07,pmk12,pmk09,pmn01 #8459  #MOD-870161 MARK
    CONSTRUCT BY NAME  tm.wc ON pmk01,pmk04,pmk12,pmk09,pmn01              #MOD-870161 ADD
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
       #TQC-D10041--add--str--add open win
       ON ACTION CONTROLP
         CASE WHEN INFIELD(pmk01)      #請購單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmk3"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk01
                   NEXT FIELD pmk01
              WHEN INFIELD(pmk12)      #請購員
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk12
                   NEXT FIELD pmk12
              WHEN INFIELD(pmk09)      #廠商編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_qcs3"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmk09
                   NEXT FIELD pmk09
              WHEN INFIELD(pmn01)      #採購單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmn02"
                   LET g_qryparam.state= "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmn01
                   NEXT FIELD pmn01
              OTHERWISE
                   EXIT CASE
         END CASE
      #TQC-D10041--add-end
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW r410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL Cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES'[YN]' THEN
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
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
 
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
      CLOSE WINDOW r410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr410'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr410','9031',1)   #No.FUN-660129
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
                         " '",tm.s,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr410',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r410_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r410()
   ERROR ""
END WHILE
   CLOSE WINDOW r410_w
END FUNCTION
 
FUNCTION r410()
   DEFINE l_name     LIKE type_file.chr20, 		 # External(Disk) file name      #No.FUN-680136 VARCHAR(20)
          l_time     LIKE type_file.chr8,  		 # Used time for running the job #No.FUN-680136 VARCHAR(8)
         #l_sql      LIKE type_file.chr1000,		 # RDSQL STATEMENT               #No.FUN-680136 VARCHAR(1000)#TQC-D10041 mark
          l_sql      STRING,#TQC-D10041 add
          l_za05     LIKE za_file.za05,                  #No.FUN-680136 VARCHAR(40)
          l_order    ARRAY[3] of LIKE pmk_file.pmk01,    #No.FUN-680136 VARCHAR(16)
          i          LIKE type_file.num5,                #No.FUN-580004 #No.FUN-680136 SMALLINT
          sr         RECORD
                    order1     LIKE    type_file.chr20,  #No.FUN-680136 VARCHAR(20)
                    order2     LIKE    type_file.chr20,  #No.FUN-680136 VARCHAR(20)
                    order3     LIKE    type_file.chr20,  #No.FUN-680136 VARCHAR(20)
                     pmk01     LIKE    pmk_file.pmk01,   #請購單號
                     pmk03     LIKE    pmk_file.pmk03,   #更動序號
                     pmk02     LIKE    pmk_file.pmk02,   #性質
                     pmk09     LIKE    pmk_file.pmk09,   #供應廠商
                     pmk22     LIKE    pmk_file.pmk22,   #幣別
                     pmk42     LIKE    pmk_file.pmk42,
                     pml02     LIKE    pml_file.pml02,   #項次
                     pml04     LIKE    pml_file.pml04,   #料件編號
                     ima08     LIKE    ima_file.ima08,   #來源
                     pml33     LIKE    pml_file.pml33,   #交貨日
                     pml34     LIKE    pml_file.pml34,   #No.TQC-640132
                     pml35     LIKE    pml_file.pml35,   #No.TQC-640132
                     pml20     LIKE    pml_file.pml20,   #訂購量
                     pml20_u   LIKE    pml_file.pml20,   #未轉採購量
                      pml20_um  LIKE    pml_file.pml44,   #MOD-530190  #未轉金額
                     pmc03     LIKE    pmc_file.pmc03,   #廠商簡稱
                     pml041    LIKE    pml_file.pml041,  #品名規格
                     pml18     LIKE    pml_file.pml18,   #MRP需求日
                     pml44     LIKE    pml_file.pml44,   #本幣單價
                     pml21     LIKE    pml_file.pml21,   #己轉採購量
                      pml21_m   LIKE    pml_file.pml44,   #MOD-530190  #己轉金額
                     pmk04     LIKE    pmk_file.pmk04,   #請購日期
                     pmk07     LIKE    pmk_file.pmk07,   #請購單類別
	                 pmk12     LIKE    pmk_file.pmk12,   #請購員
         	         pmn01     LIKE    pmn_file.pmn01    #採購單號
                     END RECORD
 
#No.FUN-840021 --Add--Begin--
DEFINE    sr1        RECORD                                                                                                         
                     pmn01     LIKE    pmn_file.pmn01,   #采購單號                                                                  
                     pmn02     LIKE    pmn_file.pmn02,   #采購項次                                                                  
                     pmm22     LIKE    pmm_file.pmm22,   #幣別                                                                      
                     pmm42     LIKE    pmm_file.pmm42,   #匯率                                                                      
                     pmn07     LIKE    pmn_file.pmn07,   #采購單位                                                                  
                     pmn04     LIKE    pmn_file.pmn04,   #料件編號                                                                  
                     pmn041    LIKE    pmn_file.pmn041,  #品名                                                          
                     ima08     LIKE    ima_file.ima08,   #來源                                                                      
                     pmn33     LIKE    pmn_file.pmn33,   #交貨日                                                                    
                     pmn20     LIKE    pmn_file.pmn20,   #訂購量                                                                    
                     pmn20_m   LIKE    pmn_file.pmn44,   #訂購金額                                                       
                     ima02     LIKE    ima_file.ima02,   #品名規格                                                                  
                     pmn44     LIKE    pmn_file.pmn44,   #本幣單價                                                                  
                     pmn16     LIKE    type_file.chr10,  #目前狀況                                              
                     pmm18     LIKE    pmm_file.pmm18,   #確認碼                                                                    
                     pmmmksg   LIKE    pmm_file.pmmmksg, #簽核否                                                                    
                     pmn80     LIKE    pmn_file.pmn80,                                                                              
                     pmn82     LIKE    pmn_file.pmn82,                                                                              
                     pmn83     LIKE    pmn_file.pmn83,                                                                              
                     pmn85     LIKE    pmn_file.pmn85,                                                                              
                     pmn86     LIKE    pmn_file.pmn86,
                     pmn87     LIKE    pmn_file.pmn87,
                     pmn24     LIKE    pmn_file.pmn24,
                     pmn25     LIKE    pmn_file.pmn25                                                                               
                     END RECORD
    DEFINE l_str2         LIKE type_file.chr1000
    DEFINE l_ima021       LIKE ima_file.ima021
    DEFINE l_ima021_1     LIKE ima_file.ima021
    DEFINE l_ima906       LIKE ima_file.ima906                                                                                        
    DEFINE l_pmn85        STRING                                                                                                      
    DEFINE l_pmn82        STRING                                                                                                      
    DEFINE l_pmn20        STRING
    DEFINE t_azi03_1      LIKE azi_file.azi03
    DEFINE t_azi04_1      LIKE azi_file.azi04
    DEFINE t_azi07_1      LIKE azi_file.azi07   #No.FUN-870151
#No.FUN-840021 --Add--End--
 
     DEFINE l_i,l_cnt          LIKE type_file.num5    #No.FUN-580004  #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02    #NO.FUN-580004
     DEFINE l_pml87            LIKE pml_file.pml87,   #TQC-6C0136 
            l_pmn87            LIKE pmn_file.pmn87    #TQC-6C0136 
     DEFINE l_flag             LIKE type_file.chr1    #CHI-950035
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
 
#No.FUN-840021 --Add--Begin--
#--------------------------CR(2)--------------------------------#                                                                   
     CALL cl_del_data(l_table1)                                                                                                     
     #CALL cl_del_data(l_table2)   #CHI-950035
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                          
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                          
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ",        #No.FUN-870151 add ?                                                                               
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",   #CHI-950035
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "    #CHI-950035
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM                                                                           
     END IF
 
     #-----CHI-950035---------
     #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
     #            " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
     #            "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )   " #No.FUN-870151 add ?                                                                                          
     #PREPARE insert_prep1 FROM g_sql                                                                                                
     #IF STATUS THEN                                                                                                                 
     #   CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM                                                                          
     #END IF
     #-----END CHI-950035-----
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#------------------------CR(2)------------------------------------#
#No.FUN-840021 --Add--End--
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004------Begin----------
#     SELECT azi03,azi04 INTO g_azi03,g_azi04
#                        FROM azi_file
#                       WHERE azi01= g_aza.aza17
#No.CHI-6A0004------End-------------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET l_sql = l_sql clipped," AND pmkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET l_sql = l_sql clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET l_sql = l_sql clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
     #     END IF
    #LET l_sql = l_sql CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')   #MOD-C90195 mark
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')   #MOD-C90195 add
     #End:FUN-980030
 
     LET l_sql = " SELECT UNIQUE '','','',",
                 " pmk01,pmk03,pmk02,pmk09,pmk22,pmk42,",
                 " pml02,pml04,ima08,pml33,pml34,pml35,",   #No.TQC-640132
                 " pml20,pml20-pml21,'',pmc03,pml041,pml18,pml44,",
                 #" pml21,pml21*pml44,pmk04,pmk07,pmk12,pmn01",   #CHI-950035
                 " pml21,pml21*pml44,pmk04,pmk07,pmk12,''",   #CHI-950035
                 " FROM pmk_file,pml_file,pmn_file,",
                 " OUTER (pmc_file,ima_file)",
                 " WHERE pmk01 = pml01 AND pml01 = pmn24",
                 " AND pml02 = pmn25 AND pmk_file.pmk09 = pmc_file.pmc01",
                 " AND pml_file.pml04 = ima_file.ima01",
                 " AND pml16 NOT IN ('6','7','8','9') ", #No.B358
                 " AND ",tm.wc CLIPPED
 
     PREPARE r410_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r410_c1 CURSOR FOR r410_p1
     #IF cl_chk_act_auth() THEN
#    IF cl_prichk('$') THEN
#         LET tm.amt_sw = 'Y'
#    ELSE LET tm.amt_sw = 'N'
#    END IF
     #LET tm.amt_sw = 'N'  #TQC-6C0136 
     LET tm.amt_sw = 'Y'   #TQC-6C0136 
 
#No.FUN-840021 --Mark--Begin--
#    CALL cl_outnam('apmr410') RETURNING l_name
#    #MOD-540173 add
#    FOR g_i = 1 TO 3
#       CASE
#          WHEN tm.s[g_i,g_i]='1'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[20]
#          WHEN tm.s[g_i,g_i]='2'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[21]
#          WHEN tm.s[g_i,g_i]='3'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[22]
#          WHEN tm.s[g_i,g_i]='4'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[23]
#          WHEN tm.s[g_i,g_i]='5'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[24]
#          WHEN tm.s[g_i,g_i]='6'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[25]
#       END CASE
#    END FOR
#    #MOD-540173(end)
 
#No.FUN-580004  --start
#    IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
#           LET g_zaa[55].zaa06 = "Y"
#           LET g_zaa[61].zaa06 = "Y"
#           LET g_zaa[66].zaa06 = "N"
#           LET g_zaa[67].zaa06 = "N"
#    ELSE
#           LET g_zaa[66].zaa06 = "Y"
#           LET g_zaa[67].zaa06 = "Y"
#           LET g_zaa[55].zaa06 = "N"
#           LET g_zaa[61].zaa06 = "N"
#    END IF
#    IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
#           LET g_zaa[65].zaa06 = "N"
#    ELSE
#           LET g_zaa[65].zaa06 = "Y"
#    END IF
#    CALL cl_prt_pos_len()
#No.FUN-580004 --end
 
#    START REPORT r410_rep TO l_name
#No.FUN-840021 --Mark--End--
 
#No.FUN-840021 --Add--Begin--
     IF g_sma.sma116 MATCHES '[13]' THEN
        LET l_name = 'apmr410'
     ELSE
        IF g_sma115 = "Y" THEN
           LET l_name = 'apmr410_1'
        ELSE
           LET l_name = 'apmr410_2'
        END IF
     END IF
#No.FUN-840021 --Add--End--  
 
     LET g_pageno = 0
     FOREACH r410_c1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
#No.FUN-840021 --Mark--Begin-- 
#      FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pmk01
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmk04 USING 'YYYYMMDD'
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pmk07
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pmk12
#              WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pmk09
#              WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.pmn01
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      IF sr.order1 IS NULL THEN LET sr.order1 = ' ' END IF
#      IF sr.order2 IS NULL THEN LET sr.order2 = ' ' END IF
#      IF sr.order3 IS NULL THEN LET sr.order3 = ' ' END IF
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#No.FUN-840021 --Mark--End-- 
 
       IF tm.amt_sw = 'N' THEN
          LET sr.pml44    = 0
          LET sr.pml21_m  = 0
       END IF
      #TQC-6C0136  add--begin
       LET sr.pml20_um = sr.pml20_u * sr.pml44
       IF  g_sma.sma116 MATCHES '[13]' THEN
         LET l_pml87 = 0
         LET l_pmn87 = 0
         SELECT pml87,pmn87 INTO l_pml87,l_pmn87 FROM pml_file,pmn_file
          WHERE pmn24 = pml01 AND pmn25 = pml02
            AND pml01 = sr.pmk01  AND pml02 = sr.pml02
         IF SQLCA.sqlcode THEN
           LET l_pml87=0 
           LET l_pmn87=0 
         END IF
         LET sr.pml20_um = (l_pml87-l_pmn87) * sr.pml44
         LET sr.pml21_m = l_pmn87 * sr.pml44
       END IF
      #TQC-6C0136  add--end
 
#      OUTPUT TO REPORT r410_rep(sr.*)                                                       #FUN-840021--Mark
 
#No.FUN-840021 --Add--Begin--
      SELECT ima021                                                                                                                 
        INTO l_ima021                                                                                                               
        FROM ima_file                                                                                                               
       WHERE ima01=sr.pml04                                                                                                         
      IF SQLCA.sqlcode THEN                                                                                                         
          LET l_ima021 = NULL                                                                                                       
      END IF
 
     #SELECT azi03,azi04 INTO t_azi03,t_azi04                 #No.FUN-870151 
      SELECT azi03,azi04,azi07 INTO t_azi03,t_azi04,t_azi07   #No.FUN-870151                                                                 
        FROM azi_file  #幣別檔小數位數讀取                                                                              
       WHERE azi01= sr.pmk22
 
      DECLARE r410_c2 CURSOR FOR                                                                                                    
      SELECT pmn01,pmn02,pmm22,pmm42,pmn07,pmn04,pmn041,ima08,                                                                      
             #pmn33,pmn20,pmn20*pmn44,ima02,pmn44,pmn16,pmm18,pmmmksg,                                              
             pmn33,pmn20,pmn87*pmn44,ima02,pmn44,pmn16,pmm18,pmmmksg,                                               
             pmn80,pmn82,pmn83,pmn85,pmn86,pmn87,pmn24,pmn25                                                                     
        FROM pmm_file,pmn_file,                                                                                                     
       OUTER (pmc_file,ima_file)                                                                                                    
       WHERE pmn24 = sr.pmk01                                                                                                       
         AND pmn25 = sr.pml02                                                                                                       
         AND pmm_file.pmm09 = pmc_file.pmc01                                                                                                          
         AND pmn_file.pmn04 = ima_file.ima01                                                                                                          
         AND pmm01 = pmn01                                                                                                          
         AND pmm18 !='X'                                                                                                            
      LET l_flag = 0    #CHI-950035
      INITIALIZE sr1.* TO NULL   #CHI-950035
      FOREACH r410_c2 INTO sr1.*                                                                                                    
            IF SQLCA.sqlcode != 0 THEN                                                                                              
               CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660129                                                             
               EXIT FOREACH                                                                                                         
             END IF                                                                                                                 
             IF cl_null(sr1.pmn20_m) THEN LET sr1.pmn20_m = 0 END IF                                                                
             CALL s_pmmsta('pmm',sr1.pmn16[1,1],sr1.pmm18,sr1.pmmmksg)                                                              
                  RETURNING sr1.pmn16
           #SELECT azi03,azi04 INTO t_azi03_1,t_azi04_1                  #No.FUN-870151
            SELECT azi03,azi04,azi07 INTO t_azi03_1,t_azi04_1,t_azi07_1  #No.FUN-870151                                                                                                   
              FROM azi_file  #幣別檔小數位數讀取                                                                                          
            #WHERE azi01= sr.pmm22      #No.FUN-870151
             WHERE azi01= sr1.pmm22     #No.FUN-870151             
             IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","azi_file",sr1.pmm22,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129                                   
             END IF                                                                                                                 
             IF tm.amt_sw = 'N' THEN LET  sr1.pmn44   = 0 END IF                                                                    
             IF tm.amt_sw = 'N' THEN LET  sr1.pmn20_m = 0 END IF                                                                    
             SELECT ima021                                                                                                          
               INTO l_ima021_1                                                                                                        
               FROM ima_file                                                                                                        
              WHERE ima01=sr1.pmn04                                                                                                 
             IF SQLCA.sqlcode THEN                                                                                                  
                 LET l_ima021_1 = NULL                                                                                                
             END IF
 
      SELECT ima906 INTO l_ima906 FROM ima_file                                                                                     
                         WHERE ima01=sr1.pmn04                                                                                      
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85                                                                    
                LET l_str2 = l_pmn85 , sr1.pmn83 CLIPPED                                                                            
                IF cl_null(sr1.pmn85) OR sr1.pmn85 = 0 THEN                                                                         
                    CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82                                                                
                    LET l_str2 = l_pmn82, sr1.pmn80 CLIPPED                                                                         
                ELSE                                                                                                                
                   IF NOT cl_null(sr1.pmn82) AND sr1.pmn82 > 0 THEN                                                                 
                      CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82                                                              
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr1.pmn80 CLIPPED                                                    
                   END IF                                                                                                           
                END IF                                                                                                              
            WHEN "3"                                                                                                                
                IF NOT cl_null(sr1.pmn85) AND sr1.pmn85 > 0 THEN                                                                    
                    CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85                                                                
                    LET l_str2 = l_pmn85 , sr1.pmn83 CLIPPED                                                                        
                END IF
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF                                                                                                                        
      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076                                                                         
           #IF sr1.pmn80 <> sr1.pmn86 THEN   #NO.TQC-6B0137 mark                                                                    
            IF sr1.pmn07 <> sr1.pmn86 THEN   #NO.TQC-6B0137 mod                                                                     
               CALL cl_remove_zero(sr1.pmn20) RETURNING l_pmn20                                                                     
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr1.pmn07 CLIPPED,")"                                                        
            END IF                                                                                                                  
      END IF
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-840021 *** ##                                                   
           #-----CHI-950035---------
           #EXECUTE insert_prep1 USING                                                                                                
           #        sr1.pmn01,sr1.pmn02,sr1.pmm22,sr1.pmm42,sr1.pmn07,sr1.pmn04,sr1.pmn041,
           #        sr1.ima08,sr1.pmn33,sr1.pmn20,sr1.pmn20_m,sr1.pmn44,sr1.pmn16,sr1.pmn86,
           #        sr1.pmn87,l_ima021_1,l_str2,sr1.pmn24,sr1.pmn25,t_azi03_1,t_azi04_1
           #        ,t_azi07_1   #No.FUN-870151
           EXECUTE insert_prep USING                                                                                                
                   sr.pmk01,sr.pmk03,sr.pmk02,sr.pmk09,sr.pmk22,sr.pmk42,sr.pml02,
                   sr.pml04,sr.ima08,sr.pml33,sr.pml34,sr.pml35,sr.pml20,sr.pml20_u,
                   sr.pml20_um,sr.pmc03,sr.pml041,sr.pml18,sr.pml44,sr.pml21,sr.pml21_m,
                   sr.pmk04,sr.pmk07,sr.pmk12,sr.pmn01,l_ima021,t_azi03,t_azi04,
                   t_azi07,  
                   sr1.pmn01,sr1.pmn02,sr1.pmm22,sr1.pmm42,sr1.pmn07,sr1.pmn04,sr1.pmn041,
                   sr1.ima08,sr1.pmn33,sr1.pmn20,sr1.pmn20_m,sr1.pmn44,sr1.pmn16,sr1.pmn86,
                   sr1.pmn87,l_ima021_1,l_str2,sr1.pmn24,sr1.pmn25,t_azi03_1,t_azi04_1,
                   t_azi07_1 
           LET l_flag = 1   
           #-----END CHI-950035-----
          #------------------------------ CR (3) ------------------------------#
      END FOREACH 
 
#No.FUN-840021 --Add--End--
 
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-840021 *** ##                                                   
        IF l_flag = 0 THEN   #CHI-950035
           EXECUTE insert_prep USING                                                                                                
                   sr.pmk01,sr.pmk03,sr.pmk02,sr.pmk09,sr.pmk22,sr.pmk42,sr.pml02,
                   sr.pml04,sr.ima08,sr.pml33,sr.pml34,sr.pml35,sr.pml20,sr.pml20_u,
                   sr.pml20_um,sr.pmc03,sr.pml041,sr.pml18,sr.pml44,sr.pml21,sr.pml21_m,
                   sr.pmk04,sr.pmk07,sr.pmk12,sr.pmn01,l_ima021,t_azi03,t_azi04
                   ,t_azi07,  #No.FUN-870151
                   #-----CHI-950035---------
                   sr1.pmn01,sr1.pmn02,sr1.pmm22,sr1.pmm42,sr1.pmn07,sr1.pmn04,sr1.pmn041,
                   sr1.ima08,sr1.pmn33,sr1.pmn20,sr1.pmn20_m,sr1.pmn44,sr1.pmn16,sr1.pmn86,
                   sr1.pmn87,l_ima021_1,l_str2,sr1.pmn24,sr1.pmn25,t_azi03_1,t_azi04_1,
                   t_azi07_1 
                   #-----END CHI-950035-----
        END IF   #CHI-950035
          #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
#    FINISH REPORT r410_rep                                                                  #FUN-840021--Mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                             #FUN-840021--Mark
 
#No.FUN-840021 --Add--Begin--
#----------------------CR(3)------------------------------#                                                                         
     #-----CHI-950035---------
     #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                         
     #            "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED              #FUN-840110 Add DISTINCT                                                
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED                                                         
     #-----END CHI-950035-----
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'pmk01,pmk04,pmk07,pmk12,pmk09,pmn01')                                                                                    
             RETURNING tm.wc                                                                                                        
     END IF                                                                                                                         
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 g_azi03,";",g_azi04    #CHI-950035                                                                           
     CALL cl_prt_cs3('apmr410',l_name,g_sql,g_str)                                                                               
#----------------------CR(3)------------------------------#
#No.FUN-840021 --Add--End--
END FUNCTION
 
#No.FUN-840021 --Add--Begin--
#REPORT r410_rep(sr)
#  DEFINE l_ima021     LIKE ima_file.ima021  #FUN-4C0095
#  DEFINE l_last_sw    LIKE type_file.chr1,              #No.FUN-680136 VARCHAR(1)
#         sr         RECORD
#                    order1    LIKE    type_file.chr20,  #No.FUN-680136 VARCHAR(20)
#                    order2    LIKE    type_file.chr20,  #No.FUN-680136 VARCHAR(20)
#                    order3    LIKE    type_file.chr20,  #No.FUN-680136 VARCHAR(20)
#                    pmk01     LIKE    pmk_file.pmk01,   #請購單號
#                    pmk03     LIKE    pmk_file.pmk03,   #更動序號
#                    pmk02     LIKE    pmk_file.pmk02,   #性質
#                    pmk09     LIKE    pmk_file.pmk09,   #供應廠商
#                    pmk22     LIKE    pmk_file.pmk22,   #幣別
#                    pmk42     LIKE    pmk_file.pmk42,   #
#                    pml02     LIKE    pml_file.pml02,   #項次
#                    pml04     LIKE    pml_file.pml04,   #料件編號
#                    ima08     LIKE    ima_file.ima08,   #來源
#                    pml33     LIKE    pml_file.pml33,   #交貨日
#                    pml34     LIKE    pml_file.pml34,   #No.TQC-640132
#                    pml35     LIKE    pml_file.pml35,   #No.TQC-640132
#                    pml20     LIKE    pml_file.pml20,   #訂購量
#                    pml20_u   LIKE    pml_file.pml20,   #未交採購量
#                    pml20_um  LIKE    pml_file.pml44,   #MOD-530190  #未轉金額
#                    pmc03     LIKE    pmc_file.pmc03,   #廠商簡稱
#                    pml041    LIKE    pml_file.pml041,  #品名規格
#                    pml18     LIKE    pml_file.pml18,   #MRP需求日
#                    pml44     LIKE    pml_file.pml44,   #本幣單價
#                    pml21     LIKE    pml_file.pml21,   #己轉採購量
#                    pml21_m   LIKE    pml_file.pml44,   #MOD-530190#己轉金額
#                    pmk04     LIKE    pmk_file.pmk04,   #請購日期
#                    pmk07     LIKE    pmk_file.pmk07,   #請購單類別
#                    pmk12     LIKE    pmk_file.pmk12,   #請購員
#                    pmn01     LIKE    pmn_file.pmn01    #採購單號
#                    END RECORD,
#         sr1        RECORD
#                    pmn01     LIKE    pmn_file.pmn01,   #採購單號
#                    pmn02     LIKE    pmn_file.pmn02,   #採購項次
#                    pmm22     LIKE    pmm_file.pmm22,   #幣別
#                    pmm42     LIKE    pmm_file.pmm42,   #匯率
#                    pmn07     LIKE    pmn_file.pmn07,   #採購單位
#                    pmn04     LIKE    pmn_file.pmn04,   #料件編號
#                    pmn041    LIKE    pmn_file.pmn041,  #品名 #FUN-4C0095
#                    ima08     LIKE    ima_file.ima08,   #來源
#                    pmn33     LIKE    pmn_file.pmn33,   #交貨日
#                    pmn20     LIKE    pmn_file.pmn20,   #訂購量
#                    pmn20_m   LIKE    pmn_file.pmn44,   #MOD-530190#訂購金額
#                    ima02     LIKE    ima_file.ima02,   #品名規格
#                    pmn44     LIKE    pmn_file.pmn44,   #本幣單價
#                    pmn16     LIKE    type_file.chr10,  #目前狀況 #No.TQC-6A0079
#                    pmm18     LIKE    pmm_file.pmm18,   #確認碼
#                    pmmmksg   LIKE    pmm_file.pmmmksg, #簽核否
#No.FUN-580004 --start--
#                    pmn80     LIKE    pmn_file.pmn80,
#                    pmn82     LIKE    pmn_file.pmn82,
#                    pmn83     LIKE    pmn_file.pmn83,
#                    pmn85     LIKE    pmn_file.pmn85,
#                    pmn86     LIKE    pmn_file.pmn86,
#                    pmn87     LIKE    pmn_file.pmn87
#                    END RECORD
# DEFINE l_ima906       LIKE ima_file.ima906
# DEFINE l_str2         LIKE type_file.chr1000        #No.FUN-680136 VARCHAR(100)
# DEFINE l_pmn85        STRING
# DEFINE l_pmn82        STRING
# DEFINE l_pmn20        STRING
#No.FUN-580004 --end--
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#     ORDER BY sr.pmk01,sr.order1,sr.order2,sr.order3,sr.pml02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<' ,"/pageno"
#     #PRINT g_head CLIPPED,pageno_total #TQC-5B0037 mark
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT g_head CLIPPED,pageno_total  #TQC-5B0037 add
#    #MOD-540173 MARK 移到其它地方給定g_x[19]的值
#    #FOR g_i = 1 TO 3
#    #   CASE
#    #      WHEN tm.s[g_i,g_i]='1'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[20]
#    #      WHEN tm.s[g_i,g_i]='2'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[21]
#    #      WHEN tm.s[g_i,g_i]='3'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[22]
#    #      WHEN tm.s[g_i,g_i]='4'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[23]
#    #      WHEN tm.s[g_i,g_i]='5'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[24]
#    #      WHEN tm.s[g_i,g_i]='6'  LET g_x[19]=g_x[19] CLIPPED,' ',g_x[25]
#    #   END CASE
#    #END FOR
#     PRINT g_x[19]
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#           g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#           g_x[51],g_x[52],g_x[53],g_x[54],g_x[65],g_x[55],g_x[66],  #No.FUN-580004
#           g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],g_x[61],g_x[67],  #No.FUN-580004
#           g_x[62],g_x[63],g_x[64],g_x[68],g_x[69]  #No.TQC-640132
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.pml02
#     SELECT ima021
#       INTO l_ima021
#       FROM ima_file
#      WHERE ima01=sr.pml04
#     IF SQLCA.sqlcode THEN
#         LET l_ima021 = NULL
#     END IF
#     PRINT COLUMN g_c[31],sr.pmk01,
#           COLUMN g_c[32],sr.pmk03 USING '########',
#           COLUMN g_c[33],sr.pmk02,
#           COLUMN g_c[34],sr.pmk09,
#           COLUMN g_c[35],sr.pmc03,
#           COLUMN g_c[36],sr.pmk22,
#           COLUMN g_c[37],cl_numfor(sr.pmk42,37,4),
#           COLUMN g_c[38],sr.pml02 USING "########",
#           COLUMN g_c[39],sr.pml04 CLIPPED, #FUN-5B0014 [1,20], #No.FUN-580004
#           COLUMN g_c[40],sr.pml041,
#           COLUMN g_c[41],l_ima021,
#           COLUMN g_c[42],sr.ima08,
#           COLUMN g_c[43],sr.pml33,
#           COLUMN g_c[68],sr.pml34,  #No.TQC-640132
#           COLUMN g_c[69],sr.pml35,  #No.TQC-640132
#           COLUMN g_c[44],sr.pml18,
#           COLUMN g_c[45],cl_numfor(sr.pml20,45,3),
#           COLUMN g_c[46],cl_numfor(sr.pml44,46,t_azi03),  #No.CHI-6A0004
#           COLUMN g_c[47],cl_numfor(sr.pml20_u,47,3),
#           COLUMN g_c[48],cl_numfor(sr.pml21,48,3),
#           COLUMN g_c[49],cl_numfor(sr.pml20_um,49,t_azi04) CLIPPED,   #No.CHI-6A0004
#           COLUMN g_c[50],cl_numfor(sr.pml21_m,50,t_azi04) CLIPPED;    #No.CHI-6A0004
#  ON EVERY ROW
#     DECLARE r410_c2 CURSOR FOR
#     SELECT pmn01,pmn02,pmm22,pmm42,pmn07,pmn04,pmn041,ima08,
#            #pmn33,pmn20,pmn20*pmn44,ima02,pmn44,pmn16,pmm18,pmmmksg,   #TQC-6C0136 
#            pmn33,pmn20,pmn87*pmn44,ima02,pmn44,pmn16,pmm18,pmmmksg,    #TQC-6C0136 
#            pmn80,pmn82,pmn83,pmn85,pmn86,pmn87  #No.FUN-580004
#       FROM pmm_file,pmn_file,
#      OUTER (pmc_file,ima_file)
#      WHERE pmn24 = sr.pmk01
#        AND pmn25 = sr.pml02
#        AND pmm_file.pmm09 = pmc_file.pmc01
#        AND pmn_file.pmn04 = ima_file.ima01
#        AND pmm01 = pmn01
#        AND pmm18 !='X'
#     FOREACH r410_c2 INTO sr1.*
#           IF SQLCA.sqlcode != 0 THEN
#              CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660129
#              EXIT FOREACH
#            END IF
#            IF cl_null(sr1.pmn20_m) THEN LET sr1.pmn20_m = 0 END IF
#            CALL s_pmmsta('pmm',sr1.pmn16[1,1],sr1.pmm18,sr1.pmmmksg)
#                 RETURNING sr1.pmn16
#            SELECT azi03,azi04 INTO t_azi03,t_azi04     #No.CHI-6A0004
#                   FROM azi_file  #幣別檔小數位數讀取
#                   WHERE azi01= sr1.pmm22
#            IF SQLCA.sqlcode THEN
#               CALL cl_err(sr.pmk01,SQLCA.sqlcode,0)   #No.FUN-660129
#               CALL cl_err3("sel","azi_file",sr1.pmm22,"",SQLCA.sqlcode,"","",0)  #No.FUN-660129
#            END IF
#            IF tm.amt_sw = 'N' THEN LET  sr1.pmn44   = 0 END IF
#            IF tm.amt_sw = 'N' THEN LET  sr1.pmn20_m = 0 END IF
#            SELECT ima021
#              INTO l_ima021
#              FROM ima_file
#             WHERE ima01=sr1.pmn04
#            IF SQLCA.sqlcode THEN
#                LET l_ima021 = NULL
#            END IF
 
 
#No.FUN-580004 --start--
#     SELECT ima906 INTO l_ima906 FROM ima_file
#                        WHERE ima01=sr1.pmn04
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85
#               LET l_str2 = l_pmn85 , sr1.pmn83 CLIPPED
#               IF cl_null(sr1.pmn85) OR sr1.pmn85 = 0 THEN
#                   CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82
#                   LET l_str2 = l_pmn82, sr1.pmn80 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr1.pmn82) AND sr1.pmn82 > 0 THEN
#                     CALL cl_remove_zero(sr1.pmn82) RETURNING l_pmn82
#                     LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr1.pmn80 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr1.pmn85) AND sr1.pmn85 > 0 THEN
#                   CALL cl_remove_zero(sr1.pmn85) RETURNING l_pmn85
#                   LET l_str2 = l_pmn85 , sr1.pmn83 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
#     IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
#          #IF sr1.pmn80 <> sr1.pmn86 THEN   #NO.TQC-6B0137 mark
#           IF sr1.pmn07 <> sr1.pmn86 THEN   #NO.TQC-6B0137 mod
#              CALL cl_remove_zero(sr1.pmn20) RETURNING l_pmn20
#              LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr1.pmn07 CLIPPED,")"
#           END IF
#     END IF
 
#            PRINT COLUMN g_c[51],sr1.pmn01,
#                  COLUMN g_c[52],sr1.pmn02 USING '########',
#                  COLUMN g_c[53],sr1.pmm22,
#                  COLUMN g_c[54],cl_numfor(sr1.pmm42,54,4),
#                  COLUMN g_c[65],l_str2 CLIPPED,  #No.FUN-580004
#                  COLUMN g_c[55],sr1.pmn07,
#                  COLUMN g_c[66],sr1.pmn86,  #No.FUN-580004
#                  COLUMN g_c[56],sr1.pmn04 CLIPPED, #FUN-5B0014 [1,20],  #No.FUN-580004
#                  COLUMN g_c[57],sr1.pmn041,
#                  COLUMN g_c[58],l_ima021,
#                  COLUMN g_c[59],sr1.ima08,
#                  COLUMN g_c[60],sr1.pmn33,
#                  COLUMN g_c[61],cl_numfor(sr1.pmn20,61,3),
#                  COLUMN g_c[67],cl_numfor(sr1.pmn87,67,3),  #No.FUN-580004
#                  COLUMN g_c[62],cl_numfor(sr1.pmn44,62,t_azi03) CLIPPED,    #No.CHI-6A0004
#                  COLUMN g_c[63],cl_numfor(sr1.pmn20_m,63,t_azi04) CLIPPED,  #No.CHI-6A0004
#                  COLUMN g_c[64],sr1.pmn16
#No.FUN-580004 --end--
#     END FOREACH
 
#  AFTER GROUP OF sr.pml02
#     SKIP 1 LINE
 
#  ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN PRINT g_dash
#          #  IF tm.wc[001,120] > ' ' THEN			# for 132
#	   #     PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#          #  IF tm.wc[121,240] > ' ' THEN
#	   #     PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#          #  IF tm.wc[241,300] > ' ' THEN
#	   #	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#          #TQC-630166
#           CALL cl_prt_pos_wc(tm.wc)
#     END IF
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED #TQC-5B0140
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0140
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-840021 --Add--End-- 
#Patch....NO.TQC-610036 <001> #
