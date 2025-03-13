# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: apmg630.4gl
# Descriptions...: 採購庫存異動單據列印
# Date & Author..: 97/07/09  By  Kitty
#
# Modify.........: No:8322 03/09/25 By Mandy l_sql中azf02='2'在.ora要改為azf_file.azf02='2'才對
# Modify.........: No.MOD-530070 05/03/24 By Mandy 異動數量欄位請放大
# Modify.........: NO.FUN-550060 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570174 05/07/19 By yoyo 項次欄位增大
# Modify.........: No.FUN-580004 05/08/03 By day 報表轉xml
# Modify.........: No.MOD-580395 05/09/08 By echo apmr631,apmr632列印時串apmg630
# Modify.........: No.MOD-590517 05/09/29 By Rosayu 報表名稱前漏加column
# Modify.........: No.FUN-5A0139 05/10/20 By Pengu 調整報表的格式
# Modify.........: No.TQC-5B0212 05/12/01 By kevin 結束位置調整
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-640070 06/04/08 By Carol 採購入庫單無列印「規格」欄位 
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-640236 06/06/27 By Sarah 將規格ima021欄位獨立出來列印
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6C0058 06/12/08 By ray 1.報表格式修改
#                                                2.非背景運行時抓不到資料
# Modify.........: No.MOD-6C0145 06/12/22 By rainy 計價數量印出小數位數依單位取aooi101
# Modify.........: No.FUN-710091 07/02/14 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740294 07/06/04 By Sarah apmg630/apmr631/apmr632共用程式,630以外的報表出表有問題
# Modify.........: No.MOD-760106 07/06/23 By claire 不可將參數default給值及修背景時傳入程式名
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.MOD-7C0035 07/12/05 By claire 調整語法FUN-710091
# Modify.........: No.FUN-860026 08/07/15 By baofei 增加子報表-列印批序號明細
# Modify.........: No.MOD-850291 08/05/28 By chenl  根據p_grog對g_rvu00異動類型進行賦值。
# Modify.........: NO.MOD-940407 09/04/30 By lutingting apmr631資料來源應該是采購倉退rvu00='3'
# Modify.........: NO.TQC-960231 09/06/19 By lilingyu apmg630畫面rvu01字段名稱顯示錯誤
# Modify.........: NO.TQC-960354 09/06/25 By sherry apmr632畫面rvu01字段名稱顯示錯誤  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:MOD-A40062 10/04/14 By Smapmin 批序號的資料呈現有誤
# Modify.........: No.FUN-B40087 11/06/09 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-C10036 12/01/11 By qirl  TQC-B90025追單
# Modify.........: No.FUN-C40019 12/04/10 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/05/04 By yangtt GR程式優化
# Modify.........: No.FUN-C50140 12/06/11 By chenying GR修改
# Modify.........: No.FUN-C70071 12/07/17 By qiaozy   添加gr服飾流通業款式明細選項
# Modify.........: No:FUN-C90130 12/09/28 By yangtt rvu01欄位添加開窗功能
# Modify.........: No.MOD-D10175 13/01/31 By Elise 將l_sql定義為STRING
# Modify.........: No.DEV-D40005 13/04/03 By TSD.JIE 與M-Barcode整合(aza131)='Y',列印單號條碼
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5       #No.FUN-680136 SMALLINT
END GLOBALS
 
  DEFINE tm  RECORD                                                           # Print condition RECORD
             wc        STRING,   #No.FUN-680136 VARCHAR(600)     # Where condition#FUN-C70071--STRING---
             a         LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)       # 選擇(1)已列印 (2)未列印 (3)全部
             b         LIKE type_file.chr1,      #No.FUN-860026 
             c         LIKE type_file.chr1,      #No.FUN-C70071--ADD--- 
             more      LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)       # Input more condition(Y/N)
             END RECORD,
         g_rvu00       LIKE rvu_file.rvu00,
         g_rvu00_o     LIKE rvu_file.rvu00       #TQC-740294 add
  DEFINE g_i           LIKE type_file.num5       #count/index for any purpose #No.FUN-680136 SMALLINT
  DEFINE g_sma115      LIKE sma_file.sma115      #No.FUN-580004
  DEFINE g_sma116      LIKE sma_file.sma116      #No.FUN-580004
  DEFINE g_sql      STRING
  DEFINE  l_table1      STRING   #No.FUN-860026 
  DEFINE l_table      STRING
  DEFINE l_table2     STRING     #FUN-C70071----ADD--
  DEFINE l_table3     STRING     #FUN-C70071----ADD---
 
###GENGRE###START
TYPE sr1_t RECORD
    rvu00 LIKE rvu_file.rvu00,
    rvu01 LIKE rvu_file.rvu01,
    rvu02 LIKE rvu_file.rvu02,
    rvu03 LIKE rvu_file.rvu03,
    rvu04 LIKE rvu_file.rvu04,
    rvu05 LIKE rvu_file.rvu05,
    rvu06 LIKE rvu_file.rvu06,
    gem02 LIKE gem_file.gem02,
    rvu07 LIKE rvu_file.rvu07,
    gen02 LIKE gen_file.gen02,
    rvu08 LIKE rvu_file.rvu08,
    rvu09 LIKE rvu_file.rvu09,
    rvv02 LIKE rvv_file.rvv02,
    rvv05 LIKE rvv_file.rvv05,
    rvv31 LIKE rvv_file.rvv31,
    rvv031 LIKE rvv_file.rvv031,
    rvv34 LIKE rvv_file.rvv34,
    rvv32 LIKE rvv_file.rvv32,
    rvv33 LIKE rvv_file.rvv33,
    rvv17 LIKE rvv_file.rvv17,
    rvv35 LIKE rvv_file.rvv35,
    rvv36 LIKE rvv_file.rvv36,
    rvv18 LIKE rvv_file.rvv18,
    rvv37 LIKE rvv_file.rvv37,
    rvv25 LIKE rvv_file.rvv25,
    azf03 LIKE azf_file.azf03,
    rvv26 LIKE rvv_file.rvv26,
    rvv80 LIKE rvv_file.rvv80,
    rvv82 LIKE rvv_file.rvv82,
    rvv83 LIKE rvv_file.rvv83,
    rvv85 LIKE rvv_file.rvv85,
    ima021 LIKE ima_file.ima021,
    str2 LIKE type_file.chr1000,
    gfe03 LIKE gfe_file.gfe03,
    str LIKE type_file.chr1000,
    sma115 LIKE sma_file.sma115,
    flag LIKE type_file.num5,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD

TYPE sr2_t RECORD
    rvbs01 LIKE rvbs_file.rvbs01,
    rvbs02 LIKE rvbs_file.rvbs02,
    rvbs103 LIKE rvbs_file.rvbs03,
    rvbs104 LIKE rvbs_file.rvbs04,
    rvbs106 LIKE rvbs_file.rvbs06,
    rvbs021 LIKE rvbs_file.rvbs021,
    rvbs203 LIKE rvbs_file.rvbs03,
    rvbs204 LIKE rvbs_file.rvbs04,
    rvbs206 LIKE rvbs_file.rvbs06,
    rvv031 LIKE rvv_file.rvv031,
    ima021 LIKE ima_file.ima021,
    rvv35 LIKE rvv_file.rvv35,
    img09 LIKE img_file.img09,
    rvv17 LIKE rvv_file.rvv17
END RECORD

#FUN-C70071-----ADD----STR-----
TYPE sr3_t RECORD
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
    rvvslk31 LIKE rvvslk_file.rvvslk31
END RECORD

TYPE sr4_t RECORD
    imx01    LIKE imx_file.imx01, 
    number1  LIKE type_file.num5,
    number2  LIKE type_file.num5,
    number3  LIKE type_file.num5,
    number4  LIKE type_file.num5,
    number5  LIKE type_file.num5,
    number6  LIKE type_file.num5,
    number7  LIKE type_file.num5,
    number8  LIKE type_file.num5,
    number9  LIKE type_file.num5,
    number10 LIKE type_file.num5,
    number11 LIKE type_file.num5,
    number12 LIKE type_file.num5,
    number13 LIKE type_file.num5,
    number14 LIKE type_file.num5,
    number15 LIKE type_file.num5,
    rvvslk01 LIKE rvvslk_file.rvvslk01,
    rvvslk02 LIKE rvvslk_file.rvvslk02,
    rvvslk31 LIKE rvvslk_file.rvvslk31
END RECORD
#FUN-C70071-----ADD-----END----
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   LET g_prog  = ARG_VAL(1)
   LET g_rvu00 = ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)            # Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET g_prtway = ARG_VAL(7)
   LET g_copies = ARG_VAL(8)
   LET tm.wc = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)
   LET tm.b = ARG_VAL(11)   #No.FUN-860026   #FUN-C10036 15->11
   LET tm.c = ARG_VAL(16)        #FUN-C70071---ADD---
   LET g_rep_user = ARG_VAL(12)  #FUN-C10036 11->12
   LET g_rep_clas = ARG_VAL(13)  #FUN-C10036 12->13
   LET g_template = ARG_VAL(14)  #FUN-C10036 13->14
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078       #FUN-C10036 14->15
   LET g_rvu00_o = g_rvu00   #TQC-740294 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   LET g_sql ="rvu00.rvu_file.rvu00,",
              "rvu01.rvu_file.rvu01,",
              "rvu02.rvu_file.rvu02,",
              "rvu03.rvu_file.rvu03,",
              "rvu04.rvu_file.rvu04,",
              "rvu05.rvu_file.rvu05,",
              "rvu06.rvu_file.rvu06,",
              "gem02.gem_file.gem02,",
              "rvu07.rvu_file.rvu07,",
              "gen02.gen_file.gen02,",
              "rvu08.rvu_file.rvu08,",
              "rvu09.rvu_file.rvu09,",
              "rvv02.rvv_file.rvv02,",
              "rvv05.rvv_file.rvv05,",
              "rvv31.rvv_file.rvv31,",
              "rvv031.rvv_file.rvv031,",
              "rvv34.rvv_file.rvv34,",
              "rvv32.rvv_file.rvv32,",
              "rvv33.rvv_file.rvv33,",
              "rvv17.rvv_file.rvv17,",
              "rvv35.rvv_file.rvv35,",
              "rvv36.rvv_file.rvv36,",
              "rvv18.rvv_file.rvv18,",
              "rvv37.rvv_file.rvv37,",
              "rvv25.rvv_file.rvv25,",
              "azf03.azf_file.azf03,",
              "rvv26.rvv_file.rvv26,",
              "rvv80.rvv_file.rvv80,",
              "rvv82.rvv_file.rvv82,",
              "rvv83.rvv_file.rvv83,",
              "rvv85.rvv_file.rvv85,",
              "ima021.ima_file.ima021,",
              "str2.type_file.chr1000,",
              "gfe03.gfe_file.gfe03,",
              "str.type_file.chr1000,",
              "sma115.sma_file.sma115,",   #No.FUN-860026
              "flag.type_file.num5,",        #No.FUN-860026
              "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
              "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
              "sign_show.type_file.chr1,",                       #FUN-C40019 add
              "sign_str.type_file.chr1000"                       #FUN-C40019 add
   LET l_table = cl_prt_temptable('apmg630',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)     #FUN-B40087 #FUN-C70071--ADD L_TABLE2,L_TABLE3
      EXIT PROGRAM END IF
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs103.rvbs_file.rvbs03,",                                                                                         
               "rvbs104.rvbs_file.rvbs04,",                                                                                         
               "rvbs106.rvbs_file.rvbs06,",                                                                                         
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "rvbs203.rvbs_file.rvbs03,",                                                                                         
               "rvbs204.rvbs_file.rvbs04,",                                                                                         
               "rvbs206.rvbs_file.rvbs06,",                                                                                         
               "rvv031.rvv_file.rvv031,",                                                                                           
               "ima021.ima_file.ima021,",                                                                                           
               "rvv35.rvv_file.rvv35,",                                                                                             
               "img09.img_file.img09,",                                                                                             
               "rvv17.rvv_file.rvv17"  
   LET l_table1 = cl_prt_temptable('apmg6301',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)     #FUN-B40087 #FUN-C70071--ADD L_TABLE2,L_TABLE3
       EXIT PROGRAM 
   END IF
