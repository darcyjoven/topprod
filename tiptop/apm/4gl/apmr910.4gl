# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: apmr910.4gl
# Desc/riptions..: 採購變更單列印
# Input parameter:
# Return code....:
# Date & Author..: 93/12/17 By Jackson
# Modify.........: No.8999 04/01/27 Kammy 付款條件/送貨地址等只印代碼，應改
#                                         印說明
# Modify.........: No.9153 04/07/07 Wiky za抓不到資料g_rlang讀不出來
# Modify.........: No.FUN-550114 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580004 05/08/03 By day 報表轉xml
# Modify.........: No.FUN-5A0139 05/10/24 By Pengu 調整報表的格式
# Modify.........: No.MOD-5A0436 05/10/28 By Echo 勾選「其他特殊列印條件」選擇語言別:「1:英文」，產生的報表還是繁體中文
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.MOD-640066 06/04/08 By vivien 打印表中顯示規格
# Modify.........: No.FUN-680136 06/09/05 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-660067 06/10/05 By rainy  傳g_xml參數
# Modify.........: No.FUN-690119 06/10/17 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.TQC-6C0135 06/12/27 By Mandy apmr910 (1)採購單位/訂購量若使用使用計價單位時應改秀計價單位/計價數量
# Modify.........:                                         (2)只要變更後數量或變更後單價有任一個做異動時,變更後金額就應印出
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740260 07/04/23 By Claire 修改TQC-6C0135
# Modify.........: No.FUN-7B0142 07/12/11 By jamie 不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.MOD-870203 08/07/16 By Smapmin 清空變數值
# Modify.........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
# Modify.........: No.MOD-930264 09/04/07 By liuxqa 在取pnd_file的值的時候，未考慮pnd03這個索引，導致這個臨時表做外聯結時，會有重復資料。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A70121 10/07/29 By yinhy 畫面條件選項增加一個選項，列印廠商料號品名規格額外說明
# Modify.........: No:MOD-A80232 10/08/31 By Smapmin mark不必要的程式段
# Modify.........: No:MOD-AB0020 10/11/04 By Smapmin 備註改用子報表的方式呈現
# Modify.........: No.FUN-B30062 11/03/28 By xianghui 新增列印：變更理由碼、稅別、客戶訂單編號、專案代號、WBS編碼、活動代號、MOS
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-940043 11/10/14 By huangtao CR報表列印EF簽核圖檔 OR TIPTOP自訂簽核欄位 
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片调整
# Modify.........: No:TQC-C70211 12/07/31 By yangtt 新增"變更理由碼"及"說明內容"
# Modify.........: No:TQC-CC0079 12/12/13 By qirl 增加欄位開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004-begin
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item    LIKE type_file.num5   	#No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004-end
   DEFINE
     tm  RECORD				# Print condition RECORD
#        wc   LIKE type_file.chr1000,   # Where condition #No.FUN-680136 VARCHAR(500)
         wc   STRING,                     #----TQC-CC0079----add--
         a    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
         b    LIKE type_file.chr1,   	#No.TQC-A70121 VARCHAR(1)
         more LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1)
         END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115    #No.FUN-580004
DEFINE   g_sma116        LIKE sma_file.sma116    #No.FUN-580004
#DEFINE   g_rlang_2       LIKE type_file.chr1     #No.FUN-580004 #No.FUN-680136 VARCHAR(1)
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING     
DEFINE  l_table2   STRING     #add by No.TQC-A70121                                             
DEFINE  l_str      STRING   
#No.FUN-710082--end  
 
