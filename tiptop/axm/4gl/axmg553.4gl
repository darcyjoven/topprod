# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axmg553.4gl
# Descriptions...: Packing List
# Date & Author..: 02/10/18 by Max
# Modify By......: 02/10/23 By Snow
# Modify.........: No.9048 04/01/12 Kammy 同一單號/項次會有多筆ogd_file資料情形
#                                         所以抓取ogd_file改放到 on every row寫
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/15 By will 報表轉XML格式
# Midify.........: No.FUN-5A0143 05/10/20 By Rosayu 報表格式修改
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-610072 06/01/20 By sarah 加印公司TITLE
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By rainy 勾選是否列印客戶料號
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.FUN-710080 07/03/19 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-740057 07/04/14 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.MOD-7A0121 07/10/22 By jamie 備註改用新的子報表寫法，舊寫法會造成資料膨脹
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990009 09/09/04 By mike invocie單號加入開窗 
# Modify.........: No.FUN-A80091 10/08/17 By yinhy 畫面條件選項增加一個選項，列印額外品名規格
# Modify.........: No:MOD-AA0023 10/10/22 By Smapmin 修改地址抓取的資料來源
# Modify.........: No:CHI-AB0029 10/11/30 By Summer 接收的參數有問題
# Modify.........: No.FUN-B40087 11/05/05 By yangtt  憑證報表轉GRW
# Modify.........: No:FUN-C10036 12/01/16 By lujh FUN-B80089追單
# Modify.........: No:FUN-C20053 12/02/27 By xuxz order by order by 修改
# Modify.........: No:FUN-C50003 12/05/14 By yangtt GR程式優化
# Modify.........: No:FUN-C30085 12/06/15 By chenying FUN-C5003優化修改 
   
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(300)   # Where condition
            d       LIKE type_file.chr1,       # No.FUN-690032             # 是否列印客戶料號
            b       LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01)    # 是否列印備註
            a       LIKE type_file.chr1,       # FUN-740057 add            # 列印公司對內全名
            c       LIKE type_file.chr1,       # FUN-740057 add            # 列印公司對外全名
            e       LIKE type_file.chr1,       # FUN-A80091 add            # 列印品名規格額外說明
            more    LIKE type_file.chr1        # Prog. Version..: '5.30.06-13.03.12(01)    # Input more condition(Y/N)
           END RECORD,
#       g_x  ARRAY[35] OF VARCHAR(40),        # Report Heading & prompt
       l_oao06    LIKE oao_file.oao06,
       x          LIKE aba_file.aba00,        # No.FUN-680137 VARCHAR(5)
       y,z        LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(1)
       tot_ctn    LIKE type_file.num10,       # No.FUN-680137 INTEGER
       wk_i       LIKE type_file.num5,        # No.FUN-680137 SMALLINT
       wk_array   DYNAMIC ARRAY OF RECORD
       	           ogd11      LIKE ogd_file.ogd11,
       	           ogd12b     LIKE ogd_file.ogd12b,
       	           ogd12e     LIKE ogd_file.ogd12e
       	  	  END RECORD,
       g_po_no,g_ctn_no1,g_ctn_no2  LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
       g_azi02    LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
       g_zo12     LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(60)
       g_zo041    LIKE zo_file.zo041,         #FUN-810029 add
       g_zo05     LIKE zo_file.zo05,          #FUN-810029 add
       g_zo09     LIKE zo_file.zo09           #FUN-810029 add
#      g_dash1     VARCHAR(132)
 
DEFINE g_i        LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
#No.FUN-580013  --begin
#DEFINE   g_dash          VARCHAR(400)   #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580013  --end
#str FUN-710080 add
DEFINE l_table    STRING
DEFINE g_sql      STRING
DEFINE g_str      STRING
#end FUN-710080 add
DEFINE l_table1   STRING   #MOD-7A012 add
DEFINE l_table2   STRING   # FUN-A80091 add
 
