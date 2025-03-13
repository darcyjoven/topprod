# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: aoou702.4gl
# Descriptions...: 單據編號未扣帳未確認檢查表 
# Date & Author..: 98/04/07 By Andersen 
# Modify.........: 98/04/07 By Andersen -報表格式
# Modify.........: MOD-470498(9790) 04/07/22 By Carol ASF系統add資料輸入員欄位
# Modify.........: MOD-480243 04/08/10 By Nicola 起始日期不能大於截止日期    
# Modify.........: MOD-4C0007 04/12/07 By Nicola 單據為作廢時仍印出"未確認"  
# Modify.........: No.FUN-510027 05/02/14 By pengu 報表轉XML
# Modify.........: No.MOD-530403 05/03/28 By pengu 修改g_sql
# Modify.........: No.FUN-550058 05/05/28 By vivien 單據編號格式放大  
# Modify.........: No.MOD-560065 05/06/14 By pengu  檢查品管系統只有FQC及PQC,少了IQC. 
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5A0001 05/10/26 By Rosayu SQL.dbo.qcs01[1,3]=smyslip-->qcs01 like trim(smy_file.smyslip)||'-%'
# Modify.........: No.FUN-610020 06/01/09 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.MOD-640235 06/04/11 By pengu 列印時,選擇不將作廢單據印出,但系統還是會將已作廢的銷退單印出
# Modify.........: No.MOD-640506 06/04/19 By Claire pna05 != 'X' 挑選
# Modify.........: No.TQC-660061 06/06/14 By Joe 修正條件判斷錯誤
# Modify.........: No.TQC-660078 06/06/16 By Claire "AND 前少一個空白
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660134 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.MOD-660134 06/06/30 By Claire l_unconf長度在unicode區會造成'未確認'只印出'未確'
# Modify.........: No.FUN-670030 06/08/11 By Claire APM&AXM 未發出單據要由未入庫顯示為未發出
# Modify.........: No.FUN-680102 06/09/19 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0023 06/11/15 By baogui 制表日期未顯示
# Modify.........: No.MOD-6B0044 06/11/23 By Claire AXM中判斷oep_file時.及APMl中pna_file應該加說明為變更單
# Modify.........: No.MOD-6A0133 06/12/12 By Carol  AXM中判斷oep_file時.應該加判斷oep09 <> '2'
# Modify.........: No.FUN-710080 07/01/30 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.MOD-720014 07/03/08 By Smapmin AAP中判斷ala_file時,應該加判斷作廢列印否 
# Modify.........: No.TQC-720033 07/03/08 By Smampin 作廢碼與確認碼由不同欄位記錄時,應將狀態全顯示出來
# Modify.........: No.TQC-6C0215 07/03/30 By pengu 修改列出已作廢數據的SQL語法
# Modify.........: No.MOD-760147 07/06/29 By Carol 修改不列出已作廢數據的SQL語法(imm_file,oha_file)
# Modify.........: No.MOD-770002 07/07/03 By Carol 調整sfu_file,sfk_file,ksc_file SQL對確認碼的檢查
# Modify.........: No.TQC-770120 07/07/25 By Sarah 執行後出現"prepare: 通用字元匹配無法用於非字元類型."錯誤訊息
# Modify.........: No.MOD-770137 07/07/27 By Carol 調整MOD-770002 SQL條件 
# Modify.........: No.TQC-780031 07/08/30 By rainy 未勾選"列印已作廢單據"確印出已作廢的倉庫調撥單
# Modify.........: No.CHI-770003 07/09/14 By kim imm04的列印處理
# Modify.........: No.TQC-790110 07/09/26 By Smapmin 修改oma_file條件
# Modify.........: No.MOD-7B0256 07/12/05 By Pengu 已確認未過帳的發料單無法印出
# Modify.........: No.MOD-850113 08/05/12 By Sarah 將g03放大至50碼
# Modify.........: No.MOD-850119 08/05/12 By Sarah 抓取pna_file段,sr.g03後要加上"變更單"(aoo-310)
# Modify.........: No.MOD-870110 08/07/11 By Sarah 抓取oha_file段,選擇不印作廢單據,但仍印出
# Modify.........: No.MOD-8A0022 08/10/02 By alexstar 原處理邏輯會遺漏已確認未扣帳的資料,需修正
# Modify.........: No.FUN-870078 08/12/08 By jan 增加"固資系統"的處理
# Modify.........: No.MOD-910245 09/02/04 By Sarah 組oep_file段SQL時,當tm.y為'Y'時應過濾oepconf!='Y',當tm.y不為'Y'時應過濾oepconf='N'
# Modify.........: No.MOD-920150 09/02/12 By Sarah AXR系統抓ooa_file時SQL應區分ooa00,
#                                                  當ooa00='1'時維持原抓法,當ooa00='2'時應多串oma_file,且需判斷omaconf與omavoid
# Modify.........: No.FUN-930013 09/03/04 By jan 變更單未發出的，打印時打印"H:變更未發出"
# Modify.........: No.FUN-930012 09/03/04 By jan 將imr_file的檢查邏輯納入"AIM"系統的檢查項目之一
# Modify.........: No.MOD-940417 09/05/21 By Pengu 未確認供單無法被呈現
# Modify.........: No.MOD-960036 09/06/08 By mike 因目前g_x[23]己抓不到值,故改抓p_ze的資料.
# Modify.........: No.MOD-960268 09/06/24 By mike 將抓nnk_file的SQL加上nnkacti='Y'的條件   
# Modify.........: No.MOD-970276 09/07/30 By Dido 增加過濾訂單變更已作廢資料邏輯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990071 09/09/08 By Dido 增加借貨出貨單
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:MOD-A10115 10/01/19 By Sarah 修改MOD-920150,g_sql使用UNION會有錯,改成分兩段寫入報表
# Modify.........: No.FUN-970092 10/02/22 By vealxu 生管系統未包含報工單據
# Modify.........: No:MOD-A30044 10/03/14 By Dido nni_file 增加 nniacti = 'Y' 
# Modify.........: No.TQC-A60046 10/06/13 By chenmoyan PREPARE u702_p661 FROM g_sql時，g_sql中的OUTER MSV不認，改用標準LEFT OUTER JOIN的寫法
# Modify.........: No:CHI-A80005 10/08/12 By Summer 報表增加使用者名稱與部門簡稱
# Modify.........: No:MOD-A80237 10/08/30 By Summer sr.g03應改成ze訊息後再顯示 
# Modify.........: No:CHI-A90031 10/10/14 By Summer 增加tm.more(其他特殊列印條件) 
# Modify.........: No.TQC-AC0356 10/12/24 By zhangll 修正sql语句
# Modify.........: No:MOD-B20110 11/02/22 By sabrina 修改sql語法
# Modify.........: No:MOD-B20139 11/02/24 By sabrina 修改u702_p41的sql語法 
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 
# Modify.........: No:MOD-B40168 11/04/19 By Dido 預購支付與預購修改支付增加支付金額 > 0 才需檢核
# Modify.........: No:FUN-A70095 11/06/10 By lixh1 增加對報工單據未扣帳未確認檢查 
# Modify.........: No:CHI-B80056 11/09/02 By johung AXM模組增加代採買出貨單
# Modify.........: No:MOD-B90001 11/09/02 By johung 單據名稱欄位長度加大
# Modify.........: No:TQC-B90218 11/09/28 By lixh1 生產報工單已經確認,但是卻都列印出來
# Modify.........: No.FUN-BA0003 11/10/06 By pauline 增加alm/art模組
# Modify.........: No:MOD-BA0063 11/10/08 By suncx 已確認的單據不需抓取
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:MOD-C40019 12/04/03 By Summer u702_c13的欄位數錯誤  
# Modify.........: No:MOD-C40073 12/04/11 By Elise 調整為UNION ALL分開抓資料,qcs00 NOT IN ('5','6')的抓smy_file,qcs00  IN ('5','6')抓oay_file
# Modify.........: No:FUN-C50077 12/06/15 bY Bart 增加apmt900資料
# Modify.........: NO.MOD-C70235 12/07/25 BY Vampire 請將UNION ALL兩段SQL分開,都要加上判斷已作廢單據
# Modify.........: NO.CHI-CB0044 12/12/11 By Lori 排除設定為無效的單據
# Modify.........: NO.MOD-CB0172 12/11/20 By jt_chen 修正MOD-960268的修改錯誤
# Modify.........: NO.FUN-C50039 13/01/30 BY Lori 勾選AAP系統時，增加aapt900單據資料處理內容
# Modify.........: No:FUN-D30097 13/04/01 By Sakura 訂金退回單據優化,將 rxacrat 改成 rxa09(單據日期)
# Modify.........: No:MOD-D60213 13/06/27 By fengmy 過濾與庫存異動無關的單據

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD 
            a        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  AIM 庫存系統
            b        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  APM 採購系統
            c        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  AXM 銷售系統
            d        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  ASF 生產系統
            e        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  AAP 應付系統
            f        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  ANM 票據系統 
            g        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  AXR 應收系統
            h        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  AQC 品管系統
            i        LIKE type_file.chr1,     #No.FUN-870078 VARCHAR(1),     
            j        LIKE type_file.chr1,     #No.FUN-BA0003 VARCHAR(1),          #  ART 流通零售系統
            k        LIKE type_file.chr1,     #No.FUN-BA0003 VARCHAR(1),          #  ART 流通零售系統
            bdate    LIKE type_file.dat,      #No.FUN-680102 DATE,             
            edate    LIKE type_file.dat,      #No.FUN-680102 DATE,
            y        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),          #  列印作廢否
            x        LIKE type_file.chr1,     #MOD-D60213 
            z        LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1)           #  依系統跳頁否 #CHI-A90031 add ,
            more     LIKE type_file.chr1      #CHI-A90031 add                  # Input more condition(Y/N)
           END RECORD
DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-680102 SMALLINT
DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680102 INTEGER   
DEFINE g_i           LIKE type_file.num5     #No.FUN-680102 SMALLINT   #count/index for any purpose
DEFINE g_head1       STRING
DEFINE l_table       STRING                   #FUN-710080 add
DEFINE g_sql         STRING                   #FUN-710080 add
DEFINE g_str         STRING                   #FUN-710080 add
define g_tiptop      like type_file.chr1      #darcy:2023/05/08 add
 
MAIN
    OPTIONS
        INPUT NO WRAP
        DEFER INTERRUPT
 
   #CHI-A90031 程式搬移 --start--
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.a = ARG_VAL(7)
   LET tm.b  = ARG_VAL(8) #CHI-A90031 mod 08->8
   LET tm.c  = ARG_VAL(9) #CHI-A90031 mod 09->9
   LET tm.d  = ARG_VAL(10)
   LET tm.e  = ARG_VAL(11)
   LET tm.f  = ARG_VAL(12)
   LET tm.g  = ARG_VAL(13)
   LET tm.h  = ARG_VAL(14)
  #CHI-A90031 mod --start--
#FUN-BA0003 mark START
#   LET tm.i = ARG_VAL(15)        #No.FUN-870078
#   LET tm.bdate  = ARG_VAL(16)
#   LET tm.edate = ARG_VAL(17)
#   LET tm.y  = ARG_VAL(18)
#   LET tm.z  = ARG_VAL(19)
#   LET g_rep_user = ARG_VAL(20)
#   LET g_rep_clas = ARG_VAL(21)
#   LET g_template = ARG_VAL(22)
#   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
#FUN-BA0003 mark END
#FUN-BA0003 add START
   LET tm.j      = ARG_VAL(16)
   LET tm.k      = ARG_VAL(17)
   LET tm.bdate  = ARG_VAL(18)
   LET tm.edate = ARG_VAL(19)
   #MOD-D60213--begin
#   LET tm.y  = ARG_VAL(20)
#   LET tm.z  = ARG_VAL(21)
#   LET g_rep_user = ARG_VAL(22)
#   LET g_rep_clas = ARG_VAL(23)
#   LET g_template = ARG_VAL(24)
#   LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
   
   LET tm.y  = ARG_VAL(20)
   LET tm.x  = ARG_VAL(21)
   LET tm.z  = ARG_VAL(22)
   LET g_rep_user = ARG_VAL(23)
   LET g_rep_clas = ARG_VAL(24)
   LET g_template = ARG_VAL(25)
   LET g_rpt_name = ARG_VAL(26)  #No.FUN-7C0078
   let g_tiptop = ARG_VAL(27)   #darcy:2023/05/08 add
   #MOD-D60213--end
#FUN-BA0003 add END
  #CHI-A90031 mod --end--
   LET g_rlang = g_lang
   LET  g_pdate   = g_today     #TQC-6B0023
   #CHI-A90031 程式搬移 --end--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 #FUN-BB0047 mark 

   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "g01.type_file.chr3,",
               "g02.sfb_file.sfb01,", 
               "g10.gee_file.gee05,", #darcy:2023/12/04 add
#              "g03.type_file.chr50,",   #MOD-850113 mod chr20->chr50   #MOD-B90001 mark
               "g03.smy_file.smydesc,",  #MOD-B90001
               "g04.type_file.dat,",
               "g05.type_file.dat,",
               "g06.type_file.chr1,",
               "g07.type_file.chr1,",
               "g08.type_file.chr20,", #CHI-A80005 mod
               "zx02.zx_file.zx02,",   #CHI-A80005 add
               "g09.type_file.chr20,", #CHI-A80005 add
               "gem02.gem_file.gem02"  #CHI-A80005 add
 
   LET l_table = cl_prt_temptable('aoou702',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)" #CHI-A80005 add ?,?,? #darcy:2023/12/04 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
#CHI-A90031 程式搬移 mark --start--
#  LET p_row = 5 LET p_col = 32
#  OPEN WINDOW aoou702_w AT p_row,p_col WITH FORM "aoo/42f/aoou702"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#  CALL cl_ui_init()
#
#  CALL cl_opmsg('z')
#
#  LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
#  LET g_towhom = ARG_VAL(2)
#  LET g_rlang = ARG_VAL(3)
#  LET g_bgjob = ARG_VAL(4)
#  LET g_prtway = ARG_VAL(5)
#  LET g_copies = ARG_VAL(6)
#  LET tm.a = ARG_VAL(7)
#  LET tm.b  = ARG_VAL(08)
#  LET tm.c  = ARG_VAL(09)
#  LET tm.d  = ARG_VAL(10)
#  LET tm.e  = ARG_VAL(11)
#  LET tm.f  = ARG_VAL(12)
#  LET tm.g  = ARG_VAL(13)
#  LET tm.h  = ARG_VAL(14)
#  LET tm.bdate  = ARG_VAL(15)
#  LET tm.edate = ARG_VAL(16)
#  LET tm.y  = ARG_VAL(17)
#  LET tm.z  = ARG_VAL(18)
#  LET g_rep_user = ARG_VAL(19)
#  LET g_rep_clas = ARG_VAL(20)
#  LET g_template = ARG_VAL(21)
#  LET g_rpt_name = ARG_VAL(22)  #No.FUN-7C0078
#  LET tm.i = ARG_VAL(23)        #No.FUN-870078
#  LET g_rlang = g_lang
#  LET  g_pdate   = g_today     #TQC-6B0023
#CHI-A90031 程式搬移 mark --end--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL u702_tm()		        # Input print condition
      ELSE CALL aoou702()			# Read data and create out-file
   END IF
    CLOSE WINDOW aoou702_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION u702_tm()
   DEFINE   s       LIKE type_file.chr50,    #No.FUN-680102 VARCHAR(35),
            l_cmd   LIKE type_file.chr1000   #No.FUN-680102 VARCHAR(1000)
 
  #CHI-A90031 程式搬移 --start--
   LET p_row = 5 LET p_col = 32
   OPEN WINDOW aoou702_w AT p_row,p_col WITH FORM "aoo/42f/aoou702"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

   CALL cl_opmsg('z')
  #CHI-A90031 程式搬移 --end--
 
 # ------ DEFAULT VALUE --------------
   LET  tm.a        = 'Y'
   LET  tm.b        = 'Y' 
   LET  tm.c        = 'Y' 
   LET  tm.d        = 'Y'
   LET  tm.e        = 'Y' 
   LET  tm.f        = 'Y' 
   LET  tm.g        = 'Y' 
   LET  tm.h        = 'Y' 
   LET  tm.i        = 'Y'   #FUN-870078
   LET  tm.j        = 'Y'   #FUN-BA0003 add
   LET  tm.k        = 'Y'   #FUN-BA0003 add  
   LET  tm.bdate    = g_today 
   LET  tm.edate    = g_today 
   LET  tm.y        = 'N' 
   LET  tm.x        = 'Y'   #MOD-D60213
   LET  tm.z        = 'Y' 
   LET  tm.more     = 'N'      #CHI-A90031 add
   LET  g_pdate     = g_today  #CHI-A90031 add
   LET  g_rlang     = g_lang   #CHI-A90031 add
   LET  g_bgjob     = 'N'      #CHI-A90031 add
   LET  g_copies    = '1'      #CHI-A90031 add
 
   WHILE TRUE
      INPUT BY NAME tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.g,tm.h,tm.i,tm.j,tm.k,     #FUN-870078       #FUN-BA0003 add tm.j,tm.k
                    tm.bdate,tm.edate,tm.y,tm.x,tm.z,tm.more #CHI-A90031 add tm.more  #MOD-D60213 tm.x
         WITHOUT DEFAULTS 
       ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
 
 
         AFTER FIELD  a  
            IF tm.a NOT MATCHES "[YN]" OR tm.a IS NULL THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD  b 
            IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL THEN
               NEXT FIELD b 
            END IF   
         AFTER FIELD  c 
            IF tm.c NOT MATCHES "[YN]" OR tm.c IS NULL THEN
               NEXT FIELD c 
            END IF   
         AFTER FIELD  d 
            IF tm.d NOT MATCHES "[YN]" OR tm.d IS NULL THEN
               NEXT FIELD d 
            END IF   
         AFTER FIELD  e 
            IF tm.e NOT MATCHES "[YN]" OR tm.e IS NULL THEN
               NEXT FIELD e 
            END IF   
         AFTER FIELD  f 
            IF tm.f NOT MATCHES "[YN]" OR tm.f IS NULL THEN
               NEXT FIELD f 
            END IF   
         AFTER FIELD  g 
            IF tm.g NOT MATCHES "[YN]" OR tm.g IS NULL THEN
               NEXT FIELD g 
            END IF   
 
         AFTER FIELD  h 
            IF tm.h NOT MATCHES "[YN]" OR tm.h IS NULL THEN
               NEXT FIELD h 
            END IF   
 
         AFTER FIELD  i 
            IF tm.i NOT MATCHES "[YN]" OR tm.i IS NULL THEN
               NEXT FIELD i 
            END IF

