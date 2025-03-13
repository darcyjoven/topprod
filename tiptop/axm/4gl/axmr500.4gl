# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmr500.4gl
# Descriptions...: 出貨通知單
# Date & Author..: 95/02/13 by Nick
# Modify.........: 01-04-06 BY ANN CHEN B297 在列印Shipping Mark時客戶的PO#
#                                            顯示訂單上的PO#,當出貨通知單單頭
#                                            有輸入訂單單號時.
# Modify.........: No.MOD-550006 05/05/02 By kim 報表XML
# Modify.........: No.FUN-550070 05/05/26 By day  單據編號加大
# Modify.........: No.FUN-560002 05/06/03 By day  單據編號修改
# Modify.........: No.FUN-550127 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-570176 05/07/19 By yoyo 項次欄位增大
# Modify.........: No.FUN-580004 05/08/05 By wujie 雙單位報表格式修改
# Modify.........: No.FUN-5A0143 05/10/20 By Rosayu 報表格式修改
# Modify.........: No.FUN-5C0076 05/12/22 By wujie 增加“檢驗”欄位的列印
# Modify.........: No.TQC-610089 06/05/16 By Pengu Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-650020 06/05/26 By kim 整合信用額度的錯誤訊息為一個視窗,不要每筆都秀
# Modify.........: No.FUN-5A0060 06/06/15 By Sarah 增加列印ima021規格
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-690032 06/10/18 By rainy 新增是否列印客戶料號
# Modify.........: NO.MOD-690064 06/11/16 By Claire 可列印CCCCCC ~ DDDDDD
# Modify.........: NO.MOD-6B0133 06/12/11 By Claire 嘜頭資料沒給值造成無法印出
# Modify.........: NO.TQC-6C0134 06/12/22 By Claire 尚未確認單據也可列印
# Modify.........: No.FUN-710090 07/02/01 By chenl 報表輸出至Crystal Reports功能
# Modify.........: No.FUN-730014 07/03/06 By chenl s_addr傳回5個參數
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-720014 07/04/10 By rainy 地址欄位加2個
# Modify.........: No.TQC-750158 07/05/28 By rainy 列印出來的,船名/航次/出貨數量/單位/校驗..等資料亂掉
# Modify.........: No.CHI-7A0010 07/10/06 By Sarah 增加列印備註功能
# Modify.........: No.TQC-7A0024 07/10/11 By Sarah 報表CREATE TEMP TABLE時，temp table名稱有誤
# Modify.........: No.MOD-850085 08/05/12 By Smapmin 勾選列印客戶產品料號,報表不會印出客戶產品料號
# Modify.........: No.MOD-850241 08/05/27 By Smapmin 增加背景傳遞參數
# Modify.........: No.FUN-860026 08/07/23 By baofei 增加子報表-列印批序號明細 
# Modify.........: No.MOD-980260 09/08/31 By Smapmin 修改ora檔
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-920103 09/09/03 By chenmoyan 增加多倉儲的列印
# Modify.........: No.FUN-990074 09/10/19 By mike axmr500交運方式的中文要顯示在oga43的右手邊. 
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:MOD-A30010 10/03/02 By Smapmin 修改變數型態
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No:TQC-B90055 11/09/07 By lilingyu通知單號欄位修改為可開窗查詢
# Modify.........: No:FUN-940044 11/11/04 By huangtao CR報表列印EF簽核圖檔 OR TIPTOP自訂簽核欄位 
# Modify.........: No.TQC-C10039 12/01/18 By wangrr 整合單據列印EF簽核 
# Modify.........: No.MOD-BB0203 12/01/30 By Vampire 顯示批序號時會有重複
# Modify.........: No.DEV-D30029 13/03/19 By TSD.JIE 與M-Barcode整合(aza131)='Y'時,列印單號條碼
# Modify.........: No.CHI-C60026 13/03/22 By Elise axmr500未抓取來源廠
# Modify.........: No.MOD-D40109 13/04/16 By Vampire 判斷不同單號時，才CALL s_ccc()，錯誤訊息只要出現一次就可以

DATABASE ds
 
GLOBALS "../../config/top.global"
 
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)             # Where condition
              a       LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)              # 列印單價
              d       LIKE type_file.chr1,        # No.FUN-690032 列印客戶料號
              c       LIKE type_file.chr1,          #No.FUN-860026  
              more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(01)               # Input more condition(Y/N)
              END RECORD,
          l_oao06    LIKE oao_file.oao06,
	  l_outbill	LIKE oga_file.oga01, # 出貨單號,傳參數用
          g_po_no,g_ctn_no1,g_ctn_no2   LIKE type_file.num10       # No.FUN-680137 VARCHAR(20)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(72)
