# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmr920.4gl
# Descriptions...: 收料單列印
# Input parameter:
# Return code....:
# Date & Author..: 91/10/14 By MAY
# Modify.........: 92/12/05 By Apple 大翻修
# Modify.........: 93/11/03 By Apple 加委外代買
#                  By Kitty 增加可選是否列印驗收人員及分機代碼,且改名為收料單
# Modify.........: NO.FUN-4A0033 04/10/04 By Echo 收貨單號,採購單號,廠商編號要開窗
# Modify.........: No.FUN-550018 05/05/09 By ice 發票號碼加大到16位
# Modify.........: No.FUN-550060  05/05/30 By yoyo單據編號格式放大
# Modify.........: No.FUN-550114 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580004 05/08/03 By day 報表轉xml
# Modify.........: No.FUN-5A0139 05/10/21 By Pengu 調整報表的格式
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680136 06/09/05 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.MOD-6C0145 06/12/22 By rainy 計價數量印出小數位數依單位抓aooi101
# Modify.........: No.FUN-710091 07/03/01 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-750046 07/06/04 By Sarah 畫面新增選項"列印料件Barcode"
# Modify.........: No.TQC-780048 07/08/15 By Carol 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-870053 08/07/09 By baofei 增加子報表-列印批序號明細
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B40067 11/04/11 By yinhy “廠商編號”欄位開窗第一頁資料全選，確定運行此作業后，報錯【prepare: 找到一個未成對的引號】
# Modify.........: No.TQC-B60289 11/06/22 By suncx    wc定義類型錯誤   
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BA0053 11/10/31 By Sakura 加入取jit收貨資料
# Modify.........: No:FUN-BA0078 11/11/03 By xumm 整合單據列印EF簽核
# Modify.........: No.MOD-BB0124 12/01/05 By Vampire 勾選印出批序號資料呈現錯誤
# Modify.........: No:TQC-BB0199 12/01/06 By destiny apmt110调用报错
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片调整 
# Modify.........: No.MOD-C50039 12/05/08 By Elise 當項次1的批序號資料比項次2多時,項次2的批序號資料會殘留項次2的資料
# Modify.........: No.MOD-CC0032 13/01/31 By Elise 品名規格直接抓收貨料件的品名規格rvb051
# Modify.........: No.DEV-D30027 13/03/18 By TSD.JIE 與M-Barcode整合(aza131)='Y',列印單號條碼

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-580004-begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5   	#No.FUN-680136  SMALLINT
END GLOBALS
#No.FUN-580004-end
 
  DEFINE tm  RECORD				# Print condition RECORD
               #wc      LIKE type_file.chr1000,	# Where condition 	        #No.FUN-680136 VARCHAR(500)
                wc      STRING,  #TQC-B60289
                a       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1) 
                c       LIKE type_file.chr1,    #No.FUN-750046 add    # 是否列印料件Barcode
                b       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1) 
                d       LIKE type_file.chr1,    #No.FUN-870053  #是否列印批序號明細
                s       LIKE type_file.chr3,   	#No.FUN-680136 VARCHAR(3) 
                more	LIKE type_file.chr1   	# Input more condition(Y/N) 	#No.FUN-680136 VARCHAR(1) 
             END RECORD
 
  DEFINE  g_i           LIKE type_file.num5     #count/index for any purpose    #No.FUN-680136 SMALLINT
  DEFINE  g_sma115      LIKE sma_file.sma115    #No.FUN-580004
  DEFINE  g_sma116      LIKE sma_file.sma116    #No.FUN-580004
#No.FUN-710091  --begin
  DEFINE  l_table       STRING
  DEFINE  l_table1      STRING   #No.FUN-870053
  DEFINE  g_sql         STRING
  DEFINE  g_str         STRING
#No.FUN-710091  --end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function

   #TQC-BB0199--begin
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.c  = ARG_VAL(9)   #FUN-750046 add
   LET tm.b  = ARG_VAL(10)  #No.FUN-870053
   LET tm.d  = ARG_VAL(11)
   LET tm.s  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #TQC-BB0199--end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #TQC-BB0199--begin 
