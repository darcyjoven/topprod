# Prog. Version..: '5.30.06-13.03.28(00006)'     #
#
# Pattern name...: axmg550.4gl
# Descriptions...: INVOICE
# Date & Author..: 96/08/13 by Roger
# Modify.........: No.7973 03/08/28 By Nicola 針對每筆已進位的明細做加總
# Modify.........: No.FUN-4A0019 04/10/04 By Echo invoice單號要開窗
# Modify.........: No.MOD-4A0338 04/11/02 By Smapmin 以za_file取代PRINT中文字的部份
# Modify.........: No.FUN-4C0096 05/03/03 By Echo 調整單價、金額、匯率欄位大小
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580004 05/08/09 By jackie 轉XML，雙單位報表修改
# Modify.........: No.MOD-560003 05/08/23 By pengu 若列印金額過大時,則無法產生報表,應加show提示訊息等.
# Modify.........: NO.MOD-590199 05/10/05 BY yiting 嘜頭報表列印程式，均無法正常印出
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: NO.FUN-610072 06/01/20 By sarah 加印公司TITLE
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-660032 06/10/18 By rainy 新增是否列印客戶料號
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: NO.MOD-690064 06/11/16 By Claire 可列印CCCCCC ~ DDDDDD
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.TQC-6C0012 06/12/06 By claire 金額計算取價錯誤
# Modify.........: No.FUN-710080 07/03/01 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.FUN-740057 07/04/13 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.TQC-750123 07/05/24 By Sarah 嘜頭資料的起始箱號,截止箱號的內容無印出
# Modify.........: No.MOD-810098 08/01/14 By cliare oea10不該定義為oea01應仍為oea10
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.FUN-7C0011 08/02/26 By Sarah 主特性代碼變數沒有清空,導致同一張INVOICE列印第二次時,主特性代碼資料會越來越多
# Modify.........: No.FUN-890098 08/09/23 By Smapmin 品名規格額外說明無法正常列印
# Modify.........: No.MOD-8A0195 08/10/24 By Smapmin 修改ora檔
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-960294 09/06/30 By Smapmin 增加列印ofa49
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:TQC-A50044 10/05/17 By Carrier MOD-9B0033追单
# Modify.........: No:CHI-A50034 10/06/03 By Summer 畫面已增加"列印品名規格額外說明類別",就不再固定抓取imc04
# Modify.........: No:MOD-A70040 10/07/07 By Smapmin 若是列印方式選擇3.就將tm.d設為='Y'.
# Modify.........: No.FUN-B40087 11/05/13 By yangtt  憑證報表轉GRW
# Modify.........: No:FUN-C10036 12/01/16 By lujh FUN-B80089追單
# Modify.........: No:FUN-C20051 12/03/01 By yangtt GR調整        
# Modify.........: No:FUN-C50003 12/05/14 By yangtt GR程式優化
# Modify.........: No:MOD-D30041 13/03/07 By jt_chen 修正t_imc04取值、SUB1取值
# Modify.........: No:CHI-D30011 13/03/21 By Elise 幣別欄位遇到USD改為US DOLLARS
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5        # No.FUN-680137 SMALLINT
END GLOBALS
 
DEFINE tm  RECORD                              # Print condition RECORD
            wc      LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(500)  # Where condition
            d       LIKE type_file.chr1,       # No.FUN-660032 列印客戶料號
            imc02   LIKE imc_file.imc02,       # 品名規格額外說明類別
            b       LIKE type_file.chr1,       # 列印公司對內全名         #FUN-740057 add
            c       LIKE type_file.chr1,       # 列印公司對外全名         #FUN-740057 add
            more    LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(01)   # Input more condition(Y/N)
           END RECORD,
       l_oao06      LIKE oao_file.oao06,
       x            LIKE aba_file.aba00,                # No.FUN-680137  VARCHAR(5)
       y,z          LIKE type_file.chr1,                # No.FUN-680137 VARCHAR(1)
       g_po_no,g_ctn_no1,g_ctn_no2  LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20)
       g_azi02      LIKE type_file.chr20,               # No.FUN-680137 VARCHAR(20)
       g_zo12       LIKE type_file.chr1000,             # No.FUN-680137 VARCHAR(60)
       g_no         LIKE type_file.num10,               # No.FUN-680137 INTEGER
       g_sr DYNAMIC ARRAY OF RECORD
             ima01  LIKE ima_file.ima01,
             ima02  LIKE ima_file.ima02
            END RECORD
 
DEFINE g_cnt        LIKE type_file.num10                #No.FUN-680137 INTEGER
DEFINE g_i          LIKE type_file.num5                 #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE i            LIKE type_file.num5                 #No.FUN-680137 SMALLINT
DEFINE j            LIKE type_file.num5                 #No.FUN-680137 SMALLINT
DEFINE g_sma115     LIKE sma_file.sma115
DEFINE g_sma116     LIKE sma_file.sma116
DEFINE l_table      STRING
DEFINE l_table1     STRING
DEFINE l_table2     STRING
DEFINE l_table3     STRING
DEFINE l_table4     STRING
DEFINE l_table5     STRING
DEFINE l_table6     STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_str1,l_str2,l_str3 LIKE type_file.chr1000
DEFINE g_zo041      LIKE zo_file.zo041
DEFINE g_zo05       LIKE zo_file.zo05   #FUN-810029 add
DEFINE g_zo09       LIKE zo_file.zo09   #FUN-810029 add
 
###GENGRE###START
TYPE sr1_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    ofa02 LIKE ofa_file.ofa02,
    ofa49 LIKE ofa_file.ofa49,
    ofa011 LIKE ofa_file.ofa011,
    ofa0351 LIKE ofa_file.ofa0351,
    ofa0352 LIKE ofa_file.ofa0352,
    ofa0353 LIKE ofa_file.ofa0353,
    ofa0354 LIKE ofa_file.ofa0354,
    ofa0355 LIKE ofa_file.ofa0355,
    ofa0451 LIKE ofa_file.ofa0451,
    ofa0452 LIKE ofa_file.ofa0452,
    ofa0453 LIKE ofa_file.ofa0453,
    ofa0454 LIKE ofa_file.ofa0454,
    ofa0455 LIKE ofa_file.ofa0455,
    ofa31 LIKE ofa_file.ofa31,
    oah02 LIKE oah_file.oah02,
    ofa32 LIKE ofa_file.ofa32,
    oag02 LIKE oag_file.oag02,
    ofa43 LIKE ofa_file.ofa43,
    ofa47 LIKE ofa_file.ofa47,
    ofa61 LIKE ofa_file.ofa61,
    ofa62 LIKE ofa_file.ofa62,
    ofa63 LIKE ofa_file.ofa63,
    oac02 LIKE oac_file.oac02,
    oac02_2 LIKE oac_file.oac02,
    ofb03 LIKE ofb_file.ofb03,
    ofb04 LIKE ofb_file.ofb04,
    ofb06 LIKE ofb_file.ofb06,
    ima138 LIKE ima_file.ima138,
    oea10 LIKE oea_file.oea10,
    ofb12 LIKE ofb_file.ofb12,
    ofb05 LIKE ofb_file.ofb05,
    ofb916 LIKE ofb_file.ofb916,
    ofb917 LIKE ofb_file.ofb917,
    ofb13 LIKE ofb_file.ofb13,
    ofb14 LIKE ofb_file.ofb14,
    imc04 LIKE imc_file.imc04,
    ofb11 LIKE ofb_file.ofb11,
    ofb33 LIKE ofb_file.ofb33,
    ofa23 LIKE ofa_file.ofa23,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    str1 LIKE type_file.chr1000,
    str2 LIKE type_file.chr1000,
    str3 LIKE type_file.chr1000,
    zo12 LIKE zo_file.zo12,
    zo041 LIKE zo_file.zo041,
    ocf101 LIKE ocf_file.ocf101,
    ocf102 LIKE ocf_file.ocf102,
    ocf103 LIKE ocf_file.ocf103,
    ocf104 LIKE ocf_file.ocf104,
    ocf105 LIKE ocf_file.ocf105,
    ocf106 LIKE ocf_file.ocf106,
    ocf107 LIKE ocf_file.ocf107,
    ocf108 LIKE ocf_file.ocf108,
    ocf109 LIKE ocf_file.ocf109,
    ocf110 LIKE ocf_file.ocf110,
    ocf111 LIKE ocf_file.ocf111,
    ocf112 LIKE ocf_file.ocf112,
    ocf201 LIKE ocf_file.ocf201,
    ocf202 LIKE ocf_file.ocf202,
    ocf203 LIKE ocf_file.ocf203,
    ocf204 LIKE ocf_file.ocf204,
    ocf205 LIKE ocf_file.ocf205,
    ocf206 LIKE ocf_file.ocf206,
    ocf207 LIKE ocf_file.ocf207,
    ocf208 LIKE ocf_file.ocf208,
    ocf209 LIKE ocf_file.ocf209,
    ocf210 LIKE ocf_file.ocf210,
    ocf211 LIKE ocf_file.ocf211,
    ocf212 LIKE ocf_file.ocf212,
    zo05 LIKE zo_file.zo05,
    zo09 LIKE zo_file.zo09
