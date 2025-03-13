# Prog. Version..: '5.30.06-13.03.12(00004)'     #
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmg911.4gl
# Desc/riptions..: Print Purchase Change Order
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-6C0005 06/12/05 By Rainy  ref.apmr910
# Modify.........: No.FUN-710091 07/03/01 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740057 07/04/14 By Sarah 增加選項,列印公司對內(外)公司全名
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.FUN-7B0142 07/12/11 By jamie 不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.FUN-840083 08/04/18 By sherry 修改子報表的sql寫法
# Modify.........: No.FUN-930113 09/03/30 By mike 將oah-->pnz
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80005 10/08/02 By yinhy 畫面條件選項增加一個選項，Print Additional Description For Vendor Item No.
# Modify.........: No.FUN-B30062 11/03/28 By xianghui 新增列印：變更理由碼、稅別、客戶訂單編號、專案代號、WBS編碼、活動代號、MOS
# Modify.........: No.FUN-B40092 11/06/07 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/05/14 By yangtt GR程式優化
# Modify.........: No.FUN-C50140 12/06/12 By chenying GR修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item    LIKE type_file.num5   	
END GLOBALS
   DEFINE
     tm  RECORD				# Print condition RECORD
       	 wc   LIKE type_file.chr1000,	# Where condition 
         a    LIKE type_file.chr1,   	
         d    LIKE type_file.chr1,      #FUN-740057 add    #列印公司對內全名
         e    LIKE type_file.chr1,      #FUN-740057 add    #列印公司對外全名
         b    LIKE type_file.chr1,      #FUN-A80005 add    #列印額外品名規格
         more LIKE type_file.chr1   	
         END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
DEFINE   g_sma115        LIKE sma_file.sma115    
DEFINE   g_sma116        LIKE sma_file.sma116  
DEFINE   g_rlang_2       LIKE type_file.chr1     
#No.FUN-710091--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING                                                       
DEFINE  l_str      STRING   
#No.FUN-710091--end   
DEFINE  l_table2   STRING       #FUN-A80005 add
 
#FUN-6C0005
###GENGRE###START
TYPE sr1_t RECORD
    pna01 LIKE pna_file.pna01,
    pna02 LIKE pna_file.pna02,
    pna04 LIKE pna_file.pna04,
    pna08 LIKE pna_file.pna08,
    pna08b LIKE pna_file.pna08b,
    pna10 LIKE pna_file.pna10,
    pna10b LIKE pna_file.pna10b,
    pna09 LIKE pna_file.pna09,
    pna09b LIKE pna_file.pna09b,
    pna11 LIKE pna_file.pna11,
    pna11b LIKE pna_file.pna11b,
    pna12 LIKE pna_file.pna12,
    pna12b LIKE pna_file.pna12b,
    pmm09 LIKE pmm_file.pmm09,
    pmm04 LIKE pmm_file.pmm04,
    pmc03 LIKE pmc_file.pmc03,
    pnb01 LIKE pnb_file.pnb01,
    pnb02 LIKE pnb_file.pnb02,
    pnb03 LIKE pnb_file.pnb03,
    pnb04b LIKE pnb_file.pnb04b,
    pnb041b LIKE pnb_file.pnb041b,
    pnb07b LIKE pnb_file.pnb07b,
    pnb20b LIKE pnb_file.pnb20b,
    pnb31b LIKE pnb_file.pnb31b,
    pnb33b LIKE pnb_file.pnb33b,
    pnb04a LIKE pnb_file.pnb04a,
    pnb041a LIKE pnb_file.pnb041a,
    pnb07a LIKE pnb_file.pnb07a,
    pnb20a LIKE pnb_file.pnb20a,
    pnb31a LIKE pnb_file.pnb31a,
    pnb33a LIKE pnb_file.pnb33a,
    pnb50 LIKE pnb_file.pnb50,
    pnb51 LIKE pnb_file.pnb51,
    pnb32a LIKE pnb_file.pnb32a,
    pnb32b LIKE pnb_file.pnb32b,
    pnb80b LIKE pnb_file.pnb80b,
    pnb81b LIKE pnb_file.pnb81b,
    pnb82b LIKE pnb_file.pnb82b,
    pnb83b LIKE pnb_file.pnb83b,
    pnb84b LIKE pnb_file.pnb84b,
    pnb85b LIKE pnb_file.pnb85b,
    pnb86b LIKE pnb_file.pnb86b,
    pnb87b LIKE pnb_file.pnb87b,
    pnb80a LIKE pnb_file.pnb80a,
    pnb81a LIKE pnb_file.pnb81a,
    pnb82a LIKE pnb_file.pnb82a,
    pnb83a LIKE pnb_file.pnb83a,
    pnb84a LIKE pnb_file.pnb84a,
    pnb85a LIKE pnb_file.pnb85a,
    pnb86a LIKE pnb_file.pnb86a,
    pnb87a LIKE pnb_file.pnb87a,
    pnb90 LIKE pnb_file.pnb90,
    pnb91 LIKE pnb_file.pnb91,
    pmm22 LIKE pmm_file.pmm22,
    pma02 LIKE pma_file.pma02,
    pma02n LIKE pma_file.pma02,
    oah02 LIKE oah_file.oah02,
    oah02n LIKE oah_file.oah02,
    pme031 LIKE pme_file.pme031,
    pme032 LIKE pme_file.pme032,
    pme033 LIKE pme_file.pme033,
    pme034 LIKE pme_file.pme034,
    pme035 LIKE pme_file.pme035,
    pme031a LIKE pme_file.pme031,
    pme032a LIKE pme_file.pme032,
    pme033a LIKE pme_file.pme033,
    pme034a LIKE pme_file.pme034,
    pme035a LIKE pme_file.pme035,
    pme031b LIKE pme_file.pme031,
    pme032b LIKE pme_file.pme032,
    pme033b LIKE pme_file.pme033,
    pme034b LIKE pme_file.pme034,
    pme035b LIKE pme_file.pme035,
    pme031c LIKE pme_file.pme031,
    pme032c LIKE pme_file.pme032,
    pme033c LIKE pme_file.pme033,
    pme034c LIKE pme_file.pme034,
    pme035c LIKE pme_file.pme035,
    ima021 LIKE ima_file.ima021,
    ima021a LIKE ima_file.ima021,
    strb LIKE type_file.chr1000,
    stra LIKE type_file.chr1000,
    amount LIKE pmn_file.pmn88,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    l_count LIKE type_file.num5,
    pnb34a LIKE pnb_file.pnb34a,
    pnb34b LIKE pnb_file.pnb34b,
    pnb35a LIKE pnb_file.pnb35a,
    pnb35b LIKE pnb_file.pnb35b,
    pnb36a LIKE pnb_file.pnb36a,
    pnb36b LIKE pnb_file.pnb36b,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD

TYPE sr2_t RECORD
    pnd01 LIKE pnd_file.pnd01,
    pnd02 LIKE pnd_file.pnd02,
    pnd03 LIKE pnd_file.pnd03,
    pnd04 LIKE pnd_file.pnd04
END RECORD

TYPE sr3_t RECORD
    pmq01 LIKE pmq_file.pmq01,
    pmq02 LIKE pmq_file.pmq02,
    pmq03 LIKE pmq_file.pmq03,
    pmq04 LIKE pmq_file.pmq04,
    pmq05 LIKE pmq_file.pmq05,
    pna01 LIKE pna_file.pna01,
    pnb03 LIKE pnb_file.pnb03