#  LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
#  LET g_towhom = ARG_VAL(2)
#  LET g_rlang = ARG_VAL(3)
#  LET g_bgjob = ARG_VAL(4)
#  LET g_prtway = ARG_VAL(5)
#  LET g_copies = ARG_VAL(6)
#  LET tm.wc = ARG_VAL(7)
#  LET tm.a  = ARG_VAL(8)
#  LET tm.c  = ARG_VAL(9)   #FUN-750046 add
#  LET tm.b  = ARG_VAL(10)  #No.FUN-870053 
#  LET tm.d  = ARG_VAL(11)
#  LET tm.s  = ARG_VAL(12)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(13)
#  LET g_rep_clas = ARG_VAL(14)
#  LET g_template = ARG_VAL(15)
#  LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #TQC-BB0199--end
   #No.FUN-710091  --begin
   LET g_sql = "order1.type_file.chr20,",
               "order2.type_file.chr20,",
               "order3.type_file.chr20,",
               "rva01.rva_file.rva01,",
               "rva02.rva_file.rva02,",
               "rva04.rva_file.rva04,",
               "rva05.rva_file.rva05,",
               "rva06.rva_file.rva06,",
               "rva08.rva_file.rva08,",
               "rva09.rva_file.rva09,",
               "rva10.rva_file.rva10,",
               "rvb39.rvb_file.rvb39,",
               "rva21.rva_file.rva21,",
               "rvaconf.rva_file.rvaconf,",
               "rvb02.rvb_file.rvb02,",
               "rvb03.rvb_file.rvb03,",
               "rvb04.rvb_file.rvb04,",
               "rvb05.rvb_file.rvb05,",
               "rvb07.rvb_file.rvb07,",
               "rvb22.rvb_file.rvb22,",
               "rvb34.rvb_file.rvb34,",
               "rvb35.rvb_file.rvb35,",
               "rvb36.rvb_file.rvb36,",
               "rvb37.rvb_file.rvb37,",
               "rvb38.rvb_file.rvb38,",
               "pmm20.pmm_file.pmm20,",
               "pma02.pma_file.pma02,",
               "pmn041.pmn_file.pmn041,",
               "ima021.ima_file.ima021,",
               "pmn07.pmn_file.pmn07,", 
               "pmn63.pmn_file.pmn63,", 
               "rvb80.rvb_file.rvb80,",
               "rvb82.rvb_file.rvb82,",
               "rvb83.rvb_file.rvb83,",
               "rvb85.rvb_file.rvb85,",
               "gfe03.gfe_file.gfe03,",
               "str2.type_file.chr1000,",
               "sma115.sma_file.sma115,",
#               "pmc03.pmc_file.pmc03"   #No.FUN-870053 
               "pmc03.pmc_file.pmc03,",  #No.FUN-870053    
               "flag.type_file.num5,",          #No.FUN-870053         #No.FUN-BA0078 add 2,
               "sign_type.type_file.chr1,",     #簽核方式              #No.FUN-BA0078 add
               "sign_img.type_file.blob,",      #簽核圖檔              #No.FUN-BA0078 add
               "sign_show.type_file.chr1,",       #是否顯示簽核資料(Y/N) #No.FUN-BA0078 add
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
   #No.FUN-710091  --end 