MAIN
   OPTIONS
     INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)     #add by No.TQC-A70121
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
 
   LET g_xml.subject = ARG_VAL(13)
   LET g_xml.body = ARG_VAL(14)
   LET g_xml.recipient = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_rlang) THEN
      LET g_rlang = g_lang
   END IF
  #LET g_rlang_2 = g_rlang              #No.FUN-580004
 
   #No.FUN-710082--begin
   LET g_sql ="pna01.pna_file.pna01,    pna02.pna_file.pna02,",
              "pna04.pna_file.pna04,    pna08.pna_file.pna08,",
              "pna08b.pna_file.pna08b,  pna10.pna_file.pna10,",
              "pna10b.pna_file.pna10b,  pna09.pna_file.pna09,",
              "pna09b.pna_file.pna09b,  pna11.pna_file.pna11,",
              "pna11b.pna_file.pna11b,  pna12.pna_file.pna12,",
              "pna12b.pna_file.pna12b,",
              "pna15.pna_file.pna15,    azf03.azf_file.azf03,",    #TQC-C70211 add
              "pmm09.pmm_file.pmm09,",
              "pmm04.pmm_file.pmm04,    pmc03.pmc_file.pmc03,",
              "pnb01.pnb_file.pnb01,    pnb02.pnb_file.pnb02,",
              "pnb03.pnb_file.pnb03,    pnb04b.pnb_file.pnb04b,",
              "pnb041b.pnb_file.pnb041b,pnb07b.pnb_file.pnb07b,",
              "pnb20b.pnb_file.pnb20b,  pnb31b.pnb_file.pnb31b,",
              "pnb33b.pnb_file.pnb33b,  pnb04a.pnb_file.pnb04a,",
              "pnb041a.pnb_file.pnb041a,pnb07a.pnb_file.pnb07a,",
              "pnb20a.pnb_file.pnb20a,  pnb31a.pnb_file.pnb31a,",
              "pnb33a.pnb_file.pnb33a,  pnb50.pnb_file.pnb50,",
              "pnb51.pnb_file.pnb51,    pnb32a.pnb_file.pnb32a,",
              "pnb32b.pnb_file.pnb32b,  pnb80b.pnb_file.pnb80b,",
              "pnb81b.pnb_file.pnb81b,  pnb82b.pnb_file.pnb82b,",
              "pnb83b.pnb_file.pnb83b,  pnb84b.pnb_file.pnb84b,",
              "pnb85b.pnb_file.pnb85b,  pnb86b.pnb_file.pnb86b,",
              "pnb87b.pnb_file.pnb87b,  pnb80a.pnb_file.pnb80a,",
              "pnb81a.pnb_file.pnb81a,  pnb82a.pnb_file.pnb82a,",
              "pnb83a.pnb_file.pnb83a,  pnb84a.pnb_file.pnb84a,",
              "pnb85a.pnb_file.pnb85a,  pnb86a.pnb_file.pnb86a,",
              "pnb87a.pnb_file.pnb87a,  pnb90.pnb_file.pnb90,",
              "pnb91.pnb_file.pnb91,    pmm22.pmm_file.pmm22,",
             #"pmc911.pmc_file.pmc911,",  #FUN-7B0142 mark
              "pma02.pma_file.pma02,    pma02n.pma_file.pma02,",
              "oah02.oah_file.oah02,    oah02n.oah_file.oah02,",
              "pme031.pme_file.pme031,  pme032.pme_file.pme032,",
              "pme033.pme_file.pme033,  pme034.pme_file.pme034,",
              "pme035.pme_file.pme035,  pme031a.pme_file.pme031,",
              "pme032a.pme_file.pme032, pme033a.pme_file.pme033,",
              "pme034a.pme_file.pme034, pme035a.pme_file.pme035,",
              "pme031b.pme_file.pme031, pme032b.pme_file.pme032,",
              "pme033b.pme_file.pme033, pme034b.pme_file.pme034,",
              "pme035b.pme_file.pme035, pme031c.pme_file.pme031,",
              "pme032c.pme_file.pme032, pme033c.pme_file.pme033,",
              "pme034c.pme_file.pme034, pme035c.pme_file.pme035,",
              "ima021.ima_file.ima021,  ima021a.ima_file.ima021,",
              "strb.type_file.chr1000,  stra.type_file.chr1000,",
              "amount.pmn_file.pmn88,   azi03.azi_file.azi03,",
              "azi04.azi_file.azi04,",   
              "l_count.type_file.num5,",   #No.TQC-A70121
              "pnb34a.pnb_file.pnb34a,  pnb34b.pnb_file.pnb34b,",  #FUN-B30062
              "pnb35a.pnb_file.pnb35a,  pnb35b.pnb_file.pnb35b,",  #FUN-B30062
              "pnb36a.pnb_file.pnb36a,  pnb36b.pnb_file.pnb36b,",    #FUN-B30062
               "sign_type.type_file.chr1,", #FUN-940043 add
               "sign_img.type_file.blob,",  #FUN-940043 add
               "sign_show.type_file.chr1,",   #FUN-940043 add
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
 
   LET l_table = cl_prt_temptable('apmr910',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql= "pnd01.pnd_file.pnd01,",
              "pnd02.pnd_file.pnd02,",
              "pnd03.pnd_file.pnd03,",
              "pnd04.pnd_file.pnd04"
 
   LET l_table1= cl_prt_temptable('apmr9101',g_sql) CLIPPED
   IF l_table1= -1 THEN EXIT PROGRAM END IF
   #No.FUN-710082--end  
   
   #No.TQC-A70121--start
   LET g_sql = "pmq01.pmq_file.pmq01,",
               "pmq02.pmq_file.pmq02,",
               "pmq03.pmq_file.pmq03,",
               "pmq04.pmq_file.pmq04,",
               "pmq05.pmq_file.pmq05,",
               "pna01.pna_file.pna01,",
               "pnb03.pnb_file.pnb03"
   LET l_table2= cl_prt_temptable('apmr9102',g_sql) CLIPPED
   IF l_table2= -1 THEN EXIT PROGRAM END IF
   #No.TQC-A70121--end
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r910_tm(0,0)		# Input print condition
      ELSE CALL apmr910()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r910_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW r910_w AT p_row,p_col WITH FORM "apm/42f/apmr910"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = '1'
   LET tm.b    = 'N'            #No.TQC-A70121
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
  #LET g_rlang_2 = g_rlang              #No.FUN-580004
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pna01,pna04,pna02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
     #--TQC-CC0079--add---star---
     ON ACTION CONTROLP
        CASE WHEN INFIELD(pna01)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pna01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pna01
              NEXT FIELD pna01
        OTHERWISE EXIT CASE
        END CASE
     #--TQC-CC0079--add---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r910_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#----TQC-CC0079----add--star--
     IF tm.wc.getLength() > 1000 THEN
        CALL cl_err('pna01','azz-533',1)
      CONTINUE WHILE
     END IF
#----TQC-CC0079----add--end--
   DISPLAY BY NAME tm.a,tm.b,tm.more # Condition  #No.TQC-A70121 add tm.b
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS   #No.TQC-A70121 add tm.b
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
      
      #No.TQC-A70121--start
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES "[YN]" THEN
            NEXT FIELD b
         END IF
      #No.TQC-A70121--end   
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,
                           g_bgjob,g_time,g_prtway,g_copies
           #LET g_rlang_2 = g_rlang              #MOD-5A0436
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r910_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr910'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr910','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",    #No.TQC-A70121
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr910',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r910_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr910()
   ERROR ""
END WHILE
   CLOSE WINDOW r910_w
END FUNCTION
 
FUNCTION apmr910()
DEFINE l_name   LIKE type_file.chr20, 	# External(Disk) file name       #No.FUN-680136 VARCHAR(20)
       l_time   LIKE type_file.chr8,  	# Used time for running the job  #No.FUN-680136 VARCHAR(8)
  #    l_sql    LIKE type_file.chr1000,	# RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
       l_sql    STRING,    #----TQC-CC0079----add--
       l_chr    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_za05   LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(40)
       l_pmm22  LIKE pmm_file.pmm22,
       l_count  LIKE type_file.num5,    #No.FUN-A80005 add
       sr   RECORD
             pna01  LIKE pna_file.pna01,  #採購單號
             pna02  LIKE pna_file.pna02,  #採購序號
             pna04  LIKE pna_file.pna04,  #採購日期
             pna08  LIKE pna_file.pna08, #NO:7203
             pna08b LIKE pna_file.pna08b,
             pna10  LIKE pna_file.pna10,
             pna10b LIKE pna_file.pna10b,
             pna09  LIKE pna_file.pna09,
             pna09b LIKE pna_file.pna09b,
             pna11  LIKE pna_file.pna11,
             pna11b LIKE pna_file.pna11b,
             pna12  LIKE pna_file.pna12,
             pna12b LIKE pna_file.pna12b,
             pna15  LIKE pna_file.pna15,    #TQC-C70211 add
             azf03  LIKE azf_file.azf03,    #TQC-C70211 add
             pmm09 LIKE pmm_file.pmm09,  #廠商編號
             pmm04 LIKE pmm_file.pmm04,  #單據日期
             pmc03 LIKE pmc_file.pmc03,
             pnb   RECORD LIKE pnb_file.*,
             pmm22 LIKE pmm_file.pmm22
            #pmc911 LIKE pmc_file.pmc911  #FUN-7B0142 mark
            END RECORD
DEFINE l_i,l_cnt          LIKE type_file.num5      #No.FUN-580004  #No.FUN-680136 SMALLINT
DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580004
#No.FUN-710082--begin
DEFINE sr1  RECORD
             pnd01  LIKE pnd_file.pnd01,  
             pnd02  LIKE pnd_file.pnd02,  
             pnd03  LIKE pnd_file.pnd03,  
             pnd04  LIKE pnd_file.pnd04  
            END RECORD
#No.TQC-A70121--start
DEFINE sr2  RECORD
             pmq01    LIKE pmq_file.pmq01,
             pmq02    LIKE pmq_file.pmq02,
             pmq03    LIKE pmq_file.pmq03,
             pmq04    LIKE pmq_file.pmq04,
             pmq05    LIKE pmq_file.pmq05
            END RECORD
#No.TQC-A70121--end    
DEFINE l_pma02    LIKE pma_file.pma02,
       l_pma02n   LIKE pma_file.pma02,
       l_pnz02    LIKE pnz_file.pnz02, #FUN-930113
       l_pnz02n   LIKE pnz_file.pnz02, #FUN-930113
       l_pme031   LIKE pme_file.pme031,
       l_pme032   LIKE pme_file.pme032,
       l_pme033   LIKE pme_file.pme033,
       l_pme034   LIKE pme_file.pme034,
       l_pme035   LIKE pme_file.pme035,
       l_pme031a  LIKE pme_file.pme031,
       l_pme032a  LIKE pme_file.pme032,
       l_pme033a  LIKE pme_file.pme033,
       l_pme034a  LIKE pme_file.pme034,
       l_pme035a  LIKE pme_file.pme035,
       l_pme031b  LIKE pme_file.pme031,
       l_pme032b  LIKE pme_file.pme032,
       l_pme033b  LIKE pme_file.pme033,
       l_pme034b  LIKE pme_file.pme034,
       l_pme035b  LIKE pme_file.pme035,
       l_pme031c  LIKE pme_file.pme031,
       l_pme032c  LIKE pme_file.pme032,
       l_pme033c  LIKE pme_file.pme033,
       l_pme034c  LIKE pme_file.pme034,
       l_pme035c  LIKE pme_file.pme035,
       l_flag   LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1) 
