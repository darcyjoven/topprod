# Prog. Version..: '5.30.06-13.03.26(00010)'     #
#
# Pattern name...: axmr400.4gl
# Descriptions...: 合約/訂單確認書
# Date & Author..: 94/12/30 By Danny
# Modify.........: 03/03/12 BY Wiky(增列印訂單嘜頭)
# Modify.........: No:7674 03/08/08 Carol 報表列印麥頭時
#                                         須轉換 CCCCCC / PPPPPP / DDDDDD 資料
# Modify.........: No:#No.MOD-480345 03/08/16 Wiky 修改單價跟金額長度
# Modify.........: No.FUN-4C0096 05/03/04 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-570176 05/07/19 By yoyo 項次欄位加大
# Modify.........: No.MOD-570395 05/08/19 By Nicola 嘜頭列印修改,嘜頭拿訂單的嘜頭資料
# Modify.........: No.FUN-590110 05/09/29 By day  報表轉xml
# Modify.........: No.FUN-5A0143 05/10/20 By Rosayu 調整報表格式
# Modify.........: No.TQC-5A0128 05/11/21 By Nicola 數量取位錯誤
# Modify.........: No.TQC-5B0156 05/11/29 By Nicola LET sr.oea12=''
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-610017 06/01/13 By Nicola 報表格式修改
# Modify.........: No.FUN-570069 06/05/04 By Sarah 列印時,要參考axmi221的慣用語言出表(occ55)
# Modify.........: No.FUN-650020 06/05/26 By kim 整合信用額度的錯誤訊息為一個視窗,不要每筆都秀
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By rainy 新增是否列印客戶料號
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.MOD-6B0114 07/01/03 By Mandy 遵循多單位報表列印規則
# Modify.........: No.TQC-730022 07/03/28 By rainy 流程自動化
# Modify.........: No.MOD-730125 07/04/03 By claire 客戶簡稱取自訂單
# Modify.........: No.TQC-720017 07/04/04 By claire 慣用語言別沒有依客戶取值
# Modify.........: No.FUN-720014 07/04/09 By rainy 地址擴充成5欄位
# Modify.........: No.TQC-740271 07/05/08 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.TQC-750076 07/05/15 By rainy 報表title及公司名稱沒依occ55顯示
# Modify.........: No.TQC-750114 07/05/23 By rainy 列印條件語言別要和當頁的語言別相同
# Modify.........: No.CHI-7A0010 07/10/06 By Sarah 1.修正合計金額Double問題
#                                                  2.增加列印備註功能
# Modify.........: No.MOD-7B0236 07/11/28 By claire 配合oaz121參數超限應於單頭顯示
# Modify.........: No.FUN-7B0142 07/12/10 By jamie 不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.FUN-810029 08/02/22 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.TQC-840040 08/04/18 By claire FUN-7C0078 調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80024 10/08/09 By wujie 增加oeb32
# Modify.........: No.FUN-A80072 10/08/12 By yinhy 畫面條件選項增加一個選項，打印额外品名规格
# Modify.........: No.FUN-B30169 11/03/24 By xianghui 訂單單號、人員編號開窗
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改 
# Modify.........: No:FUN-940044 11/11/03 By xumm 整合單據列印EF簽核
# Modify.........: No.TQC-C10039 12/01/17 By wangrr 整合單據列印EF簽核
# Modify.........: No.TQC-C50101 12/05/11 By zhuhao 變量類型定義修改
# Modify.........: No.MOD-D30205 13/03/25 By Vampire 在EXCUTE前小數取位
DATABASE ds
 
GLOBALS "../../config/top.global"
#start FUN-570069 add
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5          #No.FUN-680137 SMALLINT
END GLOBALS
#end FUN-570069 add
 
DEFINE tm  RECORD                         # Print condition RECORD
            wc      LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(500)             # Where condition
            n       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(01)              # 列印單價
            b       LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(01)              # 列印訂單嘜頭
            d       LIKE type_file.chr1,          # 列印客戶料號
            c       LIKE type_file.chr1,          # 列印額外品名規格 No.FUN-A80072
           #e       LIKE type_file.chr1,          # 發送訂單確認書給客戶  #TQC-730022
            more    LIKE type_file.chr1           #No.FUN-680137 VARCHAR(01)               # Input more condition(Y/N)
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20,         #No.FUN-680137 VARCHAR(20)   # For TIPTOP 串 EasyFlow
       g_po_no,g_ctn_no1,g_ctn_no2      LIKE type_file.chr20         #No.FUN-680137  VARCHAR(20)      #No:7674
DEFINE g_cnt       LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE g_i         LIKE type_file.num5      #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE g_msg       LIKE type_file.chr1000    #No.FUN-680137 VARCHAR(72)
DEFINE g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oea01     LIKE oea_file.oea01,
          oea03     LIKE oea_file.oea03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE g_oea01     LIKE oea_file.oea01   #FUN-650020
DEFINE g_sma115    LIKE sma_file.sma115  #MOD-6B0114
DEFINE g_sma116    LIKE sma_file.sma116  #MOD-6B0114
DEFINE l_table     STRING                #TQC-740271 add
DEFINE l_table1    STRING                #CHI-7A0010 add
DEFINE l_table2    STRING                #FUN-A80072 add
DEFINE g_sql       STRING                #TQC-740271 add
DEFINE g_str       STRING                #TQC-740271 add
 
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
 
   #str TQC-740271 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oea00.oea_file.oea00  ,oea01.oea_file.oea01,",
               "oea02.oea_file.oea02  ,oea10.oea_file.oea10,",
               "oea11.oea_file.oea11  ,oea12.oea_file.oea12,",
               "oea03.oea_file.oea03  ,oea032.oea_file.oea032,",
               "oea04.oea_file.oea04  ,oea044.oea_file.oea032,",
               "oea44.oea_file.oea44  ,occ02.occ_file.occ02,",
               "oea06.oea_file.oea06  ,oea14.oea_file.oea14,",
               "oea15.oea_file.oea15  ,oea23.oea_file.oea23,",
               "oea21.oea_file.oea21  ,oea25.oea_file.oea25,",
               "oea31.oea_file.oea31  ,oea32.oea_file.oea32,",
               "oea33.oea_file.oea33  ,oeb03.oeb_file.oeb03,",
               "oeb04.oeb_file.oeb04  ,ima021.ima_file.ima021,",
               "oeb05.oeb_file.oeb05  ,oeb12.oeb_file.oeb12,",
               "oeb13.oeb_file.oeb13  ,oeb14.oeb_file.oeb14,",
               "oeb14t.oeb_file.oeb14t,oeb15.oeb_file.oeb15,",
               "oeb06.oeb_file.oeb06  ,oeb11.oeb_file.oeb11,",
               "oeb17.oeb_file.oeb17  ,oeb18.oeb_file.oeb18,",
               "oeb19.oeb_file.oeb19  ,oeb20.oeb_file.oeb20,",
               "oeb21.oeb_file.oeb21  ,oeb32.oeb_file.oeb32,",                         #FUN-7B0142 mod   #No.FUN-A80024 add oeb32
              #"oeb21.oeb_file.oeb21  ,occ55.occ_file.occ55,",    #FUN-7B0142 mark
               "oeb916.oeb_file.oeb916,oeb917.oeb_file.oeb917,",
               "gfe03.gfe_file.gfe03  ,azi03.azi_file.azi03,",
               "azi04.azi_file.azi04  ,azi05.azi_file.azi05,",
               "occ02_1.occ_file.occ02,gen02.gen_file.gen02,",
               "oab02.oab_file.oab02  ,gem02.gem_file.gem02,",
               "oah02.oah_file.oah02  ,oag02.oag_file.oag02,",
               "gec02.gec_file.gec02  ,addr1.occ_file.occ241,",
               "addr2.occ_file.occ241 ,addr3.occ_file.occ241,",
               "addr4.occ_file.occ241 ,addr5.occ_file.occ241,",
               "unit.type_file.chr50  ,ocf01.ocf_file.ocf01,",
               "ocf02.ocf_file.ocf02  ,ocf101.ocf_file.ocf101,",
               "ocf102.ocf_file.ocf102,ocf103.ocf_file.ocf103,",
               "ocf104.ocf_file.ocf104,ocf105.ocf_file.ocf105,",
               "ocf106.ocf_file.ocf106,ocf107.ocf_file.ocf107,",
               "ocf108.ocf_file.ocf108,ocf109.ocf_file.ocf109,",
               "ocf110.ocf_file.ocf110,ocf111.ocf_file.ocf111,",
               "ocf112.ocf_file.ocf112,ocf201.ocf_file.ocf201,",
               "ocf202.ocf_file.ocf202,ocf203.ocf_file.ocf203,",
               "ocf204.ocf_file.ocf204,ocf205.ocf_file.ocf205,",
               "ocf206.ocf_file.ocf206,ocf207.ocf_file.ocf207,",
               "ocf208.ocf_file.ocf208,ocf209.ocf_file.ocf209,",
               "ocf210.ocf_file.ocf210,ocf211.ocf_file.ocf211,",
               "ocf212.ocf_file.ocf212,zo02.zo_file.zo02,",   #TQC-750076 add
               "g_msg.type_file.chr50,",   #MOD-7B0236
               "zo041.zo_file.zo041,zo05.zo_file.zo05,zo09.zo_file.zo09,",   #FUN-810029 add
               "oeb07.oeb_file.oeb07,l_count.type_file.num5,",               #FUN-940044 add 2,
               "sign_type.type_file.chr1, sign_img.type_file.blob,",         #簽核方式, 簽核圖檔    #FUN-940044 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000"         #是否顯示簽核資料(Y/N) #TQC-C10039 sign_str
              #str CHI-7A0010 mark
              #"oao04.oao_file.oao04,",
              #"oao06h.oao_file.oao06 ,oao06d1.oao_file.oao06,",
              #"oao06d2.oao_file.oao06,oao06t.oao_file.oao06"
              #end CHI-7A0010 mark
   LET l_table = cl_prt_temptable('axmr400',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   #str CHI-7A0010 add
    #備註
    LET g_sql = "oao01.oao_file.oao01,",
                "oao03.oao_file.oao03,",
                "oao04.oao_file.oao04,",
                "oao05.oao_file.oao05,",
                "oao06.oao_file.oao06"
    LET l_table1 = cl_prt_temptable('axmr4001',g_sql) CLIPPED
    IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   #end CHI-7A0010 add
   #No.FUN-A80072 --start--
   LET g_sql = "imc01.imc_file.imc01,",
               "imc02.imc_file.imc02,",
               "imc03.imc_file.imc03,",
               "imc04.imc_file.imc04,",
               "oea01.oea_file.oea01,",
               "oeb03.oeb_file.oeb03"
    LET l_table2 = cl_prt_temptable('axmr4002',g_sql) CLIPPED
    IF  l_table2 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-A80072 --end--
   #------------------------------ CR (1) ------------------------------#
 
  #start FUN-570069 add
   LET g_pdate  = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #end FUN-570069 add
   LET tm.wc    = ARG_VAL(7)                          #FUN-570069 modify
   LET tm.n     = ARG_VAL(8)                          #FUN-570069 modify
   LET tm.b     = ARG_VAL(9)       
   LET tm.c     = ARG_VAL(10)                         #FUN-A80072 modify
  #LET g_rpt_name = ARG_VAL(2)   # 外部指定報表名稱   #FUN-570069 mark
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)                       #FUN-570069 modify
   LET g_rep_clas = ARG_VAL(12)                       #FUN-570069 modify
   LET g_template = ARG_VAL(13)                       #FUN-570069 modify
   #No.FUN-570264 ---end---