#No.FUN-870053---begin
   LET l_table = cl_prt_temptable('apmr920',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                           
               "rvbs02.rvbs_file.rvbs02,",                                                                                             
               "rvbs103.rvbs_file.rvbs03,",
               "rvbs104.rvbs_file.rvbs04,",
               "rvbs106.rvbs_file.rvbs06,",
               "rvbs021.rvbs_file.rvbs021,",
               "rvbs203.rvbs_file.rvbs03,",                                                                                          
               "rvbs204.rvbs_file.rvbs04,",                                                                                          
               "rvbs206.rvbs_file.rvbs06,",     
               "pmn041.pmn_file.pmn041,",
               "ima021.ima_file.ima021,",
               "pmn07.pmn_file.pmn07,",
               "img09.img_file.img09,",
               "rvb07.rvb_file.rvb07"
   LET l_table1 = cl_prt_temptable('apmr9201',g_sql) CLIPPED                                                                          
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF  
#No.FUN-870053---end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r920_tm(0,0)		# Input print condition
      ELSE CALL apmr920()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r920_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r920_w AT p_row,p_col WITH FORM "apm/42f/apmr920"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a='N'
   LET tm.c='N'   #FUN-750046 add
   LET tm.b='3'
   LET tm.d='N'   #No.FUN-870053 
   LET tm.s='123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rva01,rvb04,rva05,rva06
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
       #### No.FUN-4A0033
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(rva01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_rvall03"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva01
                NEXT FIELD rva01
 
              WHEN INFIELD(rvb04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmm1"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rvb04
                NEXT FIELD rvb04
 
              WHEN INFIELD(rva05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_pmc"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO rva05
                NEXT FIELD rva05
           END CASE
      ### END  No.FUN-4A00333333
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r920_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.a,tm.c,tm.b,tm.d,tm2.s1,tm2.s2,tm2.s3,tm.more   #FUN-750046 add tm.c #No.FUN-870053 add tm.d
           WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]" OR cl_null(tm.a)
            THEN NEXT FIELD a
         END IF
      #str FUN-750046 add
      AFTER FIELD c   #列印料件Barcode
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)
            THEN NEXT FIELD c
         END IF
      #end FUN-870053 add
      AFTER FIELD d   #列印批序號明細                                                                                              
         IF tm.d NOT MATCHES "[YN]" OR cl_null(tm.d)                                                                                
            THEN NEXT FIELD d                                                                                                       
         END IF                                                                                                                     
      #end FUN-870053 add
      AFTER FIELD b
         IF tm.b NOT MATCHES "[123]" OR (cl_null(tm.b))
            THEN NEXT FIELD b
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
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
      #UI
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
      LET INT_FLAG = 0 CLOSE WINDOW r920_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr920'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr920','9031',1)
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
                         " '",tm.c CLIPPED,"'",                 #FUN-750046 add
                         " '",tm.b CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",                 #No.FUN-870053
                         " '",tm.s CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr920',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r920_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr920()
   ERROR ""
END WHILE
   CLOSE WINDOW r920_w
END FUNCTION
 
FUNCTION apmr920()
   DEFINE l_name	LIKE type_file.chr20, 	      # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          #l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)  
          l_sql         STRING,                       # No.TQC-B40067	
          l_chr		LIKE type_file.chr1,          # No.FUN-680136 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,       # No.FUN-680136 VARCHAR(40)
          l_order       ARRAY[4] OF LIKE type_file.chr20,    	   #No.FUN-680136 VARCHAR(20) 
          sr               RECORD order1 LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20) 
                                  order2 LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20) 
                                  order3 LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20) 
                                  rva01 LIKE rva_file.rva01,	# 單號
                                  rva02 LIKE rva_file.rva02,	# 採購單號
                                  rva04 LIKE rva_file.rva04,    # L/C收貨
                                  rva05 LIKE rva_file.rva05,    # 供應廠商
                                  rva06 LIKE rva_file.rva06,    # 收貨日期
                                  rva08 LIKE rva_file.rva08,    # 進口報單
                                  rva09 LIKE rva_file.rva09,    # 進口號碼
                                  rva10 LIKE rva_file.rva10,    # 採購性質
                                 #rva20 LIKE rva_file.rva20,    #
                                  rvb39 LIKE rvb_file.rvb39,    # no.7143
                                  rva21 LIKE rva_file.rva21,    # 進口日期
                                  rvaconf LIKE rva_file.rvaconf,#
                                  rvb02 LIKE rvb_file.rvb02,	# 收貨單項次
                                  rvb03 LIKE rvb_file.rvb03,	# 採購單項次
                                  rvb04 LIKE rvb_file.rvb04,	# 採購單
                                  rvb05 LIKE rvb_file.rvb05,	# 料件編號
                                  rvb07 LIKE rvb_file.rvb07,	# 實數數量
                                  rvb22 LIKE rvb_file.rvb22,	# 發票號碼
                                  rvb34 LIKE rvb_file.rvb34,	# 工單編號
                                  rvb35 LIKE rvb_file.rvb35,	# 樣品否
                                  rvb36 LIKE rvb_file.rvb36,	# Ware
                                  rvb37 LIKE rvb_file.rvb37,	# Loc
                                  rvb38 LIKE rvb_file.rvb38,	# Loc
                                  pmm20 LIKE pmm_file.pmm20,
                                  pma02 LIKE pma_file.pma02,
                                  pmn041 LIKE pmn_file.pmn041,  # 品名規格
                                  ima021 LIKE ima_file.ima021,  # 品名規格
                                  pmn07 LIKE pmn_file.pmn07,    # 單位
                                  pmn63 LIKE pmn_file.pmn63,     # 急料
                                  #No.FUN-580004-begin
                                  rvb80 LIKE rvb_file.rvb80,
                                  rvb82 LIKE rvb_file.rvb82,
                                  rvb83 LIKE rvb_file.rvb83,
                                  rvb85 LIKE rvb_file.rvb85
                                  #No.FUN-580004-end
                        END RECORD
#No.FUN-870053---begin
     DEFINE       l_rvbs         RECORD   
                                  rvbs03   LIKE  rvbs_file.rvbs03,
                                  rvbs04   LIKE  rvbs_file.rvbs04,
                                  rvbs06   LIKE  rvbs_file.rvbs06,
                                  rvbs021  LIKE  rvbs_file.rvbs021       
                                  END RECORD
     DEFINE        l_img09     LIKE img_file.img09
     DEFINE   rvbs1 DYNAMIC ARRAY OF RECORD
              rvbs03 LIKE rvbs_file.rvbs03,
              rvbs04 LIKE rvbs_file.rvbs04,
              rvbs06 LIKE rvbs_file.rvbs06
              END RECORD
     DEFINE   rvbs2 DYNAMIC ARRAY OF RECORD 
              rvbs03 LIKE rvbs_file.rvbs03,
              rvbs04 LIKE rvbs_file.rvbs04,
              rvbs06 LIKE rvbs_file.rvbs06
              END RECORD
     DEFINE   m,i,j,k  LIKE type_file.num10         
     DEFINE        flag          LIKE type_file.num5    