DEFINE l_str2       LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(100)
       l_str1       LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(100)
       l_ima021     LIKE ima_file.ima021,
       l_ima906     LIKE ima_file.ima906,
       l_ima021a    LIKE ima_file.ima021,
       l_ima906a    LIKE ima_file.ima906,
       l_pnb85b     STRING,
       l_pnb82b     STRING,
       l_pnb20b     STRING,
       l_pnb85a     STRING,
       l_pnb82a     STRING,
       l_pnb20a     STRING
DEFINE l_amount     LIKE pmn_file.pmn88 #金額 #MOD-6C0135 add
#No.FUN-710082--end  
DEFINE l_zo041      LIKE zo_file.zo041   #FUN-810029 add
DEFINE l_zo05       LIKE zo_file.zo05    #FUN-810029 add
DEFINE l_zo09       LIKE zo_file.zo09    #FUN-810029 add
DEFINE l_pna01      LIKE pna_file.pna01  #MOD-AB0020
DEFINE l_pna02      LIKE pna_file.pna02  #MOD-AB0020
#TQC-C10039--MARK--STR
   #FUN-B940043 START
   DEFINE l_img_blob         LIKE type_file.blob
#  DEFINE l_ii               INTEGER 
#  DEFINE l_key              RECORD 
#         v1                 LIKE pna_file.pna01,
#         v2                 LIKE pna_file.pna02
#         END RECORD 
#  #FUN-B940043 END
#TQC-C10039--MARK--END   
   LOCATE l_img_blob IN MEMORY      #FUN-B940043 add 
   
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr910'
     SELECT zo02,zo041,zo05,zo09 INTO g_company,l_zo041,l_zo05,l_zo09   #FUN-810029 add zo041,zo05,zo09
       FROM zo_file WHERE zo01 = g_rlang
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  #No.FUN-580004
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pnauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pnagrup MATCHES '",g_grup CLIPPED,"*'"
    #      END IF
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pnagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pnauser', 'pnagrup')
     #End:FUN-980030
 
#    LET l_sql = " SELECT pnd03,pnd04 FROM pnd_file ",    #No.FUN-710082
     LET l_sql = " SELECT pnd01,pnd02,pnd03,pnd04 FROM pnd_file ",    #No.FUN-710082
                 "  WHERE pnd01 = ? AND pnd02 = ? ",
                 #"  AND pnd03 = ?",       #No.MOD-930264 add   #MOD-AB0020
                 "  ORDER BY pnd03 "
     PREPARE r910_pr2 FROM l_sql
     DECLARE r910_cs2 CURSOR FOR r910_pr2
     IF SQLCA.SQLCODE THEN
        CALL cl_err('prepare:#2',sqlca.sqlcode,1)
     END IF
     LET l_sql = " SELECT pna01,pna02,pna04,",
                 "        pna08,pna08b,", #NO:7203
                 "        pna10,pna10b,pna09,pna09b,pna11,pna11b,",
                 "        pna12,pna12b,pna15,azf03,",     #TQC-C70211 add pna15,azf03
                 "        pmm09,pmm04,pmc03, ",
                 "        pnb_file.*,pmm22 ",             #FUN-7B0142 mod
                #"        pnb_file.*,pmm22,pmc911 ",      #FUN-7B0142 mark
                #"   FROM pna_file,pnb_file,pmm_file,OUTER pmc_file ",
                 "   FROM pna_file  LEFT OUTER JOIN pnb_file ON pna01=pnb01 AND pna02=pnb02 ",
                 "                  LEFT OUTER JOIN azf_file ON pna15=azf01 AND azf02='2',",  #TQC-C70211 add
                 "        pmm_file  LEFT OUTER JOIN pmc_file ON pmm09 = pmc01 ",
                 "  WHERE pna01=pmm01 AND pmm18 !='X' ",
                 "    AND pnaacti = 'Y' ",
                 "    AND pna05 != 'X' ",
                 "    AND ",tm.wc CLIPPED
     CASE tm.a
       WHEN '1' LET l_sql=l_sql CLIPPED," AND pnaconf='N' "
       WHEN '2' LET l_sql=l_sql CLIPPED," AND pnaconf='Y' "
     END CASE
     LET l_sql=l_sql CLIPPED," ORDER BY pna01,pna02,pnb03"   #No.FUN-710082
 
     PREPARE r910_pr1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r910_cs1 CURSOR FOR r910_pr1