END RECORD
###GENGRE###END

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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.d  = ARG_VAL(9)    #FUN-740057 add
   LET tm.e  = ARG_VAL(10)   #FUN-740057 add
   LET tm.b  = ARG_VAL(11)   #FUN-A80005 add
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
 
   LET g_xml.subject = ARG_VAL(15)
   LET g_xml.body    = ARG_VAL(16)
   LET g_xml.recipient = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   IF cl_null(g_rlang) THEN
      LET g_rlang = g_lang
   END IF
   LET g_rlang_2 = g_rlang             
   
   #No.FUN-710091--begin
   LET g_sql ="pna01.pna_file.pna01,",
              "pna02.pna_file.pna02,",
              "pna04.pna_file.pna04,",
              "pna08.pna_file.pna08,",
              "pna08b.pna_file.pna08b,",
              "pna10.pna_file.pna10,",
              "pna10b.pna_file.pna10b,",
              "pna09.pna_file.pna09,",
              "pna09b.pna_file.pna09b,",
              "pna11.pna_file.pna11,",
              "pna11b.pna_file.pna11b,",
              "pna12.pna_file.pna12,",
              "pna12b.pna_file.pna12b,",
              "pmm09.pmm_file.pmm09,",
              "pmm04.pmm_file.pmm04,",
              "pmc03.pmc_file.pmc03,",
              "pnb01.pnb_file.pnb01,",
              "pnb02.pnb_file.pnb02,",
              "pnb03.pnb_file.pnb03,",
              "pnb04b.pnb_file.pnb04b,",
              "pnb041b.pnb_file.pnb041b,",
              "pnb07b.pnb_file.pnb07b,",
              "pnb20b.pnb_file.pnb20b,",
              "pnb31b.pnb_file.pnb31b,",
              "pnb33b.pnb_file.pnb33b,",
              "pnb04a.pnb_file.pnb04a,",
              "pnb041a.pnb_file.pnb041a,",
              "pnb07a.pnb_file.pnb07a,",
              "pnb20a.pnb_file.pnb20a,",
              "pnb31a.pnb_file.pnb31a,",
              "pnb33a.pnb_file.pnb33a,",
              "pnb50.pnb_file.pnb50,",
              "pnb51.pnb_file.pnb51,",
              "pnb32a.pnb_file.pnb32a,",
              "pnb32b.pnb_file.pnb32b,",
              "pnb80b.pnb_file.pnb80b,",
              "pnb81b.pnb_file.pnb81b,",
              "pnb82b.pnb_file.pnb82b,",
              "pnb83b.pnb_file.pnb83b,",
              "pnb84b.pnb_file.pnb84b,",
              "pnb85b.pnb_file.pnb85b,",
              "pnb86b.pnb_file.pnb86b,",
              "pnb87b.pnb_file.pnb87b,",
              "pnb80a.pnb_file.pnb80a,",
              "pnb81a.pnb_file.pnb81a,",
              "pnb82a.pnb_file.pnb82a,",
              "pnb83a.pnb_file.pnb83a,",
              "pnb84a.pnb_file.pnb84a,",
              "pnb85a.pnb_file.pnb85a,",
              "pnb86a.pnb_file.pnb86a,",
              "pnb87a.pnb_file.pnb87a,",
              "pnb90.pnb_file.pnb90,",
              "pnb91.pnb_file.pnb91,",
              "pmm22.pmm_file.pmm22,",
             #"pmc911.pmc_file.pmc911,",   #FUN-7B0142 mark
              "pma02.pma_file.pma02,",
              "pma02n.pma_file.pma02,",
              "oah02.oah_file.oah02,",
              "oah02n.oah_file.oah02,",
              "pme031.pme_file.pme031,",
              "pme032.pme_file.pme032,",
              "pme033.pme_file.pme033,",
              "pme034.pme_file.pme034,",
              "pme035.pme_file.pme035,",
              "pme031a.pme_file.pme031,",
              "pme032a.pme_file.pme032,",
              "pme033a.pme_file.pme033,",
              "pme034a.pme_file.pme034,",
              "pme035a.pme_file.pme035,",
              "pme031b.pme_file.pme031,",
              "pme032b.pme_file.pme032,",
              "pme033b.pme_file.pme033,",
              "pme034b.pme_file.pme034,",
              "pme035b.pme_file.pme035,",
              "pme031c.pme_file.pme031,",
              "pme032c.pme_file.pme032,",
              "pme033c.pme_file.pme033,",
              "pme034c.pme_file.pme034,",
              "pme035c.pme_file.pme035,",
              "ima021.ima_file.ima021,",
              "ima021a.ima_file.ima021,",
              "strb.type_file.chr1000,",
              "stra.type_file.chr1000,",
              "amount.pmn_file.pmn88,",
              "azi03.azi_file.azi03,",
              "azi04.azi_file.azi04,",
              "l_count.type_file.num5,",   #No.FUN-A80005 add
              "pnb34a.pnb_file.pnb34a,",  #FUN-B30062
              "pnb34b.pnb_file.pnb34b,",  #FUN-B30062
              "pnb35a.pnb_file.pnb35a,",  #FUN-B30062
              "pnb35b.pnb_file.pnb35b,",  #FUN-B30062
              "pnb36a.pnb_file.pnb36a,",  #FUN-B30062
              "pnb36b.pnb_file.pnb36b,",  #FUN-B30062
              "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
              "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
              "sign_show.type_file.chr1,",                       #FUN-C40019 add
              "sign_str.type_file.chr1000"                       #FUN-C40019 add
 
   LET l_table = cl_prt_temptable('apmg911',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
      EXIT PROGRAM 
   END IF
   LET g_sql= "pnd01.pnd_file.pnd01,",
              "pnd02.pnd_file.pnd02,",
              "pnd03.pnd_file.pnd03,",
              "pnd04.pnd_file.pnd04"
   LET l_table1 = cl_prt_temptable('apmg9111',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
      EXIT PROGRAM 
   END IF  
   #No.FUN-A80005--start
   
   LET g_sql= "pmq01.pmq_file.pmq01,",
              "pmq02.pmq_file.pmq02,",
              "pmq03.pmq_file.pmq03,",
              "pmq04.pmq_file.pmq04,",
              "pmq05.pmq_file.pmq05,",
              "pna01.pna_file.pna01,",
              "pnb03.pnb_file.pnb03"  
   LET l_table2 = cl_prt_temptable('apmg9112',g_sql) CLIPPED
   IF l_table2 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
      EXIT PROGRAM 
   END IF        
   #No.FUN-A80005--end
              
   #No.FUN-710091--end  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g911_tm(0,0)		# Input print condition
      ELSE CALL apmg911()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
END MAIN
 
FUNCTION g911_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col	LIKE type_file.num5,        
          l_cmd		LIKE type_file.chr1000     
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW g911_w AT p_row,p_col WITH FORM "apm/42f/apmg911"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = '1'
   LET tm.d    = 'Y'   #FUN-740057 add
   LET tm.e    = 'Y'   #FUN-740057 add
   LET tm.b    = 'N'   #FUN-A80005 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_rlang_2 = g_rlang              
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pna01,pna04,pna02
     BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
     ON ACTION locale
        CALL cl_show_fld_cont()       
        LET g_action_choice = "locale"
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about     
        CALL cl_about()  
 
     ON ACTION help        
        CALL cl_show_help() 
 
     ON ACTION controlg   
        CALL cl_cmdask() 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW g911_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.more  # Condition
   INPUT BY NAME tm.a,tm.d,tm.e,tm.b,tm.more WITHOUT DEFAULTS   #FUN-740057 add tm.d,tm.e #No.FUN-A80005 add tm.b
 
      BEFORE INPUT
        CALL cl_qbe_display_condition(lc_qbe_sn)
 
      #str FUN-740057 add
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES "[YN]" THEN
            NEXT FIELD d
         END IF
 
      AFTER FIELD e
         IF cl_null(tm.e) OR tm.e NOT MATCHES "[YN]" THEN
            NEXT FIELD e
         END IF
      #end FUN-740057 add
      
      #No.FUN-A80005--start
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES "[YN]" THEN
            NEXT FIELD b
         END IF
      #No.FUN-A80005--end 
      
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
                 LET g_rlang_2 = g_rlang              #MOD-5A0436
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g911_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmg911'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmg911','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",         
                         " '",g_template CLIPPED,"'"         
         CALL cl_cmdat('apmg911',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW g911_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmg911()
   ERROR ""
END WHILE
   CLOSE WINDOW g911_w
END FUNCTION
 
FUNCTION apmg911()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	# Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,    
          l_za05	LIKE type_file.chr1000,
          l_pmm22       LIKE pmm_file.pmm22,
          l_count  LIKE type_file.num5,    #No.FUN-A80005 add
     sr   RECORD
          pna01  LIKE pna_file.pna01,  #採購單號
          pna02  LIKE pna_file.pna02,  #採購序號
          pna04  LIKE pna_file.pna04,  #採購日期
          pna08  LIKE pna_file.pna08, 
          pna08b LIKE pna_file.pna08b,
          pna10  LIKE pna_file.pna10,
          pna10b LIKE pna_file.pna10b,
          pna09  LIKE pna_file.pna09,
          pna09b LIKE pna_file.pna09b,
          pna11  LIKE pna_file.pna11,
          pna11b LIKE pna_file.pna11b,
          pna12  LIKE pna_file.pna12,
          pna12b LIKE pna_file.pna12b,
          pmm09 LIKE pmm_file.pmm09,  #廠商編號
          pmm04 LIKE pmm_file.pmm04,  #單據日期
          pmc03 LIKE pmc_file.pmc03,
          pnb   RECORD LIKE pnb_file.*,
          pmm22 LIKE pmm_file.pmm22
         #pmc911 LIKE pmc_file.pmc911    #FUN-7B0142 mark
          END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5      
     DEFINE l_zaa02            LIKE zaa_file.zaa02     
      
     #No.FUN-710091--begin
     DEFINE sr1  RECORD
               pnd01  LIKE pnd_file.pnd01,  
               pnd02  LIKE pnd_file.pnd02,  
               pnd03  LIKE pnd_file.pnd03,  
               pnd04  LIKE pnd_file.pnd04  
               END RECORD
     #No.FUN-A80005--start
     DEFINE sr2  RECORD
              pmq01    LIKE pmq_file.pmq01,
              pmq02    LIKE pmq_file.pmq02,
              pmq03    LIKE pmq_file.pmq03,
              pmq04    LIKE pmq_file.pmq04,
              pmq05    LIKE pmq_file.pmq05
              END RECORD
     #No.FUN-A80005--end    
     DEFINE    l_pma02    LIKE pma_file.pma02,
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
     DEFINE   l_str2       LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(100)
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
        DEFINE  l_amount LIKE pmn_file.pmn88 #金額 #MOD-6C0135 add
     #No.FUN-710091--end  
     DEFINE   l_zo12       LIKE zo_file.zo12   #FUN-740057 add
     DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add
 
     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmg911'
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
     #str FUN-740057 add
     SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='1'   #公司對外全名
     IF cl_null(l_zo12) THEN
        SELECT zo12 INTO l_zo12 FROM zo_file WHERE zo01='0'
     END IF
     #end FUN-740057 add
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pnauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pnagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pnagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pnauser', 'pnagrup')
     #End:FUN-980030
 
    #LET l_sql = " SELECT pnd03,pnd04 FROM pnd_file ",   #No.FUN-710091 
     LET l_sql = " SELECT pnd01,pnd02,pnd03,pnd04 FROM pnd_file ",    #No.FUN-710091
                 "  WHERE pnd01 = ? AND pnd02 = ? ",
                 "  ORDER BY pnd03 "
     PREPARE g911_pr2 FROM l_sql
     DECLARE g911_cs2 CURSOR FOR g911_pr2
     IF SQLCA.SQLCODE THEN
        CALL cl_err('prepare:#2',sqlca.sqlcode,1)
     END IF
     LET l_sql = " SELECT pna01,pna02,pna04,",  
                 "        pna08,pna08b,", #NO:7203
                 "        pna10,pna10b,pna09,pna09b,pna11,pna11b,",
                 "        pna12,pna12b,",
                 "        pmm09,pmm04,pmc03, ",
                 "        pnb_file.*,pmm22, ",          #FUN-7B0142 mod 
                 "        azi03,azi04,azi05 ",          #FUN-C50003 add
                #"        pnb_file.*,pmm22,pmc911 ",   #FUN-7B0142 mark
                #"   FROM pna_file,pnb_file,pmm_file,OUTER pmc_file ",
                 "   FROM pna_file LEFT OUTER JOIN pnb_file ON pna01=pnb01 AND pna02=pnb02,",
                 "        pmm_file LEFT OUTER JOIN pmc_file ON pmm09 = pmc01",
                 "                 LEFT OUTER JOIN azi_file ON azi01 = pmm22",   #FUN-C50003 add
                 "  WHERE pna01=pmm01 AND pmm18 !='X' ",
                 "    AND pnaacti = 'Y' ",
                 "    AND pna05 != 'X' ",
                 "    AND ",tm.wc CLIPPED
     CASE tm.a
       WHEN '1' LET l_sql=l_sql CLIPPED," AND pnaconf='N' "
       WHEN '2' LET l_sql=l_sql CLIPPED," AND pnaconf='Y' "
     END CASE
     LET l_sql=l_sql CLIPPED," ORDER BY pna01,pna02,pnb03"   #No.FUN-710091
 
     PREPARE g911_pr1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)
        EXIT PROGRAM
           
     END IF
     DECLARE g911_cs1 CURSOR FOR g911_pr1
     LET g_rlang = g_rlang_2                          
     #No.FUN-710091--begin
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1) 
     CALL cl_del_data(l_table2)    #No.FUN-A80005 add
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",    #FUN-7B0142 拿掉一個? #No.FUN-A80005加一个?  #FUN-B30062 最後加了6個
                 "        ?,?,?,?,?, ?) "     #FUN-C40019 add 4? 
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-780049
                 " VALUES(?,?,?,?) "
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep1:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
        EXIT PROGRAM
     END IF
     
     #No.FUN-A80005--start
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep2:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2) #FUN-B40092
        EXIT PROGRAM
     END IF
     #No.FUN-A80005--end
     