#No.FUN-870053---end
     DEFINE l_i,l_cnt          LIKE type_file.num5      #No.FUN-580004        #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580004
     #No.FUN-710091  --begin
     DEFINE l_gfe03            LIKE gfe_file.gfe03      #No.FUN-710091 
     DEFINE l_str2             LIKE type_file.chr1000 
     DEFINE l_ima906           LIKE ima_file.ima906
     DEFINE l_rvb85            LIKE rvb_file.rvb85
     DEFINE l_rvb82            LIKE rvb_file.rvb82
     DEFINE l_pmc03            LIKE pmc_file.pmc03
     #No.FUN-710091  --end  
#TQC-C10039--MOD--STR
###No.FUN-BA0078 START###
     DEFINE   l_img_blob     LIKE type_file.blob
#     DEFINE   l_ii           INTEGER
#     DEFINE   l_key          RECORD                  #主鍵
#                 v1          LIKE rva_file.rva01
#                 END RECORD
###No.FUN-BA0078 END###
#TQC-C10039--MOD--END-- 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  #No.FUN-580004
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
     #End:FUN-980030
     #No.FUN-710091   --begin
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1) #No.FUN-870053
     LOCATE l_img_blob IN MEMORY #blob初始化  #No.FUN-BA0078 add
#    LET l_sql = "INSERT INTO ds_report.",l_table CLIPPED," VALUES(?,?,?,?,?,",   #TQC-780048 mark
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780048 modify
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",  #TQC-780048 modify
                 "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"     #No.FUN-BA0078 add 3?  #TQC-C10039 add 1?
     PREPARE insert_prep FROM l_sql
     IF STATUS THEN 
        CALL cl_err("insert_prep:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM 
     END IF
     #No.FUN-710091   --end  
#No.FUN-870053---begin
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                       
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"           
     PREPARE insert_prep1 FROM l_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM                                                                           
     END IF 
#No.FUN-870053---end
     LET l_sql = "SELECT '','','',",
                 "rva01, rva02, rva04, rva05, rva06, rva08, rva09, rva10,",
                #"rva20, rva21, rvaconf, rvb02, rvb03, rvb04, rvb05,",
                 "rvb39, rva21, rvaconf, rvb02, rvb03, rvb04, rvb05,", #no.7143
                 "rvb07, rvb22,",
                 "rvb34, rvb35, rvb36, rvb37, rvb38, ",
                 "pmm20, pma02, rvb051, ima021, pmn07 , pmn63,", #MOD-CC0032 add
                #"pmm20, pma02, pmn041, ima021, pmn07 , pmn63,", #MOD-CC0032 mark
                 " rvb80,rvb82,rvb83,rvb85 ",  #No.FUN-580004
          " FROM rva_file, rvb_file LEFT OUTER JOIN ima_file ON rvb05=ima01 ", #MOD-CC0032 add
          " LEFT OUTER JOIN pmn_file ON rvb04 = pmn01 AND rvb03 = pmn02 ",     #MOD-CC0032 add
         #" FROM rva_file, rvb_file LEFT OUTER JOIN (pmn_file ",                            #MOD-CC0032 mark 
	 #" LEFT OUTER JOIN ima_file ON pmn04=ima01) ON rvb04 = pmn01 AND rvb03 = pmn02 ",  #MOD-CC0032 mark
	  " LEFT OUTER JOIN (pmm_file LEFT OUTER JOIN pma_file ON pmm20=pma01) ",
	  " ON rvb04 = pmm01 ",
          #" WHERE rva01 = rvb01 AND rvaconf !='X' AND ",tm.wc CLIPPED #No.FUN-BA0053 mark
           " WHERE rva01 = rvb01 AND rvaconf !='X'", #No.FUN-BA0053 add 
           " AND rva00 ='1' ",                       #No.FUN-BA0053 add
           " AND ",tm.wc CLIPPED                     #No.FUN-BA0053 add
     IF tm.a ='N' THEN
        LET l_sql = l_sql clipped," AND rvb19 ='1' "
     END IF
     IF tm.b ='1' THEN
        LET l_sql = l_sql clipped," AND rvaconf ='Y' "
     END IF
     IF tm.b ='2' THEN
        LET l_sql = l_sql clipped," AND rvaconf ='N' "
     END IF
     #LET l_sql = l_sql CLIPPED, "  ORDER BY rva01,rvb02" #No.FUN-710091 #No.FUN-BA0053 mark

     #No.FUN-BA0053---Begin---add
     LET l_sql = l_sql,
                 " UNION ",
                 "SELECT '','','',",
                 "rva01, rva02, rva04, rva05, rva06, rva08, rva09, rva10,",
                 "rvb39, rva21, rvaconf, rvb02, rvb03, rvb04, rvb05,", 
                 "rvb07, rvb22,",
                 "rvb34, rvb35, rvb36, rvb37, rvb38, ",
                 "rva111, pma02, rvb051, ima021, rvb90 , '',",
                 " rvb80,rvb82,rvb83,rvb85 ",
                 " FROM rva_file",
                 " LEFT OUTER JOIN pma_file ON rva_file.rva111 = pma_file.pma01 ",
                 " ,rvb_file",
                 " LEFT OUTER JOIN ima_file ON rvb_file.rvb05 = ima_file.ima01 ",
                 " WHERE rvaconf !='X' ",
                 " AND rva_file.rva01 = rvb_file.rvb01 ",
                 " AND rva00 ='2' ",
                 " AND ",tm.wc CLIPPED
     IF tm.a ='N' THEN
        LET l_sql = l_sql clipped," AND rvb19 ='1' "
     END IF
     IF tm.b ='1' THEN
        LET l_sql = l_sql clipped," AND rvaconf ='Y' "
     END IF      
     IF tm.b ='2' THEN
        LET l_sql = l_sql clipped," AND rvaconf ='N' "
     END IF
     LET l_sql = l_sql CLIPPED, "  ORDER BY rva01,rvb02"
     #No.FUN-BA0053---End-----add     
     PREPARE r920_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r920_cs1 CURSOR FOR r920_prepare1
#TQC-C10039--mark--str--
###No.FUN-BA0078 START ###
#    #單據key值
#    LET l_sql = "SELECT rva01",
#                " FROM rva_file, rvb_file LEFT OUTER JOIN (pmn_file ",
#                " LEFT OUTER JOIN ima_file ON pmn_file.pmn04=ima_file.ima01) ON rvb_file.rvb04 = pmn_file.pmn01 AND rvb_file.rvb03 = pmn_file.pmn02 ",
#                " LEFT OUTER JOIN (pmm_file LEFT OUTER JOIN pma_file ON pmm_file.pmm20=pma_file.pma01) ",
#                " ON rvb_file.rvb04 = pmm_file.pmm01 ",
#                " WHERE rva_file.rva01 = rvb_file.rvb01 AND rvaconf !='X' AND ",tm.wc CLIPPED
#    IF tm.a ='N' THEN
#       LET l_sql = l_sql clipped," AND rvb19 ='1' "
#    END IF
#    IF tm.b ='1' THEN
#       LET l_sql = l_sql clipped," AND rvaconf ='Y' "
#    END IF
#    IF tm.b ='2' THEN
#       LET l_sql = l_sql clipped," AND rvaconf ='N' "
#    END IF
#    LET l_sql = l_sql CLIPPED, "  ORDER BY rva01"
#    PREPARE r920_pr1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM

#    END IF
#    DECLARE r920_cs2 CURSOR FOR r920_pr1
###No.FUN-BA0078 END ###
#TQC-C10039--mark--end--
#No.FUN-710091  --begin mark
#    CALL cl_outnam('apmr920') RETURNING l_name  
#No.FUN-580004-begin
#  #----No.FUN-5A0139 begin
#    IF g_sma115 = "Y"  THEN  #是否顯示單位注解
#           LET g_zaa[54].zaa06 = "N"
#    ELSE
#           LET g_zaa[54].zaa06 = "Y"
#    END IF
#  #----end
#    CALL cl_prt_pos_len()
#No.FUN-580004-end
#    START REPORT r920_rep TO l_name
#No.FUN-710091  --end  mark
 
     LET g_pageno = 0
     FOREACH r920_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.rva01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.rvb04
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.rva05
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.rva06 USING 'YYYYMMDD'
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
      SELECT gfe03 INTO l_gfe03 FROM gfe_file
       WHERE gfe01 = sr.pmn07
      IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
        LET l_gfe03 = 0
      END IF
       SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01=sr.rvb05
#No.FUN-870053---begin
       LET flag = 0 
        SELECT img09 INTO l_img09  FROM img_file WHERE img01 = sr.rvb05                                                                           
               AND img02 = sr.rvb36 AND img03 = sr.rvb37                                                                            
               AND img04 = sr.rvb38  
    DECLARE r920_d  CURSOR  FOR
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file
                  WHERE rvbs01 = sr.rva01 AND rvbs02 = sr.rvb02
                    AND rvbs00<>'aqct110'         #MOD-BB0124 add
                  ORDER BY  rvbs04
    LET m = 0 LET i=0 LET j=0
    FOREACH  r920_d INTO l_rvbs.*
      LET flag = 1 
      LET m=m+1
      IF (m mod 2) = 1  THEN
         LET i=i+1
         INITIALIZE rvbs1[i].* TO NULL
         LET rvbs1[i].rvbs03 = l_rvbs.rvbs03
         LET rvbs1[i].rvbs04 = l_rvbs.rvbs04
         LET rvbs1[i].rvbs06 = l_rvbs.rvbs06
      ELSE 
         LET j=j+1
         INITIALIZE rvbs2[j].* TO NULL 
         LET rvbs2[j].rvbs03 = l_rvbs.rvbs03                                                                                        
         LET rvbs2[j].rvbs04 = l_rvbs.rvbs04                                                                                        
         LET rvbs2[j].rvbs06 = l_rvbs.rvbs06     
      END IF 
    END FOREACH 
      IF i>j THEN LET k=i ELSE LET k=j END IF
      FOR i=1 TO k      
         EXECUTE insert_prep1 USING  sr.rva01,sr.rvb02,rvbs1[i].rvbs03,
                                     rvbs1[i].rvbs04,rvbs1[i].rvbs06,l_rvbs.rvbs021,
                                     rvbs2[i].rvbs03,rvbs2[i].rvbs04,rvbs2[i].rvbs06,
                                     sr.pmn041,sr.ima021,sr.pmn07,l_img09,sr.rvb07
         INITIALIZE rvbs1[i].* TO NULL  #MOD-C50039 add
         INITIALIZE rvbs2[i].* TO NULL  #MOD-C50039 add
      END FOR 
#No.FUN-870053---end
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906
             WHEN "2"
                 CALL cl_remove_zero(sr.rvb85) RETURNING l_rvb85
                 LET l_str2 = l_rvb85 , sr.rvb83  CLIPPED
                 IF cl_null(sr.rvb85) OR sr.rvb85  = 0 THEN
                     CALL cl_remove_zero(sr.rvb82) RETURNING l_rvb82
                     LET l_str2 = l_rvb82,sr.rvb80  CLIPPED
                 ELSE
                    IF NOT cl_null(sr.rvb82) AND sr.rvb82 > 0 THEN
                       CALL cl_remove_zero(sr.rvb82) RETURNING l_rvb82
                       LET l_str2 = l_str2 CLIPPED,',',l_rvb82,sr.rvb80  CLIPPED
                    END IF
                 END IF
             WHEN "3"
                 IF NOT cl_null(sr.rvb85) AND sr.rvb85 > 0 THEN
                     CALL cl_remove_zero(sr.rvb85) RETURNING l_rvb85
                     LET l_str2 = l_rvb85  , sr.rvb83  CLIPPED
                 END IF
          END CASE
       ELSE
       END IF
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.rva05
       EXECUTE insert_prep USING sr.*,l_gfe03,l_str2,g_sma115,l_pmc03,flag,
                                 "",l_img_blob,"N",""   #No.FUN-BA0078 add  #TQC-C10039 ADD ""
#      OUTPUT TO REPORT r920_rep(sr.*)   #No.FUN-710091 
     END FOREACH
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'rva01,rvb04,rva05,rva06')
        RETURNING tm.wc
     ELSE
        LET tm.wc = ''
     END IF
  #  LET g_str =tm.wc,";",tm.c   #FUN-750046 add tm.c  #No.FUN-870053
     LET g_str =tm.wc,";",tm.c,";",tm.d   #No.FUN-870053 
                ,";",g_aza.aza131         #DEV-D30027

  #  LET g_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
  #  CALL cl_prt_cs3('apmr920',g_sql,g_str)