#TQC-C10039--MARK--str
#    #FUN-940043 START
#    LET l_sql = " SELECT pna01,pna02",
#                "   FROM pna_file  LEFT OUTER JOIN pnb_file ON pna01=pnb01 AND pna02=pnb02,pmm_file LEFT OUTER JOIN pmc_file ON pmm09 = pmc01 ",
#                "  WHERE pna01=pmm01 AND pmm18 !='X' ",
#                "    AND pnaacti = 'Y' ",
#                "    AND pna05 != 'X' ",
#                "    AND ",tm.wc CLIPPED
#    CASE tm.a
#      WHEN '1' LET l_sql=l_sql CLIPPED," AND pnaconf='N' "
#      WHEN '2' LET l_sql=l_sql CLIPPED," AND pnaconf='Y' "
#    END CASE
#    LET l_sql=l_sql CLIPPED," ORDER BY pna01,pna02"   #No.FUN-710082
#
#    PREPARE r910_pr4 FROM l_sql
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('prepare4:',SQLCA.sqlcode,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#       EXIT PROGRAM
#          
#    END IF
#    DECLARE r910_cs4 CURSOR FOR r910_pr4
#    #FUN-940043 END
#TQC-C10039--MARK--end
     
    #LET g_rlang = g_rlang_2                             #No.FUN-580004
     #No.FUN-710082--begin
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1) 
     CALL cl_del_data(l_table2)      #No.TQC-A70121
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?) " #TQC-C10039 add 1?  #FUN-B940043 add 3?  #FUN-7B0142 拿掉一個?  #TQC-A70121 加一個?   #FUN-B30062 最後加了6個 #TQC-C70211 add 2?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?) "
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     
     #No.TQC-A70121--start
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep2:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     #No.TQC-A70121--end
#    CALL cl_outnam('apmr910') RETURNING l_name
##No.FUN-580004-begin
##---No.FUN-5A0139 改由p_zaa設定
##    IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
##           LET g_zaa[35].zaa06 = "Y"
##           LET g_zaa[36].zaa06 = "Y"
##           LET g_zaa[37].zaa06 = "N"
##           LET g_zaa[38].zaa06 = "N"
##    ELSE
##           LET g_zaa[37].zaa06 = "Y"
##           LET g_zaa[38].zaa06 = "Y"
##           LET g_zaa[35].zaa06 = "N"
##           LET g_zaa[36].zaa06 = "N"
##    END IF
##----No.FUN-5A0139 end
#    #TQC-6C0135--------------add------str---
#    #zaa06隱藏否
#    IF g_sma.sma116 MATCHES '[13]' THEN #使用計價單位
#        LET g_zaa[40].zaa06 = "Y"    #採購單位
#        LET g_zaa[41].zaa06 = "Y"    #訂購量
#        LET g_zaa[42].zaa06 = "N"    #計價單位
#        LET g_zaa[43].zaa06 = "N"    #計價數量
#    ELSE
#        LET g_zaa[40].zaa06 = "N"    #採購單位
#        LET g_zaa[41].zaa06 = "N"    #訂購量
#        LET g_zaa[42].zaa06 = "Y"    #計價單位
#        LET g_zaa[43].zaa06 = "Y"    #計價數量
#    END IF
#    #TQC-6C0135--------------add------end---
#    IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
#           LET g_zaa[34].zaa06 = "N"
#    ELSE
#           LET g_zaa[34].zaa06 = "Y"
#    END IF
#    CALL cl_prt_pos_len()
##No.FUN-580004-end
#    START REPORT r910_rep TO l_name
#    LET g_pageno = 0
 
 
     FOREACH r910_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       ## Bug No. 7252
      #FUN-7B0142 mark
      #IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN
      #    LET g_rlang = sr.pmc911
      #END IF
      #FUN-7B0142 mark
       ##
      #IF cl_null(g_rlang) THEN     #No.9153
      #   LET g_rlang = g_lang
      #END IF
      
       LET l_pma02 = '' LET l_pnz02 = '' #FUN-930113
       LET l_pma02n= '' LET l_pnz02n= '' #FUN-930113
       SELECT pma02 INTO l_pma02    FROM pma_file WHERE pma01 = sr.pna10
       SELECT pma02 INTO l_pma02n   FROM pma_file WHERE pma01 = sr.pna10b
       SELECT pnz02 INTO l_pnz02    FROM pnz_file WHERE pnz01 = sr.pna09 #FUN-930113 oah-->pnz
       SELECT pnz02 INTO l_pnz02n   FROM pnz_file WHERE pnz01 = sr.pna09b #FUN-930113 oah-->pnz
 
       LET l_pme031 = '' LET l_pme032 = '' LET l_pme033 = '' LET l_pme034 = '' LET l_pme035 = ''
       LET l_pme031a= '' LET l_pme032a= '' LET l_pme033a= '' LET l_pme034a= '' LET l_pme035a= ''
       LET l_pme031b= '' LET l_pme032b= '' LET l_pme033b= '' LET l_pme034b= '' LET l_pme035b= ''
       LET l_pme031c= '' LET l_pme032c= '' LET l_pme033c= '' LET l_pme034c= '' LET l_pme035c= ''
       IF NOT cl_null(sr.pna11b) THEN
          SELECT pme031,pme032,pme033,pme034,pme035
            INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
            FROM pme_file
           WHERE pme01 = sr.pna11
          SELECT pme031,pme032,pme033,pme034,pme035
            INTO l_pme031a,l_pme032a,l_pme033a,l_pme034a,l_pme035a FROM pme_file
           WHERE pme01 = sr.pna11b
       END IF
       IF NOT cl_null(sr.pna12b) THEN
          SELECT pme031,pme032,pme033,pme034,pme035
            INTO l_pme031b,l_pme032b,l_pme033b,l_pme034b,l_pme035b
            FROM pme_file
           WHERE pme01 = sr.pna12
          SELECT pme031,pme032,pme033,pme034,pme035
            INTO l_pme031c,l_pme032c,l_pme033c,l_pme034c,l_pme035c FROM pme_file
           WHERE pme01 = sr.pna12b
       END IF
 
       SELECT azi03,azi04,azi05
         INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取    #No.CHI-6A0004
         FROM azi_file
        WHERE azi01=sr.pmm22
 
       LET l_ima021 = ''   #MOD-870203
       LEt l_ima906 = ''   #MOD-870203
       SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
                          WHERE ima01=sr.pnb.pnb04b
  
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906
             WHEN "2"
                 CALL cl_remove_zero(sr.pnb.pnb85b) RETURNING l_pnb85b
                 LET l_str2 = l_pnb85b, sr.pnb.pnb83b CLIPPED
                 IF cl_null(sr.pnb.pnb85b) OR sr.pnb.pnb85b = 0 THEN
                     CALL cl_remove_zero(sr.pnb.pnb82b) RETURNING l_pnb82b
                     LET l_str2 = l_pnb82b, sr.pnb.pnb80b CLIPPED
                 ELSE
                    IF NOT cl_null(sr.pnb.pnb82b) AND sr.pnb.pnb82b > 0 THEN
                       CALL cl_remove_zero(sr.pnb.pnb82b) RETURNING l_pnb82b
                       LET l_str2 = l_str2 CLIPPED,',',l_pnb82b, sr.pnb.pnb80b CLIPPED
                    END IF
                 END IF
             WHEN "3"
                 IF NOT cl_null(sr.pnb.pnb85b) AND sr.pnb.pnb85b > 0 THEN
                     CALL cl_remove_zero(sr.pnb.pnb85b) RETURNING l_pnb85b
                     LET l_str2 = l_pnb85b , sr.pnb.pnb83b CLIPPED
                 END IF
          END CASE
       ELSE
       END IF
 
       LET l_ima021a = ''   #MOD-870203
       LET l_ima906a = ''   #MOD-870203 
       SELECT ima021,ima906 INTO l_ima021a,l_ima906a FROM ima_file
                          WHERE ima01=sr.pnb.pnb04a
  
       LET l_str1 = ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906a
             WHEN "2"
                 CALL cl_remove_zero(sr.pnb.pnb85a) RETURNING l_pnb85a
                 LET l_str1 = l_pnb85a, sr.pnb.pnb83a CLIPPED
                 IF cl_null(sr.pnb.pnb85a) OR sr.pnb.pnb85a = 0 THEN
                     CALL cl_remove_zero(sr.pnb.pnb82a) RETURNING l_pnb82a
                     LET l_str1 = l_pnb82a, sr.pnb.pnb80a CLIPPED
                 ELSE
                    IF NOT cl_null(sr.pnb.pnb82a) AND sr.pnb.pnb82a > 0 THEN
                       CALL cl_remove_zero(sr.pnb.pnb82a) RETURNING l_pnb82a
                       LET l_str1 = l_str1 CLIPPED,',',l_pnb82a, sr.pnb.pnb80a CLIPPED
                    END IF
                 END IF
             WHEN "3"
                 IF NOT cl_null(sr.pnb.pnb85a) AND sr.pnb.pnb85a > 0 THEN
                     CALL cl_remove_zero(sr.pnb.pnb85a) RETURNING l_pnb85a
                     LET l_str1 = l_pnb85a , sr.pnb.pnb83a CLIPPED
                 END IF
          END CASE
       ELSE
       END IF
 
       IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
         #IF sr.pnb.pnb80b <> sr.pnb.pnb86b THEN  #No.TQC-6B0137 mark
          IF sr.pnb.pnb07b <> sr.pnb.pnb86b THEN  #No.TQC-6B0137 mod
             CALL cl_remove_zero(sr.pnb.pnb20b) RETURNING l_pnb20b
             LET l_str2 = l_str2 CLIPPED,"(",l_pnb20b,sr.pnb.pnb07b CLIPPED,")"
          END IF
         #IF sr.pnb.pnb80a <> sr.pnb.pnb86a THEN  #NO.TQC-6B0137 mark
          IF sr.pnb.pnb07a <> sr.pnb.pnb86a THEN  #NO.TQC-6B0137 mod
             CALL cl_remove_zero(sr.pnb.pnb20a) RETURNING l_pnb20a
             LET l_str1 = l_str1 CLIPPED,"(",l_pnb20a,sr.pnb.pnb07a CLIPPED,")"
          END IF
       END IF
 
       #TC-6C0135 --------------add--------str-----
       #只要變更後計價數量有值,變更後單價無值,金額=變更後計價數量*變更前單價
       IF NOT cl_null(sr.pnb.pnb87a) THEN        #變更后計價數量
           IF cl_null(sr.pnb.pnb31a) THEN #變更後單價
              LET l_amount = sr.pnb.pnb87a*sr.pnb.pnb31b
         #TQC-740260-begin-add
         ELSE 
           IF NOT cl_null(sr.pnb.pnb31a) THEN #變更後單價
              LET l_amount = sr.pnb.pnb87a*sr.pnb.pnb31a
           END IF
         #TQC-740260-end-add
         END IF
     #TQC-740260-begin-add
      ELSE
           IF NOT cl_null(sr.pnb.pnb31a) THEN #變更後單價
               LET l_amount = sr.pnb.pnb31a * sr.pnb.pnb87b
           ELSE 
             IF cl_null(sr.pnb.pnb31a) THEN #變更後單價
                LET l_amount = sr.pnb.pnb31b * sr.pnb.pnb87b
             END IF
           END IF
     #TQC-740260-end-add
       END IF
      # #只要變更後單價有值,變更後計價數量無值,金額=變更後單價*變更前計價數量
      # IF NOT cl_null(sr.pnb.pnb31a) THEN #變更後單價
      #     IF cl_null(sr.pnb.pnb87a) THEN #變更後計價數量
      #        LET l_amount = sr.pnb.pnb31a * sr.pnb.pnb87b
      #     END IF
      # END IF
 
       #-----MOD-AB0020---------
       ##FOREACH r910_cs2 USING sr.pna01,sr.pna02 INTO sr1.*  #No.MOD-930264 mark
       #FOREACH r910_cs2 USING sr.pna01,sr.pna02,sr.pnb.pnb03 INTO sr1.*  #No.MOD-930264 mod
       #   IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
       #   EXECUTE insert_prep1 USING sr1.*
       #END FOREACH 
       #-----END MOD-AB0020-----
      #No.TQC-A70121--start
      IF tm.b = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM pmq_file
             WHERE pmq01=sr.pnb.pnb04a AND pmq02=sr.pmm09
          IF l_count !=0  THEN
            DECLARE pmq_cur CURSOR FOR
            SELECT * FROM pmq_file    
              WHERE pmq01=sr.pnb.pnb04a AND pmq02=sr.pmm09 
            ORDER BY pmq04                                        
            FOREACH pmq_cur INTO sr2.*                            
              EXECUTE insert_prep2 USING sr2.pmq01,sr2.pmq02,sr2.pmq03,sr2.pmq04,sr2.pmq05,sr.pna01,sr.pnb.pnb03
            END FOREACH
          END IF
       END IF    
       #No.TQC-A70121--end 
       EXECUTE insert_prep USING
         sr.pna01,sr.pna02,sr.pna04,sr.pna08,sr.pna08b,
         sr.pna10,sr.pna10b,sr.pna09,sr.pna09b,sr.pna11,
         sr.pna11b,sr.pna12,sr.pna12b,sr.pna15,sr.azf03,sr.pmm09,sr.pmm04,   #TQC-C70211 add sr.pna15,sr.azf03
         sr.pmc03,sr.pnb.pnb01,sr.pnb.pnb02,sr.pnb.pnb03,sr.pnb.pnb04b,
         sr.pnb.pnb041b,sr.pnb.pnb07b,sr.pnb.pnb20b,sr.pnb.pnb31b,sr.pnb.pnb33b,
         sr.pnb.pnb04a,sr.pnb.pnb041a,sr.pnb.pnb07a,sr.pnb.pnb20a,sr.pnb.pnb31a,
         sr.pnb.pnb33a,sr.pnb.pnb50,sr.pnb.pnb51,sr.pnb.pnb32a,sr.pnb.pnb32b,
         sr.pnb.pnb80b,sr.pnb.pnb81b,sr.pnb.pnb82b,sr.pnb.pnb83b,sr.pnb.pnb84b,
         sr.pnb.pnb85b,sr.pnb.pnb86b,sr.pnb.pnb87b,sr.pnb.pnb80a,sr.pnb.pnb81a,
         sr.pnb.pnb82a,sr.pnb.pnb83a,sr.pnb.pnb84a,sr.pnb.pnb85a,sr.pnb.pnb86a,
         sr.pnb.pnb87a,sr.pnb.pnb90,sr.pnb.pnb91,sr.pmm22,    #FUN-7B0142 拿掉sr
         l_pma02,l_pma02n,l_pnz02,l_pnz02n,l_pme031, #FUN-930113
         l_pme032,l_pme033,l_pme034,l_pme035,l_pme031a,
         l_pme032a,l_pme033a,l_pme034a,l_pme035a,l_pme031b,
         l_pme032b,l_pme033b,l_pme034b,l_pme035b,l_pme031c,
         l_pme032c,l_pme033c,l_pme034c,l_pme035c,l_ima021,
         l_ima021a,l_str2,l_str1,l_amount,t_azi03,t_azi04,l_count, #No.TQC-A70121
         sr.pnb.pnb34a,sr.pnb.pnb34b,sr.pnb.pnb35a,sr.pnb.pnb35b,sr.pnb.pnb36a,sr.pnb.pnb36b,  #FUN-B30062
         "",l_img_blob,"N",""  #FUN-940043  #TQC-C10039 ADD ""