#    CALL cl_outnam('apmg911') RETURNING l_name
#    IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN   
#           LET g_zaa[34].zaa06 = "N"
#    ELSE
#           LET g_zaa[34].zaa06 = "Y"
#    END IF
#    CALL cl_prt_pos_len()
#No.FUN-580004-end
#    START REPORT g911_rep TO l_name
#    LET g_pageno = 0
 
     #FUN-C50003----mark---str--
      DECLARE pmq_cur1 CURSOR FOR
        SELECT * FROM pmq_file    
         WHERE pmq01=? AND pmq02=? 
         ORDER BY pmq04                                        
     #FUN-C50003----mark---end--
 
     FOREACH g911_cs1 INTO sr.*,t_azi03,t_azi04,t_azi05   #FUN-C50003 add ,t_azi03,t_azi04,t_azi05
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       ## Bug No. 7252
      #FUN-7B0142---mark---str---
      #IF tm.more = "N" AND cl_null(ARG_VAL(3)) THEN
      #    LET g_rlang = sr.pmc911
      #END IF
      #FUN-7B0142---mark---end---
       ##
       IF cl_null(g_rlang) THEN     #No.9153
           LET g_rlang = g_lang
       END IF
 
       SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
       LET l_pma02 = '' LET l_pnz02 = '' #FUN-930113
       LET l_pma02n= '' LET l_pnz02n= '' #FUN-930113 
       SELECT pma02 INTO l_pma02    FROM pma_file WHERE pma01 = sr.pna10
       SELECT pma02 INTO l_pma02n   FROM pma_file WHERE pma01 = sr.pna10b
       SELECT pnz02 INTO l_pnz02    FROM pnz_file WHERE pnz01 = sr.pna09   #FUN-930113
       SELECT pnz02 INTO l_pnz02n   FROM pnz_file WHERE pnz01 = sr.pna09b  #FUN-930113
 
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
 
      #FUN-C50003---mark---str---
      #SELECT azi03,azi04,azi05
      #  INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取    #No.CHI-6A0004
      #  FROM azi_file
      # WHERE azi01=sr.pmm22
      #FUN-C50003---mark---end---
  
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
           END IF
       END IF
       #只要變更後單價有值,變更後計價數量無值,金額=變更後單價*變更前計價數量
       IF NOT cl_null(sr.pnb.pnb31a) THEN #變更後單價
           IF cl_null(sr.pnb.pnb87a) THEN #變更後計價數量
              LET l_amount = sr.pnb.pnb31a * sr.pnb.pnb87b
           END IF
       END IF
 
       FOREACH g911_cs2 USING sr.pna01,sr.pna02 INTO sr1.*
          IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
          EXECUTE insert_prep1 USING sr1.*
       END FOREACH
       #No.FUN-A80005--start
        IF tm.b = 'Y' THEN
          SELECT COUNT(*) INTO l_count FROM pmq_file
             WHERE pmq01=sr.pnb.pnb04a AND pmq02=sr.pmm09
             IF l_count !=0  THEN
              #FUN-C50003----mark---str--
              #DECLARE pmq_cur1 CURSOR FOR
              #SELECT * FROM pmq_file    
              #  WHERE pmq01=sr.pnb.pnb04a AND pmq02=sr.pmm09 
              #ORDER BY pmq04                                        
              #FUN-C50003----mark---end--
               FOREACH pmq_cur1 USING sr.pnb.pnb04a,sr.pmm09 INTO sr2.*        #FUN-C50003 add USING sr.pnb.pnb04a,sr.pmm09                    
                 EXECUTE insert_prep2 USING sr2.pmq01,sr2.pmq02,sr2.pmq03,sr2.pmq04,sr2.pmq05,sr.pna01,sr.pnb.pnb03
               END FOREACH
             END IF 
        END IF    
       #No.FUN-A80005--end 
         EXECUTE insert_prep USING sr.pna01,sr.pna02,sr.pna04,sr.pna08,sr.pna08b,
                                   sr.pna10,sr.pna10b,sr.pna09,sr.pna09b,sr.pna11,
                                   sr.pna11b,sr.pna12,sr.pna12b,sr.pmm09,sr.pmm04,
                                   sr.pmc03,sr.pnb.pnb01,sr.pnb.pnb02,sr.pnb.pnb03,sr.pnb.pnb04b,
                                   sr.pnb.pnb041b,sr.pnb.pnb07b,sr.pnb.pnb20b,sr.pnb.pnb31b,sr.pnb.pnb33b,
                                   sr.pnb.pnb04a,sr.pnb.pnb041a,sr.pnb.pnb07a,sr.pnb.pnb20a,sr.pnb.pnb31a,
                                   sr.pnb.pnb33a,sr.pnb.pnb50,sr.pnb.pnb51,sr.pnb.pnb32a,sr.pnb.pnb32b,
                                   sr.pnb.pnb80b,sr.pnb.pnb81b,sr.pnb.pnb82b,sr.pnb.pnb83b,sr.pnb.pnb84b,
                                   sr.pnb.pnb85b,sr.pnb.pnb86b,sr.pnb.pnb87b,sr.pnb.pnb80a,sr.pnb.pnb81a,
                                   sr.pnb.pnb82a,sr.pnb.pnb83a,sr.pnb.pnb84a,sr.pnb.pnb85a,sr.pnb.pnb86a,
                                   sr.pnb.pnb87a,sr.pnb.pnb90,sr.pnb.pnb91,sr.pmm22,            #FUN-7B0142 mod 拿掉sr.pmc911,
                                   l_pma02,l_pma02n,l_pnz02,l_pnz02n,l_pme031, #FUN-930113 
                                   l_pme032,l_pme033,l_pme034,l_pme035,l_pme031a,
                                   l_pme032a,l_pme033a,l_pme034a,l_pme035a,l_pme031b,
                                   l_pme032b,l_pme033b,l_pme034b,l_pme035b,l_pme031c,
                                   l_pme032c,l_pme033c,l_pme034c,l_pme035c,l_ima021,
                                   l_ima021a,l_str2,l_str1,l_amount,t_azi03,t_azi04,l_count,  #No.FUN-A80005 add l_count
                                   sr.pnb.pnb34a,sr.pnb.pnb34b,sr.pnb.pnb35a,sr.pnb.pnb35b,sr.pnb.pnb36a,sr.pnb.pnb36b,  #FUN-B30062 
                                   "",l_img_blob,"N",""    #FUN-C40019 add