DEFINE   i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   j               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE l_sql            STRING   #MOD-A30010 
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD  #FUN-650020
          oga01     LIKE oga_file.oga01,
          oga03     LIKE oga_file.oga03,
          occ02     LIKE occ_file.occ02,
          occ18     LIKE occ_file.occ18,
          ze01      LIKE ze_file.ze01,
          ze03      LIKE ze_file.ze03
                   END RECORD
DEFINE  g_oga01     LIKE oga_file.oga01   #FUN-650020
   DEFINE         l_ogc      RECORD
                  ogc09     LIKE ogc_file.ogc09,
                  ogc091    LIKE ogc_file.ogc091,
                  ogc16     LIKE ogc_file.ogc16,
                  ogc092    LIKE ogc_file.ogc092
                             END RECORD
   DEFINE         l_ogb17   LIKE ogb_file.ogb17
DEFINE l_table      STRING
DEFINE l_table1     STRING   #CHI-7A0010 add
DEFINE l_table2     STRING                 #No.FUN-860026 
DEFINE l_table3     STRING   #No.FUN-920103
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE g_oga01_o   LIKE oga_file.oga01 #MOD-D40109 add 
 
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
 
   LET g_sql="oga01.oga_file.oga01,",
             "oaydesc.oay_file.oaydesc,",
             "oga02.oga_file.oga02,",
             "oga021.oga_file.oga021,",
             "gen02.gen_file.gen02,",
             "gem02.gem_file.gem02,",
             "oga032.oga_file.oga032,",
             "oga03.oga_file.oga03,",
             "occ02.occ_file.occ02,",
             "oga04.oga_file.oga04,",
             "oga044.oga_file.oga044,",
             "ocd221.ocd_file.ocd221,",
             "ocd222.ocd_file.ocd222,",
             "ocd223.ocd_file.ocd223,",
             "ocd230.ocd_file.ocd230,",  #FUN-720014
             "ocd231.ocd_file.ocd231,",  #FUN-720014
             "oga41.oga_file.oga41,",
             "oac02.oac_file.oac02,",
             "oga42.oga_file.oga42,",
             "oac02_2.oac_file.oac02,",
             "oga43.oga_file.oga43,",
             "ged02.ged_file.ged02,", #FUN-990074      
             "oga47.oga_file.oga47,",
             "oga48.oga_file.oga48,",
             "oga16.oga_file.oga16,",
             "ocf101.ocf_file.ocf101,",
             "ocf102.ocf_file.ocf102,",
             "ocf103.ocf_file.ocf103,",
             "ocf104.ocf_file.ocf104,",
             "ocf105.ocf_file.ocf105,",
             "ocf106.ocf_file.ocf106,",
             "ocf107.ocf_file.ocf107,",
             "ocf108.ocf_file.ocf108,",
             "ocf109.ocf_file.ocf109,",
             "ocf110.ocf_file.ocf110,",
             "ocf111.ocf_file.ocf111,",
             "ocf112.ocf_file.ocf112,",
             "ogb03.ogb_file.ogb03,",
             "ogb31.ogb_file.ogb31,",
             "ogb32.ogb_file.ogb32,",
             "ogb04.ogb_file.ogb04,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "ogb092.ogb_file.ogb092,",
             "ogb05.ogb_file.ogb05,",
             "ogb06.ogb_file.ogb06,",
             "ogb12.ogb_file.ogb12,",
             "ogb19.ogb_file.ogb19,",
             "ogb910.ogb_file.ogb910,",
             "ogb912.ogb_file.ogb912,",
             "ogb913.ogb_file.ogb913,",
             "ogb915.ogb_file.ogb915,",
             "azi03.azi_file.azi03,",
             "azi04.azi_file.azi04,",
             "azi05.azi_file.azi05,",
             "oga27.oga_file.oga27,",
             "oeb11.oeb_file.oeb11,",
             "unit_ep.type_file.chr50,",
             "ogb09.ogb_file.ogb09,",
             "ogb091.ogb_file.ogb091,",
             "message.type_file.chr1000,",   #No.FUN-860026
             "flag.type_file.num5,",           #No.FUN-860026
             "sign_type.type_file.chr1,",     #FUN-940044 add
             "sign_img.type_file.blob,",      #FUN-940044 add
             "sign_show.type_file.chr1,",     #FUN-940044 add
             "sign_str.type_file.chr1000"     #TQC-C10039 sign_str
    LET l_table = cl_prt_temptable('axmr500',g_sql) CLIPPED    #TQC-7A0024 mod
    IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs03.rvbs_file.rvbs03,",                                                                                          
               "rvbs04.rvbs_file.rvbs04,",                                                                                          
               "rvbs06.rvbs_file.rvbs06,",                                                                                          
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "ogb06.ogb_file.ogb06,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "ogb05.ogb_file.ogb05,",                                                                                             
               "ogb12.ogb_file.ogb12,",                                                                                             
               "img09.img_file.img09"                                                                                               
   LET l_table2 = cl_prt_temptable('axmr5002',g_sql) CLIPPED                                                                        
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF                                                                                       
   #備註
    LET g_sql = "oao01.oao_file.oao01,",
                "oao03.oao_file.oao03,",
                "oao04.oao_file.oao04,",
                "oao05.oao_file.oao05,",
                "oao06.oao_file.oao06"
    LET l_table1 = cl_prt_temptable('axmr5001',g_sql) CLIPPED
    IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   LET g_sql ="ogc01.ogc_file.ogc01,",
              "ogb03.ogb_file.ogb03,",
              "ogc09.ogc_file.ogc09,",
              "ogc091.ogc_file.ogc091,",
              "ogc092.ogc_file.ogc092,",
              "i1.type_file.num5,",
              "ogc16.ogc_file.ogc16"
   LET l_table3 = cl_prt_temptable('axmr5003',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.d    = ARG_VAL(9)   #MOD-850241
   LET tm.c    = ARG_VAL(14)  #No.FUN-860026
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   IF cl_null(tm.wc)
      THEN CALL axmr500_tm(0,0)             # Input print condition
   ELSE 
      CALL axmr500()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr500_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
 
   LET p_row = 7 LET p_col = 17
 
   OPEN WINDOW axmr500_w AT p_row,p_col WITH FORM "axm/42f/axmr500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a ='N'
   LET tm.d ='N'  #FUN-690032
   LET tm.c ='N'  #No.FUN-860026
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oga01,oga02
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
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
 
 
#TQC-B90055 --begin--
      ON ACTION CONTROLP
        CASE 
          WHEN INFIELD(oga01)
             CALL cl_init_qry_var()
             LET g_qryparam.state = 'c'
             LET g_qryparam.form ="q_oga01_1"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO oga01
             NEXT FIELD oga01
        END CASE 
#TQC-B90055 --end-- 

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
      LET INT_FLAG = 0 CLOSE WINDOW axmr500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm.a,tm.d,tm.c,tm.more WITHOUT DEFAULTS  #FUN-690032 add tm.d  #No.FUN-860026 add tm.c
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD d
       IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
         NEXT FIELD d
       END IF
      AFTER FIELD c    #列印批序號明細                                                                                              
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)                                                                                
            THEN NEXT FIELD c                                                                                                       
         END IF                                                                                                                     
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr500','9031',1)
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
                         " '",tm.a CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'" ,   #FUN-690032 add
                         " '",tm.c CLIPPED,"'",                 #No.FUN-860026  
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr500',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axmr500()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr500_w
END FUNCTION
 