###GENGRE###START
TYPE sr1_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    ofa02 LIKE ofa_file.ofa02,
    ofa03 LIKE ofa_file.ofa03,
    ofa011 LIKE ofa_file.ofa011,
    ofa0351 LIKE ofa_file.ofa0351,
    ofa0451 LIKE ofa_file.ofa0451,
    ofa31 LIKE ofa_file.ofa31,
    oah02 LIKE oah_file.oah02,
    ofa32 LIKE ofa_file.ofa32,
    oag02 LIKE oag_file.oag02,
    ofa75 LIKE ofa_file.ofa75,
    occ29 LIKE occ_file.occ29,
    occ292 LIKE occ_file.occ292,
    occ231 LIKE occ_file.occ231,
    occ232 LIKE occ_file.occ232,
    occ233 LIKE occ_file.occ233,
    occ241 LIKE occ_file.occ241,
    occ242 LIKE occ_file.occ242,
    occ243 LIKE occ_file.occ243,
    ofb04 LIKE ofb_file.ofb04,
    ofb06 LIKE ofb_file.ofb06,
    ima021 LIKE ima_file.ima021,
    ofb11 LIKE ofb_file.ofb11,
    ofb05 LIKE ofb_file.ofb05,
    zo12 LIKE zo_file.zo12,
    ofb03 LIKE ofb_file.ofb03,
    ogd11 LIKE ogd_file.ogd11,
    ogd12b LIKE ogd_file.ogd12b,
    ogd12e LIKE ogd_file.ogd12e,
    ogd10 LIKE ogd_file.ogd10,
    ogd09 LIKE ogd_file.ogd09,
    ogd13 LIKE ogd_file.ogd13,
    ogd14 LIKE ogd_file.ogd14,
    ogd14t LIKE ogd_file.ogd14t,
    ogd15 LIKE ogd_file.ogd15,
    ogd15t LIKE ogd_file.ogd15t,
    ogd16 LIKE ogd_file.ogd16,
    ogd16t LIKE ogd_file.ogd16t,
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126  #FUN-C10036  mark
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql =  "ofa01.ofa_file.ofa01,    ofa02.ofa_file.ofa02,",
       "ofa03.ofa_file.ofa03,    ofa011.ofa_file.ofa011,",
       "ofa0351.ofa_file.ofa0351,ofa0451.ofa_file.ofa0451,",
       "ofa31.ofa_file.ofa31,    oah02.oah_file.oah02,",
       "ofa32.ofa_file.ofa32,    oag02.oag_file.oag02,",
       "ofa75.ofa_file.ofa75,    occ29.occ_file.occ29,",
       "occ292.occ_file.occ292,  occ231.occ_file.occ231,",
       "occ232.occ_file.occ232,  occ233.occ_file.occ233,",
       "occ241.occ_file.occ241,  occ242.occ_file.occ242,",
       "occ243.occ_file.occ243,  ofb04.ofb_file.ofb04,",
       "ofb06.ofb_file.ofb06,    ima021.ima_file.ima021,",
       "ofb11.ofb_file.ofb11,    ofb05.ofb_file.ofb05,",
       "zo12.zo_file.zo12,       ofb03.ofb_file.ofb03,",     #MOD-7A0121 add ofb03   
       "ogd11.ogd_file.ogd11,",
       "ogd12b.ogd_file.ogd12b,  ogd12e.ogd_file.ogd12e,",
       "ogd10.ogd_file.ogd10,    ogd09.ogd_file.ogd09,",
       "ogd13.ogd_file.ogd13,    ogd14.ogd_file.ogd14,",
       "ogd14t.ogd_file.ogd14t,  ogd15.ogd_file.ogd15,",
       "ogd15t.ogd_file.ogd15t,  ogd16.ogd_file.ogd16,",
       "ogd16t.ogd_file.ogd16t,",                            #MOD-7A0121  mod
       "zo041.zo_file.zo041,zo05.zo_file.zo05,zo09.zo_file.zo09,",   #FUN-810029 add
       "ofb07.ofb_file.ofb07,    l_count.type_file.num5"     #FUN-A80091  add
      #"ogd16t.ogd_file.ogd16t,  oao06h.oao_file.oao06,",    #MOD-7A0121  mod
      #"oao06d1.oao_file.oao06,  oao06d2.oao_file.oao06,",   #MOD-7A0121  mod
      #"oao06t.oao_file.oao06"                               #MOD-7A0121  mod
 
   LET l_table = cl_prt_temptable('axmg553',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time                        #FUN-B40087  #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087  #FUN-C10036  mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
  #MOD-7A0121 mark
  #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
  #            " VALUES(?,?,?,?,?, ?,?,?,?,?,",
  #            "        ?,?,?,?,?, ?,?,?,?,?,",
  #            "        ?,?,?,?,?, ?,?,?,?,?,",
  #            "        ?,?,?,?,?, ?,?,?,?,?,",
  #            "        ?)"
  #PREPARE insert_prep FROM g_sql
  #IF STATUS THEN
  #   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  #END IF
  #MOD-7A0121 mark
   #------------------------------ CR (1) ------------------------------#
 
  #MOD-7A0121---add---str---
   LET g_sql = 
       "oao01.oao_file.oao01,",
       "oao03.oao_file.oao03,",
       "oao04.oao_file.oao04,",
       "oao05.oao_file.oao05,",
       "oao06.oao_file.oao06"
   LET l_table1 = cl_prt_temptable('axmg5531',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time                        #FUN-B40087  #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087  #FUN-C10036  mark
      EXIT PROGRAM 
    END IF                   # Temp Table產生
  #MOD-7A0121---add---end---
  #No.FUN-A80091 --start--
    LET g_sql = "imc01.imc_file.imc01,",
                "imc02.imc_file.imc02,",
                "imc03.imc_file.imc03,",
                "imc04.imc_file.imc04,",
                "ofa01.ofa_file.ofa01,",
                "ofb03.ofb_file.ofb03"
    LET l_table2 = cl_prt_temptable('axmg5532',g_sql) CLIPPED
    IF l_table2 = -1 THEN 
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time                        #FUN-B40087  #FUN-C10036  mark
       #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087  #FUN-C10036  mark
       EXIT PROGRAM 
    END IF
   #No.FUN-A80091 --end--
   #------------------------------ CR (1) ------------------------------#
   LET g_zo12 = NULL
   LET g_zo041 = NULL  LET g_zo05 = NULL  LET g_zo09 = NULL   #FUN-810029 add
   SELECT zo12,zo041,zo05,zo09 INTO g_zo12,g_zo041,g_zo05,g_zo09    #FUN-810029 add zo041,zo05,zo09
     FROM zo_file WHERE zo01='1'
   #no.7210
   IF cl_null(g_zo12) THEN
      SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='0'
   END IF
   #no.7210(end)
   #str FUN-810029 add
   IF cl_null(g_zo041) THEN
      SELECT zo041 INTO g_zo041 FROM zo_file WHERE zo01='0'
   END IF
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
   LET tm.e    = ARG_VAL(11)   #FUN-A80091
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)  
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(tm.wc)
      THEN CALL axmg553_tm(0,0)             # Input print condition
      ELSE 
         #LET tm.wc="ofa01 ='",tm.wc CLIPPED,"'" #CHI-AB0029 mark
         CALL axmg553()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
END MAIN
 
FUNCTION axmg553_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmg553_w AT p_row,p_col WITH FORM "axm/42f/axmg553"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofa01,ofa02,ofa011
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      
      #FUN-990009   ---START                                                                                                        
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
      #FUN-990009   ---END        
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg553_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   LET tm.b='N'   #DEFAULT 不列印備註
   LET tm.d='Y'   #DEFAULT 列印備註客戶料號 #FUN-690032 add
   LET tm.a='Y'   #FUN-740057 add
   LET tm.c='Y'   #FUN-740057 add
   LET tm.e='N'   #FUN-A80091 add
 
   INPUT BY NAME tm.d,tm.b,tm.a,tm.c,tm.e,tm.more WITHOUT DEFAULTS  #FUN-690032 add tm.d   #FUN-740057 add tm.a,tm.c  #FUN-A80091 add tm.e
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
          IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN NEXT FIELD e END IF
      #FUN-A80089 add--end
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
         END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmg553_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axmg553'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg553','9031',1)
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
                          " '",tm.b CLIPPED,"'" ,
                          " '",tm.d CLIPPED,"'" ,  #FUN-690032 add
                          " '",tm.a CLIPPED,"'" ,                #FUN-740057 add
                          " '",tm.c CLIPPED,"'" ,                #FUN-740057 add
                          " '",tm.e CLIPPED,"'" ,                #FUN-A80091 add
                         #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                          " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                          " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                          " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmg553',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg553_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg553()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg553_w
END FUNCTION
 
FUNCTION axmg553()
   DEFINE l_name     LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
   #       l_time     LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
          l_sql      LIKE type_file.chr1000,       #No.FUN-680137  VARCHAR(1000)
          l_ogd01    LIKE ogd_file.ogd01,  #No.FUN-550070
          l_count    LIKE type_file.num5,  #No.FUN-A80091
          ofa        RECORD LIKE ofa_file.*,
          ofb        RECORD LIKE ofb_file.*,
          ogd        RECORD LIKE ogd_file.*,
          sr         RECORD
                      #-----MOD-AA0023---------
                      #occ231     LIKE occ_file.occ231,
                      #occ232     LIKE occ_file.occ232,
                      #occ233     LIKE occ_file.occ233,
                      #occ241     LIKE occ_file.occ241,
                      #occ242     LIKE occ_file.occ242,
                      #occ243     LIKE occ_file.occ243,
                      #-----END MOD-AA0023-----
                      occ29      LIKE occ_file.occ29,
                      occ292     LIKE occ_file.occ292,
                      oah02      LIKE oah_file.oah02,
                      oag02      LIKE oag_file.oag02,
                      oga02      LIKE oga_file.oga02
                     END RECORD,
         #No.FUN-A80091  --start--
         sr1        RECORD
                     imc01     LIKE imc_file.imc01,
                     imc02     LIKE imc_file.imc02,
                     imc03     LIKE imc_file.imc03,
                     imc04     LIKE imc_file.imc04
                    END RECORD
         #No.FUN-A80091  --end--
   DEFINE l_ima021   LIKE ima_file.ima021       #FUN-710080 add
   DEFINE oao        RECORD LIKE oao_file.*     #MOD-7A0121 add
   DEFINE l_cnt      LIKE type_file.num5        #MOD-7A0121 add
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)  #MOD-7A0121 add
   CALL cl_del_data(l_table2)  #No.FUN-A80091 add
   #------------------------------ CR (2) ------------------------------#
 
  #MOD-7A0121---add---str---
  #l_table
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"   #FUN-810029 38?->41?  #FUN-A80091 add 2?
   PREPARE insert_prep FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087
      EXIT PROGRAM                        
   END IF
 
  #l_table1
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql                                              
   IF STATUS THEN                                                               
      CALL cl_err("insert_prep1:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087
      EXIT PROGRAM                        
   END IF
  #MOD-7A0121---add---end---
  #No.FUN-A80091---begin                                                                                                              
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
              " VALUES(?,?,?,?,?, ?)"                                                                                 
  PREPARE insert_prep2 FROM g_sql                                                                                                
  IF STATUS THEN                                                                                                                 
     CALL cl_err("insert_prep2:",STATUS,1) 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)     #FUN-B40087
     EXIT PROGRAM                                                                          
  END IF                                                                                                                         
  #No.FUN-A80091---END
  #MOD-7A0121---mark---str---
  #DELETE FROM g553_tmp
  #DELETE FROM g553_tmp1
  #DELETE FROM g553_tmp2
 
  #LET g_sql = "INSERT INTO g553_tmp ",
  #            " VALUES(?,?,?,?,?, ?,?,?,?,?,",
  #            "        ?,?,?,?,?, ?,?,?,?,?,",
  #            "        ?,?,?,?,?)"
  #PREPARE insert_prep0 FROM g_sql
  #IF STATUS THEN
  #   CALL cl_err('insert_prep0:',status,1) EXIT PROGRAM
  #END IF
 
  #LET g_sql = "INSERT INTO g553_tmp1 ",
  #            " VALUES(?,?,?,?,?, ?,?,?,?,?,",
  #            "        ?,?,?)"
  #PREPARE insert_prep1 FROM g_sql
  #IF STATUS THEN
  #   CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM
  #END IF
 
  #LET g_sql = "INSERT INTO g553_tmp2 VALUES(?,?,?,?,?, ?,?)"
  #PREPARE insert_prep2 FROM g_sql
  #IF STATUS THEN
  #   CALL cl_err('insert_prep2:',status,1) EXIT PROGRAM
  #END IF
  ##end FUN-710080 add
  #MOD-7A0121---mark---end---
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-710080 add
 