#      OUTPUT TO REPORT r910_rep(sr.*)
     END FOREACH
     #-----MOD-AB0020---------
     LET l_sql = "SELECT distinct pna01,pna02 FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
     PREPARE r910_p FROM l_sql
     DECLARE r910_c CURSOR FOR r910_p
     FOREACH r910_c INTO l_pna01,l_pna02
        FOREACH r910_cs2 USING l_pna01,l_pna02 INTO sr1.*  
           IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
           EXECUTE insert_prep1 USING sr1.*
        END FOREACH
     END FOREACH
     #-----END MOD-AB0020-----
      
    #str FUN-810029 mod
    #LET l_sql = " SELECT ",l_table CLIPPED,".*,",l_table1 CLIPPED,".*",
    #         #  "   FROM ",l_table CLIPPED,",      ",l_table1 CLIPPED,   #TQC-730088
    #            "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,",      ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
    #            " WHERE pna01 =",l_table1 CLIPPED,".pnd01 ",
    #            "   AND pna02 =",l_table1 CLIPPED,".pnd02 ",
    #            " ORDER BY pna01,pna02,pnb03 "
 
     #-----MOD-AB0020---------
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",
                 "SELECT * FROM ", g_cr_db_str CLIPPED, l_table2 CLIPPED, "|",    
                 "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED    
     #LET l_sql = "SELECT * ",
     #            "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED, " B ON A.pna01 =B.pnd01 AND A.pna02 =B.pnd02 ",
     #            " ORDER BY A.pna01,A.pna02,A.pnb03","|",
     #            " SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED         #No.TQC-A70121
     #-----END MOD-AB0020-----

    #end FUN-810029 mod
            
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'pna01,pna04,pna02')  
        RETURNING tm.wc                                                           
     END IF                      
     LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",g_sma116,";",g_sma115
                              ,";",l_zo041,";",l_zo05,";",l_zo09   #FUN-810029 add
                              ,";",tm.b CLIPPED,g_aza.aza08   #No.TQC-A70121   #FUN-B30062 add aza08  #TQC-CC0079--mark