END RECORD

TYPE sr2_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    imc01 LIKE imc_file.imc01,
    imc04 LIKE imc_file.imc04
END RECORD

TYPE sr3_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    ogd01 LIKE ogd_file.ogd01,
    ogd03 LIKE ogd_file.ogd03,
    ogd08 LIKE ogd_file.ogd08,
    ima02 LIKE ima_file.ima02,
    ogd13 LIKE ogd_file.ogd13
END RECORD

TYPE sr4_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    sfa01 LIKE sfa_file.sfa01,
    sfa03 LIKE sfa_file.sfa03,
    ima02 LIKE ima_file.ima02,
    sfa12 LIKE sfa_file.sfa12,
    sfa06 LIKE sfa_file.sfa06
END RECORD

TYPE sr5_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    ofb04 LIKE ofb_file.ofb04,
    ima0102 LIKE type_file.chr1000
END RECORD

TYPE sr6_t RECORD
    oao01 LIKE oao_file.oao01,
    oao03 LIKE oao_file.oao03,
    oao04 LIKE oao_file.oao04,
    oao05 LIKE oao_file.oao05,
    oao06 LIKE oao_file.oao06
END RECORD

TYPE sr7_t RECORD
    ofa01 LIKE ofa_file.ofa01,
    oaf03 LIKE oaf_file.oaf03
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
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ofa01.ofa_file.ofa01,    ofa02.ofa_file.ofa02,",
               "ofa49.ofa_file.ofa49,",   #MOD-960294
               "ofa011.ofa_file.ofa011,  ofa0351.ofa_file.ofa0351,",
               "ofa0352.ofa_file.ofa0352,ofa0353.ofa_file.ofa0353,",
               "ofa0354.ofa_file.ofa0354,ofa0355.ofa_file.ofa0355,",
               "ofa0451.ofa_file.ofa0451,ofa0452.ofa_file.ofa0452,",
               "ofa0453.ofa_file.ofa0453,ofa0454.ofa_file.ofa0454,",
               "ofa0455.ofa_file.ofa0455,ofa31.ofa_file.ofa31,",
               "oah02.oah_file.oah02,    ofa32.ofa_file.ofa32,",
               "oag02.oag_file.oag02,    ofa43.ofa_file.ofa43,",
               "ofa47.ofa_file.ofa47,    ofa61.ofa_file.ofa61,",
               "ofa62.ofa_file.ofa62,    ofa63.ofa_file.ofa63,",
               "oac02.oac_file.oac02,    oac02_2.oac_file.oac02,",
               "ofb03.ofb_file.ofb03,    ofb04.ofb_file.ofb04,",
               "ofb06.ofb_file.ofb06,    ima138.ima_file.ima138,",
               "oea10.oea_file.oea10,",  #MOD-810098 modify
               "ofb12.ofb_file.ofb12,    ofb05.ofb_file.ofb05,",
               "ofb916.ofb_file.ofb916,  ofb917.ofb_file.ofb917,",
               "ofb13.ofb_file.ofb13,    ofb14.ofb_file.ofb14,",
               "imc04.imc_file.imc04,    ofb11.ofb_file.ofb11,",
               "ofb33.ofb_file.ofb33,    ofa23.ofa_file.ofa23,",
               "azi03.azi_file.azi03,    azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,    str1.type_file.chr1000,",
               "str2.type_file.chr1000,  str3.type_file.chr1000,",
               "zo12.zo_file.zo12,       zo041.zo_file.zo041,",
               "ocf101.ocf_file.ocf101,  ocf102.ocf_file.ocf102,",
               "ocf103.ocf_file.ocf103,  ocf104.ocf_file.ocf104,",
               "ocf105.ocf_file.ocf105,  ocf106.ocf_file.ocf106,",
               "ocf107.ocf_file.ocf107,  ocf108.ocf_file.ocf108,",
               "ocf109.ocf_file.ocf109,  ocf110.ocf_file.ocf110,",
               "ocf111.ocf_file.ocf111,  ocf112.ocf_file.ocf112,",
               "ocf201.ocf_file.ocf201,  ocf202.ocf_file.ocf202,",
               "ocf203.ocf_file.ocf203,  ocf204.ocf_file.ocf204,",
               "ocf205.ocf_file.ocf205,  ocf206.ocf_file.ocf206,",
               "ocf207.ocf_file.ocf207,  ocf208.ocf_file.ocf208,",
               "ocf209.ocf_file.ocf209,  ocf210.ocf_file.ocf210,",
               "ocf211.ocf_file.ocf211,  ocf212.ocf_file.ocf212,",
               "zo05.zo_file.zo05,       zo09.zo_file.zo09"    #FUN-810029 add
   LET l_table = cl_prt_temptable('axmg550',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087  #FUN-C10036   mark                                                       
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)   #FUN-B40087  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                  # Temp Table產生
 
   LET g_sql = "ofa01.ofa_file.ofa01,",
               "imc01.imc_file.imc01,",
               "imc04.imc_file.imc04"
   LET l_table1 = cl_prt_temptable('axmg5501',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087   #FUN-C10036   mark                                                      
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)   #FUN-B40087 #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                   # Temp Table產生
 
   LET g_sql = "ofa01.ofa_file.ofa01,",
               "ogd01.ogd_file.ogd01,",  
               "ogd03.ogd_file.ogd03,",  
               "ogd08.ogd_file.ogd08,",  
               "ima02.ima_file.ima02,",
               "ogd13.ogd_file.ogd13"
   LET l_table2 = cl_prt_temptable('axmg5502',g_sql) CLIPPED   # 產生Temp Table
   IF l_table2 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087  #FUN-C10036   mark                                                       
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)    #FUN-B40087 #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                   # Temp Table產生
 
   LET g_sql = "ofa01.ofa_file.ofa01,",
               "sfa01.sfa_file.sfa01,",  
               "sfa03.sfa_file.sfa03,",  
               "ima02.ima_file.ima02,",
               "sfa12.sfa_file.sfa12,",  
               "sfa06.sfa_file.sfa06"
   LET l_table3 = cl_prt_temptable('axmg5503',g_sql) CLIPPED   # 產生Temp Table
   IF l_table3 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087  #FUN-C10036   mark                                                        
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)   #FUN-B40087  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                   # Temp Table產生
 
   LET g_sql = "ofa01.ofa_file.ofa01,",
               "ofb04.ofb_file.ofb04,",
               "ima0102.type_file.chr1000"
   LET l_table4 = cl_prt_temptable('axmg5504',g_sql) CLIPPED   # 產生Temp Table
   IF l_table4 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087  #FUN-C10036   mark                                                       
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)   #FUN-B40087 #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                   # Temp Table產生
 
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao04.oao_file.oao04,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06"
   LET l_table5 = cl_prt_temptable('axmg5505',g_sql) CLIPPED   # 產生Temp Table
   IF l_table5 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087 #FUN-C10036   mark                                                        
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)   #FUN-B40087  #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                   # Temp Table產生
 
   LET g_sql = "ofa01.ofa_file.ofa01,",
               "oaf03.oaf_file.oaf03"
   LET l_table6 = cl_prt_temptable('axmg5506',g_sql) CLIPPED   # 產生Temp Table
   IF l_table6 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087  #FUN-C10036   mark                                                       
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)   #FUN-B40087 #FUN-C10036   mark
      EXIT PROGRAM  
   END IF                   # Temp Table產生
   ##------------------------------ CR (1) ------------------------------#
 
   LET g_zo12 = NULL
   LET g_zo041= NULL   #FUN-710080 add
   LET g_zo05 = NULL   #FUN-810029 add
   LET g_zo09 = NULL   #FUN-810029 add
   SELECT zo12,zo041,zo05,zo09 INTO g_zo12,g_zo041,g_zo05,g_zo09    #FUN-710080 add zo041   #FUN-810029 add zo05,zo09
     FROM zo_file WHERE zo01='1'
   IF cl_null(g_zo12) THEN
      SELECT zo12 INTO g_zo12 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo041) THEN
      SELECT zo041 INTO g_zo041 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo05) THEN
      SELECT zo05 INTO g_zo05 FROM zo_file WHERE zo01='0'
   END IF
   IF cl_null(g_zo09) THEN
      SELECT zo09 INTO g_zo09 FROM zo_file WHERE zo01='0'
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.imc02= ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)    #FUN-740057 add
   LET tm.c    = ARG_VAL(10)   #FUN-740057 add
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   IF cl_null(tm.wc)
      THEN CALL axmg550_tm(0,0)             # Input print condition
   ELSE 
      CALL axmg550()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)