#No.FUN-580013  --begin
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmg553'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   FOR g_i = 1 TO g_len LET g_dash1[g_i,g_i] = '-' END FOR
#No.FUN-580013  --end
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND ofauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND ofagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND ofagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
   #End:FUN-980030
 
   LET l_sql="SELECT ofa_file.*, ofb_file.*, ",
            #FUN-C50003-----mod---str---
             "  occ29,occ292,oah02,oag02,oga02 ", 
            #"  FROM ofa_file,ofb_file  ",    
             "  FROM ofa_file LEFT OUTER JOIN occ_file ON occ01=ofa03 ",
             "                LEFT OUTER JOIN oah_file ON oah01=ofa31 ",
             "                LEFT OUTER JOIN oag_file ON oag01=ofa32 ",
             "                LEFT OUTER JOIN oga_file ON oga01=ofa01 AND (oga09 = '1' OR oga09 = '5') ",       
             "      ,ofb_file ",
            #FUN-C50003-----mod---str---
             " WHERE ofa01=ofb01 ",
             "   AND ",tm.wc CLIPPED,
             "   AND ofaconf !='X' "
   PREPARE axmg553_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   DECLARE axmg553_curs1 CURSOR FOR axmg553_prepare1

  #FUN-C50003----add----str--
   DECLARE imc_cur CURSOR FOR
     SELECT * FROM imc_file
     WHERE imc01=? AND imc02=?
      ORDER BY imc03

   DECLARE ogd_cur CURSOR FOR
     SELECT * FROM ogd_file WHERE ogd01 = ? AND ogd03 = ?

   DECLARE oao_c1 CURSOR FOR                                                 
     SELECT * FROM oao_file                                               
     WHERE oao01=? AND oao03=? AND (oao05='1' OR oao05='2')
      ORDER BY oao04          
  #FUN-C50003----add----str--
 
   FOREACH axmg553_curs1 INTO ofa.*, ofb.*,sr.*,ogd.*     #FUN-C50003 add sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.9048 mark
      #SELECT ogd_file.* INTO ogd.* FROM ogd_file
      # WHERE ogd01=ofa.ofa011 AND ogd03 = ofb.ofb03
      #-----MOD-AA0023---------
      #SELECT occ231,occ232,occ233,occ241,occ242,occ243,occ29,occ292   
      #  INTO sr.occ231,sr.occ232,sr.occ233,sr.occ241,sr.occ242,
      #       sr.occ243,sr.occ29 ,sr.occ292
      #  FROM occ_file WHERE occ01 = ofa.ofa03
     #FUN-C50003---mark---str--
     #SELECT occ29,occ292   
     #  INTO sr.occ29 ,sr.occ292
     #  FROM occ_file WHERE occ01 = ofa.ofa03
     #FUN-C50003---mark---end--
      #-----END MOD-AA0023-----
     #FUN-C50003---mark---str--
     #SELECT oah02 INTO sr.oah02 FROM oah_file WHERE oah01 = ofa.ofa31
     #SELECT oag02 INTO sr.oag02 FROM oag_file WHERE oah01 = ofa.ofa32
     #SELECT oga02 INTO sr.oga02 FROM oga_file
     # WHERE oga01 = ofa.ofa011 AND (oga09 = '1' OR oga09='5') #No.8347
     #FUN-C50003---mark---end--
 
      #-----MOD-AA0023---------
      #IF ofa.ofa0352 IS NULL THEN
      #   LET ofa.ofa0352 = ofa.ofa0353 LET ofa.ofa0353 = ofa.ofa0354
      #   LET ofa.ofa0354 = ofa.ofa0355 LET ofa.ofa0355 = NULL
      #END IF
      #IF ofa.ofa0452 IS NULL THEN
      #   LET ofa.ofa0452 = ofa.ofa0453 LET ofa.ofa0453 = ofa.ofa0454
      #   LET ofa.ofa0454 = ofa.ofa0455 LET ofa.ofa0455 = NULL
      #END IF
      #-----END MOD-AA0023-----
 
      #str FUN-710080 add
      #客戶產品編號
      IF cl_null(ofb.ofb11) THEN 
         SELECT obk03 INTO ofb.ofb11 FROM obk_file
          WHERE obk01=ofb.ofb04 AND obk02=ofa.ofa03
      END IF
 
      #規格
      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01 = ofb.ofb04
 
     #MOD-7A0121---mark---str---
     #EXECUTE insert_prep0 USING
     #   ofa.ofa01  ,ofa.ofa02,ofa.ofa03,ofa.ofa011,ofa.ofa0351,
     #   ofa.ofa0451,ofa.ofa31,sr.oah02 ,ofa.ofa32 ,sr.oag02   ,
     #   ofa.ofa75  ,sr.occ29 ,sr.occ292,sr.occ231 ,sr.occ232  ,
     #   sr.occ233  ,sr.occ241,sr.occ242,sr.occ243 ,ofb.ofb04  ,
     #   ofb.ofb06  ,l_ima021 ,ofb.ofb11,ofb.ofb05 ,g_zo12
 
     #IF tm.b='Y' THEN   #是否列印備註
     #   #整張備註-列印於前
     #   DECLARE oao_c1 CURSOR FOR
     #    SELECT oao06 FROM oao_file
     #     WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05='1'
     #   FOREACH oao_c1 INTO l_oao06
     #      IF NOT cl_null(l_oao06) THEN
     #         EXECUTE insert_prep2 USING ofa.ofa01,'0','1',l_oao06,'','',''
     #      END IF
     #   END FOREACH
     #   #整張備註-列印於後
     #   DECLARE oao_c2 CURSOR FOR
     #    SELECT oao06 FROM oao_file
     #     WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05='2'
     #   FOREACH oao_c2 INTO l_oao06
     #      IF NOT cl_null(l_oao06) THEN
     #         EXECUTE insert_prep2 USING ofa.ofa01,'0','2','','','',l_oao06
     #      END IF
     #   END FOREACH
     #END IF
     #MOD-7A0121---mark---end---
    #No.FUN-A80091  --start  列印額外品名規格說明
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
          FOREACH imc_cur USING ofb.ofb04,ofb.ofb07 INTO sr1.*     #FUN-C50003 add USING ofb.ofb04,ofb.ofb07                        
            EXECUTE insert_prep2 USING sr1.imc01,sr1.imc02,sr1.imc03,sr1.imc04,ofa.ofa01,ofb.ofb03
          END FOREACH
        END IF
     END IF 
     #No.FUN-A80091  --end    
    #MOD-7A0045 add
     SELECT COUNT(*) INTO l_cnt FROM ogd_file WHERE ogd01 = ofa.ofa011 AND ogd03 = ofb.ofb03   
     IF l_cnt <>0 THEN   
          #包裝資料檔
         #FUN-C50003----mark---str--
         #DECLARE ogd_cur CURSOR FOR
         #   SELECT * FROM ogd_file WHERE ogd01 = ofa.ofa011 AND ogd03 = ofb.ofb03
         #FUN-C50003----mark---end--
         #FOREACH ogd_cur USING ofb.ofb11,ofb.ofb03 INTO ogd.*  #FUN-C50003 add USING ofb.ofb11,ofb.ofb03  #FUN-C30085 mark
          FOREACH ogd_cur USING ofa.ofa011,ofb.ofb03 INTO ogd.*  #FUN-C50003 add USING ofb.ofb11,ofb.ofb03 #FUN-C30085 
             IF ogd.ogd04=1 AND tm.b='Y' THEN   #序號=1且要列印備註
               #MOD-7A0121---mod---str---
               ##單身備註-列印於前
               #DECLARE oao_c3 CURSOR FOR
               # SELECT oao06 FROM oao_file
               #  WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND oao05='1'
               #FOREACH oao_c3 INTO l_oao06
               #   IF NOT cl_null(l_oao06) THEN
               #      EXECUTE insert_prep2 USING ofa.ofa01,ofb.ofb03,'1','',l_oao06,'',''
               #   END IF
               #END FOREACH
               ##單身備註-列印於後
               #DECLARE oao_c4 CURSOR FOR
               # SELECT oao06 FROM oao_file
               #  WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND oao05='2'
               #FOREACH oao_c4 INTO l_oao06
               #   IF NOT cl_null(l_oao06) THEN
               #      EXECUTE insert_prep2 USING ofa.ofa01,ofb.ofb03,'2','','',l_oao06,''
               #   END IF
               #END FOREACH
          
               #列印單身備註
               #FUN-C50003----mark---str--
               #DECLARE oao_c1 CURSOR FOR                                                 
               # SELECT * FROM oao_file                                               
               #  WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND (oao05='1' OR oao05='2')
               #  ORDER BY oao04          
               #FUN-C50003----mark---end--                                                
                FOREACH oao_c1 USING ofa.ofa01,ofb.ofb03 INTO oao.*       #FUN-C50003 add USING ofa.ofa01,ofb.ofb03                                        
                   IF NOT cl_null(oao.oao06) THEN
                      EXECUTE insert_prep1 USING 
                         ofa.ofa01,ofb.ofb03,oao.oao04,oao.oao05,oao.oao06                
                   END IF                                                                 
                END FOREACH                                                               
               #MOD-7A0121---mod---end---
             END IF
             IF cl_null(ogd.ogd14)  THEN LET ogd.ogd14 = 0 END IF
             IF cl_null(ogd.ogd14t) THEN LET ogd.ogd14t= 0 END IF
             IF cl_null(ogd.ogd15)  THEN LET ogd.ogd15 = 0 END IF
             IF cl_null(ogd.ogd15t) THEN LET ogd.ogd15t= 0 END IF
             IF cl_null(ogd.ogd16)  THEN LET ogd.ogd16 = 0 END IF
             IF cl_null(ogd.ogd16t) THEN LET ogd.ogd16t= 0 END IF
            #MOD-7A0121---mod---str---
            #EXECUTE insert_prep1 USING
            #   ofa.ofa01 ,ogd.ogd11,ogd.ogd12b,ogd.ogd12e,ogd.ogd10,
            #   ogd.ogd09 ,ogd.ogd13,ogd.ogd14 ,ogd.ogd14t,ogd.ogd15,
            #   ogd.ogd15t,ogd.ogd16,ogd.ogd16t
                    
             EXECUTE insert_prep USING
             ofa.ofa01  ,ofa.ofa02 ,ofa.ofa03 ,ofa.ofa011,ofa.ofa0351,
             ofa.ofa0451,ofa.ofa31 ,sr.oah02  ,ofa.ofa32 ,sr.oag02   ,
             #-----MOD-AA0023---------
             #ofa.ofa75  ,sr.occ29  ,sr.occ292 ,sr.occ231 ,sr.occ232  ,
             #sr.occ233  ,sr.occ241 ,sr.occ242 ,sr.occ243 ,ofb.ofb04  ,
             ofa.ofa75  ,sr.occ29  ,sr.occ292 ,ofa.ofa0353 ,ofa.ofa0354  ,
             ofa.ofa0355  ,ofa.ofa0453 ,ofa.ofa0454 ,ofa.ofa0455 ,ofb.ofb04  ,
             #-----END MOD-AA0023----- 
             ofb.ofb06  ,l_ima021  ,ofb.ofb11 ,ofb.ofb05 ,g_zo12,
             ofb.ofb03  ,
             ogd.ogd11  ,ogd.ogd12b,ogd.ogd12e,ogd.ogd10 ,
             ogd.ogd09  ,ogd.ogd13 ,ogd.ogd14 ,ogd.ogd14t,ogd.ogd15,
             ogd.ogd15t ,ogd.ogd16 ,ogd.ogd16t,
             g_zo041    ,g_zo05    ,g_zo09    ,ofb.ofb07 ,l_count    #FUN-810029 add  #FUN-A80091 add ofb.ofb07 ,l_count
            #MOD-7A0121---mod---end---
          END FOREACH
            #MOD-7A0121---mod---str---
    ELSE
            
             EXECUTE insert_prep USING
             ofa.ofa01  ,ofa.ofa02 ,ofa.ofa03 ,ofa.ofa011,ofa.ofa0351,
             ofa.ofa0451,ofa.ofa31 ,sr.oah02  ,ofa.ofa32 ,sr.oag02   ,
             #-----MOD-AA0023---------
             #ofa.ofa75  ,sr.occ29  ,sr.occ292 ,sr.occ231 ,sr.occ232  ,
             #sr.occ233  ,sr.occ241 ,sr.occ242 ,sr.occ243 ,ofb.ofb04  ,
             ofa.ofa75  ,sr.occ29  ,sr.occ292 ,ofa.ofa0353 ,ofa.ofa0354  ,
             ofa.ofa0355  ,ofa.ofa0453 ,ofa.ofa0454 ,ofa.ofa0455 ,ofb.ofb04  ,
             #-----END MOD-AA0023----- 
             ofb.ofb06  ,l_ima021  ,ofb.ofb11 ,ofb.ofb05 ,g_zo12,
             ofb.ofb03  ,
             '','0','0','0','0','0','0','0','0','0','0','0',
             g_zo041    ,g_zo05    ,g_zo09 ,ofb.ofb07 ,l_count  #FUN-810029 add     #FUN-A80091 add ofb.ofb07 ,l_count
            #MOD-7A0121---mod---end---
    END IF
   END FOREACH
 
  #MOD-7A0121---add---str---                                                               #MOD-7A0121---mark---str--
   #列印整張備註                                                          
   IF tm.b='Y' THEN   #是否列印備註
      LET l_sql = "SELECT ofa01 FROM ofa_file ",
                  " WHERE ",tm.wc CLIPPED,      
                  "   ORDER BY ofa01"           
      PREPARE g553_prepare2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN      
         CALL cl_err('prepare2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
         EXIT PROGRAM  
      END IF           
      DECLARE g553_cs2 CURSOR FOR g553_prepare2

     #FUN-C50003----mark---str--
      DECLARE oao_c2 CURSOR FOR  
       SELECT * FROM oao_file
        WHERE oao01=? AND oao03=0 AND (oao05='1' OR oao05='2')
        ORDER BY oao04                                
     #FUN-C50003----mark---end--
                                                                                 
      FOREACH g553_cs2 INTO ofa.ofa01
         #整張前備註
        #FUN-C50003----mark---str--
        #DECLARE oao_c2 CURSOR FOR  
        # SELECT * FROM oao_file
        #  WHERE oao01=ofa.ofa01 AND oao03=0 AND (oao05='1' OR oao05='2')
        #  ORDER BY oao04                                
        #FUN-C50003----mark---end--
         FOREACH oao_c2 USING ofa.ofa01 INTO oao.*    #FUN-C50003 add USING ofa.ofa01
            IF NOT cl_null(oao.oao06) THEN
               EXECUTE insert_prep1 USING
                  ofa.ofa01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
            END IF                                         
         END FOREACH
      END FOREACH    
   END IF 
 
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", 
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###               " WHERE oao03 =0 AND oao05='1'","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###               " WHERE oao03!=0 AND oao05='1'","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###               " WHERE oao03!=0 AND oao05='2'","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
###GENGRE###               " WHERE oao03 =0 AND oao05='2'","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
 
  #MOD-7A0121---add---end---                                                               #MOD-7A0121---mark---str--
 
  ##str FUN-710080 add
  #LET l_sql=
  #    "SELECT A.*,",
  #    "       B.ogd11,B.ogd12b,B.ogd12e,B.ogd10,B.ogd09,",
  #    "       B.ogd13,B.ogd14,B.ogd14t,B.ogd15,B.ogd15t,",
  #    "       B.ogd16,B.ogd16t,",
  #    "       C.oao06h,C.oao06d1,C.oao06d2,C.oao06t",
  #    "  FROM g553_tmp A,",
  #    "       g553_tmp1 B,g553_tmp2 C",
  #    " WHERE A.ofa01=B.ofa01_1(+)",
  #    "   AND A.ofa01=C.ofa01_2(+)"
  #PREPARE axmg553_prepare0 FROM l_sql
  #IF SQLCA.sqlcode != 0 THEN
  #   CALL cl_err('prepare0:',SQLCA.sqlcode,1)
  #END IF
  #DECLARE axmg553_curs0 CURSOR FOR axmg553_prepare0
  #FOREACH axmg553_curs0 INTO cr.*
  #   ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
  #   EXECUTE insert_prep USING
  #      cr.ofa01  ,cr.ofa02 ,cr.ofa03 ,cr.ofa011 ,cr.ofa0351,
  #      cr.ofa0451,cr.ofa31 ,cr.oah02 ,cr.ofa32  ,cr.oag02  ,
  #      cr.ofa75  ,cr.occ29 ,cr.occ292,cr.occ231 ,cr.occ232 ,
  #      cr.occ233 ,cr.occ241,cr.occ242,cr.occ243 ,cr.ofb04  ,
  #      cr.ofb06  ,cr.ima021,cr.ofb11 ,cr.ofb05  ,cr.zo12   ,
  #      cr.ogd11  ,cr.ogd12b,cr.ogd12e,cr.ogd10  ,cr.ogd09  ,
  #      cr.ogd13  ,cr.ogd14 ,cr.ogd14t,cr.ogd15  ,cr.ogd15t ,
  #      cr.ogd16  ,cr.ogd16t,cr.oao06h,cr.oao06d1,cr.oao06d2,
  #      cr.oao06t
  #   #------------------------------ CR (3) ------------------------------#
  #END FOREACH
  #MOD-7A0121---mark---end--
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #MOD-7A0121 mark
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ofa01,ofa02,ofa011')
           RETURNING tm.wc  
   ELSE
      LET tm.wc = ''
   END IF                   
###GENGRE###   LET g_str = tm.d,";",tm.b,";",tm.wc,";",
###GENGRE###               tm.a,";",tm.c,";",tm.e               #FUN-740057 add tm.a,tm.c  #FUN-A80091 add tm.e
###GENGRE###   CALL cl_prt_cs3('axmg553','axmg553',g_sql,g_str)
    CALL axmg553_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
   #end FUN-710080 add
 
END FUNCTION
 
FUNCTION cnt_ogd10(wk_ogd11,wk_ogd12b,wk_ogd12e,wk_ogd10)
   DEFINE wk_ogd11   LIKE ogd_file.ogd11,
          wk_ogd12b  LIKE ogd_file.ogd12b,
          wk_ogd12e  LIKE ogd_file.ogd12e,
          wk_ogd10   LIKE ogd_file.ogd10,
          wk_j       LIKE type_file.num5,       # No.FUN-680137 SMALLINT
          sw_esit    LIKE type_file.chr1,       # No.FUN-680137 VARCHAR(1)
          l_ogd12b   LIKE type_file.chr20,      #No.FUN-690126
          l_ogd12e   LIKE type_file.chr20       #No.FUN-690126
   IF cl_null(wk_ogd11) THEN LET wk_ogd11 = ' ' END IF
#No.FUN-690126-------Begin-------
   IF l_ogd12b[1] NOT MATCHES '[A-z]' AND
      l_ogd12b[2] NOT MATCHES '[A-z]' AND
      l_ogd12b[3] NOT MATCHES '[A-z]' THEN
      LET wk_ogd12b  = l_ogd12b USING '&&&'
   END IF
   IF  l_ogd12e[1] NOT MATCHES '[A-z]' AND
       l_ogd12e[2] NOT MATCHES '[A-z]' AND
       l_ogd12e[3] NOT MATCHES '[A-z]' THEN
       LET wk_ogd12e  = l_ogd12e USING '&&&'
#No.FUN-690126-------End----------
   END IF
   LET sw_esit     = 'N'
   IF     wk_i     = 0 THEN
      LET wk_i     = wk_i + 1
      LET wk_array[wk_i].ogd11   = wk_ogd11
      LET wk_array[wk_i].ogd12b  = wk_ogd12b  USING '&&&'
      LET wk_array[wk_i].ogd12e  = wk_ogd12e  USING '&&&'
      LET tot_ctn    =    tot_ctn   + wk_ogd10
   ELSE
      FOR wk_j     =   1    TO   wk_i
          IF wk_ogd11  =    wk_array[wk_j].ogd11 THEN
             IF   (wk_ogd12b  >= wk_array[wk_j].ogd12b  AND
                   wk_ogd12b  <= wk_array[wk_j].ogd12e) AND
                  (wk_ogd12e  >= wk_array[wk_j].ogd12b  AND
                   wk_ogd12e  <= wk_array[wk_j].ogd12e) THEN
                   LET sw_esit = 'Y'
                   EXIT FOR
              ELSE
                   LET sw_esit = 'N'
              END  IF
          END IF
      END FOR
      IF  sw_esit  =  'N'   THEN
          LET wk_i =  wk_i  +  1
          LET wk_array[wk_i].ogd11   = wk_ogd11
          LET wk_array[wk_i].ogd12b  = wk_ogd12b  USING '&&&'
          LET wk_array[wk_i].ogd12e  = wk_ogd12e  USING '&&&'
          LET tot_ctn  =  tot_ctn  + wk_ogd10
      END IF
      LET sw_esit    = 'N'
    END IF
END FUNCTION
 
{
REPORT axmg553_rep(ofa, ofb,ogd, sr)
  DEFINE head1,head2   LIKE type_file.chr1000   # No.FUN-680137 VARCHAR(120)
  DEFINE l_last_sw     LIKE type_file.chr1      # No.FUN-680137 VARCHAR(1)
  DEFINE l_str         LIKE type_file.chr1000   # No.FUN-680137 VARCHAR(80)
  DEFINE l_ima02       LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(30)
  DEFINE l_ima021      LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(30) #add by anderswon 021128
  DEFINE sfa30_t       LIKE faj_file.faj02      # No.FUN-680137 VARCHAR(10)
  DEFINE sfa30_p       LIKE faj_file.faj02      # No.FUN-680137 VARCHAR(10)
  DEFINE tot_ogd13      LIKE   ogd_file.ogd13
  DEFINE oao		RECORD LIKE oao_file.*
  DEFINE oaf		RECORD LIKE oaf_file.*
  DEFINE l_oao          RECORD LIKE oao_file.*
  DEFINE wk_ima02       LIKE   ima_file.ima02
  DEFINE wk_ima25       LIKE   ima_file.ima25
  DEFINE l_ogd14t       LIKE ogd_file.ogd14t
  DEFINE l_ogd15t       LIKE ogd_file.ogd15t
  DEFINE l_ogd16t       LIKE ogd_file.ogd16t
  DEFINE ofa       RECORD LIKE ofa_file.*,
         ofb       RECORD LIKE ofb_file.*,
         ogd       RECORD LIKE ogd_file.*,
         sfa       RECORD LIKE sfa_file.*,
         sr        RECORD
                   occ231       LIKE occ_file.occ231,
                   occ232       LIKE occ_file.occ232,
                   occ233       LIKE occ_file.occ233,
                   occ241       LIKE occ_file.occ241,
                   occ242       LIKE occ_file.occ242,
                   occ243       LIKE occ_file.occ243,
                   occ29        LIKE occ_file.occ29,
                   occ292       LIKE occ_file.occ292,
                   oah02        LIKE oah_file.oah02,
                   oag02        LIKE oag_file.oag02,
                   oga02        LIKE oga_file.oga02
                   END RECORD ,
          g_title  LIKE occ_file.occ02      # No.FUN-680137 VARCHAR(25)
 
  OUTPUT
  TOP MARGIN g_top_margin
  LEFT MARGIN g_left_margin
  BOTTOM MARGIN g_bottom_margin
  PAGE LENGTH g_page_line
  ORDER BY ofa.ofa01,ogd.ogd12b,ofb.ofb04 #Invoice,料號
  FORMAT
   PAGE HEADER
      LET l_oao.oao06 = ' '
      LET g_pageno= g_pageno+1
      #表頭
      LET g_title="PACKING LIST"
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED   #FUN-610072
      PRINT COLUMN 01,"Invoice No.:",ofa.ofa01,                    #Invoice
            #COLUMN 62,"Date:",ofa.ofa02	USING 'yyyy/mm/dd'#Date #FUN-570250 mark
            #COLUMN 62,"Date:",ofa.ofa02   #Date #FUN-570250 add #No.TQC-6A0087
            COLUMN g_len-15,"Date:",ofa.ofa02 #No.TQC-6A0087 
      PRINT COLUMN 01,"Ref.    No.:",ofa.ofa011,                   #通知單號
            #COLUMN 62,"Page:",g_pageno USING '<<<'        #頁次 #No.TQC-6A0087
            COLUMN g_len-15,"Page:",g_pageno USING '<<<' #No.TQC-6A0087
      PRINT (g_len-FGL_WIDTH(g_title))/2 SPACES,"PACKING LIST"         #表名
      PRINT COLUMN  9,'(',ofa.ofa03,')',      #帳款客戶編號
            #COLUMN 34,"============" #FUN-5A0143 mark
            #COLUMN 41,"============"  #FUN-5A0143 add #No.TQC-6A0087
            COLUMN (g_len-FGL_WIDTH(g_title))/2,"==============" #No.TQC-6A0087
#No.FUN-580013  --begin
#     LET head1=" CTN NO.  CTN#         Item No.            Unit       Q'ty   N.W.(Kg)   G.W.(Kg)"
#     LET head2="--------- ---- --------------------------- ---- ----------- --------- ----------"
#     IF ofa.ofa75='1' THEN
#        LET head1[1,14]=" PLT NO.  PLT#"
#     END IF
       IF g_pageno>1 THEN
#        PRINT g_dash1
#        PRINT head1
#        PRINT head2
         PRINT g_dash
         PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[38],g_x[34],g_x[35],g_x[36],g_x[37]   #FUN-690032 add g_x[38]
         PRINT g_dash1
       ELSE
          SKIP 3 LINE
       END IF
#No.FUN-580013  --end
 
   BEFORE GROUP OF ofa.ofa01  #Invoice
     #不同單號跳頁
     SKIP TO TOP OF PAGE
     LET tot_ogd13 = 0  #產品數量
 
     IF g_pageno=1 THEN
 
#--start-- No.TQC-6A0087 增加判別語句
     IF tm.d != 'Y' THEN
        #表頭下面一點 bill to
        PRINT COLUMN 01,'Bill To: ';
        PRINT COLUMN 36,'Ship To: '
        PRINT ofa.ofa0351 CLIPPED;                   #帳款客戶全名
        PRINT COLUMN 36,ofa.ofa0451 CLIPPED          #送貨客戶全名
        PRINT 'Attn To: ',sr.occ29 CLIPPED,' ',sr.occ292 CLIPPED;  #業務
        PRINT COLUMN 36,'Attn To: ';
        PRINT COLUMN 45,'Receiving Center'
        PRINT COLUMN 1 ,sr.occ231 CLIPPED;                     #ADDRESS-1
        PRINT COLUMN 36,sr.occ241 CLIPPED
        PRINT COLUMN 1 ,sr.occ232 CLIPPED;                     #ADDRESS-2
        PRINT COLUMN 36,sr.occ242 CLIPPED
        PRINT COLUMN 1 ,sr.occ233 CLIPPED;                     #ADDRESS-3
        PRINT COLUMN 36,sr.occ243 CLIPPED
        PRINT
 
        #再下面一點 ship to
 
        PRINT COLUMN 01,'Price Term : ',
              COLUMN 14,ofa.ofa31 CLIPPED;                     #價格條件
        PRINT COLUMN 36,'Payment : ',
              COLUMN 14,ofa.ofa32 CLIPPED,' ',sr.oag02 CLIPPED #付款條件+說明
        PRINT #COLUMN 01,'AIRWAY BILL: ',
              #COLUMN 14,l_oao.oao06[1,33] CLIPPED,           #單頭備註第一筆
              COLUMN 36,'COUNTRY OF ORIGIN : TAIWAN.'
#--end-- No.TQC-6A0087
#--start-- No.TQC-6A0087 新增判別情況
    ELSE
        #表頭下面一點 bill to                                                  
        PRINT COLUMN 01,'Bill To: ';                                            
        PRINT COLUMN 67,'Ship To: '                                             
        PRINT ofa.ofa0351 CLIPPED;                   #帳款客戶全名              
        PRINT COLUMN 67,ofa.ofa0451 CLIPPED          #送貨客戶全名              
        PRINT 'Attn To: ',sr.occ29 CLIPPED,' ',sr.occ292 CLIPPED;  #業務        
        PRINT COLUMN 67,'Attn To: ';                                            
        PRINT COLUMN 76,'Receiving Center'                                      
        PRINT COLUMN 1 ,sr.occ231 CLIPPED;                     #ADDRESS-1       
        PRINT COLUMN 67,sr.occ241 CLIPPED                                       
        PRINT COLUMN 1 ,sr.occ232 CLIPPED;                     #ADDRESS-2       
        PRINT COLUMN 67,sr.occ242 CLIPPED                                       
        PRINT COLUMN 1 ,sr.occ233 CLIPPED;                     #ADDRESS-3       
        PRINT COLUMN 67,sr.occ243 CLIPPED                                       
        PRINT                                                                   
                                                                                
        #再下面一點 ship to              
                                                                                
        PRINT COLUMN 01,'Price Term : ',                                        
              COLUMN 14,ofa.ofa31 CLIPPED;                     #價格條件        
        PRINT COLUMN 67,'Payment : ',                                           
              COLUMN 14,ofa.ofa32 CLIPPED,' ',sr.oag02 CLIPPED #付款條件+說明   
        PRINT #COLUMN 01,'AIRWAY BILL: ',                                       
              #COLUMN 14,l_oao.oao06[1,33] CLIPPED,           #單頭備注第一筆   
              COLUMN 67,'COUNTRY OF ORIGIN : TAIWAN.'
     END IF
#--end-- No.TQC-6A0087        
        #列印備註
        IF tm.b='Y' THEN
           DECLARE oao_c1 CURSOR FOR
            SELECT * FROM oao_file
             WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05='1'
            ORDER BY 3
           FOREACH oao_c1 INTO oao.* PRINT COLUMN 1,oao.oao06 END FOREACH
        END IF
#No.FUN-580013  --begin
#       PRINT g_dash1
#       PRINT head1
#       PRINT head2
        PRINT g_dash
        PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[38],g_x[34],g_x[34],g_x[35],g_x[36],g_x[37]  #FUN-690032 add g_x[38]
        PRINT g_dash1
#No.FUN-580013  --end
     END IF
 
     LET l_last_sw='n'
 
     LET tot_ctn=0
     FOR wk_i = 1  TO 20
       INITIALIZE  wk_array[wk_i].*  TO NULL
     END    FOR
     LET wk_i = 0
 
   ON EVERY ROW
 
      IF cl_null(ofb.ofb11) THEN #客戶產品編號
         SELECT obk03 INTO ofb.ofb11 FROM obk_file
          WHERE obk01=ofb.ofb04 AND obk02=ofa.ofa03
      END IF
      #No.9048
      DECLARE ogd_cur CURSOR FOR
       SELECT * FROM ogd_file WHERE ogd01 = ofa.ofa011 AND ogd03 = ofb.ofb03
      FOREACH ogd_cur INTO ogd.*
      #No.9048(end)
 
        #序號=1且要列印備註時
        IF ogd.ogd04=1 AND tm.b='Y' THEN #序號
           DECLARE oao_c2 CURSOR FOR
             SELECT * FROM oao_file
              WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND oao05=1
              ORDER BY 3
           FOREACH oao_c2 INTO oao.* PRINT COLUMN 37,oao.oao06 END FOREACH
        END IF
 
        #抓料件品名規格
        SELECT ima02,ima021 INTO l_ima02,l_ima021
           FROM ima_file WHERE ima01 = ofb.ofb04
#No.FUN-580013  --begin
#       PRINT COLUMN 01,ogd.ogd11 CLIPPED,              #包裝箱號字軌
#                       ogd.ogd12b CLIPPED,'-',         #起始包裝箱號
#                       ogd.ogd11 CLIPPED,              #包裝箱號字軌
#                       ogd.ogd12e CLIPPED,             #截止包裝箱號
#                       ogd.ogd10 USING '####&',        #箱數
#             COLUMN 16,ofb.ofb04 CLIPPED,              #產品編號
#             COLUMN 45,ofb.ofb05 CLIPPED,              #銷售單位
#             COLUMN 50,ogd.ogd09 USING '--,---,--&',   #每箱裝數
#             COLUMN 61,ogd.ogd14 USING '---,--&.&',#單位淨重
#             COLUMN 71,ogd.ogd15 USING '---,--&.&'  #單位毛重
        PRINTX name = D1 COLUMN g_c[31],ogd.ogd11 CLIPPED,              #包裝箱號字軌
                                        ogd.ogd12b CLIPPED,'-',         #起始包裝箱號
                                        ogd.ogd11 CLIPPED,              #包裝箱號字軌
                                        ogd.ogd12e CLIPPED,             #截止包裝箱號
                         COLUMN g_c[32],ogd.ogd10 USING '####&',        #箱數
                         COLUMN g_c[33],ofb.ofb04 CLIPPED,              #產品編號
                         COLUMN g_c[38],ofb.ofb11 CLIPPED,              #客戶料號
                         COLUMN g_c[34],ofb.ofb05 CLIPPED,              #銷售單位
                         COLUMN g_c[35],ogd.ogd09 USING '--,---,--&',   #每箱裝數
                         COLUMN g_c[36],ogd.ogd14 USING '---,--&.&',    #單位淨重
                         COLUMN g_c[37],ogd.ogd15 USING '---,--&.&'     #單位毛重
#No.FUN-580013  --end
        #累計產品淨重
        IF NOT cl_null(ogd.ogd12b) THEN #起始包裝箱號
           LET tot_ogd13=tot_ogd13+ogd.ogd13    #產品淨重
        END IF
#No.FUN-580013  --begin
#       PRINT COLUMN 16,ofb.ofb06 CLIPPED,' /',l_ima021 CLIPPED  #品名
#       PRINT COLUMN 16,ofb.ofb11 CLIPPED             #客戶產品編號
        PRINTX name = D1 COLUMN g_c[33],ofb.ofb06 CLIPPED,' /',l_ima021 CLIPPED  #品名
      #FUN-690032 remark 
      # PRINT COLUMN g_c[33],ofb.ofb11 CLIPPED             #客戶產品編號
#No.FUN-580013  --end
        IF NOT cl_null(ogd.ogd12b) THEN  #起始包裝箱號
           CALL cnt_ogd10(ogd.ogd11,ogd.ogd12b,ogd.ogd12e,ogd.ogd10)
        END IF
       END FOREACH #No.9048
 
   AFTER GROUP OF ofa.ofa01 #Invoice
     #列印備註
     IF tm.b='Y' THEN
        DECLARE oao_c4 CURSOR FOR
         SELECT * FROM oao_file
          WHERE oao01=ofa.ofa01 AND oao03=0 AND oao05='2'
          ORDER BY 3
        FOREACH oao_c4 INTO oao.* PRINT COLUMN 1,oao.oao06 END FOREACH
     END IF
     PRINT g_dash2      #No.FUN-580013
 
     #SUM 總淨重,總毛重,總材積
     SELECT SUM(ogd14t),SUM(ogd15t),SUM(ogd16t)
       INTO l_ogd14t,l_ogd15t,l_ogd16t
       FROM ogd_file
      WHERE ogd01 = ofa.ofa011 #出貨通知單
 
      IF ofa.ofa75='1' THEN LET l_str='PALLETS' ELSE LET l_str='CARTONS' END IF
#No.FUN-580013  --begin
#     PRINT COLUMN 04,'Total:',
#           COLUMN 10,tot_ctn USING '####&',               #total箱數
#           COLUMN 16,l_str CLIPPED,
#           COLUMN 50,tot_ogd13 USING '--,---,--&',        #產品數量
#           COLUMN 61,l_ogd14t USING '---,--&.&',          #單位淨重
#           COLUMN 71,l_ogd15t USING '---,--&.&'           #單位毛重
      PRINTX name = D1 COLUMN g_c[31],'Total:',
            COLUMN g_c[32],tot_ctn USING '####&',               #total箱數
            COLUMN g_c[33],l_str CLIPPED,
            COLUMN g_c[35],tot_ogd13 USING '--,---,--&',        #產品數量
            COLUMN g_c[36],l_ogd14t USING '---,--&.&',          #單位淨重
            COLUMN g_c[37],l_ogd15t USING '---,--&.&'           #單位毛重
 
      LET tot_ogd13 = 0
#     PRINT COLUMN 10,'vvvvv',
#           COLUMN 50,'vvvvvvvvvv vvvvvvvvv vvvvvvvvv'
      PRINTX name = D1 COLUMN g_c[32],'vvvvv',
            COLUMN g_c[35],'vvvvvvvvvv vvvvvvvvv vvvvvvvvv'
#No.FUN-580013  --end
      PRINT
      IF ofa.ofa75='1'
         THEN PRINT 'SAY TOTAL PACKED IN (',tot_ctn CLIPPED,') PALLETS ONLY'
         ELSE PRINT 'SAY TOTAL PACKED IN (',tot_ctn CLIPPED,') CARTONS ONLY'
      END IF
      LET l_last_sw='y'
 
      LET g_pageno = 0
 
   PAGE TRAILER
     IF l_last_sw='y' THEN
#       PRINT COLUMN 41,g_zo12        #No.TQC-6A0087 
        PRINT COLUMN g_len-38,g_zo12  #No.TQC-6A0087
        PRINT ''
        PRINT ''
        PRINT ''
        PRINT ''
#       PRINT COLUMN 41,'----------------------------'       #No.TQC-6A0087
        PRINT COLUMN g_len-38,'----------------------------' #No.TQC-6A0087
     ELSE
        SKIP 5 LINE
        PRINT g_dash2   #No.FUN-580013
     END IF
     PRINT
   # PRINT COLUMN 6,'(白聯)業務     (紅聯)客戶     (黃聯)財會     (藍聯)倉管     (綠聯)業務'
## FUN-550127
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[1]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[1]
             PRINT g_memo
      END IF
## END FUN-550127
 
END REPORT
}
#Patch....NO.TQC-610037 <003,004> #

###GENGRE###START
FUNCTION axmg553_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg553")
        IF handler IS NOT NULL THEN
            START REPORT axmg553_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ofa01"
          
            DECLARE axmg553_datacur1 CURSOR FROM l_sql
            FOREACH axmg553_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg553_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg553_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg553_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno         LIKE type_file.num5
    DEFINE l_sum_ogd10      LIKE ogd_file.ogd10
    DEFINE l_str1           STRING 
    DEFINE l_str2           STRING 
    DEFINE l_occ29_occ292   LIKE occ_file.occ29
    DEFINE l_ogd11_ogd12b   STRING   
    DEFINE l_ogd12e         LIKE ogd_file.ogd12e
    DEFINE l_ogd12b         LIKE ogd_file.ogd12b
    DEFINE l_sql            STRING
 
    ORDER EXTERNAL BY sr1.ofa01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_lang    #FUN-B40087
              
        BEFORE GROUP OF sr1.ofa01
            LET l_lineno = 0
            #FUN-B40087  ADD --------STR -----
            IF NOT cl_null(sr1.occ29) AND NOT cl_null(sr1.occ292) THEN
               LET l_occ29_occ292 = sr1.occ29,' ',sr1.occ292
            ELSE
               IF NOT cl_null(sr1.occ29) AND cl_null(sr1.occ292) THEN
                  LET l_occ29_occ292 = sr1.occ29
               END IF
               IF cl_null(sr1.occ29) AND NOT cl_null(sr1.occ292) THEN
                  LET l_occ29_occ292 = sr1.occ292
               END IF
            END IF
            PRINTX l_occ29_occ292
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = 0 ",
                        " AND oao05 ='1'",
                        " ORDER BY oao06 "#FUN-C20053 add
            START REPORT axmg553_subrep01
            DECLARE axmg553_repcur1 CURSOR FROM l_sql
            FOREACH axmg553_repcur1 INTO sr2.*
                OUTPUT TO REPORT axmg553_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg553_subrep01
            #FUN-B40087  ADD --------END -----       
 
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B40087  ADD --------STR -----
            LET l_ogd12e = sr1.ogd12e
            LET l_ogd12b = sr1.ogd12b
            IF sr1.ogd11 ="X" OR cl_null(sr1.ogd11) THEN
               IF NOT cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
                  LET l_ogd11_ogd12b = l_ogd12b,'-',l_ogd12e
               ELSE IF NOT cl_null(sr1.ogd12b) AND cl_null(sr1.ogd12e) THEN
                       LET l_ogd11_ogd12b = l_ogd12b,'-'
                    END IF 
                    IF cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
                       LET l_ogd11_ogd12b = '-',l_ogd12e
                    END IF
               END IF
            ELSE IF NOT cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
                    LET l_ogd11_ogd12b = sr1.ogd11,l_ogd12b,'-',sr1.ogd11,l_ogd12e        
                 ELSE IF NOT cl_null(sr1.ogd12b) AND cl_null(sr1.ogd12e) THEN
                      LET l_ogd11_ogd12b = sr1.ogd11,l_ogd12b,'-'
                    END IF
                    IF cl_null(sr1.ogd12b) AND NOT cl_null(sr1.ogd12e) THEN
                       LET l_ogd11_ogd12b = '-',sr1.ogd11,l_ogd12e
                    END IF
               END IF
            END IF
            PRINTX l_ogd11_ogd12b          

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = ",sr1.ofb03 CLIPPED,
                        " AND oao05 ='1'"
            START REPORT axmg553_subrep02
            DECLARE axmg553_repcur2 CURSOR FROM l_sql
            FOREACH axmg553_repcur2 INTO sr2.*
                OUTPUT TO REPORT axmg553_subrep02(sr2.*)
            END FOREACH
            FINISH REPORT axmg553_subrep02

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = ",sr1.ofb03 CLIPPED,
                        " AND oao05 ='2'" 
            START REPORT axmg553_subrep03
            DECLARE axmg553_repcur3 CURSOR FROM l_sql
            FOREACH axmg553_repcur3 INTO sr2.*
                OUTPUT TO REPORT axmg553_subrep03(sr2.*)
            END FOREACH
            FINISH REPORT axmg553_subrep03

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE imc01 = '",sr1.ofb04 CLIPPED,"'",
                        " AND imc02 ='",sr1.ofb07 CLIPPED,"'"
            START REPORT axmg553_subrep05
            DECLARE axmg553_repcur5 CURSOR FROM l_sql
            FOREACH axmg553_repcur5 INTO sr3.*
                OUTPUT TO REPORT axmg553_subrep05(sr3.*)
            END FOREACH
            FINISH REPORT axmg553_subrep05
            #FUN-B40087  ADD --------END -----                    
            PRINTX sr1.*

        AFTER GROUP OF sr1.ofa01
            #FUN-B40087  ADD --------STR -----
            IF sr1.ofa75 = "1" THEN
               LET l_str1 = "PALLETS"
            ELSE 
               LET l_str1 = "CARTONS" 
            END IF
            PRINTX l_str1
            IF sr1.ofa75 = "1" THEN
               LET l_str2 = ") PALLETS ONLY"
            ELSE
               LET l_str2 = ") ARTONS ONLY"
            END IF
            PRINTX l_str2
            LET l_sum_ogd10 = GROUP SUM(sr1.ogd10)
            IF cl_null(l_sum_ogd10) THEN 
               LET l_sum_ogd10 = 0
            END IF 
            PRINTX l_sum_ogd10
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = 0 ",
                        " AND oao05 ='2'"
            START REPORT axmg553_subrep04
            DECLARE axmg553_repcur4 CURSOR FROM l_sql
            FOREACH axmg553_repcur4 INTO sr2.*
                OUTPUT TO REPORT axmg553_subrep04(sr2.*)
            END FOREACH
            FINISH REPORT axmg553_subrep04
            #FUN-B40087  ADD --------END -----
        
        ON LAST ROW

END REPORT

#FUN-B40087  ADD --------STR -----
REPORT axmg553_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg553_subrep02(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg553_subrep03(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg553_subrep04(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg553_subrep05(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT
#FUN-B40087  ADD --------END -----
###GENGRE###END