#    FINISH REPORT r910_rep
 
    #LET g_rlang = g_rlang_2                      #No.FUN-580004
   #FUN-660067--add--start
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #IF g_bgjob='Y' AND g_prtway = 'J' THEN   #MOD-A80232
     #  CALL r910_jmail(l_name)   #MOD-A80232
     #ELSE   #MOD-A80232
#      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   # CALL cl_prt_cs3('apmr910',l_sql,l_str)  #TQC-730088
#TQC-C10039--MOD--STR
   #FUN-940043  START
   LET g_cr_table = l_table
#  LET g_cr_gcx01 = "asmi300"
   LET g_cr_apr_key_f = "pna01|pna02"

#  LET l_ii = 1

#  CALL g_cr_apr_key.clear()  

#  FOREACH r910_cs4 INTO l_key.* 
#    LET g_cr_apr_key[l_ii].v1 = l_key.v1
#    LET g_cr_apr_key[l_ii].v2 = l_key.v2
#    LET l_ii = l_ii + 1 
#  END FOREACH

   #FUN-940043  END
#TQC-C10039--MOD--END   
     CALL cl_prt_cs3('apmr910','apmr910',l_sql,l_str) 
     #END IF   #MOD-A80232
     #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT r910_rep(sr)
#  DEFINE  l_amount LIKE pmn_file.pmn88 #金額 #MOD-6C0135 add
#  DEFINE
#    l_last_sw	LIKE type_file.chr1,   	#No.FUN-680136  VARCHAR(1)
#    l_dash        LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#    l_str         LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(50)
#  sr   RECORD
#         pna01 LIKE pna_file.pna01,  #採購單號
#         pna02 LIKE pna_file.pna02,  #採購序號
#         pna04 LIKE pna_file.pna04,  #採購日期
#         pna08  LIKE pna_file.pna08, #NO:7203
#         pna08b LIKE pna_file.pna08b,
#         pna10  LIKE pna_file.pna10,
#         pna10b LIKE pna_file.pna10b,
#         pna09  LIKE pna_file.pna09,
#         pna09b LIKE pna_file.pna09b,
#         pna11  LIKE pna_file.pna11,
#         pna11b LIKE pna_file.pna11b,
#         pna12  LIKE pna_file.pna12,
#         pna12b LIKE pna_file.pna12b,
#         pmm09 LIKE pmm_file.pmm09,  #廠商編號
#         pmm04 LIKE pmm_file.pmm04,  #單據日期
#         pmc03 LIKE pmc_file.pmc03,
#         pnb   RECORD LIKE pnb_file.*,
#         pmm22 LIKE pmm_file.pmm22,
#         pmc911 LIKE pmc_file.pmc911
#         END RECORD,
#   l_pma02    LIKE pma_file.pma02,
#   l_pma02n   LIKE pma_file.pma02,
#   l_oah02    LIKE oah_file.oah02,
#   l_oah02n   LIKE oah_file.oah02,
#   l_pme031   LIKE pme_file.pme031,
#   l_pme032   LIKE pme_file.pme032,
#   l_pme033   LIKE pme_file.pme033,
#   l_pme034   LIKE pme_file.pme034,
#   l_pme035   LIKE pme_file.pme035,
#   l_add1    LIKE type_file.chr1000,	#No.FUN-680136  VARCHAR(60)
#   l_add2    LIKE type_file.chr1000,	#No.FUN-680136  VARCHAR(60)
#   l_add3    LIKE type_file.chr1000,	#No.FUN-680136  VARCHAR(60)
#   l_pnd03  LIKE pnd_file.pnd03,
#   l_pnd04  LIKE pnd_file.pnd04,
#   p_ima021 LIKE ima_file.ima021,    #No.MOD-640066 
#   l_swich  LIKE type_file.num5,   	#No.FUN-680136 SMALLINT
#   l_flag   LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1) 
##No.FUN-580004-begin
#DEFINE   l_str2       LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(100)
#        l_str1       LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(100)
#        l_ima021     LIKE ima_file.ima021,
#        l_ima906     LIKE ima_file.ima906,
#        l_ima021a    LIKE ima_file.ima021,
#        l_ima906a    LIKE ima_file.ima906,
#        l_pnb85b     STRING,
#        l_pnb82b     STRING,
#        l_pnb20b     STRING,
#        l_pnb85a     STRING,
#        l_pnb82a     STRING,
#        l_pnb20a     STRING
##No.FUN-580004-end
 
 
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN 9
#        PAGE LENGTH g_page_line
# ORDER BY sr.pna01,sr.pna02,sr.pnb.pnb03
 
##No.FUN-580004-begin
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#     PRINT
 
##----No.FUN-5A0139 begin
#     PRINT COLUMN 1,g_x[11] CLIPPED,sr.pmm09 CLIPPED,
#           COLUMN 23,sr.pmc03 CLIPPED,
#           COLUMN 51,g_x[14] CLIPPED,sr.pmm04 CLIPPED,
#           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     PRINT ' '
#     #No.8999
#     LET l_pma02 = '' LET l_oah02 = ''
#     LET l_pma02n= '' LET l_oah02n= ''
#     SELECT pma02 INTO l_pma02    FROM pma_file WHERE pma01 = sr.pna10
#     SELECT oah02 INTO l_oah02    FROM oah_file WHERE oah01 = sr.pna09
#     SELECT pma02 INTO l_pma02n   FROM pma_file WHERE pma01 = sr.pna10b
#     SELECT oah02 INTO l_oah02n   FROM oah_file WHERE oah01 = sr.pna09b
#     #No.8999(end)
#     PRINT COLUMN  1,g_x[13] CLIPPED,sr.pna01 CLIPPED,
#           COLUMN 51,g_x[29] CLIPPED
#     PRINT COLUMN 1,g_x[26] CLIPPED,
#           COLUMN 51,g_x[30] CLIPPED
#     PRINT COLUMN  1,g_x[12] CLIPPED,sr.pna04 CLIPPED,
#           COLUMN  51,g_x[15] CLIPPED,sr.pna02 USING '####'
#     PRINT COLUMN 1,g_x[21] CLIPPED,
#           COLUMN 8,sr.pna08 CLIPPED,'-',l_pma02 CLIPPED,'-',l_oah02 CLIPPED
#     PRINT COLUMN 1,g_x[23] CLIPPED,
#           COLUMN 8,sr.pna08b CLIPPED,'-',l_pma02n CLIPPED,'-',l_oah02n CLIPPED
##-------end
#     LET l_flag = 'Y'
#     LET l_last_sw = 'n'             #FUN-550114
 