END MAIN
 
FUNCTION axmg550_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
       l_cmd          LIKE type_file.chr1000     #No.FUN-680137 VARCHAR(400)
 
   LET p_row = 6 LET p_col = 17
 
 
   OPEN WINDOW axmg550_w AT p_row,p_col WITH FORM "axm/42f/axmg550"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET tm.more = 'N'
   LET tm.d = 'Y'      #FUN-690032 add
   LET tm.b = 'Y'      #FUN-740057 add
   LET tm.c = 'Y'      #FUN-740057 add
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ofa01,ofa02
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
 
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmg550_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm.d,tm.imc02,tm.b,tm.c,tm.more WITHOUT DEFAULTS  #FUN-690032   #FUN-740057 add tm.b,tm.c
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD d
         IF tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
 
      AFTER FIELD b
         IF tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES '[YN]' THEN NEXT FIELD c END IF
 
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmg550_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmg550'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmg550','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.imc02 CLIPPED,"'"  ,           #TQC-610089 modify
                         " '",tm.b CLIPPED,"'" ,                #FUN-740057 add
                         " '",tm.c CLIPPED,"'" ,                #FUN-740057 add
                         " '",g_rep_user CLIPPED,"'",           #FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #FUN-570264
                         " '",g_template CLIPPED,"'",           #FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmg550',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmg550_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmg550()
   ERROR ""
END WHILE
   CLOSE WINDOW axmg550_w
END FUNCTION
 