#FUN-C70071-----ADD----STR-----
    LET g_sql="agd03_1.agd_file.agd03,agd03_2.agd_file.agd03,",
             "agd03_3.agd_file.agd03,agd03_4.agd_file.agd03,",
             "agd03_5.agd_file.agd03,agd03_6.agd_file.agd03,",
             "agd03_7.agd_file.agd03,agd03_8.agd_file.agd03,",
             "agd03_9.agd_file.agd03,agd03_10.agd_file.agd03,",
             "agd03_11.agd_file.agd03,agd03_12.agd_file.agd03,",
             "agd03_13.agd_file.agd03,agd03_14.agd_file.agd03,",
             "agd03_15.agd_file.agd03,rvvslk31.rvvslk_file.rvvslk31"
   LET l_table2 = cl_prt_temptable('apmg6302',g_sql) CLIPPED 
   IF l_table2 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM 
   END IF 
   LET g_sql="imx01.imx_file.imx01,number1.type_file.num5,", 
             "number2.type_file.num5,",
             "number3.type_file.num5,",
             "number4.type_file.num5,",
             "number5.type_file.num5,",
             "number6.type_file.num5,",
             "number7.type_file.num5,",
             "number8.type_file.num5,",
             "number9.type_file.num5,",
             "number10.type_file.num5,number11.type_file.num5,",
             "number12.type_file.num5,number13.type_file.num5,",
             "number14.type_file.num5,number15.type_file.num5,",
             "rvvslk01.rvvslk_file.rvvslk01,",
             "rvvslk02.rvvslk_file.rvvslk02,rvvslk31.rvvslk_file.rvvslk31"
   LET l_table3 = cl_prt_temptable('apmg6303',g_sql) CLIPPED 
   IF l_table3 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
      EXIT PROGRAM 
   END IF
   IF g_azw.azw04='2' AND s_industry('slk') AND cl_null(tm.c) THEN
      LET tm.c='Y'
   END IF
#FUN-C70071-----ADD----END-----   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g630_tm(0,0)        # Input print condition
      ELSE CALL g630()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)  #FUN-C70071--ADD L_TABLE2,L_TABLE3
END MAIN
 
FUNCTION g630_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
  DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
         l_program      LIKE zaa_file.zaa01,       #MOD-760106 add
         l_cmd          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
  DEFINE l_msg          STRING                      #TQC-960231
  DEFINE l_msg1         STRING                      #TQC-960354 
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW g630_w AT p_row,p_col WITH FORM "apm/42f/apmg630"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #2004/06/02共用程式時呼叫
   CALL cl_set_locale_frm_name("apmg630")
   CALL cl_ui_init()
   #FUN-C70071------ADD---STR---
   IF s_industry('slk') AND g_azw.azw04='2' THEN
      CALL cl_set_comp_visible("c",TRUE)
      CALL cl_set_comp_visible("more,b",FALSE)
   ELSE
      CALL cl_set_comp_visible("c",FALSE)
      CALL cl_set_comp_visible("more,b",TRUE)
   END IF
   #FUN-C70071----ADD----END----
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '3'
   LET tm.b    = 'N'   #No.FUN-860026
   LET tm.c    = 'Y'   #FUN-C70071---ADD---
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   IF NOT cl_null(g_prog) THEN
      CASE g_prog
        WHEN 'apmg630'
          LET g_rvu00 = '1'
     #  WHEN 'apmr631'         #FUN-C40019 mark
        WHEN 'apmg631'         #FUN-C40019 add
          LET g_rvu00 = '3'    #MOD-940407 
     #  WHEN 'apmr632'         #FUN-C40019 mark
        WHEN 'apmg632'         #FUN-C40019 add
          LET g_rvu00 = '2'    #MOD-940407  
        OTHERWISE EXIT CASE
      END CASE
   END IF
  
  IF g_rvu00 = '3' THEN 
     CALL cl_getmsg('apm-079',g_lang) RETURNING l_msg                                                                              
      CALL cl_set_comp_att_text("rvu01",l_msg CLIPPED)    
  END IF  
  IF g_rvu00 = '2' THEN                                                                                                             
     CALL cl_getmsg('apm-939',g_lang) RETURNING l_msg1                                                                              
     CALL cl_set_comp_att_text("rvu01",l_msg1 CLIPPED)                                                                              
  END IF                                                                                                                            
  
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rvu01,rvu03,rvu04,rvu06,rvu07
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

   #FUN-C90130-----add----str--
   ON ACTION CONTROLP
      CASE
        WHEN INFIELD(rvu01)
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_rvu01_3"
         LET g_qryparam.state = "c"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO rvu01
         NEXT FIELD rvu01
      END CASE
   #FUN-C90130-----add----end--
 
     ON ACTION locale
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3) #FUN-C70071 ADD
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS   #No.FUN-860026 add tm.b#FUN-C70071 ADD TM.C
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]'  OR cl_null(tm.a) THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b   #列印批序號明細                                                                                               
         IF tm.b NOT MATCHES "[YN]" OR cl_null(tm.b)                                                                                
            THEN NEXT FIELD b                                                                                                       
         END IF  
      #FUN-C70051----ADD----STR-----
      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
         END IF
      #FUN-C70051----ADD----END-----   
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            LET l_program = g_prog   #MOD-760106 add
            LET g_prog='apmg630'     #MOD-760106 add
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
            LET g_prog=l_program  #MOD-760106 add
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3) #FUN-C70071--ADD L_TABLE2,L_TABLE3
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmg630'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmg630','9031',1)   #No.FUN-660129
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_prog CLIPPED,"'",    #No.TQC-610085 add
                         " '",g_rvu00 CLIPPED,"'",   #No.TQC-610085 add
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",        #No.FUN-860026 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmg630',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3) #FUN-C70071--ADD--L_TABLE2,L_TABLE3
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g630()
   ERROR ""
END WHILE
   CLOSE WINDOW g630_w
END FUNCTION
 