#      OUTPUT TO REPORT g911_rep(sr.*)
     END FOREACH
 
#    FINISH REPORT g911_rep
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'pna01,pna04,pna02')  
        RETURNING tm.wc                                                           
     ELSE
        LET tm.wc = ''
     END IF                      
     LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",g_sma116,";",g_sma115
###GENGRE###     LET l_str = l_str,";",tm.d,";",tm.e,";",l_zo12,";",tm.b CLIPPED,g_aza.aza08   #FUN-740057 add  #FUN-A80005 add tm.b CLIPPED  #FUN-B30062 add aza08
 
     #No.FUN-840083---Begin
     #LET l_sql = "SELECT ",l_table CLIPPED,".*,",l_table1 CLIPPED,".*",
  #TQC-730088 #  "  FROM ",l_table CLIPPED,",",l_table1 CLIPPED,
     #            "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,",",
     #                      g_cr_db_str CLIPPED,l_table1 CLIPPED,
     #            " WHERE pna01 =",l_table1 CLIPPED,".pnd01(+) ",
     #            "   AND pna02 =",l_table1 CLIPPED,".pnd02(+) ",
     #            " ORDER BY pna01,pna02,pnb03 "
###GENGRE###     LET l_sql = "SELECT A.*,B.*",                                              
###GENGRE###                 "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",           
###GENGRE###                           g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON A.pna01=B.pnd01 AND A.pna02=B.pnd02 ",           
###GENGRE###                 " ORDER BY pna01,pna02,pnb03","|",
###GENGRE###                 " SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED      #No.FUN-A80005 add                              
     #No.FUN-840083---End           
     LET g_rlang = g_rlang_2                      
     IF g_bgjob='Y' AND g_prtway = 'J' THEN
   #   CALL g911_jmail(l_name)
     ELSE
