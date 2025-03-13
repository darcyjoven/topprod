# Prog. Version..: '5.30.06-13.03.28(00005)'     #
#
# Pattern name...: axmg551.4gl
# Descriptions...: INVOICE 套表
# Date & Author..: 02/10/18 by Max
# Modify By .....: 02/12/02 By Snow
#                  1.調整列印在項次備註前後的備註,改抓axmt620-M.備註 的資料
# Modify.........: No.FUN-4C0096 05/03/04 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.MOD-530091 05/03/14 By cate 報表標題標準化
# Modify.........: No.MOD-530071 05/05/06 By Mandy INVOICE(axmg551) 的 SHIP TO 資料錯誤
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580004 05/08/09 By day 報表轉xml
# Modify.........: No.FUN-5A0143 05/10/24 By Rosayu 報表格式修改
# Modify.........: No.FUN-5A0181 05/10/26 By Rosayu 當"使用多單位",和"使用計價單位"有無勾選時,報表欄位位置對齊
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.TQC-5B0126 05/11/14 BY CoCo 報表位置調整
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: NO.FUN-610072 06/01/20 By sarah 加印公司TITLE
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By rainy 新增是否列印客戶料號
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.FUN-710080 07/02/02 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-720011 07/02/06 By Sarah QBE的ofa01(INVOICE單號)增加開窗功能
# Modify.........: No.FUN-740057 07/04/14 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.MOD-810098 08/01/14 By cliare oea10不該定義為oea01應仍為oea10
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.MOD-850197 08/05/21 By Smapmin 放大程式中變數大小
# Modify.........: No.MOD-860289 08/06/25 By Smapmin 客戶料號沒有顯示
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80089 10/08/17 By yinhy 畫面條件選項增加一個選項，列印額外品名規格
# Modify.........: No:CHI-AB0029 10/11/30 By Summer 接收的參數有問題
# Modify.........: No.FUN-B40087 11/05/05 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改 
# Modify.........: No:FUN-C10036 12/01/16 By lujh FUN-B80089追單
# Modify.........: No:FUN-C50003 12/05/14 By yangtt GR程式優化
# Modify.........: No:CHI-D30011 13/03/21 By Elise 幣別欄位遇到USD改為US DOLLARS

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004-begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-680137 SMALLINT
END GLOBALS
#No.FUN-580004-end
 
DEFINE tm   RECORD                                #Print condition RECORD
             wc        LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(300)   #Where condition
             d         LIKE type_file.chr1,       # No.FUN-690032 是否列印客戶料號
             b         LIKE type_file.chr1,       # No.FUN-680137 VARCHAR(1)     #是否列印備註
             a         LIKE type_file.chr1,       # 列印公司對內全名          #FUN-740057 add
             c         LIKE type_file.chr1,       # 列印公司對外全名          #FUN-740057 add
             e         LIKE type_file.chr1,       # 列印額外品名規格          #FUN-A80089 add
             more      LIKE type_file.chr1        # No.FUN-680137 VARCHAR(01)    #Input more condition(Y/N)
            END RECORD,
       l_oao06         LIKE oao_file.oao06,
       x               LIKE aba_file.aba00,       # No.FUN-680137 VARCHAR(5)
       y,z             LIKE type_file.chr1,       # No.FUN-680137  VARCHAR(1)
       g_po_no,g_ctn_no1,g_ctn_no2    LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
       g_azi02         LIKE type_file.chr20,      # No.FUN-680137 VARCHAR(20)
       g_zo12          LIKE zo_file.zo12,         # No.FUN-680137 VARCHAR(60)
       g_no            LIKE type_file.num10,      # No.FUN-680137 INTEGER
       g_title         LIKE occ_file.occ02,       # No.FUN-680137 VARCHAR(25)
       g_sr DYNAMIC ARRAY OF RECORD
             ima01     LIKE ima_file.ima01,
             ima02     LIKE ima_file.ima02
            END RECORD,
       g_str1,g_str2,g_str3,g_str4  LIKE type_file.chr20,       # No.FUN-680137  VARCHAR(20)
       l_flag          LIKE type_file.chr1        #No.FUN-680137 VARCHAR(1)
DEFINE g_i             LIKE type_file.num5        #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE i               LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE j               LIKE type_file.num5        #No.FUN-680137 SMALLINT
#str FUN-710080 add
DEFINE l_table         STRING
DEFINE l_table1        STRING              #FUN-810029 add
DEFINE l_table2        STRING              #FUN-810029 add
DEFINE l_table3        STRING              #FUN-A80089 add
DEFINE g_sql           STRING
DEFINE g_str           STRING
DEFINE l_str1,l_str2,l_str3 LIKE type_file.chr1000
DEFINE g_zo041         LIKE zo_file.zo041
DEFINE g_zo05          LIKE zo_file.zo05   #FUN-810029 add
DEFINE g_zo09          LIKE zo_file.zo09   #FUN-810029 add
#end FUN-710080 add
 
###GENGRE###START
TYPE sr1_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    ofa02 LIKE ofa_file.ofa02,
    ofa0351 LIKE ofa_file.ofa0351,
    ofa0352 LIKE ofa_file.ofa0353,
    ofa0353 LIKE ofa_file.ofa0353,
    ofa0354 LIKE ofa_file.ofa0354,
    ofa0355 LIKE ofa_file.ofa0355,
    ofa0451 LIKE ofa_file.ofa0451,
    ofa0452 LIKE ofa_file.ofa0453,
    ofa0453 LIKE ofa_file.ofa0453,
    ofa0454 LIKE ofa_file.ofa0454,
    ofa0455 LIKE ofa_file.ofa0455,
    occ29 LIKE occ_file.occ29,
    occ292 LIKE occ_file.occ292,
    ofa31 LIKE ofa_file.ofa31,
    oah02 LIKE oah_file.oah02,
    ofa32 LIKE ofa_file.ofa32,
    oag02 LIKE oag_file.oag02,
    ofb03 LIKE ofb_file.ofb03,
    ofb04 LIKE ofb_file.ofb04,
    ofb06 LIKE ofb_file.ofb06,
    ima021 LIKE ima_file.ima021,
    ima138 LIKE ima_file.ima138,
    oea10 LIKE oea_file.oea10,
    ofb12 LIKE ofb_file.ofb12,
    ofb05 LIKE ofb_file.ofb05,
    ofb916 LIKE ofb_file.ofb916,
    ofb917 LIKE ofb_file.ofb917,
    ofb13 LIKE ofb_file.ofb13,
    ofb14 LIKE ofb_file.ofb14,
    ofb11 LIKE ofb_file.ofb11,
    ofa23 LIKE ofa_file.ofa23,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    str1 LIKE type_file.chr1000,
    str2 LIKE type_file.chr1000,
    str3 LIKE type_file.chr1000,
    zo12 LIKE zo_file.zo12,
    zo041 LIKE zo_file.zo041,
    zo05 LIKE zo_file.zo05,
    zo09 LIKE zo_file.zo09,
    ofb07 LIKE ofb_file.ofb07,
    l_count LIKE type_file.num5
END RECORD

TYPE sr2_t RECORD
    oao01 LIKE oao_file.oao01,
    oao03 LIKE oao_file.oao03,
    oao04 LIKE oao_file.oao04,
    oao05 LIKE oao_file.oao05,
    oao06 LIKE oao_file.oao06
END RECORD

TYPE sr3_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    oaf03 LIKE oaf_file.oaf03
END RECORD