#FUN-BA0003 add START
         AFTER FIELD j
            IF tm.j NOT MATCHES "[YN]" OR tm.j IS NULL THEN
               NEXT FIELD j
            END IF

         AFTER FIELD k
            IF tm.j NOT MATCHES "[YN]" OR tm.j IS NULL THEN
               NEXT FIELD k
            END IF
#FUN-BA0003 add END
#MOD-D60213--begin
         ON CHANGE x
            IF tm.x NOT MATCHES "[YN]" OR tm.x IS NULL THEN
               NEXT FIELD x
            ELSE 
               LET  tm.e  = 'N' 
               LET  tm.f  = 'N' 
               LET  tm.g  = 'N' 
               LET  tm.h  = 'N' 
               LET  tm.k  = 'N'
               DISPLAY BY NAME tm.e,tm.f,tm.g,tm.h,tm.k
            END IF
#MOD-D60213--end
 
         AFTER FIELD bdate
            IF tm.bdate IS NULL OR tm.bdate = ' ' THEN
               NEXT FIELD bdate
            ELSE
               IF NOT cl_null(tm.edate) THEN
                  IF tm.edate < tm.bdate THEN
                     CALL cl_err(tm.bdate,'agl-031',0)
                     NEXT FIELD bdate
                  END IF
               END IF
            END IF
 
         AFTER FIELD edate
            IF tm.edate IS NULL OR tm.edate = ' ' THEN
               NEXT FIELD edate
            ELSE
               IF tm.edate < tm.bdate THEN
                  CALL cl_err(tm.bdate,'agl-031',0)
                  NEXT FIELD bdate
               END IF
            END IF
 
         AFTER FIELD  y
            IF tm.y NOT MATCHES "[YN]" OR tm.y IS NULL THEN
               NEXT FIELD y 
            END IF   
 
         AFTER FIELD z 
            IF tm.z NOT MATCHES "[YN]" OR tm.z IS NULL THEN
               NEXT FIELD z 
            END IF   
 
         #CHI-A90031 add --start--
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
         #CHI-A90031 add --end--

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
 
      
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 RETURN
      END IF
      CALL cl_wait()
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='aoou702'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aoou702','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                    " '",g_pdate CLIPPED,"'",
                    " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                    " '",g_bgjob CLIPPED,"'",
                    " '",g_prtway CLIPPED,"'",
                    " '",g_copies CLIPPED,"'",
                    " '",tm.a CLIPPED,"'",
                    " '",tm.b CLIPPED,"'",
                    " '",tm.c CLIPPED,"'",
                    " '",tm.d CLIPPED,"'",
                    " '",tm.e CLIPPED,"'",
                    " '",tm.f CLIPPED,"'",
                    " '",tm.g CLIPPED,"'",
                    " '",tm.h CLIPPED,"'",
                    " '",tm.i CLIPPED,"'",                 #No:FUN-870078 #CHI-A90031 mod
                    " '",tm.j CLIPPED,"'",                 #FUN-BA0003 add
                    " '",tm.k CLIPPED,"'",                 #FUN-BA0003 add
                    " '",tm.bdate CLIPPED,"'",
                    " '",tm.edate CLIPPED,"'",
                    " '",tm.y CLIPPED,"'",
                    " '",tm.x CLIPPED,"'",                 #MOD-D60213
                    " '",tm.z CLIPPED,"'",
                    " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                    " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                    " '",g_template CLIPPED,"'",           #No.FUN-570264
                    " '",g_rpt_name CLIPPED,"'"           #No.FUN-7C0078
            CALL cl_cmdat('aoou702',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW aoou702_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aoou702()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aoou702_w
END FUNCTION
 
FUNCTION aoou702()
   DEFINE l_name	LIKE type_file.chr20,    #No.FUN-680102 VARCHAR(20),		# External(Disk) file name
          g_sql 	STRING,		         #RDSQL STATEMENT  #No.FUN-580092 HCN
          l_za05	LIKE za_file.za05,       #No.FUN-680102 VARCHAR(40),
          l_imm10       LIKE imm_file.imm10,
          l_oep09       LIKE oep_file.oep09,
          l_pmm25       LIKE pmm_file.pmm25,
          l_pmk25       LIKE pmk_file.pmk25,
          l_nmd12       LIKE nmd_file.nmd12,
          l_oga09       LIKE oga_file.oga09,
          l_rvaconf     LIKE rva_file.rvaconf,
          l_cnt         LIKE type_file.num5,     #No.FUN-680102 SMALLINT,
          l_msg         LIKE type_file.chr20,    #MOD-850119 add
          sr  RECORD 
                     g01   LIKE type_file.chr3,     #No.FUN-680102 VARCHAR(03),                 #  系統別
                     g02   LIKE sfb_file.sfb01,     #No.FUN-680102 VARCHAR(16),                 #  單據編號  #No.FUN-550058
                     g10   like gee_file.gee05,     #darcy:2023/12/04 add 
                     g03   LIKE smy_file.smydesc,    #No.FUN-680102 VARCHAR(30),                 #  單據名稱  #No.FUN-550058  #MOD-6B0044 20->30  #No.MOD-7B0256 modify
                     g04   LIKE type_file.dat,      #No.FUN-680102 DATE,                     #  單據日期  
                     g05   LIKE type_file.dat,      #No.FUN-680102 DATE,                     #  輸入日期
                     g06   LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),                  #  未確認
                     g07   LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),                  #  未過帳
                     g08   LIKE type_file.chr20,    #No:FUN-680102 CHAR(10)                  #  資料所有者 #CHI-A80005 add ,
                     zx02  LIKE zx_file.zx02,       #資料所有者名稱   #CHI-A80005 add
                     g09   LIKE type_file.chr20,    #資料所有部門     #CHI-A80005 add
                     gem02 LIKE gem_file.gem02      #資料所有部門名稱 #CHI-A80005 add
              END RECORD
   DEFINE l_where,l_where1,l_where2 STRING  #CHI-770003
   DEFINE l_cnt2                    LIKE type_file.num5   #FUN-BA0003 add
   DEFINE g_sql2        STRING #MOD-C70235 add
 
#     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081     #FUN-BA0003 mark
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 # ***************************************
 #     START REPORT   ! 
 # *************************************** 
 
     # *********************************
     # **    庫存系統 (系統別:AIM)    **
     # *********************************   
     IF  tm.a = 'Y'  THEN  
        # ========= (1) ina_file ========== 
        LET g_sql = "SELECT 'AIM',ina01,gee05,smydesc,ina02,ina03,inaconf,inapost,inauser ", #CHI-770003 #darcy:2023/12/04 add gee05
                       " ,zx02,inagrup,gem02 ", #CHI-A80005 add
                    " FROM ina_file LEFT OUTER JOIN smy_file ON ina01 like rtrim(ltrim(smyslip)) || '-%'",
                    " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON inauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON inagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE ina02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND inapost!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND inapost='N' AND inaconf != 'X' " CLIPPED   #TQC-660078 #No.TQC-6C0215 modify   
        END IF
        PREPARE u702_p01 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c01 CURSOR FOR u702_p01
            FOREACH u702_c01 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              IF sr.g06='X' THEN
                 LET sr.g07=' '
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (2) imm_file ========== 
        DROP TABLE u702_aim
        LET g_sql = "SELECT 'AIM' as AA,imm01,gee05,smydesc,imm02,imm12,immconf,imm03,immuser,zx02,immgrup,gem02,imm10 ", #CHI-770003 #CHI-A80005 add ,zx02,immgrup,gem02 #darcy:2023/12/04 add gee05
                       " FROM imm_file,smy_file,zx_file,gem_file,gee_file WHERE 1=2 INTO TEMP u702_aim" #CHI-A80005 add zx_file,gem_file 
        PREPARE u702_aim_ins1 FROM g_sql
        EXECUTE u702_aim_ins1
        IF STATUS THEN
           CALL cl_err('create u702_aim fail!',SQLCA.sqlcode,1)           
        END IF
        LET l_where=" WHERE imm02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"  #No.FUN-550058 
 
        IF tm.y='Y'  THEN
           LET l_where1=" AND imm03 != 'Y' "
           LET l_where2=" AND (imm04 !='Y' OR imm03 !='Y') "
        ELSE
           LET l_where1=" AND (immconf !='X' AND imm03 ='N') " #MOD-8A0022
           LET l_where2=" AND (imm04 ='N' AND  imm03 ='N') "
        END IF
        LET g_sql =    "INSERT INTO u702_aim ",
                       "SELECT 'AIM',imm01,gee05,smydesc,imm02,imm12,immconf,imm03,immuser,zx02,immgrup,gem02,imm10 ", #CHI-770003 #CHI-A80005 add zx02,immgrup,gem02 #darcy:2023/12/04 add gee05
                       " FROM imm_file LEFT OUTER JOIN smy_file ON imm01 like rtrim(ltrim(smyslip)) || '-%'",
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON immuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON immgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       l_where,
                       " AND imm10='1'",
                       l_where1,
                       " AND immacti = 'Y' "          #CHI-CB0044 add
        PREPARE u702_aim_ins2 FROM g_sql
        EXECUTE u702_aim_ins2
        IF STATUS THEN
           CALL cl_err('INSERT INTO u702_aim(1) fail!',SQLCA.sqlcode,1)           
        END IF
                       
        LET g_sql =    "INSERT INTO u702_aim ",
                       " SELECT 'AIM',imm01,gee05,smydesc,imm02,imm12,imm04,imm03,immuser,zx02,immgrup,gem02,imm10 ", #CHI-770003 #CHI-A80005 add zx02,immgrup,gem02 #darcy:2023/12/04 add
                       " FROM imm_file LEFT OUTER JOIN smy_file ON imm01 like rtrim(ltrim(smyslip)) || '-%'", #CHI-770003
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON immuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON immgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       l_where,
                       " AND imm10 IN ('2','3','4')",  
                       l_where2,
                       " AND immacti = 'Y' "         #CHI-CB0044 add
        PREPARE u702_aim_ins3 FROM g_sql
        EXECUTE u702_aim_ins3
        IF STATUS THEN
           CALL cl_err('INSERT INTO u702_aim(2) fail!',SQLCA.sqlcode,1)
        END IF
        
        LET g_sql="SELECT * FROM u702_aim"
        PREPARE u702_p02 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c02 CURSOR FOR u702_p02
        FOREACH u702_c02 INTO sr.*,l_imm10
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) 
             EXIT FOREACH
          END IF
          IF sr.g06='X' THEN
             LET sr.g07=' '
          END IF
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
          EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                    sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
          #------------------------------ CR (3) ------------------------------#
        END FOREACH
        # ========= (3) imo_file ========== #NO:4441
         LET g_sql = "SELECT 'AIM',imo01,gee05,smydesc,imo02,'',imoconf,imopost,imouser,zx02,imogrup,gem02 ",   #No:MOD-4C0007 #CHI-A80005 add zx02,imogrup,gem02
                       " FROM imo_file LEFT OUTER JOIN smy_file ON imo01 like rtrim(ltrim(smyslip)) || '-%' ",
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON imouser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON imogrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE imo02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND imopost!='Y' " CLIPPED #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND imopost='N' AND imoconf != 'X' " CLIPPED   #TQC-660078 #No.TQC-6C0215 modify   
        END IF
        PREPARE u702_p03 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c03 CURSOR FOR u702_p03
            FOREACH u702_c03 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              IF sr.g06='X' THEN
                 LET sr.g07=' '
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (4) imr_file ========== 
         LET g_sql = "SELECT 'AIM',imr01,gee05,smydesc,imr02,'',imrconf,imrpost,imruser,zx02,imrgrup,gem02 ",  #CHI-A80005 add zx02,imrgrup,gem02
                       " FROM imr_file LEFT OUTER JOIN smy_file ON(imr01 like rtrim(ltrim(smy_file.smyslip)) || '-%')",
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON imruser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON imrgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE imr02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND imrpost!='Y' " CLIPPED 
        ELSE
           LET g_sql=g_sql CLIPPED," AND imrpost='N' AND imrconf != 'X' " CLIPPED   
        END IF
        PREPARE u702_p26 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c26 CURSOR FOR u702_p26
            FOREACH u702_c26 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              IF sr.g06='X' THEN
                 LET sr.g07=' '
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
     END IF 
     # *********************************
     # **    採購系統 (系統別:APM)    **
     # *********************************   
     IF  tm.b = 'Y'  THEN  
        # ========= (1) pmk_file ========== 
        IF u702_inv('APM','pmk') THEN #MOD-D60213
           LET g_sql = "SELECT 'APM',pmk01,gee05,smydesc,pmk04,'',pmk18,' ',pmkuser,zx02,pmkgrup,gem02,pmk25 ", #CHI-A80005 add zx02,pmkgrup,gem02
                          " FROM pmk_file LEFT OUTER JOIN smy_file ON pmk01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON pmkuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON pmkgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE pmk04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND pmk25 <> '6' ",   #No.B221 010327 by linda add
                          " AND pmkacti = 'Y' "   #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND pmk18!='Y' " CLIPPED   #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND pmk18='N' " CLIPPED    #TQC-660078
           END IF
           PREPARE u702_p11 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c11 CURSOR FOR u702_p11
               FOREACH u702_c11 INTO sr.*,l_pmk25
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF l_pmk25 ='9' THEN
                    LET sr.g06='X'
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        # ========= (2) pmi_file ==========
        IF u702_inv('APM','pmi') THEN #MOD-D60213 
           LET g_sql = "SELECT 'APM',pmi01,gee05,smydesc,pmi02,'',pmiconf,' ',pmiuser,zx02,pmigrup,gem02 ",   #No.MOD-4C0007 #CHI-A80005 add zx02,pmigrup,gem02
                        " FROM pmi_file LEFT OUTER JOIN smy_file ON pmi01 like rtrim(ltrim(smyslip)) || '-%'",
                        " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                        " LEFT OUTER JOIN zx_file ON pmiuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                        " LEFT OUTER JOIN gem_file ON pmigrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                        " WHERE pmi02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                        " AND pmiacti = 'Y' "   #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND pmiconf!='Y' " CLIPPED   #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND pmiconf='N' " CLIPPED    #TQC-660078
           END IF
           LET g_sql = g_sql  CLIPPED
           PREPARE u702_p12 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c12 CURSOR FOR u702_p12
               FOREACH u702_c12 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
        END IF #MOD-D60213
        # ========= (3) pmm_file ========== 
        IF u702_inv('APM','pmm') THEN #MOD-D60213
          #LET g_sql = "SELECT 'APM',pmm01,smydesc,pmm04,'',pmm18,' ',pmmuser,pmm25,zx02,pmmgrup,gem02,pmm25 ",  #No.MOD-4C0007 #CHI-A80005 add zx02,pmmgrup,gem02 #MOD-C40019 mark
           LET g_sql = "SELECT 'APM',pmm01,gee05,smydesc,pmm04,'',pmm18,' ',pmmuser,zx02,pmmgrup,gem02,pmm25 ",        #MOD-C40019
                       " FROM pmm_file LEFT OUTER JOIN smy_file ON pmm01 like rtrim(ltrim(smyslip)) || '-%' ",
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON pmmuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON pmmgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND pmm25 <> '6' ",   #No.B221 010327 by linda add
                       " AND pmmacti = 'Y' "    #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND pmm18!='Y' " CLIPPED  #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND pmm18='N' " CLIPPED   #TQC-660078
           END IF
           PREPARE u702_p13 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c13 CURSOR FOR u702_p13
               FOREACH u702_c13 INTO sr.*,l_pmm25
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF l_pmm25 ='9' THEN
                    LET sr.g06='X'
                 END IF
                 IF sr.g06='Y' AND l_pmm25 MATCHES '[X01]' THEN
                    LET sr.g07='G'
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        # ========= (4) pna_file ==========
        IF u702_inv('APM','pna') THEN #MOD-D60213 
           LET g_sql = "SELECT 'APM',pna01,gee05,smydesc,pna04,'',pna05,pnaconf,pnauser,zx02,pnagrup,gem02 ", #CHI-A80005 add zx02,pnagrup,gem02
                          " FROM pna_file LEFT OUTER JOIN smy_file ON pna01 like rtrim(ltrim(smyslip)) || '-%'",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON pnauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON pnagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE pna04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND pnaacti = 'Y' "               #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND (pna05!='Y' OR pnaconf!='Y') " CLIPPED #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND (pna05!='X' AND pnaconf='N' ) " CLIPPED  #MOD-640506 
           END IF
           PREPARE u702_p14 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c14 CURSOR FOR u702_p14
           
               FOREACH u702_c14 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF sr.g06='Y' AND sr.g07='N' THEN
                    LET sr.g07='G'
                 END IF
                 CALL cl_getmsg('aoo-310',g_lang) RETURNING l_msg
                 LET sr.g03=sr.g03 CLIPPED,l_msg CLIPPED
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        # ========= (5) rvu_file ========== 
        IF u702_inv('APM','rvu') THEN #MOD-D60213
           LET g_sql = "SELECT 'APM',rvu01,gee05,smydesc,rvu03,'',rvuconf,' ',rvuuser,zx02,rvugrup,gem02 ",   #No.MOD-4C0007 #CHI-A80005 add zx02,rvugrup,gem02
                       " FROM rvu_file LEFT OUTER JOIN smy_file ON rvu01 like rtrim(ltrim(smyslip)) || '-%' ",
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rvuuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON rvugrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE rvu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rvuacti = 'Y' "   #CHI-CB0044 add
           LET g_sql = g_sql  CLIPPED
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND rvuconf!='Y' " CLIPPED  #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND rvuconf='N' " CLIPPED    #TQC-660078
           END IF
           PREPARE u702_p15 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c15 CURSOR FOR u702_p15
               FOREACH u702_c15 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
        END IF #MOD-D60213
        # ========= (6) rva_file ========== 
        IF u702_inv('APM','rva') THEN #MOD-D60213
           LET g_sql = "SELECT 'APM',rva01,gee05,smydesc,rva06,'',rvaconf,' ',rvauser,zx02,rvagrup,gem02 ", #CHI-A80005 add zx02,rvagrup,gem02
                          " FROM rva_file LEFT OUTER JOIN smy_file ON rva01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON rvauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON rvagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE rva06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND rvaacti = 'Y' "   #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND rvaconf!='Y' " CLIPPED #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND rvaconf='N' " CLIPPED   #TQC-660078
           END IF
           PREPARE u702_p16 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c16 CURSOR FOR u702_p16
               FOREACH u702_c16 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 LET g_cnt=0
                 SELECT COUNT(*) INTO g_cnt FROM rvu_file 
                   WHERE rvu02 = sr.g02  AND rvuconf !='X'   #驗收單
                 IF sr.g06 = 'N' OR g_cnt = 0 THEN    #RA單未確認,有RA單沒有RC單
                    IF g_cnt=0 THEN
                       LET sr.g07='A'
                    END IF
                    ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                    EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                              sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                    #------------------------------ CR (3) ------------------------------#
                 END IF
               END FOREACH
         END IF #MOD-D60213