#     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      #No.FUN-870053 
      LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", #No.FUN-870053 
                  "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED     #No.FUN-870053 
#TQC-C10039--mod--str-- 
###No.FUN-BA0078 START###
     LET g_cr_table = l_table                      #主報表的temp table名稱
#    LET g_cr_gcx01 = "asmi300"                    #單別維護程式
     LET g_cr_apr_key_f = "rva01"                  #報表主鍵欄位名稱，用"|"隔開
#    LET l_ii = 1
#    #報表主鍵值
#    CALL g_cr_apr_key.clear()                #清空
#    FOREACH r920_cs2 INTO l_key.*
#       LET g_cr_apr_key[l_ii].v1 = l_key.v1
#       LET l_ii = l_ii + 1
#    END FOREACH
###No.FUN-BA0078 END###
#TQC-C10039--mod--end--
     CALL cl_prt_cs3('apmr920','apmr920',g_sql,g_str)
 
#    FINISH REPORT r920_rep    #No.FUN-710091
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-710091 
END FUNCTION
#No.FUN-710091  --begin
#REPORT r920_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)  
#          sr               RECORD order1 LIKE type_file.chr20,  	#No.FUN-680136 VARCHAR(20) 
#                                  order2 LIKE type_file.chr20,  	#No.FUN-680136 VARCHAR(20) 
#                                  order3 LIKE type_file.chr20,  	#No.FUN-680136 VARCHAR(20) 
#                                  rva01 LIKE rva_file.rva01,	# 單號
#                                  rva02 LIKE rva_file.rva02,	# 採購單號
#                                  rva04 LIKE rva_file.rva04,    # L/C收貨
#                                  rva05 LIKE rva_file.rva05,    # 供應廠商
#                                  rva06 LIKE rva_file.rva06,    # 收貨日期
#                                  rva08 LIKE rva_file.rva08,    # 進口報單
#                                  rva09 LIKE rva_file.rva09,    # 進口號碼
#                                  rva10 LIKE rva_file.rva10,    # 採購性質
#                                 #rva20 LIKE rva_file.rva20,    #
#                                  rvb39 LIKE rvb_file.rvb39,    # no.7143
#                                  rva21 LIKE rva_file.rva21,    # 進口日期
#                                  rvaconf LIKE rva_file.rvaconf,#
#                                  rvb02 LIKE rvb_file.rvb02,	# 收貨單項次
#                                  rvb03 LIKE rvb_file.rvb03,	# 採購單項次
#                                  rvb04 LIKE rvb_file.rvb04,	# 採購單
#                                  rvb05 LIKE rvb_file.rvb05,	# 料件編號
#                                  rvb07 LIKE rvb_file.rvb07,	# 實數數量
#                                  rvb22 LIKE rvb_file.rvb22,	# 發票號碼
#                                  rvb34 LIKE rvb_file.rvb34,	# 工單編號
#                                  rvb35 LIKE rvb_file.rvb35,	# 樣品否
#                                  rvb36 LIKE rvb_file.rvb36,	# Ware
#                                  rvb37 LIKE rvb_file.rvb37,	# Loc
#                                  rvb38 LIKE rvb_file.rvb38,	# Loc
#                                  pmm20 LIKE pmm_file.pmm20,
#                                  pma02 LIKE pma_file.pma02,
#                                  pmn041 LIKE pmn_file.pmn041,  # 品名規格
#                                  ima021 LIKE ima_file.ima021,  # 品名規格
#                                  pmn07 LIKE pmn_file.pmn07,    # 單位
#                                  pmn63 LIKE pmn_file.pmn63,     # 急料
#                                  #No.FUN-580004-begin
#                                  rvb80 LIKE rvb_file.rvb80,
#                                  rvb82 LIKE rvb_file.rvb82,
#                                  rvb83 LIKE rvb_file.rvb83,
#                                  rvb85 LIKE rvb_file.rvb85
#                                  #No.FUN-580004-end
#                        END RECORD,
#          l_tot         LIKE  pmn_file.pmn31,
#          l_pmc03       LIKE  pmc_file.pmc03,
#          l_gen05       LIKE  gen_file.gen05,
#          l_str         LIKE type_file.chr8,   	#No.FUN-680136 VARCHAR(8) 
#          l_sw      	LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1) 
##No.FUN-580004-begin
#DEFINE   l_str2,l_str3  LIKE type_file.chr1000, #No.FUN-5A0139 add 	#No.FUN-680136 VARCHAR(100) 
#         l_ima021     LIKE ima_file.ima021,
#         l_ima906     LIKE ima_file.ima906,
#         l_rvb85      STRING,
#         l_rvb82      STRING
##No.FUN-580004-end
#DEFINE   l_gfe03      LIKE gfe_file.gfe03   #MOD-6C0145
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.rva01,sr.rvb02
##No.FUN-580004-begin
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#
#      LET g_pageno = g_pageno + 1
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT
#      PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#
#      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = sr.rva05
#      CALL s_prtype(sr.rva10) RETURNING l_str
##No.FUN-550060 --start--
##---No.FUN-5A0139 begin
##      PRINT g_x[11] CLIPPED,sr.rva01,COLUMN 23,g_x[15] CLIPPED,sr.rva05,
##            COLUMN 40,g_x[16] CLIPPED,l_pmc03
#      PRINT g_x[11] CLIPPED,sr.rva01,
#            COLUMN 40,g_x[15] CLIPPED,sr.rva05,
#            COLUMN 74,g_x[16] CLIPPED,l_pmc03
##     PRINT g_x[12] CLIPPED,sr.rva06,COLUMN 23,g_x[19] CLIPPED,
#      PRINT g_x[12] CLIPPED,sr.rva06,
#            COLUMN 40,g_x[19] CLIPPED,
#            sr.rva10 CLIPPED,l_str CLIPPED,
##            COLUMN 40,g_x[21] CLIPPED,sr.rva21
#            COLUMN 74,g_x[21] CLIPPED,sr.rva21
##      PRINT g_x[13] CLIPPED,sr.rva02,COLUMN 23,g_x[20] CLIPPED,
#      PRINT g_x[13] CLIPPED,sr.rva02,
#            COLUMN 40,g_x[20] CLIPPED,
#            sr.rva04 CLIPPED,
##           COLUMN 40,g_x[18] CLIPPED,sr.rva08
#            COLUMN 74,g_x[18] CLIPPED,sr.rva08
#      PRINT g_x[40] CLIPPED,sr.rvaconf,'        ',
#           #g_x[33] CLIPPED,sr.rva20, #mark no.7143
##            COLUMN 40,g_x[17] CLIPPED,sr.rva09
#            COLUMN 74,g_x[17] CLIPPED,sr.rva09
#      PRINT g_x[34] CLIPPED,sr.pmm20 CLIPPED,' ',sr.pma02
#      PRINT g_dash[1,g_len]
#
#      PRINTX name=H1 g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
#                     g_x[49],g_x[50],g_x[51]
#      PRINTX name=H2 g_x[52],g_x[53],g_x[54]
#      PRINTX name=H3 g_x[55],g_x[56],g_x[59]
#      PRINTX name=H4 g_x[57],g_x[58],g_x[60]
##---No.FUN-5A0139 end
#      PRINT g_dash1
#      LET l_last_sw='n'
#
#   BEFORE GROUP OF sr.rva01
#      SKIP TO TOP OF PAGE
#
#      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                         WHERE ima01=sr.rvb05
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.rvb85) RETURNING l_rvb85
#                LET l_str2 = l_rvb85 , sr.rvb83  CLIPPED
#                IF cl_null(sr.rvb85) OR sr.rvb85  = 0 THEN
#                    CALL cl_remove_zero(sr.rvb82) RETURNING l_rvb82
#                    LET l_str2 = l_rvb82,sr.rvb80  CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.rvb82) AND sr.rvb82 > 0 THEN
#                      CALL cl_remove_zero(sr.rvb82) RETURNING l_rvb82
#                      LET l_str2 = l_str2 CLIPPED,',',l_rvb82,sr.rvb80  CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.rvb85) AND sr.rvb85 > 0 THEN
#                    CALL cl_remove_zero(sr.rvb85) RETURNING l_rvb85
#                    LET l_str2 = l_rvb85  , sr.rvb83  CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#
#   ON EVERY ROW
##---No.FUN-5A0139 begin
#    #MOD-6C0145--begin
#     SELECT gfe03 INTO l_gfe03 FROM gfe_file
#      WHERE gfe01 = sr.pmn07
#     IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
#       LET l_gfe03 = 0
#     END IF
#    #MOD-6C0145--end
#
#      PRINTX name=D1 COLUMN g_c[43],sr.rvb02 USING'###&',#FUN-590118
#                     COLUMN g_c[44],sr.rvb22 CLIPPED,
#                     COLUMN g_c[45],sr.rvb04 CLIPPED,
#                     COLUMN g_c[46],sr.rvb03 USING '#########&';
#    IF sr.pmn63='Y' THEN
#      PRINTX name=D1 COLUMN g_c[47],sr.rvb34 CLIPPED;
#    END IF
#      PRINTX name=D1 COLUMN g_c[48],sr.pmn07 CLIPPED,
#                     COLUMN g_c[49],sr.rvb35 CLIPPED,
#                     #COLUMN g_c[50],cl_numfor(sr.rvb07,50,2),  #MOD-6C0145
#                     COLUMN g_c[50],cl_numfor(sr.rvb07,50,l_gfe03),   #MOD-6C0145
#                     COLUMN g_c[51],sr.rvb39 CLIPPED
#      PRINTX name=D2 COLUMN g_c[53],sr.rvb05 CLIPPED,
#                     COLUMN g_c[54],l_str2 CLIPPED
#    IF sr.pmn63='Y' THEN
#      PRINTX name=D3 COLUMN g_c[55],g_x[32] CLIPPED,
#                     COLUMN g_c[56],sr.pmn041 CLIPPED,
#                     COLUMN g_c[59],g_x[35] CLIPPED
#    ELSE
#      PRINTX name=D3 COLUMN g_c[56],sr.pmn041 CLIPPED,
#                     COLUMN g_c[59],g_x[35] CLIPPED
#      END IF
#
#      PRINTX name=D4  COLUMN g_c[58],sr.ima021 CLIPPED,
#                      COLUMN g_c[60],g_x[36] CLIPPED
# 
#      LET l_str3=g_x[37] CLIPPED,sr.rvb36 CLIPPED,' ',
#                 sr.rvb37 CLIPPED,' ',sr.rvb38 CLIPPED
#      PRINTX name=S1  COLUMN g_c[58],l_str3 CLIPPED
##----end
# 
#   AFTER GROUP OF sr.rva01
#      UPDATE rva_file SET rvaprno = rvaprno+1,
#                          rva28   = g_today
#             WHERE rva01 = sr.rva01
#      LET g_pageno = 0
#      LET l_last_sw = 'y'
#
##No.FUN-580004-end
### FUN-550114
# PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n' THEN
#         #PRINT g_x[38],COLUMN 41,g_x[39]#NO:2879
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         #PRINT g_x[38],COLUMN 41,g_x[39]#NO:2879
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
#
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[38]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[38]
#             PRINT g_memo
#      END IF
### END FUN-550114
#
#END REPORT
#No.FUN-710091
##Patch....NO.TQC-610036 <> #
