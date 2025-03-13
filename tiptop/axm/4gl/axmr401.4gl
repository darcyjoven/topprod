# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: axmr401.4gl
# Descriptions...: S/C
# Date & Author..: 95/01/06 By Danny
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.FUN-4C0096 05/03/04 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-590110 05/09/26 By day  報表轉xml
# Modify.........: No.FUN-5A0143 05/10/24 By Rosayu 報表格式修改
# Modify.........: NO.TQC-5B0061 05/11/08 BY yiting 中文英選項拿掉
# Modify.........: No.TQC-5B0128 05/11/24 By echo 修改p_zz的列印寬度
# Modify.........: NO.FUN-5C0036 05/12/29 By Sarah 預設出英文報表
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-680086 修正FUN-5C0036
# Modify.........: No.FUN-680137 06/09/14 By bnlent 欄位型態定義，改為LIKE  
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By rainy 新增是否列印客戶料號
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/10/28 By yjkhero l_time轉g_time  
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.MOD-6B0114 07/01/03 By Mandy 遵循多單位報表列印規則
# Modify.........: No.MOD-710194 07/01/31 By claire l_addr1 LIKE occ241
# Modify.........: No.FUN-710090 07/02/01 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.FUN-730014 07/03/06 By chenl s_addr傳回5個參數
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740057 07/04/14 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.TQC-740103 07/04/17 By Sarah 出報表一直跑不出資料
# Modify.........: No.MOD-7C0033 07/12/05 By Sarah CR報表未印出帳款客戶與送貨客戶資料
# Modify.........: No.FUN-810029 08/02/22 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.MOD-980008 09/08/03 By Dido 交運方式抓取調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80079 10/08/13 By yinhy  畫面條件選項增加一個選項，打印额外品名规格
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:FUN-940044 11/11/03 By xumm 整合單據列印EF簽核
# Modify.........: No.TQC-C10039 12/01/18 By wangrr 整合單據列印EF簽核
# Modify.........: No.TQC-C50101 12/05/11 By zhuhao 變量類型定義修改 
# Modify.........: No.MOD-D10039 13/01/08 By jt_chen 調整頁首n的客戶電話與傳真,改抓客戶基本資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                           # Print condition RECORD
            wc      LIKE type_file.chr1000, # Where condition #No.FUN-680137 VARCHAR(500)
            n       LIKE type_file.chr1,    # Title  #No.FUN-680137 VARCHAR(01)