#FUN-C50077---begin
        # ========= (7) pne_file ========== 
        IF u702_inv('APM','pne') THEN #MOD-D60213
           LET g_sql = "SELECT 'APM',pne01,smydesc,pne03,'',pne06,pneconf,pneuser,zx02,pnegrup,gem02 ", 
                          " FROM pne_file LEFT OUTER JOIN smy_file ON pne01 like rtrim(ltrim(smyslip)) || '-%'",
                          " LEFT OUTER JOIN zx_file ON pneuser=zx_file.zx01 ", 
                          " LEFT OUTER JOIN gem_file ON pnegrup=gem_file.gem01 ", 
                          " WHERE pne03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND pneacti = 'Y' "    #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND (pne06!='Y' OR pneconf!='Y') " CLIPPED 
           ELSE
              LET g_sql=g_sql CLIPPED," AND (pne06!='X' AND pneconf='N' ) " CLIPPED  
           END IF
           PREPARE u702_p17 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      
               EXIT PROGRAM
           END IF
           DECLARE u702_c17 CURSOR FOR u702_p17
           
               FOREACH u702_c17 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF sr.g06='Y' AND sr.g07='N' THEN
                    LET sr.g07='G'
                 END IF
                 CALL cl_getmsg('aoo-310',g_lang) RETURNING l_msg
                 LET sr.g03=sr.g03 CLIPPED,l_msg CLIPPED
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02 
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH             
         END IF #MOD-D60213
#FUN-C50077---end
     END IF 
     # **    銷售系統 (系統別:AXM)    **
     # *********************************   
     IF  tm.c = 'Y'  THEN  
        # ========= (1) oea_file =========
        IF u702_inv('AXM','oea') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AXM',oea01,gee05,oaydesc,oea02,'',oeaconf,' ',oeauser ,zx02,oeagrup,gem02", #CHI-A80005 add zx02,oeagrup,gem02
                          " FROM oea_file LEFT OUTER JOIN oay_file ON oea01 like rtrim(ltrim(oayslip)) || '-%' ",
                          " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON oeauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON oeagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE oea02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
          
           #判斷已作廢單據
           IF tm.y='Y' THEN  
              LET g_sql=g_sql CLIPPED," AND oeaconf!='Y' " CLIPPED  #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND oeaconf='N' " CLIPPED   #TQC-660078
           END IF
          
           PREPARE u702_p21 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c21 CURSOR FOR u702_p21
               FOREACH u702_c21 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
        END IF #MOD-D60213
        # ========= (2) oep_file ========== 
        IF u702_inv('AXM','oep') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AXM',oep01,gee05,oaydesc,oep04,'',oepconf,' ',oepuser,zx02,oepgrup,gem02,oep09", #CHI-A80005 add zx02,oepgrup,gem02
                          " FROM oep_file LEFT OUTER JOIN oay_file ON oep01 like rtrim(ltrim(oayslip)) || '-%' ",
                          " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON oepuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON oepgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE oep09<>'2' ",                        #MOD-6A0133 modify
                          " AND oep04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND oepacti = 'Y' "                         #CHI-CB0044 add
           LET g_sql = g_sql  CLIPPED
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND oepconf!='Y' " CLIPPED  #TQC-660078  
           ELSE
              LET g_sql=g_sql CLIPPED," AND (oepconf='N' OR (oepconf='Y' AND oep09 IN ('0','1'))) " CLIPPED 					#MOD-970276
           END IF
           
           PREPARE u702_p22 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c22 CURSOR FOR u702_p22
               FOREACH u702_c22 INTO sr.*,l_oep09
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF sr.g06='Y' AND l_oep09<> '2' THEN
                    LET sr.g07='H'  #FUN-930013
                 END IF
                 CALL cl_getmsg('aoo-310',g_lang) RETURNING l_msg
                 LET sr.g03=sr.g03 CLIPPED,l_msg CLIPPED
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        # ========= (3) oga_file ========== 
        IF u702_inv('AXM','oga') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AXM',oga01,gee05,oaydesc,oga02,'',ogaconf,ogapost,ogauser,zx02,ogagrup,gem02,oga09", #CHI-A80005 add zx02,ogagrup,gem02
                          " FROM oga_file LEFT OUTER JOIN oay_file ON oga01 like rtrim(ltrim(oayslip)) || '-%' ",
                          " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON ogauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON ogagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           # Check 出貨單是否扣帳/確認 IFB 單是否確認
           IF tm.y='Y' THEN
              LET g_sql=g_sql CLIPPED,
#                       " AND ((oga09 IN ('2','3','4','7','8','9','A') AND ",  #No.FUN-610020	#MOD-990071    #CHI-B80056 mark
                        " AND ((oga09 IN ('2','3','4','6','7','8','9','A') AND ",                  #CHI-B80056
                        " (ogaconf!='Y' OR ogapost='N')) ",
                        " OR (oga09 IN ('1','5') AND ogaconf != 'Y' ))"
           ELSE
              LET g_sql=g_sql CLIPPED,
                        " AND ogaconf!='X' ",
#                       " AND ((oga09 IN ('2','3','4','7','8','9','A') AND ",  #No.FUN-610020	#MOD-990071    #CHI-B80056 mark
                        " AND ((oga09 IN ('2','3','4','6','7','8','9','A') AND ",                  #CHI-B80056
                        " (ogaconf='N' OR ogapost='N')) ",
                        " OR (oga09 IN ('1','5') AND ogaconf = 'N' ))"
           END IF
           PREPARE u702_p23 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                EXIT PROGRAM
           END IF
           DECLARE u702_c23 CURSOR FOR u702_p23
               FOREACH u702_c23 INTO sr.*,l_oga09
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF l_oga09 MATCHES '[15]' THEN LET sr.g07=' ' END IF #No.B221 add
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        # ========= (4) ofa_file ========== 
        IF u702_inv('AXM','ofa') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AXM',ofa01,'','INVOICE   ',ofa02,'',ofaconf,' ',ofauser,zx02,ofagrup,gem02 ", #CHI-A80005 add zx02,ofagrup,gem02
                          " FROM ofa_file",
                          " LEFT OUTER JOIN zx_file ON ofauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON ofagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE ",   #No.MOD-530403
                          " ofa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND ofaconf!='Y' " CLIPPED  #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND ofaconf='N' " CLIPPED   #TQC-660078
           END IF
           PREPARE u702_p24 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c24 CURSOR FOR u702_p24
               FOREACH u702_c24 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
        END IF #MOD-D60213
        IF u702_inv('AXM','oha') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AXM',oha01,gee05,oaydesc,oha02,'',ohaconf,ohapost,ohauser,zx02,ohagrup,gem02 ", #CHI-A80005 add zx02,ohagrup,gem02
                          " FROM oha_file LEFT OUTER JOIN oay_file ON oha01 like rtrim(ltrim(oayslip)) || '-%'",
                          " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON ohauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON ohagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE oha02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           LET g_sql = g_sql  CLIPPED
           
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND (ohaconf!='Y' OR ohapost!='Y') " CLIPPED  #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND (ohaconf='N' OR ohapost='N') " CLIPPED    #No.MOD-640235 modify  #TQC-660078  #MOD-760147 modify                     #MOD-870110 mark
              LET g_sql=g_sql CLIPPED," AND (ohaconf='N' OR (ohaconf!='X' AND ohapost='N')) " CLIPPED    #No.MOD-640235 modify  #TQC-660078  #MOD-760147 modify  #MOD-870110
           END IF
           
           PREPARE u702_p25 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c25 CURSOR FOR u702_p25
               FOREACH u702_c25 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
     END IF 
     # *********************************
     # **    生產系統 (系統別:ASF)    **
     # *********************************   
     IF  tm.d = 'Y'  THEN  
        # ========= (1) sfb_file ========== 
        IF u702_inv('ASF','sfb') THEN #MOD-D60213 
           LET g_sql = "SELECT 'ASF',sfb01,gee05,smydesc,sfb81,'',sfb87,' ',sfbuser,zx02,sfbgrup,gem02 ", #CHI-A80005 add
                          " FROM sfb_file LEFT OUTER JOIN smy_file ON sfb01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON sfbuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON sfbgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE sfb81 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND sfb04 <> '8' ",    #No.B221  add 不含結案
                          " AND sfbacti = 'Y' "    #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND sfb87!='Y' " CLIPPED  #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND sfb87='N' " CLIPPED   #TQC-660078
           END IF
           PREPARE u702_p31 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c31 CURSOR FOR u702_p31
               FOREACH u702_c31 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        # ========= (2) sfp_file ========== 
        IF u702_inv('ASF','sfp') THEN #MOD-D60213
            LET g_sql = "SELECT 'ASF',sfp01,gee05,smydesc,sfp03,'',sfpconf,sfp04,sfpuser,zx02,sfpgrup,gem02",   #No:MOD-4C0007 #CHI-770003 #CHI-A80005 add zx02,sfpgrup,gem02
                          " FROM sfp_file LEFT OUTER JOIN smy_file ON sfp01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON sfpuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON sfpgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE sfp03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND (sfpconf !='Y' OR sfp04 !='Y') " CLIPPED
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( sfpconf !='X' AND sfp04 = 'N')" CLIPPED  
           END IF
           PREPARE u702_p32 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c32 CURSOR FOR u702_p32
               FOREACH u702_c32 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF sr.g06='X' THEN LET sr.g07=' ' END IF #CHI-770003
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (3) sfu_file ========== 
        IF u702_inv('ASF','sfu') THEN #MOD-D60213
           LET g_sql = "SELECT 'ASF',sfu01,gee05,smydesc,sfu02,'',sfuconf,sfupost,sfuuser,zx02,sfugrup,gem02 ",  #MOD-770002 modify add sfuconf #CHI-A80005 add zx02,sfugrup,gem02
                          " FROM sfu_file LEFT OUTER JOIN smy_file ON sfu01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON sfuuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON sfugrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE sfu02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND (sfuconf !='Y' OR sfupost !='Y') " CLIPPED #TQC-660078s  #MOD-770002 add sfuconf
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( sfuconf !='X' AND sfupost = 'N')" CLIPPED  #MOD-770137 modify
           END IF
           PREPARE u702_p33 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
              CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
              EXIT PROGRAM
           
           END IF
           DECLARE u702_c33 CURSOR FOR u702_p33
               FOREACH u702_c33 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF sr.g06='X' THEN LET sr.g07=' ' END IF #CHI-770003
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        # ========= (4) sfk_file ==========
        IF u702_inv('ASF','sfk') THEN #MOD-D60213 
           LET g_sql = "SELECT 'ASF',sfk01,gee05,smydesc,sfk02,'',sfkconf,sfkpost,sfkuser,zx02,sfkgrup,gem02 ",  #MOD-770002 modify add sfkconf #CHI-A80005 add zx02,sfkgrup,gem02
                          " FROM sfk_file LEFT OUTER JOIN smy_file ON sfk01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON sfkuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON sfkgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE sfk02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND ( sfkpost!='Y' OR sfkconf !='Y' ) " CLIPPED  #TQC-660078  #MOD-770002 modify
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( sfkconf !='X' AND sfkpost ='N' ) " CLIPPED  #MOD-770137 modify
           END IF
           
           PREPARE u702_p34 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c34 CURSOR FOR u702_p34
               FOREACH u702_c34 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF sr.g06='X' THEN LET sr.g07=' ' END IF #CHI-770003
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
#FUN-A70095 ----------------------------Begin----------------------------
        # ========= (8) shb_file =========
        IF u702_inv('ASF','shb') THEN #MOD-D60213
           LET g_sql = "SELECT 'ASF',shb01,smydesc,shb02,shbinp,shbconf,'',shbuser,zx02,shbgrup,gem02 ", 
                          " FROM shb_file LEFT OUTER JOIN smy_file ON shb01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " LEFT OUTER JOIN zx_file ON shbuser=zx_file.zx01 ",
                          " LEFT OUTER JOIN gem_file ON shbgrup=gem_file.gem01 ",
                          " WHERE shb02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND shbacti = 'Y' "                #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN
           #  LET g_sql=g_sql CLIPPED," AND shbconf = 'X' " CLIPPED     #TQC-B90218
              LET g_sql=g_sql CLIPPED," AND shbconf! = 'Y' " CLIPPED    #TQC-B90218
           ELSE
           #  LET g_sql=g_sql CLIPPED," AND ( shbconf!='Y' AND shbconf ='N' ) "   #TQC-B90218 
              LET g_sql=g_sql CLIPPED," AND shbconf ='N' " CLIPPED                #TQC-B90218 
           END IF
           PREPARE u702_p38 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time 
               EXIT PROGRAM
           END IF
           DECLARE u702_c38 CURSOR FOR u702_p38
              FOREACH u702_c38 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF sr.g06='X' THEN LET sr.g07=' ' END IF #CHI-770003
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
              END FOREACH 
        END IF #MOD-D60213 
