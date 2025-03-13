# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: apmr630.4gl
# Descriptions...: 採購庫存異動單據列印
# Date & Author..: 97/07/09  By  Kitty
#
# Modify.........: No:8322 03/09/25 By Mandy l_sql中azf02='2'在.ora要改為azf_file.azf02='2'才對
# Modify.........: No.MOD-530070 05/03/24 By Mandy 異動數量欄位請放大
# Modify.........: NO.FUN-550060 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-570174 05/07/19 By yoyo 項次欄位增大
# Modify.........: No.FUN-580004 05/08/03 By day 報表轉xml
# Modify.........: No.MOD-580395 05/09/08 By echo apmr631,apmr632列印時串apmr630
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
# Modify.........: No.TQC-740294 07/06/04 By Sarah apmr630/apmr631/apmr632共用程式,630以外的報表出表有問題
# Modify.........: No.MOD-760106 07/06/23 By claire 不可將參數default給值及修背景時傳入程式名
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.MOD-7C0035 07/12/05 By claire 調整語法FUN-710091
# Modify.........: No.FUN-860026 08/07/15 By baofei 增加子報表-列印批序號明細
# Modify.........: No.MOD-850291 08/05/28 By chenl  根據p_grog對g_rvu00異動類型進行賦值。
# Modify.........: NO.MOD-940407 09/04/30 By lutingting apmr631資料來源應該是采購倉退rvu00='3'
# Modify.........: NO.TQC-960231 09/06/19 By lilingyu apmr630畫面rvu01字段名稱顯示錯誤
# Modify.........: NO.TQC-960354 09/06/25 By sherry apmr632畫面rvu01字段名稱顯示錯誤  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:MOD-A40062 10/04/14 By Smapmin 批序號的資料呈現有誤
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-B90025 11/09/06 By johung 修改接外部參數順序
# Modify.........: No:FUN-BA0078 11/11/04 By huangtao CR報表列印EF簽核圖檔 OR TIPTOP自訂簽核欄位
# Modify.........: No:TQC-C10039 12/01/12 By minpp  CR报表列印TIPTOP与EasyFlow签核图片修改 
# Modify.........: No:TQC-C60078 12/06/08 By yangtt rvu01欄位添加開窗功能 
# Modify.........: No.MOD-D10175 13/01/31 By Elise 將tm.wc、l_sql定義為STRING

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
            #wc        LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(600)     # Where condition #MOD-D10175 mark
             wc        STRING,                   #MOD-D10175 add
             a         LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)       # 選擇(1)已列印 (2)未列印 (3)全部
             b         LIKE type_file.chr1,      #No.FUN-860026  
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
   LET tm.b = ARG_VAL(11)   #No.FUN-860026   #MOD-B90025 15->11
   LET g_rep_user = ARG_VAL(12)  #MOD-B90025 11->12
   LET g_rep_clas = ARG_VAL(13)  #MOD-B90025 12->13
   LET g_template = ARG_VAL(14)  #MOD-B90025 13->14
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078       #MOD-B90025 14->15
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
              "sign_type.type_file.chr1,", #FUN-BA0078 add
              "sign_img.type_file.blob,",  #FUN-BA0078 add
              "sign_show.type_file.chr1,",   #FUN-BA0078 add
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
   LET l_table = cl_prt_temptable('apmr630',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
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
   LET l_table1 = cl_prt_temptable('apmr6301',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF     
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r630_tm(0,0)        # Input print condition
      ELSE CALL r630()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r630_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
  DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
         l_program      LIKE zaa_file.zaa01,       #MOD-760106 add
         l_cmd          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
  DEFINE l_msg          STRING                      #TQC-960231
  DEFINE l_msg1         STRING                      #TQC-960354 
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r630_w AT p_row,p_col WITH FORM "apm/42f/apmr630"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   #2004/06/02共用程式時呼叫
   CALL cl_set_locale_frm_name("apmr630")
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '3'
   LET tm.b    = 'N'   #No.FUN-860026
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   IF NOT cl_null(g_prog) THEN
      CASE g_prog
        WHEN 'apmr630'
          LET g_rvu00 = '1'
        WHEN 'apmr631'
          LET g_rvu00 = '3'    #MOD-940407 
        WHEN 'apmr632'
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
 
   #TQC-C60078-----add----str--
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
   #TQC-C60078-----add----end--

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
      LET INT_FLAG = 0 CLOSE WINDOW r630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS   #No.FUN-860026 add tm.b
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
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            LET l_program = g_prog   #MOD-760106 add
            LET g_prog='apmr630'     #MOD-760106 add
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
      LET INT_FLAG = 0 CLOSE WINDOW r630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr630'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr630','9031',1)   #No.FUN-660129
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
         CALL cl_cmdat('apmr630',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r630()
   ERROR ""
END WHILE
   CLOSE WINDOW r630_w
END FUNCTION
 
FUNCTION r630()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,        # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000) #MOD-D10175 makr
          l_sql     STRING,                        # RDSQL STATEMENT                #MOD-D10175 add 
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
#TQC-C10039--MOD--STR--
     #FUN-BA0078 START
     DEFINE l_img_blob         LIKE type_file.blob
#    DEFINE l_ii               INTEGER 
#    DEFINE l_key              RECORD 
#           v1                 LIKE rvu_file.rvu01
#           END RECORD 
#    #FUN-BA0078 END 
#TQC-C10039--MOD--END--     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  #No.FUN-580004
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)   #No.FUN-860026 

     LOCATE l_img_blob IN MEMORY      #FUN-BA0078 add
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE  zz01 = g_prog  #No.FUN-860026
     LET l_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"  #FUN-BA0078 add 3? #No.FUN-860026   #TQC-C10039 ADD 1？
 
     PREPARE insert_prep FROM l_sql
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"                                                                           
     PREPARE insert_prep1 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM                                                                          
     END IF         
     LET l_sql = "SELECT ",
                 " rvu00, rvu01, rvu02, rvu03, rvu04, rvu05, rvu06, gem02, ",
                 " rvu07, gen02, rvu08, rvu09, rvv02, rvv05, rvv31, rvv031,",
                 " rvv34,rvv32, rvv33, rvv17, rvv35, rvv36, rvv18, rvv37,",
                 " rvv25, azf03, rvv26, ",
                 " rvv80,rvv82,rvv83,rvv85 ",  #No.FUN-580004
            " FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
	    " LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
	    " ,rvv_file LEFT OUTER JOIN azf_file ON  rvv26=azf01 AND azf02='2' ",
	    " WHERE rvu01 = rvv01 AND rvuconf !='X' ",
            "   AND rvu00='",g_rvu00,"' AND ",tm.wc clipped
 
 
     CASE WHEN tm.a ='1' LET l_sql = l_sql CLIPPED, " AND rvuconf ='Y' "
          WHEN tm.a ='2' LET l_sql = l_sql CLIPPED, " AND rvuconf ='N' "
          OTHERWISE EXIT CASE
     END CASE
     LET l_sql = l_sql CLIPPED,"   ORDER BY rvu01,rvv02"   #MOD-7C0035
     PREPARE r630_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r630_curs1 CURSOR FOR r630_prepare1
#TQC-C10039--MARK--STR--     
#    #FUN-BA0078  START
#    LET l_sql = "SELECT ",
#                "rvu01",
#           " FROM rvu_file LEFT OUTER JOIN gem_file ON rvu06=gem01 ",
#           " LEFT OUTER JOIN gen_file ON rvu07=gen01 ",
#           " ,rvv_file LEFT OUTER JOIN azf_file ON  rvv26=azf01 AND azf02='2' ",
#           " WHERE rvu01 = rvv01 AND rvuconf !='X' ",
#           "   AND rvu00='",g_rvu00,"' AND ",tm.wc clipped
#
#    CASE WHEN tm.a ='1' LET l_sql = l_sql CLIPPED, " AND rvuconf ='Y' "
#         WHEN tm.a ='2' LET l_sql = l_sql CLIPPED, " AND rvuconf ='N' "
#         OTHERWISE EXIT CASE
#    END CASE
#    LET l_sql = l_sql CLIPPED,"   ORDER BY rvu01"   #MOD-7C0035
#    PREPARE r630_prepare4 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare4:',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#       EXIT PROGRAM
#    END IF
#    DECLARE r630_curs4 CURSOR FOR r630_prepare4
#    #FUN-BA0078  END 
#TQC-C10039--MARK--END--
     
     LET l_program = g_prog
     LET g_prog='apmr630'
 
     FOREACH r630_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                         WHERE ima01=sr.rvv31
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
        SELECT img09 INTO l_img09  FROM img_file WHERE img01 = sr.rvv31                                                             
               AND img02 = sr.rvv32 AND img03 = sr.rvv33                                                                            
               AND img04 = sr.rvv34                                                                                                 
    DECLARE r920_d  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
                  WHERE rvbs01 = sr.rvu01 AND rvbs02 = sr.rvv02                                                                     
                  ORDER BY  rvbs04                                                                                                  
    LET m = 0 LET i=0 LET j=0                                                                                                       
    CALL rvbs1.clear()   #MOD-A40062
    CALL rvbs2.clear()   #MOD-A40062
    FOREACH  r920_d INTO l_rvbs.*                               
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
        EXECUTE insert_prep USING sr.*,l_ima021,l_str2,l_gfe03,l_str,g_sma115,flag,"",l_img_blob,"N",""  #FUN-BA0078  #No.FUN-860026  #TQC-C10039 add ""
     END FOREACH
     LET l_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED   #No.FUN-860026 
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'rvu01,rvu03,rvu04,rvu06,rvu07')
             RETURNING tm.wc
     ELSE
        LET tm.wc = ' '
     END IF
     LET g_str = tm.wc      
     LET g_str = g_str,";",g_rvu00_o,";",tm.b   #TQC-740294 add #No.FUN-80026 add tm.b
#TQC-C10039--mark--str--
     #FUN-BA0078  START
     LET g_cr_table = l_table
#    LET g_cr_gcx01 = "asmi300"
     LET g_cr_apr_key_f = "rvu01"

#    LET l_ii = 1

#    CALL g_cr_apr_key.clear()  

#    FOREACH r630_curs4 INTO l_key.* 
#      LET g_cr_apr_key[l_ii].v1 = l_key.v1
#      LET l_ii = l_ii + 1 
#    END FOREACH

     #FUN-BA0078  END
#TQC-C10039--mark--end--
     
     CALL cl_prt_cs3('apmr630','apmr630',l_sql,g_str)
     LET g_prog=l_program   #TQC-740294 add
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