#      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #  CALL cl_prt_cs3('apmg911',l_sql,l_str)    #TQC-730088
###GENGRE###     CALL cl_prt_cs3('apmg911','apmg911',l_sql,l_str) 
  
    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "pna01|pna02"         #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add

    CALL apmg911_grdata()    ###GENGRE###
     END IF
     #No.FUN-710091  --end 
END FUNCTION
 
#No.FUN-710091  --begin
#REPORT g911_rep(sr)
#   DEFINE
#     l_last_sw	LIKE type_file.chr1,   	
#     l_dash        LIKE type_file.chr1,   
#     l_str         LIKE type_file.chr1000,	
#  sr   RECORD
#          pna01 LIKE pna_file.pna01,  #採購單號
#          pna02 LIKE pna_file.pna02,  #採購序號
#          pna04 LIKE pna_file.pna04,  #採購日期
#          pna08  LIKE pna_file.pna08, #NO:7203
#          pna08b LIKE pna_file.pna08b,
#          pna10  LIKE pna_file.pna10,
#          pna10b LIKE pna_file.pna10b,
#          pna09  LIKE pna_file.pna09,
#          pna09b LIKE pna_file.pna09b,
#          pna11  LIKE pna_file.pna11,
#          pna11b LIKE pna_file.pna11b,
#          pna12  LIKE pna_file.pna12,
#          pna12b LIKE pna_file.pna12b,
#          pmm09 LIKE pmm_file.pmm09,  #廠商編號
#          pmm04 LIKE pmm_file.pmm04,  #單據日期
#          pmc03 LIKE pmc_file.pmc03,
#          pnb   RECORD LIKE pnb_file.*,
#          pmm22 LIKE pmm_file.pmm22,
#          pmc911 LIKE pmc_file.pmc911
#          END RECORD,
#    l_pma02    LIKE pma_file.pma02,
#    l_pma02n   LIKE pma_file.pma02,
#    l_oah02    LIKE oah_file.oah02,
#    l_oah02n   LIKE oah_file.oah02,
#    l_pme031   LIKE pme_file.pme031,
#    l_pme032   LIKE pme_file.pme032,
#    l_pme033   LIKE pme_file.pme033,
#    l_pme034   LIKE pme_file.pme034,
#    l_pme035   LIKE pme_file.pme035,
#    l_add1    LIKE type_file.chr1000,	
#    l_add2    LIKE type_file.chr1000,
#    l_add3    LIKE type_file.chr1000,	
#    l_pnd03  LIKE pnd_file.pnd03,
#    l_pnd04  LIKE pnd_file.pnd04,
#    p_ima021 LIKE ima_file.ima021,    
#    l_swich  LIKE type_file.num5,   
#    l_flag   LIKE type_file.chr1   
#DEFINE   l_str2       LIKE type_file.chr1000,	
#         l_str1       LIKE type_file.chr1000,
#         l_ima021     LIKE ima_file.ima021,
#         l_ima906     LIKE ima_file.ima906,
#         l_ima021a    LIKE ima_file.ima021,
#         l_ima906a    LIKE ima_file.ima906,
#         l_pnb85b     STRING,
#         l_pnb82b     STRING,
#         l_pnb20b     STRING,
#         l_pnb85a     STRING,
#         l_pnb82a     STRING,
#         l_pnb20a     STRING
# 
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 9
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pna01,sr.pna02,sr.pnb.pnb03
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT
#      LET g_pageno = g_pageno + 1
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#      PRINT
#
#      PRINT COLUMN 1,g_x[11] CLIPPED,sr.pmm09 CLIPPED,
#            COLUMN 23,sr.pmc03 CLIPPED,
#            COLUMN 51,g_x[14] CLIPPED,sr.pmm04 CLIPPED,
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT ' '
#      LET l_pma02 = '' LET l_oah02 = ''
#      LET l_pma02n= '' LET l_oah02n= ''
#      SELECT pma02 INTO l_pma02    FROM pma_file WHERE pma01 = sr.pna10
#      SELECT oah02 INTO l_oah02    FROM oah_file WHERE oah01 = sr.pna09
#      SELECT pma02 INTO l_pma02n   FROM pma_file WHERE pma01 = sr.pna10b
#      SELECT oah02 INTO l_oah02n   FROM oah_file WHERE oah01 = sr.pna09b
#      #No.8999(end)
#      PRINT COLUMN  1,g_x[13] CLIPPED,sr.pna01 CLIPPED,
#            COLUMN 51,g_x[29] CLIPPED
#      PRINT COLUMN 1,g_x[26] CLIPPED,
#            COLUMN 51,g_x[30] CLIPPED
#      PRINT COLUMN  1,g_x[12] CLIPPED,sr.pna04 CLIPPED,
#            COLUMN  51,g_x[15] CLIPPED,sr.pna02 USING '####'
#      PRINT COLUMN 1,g_x[21] CLIPPED,
#            COLUMN 8,sr.pna08 CLIPPED,'-',l_pma02 CLIPPED,'-',l_oah02 CLIPPED
#      PRINT COLUMN 1,g_x[23] CLIPPED,
#            COLUMN 8,sr.pna08b CLIPPED,'-',l_pma02n CLIPPED,'-',l_oah02n CLIPPED
#      LET l_flag = 'Y'
#      LET l_last_sw = 'n'           
#
#BEFORE GROUP OF sr.pna02
#   SKIP TO TOP OF PAGE
#   PRINT
#   #No.8999
#   IF NOT cl_null(sr.pna11b) THEN
#      SELECT pme031,pme032,pme033,pme034,pme035
#        INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
#        FROM pme_file
#       WHERE pme01 = sr.pna11
#      LET l_add1 = l_pme031 CLIPPED,l_pme032
#      LET l_add2 = l_pme033 CLIPPED,l_pme034
#      LET l_add3 = l_pme035 CLIPPED
#      PRINT g_x[28] CLIPPED,g_x[21] CLIPPED,l_add1
#      IF NOT cl_null(l_add2) THEN
#         PRINT COLUMN 16,l_add2
#      END IF
#      IF NOT cl_null(l_add3) THEN
#         PRINT COLUMN 16,l_add3
#      END IF
#      SELECT pme031,pme032,pme033,pme034,pme035
#        INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035 FROM pme_file
#       WHERE pme01 = sr.pna11b
#      LET l_add1 = l_pme031 CLIPPED,l_pme032
#      LET l_add2 = l_pme033 CLIPPED,l_pme034
#      LET l_add3 = l_pme035 CLIPPED
#      PRINT g_x[28] CLIPPED,g_x[23] CLIPPED,l_add1
#      IF NOT cl_null(l_add2) THEN
#         PRINT COLUMN 16,l_add2
#      END IF
#      IF NOT cl_null(l_add3) THEN
#         PRINT COLUMN 16,l_add3
#      END IF
#   END IF
#   IF NOT cl_null(sr.pna12b) THEN
#      SELECT pme031,pme032,pme033,pme034,pme035
#        INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035
#        FROM pme_file
#       WHERE pme01 = sr.pna12
#      LET l_add1 = l_pme031 CLIPPED,l_pme032
#      LET l_add2 = l_pme033 CLIPPED,l_pme034
#      LET l_add3 = l_pme035 CLIPPED
#      PRINT g_x[27] CLIPPED,g_x[21] CLIPPED,l_add1
#      IF NOT cl_null(l_add2) THEN
#         PRINT COLUMN 16,l_add2
#      END IF
#      IF NOT cl_null(l_add3) THEN
#         PRINT COLUMN 16,l_add3
#      END IF
#      SELECT pme031,pme032,pme033,pme034,pme035
#        INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035 FROM pme_file
#       WHERE pme01 = sr.pna12b
#      LET l_add1 = l_pme031 CLIPPED,l_pme032
#      LET l_add2 = l_pme033 CLIPPED,l_pme034
#      LET l_add3 = l_pme035 CLIPPED
#      PRINT g_x[27] CLIPPED,g_x[23] CLIPPED,l_add1
#      IF NOT cl_null(l_add2) THEN
#         PRINT COLUMN 16,l_add2
#      END IF
#      IF NOT cl_null(l_add3) THEN
#         PRINT COLUMN 16,l_add3
#      END IF
#   END IF
#
#   IF l_flag = 'Y' THEN
#      PRINT g_dash[1,g_len]
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34]
#      PRINTX name=H2 g_x[35],g_x[36],g_x[37]
#      PRINTX name=H3 g_x[47],g_x[48],g_x[49]
#      PRINTX name=H4 g_x[38],g_x[39],g_x[40],g_x[41],
#                     g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#      PRINT g_dash1
#      LET l_flag = 'N'
#   END IF
#
# ON EVERY ROW
#   SELECT azi03,azi04,azi05
#     INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取  
#     FROM azi_file
#    WHERE azi01=sr.pmm22
#
#   SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
#                      WHERE ima01=sr.pnb.pnb04b
#   LET l_str2 = ""
#   IF g_sma115 = "Y" THEN
#      CASE l_ima906
#         WHEN "2"
#             CALL cl_remove_zero(sr.pnb.pnb85b) RETURNING l_pnb85b
#             LET l_str2 = l_pnb85b, sr.pnb.pnb83b CLIPPED
#             IF cl_null(sr.pnb.pnb85b) OR sr.pnb.pnb85b = 0 THEN
#                 CALL cl_remove_zero(sr.pnb.pnb82b) RETURNING l_pnb82b
#                 LET l_str2 = l_pnb82b, sr.pnb.pnb80b CLIPPED
#             ELSE
#                IF NOT cl_null(sr.pnb.pnb82b) AND sr.pnb.pnb82b > 0 THEN
#                   CALL cl_remove_zero(sr.pnb.pnb82b) RETURNING l_pnb82b
#                   LET l_str2 = l_str2 CLIPPED,',',l_pnb82b, sr.pnb.pnb80b CLIPPED
#                END IF
#             END IF
#         WHEN "3"
#             IF NOT cl_null(sr.pnb.pnb85b) AND sr.pnb.pnb85b > 0 THEN
#                 CALL cl_remove_zero(sr.pnb.pnb85b) RETURNING l_pnb85b
#                 LET l_str2 = l_pnb85b , sr.pnb.pnb83b CLIPPED
#             END IF
#      END CASE
#   ELSE
#   END IF
#
#   SELECT ima021,ima906 INTO l_ima021a,l_ima906a FROM ima_file
#                      WHERE ima01=sr.pnb.pnb04a
#   LET l_str1 = ""
#   IF g_sma115 = "Y" THEN
#      CASE l_ima906a
#         WHEN "2"
#             CALL cl_remove_zero(sr.pnb.pnb85a) RETURNING l_pnb85a
#             LET l_str1 = l_pnb85a, sr.pnb.pnb83a CLIPPED
#             IF cl_null(sr.pnb.pnb85a) OR sr.pnb.pnb85a = 0 THEN
#                 CALL cl_remove_zero(sr.pnb.pnb82a) RETURNING l_pnb82a
#                 LET l_str1 = l_pnb82a, sr.pnb.pnb80a CLIPPED
#             ELSE
#                IF NOT cl_null(sr.pnb.pnb82a) AND sr.pnb.pnb82a > 0 THEN
#                   CALL cl_remove_zero(sr.pnb.pnb82a) RETURNING l_pnb82a
#                   LET l_str1 = l_str1 CLIPPED,',',l_pnb82a, sr.pnb.pnb80a CLIPPED
#                END IF
#             END IF
#         WHEN "3"
#             IF NOT cl_null(sr.pnb.pnb85a) AND sr.pnb.pnb85a > 0 THEN
#                 CALL cl_remove_zero(sr.pnb.pnb85a) RETURNING l_pnb85a
#                 LET l_str1 = l_pnb85a , sr.pnb.pnb83a CLIPPED
#             END IF
#      END CASE
#   ELSE
#   END IF
#   IF g_sma.sma116 MATCHES '[13]' THEN    
#     #IF sr.pnb.pnb80b <> sr.pnb.pnb86b THEN  
#      IF sr.pnb.pnb07b <> sr.pnb.pnb86b THEN 
#         CALL cl_remove_zero(sr.pnb.pnb20b) RETURNING l_pnb20b
#         LET l_str2 = l_str2 CLIPPED,"(",l_pnb20b,sr.pnb.pnb07b CLIPPED,")"
#      END IF
#     #IF sr.pnb.pnb80a <> sr.pnb.pnb86a THEN  
#      IF sr.pnb.pnb07a <> sr.pnb.pnb86a THEN 
#         CALL cl_remove_zero(sr.pnb.pnb20a) RETURNING l_pnb20a
#         LET l_str1 = l_str1 CLIPPED,"(",l_pnb20a,sr.pnb.pnb07a CLIPPED,")"
#      END IF
#   END IF
#
#   PRINTX name=D1
#         COLUMN g_c[31],sr.pnb.pnb03 USING '###&', 
#         COLUMN g_c[32],g_x[21] CLIPPED,
#         COLUMN g_c[33],sr.pnb.pnb04b,
#         COLUMN g_c[34],l_str2 CLIPPED
#
#   LET p_ima021 = ''   #FUN-640236 add
#   SELECT ima021 INTO p_ima021 FROM ima_file WHERE ima01=sr.pnb.pnb04b
#   PRINTX name=D2
#         COLUMN g_c[37],sr.pnb.pnb041b
#   PRINTX name=D3
#         COLUMN g_c[49],p_ima021
#   PRINTX name=D4
#         COLUMN g_c[40],sr.pnb.pnb07b CLIPPED,
#         COLUMN g_c[41],cl_numfor(sr.pnb.pnb20b,41,2),
#         COLUMN g_c[42],sr.pnb.pnb86b CLIPPED,
#         COLUMN g_c[43],cl_numfor(sr.pnb.pnb87b,43,2),
#         COLUMN g_c[44],cl_numfor(sr.pnb.pnb31b,44,t_azi03),  
#         COLUMN g_c[45],cl_numfor(sr.pnb.pnb87b*sr.pnb.pnb31b,45,t_azi04),   #No.CHI-6A0004
#         COLUMN g_c[46],sr.pnb.pnb33b CLIPPED
#   PRINTX name=D1
#         COLUMN g_c[32],g_x[23] CLIPPED,
#         COLUMN g_c[33],sr.pnb.pnb04a,
#         COLUMN g_c[34],l_str1 CLIPPED
#   LET p_ima021 = ''   
#   SELECT ima021 INTO p_ima021 FROM ima_file WHERE ima01=sr.pnb.pnb04a
#   PRINTX name=D2
#         COLUMN g_c[37],sr.pnb.pnb041a
#   PRINTX name=D3
#         COLUMN g_c[49],p_ima021
#   PRINTX name=D4
#         COLUMN g_c[40],sr.pnb.pnb07a CLIPPED,
#         COLUMN g_c[41],cl_numfor(sr.pnb.pnb20a,41,2),
#         COLUMN g_c[42],sr.pnb.pnb86a CLIPPED,
#         COLUMN g_c[43],cl_numfor(sr.pnb.pnb87a,43,2),
#         COLUMN g_c[44],cl_numfor(sr.pnb.pnb31a,44,t_azi03),  
#         COLUMN g_c[45],cl_numfor(sr.pnb.pnb87a*sr.pnb.pnb31a,45,t_azi04), 
#         COLUMN g_c[46],sr.pnb.pnb33a CLIPPED
#
#   IF NOT(cl_null(sr.pnb.pnb50)) THEN
#      PRINTX name=S1 COLUMN g_c[32],g_x[22] CLIPPED,
#                     COLUMN g_c[33],sr.pnb.pnb50
#   END IF
#
#   SKIP 1 LINE
#AFTER GROUP OF sr.pna02
#   LET l_swich=1
#   LET l_pnd03=0
#   LET l_pnd04=' '
#   SKIP 1 LINE
#   FOREACH g911_cs2 USING sr.pna01,sr.pna02
#     INTO l_pnd03,l_pnd04
#     IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
#     IF l_swich=1 THEN
#        PRINTX name=S1
#              COLUMN g_c[36],g_x[22] CLIPPED;
#     END IF
#     PRINTX name=S1
#           COLUMN g_c[37],l_pnd04
#
#     LET l_swich=l_swich+1
#   END FOREACH
# 
#ON LAST ROW
#      LET l_last_sw = 'y'
#
#PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[24]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[24]
#             PRINT g_memo
#      END IF
#
#END REPORT
#FUNCTION g911_jmail(l_name)
#   DEFINE l_name       LIKE type_file.chr20 	
#   DEFINE l_cmd	       LIKE type_file.chr1000  
#
#   CALL cl_trans_xml(g_xml_rep,"T")
#   LET l_cmd = "cp ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED," ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
#   RUN l_cmd
#   LET l_cmd = FGL_GETENV("DS4GL"),"/bin/addcr ",FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
#   RUN l_cmd
#   LET g_xml.attach = FGL_GETENV("TEMPDIR") CLIPPED,"/", l_name CLIPPED,".txt"
#
#   CALL cl_jmail()
#   LET l_cmd = "rm ",g_xml.attach CLIPPED
#   RUN l_cmd
#END FUNCTION
#No.FUN-710091  --end