FUNCTION g630()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_sql     STRING,                        # RDSQL STATEMENT                #MOD-D10175
          l_za05    LIKE type_file.chr1000,        #No.FUN-680136 VARCHAR(40)
          l_program LIKE type_file.chr10,          #No.FUN-680136 VARCHAR(10) #No.TQC-6A0079
          sr               RECORD rvu00 LIKE rvu_file.rvu00,
                                  rvu01 LIKE rvu_file.rvu01,
                                  rvu02 LIKE rvu_file.rvu02,
                                  rvu03 LIKE rvu_file.rvu03,
                                  rvu04 LIKE rvu_file.rvu04,
                                  rvu05 LIKE rvu_file.rvu05,
                                  rvu06 LIKE rvu_file.rvu06,
                                  gem02 LIKE gem_file.gem02,
                                  rvu07 LIKE rvu_file.rvu07,
                                  gen02 LIKE gen_file.gen02,
                                  rvu08 LIKE rvu_file.rvu08,
                                  rvu09 LIKE rvu_file.rvu09,
                                  rvv02 LIKE rvv_file.rvv02,
                                  rvv05 LIKE rvv_file.rvv05,
                                  rvv31 LIKE rvv_file.rvv31,
                                  rvv031 LIKE rvv_file.rvv031,
                                  rvv34 LIKE rvv_file.rvv34,
                                  rvv32 LIKE rvv_file.rvv32,
                                  rvv33 LIKE rvv_file.rvv33,
                                  rvv17 LIKE rvv_file.rvv17,
                                  rvv35 LIKE rvv_file.rvv35,
                                  rvv36 LIKE rvv_file.rvv36,
                                  rvv18 LIKE rvv_file.rvv18,
                                  rvv37 LIKE rvv_file.rvv37,
                                  rvv25 LIKE rvv_file.rvv25,
                                  azf03 LIKE azf_file.azf03,
                                  rvv26 LIKE rvv_file.rvv26,
                                  rvv80 LIKE rvv_file.rvv80,
                                  rvv82 LIKE rvv_file.rvv82,
                                  rvv83 LIKE rvv_file.rvv83,
                                  rvv85 LIKE rvv_file.rvv85
                        END RECORD
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
     DEFINE   flag     LIKE type_file.num5                                                     
     DEFINE l_i,l_cnt          LIKE type_file.num5      #No.FUN-580004 #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580004
     DEFINE l_ima021  LIKE ima_file.ima021
     DEFINE l_str2    LIKE type_file.chr1000
     DEFINE l_ima906  LIKE ima_file.ima906
     DEFINE l_rvv85   LIKE rvv_file.rvv85
     DEFINE l_rvv82   LIKE rvv_file.rvv82
     DEFINE g_str     STRING
     DEFINE l_gfe03   LIKE gfe_file.gfe03
     DEFINE l_str     LIKE type_file.chr1000
     DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add
#FUN-C70071-----ADD-----STR----
   DEFINE l_num_t        RECORD
                  number1       LIKE type_file.num5,
                  number2       LIKE type_file.num5,
                  number3       LIKE type_file.num5,
                  number4       LIKE type_file.num5,
                  number5       LIKE type_file.num5,
                  number6       LIKE type_file.num5,
                  number7       LIKE type_file.num5,
                  number8       LIKE type_file.num5,
                  number9       LIKE type_file.num5,
                  number10      LIKE type_file.num5,
                  number11      LIKE type_file.num5,
                  number12      LIKE type_file.num5,
                  number13      LIKE type_file.num5,
                  number14      LIKE type_file.num5,
                  number15      LIKE type_file.num5
                  END RECORD
                  
DEFINE l_ogbslk03 LIKE ogbslk_file.ogbslk03
DEFINE l_ogb04    LIKE ogb_file.ogb04
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
                 number  LIKE type_file.num5
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
#FUN-C70071-----ADD-----END-----     

 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  #No.FUN-580004
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)   #No.FUN-860026
     CALL cl_del_data(l_table2)   #FUN-C70071---ADD--
     CALL cl_del_data(l_table3)   #FUN-C70071---ADD---
      
     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE  zz01 = g_prog  #No.FUN-860026
     LET l_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)" #No.FUN-860026  #FUN-C40019 add 4?
 
     PREPARE insert_prep FROM l_sql
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"                                                                           
     PREPARE insert_prep1 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)     #FUN-B40087 #FUN-C70071--ADD L_TABLE2,L_TABLE3
        EXIT PROGRAM                                                                          
     END IF 
#FUN-C70071-----ADD-----STR----
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep2 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep2:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM                                                                          
     END IF
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"                                                                                 
     PREPARE insert_prep3 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep3:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3)
        EXIT PROGRAM                                                                          
     END IF
     IF tm.c='N' THEN
#FUN-C70071-----ADD-----END----          
     LET l_sql = "SELECT ",
                 " rvu00, rvu01, rvu02, rvu03, rvu04, rvu05, rvu06, gem02, ",
                 " rvu07, gen02, rvu08, rvu09, rvv02, rvv05, rvv31, rvv031,",
                 " rvv34,rvv32, rvv33, rvv17, rvv35, rvv36, rvv18, rvv37,",
                 " rvv25, azf03, rvv26, ",
                 " rvv80,rvv82,rvv83,rvv85, ",  #No.FUN-580004
                 " ima021,ima906,img09 ",             #FUN-C50003 add
            " FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
	    " LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
	    " ,rvv_file LEFT OUTER JOIN azf_file ON  rvv26=azf01 AND azf02='2' ",
            " LEFT OUTER JOIN ima_file ON ima01=rvv31",           #FUN-C50003 add
            " LEFT OUTER JOIN img_file ON img01=rvv31 AND img02=rvv32 AND img03=rvv33 AND img04=rvv34",  #FUN-C50003 add
	    " WHERE rvu01 = rvv01 AND rvuconf !='X' ",
            "   AND rvu00='",g_rvu00,"' AND ",tm.wc clipped
 
 
     CASE WHEN tm.a ='1' LET l_sql = l_sql CLIPPED, " AND rvuconf ='Y' "
          WHEN tm.a ='2' LET l_sql = l_sql CLIPPED, " AND rvuconf ='N' "
          OTHERWISE EXIT CASE
     END CASE
     LET l_sql = l_sql CLIPPED,"   ORDER BY rvu01,rvv02"   #MOD-7C0035