#TQC-730022 begin
   LET tm.d = ARG_VAL(13)   #是否發mail給客戶
  #LET tm.e = ARG_VAL(14)   #是否發mail給客戶   #TQC-740271 mark
   LET g_xml.subject = ARG_VAL(14)
   LET g_xml.body = ARG_VAL(15)
   LET g_xml.recipient = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
#TQC-730022 end
 
  #LET g_rpt_name = ''
  
  #IF cl_null(tm.wc) THEN                                         #FUN-570069 mark
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') THEN  # If background   #FUN-570069
      CALL axmr400_tm(0,0)             # Input print condition
   ELSE 
  #   LET tm.wc="oea01= '",tm.wc CLIPPED,"'"   #FUN-570069 mark
      CALL axmr400()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr400_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr400_w AT p_row,p_col WITH FORM "axm/42f/axmr400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'       
   LET g_copies = '1'
   LET tm.n ='Y'
   LET tm.b ='Y'
   LET tm.d ='Y'   #FUN-690032 add
   LET tm.c ='N'   #FUN-A80072 add 
  #LET tm.e ='N'   #TQC-730022 add   #TQC-740271 mark
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea14
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
    #No.FUN-B30169-add-start--
      ON ACTION controlp
         CASE
            WHEN INFIELD(oea01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_oea11"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea01
               NEXT FIELD oea01
            WHEN INFIELD(oea14)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gen"
               LET g_qryparam.state ="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea14
               NEXT FIELD oea14
         OTHERWISE
            EXIT CASE
         END CASE
    #No.FUN-B30169-add-end--

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
      LET INT_FLAG = 0 CLOSE WINDOW axmr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #INPUT BY NAME tm.n,tm.b,tm.d,tm.e,tm.more WITHOUT DEFAULTS  #BugNo:6289  #FUN-690032 add tm.d  #TQC-730022 add tm.e   #TQC-740271 mark
   INPUT BY NAME tm.n,tm.b,tm.c,tm.d,tm.more WITHOUT DEFAULTS  #BugNo:6289  #FUN-690032 add tm.d  #FUN-A80072 add tm.c                         #TQC-740271
#        #No.FUN-580031 --start--
#        BEFORE INPUT
#            CALL cl_qbe_display_condition(lc_qbe_sn)
#        #No.FUN-580031 ---end---
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[YN]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD b                #NO:6882
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF
 
     #FUN-690032 add--begin
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
     #FUN-690032 add--end
     #FUN-A80072 --start--
     AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
     #FUN-A80072 --start--
 
    #str TQC-740271 mark
    ##TQC-730022 add--begin
    # AFTER FIELD e
    #    IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
    #       NEXT FIELD e
    #    END IF
    ##TQC-730022 add--end
    #end TQC-740271 mark
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr400','9031',1)
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
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,   #No.FUN-A80072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr400',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr400()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr400_w
END FUNCTION
 
FUNCTION axmr400()
#TQC-730022 add
  DEFINE l_cmd           LIKE type_file.chr1000 
  DEFINE l_oce03         LIKE oce_file.oce03
  DEFINE l_oce05         LIKE oce_file.oce05
  DEFINE l_zo02          LIKE zo_file.zo02
  DEFINE l_zo041         LIKE zo_file.zo041       #FUN-810029 add
  DEFINE l_zo05          LIKE zo_file.zo05        #FUN-810029 add
  DEFINE l_zo09          LIKE zo_file.zo09        #FUN-810029 add
  DEFINE l_subject       STRING   #主旨
  DEFINE l_body          STRING   #內文路徑
  DEFINE l_recipient     STRING   #收件者
  DEFINE l_cnt           LIKE   type_file.num5    #SMALLINT
  DEFINE l_wc            STRING
  DEFINE ls_context      STRING  
  DEFINE ls_temp_path    STRING 
  DEFINE ls_context_file STRING
  DEFINE l_oea01_t       LIKE oea_file.oea01
  DEFINE l_count         LIKE   type_file.num5    #SMALLINT  #No.FUN-A80072
#TQC-730022 end
 
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
         # l_time    LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)  #TQC-C50101 mark
         #l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)    #TQC-C50101 mark
          l_sql     STRING,                       #TQC-C50101 add
          sr        RECORD
                    oea00     LIKE oea_file.oea00,
                    oea01     LIKE oea_file.oea01,
                    oea02     LIKE oea_file.oea02,
                    oea10     LIKE oea_file.oea10,   #No.MOD-570395
                    oea11     LIKE oea_file.oea11,
                    oea12     LIKE oea_file.oea12,
                #   oea71     LIKE oea_file.oea71,    oea71 --> oea03
                    oea03     LIKE oea_file.oea03,
                    oea032    LIKE oea_file.oea032,
                    oea04     LIKE oea_file.oea04,
                    oea044    LIKE oea_file.oea044,
                    oea44     LIKE oea_file.oea44,   #No.MOD-570395
                    occ02     LIKE occ_file.occ02,
                    oea06     LIKE oea_file.oea06,
                    oea14     LIKE oea_file.oea14,
                    oea15     LIKE oea_file.oea15,
                    oea23     LIKE oea_file.oea23,
                    oea21     LIKE oea_file.oea21,
                    oea25     LIKE oea_file.oea25,
                    oea31     LIKE oea_file.oea31,
                    oea32     LIKE oea_file.oea32,
                    oea33     LIKE oea_file.oea33,
                    oeb03     LIKE oeb_file.oeb03,
                    oeb04     LIKE oeb_file.oeb04,
                    ima021    LIKE ima_file.ima021,
                    oeb05     LIKE oeb_file.oeb05,
                    oeb12     LIKE oeb_file.oeb12,
                    oeb13     LIKE oeb_file.oeb13,
                    oeb14     LIKE oeb_file.oeb14,
                    oeb14t    LIKE oeb_file.oeb14t,
                    oeb15     LIKE oeb_file.oeb15,
                    oeb06     LIKE oeb_file.oeb06,
                    oeb07     LIKE oeb_file.oeb07,  #No.FUN-A80072
                    oeb11     LIKE oeb_file.oeb11,
                    oeb17     LIKE oeb_file.oeb17,
                    oeb18     LIKE oeb_file.oeb18,
                    oeb19     LIKE oeb_file.oeb19,
                    oeb20     LIKE oeb_file.oeb20,
                    oeb21     LIKE oeb_file.oeb21,
                    oeb32     LIKE oeb_file.oeb32,  #No.FUN-A80024
                    ofa04     LIKE ofa_file.ofa04,  #No:7646
                    ofa10     LIKE ofa_file.ofa10,  #No:7646
                    ofa44     LIKE ofa_file.ofa44,  #No:7646
                    ofa45     LIKE ofa_file.ofa45,  #No:7646
                    ofa46     LIKE ofa_file.ofa46,  #No:7646
                   #occ55     LIKE occ_file.occ55,  #FUN-7B0142 mark #FUN-570069 add
                    oeb910    LIKE oeb_file.oeb910, #MOD-6B0114
                    oeb912    LIKE oeb_file.oeb912, #MOD-6B0114
                    oeb913    LIKE oeb_file.oeb913, #MOD-6B0114
                    oeb915    LIKE oeb_file.oeb915, #MOD-6B0114
                    oeb916    LIKE oeb_file.oeb916, #MOD-6B0114
                    oeb917    LIKE oeb_file.oeb917  #MOD-6B0114
                    END RECORD,
          #No.FUN-A80072  --start--
          sr1       RECORD
                    imc01     LIKE imc_file.imc01,
                    imc02     LIKE imc_file.imc02,
                    imc03     LIKE imc_file.imc03,
                    imc04     LIKE imc_file.imc04
                    END RECORD
          #No.FUN-A80072  --end--
   DEFINE oao      RECORD LIKE oao_file.*            #CHI-7A0010 add
   DEFINE l_msg    STRING    #FUN-650020
   DEFINE l_msg2   STRING    #FUN-650020
   DEFINE lc_gaq03 LIKE gaq_file.gaq03   #FUN-650020
   DEFINE l_oea03 DYNAMIC ARRAY OF LIKE oea_file.oea03  #TQC-730022
   DEFINE l_oea01 DYNAMIC ARRAY OF LIKE oea_file.oea01  #TQC-730022
   DEFINE l_i,l_j     LIKE type_file.num5     #TQC-730022
   #str TQC-740271 add
   DEFINE l_gfe03   LIKE gfe_file.gfe03,
          l_occ02   LIKE occ_file.occ02,
          l_gen02   LIKE gen_file.gen02,
          l_oab02   LIKE oab_file.oab02,
          l_gem02   LIKE gem_file.gem02,
          l_oah02   LIKE oah_file.oah02,
          l_oag02   LIKE oag_file.oag02,
          l_gec02   LIKE gec_file.gec02,
          l_addr1   LIKE occ_file.occ241,
          l_addr2   LIKE occ_file.occ241,
          l_addr3   LIKE occ_file.occ241,
          l_addr4   LIKE occ_file.occ241,
          l_addr5   LIKE occ_file.occ241,
          l_ima906  LIKE ima_file.ima906,
          l_oeb910  LIKE oeb_file.oeb910,
          l_oeb912  LIKE oeb_file.oeb912,
          l_oeb913  LIKE oeb_file.oeb913,
          l_oeb915  LIKE oeb_file.oeb915,
          l_oeb12   LIKE oeb_file.oeb12,
          l_unit    LIKE type_file.chr50,
         #l_oao04   LIKE oao_file.oao04,   #CHI-7A0010 mark
         #l_oao06   LIKE oao_file.oao06,   #CHI-7A0010 mark
          l_ocf     RECORD LIKE ocf_file.* 
   #end TQC-740271 add
DEFINE l_lang_t     LIKE type_file.chr1,   #TQC-750114
       l_wc0        STRING,
       l_wc1        STRING,
       l_wc2        STRING
   ###No.FUN-940044 START###
   DEFINE   l_img_blob     LIKE type_file.blob
#TQC-C10039--add--start---
   #DEFINE   l_ii           INTEGER
   #DEFINE   l_key          RECORD                  #主鍵
   #            v1          LIKE oea_file.oea01
   #                        END RECORD
#TQC-C10039--add--end---
   ###No.FUN-940044 END###
 
   #str TQC-740271 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   LOCATE l_img_blob IN MEMORY #blob初始化  #No.FUN-940044 add
   CALL cl_del_data(l_table1)   #CHI-7A0010 add
   CALL cl_del_data(l_table2)   #No.FUN-A80072 
   #------------------------------ CR (2) ------------------------------#
 
  #str CHI-7A0010 add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  #?  #FUN-7B0142 mod  #?,?,?,?,?  #071002 mod  #MOD-7B0236   #FUN-810029 84?->87?  #No.FUN-A80024 add ? #No.FUN-A80072 add 2?  #No.FUN-940044 add 3?#TQC-C10039 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
  #end CHI-7A0010 add
   #No.FUN-A80072 --start--
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
      EXIT PROGRAM
   END IF
   #No.FUN-A80072 --end--
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #MOD-6B0114
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  #str FUN-810029 mod
  #公司全名zo02、公司地址zo041、公司電話zo05、公司傳真zo09
   LET l_zo041 = NULL  LET l_zo05 = NULL  LET l_zo09 = NULL
   SELECT zo02,zo041,zo05,zo09 INTO g_company,l_zo041,l_zo05,l_zo09
     FROM zo_file WHERE zo01=g_rlang
  #end FUN-810029 mod
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #TQC-740271 add
 
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
 
   LET l_sql="SELECT oea00,oea01,oea02,oea10,oea11,oea12,",   #No.MOD-570395
             "       oea03,oea032,oea04,oea044,oea44,occ02,oea06,",   #No:BGU-570395
             "       oea14,oea15,oea23,oea21,oea25,oea31,oea32,",
             "       oea33,oeb03,oeb04,ima021,oeb05,oeb12,oeb13,oeb14,",
             "       oeb14t,oeb15,oeb06,oeb07,oeb11,oeb17,oeb18,oeb19,oeb20,oeb21,oeb32",       #No.FUN-A80024 add oeb32 #No.FUN-A80072 add oeb07
             ",'','','','','',",     #No:7674
            #"      ,occ55,",        #FUN-7B0142 mark      #FUN-570069 add
             "oeb910,oeb912,oeb913,oeb915,oeb916,oeb917 ", #MOD-6B0114 add
             "  FROM oea_file,oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01,occ_file ", 
             " WHERE oea01=oeb01 ",
             "   AND oea04=occ01 ",  
             "   AND oeaconf != 'X' ", #01/08/01 mandy
             "   AND ",tm.wc CLIPPED,
             " ORDER BY oea01,oea02,oeb03 "
   PREPARE axmr400_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE axmr400_curs1 CURSOR FOR axmr400_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF

###No.FUN-940044 START ###
   #單據key值
   LET l_sql="SELECT oea01",
             "  FROM oea_file,oeb_file LEFT OUTER JOIN ima_file ON oeb_file.oeb04 = ima_file.ima01,occ_file ",
             " WHERE oea_file.oea01 = oeb_file.oeb01 ",
             "   AND oea_file.oea04 = occ_file.occ01 ",
             "   AND oeaconf != 'X' ",
             "   AND ",tm.wc CLIPPED,
             " ORDER BY oea01"
   
   PREPARE r400_pr1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r400_cs1 CURSOR FOR r400_pr1
  
###No.FUN-940044 END ### 
 #-----No.MOD-570395 Mark-----
#No.7674
#   LET l_sql="SELECT ofa04,ofa10,ofa44,ofa45,ofa46 FROM ofa_file ",
#             " WHERE ofa16 = ? " #AND ofaconf = 'Y' "
#   PREPARE axmr400_prepare2 FROM l_sql
#   IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) RETURN END IF
#   DECLARE axmr400_curs2 CURSOR FOR axmr400_prepare2
#   IF STATUS THEN CALL cl_err('declare2:',STATUS,1) RETURN END IF
##
 #-----No.MOD-570395 Mark END-----
  
  #str TQC-740271 mark
  #IF NOT cl_null(g_rpt_name) THEN   #已有外部指定報表名稱
  #   LET l_name = g_rpt_name
  #ELSE
  #   CALL cl_outnam('axmr400') RETURNING l_name
  #END IF
  ##MOD-6B0114--add---str---
  ##zaa06隱藏否
  #IF g_sma.sma116 MATCHES '[23]' THEN    
  #    LET g_zaa[57].zaa06 = "N" #計價單位
  #    LET g_zaa[58].zaa06 = "N" #計價數量
  #    LET g_zaa[46].zaa06 = "Y" #單位
  #    LET g_zaa[47].zaa06 = "Y" #數量
  #ELSE
  #    LET g_zaa[57].zaa06 = "Y" #計價單位
  #    LET g_zaa[58].zaa06 = "Y" #計價數量
  #    LET g_zaa[46].zaa06 = "N" #單位
  #    LET g_zaa[47].zaa06 = "N" #數量
  #END IF
  #IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN    
  #    LET g_zaa[59].zaa06 = "N" #單位註解
  #ELSE
  #    LET g_zaa[59].zaa06 = "Y" #單位註解
  #END IF
  #IF tm.n = 'Y' THEN #單價/金額列印否
  #    LET g_zaa[48].zaa06 = "N" #單價
  #    LET g_zaa[49].zaa06 = "N" #未稅金額
  #    LET g_zaa[50].zaa06 = "N" #含稅金額
  #ELSE
  #    LET g_zaa[48].zaa06 = "Y" #單價
  #    LET g_zaa[49].zaa06 = "Y" #未稅金額
  #    LET g_zaa[50].zaa06 = "Y" #含稅金額
  #END IF
  ##MOD-6B0114--add---end---
  ##FUN-690032 add--begin
  #IF tm.d = 'Y' THEN
  #   #LET g_zaa[57].zaa06 = 'N' #MOD-6B0114
  #    LET g_zaa[61].zaa06 = 'N' #MOD-6B0114
  #ELSE
  #   #LET g_zaa[57].zaa06 = 'Y' #MOD-6B0114
  #    LET g_zaa[61].zaa06 = 'Y' #MOD-6B0114
  #END IF
  ##FUN-690032 add--end
  #
  #CALL cl_prt_pos_len()  #FUN-690032
  #START REPORT axmr400_rep TO l_name
  #
  ##start FUN-570069 add
  #LET l_sql = "SELECT zaa02,zaa08,zaa09,zaa14,zaa16 FROM zaa_file ",
  #            "WHERE zaa01 = '",g_prog ,"' AND zaa03 = ? ",
  #            "  AND zaa04 = '",g_zaa04_value,"' ",
  #            "  AND zaa10 = '",g_zaa10_value,"'",
  #            "  AND zaa11 = '",g_zaa11_value CLIPPED,"'",
  #            "  AND zaa17 = '",g_zaa17_value CLIPPED,"'" 
  #PREPARE r400_zaa_pre FROM l_sql
  #DECLARE r400_zaa_cur CURSOR FOR r400_zaa_pre
  #
  #LET l_sql = "SELECT zab05 from zab_file ",
  #            " WHERE zab01= ? AND zab04= ? AND zab03 = ?"
  #PREPARE zab_prepare FROM l_sql
  ##end FUN-570069 add
  #
  #LET g_pageno = 0
  #end TQC-740271 mark
   LET l_i = 0  #TQC-730022
   CALL g_show_msg.clear() #FUN-650020
   FOREACH axmr400_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
      #str TQC-740271 add
      #慣用文件列印語言
      #IF cl_null(sr.occ55) THEN LET sr.occ55 = '0' END IF   #FUN-7B0142 mark
      #單位小數位數
      SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.oeb05
      IF cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
     #MOD-D30205 mark start -----
     ##單價、金額、小計小數位數
     #SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
     #  FROM azi_file WHERE azi01=sr.oea23
     #IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF
     #IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
     #IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF
     #MOD-D30205 mark end   -----
      #帳款客戶名稱
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oea03
      IF SQLCA.SQLCODE THEN LET l_occ02='' END IF
      #員工姓名
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oea14
      IF SQLCA.SQLCODE THEN LET l_gen02='' END IF
      #分類名稱
      SELECT oab02 INTO l_oab02 FROM oab_file WHERE oab01=sr.oea25
      IF SQLCA.SQLCODE THEN LET l_oab02='' END IF
      #部門名稱
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oea15
      IF SQLCA.SQLCODE THEN LET l_gem02='' END IF
      #說明
      SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=sr.oea31
      IF SQLCA.SQLCODE THEN LET l_oah02='' END IF
      #說明
      SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=sr.oea32
      IF SQLCA.SQLCODE THEN LET l_oah02='' END IF
      #稅別名稱
      SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01=sr.oea21 AND gec011='2'   #銷項
      IF SQLCA.SQLCODE THEN LET l_gec02='' END IF
      #地址檔
      CALL s_addr(sr.oea01,sr.oea04,sr.oea044) 
           RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5
      IF SQLCA.SQLCODE THEN
         LET l_addr1='' LET l_addr2='' LET l_addr3='' 
         LET l_addr4='' LET l_addr5=''
      END IF
      #客戶信用查核
      LET g_msg=NULL
      IF g_oaz.oaz121 = "1" THEN
         CALL s_ccc_logerr()  #FUN-650020
         LET g_oea01=sr.oea01 #FUN-650020
         CALL s_ccc(sr.oea03,'0','')      #Customer Credit Check 客戶信用查核
         #FUN-650020...............begin
         IF r400_err_ana(g_showmsg) THEN
 
         END IF
         #Fun-650020...............end
         IF g_errno = 'N' THEN
            CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
         END IF
      END IF
      #單位備註(當使用多單位時才需要印)
      LET l_unit = ""
      IF g_sma115 = "Y" THEN
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.oeb04
         CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
               LET l_unit = l_oeb915 , sr.oeb913 CLIPPED
               IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
                  CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                  LET l_unit = l_oeb912, sr.oeb910 CLIPPED
               ELSE
                 IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                    LET l_unit = l_unit CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
                 END IF
               END IF
            WHEN "3"
               IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
                  CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                  LET l_unit = l_oeb915 , sr.oeb913 CLIPPED
               END IF
         END CASE
      END IF
      IF g_sma116 MATCHES '[13]' THEN    #No.FUN-610076
         IF sr.oeb05  <> sr.oeb916 THEN
            CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
            LET l_unit = l_unit CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
         END IF
      END IF
     #str CHI-7A0010 mod
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
     #end CHI-7A0010 mod
      #客戶嘜頭檔
      SELECT * INTO l_ocf.* FROM ocf_file WHERE ocf01=sr.oea04 AND ocf02=sr.oea44
      IF SQLCA.SQLCODE THEN INITIALIZE l_ocf.* TO NULL END IF
      IF NOT cl_null(l_ocf.ocf01) THEN
         #-----No.MOD-570395-----
         LET g_po_no=sr.oea10
         LET g_ctn_no1=""
         LET g_ctn_no2=""
         #-----No.MOD-570395 END-----
         LET l_ocf.ocf101=r400_ocf_c(l_ocf.ocf101)
         LET l_ocf.ocf102=r400_ocf_c(l_ocf.ocf102)
         LET l_ocf.ocf103=r400_ocf_c(l_ocf.ocf103)
         LET l_ocf.ocf104=r400_ocf_c(l_ocf.ocf104)
         LET l_ocf.ocf105=r400_ocf_c(l_ocf.ocf105)
         LET l_ocf.ocf106=r400_ocf_c(l_ocf.ocf106)
         LET l_ocf.ocf107=r400_ocf_c(l_ocf.ocf107)
         LET l_ocf.ocf108=r400_ocf_c(l_ocf.ocf108)
         LET l_ocf.ocf109=r400_ocf_c(l_ocf.ocf109)
         LET l_ocf.ocf110=r400_ocf_c(l_ocf.ocf110)
         LET l_ocf.ocf111=r400_ocf_c(l_ocf.ocf111)
         LET l_ocf.ocf112=r400_ocf_c(l_ocf.ocf112)
         LET l_ocf.ocf201=r400_ocf_c(l_ocf.ocf201)
         LET l_ocf.ocf202=r400_ocf_c(l_ocf.ocf202)
         LET l_ocf.ocf203=r400_ocf_c(l_ocf.ocf203)
         LET l_ocf.ocf204=r400_ocf_c(l_ocf.ocf204)
         LET l_ocf.ocf205=r400_ocf_c(l_ocf.ocf205)
         LET l_ocf.ocf206=r400_ocf_c(l_ocf.ocf206)
         LET l_ocf.ocf207=r400_ocf_c(l_ocf.ocf207)
         LET l_ocf.ocf208=r400_ocf_c(l_ocf.ocf208)
         LET l_ocf.ocf209=r400_ocf_c(l_ocf.ocf209)
         LET l_ocf.ocf210=r400_ocf_c(l_ocf.ocf210)
         LET l_ocf.ocf211=r400_ocf_c(l_ocf.ocf211)
         LET l_ocf.ocf212=r400_ocf_c(l_ocf.ocf212)
      ELSE
         LET l_ocf.ocf01=' '
         LET l_ocf.ocf02=' '
         LET l_ocf.ocf101=' '
         LET l_ocf.ocf102=' '
         LET l_ocf.ocf103=' '
         LET l_ocf.ocf104=' '
         LET l_ocf.ocf105=' '
         LET l_ocf.ocf106=' '
         LET l_ocf.ocf107=' '
         LET l_ocf.ocf108=' '
         LET l_ocf.ocf109=' '
         LET l_ocf.ocf110=' '
         LET l_ocf.ocf111=' '
         LET l_ocf.ocf112=' '
         LET l_ocf.ocf201=' '
         LET l_ocf.ocf202=' '
         LET l_ocf.ocf203=' '
         LET l_ocf.ocf204=' '
         LET l_ocf.ocf205=' '
         LET l_ocf.ocf206=' '
         LET l_ocf.ocf207=' '
         LET l_ocf.ocf208=' '
         LET l_ocf.ocf209=' '
         LET l_ocf.ocf210=' '
         LET l_ocf.ocf211=' '
         LET l_ocf.ocf212=' '
      END IF
      #No.FUN-A80072  --start  列印額外品名規格說明
      IF tm.c = 'Y' THEN
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
       #No.FUN-A80072  --end
     #MOD-D30205 add start -----
      #單價、金額、小計小數位數
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
        FROM azi_file WHERE azi01=sr.oea23
      IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF
      IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
      IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF
     #MOD-D30205 add end  -----
      EXECUTE insert_prep USING 
        sr.oea00    ,sr.oea01    ,sr.oea02    ,sr.oea10    ,sr.oea11    ,
         sr.oea12    ,sr.oea03    ,sr.oea032   ,sr.oea04    ,sr.oea044   ,
         sr.oea44    ,sr.occ02    ,sr.oea06    ,sr.oea14    ,sr.oea15    ,
         sr.oea23    ,sr.oea21    ,sr.oea25    ,sr.oea31    ,sr.oea32    ,
         sr.oea33    ,sr.oeb03    ,sr.oeb04    ,sr.ima021   ,sr.oeb05    ,
         sr.oeb12    ,sr.oeb13    ,sr.oeb14    ,sr.oeb14t   ,sr.oeb15    ,
         sr.oeb06    ,sr.oeb11    ,sr.oeb17    ,sr.oeb18    ,sr.oeb19    ,
         sr.oeb20    ,sr.oeb21    ,sr.oeb32    ,sr.oeb916   ,sr.oeb917   ,                #FUN-7B0142 mod   No.FUN-A80024 add oeb32
        #sr.oeb20    ,sr.oeb21    ,sr.occ55    ,sr.oeb916   ,sr.oeb917   ,   #FUN-7B0142 mark 
         l_gfe03     ,t_azi03     ,t_azi04     ,t_azi05     ,l_occ02     ,
         l_gen02     ,l_oab02     ,l_gem02     ,l_oah02     ,l_oag02     ,
         l_gec02     ,l_addr1     ,l_addr2     ,l_addr3     ,l_addr4     ,
         l_addr5     ,l_unit      ,l_ocf.ocf01 ,l_ocf.ocf02 ,l_ocf.ocf101,
         l_ocf.ocf102,l_ocf.ocf103,l_ocf.ocf104,l_ocf.ocf105,l_ocf.ocf106,
         l_ocf.ocf107,l_ocf.ocf108,l_ocf.ocf109,l_ocf.ocf110,l_ocf.ocf111,
         l_ocf.ocf112,l_ocf.ocf201,l_ocf.ocf202,l_ocf.ocf203,l_ocf.ocf204,
         l_ocf.ocf205,l_ocf.ocf206,l_ocf.ocf207,l_ocf.ocf208,l_ocf.ocf209,
         l_ocf.ocf210,l_ocf.ocf211,l_ocf.ocf212,l_zo02,g_msg #MOD-7B0236
        ,l_zo041     ,l_zo05      ,l_zo09  ,sr.oeb07 ,l_count      #FUN-810029 add  #FUN-A80072 add l_count
        ,"",l_img_blob,"N",""                                      #FUN-940044 add  #TQC-C10039 add ""
      #end TQC-740271 add
 
 #----No.MOD-570395 Mark-----
#No:7674
#     FOREACH axmr400_curs2 USING sr.oea01
#        INTO sr.ofa04,sr.ofa10,sr.ofa44,sr.ofa45,sr.ofa46
#        IF SQLCA.sqlcode THEN
#           LET sr.ofa10 =''
#           LET sr.ofa45 =''
#           LET sr.ofa46 =''
#        END IF
#        EXIT FOREACH
#     END FOREACH
##
 #----No.MOD-570395 Mark END-----
 
    #str TQC-740271 mark
    # OUTPUT TO REPORT axmr400_rep(sr.*)
    ##TQC-730022  #如果有勾依客戶發送則再跑一次 背景axmt400發mail給客戶
    # #sr.oea03 客戶
    #
    # IF g_bgjob = 'N' AND tm.e = 'Y' THEN
    #    IF cl_null(l_oea01_t) OR (l_oea01_t <> sr.oea01) THEN
    #       LET l_i = l_i + 1
    #       LET l_oea03[l_i] = sr.oea03
    #       LET l_oea01[l_i] = sr.oea01
    #       LET l_oea01_t = sr.oea01
    #
    #      #  #主旨
    #      #   SELECT zo02 INTO l_zo02  FROM zo_file  WHERE zo01 = g_lang
    #      #   LET l_subject = cl_getmsg("apm-795",g_lang) CLIPPED,l_zo02 CLIPPED,
    #      #                   cl_getmsg("axm-796",g_lang) CLIPPED,sr.oea01
    #      #   LET g_xml.subject = l_subject 
    #
    #      #  #內文 
    #      #   LET ls_context = cl_getmsg("apm-799",g_lang) CLIPPED
    #      #   LET ls_temp_path = FGL_GETENV("TEMPDIR")
    #      #   LET ls_context_file = ls_temp_path,"/report_context_" || FGL_GETPID() || ".txt"
    #      #   LET l_cmd = "echo '" || ls_context || "' > " || ls_context_file
    #      #   RUN l_cmd WITHOUT WAITING
    #      #   LET g_xml.body = ls_context_file
    #
    #      #  #收件者
    #      #    LET l_recipient = ''
    #      #    DECLARE r400_oce_c CURSOR FOR
    #      #            SELECT oce03,oce05 FROM oce_file
    #      #              WHERE oce01 = sr.oea03
    #      #                AND oce05 IS NOT NULL
    #      #              ORDER BY oce03
    #      #    FOREACH r400_oce_c INTO l_oce03,l_oce05
    #      #      LET l_recipient = l_recipient CLIPPED,l_oce05 CLIPPED,":",l_oce03 CLIPPED ,";"
    #      #    END FOREACH
    #      #    IF NOT cl_null(l_recipient) THEN
    #      #      LET g_xml.recipient = l_recipient
    #      #      
    #      #      LET l_wc = tm.wc
    #      #      LET l_wc = cl_replace_str(l_wc,"'","\"")
    #      #      LET l_cmd = " axmr400  '",g_today,"' ''",       #1 2
    #      #                           #" '",g_lang,"'", #No.FUN-7C0078
           #              " '",g_rlang CLIPPED,"'", #No.FUN-7C0078          #3  #TQC-840040 mark
    #      #                           " 'Y' 'J' '1'",           #4 5 6
    #      #                           " '",l_wc CLIPPED,"'",    #7
    #      #                           " 'Y' 'Y' ",               #8 9 
    #      #                           " 'default' 'default'",   #10 11
    #      #                           " 'template1'",           #12
    #      #                           " 'Y' 'Y'",               #13 14
    #      #                           " '",g_xml.subject,"'",   #15
    #      #                           " '",g_xml.body,"'",      #16
    #      #                           " '",g_xml.recipient,"'"  #17
    #      #      CALL cl_cmdrun(l_cmd)
    #      #    END IF
    #    END IF
    # END IF
    ##TQC-730022
    #end TQC-740271 mark
   END FOREACH
 
  #str CHI-7A0010 add
   #列印整張備註
   LET l_sql = "SELECT oea01 FROM oea_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY oea01"
   PREPARE r400_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE r400_cs2 CURSOR FOR r400_prepare2
 
   FOREACH r400_cs2 INTO sr.oea01
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
  #end CHI-7A0010 add
 
  #FINISH REPORT axmr400_rep   #TQC-740271 mark
     
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  #TQC-730022
      #FUN-650020...............begin
      IF g_show_msg.getlength()>0 THEN
         #TQC-840040-begin-modify
         #CALL cl_get_feldname(#"oea01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|", #No.FUN-7C0078
         #                "oea01",g_rlang CLIPPED,"|", #No.FUN-7C0078lc_gaq03 CLIPPED
         #CALL cl_get_feldname(#"oea03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|", #No.FUN-7C0078
         #                "oea03",g_rlang CLIPPED,"|", #No.FUN-7C0078lc_gaq03 CLIPPED
         #CALL cl_get_feldname(#"occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|", #No.FUN-7C0078
         #                "occ02",g_rlang CLIPPED,"|", #No.FUN-7C0078lc_gaq03 CLIPPED
         #CALL cl_get_feldname(#"occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|", #No.FUN-7C0078
         #                "occ18",g_rlang CLIPPED,"|", #No.FUN-7C0078lc_gaq03 CLIPPED
         #CALL cl_get_feldname(#"ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|", #No.FUN-7C0078
         #                "ze01",g_rlang CLIPPED,"|", #No.FUN-7C0078lc_gaq03 CLIPPED
         #CALL cl_get_feldname(#"ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|", #No.FUN-7C0078
         #                "ze03",g_rlang CLIPPED,"|", #No.FUN-7C0078lc_gaq03 CLIPPED
         CALL cl_get_feldname("oea01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("oea03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         #TQC-840040-end-modify
         CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
         CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
      END IF
      #FUN-650020...............end
   END IF   #TQC-730022
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
  #str CHI-7A0010 mod
  #修改成新的子報表的寫法(可組一句主要SQL,五句子報表SQL)
  #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " WHERE oao03 =0 AND oao05='1'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " WHERE oao03!=0 AND oao05='1'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " WHERE oao03!=0 AND oao05='2'","|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " WHERE oao03 =0 AND oao05='2'","|",   
               "SELECT * FROM ", g_cr_db_str CLIPPED,l_table2 CLIPPED
  #end CHI-7A0010 mod
 
   LET g_str = tm.n,";",tm.b,";",tm.d,";",g_sma116
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
     #TQC-750114 begin
       CALL cl_wcchp(tm.wc,'oea01,oea02,oea14')  #FUN-7B0142 mark還原
            RETURNING tm.wc                      #FUN-7B0142 mark還原
     #FUN-7B0142---mark---str---
     #LET l_lang_t = g_lang  
     #LET g_lang = '0'  
     #CALL cl_wcchp(tm.wc,'oea01,oea02,oea14')
     #     RETURNING l_wc0
     #LET g_lang = '1'  
     #CALL cl_wcchp(tm.wc,'oea01,oea02,oea14')
     #     RETURNING l_wc1
     #LET g_lang = '2'  
     #CALL cl_wcchp(tm.wc,'oea01,oea02,oea14')
     #     RETURNING l_wc2
     #LEt g_lang = l_lang_t  
     #FUN-7B0142---mark---end---
     #TQC-750114 end
   ELSE
      LET tm.wc = ''
   END IF
    LET g_str = g_str ,";",tm.wc,";",tm.c                #FUN-7B0142 mark 還原  #TQC-750114
   #LET g_str = g_str ,";",l_wc0 CLIPPED,";",l_wc1 CLIPPED,";",l_wc2 CLIPPED  #FUN-7B0142 mark#TQC-750114
###No.FUN-940044 START###
   LET g_cr_table = l_table                 #主報表的temp table名稱
   #LET g_cr_gcx01 = "axmi010"              #單別維護程式#TQC-C10039 mark---
   LET g_cr_apr_key_f = "oea01"             #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--start--mark---   
   #LET l_ii = 1
   ##報表主鍵值
   #CALL g_cr_apr_key.clear()                #清空
   #FOREACH r400_cs1 INTO l_key.*
   #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
   #   LET l_ii = l_ii + 1
   #END FOREACH
#TQC-C10039--end--mark---
###No.FUN-940044 END###
   CALL cl_prt_cs3('axmr400','axmr400',g_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   #end TQC-740271 add
 
  #str TQC-740271 mark
  ##TQC-730022 add--start
  # #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  # IF g_bgjob='Y' AND g_prtway = 'J' THEN
  #   CALL r400_jmail(l_name)
  # ELSE
  #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  # END IF
  ##TQC-730022 --END
  #
  ##TQC-730022 begin
  # IF g_bgjob = 'N' AND tm.e = 'Y' THEN
  #    FOR l_j = 1 TO l_i
  #      #主旨
  #       SELECT zo02 INTO l_zo02  FROM zo_file  WHERE zo01 = g_lang
  #       LET l_subject = cl_getmsg("apm-795",g_lang) CLIPPED,l_zo02 CLIPPED,
  #                       cl_getmsg("axm-796",g_lang) CLIPPED,l_oea01[l_j] CLIPPED
  #       LET g_xml.subject = l_subject 
  #
  #      #內文 
  #       LET ls_context = cl_getmsg("apm-799",g_lang) CLIPPED
  #       LET ls_temp_path = FGL_GETENV("TEMPDIR")
  #       LET ls_context_file = ls_temp_path,"/report_context_" || FGL_GETPID() || ".txt"
  #       LET l_cmd = "echo '" || ls_context || "' > " || ls_context_file
  #       RUN l_cmd WITHOUT WAITING
  #       LET g_xml.body = ls_context_file
  #
  #      #收件者
  #        LET l_recipient = ''
  #        DECLARE r400_oce_c CURSOR FOR
  #                SELECT oce03,oce05 FROM oce_file
  #                  WHERE oce01 = l_oea03[l_j]
  #                    AND oce05 IS NOT NULL
  #                  ORDER BY oce03
  #        FOREACH r400_oce_c INTO l_oce03,l_oce05
  #          LET l_recipient = l_recipient CLIPPED,l_oce05 CLIPPED,":",l_oce03 CLIPPED ,";"
  #        END FOREACH
  #        IF NOT cl_null(l_recipient) THEN
  #          LET g_xml.recipient = l_recipient
  #          
  #          LET l_wc = " oea01 = '",l_oea01[l_j] CLIPPED,"'"
  #          LET l_wc = cl_replace_str(l_wc,"'","\"")
  #          LET l_cmd = " axmr400  '",g_today,"' ''",       #1 2
  #                               #" '",g_lang,"'", #No.FUN-7C0078
  #                      " '",g_rlang CLIPPED,"'", #No.FUN-7C0078          #3  #TQC-840040 mark
  #                               " 'Y' 'J' '1'",           #4 5 6
  #                               " '",l_wc CLIPPED,"'",    #7
  #                               " 'Y' 'Y' ",               #8 9 
  #                               " 'default' 'default'",   #10 11
  #                               " 'template1'",           #12
  #                               " 'Y' 'Y'",               #13 14
  #                               " '",g_xml.subject,"'",   #15
  #                               " '",g_xml.body,"'",      #16
  #                               " '",g_xml.recipient,"'"  #17
  #          CALL cl_cmdrun(l_cmd)
  #        END IF
  #    END FOR
  # END IF
  ##TQC-730022
  #end TQC-740271 mark
END FUNCTION
 
#str TQC-740271 mark
#REPORT axmr400_rep(sr)
#   DEFINE l_oea01    LIKE oea_file.oea01
#   DEFINE l_ofb01    LIKE ofb_file.ofb01
#   DEFINE l_oea04    LIKE oea_file.oea04
#   DEFINE l_oea44    LIKE oea_file.oea44
#   DEFINE l_last_sw  LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#          sr         RECORD
#                     oea00     LIKE oea_file.oea00,
#                     oea01     LIKE oea_file.oea01,
#                     oea02     LIKE oea_file.oea02,
#                     oea10     LIKE oea_file.oea10,   #No.MOD-570395
#                     oea11     LIKE oea_file.oea11,
#                     oea12     LIKE oea_file.oea12,
#                     oea03     LIKE oea_file.oea03,
#                     oea032    LIKE oea_file.oea032,
#                     oea04     LIKE oea_file.oea04,
#                     oea044    LIKE oea_file.oea044,
#                     oea44     LIKE oea_file.oea44,   #No.MOD-570395
#                     occ02     LIKE occ_file.occ02,
#                     oea06     LIKE oea_file.oea06,
#                     oea14     LIKE oea_file.oea14,
#                     oea15     LIKE oea_file.oea15,
#                     oea23     LIKE oea_file.oea23,
#                     oea21     LIKE oea_file.oea21,
#                     oea25     LIKE oea_file.oea25,
#                     oea31     LIKE oea_file.oea31,
#                     oea32     LIKE oea_file.oea32,
#                     oea33     LIKE oea_file.oea33,
#                     oeb03     LIKE oeb_file.oeb03,
#                     oeb04     LIKE oeb_file.oeb04,
#                     ima021    LIKE ima_file.ima021,
#                     oeb05     LIKE oeb_file.oeb05,
#                     oeb12     LIKE oeb_file.oeb12,
#                     oeb13     LIKE oeb_file.oeb13,
#                     oeb14     LIKE oeb_file.oeb14,
#                     oeb14t    LIKE oeb_file.oeb14t,
#                     oeb15     LIKE oeb_file.oeb15,
#                     oeb06     LIKE oeb_file.oeb06,
#                     oeb11     LIKE oeb_file.oeb11,
#                     oeb17     LIKE oeb_file.oeb17,
#                     oeb18     LIKE oeb_file.oeb18,
#                     oeb19     LIKE oeb_file.oeb19,
#                     oeb20     LIKE oeb_file.oeb20,
#                     oeb21     LIKE oeb_file.oeb21,
#                     ofa04     LIKE ofa_file.ofa04,  #No:7646
#                     ofa10     LIKE ofa_file.ofa10,  #No:7646
#                     ofa44     LIKE ofa_file.ofa44,  #No:7646
#                     ofa45     LIKE ofa_file.ofa45,  #No:7646
#                     ofa46     LIKE ofa_file.ofa46,  #No:7646
#                     occ55     LIKE occ_file.occ55,  #FUN-570069 add
#                     oeb910    LIKE oeb_file.oeb910, #MOD-6B0114
#                     oeb912    LIKE oeb_file.oeb912, #MOD-6B0114
#                     oeb913    LIKE oeb_file.oeb913, #MOD-6B0114
#                     oeb915    LIKE oeb_file.oeb915, #MOD-6B0114
#                     oeb916    LIKE oeb_file.oeb916, #MOD-6B0114
#                     oeb917    LIKE oeb_file.oeb917  #MOD-6B0114
#                     END RECORD,
#          sr2        RECORD
#                     ocf        RECORD LIKE ocf_file.*    #NO:6882
#                     END RECORD,
#          l_flag     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
#          l_addr1    LIKE oeb_file.oeb06,    #No.FUN-680137 VARCHAR(36)
#          l_addr2    LIKE oeb_file.oeb06,    #No.FUN-680137 VARCHAR(36)
#          l_addr3    LIKE oeb_file.oeb06,    #No.FUN-680137 VARCHAR(36)
#          l_addr4    LIKE oeb_file.oeb06,    #No.FUN-680137 VARCHAR(36)
#          l_addr5    LIKE oeb_file.oeb06,    #No.FUN-680137 VARCHAR(36)
#          l_oeb14    LIKE oeb_file.oeb14,
#          l_oeb14t   LIKE oeb_file.oeb14t,
#          l_oab02    LIKE oab_file.oab02,
#          l_oac02    LIKE oac_file.oac02,
#          l_gec02    LIKE gec_file.gec02,
#          l_ged02    LIKE ged_file.ged02,
#          l_gen02    LIKE gen_file.gen02,
#          l_occ02    LIKE occ_file.occ02,
#          l_oao06    LIKE oao_file.oao06,
#          l_oah02    LIKE oah_file.oah02,
#          l_oag02    LIKE oag_file.oag02,
#          l_gem02    LIKE gem_file.gem02,
#          l_tot      LIKE type_file.num5        #No.FUN-680137 SMALLINT
#   DEFINE l_gfe03    LIKE gfe_file.gfe03
#   DEFINE l_zaa08       LIKE zaa_file.zaa08,    #FUN-570069 add
#          l_zaa09       LIKE zaa_file.zaa09,    #FUN-570069 add
#          l_zaa14       LIKE zaa_file.zaa14,    #FUN-570069 add
#          l_zaa16       LIKE zaa_file.zaa16,    #FUN-570069 add
#          l_memo        LIKE zab_file.zab05,    #FUN-570069 add
#          l_zaa08_trim  STRING,                 #FUN-570069 add
#          l_zab05       LIKE zab_file.zab05     #FUN-570069 add
#   DEFINE l_str2        STRING                  #MOD-6B0114 add
#   DEFINE l_oeb915      STRING                  #MOD-6B0114 add
#   DEFINE l_oeb912      STRING                  #MOD-6B0114 add
#   DEFINE l_oeb12       STRING                  #MOD-6B0114 add
#   DEFINE l_ima906      LIKE ima_file.ima906    #MOD-6B0114 add
# 
# 
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
# 
#   ORDER BY sr.oea01,sr.oeb03
# 
#  #No.FUN-590110-begin
#   FORMAT
#      PAGE HEADER
#        #start FUN-570069 add
#         IF g_pageno=0 AND (g_rlang <> sr.occ55) THEN
#            IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN
#                LET g_rlang = sr.occ55
#            END IF
#            SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#           
#            #TQC-720017-begin-add
#            #OPEN r400_zaa_cur USING g_rlang
#            #FOREACH r400_zaa_cur INTO g_i,l_zaa08,l_zaa09,l_zaa14,l_zaa16
#             FOREACH r400_zaa_cur USING g_rlang INTO g_i,l_zaa08,l_zaa09,l_zaa14,l_zaa16
#            #TQC-720017-end-add
#              IF l_zaa09 = '1' THEN
#                 IF l_zaa14 = "H" OR l_zaa14 = "I" THEN              ##報表備註
#                    IF l_zaa16 = "Y" THEN
#                       IF l_zaa14 = "H" THEN
#                          LET g_memo_pagetrailer = 1
#                       ELSE
#                          LET g_memo_pagetrailer = 0
#                       END IF
#                       EXECUTE zab_prepare USING l_zaa08,g_rlang,'1' INTO l_zab05
#                       EXECUTE zab_prepare USING l_zaa08,g_rlang,'2' INTO l_memo  
#                       IF l_zab05 IS NOT NULL OR l_memo IS NOT NULL THEN
#                           LET l_zaa08 = l_zab05
#                           LET g_memo = l_memo CLIPPED
#                       END IF
#                    ELSE
#                       LET g_memo_pagetrailer = 0
#                       LET l_zaa08 = ""
#                       LET g_memo =  ""
#                    END IF
#                 END IF
#                 LET l_zaa08_trim = l_zaa08
#                 LET g_x[g_i] = l_zaa08_trim.trimRight()
#              ELSE
#                 LET g_zaa[g_i].zaa08 = l_zaa08
#              END IF
#           END FOREACH
#         ELSE
#            SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#         END IF
#        #end FUN-570069 add
# 
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
# 
#         LET g_pageno = g_pageno + 1
#         #LET pageno_total = PAGENO USING '<<<',"/pageno"  #TQC-720017 mark
#         #PRINT g_head CLIPPED,pageno_total  #FUN-5A0143 mark
# 
#         CASE WHEN sr.oea00='0' LET g_msg=g_x[29]
#              WHEN sr.oea00='1' LET g_msg=g_x[1]
#              WHEN sr.oea00='2' LET g_msg=g_x[30]
#         END CASE
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_msg CLIPPED))/2+1),g_msg CLIPPED  #No.TQC-6A0091
#        #TQC-720017-begin
#        #PRINT g_head CLIPPED,pageno_total  #FUN-5A0143 add #TQC-720017 mark
#         PRINT
#         PRINT g_x[2] CLIPPED,g_today,'  ',TIME,' ',                               
#            COLUMN (g_len-FGL_WIDTH(g_user)-13),'FROM:',g_user,
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#        #TQC-720017-end
#         PRINT g_dash[1,g_len]
#            LET g_msg=NULL
#            IF g_oaz.oaz121 = "1" THEN
#               CALL s_ccc_logerr() #FUN-650020
#               LET g_oea01=sr.oea01 #FUN-650020
#               CALL s_ccc(sr.oea03,'0','')	#Customer Credit Check 客戶信用查核
#               #FUN-650020...............begin
#               IF r400_err_ana(g_showmsg) THEN
#                  
#               END IF
#               #Fun-650020...............end
#               IF g_errno = 'N' THEN
#                  CALL cl_getmsg('axm-107',g_rlang) RETURNING g_msg
#               END IF
#            END IF
#         #FUN-5A0143 mark IF的判斷,讓每一頁都會印訂單資料
#         #IF g_pageno = 1 THEN
#            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oea14
#            SELECT oab02 INTO l_oab02 FROM oab_file WHERE oab01=sr.oea25
#            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oea15
#            SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=sr.oea31
#            IF SQLCA.SQLCODE THEN
#               LET l_gen02='' LET l_gem02='' LET l_oab02='' LET l_oah02=''
#            END IF
#            CASE WHEN sr.oea00='0' LET g_msg=g_x[13]
#                 OTHERWISE         LET g_msg=g_x[11]
#            END CASE
#            #No.FUN-550070-begin
#            PRINT COLUMN 01,g_msg   CLIPPED,sr.oea01 CLIPPED,' (',sr.oea06,')',
#                  COLUMN 34,g_x[16] CLIPPED,sr.oea14,' ',l_gen02 CLIPPED,
#                  COLUMN 56,g_x[20] CLIPPED,sr.oea25,'   ',l_oab02
#            CASE WHEN sr.oea00='0' LET g_msg=g_x[31]
#                 OTHERWISE         LET g_msg=g_x[12]
#            END CASE
#            PRINT COLUMN 01,g_msg   CLIPPED,sr.oea02,
#                  COLUMN 34,g_x[17] CLIPPED,sr.oea15 CLIPPED,'   ',l_gem02 CLIPPED
#                  #COLUMN 56,g_x[21] CLIPPED,l_oah02  #FUN-5A0143 mark
#         #ELSE
#         #    SKIP 2 LINES
#         #END IF
#         LET l_last_sw = 'n'
# 
#         #-----No.MOD-610017-----
#     #BEFORE GROUP OF sr.oea01
#     #   SKIP TO TOP OF PAGE
#     #      LET l_flag = 'N'
#     #      LET l_oeb14=0  LET l_oeb14t=0
#            CALL s_addr(sr.oea01,sr.oea04,sr.oea044) 
#                 RETURNING l_addr1,l_addr2,l_addr3,l_addr4,l_addr5
#            IF SQLCA.SQLCODE THEN
#               LET l_addr1='' LET l_addr2='' LET l_addr3='' 
#               LET l_addr4='' LET l_addr5=''
#            END IF
# 
#            SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01=sr.oea32
#            SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01=sr.oea21
#                                                      AND gec011='2'  #銷項
#            IF SQLCA.SQLCODE THEN
#               LET l_gec02='' LET l_oag02=''
#            END IF
#            SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.oea03
#            CASE
#               WHEN sr.oea00='1' AND sr.oea11 = '2'
#                  LET g_msg=g_x[32]
#               WHEN sr.oea00='1' AND sr.oea11 = '3'
#                  LET g_msg=g_x[13]
#               OTHERWISE
#                  LET g_msg=''
#                  LET sr.oea12=''   #No.TQC-5B0156
#            END CASE
#            SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
#             FROM azi_file
#             WHERE azi01=sr.oea23
#            #FUN-5A0143 mark
#           #PRINT COLUMN 01,g_msg   CLIPPED,sr.oea12, #FUN-5A0143 mark
#           #      COLUMN 56,g_x[22] CLIPPED,l_oag02
#           #PRINT COLUMN 01,g_x[14] CLIPPED,sr.oea03 CLIPPED,' ',l_occ02 CLIPPED,
#           #      COLUMN 34,g_x[18] CLIPPED,sr.oea23 CLIPPED,
#           #      COLUMN 56,g_x[23] CLIPPED,sr.oea33
#           #PRINT COLUMN 01,g_x[15] CLIPPED,sr.oea04[1,10] CLIPPED,' ',sr.occ02 CLIPPED,
#           #      COLUMN 34,g_x[19] CLIPPED,sr.oea21 CLIPPED,' ',l_gec02
#           #PRINT COLUMN 01,g_x[24] CLIPPED,l_addr1
#            #FUN-5A0143 end mark
#            #FUN-5A0143 add
#           #PRINT COLUMN 01,g_x[14] CLIPPED,sr.oea03 CLIPPED,' ',l_occ02 CLIPPED,       #MOD-730125 mark
#            PRINT COLUMN 01,g_x[14] CLIPPED,sr.oea03 CLIPPED,' ',sr.oea032 CLIPPED,      #MOD-730125  
#                  COLUMN 34,g_x[18] CLIPPED,sr.oea23 CLIPPED,
#                  COLUMN 56,g_x[23] CLIPPED,sr.oea33
#            PRINT COLUMN 01,g_x[21] CLIPPED,l_oah02
#            PRINT COLUMN 01,g_x[22] CLIPPED,l_oag02
#           #PRINT COLUMN 01,g_x[15] CLIPPED,sr.oea04[1,10] CLIPPED,' ',sr.occ02 CLIPPED,    #MOD-730125 mark
#            PRINT COLUMN 01,g_x[15] CLIPPED,sr.oea04[1,10] CLIPPED,' ',sr.oea032 CLIPPED,   #MOD-730125
#                  COLUMN 34,g_x[19] CLIPPED,sr.oea21 CLIPPED,' ',l_gec02
#            PRINT COLUMN 01,g_x[24] CLIPPED,l_addr1
#            #FUN-5A0143 end add
#            #No.FUN-550070-end
#            IF NOT cl_null(l_addr2) THEN
#               PRINT COLUMN 10,l_addr2
#            ELSE
#               SKIP 1 LINES
#            END IF
#            IF NOT cl_null(l_addr3) THEN
#               PRINT COLUMN 10,l_addr3
#            ELSE
#               SKIP 1 LINES
#            END IF
#         #FUN-720014 begin
#            IF NOT cl_null(l_addr4) THEN
#               PRINT COLUMN 10,l_addr4
#            ELSE
#               SKIP 1 LINES
#            END IF
#            IF NOT cl_null(l_addr5) THEN
#               PRINT COLUMN 10,l_addr5
#            ELSE
#               SKIP 1 LINES
#            END IF
#         #FUN-720014 end
#            DECLARE oao_cur CURSOR FOR
#             SELECT oao06 FROM oao_file
#              WHERE oao01=sr.oea01
#                AND oao03=0 AND oao05='1'
#            FOREACH oao_cur INTO l_oao06
#               IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#               IF NOT cl_null(l_oao06) THEN
#                  PRINT COLUMN 01,l_oao06
#               ELSE
#                  SKIP 1 LINES
#               END IF
#            END FOREACH
#            PRINT g_dash2[1,g_len]
#            #FUN-5A0143 mark
#            #PRINTX name=H1 g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
#            #      g_x[49],g_x[50],g_x[51]
#            #FUN-5A0143 end mark
#          ##MOD-6B0114---------mod---------str---
#          # #FUN-5A0143 add
#          # PRINTX name=H1 g_x[44],g_x[45]
#          # PRINTX name=H2 g_x[53],g_x[52]
#          # PRINTX name=H3 g_x[56],g_x[55]
#          # PRINTX name=H4 g_x[58],g_x[57]
#          ##FUN-690032 name=H4->name=H5
#          ##PRINTX name=H4 g_x[54],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
#          # PRINTX name=H5 g_x[54],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51]
#          # #FUN-5A0143 end
#            CALL cl_prt_pos_dyn()                        #TQC-720017 add
#            PRINTX name=H1 g_x[44],g_x[45],g_x[61]
#            PRINTX name=H2 g_x[53],g_x[52]
#            PRINTX name=H3 g_x[56],g_x[55]
#            PRINTX name=H4 g_x[54],g_x[46],g_x[57],g_x[59],g_x[51]
#            PRINTX name=H5 g_x[60],g_x[47],g_x[58],g_x[48],g_x[49],g_x[50]
#          ##MOD-6B0114---------mod---------end---
#            PRINT g_dash1
# 
#      BEFORE GROUP OF sr.oea01
#         SKIP TO TOP OF PAGE
#         LET l_flag = 'N'
#         LET l_oeb14=0  LET l_oeb14t=0
#         LET g_pageno = 0    #TQC-720017 add
#         #-----No.MOD-610017 END-----
# 
#      ON EVERY ROW
#         DECLARE oao_cur1 CURSOR FOR SELECT oao06 FROM oao_file
#                                      WHERE oao01=sr.oea01
#                                        AND oao03=sr.oeb03 AND oao05='1'
#         FOREACH oao_cur1 INTO l_oao06
#            IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#            IF NOT cl_null(l_oao06) THEN
#               PRINT COLUMN 05,l_oao06
#            END IF
#         END FOREACH
#         #MOD-6B0114--------add-----------str---
#         SELECT ima906 INTO l_ima906 
#           FROM ima_file
#          WHERE ima01=sr.oeb04
#         LET l_str2 = ""
#         IF g_sma115 = "Y" THEN
#            CASE l_ima906
#               WHEN "2"
#                   CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                   LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
#                   IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
#                       CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                       LET l_str2 = l_oeb912, sr.oeb910 CLIPPED
#                   ELSE
#                      IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
#                         CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                         LET l_str2 = l_str2 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
#                      END IF
#                   END IF
#               WHEN "3"
#                   IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
#                       CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                       LET l_str2 = l_oeb915 , sr.oeb913 CLIPPED
#                   END IF
#            END CASE
#         END IF
#         IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
#               IF sr.oeb05  <> sr.oeb916 THEN
#                  CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
#                  LET l_str2 = l_str2 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
#               END IF
#         END IF
#         #MOD-6B0114--------add-----------end---
#         #FUN-5A0143 mark
#        #PRINTX name=D1 COLUMN g_c[44],sr.oeb03 USING '#####',
#        #      COLUMN g_c[45],sr.oeb04 CLIPPED,
#        #      COLUMN g_c[46],sr.oeb05 CLIPPED,
#        #      COLUMN g_c[47],cl_numfor(sr.oeb12,47,t_azi04);
#        #IF tm.n = 'Y' THEN
#        #    PRINT COLUMN g_c[48],cl_numfor(sr.oeb13,48,t_azi03),     #No.MOD-480345
#        #          COLUMN g_c[49],cl_numfor(sr.oeb14,49,t_azi04),     #No.MOD-480345
#        #          COLUMN g_c[50],cl_numfor(sr.oeb14t,50,t_azi04);    #No.MOD-480345
#        #END IF
#         #FUN-5A0143 end mark
#         #FUN-5A0143 add
#         SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.oeb05  #No.TQC-5A0128
#         PRINTX name=D1 COLUMN g_c[44],sr.oeb03 USING '###&', #FUN-590118
#                        COLUMN g_c[45],sr.oeb04 CLIPPED,
#                        COLUMN g_c[61],sr.oeb11 CLIPPED #MOD-6B0114 add
#         PRINTX name=D2 COLUMN g_c[53],'',
#                        #COLUMN 7,sr.oeb06 CLIPPED       #FUN-690032
#                        COLUMN g_c[52],sr.oeb06 CLIPPED  #FUN-690032
#         PRINTX name=D3 COLUMN g_c[56],'',
#                        #COLUMN 7,sr.ima021 CLIPPED      #FUN-690032
#                        COLUMN g_c[55],sr.ima021 CLIPPED #FUN-690032
#        #FUN-690032--begin
#        # PRINTX name=D4 COLUMN g_c[58],'',
#         #PRINTX name=D4 COLUMN g_c[57],sr.oeb11 CLIPPED #MOD-6B0114 mark
#       #MOD-6B0114-----------mark-------------str------
#       ##name=D4->name=D5
#       ##PRINTX name=D4 COLUMN g_c[54],'',
#       # PRINTX name=D5 COLUMN g_c[54],'',
#       #                COLUMN g_c[46],sr.oeb05 CLIPPED,
#       #                COLUMN g_c[47],cl_numfor(sr.oeb12,47,l_gfe03);  #No.TQC-5A0128
#       ##FUN-690032--end 
#       # IF tm.n = 'Y' THEN
#       #          PRINT COLUMN g_c[48],cl_numfor(sr.oeb13,48,t_azi03),
#       #                COLUMN g_c[49],cl_numfor(sr.oeb14,49,t_azi04),
#       #                COLUMN g_c[50],cl_numfor(sr.oeb14t,50,t_azi04);
#       # END IF
#       # #FUN-5A0143 end add
#       # PRINT COLUMN g_c[51],sr.oeb15
#       #MOD-6B0114-----------mark------------end------
#       #MOD-6B0114-----------mod-------------str------
#         PRINTX name=D4 COLUMN g_c[54],'',
#                        COLUMN g_c[46],sr.oeb05 CLIPPED,
#                        COLUMN g_c[57],sr.oeb916,#計價單位
#                        COLUMN g_c[59],l_str2 CLIPPED,
#                        COLUMN g_c[51],sr.oeb15
#         PRINTX name=D5 COLUMN g_c[60],'',
#                        COLUMN g_c[47],cl_numfor(sr.oeb12,47,l_gfe03),
#                        COLUMN g_c[58],cl_numfor(sr.oeb917,58,l_gfe03),#計價數量
#                        COLUMN g_c[48],cl_numfor(sr.oeb13,48,t_azi03),
#                        COLUMN g_c[49],cl_numfor(sr.oeb14,49,t_azi04),
#                        COLUMN g_c[50],cl_numfor(sr.oeb14t,50,t_azi04)
#       #MOD-6B0114-----------mod-------------end------
# 
#         #PRINT COLUMN g_c[45],sr.oeb06 CLIPPED  #FUN-5A0143 mark
#         #PRINT COLUMN g_c[45],sr.ima021 clipped #FUN-5A0143 mark
# 
#         SELECT oac02 INTO l_oac02 FROM oac_file WHERE oac01 = sr.oeb18
#         IF SQLCA.sqlcode THEN LET l_oac02 = null END IF
#         SELECT ged02 INTO l_ged02 FROM ged_file WHERE ged01 = sr.oeb20
#         IF SQLCA.sqlcode THEN LET l_ged02 = null END IF
#         SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01 = sr.oeb21
#         IF SQLCA.sqlcode THEN LET l_oah02 = null END IF
# 
#         PRINT COLUMN  g_x[40] clipped,l_oac02,      #出貨地點
#               COLUMN  g_x[41] clipped,l_ged02,      #交運方式
#               COLUMN  g_x[42] clipped,l_oah02       #價格條件
# 
#        #FUN-69032 remark--begin
#         #IF NOT cl_null(sr.oeb11) THEN
#         #   PRINT COLUMN 07,g_x[28] CLIPPED,sr.oeb11
#         #END IF
#        #FUN-690032 remark--end
#         DECLARE oao_cur2 CURSOR FOR SELECT oao06 FROM oao_file
#                                                 WHERE oao01=sr.oea01
#                                                   AND oao03=sr.oeb03 AND oao05='2'
#         FOREACH oao_cur2 INTO l_oao06
#            IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#            IF NOT cl_null(l_oao06) THEN
#               PRINT COLUMN 07,l_oao06
#            END IF
#         END FOREACH
#         PRINT ''
# 
#      AFTER GROUP OF sr.oea01
#         IF tm.n = 'Y' THEN
#            LET l_oeb14= GROUP SUM(sr.oeb14)
#            LET l_oeb14t= GROUP SUM(sr.oeb14t)
#           #PRINT COLUMN g_c[49],g_dash2[1,g_w[49]],
#           #      COLUMN g_c[50],g_dash2[1,g_w[50]]
#           #PRINT COLUMN g_c[48],g_x[27] CLIPPED,
#           #       COLUMN g_c[49],cl_numfor(l_oeb14,49,t_azi05),      #No.MOD-480345
#           #       COLUMN g_c[50],cl_numfor(l_oeb14t,50,t_azi05)      #No.MOD-480345
#           
#           #FUN-690032 name=D4->name=D5 
#            #PRINTX name=D4 COLUMN g_c[49],g_dash2[1,g_w[49]],
#            PRINTX name=D5 COLUMN g_c[49],g_dash2[1,g_w[49]],
#                           COLUMN g_c[50],g_dash2[1,g_w[50]]
#           #FUN-690032 name=D4->name=D5 
#            #PRINTX name=D4 COLUMN g_c[48],g_x[27] CLIPPED,
#            PRINTX name=D5 COLUMN g_c[48],g_x[27] CLIPPED,
#                           COLUMN g_c[49],cl_numfor(l_oeb14,49,t_azi05),      #No.MOD-480345
#                           COLUMN g_c[50],cl_numfor(l_oeb14t,50,t_azi05)      #No.MOD-480345
#         END IF
#       # PRINT g_dash[1,g_len]
#         SELECT COUNT(*) INTO g_cnt FROM oao_file
#          WHERE oao01=sr.oea01 AND oao03=0 AND oao05 = '2'
#         LET l_tot = LINENO+ g_cnt
#         DECLARE oao_cur3 CURSOR FOR SELECT oao06 FROM oao_file
#                                                WHERE oao01=sr.oea01
#                                                 AND oao03=0 AND oao05='2'
#         FOREACH oao_cur3 INTO l_oao06
#            IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#            IF NOT cl_null(l_oao06) THEN
#               PRINT COLUMN 01,l_oao06
#            END IF
#            IF l_tot = 58 AND LINENO = 57 THEN LET l_flag = 'Y' END IF #no.7077
#         END FOREACH
# 
#         #====================================================NO:6882印麥頭
#         IF tm.b ='Y' THEN
#            ##No:7674 mark
##            SELECT oea04,oea44 INTO l_oea04,l_oea44
##              FROM oea_file             #抓單頭資料
##             WHERE oea01=sr.oea01       #訂單單號
##            IF SQLCA.SQLCODE THEN
##                LET l_oea04=NULL
##                LET l_oea44=NULL
##            END IF
## 
#            INITIALIZE sr2.* TO NULL
#            SELECT * INTO sr2.* FROM ocf_file
##            WHERE ocf01=sr.ofa04 AND ocf02=sr.ofa44   #No:7674 modify
#              WHERE ocf01=sr.oea04 AND ocf02=sr.oea44   #No.MOD-570395
# 
#            #No:7674
#            IF NOT cl_null(sr2.ocf.ocf01) THEN
#                #-----No.MOD-570395-----
#               LET g_po_no=sr.oea10
#               LET g_ctn_no1=""
#               LET g_ctn_no2=""
#            #  LET g_po_no=sr.ofa10
#            #  LET g_ctn_no1=sr.ofa45
#            #  LET g_ctn_no2=sr.ofa46
#                #-----No.MOD-570395 END-----
# 
#               LET sr2.ocf.ocf101=r400_ocf_c(sr2.ocf.ocf101)
#               LET sr2.ocf.ocf102=r400_ocf_c(sr2.ocf.ocf102)
#               LET sr2.ocf.ocf103=r400_ocf_c(sr2.ocf.ocf103)
#               LET sr2.ocf.ocf104=r400_ocf_c(sr2.ocf.ocf104)
#               LET sr2.ocf.ocf105=r400_ocf_c(sr2.ocf.ocf105)
#               LET sr2.ocf.ocf106=r400_ocf_c(sr2.ocf.ocf106)
#               LET sr2.ocf.ocf107=r400_ocf_c(sr2.ocf.ocf107)
#               LET sr2.ocf.ocf108=r400_ocf_c(sr2.ocf.ocf108)
#               LET sr2.ocf.ocf109=r400_ocf_c(sr2.ocf.ocf109)
#               LET sr2.ocf.ocf110=r400_ocf_c(sr2.ocf.ocf110)
#               LET sr2.ocf.ocf111=r400_ocf_c(sr2.ocf.ocf111)
#               LET sr2.ocf.ocf112=r400_ocf_c(sr2.ocf.ocf112)
#               LET sr2.ocf.ocf201=r400_ocf_c(sr2.ocf.ocf201)
#               LET sr2.ocf.ocf202=r400_ocf_c(sr2.ocf.ocf202)
#               LET sr2.ocf.ocf203=r400_ocf_c(sr2.ocf.ocf203)
#               LET sr2.ocf.ocf204=r400_ocf_c(sr2.ocf.ocf204)
#               LET sr2.ocf.ocf205=r400_ocf_c(sr2.ocf.ocf205)
#               LET sr2.ocf.ocf206=r400_ocf_c(sr2.ocf.ocf206)
#               LET sr2.ocf.ocf207=r400_ocf_c(sr2.ocf.ocf207)
#               LET sr2.ocf.ocf208=r400_ocf_c(sr2.ocf.ocf208)
#               LET sr2.ocf.ocf209=r400_ocf_c(sr2.ocf.ocf209)
#               LET sr2.ocf.ocf210=r400_ocf_c(sr2.ocf.ocf210)
#               LET sr2.ocf.ocf211=r400_ocf_c(sr2.ocf.ocf211)
#               LET sr2.ocf.ocf212=r400_ocf_c(sr2.ocf.ocf212)
#               ##
#               PRINT g_x[38] CLIPPED,g_x[39] CLIPPED
#               PRINT
#              #PRINT COLUMN 10,g_x[34] CLIPPED,sr2.ocf.ocf01,' ',l_occ02,   #MOD-730125 mark
#               PRINT COLUMN 10,g_x[34] CLIPPED,sr2.ocf.ocf01,' ',sr.oea032, #MOD-730125 
#                     COLUMN 45,g_x[35] CLIPPED,sr2.ocf.ocf02
#               PRINT '       ------------------------------   ',
#                             '-----------------------------'
#               PRINT COLUMN 21,g_x[36] CLIPPED,
#                     COLUMN 52,g_x[37] CLIPPED
#               PRINT '       ------------------------------   '
#                            ,'-----------------------------'
#               PRINT COLUMN 8,sr2.ocf.ocf101,
#                     COLUMN 41,sr2.ocf.ocf201
#               PRINT COLUMN 8,sr2.ocf.ocf102,
#                     COLUMN 41,sr2.ocf.ocf202
#               PRINT COLUMN 8,sr2.ocf.ocf103,
#                     COLUMN 41,sr2.ocf.ocf203
#               PRINT COLUMN 8,sr2.ocf.ocf104,
#                     COLUMN 41,sr2.ocf.ocf204
#               PRINT COLUMN 8,sr2.ocf.ocf105,
#                     COLUMN 41,sr2.ocf.ocf205
#               PRINT COLUMN 8,sr2.ocf.ocf106,
#                     COLUMN 41,sr2.ocf.ocf206
#               PRINT COLUMN 8,sr2.ocf.ocf107,
#                     COLUMN 41,sr2.ocf.ocf207
#               PRINT COLUMN 8,sr2.ocf.ocf108,
#                     COLUMN 41,sr2.ocf.ocf208
#               PRINT COLUMN 8,sr2.ocf.ocf109,
#                     COLUMN 41,sr2.ocf.ocf209
#               PRINT COLUMN 8,sr2.ocf.ocf110,
#                     COLUMN 41,sr2.ocf.ocf210
#               PRINT COLUMN 8,sr2.ocf.ocf111,
#                     COLUMN 41,sr2.ocf.ocf211
#               PRINT COLUMN 8,sr2.ocf.ocf112,
#                     COLUMN 41,sr2.ocf.ocf212
#            END IF
#         END IF
#         #====================================================NO:6882
#         LET l_flag='Y'
# 
#      ## FUN-550127
#      PAGE TRAILER
#         IF l_flag ='Y' THEN
#            PRINT g_dash[1,g_len]
#          # PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
#         ELSE
#            PRINT g_dash[1,g_len]
#          # PRINT
#         END IF
#         IF l_flag = 'N' THEN
#            IF g_memo_pagetrailer THEN
#               PRINT            #No.TQC-6A0091
#               PRINT g_x[4]
#               PRINT g_memo
#            ELSE
#               PRINT            #No.TQC-6A0091
#               PRINT
#               PRINT
#            END IF
#         ELSE
#            PRINT            #No.TQC-6A0091
#            PRINT g_x[4]
#            PRINT g_memo
#         END IF
### END FUN-550127
#
##No.FUN-590110-end
# 
#END REPORT
 