FUNCTION axmr500()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680137 VARCHAR(8)
          l_sql     STRING,   #MOD-A30010 
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          sr        RECORD
                    oga01     LIKE oga_file.oga01,
                    oaydesc   LIKE oay_file.oaydesc,
                    oga02     LIKE oga_file.oga02,
                    oga021    LIKE oga_file.oga021,
                    gen02     LIKE gen_file.gen02,
                    gem02     LIKE gem_file.gem02,
                    oga032    LIKE oga_file.oga032,
                    oga03     LIKE oga_file.oga03,
                    occ02     LIKE occ_file.occ02,
                    oga04     LIKE oga_file.oga04,
                    oga044    LIKE oga_file.oga044,
                    ocd221    LIKE ocd_file.ocd221,
                    ocd222    LIKE ocd_file.ocd222,
                    ocd223    LIKE ocd_file.ocd223,
                    ocd230    LIKE ocd_file.ocd230,  #FUN-720014
                    ocd231    LIKE ocd_file.ocd231,  #FUN-720014
                    oga41     LIKE oga_file.oga41,
                    oac02     LIKE oac_file.oac02,
                    oga42     LIKE oga_file.oga42,
                    oac02_2   LIKE oac_file.oac02,
                    oga43     LIKE oga_file.oga43,
                    ged02     LIKE ged_file.ged02, #FUN-990074       
                    oga47     LIKE oga_file.oga47,
                    oga48     LIKE oga_file.oga48,
                    oga16     LIKE oga_file.oga16,
                    ocf101    LIKE ocf_file.ocf101,
                    ocf102    LIKE ocf_file.ocf102,
                    ocf103    LIKE ocf_file.ocf103,
                    ocf104    LIKE ocf_file.ocf104,
                    ocf105    LIKE ocf_file.ocf105,
                    ocf106    LIKE ocf_file.ocf106,
                    ocf107    LIKE ocf_file.ocf107,
                    ocf108    LIKE ocf_file.ocf108,
                    ocf109    LIKE ocf_file.ocf109,
                    ocf110    LIKE ocf_file.ocf110,
                    ocf111    LIKE ocf_file.ocf111,
                    ocf112    LIKE ocf_file.ocf112,
                    ogb03     LIKE ogb_file.ogb03,
                    ogb31     LIKE ogb_file.ogb31,
                    ogb32     LIKE ogb_file.ogb32,
                    ogb04     LIKE ogb_file.ogb04,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,  #FUN-5A0060 add
                    ogb092    LIKE ogb_file.ogb092,
                    ogb05     LIKE ogb_file.ogb05,
                    ogb06     LIKE ogb_file.ogb06,
                    ogb12     LIKE ogb_file.ogb12,
                    ogb19     LIKE ogb_file.ogb19,   #No.FUN-5C0076
                    ogb910    LIKE ogb_file.ogb910,  #No.FUN-580004
                    ogb912    LIKE ogb_file.ogb912,  #No.FUN-580004
                    ogb913    LIKE ogb_file.ogb913,  #No.FUN-580004
                    ogb915    LIKE ogb_file.ogb915,  #No.FUN-580004
                    azi03     LIKE azi_file.azi03,	
                    azi04     LIKE azi_file.azi04,
                    azi05     LIKE azi_file.azi05,
                    oga27     LIKE oga_file.oga27,   #MOD-6B0133 add
                    ogb09     LIKE ogb_file.ogb09,   #No.FUN-710090 
                    ogb091    LIKE ogb_file.ogb091   #No.FUN-710090 
                    END RECORD
   DEFINE oao      RECORD LIKE oao_file.*            #CHI-7A0010 add
   DEFINE l_msg    STRING                            #FUN-650020
   DEFINE l_msg2   STRING                            #FUN-650020
   DEFINE lc_gaq03 LIKE gaq_file.gaq03               #FUN-650020
   DEFINE l_message LIKE type_file.chr1000
   DEFINE l_oeb11   LIKE oeb_file.oeb11
   DEFINE l_str2    STRING
   DEFINE l_unit_ep LIKE type_file.chr50
   DEFINE l_ogb915  LIKE ogb_file.ogb915
   DEFINE l_ogb912  LIKE ogb_file.ogb912
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_slip    LIKE oay_file.oayslip
   DEFINE l_ofa10   LIKE ofa_file.ofa10
   DEFINE l_ofa45   LIKE ofa_file.ofa45
   DEFINE l_ofa46   LIKE ofa_file.ofa46
   DEFINE l_ocd230 LIKE ocd_file.ocd230    #No.FUN-730014   #FUN-720014
   DEFINE l_ocd231 LIKE ocd_file.ocd231    #No.FUN-730014   #FUN-720014
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09     LIKE img_file.img09            
     DEFINE        flag        LIKE type_file.num5  

   #FUN-B940044 START
   DEFINE l_img_blob         LIKE type_file.blob