###GENGRE###START
FUNCTION apmg911_grdata()
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
        LET handler = cl_gre_outnam("apmg911")
        IF handler IS NOT NULL THEN
            START REPORT apmg911_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY pna01,pnb03"
          
            DECLARE apmg911_datacur1 CURSOR FROM l_sql
            FOREACH apmg911_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg911_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg911_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg911_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_pme031a_pme032a STRING
    DEFINE l_pme031b_pme032b STRING
    DEFINE l_pme031c_pme032c STRING
    DEFINE l_pme031_pme032   STRING
    DEFINE l_pme033_pme034   STRING
    DEFINE l_pme033a_pme034a STRING
    DEFINE l_pme033b_pme034b STRING
    DEFINE l_pme033c_pme034c STRING
    DEFINE l_pmm09_pmc03     STRING
    DEFINE l_pna09_oha02     STRING
    DEFINE l_pna09b_oha02n   STRING
    DEFINE l_pna10_pma02     STRING
    DEFINE l_pna10b_pma02n   STRING
    DEFINE l_qtya          LIKE pnb_file.pnb87a  
    DEFINE l_pnb87b_pnb31b LIKE pnb_file.pnb31b
    DEFINE l_qtyb          LIKE pnb_file.pnb87b  
    DEFINE l_pnb87a          STRING
    DEFINE l_pnb87b          STRING
    DEFINE l_pnb20a          STRING
    DEFINE l_pnb20b          STRING
    DEFINE l_unita         LIKE pnb_file.pnb86a
    DEFINE l_unitb         LIKE pnb_file.pnb86b 
    DEFINE l_title_qty       STRING
    DEFINE l_title_unit      STRING
    DEFINE l_sql             STRING
    DEFINE l_title_unit_comment STRING
    DEFINE l_p7        LIKE zo_file.zo12
    DEFINE l_display   LIKE type_file.chr1
    DEFINE l_display1  LIKE type_file.chr1
    DEFINE l_pnb31b_fmt          STRING
    DEFINE l_pnb31a_fmt          STRING
    DEFINE l_pnb87b_pnb31b_fmt   STRING
    DEFINE l_amount_fmt          STRING
    DEFINE l_display2            STRING
    DEFINE l_display3            STRING
    DEFINE l_display4            STRING    
    #FUN-B40092------add------end
    DEFINE l_pnb34b              STRING  #FUN-C50140
    DEFINE l_pnb35b              STRING  #FUN-C50140
    DEFINE l_pnb36b              STRING  #FUN-C50140

    
    ORDER EXTERNAL BY sr1.pna01,sr1.pna02,sr1.pnb03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_lang     #FUN-B40092 add
              
        BEFORE GROUP OF sr1.pna01
            LET l_lineno = 0
            #FUN-B40092------add------str
            SELECT zo12 INTO l_p7 FROM zo_file WHERE zo01='1'
            PRINTX l_p7
            LET l_pna10_pma02   = sr1.pna10,' ',sr1.pma02
            LET l_pna10b_pma02n = sr1.pna10b,' ',sr1.pma02n
            LET l_pna09b_oha02n = sr1.pna09b,' ',sr1.oah02n
            LET l_pme031c_pme032c = sr1.pme031c,' ',sr1.pme032c
            LET l_pme031b_pme032b = sr1.pme031b,' ',sr1.pme032b
            LET l_pme031a_pme032a = sr1.pme031a,' ',sr1.pme032a
            LET l_pme031_pme032 = sr1.pme031,' ',sr1.pme032
            LET l_pme033_pme034 = sr1.pme033,' ',sr1.pme034
            LET l_pme033a_pme034a = sr1.pme033a,' ',sr1.pme034a
            LET l_pme033b_pme034b = sr1.pme033b,' ',sr1.pme034b
            LET l_pme033c_pme034c = sr1.pme033c,' ',sr1.pme034c
            LET l_pmm09_pmc03 = sr1.pmm09,' ',sr1.pmc03
            LET l_pna09_oha02 = sr1.pna09,' ',sr1.oah02
            PRINTX l_pna10b_pma02n
            PRINTX l_pna10_pma02
            PRINTX l_pna09b_oha02n
            PRINTX l_pna09_oha02
            PRINTX l_pmm09_pmc03
            PRINTX l_pme033a_pme034a
            PRINTX l_pme033b_pme034b
            PRINTX l_pme033c_pme034c
            PRINTX l_pme033_pme034
            PRINTX l_pme031c_pme032c
            PRINTX l_pme031a_pme032a
            PRINTX l_pme031b_pme032b
            PRINTX l_pme031_pme032
 
            IF cl_null(sr1.pnb34a) AND cl_null(sr1.pnb34b) THEN
               LET l_display2 = "N"
            ELSE 
               LET l_display2 = "Y"              
            END IF 
            PRINTX l_display2

            IF cl_null(sr1.pnb35a) AND cl_null(sr1.pnb35b) THEN
               LET l_display3 = "N"
            ELSE
               LET l_display3 = "Y"
            END IF
            PRINTX l_display3

            IF cl_null(sr1.pnb36a) AND cl_null(sr1.pnb36b) THEN
               LET l_display4 = "N"
            ELSE
               LET l_display4 = "Y"
            END IF
            PRINTX l_display4

            #FUN-B40092------add------end
            LET l_lineno = 0
        BEFORE GROUP OF sr1.pna02
        BEFORE GROUP OF sr1.pnb03
            #FUN-B40092------add------str
            IF g_sma115 = 'Y' OR g_sma116 = '1' OR g_sma116 = '3' THEN
               LET l_title_unit_comment = "Unit Comment"
            ELSE
               LET l_title_unit_comment = ' '
            END IF
            PRINTX l_title_unit_comment 
            IF g_sma.sma116 = '1' OR g_sma.sma116 = '3' THEN
               LET l_title_qty = "Price Qty"
            ELSE
               LET l_title_qty = "Order Qty"
            END IF

             IF g_sma.sma116 = '1' OR g_sma.sma116 = '3' THEN
               LET l_title_unit = "Price Unt"
             ELSE
               LET l_title_unit = "Order Unt"
             END IF
            PRINTX l_title_qty
            PRINTX l_title_unit
            #FUN-B40092------add------end
        
        ON EVERY ROW
            #FUN-B40092------add------str
            PRINTX g_aza.aza08
            LET l_pnb31b_fmt = cl_gr_numfmt('pnb_file','pnb31b',sr1.azi03)
            PRINTX l_pnb31b_fmt
            LET l_pnb31a_fmt = cl_gr_numfmt('pnb_file','pnb31a',sr1.azi03)
            PRINTX l_pnb31a_fmt
            LET l_pnb87b_pnb31b_fmt = cl_gr_numfmt('pnb_file','pnb31b',sr1.azi04)
            PRINTX l_pnb87b_pnb31b_fmt
            LET l_amount_fmt = cl_gr_numfmt('pmn_file','pmn88',sr1.azi04)
            PRINTX l_amount_fmt
            IF g_sma115 = 'Y' OR g_sma116 = '1' OR g_sma116 = '3' THEN
               LET l_display1 = 'Y'
            ELSE
               LET l_display1 = 'N'
            END IF
            PRINTX l_display1
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE pmq01= '",sr1.pnb04a CLIPPED,"'",
                        " AND pmq02 = '",sr1.pmm09 CLIPPED,"'"
            START REPORT apmg911_subrep01
            DECLARE apmg911_repcur1 CURSOR FROM l_sql
            FOREACH apmg911_repcur1 INTO sr3.*
                OUTPUT TO REPORT apmg911_subrep01(sr3.*)
            END FOREACH
            FINISH REPORT apmg911_subrep01

            IF tm.b = 'Y' AND sr1.l_count > 0 THEN
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF
            PRINTX l_display

            LET l_pnb87b_pnb31b = sr1.pnb87b * sr1.pnb31b
            PRINTX l_pnb87b_pnb31b
            LET l_pnb87a = sr1.pnb87a USING '--,---,---,---,---,--&.&&'
            LET l_pnb87b = sr1.pnb87b USING '--,---,---,---,---,--&.&&'
            LET l_pnb20b = sr1.pnb20b USING '--,---,---,---,---,--&.&&'
            LET l_pnb20a = sr1.pnb20a USING '--,---,---,---,---,--&.&&'
            IF g_sma.sma116 = '1' OR g_sma.sma116 = '3' THEN
               LET l_qtya = l_pnb87a
            ELSE
               LET l_qtya = l_pnb20a
            END IF

            IF g_sma.sma116 = '1' OR g_sma.sma116 = '3' THEN
               LET l_qtyb = l_pnb87b
            ELSE
               LET l_qtyb = l_pnb20b
            END IF

            IF g_sma.sma116 = '1' OR g_sma.sma116 = '3' THEN
               LET l_unita = sr1.pnb86a
            ELSE
               LET l_unita = sr1.pnb07a
            END IF

            IF g_sma.sma116 = '1' OR g_sma.sma116 = '3' THEN
               LET l_unitb = sr1.pnb86b
            ELSE
               LET l_unitb = sr1.pnb07b
            END IF

            PRINTX l_qtya
            PRINTX l_qtyb
            PRINTX l_unita
            PRINTX l_unitb
            #FUN-B40092------add------end

            #FUN-C50140--add---str------
            LET l_pnb34b = cl_gr_getmsg('gre-271',g_lang,g_aza.aza08)
            LET l_pnb35b = cl_gr_getmsg('gre-273',g_lang,g_aza.aza08)
            LET l_pnb36b = cl_gr_getmsg('gre-274',g_lang,g_aza.aza08)
            PRINTX l_pnb34b
            PRINTX l_pnb35b
            PRINTX l_pnb36b
            #FUN-C50140--add---end------


            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.pna01
        AFTER GROUP OF sr1.pna02
        AFTER GROUP OF sr1.pnb03
            #FUN-B40092------add------str
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE pnd01 = '",sr1.pna01 CLIPPED,"'",
                        " AND pnd02 = ",sr1.pna02 CLIPPED 
            START REPORT apmg911_subrep02
            DECLARE apmg911_repcur2 CURSOR FROM l_sql
            FOREACH apmg911_repcur2 INTO sr2.*
                OUTPUT TO REPORT apmg911_subrep02(sr2.*)
            END FOREACH
            FINISH REPORT apmg911_subrep02
            #FUN-B40092------add------end
        
        ON LAST ROW

END REPORT


REPORT apmg911_subrep01(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT apmg911_subrep02(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_n              LIKE type_file.num5

    ORDER EXTERNAL BY sr2.pnd01

    FORMAT
        BEFORE GROUP OF sr2.pnd01
           LET l_n = 0

        ON EVERY ROW
           LET l_n = l_n + 1
           PRINTX l_n
           PRINTX sr2.*

END REPORT
###GENGRE###END