#FUN-A70095 ----------------------------End------------------------------
        # ========= (5) ksa_file ========== 
        IF u702_inv('ASF','ksa') THEN #MOD-D60213
           LET g_sql = "SELECT 'ASF',ksa01,gee05,smydesc,ksa02,'',' ',ksapost,ksauser,zx02,ksagrup,gem02 ", #CHI-A80005 add zx02,ksagrup,gem02
                          " FROM ksa_file LEFT OUTER JOIN smy_file ON ksa01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON ksauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON ksagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE ksa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND ksapost!='Y' " CLIPPED #TQC-660078
           ELSE
              LET g_sql=g_sql CLIPPED," AND ksapost='N' " CLIPPED  #TQC-660078
           END IF
           PREPARE u702_p35 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c35 CURSOR FOR u702_p35
               FOREACH u702_c35 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        # ========= (6) ksc_file ========== 
        IF u702_inv('ASF','ksc') THEN #MOD-D60213
           LET g_sql = "SELECT 'ASF',ksc01,gee05,smydesc,ksc02,'',kscconf,kscpost,kscuser,zx02,kscgrup,gem02 ",  #MOD-770002 modify kscconf #CHI-A80005 add zx02,kscgrup,gem02
                          " FROM ksc_file LEFT OUTER JOIN smy_file ON ksc01 like rtrim(ltrim(smyslip)) || '-%' ",
                          " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON kscuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON kscgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE ksc02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND ( kscpost!='Y' OR kscconf !='Y' ) " CLIPPED #TQC-660078 #MOD-770002 modify
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( kscconf !='X' AND kscpost = 'N' ) " CLIPPED  #MOD-770137 modify   
           END IF
           
           PREPARE u702_p36 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c36 CURSOR FOR u702_p36
               FOREACH u702_c36 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 IF sr.g06='X' THEN LET sr.g07=' ' END IF #CHI-770003
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
                 #------------------------------ CR (3) ------------------------------#
               END FOREACH
         END IF #MOD-D60213
        #No.FUN-970092 ---- start ----
        # ========= (7) srf_file ========= 
        IF u702_inv('ASF','srf') THEN #MOD-D60213
           LET g_sql = "SELECT 'ASF',srf01,gee05,smydesc,srf02,'',srfconf,' ',srfuser,zx02,srfgrup,gem02 ", #CHI-A80005 add zx02,srfgrup,gem02
                         " FROM srf_file LEFT OUTER JOIN smy_file ON srf01 like rtrim(ltrim(smyslip)) || '-%' ",
                         " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON srfuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON srfgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                         " WHERE srf02 BETWEEN '",tm.bdate, "' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y = 'Y' THEN
              LET g_sql = g_sql CLIPPED," AND srfconf != 'Y' " CLIPPED
           ELSE
             #LET g_sql = g_sql CLIPPED," AND srfconf != 'X' " CLIPPED
              LET g_sql = g_sql CLIPPED," AND srfconf = 'N' " CLIPPED     #MOD-BA0063 mod by suncx
           END IF 
           PREPARE u702_p37 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('prepare:',SQLCA.sqlcode,1) 
              CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
              EXIT PROGRAM
           END IF
           DECLARE u702_c37 CURSOR FOR u702_p37
              FOREACH u702_c37 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) 
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
                    EXIT PROGRAM
                 END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR(3) -------------------------------#
              END FOREACH 
        #No.FUN-970092 ---- end ----
        END IF #MOD-D60213
     END IF   
     # *********************************
     # **    應付系統 (系統別:AAP)    **
     # *********************************   
     IF  tm.f = 'Y'  THEN  
        # ========= (1) apa_file ========== 
        LET g_sql = "SELECT 'AAP',apa01,gee05,apydesc,apa02,'',apa41,apa42,apauser,zx02,apagrup,gem02 ",   #TQC-720033 #CHI-A80005 add zx02,apagrup,gem02
                       " FROM apa_file LEFT OUTER JOIN apy_file ON apa01 like rtrim(ltrim(apyslip)) || '-%' ",
                       " left join gee_file on gee01 ='AAP' and gee02 = apykind and gee03='2' and gee04 ='aapi103' ", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON apauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON apagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                      #" AND apa41 = 'N'",            #MOD-B20139 mark
                       " WHERE apa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND apa41 = 'N'",             #MOD-B20139 add
                       " AND apaacti = 'Y' "           #CHI-CB0044 add  
        #判斷已作廢單據 No.B221
        IF tm.y='N' THEN 
           LET g_sql=g_sql CLIPPED," AND apa42='N' " CLIPPED #modi 01/08/09  #TQC-660078
        END IF
        PREPARE u702_p41 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c41 CURSOR FOR u702_p41
            FOREACH u702_c41 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              IF sr.g07='Y' THEN LET sr.g07='X' ELSE LET sr.g07=' ' END IF   #TQC-720033
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (2) apf_file ========== 
        LET g_sql = "SELECT 'AAP',apf01,gee05,apydesc,apf02,apfinpd,apf41,' ',apfuser,zx02,apfgrup,gem02 ", #CHI-A80005 add zx02,apfgrup,gem02
                       " FROM apf_file LEFT OUTER JOIN apy_file ON apf01 like rtrim(ltrim(apyslip)) || '-%' ",
                       " left join gee_file on gee01 ='AAP' and gee02 = apykind and gee03='2' and gee04 ='aapi103' ", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON apfuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON apfgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE apf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND apfacti = 'Y' "     #CHI-CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND apf41!='Y' " CLIPPED   #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND apf41='N' " CLIPPED    #TQC-660078
        END IF
        PREPARE u702_p42 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
            EXIT PROGRAM
        END IF
        DECLARE u702_c42 CURSOR FOR u702_p42
            FOREACH u702_c42 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (3) ala_file ========== 
        LET g_sql = "SELECT 'AAP',ala01,'','',ala08,alainpd,alafirm,'',alauser,zx02,alagrup,gem02 ", #CHI-A80005 add zx02,alagrup,gem02
                       " FROM ala_file",
                       " LEFT OUTER JOIN zx_file ON alauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON alagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE ala08 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND (alaclos IS NULL OR alaclos<> 'Y') ",   #No.B221 
                       " AND alaacti = 'Y' "   #CHI-CB0044 add
        #判斷已作廢單據 No.B221
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND alafirm!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND alafirm='N' " CLIPPED   #TQC-660078
        END IF
        PREPARE u702_p43 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c43 CURSOR FOR u702_p43
            FOREACH u702_c43 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              #LET sr.g03="預購開狀" #MOD-A80237 mark
              CALL cl_getmsg('aoo-240',g_lang) RETURNING sr.g03 #MOD-A80237
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (3-1) ala_file ========== 
        LET g_sql = "SELECT 'AAP',ala01,'','',ala08,alainpd,ala78,alafirm,alauser,zx02,alagrup,gem02 ", #TQC-720033 #CHI-A80005 add zx02,alagrup,gem02
                       " FROM ala_file",
                       " LEFT OUTER JOIN zx_file ON alauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON alagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE ala78 = 'N'", 
                       " AND ala08 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND (alaclos IS NULL OR alaclos<> 'Y') ",    #No.B221 
                       " AND ala34+ala56+ala53+ala54 > 0 ",           #MOD-B40168
                       " AND alaacti ='Y' "                           #CHI-CB0044 add
        #判斷已作廢單據 
        IF tm.y='N' THEN 
           LET g_sql=g_sql CLIPPED," AND alafirm!='X' " CLIPPED  
        END IF
        PREPARE u702_p431 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c431 CURSOR FOR u702_p431
            FOREACH u702_c431 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              #LET sr.g03="開狀付款" #MOD-A80237 mark
              CALL cl_getmsg('aoo-241',g_lang) RETURNING sr.g03 #MOD-A80237
              IF sr.g07 != 'X' THEN LET sr.g07 = '' END IF   #TQC-720033
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (4) alc_file ========== 
        LET g_sql = "SELECT 'AAP',alc01,'','',alc08,alcinpd,alcfirm,' ',alcuser,zx02,alcgrup,gem02 ", #CHI-A80005 addzx02,alcgrup,gem02
                       " FROM alc_file",
                       " LEFT OUTER JOIN zx_file ON alcuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON alcgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE alc08 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND alcacti = 'Y' "        #CHI-CB0044 add
        #判斷已作廢單據 No.B221
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND alcfirm!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND alcfirm='N' " CLIPPED   #TQC-660078
        END IF
        PREPARE u702_p44 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c44 CURSOR FOR u702_p44
            FOREACH u702_c44 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              #LET sr.g03="預購修改" MOD-A80237 mark
              CALL cl_getmsg('aoo-242',g_lang) RETURNING sr.g03 #MOD-A80237
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (4-1) alc_file ========== 
        LET g_sql = "SELECT 'AAP',alc01,'','',alc08,alcinpd,alc78,' ',alcuser ,zx02,alcgrup,gem02 ", #CHI-A80005 add zx02,alcgrup,gem02
                       " FROM alc_file",
                       " LEFT OUTER JOIN zx_file ON alcuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON alcgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE alc78 = 'N'", 
                       " AND alc08 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND alc34+alc56+alc53+alc54 > 0 ",           #MOD-B40168
                       " AND alcacti = 'Y' "   #CHI-CB0044 add
        LET g_sql = g_sql  CLIPPED
        PREPARE u702_p441 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c441 CURSOR FOR u702_p441
            FOREACH u702_c441 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              #LET sr.g03="修改付款" #MOD-A80237 mark
              CALL cl_getmsg('aoo-243',g_lang) RETURNING sr.g03 #MOD-A80237
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (5) alk_file ========== 
        LET g_sql = "SELECT 'AAP',alk01,'','',alk02,alkinpd,alkfirm,' ',alkuser,zx02,alkgrup,gem02 ", #CHI-A80005 add zx02,alkgrup,gem02
                       " FROM alk_file",
                       " LEFT OUTER JOIN zx_file ON alkuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON alkgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE alk02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND alkacti = 'Y' "    #CHI-CB0044 add
        #判斷已作廢單據 No.B221
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND alkfirm!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND alkfirm='N' " CLIPPED   #TQC-660078
        END IF
        PREPARE u702_p45 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c45 CURSOR FOR u702_p45
            FOREACH u702_c45 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              #LET sr.g03="外購到貨" #MOD-A80237 mark
              CALL cl_getmsg('aoo-244',g_lang) RETURNING sr.g03 #MOD-A80237
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (6) alh_file ========== 
        LET g_sql = "SELECT 'AAP',alh01,'','',alh021,alhinpd,alhfirm,' ',alhuser ,zx02,alhgrup,gem02", #CHI-A80005 add zx02,alhgrup,gem02
                       " FROM alh_file",
                       " LEFT OUTER JOIN zx_file ON alhuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON alhgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE alh021 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND  alhacti = 'Y' "    #CHI-CB0044 add
        #判斷已作廢單據 No.B221
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND alhfirm!='Y' " CLIPPED   #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND alhfirm='N' " CLIPPED    #TQC-660078
        END IF
        PREPARE u702_p46 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c46 CURSOR FOR u702_p46
            FOREACH u702_c46 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              #LET sr.g03="外購到單" #MOD-A80237 mark
              CALL cl_getmsg('aoo-245',g_lang) RETURNING sr.g03 #MOD-A80237
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (7) als_file ========== 
        LET g_sql = "SELECT 'AAP',als01,'','',als02,alsinpd,alsfirm,' ',alsuser,zx02,alsgrup,gem02 ", #CHI-A80005 add zx02,alsgrup,gem02
                       " FROM als_file",
                       " LEFT OUTER JOIN zx_file ON alsuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON alsgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE als02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND alsacti = 'Y' "    #CHI-CB0044 add
        #判斷已作廢單據 No.B221
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND alsfirm!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND alsfirm='N' " CLIPPED   #TQC-660078
        END IF
        PREPARE u702_p47 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c47 CURSOR FOR u702_p47
            FOREACH u702_c47 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              #LET sr.g03="外購提單" #MOD-A80237 mark
              CALL cl_getmsg('aoo-246',g_lang) RETURNING sr.g03 #MOD-A80237
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        #---FUN-C50039 start--
        # ========= (8) aqa_file ==========
        LET g_sql = "SELECT 'AAP',aqa01,'','',aqa02,aqainpd,aqaconf,' ',aqauser,zx02,aqagrup,gem02 ",
                       " FROM aqa_file",
                       " LEFT OUTER JOIN zx_file ON aqauser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON aqagrup=gem_file.gem01 ",
                       " WHERE aqa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND aqaacti = 'Y' "                                         #CHI-CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND aqaconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND aqaconf='N' " CLIPPED
        END IF
        PREPARE u702_p48 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_c48 CURSOR FOR u702_p48
            FOREACH u702_c48 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              CALL cl_getmsg('aoo-247',g_lang) RETURNING sr.g03
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        #--FUN-C50039 end---
     END IF 
     # *********************************
     # **    票據系統 (系統別:ANM)   **
     # *********************************   
     IF  tm.g = 'Y'  THEN  
        # ========= (1) nmd_file ========== 
         LET g_sql = "SELECT 'ANM',nmd01,gee05,nmydesc,nmd07,'',nmd30,' ',nmduser ,zx02,nmdgrup,gem02",   #No:MOD-4C0007 #CHI-A80005 add zx02,nmdgrup,gem02
                       " FROM nmd_file LEFT OUTER JOIN nmy_file ON nmd01 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON nmduser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON nmdgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE nmd07 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'" 
        #判斷已作廢單據 01/08/15
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND nmd30!='Y' " CLIPPED   #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND nmd30='N' " CLIPPED    #TQC-660078
        END IF
        PREPARE u702_p51 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c51 CURSOR FOR u702_p51
            FOREACH u702_c51 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (2) npl_file ========== 
       #LET g_sql = "SELECT 'ANM',npl01,nmydesc,npl02,'','N',' ',npluser ",
         LET g_sql = "SELECT 'ANM',npl01,gee05,nmydesc,npl02,'',nplconf,' ',npluser,zx02,nplgrup,gem02 ",   #No:MOD-4C0007 #CHI-A80005 add zx02,nplgrup,gem02
                       " FROM npl_file LEFT OUTER JOIN nmy_file ON npl01 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON npluser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON nplgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE npl02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        #判斷已作廢單據 01/08/16
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND nplconf!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND nplconf='N' " CLIPPED   #TQC-660078
        END IF
        LET g_sql = g_sql  CLIPPED
        PREPARE u702_p52 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c52 CURSOR FOR u702_p52
            FOREACH u702_c52 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (3) nmh_file ========== 
         LET g_sql = "SELECT 'ANM',nmh01,gee05,nmydesc,nmh04,'',nmh38,' ',nmhuser,zx02,nmhgrup,gem02 ",   #No:MOD-4C0007 #CHI-A80005 addzx02,nmhgrup,gem02
                       " FROM nmh_file LEFT OUTER JOIN nmy_file ON nmh01 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON nmhuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON nmhgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE nmh04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        LET g_sql = g_sql  CLIPPED
        #判斷已作廢單據 01/08/17
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND nmh38!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND nmh38='N' " CLIPPED   #TQC-660078
        END IF
        PREPARE u702_p53 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM

        END IF
        DECLARE u702_c53 CURSOR FOR u702_p53
            FOREACH u702_c53 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (4) npn_file ========== 
         LET g_sql = "SELECT 'ANM',npn01,gee05,nmydesc,npn02,'',npnconf,' ',npnuser ,zx02,npngrup,gem02",   #No:MOD-4C0007 #CHI-A80005 add zx02,npngrup,gem02
                       " FROM npn_file LEFT OUTER JOIN nmy_file ON npn01 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON npnuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON npngrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE npn02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        #判斷已作廢單據 01/08/29
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND npnconf!='Y' " CLIPPED   #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND npnconf='N' " CLIPPED    #TQC-660078
        END IF
        LET g_sql = g_sql  CLIPPED
        PREPARE u702_p54 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c54 CURSOR FOR u702_p54
            FOREACH u702_c54 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (5) nmg_file ========== 
         LET g_sql = "SELECT 'ANM',nmg00,gee05,nmydesc,nmg01,'',nmgconf,' ',nmguser ,zx02,nmggrup,gem02",   #No:MOD-4C0007 #CHI-A80005 add zx02,nmggrup,gem02
                       " FROM nmg_file LEFT OUTER JOIN nmy_file ON nmg00 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON nmguser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON nmggrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE nmg01 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND nmgacti = 'Y' "             #CHI-CB0044 add 
 
        #判斷已作廢單據 01/08/29
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND nmgconf!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND nmgconf='N' " CLIPPED   #TQC-660078
        END IF
        LET g_sql = g_sql  CLIPPED
        PREPARE u702_p55 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c55 CURSOR FOR u702_p55
            FOREACH u702_c55 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (6) nne_file ========== 
         LET g_sql = "SELECT 'ANM',nne01,gee05,nmydesc,nne02,'',nneconf,' ',nneuser,zx02,nnegrup,gem02 ",   #No:MOD-4C0007 #CHI-A80005 add zx02,nnegrup,gem02
                       " FROM nne_file LEFT OUTER JOIN nmy_file ON nne01 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON nneuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON nnegrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE nne02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND nneacti = 'Y' "              #CHI-CB0044 add
        #判斷已作廢單據 01/08/29
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND nneconf!='Y' " CLIPPED   #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND nneconf='N' " CLIPPED    #TQC-660078
        END IF
        LET g_sql = g_sql  CLIPPED
        PREPARE u702_p56 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c56 CURSOR FOR u702_p56
            FOREACH u702_c56 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
         LET g_sql = "SELECT 'ANM',nng01,gee05,nmydesc,nng02,'',nngconf,' ',nnguser,zx02,nnggrup,gem02 ",   #No:MOD-4C0007 #CHI-A80005 add zx02,nnggrup,gem02
                       " FROM nng_file LEFT OUTER JOIN nmy_file ON nng01 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON nnguser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON nnggrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE nng02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND nngacti = 'Y' "   #CHI-CB0044 add
        #判斷已作廢單據 01/08/30
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND nngconf!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND nngconf='N' " CLIPPED    #TQC-660078
        END IF
        LET g_sql = g_sql  CLIPPED
        PREPARE u702_p57 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c57 CURSOR FOR u702_p57
            FOREACH u702_c57 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (8) nni_file ========== 
         LET g_sql = "SELECT 'ANM',nni01,gee05,nmydesc,nni02,nniinpd,nniconf,' ',nniuser,zx02,nnigrup,gem02",   #No:MOD-4C0007 #CHI-A80005 add zx02,nnigrup,gem02
                       " FROM nni_file LEFT OUTER JOIN nmy_file ON nni01 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON nniuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON nnigrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE nni02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND nniacti = 'Y'"                    #MOD-A30044  
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND nniconf!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND nniconf='N' " CLIPPED    #TQC-660078
        END IF
        PREPARE u702_p58 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c58 CURSOR FOR u702_p58
            FOREACH u702_c58 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (9) nnk_file ========== 
         LET g_sql = "SELECT 'ANM',nnk01,gee05,nmydesc,nnk02,nnkinpd,nnkconf,' ',nnkuser,zx02,nnkgrup,gem02 ",   #No:MOD-4C0007 #CHI-A80005 add zx02,nnkgrup,gem02
                       " FROM nnk_file LEFT OUTER JOIN nmy_file ON nnk01 like rtrim(ltrim(nmyslip)) || '-%' ",
                       " left join gee_file on gee01 ='ANM' and gee02 = nmykind and gee03='2' and gee04 ='anmi100'", #darcy:2023/12/04 add
                      #" AND nnkacti = 'Y' ",  #MOD-960268   #MOD-CB0172 mark 
                       " LEFT OUTER JOIN zx_file ON nnkuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON nnkgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE nnk02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #MOD-CB0172 add ,
                       " AND nnkacti = 'Y' "                 #MOD-CB0172 add
                       
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND nnkconf!='Y' " CLIPPED #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND nnkconf='N' " CLIPPED   #TQC-660078
        END IF
        PREPARE u702_p59 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c59 CURSOR FOR u702_p59
            FOREACH u702_c59 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
              #end FUN-710080 add
            END FOREACH
     END IF 
     # *********************************
     # **    應收系統 (系統別:AXR)    **
     # *********************************   
     IF  tm.e = 'Y'  THEN  
        # ========= (1) ola_file ========== 
        LET g_sql = "SELECT 'AXR',ola01,gee05,ooydesc,ola02,'',olaconf,'',olauser ,zx02,olagrup,gem02",   #No:MOD-4C0007 #CHI-A80005 add zx02,olagrup,gem02
                       " FROM ola_file LEFT OUTER JOIN ooy_file ON ola01 like rtrim(ltrim(ooyslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXR' and gee02 = ooytype and gee03='2' and gee04 ='axri010'", #darcy:2023/12/04 add
                      #" AND ola02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",  #Mark No.TQC-AC0356
                       " LEFT OUTER JOIN zx_file ON olauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON olagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE (ola40 IS NULL OR ola40<>'Y') ",   #No.B221
                       " AND ola02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"   #Add No.TQC-AC0356
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND olaconf!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND olaconf='N' " CLIPPED    #TQC-660078
        END IF
        PREPARE u702_p61 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c61 CURSOR FOR u702_p61
            FOREACH u702_c61 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (2) ole_file ========== 
        LET g_sql = "SELECT 'AXR',ole01,gee05,ooydesc,ole03,'',oleconf,ole28,oleuser ,zx02,olegrup,gem02", #CHI-A80005 add zx02,olegrup,gem02
                       " FROM ole_file LEFT OUTER JOIN ooy_file ON ole01 like rtrim(ltrim(ooyslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXR' and gee02 = ooytype and gee03='2' and gee04 ='axri010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON oleuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON olegrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE ole03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED, " AND (oleconf !='Y' OR ole28!='Y') " 
        ELSE
           LET g_sql=g_sql CLIPPED, " AND (oleconf = 'N' AND ole28='N') "    #No.MOD-640235 modify
        END IF
        PREPARE u702_p62 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c62 CURSOR FOR u702_p62
            FOREACH u702_c62 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              IF sr.g07='N' THEN
                 LET sr.g07='T'
              ELSE
                 LET sr.g07=' '
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (3) olc_file ========== 
        LET g_sql = "SELECT 'AXR',olc01,'','INVOICE   ',olc02,'',olcconf,' ',olcuser zx02,olcgrup,gem02",   #No:MOD-4C0007 #CHI-A80005 add zx02,olcgrup,gem02
                       " FROM olc_file",
                       " LEFT OUTER JOIN zx_file ON olcuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON olcgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE ",   #No.MOD-530403
                       " olc02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND olcconf!='Y' " CLIPPED #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND olcconf='N' " CLIPPED   #TQC-660078 
        END IF
        PREPARE u702_p63 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c63 CURSOR FOR u702_p63
            FOREACH u702_c63 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (4) oma_file ========== 
        LET g_sql = "SELECT 'AXR',oma01,gee05,ooydesc,oma02,'',omaconf,omavoid,omauser,zx02,omagrup,gem02 ", #CHI-A80005 add zx02,omagrup,gem02
                       " FROM oma_file LEFT OUTER JOIN ooy_file ON oma01 like rtrim(ltrim(ooyslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXR' and gee02 = ooytype and gee03='2' and gee04 ='axri010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON omauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON omagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE oma02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND omaconf='N' " CLIPPED   #TQC-790110
        ELSE
           LET g_sql=g_sql CLIPPED," AND omaconf='N' AND omavoid='N' " CLIPPED    #TQC-660078
        END IF
        PREPARE u702_p64 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c64 CURSOR FOR u702_p64
 
            FOREACH u702_c64 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              IF sr.g07='Y' THEN LET sr.g07='X' ELSE LET sr.g07=' ' END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (6) ooa_file ========== 
        LET g_sql = "SELECT 'AXR',ooa01,gee05,ooydesc,ooa02,ooa021,ooaconf,' ',ooauser,zx02,ooagrup,gem02 ",   #No:MOD-4C0007 #CHI-A80005 add zx02,ooagrup,gem02
                       " FROM ooa_file LEFT OUTER JOIN ooy_file ON ooa01 like rtrim(ltrim(ooyslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXR' and gee02 = ooytype and gee03='2' and gee04 ='axri010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ooauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON ooagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE ooa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND ooa00='1'"   #MOD-920150 add
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND ooaconf!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND ooaconf='N' " CLIPPED   #TQC-660078
        END IF
        PREPARE u702_p66 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c66 CURSOR FOR u702_p66
        FOREACH u702_c66 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
           #------------------------------ CR (3) ------------------------------#
        END FOREACH
     #str MOD-A10115 mod
       #str MOD-920150 add
        LET g_sql = "SELECT 'AXR',ooa01,'',ooydesc,ooa02,ooa021,ooaconf,' ',ooauser ,zx02,ooagrup,gem02", #CHI-A80005 add zx02,ooagrup,gem02