#TQC-C10039--start--mark---
   #DEFINE l_ii               INTEGER 
   #DEFINE l_key              RECORD 
   #       v1                 LIKE oga_file.oga01
   #       END RECORD
#TQC-C10039--end--mark--- 
   #FUN-B940044 END    
   DEFINE l_oga909   LIKE oga_file.oga909 #CHI-C60026 add
   DEFINE l_oga09    LIKE oga_file.oga09  #CHI-C60026 add 
   DEFINE l_poz00    LIKE poz_file.poz00  #CHI-C60026 add 
   DEFINE l_poz011   LIKE poz_file.poz011 #CHI-C60026 add 
   DEFINE l_poz01    LIKE poz_file.poz01  #CHI-C60026 add 
   DEFINE l_poy04    LIKE poy_file.poy04  #CHI-C60026 add 
   DEFINE l_oea904   LIKE oea_file.oea904 #CHI-C60026 add
   DEFINE l_oea99    LIKE oea_file.oea99  #CHI-C60026 add
   DEFINE l_cnt      LIKE type_file.num5  #CHI-C60026 add

   
   CALL cl_del_data(l_table)    #No.FUN-710090
   CALL cl_del_data(l_table1)   #CHI-7A0010 add
   CALL cl_del_data(l_table2)   #No.FUN-860026
   CALL cl_del_data(l_table3)   #No.FUN-920103

   LOCATE l_img_blob IN MEMORY      #FUN-B940044 add
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"  #FUN-B940044 add 3?  #No.FUN-860026 #FUN-990074 add ?#TQC-C10039 add 1?   
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
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                 
     PREPARE insert_prep2 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep2:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?)"
     PREPARE insert_prep3 FROM l_sql
     IF STATUS THEN
        CALL cl_err("insert_prep3:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axmr500'             #No.FUN-710090   
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
 
     LET l_sql="SELECT oga01,oaydesc,oga02,oga021,gen02,gem02, ",
            "    oga032,oga03,occ02,oga04,oga044,'','','','','', ",  #TQC-750158
            "    oga41,oac02,oga42,' ',oga43,'',oga47,oga48,oga16,ocf101,ocf102, ", #FUN-990074 add ''   
            " ocf103,ocf104,ocf105,ocf106,ocf107,ocf108,ocf109,ocf110,  ",
            " ocf111,ocf112,ogb03,ogb31,ogb32,ogb04,ima02,ima021,ogb092,ogb05,ogb06, ",   #FUN-5A0060 add ima021
            "  ogb12,ogb19,ogb910,ogb912,ogb913,ogb915,azi03,azi04,azi05,oga27, ",         #No.FUN-5C0076  #MOD-6B0133 modify oga27
            "  ogb09,ogb091 ",   #No.FUN-710090
            ", ogb17 ",          #No.FUN-920103
            "   FROM oga_file LEFT OUTER JOIN oay_file ON(oga01 like ltrim(rtrim(oayslip)) || '-%') ",
                            " LEFT OUTER JOIN occ_file ON(oga04 = occ01) ",
                            " LEFT OUTER JOIN azi_file ON(oga23 = azi01) ",
                            " LEFT OUTER JOIN oac_file ON(oga41= oac01) ",
                            " LEFT OUTER JOIN ocf_file ON(oga44 = ocf02 AND ocf01 = oga04) ",
                            " LEFT OUTER JOIN gem_file ON(oga15 = gem01) ",
                            " LEFT OUTER JOIN gen_file ON(oga14 = gen01),",
                   " ogb_file,ima_file ",
             " WHERE oga01=ogb01 AND (oga09='1'  OR oga09 = '5') AND ima01 = ogb04 ",
              " AND ",tm.wc CLIPPED," ORDER BY oga01,ogb03 "
     PREPARE axmr500_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE axmr500_curs1 CURSOR FOR axmr500_prepare1
#TQC-C10039--start--mark---
     #FUN-940044 START
     #LET l_sql="SELECT oga01 ",
     #       "   FROM oga_file LEFT OUTER JOIN oay_file ON(oga01 like ltrim(rtrim(oayslip)) || '-%') ",
     #                       " LEFT OUTER JOIN occ_file ON(oga04 = occ01) ",
     #                       " LEFT OUTER JOIN azi_file ON(oga23 = azi01) ",
     #                       " LEFT OUTER JOIN oac_file ON(oga41= oac01) ",
     #                       " LEFT OUTER JOIN ocf_file ON(oga44 = ocf02 AND ocf01 = oga04) ",
     #                       " LEFT OUTER JOIN gem_file ON(oga15 = gem01) ",
     #                       " LEFT OUTER JOIN gen_file ON(oga14 = gen01),",
     #              " ogb_file,ima_file ",
     #        " WHERE oga01=ogb01 AND (oga09='1'  OR oga09 = '5') AND ima01 = ogb04 ",
     #         " AND ",tm.wc CLIPPED," ORDER BY oga01 "
     #PREPARE axmr500_prepare4 FROM l_sql
     #IF SQLCA.sqlcode != 0 THEN
     #   CALL cl_err('prepare4:',SQLCA.sqlcode,1)
     #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     #   EXIT PROGRAM
     #END IF
     #DECLARE r500_curs4 CURSOR FOR axmr500_prepare4
     #FUN-940044 END
#TQC-C10039--end--mark---
	 LET l_sql="SELECT oao06 FROM oao_file ",
			   " WHERE oao01=? AND oao05 = '0' "
	 LET l_sql=l_sql CLIPPED
     PREPARE axmr500_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
     END IF
     DECLARE axmr500_curs2 CURSOR FOR axmr500_prepare2 #BugNo:6510
 
     FOREACH axmr500_curs1 INTO sr.*,l_ogb17    #No.FUN-920103 add l_ogb17
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #CHI-C60026 add start -----
       #逆拋則要抓來源廠的客戶名稱(多角貿易)
       SELECT oga909,oga09 INTO l_oga909,l_oga09 FROM oga_file WHERE oga01 = sr.oga01
       IF l_oga909 = 'Y' AND (l_oga09 = '4' OR l_oga09 = '5') THEN
          IF cl_null(sr.oga16) THEN
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM ogb_file
              WHERE ogb01 = sr.oga01
             IF l_cnt=0 THEN
                 SELECT oea99 INTO l_oea99 FROM oea_file
                  WHERE oea01 = sr.ogb31
             ELSE
               #只讀取第一筆訂單之資料
               SELECT oea99 INTO l_oea99
                 FROM oea_file,ogb_file
                WHERE oea01 = ogb31 AND ogb01 = sr.oga01
                  AND oeaconf = 'Y'
                ORDER BY ogb03
             END IF
          ELSE
             #讀取該出貨單之訂單
             SELECT oea99 INTO l_oea99
               FROM oea_file
              WHERE oea01 = sr.oga16 AND oeaconf = 'Y'
          END IF
          IF SQLCA.sqlcode = 0 THEN
             SELECT oea904 INTO l_oea904 FROM oea_file WHERE oea99 = l_oea99
             SELECT poz00,poz011,poz01 INTO l_poz00,l_poz011,l_poz01 FROM poz_file WHERE poz01 = l_oea904
             IF l_poz00 = '1' THEN
                IF l_poz011 = '2' THEN
                   SELECT poy04 INTO l_poy04
                     FROM poy_file
                    WHERE poy01 = l_poz01
                      AND poy02 = '0'

                   LET l_sql = " SELECT oea03 FROM ",cl_get_target_table(l_poy04,'oea_file'),
                               "  WHERE oea99 = '",l_oea99,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql
                   PREPARE oea03_pre1 FROM l_sql
                   DECLARE oea03_cs1 CURSOR FOR oea03_pre1
                   OPEN oea03_cs1
                   IF STATUS THEN
                      DISPLAY 'open oea03',STATUS
                   END IF
                   FETCH oea03_cs1 INTO sr.oga03
                   IF STATUS THEN
                      DISPLAY 'fetch oea03',STATUS
                   END IF
                END IF
             END IF
          END IF
       END IF
       #CHI-C60026 add end   -----
         CALL s_addr(sr.oga01,sr.oga04,sr.oga044)
              RETURNING sr.ocd221,sr.ocd222,sr.ocd223,l_ocd230,l_ocd231  #No.FUN-730014 ocd2231/ocd2232  #FUN-720014 l_ocd2231/32->l_ocd230/231
         IF SQLCA.SQLCODE THEN
            LET sr.ocd221=''
            LET sr.ocd222=''
            LET sr.ocd223=''
            LET l_ocd230 = ''  #FUN-720014
            LET l_ocd231 = ''  #FUN-720014
         END IF
         SELECT oac02 INTO sr.oac02_2 FROM oac_file
          WHERE oac01 = sr.oga42
         IF SQLCA.SQLCODE THEN
            LET sr.oac02_2 =''
         END IF
         SELECT ged02 INTO sr.ged02 FROM ged_file                                                                                   
          WHERE ged01 = sr.oga43                                                                                                    
         IF SQLCA.SQLCODE THEN                                                                                                      
            LET sr.ged02 =''                                                                                                        
         END IF                                                                                                                     
       IF g_oaz.oaz131 = "1" THEN
          IF g_oga01_o != sr.oga01 OR cl_null(g_oga01_o) THEN #MOD-D40109 add
             CALL s_get_doc_no(sr.oga01) RETURNING l_slip
             CALL s_ccc_logerr()
             CALL s_ccc(sr.oga03,'0',l_slip)
             IF g_errno = 'N' THEN
                CALL cl_getmsg('axm-107',g_rlang) RETURNING l_message
             END IF
         #MOD-D40109 add start -----
          END IF 
          LET g_oga01_o = sr.oga01
         #MOD-D40109 add end  -----
       END IF
       SELECT ofa10,ofa45,ofa46 
         INTO l_ofa10,l_ofa45,l_ofa46 
         FROM ofa_file 
        WHERE ofa01 = sr.oga27
       LET g_po_no=l_ofa10 
       LET g_ctn_no1=l_ofa45 
       LET g_ctn_no2=l_ofa46
       LET sr.ocf101=ocf_c(sr.ocf101)
       LET sr.ocf102=ocf_c(sr.ocf102)
       LET sr.ocf103=ocf_c(sr.ocf103)
       LET sr.ocf104=ocf_c(sr.ocf104)
       LET sr.ocf105=ocf_c(sr.ocf105)
       LET sr.ocf106=ocf_c(sr.ocf106)
       LET sr.ocf107=ocf_c(sr.ocf107)
       LET sr.ocf108=ocf_c(sr.ocf108)
       LET sr.ocf109=ocf_c(sr.ocf109)
       LET sr.ocf110=ocf_c(sr.ocf110)
       LET sr.ocf111=ocf_c(sr.ocf111)
       LET sr.ocf112=ocf_c(sr.ocf112)
 
       #列印單身備註
       DECLARE oao_c1 CURSOR FOR                                                 
        SELECT * FROM oao_file                                               
         WHERE oao01=sr.oga01 AND oao03=sr.ogb03 AND (oao05='1' OR oao05='2')
         ORDER BY oao04                                                          
       FOREACH oao_c1 INTO oao.*                                               
          IF NOT cl_null(oao.oao06) THEN
             EXECUTE insert_prep1 USING 
                sr.oga01,sr.ogb03,oao.oao04,oao.oao05,oao.oao06                
          END IF                                                                 
       END FOREACH                                                               
 
       SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=sr.ogb04
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906
             WHEN "2"
                 CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                 LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                 IF cl_null(sr.ogb915) OR sr.ogb915 = 0 THEN
                     CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                     LET l_str2 = l_ogb912, sr.ogb910 CLIPPED
                 ELSE
                    IF NOT cl_null(sr.ogb912) AND sr.ogb912 > 0 THEN
                       CALL cl_remove_zero(sr.ogb912) RETURNING l_ogb912
                       LET l_str2 = l_str2 CLIPPED,',',l_ogb912, sr.ogb910 CLIPPED
                    END IF
                 END IF
             WHEN "3"
                 IF NOT cl_null(sr.ogb915) AND sr.ogb915 > 0 THEN
                     CALL cl_remove_zero(sr.ogb915) RETURNING l_ogb915
                     LET l_str2 = l_ogb915 , sr.ogb913 CLIPPED
                 END IF
          END CASE
       END IF
       LET l_unit_ep = l_str2
       LET l_oeb11 = ''
       SELECT oeb11 INTO l_oeb11 FROM oeb_file 
        WHERE oeb01 = sr.ogb31
          AND oeb03 = sr.ogb32
       IF SQLCA.sqlcode THEN
         LET l_oeb11 = ''
       END IF
    LET flag = 0                                                                                                             
    SELECT img09 INTO l_img09  FROM img_file WHERE img01 = sr.ogb04                                                                 
               AND img02 = sr.ogb09 AND img03 = sr.ogb091                                                                           
               AND img04 = sr.ogb092                                                                                                
    DECLARE r920_d  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
                  WHERE rvbs01 = sr.oga01 AND rvbs02 = sr.ogb03  
                  AND rvbs00<>'aqct800'   #MOD-BB0203 add                  
                  ORDER BY  rvbs04                                                                                                  
    FOREACH  r920_d INTO l_rvbs.*                                                                                                   
         LET flag=1
         EXECUTE insert_prep2 USING  sr.oga01,sr.ogb03,l_rvbs.rvbs03,                                                               
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
                                     sr.ogb06,sr.ima021,sr.ogb05,sr.ogb12,                                                          
                                     l_img09                                                                                        
                                                                                                                                    
    END FOREACH                                                                                                                     
    CASE l_ogb17 #多倉儲批出貨否 (Y/N)
       WHEN 'Y'
          LET l_sql=" SELECT ogc09,ogc091,ogc16,ogc092  FROM ogc_file ",
                    " WHERE ogc01 = '",sr.oga01,"' AND ogc03 ='",sr.ogb03,"'"
       WHEN 'N'
          LET l_sql=" SELECT ogb09,ogb091,ogb16,ogb092 FROM ogb_file",
                    " WHERE ogb01 = '",sr.oga01,"' AND ogb03 ='",sr.ogb03,"'"
    END CASE
    PREPARE r500_p1 FROM l_sql
    DECLARE r500_c1 CURSOR FOR r500_p1
    LET i=1
    FOREACH r500_c1 INTO l_ogc.*
       IF STATUS THEN EXIT FOREACH END IF
       EXECUTE insert_prep3 USING
          sr.oga01,sr.ogb03,l_ogc.ogc09,l_ogc.ogc091,
          l_ogc.ogc092,i,l_ogc.ogc16
       LET i = i+1
    END FOREACH
       EXECUTE insert_prep USING 
          sr.oga01,sr.oaydesc,sr.oga02,sr.oga021,sr.gen02,
          sr.gem02,sr.oga032,sr.oga03,
          sr.occ02,sr.oga04,sr.oga044,sr.ocd221,
          sr.ocd222,sr.ocd223,l_ocd230,l_ocd231,sr.oga41,sr.oac02,   #FUN-720014 add ocd230/231
          sr.oga42,sr.oac02_2,sr.oga43,sr.ged02,sr.oga47, #FUN-990074 add ged02     
          sr.oga48,sr.oga16,sr.ocf101,sr.ocf102,
          sr.ocf103,sr.ocf104,sr.ocf105,sr.ocf106,
          sr.ocf107,sr.ocf108,sr.ocf109,sr.ocf110,
          sr.ocf111,sr.ocf112,sr.ogb03,sr.ogb31,
          sr.ogb32,sr.ogb04,sr.ima02,sr.ima021,
          sr.ogb092,sr.ogb05,sr.ogb06,sr.ogb12,sr.ogb19,
          sr.ogb910,sr.ogb912,sr.ogb913,
          sr.ogb915,sr.azi03,sr.azi04,sr.azi05,sr.oga27,
          l_oeb11,
          l_unit_ep,
          sr.ogb09,sr.ogb091,l_message,flag,   #No.FUN-860026  add flag
          "",l_img_blob,"N",""  #FUN-940044 #TQC-C10039 add ""
     END FOREACH
 
     #列印整張備註                                                          
     LET l_sql = "SELECT oga01 FROM oga_file ",
                 " WHERE ",tm.wc CLIPPED,      
                 "   ORDER BY oga01"           
     PREPARE r500_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN      
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM  
     END IF           
     DECLARE r500_cs2 CURSOR FOR r500_prepare2
                                                                                
     FOREACH r500_cs2 INTO sr.oga01
        #整張備註
        DECLARE oao_c2 CURSOR FOR  
         SELECT * FROM oao_file
          WHERE oao01=sr.oga01 AND oao03=0 AND (oao05='1' OR oao05='2')
          ORDER BY oao04                                
        FOREACH oao_c2 INTO oao.* 
           IF NOT cl_null(oao.oao06) THEN
              EXECUTE insert_prep1 USING
                 sr.oga01,oao.oao03,oao.oao04,oao.oao05,oao.oao06
           END IF                                         
        END FOREACH
     END FOREACH    
    #修改成新的子報表的寫法(可組一句主要SQL,五句子報表SQL)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",                                                          
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                             
                 " WHERE oao03 =0 AND oao05='1'","|",                                                                               
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                             
                 " WHERE oao03!=0 AND oao05='1'","|",                                                                               
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                             
                 " WHERE oao03!=0 AND oao05='2'","|",                                                                               
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                             
                 " WHERE oao03 =0 AND oao05='2'","|",   
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
            ,"|","SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED #No.FUN-920103
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oga01,oga02')
         RETURNING tm.wc
     ELSE                                 #No.FUN-860026
        LET tm.wc = ''                        #No.FUN-860026
     END IF
     LET g_str = tm.wc,";",tm.d,";",tm.c     #MOD-850085     #No.FUN-860026 add tm.c     
                ,";",g_aza.aza131            #DEV-D30029	

     #FUN-940044  START
     LET g_cr_table = l_table
     #LET g_cr_gcx01 = "axmi010"  #TQC-C10039 mark--
     LET g_cr_apr_key_f = "oga01"
#TQC-C10039--start--mark---
     #LET l_ii = 1

     #CALL g_cr_apr_key.clear()  

     #FOREACH r500_curs4 INTO l_key.* 
     #  LET g_cr_apr_key[l_ii].v1 = l_key.v1
     #  LET l_ii = l_ii + 1 
     #END FOREACH
#TQC-C10039--end--mark---
     #FUN-940044  END
     
     CALL cl_prt_cs3('axmr500','axmr500',g_sql,g_str)  
END FUNCTION
 
FUNCTION ocf_c(str)
  DEFINE str    LIKE occ_file.occ46     # No.MOD-690064 VARCHAR(40)
  # 把麥頭內'PPPPPP'字串改為 P/O NO (ofa.ofa10)
  # 把麥頭內'CCCCCC'字串改為 CTN NO (ofa.ofa45)
  # 把麥頭內'DDDDDD'字串改為 CTN NO (ofa.ofa46)
  FOR i=1 TO 20
    LET j=i+5
    IF str[i,j]='PPPPPP' THEN LET str[i,40]=g_po_no   RETURN str END IF
    IF str[i,j]='CCCCCC' THEN LET str[i,j]=g_ctn_no1 RETURN str END IF
    IF str[i,j]='DDDDDD' THEN LET str[i,j]=g_ctn_no2 RETURN str END IF
  END FOR
  RETURN str
END FUNCTION
 
FUNCTION r500_err_ana(ls_showmsg)    #FUN-650020
   DEFINE ls_showmsg  STRING
   DEFINE lc_oga03    LIKE oga_file.oga03
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5        # No.FUN-680137 SMALLINT
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET lc_oga03 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
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
    WHERE occ01=lc_oga03
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].oga01   = g_oga01
   LET g_show_msg[li_newerrno].oga03   = lc_oga03
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
#No:FUN-9C0071--------精簡程式-----