#           o       VARCHAR(01),               # Language #NO.TQC-5B0061
            p       LIKE type_file.chr1,    # Language #No.FUN-680137 VARCHAR(01)
            d       LIKE type_file.chr1,    # 列印客戶料號
            b       LIKE type_file.chr1,    # 列印公司對內全名   #FUN-740057 add
            c       LIKE type_file.chr1,    # 列印公司對外全名   #FUN-740057 add
            e       LIKE type_file.chr1,    # 列印額外品名規格
            more    LIKE type_file.chr1     # Input more condition(Y/N)#No.FUN-680137 VARCHAR(01)
           END RECORD
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE g_sma115     LIKE sma_file.sma115    #MOD-6B0114
DEFINE g_sma116     LIKE sma_file.sma116    #MOD-6B0114
DEFINE l_table      STRING                  #FUN-710090 add
DEFINE l_table1     STRING                  #FUN-710090 add
DEFINE l_table2     STRING                  #FUN-A80079 add
DEFINE g_sql        STRING                  #FUN-710090 add
DEFINE g_str        STRING                  #FUN-710090 add
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
  #No.FUN-710090--begin--
  #str MOD-7C0033 mod
   LET g_sql="oea00.oea_file.oea00  ,oea01.oea_file.oea01,",
             "oea02.oea_file.oea02  ,oea03.oea_file.oea03,",
             "oea032.oea_file.oea032,oea04.oea_file.oea04,",
             "oea044.oea_file.oea044,oea06.oea_file.oea06,",
             "oea10.oea_file.oea10  ,oea11.oea_file.oea11,",
             "oea12.oea_file.oea12  ,oea14.oea_file.oea14,",
             "oea15.oea_file.oea15  ,oea21.oea_file.oea21,",
             "oea23.oea_file.oea23  ,oea25.oea_file.oea25,",
             "oea31.oea_file.oea31  ,oea32.oea_file.oea32,",
             "oea33.oea_file.oea33  ,oea41.oea_file.oea41,",
             "oea42.oea_file.oea42  ,oea43.oea_file.oea43,",
             "oea44.oea_file.oea44  ,occ02.occ_file.occ02,",
             "occ231.occ_file.occ231,occ232.occ_file.occ232,",
             "occ233.occ_file.occ233,occ234.occ_file.occ234,",
             "occ235.occ_file.occ235,oah02.oah_file.oah02,",
             "oag02.oag_file.oag02  ,gec02.gec_file.gec02,",
             "occ02_1.occ_file.occ02,addr1.occ_file.occ241,",
             "addr2.occ_file.occ241 ,addr3.occ_file.occ241,",
             "addr4.occ_file.occ241 ,addr5.occ_file.occ241,",
             "oab02.oab_file.oab02  ,gem02.gem_file.gem02,",
             "gen02.gen_file.gen02  ,ged02.ged_file.ged02,",
             "oeb03.oeb_file.oeb03  ,oeb04.oeb_file.oeb04,",
             "oeb05.oeb_file.oeb05  ,oeb06.oeb_file.oeb06,",
             "oeb11.oeb_file.oeb11  ,oeb12.oeb_file.oeb12,",
             "oeb13.oeb_file.oeb13  ,oeb14.oeb_file.oeb14,",
             "oeb14t.oeb_file.oeb14t,oeb15.oeb_file.oeb15,",
             "oeb17.oeb_file.oeb17  ,oeb18.oeb_file.oeb18,",
             "oeb19.oeb_file.oeb19  ,oeb20.oeb_file.oeb20,",
             "oeb21.oeb_file.oeb21  ,oeb910.oeb_file.oeb910,",
             "oeb912.oeb_file.oeb912,oeb913.oeb_file.oeb913,",
             "oeb915.oeb_file.oeb915,oeb916.oeb_file.oeb916,",
             "oeb917.oeb_file.oeb917,unit.type_file.chr50,",
             "azi02.azi_file.azi02  ,azi03.azi_file.azi03,",
             "azi04.azi_file.azi04  ,azi05.azi_file.azi05,",
             "oeb14_ep.type_file.chr1000,zo041.zo_file.zo041,",    #FUN-810029 add zo041
             "zo05.zo_file.zo05     ,zo09.zo_file.zo09,",          #FUN-810029 add zo05,zo09
             "occ261.occ_file.occ261,occ271.occ_file.occ271,",     #MOD-D10039 add
             "oeb07.oeb_file.oeb07  ,l_count.type_file.num5,",     #FUN-A80079 add        #FUN-940044 add 2,
             "sign_type.type_file.chr1 ,sign_img.type_file.blob,", #簽核方式, 簽核圖檔    #No.FUN-940044 add
             "sign_show.type_file.chr1,sign_str.type_file.chr1000" #是否顯示簽核資料(Y/N) #No.FUN-940044 add #TQC-C10039 sign_str
  #end MOD-7C0033 mod
   LET l_table = cl_prt_temptable('axmr401',g_sql) CLIPPED 
   IF l_table = -1 THEN EXIT PROGRAM END IF
  #No.FUN-710090--end--
 
  #str MOD-7C0033 add
   #備註
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao04.oao_file.oao04,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06"
   LET l_table1 = cl_prt_temptable('axmr4011',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
  #str MOD-7C0033 add
  #No.FUN-A80079 --start--
   LET g_sql = "imc01.imc_file.imc01,",
               "imc02.imc_file.imc02,",
               "imc03.imc_file.imc03,",
               "imc04.imc_file.imc04,",
               "oea01.oea_file.oea01,",
               "oeb03.oeb_file.oeb03"
    LET l_table2 = cl_prt_temptable('axmr4012',g_sql) CLIPPED
    IF  l_table2 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-A80079 --end--
 #--------------No.TQC-610089 modify
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.n    = ARG_VAL(8)
   LET tm.p    = ARG_VAL(9)
   LET tm.b    = ARG_VAL(10)   #FUN-740057 add
   LET tm.c    = ARG_VAL(11)   #FUN-740057 add
   LET tm.e    = ARG_VAL(12)   #FUN-A80079 add
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(tm.wc) THEN
      CALL axmr401_tm(0,0)             # Input print condition
   ELSE 
     #LET tm.wc="oea01= '",tm.wc CLIPPED,"'"    #No.TQC-610089 mark
      CALL axmr401()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr401_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW axmr401_w AT p_row,p_col WITH FORM "axm/42f/axmr401"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = 'Y'      #FUN-740057 add
   LET tm.c    = 'Y'      #FUN-740057 add
   LET tm.e    = 'N'      #FUN-A80079 add
   LET tm.more = 'N'      #FUN-A80079 add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='1'
#  LET tm.o ='1'   #NO.TQC-5B0061
   LET tm.p ='N'
   LET tm.d ='N'    #FUN-690032
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea14
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP    #FUN-4B0043
            IF INFIELD(oea14) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea14
               NEXT FIELD oea14
            END IF
 
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr401_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      #INPUT BY NAME tm.n,tm.o,tm.p,tm.more WITHOUT DEFAULTS
      INPUT BY NAME tm.n,tm.p,tm.d,tm.b,tm.c,tm.e,tm.more WITHOUT DEFAULTS   #NO.TQC-5B0061  #FUN-690032 add tm.d  #FUN-740057 add tm.b,tm.c
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         AFTER FIELD n
            IF cl_null(tm.n) OR tm.n NOT MATCHES '[1-3]' THEN
               NEXT FIELD n
            END IF
#NO.TQC-5B0061
#        AFTER FIELD o
#           IF cl_null(tm.o) OR tm.o NOT MATCHES '[01]' THEN
#              NEXT FIELD o
#           END IF
#NO.TQC-5B0061
         AFTER FIELD p
            IF cl_null(tm.p) OR tm.p NOT MATCHES '[YN]' THEN
               NEXT FIELD p
            END IF
        #FUN-690032 add--begin
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
               NEXT FIELD d
            END IF
        #FUN-690032 add--end
        #FUN-A80079  --start--
         AFTER FIELD e
            IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
               NEXT FIELD e
            END IF
        #FUN-A80079  --end--
        
         #str FUN-740057 add
         AFTER FIELD b
             IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
         AFTER FIELD c
             IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN NEXT FIELD c END IF
         #end FUN-740057 add
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr401_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='axmr401'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr401','9031',1)
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
                            " '",tm.n CLIPPED,"'" ,
#                            " '",tm.o CLIPPED,"'",                #NO.TQC-5B0061
                            " '",tm.p CLIPPED,"'" ,
                            " '",tm.d CLIPPED,"'" ,                #FUN-690032 add
                            " '",tm.b CLIPPED,"'" ,                #FUN-740057 add
                            " '",tm.c CLIPPED,"'" ,                #FUN-740057 add
                            " '",tm.e CLIPPED,"'" ,                #FUN-A80079 add
                           #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axmr401',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axmr401_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmr401()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmr401_w
END FUNCTION
 
FUNCTION axmr401()
DEFINE l_name     LIKE type_file.chr20,    # External(Disk) file name  #No.FUN-680137 VARCHAR(20)
  #    l_time     LIKE type_file.chr8,     # Used time for running the job  #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094	
      #l_sql      LIKE type_file.chr1000,  #No.FUN-680137 VARCHAR(3000)   #TQC-C50101 mark
      #l_za05     LIKE type_file.chr1000,  #No.FUN-680137 VARCHAR(40)     #TQC-C50101 mark
       l_sql      STRING,                  #TQC-C50101 add
       l_count    LIKE type_file.num5,     #No.FUN-A80079
       sr         RECORD
                  oea00     LIKE oea_file.oea00,
                  oea01     LIKE oea_file.oea01,
                  oea02     LIKE oea_file.oea02,
                  oea03     LIKE oea_file.oea03,
                  oea032    LIKE oea_file.oea032,
                  oea04     LIKE oea_file.oea04,
                  oea044    LIKE oea_file.oea044,
                  oea06     LIKE oea_file.oea06,
                  oea10     LIKE oea_file.oea10,  #No.FUN-710090
                  oea11     LIKE oea_file.oea11,
                  oea12     LIKE oea_file.oea12,
                  oea14     LIKE oea_file.oea14,
                  oea15     LIKE oea_file.oea15,
                  oea21     LIKE oea_file.oea21,
                  oea23     LIKE oea_file.oea23,
                  oea25     LIKE oea_file.oea25,
                  oea31     LIKE oea_file.oea31,
                  oea32     LIKE oea_file.oea32,
                  oea33     LIKE oea_file.oea33,
                  oea41     LIKE oea_file.oea41,
                  oea42     LIKE oea_file.oea42,
                  oea43     LIKE oea_file.oea43,
                  oea44     LIKE oea_file.oea44,
                  occ02     LIKE occ_file.occ02,
                  occ231    LIKE occ_file.occ231,
                  occ232    LIKE occ_file.occ232,
                  occ233    LIKE occ_file.occ233,
                  occ234    LIKE occ_file.occ234,
                  occ235    LIKE occ_file.occ235,
                  oah02     LIKE oah_file.oah02,
                  oag02     LIKE oag_file.oag02,
                  oeb03     LIKE oeb_file.oeb03,
                  oeb04     LIKE oeb_file.oeb04,
                  oeb05     LIKE oeb_file.oeb05,
                  oeb06     LIKE oeb_file.oeb06,
                  oeb07     LIKE oeb_file.oeb07,  #FUN-A80079 add
                  oeb11     LIKE oeb_file.oeb11,  #FUN-690032 add
                  oeb12     LIKE oeb_file.oeb12,
                  oeb13     LIKE oeb_file.oeb13,
                  oeb14     LIKE oeb_file.oeb14,
                  oeb14t    LIKE oeb_file.oeb14t,
                  oeb15     LIKE oeb_file.oeb15,
                  oeb17     LIKE oeb_file.oeb17,
                  oeb18     LIKE oeb_file.oeb18,
                  oeb19     LIKE oeb_file.oeb19,
                  oeb20     LIKE oeb_file.oeb20,
                  oeb21     LIKE oeb_file.oeb21,
                  oeb910    LIKE oeb_file.oeb910, #MOD-6B0114
                  oeb912    LIKE oeb_file.oeb912, #MOD-6B0114
                  oeb913    LIKE oeb_file.oeb913, #MOD-6B0114
                  oeb915    LIKE oeb_file.oeb915, #MOD-6B0114
                  oeb916    LIKE oeb_file.oeb916, #MOD-6B0114
                  oeb917    LIKE oeb_file.oeb917  #MOD-6B0114
                  END RECORD
#No.FUN-A80079  --start--
DEFINE    sr1     RECORD
                  imc01     LIKE imc_file.imc01,
                  imc02     LIKE imc_file.imc02,
                  imc03     LIKE imc_file.imc03,
                  imc04     LIKE imc_file.imc04
                  END RECORD
#No.FUN-A80079  --end--
#No.FUN-710090--begin--
DEFINE sr2        RECORD
                  oea01     LIKE oea_file.oea01,
                  oea23     LIKE oea_file.oea23,
                  oeb14     LIKE oeb_file.oeb14
                  END RECORD,
       l_azi02    LIKE azi_file.azi02,
       l_ged02    LIKE ged_file.ged02,
       l_oab02    LIKE oab_file.oab02,      #MOD-7C0033 add
       l_gec02    LIKE gec_file.gec02,      #MOD-7C0033 add
       l_gem02    LIKE gem_file.gem02,      #MOD-7C0033 add
       l_gen02    LIKE gen_file.gen02,      #MOD-7C0033 add
       l_addr1    LIKE occ_file.occ241,
       l_addr2    LIKE occ_file.occ241,
       l_addr3    LIKE occ_file.occ241,
       l_addr4    LIKE occ_file.occ241,     #No.FUN-730014 
       l_addr5    LIKE occ_file.occ241,     #No.FUN-730014 
       l_occ02    LIKE occ_file.occ02,      #MOD-7C0033 add
       l_occ18    LIKE occ_file.occ18,
       l_unit_ep  LIKE type_file.chr1000,
       l_oeb14_ep LIKE type_file.chr1000,
       l_ima906   LIKE ima_file.ima906,
       l_str      LIKE type_file.chr50,     #MOD-7C0033 add
       l_str1     STRING,
       l_str2     STRING,
       l_str3     LIKE type_file.chr1000,
       l_oeb915   STRING,
       l_oeb912   STRING,
       l_oeb12    LIKE oeb_file.oeb12,
       l_azi03    LIKE azi_file.azi03,
       l_azi04    LIKE azi_file.azi04,
       l_azi05    LIKE azi_file.azi05 
#No.FUN-710090--end--
DEFINE l_zo12     LIKE zo_file.zo12        #FUN-740057 add
DEFINE l_zo041    LIKE zo_file.zo041       #FUN-810029 add
DEFINE l_zo05     LIKE zo_file.zo05        #FUN-810029 add
DEFINE l_zo09     LIKE zo_file.zo09        #FUN-810029 add
DEFINE l_occ261   LIKE occ_file.occ261     #MOD-D10039 add
DEFINE l_occ271   LIKE occ_file.occ271     #MOD-D10039 add
DEFINE oao        RECORD LIKE oao_file.*   #MOD-7C0033 add
 
###No.FUN-940044 START###
     DEFINE   l_img_blob     LIKE type_file.blob
#TQC-C10039--start--mark---
     #DEFINE   l_ii           INTEGER
     #DEFINE   l_key          RECORD                  #主鍵
     #            v1          LIKE oea_file.oea01
     #                        END RECORD
#TQC-C10039--end--mark---
###No.FUN-940044 END###
   CALL cl_del_data(l_table)    #No.FUN-710090
   CALL cl_del_data(l_table1)   #No.FUN-710090
   CALL cl_del_data(l_table2)   #No.FUN-A80079
 
   LOCATE l_img_blob IN MEMORY #blob初始化  #No.FUN-940044 add
  #No.FUN-710090--begin--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #TQC-740103 多了一個?,拿掉   #MOD-7C0033 mod #FUN-810029 69?->72?  #No.FUN-940044 add 3? #TQC-C10039 add 1?   #MOD-D10039 add ,?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "   SET oeb14_ep = ? ",
               " WHERE oea01 = ?"
   PREPARE update_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('update_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
  #No.FUN-710090--end--
 
  #str MOD-7C0033 add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN  
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM 
   END IF
  #end MOD-7C0033 add
  #No.FUN-A80079 --start--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   #No.FUN-A80079 --end--
   #LET g_rlang = '1'   #FUN-5C0036   #MOD-680086
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #MOD-6B0114
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmr401'   #NO.FUN-710090
   #str FUN-740057 add
   SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='1'   #公司對外全名
   IF cl_null(l_zo12) THEN
      SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='0'
   END IF
   #end FUN-740057 add
  #str FUN-810029 mod
  #公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo041,zo05,zo09 INTO l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01='1'   #英文版報表
  #end FUN-810029 mod
 
#NO.TQC-5B0061
#  IF tm.o = '0' THEN
#     LET g_rlang='0'
#  ELSE
#     LET g_rlang='1'
#  END IF
#NO.TQC-5B0061
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                   #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   #End:FUN-980030
 
   LET l_sql="SELECT oea00,oea01,oea02,oea03,oea032,oea04,oea044,oea06,",
             "       oea10,oea11,oea12,oea14,oea15,oea21,oea23,oea25,",  #No.FUN-710090 add oea10
             "       oea31,oea32,oea33,oea41,oea42,oea43,oea44,",
             "       occ02,occ231,occ232,occ233,occ234,occ235,",
             "       oah02,oag02,",                              #FUN-A800079 add oeb07
             "       oeb03,oeb04,oeb05,oeb06,oeb07,oeb11,oeb12,oeb13,oeb14,",  #FUN-690032 add oeb11
             "       oeb14t,oeb15,oeb17,oeb18,oeb19,oeb20,oeb21,",
             "       oeb910,oeb912,oeb913,oeb915,oeb916,oeb917 ",     #MOD-6B0114 add
 " FROM oeb_file,oea_file LEFT OUTER JOIN occ_file ON oea_file.oea04 = occ_file.occ01  LEFT OUTER JOIN oag_file ON oea_file.oea32 = oag_file.oag01 LEFT OUTER JOIN oah_file ON oea_file.oea31 = oah_file.oah01 ",
             " WHERE oea01=oeb01 ",
             "   AND oeaconf != 'X' ",
             "   AND ",tm.wc CLIPPED,
             " ORDER BY oea01 "
   PREPARE axmr401_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE axmr401_curs1 CURSOR FOR axmr401_prepare1
#TQC-C10039--start--mark---    
   ###No.FUN-940044 START ###
   #單據key值
   #LET l_sql="SELECT oea01",
   #          "  FROM oeb_file,oea_file LEFT OUTER JOIN occ_file ON oea_file.oea04 = occ_file.occ01 LEFT OUTER JOIN oag_file ON oea_file.oea32 = oag_file.oag01 LEFT OUTER JOIN oah_file ON oea_file.oea31 = oah_file.oah01 ",
   #          " WHERE oea_file.oea01 = oeb_file.oeb01 ",
   #          "   AND oeaconf != 'X' ",
   #          "   AND ",tm.wc CLIPPED,
   #          " ORDER BY oea01 "
   #PREPARE r401_pr1 FROM l_sql
   #IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   #   EXIT PROGRAM
   #END IF
   #DECLARE r401_cs1 CURSOR FOR r401_pr1

   ###No.FUN-940044 END ### 
#TQC-C10039--end--mark---
   LET l_sql="SELECT oea01,oea23,sum(oeb14)",
 " FROM oeb_file,oea_file LEFT OUTER JOIN occ_file ON oea_file.oea04 = occ_file.occ01  LEFT OUTER JOIN oag_file ON oea_file.oea32 = oag_file.oag01 LEFT OUTER JOIN oah_file ON oea_file.oea31 = oah_file.oah01 ",
             " WHERE oea01=oeb01 ",
             "   AND oeaconf != 'X' ",
             "   AND ",tm.wc CLIPPED,
             " GROUP BY oea01,oea23 "
   PREPARE axmr401_prepare2 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   DECLARE axmr401_curs2 CURSOR FOR axmr401_prepare2
 
  #CALL cl_outnam('axmr401') RETURNING l_name  #No.FUN-710090 mark
 
  #No.FUN-710090--begin-- mark
  ##FUN-690032 add--begin
  #IF tm.d = 'N' THEN
  #  #LET g_zaa[39].zaa06 = 'Y' #MOD-6B0144
  #   LET g_zaa[42].zaa06 = 'Y' #MOD-6B0144
  #ELSE
  #  #LET g_zaa[39].zaa06 = 'N' #MOD-6B0144
  #   LET g_zaa[42].zaa06 = 'N' #MOD-6B0144
  #END IF
  ##FUN-690032 add--end
 
  ##MOD-6B0114--add---str---
  ##zaa06隱藏否
  #IF g_sma.sma116 MATCHES '[23]' THEN    
  #   LET g_zaa[39].zaa06 = "N" #計價單位
  #   LET g_zaa[40].zaa06 = "N" #計價數量
  #   LET g_zaa[32].zaa06 = "Y" #單位
  #   LET g_zaa[33].zaa06 = "Y" #數量
  #ELSE
  #   LET g_zaa[39].zaa06 = "N" #計價單位
  #   LET g_zaa[40].zaa06 = "N" #計價數量
  #   LET g_zaa[32].zaa06 = "Y" #單位
  #   LET g_zaa[33].zaa06 = "Y" #數量
  #END IF
  #IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN    
  #   LET g_zaa[41].zaa06 = "N" #單位註解
  #ELSE
  #   LET g_zaa[41].zaa06 = "Y" #單位註解
  #END IF
  #CALL cl_prt_pos_len() #重新計算報表長度
  ##MOD-6B0114--add---end---
 
  #START REPORT axmr401_rep TO l_name
  #LET g_pageno = 0
  #No.FUN-710090--end-- mark
 
   FOREACH axmr401_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
     #No.FUN-710090--begin-- 
      #帳款客戶名稱,公司全名
      SELECT occ02,occ18,occ261,occ271 INTO l_occ02,l_occ18,l_occ261,l_occ271   #MOD-D10039 add ,occ261,occ271、,l_occ261,l_occ271
        FROM occ_file WHERE occ01=sr.oea03
      IF SQLCA.sqlcode THEN 
         LET l_occ02 = ''   #MOD-7C0033 add
         LET l_occ18 = ''
         LET l_occ261 = ''  #MOD-D10039 add
         LET l_occ271 = ''  #MOD-D10039 add
      END IF
      #員工姓名
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oea14
      IF SQLCA.SQLCODE THEN LET l_gen02='' END IF
      #分類名稱
      SELECT oab02 INTO l_oab02 FROM oab_file WHERE oab01=sr.oea25
      IF SQLCA.SQLCODE THEN LET l_oab02='' END IF
      #部門名稱
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oea15
      IF SQLCA.SQLCODE THEN LET l_gem02='' END IF
     #-MOD-980008-add- 
      #交運方式
      SELECT ged02 INTO l_ged02 FROM ged_file WHERE ged01=sr.oea43
      IF SQLCA.SQLCODE THEN LET l_ged02='' END IF
     #-MOD-980008-end- 
      #稅別名稱
      SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01=sr.oea21 AND gec011='2'   #銷項
      IF SQLCA.SQLCODE THEN LET l_gec02='' END IF
      #地址檔
      CALL s_addr(sr.oea01,sr.oea04,sr.oea044) 
           RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5  #No.FUN-730014 add addr4/addr5
      LET l_addr1=l_addr1 CLIPPED
      LET l_addr2=l_addr2 CLIPPED
      LET l_addr3=l_addr3 CLIPPED
      LET l_addr4=l_addr4 CLIPPED   #FUN-730014 add
      LET l_addr5=l_addr5 CLIPPED   #FUN-730014 add
      #單位使用方式(1.單一單位 2.母子單位 3.參考單位)
      SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.oea04
      IF sqlca.sqlcode THEN LET l_ima906='' END IF
      #單位備註(當使用多單位時才需要印)
      LET l_str = ''
      IF g_sma115 = 'Y' THEN   #使用多單位時
         CASE l_ima906
            WHEN '2'   #母子單位
                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                LET l_str = l_oeb915 , sr.oeb913 CLIPPED
                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                    LET l_str = l_oeb912, sr.oeb910 CLIPPED
                ELSE
                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                      LET l_str = l_str CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
                   END IF
                END IF
            WHEN '3'   #參考單位
                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                    LET l_str = l_oeb915 , sr.oeb913 CLIPPED
                END IF
         END CASE
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
         IF sr.oeb05  <> sr.oeb916 THEN
            CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
            LET l_str = l_str CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
         END IF
      END IF
     #str MOD-7C0033 add 
      #列印單身備註
      DECLARE oao_c2 CURSOR FOR
       SELECT * FROM oao_file
        WHERE oao01=sr.oea01 AND oao03=sr.oeb03 AND (oao05='1' OR oao05='2')
      FOREACH oao_c2 INTO oao.*
         IF NOT cl_null(oao.oao06) THEN
            EXECUTE insert_prep1 USING
               sr.oea01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
         END IF
      END FOREACH
      #No.FUN-A80079  --start  列印額外品名規格說明
      IF tm.e = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM imc_file
             WHERE imc01=sr.oeb04 AND imc02=sr.oeb07
          IF l_count !=0  THEN
            DECLARE imc_cur CURSOR FOR
            SELECT * FROM imc_file    
              WHERE imc01=sr.oeb04 AND imc02=sr.oeb07 
            ORDER BY imc03                                        
            FOREACH imc_cur INTO sr1.*                            
              EXECUTE insert_prep2 USING sr1.imc01,sr1.imc02,sr1.imc03,sr1.imc04,sr.oea01,sr.oeb03
            END FOREACH 
          END IF
       END IF    
       #No.FUN-A80079  --end
     #end MOD-7C0033 add
      LET l_unit_ep = ''
      SELECT azi03,azi04,azi05 INTO l_azi03,l_azi04,l_azi05 
        FROM azi_file where azi01=sr.oea23
     #str MOD-7C0033 mod
      EXECUTE insert_prep USING 
         sr.oea00 ,sr.oea01 ,sr.oea02 ,sr.oea03 ,sr.oea032,
         sr.oea04 ,sr.oea044,sr.oea06 ,sr.oea10 ,sr.oea11 ,
         sr.oea12 ,sr.oea14 ,sr.oea15 ,sr.oea21 ,sr.oea23 ,
         sr.oea25 ,sr.oea31 ,sr.oea32 ,sr.oea33 ,sr.oea41 ,
         sr.oea42 ,sr.oea43 ,sr.oea44 ,sr.occ02 ,sr.occ231,
         sr.occ232,sr.occ233,sr.occ234,sr.occ235,sr.oah02 ,
         sr.oag02 ,l_gec02  ,l_occ02  ,l_addr1  ,l_addr2  ,
         l_addr3  ,l_addr4  ,l_addr5  ,l_oab02  ,l_gem02  ,
         l_gen02  ,l_ged02  ,sr.oeb03 ,sr.oeb04 ,sr.oeb05 , 
         sr.oeb06 ,sr.oeb11 ,sr.oeb12 ,sr.oeb13 ,sr.oeb14 ,
         sr.oeb14t,sr.oeb15 ,sr.oeb17 ,sr.oeb18 ,sr.oeb19 ,
         sr.oeb20 ,sr.oeb21 ,sr.oeb910,sr.oeb912,sr.oeb913,
         sr.oeb915,sr.oeb916,sr.oeb917,l_str    ,l_azi02  ,
         l_azi03  ,l_azi04  ,l_azi05  ,' '      ,
         l_zo041     ,l_zo05      ,l_zo09,l_occ261,l_occ271,sr.oeb07,l_count   #FUN-810029 add  #FUN-A80079 add sr_oeb07,l_count  #MOD-D10039 add l_occ261,l_occ271,
         ,"",l_img_blob,"N",""   #No.FUN-940044 ad #TQC-C10039 add ""
     #end MOD-7C0033 mod
      #No.FUN-710090--end--
     # LET g_pageno = g_pageno + 1              #No.FUN-710090 mark   
     # OUTPUT TO REPORT axmr401_rep(sr.*)       #No.FUN-710090 mark  
   END FOREACH
 
  #No.FUN-710090--begin--
  #FINISH REPORT axmr401_rep
   #
   FOREACH axmr401_curs2 INTO sr2.*
      #幣別說明
      SELECT azi02 INTO l_azi02 FROM azi_file WHERE azi01=sr.oea23
      IF SQLCA.SQLCODE THEN LET l_azi02='  ' END IF
      #將oeb14金額數值轉換成SAY TOTAL
      CALL cl_say(sr2.oeb14,50) RETURNING l_str1,l_str2 
      IF cl_null(l_str2) THEN
         LET l_str3= l_azi02 CLIPPED,' ',l_str1 CLIPPED
      ELSE
         LET l_str3= l_azi02 CLIPPED,' ',l_str1,l_str2 CLIPPED
      END IF  
      EXECUTE update_prep USING l_str3,sr2.oea01
   END FOREACH
 
  #str MOD-7C0033 add
   #列印整張備註
   LET l_sql = "SELECT oea01 FROM oea_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY oea01"
   PREPARE r401_prepare3 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare3:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE r401_cs3 CURSOR FOR r401_prepare3
 
   FOREACH r401_cs3 INTO sr.oea01
      DECLARE oao_c1 CURSOR FOR
       SELECT * FROM oao_file
        WHERE oao01=sr.oea01 AND oao03=0 AND (oao05='1' OR oao05='2')
      FOREACH oao_c1 INTO oao.*
         IF NOT cl_null(oao.oao06) THEN
            EXECUTE insert_prep1 USING 
               sr.oea01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
         END IF
      END FOREACH
   END FOREACH
  #end MOD-7C0033 add
 
  #str MOD-7C0033 mod
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " WHERE oao03 =0 AND oao05='1'","|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " WHERE oao03!=0 AND oao05='1'","|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " WHERE oao03!=0 AND oao05='2'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " WHERE oao03 =0 AND oao05='2'","|",   
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED     #FUN-A80079 add
  #end MOD-7C0033 mod
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'oea01,oea02,oea14')
           RETURNING  tm.wc
   ELSE 
      LET tm.wc = ''
   END IF
   LET g_str = tm.wc,';',tm.n
                    ,";",tm.b,";",tm.c,";",l_zo12,";",tm.e   #FUN-740057 add  #FUN-A80079 add tm.e
   ###No.FUN-940044 START###
   LET g_cr_table = l_table                         #主報表的temp table名稱
   #LET g_cr_gcx01 = "axmi010"                       #單別維護程式 #TQC-C10039 mark--
   LET g_cr_apr_key_f = "oea01"                     #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--start--mark---   
   #LET l_ii = 1
   ##報表主鍵值
   #CALL g_cr_apr_key.clear()                #清空
   #FOREACH r401_cs1 INTO l_key.*
   #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
   #   LET l_ii = l_ii + 1
   #END FOREACH
#TQC-C10039--end--mark---
   ###No.FUN-940044 END###
  #CALL cl_prt_cs3('axmr401',g_sql,g_str)   #TQC-730088
   CALL cl_prt_cs3('axmr401','axmr401',g_sql,g_str)
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #No.FUN-710090--end--
END FUNCTION
 
 
#No.FUN-710090--begin-- mark
#REPORT axmr401_rep(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,         #No.FUN-680137  VARCHAR(1)
#          sr        RECORD
#                    oea01     LIKE oea_file.oea01,
#                    oea03     LIKE oea_file.oea03,
#                    oea032    LIKE oea_file.oea032,
#                    oea04     LIKE oea_file.oea04,
#                    oea044    LIKE oea_file.oea044,
#                    occ02     LIKE occ_file.occ02,
#                    occ231    LIKE occ_file.occ231,
#                    occ232    LIKE occ_file.occ232,
#                    occ233    LIKE occ_file.occ233,
#                    oea12     LIKE oea_file.oea12,
#                    oea23     LIKE oea_file.oea23,
#                    oah02     LIKE oah_file.oah02,
#                    oag02     LIKE oag_file.oag02,
#                    oea33     LIKE oea_file.oea33,
#                    oea41     LIKE oea_file.oea41,
#                    oea42     LIKE oea_file.oea42,
#                    oea43     LIKE oea_file.oea43,
#                    oeb03     LIKE oeb_file.oeb03,
#                    oeb04     LIKE oeb_file.oeb04,
#                    oeb05     LIKE oeb_file.oeb05,
#                    oeb06     LIKE oeb_file.oeb06,
#                    oeb11     LIKE oeb_file.oeb11,  #FUN-690032 add
#                    oeb12     LIKE oeb_file.oeb12,
#                    oeb13     LIKE oeb_file.oeb13,
#                    oeb14     LIKE oeb_file.oeb14,
#                    oeb15     LIKE oeb_file.oeb15,
#                    oeb17     LIKE oeb_file.oeb17,
#                    oeb18     LIKE oeb_file.oeb18,
#                    oeb19     LIKE oeb_file.oeb19,
#                    oeb20     LIKE oeb_file.oeb20,
#                    oeb21     LIKE oeb_file.oeb21,
#                    oeb910    LIKE oeb_file.oeb910, #MOD-6B0114
#                    oeb912    LIKE oeb_file.oeb912, #MOD-6B0114
#                    oeb913    LIKE oeb_file.oeb913, #MOD-6B0114
#                    oeb915    LIKE oeb_file.oeb915, #MOD-6B0114
#                    oeb916    LIKE oeb_file.oeb916, #MOD-6B0114
#                    oeb917    LIKE oeb_file.oeb917  #MOD-6B0114
#                    END RECORD,
#         l_i,l_j    LIKE type_file.num10,   #No.FUN-680137 INTEGER
#         l_k        LIKE type_file.num10,   #No.FUN-680137 INTEGER
#         l_flag     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
#         l_str1     LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(80)
#         l_str2     LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(80)
#         l_dash     LIKE type_file.chr20,   #No.FUN-680137 VARCHAR(20)
#         l_azi02    LIKE azi_file.azi02,
#         l_ged02    LIKE ged_file.ged02,
#        #MOD-7101949-begin
#        #y1,y2,y3   LIKE occ_file.occ18,  #No.FUN-680137 VARCHAR(36)
#        #x1,x2,x3   LIKE occ_file.occ18,  #No.FUN-680137 VARCHAR(36)
#         x1,x2,x3,y1,y2,y3  LIKE occ_file.occ241,
#        #MOD-7101949-end
#         l_oeb12    LIKE oeb_file.oeb12,
#         l_oeb14    LIKE oeb_file.oeb14,
#         l_oao06    LIKE oao_file.oao06
#  DEFINE l_oeb915      STRING                  #MOD-6B0114 add
#  DEFINE l_oeb912      STRING                  #MOD-6B0114 add
#  DEFINE l_ima906      LIKE ima_file.ima906    #MOD-6B0114 add
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#  ORDER BY sr.oea01
#
##NO.FUN-590110-begin
#  FORMAT
#   PAGE HEADER
#      CASE tm.n
#        WHEN '2' LET g_company=g_x[28] CLIPPED
#        WHEN '3' LET g_company=g_x[29] CLIPPED
#        OTHERWISE LET g_company=g_x[27] CLIPPED
#      END CASE
#      LET l_dash='===================='
#      LET g_pageno= g_pageno+1
#      PRINT COLUMN 01,g_x[11] CLIPPED,sr.oea01 CLIPPED,
#            #COLUMN 65,g_x[2] CLIPPED,g_pdate #FUN-5A0143 mark
#            COLUMN g_len-13,g_x[2] CLIPPED,g_pdate CLIPPED  #FUN-5A0143 add  #No.TQC-6A0091
#      PRINT COLUMN 01,g_x[12] CLIPPED,sr.oea12 CLIPPED,
#             #COLUMN 65,g_x[3] CLIPPED,g_pageno  USING '<<<'#FUN-5A0143 mark
#             COLUMN g_len-13,g_x[3] CLIPPED,g_pageno  USING '<<<' #FUN-5A0143 add
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED CLIPPED #TQC-5B0128
#      PRINT COLUMN ((g_len-FGL_WIDTH(l_dash CLIPPED))/2+1),l_dash CLIPPED #No.TQC-6A0091
#      IF g_pageno=1 THEN
#         PRINT g_x[13] CLIPPED,COLUMN 41,g_x[14] CLIPPED
#         SELECT occ18,occ231,occ232 INTO y1,y2,y3
#                FROM occ_file WHERE occ01=sr.oea03
#         CALL s_addr(sr.oea01,sr.oea04,sr.oea044) RETURNING x1,x2,x3
#         PRINT COLUMN 03,y1[1,40] CLIPPED, COLUMN 43,x1[1,27] CLIPPED   #No.TQC-6A0091
#         PRINT COLUMN 03,y2[1,40] CLIPPED, COLUMN 43,x2[1,27] CLIPPED   #No.TQC-6A0091
#         PRINT COLUMN 03,y3[1,40] CLIPPED, COLUMN 43,x3[1,27] CLIPPED   #No.TQC-6A0091
#      ELSE
#         PRINT
#         PRINT
#         PRINT
#         PRINT
#      END IF
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.oea01
#      SKIP TO TOP OF PAGE
#      LET l_flag = 'N'
#      LET l_oeb12=0  LET l_oeb14=0
#      SELECT ged02 INTO l_ged02 FROM ged_file WHERE ged01 = sr.oea43
#      IF SQLCA.sqlcode THEN LET l_ged02 = ' ' END IF
#      PRINT    #No.TQC-6A0091
#      PRINT COLUMN 01,g_x[16] CLIPPED,sr.oah02 CLIPPED,
#           #COLUMN 46,g_x[19] CLIPPED,' ',l_ged02[1,g_len-57] CLIPPED  #No:7670 #MOD-6B0114
#            COLUMN 46,g_x[19] CLIPPED,' ',l_ged02 CLIPPED              #No:7670 #MOD-6B0114 
#      PRINT COLUMN 01,g_x[17] CLIPPED,sr.oag02 CLIPPED,
#            COLUMN 46,g_x[20] CLIPPED,' ',sr.oea41 CLIPPED   #No.TQC-6A0091
#      PRINT COLUMN 01,g_x[18] CLIPPED,sr.oea33[1,35] CLIPPED,')',  #No.TQC-6A0091
#            COLUMN 46,g_x[21] CLIPPED,' ',sr.oea42 CLIPPED   #No.TQC-6A0091
#      DECLARE oao_cur CURSOR FOR SELECT oao06 FROM oao_file
#                                             WHERE oao01=sr.oea01
#                                               AND oao03=0 AND oao05='1'
#      FOREACH oao_cur INTO l_oao06
#          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#          IF NOT cl_null(l_oao06) THEN
#             PRINT COLUMN 01,l_oao06[1,g_len] CLIPPED   #No.TQC-6A0091
#          END IF
#      END FOREACH
#      PRINT g_dash2[1,g_len]
#      #PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37] #FUN-5A0143 mark
#      #FUN-5A0143 add
#      PRINTX name = H1 g_x[31],g_x[42] #MOD-6B0144
#      PRINTX name = H2 g_x[38]
#    #MOD-6B0114---mod-----str-----
#    # PRINTX name = H3 g_x[39]  #FUN-690032 add
#    ##FUN-690032 name=H3->name-H4
#    ##PRINTX name = H3 g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#    # PRINTX name = H4 g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#    # #FUN-5A0143 end
#      PRINTX name = H3 g_x[32],g_x[39],g_x[34],g_x[35],g_x[36],g_x[37]
#      PRINTX name = H4 g_x[33],g_x[40],g_x[41]
#    #MOD-6B0114---mod-----end-----
#      PRINT g_dash1
#
#   ON EVERY ROW
#      DECLARE oao_cur1 CURSOR FOR SELECT oao06 FROM oao_file
#                                              WHERE oao01=sr.oea01
#                                                AND oao03=sr.oeb03 AND oao05='1'
#      FOREACH oao_cur1 INTO l_oao06
#         IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#         IF NOT cl_null(l_oao06) THEN
#            PRINT COLUMN 01,l_oao06[1,g_len] CLIPPED   #No.TQC-6A0091
#         END IF
#      END FOREACH
#      SELECT azi03,azi04,azi05
#       INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取  #No.CHI-6A0004
#       FROM azi_file
#      WHERE azi01=sr.oea23
#      #MOD-6B0114--------add-----------str---
#      SELECT ima906 INTO l_ima906 
#        FROM ima_file
#       WHERE ima01=sr.oeb04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
#                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
#                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                    LET l_str2 = l_oeb912, sr.oeb910 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
#                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                      LET l_str2 = l_str2 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
#                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                    LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
#                END IF
#         END CASE
#      END IF
#      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
#            IF sr.oeb05  <> sr.oeb916 THEN
#               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
#               LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
#            END IF
#      END IF
#      #MOD-6B0114--------add-----------end---
#     ##FUN-5A0143 mark
#     #{PRINTX name=D1 COLUMN g_c[31],sr.oeb04 CLIPPED,
#     #      COLUMN g_c[32],sr.oeb05 CLIPPED,
#     #      COLUMN g_c[33],cl_numfor(sr.oeb12,33,t_azi04),  #No.CHI-6A0004
#     #      COLUMN g_c[34],sr.oea23 CLIPPED,
#     #      COLUMN g_c[35],cl_numfor(sr.oeb13,35,t_azi03),  #No.CHI-6A0004
#     #      COLUMN g_c[36],cl_numfor(sr.oeb14,36,t_azi04),  #No.CHI-6A0004
#     #      COLUMN g_c[37],sr.oeb15 CLIPPED
#     #PRINT COLUMN g_c[31],sr.oeb06 CLIPPED,
#     #      COLUMN g_c[33],sr.oeb18 CLIPPED,
#     #      COLUMN g_c[34],sr.oeb19 CLIPPED,
#     #      COLUMN g_c[35],sr.oeb20 CLIPPED,
#     #      COLUMN g_c[36],sr.oeb21 CLIPPED}
#     ##FUN-5A0143 add
#    #MOD-6B0114-------mark------str----
#    # PRINTX name = D1 COLUMN g_c[31],sr.oeb04 CLIPPED
#    # PRINTX name = D2 COLUMN g_c[38],sr.oeb06 CLIPPED
#    ##FUN-690032--begin
#    # PRINTX name = D3 COLUMN g_c[39],sr.oeb11 CLIPPED
#    # #PRINTX name = D3 COLUMN g_c[32],sr.oeb05 CLIPPED,
#    # PRINTX name = D4 COLUMN g_c[32],sr.oeb05 CLIPPED,
#    ##FUN-690032--end
#    #                  COLUMN g_c[33],cl_numfor(sr.oeb12,33,t_azi04), #No.CHI-6A0004
#    #                  COLUMN g_c[34],sr.oea23 CLIPPED,
#    #                  COLUMN g_c[35],cl_numfor(sr.oeb13,35,t_azi03), #No.CHI-6A0004
#    #                  COLUMN g_c[36],cl_numfor(sr.oeb14,36,t_azi04), #No.CHI-6A0004
#    #                  COLUMN g_c[37],sr.oeb15 CLIPPED
#    ##FUN-690032 D3->D4 
#    ##PRINTX name = D3 COLUMN g_c[33],sr.oeb18 CLIPPED,
#    # PRINTX name = D4 COLUMN g_c[33],sr.oeb18 CLIPPED,
#    #       COLUMN g_c[34],sr.oeb19 CLIPPED,
#    #       COLUMN g_c[35],sr.oeb20 CLIPPED,
#    #       COLUMN g_c[36],sr.oeb21 CLIPPED
#    # #FUN-5A0143 end
#    #MOD-6B0114-------mark------end----
#    #MOD-6B0114-------add-------str----
#      PRINTX name = D1 COLUMN g_c[31],sr.oeb04 CLIPPED,
#                       COLUMN g_c[42],sr.oeb11 CLIPPED
#      PRINTX name = D2 COLUMN g_c[38],sr.oeb06 CLIPPED
#      PRINTX name = D3 COLUMN g_c[32],sr.oeb05 CLIPPED,
#                       COLUMN g_c[39],sr.oeb916 CLIPPED, #計價單位
#                       COLUMN g_c[34],sr.oea23 CLIPPED,
#                       COLUMN g_c[35],cl_numfor(sr.oeb13,35,g_azi03),
#                       COLUMN g_c[36],cl_numfor(sr.oeb14,36,g_azi04),
#                       COLUMN g_c[37],sr.oeb15 CLIPPED
#      PRINTX name = D4 COLUMN g_c[33],cl_numfor(sr.oeb12,33,g_azi04),
#                       COLUMN g_c[40],cl_numfor(sr.oeb917,40,2), #計價數量
#                       COLUMN g_c[37],l_str2 CLIPPED             #單位註解
#    #MOD-6B0114-------add-------end----
#      DECLARE oao_cur2 CURSOR FOR SELECT oao06 FROM oao_file
#                                              WHERE oao01=sr.oea01
#                                                AND oao03=sr.oeb03 AND oao05='2'
#      FOREACH oao_cur2 INTO l_oao06
#          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#          IF NOT cl_null(l_oao06) THEN
#             PRINT COLUMN 01,l_oao06[1,g_len] CLIPPED   #No.TQC-6A0091
#          END IF
#      END FOREACH
# 
#   AFTER GROUP OF sr.oea01
#      LET l_oeb14= GROUP SUM(sr.oeb14)
#      LET l_oeb12= GROUP SUM(sr.oeb12)
#      PRINT g_dash2
#
#      PRINTX name=S1 COLUMN g_c[31],g_x[24] CLIPPED;
#      IF tm.p='Y' THEN
#         #PRINT COLUMN g_c[33],cl_numfor(l_oeb12,33,t_azi05);  #No.CHI-6A0004
#        #FUN-690032 D3->D4 
#        #PRINTX name = D3 COLUMN g_c[33],cl_numfor(l_oeb12,33,t_azi05);  #No.CHI-6A0004
#         PRINTX name = D4 COLUMN g_c[33],cl_numfor(l_oeb12,33,t_azi05);  #No.CHI-6A0004
#      END IF
#      #PRINT COLUMN g_c[34],sr.oea23 CLIPPED,
#     #FUN-690032 D3->D4 
#      #PRINTX name = D3 COLUMN g_c[34],sr.oea23 CLIPPED,
#      PRINTX name = D4 COLUMN g_c[34],sr.oea23 CLIPPED,
#           #MOD-6B0114----mod--------str------
#           #COLUMN g_c[35],cl_numfor(l_oeb14,35,t_azi05)  #No.CHI-6A0004
#            COLUMN g_c[36],cl_numfor(l_oeb14,35,t_azi05)  #No.CHI-6A0004
#           #MOD-6B0114----mod--------end------
#      PRINT
#      DECLARE oao_cur3 CURSOR FOR SELECT oao06 FROM oao_file
#                                              WHERE oao01=sr.oea01
#                                                AND oao03=0 AND oao05='2'
#      FOREACH oao_cur3 INTO l_oao06
#         IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#         IF NOT cl_null(l_oao06) THEN
#            PRINT COLUMN 01,l_oao06[1,g_len] CLIPPED   #No.TQC-6A0091
#         END IF
#      END FOREACH
#      CALL cl_say(l_oeb14,50) RETURNING l_str1,l_str2
#      SELECT azi02 INTO l_azi02 FROM azi_file WHERE azi01=sr.oea23
#      IF SQLCA.SQLCODE THEN LET l_azi02='  ' END IF
#      PRINT ''
#      IF l_str2=' ' THEN
#         PRINT COLUMN 01,g_x[30] CLIPPED,' ',l_azi02 CLIPPED,' ',l_str1 CLIPPED    #No.TQC-6A0091
#      ELSE
#         LET g_x[30]=g_x[30] CLIPPED
#         LET l_azi02=l_azi02 CLIPPED
#         LET l_i=length(g_x[30])
#         LET l_j=length(l_azi02)
#         LET l_k=l_i+l_j+4
#         PRINT COLUMN 01,g_x[30] CLIPPED,' ',l_azi02 CLIPPED,' ',l_str1[1,g_len-LENGTH(g_x[30] CLIPPED)-LENGTH(l_azi02 CLIPPED)-1] CLIPPED    #No.TQC-6A0091
#         PRINT COLUMN l_k,l_str2[1,g_len-l_k] CLIPPED   #No.TQC-6A0091
#      END IF
##NO.FUN-590110-end
#
#      LET g_pageno=0
#      LET l_flag='Y'
## FUN-550127
#   PAGE TRAILER
#     #IF tm.n != '2' AND l_flag= 'Y' THEN
#     #   PRINT COLUMN 01,g_x[25] CLIPPED,
#     #         COLUMN 45,g_x[26] CLIPPED
#     #   SKIP 2 LINE
#     #   PRINT COLUMN 01,'------------------------------',
#     #         COLUMN 45,'------------------------------'
#     #ELSE
#     #  PRINT '-------------------------------------------------------------------',
#     #        '----------------------------------'
#     #  SKIP 3 LINE
#     #END IF
#     IF l_flag = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[25]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[25]
#            PRINT g_memo
#     END IF
#
## END FUN-550127
#
#END REPORT
##Patch....NO.TQC-610037 <> #
#No.FUN-710090--end-- mark