#No:7674 add
FUNCTION r400_ocf_c(str)
  DEFINE str   LIKE cob_file.cob08        #No.FUN-680137 VARCHAR(30)
  DEFINE i,j    LIKE type_file.num5       #No.FUN-680137 SMALLINT
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
##
 
FUNCTION r400_err_ana(ls_showmsg)    #FUN-650020
   DEFINE ls_showmsg  STRING
   DEFINE lc_oea03    LIKE oea_file.oea03
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET lc_oea03 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
   LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                         ls_showmsg.getLength())
   IF ls_showmsg.getIndexOf("||",1) THEN
      LET lc_ze01 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
      LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                            ls_showmsg.getLength())
   ELSE
      LET lc_ze01 = ls_showmsg.trim()
      LET ls_showmsg = ""
   END IF
 
   SELECT occ02,occ18 INTO lc_occ02,lc_occ18 FROM occ_file
    WHERE occ01=lc_oea03
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].oea01   = g_oea01
   LET g_show_msg[li_newerrno].oea03   = lc_oea03
   LET g_show_msg[li_newerrno].occ02   = lc_occ02
   LET g_show_msg[li_newerrno].occ18   = lc_occ18
   LET g_show_msg[li_newerrno].ze01    = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03    = ls_showmsg.trim(),ls_tmpstr.trim()
   #kim test
   LET li_newerrno = g_show_msg.getLength()
   DISPLAY li_newerrno
   RETURN TRUE
 
END FUNCTION
 
#str TQC-740271 mark 
##TQC-730022 begin
#FUNCTION r400_jmail(l_name)
#  DEFINE l_name       LIKE type_file.chr20 	
#  DEFINE l_cmd	       LIKE type_file.chr1000  #No.FUN-660067 add 
#
#  CALL cl_trans_xml(g_xml_rep,"T")
#  LET l_cmd = "cp ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED," ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
#  RUN l_cmd
#  LET l_cmd = FGL_GETENV("DS4GL"),"/bin/addcr ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
#  RUN l_cmd
#  LET g_xml.attach = FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
#
#  CALL cl_jmail()
#  LET l_cmd = "rm ",g_xml.attach CLIPPED
#  RUN l_cmd
#END FUNCTION
##TQC-730022 end
#end TQC-740271 mark 
#Patch....NO.TQC-610037 <> #