TYPE sr4_t RECORD
    imc01 LIKE imc_file.imc01,
    imc02 LIKE imc_file.imc02,
    imc03 LIKE imc_file.imc03,
    imc04 LIKE imc_file.imc04,
    ofa01 LIKE ofa_file.ofa01,
    ofb03 LIKE ofb_file.ofb03
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126   #FUN-C10036   mark
 
  #str FUN-810029 mod
   #str FUN-710080 mod
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ofa01.ofa_file.ofa01,    ofa02.ofa_file.ofa02,",
               #"ofa0351.ofa_file.ofa0351,ofa0352.ofa_file.ofa0352,",   #MOD-850197
               "ofa0351.ofa_file.ofa0351,ofa0352.ofa_file.ofa0353,",   #MOD-850197
               "ofa0353.ofa_file.ofa0353,ofa0354.ofa_file.ofa0354,",
               "ofa0355.ofa_file.ofa0355,ofa0451.ofa_file.ofa0451,",
               #"ofa0452.ofa_file.ofa0452,ofa0453.ofa_file.ofa0453,",   #MOD-850197
               "ofa0452.ofa_file.ofa0453,ofa0453.ofa_file.ofa0453,",   #MOD-850197
               "ofa0454.ofa_file.ofa0454,ofa0455.ofa_file.ofa0455,",
               "occ29.occ_file.occ29,    occ292.occ_file.occ292,",
               "ofa31.ofa_file.ofa31,    oah02.oah_file.oah02,",
               "ofa32.ofa_file.ofa32,    oag02.oag_file.oag02,",
               "ofb03.ofb_file.ofb03,    ofb04.ofb_file.ofb04,",
               "ofb06.ofb_file.ofb06,    ima021.ima_file.ima021,",
               "ima138.ima_file.ima138,  oea10.oea_file.oea10,",   #MOD-810098 modify oea10
               "ofb12.ofb_file.ofb12,    ofb05.ofb_file.ofb05,",
               "ofb916.ofb_file.ofb916,  ofb917.ofb_file.ofb917,",
               "ofb13.ofb_file.ofb13,    ofb14.ofb_file.ofb14,",
               "ofb11.ofb_file.ofb11,    ofa23.ofa_file.ofa23,",
               "azi03.azi_file.azi03,    azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,    str1.type_file.chr1000,",
               "str2.type_file.chr1000,  str3.type_file.chr1000,",
               "zo12.zo_file.zo12,       zo041.zo_file.zo041,",
               "zo05.zo_file.zo05,       zo09.zo_file.zo09,",   #FUN-810029 add
               "ofb07.ofb_file.ofb07,    l_count.type_file.num5" #FUN-A80089 add
   LET l_table = cl_prt_temptable('axmg551',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087    #FUN-C10036   mark                                                     
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40087  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
 
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao04.oao_file.oao04,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06"
   LET l_table1 = cl_prt_temptable('axmg5511',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087   #FUN-C10036   mark                                                      
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40087  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
 
   LET g_sql = "ofa01.ofa_file.ofa01,",
               "oaf03.oaf_file.oaf03"
   LET l_table2 = cl_prt_temptable('axmg5512',g_sql) CLIPPED   # 產生Temp Table
   IF l_table2 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087   #FUN-C10036   mark                                                      
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40087   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
   #No.FUN-A80089 --start--
    LET g_sql = "imc01.imc_file.imc01,",
                "imc02.imc_file.imc02,",
                "imc03.imc_file.imc03,",
                "imc04.imc_file.imc04,",
                "ofa01.ofa_file.ofa01,",
                "ofb03.ofb_file.ofb03"
    LET l_table3 = cl_prt_temptable('axmg5513',g_sql) CLIPPED
    IF l_table3 = -1 THEN 
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087  #FUN-C10036   mark                                                       
       #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40087  #FUN-C10036   mark
       EXIT PROGRAM 
    END IF
   #No.FUN-A80089 --end--
   #------------------------------ CR (1) ------------------------------#
   #end FUN-710080 add
  #end FUN-810029 mod
 
   LET g_zo12 = NULL
   LET g_zo041= NULL   #FUN-710080 add
   LET g_zo05 = NULL   #FUN-810029 add
   LET g_zo09 = NULL   #FUN-810029 add
   SELECT zo12,zo041,zo05,zo09 INTO g_zo12,g_zo041,g_zo05,g_zo09    #FUN-710080 add zo041   #FUN-810029 add zo05,zo09
     FROM zo_file WHERE zo01='1'
   #no.7210
   IF cl_null(g_zo12) THEN
      SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='0'
   END IF
   #no.7210(end)
   #str FUN-710080 add
   IF cl_null(g_zo041) THEN
      SELECT zo041 INTO g_zo041 FROM zo_file WHERE zo01='0'
   END IF
   #end FUN-710080 add
   #str FUN-810029 add
   IF cl_null(g_zo05) THEN
      SELECT zo05 INTO g_zo05 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo09) THEN
      SELECT zo09 INTO g_zo09 FROM zo_file WHERE zo01='0'
   END IF
   #end FUN-810029 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
   INITIALIZE tm.* TO NULL            # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.wc = ARG_VAL(1)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.b    = ARG_VAL(8)
   LET tm.a    = ARG_VAL(9)    #FUN-740057 add
   LET tm.c    = ARG_VAL(10)   #FUN-740057 add
   LET tm.e    = ARG_VAL(11)   #FUN-A80089 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(tm.wc) THEN
      CALL axmg551_tm(0,0)             # Input print condition
   ELSE 
     #LET tm.wc="ofa01 ='",tm.wc CLIPPED,"'" #CHI-AB0029 mark
      CALL axmg551()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
END MAIN
 
FUNCTION axmg551_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(400)
 
   LET p_row = 6 LET p_col = 17
 
   OPEN WINDOW axmg551_w AT p_row,p_col WITH FORM "axm/42f/axmg551"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.a    = 'Y'      #FUN-740057 add
   LET tm.c    = 'Y'      #FUN-740057 add
   LET tm.e    = 'N'      #FUN-A80089 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofa01,ofa02
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
 
      #str FUN-720011 add
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ofa01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ofa"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ofa01
               NEXT FIELD ofa01
         END CASE
      #end FUN-720011 add
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg551_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   LET tm.b='Y'  #DEFAULT 列印備註
   LET tm.d='N'  #DEFAULT 不列印客戶料號  #FUN-690032 add
 
   INPUT BY NAME tm.d,tm.b,tm.a,tm.c,tm.e,tm.more WITHOUT DEFAULTS  #FUN-690032 add tm.d   #FUN-740057 add tm.a,tm.c  #FUN-A80089 add tm.e
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      #FUN-690032 add--begin
      AFTER FIELD d  #是否列印客戶料號
          IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN 
             NEXT FIELD d 
          END IF
      #FUN-690032 add--end
 
      AFTER FIELD b  #是否列印備註
          IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
 
      #str FUN-740057 add
      AFTER FIELD a
          IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
 
      AFTER FIELD c
          IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN NEXT FIELD c END IF
      #end FUN-740057 add
      #FUN-A80089 add--begin
      AFTER FIELD e  #是否列印品名規格額外說明
          IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN 
             NEXT FIELD e 
          END IF
      #FUN-A80089 add--end
      AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF
 
      AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          LET l_flag='N'
          IF cl_null(tm.b) THEN LET l_flag='Y' END IF
          IF l_flag='Y' THEN NEXT FIELD a END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg551_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axmg551'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg551','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.b  CLIPPED,"'",
                         " '",tm.d  CLIPPED,"'",    #FUN-690032 add
                         " '",tm.a CLIPPED,"'" ,                #FUN-740057 add
                         " '",tm.c CLIPPED,"'" ,                #FUN-740057 add
                         " '",tm.e CLIPPED,"'" ,                #FUN-A80089 add
                        #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmg551',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg551_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg551()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg551_w
END FUNCTION
 
FUNCTION axmg551()
  DEFINE l_name     LIKE type_file.chr20,        # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
      #   l_time     LIKE type_file.chr8,        # Used time for running the job   #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
         l_sql      LIKE type_file.chr1000,      #No.FUN-680137 VARCHAR(800)
         l_count    LIKE type_file.num5,         #No.FUN-A80089
         ofa        RECORD LIKE ofa_file.*,
         ofb        RECORD LIKE ofb_file.*,
         oao        RECORD LIKE oao_file.*,      #FUN-810029 add
         sr         RECORD
                     occ29  LIKE occ_file.occ29,
                     occ292 LIKE occ_file.occ292,
                     oah02  LIKE oah_file.oah02,
                     oag02  LIKE oag_file.oag02,
                     ima138 LIKE ima_file.ima138,
                     ima021 LIKE ima_file.ima021,     #FUN-710080 add
                     ima906 LIKE ima_file.ima906,     #FUN-710080 add
                     oea10  LIKE oea_file.oea10       #FUN-710080 add
                    END RECORD,
        #No.FUN-A80089  --start--
         sr1        RECORD
                     imc01     LIKE imc_file.imc01,
                     imc02     LIKE imc_file.imc02,
                     imc03     LIKE imc_file.imc03,
                     imc04     LIKE imc_file.imc04
                    END RECORD
        #No.FUN-A80089  --end--
                    
  DEFINE l_i,l_cnt  LIKE type_file.num5               #No.FUN-580004        #No.FUN-680137 SMALLINT
  DEFINE l_zaa02    LIKE zaa_file.zaa02               #No.FUN-580004
  #str FUN-710080 add
  DEFINE l_ofb915   STRING,
         l_ofb912   STRING,
         l_ofb12    STRING,
         t_ofb14    LIKE ofb_file.ofb14,
         l_oaf03    LIKE oaf_file.oaf03
  #end FUN-710080 add
  DEFINE l_ofa0352  LIKE ofa_file.ofa0353   #MOD-850197
  DEFINE l_ofa0452  LIKE ofa_file.ofa0453   #MOD-850197
 
  #str FUN-710080 add
  ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
  CALL cl_del_data(l_table)
  CALL cl_del_data(l_table1)   #FUN-810029 add
  CALL cl_del_data(l_table2)   #FUN-810029 add
  CALL cl_del_data(l_table3)   #FUN-A80089 add
  #------------------------------ CR (2) ------------------------------#
 
 #str FUN-810029 mod
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?)"   #No.FUN-A80089 add 2?                         
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40087
     EXIT PROGRAM
  END IF
 
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
              " VALUES(?,?,?,?,?)"
  PREPARE insert_prep1 FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep1:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40087
     EXIT PROGRAM
  END IF
 
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
              " VALUES(?,?)"
  PREPARE insert_prep2 FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep2:',status,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40087
     EXIT PROGRAM
  END IF
  #end FUN-710080 add
 #end FUN-810029 add
 #No.FUN-A80089---begin                                                                                                              
  LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
              " VALUES(?,?,?,?,?, ?)"                                                                                 
  PREPARE insert_prep3 FROM l_sql                                                                                                
  IF STATUS THEN                                                                                                                 
     CALL cl_err("insert_prep3:",STATUS,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)         #FUN-B40087
     EXIT PROGRAM                                                                          
  END IF                                                                                                                         
