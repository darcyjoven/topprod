# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmr700.4gl
# Descriptions...: 銷退單
# Date & Author..: 95/01/20 by Nick
# Modify.........: 95/07/04 By Danny (將ogc_flie改成ohb_file)
# Modify.........: No.MOD-530320 05/03/26 By Mandy 銷退單單頭請增加幣別及匯率;業務部門修正為部門
# Modify.........: No.FUN-550070  05/05/27 By yoyo單據編號格式放大
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-570176 05/07/20 By yoyo項次欄位增大
# Modify.........: No.FUN-580004 05/08/03 By day 報表轉xml
# Modify.........: No.FUN-5A0143 05/10/21 By Rosayu 報表格式修正
# Modify.........: No.TQC-5A0098 05/10/27 By Nicola 單據性質取位修改
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-590118 06/01/13 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
#
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6C0033 06/12/07 By Smapmin 處理方式列印資料有誤
# Modify.........: No.FUN-710090 07/02/01 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.MOD-7A0091 07/10/17 By Claire 理由碼沒有印出
# Modify.........: No.CHI-7B0002 07/11/06 By jamie 備註列印有問題，改為新的子報表寫法
# Modify.........: No.MOD-820092 08/02/20 By claire 理由碼若超過oak_file.oak02的定義時,azf03寫入時會造成報表無法印
# Modify.........: No.FUN-860026 08/07/25 By baofei 增加子報表-列印批序號明細
# Modify.........: No.MOD-990004 09/09/01 By Dido 過濾借貨還量的資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30233 10/03/30 By Smapmin 還原MOD-990004
# Modify.........: No:MOD-A60148 10/07/30 By Smapmin 修改外部參數接收順序
# Modify.........: No.FUN-A80103 10/08/17 By yinhy 畫面條件選項增加一個選項，列印額外品名規格
# Modify.........: No:CHI-AB0003 10/11/23 By Summer 多印出銷退單金額
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:TQC-B90055 11/09/07 By lilingyu 銷退單號欄位修改為可開窗查詢
# Modify.........: No:FUN-940044 11/11/06 By minpp 整合單據列印EF簽核
# Modify.........: No.TQC-C10039 12/01/17 By JinJJ  CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C90048 12/09/10 By zhuhao chr1000->string
# Modify.........: No:CHI-C30127 12/12/04 By bart 報表增加oha05
# Modify.........: No.DEV-D30029 13/03/19 By TSD.JIE 與M-Barcode整合(aza131)='Y'時,列印單號條碼

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
 
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc     LIKE type_file.chr1000,    # No.FUN-680137 VARCHAR(500)       # Where condition  #TQC-C90048 mark
              wc     STRING,                                                                          #TQC-C90048 add
              a      LIKE type_file.chr1,       # No.FUN-680137 VARCHAR(01)     # 列印單價
              b      LIKE type_file.chr1,       #No.FUN-860026
              c      LIKE type_file.chr1,       #No.FUN-A80103
              more   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(01)               # Input more condition(Y/N)
              END RECORD,
		  l_outbill	LIKE oha_file.oha01		 # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115      #No.FUN-580004
#No.FUN-710090--begin-- 
DEFINE   l_table         STRING           #No.FUN-710090 
DEFINE   g_sql           STRING           #No.FUN-710090 
DEFINE   g_str           STRING           #No.FUN-710090  
#No.FUN-710090--end--
DEFINE   l_table1        STRING           #CHI-7B0002 add 
DEFINE   l_table2        STRING                 #No.FUN-860026 
DEFINE   l_table3        STRING                 #No.FUN-A80103 
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
   LET g_sql="oha01.oha_file.oha01,",
             "oaydesc.oay_file.oaydesc,",
             "oha02.oha_file.oha02,",
             "oha14.oha_file.oha14,",
             "oha15.oha_file.oha15,",
             "oha03.oha_file.oha03,",
             "oha032.oha_file.oha032,",
             "oha04.oha_file.oha04,",
             "oha05.oha_file.oha05,",  #CHI-C30127
             "oha09.oha_file.oha09,",
             "oha48.oha_file.oha48,",
             "ohb03.ohb_file.ohb03,",
             "ohb31.ohb_file.ohb31,",
             "ohb32.ohb_file.ohb32,",
             "ohb33.ohb_file.ohb33,",
             "ohb34.ohb_file.ohb34,",
             "ohb04.ohb_file.ohb04,",
             "ohb092.ohb_file.ohb092,",
             "ohb05.ohb_file.ohb05,",
             "ohb50.ohb_file.ohb50,",
             "ohb51.ohb_file.ohb51,",
             "ohb06.ohb_file.ohb06,",
             "ohb12.ohb_file.ohb12,",
             "ohb11.ohb_file.ohb11,",
             "ohb09.ohb_file.ohb09,",
             "ohb091.ohb_file.ohb091,",
             "ohb16.ohb_file.ohb16,",
             "oha23.oha_file.oha23,",
             "oha24.oha_file.oha24,",
             "ohb910.ohb_file.ohb910,",
             "ohb912.ohb_file.ohb912,",
             "ohb913.ohb_file.ohb913,",
             "ohb915.ohb_file.ohb915,",
             "ohb916.ohb_file.ohb916,",
             "ohb917.ohb_file.ohb917,",
            #"oak02.oak_file.oak02,",  #MOD-820092
             "oak02.azf_file.azf03,",  #MOD-820092 
             "occ01.occ_file.occ01,",
             "occ02.occ_file.occ02,",
             "occ18_oha03.occ_file.occ18,",
             "occ18_oha04.occ_file.occ18,",
             "gen02.gen_file.gen02,",
             "oag02.oag_file.oag02,",
             "gem02.gem_file.gem02,",
            #"oao06_1.oao_file.oao06,",   #CHI-7B0002 mark
            #"oao06_2.oao_file.oao06,",   #CHI-7B0002 mark
            #"oao06_3.oao_file.oao06,",   #CHI-7B0002 mark
            #"oao06_4.oao_file.oao06,",   #CHI-7B0002 mark
             "unit_ep.type_file.chr50,",