#FUN-C70071----ADD----STR-----     
     ELSE
        IF s_industry('slk') AND g_azw.azw04='2' THEN
           LET l_sql = "SELECT ",
                 " rvu00, rvu01, rvu02, rvu03, rvu04, rvu05, rvu06, gem02, ",
                 " rvu07, gen02, rvu08, rvu09, rvvslk02, rvvslk05, rvvslk31, rvvslk031,",
                 " rvvslk34,rvvslk32, rvvslk33, rvvslk17, rvvslk35, rvvslk36, '', rvvslk37,",
                 " '', '', '', ",
                 " '','','','', ",
                 " ima021,ima906,'' ",
                 " FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
	             " LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
	             " ,rvvslk_file  ",
                 " LEFT OUTER JOIN ima_file ON ima01=rvvslk31",
	             " WHERE rvu01 = rvvslk01 AND rvuconf !='X' ",
                 "   AND rvu00='",g_rvu00,"' AND ",tm.wc CLIPPED
 
 
           CASE WHEN tm.a ='1' LET l_sql = l_sql CLIPPED, " AND rvuconf ='Y' "
                WHEN tm.a ='2' LET l_sql = l_sql CLIPPED, " AND rvuconf ='N' "
                OTHERWISE EXIT CASE
           END CASE
           LET l_sql = l_sql CLIPPED,"   ORDER BY rvu01,rvvslk02"
        ELSE
           LET l_sql = "SELECT ",
                 " rvu00, rvu01, rvu02, rvu03, rvu04, rvu05, rvu06, gem02, ",
                 " rvu07, gen02, rvu08, rvu09, rvv02, rvv05, rvv31, rvv031,",
                 " rvv34,rvv32, rvv33, rvv17, rvv35, rvv36, rvv18, rvv37,",
                 " rvv25, azf03, rvv26, ",
                 " rvv80,rvv82,rvv83,rvv85, ",
                 " ima021,ima906,img09 ",
                 " FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
	             " LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
	             " ,rvv_file LEFT OUTER JOIN azf_file ON  rvv26=azf01 AND azf02='2' ",
                 " LEFT OUTER JOIN ima_file ON ima01=rvv31",
                 " LEFT OUTER JOIN img_file ON img01=rvv31 AND img02=rvv32 AND img03=rvv33 AND img04=rvv34",
	             " WHERE rvu01 = rvv01 AND rvuconf !='X' ",
                 "   AND rvu00='",g_rvu00,"' AND ",tm.wc CLIPPED
 
 
           CASE WHEN tm.a ='1' LET l_sql = l_sql CLIPPED, " AND rvuconf ='Y' "
                WHEN tm.a ='2' LET l_sql = l_sql CLIPPED, " AND rvuconf ='N' "
                OTHERWISE EXIT CASE
           END CASE
           LET l_sql = l_sql CLIPPED,"   ORDER BY rvu01,rvv02"
        END IF
     END IF
#FUN-C70071-----ADD----END-------     
      
     PREPARE g630_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3) #FUN-C70071---ADD L_TABLE2,L_TABLE3
        EXIT PROGRAM
     END IF
     DECLARE g630_curs1 CURSOR FOR g630_prepare1
 
     LET l_program = g_prog
     LET g_prog='apmg630'
     
     #FUN-C50003---add---str--
     DECLARE r920_d  CURSOR  FOR
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file
                  WHERE rvbs01 = ? AND rvbs02 = ? 
                  ORDER BY  rvbs04
     #FUN-C50003---add---end--
 
     FOREACH g630_curs1 INTO sr.*,l_ima021,l_ima906,l_img09     #FUN-C50003 add l_ima021,l_ima906,l_img09
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
  #   SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file        #FUN-C50003 mark
  #                      WHERE ima01=sr.rvv31                          #FUN-C50003 mark 
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                LET l_str2 = l_rvv85 , sr.rvv83  CLIPPED
                IF cl_null(sr.rvv85) OR sr.rvv85  = 0 THEN
                    CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                    LET l_str2 = l_rvv82,sr.rvv80  CLIPPED
                ELSE
                   IF NOT cl_null(sr.rvv82) AND sr.rvv82 > 0 THEN
                      CALL cl_remove_zero(sr.rvv82) RETURNING l_rvv82
                      LET l_str2 = l_str2 CLIPPED,',',l_rvv82,sr.rvv80  CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.rvv85) AND sr.rvv85 > 0 THEN
                    CALL cl_remove_zero(sr.rvv85) RETURNING l_rvv85
                    LET l_str2 = l_rvv85 , sr.rvv83  CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      SELECT gfe03 INTO l_gfe03 FROM gfe_file 
       WHERE gfe01 = sr.rvv35
      IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
        LET l_gfe03 = 0
      END IF
      LET flag = 0                                                                                  
      #FUN-C50003-----mark---str---
      # SELECT img09 INTO l_img09  FROM img_file WHERE img01 = sr.rvv31                                                             
      #        AND img02 = sr.rvv32 AND img03 = sr.rvv33                                                                            
      #        AND img04 = sr.rvv34                                                                                                 
      # DECLARE r920_d  CURSOR  FOR                                                                                                     
      #    SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
      #           WHERE rvbs01 = sr.rvu01 AND rvbs02 = sr.rvv02                                                                     
      #           ORDER BY  rvbs04                                                                                                  
      #FUN-C50003-----mark---str---
    LET m = 0 LET i=0 LET j=0                                                                                                       
    CALL rvbs1.clear()   #MOD-A40062
    CALL rvbs2.clear()   #MOD-A40062
    FOREACH  r920_d USING sr.rvu01,sr.rvv02 INTO l_rvbs.*            #FUN-C50003 add USING sr.rvu01,sr.rvv02                   
     LET flag = 1                                                                    
      LET m=m+1                                                                                                                     
      IF (m mod 2) = 1  THEN                                                                                                        
         LET i=i+1                                                                                                                  
         #INITIALIZE rvbs1[i].* TO NULL    #MOD-A40062                                                                                            
         LET rvbs1[i].rvbs03 = l_rvbs.rvbs03                                                                                        
         LET rvbs1[i].rvbs04 = l_rvbs.rvbs04                                                                                        
         LET rvbs1[i].rvbs06 = l_rvbs.rvbs06                                                                                        
      ELSE                 
         LET j=j+1                                                                                                                  
         #INITIALIZE rvbs2[j].* TO NULL     #MOD-A40062                                                                                         
         LET rvbs2[j].rvbs03 = l_rvbs.rvbs03                                                                                        
         LET rvbs2[j].rvbs04 = l_rvbs.rvbs04                                                                                        
         LET rvbs2[j].rvbs06 = l_rvbs.rvbs06                                                                                        
      END IF                                                                                                                        
    END FOREACH                                                                                                                     
      IF i>j THEN LET k=i ELSE LET k=j END IF                                                                                       
      FOR i=1 TO k                                                                                                                  
         EXECUTE insert_prep1 USING  sr.rvu01,sr.rvv02,rvbs1[i].rvbs03,                                                             
                                     rvbs1[i].rvbs04,rvbs1[i].rvbs06,l_rvbs.rvbs021,                                                
                                     rvbs2[i].rvbs03,rvbs2[i].rvbs04,rvbs2[i].rvbs06,                                               
                                     sr.rvv031,l_ima021,sr.rvv35,l_img09,sr.rvv17                                                   
      END FOR                                                                                                                       
      CALL s_prtype(sr.rvu08) RETURNING l_str
        EXECUTE insert_prep USING sr.*,l_ima021,l_str2,l_gfe03,l_str,g_sma115,flag,  #No.FUN-860026
                                  "",l_img_blob,"N",""    #FUN-C40019 add