#No.FUN-A80089---END
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-710080 add
 
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                   #只能使用自己的資料
  #     LET tm.wc = tm.wc clipped," AND ofauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                   #只能使用相同群的資料
  #     LET tm.wc = tm.wc clipped," AND ofagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET tm.wc = tm.wc clipped," AND ofagrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
  #End:FUN-980030
 
  LET l_sql="SELECT ofa_file.*, ofb_file.* ,",
           #FUN-C50003----mod---str---
            "       occ29,occ292,oah02,oag02,ima138,ima021,ima906,oea10,azi03,azi04,azi05 ",
           #"  FROM ofa_file,ofb_file ",
            "  FROM ofa_file LEFT OUTER JOIN occ_file ON occ01=ofa03",
            "                LEFT OUTER JOIN oah_file ON oah01=ofa31",
            "                LEFT OUTER JOIN oag_file ON oag01=ofa32",
            "                LEFT OUTER JOIN azi_file ON azi01=ofa23,",
            "       ofb_file LEFT OUTER JOIN ima_file ON ima01=ofb04",
            "                LEFT OUTER JOIN oea_file ON oea01=ofb31",
           #FUN-C50003----mod---end---
            " WHERE ofa01=ofb01 ",
            "   AND ",tm.wc CLIPPED,
            "   AND ofaconf !='X' "
  PREPARE axmg551_prepare1 FROM l_sql
  IF SQLCA.sqlcode != 0 THEN
     CALL cl_err('prepare1:',SQLCA.sqlcode,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
     EXIT PROGRAM
  END IF
  DECLARE axmg551_curs1 CURSOR FOR axmg551_prepare1

  #FUN-C50003----mark---str--
   DECLARE imc_cur CURSOR FOR
     SELECT * FROM imc_file    
      WHERE imc01=? AND imc02=? 
     ORDER BY imc03                                        

   IF tm.b='Y' THEN
   #列印單身備註
     DECLARE oao_c1 CURSOR FOR
       SELECT * FROM oao_file
        WHERE oao01=? AND oao03=? AND (oao05='1' OR oao05='2')
   END IF
  #FUN-C50003----mark---end--
 
  FOREACH axmg551_curs1 INTO ofa.*,ofb.*,sr.*,t_azi03,t_azi04,t_azi05      #FUN-C50003 add sr.*,t_azi03,t_azi04,t_azi05
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
 
     #str FUN-710080 add
    #FUN-C50003----mark---str--
    ##業務聯絡人,業務聯絡人分機號碼
    #SELECT occ29,occ292 INTO sr.occ29 ,sr.occ292 FROM occ_file
    # WHERE occ01 = ofa.ofa03
    ##價格條件編號
    #SELECT oah02 INTO sr.oah02 FROM oah_file
    # WHERE oah01 = ofa.ofa31
    ##收款條件編號
    #SELECT oag02 INTO sr.oag02 FROM oag_file
    # WHERE oag01 = ofa.ofa32
    ##FCC No,規格,單位使用方式
    #SELECT ima138,ima021,ima906 INTO sr.ima138,sr.ima021,sr.ima906 
    #  FROM ima_file
    # WHERE ima01 = ofb.ofb04
    #FUN-C50003----mark---str--
     #ofa72(是否列印FCC No.)
     IF ofa.ofa72='N' THEN LET sr.ima138 = "" END IF
     #客戶訂單單號
   # SELECT oea10 INTO sr.oea10 FROM oea_file WHERE oea01=ofb.ofb31    #FUN-C50003 mark
     #多單位
     LET l_str3 = ""
     IF g_sma.sma115 = "Y" THEN
        CASE sr.ima906
           WHEN "2"
              CALL cl_remove_zero(ofb.ofb915) RETURNING l_ofb915
              LET l_str3 = l_ofb915,ofb.ofb913 CLIPPED
              IF cl_null(ofb.ofb915) OR ofb.ofb915 = 0 THEN
                 CALL cl_remove_zero(ofb.ofb912) RETURNING l_ofb912
                 LET l_str3 = l_ofb912,ofb.ofb910 CLIPPED
              ELSE
                 IF NOT cl_null(ofb.ofb912) AND ofb.ofb912 > 0 THEN
                    CALL cl_remove_zero(ofb.ofb912) RETURNING l_ofb912
                    LET l_str3 = l_str3 CLIPPED,',',l_ofb912,ofb.ofb910 CLIPPED
                 END IF
              END IF
           WHEN "3"
              IF NOT cl_null(ofb.ofb915) AND ofb.ofb915 > 0 THEN
                  CALL cl_remove_zero(ofb.ofb915) RETURNING l_ofb915
                  LET l_str3 = l_ofb915 , ofb.ofb913 CLIPPED
              END IF
        END CASE
     END IF
     IF g_sma.sma116 MATCHES '[23]' THEN     #No.FUN-610076
        IF ofb.ofb05 <> ofb.ofb916 THEN  #NO.TQC-6B0137 mod
           CALL cl_remove_zero(ofb.ofb12) RETURNING l_ofb12
           LET l_str3 = l_str3 CLIPPED,"(",l_ofb12,ofb.ofb05 CLIPPED,")"
        END IF
     END IF
     IF ofa.ofa0352 IS NULL THEN #帳款客戶全名
        #LET ofa.ofa0352 = ofa.ofa0353 LET ofa.ofa0353 = ofa.ofa0354   #MOD-850197
        LET l_ofa0352 = ofa.ofa0353 LET ofa.ofa0353 = ofa.ofa0354   #MOD-850197
        LET ofa.ofa0354 = ofa.ofa0355 LET ofa.ofa0355 = NULL
     ELSE   #MOD-850197
        LET l_ofa0352 = ofa.ofa0352   #MOD-850197
     END IF
     IF ofa.ofa0452 IS NULL THEN #送貨客戶全名
        #LET ofa.ofa0452 = ofa.ofa0453 LET ofa.ofa0453 = ofa.ofa0454   #MOD-850197
        LET l_ofa0452 = ofa.ofa0453 LET ofa.ofa0453 = ofa.ofa0454   #MOD-850197
        LET ofa.ofa0454 = ofa.ofa0455 LET ofa.ofa0455 = NULL
     ELSE   #MOD-850197
        LET l_ofa0452 = ofa.ofa0452   #MOD-850197
     END IF
     #產品編號,客戶產品編號
     CASE WHEN ofa.ofa71='1' #LET ofb.ofb11=NULL   #MOD-860289
          WHEN ofa.ofa71='2' LET ofb.ofb04=ofb.ofb11 #LET ofb.ofb11=NULL   #MOD-860289
     END CASE
     #SAY TOTAL
     LET t_ofb14 = 0
     SELECT SUM(ofb14) INTO t_ofb14 FROM ofb_file WHERE ofb01=ofa.ofa01
     CALL cl_say(t_ofb14,80) RETURNING l_str1,l_str2
     #單價、金額、小計小數位數
     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
       FROM azi_file WHERE azi01 = ofa.ofa23
     IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF
     IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
     IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF
     #No.FUN-A80089  --start  列印額外品名規格說明
      IF tm.e = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM imc_file
             WHERE imc01=ofb.ofb04 AND imc02=ofb.ofb07
          IF l_count !=0  THEN
           #FUN-C50003----mark---str--
           #DECLARE imc_cur CURSOR FOR
           #SELECT * FROM imc_file    
           #  WHERE imc01=ofb.ofb04 AND imc02=ofb.ofb07 
           #ORDER BY imc03                                        
           #FUN-C50003----mark---end--
            FOREACH imc_cur USING ofb.ofb04,ofb.ofb07 INTO sr1.*         #FUN-C50003 add USING ofb.ofb04,ofb.ofb07                    
              EXECUTE insert_prep3 USING sr1.imc01,sr1.imc02,sr1.imc03,sr1.imc04,ofa.ofa01,ofb.ofb03
            END FOREACH
          END IF
     END IF    
     #No.FUN-A80089  --end
     EXECUTE insert_prep USING 
        #ofa.ofa01  ,ofa.ofa02  ,ofa.ofa0351,ofa.ofa0352,ofa.ofa0353,   #MOD-850197
        ofa.ofa01  ,ofa.ofa02  ,ofa.ofa0351,l_ofa0352,ofa.ofa0353,   #MOD-850197
        #ofa.ofa0354,ofa.ofa0355,ofa.ofa0451,ofa.ofa0452,ofa.ofa0453,   #MOD-850197
        ofa.ofa0354,ofa.ofa0355,ofa.ofa0451,l_ofa0452,ofa.ofa0453,   #MOD-850197
        ofa.ofa0454,ofa.ofa0455,sr.occ29   ,sr.occ292  ,ofa.ofa31  ,
        sr.oah02   ,ofa.ofa32  ,sr.oag02   ,ofb.ofb03  ,ofb.ofb04  ,
        ofb.ofb06  ,sr.ima021  ,sr.ima138  ,sr.oea10   ,ofb.ofb12  ,
        ofb.ofb05  ,ofb.ofb916 ,ofb.ofb917 ,ofb.ofb13  ,ofb.ofb14  ,
        ofb.ofb11  ,ofa.ofa23  ,t_azi03    ,t_azi04    ,t_azi05    ,
        l_str1     ,l_str2     ,l_str3     ,g_zo12     ,g_zo041    ,
        g_zo05     ,g_zo09     ,ofb.ofb07  ,l_count    #FUN-810029 add  #FUN-A80089 add ofb.ofb07 ,l_count
 
     #列印備註
     IF tm.b='Y' THEN
       #str FUN-810029 mod
        #列印單身備註
       #FUN-C50003----mark---str--
       #DECLARE oao_c1 CURSOR FOR
       # SELECT * FROM oao_file
       #  WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND (oao05='1' OR oao05='2')
       #FUN-C50003----mark---end--
        FOREACH oao_c1 USING ofa.ofa01,ofb.ofb03 INTO oao.*   #FUN-C50003 add USING ofa.ofa01,ofb.ofb03
           IF NOT cl_null(oao.oao06) THEN
              EXECUTE insert_prep1 USING 
                 ofa.ofa01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
           END IF
        END FOREACH
       #end FUN-810029 mod
     END IF
     #end FUN-710080 add
  END FOREACH
 
 #str FUN-810029 add
  LET l_sql = "SELECT * FROM ofa_file ",
              " WHERE ",tm.wc CLIPPED,
              "   AND ofaconf !='X' ",
              " ORDER BY ofa01"
  PREPARE axmg551_prepare2 FROM l_sql
  IF SQLCA.sqlcode != 0 THEN
     CALL cl_err('axmg551_prepare2:',SQLCA.sqlcode,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
     CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
     EXIT PROGRAM
  END IF
  DECLARE axmg551_curs2 CURSOR FOR axmg551_prepare2

  #FUN-C50003----add----end--
   #列印整張備註
   DECLARE oao_c2 CURSOR FOR
     SELECT * FROM oao_file
      WHERE oao01=? AND oao03=0 AND (oao05='1' OR oao05='2')

   DECLARE oaf_c CURSOR FOR
     SELECT oaf03 FROM oaf_file
      WHERE (oaf01=? OR oaf01=? OR oaf01=?)
     ORDER BY oaf01,oaf02
 #FUN-C50003----add----end--
 
  FOREACH axmg551_curs2 INTO ofa.*
    #str FUN-810029 mod
     IF tm.b='Y' THEN
       #FUN-C50003----mark---end--
       ##列印整張備註
       #DECLARE oao_c2 CURSOR FOR
       # SELECT * FROM oao_file
       #  WHERE oao01=ofa.ofa01 AND oao03=0 AND (oao05='1' OR oao05='2')
       #FUN-C50003----mark---end--
        FOREACH oao_c2 USING ofa.ofa01 INTO oao.*    #FUN-C50003 add USING ofa.ofa01
           IF NOT cl_null(oao.oao06) THEN
              EXECUTE insert_prep1 USING 
                 ofa.ofa01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
           END IF
        END FOREACH
     END IF
    #end FUN-810029 mod
 
     #str FUN-710080 add
     #常用說明
    #FUN-C50003----mark---str--
    #DECLARE oaf_c CURSOR FOR
    #   SELECT oaf03 FROM oaf_file
    #    WHERE (oaf01=ofa.ofa741 OR oaf01=ofa.ofa742 OR oaf01=ofa.ofa743)
    #    ORDER BY oaf01,oaf02
    #FUN-C50003----mark---end--
     FOREACH oaf_c USING ofa.ofa741,ofa.ofa742 ,ofa.ofa743 INTO l_oaf03   #FUN-C50003 add USING ofa.ofa741,ofa.ofa742 ,ofa.ofa743
        IF NOT cl_null(l_oaf03) THEN
           EXECUTE insert_prep2 USING ofa.ofa01,l_oaf03
        END IF
     END FOREACH
     #end FUN-710080 add
  END FOREACH
 #end FUN-810029 add
 
 #str FUN-810029 mod
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
 ##str FUN-710080 add
 #LET l_sql=
 #    "SELECT A.*,",
 #    "       B.oao06h,B.oao06d1,B.oao06d2,B.oao06t,",
 #    "       C.oaf03",
 #    "  FROM g551_tmp A,",
 #    "       g551_tmp1 B, r551_tmp2 C ",
 #    " WHERE A.ofa01=B.ofa01_1(+)",
 #    "   AND A.ofa01=C.ofa01_2(+)"
###GENGRE###  LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###              " WHERE oao03 =0 AND oao05='1'","|",
###GENGRE###              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###              " WHERE oao03!=0 AND oao05='1'","|",
###GENGRE###              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###              " WHERE oao03!=0 AND oao05='2'","|",
###GENGRE###              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###              " WHERE oao03 =0 AND oao05='2'","|",
###GENGRE###              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
###GENGRE###              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED     #FUN-A80089
 #end FUN-810029 mod
 
  #是否列印選擇條件
  IF g_zz05 = 'Y' THEN
     CALL cl_wcchp(tm.wc,'ofa01,ofa02') RETURNING tm.wc
  ELSE
     LET tm.wc = ''
  END IF
###GENGRE###  LET g_str = g_sma.sma116,";",tm.b,";",tm.d,";",
###GENGRE###              tm.wc,";",tm.a,";",tm.c,";",tm.e  #FUN-740057 add tm.a,tm.c  #FUN-A80089 add tm.e
###GENGRE###  CALL cl_prt_cs3('axmg551','axmr551',g_sql,g_str)
    CALL axmg551_grdata()    ###GENGRE###
  #------------------------------ CR (4) ------------------------------#
  #end FUN-710080 add
 
END FUNCTION
 
{
FUNCTION ocf_c(str)
  DEFINE str	LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(30)
  # 把麥頭內'PPPPPP'字串改為 P/O NO (ofa.ofa10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO (ofa.ofa45)
  # 把麥頭內'DDDDDD'字串改為 CTN NO (ofa.ofa46)
  FOR i=1 TO 20
     LET j=i+5
     IF str[i,j]='PPPPPP' THEN LET str[i,30]=g_po_no   RETURN str END IF
     IF str[i,j]='CCCCCC' THEN LET str[i,30]=g_ctn_no1 RETURN str END IF
     IF str[i,j]='DDDDDD' THEN LET str[i,30]=g_ctn_no2 RETURN str END IF
  END FOR
  RETURN str
END FUNCTION
 
REPORT axmg551_rep(ofa, ofb, sr)
  DEFINE head1,head2,head3    LIKE type_file.chr1000   # No.FUN-680137 VARCHAR(120)
  DEFINE l_last_sw,sw_first   LIKE type_file.chr1      # No.FUN-680137 VARCHAR(1)
  DEFINE l_str1,l_str2	      LIKE type_file.chr1000   # No.FUN-680137 VARCHAR(80)
  DEFINE l_ima02              LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(30)
  DEFINE l_ima021             LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(30)
  DEFINE t_ofb12              LIKE ofb_file.ofb12
  DEFINE t_ofb14              LIKE ofb_file.ofb14
  DEFINE l_ofb05              LIKE ofb_file.ofb05
  DEFINE l_ofa23              LIKE ofa_file.ofa23
  DEFINE l_found              LIKE type_file.num5        # No.FUN-680137 SMALLINT
  DEFINE oao	   RECORD LIKE oao_file.*
  DEFINE oaf	   RECORD LIKE oaf_file.*
  DEFINE l_oao     RECORD LIKE oao_file.*
  DEFINE ofa       RECORD LIKE ofa_file.*,
         ofb       RECORD LIKE ofb_file.*,
         sr        RECORD
                   occ29  LIKE occ_file.occ29,
                   occ292 LIKE occ_file.occ292,
                   oah02  LIKE oah_file.oah02,
                   oag02  LIKE oag_file.oag02,
                   ima138 LIKE ima_file.ima138
                   END RECORD ,
        l_oga01    LIKE oga_file.oga01  #Add By Snow..021202
#No.FUN-580004-begin
DEFINE   l_str3      LIKE type_file.chr1000,    # No.FUN-680137  VARCHAR(100)
         l_ima906     LIKE ima_file.ima906,
         l_ofb915    STRING,
         l_ofb912    STRING,
         l_ofb12     STRING
  DEFINE t_ofb917     LIKE ofb_file.ofb917
#No.FUN-580004-end
 
  OUTPUT
    TOP MARGIN g_top_margin
    LEFT MARGIN g_left_margin
    BOTTOM MARGIN g_bottom_margin
    PAGE LENGTH g_page_line
  ORDER BY ofa.ofa01,ofb.ofb03
 
#No.FUN-580004-begin
  FORMAT
   PAGE HEADER
      LET l_oao.oao06 = ' '
      LET g_pageno= g_pageno+1
      #表頭
      LET g_title = "I N V O I C E"
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED   #FUN-610072
      PRINT COLUMN 01,g_x[20] CLIPPED,ofa.ofa01,                      #Invoice
            #COLUMN (g_len-14),g_x[21] CLIPPED,ofa.ofa02 USING 'yyyy/mm/dd'#Date #FUN-570250 mark
            COLUMN (g_len-14),g_x[21] CLIPPED,ofa.ofa02  #Date #FUN-570250 add
      PRINT COLUMN 01,g_x[22] CLIPPED,ofa.ofa011,                     #通知單號
            COLUMN (g_len-14),g_x[23] CLIPPED,g_pageno USING '<<<'   #頁次
      PRINT COLUMN ((g_len-FGL_WIDTH(g_title))/2+1),g_title                  #表名
      PRINT COLUMN ((g_len-FGL_WIDTH(g_title))/2+1),g_x[11] CLIPPED
      IF g_pageno>1 THEN
         #FUN-5A0181 mark
         #PRINTX name=H1 g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
         #      g_x[45],g_x[46]
         #PRINTX name=H2 g_x[47],g_x[48]
         #FUN-5A0181 add
         PRINTX name = H1 g_x[37],g_x[39],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
         PRINTX name = H2 g_x[48],g_x[38],g_x[40]
         PRINTX name = H3 g_x[49],g_x[47]
         PRINTX name = H4 g_x[50],g_x[51]   #FUN-690032 add
         #FUN-5A0181 end
         PRINT g_dash1
      ELSE
         #SKIP 4 LINE   #FUN-690032
         SKIP 5 LINE    #FUN-690032
      END IF
 
   BEFORE GROUP OF ofa.ofa01 #Invoice
     #不同單號跳頁
     SKIP TO TOP OF PAGE
     LET t_ofb12 = 0
     LET t_ofb917= 0  #No.FUN-580004
     LET t_ofb14 = 0
 
     IF g_pageno=1 THEN
        #若業務為空白,則填入RECEIVING CENTER
       #IF cl_null(sr.occ29) THEN
       #   LET sr.occ29 = 'RECEIVING CENTER'
       #ELSE
        #   LET sr.occ29=sr.occ29 CLIPPED,g_x[4] CLIPPED,sr.occ292 CLIPPED   #MOD-530071
       #END IF
 
        #表頭下面一點 bill to
 
         #MOD-530071
        #FUN-5A0143 61->45
        #帳款                                     送貨
        PRINT COLUMN 01,g_x[26] CLIPPED    ,COLUMN 45,g_x[27] CLIPPED
        PRINT COLUMN 01,ofa.ofa0351 CLIPPED,COLUMN 45,ofa.ofa0451 CLIPPED          #送貨客戶全名
        PRINT COLUMN 01,ofa.ofa0352 CLIPPED,COLUMN 45,ofa.ofa0452 CLIPPED
        PRINT COLUMN 01,ofa.ofa0353 CLIPPED,COLUMN 45,ofa.ofa0453 CLIPPED
        PRINT COLUMN 01,ofa.ofa0354 CLIPPED,COLUMN 45,ofa.ofa0454 CLIPPED
        PRINT COLUMN 01,ofa.ofa0355 CLIPPED,COLUMN 45,ofa.ofa0455 CLIPPED
        PRINT g_x[28] CLIPPED;
              IF cl_null(sr.occ29) THEN
                 PRINT g_x[29] CLIPPED;           #業務
              ELSE
                 PRINT sr.occ29 CLIPPED,' ',sr.occ292 CLIPPED;  #業務
              END IF
        PRINT COLUMN 45,g_x[28] CLIPPED,COLUMN 54, g_x[29] CLIPPED
         #MOD-530071(end)
        PRINT
 
        #再下面一點 ship to
 
        PRINT COLUMN 01,g_x[30] CLIPPED,
              COLUMN 14,ofa.ofa31 CLIPPED;                     #價格條件
## TQC-5B0126 ##
        PRINT COLUMN 45,g_x[31] CLIPPED,
             # COLUMN 14,ofa.ofa32 CLIPPED,' ',sr.oag02 CLIPPED #付款條件+說明
              COLUMN 54,ofa.ofa32 CLIPPED  #付款條件
        PRINT COLUMN 54,sr.oag02 CLIPPED #說明
##TQC-5B0126 ##
        PRINT #COLUMN 01,g_x[32] CLIPPED,
              #COLUMN 14,l_oao.oao06[1,32] CLIPPED,         #單頭備註第一筆
              COLUMN 45,'COUNTRY OF ORIGIN : TAIWAN.       '
      PRINT g_dash[1,g_len]
       #列印備註
        IF tm.b='Y' THEN
           SELECT oga01 INTO l_oga01 FROM oga_file WHERE oga011=ofa.ofa011
           DECLARE oao_c1 CURSOR FOR
            SELECT * FROM oao_file
  	     WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05='1'
   	    ORDER BY 3
            FOREACH oao_c1 INTO oao.*
            PRINT COLUMN 1,oao.oao06[1,g_len] CLIPPED ## TQC-5B0126 add [1,g_len] CLIPPED##
            END FOREACH
        END IF
        #FUN-5A0143 mark
        #PRINTX name=H1 g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
        #               g_x[45],g_x[46]
        #PRINTX name=H2 g_x[47],g_x[48] 
        #FUN-5A0181 add
        PRINTX name = H1 g_x[37],g_x[39],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
        PRINTX name = H2 g_x[48],g_x[38],g_x[40]
        PRINTX name = H3 g_x[49],g_x[47]
        PRINTX name = H4 g_x[50],g_x[51]   #FUN-690032 add
        #FUN-5A0181 end
        PRINT g_dash1
     END IF
 
     LET l_last_sw='n'
 
   ON EVERY ROW
      #列印備註
      IF tm.b='Y' THEN
         DECLARE oao_c2 CURSOR FOR
          SELECT * FROM oao_file
           WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND oao05='1'
           ORDER BY 3
         FOREACH oao_c2 INTO oao.*
         PRINT COLUMN 06,oao.oao06[1,g_len-6] CLIPPED ## TQC-5B0126 add [1,g_len-6] CLIPPED##
         END FOREACH
      END IF
 
      CASE WHEN ofa.ofa71='1' LET ofb.ofb11=NULL
           WHEN ofa.ofa71='2' LET ofb.ofb04=ofb.ofb11 LET ofb.ofb11=NULL
      END CASE
 
      SELECT oea10 INTO ofa.ofa10 FROM oea_file WHERE oea01=ofb.ofb31
#FUN-4C0096 add
     SELECT azi03,azi04,azi05
       INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取
       FROM azi_file
      WHERE azi01=ofa.ofa23
 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=ofb.ofb04
      LET l_str3 = ""
      IF g_sma.sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(ofb.ofb915) RETURNING l_ofb915
               LET l_str3 = l_ofb915,ofb.ofb913 CLIPPED
               IF cl_null(ofb.ofb915) OR ofb.ofb915 = 0 THEN
                  CALL cl_remove_zero(ofb.ofb912) RETURNING l_ofb912
                  LET l_str3 = l_ofb912,ofb.ofb910 CLIPPED
               ELSE
                  IF NOT cl_null(ofb.ofb912) AND ofb.ofb912 > 0 THEN
                     CALL cl_remove_zero(ofb.ofb912) RETURNING l_ofb912
                     LET l_str3 = l_str3 CLIPPED,',',l_ofb912,ofb.ofb910 CLIPPED
                  END IF
               END IF
            WHEN "3"
               IF NOT cl_null(ofb.ofb915) AND ofb.ofb915 > 0 THEN
                   CALL cl_remove_zero(ofb.ofb915) RETURNING l_ofb915
                   LET l_str3 = l_ofb915 , ofb.ofb913 CLIPPED
               END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[23]' THEN     #No.FUN-610076
           #IF ofb.ofb910 <> ofb.ofb916 THEN  #No.TQC-6B0137 mark
            IF ofb.ofb05  <> ofb.ofb916 THEN  #NO.TQC-6B0137 mod
               CALL cl_remove_zero(ofb.ofb12) RETURNING l_ofb12
               LET l_str3 = l_str3 CLIPPED,"(",l_ofb12,ofb.ofb05 CLIPPED,")"
            END IF
      END IF
      #FUN-5A0143 mark
      #PRINTX name=D1 COLUMN g_c[37],ofb.ofb03 USING '####',
      #     COLUMN g_c[38],ofb.ofb04[1,20] CLIPPED,
      #     COLUMN g_c[39],ofa.ofa10 CLIPPED,
      #     COLUMN g_c[40],l_str3 CLIPPED,
      #     COLUMN g_c[41],ofb.ofb05 CLIPPED,
      #     COLUMN g_c[42],cl_numfor(ofb.ofb12,42,3),
      #     COLUMN g_c[43],ofb.ofb916 CLIPPED,
      #     COLUMN g_c[44],cl_numfor(ofb.ofb917,44,3),
      #     COLUMN g_c[45],cl_numfor(ofb.ofb13,45,t_azi03),
      #     COLUMN g_c[46],cl_numfor(ofb.ofb14,46,t_azi04)
      #FUN-5A0143 add
      PRINTX name = D1 COLUMN g_c[37],ofb.ofb03 USING '####',
                       COLUMN g_c[39],ofa.ofa10 CLIPPED,
                       COLUMN g_c[41],ofb.ofb05 CLIPPED,
                       COLUMN g_c[42],cl_numfor(ofb.ofb12,42,3), #FUN-5A0181 add
                       COLUMN g_c[43],ofb.ofb916 CLIPPED,        #FUN-5A0181 add
                       COLUMN g_c[44],cl_numfor(ofb.ofb917,44,3),
                       COLUMN g_c[45],cl_numfor(ofb.ofb13,45,t_azi03),
                       COLUMN g_c[46],cl_numfor(ofb.ofb14,46,t_azi04)
      #FUN-5A0143 end
     #FUN-690032 remark--begin
      #IF NOT cl_null(ofb.ofb11) THEN
      #   PRINT COLUMN 06,ofb.ofb11 CLIPPED                   #客戶料號
      #END IF
     #FUN-690032 reamrk--end
      #FNU-5A0143 add
      PRINTX name = D2 COLUMN g_c[48],'',
                       #COLUMN g_c[38],ofb.ofb04[1,20] CLIPPED,
                       COLUMN g_c[38],ofb.ofb04 CLIPPED, #NO.FUN-5B0015
                       COLUMN g_c[40],l_str3 CLIPPED
      #FUN-5A0143 end
      PRINTX name=D3 COLUMN g_c[47],ofb.ofb06 CLIPPED; #FUN-5A0143 D2->D3
      IF ofa.ofa72='Y' AND sr.ima138 IS NOT NULL THEN
         PRINT COLUMN g_c[49],"FCC#:",sr.ima138 CLIPPED
      ELSE PRINT
      END IF
      PRINTX name=D4 COLUMN g_c[51],ofb.ofb11 CLIPPED #FUN-690032 add
 
      LET t_ofb12 = t_ofb12 + ofb.ofb12
      LET t_ofb917= t_ofb917+ ofb.ofb917  #No.FUN-580004
      LET t_ofb14 = t_ofb14 + ofb.ofb14
      LET l_ofb05 = ofb.ofb05
      LET l_ofa23 = ofa.ofa23
 
      #列印備註
      IF tm.b='Y' THEN
         DECLARE oao_c3 CURSOR FOR
          SELECT * FROM oao_file
           WHERE oao01=l_oga01   AND oao03=ofb.ofb03 AND oao05='2'
           ORDER BY 3
         FOREACH oao_c3 INTO oao.*
            PRINT COLUMN 06,oao.oao06[1,g_len-6] CLIPPED ## TQC-5B0126 add [1,g_len-6] CLIPPED##
         END FOREACH
      END IF
 
   AFTER GROUP OF ofa.ofa01  #Invoice
     PRINT g_dash2[1,g_len]
     PRINTX name=S1 COLUMN g_c[41],g_x[33] CLIPPED,
           COLUMN g_c[42],cl_numfor(t_ofb12,42,3),   #Qty
           COLUMN g_c[43],g_x[33] CLIPPED,
           COLUMN g_c[44],cl_numfor(t_ofb917,42,3),
           COLUMN g_c[45],l_ofa23 CLIPPED,                #幣別
           COLUMN g_c[46],cl_numfor(t_ofb14,46,t_azi05)   #Amount
     PRINT
     PRINT
     CALL cl_say(t_ofb14,80) RETURNING l_str1,l_str2
     SELECT azi02 INTO g_azi02 FROM azi_file WHERE azi01=ofa.ofa23
     IF SQLCA.SQLCODE THEN LET g_azi02='  ' END IF
     PRINT 'Say Total ',ofa.ofa23 CLIPPED,
                        l_str1 CLIPPED,l_str2 CLIPPED,z
     #列印備註
     IF tm.b='Y' THEN
        DECLARE oao_c4 CURSOR FOR
         SELECT * FROM oao_file
          WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05='2'
          ORDER BY 3
        FOREACH oao_c4 INTO oao.* PRINT COLUMN 1,oao.oao06 END FOREACH
     END IF
     PRINT
     DECLARE oaf_c CURSOR FOR
        SELECT * FROM oaf_file
         WHERE (oaf01=ofa.ofa741 OR oaf01=ofa.ofa742 OR oaf01=ofa.ofa743)
         ORDER BY 1,2
     FOREACH oaf_c INTO oaf.*
        PRINT oaf.oaf03
     END FOREACH
     LET l_last_sw='y'
#No.FUN-580004-end
 
     LET g_pageno=0
 
   PAGE TRAILER
      PRINT
    ## TQC-5B0126 ##
      PRINT COLUMN (g_len-FGL_WIDTH(g_zo12)-7) ,g_zo12 #FUN-5A0143 61->49
      #PRINT COLUMN 49 ,g_zo12 #FUN-5A0143 61->49
    ## TQC-5B0126 ##
      PRINT
      PRINT
      PRINT COLUMN 49 ,g_x[15] CLIPPED #FUN-5A0143 61->49
      PRINT
      PRINT COLUMN 49 ,g_x[34] CLIPPED #FUN-5A0143 61->49
      PRINT
      PRINT
    # PRINT COLUMN 6,g_x[16],g_x[17] CLIPPED
## FUN-550127
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[36]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[36]
             PRINT g_memo
      END IF
## END FUN-550127
 
END REPORT
#Patch....NO.TQC-610037 <003,004> #
}

###GENGRE###START
FUNCTION axmg551_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg551")
        IF handler IS NOT NULL THEN
            START REPORT axmg551_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY ofa01,ofb03"
          
            DECLARE axmg551_datacur1 CURSOR FROM l_sql
            FOREACH axmg551_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg551_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg551_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg551_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE l_lineno           LIKE type_file.num5
    #FUN-B40087  ADD --------STR -----
    DEFINE l_occ29_occ292     STRING 
    DEFINE l_say_total        STRING   
    DEFINE l_data_qty         LIKE ofb_file.ofb12
    DEFINE l_data_unit        LIKE ofb_file.ofb05
    DEFINE l_sum_data_qty     LIKE ofb_file.ofb12
    DEFINE l_sum_data_unit    LIKE ofb_file.ofb05
    DEFINE l_sql              STRING
    DEFINE l_sum_ofb14        LIKE ofb_file.ofb14
    DEFINE l_display          LIKE sma_file.sma116
    DEFINE l_ofb13_fmt        STRING
    DEFINE l_ofb14_fmt        STRING
    DEFINE l_ofb12_fmt        STRING
    #FUN-B40087  ADD --------END -----    
    DEFINE l_ofa23          STRING  #CHI-D30011 add

    ORDER EXTERNAL BY sr1.ofa01,sr1.ofb03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ofa01
            LET l_lineno = 0
            #FUN-B40087  ADD --------STR -----
            LET l_ofb12_fmt = cl_gr_numfmt('ofb_file','ofb12',sr1.azi05)
            LET l_ofb13_fmt = cl_gr_numfmt('ofb_file','ofb13',sr1.azi03)
            LET l_ofb14_fmt = cl_gr_numfmt('ofb_file','ofb14',sr1.azi04)
            PRINTX l_ofb12_fmt
            PRINTX l_ofb13_fmt
            PRINTX l_ofb14_fmt
            LET l_display = g_sma.sma116
            PRINTX l_display
            IF NOT cl_null(sr1.occ29) AND NOT cl_null(sr1.occ292) THEN 
               LET l_occ29_occ292 = sr1.occ29,' ',sr1.occ292
            ELSE 
               IF NOT cl_null(sr1.occ29) AND cl_null(sr1.occ292) THEN
                  LET l_occ29_occ292 = sr1.occ29
               END IF
               IF cl_null(sr1.occ29) AND NOT cl_null(sr1.occ292) THEN
                  LET l_occ29_occ292 = sr1.occ292
               END IF
               IF cl_null(sr1.occ29) AND cl_null(sr1.occ292) THEN
                  LET l_occ29_occ292 = "Receving Cente:"
               END IF
            END IF
            PRINTX l_occ29_occ292

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = 0 AND oao05='1'"
            START REPORT axmg551_subrep01
            DECLARE axmg551_repcur1 CURSOR FROM l_sql
            FOREACH axmg551_repcur1 INTO sr2.*
                OUTPUT TO REPORT axmg551_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg551_subrep01
            #FUN-B40087  ADD --------END -----
        BEFORE GROUP OF sr1.ofb03

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B40087  ADD --------STR -----
            IF NOT cl_null(sr1.ima138) THEN
               LET sr1.ima138 = "FCC#:",sr1.ima138
            ELSE
               LET sr1.ima138 = " "
            END IF
            IF g_sma.sma116 == 0 OR g_sma.sma116 ==1 THEN
               LET l_data_qty = sr1.ofb12
               LET l_data_unit = sr1.ofb05
            ELSE 
               LET l_data_qty = sr1.ofb917
               LET l_data_unit = sr1.ofb916
            END IF 
            PRINTX l_data_qty
            PRINTX l_data_unit
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = ",sr1.ofb03 CLIPPED, 
                        " AND oao05= '1'"
            START REPORT axmg551_subrep02
            DECLARE axmg551_repcur2 CURSOR FROM l_sql
            FOREACH axmg551_repcur2 INTO sr2.*
                OUTPUT TO REPORT axmg551_subrep02(sr2.*)
            END FOREACH
            FINISH REPORT axmg551_subrep02
          
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE imc04 = '",sr1.ofb04 CLIPPED,"'",
                        " AND imc02 = '",sr1.ofb07 CLIPPED,"'"
            START REPORT axmg551_subrep06
            DECLARE axmg551_repcur6 CURSOR FROM l_sql
            FOREACH axmg551_repcur6 INTO sr4.*
                OUTPUT TO REPORT axmg551_subrep06(sr4.*)
            END FOREACH
            FINISH REPORT axmg551_subrep06
            PRINTX sr1.*

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = ",sr1.ofb03 CLIPPED, 
                        " AND oao05= '2'"
            START REPORT axmg551_subrep03
            DECLARE axmg551_repcur3 CURSOR FROM l_sql
            FOREACH axmg551_repcur3 INTO sr2.*
                OUTPUT TO REPORT axmg551_subrep03(sr2.*)
            END FOREACH
            FINISH REPORT axmg551_subrep03
            #FUN-B40087  ADD --------END -----

        AFTER GROUP OF sr1.ofa01
           #FUN-B40087  ADD --------STR -----
           #CHI-D30011---add---S
           LET l_ofa23 = sr1.ofa23
           IF l_ofa23 <> "USD" THEN
              LET l_ofa23 = l_ofa23
           ELSE
              LET l_ofa23 = "US DOLLARS"
           END IF
           #CHI-D30011---add---E
           IF cl_null(sr1.str1) AND cl_null(sr1.str2) THEN
             #LET l_say_total = "Say Total",sr1.ofa23 #CHI-D30011 mark
              LET l_say_total = "Say Total",l_ofa23   #CHI-D30011
           ELSE 
              IF cl_null(sr1.str1) AND NOT cl_null(sr1.str2) THEN
                #LET l_say_total = "Say Total",sr1.ofa23,' ',sr1.str2 #CHI-D30011 mark
                 LET l_say_total = "Say Total",l_ofa23,' ',sr1.str2   #CHI-D30011
              ELSE IF NOT cl_null(sr1.str1) AND cl_null(sr1.str2) THEN 
                     #LET l_say_total = "Say Total",sr1.ofa23,' ',sr1.str1 #CHI-D30011 mark                
                      LET l_say_total = "Say Total",l_ofa23,' ',sr1.str1   #CHI-D30011                
                  ELSE 
                    #LET l_say_total = "Say Total",sr1.ofa23,' ',sr1.str1,' ',sr1.str2 #CHI-D30011 mark
                     LET l_say_total = "Say Total",l_ofa23,' ',sr1.str1,' ',sr1.str2   #CHI-D30011
                  END IF
               END IF
           END IF 
           IF g_sma.sma116 == 0 OR g_sma.sma116 ==1 THEN
              LET l_sum_data_qty = GROUP SUM(sr1.ofb12)
              LET l_sum_data_unit = GROUP SUM(sr1.ofb05)
           ELSE
               LET l_sum_data_qty = GROUP SUM(sr1.ofb917)
               LET l_sum_data_unit = GROUP SUM(sr1.ofb916)
           END IF
           LET l_sum_ofb14 = GROUP SUM(sr1.ofb14)
           PRINTX l_sum_ofb14
           PRINTX l_sum_data_qty
           PRINTX l_sum_data_unit 
           PRINTX l_say_total
          
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = 0",
                        " AND oao05 = '2'"
            START REPORT axmg551_subrep04
            DECLARE axmg551_repcur4 CURSOR FROM l_sql
            FOREACH axmg551_repcur4 INTO sr2.*
                OUTPUT TO REPORT axmg551_subrep04(sr2.*)
            END FOREACH
            FINISH REPORT axmg551_subrep04

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE ofa01 = '",sr1.ofa01,"'"
            START REPORT axmg551_subrep05
            DECLARE axmg551_repcur5 CURSOR FROM l_sql
            FOREACH axmg551_repcur5 INTO sr3.*
                OUTPUT TO REPORT axmg551_subrep05(sr3.*)
            END FOREACH
            FINISH REPORT axmg551_subrep05
            #FUN-B40087  ADD --------END -----
 
        AFTER GROUP OF sr1.ofb03

        
        ON LAST ROW

END REPORT
#FUN-B40087  ADD --------STR -----
REPORT axmg551_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg551_subrep02(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg551_subrep03(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg551_subrep04(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg551_subrep05(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axmg551_subrep06(sr4)
    DEFINE sr4 sr4_t

    FORMAT
        ON EVERY ROW
            PRINTX sr4.*
END REPORT
#FUN-B40087  ADD --------END -----
###GENGRE###END