#                   " FROM ooa_file,OUTER ooy_file,oma_file",   #TQC-A60046
                    " FROM oma_file,ooa_file LEFT OUTER JOIN ooy_file ", #TQC-A60046
                    "    ON ooa01 like ltrim(rtrim(ooyslip))||'-%' ",  #TQC-A60046
                       " LEFT OUTER JOIN zx_file ON ooauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON ooagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
#                   " WHERE ooa01 like trim(ooyslip)||'-%' ",   #TQC-A60046
#                   " AND ooa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",#TQC-A60046
                    " WHERE ooa02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",#TQC-A60046
                    " AND ooa00='2'",
                    " AND ooa01=oma01"
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND ooaconf!='Y' " CLIPPED
                                  ," AND omaconf='N' "
        ELSE
           LET g_sql=g_sql CLIPPED," AND ooaconf='N' " CLIPPED
                                  ," AND omaconf='N' AND omavoid='N' "
        END IF
       #end MOD-920150 add
        PREPARE u702_p661 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c661 CURSOR FOR u702_p661
        FOREACH u702_c661 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           #str FUN-710080 add
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
           #------------------------------ CR (3) ------------------------------#
           #end FUN-710080 add
        END FOREACH
     #end MOD-A10115 mod
     END IF 
 
     # *********************************
     # **    品管系統 (系統別:AQC)    **
     # *********************************   
     IF  tm.h = 'Y'  THEN  
        # ========= (1) qcf_file ========== 
        LET g_sql = "SELECT 'AQC',qcf01,gee05,smydesc,qcf04,'',qcf14,'',qcfuser,zx02,qcfgrup,gem02 ", #CHI-A80005 add zx02,qcfgrup,gem02
                       " FROM qcf_file LEFT OUTER JOIN smy_file ON qcf01 like rtrim(ltrim(smyslip)) || '-%' ",
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON qcfuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON qcfgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND qcfacti = 'Y' "   #CHI-0CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND qcf14!='Y' " CLIPPED #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND qcf14='N' " CLIPPED  #TQC-660078
        END IF
        PREPARE u702_p81 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c81 CURSOR FOR u702_p81
            FOREACH u702_c81 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (2) qcm_file ========== 
        LET g_sql = "SELECT 'AQC',qcm01,gee05,smydesc,qcm04,'',qcm14,'',qcmuser ,zx02,qcmgrup,gem02", #CHI-A80005 add zx02,qcmgrup,gem02
                       " FROM qcm_file LEFT OUTER JOIN smy_file ON qcm01 like rtrim(ltrim(smyslip)) || '-%'",
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON qcmuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON qcmgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND qcmacti = 'Y' " #CHI-CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN 
           LET g_sql=g_sql CLIPPED," AND qcm14!='Y' " CLIPPED  #TQC-660078
        ELSE
           LET g_sql=g_sql CLIPPED," AND qcm14='N' " CLIPPED   #TQC-660078
        END IF
        PREPARE u702_p82 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c82 CURSOR FOR u702_p82
            FOREACH u702_c82 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
              #------------------------------ CR (3) ------------------------------#
            END FOREACH
        # ========= (3) qcs_file ==========
        LET g_sql = "SELECT 'AQC',qcs01,gee05,smydesc,qcs04,'',qcs14,'',qcsuser,zx02,qcsgrup,gem02 ", #CHI-A80005 add zx02,qcsgrup,gem02
                       " FROM qcs_file LEFT OUTER JOIN smy_file ON qcs01 like rtrim(ltrim(smyslip)) || '-%'",
                       " left join gee_file on smykind = gee02 and gee03 ='2' and gee04 = 'asmi300' and gee01 = upper(smysys)", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON qcsuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                       " LEFT OUTER JOIN gem_file ON qcsgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                       " WHERE qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                      #MOD-C40073---str---
                       " AND qcs00 NOT IN ('5','6')" ,  #MOD-C70235 add
                       #" AND qcs00 NOT IN ('5','6')", #MOD-C70235 mark
                       #" UNION ALL ",                 #MOD-C70235 mark
                       " AND qcsacti = 'Y' "          #CHI-CB0044 add
                       #" SELECT 'AQC',qcs01,oaydesc,qcs04,'',qcs14,'',qcsuser,zx02,qcsgrup,gem02 ", #MOD-C70235 mark
        LET g_sql2 =   " SELECT 'AQC',qcs01,gee05,oaydesc,qcs04,'',qcs14,'',qcsuser,zx02,qcsgrup,gem02 ",  #MOD-C70235 add
                       " FROM qcs_file LEFT OUTER JOIN oay_file ON qcs01 like rtrim(ltrim(oayslip)) || '-%'",
                        " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON qcsuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON qcsgrup=gem_file.gem01 ",
                       " WHERE qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND qcs00  IN ('5','6')",
                       " AND qcsacti = 'Y' "          #CHI-CB0044 add
                      #MOD-C40073---end---

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND qcs14!='Y' " CLIPPED  #TQC-660078
           LET g_sql2=g_sql2 CLIPPED," AND qcs14!='Y' " CLIPPED  #MOD-C70235 add
        ELSE
           LET g_sql=g_sql CLIPPED," AND qcs14='N' " CLIPPED   #TQC-660078
           LET g_sql2=g_sql2 CLIPPED," AND qcs14='N' " CLIPPED   #MOD-C70235 add
        END IF
        LET g_sql = g_sql ," UNION ALL ", g_sql2 #MOD-C70235 add
        PREPARE u702_p83 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
        END IF
        DECLARE u702_c83 CURSOR FOR u702_p83
        FOREACH u702_c83 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
          EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                    sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
          #------------------------------ CR (3) ------------------------------#
        END FOREACH        
     END IF
     # *********************************
     # **    固資系統 (系統別:AFA)    **
     # *********************************   
     IF  tm.i = 'Y'  THEN  
        # ========= (1) faq_file ========== 
        IF u702_inv('AFA','faq') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',faq01,gee05,fahdesc,faq02,'',faqconf,faqpost,faquser,zx02,faqgrup,gem02 ", #CHI-A80005 add zx02,faqgrup,gem02
                          " FROM faq_file LEFT OUTER JOIN fah_file ON faq01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON faquser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON faqgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE faq02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  faqpost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( faqconf !='X' AND faqpost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p84 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c84 CURSOR FOR u702_p84
               FOREACH u702_c84 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (2) fas_file ========== 
        IF u702_inv('AFA','fas') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',fas01,gee05,fahdesc,fas02,'',fasconf,faspost,fasuser,zx02,fasgrup,gem02 ", #CHI-A80005 add zx02,fasgrup,gem02
                          " FROM fas_file LEFT OUTER JOIN fah_file ON fas01 like rtrim(ltrim(fahslip)) || '-%'",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fasuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fasgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE fas02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  faspost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fasconf !='X' AND faspost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p85 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c85 CURSOR FOR u702_p85
               FOREACH u702_c85 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (3) fau_file ========== 
        IF u702_inv('AFA','fau') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',fau01,gee05,fahdesc,fau02,'',fauconf,faupost,fauuser,zx02,faugrup,gem02 ", #CHI-A80005 add zx02,faugrup,gem02
                          " FROM fau_file LEFT OUTER JOIN fah_file ON fau01 like rtrim(ltrim(fahslip)) || '-%'",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fauuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON faugrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE fau02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  faupost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fauconf !='X' AND faupost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p86 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c86 CURSOR FOR u702_p86
               FOREACH u702_c86 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (4) faw_file ==========
        IF u702_inv('AFA','faw') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AFA',faw01,gee05,fahdesc,faw02,'',fawconf,fawpost,fawuser ,zx02,fawgrup,gem02", #CHI-A80005 add zx02,fawgrup,gem02
                          " FROM faw_file LEFT OUTER JOIN fah_file ON faw01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fawuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fawgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE faw02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  fawpost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fawconf !='X' AND fawpost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p87 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c87 CURSOR FOR u702_p87
               FOREACH u702_c87 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (5) fay_file ==========
        IF u702_inv('AFA','fay') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AFA',fay01,gee05,fahdesc,fay02,'',fayconf,faypost,fayuser,zx02,faygrup,gem02 ", #CHI-A80005 add zx02,faygrup,gem02
                          " FROM fay_file LEFT OUTER JOIN fah_file ON fay01 like rtrim(ltrim(fahslip)) || '-%'",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fayuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON faygrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE fay02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  faypost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fayconf !='X' AND faypost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p88 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c88 CURSOR FOR u702_p88
               FOREACH u702_c88 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        IF u702_inv('AFA','fba') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',fba01,gee05,fahdesc,fba02,'',fbaconf,fbapost,fbauser ,zx02,fbagrup,gem02", #CHI-A80005 add zx02,fbagrup,gem02
                          " FROM fba_file LEFT OUTER JOIN fah_file ON fba01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fbauser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fbagrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify 
                          " WHERE fba02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  fbapost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fbaconf !='X' AND fbapost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p89 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c89 CURSOR FOR u702_p89
               FOREACH u702_c89 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (7) fbc_file ========== 
        IF u702_inv('AFA','fbc') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',fbc01,gee05,fahdesc,fbc02,'',fbcconf,fbcpost,fbcuser ,zx02,fbcgrup,gem02", #CHI-A80005 add zx02,fbcgrup,gem02
                          " FROM fbc_file LEFT OUTER JOIN fah_file ON fbc01 like rtrim(ltrim(fahslip)) || '-%'",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fbcuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fbcgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify 
                          " WHERE fbc02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  fbcpost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fbcconf !='X' AND fbcpost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p90 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c90 CURSOR FOR u702_p90
               FOREACH u702_c90 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (8) fbg_file ========== 
        IF u702_inv('AFA','fbg') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',fbg01,gee05,fahdesc,fbg02,'',fbgconf,fbgpost,fbguser,zx02,fbggrup,gem02 ", #CHI-A80005 add zx02,fbggrup,gem02
                          " FROM fbg_file LEFT OUTER JOIN fah_file ON fbg01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fbguser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fbggrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE fbg02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  fbgpost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fbgconf !='X' AND fbgpost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p91 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c91 CURSOR FOR u702_p91
               FOREACH u702_c91 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (9) fbe_file ========== 
        IF u702_inv('AFA','fbe') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',fbe01,gee05,fahdesc,fbe02,'',fbeconf,fbepost,fbeuser ,zx02,fbegrup,gem02", #CHI-A80005 add zx02,fbegrup,gem02
                          " FROM fbe_file LEFT OUTER JOIN fah_file ON fbe01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fbeuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fbegrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify 
                          " WHERE fbe02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  fbepost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fbeconf !='X' AND fbepost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p92 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c92 CURSOR FOR u702_p92
               FOREACH u702_c92 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (10) fbl_file ==========
        IF u702_inv('AFA','fbl') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AFA',fbl01,gee05,fahdesc,fbl02,'',fblconf,fblpost,fbluser ,zx02,fblgrup,gem02", #CHI-A80005 add zx02,fblgrup,gem02
                          " FROM fbl_file LEFT OUTER JOIN fah_file ON fbl01 like rtrim(ltrim(fahslip)) || '-%' ",  #CHI-A80005 add
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fbluser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fblgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify 
                          " WHERE fbl02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  fblpost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fblconf !='X' AND fblpost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p93 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c93 CURSOR FOR u702_p93
               FOREACH u702_c93 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (11) fbs_file ========== 
        IF u702_inv('AFA','fbs') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',fbs01,gee05,fahdesc,fbs02,'',fbsconf,fbspost,fbsuser ,zx02,fbsgrup,gem02", #CHI-A80005 add zx02,fbsgrup,gem02
                          " FROM fbs_file LEFT OUTER JOIN fah_file ON fbs01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fbsuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fbsgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE fbs02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND  fbspost!='Y' " CLIPPED  
           ELSE
              LET g_sql=g_sql CLIPPED," AND ( fbsconf !='X' AND fbspost ='N' ) " CLIPPED 
           END IF
           PREPARE u702_p94 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c94 CURSOR FOR u702_p94
               FOREACH u702_c94 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (12) fgh_file ==========
        IF u702_inv('AFA','fgh') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AFA',fgh01,gee05,fahdesc,fgh02,'',fghconf,'',fghuser ,zx02,fghgrup,gem02", #CHI-A80005 add zx02,fghgrup,gem02
                          " FROM fgh_file LEFT OUTER JOIN fah_file ON fgh01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fghuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fghgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE fgh02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND fghacti = 'Y' "    #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND fghconf!='Y' " CLIPPED 
           ELSE
              LET g_sql=g_sql CLIPPED," AND fghconf='N' " CLIPPED 
           END IF
           PREPARE u702_p95 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c95 CURSOR FOR u702_p95
               FOREACH u702_c95 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (13) fec_file ==========
        IF u702_inv('AFA','fec') THEN #MOD-D60213 
           LET g_sql = "SELECT 'AFA',fec01,gee05,fahdesc,fec02,'',fecconf,'',fecuser ,zx02,fecgrup,gem02", #CHI-A80005 add zx02,fecgrup,gem02
                          " FROM fec_file LEFT OUTER JOIN fah_file ON fec01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON fecuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON fecgrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify 
                          " WHERE fec02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND fecacti = 'Y' "    #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND fecconf!='Y' " CLIPPED 
           ELSE
              LET g_sql=g_sql CLIPPED," AND fecconf='N' " CLIPPED 
           END IF
           PREPARE u702_p96 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c96 CURSOR FOR u702_p96
               FOREACH u702_c96 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH
         END IF #MOD-D60213
        # ========= (14) fee_file ========== 
        IF u702_inv('AFA','fee') THEN #MOD-D60213
           LET g_sql = "SELECT 'AFA',fee01,gee05,fahdesc,fee02,'',feeconf,'',feeuser ,zx02,feegrup,gem02", #CHI-A80005 add zx02,feegrup,gem02
                          " FROM fee_file LEFT OUTER JOIN fah_file ON fee01 like rtrim(ltrim(fahslip)) || '-%' ",
                          " left join gee_file on gee01 ='AFA' and gee02 = fahtype and gee03='2' and gee04 ='afai060'", #darcy:2023/12/04 addd
                          " LEFT OUTER JOIN zx_file ON feeuser=zx_file.zx01 ", #CHI-A80005 add #MOD-B20110 modify
                          " LEFT OUTER JOIN gem_file ON feegrup=gem_file.gem01 ", #CHI-A80005 add #MOD-B20110 modify
                          " WHERE fee02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND feeacti = 'Y' "    #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN 
              LET g_sql=g_sql CLIPPED," AND feeconf!='Y' " CLIPPED 
           ELSE
              LET g_sql=g_sql CLIPPED," AND feeconf='N' " CLIPPED 
           END IF
           PREPARE u702_p97 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
           END IF
           DECLARE u702_c97 CURSOR FOR u702_p97
               FOREACH u702_c97 INTO sr.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
                 END IF
                 ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
                 EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                           sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02  #CHI-A80005 add sr.zx02,sr.g09,sr.gem02
               END FOREACH 
           END IF #MOD-D60213
       END IF