#FUN-C70051-----ADD----STR----
      SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr.rvv31
      IF l_ima151='Y' AND tm.c='Y' AND sr.rvv17>0 THEN
         LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",sr.rvv31,"'",
               "   AND imx02=agd02",
               "   AND agd01 IN ",
               " (SELECT ima941 FROM ima_file WHERE ima01='",sr.rvv31,"')",
               " ORDER BY agd04"
           PREPARE g630_sr2_pre FROM l_sql
           DECLARE g630_sr2_cs CURSOR FOR g630_sr2_pre 
           LET l_imx02 = NULL 
           INITIALIZE l_imx_t.* TO NULL
           LET l_i = 1
           FOR l_i = 1 TO 15
               LET l_imx[l_i].imx01 =NULL
           END FOR
           LET l_i = 1
           FOREACH g630_sr2_cs INTO l_imx02,l_agd04
              LET l_imx[l_i].imx01=' '  
              SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
               WHERE agd01 = ima941 AND agd02 = l_imx02 
                 AND ima01 = sr.rvv31 
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
           EXECUTE insert_prep2 USING 
           l_imx_t.*,sr.rvv31
#子報表2
           LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
                " WHERE imx00 = '",sr.rvv31,"'",
               "   AND imx01=agd02",
               "   AND agd01 IN ",
               " (SELECT ima940 FROM ima_file WHERE ima01='",sr.rvv31,"')",
               " ORDER BY agd04"
           PREPARE g630_colslk_pre FROM l_sql
           DECLARE g630_colslk_cs CURSOR FOR g630_colslk_pre
           LET l_imx01 = NULL

           FOREACH g630_colslk_cs INTO l_imx01,l_agd04
              SELECT agd03 INTO l_agd03 FROM agd_file,ima_file
               WHERE agd01 = ima940 AND agd02 = l_imx01
                 AND ima01 = sr.rvv31 
   
              LET l_sql2 = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
                   " WHERE imx00 = '",sr.rvv31,"'",
                   "   AND imx02=agd02",
                   "   AND agd01 IN ",
                   " (SELECT ima941 FROM ima_file WHERE ima01='",sr.rvv31,"')",
                   " ORDER BY agd04"
              PREPARE g630_sr3_pre FROM l_sql2
              DECLARE g630_sr3_cs CURSOR FOR g630_sr3_pre
              LET l_imx02 = NULL
              LET l_i = 1
              FOR l_i = 1 TO 15
                  LET l_num[l_i].number =NULL
              END FOR
              LET l_i = 1
              FOREACH g630_sr3_cs INTO l_imx02,l_agd04
                 LET l_imx[l_i].imx01=' '
                 SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
                  WHERE agd01 = ima941 AND agd02 = l_imx02
                    AND ima01 = sr.rvv31
          
                 SELECT sma46 INTO l_ps FROM sma_file
                 IF cl_null(l_ps) THEN LET l_ps = ' ' END IF
                 LET l_ima01 = sr.rvv31,l_ps,l_imx01,l_ps,l_imx02
                 SELECT count(*) INTO l_n FROM rvv_file WHERE rvv01=sr.rvu01 AND rvv31=l_ima01
                 IF l_n>0 THEN
                    SELECT rvv17 INTO l_num[l_i].number
                      FROM rvv_file,rvvslk_file,rvvi_file 
                     WHERE rvv01=rvvi01 AND rvv02=rvvi02
                       AND rvvslk01=rvvi01 AND rvvislk02=sr.rvv02
                       AND rvv01=sr.rvu01 AND rvv31=l_ima01
                 ELSE
                    LET l_num[l_i].number=0
                 END IF     
                 LET l_i=l_i+1   
                 LET l_imx02=null 
              END FOREACH
              LET l_num_t.number1=l_num[1].number
              LET l_num_t.number2=l_num[2].number
              LET l_num_t.number3=l_num[3].number
              LET l_num_t.number4=l_num[4].number
              LET l_num_t.number5=l_num[5].number
              LET l_num_t.number6=l_num[6].number
              LET l_num_t.number7=l_num[7].number 
              LET l_num_t.number8=l_num[8].number
              LET l_num_t.number9=l_num[9].number
              LET l_num_t.number10=l_num[10].number
              LET l_num_t.number11=l_num[11].number
              LET l_num_t.number12=l_num[12].number 
              LET l_num_t.number13=l_num[13].number
              LET l_num_t.number14=l_num[14].number
              LET l_num_t.number15=l_num[15].number
              IF cl_null(l_num_t.number1) THEN LET l_num_t.number1=0 END IF
              IF cl_null(l_num_t.number2) THEN LET l_num_t.number2=0 END IF
              IF cl_null(l_num_t.number3) THEN LET l_num_t.number3=0 END IF
              IF cl_null(l_num_t.number4) THEN LET l_num_t.number4=0 END IF
              IF cl_null(l_num_t.number5) THEN LET l_num_t.number5=0 END IF
              IF cl_null(l_num_t.number6) THEN LET l_num_t.number6=0 END IF
              IF cl_null(l_num_t.number7) THEN LET l_num_t.number7=0 END IF
              IF cl_null(l_num_t.number8) THEN LET l_num_t.number8=0 END IF
              IF cl_null(l_num_t.number9) THEN LET l_num_t.number9=0 END IF
              IF cl_null(l_num_t.number10) THEN LET l_num_t.number10=0 END IF
              IF cl_null(l_num_t.number11) THEN LET l_num_t.number11=0 END IF
              IF cl_null(l_num_t.number12) THEN LET l_num_t.number12=0 END IF
              IF cl_null(l_num_t.number13) THEN LET l_num_t.number13=0 END IF
              IF cl_null(l_num_t.number14) THEN LET l_num_t.number14=0 END IF
              IF cl_null(l_num_t.number15) THEN LET l_num_t.number15=0 END IF
              IF  l_num_t.number1=0 AND l_num_t.number2=0 AND
              l_num_t.number3=0 AND l_num_t.number4=0 AND
              l_num_t.number5=0 AND l_num_t.number6=0 AND 
              l_num_t.number7=0 AND
              l_num_t.number8=0 AND
              l_num_t.number9=0 AND
              l_num_t.number10=0 AND 
              l_num_t.number11=0 AND
              l_num_t.number12=0 AND
              l_num_t.number13=0 AND
              l_num_t.number14=0 AND
              l_num_t.number15=0 THEN
                 CONTINUE FOREACH
              ELSE 
                 EXECUTE insert_prep3 USING 
              l_imx01,l_num_t.*,sr.rvu01,sr.rvv02,sr.rvv31
              END IF
           END FOREACH 
        END IF