#BEFORE GROUP OF sr.pna02
#   SKIP TO TOP OF PAGE
#  PRINT
#  #No.8999
#  IF NOT cl_null(sr.pna11b) THEN
#     SELECT pme031,pme032,pme033,pme034,pme035
#       INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
#       FROM pme_file
#      WHERE pme01 = sr.pna11
#     LET l_add1 = l_pme031 CLIPPED,l_pme032
#     LET l_add2 = l_pme033 CLIPPED,l_pme034
#     LET l_add3 = l_pme035 CLIPPED
#     PRINT g_x[28] CLIPPED,g_x[21] CLIPPED,l_add1
#     IF NOT cl_null(l_add2) THEN
#        PRINT COLUMN 16,l_add2
#     END IF
#     IF NOT cl_null(l_add3) THEN
#        PRINT COLUMN 16,l_add3
#     END IF
#     SELECT pme031,pme032,pme033,pme034,pme035
#       INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035 FROM pme_file
#      WHERE pme01 = sr.pna11b
#     LET l_add1 = l_pme031 CLIPPED,l_pme032
#     LET l_add2 = l_pme033 CLIPPED,l_pme034
#     LET l_add3 = l_pme035 CLIPPED
#     PRINT g_x[28] CLIPPED,g_x[23] CLIPPED,l_add1
#     IF NOT cl_null(l_add2) THEN
#        PRINT COLUMN 16,l_add2
#     END IF
#     IF NOT cl_null(l_add3) THEN
#        PRINT COLUMN 16,l_add3
#     END IF
#  END IF
#  IF NOT cl_null(sr.pna12b) THEN
#     SELECT pme031,pme032,pme033,pme034,pme035
#       INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
#       FROM pme_file
#      WHERE pme01 = sr.pna12
#     LET l_add1 = l_pme031 CLIPPED,l_pme032
#     LET l_add2 = l_pme033 CLIPPED,l_pme034
#     LET l_add3 = l_pme035 CLIPPED
#     PRINT g_x[27] CLIPPED,g_x[21] CLIPPED,l_add1
#     IF NOT cl_null(l_add2) THEN
#        PRINT COLUMN 16,l_add2
#     END IF
#     IF NOT cl_null(l_add3) THEN
#        PRINT COLUMN 16,l_add3
#     END IF
#     SELECT pme031,pme032,pme033,pme034,pme035
#       INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035 FROM pme_file
#      WHERE pme01 = sr.pna12b
#     LET l_add1 = l_pme031 CLIPPED,l_pme032
#     LET l_add2 = l_pme033 CLIPPED,l_pme034
#     LET l_add3 = l_pme035 CLIPPED
#     PRINT g_x[27] CLIPPED,g_x[23] CLIPPED,l_add1
#     IF NOT cl_null(l_add2) THEN
#        PRINT COLUMN 16,l_add2
#     END IF
#     IF NOT cl_null(l_add3) THEN
#        PRINT COLUMN 16,l_add3
#     END IF
#  END IF
#  #No.8999(end)
 
#  #No.8999
#  IF l_flag = 'Y' THEN
#     PRINT g_dash[1,g_len]
##----------No.FUN-5A0139 begin
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34]
#     PRINTX name=H2 g_x[35],g_x[36],g_x[37]
#     PRINTX name=H3 g_x[47],g_x[48],g_x[49]
#     PRINTX name=H4 g_x[38],g_x[39],g_x[40],g_x[41],
#                    g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
##----------No.FUN-5A0139 end
#     PRINT g_dash1
#     LET l_flag = 'N'
#  END IF
 
#ON EVERY ROW
#  #No.8999(end)
#  SELECT azi03,azi04,azi05
#    INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取    #No.CHI-6A0004
#    FROM azi_file
#   WHERE azi01=sr.pmm22
 
#  SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                     WHERE ima01=sr.pnb.pnb04b
#  LET l_str2 = ""
#  IF g_sma115 = "Y" THEN
#     CASE l_ima906
#        WHEN "2"
#            CALL cl_remove_zero(sr.pnb.pnb85b) RETURNING l_pnb85b
#            LET l_str2 = l_pnb85b, sr.pnb.pnb83b CLIPPED
#            IF cl_null(sr.pnb.pnb85b) OR sr.pnb.pnb85b = 0 THEN
#                CALL cl_remove_zero(sr.pnb.pnb82b) RETURNING l_pnb82b
#                LET l_str2 = l_pnb82b, sr.pnb.pnb80b CLIPPED
#            ELSE
#               IF NOT cl_null(sr.pnb.pnb82b) AND sr.pnb.pnb82b > 0 THEN
#                  CALL cl_remove_zero(sr.pnb.pnb82b) RETURNING l_pnb82b
#                  LET l_str2 = l_str2 CLIPPED,',',l_pnb82b, sr.pnb.pnb80b CLIPPED
#               END IF
#            END IF
#        WHEN "3"
#            IF NOT cl_null(sr.pnb.pnb85b) AND sr.pnb.pnb85b > 0 THEN
#                CALL cl_remove_zero(sr.pnb.pnb85b) RETURNING l_pnb85b
#                LET l_str2 = l_pnb85b , sr.pnb.pnb83b CLIPPED
#            END IF
#     END CASE
#  ELSE
#  END IF
 
#  SELECT ima021,ima906 INTO l_ima021a,l_ima906a FROM ima_file
#                     WHERE ima01=sr.pnb.pnb04a
#  LET l_str1 = ""
#  IF g_sma115 = "Y" THEN
#     CASE l_ima906a
#        WHEN "2"
#            CALL cl_remove_zero(sr.pnb.pnb85a) RETURNING l_pnb85a
#            LET l_str1 = l_pnb85a, sr.pnb.pnb83a CLIPPED
#            IF cl_null(sr.pnb.pnb85a) OR sr.pnb.pnb85a = 0 THEN
#                CALL cl_remove_zero(sr.pnb.pnb82a) RETURNING l_pnb82a
#                LET l_str1 = l_pnb82a, sr.pnb.pnb80a CLIPPED
#            ELSE
#               IF NOT cl_null(sr.pnb.pnb82a) AND sr.pnb.pnb82a > 0 THEN
#                  CALL cl_remove_zero(sr.pnb.pnb82a) RETURNING l_pnb82a
#                  LET l_str1 = l_str1 CLIPPED,',',l_pnb82a, sr.pnb.pnb80a CLIPPED
#               END IF
#            END IF
#        WHEN "3"
#            IF NOT cl_null(sr.pnb.pnb85a) AND sr.pnb.pnb85a > 0 THEN
#                CALL cl_remove_zero(sr.pnb.pnb85a) RETURNING l_pnb85a
#                LET l_str1 = l_pnb85a , sr.pnb.pnb83a CLIPPED
#            END IF
#     END CASE
#  ELSE
#  END IF
#  IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
#    #IF sr.pnb.pnb80b <> sr.pnb.pnb86b THEN  #No.TQC-6B0137 mark
#     IF sr.pnb.pnb07b <> sr.pnb.pnb86b THEN  #No.TQC-6B0137 mod
#        CALL cl_remove_zero(sr.pnb.pnb20b) RETURNING l_pnb20b
#        LET l_str2 = l_str2 CLIPPED,"(",l_pnb20b,sr.pnb.pnb07b CLIPPED,")"
#     END IF
#    #IF sr.pnb.pnb80a <> sr.pnb.pnb86a THEN  #NO.TQC-6B0137 mark
#     IF sr.pnb.pnb07a <> sr.pnb.pnb86a THEN  #NO.TQC-6B0137 mod
#        CALL cl_remove_zero(sr.pnb.pnb20a) RETURNING l_pnb20a
#        LET l_str1 = l_str1 CLIPPED,"(",l_pnb20a,sr.pnb.pnb07a CLIPPED,")"
#     END IF
#  END IF
 