#             "ima021.ima_file.ima021"    #No.FUN-860026
             "ima021.ima_file.ima021,",   #No.FUN-860026
             "flag.type_file.num5,",      #No.FUN-860026  
             "ohb07.ohb_file.ohb07,",     #No.FUN-A80103
             "l_count.type_file.num5,",   #No.FUN-A80103 #CHI-AB0003 mod
             "ohb14.ohb_file.ohb14,",     #CHI-AB0003 add
             "ohb14t.ohb_file.ohb14t,",   #CHI-AB0003 add
             "azi04.azi_file.azi04,",       #CHI-AB0003 add
             "sign_type.type_file.chr1,",#簽核方式   #No.FUN-940044
             "sign_img.type_file.blob,", #簽核圖檔   #No.FUN-940044
             "sign_show.type_file.chr1,",  #是否顯示簽核資料(Y/N) #No.FUN-940044
             "sign_str.type_file.chr1000"    #TQC-C10039

    LET l_table = cl_prt_temptable('axmr700',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
 
   #CHI-7B0002---str---mark---
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   #            " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
   #            "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
   #            "        ?,?,?,?,?,?,?,?)"
   # PREPARE insert_prep FROM g_sql                                                                                                  
   # IF STATUS THEN        
   #    CALL cl_err('insert_prep:',status,1) EXIT PROGRAM     
   # END IF               
   #CHI-7B0002---end---mark---
  #No.FUN-710090--end--
 
  #CHI-7B0002---str---add---
   LET g_sql = 
       "oao01.oao_file.oao01,",
       "oao03.oao_file.oao03,",
       "oao04.oao_file.oao04,",
       "oao05.oao_file.oao05,",
       "oao06.oao_file.oao06"
   LET l_table1 = cl_prt_temptable('axmr7001',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
  #CHI-7B0002---end---add---
#No.FUN-860026---begin                                                                                                              
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs03.rvbs_file.rvbs03,",                                                                                          
               "rvbs04.rvbs_file.rvbs04,",                                                                                          
               "rvbs06.rvbs_file.rvbs06,",                                                                                          
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "ohb06.ohb_file.ohb06,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "ohb05.ohb_file.ohb05,",                                                                                             
               "ohb12.ohb_file.ohb12,",                                                                                             
               "img09.img_file.img09"                                                                                               
   LET l_table2 = cl_prt_temptable('axmr7002',g_sql) CLIPPED                                                                        
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF                                                                                       
#No.FUN-860026---end 
   #No.FUN-A80103 --start--
    LET g_sql = "imc01.imc_file.imc01,",
                "imc02.imc_file.imc02,",
                "imc03.imc_file.imc03,",
                "imc04.imc_file.imc04,",
                "oha01.oha_file.oha01,",
                "ohb03.ohb_file.ohb03"
    LET l_table3 = cl_prt_temptable('axmr7003',g_sql) CLIPPED
    IF  l_table3 = -1 THEN EXIT PROGRAM END IF
   #No.FUN-A80103 --end--   
   INITIALIZE tm.* TO NULL            # Default condition
 #--------------No.TQC-610089 modify
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
  #LET tm.a ='Y'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)  #No.FUN-860026   #MOD-A60148
   LET tm.c    = ARG_VAL(10)  #No.FUN-A80103
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)   #MOD-A60148
   LET g_rep_clas = ARG_VAL(12)   #MOD-A60148
   LET g_template = ARG_VAL(13)   #MOD-A60148
   LET g_rpt_name = ARG_VAL(14)   #MOD-A60148    #No.FUN-7C0078
   #No.FUN-570264 ---end---
 #--------------No.TQC-610089 end
   IF cl_null(tm.wc)
      THEN CALL axmr700_tm(0,0)             # Input print condition
   ELSE 
     #LET tm.wc='oha01= "',l_outbill CLIPPED,'"'     #No.TQC-610089 mark
      CALL axmr700()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr700_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr700_w AT p_row,p_col WITH FORM "axm/42f/axmr700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 #--------------No.TQC-610089 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a ='Y'
   LET tm.b ='N'  #No.FUN-860026
   LET tm.c ='N'  #No.FUN-A80103
 #--------------No.TQC-610089 end
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oha01,oha02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
#TQC-B90055 --begin--
      ON ACTION CONTROLP
          CASE 
             WHEN INFIELD(oha01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_oha01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oha01
                  NEXT FIELD oha01
          END CASE         
#TQC-B90055 --end--    
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.b,tm.c,tm.more WITHOUT DEFAULTS   #No.FUN-860026 add tm.b #No.FUN-A80103
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
#No.FUN-860026---BEGIN                                                                                                              
      AFTER FIELD b    #列印批序號明細                                                                                              
         IF tm.b NOT MATCHES "[YN]" OR cl_null(tm.b)                                                                                
            THEN NEXT FIELD b                                                                                                       
         END IF                                                                                                                     
#No.FUN-860026---END  
#No.FUN-A80103---BEGIN                                                                                                              
      AFTER FIELD c    #列印額外品名規格                                                                                              
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)                                                                                
            THEN NEXT FIELD c                                                                                                       
         END IF                                                                                                                     
#No.FUN-A80103---END  
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr700','9031',1)
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
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'",                 #No.FUN-860026       
                         " '",tm.c CLIPPED,"'",                 #No.FUN-A80103 
                         #" '",tm.more CLIPPED,"'"  ,            #No.TQC-610089 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr700',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr700_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr700()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr700_w
END FUNCTION
 
FUNCTION axmr700()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
         #l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)    #TQC-C90048 mark
          l_sql     STRING,                                                       #TQC-C90048 add
         #l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)      #TQC-C90048 mark
          l_count    LIKE type_file.num5,         #No.FUN-A80103
          sr        RECORD
                    oha01     LIKE oha_file.oha01,
                    oaydesc   LIKE oay_file.oaydesc,
                    oha02     LIKE oha_file.oha02,
                    oha14     LIKE oha_file.oha14,
                    oha15     LIKE oha_file.oha15,
                    oha03     LIKE oha_file.oha03,
                    oha032    LIKE oha_file.oha032,
                    oha04     LIKE oha_file.oha04,
                    oha05     LIKE oha_file.oha05,  #CHI-C30127
                    oha09     LIKE oha_file.oha09,
                    oha48     LIKE oha_file.oha48,   #備註
                    ohb03     LIKE ohb_file.ohb03,
                    ohb31     LIKE ohb_file.ohb31,
                    ohb32     LIKE ohb_file.ohb32,
                    ohb33     LIKE ohb_file.ohb33,
                    ohb34     LIKE ohb_file.ohb34,
                    ohb04     LIKE ohb_file.ohb04,
                    ohb092    LIKE ohb_file.ohb092,
                    ohb05     LIKE ohb_file.ohb05,
                    ohb50     LIKE ohb_file.ohb50,
                    ohb51     LIKE ohb_file.ohb51,
                    ohb06     LIKE ohb_file.ohb06,
                    ohb07     LIKE ohb_file.ohb07,   #No.FUN-A80103
                    ohb12     LIKE ohb_file.ohb12,
                    ohb11     LIKE ohb_file.ohb11,
                    ohb09     LIKE ohb_file.ohb09,
                    ohb091    LIKE ohb_file.ohb091,
                    ohb16     LIKE ohb_file.ohb16,
                     oha23     LIKE oha_file.oha23,#MOD-530320
                     oha24     LIKE oha_file.oha24, #MOD-530320
                    #No.FUN-580004-begin
                    ohb910    LIKE ohb_file.ohb910,
                    ohb912    LIKE ohb_file.ohb912,
                    ohb913    LIKE ohb_file.ohb913,
                    ohb915    LIKE ohb_file.ohb915,
                    ohb916    LIKE ohb_file.ohb916,
                    ohb917    LIKE ohb_file.ohb917, #CHI-AB0003 add ,
                    ohb14     LIKE ohb_file.ohb14,  #CHI-AB0003 add
                    ohb14t    LIKE ohb_file.ohb14t  #CHI-AB0003 add
                    #No.FUN-580004-end
                    END RECORD,
         #No.FUN-A80103  --start--
         sr1        RECORD
                     imc01     LIKE imc_file.imc01,
                     imc02     LIKE imc_file.imc02,
                     imc03     LIKE imc_file.imc03,
                     imc04     LIKE imc_file.imc04
                    END RECORD
         #No.FUN-A80103  --end--
     DEFINE l_i,l_cnt          LIKE type_file.num5      #No.FUN-580004               #No.FUN-680137 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580004
     DEFINE l_oha01           LIKE oay_file.oayslip     # No.FUN-680137 VARCHAR(05)     #No.TQC-5A0098
    #No.FUN-710090--begin--
     DEFINE l_oak02           LIKE azf_file.azf03       #MOD-7A0091 oak_file.oak02
     DEFINE l_occ01           LIKE occ_file.occ01
     DEFINE l_occ02           LIKE occ_file.occ02
     DEFINE l_occ18_oha03     LIKE occ_file.occ18
     DEFINE l_occ18_oha04     LIKE occ_file.occ18
     DEFINE l_gen02           LIKE gen_file.gen02
     DEFINE l_oag02           LIKE oag_file.oag02
     DEFINE l_gem02           LIKE gem_file.gem02
    #CHI-7B0002---str---mark---
    #DEFINE l_oao06_1         LIKE oao_file.oao06
    #DEFINE l_oao06_2         LIKE oao_file.oao06
    #DEFINE l_oao06_3         LIKE oao_file.oao06
    #DEFINE l_oao06_4         LIKE oao_file.oao06
    #CHI-7B0002---end---mark---
     DEFINE l_unit_ep         LIKE type_file.chr50
     DEFINE l_ima021          LIKE ima_file.ima021
     DEFINE l_ima906          LIKE ima_file.ima906
     DEFINE l_str2            STRING
     DEFINE l_ohb915          STRING 
     DEFINE l_ohb912          STRING 
    #No.FUN-710090--end--
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09     LIKE img_file.img09                                                                                  
     DEFINE        flag        LIKE type_file.num5
#No.FUN-860026---end    
     DEFINE oao        RECORD LIKE oao_file.*     #CHI-7B0002 add
     DEFINE l_azi04    LIKE azi_file.azi04  #CHI-AB0003 add
#NO.TQC-C10039--START MARK--
#No.FUN-940044--START--
     DEFINE            l_img_blob     LIKE type_file.blob
#     DEFINE            l_sql_1        LIKE type_file.chr1000
#     DEFINE            l_ii           INTEGER
#     DEFINE            l_key          RECORD                  #主鍵
#                          v1          LIKE oha_file.oha01
#                                      END RECORD
#No.FUN-940044--END--
#NO.TQC-C10039--END MARK--
 
    CALL cl_del_data(l_table)  #No.FUN-710090
    CALL cl_del_data(l_table1) #CHI-7B0002 add
    CALL cl_del_data(l_table2)   #No.FUN-860026  
    CALL cl_del_data(l_table3)   #No.FUN-A80103 
   #CHI-7B0002---str---add---
   #l_table1
    LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940044 add
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
#                "       ?,?,?,?)"  #No.FUN-860026
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"   #No.FUN-860026  #FUN-A80103 add 2? #CHI-AB0003 add 3? #FUN-940044 ADD 3?  #TQC-C10039 add 1? #CHI-C30127
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN        
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM     
     END IF 
 
   #l_table2
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,             
                " VALUES(?,?,?,?,?)"
    PREPARE insert_prep1 FROM g_sql                                              
    IF STATUS THEN                                                               
       CALL cl_err("insert_prep1:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
       EXIT PROGRAM                        
    END IF
   #CHI-7B0002---end---add---
#No.FUN-860026---begin                                                                                                              
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep2 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep2:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
#No.FUN-860026---END   
     #No.FUN-A80103---begin                                                                                                              
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep3 FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep3:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
     #No.FUN-A80103---END
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT sma115 INTO g_sma115 FROM sma_file  #No.FUN-580004
 
    #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axmr700'    #No.FUN-710090 mark
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr700'    #No.FUN-710090  
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ohauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ohagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ohagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup')
     #End:FUN-980030
 
   # LET l_sql="SELECT oha01,oaydesc,oha02,oha14,oha15,oha03,oha032,oha04, ",
     LET l_sql="SELECT oha01,'',oha02,oha14,oha15,oha03,oha032,oha04,oha05, ",  #No.TQC-5A0098  #CHI-C30127
               " oha09,oha48,ohb03,ohb31,ohb32,ohb33,ohb34,ohb04,ohb092,ohb05,",
 	      #" ohb50,ohb51,ohb06,ohb12,ohb11,ohb09,ohb091,ohb16 ",             #MOD-530320  
 	       " ohb50,ohb51,ohb06,ohb07,ohb12,ohb11,ohb09,ohb091,ohb16,oha23,oha24, ", #MOD-530320  #FUN-A800103 add ohb07
	       " ohb910,ohb912,ohb913,ohb915,ohb916,ohb917  ", #No.FUN-580004
	       " ,ohb14,ohb14t  ", #CHI-AB0003 add
             # "  FROM oha_file,OUTER oay_file,ohb_file ",
               "  FROM oha_file,ohb_file ",   #No.TQC-5A0098
             #  " WHERE oha01[1,3]=oay_file.oayslip AND oha01=ohb_file.ohb01 ",
               " WHERE oha01=ohb01 ",  #No.TQC-5A0098
             #  "   AND ohaconf != 'X' ", #01/08/17 mandy
               #"   AND oha09 != '6' ", 				#MOD-990004   #MOD-A30233
               " AND ",tm.wc
 
     LET l_sql= l_sql CLIPPED," ORDER BY oha01,ohb03 "
 
     PREPARE axmr700_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr700_curs1 CURSOR FOR axmr700_prepare1
 
#No.FUN-710090--begin--
#     CALL cl_outnam('axmr700') RETURNING l_name
##No.FUN-580004-begin
#     IF g_sma115 = "Y" THEN  #是否顯示單位注解
#            LET g_zaa[36].zaa06 = "N"
#     ELSE
#            LET g_zaa[36].zaa06 = "Y"
#     END IF
#      CALL cl_prt_pos_len()
##No.FUN-580004-end
#     START REPORT axmr700_rep TO l_name
#    LET g_pageno = 0
#No.FUN-710090--end--
 
     FOREACH axmr700_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=sr.oha23 #CHI-AB0003 add

       #-----No.MOD-5A0098-----
       LET l_oha01 = s_get_doc_no(sr.oha01)
       SELECT oaydesc INTO sr.oaydesc
         FROM oay_file
        WHERE oayslip = l_oha01
       #-----No.MOD-5A0098 END-----
      #No.FUN-710090--begin-- 
      #MOD-7A0091-beigin-modify
       #SELECT oak02 INTO l_oak02 FROM oak_file
       # WHERE oak01=sr.ohb50
       SELECT azf03 INTO l_oak02 FROM azf_file
        WHERE azf01=sr.ohb50
          AND azf02='2'      
      #MOD-7A0091-end-modify
       IF l_oak02 IS NULL THEN LET l_oak02 = '' END IF 
       SELECT occ18 INTO l_occ18_oha03 FROM occ_file WHERE occ01=sr.oha03
       IF SQLCA.sqlcode THEN LET l_occ18_oha03=' ' END IF
       SELECT occ18 INTO l_occ18_oha04 FROM occ_file WHERE occ01=sr.oha04
       IF SQLCA.sqlcode THEN LET l_occ18_oha04=' ' END IF
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oha14
       IF SQLCA.sqlcode THEN LET l_gen02=' ' END IF
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oha15
       IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
       SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file WHERE ima01=sr.ohb04
       LET l_str2= ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906
             WHEN "2"
                 CALL cl_remove_zero(sr.ohb915) RETURNING l_ohb915
                 LET l_str2 = l_ohb915, sr.ohb913 CLIPPED
                 IF cl_null(sr.ohb915) OR sr.ohb915 = 0 THEN
                     CALL cl_remove_zero(sr.ohb912) RETURNING l_ohb912
                     LET l_str2 = l_ohb912,sr.ohb910 CLIPPED
                 ELSE
                    IF NOT cl_null(sr.ohb912) AND sr.ohb912 > 0 THEN
                       CALL cl_remove_zero(sr.ohb912) RETURNING l_ohb912
                       LET l_str2 = l_str2 CLIPPED,',',l_ohb912,sr.ohb910 CLIPPED
                    END IF
                 END IF
             WHEN "3"
                 IF NOT cl_null(sr.ohb915) AND sr.ohb915> 0 THEN
                     CALL cl_remove_zero(sr.ohb915) RETURNING l_ohb915
                     LET l_str2 = l_ohb915 , sr.ohb913 CLIPPED
                 END IF
          END CASE
       END IF
       LET l_unit_ep = l_str2
      #CHI-7B0002---str---mark---
      #LET l_oao06_1 = ""
      #LET l_oao06_4 = ""
      #DECLARE oao_cur1 CURSOR FOR
      # SELECT oao06 FROM oao_file
      #  WHERE oao01=sr.oha01
      #    AND oao03=sr.ohb03
      #    AND oao05='1'
      # FOREACH oao_cur1 INTO l_oao06_4
      #    IF SQLCA.SQLCODE THEN LET l_oao06_4=' ' END IF
      #    IF NOT cl_null(l_oao06_4) THEN
      #       LET l_oao06_1 = l_oao06_1,' ',l_oao06_4
      #    END IF
      # END FOREACH
      #LET l_oao06_2=""
      #LET l_oao06_4=""
      #DECLARE oao_cur2 CURSOR FOR
      # SELECT oao06 FROM oao_file
      #  WHERE oao01=sr.oha01
      #    AND oao03=sr.ohb03
      #    AND oao05='2'
      # FOREACH oao_cur2 INTO l_oao06_4
      #     IF SQLCA.SQLCODE THEN LET l_oao06_4=' ' END IF
      #     IF NOT cl_null(l_oao06_4) THEN
      #        LET l_oao06_2 = l_oao06_2,' ',l_oao06_4
      #     END IF
      # END FOREACH
      #CHI-7B0002---end---mark---
 
      #CHI-7B0002---str---add---
      #列印單身備註
       DECLARE oao_c1 CURSOR FOR                                                 
        SELECT * FROM oao_file                                               
         WHERE oao01=sr.oha01 AND oao03=sr.ohb03 AND (oao05='1' OR oao05='2')
         ORDER BY oao04                                                          
       FOREACH oao_c1 INTO oao.*                                               
          IF NOT cl_null(oao.oao06) THEN
             EXECUTE insert_prep1 USING 
                sr.oha01,sr.ohb03,oao.oao04,oao.oao05,oao.oao06                
          END IF                                                                 
       END FOREACH                                                               
      #CHI-7B0002---end---add---
#No.FUN-860026---begin
    LET flag = 0                                                                                                              
    SELECT img09 INTO l_img09  FROM img_file WHERE img01 = sr.ohb04                                                                 
               AND img02 = sr.ohb09 AND img03 = sr.ohb091                                                                           
               AND img04 = sr.ohb092                                                                                                
    DECLARE r920_d  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
                  WHERE rvbs01 = sr.oha01 AND rvbs02 = sr.ohb03                                                                     
                  ORDER BY  rvbs04                                                                                                  
    FOREACH  r920_d INTO l_rvbs.*  
          LET flag =1                                                                                                  
         EXECUTE insert_prep2 USING  sr.oha01,sr.ohb03,l_rvbs.rvbs03,                                                               
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
                                     sr.ohb05,l_ima021,sr.ohb05,sr.ohb12,                                                           
                                     l_img09                                                                                        
                                                                                                                                    
    END FOREACH                                                                                                                     
#No.FUN-860026---end  
     #No.FUN-A80103  --start  列印額外品名規格說明
     IF tm.c = 'Y' THEN
        SELECT COUNT(*) INTO l_count FROM imc_file
           WHERE imc01=sr.ohb04 AND imc02=sr.ohb07
        IF l_count !=0  THEN
          DECLARE imc_cur CURSOR FOR
          SELECT * FROM imc_file    
            WHERE imc01=sr.ohb04 AND imc02=sr.ohb07 
          ORDER BY imc03                                        
          FOREACH imc_cur INTO sr1.*                            
            EXECUTE insert_prep3 USING sr1.imc01,sr1.imc02,sr1.imc03,sr1.imc04,sr.oha01,sr.ohb03
          END FOREACH
        END IF
     END IF 
     #No.FUN-A80103  --end   
       EXECUTE insert_prep USING sr.oha01,sr.oaydesc,sr.oha02,sr.oha14,sr.oha15,
                                 sr.oha03,sr.oha032,sr.oha04,sr.oha05,sr.oha09,  #CHI-C30127
                                 sr.oha48,sr.ohb03,sr.ohb31,sr.ohb32,sr.ohb33,
                                 sr.ohb34,sr.ohb04,sr.ohb092,sr.ohb05,sr.ohb50,
                                 sr.ohb51,sr.ohb06,sr.ohb12,sr.ohb11,sr.ohb09,
                                 sr.ohb091,sr.ohb16,sr.oha23,sr.oha24,sr.ohb910,
                                 sr.ohb912,sr.ohb913,sr.ohb915,sr.ohb916,sr.ohb917,
                                 l_oak02,l_occ01,l_occ02,l_occ18_oha03,
                                 l_occ18_oha04,l_gen02,l_oag02,l_gem02,              #CHI-7B0002 mod
                                 l_unit_ep,l_ima021,flag,sr.ohb07,l_count,  #No.FUN-860026  add flag #CHI-7B0002 mod #CHI-AB0003 add ,
                                 sr.ohb14,sr.ohb14t,l_azi04, #CHI-AB0003 add
                                #l_occ18_oha04,l_gen02,l_oag02,l_gem02,l_oao06_1,    #CHI-7B0002 mark
                                #l_oao06_2,l_oao06_3,l_oao06_4,l_unit_ep,l_ima021,    #CHI-7B0002 mark
                                  "",l_img_blob,"N",""    #TQC-C10039 add ""     #No.FUN-940044 add  "",l_img_blob,"N"
      #No.FUN-710090--end--
      #OUTPUT TO REPORT axmr700_rep(sr.*)    #No.FUN-710090 mark
     END FOREACH
 
    #CHI-7B0002---end---add---
     #列印整張備註                                                          
     LET l_sql = "SELECT oha01 FROM oha_file ",
                 " WHERE ",tm.wc CLIPPED,      
                 "   ORDER BY oha01"           
     PREPARE r700_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN      
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM  
     END IF           
     DECLARE r700_cs2 CURSOR FOR r700_prepare1
                                                                                
     FOREACH r700_cs2 INTO sr.oha01
        #整張前備註
        DECLARE oao_c2 CURSOR FOR  
         SELECT * FROM oao_file
          WHERE oao01=sr.oha01 AND oao03=0 AND (oao05='1' OR oao05='2')
          ORDER BY oao04                                
        FOREACH oao_c2 INTO oao.* 
           IF NOT cl_null(oao.oao06) THEN
              EXECUTE insert_prep1 USING
                 sr.oha01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
           END IF                                         
        END FOREACH
     END FOREACH    
    #CHI-7B0002---end---add---
 
    #No.FUN-710090--begin-- 
    #FINISH REPORT axmr700_rep
    #LET g_sql = "SELECT * FROM ",l_table CLIPPED                      #TQC-730088
    #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #CHI-7B0002 mark
 
    #CHI-7B0002---str---add---
#No.FUN-860026---begin
#     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", 
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
#                 " WHERE oao03 =0 AND oao05='1'","|",
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
#                 " WHERE oao03!=0 AND oao05='1'","|",
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
#                 " WHERE oao03!=0 AND oao05='2'","|",
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
#                 " WHERE oao03 =0 AND oao05='2'"
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",                                                          
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                             
                 " WHERE oao03 =0 AND oao05='1'","|",                                                                               
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                             
                 " WHERE oao03!=0 AND oao05='1'","|",                                                                               
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                             
                 " WHERE oao03!=0 AND oao05='2'","|",                                                                               
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                             
                 " WHERE oao03 =0 AND oao05='2'","|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",  
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
#No.FUN-860026---end
    #CHI-7B0002---end---add---
 
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oha01,oha02')
         RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.b,";",tm.c   #No.FUN-860026  add tm.b #FUN-A80103 add tm.c
                 ,";",g_aza.aza131         #DEV-D30029	
#NO.TQC-C10039--START MARK--
     #FUN-940044--ADD--STR--
     LET g_cr_table = l_table                 #主報表的temp table名稱
#     LET g_cr_gcx01 = "axmi010"               #單別維護程式
     LET g_cr_apr_key_f = "oha01"             #報表主鍵欄位名稱，用"|"隔開
#     LET l_sql_1= " SELECT DISTINCT oha01 FROM ", g_cr_db_str CLIPPED,l_table CLIPPED
#     PREPARE key_pr FROM l_sql_1
#     DECLARE key_cs CURSOR FOR key_pr
#     LET l_ii = 1
#     #報表主鍵值
#     CALL g_cr_apr_key.clear()                #清空
#     FOREACH key_cs INTO l_key.*
#        LET g_cr_apr_key[l_ii].v1 = l_key.v1
#        LET l_ii = l_ii + 1
#     END FOREACH
     #FUN-940044--ADD--END--
#NO.TQC-C10039--END MARK--
   # CALL cl_prt_cs3('axmr700',g_sql,g_str)    #TQC-730088
     CALL cl_prt_cs3('axmr700','axmr700',g_sql,g_str)
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #No.FUN-710090--end--
END FUNCTION
 
#FUN-710090--begin-- mark
#{
#REPORT axmr700_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
#          sr        RECORD
#                    oha01     LIKE oha_file.oha01,
#                    oaydesc   LIKE oay_file.oaydesc,
#                    oha02     LIKE oha_file.oha02,
#                    oha14     LIKE oha_file.oha14,
#                    oha15     LIKE oha_file.oha15,
#                    oha03     LIKE oha_file.oha03,
#                    oha032    LIKE oha_file.oha032,
#                    oha04     LIKE oha_file.oha04,
#                    oha09     LIKE oha_file.oha09,
#                    oha48     LIKE oha_file.oha48,   #備註
#                    ohb03     LIKE ohb_file.ohb03,
#                    ohb31     LIKE ohb_file.ohb31,
#                    ohb32     LIKE ohb_file.ohb32,
#                    ohb33     LIKE ohb_file.ohb33,
#                    ohb34     LIKE ohb_file.ohb34,
#                    ohb04     LIKE ohb_file.ohb04,
#                    ohb092    LIKE ohb_file.ohb092,
#                    ohb05     LIKE ohb_file.ohb05,
#                    ohb50     LIKE ohb_file.ohb50,
#                    ohb51     LIKE ohb_file.ohb51,
#                    ohb06     LIKE ohb_file.ohb06,
#                    ohb12     LIKE ohb_file.ohb12,
#                    ohb11     LIKE ohb_file.ohb11,
#                    ohb09     LIKE ohb_file.ohb09,
#                    ohb091    LIKE ohb_file.ohb091,
#                    ohb16     LIKE ohb_file.ohb16,
#                     oha23     LIKE oha_file.oha23,#MOD-530320
#                     oha24     LIKE oha_file.oha24,#MOD-530320
#                    #No.FUN-580004-begin
#                    ohb910    LIKE ohb_file.ohb910,
#                    ohb912    LIKE ohb_file.ohb912,
#                    ohb913    LIKE ohb_file.ohb913,
#                    ohb915    LIKE ohb_file.ohb915,
#                    ohb916    LIKE ohb_file.ohb916,
#                    ohb917    LIKE ohb_file.ohb917
#                    #No.FUN-580004-end
#                    END RECORD,
#         l_flag     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#         l_oak02    LIKE oak_file.oak02,   #理由說明
#	 l_occ01    LIKE occ_file.occ18,
#	 l_occ02    LIKE occ_file.occ18,
#         l_gen02    LIKE gen_file.gen02,
#         l_oag02    LIKE oag_file.oag02,
#         l_gem02    LIKE gem_file.gem02,
#	 l_sql 	    LIKE type_file.chr1000,               #No.FUN-680137 VARCHAR(100)
#		 i,j	    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#         l_ohb04092 LIKE type_file.chr50,                # No.FUN-680137 VARCHAR(50)
#         l_oao06    LIKE oao_file.oao06 #No:5384
##No.FUN-580004-begin
#DEFINE   l_str2      LIKE type_file.chr1000,             # No.FUN-680137 VARCHAR(100)
#         l_ima021     LIKE ima_file.ima021,
#         l_ima906     LIKE ima_file.ima906,
#         l_ohb915     STRING,
#         l_ohb912     STRING,
#         l_ohb12      STRING
##No.FUN-580004-end
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5
#         PAGE LENGTH g_page_line
#  ORDER BY sr.oha01,sr.ohb03
#
##No.FUN-580004-begin
#  FORMAT
#   PAGE HEADER
#      LET g_pageno= g_pageno+1
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED ))/2)+1,g_company CLIPPED 
#      PRINT	g_x[11] CLIPPED,sr.oha01 CLIPPED,
# 	        COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT COLUMN 10,sr.oaydesc CLIPPED,
#            #COLUMN (((g_len-FGL_WIDTH(g_x[1]))/2-FGL_WIDTH(sr.oaydesc)-10)+1),g_x[1] CLIPPED #FUN-5A0143 mark
#            COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1] CLIPPED  #FUN-5A0143 add
#      PRINT ' '
#      LET l_last_sw = 'n'        #FUN-550127
#
#    BEFORE GROUP OF sr.oha01
#      SKIP TO TOP OF PAGE
#      SELECT occ18 INTO l_occ01 FROM occ_file WHERE occ01=sr.oha03
#      SELECT occ18 INTO l_occ02 FROM occ_file WHERE occ01=sr.oha04
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.oha14
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.oha15
#      IF SQLCA.SQLCODE THEN
#         LET l_gen02='' LET l_gem02='' LET l_occ01 ='' LET l_occ02=''
#      END IF
#      PRINT g_x[12] CLIPPED,sr.oha02 CLIPPED,
#           COLUMN 41,g_x[13] CLIPPED,l_occ01 CLIPPED, #FUN-5A0143 62->41
#           COLUMN 78,'(',sr.oha032 CLIPPED,')' #FUN-5A0143 99->78
#      PRINT g_x[14] CLIPPED;
#            CASE sr.oha09
#              WHEN '1'	PRINT g_x[23] CLIPPED;
#              WHEN '2'  PRINT g_x[24] CLIPPED;
#              WHEN '3'  PRINT g_x[25] CLIPPED;
#              WHEN '4'  PRINT g_x[19] CLIPPED;   #MOD-6C0033
#              WHEN '5'  PRINT g_x[20] CLIPPED;   #MOD-6C0033
#            END CASE
#
#      PRINT COLUMN 41,g_x[15] CLIPPED,l_occ02 CLIPPED, #FUN-5A0143 62->41
#            COLUMN 78,'(',sr.oha04 CLIPPED,')' #FUN-5A0143 99->78
#      PRINT g_x[16] CLIPPED,l_gen02 CLIPPED,
#            COLUMN 41,g_x[17] CLIPPED,l_gem02  #FUN-5A0143 62->41
#      PRINT g_x[21] CLIPPED,COLUMN 9,':',sr.oha23,
#            COLUMN 41,g_x[26] CLIPPED,COLUMN 49,':',sr.oha24 #FUN-5A0143 62->41 70->49
#      #No:5384
#      DECLARE oao_cur CURSOR FOR
#       SELECT oao06 FROM oao_file
#        WHERE oao01=sr.oha01
#          AND oao03=0
#          AND oao05='1'
#      FOREACH oao_cur INTO l_oao06
#          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#          IF NOT cl_null(l_oao06) THEN
#              PRINT COLUMN 01,l_oao06
#          END IF
#      END FOREACH
#      PRINT g_dash[1,g_len]
#      #FUN-5A0143 mark
#      {PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                     g_x[36],g_x[37],g_x[38],g_x[41],g_x[42]
#      PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[46],
#                     g_x[47],g_x[48]}
#      #FUN-5A0143 add
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[35],
#                     g_x[41],g_x[42],g_x[37],g_x[38]
#      PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[51],g_x[36]
#      PRINTX name=H3 g_x[49],g_x[34],g_x[52],g_x[48]
#      PRINTX name=H4 g_x[50],g_x[46],g_x[47]
#      #FUN-5A0143 end
#      PRINT g_dash1
#
#   ON EVERY ROW
#      DECLARE oao_cur1 CURSOR FOR
#       SELECT oao06 FROM oao_file
#        WHERE oao01=sr.oha01
#          AND oao03=sr.ohb03
#          AND oao05='1'
#      FOREACH oao_cur1 INTO l_oao06
#          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#          IF NOT cl_null(l_oao06) THEN
#            PRINT COLUMN 05,l_oao06
#          END IF
#      END FOREACH
#
#         select oak02 into l_oak02 from oak_file
#          where oak01=sr.ohb50
#          if l_oak02 is null then let l_oak02 = '' end if
# 
#      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                         WHERE ima01=sr.ohb04
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.ohb915) RETURNING l_ohb915
#                LET l_str2 = l_ohb915, sr.ohb913 CLIPPED
#                IF cl_null(sr.ohb915) OR sr.ohb915 = 0 THEN
#                    CALL cl_remove_zero(sr.ohb912) RETURNING l_ohb912
#                    LET l_str2 = l_ohb912,sr.ohb910 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.ohb912) AND sr.ohb912 > 0 THEN
#                      CALL cl_remove_zero(sr.ohb912) RETURNING l_ohb912
#                      LET l_str2 = l_str2 CLIPPED,',',l_ohb912,sr.ohb910 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.ohb915) AND sr.ohb915> 0 THEN
#                    CALL cl_remove_zero(sr.ohb915) RETURNING l_ohb915
#                    LET l_str2 = l_ohb915 , sr.ohb913 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#         #FUN-5A0143 mark
#	#PRINTX name=D1
#        #        COLUMN g_c[31],sr.ohb03 USING '#####',
#	#        COLUMN g_c[32],sr.ohb31 CLIPPED,
#        #        COLUMN g_c[33],sr.ohb32 USING '########',
#	#        #COLUMN g_c[34],sr.ohb04[1,20] CLIPPED,
#	#        COLUMN g_c[34],sr.ohb04 CLIPPED,  #NO.FUN-5B0015
#        #        COLUMN g_c[35],sr.ohb092 CLIPPED,
#        #        COLUMN g_c[36],l_str2 CLIPPED,
#	#        COLUMN g_c[37],sr.ohb05 CLIPPED,
#        #        COLUMN g_c[38],cl_numfor(sr.ohb12,38,3),
#	#        COLUMN g_c[41],sr.ohb09 CLIPPED,
#        #        COLUMN g_c[42],sr.ohb091 CLIPPED
#	#PRINTX name=D2
#        #        COLUMN g_c[44],sr.ohb33 CLIPPED,
#        #        COLUMN g_c[45],sr.ohb34 USING '########',
#	#        COLUMN g_c[46],sr.ohb06 CLIPPED,
#        #        COLUMN g_c[47],sr.ohb51 CLIPPED,
#        #        COLUMN g_c[48],l_oak02 CLIPPED
#         #FUN-5A0143 end mark
#         #FUN-5A0143 add
#         PRINTX name=D1 COLUMN g_c[31],sr.ohb03 USING '###&', #FUN-590118
#                        COLUMN g_c[32],sr.ohb31 CLIPPED,
#                        COLUMN g_c[33],sr.ohb32 USING '########',
#                        COLUMN g_c[35],sr.ohb092 CLIPPED,
#                        COLUMN g_c[41],sr.ohb09 CLIPPED,
#                        COLUMN g_c[42],sr.ohb091 CLIPPED,
#                        COLUMN g_c[37],sr.ohb05 CLIPPED,
#                        COLUMN g_c[38],cl_numfor(sr.ohb12,38,3)
#         PRINTX name=D2 COLUMN g_c[44],sr.ohb33 CLIPPED,
#                        COLUMN g_c[45],sr.ohb34 USING '########',
#                        COLUMN g_c[51],'',
#                        COLUMN g_c[36],l_str2 CLIPPED
#         #PRINTX name=D3 COLUMN g_c[34],sr.ohb04[1,20] CLIPPED,
#         PRINTX name=D3 COLUMN g_c[34],sr.ohb04 CLIPPED,  #NO.FUN-5B0015
#                        COLUMN g_c[51],'',
#                        COLUMN g_c[48],l_oak02 CLIPPED
#         PRINTX name=D4 COLUMN g_c[46],sr.ohb06 CLIPPED,
#                        COLUMN g_c[47],sr.ohb51 CLIPPED
#         #FUN-5A0143 end
#	 IF tm.a = 'Y' THEN
#	 	PRINTX name=S1 COLUMN g_c[32],g_x[22] CLIPPED,
#                               COLUMN g_c[33],sr.ohb11 CLIPPED
#	 END IF
#         DECLARE oao_cur2 CURSOR FOR
#          SELECT oao06 FROM oao_file
#           WHERE oao01=sr.oha01
#             AND oao03=sr.ohb03
#             AND oao05='2'
#         FOREACH oao_cur2 INTO l_oao06
#             IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#             IF NOT cl_null(l_oao06) THEN
#                 PRINT COLUMN 07,l_oao06
#             END IF
#         END FOREACH
#         PRINT ''
#
#
#   AFTER GROUP OF sr.oha01
#        PRINT g_x[18] CLIPPED,sr.oha48 CLIPPED
##No.FUN-580004-end
#      DECLARE oao_cur3 CURSOR FOR
#       SELECT oao06 FROM oao_file
#        WHERE oao01=sr.oha01
#          AND oao03=0
#          AND oao05='2'
#      FOREACH oao_cur3 INTO l_oao06
#          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF
#          IF NOT cl_null(l_oao06) THEN
#             PRINT COLUMN 01,l_oao06
#          END IF
#      END FOREACH
#
### FUN-550127
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
##       PRINT g_x[4] CLIPPED,COLUMN 41,g_x[5]
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[4]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[4]
#             PRINT g_memo
#      END IF
### END FUN-550127
#
#END REPORT
##Patch....NO.TQC-610037 <> #
#
#}
#No.FUN-710090--end-- mark