#FUN-C70051------ADD----END----                      
     END FOREACH
###GENGRE###     LET l_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED   #No.FUN-860026 
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'rvu01,rvu03,rvu04,rvu06,rvu07')
             RETURNING tm.wc
     ELSE
        LET tm.wc = ' '
     END IF
     LET g_str = tm.wc      
     #FUN-C40019 -----add---str---
     CASE g_rvu00
       WHEN '1'
         LET g_prog = 'apmg630'
       WHEN '2'    
         LET g_prog = 'apmg631'
       WHEN '3'      
         LET g_prog = 'apmg632'   
       OTHERWISE EXIT CASE
     END CASE
     #FUN-C40019 -----add---end---
     LET g_prog = 'apmg630' #FUN-C40019

     LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
     LET g_cr_apr_key_f = "rvu01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
###GENGRE###     LET g_str = g_str,";",g_rvu00_o,";",tm.b   #TQC-740294 add #No.FUN-80026 add tm.b
###GENGRE###     CALL cl_prt_cs3('apmg630','apmg630',l_sql,g_str)
#FUN-C70071-----ADD----STR---
     IF s_industry('slk') AND g_azw.azw04='2' AND tm.c='Y' THEN
        LET g_template="apmg630_slk"
        CALL apmg630_slk_grdata()
     ELSE 
        LET g_template="apmg630"  
#FUN-C70071-----ADD----END---
        CALL apmg630_grdata()    ###GENGRE###
     END IF                    #FUN-C70071-----ADD
     LET g_prog=l_program   #TQC-740294 add
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

###GENGRE###START
FUNCTION apmg630_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("apmg630")
        IF handler IS NOT NULL THEN
            START REPORT apmg630_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY rvu01,rvv02"
            DECLARE apmg630_datacur1 CURSOR FROM l_sql
            FOREACH apmg630_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg630_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg630_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg630_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40087---------add------str-----
    DEFINE l_rvu04_rvu05     STRING
    DEFINE l_rvu06_gem02     STRING
    DEFINE l_rvu07_gen02     STRING
    DEFINE l_rvu08           STRING
    DEFINE l_rvv26_azf03     STRING
    DEFINE l_sql             STRING
    DEFINE l_rvv32_33_34     STRING
    DEFINE l_rvv17_fmt       STRING
    DEFINE l_flag            LIKE type_file.num5
    #FUN-B40087---------add------end-----
    DEFINE l_str2            STRING
    DEFINE l_display1        LIKE type_file.chr1 #DEV-D40005
    
    ORDER EXTERNAL BY sr1.rvu01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.rvu01
            LET l_lineno = 0
            #DEV-D40005--begin
            IF g_aza.aza131 = 'Y' THEN
               LET l_display1 = 'Y'
            ELSE
               LET l_display1 = 'N'
            END IF
            PRINTX l_display1
            #DEV-D40005--end

            #FUN-B40087---------add------str-----
            LET l_rvv17_fmt = cl_gr_numfmt('rvv_file','rvv17',sr1.gfe03)
            PRINTX l_rvv17_fmt

            LET l_rvu04_rvu05 = sr1.rvu04,' ',sr1.rvu05
            PRINTX l_rvu04_rvu05
            LET l_rvu06_gem02 = sr1.rvu06,' ',sr1.gem02
            PRINTX l_rvu06_gem02
            IF NOT cl_null(sr1.rvu07) AND NOT cl_null(sr1.gen02) THEN
               LET l_rvu07_gen02 = sr1.rvu07,' ',sr1.gen02
            ELSE IF cl_null(sr1.rvu07) AND NOT cl_null(sr1.gen02) THEN
                    LET l_rvu07_gen02 = sr1.gen02
                 ELSE IF NOT cl_null(sr1.rvu07) AND cl_null(sr1.gen02) THEN
                         LET l_rvu07_gen02 =sr1.rvu07
                      END IF
                 END IF
            END IF 
            PRINTX l_rvu07_gen02
            LET l_rvu08 = sr1.rvu08,' ',sr1.str
            PRINTX l_rvu08
            #FUN-B40087---------add------end-----

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-C50140---add---str-------
            LET l_str2 = cl_gr_getmsg('gre-268',g_lang,sr1.sma115)
            PRINTX l_str2
            #FUN-C50140---add---end-------

            #FUN-B40087---------add------str-----
            LET l_sql = "SELECT MAX(flag) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE rvu01='",sr1.rvu01 CLIPPED,"'"
            PREPARE l_prep1 FROM l_sql
            EXECUTE l_prep1 INTO l_flag
            PRINTX l_flag            

            IF NOT cl_null(sr1.rvv26) THEN 
               LET l_rvv26_azf03 = sr1.rvv26,' ',sr1.azf03
            END IF     
            PRINTX l_rvv26_azf03
            LET l_rvv32_33_34 = '(',sr1.rvv32,'/',sr1.rvv33,'/',sr1.rvv34,')'
            PRINTX l_rvv32_33_34
            #FUN-B40087---------add------end-----

            PRINTX sr1.*

        AFTER GROUP OF sr1.rvu01
            #FUN-B40087---------add------str-----
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE rvbs01 = '",sr1.rvu01 CLIPPED,"'",
                        " AND rvbs02 = ",sr1.rvv02 CLIPPED
            START REPORT apmg630_subrep01
            DECLARE apmg630_repcur1 CURSOR FROM l_sql
            FOREACH apmg630_repcur1 INTO sr2.*
                OUTPUT TO REPORT apmg630_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT apmg630_subrep01
            #FUN-B40087---------add------end-----

        
        ON LAST ROW

END REPORT