#FUN-BA0003 add START-------------------------------------
     # **    流通零售系統 (系統別:ART)    **
     # *********************************
     IF  tm.j = 'Y'  THEN
        # ========= (1) rvq_file ==========        
        LET g_sql = "SELECT 'ART',rvq01,gee05,oaydesc,rvq03,rvqcrat,rvqconf,rvqconf,rvquser ,zx02,rvqgrup,gem02", 
                       " FROM rvq_file LEFT OUTER JOIN oay_file ON rvq01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rvquser=zx_file.zx01 ", 
                       " LEFT OUTER JOIN gem_file ON rvqgrup=gem_file.gem01 ",
                       " WHERE rvq03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rvqacti = 'Y' "    #CHI-CB0044 add
                       

        LET g_sql=g_sql CLIPPED," AND rvqconf = '0'  " CLIPPED  
        LET g_sql= g_sql CLIPPED," ORDER BY rvq_file.rvq03 ,rvq_file.rvq01"

        PREPARE u702_part1 FROM g_sql 
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      
            EXIT PROGRAM
        END IF
        DECLARE u702_cart1 CURSOR FOR u702_part1 
            FOREACH u702_cart1 INTO sr.*
              IF sr.g06 = 0 THEN
                 LET sr.g06 = 'N'
              END IF
              IF sr.g07 = 0 OR sr.g07 = 1 OR sr.g07 = 2 THEN
                 LET sr.g07 = 'N'
              END IF
                
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02 
            END FOREACH
        # ========= (2) lua_file ==========
        LET g_sql = "SELECT 'ART',lua01,gee05,oaydesc,lua09,luacrat,lua15,'',luauser ,zx02,luagrup,gem02",
                       " FROM lua_file LEFT OUTER JOIN oay_file ON lua01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON luauser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON luagrup=gem_file.gem01 ",
                       " WHERE lua09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND luaacti = 'Y' "    #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lua15!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lua15 = 'N' " CLIPPED 
        END IF
        LET g_sql= g_sql CLIPPED, " ORDER BY lua_file.lua09 ,lua_file.lua01"

        PREPARE u702_part2 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart2 CURSOR FOR u702_part2
            FOREACH u702_cart2 INTO sr.*

              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
              END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
            END FOREACH
        # ========= (3) luc_file ==========        
        LET g_sql = "SELECT 'ART',luc01,gee05,oaydesc,luc07,luccrat,luc14,'',lucuser ,zx02,lucgrup,gem02",
                       " FROM luc_file LEFT OUTER JOIN oay_file ON luc01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lucuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lucgrup=gem_file.gem01 ",
                       " WHERE luc07 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lucacti = 'Y' "    #CHI-CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND luc14!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND luc14 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY luc_file.luc070,luc_file.luc01"

        PREPARE u702_part3 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart3 CURSOR FOR u702_part3
            FOREACH u702_cart3 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (4) rab_file ==========        
        LET g_sql = "SELECT 'ART',rab02,gee05,oaydesc,rabcrat,rabcrat,rabconf,'',rabuser ,zx02,rabgrup,gem02",
                       " FROM rab_file LEFT OUTER JOIN oay_file ON rab02 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rabuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rabgrup=gem_file.gem01 ",
                       " WHERE rabcrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rabacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rabconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rabconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED, " ORDER BY rab_file.rabcrat,rab_file.rab02"
        PREPARE u702_part4 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart4 CURSOR FOR u702_part4
            FOREACH u702_cart4 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (5) rae_file ==========        
        LET g_sql = "SELECT 'ART',rae02,gee05,oaydesc,raecrat,raecrat,raeconf,'',raeuser ,zx02,raegrup,gem02",
                       " FROM rae_file LEFT OUTER JOIN oay_file ON rae02 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON raeuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON raegrup=gem_file.gem01 ",
                       " WHERE raecrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND raeacti = 'Y' "   #CHI-CB0044 add
                       
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND raeconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND raeconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rae_file.raecrat,rae_file.rae02"
        PREPARE u702_part5 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart5 CURSOR FOR u702_part5
            FOREACH u702_cart5 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (6) rah_file ==========        
        LET g_sql = "SELECT 'ART',rah02,gee05,oaydesc,rahcrat,rahcrat,rahconf,'',rahuser ,zx02,rahgrup,gem02",
                       " FROM rah_file LEFT OUTER JOIN oay_file ON rah02 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rahuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rahgrup=gem_file.gem01 ",
                       " WHERE rahcrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rahacti = 'Y' "    #CHI-CB0044 add 


        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rahconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rahconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rah_file.rahcrat,rah_file.rah02"
        PREPARE u702_part6 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart6 CURSOR FOR u702_part6
           FOREACH u702_cart6 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (7) rcd_file ==========        
        LET g_sql = "SELECT 'ART',rcd01,gee05,oaydesc,rcd02,rcdcrat,rcdconf,'',rcduser ,zx02,rcdgrup,gem02",
                       " FROM rcd_file LEFT OUTER JOIN oay_file ON rcd01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rcduser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rcdgrup=gem_file.gem01 ",
                       " WHERE rcd02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rcdacti = 'Y' "     #CHI-CB0044 add
                      

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rcdconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rcdconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED, " ORDER BY rcd_file.rcd02,rcd_file.rcd01"
        PREPARE u702_part7 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart7 CURSOR FOR u702_part7
            FOREACH u702_cart7 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (8) rcf_file ==========        
        LET g_sql = "SELECT 'ART',rcf01,gee05,oaydesc,rcf02,rcfcrat,rcfconf,'',rcfuser ,zx02,rcfgrup,gem02",
                       " FROM rcf_file LEFT OUTER JOIN oay_file ON rcf01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rcfuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rcfgrup=gem_file.gem01 ",
                       " WHERE rcf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rcfacti = 'Y' "    #CHI-CB0044 add


        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rcfconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rcfconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rcf_file.rcf02,rcf_file.rcf01"
        PREPARE u702_part8 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart8 CURSOR FOR u702_part8
            FOREACH u702_cart8 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (9) rch_file ==========        
        LET g_sql = "SELECT 'ART',rch01,gee05,oaydesc,rch02,rchcrat,rchconf,'',rchuser ,zx02,rchgrup,gem02",
                       " FROM rch_file LEFT OUTER JOIN oay_file ON rch01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rchuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rchgrup=gem_file.gem01 ",
                       " WHERE rch02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rchacti = 'Y' "     #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rchconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rchconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rch_file.rch02,rch_file.rch01"
        PREPARE u702_part9 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart9 CURSOR FOR u702_part9
            FOREACH u702_cart9 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (10) rti_file ==========
        LET g_sql = "SELECT 'ART',rti01,gee05,oaydesc,rti03,rticrat,rticonf,'',rtiuser ,zx02,rtigrup,gem02",
                       " FROM rti_file LEFT OUTER JOIN oay_file ON rti01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rtiuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rtigrup=gem_file.gem01 ",
                       " WHERE rti03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rtiacti = 'Y' "    #CHI-CB0044 add                 

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rticonf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rticonf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rti_file.rti03,rti_file.rti01" 
        PREPARE u702_part10 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart10 CURSOR FOR u702_part10
            FOREACH u702_cart10 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH

        # ========= (11) rtm_file ==========
        LET g_sql = "SELECT 'ART',rtm01,gee05,oaydesc,rtm03,rtmcrat,rtmconf,'',rtmuser ,zx02,rtmgrup,gem02",
                       " FROM rtm_file LEFT OUTER JOIN oay_file ON rtm01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rtmuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rtmgrup=gem_file.gem01 ",
                       " WHERE rtm03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rtmacti = 'Y' "    #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rtmconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rtmconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rtm_file.rtm03,rtm_file.rtm01"
        PREPARE u702_part11 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart11 CURSOR FOR u702_part11
            FOREACH u702_cart11 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (12) rto_file ==========
        LET g_sql = "SELECT 'ART',rto01,gee05,oaydesc,rtocrat,rtocrat,rtoconf,'',rtouser ,zx02,rtogrup,gem02",
                       " FROM rto_file LEFT OUTER JOIN oay_file ON rto01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rtouser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rtogrup=gem_file.gem01 ",
                       " WHERE rtocrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rtoacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rtoconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rtoconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rto_file.rtocrat,rto_file.rto01"
        PREPARE u702_part12 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart12 CURSOR FOR u702_part12
            FOREACH u702_cart12 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (13) rts_file ==========
        LET g_sql = "SELECT 'ART',rts01,gee05,oaydesc,rtscrat,rtscrat,rtsconf,'',rtsuser ,zx02,rtsgrup,gem02",
                       " FROM rts_file LEFT OUTER JOIN oay_file ON rts01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rtsuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rtsgrup=gem_file.gem01 ",
                       " WHERE rtscrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rtsacti = 'Y' "     #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rtsconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rtsconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rts_file.rtscrat,rts_file.rts01"
        PREPARE u702_part13 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart13 CURSOR FOR u702_part13
            FOREACH u702_cart13 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (14) rtu_file ==========
        LET g_sql = "SELECT 'ART',rtu01,gee05,oaydesc,rtucrat,rtucrat,rtuconf,'',rtuuser ,zx02,rtugrup,gem02",
                       " FROM rtu_file LEFT OUTER JOIN oay_file ON rtu01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rtuuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rtugrup=gem_file.gem01 ",
                       " WHERE rtucrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rtuacti = 'Y' "    #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rtuconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rtuconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rtu_file.rtucrat,rtu_file.rtu01" 
        PREPARE u702_part14 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart14 CURSOR FOR u702_part14
            FOREACH u702_cart14 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (15) rua_file ==========
        LET g_sql = "SELECT 'ART',rua01,gee05,oaydesc,ruacrat,ruacrat,ruaconf,'',ruauser ,zx02,ruagrup,gem02",
                       " FROM rua_file LEFT OUTER JOIN oay_file ON rua01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ruauser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ruagrup=gem_file.gem01 ",
                       " WHERE ruacrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rtuacti = 'Y' "                                        #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND ruaconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND ruaconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rua_file.ruacrat,rua_file.rua01"
        PREPARE u702_part15 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart15 CURSOR FOR u702_part15
            FOREACH u702_cart15 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (16) rud_file ==========
        LET g_sql = "SELECT 'ART',rud01,gee05,oaydesc,rud02,rudcrat,rudconf,'',ruduser ,zx02,rudgrup,gem02",
                       " FROM rud_file LEFT OUTER JOIN oay_file ON rud01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ruduser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rudgrup=gem_file.gem01 ",
                       " WHERE rud02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rudacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rudconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rudconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rud_file.rud02,rud_file.rud01"
        PREPARE u702_part16 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart16 CURSOR FOR u702_part16
            FOREACH u702_cart16 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (17) ruf_file ==========
        LET g_sql = "SELECT 'ART',ruf01,gee05,oaydesc,ruf02,rufcrat,rufconf,'',rufuser ,zx02,rufgrup,gem02",
                       " FROM ruf_file LEFT OUTER JOIN oay_file ON ruf01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rufuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rufgrup=gem_file.gem01 ",
                       " WHERE ruf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rufacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rufconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rufconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY ruf_file.ruf02,ruf_file.ruf01" 
        PREPARE u702_part17 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart17 CURSOR FOR u702_part17
            FOREACH u702_cart17 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (18) rui_file ==========
        LET g_sql = "SELECT 'ART',rui01,gee05,oaydesc,ruicrat,ruicrat,ruiconf,'',ruiuser ,zx02,ruigrup,gem02",
                       " FROM rui_file LEFT OUTER JOIN oay_file ON rui01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ruiuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ruigrup=gem_file.gem01 ",
                       " WHERE ruicrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND ruiacti = 'Y' "     #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND ruiconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND ruiconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rui_file.ruicrat,rui_file.rui01"
        PREPARE u702_part18 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart18 CURSOR FOR u702_part18
            FOREACH u702_cart18 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (19) ruk_file ==========
        LET g_sql = "SELECT 'ART',ruk01,gee05,oaydesc,ruk04,rukcrat,rukconf,'',rukuser ,zx02,rukgrup,gem02",
                       " FROM ruk_file LEFT OUTER JOIN oay_file ON ruk01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rukuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rukgrup=gem_file.gem01 ",
                       " WHERE ruk04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rukacti = 'Y' "     #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rukconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rukconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY ruk_file.ruk04,ruk_file.ruk01"
        PREPARE u702_part19 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart19 CURSOR FOR u702_part19
            FOREACH u702_cart19 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (20) rum_file ==========
        LET g_sql = "SELECT 'ART',rum01,gee05,oaydesc,rum04,rumcrat,rumconf,'',rumuser ,zx02,rumgrup,gem02",
                       " FROM rum_file LEFT OUTER JOIN oay_file ON rum01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rumuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rumgrup=gem_file.gem01 ",
                       " WHERE rum04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rumacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rumconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rumconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rum_file.rum04,rum_file.rum01"
        PREPARE u702_part20 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart20 CURSOR FOR u702_part20
            FOREACH u702_cart20 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        
        # ========= (21) ruo_file ==========
        IF tm.x = 'Y' THEN   #MOD-D60213
           LET g_sql = "SELECT 'ART',ruo01,gee05,oaydesc,ruo07,ruocrat,ruoconf,ruo15,ruouser ,zx02,ruogrup,gem02",
                          " FROM ruo_file LEFT OUTER JOIN oay_file ON ruo01 like rtrim(ltrim(oayslip)) || '-%' ",
                          " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                          " LEFT OUTER JOIN zx_file ON ruouser=zx_file.zx01 ",
                          " LEFT OUTER JOIN gem_file ON ruogrup=gem_file.gem01 ",
                          " WHERE ruo07 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                          " AND ruoacti = 'Y' "     #CHI-CB0044 add
           #判斷已作廢單據
           IF tm.y='Y' THEN
              LET g_sql=g_sql CLIPPED," AND (ruoconf = 'X' OR ruo15 <> 'Y')" CLIPPED
           ELSE
              LET g_sql=g_sql CLIPPED," AND ruo15 <> 'Y' " CLIPPED 
           END IF
           LET g_sql= g_sql CLIPPED," ORDER BY ruo_file.ruo07,ruo_file.ruo01"
           
           PREPARE u702_part21 FROM g_sql
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('prepare:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time
               EXIT PROGRAM
           END IF
           DECLARE u702_cart21 CURSOR FOR u702_part21
               FOREACH u702_cart21 INTO sr.*
           
           #判斷當前營運中心是否為撥入營運中心
           SELECT COUNT(*) INTO l_cnt2 FROM ruo_file WHERE ruo01 = sr.g02 AND ruo05 = g_plant
           IF l_cnt2 >= 1 THEN     #當前營運中心為撥入營運中心
              IF sr.g06 = '0' OR sr.g06 = '1' THEN 
                 LET sr.g06 = 'N'        #開立,撥出確認=未確認
              END IF
              IF sr.g07 <> 'Y' OR cl_null(sr.g07) THEN
                 LET sr.g07 = 'N'        #開立,撥出確認 = 未扣帳 
              END IF
           ELSE
              IF sr.g06 = '0' THEN
                 LET sr.g06 = 'N'
              END IF
              IF sr.g07 <> 'Y' OR cl_null(sr.g07) THEN
                 LET sr.g07 = 'N'
              END IF
           END IF
              
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
              ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
              EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                        sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
           END FOREACH
        END IF #MOD-D60213
        # ========= (22) ruq_file ==========
        LET g_sql = "SELECT 'ART',ruq01,gee05,oaydesc,ruq03,ruqcrat,ruqconf,ruq12,ruquser ,zx02,ruqgrup,gem02",
                       " FROM ruq_file LEFT OUTER JOIN oay_file ON ruq01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ruquser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ruqgrup=gem_file.gem01 ",
                       " WHERE ruq03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND ruqacti = 'Y' "    #HCI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND ruqconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND ruqconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY ruq_file.ruq03,ruq_file.ruq01"

        PREPARE u702_part22 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart22 CURSOR FOR u702_part22
            FOREACH u702_cart22 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (23) rus_file ==========
        LET g_sql = "SELECT 'ART',rus01,gee05,oaydesc,rus03,ruscrat,rusconf,'',rususer ,zx02,rusgrup,gem02",
                       " FROM rus_file LEFT OUTER JOIN oay_file ON rus01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rususer=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rusgrup=gem_file.gem01 ",
                       " WHERE rus03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rusacti = 'Y' "         #CHI-CB0044 add
                      
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rusconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rusconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED, " ORDER BY rus_file.rus03,rus_file.rus01" 

        PREPARE u702_part23 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart23 CURSOR FOR u702_part23
            FOREACH u702_cart23 INTO sr.*
        IF sr.g07 != 3 THEN
           LET sr.g07 = 'N'
        END IF
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (24) ruu_file ==========
        LET g_sql = "SELECT 'ART',ruu01,gee05,oaydesc,ruu03,ruucrat,ruuconf,'',ruuuser ,zx02,ruugrup,gem02",
                       " FROM ruu_file LEFT OUTER JOIN oay_file ON ruu01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ruuuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ruugrup=gem_file.gem01 ",
                       " WHERE ruu03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND ruuacti = 'Y' "    #CHI-BC0044 add
                       

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND ruuconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND ruuconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY ruu_file.ruu03,ruu_file.ruu01"

        PREPARE u702_part24 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart24 CURSOR FOR u702_part24
            FOREACH u702_cart24 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (25) ruw_file ==========
        LET g_sql = "SELECT 'ART',ruw01,gee05,oaydesc,ruw04,ruwcrat,ruwconf,'',ruwuser ,zx02,ruwgrup,gem02",
                       " FROM ruw_file LEFT OUTER JOIN oay_file ON ruw01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ruwuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ruwgrup=gem_file.gem01 ",
                       " WHERE ruw04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND ruwacti = 'Y' "    #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND ruwconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND ruwconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY ruw_file.ruw04,ruw_file.ruw01"

        PREPARE u702_part25 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart25 CURSOR FOR u702_part25
            FOREACH u702_cart25 INTO sr.*
        IF sr.g07 != 3 THEN
           LET sr.g07 = 'N'
        END IF
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (26) ruy_file ==========
        LET g_sql = "SELECT 'ART',ruy01,gee05,gee05,oaydesc,ruy04,ruycrat,ruyconf,'',ruyuser ,zx02,ruygrup,gem02",
                       " FROM ruy_file LEFT OUTER JOIN oay_file ON ruy01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ruyuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ruygrup=gem_file.gem01 ",
                       " WHERE ruy04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND ruyacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND ruyconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND ruyconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY ruy_file.ruy04,ruy_file.ruy01"

        PREPARE u702_part26 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart26 CURSOR FOR u702_part26
            FOREACH u702_cart26 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (27) rvc_file ==========
        LET g_sql = "SELECT 'ART',rvc01,gee05,oaydesc,rvc04,rvccrat,rvcconf,'',rvcuser ,zx02,rvcgrup,gem02",
                       " FROM rvc_file LEFT OUTER JOIN oay_file ON rvc01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rvcuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rvcgrup=gem_file.gem01 ",
                       " WHERE rvc04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rvcacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rvcconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rvcconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rvc_file.rvc04,rvc_file.rvc01"

        PREPARE u702_part27 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart27 CURSOR FOR u702_part27
            FOREACH u702_cart27 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (28) rvm_file ==========
        LET g_sql = "SELECT 'ART',rvm01,gee05,oaydesc,rvm02,rvmcrat,rvmconf,'',rvmuser ,zx02,rvmgrup,gem02",
                       " FROM rvm_file LEFT OUTER JOIN oay_file ON rvm01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rvmuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rvmgrup=gem_file.gem01 ",
                       " WHERE rvm02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rvmacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rvmconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rvmconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rvm_file.rvm02,rvm_file.rvm01"

        PREPARE u702_part28 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart28 CURSOR FOR u702_part28
            FOREACH u702_cart28 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (29) rvo_file ==========
        LET g_sql = "SELECT 'ART',rvo01,gee05,oaydesc,rvo03,rvocrat,rvoconf,'',rvouser ,zx02,rvogrup,gem02",
                       " FROM rvo_file LEFT OUTER JOIN oay_file ON rvo01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rvouser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rvogrup=gem_file.gem01 ",
                       " WHERE rvo03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rvoacti = 'Y' "  #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rvoconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rvoconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rvo_file.rvo03,rvo_file.rvo01"

        PREPARE u702_part29 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart29 CURSOR FOR u702_part29
            FOREACH u702_cart29 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (30) rwv_file ==========
        LET g_sql = "SELECT 'ART',rwv01,gee05,oaydesc,rwv02,rwvcrat,rwvconf,'',rwvuser ,zx02,rwvgrup,gem02",
                       " FROM rwv_file LEFT OUTER JOIN oay_file ON rwv01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rwvuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rwvgrup=gem_file.gem01 ",
                       " WHERE rwv02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                       

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rwvconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rwvconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rwv_file.rwv02,rwv_file.rwv01"

        PREPARE u702_part30 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart30 CURSOR FOR u702_part30
            FOREACH u702_cart30 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (31) rxa_file ==========
       #LET g_sql = "SELECT 'ART',rxa01,oaydesc,rxacrat,rxacrat,rxaconf,'',rxauser ,zx02,rxagrup,gem02", #FUN-D30097 mark
        LET g_sql = "SELECT 'ART',rxa01,gee05,oaydesc,rxa09,rxacrat,rxaconf,'',rxauser ,zx02,rxagrup,gem02",   #FUN-D30097 add
                       " FROM rxa_file LEFT OUTER JOIN oay_file ON rxa01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rxauser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rxagrup=gem_file.gem01 ",
                      #" WHERE rxacrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'", #FUN-D30097 mark
                       " WHERE rxa09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",   #FUN-D30097 add
                       " AND rxaacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rxaconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rxaconf = 'N' " CLIPPED
        END IF
       #LET g_sql= g_sql CLIPPED," ORDER BY rxa_file.rxacrat,rxa_file.rxa01"  #FUN-D30097 mark
        LET g_sql= g_sql CLIPPED," ORDER BY rxa_file.rxa09,rxa_file.rxa01"    #FUN-D30097 add

        PREPARE u702_part31 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart31 CURSOR FOR u702_part31
            FOREACH u702_cart31 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (32) rxm_file ==========
        LET g_sql = "SELECT 'ART',rxm01,gee05,oaydesc,rxm02,rxmcrat,rxmconf,'',rxmuser ,zx02,rxmgrup,gem02",
                       " FROM rxm_file LEFT OUTER JOIN oay_file ON rxm01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rxmuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rxmgrup=gem_file.gem01 ",
                       " WHERE rxm02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rxmacti = 'Y' "    #CHI-CB00044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rxmconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rxmconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rxm_file.rxm02,rxm_file.rxm01"

        PREPARE u702_part32 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart32 CURSOR FOR u702_part32
            FOREACH u702_cart32 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (33) rxp_file ==========
        LET g_sql = "SELECT 'ART',rxp01,gee05,oaydesc,rxp02,rxpcrat,rxpconf,'',rxpuser ,zx02,rxpgrup,gem02",
                       " FROM rxp_file LEFT OUTER JOIN oay_file ON rxp01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rxpuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rxpgrup=gem_file.gem01 ",
                       " WHERE rxp02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rxpacti = 'Y' "   #CHI-CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rxpconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rxpconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rxp_file.rxp02,rxp_file.rxp01" 

        PREPARE u702_part33 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart33 CURSOR FOR u702_part33
            FOREACH u702_cart33 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (34) rxr_file ==========
        LET g_sql = "SELECT 'ART',rxr01,gee05,oaydesc,rxr05,rxrcrat,rxrconf,'',rxruser ,zx02,rxrgrup,gem02",
                       " FROM rxr_file LEFT OUTER JOIN oay_file ON rxr01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rxruser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rxrgrup=gem_file.gem01 ",
                       " WHERE rxr05 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND rxracti = 'Y' "   #CHI-CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rxrconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rxrconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rxr_file.rxr05,rxr_file.rxr01"


        PREPARE u702_part34 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart34 CURSOR FOR u702_part34
            FOREACH u702_cart34 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (35) rym_file ==========
        LET g_sql = "SELECT 'ART',rym01,gee05,oaydesc,rym02,rymcrat,rymconf,'',rymuser ,zx02,rymgrup,gem02",
                       " FROM rym_file LEFT OUTER JOIN oay_file ON rym01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON rymuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON rymgrup=gem_file.gem01 ",
                       " WHERE rym02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND rymconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND rymconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY rym_file.rym02,rym_file.rym01"

        PREPARE u702_part35 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart35 CURSOR FOR u702_part35
            FOREACH u702_cart35 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (36) ryv_file ==========
        LET g_sql = "SELECT 'ART',ryv01,gee05,oaydesc,ryv03,ryvcrat,ryvconf,'',ryvuser ,zx02,ryvgrup,gem02",
                       " FROM ryv_file LEFT OUTER JOIN oay_file ON ryv01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ryvuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ryvgrup=gem_file.gem01 ",
                       " WHERE ryv03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND ryvacti = 'Y' "     #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND ryvconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND ryvconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY ryv_file.ryv03,ryv_file.ryv01"

        PREPARE u702_part36 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_cart36 CURSOR FOR u702_part36
            FOREACH u702_cart36 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
     END IF
     # **    招商系統 (系統別:ALM)    **
     # *********************************
     IF  tm.k = 'Y'  THEN

        # ========= (1) lte_file ==========
        LET g_sql = "SELECT 'ALM',lte01,gee05,oaydesc,ltecrat,ltecrat,lte03,'',lteuser ,zx02,ltegrup,gem02",
                       " FROM lte_file LEFT OUTER JOIN oay_file ON lte01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lteuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ltegrup=gem_file.gem01 ",
                       " WHERE ltecrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lteacti = 'Y' "   #CHI-CB0044 add
 
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lte03!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lte03 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lte_file.ltecrat,lte_file.lte01"

        PREPARE u702_palm1 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm1 CURSOR FOR u702_palm1
            FOREACH u702_calm1 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (2) lta_file ==========
        LET g_sql = "SELECT 'ALM',lta01,gee05,oaydesc,ltacrat,ltacrat,lta03,'',ltauser ,zx02,ltagrup,gem02",
                       " FROM lta_file LEFT OUTER JOIN oay_file ON lta01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON ltauser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON ltagrup=gem_file.gem01 ",
                       " WHERE ltacrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND ltaacti = 'Y' "   #CHI-CB0044 add
 
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lta03!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lta03 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lta_file.ltacrat,lta_file.lta01"

        PREPARE u702_palm2 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm2 CURSOR FOR u702_palm2
            FOREACH u702_calm2 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (3) lsc_file ==========
        LET g_sql = "SELECT 'ALM',lsc01,gee05,oaydesc,lsc07,lsccrat,lsc14,'',lscuser ,zx02,lscgrup,gem02",
                       " FROM lsc_file LEFT OUTER JOIN oay_file ON lsc01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lscuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lscgrup=gem_file.gem01 ",
                       " WHERE lsc07 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                       
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lsc14!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lsc14 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lsc_file.lsc07,lsc_file.lsc01"


        PREPARE u702_palm3 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm3 CURSOR FOR u702_palm3
            FOREACH u702_calm3 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (4) lrx_file ==========
        LET g_sql = "SELECT 'ALM',lrx01,gee05,oaydesc,lrx05,lrxcrat,lrx06,'',lrxuser ,zx02,lrxgrup,gem02",
                       " FROM lrx_file LEFT OUTER JOIN oay_file ON lrx01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add3
                       " LEFT OUTER JOIN zx_file ON lrxuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lrxgrup=gem_file.gem01 ",
                       " WHERE lrx05 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lrxacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lrx06!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lrx06 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lrx_file.lrx05,lrx_file.lrx01"

        PREPARE u702_palm4 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm4 CURSOR FOR u702_palm4
            FOREACH u702_calm4 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (5) lrw_file ==========
        LET g_sql = "SELECT 'ALM',lrw01,gee05,oaydesc,lrw15,lrwcrat,lrw16,'',lrwuser ,zx02,lrwgrup,gem02",
                       " FROM lrw_file LEFT OUTER JOIN oay_file ON lrw01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lrwuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lrwgrup=gem_file.gem01 ",
                       " WHERE lrw15 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lrwacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lrw16!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lrw16 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lrw_file.lrw15,lrw_file.lrw01"

        PREPARE u702_palm5 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm5 CURSOR FOR u702_palm5
            FOREACH u702_calm5 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (6) lru_file ==========
        LET g_sql = "SELECT 'ALM',lru01,gee05,oaydesc,lru05,lrucrat,lru06,'',lruuser ,zx02,lrugrup,gem02",
                       " FROM lru_file LEFT OUTER JOIN oay_file ON lru01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lruuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lrugrup=gem_file.gem01 ",
                       " WHERE lru05 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lruacti = 'Y' " #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lru06!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lru06 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lru_file.lru05,lru_file.lru01"

        PREPARE u702_palm6 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm6 CURSOR FOR u702_palm6
            FOREACH u702_calm6 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (7) lrs_file ==========
        LET g_sql = "SELECT 'ALM',lrs01,gee05,oaydesc,lrs02,lrscrat,lrs03,'',lrsuser ,zx02,lrsgrup,gem02",
                       " FROM lrs_file LEFT OUTER JOIN oay_file ON lrs01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lrsuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lrsgrup=gem_file.gem01 ",
                       " WHERE lrs02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lrsacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lrs03!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lrs03 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lrs_file.lrs02,lrs_file.lrs01"

        PREPARE u702_palm7 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm7 CURSOR FOR u702_palm7
            FOREACH u702_calm7 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (8) lrl_file ==========
        LET g_sql = "SELECT 'ALM',lrl01,gee05,oaydesc,lrlcrat,lrlcrat,lrl11,'',lrluser ,zx02,lrlgrup,gem02",
                       " FROM lrl_file LEFT OUTER JOIN oay_file ON lrl01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lrluser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lrlgrup=gem_file.gem01 ",
                       " WHERE lrlcrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lrlacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lrl11!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lrl11 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lrl_file.lrlcrat,lrl_file.lrl01"

        PREPARE u702_palm8 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm8 CURSOR FOR u702_palm8
            FOREACH u702_calm8 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (9) lrj_file ==========
        LET g_sql = "SELECT 'ALM',lrj01,gee05,oaydesc,lrjcrat,lrjcrat,lrj10,'',lrjuser ,zx02,lrjgrup,gem02",
                       " FROM lrj_file LEFT OUTER JOIN oay_file ON lrj01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lrjuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lrjgrup=gem_file.gem01 ",
                       " WHERE lrjcrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lrjacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lrj10!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lrj10 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lrj_file.lrjcrat, lrj_file.lrj01"

        PREPARE u702_palm9 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm9 CURSOR FOR u702_palm9
            FOREACH u702_calm9 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (10) lqr_file ==========
        LET g_sql = "SELECT 'ALM',lqr01,gee05,oaydesc,lqr02,lqr02,lqrconf,'',lqruser ,zx02,lqrgrup,gem02",
                       " FROM lqr_file LEFT OUTER JOIN oay_file ON lqr01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lqruser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lqrgrup=gem_file.gem01 ",
                       " WHERE lqr02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lqracti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lqrconf!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lqrconf = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lqr_file.lqr02,lqr_file.lqr01" 

        PREPARE u702_palm10 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm10 CURSOR FOR u702_palm10
            FOREACH u702_calm10 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (11) lqn_file ==========
        LET g_sql = "SELECT 'ALM',lqn01,gee05,oaydesc,lqn06,lqncrat,lqn09,'',lqnuser ,zx02,lqngrup,gem02",
                       " FROM lqn_file LEFT OUTER JOIN oay_file ON lqn01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lqnuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lqngrup=gem_file.gem01 ",
                       " WHERE lqn06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                       

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lqn09!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lqn09 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lqn_file.lqn06,lqn_file.lqn01"

        PREPARE u702_palm11 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm11 CURSOR FOR u702_palm11
            FOREACH u702_calm11 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (12) lqg_file ==========
        LET g_sql = "SELECT 'ALM',lqg01,gee05,oaydesc,lqgcrat,lqgcrat,lqg07,'',lqguser ,zx02,lqggrup,gem02",
                       " FROM lqg_file LEFT OUTER JOIN oay_file ON lqg01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lqguser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lqggrup=gem_file.gem01 ",
                       " WHERE lqgcrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lqgacti = 'Y' "   #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lqg07!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lqg07 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lqg_file.lqgcrat,lqg_file.lqg01"

        PREPARE u702_palm12 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm12 CURSOR FOR u702_palm12
            FOREACH u702_calm12 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (13) lqd_file ==========
        LET g_sql = "SELECT 'ALM',lqd01,gee05,oaydesc,lqd06,lqdcrat,lqd12,'',lqduser ,zx02,lqdgrup,gem02",
                       " FROM lqd_file LEFT OUTER JOIN oay_file ON lqd01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lqduser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lqdgrup=gem_file.gem01 ",
                       " WHERE lqd06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                      
 
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lqd12!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lqd12 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED, " ORDER BY lqd_file.lqd06,lqd_file.lqd01"

        PREPARE u702_palm13 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm13 CURSOR FOR u702_palm13
            FOREACH u702_calm13 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (14) lqa_file ==========
        LET g_sql = "SELECT 'ALM',lqa01,gee05,oaydesc,lqa04,lqacrat,lqa07,'',lqauser ,zx02,lqagrup,gem02",
                       " FROM lqa_file LEFT OUTER JOIN oay_file ON lqa01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lqauser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lqagrup=gem_file.gem01 ",
                       " WHERE lqa04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lqaacti = 'Y' "    #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lqa07!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lqa07 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lqa_file.lqa04,lqa_file.lqa01"

        PREPARE u702_palm14 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm14 CURSOR FOR u702_palm14
            FOREACH u702_calm14 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (15) lpy_file ==========
        LET g_sql = "SELECT 'ALM',lpy02,gee05,oaydesc,lpy17,lpycrat,lpy13,'',lpyuser ,zx02,lpygrup,gem02",
                       " FROM lpy_file LEFT OUTER JOIN oay_file ON lpy02 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lpyuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lpygrup=gem_file.gem01 ",
                       " WHERE lpy17 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lpyacti = 'Y' "   #CHI-CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lpy13!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lpy13 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lpy_file.lpy17,lpy_file.lpy02"


        PREPARE u702_palm15 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm15 CURSOR FOR u702_palm15
            FOREACH u702_calm15 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (16) lpv_file ==========
        LET g_sql = "SELECT 'ALM',lpv01,gee05,oaydesc,lpvcrat,lpvcrat,lpv08,'',lpvuser ,zx02,lpvgrup,gem02",
                       " FROM lpv_file LEFT OUTER JOIN oay_file ON lpv01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lpvuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lpvgrup=gem_file.gem01 ",
                       " WHERE lpvcrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lpvacti = 'Y' "   #HCI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lpv08!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lpv08 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lpv_file.lpvcrat,lpv_file.lpv01"

        PREPARE u702_palm16 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm16 CURSOR FOR u702_palm16
            FOREACH u702_calm16 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (17) lpu_file ==========
        LET g_sql = "SELECT 'ALM',lpu01,gee05,oaydesc,lpucrat,lpucrat,lpu08,'',lpuuser ,zx02,lpugrup,gem02",
                       " FROM lpu_file LEFT OUTER JOIN oay_file ON lpu01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lpuuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lpugrup=gem_file.gem01 ",
                       " WHERE lpucrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lpuacti = 'Y'  "    #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lpu08!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lpu08 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lpu_file.lpucrat,lpu_file.lpu01"

        PREPARE u702_palm17 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm17 CURSOR FOR u702_palm17
            FOREACH u702_calm17 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (18) lps_file ==========
        LET g_sql = "SELECT 'ALM',lps01,gee05,oaydesc,lps03,lpscrat,lps09,'',lpsuser ,zx02,lpsgrup,gem02",
                       " FROM lps_file LEFT OUTER JOIN oay_file ON lps01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lpsuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lpsgrup=gem_file.gem01 ",
                       " WHERE lps03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lpsacti = 'Y' "    #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lps09!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lps09 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lps_file.lps03,lps_file.lps01"

        PREPARE u702_palm18 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm18 CURSOR FOR u702_palm18
            FOREACH u702_calm18 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (19) lpo_file ==========
        LET g_sql = "SELECT 'ALM',lpo01,gee05,oaydesc,lpocrat,lpocrat,lpo07,'',lpouser ,zx02,lpogrup,gem02",
                       " FROM lpo_file LEFT OUTER JOIN oay_file ON lpo01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lpouser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lpogrup=gem_file.gem01 ",
                       " WHERE lpocrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lpoacti = 'Y' "    #CHI-CB0044 add
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lpo07!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lpo07 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lpo_file.lpocrat,lpo_file.lpo01"


        PREPARE u702_palm19 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm19 CURSOR FOR u702_palm19
            FOREACH u702_calm19 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (20) lnt_file ==========
        LET g_sql = "SELECT 'ALM',lnt01,gee05,oaydesc,lnt03,lntcrat,lnt26,'',lntuser ,zx02,lntgrup,gem02",
                       " FROM lnt_file LEFT OUTER JOIN oay_file ON lnt01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lntuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lntgrup=gem_file.gem01 ",
                       " WHERE lnt03 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                       " AND lntacti = 'Y' "    #CHI-CB0044 add

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lnt26!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lnt26 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lnt_file.lnt03,lnt_file.lnt01"

        PREPARE u702_palm20 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm20 CURSOR FOR u702_palm20
            FOREACH u702_calm20 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (21) lnb_file ==========
        LET g_sql = "SELECT 'ALM',lnb01,gee05,oaydesc,lnbcrat,lnbcrat,lnb33,'',lnbuser ,zx02,lnbgrup,gem02",
                       " FROM lnb_file LEFT OUTER JOIN oay_file ON lnb01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lnbuser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lnbgrup=gem_file.gem01 ",
                       " WHERE lnbcrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                       

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lnb33!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lnb33 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lnb_file.lnbcrat,lnb_file.lnb01"

        PREPARE u702_palm21 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm21 CURSOR FOR u702_palm21
            FOREACH u702_calm21 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (22) lna_file ==========
        LET g_sql = "SELECT 'ALM',lna01,gee05,oaydesc,lnacrat,lnacrat,lna26,'',lnauser ,zx02,lnagrup,gem02",
                       " FROM lna_file LEFT OUTER JOIN oay_file ON lna01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lnauser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lnagrup=gem_file.gem01 ",
                       " WHERE lnacrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                       
        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lna26!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lna26 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lna_file.lncrat,lna_file.lna01"


        PREPARE u702_palm22 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm22 CURSOR FOR u702_palm22
            FOREACH u702_calm22 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH
        # ========= (23) lmg_file ==========
        LET g_sql = "SELECT 'ALM',lmg01,gee05,oaydesc,lmgcrat,lmgcrat,lmg08,'',lmguser ,zx02,lmggrup,gem02",
                       " FROM lmg_file LEFT OUTER JOIN oay_file ON lmg01 like rtrim(ltrim(oayslip)) || '-%' ",
                       " left join gee_file on gee01 ='AXM' and gee02 = oaytype and gee03='2' and gee04 ='axmi010'", #darcy:2023/12/04 add
                       " LEFT OUTER JOIN zx_file ON lmguser=zx_file.zx01 ",
                       " LEFT OUTER JOIN gem_file ON lmggrup=gem_file.gem01 ",
                       " WHERE lmgcrat BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
                       

        #判斷已作廢單據
        IF tm.y='Y' THEN
           LET g_sql=g_sql CLIPPED," AND lmg08!='Y' " CLIPPED
        ELSE
           LET g_sql=g_sql CLIPPED," AND lmg08 = 'N' " CLIPPED
        END IF
        LET g_sql= g_sql CLIPPED," ORDER BY lmg_file.lmgcrat,lmg_file.lmg01"

        PREPARE u702_palm23 FROM g_sql
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
        END IF
        DECLARE u702_calm23 CURSOR FOR u702_palm23
            FOREACH u702_calm23 INTO sr.*

        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING sr.g01,sr.g02,sr.g10,sr.g03,sr.g04,sr.g05,
                                     sr.g06,sr.g07,sr.g08,sr.zx02,sr.g09,sr.gem02
        END FOREACH

     END IF

#FUN-BA0003 add END---------------------------------------
     #darcy:2023/05/08 add s---
     if g_tiptop = 'Y' then
         call u702_email_tiptop(l_table)
     else
     #darcy:2023/05/08 add e---
         ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
         LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED
         LET g_str = tm.bdate,";",tm.edate,";",tm.z   #MOD-850113 add tm.z
         CALL cl_prt_cs3('aoou702','aoou702',g_sql,g_str)
         #------------------------------ CR (4) ------------------------------#
     end if #darcy:2023/05/08 add
 
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081    #FUN-BA0003 mark
END FUNCTION
#No:FUN-9C0071--------精簡程式-----


#MOD-D60213--begin
FUNCTION u702_inv(p_sys,p_tab)
   DEFINE p_sys,p_tab LIKE type_file.chr3   
   
   IF tm.x = 'N' THEN
      IF   (p_sys = 'APM' AND p_tab <> 'rvu')      
        OR (p_sys = 'AXM' AND p_tab <> 'oga' AND p_tab <> 'oha')     
        OR (p_sys = 'ASF' AND p_tab <> 'sfu' AND p_tab <> 'sfk' AND p_tab <> 'ksa' AND p_tab <> 'ksc')       
        OR (p_sys = 'AFA' AND (p_tab = 'fgh' OR p_tab = 'fec' OR p_tab = 'fee'))        
        OR (p_sys = 'ALM' AND p_tab <> 'ruo')  THEN
        RETURN FALSE 
      ELSE
      	RETURN TRUE 
      END IF
   ELSE
   	  RETURN TRUE   
   END IF   
END FUNCTION
#MOD-D60213--end

#darcy:2023/05/08 add s---
# tiptop过筛
function u702_email_tiptop(p_table)
   define p_table,l_sql       string
   define l_cmd               string
   define l_cnt integer

   let l_sql = "create or replace view pqrazz0001 as ",
               "select * from ",g_cr_db_str CLIPPED ,l_table CLIPPED,
               " where g08 = 'tiptop' "
   prepare u702_view_crt from l_sql
   execute u702_view_crt

   let l_cnt = 0 
   select count(1) into l_cnt from pqrazz0001 
   if l_cnt > 0 then
      let l_cmd = "/u1/usr/tiptop/mail/fastmail -config /u1/usr/tiptop/mail/config.json -table pqrazz0001  -mail 未审核邮件提醒 -file  /u1/out/未审核邮件提醒.xlsx "
      run l_cmd
   end if

end function
#darcy:2023/05/08 add e---