##----------No.FUN-5A0139 begin
#  PRINTX name=D1
#        COLUMN g_c[31],sr.pnb.pnb03 USING '###&', #FUN-590118
#        COLUMN g_c[32],g_x[21] CLIPPED,
#        COLUMN g_c[33],sr.pnb.pnb04b,
#        COLUMN g_c[34],l_str2 CLIPPED
 
##No.MOD-640066 --begin
#  LET p_ima021 = ''   #FUN-640236 add
#  SELECT ima021 INTO p_ima021 FROM ima_file WHERE ima01=sr.pnb.pnb04b
#  PRINTX name=D2
#        COLUMN g_c[37],sr.pnb.pnb041b
#  PRINTX name=D3
#        COLUMN g_c[49],p_ima021
#  PRINTX name=D4
##No.MOD-640066 --end  
#        COLUMN g_c[40],sr.pnb.pnb07b CLIPPED,
#        COLUMN g_c[41],cl_numfor(sr.pnb.pnb20b,41,2),
#        COLUMN g_c[42],sr.pnb.pnb86b CLIPPED,
#        COLUMN g_c[43],cl_numfor(sr.pnb.pnb87b,43,2),
#        COLUMN g_c[44],cl_numfor(sr.pnb.pnb31b,44,t_azi03),  #No.CHI-6A0004
#        COLUMN g_c[45],cl_numfor(sr.pnb.pnb87b*sr.pnb.pnb31b,45,t_azi04),   #No.CHI-6A0004
#        COLUMN g_c[46],sr.pnb.pnb33b CLIPPED
#  PRINTX name=D1
#        COLUMN g_c[32],g_x[23] CLIPPED,
#        COLUMN g_c[33],sr.pnb.pnb04a,
#        COLUMN g_c[34],l_str1 CLIPPED
##No.MOD-640066 --begin
#  LET p_ima021 = ''   #FUN-640236 add
#  SELECT ima021 INTO p_ima021 FROM ima_file WHERE ima01=sr.pnb.pnb04a
#  #TC-6C0135 --------------add--------str-----
#  #只要變更後計價數量有值,變更後單價無值,金額=變更後計價數量*變更前單價
#  IF NOT cl_null(sr.pnb.pnb87a) THEN        #變更后計價數量
#      IF cl_null(sr.pnb.pnb31a) THEN #變更後單價
#         LET l_amount = sr.pnb.pnb87a*sr.pnb.pnb31b
#      END IF
#  END IF
#  #只要變更後單價有值,變更後計價數量無值,金額=變更後單價*變更前計價數量
#  IF NOT cl_null(sr.pnb.pnb31a) THEN #變更後單價
#      IF cl_null(sr.pnb.pnb87a) THEN #變更後計價數量
#         LET l_amount = sr.pnb.pnb31a * sr.pnb.pnb87b
#      END IF
#  END IF
#  #TC-6C0135 --------------add--------end-----
#  PRINTX name=D2
#        COLUMN g_c[37],sr.pnb.pnb041a
#  PRINTX name=D3
#        COLUMN g_c[49],p_ima021
#  PRINTX name=D4
##No.MOD-640066 --end  
#        COLUMN g_c[40],sr.pnb.pnb07a CLIPPED,
#        COLUMN g_c[41],cl_numfor(sr.pnb.pnb20a,41,2),
#        COLUMN g_c[42],sr.pnb.pnb86a CLIPPED,
#        COLUMN g_c[43],cl_numfor(sr.pnb.pnb87a,43,2),
#        COLUMN g_c[44],cl_numfor(sr.pnb.pnb31a,44,t_azi03),   #No.CHI-6A0004
#       #TQC-6C0135---------mod-------------str--------------------------
#       #COLUMN g_c[45],cl_numfor(sr.pnb.pnb87a*sr.pnb.pnb31a,45,t_azi04), #No.CHI-6A0004
#        COLUMN g_c[45],cl_numfor(l_amount,45,t_azi04),        #金額
#       #TQC-6C0135---------mod-------------end--------------------------
#        COLUMN g_c[46],sr.pnb.pnb33a CLIPPED
 
#  IF NOT(cl_null(sr.pnb.pnb50)) THEN
#     PRINTX name=S1 COLUMN g_c[32],g_x[22] CLIPPED,
#                    COLUMN g_c[33],sr.pnb.pnb50
#  END IF
 
#  SKIP 1 LINE
#AFTER GROUP OF sr.pna02
#  LET l_swich=1
#  LET l_pnd03=0
#  LET l_pnd04=' '
#  SKIP 1 LINE
#  FOREACH r910_cs2 USING sr.pna01,sr.pna02
#    INTO l_pnd03,l_pnd04
#    IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
#    IF l_swich=1 THEN
#       PRINTX name=S1
#             COLUMN g_c[36],g_x[22] CLIPPED;
#    END IF
#    PRINTX name=S1
#          COLUMN g_c[37],l_pnd04
##----------No.FUN-5A0139 end
 
#    LET l_swich=l_swich+1
#  END FOREACH
##No.FUN-580004-end
 
## FUN-550114
#ON LAST ROW
#     LET l_last_sw = 'y'
 
#PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     # PRINT COLUMN 02,g_x[24] CLIPPED,
#     #       COLUMN 41,g_x[25] CLIPPED
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[24]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[24]
#            PRINT g_memo
#     END IF
## END FUN-550114
 
#END REPORT
#No.FUN-710082--end  
 
#FUN-660067--add--start
FUNCTION r910_jmail(l_name)
   DEFINE l_name       LIKE type_file.chr20 	
   DEFINE l_cmd	       LIKE type_file.chr1000  #No.FUN-660067 add 
 
   CALL cl_trans_xml(g_xml_rep,"T")
   LET l_cmd = "cp ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED," ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
   RUN l_cmd
   LET l_cmd = FGL_GETENV("DS4GL"),"/bin/addcr ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
   RUN l_cmd
   LET g_xml.attach = FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
 
   CALL cl_jmail()
   LET l_cmd = "rm ",g_xml.attach CLIPPED
   RUN l_cmd
END FUNCTION
#FUN-660067 add--end
#Patch....NO.TQC-610036 <001> #