#FUN-C70071-----ADD----STR----
FUNCTION apmg630_slk_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("apmg630")
        IF handler IS NOT NULL THEN
            START REPORT apmg630_slk_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY rvu01,rvv02"
            DECLARE apmg630_slk_datacur1 CURSOR FROM l_sql
            FOREACH apmg630_slk_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg630_slk_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg630_slk_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg630_slk_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE l_display         LIKE type_file.chr1 
    DEFINE l_ima151          LIKE ima_file.ima151
    DEFINE l_lineno          LIKE type_file.num5
    DEFINE l_rvu04_rvu05     STRING
    DEFINE l_rvu06_gem02     STRING
    DEFINE l_rvu07_gen02     STRING
    DEFINE l_rvu08           STRING
    DEFINE l_rvv26_azf03     STRING
    DEFINE l_sql             STRING
    DEFINE l_rvv32_33_34     STRING
    DEFINE l_rvv17_fmt       STRING
    DEFINE l_flag            LIKE type_file.num5
    DEFINE l_str2            STRING
    
    ORDER EXTERNAL BY sr1.rvu01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.rvu01
            LET l_lineno = 0
            #FUN-B40087---------add------str-----
            LET l_rvv17_fmt = cl_gr_numfmt('rvv_file','rvv17',sr1.gfe03)
            PRINTX l_rvv17_fmt

            LET l_rvu04_rvu05 = sr1.rvu04,' ',sr1.rvu05
            PRINTX l_rvu04_rvu05
            LET l_rvu06_gem02 = sr1.rvu06,' ',sr1.gem02
            PRINTX l_rvu06_gem02
            IF NOT cl_null(sr1.rvu07) AND NOT cl_null(sr1.gen02) THEN
               LET l_rvu07_gen02 = sr1.rvu07,' ',sr1.gen02
            ELSE IF cl_null(sr1.rvu07) AND NOT cl_null(sr1.gen02) THEN
                    LET l_rvu07_gen02 = sr1.gen02
                 ELSE IF NOT cl_null(sr1.rvu07) AND cl_null(sr1.gen02) THEN
                         LET l_rvu07_gen02 =sr1.rvu07
                      END IF
                 END IF
            END IF 
            PRINTX l_rvu07_gen02
            LET l_rvu08 = sr1.rvu08,' ',sr1.str
            PRINTX l_rvu08
            #FUN-B40087---------add------end-----

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-C50140---add---str-------
            LET l_str2 = cl_gr_getmsg('gre-268',g_lang,sr1.sma115)
            PRINTX l_str2
            #FUN-C50140---add---end-------

            #FUN-B40087---------add------str-----
            LET l_sql = "SELECT MAX(flag) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE rvu01='",sr1.rvu01 CLIPPED,"'"
            PREPARE l_slkprep1 FROM l_sql
            EXECUTE l_slkprep1 INTO l_flag
            PRINTX l_flag            

            IF NOT cl_null(sr1.rvv26) THEN 
               LET l_rvv26_azf03 = sr1.rvv26,' ',sr1.azf03
            END IF     
            PRINTX l_rvv26_azf03
            LET l_rvv32_33_34 = '(',sr1.rvv32,'/',sr1.rvv33,'/',sr1.rvv34,')'
            PRINTX l_rvv32_33_34
            #FUN-B40087---------add------end-----

            PRINTX sr1.*

            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr1.rvv31
            IF tm.c='Y' AND l_ima151='Y' AND sr1.rvv17>0 THEN
               LET l_display = 'Y'
            ELSE 
               LET l_display = 'N'
            END IF 
            PRINTX l_display   
            LET l_sql = "SELECT distinct * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE rvvslk31 = '",sr1.rvv31 CLIPPED,"'"
               START REPORT apmg630_subrep02
               DECLARE apmg630_repcur2 CURSOR FROM l_sql
               FOREACH apmg630_repcur2 INTO sr3.*
                  OUTPUT TO REPORT apmg630_subrep02(sr3.*)
               END FOREACH
               FINISH REPORT apmg630_subrep02

#子報表2
               LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE rvvslk01 = '",sr1.rvu01 CLIPPED,"'",
                        " AND rvvslk02 = ",sr1.rvv02 CLIPPED
               START REPORT apmg630_subrep03
               DECLARE apmg630_repcur3 CURSOR FROM l_sql
               FOREACH apmg630_repcur3 INTO sr4.*
                   OUTPUT TO REPORT apmg630_subrep03(sr4.*,sr3.*)
               END FOREACH
               FINISH REPORT apmg630_subrep03
               
        AFTER GROUP OF sr1.rvu01
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE rvbs01 = '",sr1.rvu01 CLIPPED,"'",
                        " AND rvbs02 = ",sr1.rvv02 CLIPPED
            START REPORT apmg630_subrep01
            DECLARE apmg630_slkrepcur1 CURSOR FROM l_sql
            FOREACH apmg630_slkrepcur1 INTO sr2.*
                OUTPUT TO REPORT apmg630_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT apmg630_subrep01

        
        ON LAST ROW

END REPORT

REPORT apmg630_subrep02(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*

END REPORT
REPORT apmg630_subrep03(sr4,sr3)
    DEFINE sr4 sr4_t
    DEFINE sr3 sr3_t
    DEFINE l_color  LIKE agd_file.agd03

    FORMAT
        ON EVERY ROW
        SELECT agd03 INTO l_color FROM agd_file,ima_file
           WHERE agd01 = ima940 AND agd02 = sr4.imx01
             AND ima01 = sr4.rvvslk31
            PRINTX l_color 
            PRINTX sr4.*
            PRINTX sr3.* 
END REPORT
#FUN-C70071-----ADD----END----

#FUN-B40087---------add------str-----
REPORT apmg630_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_rvbs06_sum LIKE rvbs_file.rvbs06
    DEFINE l_sum1       LIKE rvbs_file.rvbs06
    DEFINE l_sum2       LIKE rvbs_file.rvbs06

    ORDER EXTERNAL BY sr2.rvbs02

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*

        AFTER GROUP OF sr2.rvbs02
            LET l_sum1 = GROUP SUM(sr2.rvbs106) 
            LET l_sum2 = GROUP SUM(sr2.rvbs206)
            IF NOT cl_null(sr2.rvbs106) AND NOT cl_null(sr2.rvbs206) THEN
               LET l_rvbs06_sum = l_sum1 + l_sum2 
            ELSE
               IF cl_null(sr2.rvbs206) THEN
                  LET l_rvbs06_sum = l_sum1 
               END IF
            END IF
            PRINTX l_rvbs06_sum


END REPORT
#FUN-B40087---------add------end-----
###GENGRE###END