FUNCTION axmg550()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # No.FUN-680137 VARCHAR(1000) 
          l_za05    LIKE type_file.chr1000,       # No.FUN-680137 VARCHAR(50)
          ofa       RECORD LIKE ofa_file.*,
          ofb       RECORD LIKE ofb_file.*,
          ocf       RECORD LIKE ocf_file.*,
          l_ofb12   LIKE ofb_file.ofb12,          #MOD-560003
          sr        RECORD
                    oea10	LIKE oea_file.oea10,
                    oah02	LIKE oah_file.oah02,
                    oag02	LIKE oag_file.oag02,
                    oac02	LIKE oac_file.oac02,
                    oac02_2	LIKE oac_file.oac02,
                    ima138	LIKE ima_file.ima138, #(FCC#) BugNo:4542
                    ima906	LIKE ima_file.ima906, #FUN-710080 add
                    ima910	LIKE ima_file.ima910  #FUN-710080 add
                    END RECORD 
   DEFINE l_found    LIKE type_file.num5,     # No.FUN-680137 SMALLINT
          l_imc04    LIKE ooc_file.ooc02,     
          t_imc04    LIKE imc_file.imc04,     #品名規格額外說明資料
          oao        RECORD LIKE oao_file.*,
          l_ima0102  LIKE type_file.chr1000,
          l_ogd      RECORD LIKE ogd_file.*,
          l_ima02_1  LIKE ima_file.ima02,
          l_sfa      RECORD LIKE sfa_file.*,
          l_ima02_2  LIKE ima_file.ima02,
          l_oaf03    LIKE oaf_file.oaf03,     #說明
          l_ofb915   STRING,
          l_ofb912   STRING,
          t_ofb12    STRING,
          t_ofb14    LIKE ofb_file.ofb14
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)   #FUN-810029 add
   CALL cl_del_data(l_table2)   #FUN-810029 add
   CALL cl_del_data(l_table3)   #FUN-810029 add
   CALL cl_del_data(l_table4)   #FUN-810029 add
   CALL cl_del_data(l_table5)   #FUN-810029 add
   CALL cl_del_data(l_table6)   #FUN-810029 add
   #------------------------------ CR (2) ------------------------------#
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"   #FUN-810029 add 2?   #MOD-960294
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)         #FUN-B40087
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)         #FUN-B40087
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)         #FUN-B40087
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?, ?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
   #  CALL cl_err('insert_prep3:',status,1) CALL cl_used(g_prog,g_time,2) RETURNING g_time EXIT PROGRAM   #FUN-C10036 mark
      CALL cl_err('insert_prep3:',status,1)                         #FUN-C10036 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                #FUN-C10036 add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)         #FUN-B40087
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
 #    CALL cl_err('insert_prep4:',status,1) CALL cl_used(g_prog,g_time,2) RETURNING g_time EXIT PROGRAM   #FUN-C10036 mark
      CALL cl_err('insert_prep4:',status,1)                         #FUN-C10036 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                #FUN-C10036 add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)         #FUN-B40087
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep5 FROM g_sql
   IF STATUS THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#     CALL cl_err('insert_prep5:',status,1) CALL cl_used(g_prog,g_time,2) RETURNING g_time EXIT PROGRAM   #FUN-C10036 mark
      CALL cl_err('insert_prep5:',status,1)                         #FUN-C10036 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                #FUN-C10036 add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)         #FUN-B40087
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
               " VALUES(?,?)"
   PREPARE insert_prep6 FROM g_sql
   IF STATUS THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
    # CALL cl_err('insert_prep6:',status,1) CALL cl_used(g_prog,g_time,2) RETURNING g_time EXIT PROGRAM    #FUN-C10036 mark
      CALL cl_err('insert_prep6:',status,1)                         #FUN-C10036 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                #FUN-C10036 add
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)         #FUN-B40087
      EXIT PROGRAM
   END IF
 
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmg550'
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ofauser', 'ofagrup')
 
   LET l_sql="SELECT ofa_file.*, ofb_file.*,",
             "       ocf_file.*, oea10, oah02, oag02, a.oac02, b.oac02,",
             "       ima138,ima906,ima910,",
             "       azi03,azi04,azi05 ",    #FUN-C50003 add
            #FUN-C50003----mod----str----
            #"  FROM ofa_file,ofb_file,",
            #"       OUTER ocf_file, OUTER oea_file,",
            #"       OUTER oah_file, OUTER oag_file,",
            #"       OUTER oac_file a, OUTER oac_file b,",
            #"       OUTER ima_file",
            #" WHERE ofa01=ofb01 ",
            #"   AND ",tm.wc CLIPPED,
            #"   AND ofaconf !='X' ", #01/08/06 mandy 不要作廢的資料
            #"   AND ofa_file.ofa04=ocf_file.ocf01 AND ofa_file.ofa44=ocf_file.ocf02",
            #"   AND ofb_file.ofb31=oea_file.oea01 AND ofa_file.ofa31=oah_file.oah01 AND ofa_file.ofa32=oag_file.oag01",
            #"   AND ofa_file.ofa41=a.oac01 AND ofa_file.ofa42=b.oac01",
            #"   AND ofb_file.ofb04=ima_file.ima01"
             "  FROM ofa_file LEFT OUTER JOIN ocf_file ON ofa04=ocf01 AND ofa44=ocf02",
             "                LEFT OUTER JOIN oah_file ON ofa31=oah01 ",
             "                LEFT OUTER JOIN oag_file ON ofa32=oag01",
             "                LEFT OUTER JOIN oac_file a ON a.oac01=ofa41 ",
             "                LEFT OUTER JOIN oac_file b ON b.oac01=ofa42 ",
             "                LEFT OUTER JOIN azi_file ON ofa23=azi01,",
             "       ofb_file LEFT OUTER JOIN oea_file ON ofb31=oea01",
             "                LEFT OUTER JOIN ima_file ON ofb04=ima01",
             " WHERE ofa01=ofb01 ",
             "   AND ",tm.wc CLIPPED,
             "   AND ofaconf !='X' "
            #FUN-C50003----mod----str----
   PREPARE axmg550_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)
      EXIT PROGRAM
   END IF
   #先chech金額是否超過20億,因為cl_say超過20億,會掛
   LET l_sql="SELECT SUM(ofb12*ofb13) FROM ofa_file,ofb_file",
             " WHERE ofa01=ofb01 ",
             "   AND ",tm.wc CLIPPED,
             "   AND ofaconf !='X' ",
             " GROUP BY ofa01"
   PREPARE axmg550_chk_say_sql FROM l_sql
   DECLARE axmg550_chk_say_cur CURSOR FOR axmg550_chk_say_sql
   OPEN axmg550_chk_say_cur
   IF SQLCA.sqlcode THEN
      LET l_ofb12=0
   ELSE
      FOREACH axmg550_chk_say_cur INTO l_ofb12
         IF l_ofb12>=2000000000 THEN
            CALL cl_err('chk say','axm-550',1)   #金額過大,無法列印
            RETURN
         END IF
      END FOREACH
   END IF
   DECLARE axmg550_curs1 CURSOR FOR axmg550_prepare1
   #FUN-C50003---mark---str--
    DECLARE ogd_curr CURSOR FOR
     SELECT ogd_file.*,ima02 FROM ogd_file,ogb_file,ima_file
      WHERE ogd01 = ? 
        AND ogd03 = ? 
        AND ogd04 >= 70
        AND ogd01 = ogb01 
        AND ogd03 = ogb03 
        AND ima01 = ogd08

    DECLARE sfa_c CURSOR FOR
     SELECT sfa_file.*,ima02
      FROM sfa_file LEFT OUTER JOIN ima_file ON sfa03=ima01
     WHERE sfa01=?
      ORDER BY sfa30,sfa03

    DECLARE imc_c1 CURSOR FOR
     SELECT imc04 FROM imc_file
     #WHERE imc01=? AND imc02=tm.imc02   #MOD-D30041 mark
      WHERE imc01=? AND imc02=?          #MOD-D30041 add

    DECLARE oao_c1 CURSOR FOR
     SELECT * FROM oao_file
      WHERE oao01=? AND oao03=? AND (oao05='1' OR oao05='2')
   #FUN-C50003---mark---str--31
 
   FOREACH axmg550_curs1 INTO ofa.*, ofb.*, ocf.*, sr.*,t_azi03,t_azi04,t_azi05  #FUN-C50003 add t_azi03,t_azi04,t_azi05
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF ofa.ofa0352 IS NULL THEN
         LET ofa.ofa0352 = ofa.ofa0353 LET ofa.ofa0353 = ofa.ofa0354
         LET ofa.ofa0354 = ofa.ofa0355 LET ofa.ofa0355 = NULL
      END IF
      IF ofa.ofa0452 IS NULL THEN
         LET ofa.ofa0452 = ofa.ofa0453 LET ofa.ofa0453 = ofa.ofa0454
         LET ofa.ofa0454 = ofa.ofa0455 LET ofa.ofa0455 = NULL
      END IF
 
      #ofa72(是否列印FCC No.)
      IF ofa.ofa72='N' THEN LET sr.ima138 = "" END IF
      #客戶訂單單號
      SELECT oea10 INTO sr.oea10 FROM oea_file WHERE oea01=ofb.ofb31
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
            CALL cl_remove_zero(ofb.ofb12) RETURNING t_ofb12
            LET l_str3 = l_str3 CLIPPED,"(",t_ofb12,ofb.ofb05 CLIPPED,")"
         END IF
      END IF
      IF ofa.ofa0352 IS NULL THEN #帳款客戶全名
         LET ofa.ofa0352 = ofa.ofa0353 LET ofa.ofa0353 = ofa.ofa0354
         LET ofa.ofa0354 = ofa.ofa0355 LET ofa.ofa0355 = NULL
      END IF
      IF ofa.ofa0452 IS NULL THEN #送貨客戶全名
         LET ofa.ofa0452 = ofa.ofa0453 LET ofa.ofa0453 = ofa.ofa0454
         LET ofa.ofa0454 = ofa.ofa0455 LET ofa.ofa0455 = NULL
      END IF
      #品名規格額外說明
      LET l_imc04=NULL
      #CHI-A50034 mark --start--
      #SELECT imc04 INTO l_imc04 FROM imc_file
      # WHERE imc01=ofb.ofb04 AND imc02='1' AND imc03='1'
      #CHI-A50034 mark --end--
      IF NOT cl_null(tm.imc02) THEN   #FUN-890098
     #FUN-C50003----mark----str---
     #   DECLARE imc_c1 CURSOR FOR
     #    SELECT imc04 FROM imc_file
     #     WHERE imc01=ofb.ofb04 AND imc02=tm.imc02
     #FUN-C50003----mark----str---
         FOREACH imc_c1 USING ofb.ofb04,tm.imc02 INTO t_imc04    #FUN-C50003 add USING ofb.ofb04   #MOD-D30041 add ,tm.imc02
            IF NOT cl_null(t_imc04) THEN
               EXECUTE insert_prep1 USING ofa.ofa01,ofb.ofb04,t_imc04
            END IF
         END FOREACH
      END IF
      #產品編號,客戶產品編號
      IF ofb.ofb11 IS NULL THEN
         SELECT obk03 INTO ofb.ofb11 FROM obk_file
          WHERE obk01=ofb.ofb04 AND obk02=ofa.ofa03
      END IF
      CASE WHEN ofa.ofa71='1' #LET ofb.ofb11=NULL  #No.TQC-A50044
           WHEN ofa.ofa71='2' LET ofb.ofb04=ofb.ofb11 #LET ofb.ofb11=NULL  #No.TQC-A50044
      END CASE
      #-----MOD-A70040---------
      IF ofa.ofa71 = '3' THEN
         LET tm.d = 'Y'
      END IF
      #-----END MOD-A70040-----
      LET t_ofb14 = 0
      SELECT SUM(ofb14) INTO t_ofb14 FROM ofb_file WHERE ofb01=ofa.ofa01
      CALL cl_say(t_ofb14,80) RETURNING l_str1,l_str2
      #單價、金額、小計小數位數
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
        FROM azi_file WHERE azi01 = ofa.ofa23
      IF cl_null(t_azi03) THEN LET t_azi03 = 0 END IF
      IF cl_null(t_azi04) THEN LET t_azi04 = 0 END IF
      IF cl_null(t_azi05) THEN LET t_azi05 = 0 END IF
      #客戶嘜頭檔
      LET g_po_no=ofa.ofa10 LET g_ctn_no1=ofa.ofa45 LET g_ctn_no2=ofa.ofa46   #TQC-750123 add
      LET ocf.ocf101=ocf_c(ocf.ocf101) LET ocf.ocf201=ocf_c(ocf.ocf201)
      LET ocf.ocf102=ocf_c(ocf.ocf102) LET ocf.ocf202=ocf_c(ocf.ocf202)
      LET ocf.ocf103=ocf_c(ocf.ocf103) LET ocf.ocf203=ocf_c(ocf.ocf203)
      LET ocf.ocf104=ocf_c(ocf.ocf104) LET ocf.ocf204=ocf_c(ocf.ocf204)
      LET ocf.ocf105=ocf_c(ocf.ocf105) LET ocf.ocf205=ocf_c(ocf.ocf205)
      LET ocf.ocf106=ocf_c(ocf.ocf106) LET ocf.ocf206=ocf_c(ocf.ocf206)
      LET ocf.ocf107=ocf_c(ocf.ocf107) LET ocf.ocf207=ocf_c(ocf.ocf207)
      LET ocf.ocf108=ocf_c(ocf.ocf108) LET ocf.ocf208=ocf_c(ocf.ocf208)
      LET ocf.ocf109=ocf_c(ocf.ocf109) LET ocf.ocf209=ocf_c(ocf.ocf209)
      LET ocf.ocf110=ocf_c(ocf.ocf110) LET ocf.ocf210=ocf_c(ocf.ocf210)
      LET ocf.ocf111=ocf_c(ocf.ocf111) LET ocf.ocf211=ocf_c(ocf.ocf211)
      LET ocf.ocf112=ocf_c(ocf.ocf112) LET ocf.ocf212=ocf_c(ocf.ocf212)
 
      EXECUTE insert_prep USING
         ofa.ofa01  ,ofa.ofa02  ,ofa.ofa49  ,ofa.ofa011 ,ofa.ofa0351,ofa.ofa0352,      #MOD-960294
         ofa.ofa0353,ofa.ofa0354,ofa.ofa0355,ofa.ofa0451,ofa.ofa0452,
         ofa.ofa0453,ofa.ofa0454,ofa.ofa0455,ofa.ofa31  ,sr.oah02   ,
         ofa.ofa32  ,sr.oag02   ,ofa.ofa43  ,ofa.ofa47  ,ofa.ofa61  ,
         ofa.ofa62  ,ofa.ofa63  ,sr.oac02   ,sr.oac02_2 ,ofb.ofb03  ,
         ofb.ofb04  ,ofb.ofb06  ,sr.ima138  ,sr.oea10   ,ofb.ofb12  ,
         ofb.ofb05  ,ofb.ofb916 ,ofb.ofb917 ,ofb.ofb13  ,ofb.ofb14  ,
         l_imc04    ,ofb.ofb11  ,ofb.ofb33  ,ofa.ofa23  ,t_azi03    ,
         t_azi04    ,t_azi05    ,l_str1     ,l_str2     ,l_str3     ,
         g_zo12     ,g_zo041    ,ocf.ocf101 ,ocf.ocf102 ,ocf.ocf103 ,
         ocf.ocf104 ,ocf.ocf105 ,ocf.ocf106 ,ocf.ocf107 ,ocf.ocf108 ,
         ocf.ocf109 ,ocf.ocf110 ,ocf.ocf111 ,ocf.ocf112 ,ocf.ocf201 ,
         ocf.ocf202 ,ocf.ocf203 ,ocf.ocf204 ,ocf.ocf205 ,ocf.ocf206 ,
         ocf.ocf207 ,ocf.ocf208 ,ocf.ocf209 ,ocf.ocf210 ,ocf.ocf211 ,
         ocf.ocf212 ,g_zo05     ,g_zo09   #FUN-810029 add g_zo05,g_zo09
 
      #列印單身備註
     #FUN-C50003----mark----str---
     #DECLARE oao_c1 CURSOR FOR
     # SELECT * FROM oao_file
     #  WHERE oao01=ofa.ofa01 AND oao03=ofb.ofb03 AND (oao05='1' OR oao05='2')
     #FUN-C50003----mark----str---
      FOREACH oao_c1 USING ofa.ofa01,ofb.ofb03 INTO oao.*    #FUN-C50003 add USING ofa.ofa01.ofb.ofb03 
         IF NOT cl_null(oao.oao06) THEN
            EXECUTE insert_prep5 USING 
               ofa.ofa01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
         END IF
      END FOREACH
 
      #主特性代碼
      IF ofa.ofa73='Y' THEN
         FOR i=1 to 99 INITIALIZE g_sr[i].* TO NULL END FOR   #FUN-7C0011 add
         IF cl_null(sr.ima910) THEN LET sr.ima910=' ' END IF
         LET g_no=0                                           #FUN-7C0011 add
         CALL g550_bom(0,ofb.ofb04,sr.ima910)  #FUN-550110
         IF g_no >=1 THEN
            FOR i= 1 TO g_no
               IF g_sr[i].ima01 IS NULL THEN CONTINUE FOR END IF
               LET l_ima0102 = g_sr[i].ima01[1,12],' ',g_sr[i].ima02
               EXECUTE insert_prep4 USING ofa.ofa01,ofb.ofb04,l_ima0102
               LET l_ima0102 = ''                             #FUN-7C0011 add
            END FOR
         END IF
      END IF
      #包裝方式
     #FUN-C50003---mark---str--
     #DECLARE ogd_curr CURSOR FOR
     # SELECT ogd_file.*,ima02 FROM ogd_file,ogb_file,ima_file
     #  WHERE ogd01 = ofa.ofa011 
     #    AND ogd03 = ofb.ofb03 
     #    AND ogd04 >= 70
     #    AND ogd01 = ogb01 
     #    AND ogd03 = ogb03 
     #    AND ima01 = ogd08
     #FUN-C50003---mark---str--
      FOREACH ogd_curr USING ofa.ofa011,ofb.ofb03 INTO l_ogd.*,l_ima02_1    #FUN-C50003 add USING ofa.ofa011,ofb.ofb03
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
         IF cl_null(l_ogd.ogd08) THEN LET l_ogd.ogd08='' END IF
         IF cl_null(l_ogd.ogd13) THEN LET l_ogd.ogd13=0 END IF
         IF cl_null(l_ima02_1) THEN LET l_ima02_1='' END IF
         EXECUTE insert_prep2 USING 
            ofa.ofa01,ofa.ofa011,ofb.ofb03,l_ogd.ogd08,l_ima02_1,
            l_ogd.ogd13
      END FOREACH
      #備料
      IF ofb.ofb33 IS NOT NULL THEN
        #FUN-C50003---mark---str--
        #DECLARE sfa_c CURSOR FOR
        #   SELECT sfa_file.*,ima02
        #     FROM sfa_file, OUTER ima_file
        #    WHERE sfa01=ofb.ofb33 
        #      AND sfa_file.sfa03=ima_file.ima01
        #    ORDER BY sfa30,sfa03
        #FUN-C50003---mark---end--
         FOREACH sfa_c USING ofb.ofb33 INTO l_sfa.*,l_ima02_2   #FUN-C50003 add USING ofb.ofb33
            IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
            IF cl_null(l_sfa.sfa03) THEN LET l_sfa.sfa03='' END IF
            IF cl_null(l_sfa.sfa12) THEN LET l_sfa.sfa12='' END IF
            IF cl_null(l_sfa.sfa06) THEN LET l_sfa.sfa06=0 END IF
            IF cl_null(l_ima02_2) THEN LET l_ima02_2='' END IF
            EXECUTE insert_prep3 USING 
               ofa.ofa01,ofb.ofb33,l_sfa.sfa03,l_ima02_2,l_sfa.sfa12,
               l_sfa.sfa06
         END FOREACH
      END IF
   END FOREACH
 
   LET l_sql = "SELECT * FROM ofa_file ",
               " WHERE ",tm.wc CLIPPED,
               "   AND ofaconf !='X' ",
               " ORDER BY ofa01"
   PREPARE axmg550_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('axmg550_prepare2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5||"|"||l_table6)
      EXIT PROGRAM
   END IF
   DECLARE axmg550_curs2 CURSOR FOR axmg550_prepare2
  
  #FUN-C50003----add----str----
   #列印整張備註
    DECLARE oao_c2 CURSOR FOR
     SELECT * FROM oao_file
      WHERE oao01=? AND oao03=0 AND (oao05='1' OR oao05='2')

   #常用說明
    DECLARE oaf_c CURSOR FOR
       SELECT oaf03 FROM oaf_file
        WHERE (oaf01=? OR oaf01=? OR oaf01=?)
        ORDER BY oaf01,oaf02
  #FUN-C50003----add----end----
 
   FOREACH axmg550_curs2 INTO ofa.*
      #列印整張備註
     #FUN-C50003---mark---str--
     #DECLARE oao_c2 CURSOR FOR
     # SELECT * FROM oao_file
     #  WHERE oao01=ofa.ofa01 AND oao03=0 AND (oao05='1' OR oao05='2')
     #FUN-C50003---mark---end--
      FOREACH oao_c2 USING ofa.ofa01 INTO oao.*   #FUN-C50003 add USING ofa.ofa01 
         IF NOT cl_null(oao.oao06) THEN
            EXECUTE insert_prep5 USING
               ofa.ofa01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
         END IF
      END FOREACH
      #常用說明
     #FUN-C50003---mark---str--
     #DECLARE oaf_c CURSOR FOR
     #   SELECT oaf03 FROM oaf_file
     #    WHERE (oaf01=ofa.ofa741 OR oaf01=ofa.ofa742 OR oaf01=ofa.ofa743)
     #    ORDER BY oaf01,oaf02
     #FUN-C50003---mark---end--
      FOREACH oaf_c USING ofa.ofa741,ofa.ofa742,ofa.ofa743 INTO l_oaf03   #FUN-C50003 add USINGUSING ofa.ofa741,ofa.ofa742,ofa.ofa743
         IF NOT cl_null(l_oaf03) THEN
            EXECUTE insert_prep6 USING ofa.ofa01,l_oaf03
         END IF
      END FOREACH
   END FOREACH
 
  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
###GENGRE###               " WHERE oao03 =0 AND oao05='1'","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
###GENGRE###               " WHERE oao03!=0 AND oao05='1'","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
###GENGRE###               " WHERE oao03!=0 AND oao05='2'","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
###GENGRE###               " WHERE oao03 =0 AND oao05='2'","|",
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ofa01,ofa02') RETURNING tm.wc
   ELSE
      LET tm.wc = ''
   END IF
###GENGRE###   LET g_str = g_sma.sma115,";",g_sma.sma116,";",tm.d,";",
###GENGRE###               tm.wc,";",tm.b,";",tm.c   #FUN-740057 add tm.b,tm.c
###GENGRE###   CALL cl_prt_cs3('axmg550','axmg550',g_sql,g_str)
    CALL axmg550_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
 
FUNCTION ocf_c(str)
  DEFINE str	 LIKE occ_file.occ46      # No.MOD-690064 VARCHAR(30)
  # 把麥頭內'PPPPPP'字串改為 P/O NO (ofa.ofa10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO (ofa.ofa45)
  # 把麥頭內'DDDDDD'字串改為 CTN NO (ofa.ofa46)
  FOR i=1 TO 20
     LET j=i+5
     IF str[i,j]='PPPPPP' THEN LET str[i,40]=g_po_no  END IF
     IF str[i,j]='CCCCCC' THEN LET str[i,j]=g_ctn_no1 END IF  
     IF str[i,j]='DDDDDD' THEN LET str[i,j]=g_ctn_no2 END IF 
  END FOR
  RETURN str
END FUNCTION
 
FUNCTION g550_bom(p_level,p_key,p_key2)     #FUN-550110
DEFINE
   p_level        LIKE type_file.num5,      #No.FUN-680137 SMALLINT #level code
   p_key          LIKE bma_file.bma01,      #assembly part number
   p_key2         LIKE ima_file.ima910,     #FUN-550110
   l_ac,l_i,l_x   LIKE type_file.num5,      #No.FUN-680137 SMALLINT
   arrno          LIKE type_file.num5,      #No.FUN-680137 SMALLINT #BUFFER SIZE
   b_seq,l_double LIKE type_file.num5,      #No.FUN-680137 INTEGER #restart sequence (line number)
   sr DYNAMIC ARRAY OF RECORD  #array for storage
       bmb02      LIKE bmb_file.bmb02,      #項次
       bmb03      LIKE bmb_file.bmb03,      #料號
       ima02      LIKE ima_file.ima02,      #品名規格
       ima105     LIKE ima_file.ima105,     #軟體物件
       bma01      LIKE bma_file.bma01       #主件
   END RECORD,
   l_chr          LIKE type_file.chr1,      #No.FUN-680137 VARCHAR(1)
   l_cnt,l_c      LIKE type_file.num5,      #No.FUN-680137 smallint
   l_cmd          LIKE type_file.chr1000    #No.FUN-680137
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
   LET p_level = p_level + 1
   LET arrno = 500
   LET l_cmd=" SELECT 0,bmb03,ima02,ima105,bma01 ",
             "   FROM bmb_file,OUTER ima_file,OUTER bma_file ",
             "  WHERE bmb01='",p_key,"' AND bmb02 > ?",
             "    AND bmb_file.bmb03 = bma_file.bma01",
             "    AND bmb_file.bmb03 = ima_file.ima01",
             "    AND bmb29 ='",p_key2,"' ",  #FUN-550110
             "    AND (bmb04 <='",TODAY,"' OR bmb04 IS NULL) ",
             "    AND (bmb05 >'",TODAY,"' OR bmb05 IS NULL)",
             " ORDER BY 1"
   PREPARE bom_p FROM l_cmd
   DECLARE bom_cs CURSOR FOR bom_p
   IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN  END IF
 
   LET b_seq=0
   WHILE TRUE
      LET l_ac = 1
      FOREACH bom_cs USING b_seq INTO sr[l_ac].*
         MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
         CALL ui.Interface.refresh()
         IF sr[l_ac].ima105='Y' THEN
            LET g_no=g_no+1
            LET g_sr[g_no].ima01=sr[l_ac].bmb03
            LET g_sr[g_no].ima02=sr[l_ac].ima02
            IF g_no > 20 THEN RETURN END IF
         END IF
         LET l_ima910[l_ac]=''
         SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03 
         IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
         LET l_ac = l_ac + 1    #check limitation
         IF l_ac > arrno THEN EXIT FOREACH END IF
      END FOREACH
      LET l_x=l_ac-1
 
      FOR l_i = 1 TO l_x
         IF sr[l_i].bma01 IS NOT NULL THEN
            CALL g550_bom(p_level,sr[l_i].bmb03,l_ima910[l_i])  #FUN-8B0035
         END IF
      END FOR
      IF l_x < arrno OR l_ac=1 THEN #nothing left
         EXIT WHILE
      ELSE
         LET b_seq = sr[l_x].bmb02
      END IF
   END WHILE
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

###GENGRE###START
FUNCTION axmg550_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axmg550")
        IF handler IS NOT NULL THEN
            START REPORT axmg550_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ofa01,ofb04"          #FUN-B40087

            DECLARE axmg550_datacur1 CURSOR FROM l_sql
            FOREACH axmg550_datacur1 INTO sr1.*
                OUTPUT TO REPORT axmg550_rep(sr1.*)
            END FOREACH
            FINISH REPORT axmg550_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axmg550_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE sr5 sr5_t
    DEFINE sr6 sr6_t
    DEFINE sr7 sr7_t
    DEFINE l_lineno         LIKE type_file.num5
    #FUN-B40087  ADD --------STR -----
    DEFINE l_data_qty       LIKE ofb_file.ofb12
    DEFINE l_data_unit      LIKE ofb_file.ofb05
    DEFINE l_oac02_oac02_2  STRING
    DEFINE l_ofa31_oah02    STRING
    DEFINE l_ofa32_oag02    STRING
    DEFINE l_say_total      STRING
    DEFINE l_sum_data_qty   LIKE ofb_file.ofb12
    DEFINE l_sum_ofb14      LIKE ofb_file.ofb14
    DEFINE l_display        LIKE sma_file.sma116
    DEFINE l_sql            STRING
    DEFINE l_data_qty_fmt   STRING
    DEFINE l_ofb13_fmt      STRING
    DEFINE l_ofb14_fmt      STRING
    DEFINE l_sum_data_qty_fmt STRING
    DEFINE l_display1       STRING
    DEFINE l_flag1          STRING
    DEFINE l_flag2          STRING
    DEFINE l_flag3          STRING
    DEFINE l_flag4          STRING
    DEFINE l_flag6          STRING
    DEFINE l_flag7          STRING
    #FUN-B40087  ADD --------END -----
    DEFINE l_ofa23          STRING  #CHI-D30011 add

    
    ORDER EXTERNAL BY sr1.ofa01,sr1.ofb04
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_sma.sma115    #FUN-B40087  ADD
              
        BEFORE GROUP OF sr1.ofa01
            LET l_lineno = 0
            #FUN-B40087  ADD --------STR -----
            IF NOT cl_null(sr1.oac02) AND NOT cl_null(sr1.oac02_2) THEN
               LET l_oac02_oac02_2 = sr1.oac02,' TO ',sr1.oac02_2
            ELSE IF NOT cl_null(sr1.oac02) AND cl_null(sr1.oac02_2) THEN
                    LET l_oac02_oac02_2 = sr1.oac02,' TO '
                 END IF 
                 IF cl_null(sr1.oac02) AND NOT cl_null(sr1.oac02_2) THEN
                    LET l_oac02_oac02_2 =' TO ',sr1.oac02_2
                 END IF
                 IF cl_null(sr1.oac02) AND cl_null(sr1.oac02_2) THEN
                    LET l_oac02_oac02_2 =' TO '
                 END IF 
            END IF 
            PRINTX l_oac02_oac02_2
            IF NOT cl_null(sr1.ofa31) AND NOT cl_null(sr1.oah02) THEN
               LET l_ofa31_oah02 = sr1.ofa31,' ',sr1.oah02
            ELSE IF NOT cl_null(sr1.ofa31) AND cl_null(sr1.oah02) THEN
                    LET l_ofa31_oah02 = sr1.ofa31
                 END IF
                 IF cl_null(sr1.ofa31) AND NOT cl_null(sr1.oah02) THEN
                    LET l_ofa31_oah02 = sr1.oah02
                 END IF
            END IF
            PRINTX l_ofa31_oah02
            IF NOT cl_null(sr1.ofa32) AND NOT cl_null(sr1.oag02) THEN
               LET l_ofa32_oag02 = sr1.ofa32,' ',sr1.oag02
            ELSE IF NOT cl_null(sr1.ofa32) AND cl_null(sr1.oag02) THEN
                    LET l_ofa32_oag02 = sr1.ofa32
                 END IF
                 IF cl_null(sr1.ofa32) AND NOT cl_null(sr1.oag02) THEN
                    LET l_ofa32_oag02 = sr1.oag02
                 END IF
            END IF
            PRINTX l_ofa32_oag02

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao05='1' AND oao03= 0"  
            START REPORT axmg550_subrep05
            DECLARE axmg550_repcur5 CURSOR FROM l_sql
            FOREACH axmg550_repcur5 INTO sr6.*
                OUTPUT TO REPORT axmg550_subrep05(sr6.*)
            END FOREACH
            FINISH REPORT axmg550_subrep05
            #FUN-B40087  ADD --------END -----
        BEFORE GROUP OF sr1.ofb04

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B40087  ADD --------STR -----
            IF cl_null(sr1.ima138) THEN
               LET sr1.ima138 = sr1.ima138
            ELSE
               LET sr1.ima138 = "FCC#：",sr1.ima138
            END IF

            IF cl_null(sr1.ima138) AND cl_null(sr1.ofb11) AND cl_null(sr1.str3) THEN
               LET l_display1 = "N"
            ELSE 
               LET l_display1 = "Y"
            END IF
            PRINTX l_display1
            LET l_data_qty_fmt = cl_gr_numfmt('ofb_file','ofb12',sr1.azi05)
            PRINTX l_data_qty_fmt
            LET l_ofb13_fmt = cl_gr_numfmt('ofb_file','ofb13',sr1.azi03)
            PRINTX l_ofb13_fmt
            LET l_ofb14_fmt = cl_gr_numfmt('ofb_file','ofb14',sr1.azi04)
            PRINTX l_ofb14_fmt
            LET l_sum_data_qty_fmt = cl_gr_numfmt('ofb_file','ofb12',sr1.azi05)
            PRINTX l_sum_data_qty_fmt
            LET l_display = g_sma.sma116
            PRINTX l_display
            IF l_display = '0' OR l_display = '1' THEN
               LET l_data_qty = sr1.ofb12
            ELSE
               LET l_data_qty = sr1.ofb917
            END IF 
            PRINTX l_data_qty
            IF l_display = '0' OR l_display = '1' THEN
               LET l_data_unit = sr1.ofb05
            ELSE
               LET l_data_unit = sr1.ofb916
            END IF 
            PRINTX l_data_unit
         
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = ",sr1.ofb03 CLIPPED,
                        " AND oao05='1'"
            START REPORT axmg550_subrep06
            DECLARE axmg550_repcur6 CURSOR FROM l_sql
            FOREACH axmg550_repcur6 INTO sr6.*
                LET l_flag6 = "N"
                OUTPUT TO REPORT axmg550_subrep06(sr6.*)
            END FOREACH
            FINISH REPORT axmg550_subrep06


            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                       #" WHERE imc01 = '",sr1.ofb04 CLIPPED,"'",   #MOD-D30041 mark
                        " WHERE ofa01 = '",sr1.ofa01 CLIPPED,"'",   #MOD-D30041 add
                       #" AND imc02 = '",tm.imc02 CLIPPED,"'"       #MOD-D30041 mark
                        " AND imc01 = '",sr1.ofb04 CLIPPED,"'"       #MOD-D30041 add
            START REPORT axmg550_subrep01
            DECLARE axmg550_repcur1 CURSOR FROM l_sql
            FOREACH axmg550_repcur1 INTO sr2.*
                LET l_flag1 = "N"
                OUTPUT TO REPORT axmg550_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT axmg550_subrep01

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                        " WHERE ofa01 = '",sr1.ofa01 CLIPPED,"'"
            START REPORT axmg550_subrep04
            DECLARE axmg550_repcur4 CURSOR FROM l_sql
            FOREACH axmg550_repcur4 INTO sr5.*
                LET l_flag4 = "N"
                OUTPUT TO REPORT axmg550_subrep04(sr5.*)
            END FOREACH
            FINISH REPORT axmg550_subrep04

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = ",sr1.ofb03 CLIPPED,
                        " AND oao05='2'"
            START REPORT axmg550_subrep07
            DECLARE axmg550_repcur7 CURSOR FROM l_sql
            FOREACH axmg550_repcur7 INTO sr6.*
                LET l_flag7 = "N"
                OUTPUT TO REPORT axmg550_subrep07(sr6.*)
            END FOREACH
            FINISH REPORT axmg550_subrep07

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE ogd01 = '",sr1.ofa011 CLIPPED,"'",
                        " AND ogd03 = ",sr1.ofb03 CLIPPED
            START REPORT axmg550_subrep02
            DECLARE axmg550_repcur2 CURSOR FROM l_sql
            FOREACH axmg550_repcur2 INTO sr3.*
                LET l_flag2 = "N"
                OUTPUT TO REPORT axmg550_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT axmg550_subrep02

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE sfa01 = '",sr1.ofb33 CLIPPED,"'"
            START REPORT axmg550_subrep03
            DECLARE axmg550_repcur3 CURSOR FROM l_sql
            FOREACH axmg550_repcur3 INTO sr4.*
                LET l_flag3 = "N"
                OUTPUT TO REPORT axmg550_subrep03(sr4.*)
            END FOREACH
            FINISH REPORT axmg550_subrep03
            PRINTX l_flag1
            PRINTX l_flag2
            PRINTX l_flag3
            PRINTX l_flag4
            PRINTX l_flag6
            PRINTX l_flag7
            #FUN-B40087  ADD --------END -----
            PRINTX sr1.*

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
              #LET l_say_total = "Say Total ",sr1.ofa23 #CHI-D30011 mark
               LET l_say_total = "Say Total ",l_ofa23   #CHI-D30011 
            ELSE IF cl_null(sr1.str1) AND NOT cl_null(sr1.str2) THEN
                   #LET l_say_total = "Say Total ",sr1.ofa23,' ',sr1.str2 #CHI-D30011 mark
                    LET l_say_total = "Say Total ",l_ofa23,' ',sr1.str2   #CHI-D30011 
                 ELSE IF NOT cl_null(sr1.str1) AND cl_null(sr1.str2) THEN
                        #LET l_say_total = "Say Total ",sr1.ofa23,' ',sr1.str1 #CHI-D30011 mark
                         LET l_say_total = "Say Total ",l_ofa23,' ',sr1.str1   #CHI-D30011
                       ELSE
                         #LET l_say_total = "Say Total ",sr1.ofa23,' ',sr1.str1,' ',sr1.str2 #CHI-D30011 mark
                          LET l_say_total = "Say Total ",l_ofa23,' ',sr1.str1,' ',sr1.str2   #CHI-D30011 
                       END IF
                  END IF
             END IF
             PRINTX l_say_total
             LET l_sum_ofb14 = GROUP SUM(sr1.ofb14)
             PRINTX l_sum_ofb14
             IF l_display = '0' OR l_display = '1' THEN
                LET l_sum_data_qty = GROUP SUM(sr1.ofb12)
             ELSE
                LET l_sum_data_qty = GROUP SUM(sr1.ofb917)
             END IF
             PRINTX l_sum_data_qty
   
             LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                        " WHERE oao01 = '",sr1.ofa01 CLIPPED,"'",
                        " AND oao03 = 0",
                        " AND oao05= '2'"
            START REPORT axmg550_subrep08
            DECLARE axmg550_repcur8 CURSOR FROM l_sql
            FOREACH axmg550_repcur8 INTO sr6.*
                OUTPUT TO REPORT axmg550_subrep08(sr6.*)
            END FOREACH
            FINISH REPORT axmg550_subrep08

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
                        " WHERE ofa01 = '",sr1.ofa01 CLIPPED,"'"
            START REPORT axmg550_subrep09
            DECLARE axmg550_repcur9 CURSOR FROM l_sql
            FOREACH axmg550_repcur9 INTO sr7.*
                OUTPUT TO REPORT axmg550_subrep09(sr7.*)
            END FOREACH
            FINISH REPORT axmg550_subrep09
             #FUN-B40087  ADD --------END -----
        AFTER GROUP OF sr1.ofb04

        
        ON LAST ROW

END REPORT
#FUN-B40087  ADD --------STR -----
REPORT axmg550_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT

REPORT axmg550_subrep02(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axmg550_subrep03(sr4)
    DEFINE sr4 sr4_t

    FORMAT
        ON EVERY ROW
            PRINTX sr4.*
END REPORT

REPORT axmg550_subrep04(sr5)
    DEFINE sr5 sr5_t
    DEFINE l_n   LIKE type_file.num5     #FUN-C20051 add

    FORMAT
        ON EVERY ROW
            #FUN-C20051 add-----str-----
            IF cl_null(l_n) THEN
               LET l_n = 1        
            ELSE
               LET l_n = l_n +1  
            END IF
            PRINTX l_n          
            #FUN-C20051 add-----end-----

            PRINTX sr5.*
END REPORT

REPORT axmg550_subrep05(sr6)
    DEFINE sr6 sr6_t

    FORMAT
        ON EVERY ROW
            PRINTX sr6.*
END REPORT
REPORT axmg550_subrep06(sr6)
    DEFINE sr6 sr6_t

    FORMAT
        ON EVERY ROW
            PRINTX sr6.*
END REPORT
REPORT axmg550_subrep07(sr6)
    DEFINE sr6 sr6_t

    FORMAT
        ON EVERY ROW
            PRINTX sr6.*
END REPORT
REPORT axmg550_subrep08(sr6)
    DEFINE sr6 sr6_t

    FORMAT
        ON EVERY ROW
            PRINTX sr6.*
END REPORT
REPORT axmg550_subrep09(sr7)
    DEFINE sr7 sr7_t

    FORMAT
        ON EVERY ROW
            PRINTX sr7.*
END REPORT
#FUN-B40087  ADD --------END -----
###GENGRE###END
