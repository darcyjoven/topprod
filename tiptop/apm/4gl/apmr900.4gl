# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr900.4gl
# Desc/riptions..: 採購單
# Date & Author..: 95/02/14 By Danny
# Modify.........: No.MOD-490282 04/09/16 Melody ARG_VAL()接收段挪到 cl_user()之前
# Modify.........: No.MOD-4A0223 04/10/14 By Smapmin將sr.oah02[1,20]改成將sr.oah02全部印出來
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or type_file.num20_6	
# Modify.........: No.FUN-540027 05/05/30 By Elva  增印pmn88t,pmn31t
# Modify.........: No.FUN-550114 05/05/26 By Echo 新增報表備註
# Modify.........: No.FUN-560229 05/06/29 By Echo 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.FUN-580019 05/08/10 By Echo 報表選擇列印單行時，g_len計算錯誤。
# Modify.........: No.MOD-590494 05/10/03 By Rosayu 1.報表寬度錯誤
#                                                   2.報表位置不正確、調整
# Modify.........: No.FUN-5A0139 05/10/24 By Pengu 調整報表的格式
# Modify.........: No.MOD-5A0436 05/10/28 By Echo 勾選「其他特殊列印條件」選擇語言別:「1:英文」，產生的報表還是繁體中文
# Modify.........: No.TQC-5B0037 05/11/08 By Rosayu 1.項次資料跟後面資料黏在一起
#                                                   2.報表格式調整
# Modify.........: No.TQC-5A0121 05/11/22 By Rosayu 1.項次列印沒加USING或cl_number 2.第一次變換語言產生的報表非該語言別
# Modify.........: No.MOD-5A0381 05/11/22 By Rosayu 第二頁加入採購單號顯示,頁尾程式編號放錯地方
# Modify.........: No.FUN-5B0059 06/01/03 By Sarah 當(cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)時才CALL r900_tm()
# Modify.........: No.FUN-610028 06/01/11 By Sarah 畫面的語言變更時,報表內容表頭不需跟著變,因為要列印的語言別是跟著apmi600的慣用語言走的(pmc911)
# Modify.........: No.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-640173 06/04/09 By Echo 簽核欄位重覆為二列, 應保留最後一列即可
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-660067 06/10/05 By rainy 傳參數 g_xml
# Modify.........: No.FUN-690119 06/10/17 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6A0086 06/11/13 By baogui 無接下頁 結束
# Modify.........: No.MOD-6B0030 06/12/11 By claire 合計沒有印出
# Modify.........: No.MOD-6C0093 06/12/18 By kim 程式apmr900的計價數量請給三位小數,以免造成與輸入資料不符.
# Modify.........: No.TQC-6C0136 06/12/22 By rainy 使用計價單位時，金額有誤修正.
# Modify.........: No.MOD-6B0111 06/12/28 By Mandy 使用雙單位或計價單位時,報表呈現有問題
# Modify.........: No.FUN-710091 07/02/20 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.MOD-6C0176 07/04/03 By pengu 特別說明單身"在後"印出來的位置錯誤
# Modify.........: No.TQC-740276 07/04/20 By wujie 特別說明單身"在後"印出來的位置錯誤
# Modify.........: No.MOD-740291 07/05/02 By Sarah 在4gl裡先將合計(sum_pmn88,sum_pmn88t)計算好
# Modify.........: No.FUN-750059 07/05/15 By Sarah 單位註解(l_str2)中間含有空白,加上CLIPPED
# Modify.........: No.FUN-740224 07/06/05 By Sarah 列印最近採購紀錄最大筆數功能有問題
# Modify.........: No.TQC-780030 07/08/30 By rainy 送貨地址異常
# Modify.........: No.FUN-770064 07/09/21 By Sarah 增加特別說明功能(改用新的子報表寫法改寫)
# Modify.........: No.CHI-790029 07/10/09 By jamie 過FUN-770064的程式
# Modify.........: No.CHI-7A0017 07/10/11 By jamie 報表印不出來 l_sql導致
# Modify.........: No.FUN-7B0142 07/12/12 By jamie 不應在rpt寫入各語言的title，要廢除這樣的寫法(程式中使用g_rlang再切換)，報表列印不需參考慣用語言的設定。
# Modify.........: No.FUN-810029 08/02/25 By Sarah 對外的憑證，皆需在頁首公司名稱下，增加顯示"公司地址zo041、公司電話zo05、公司傳真zo09"
# Modify.........: No.MOD-820152 08/02/25 By claire apmp210勾選超過20張單號時,串入會有prepare錯誤
# Modify.........: No.FUN-860075 08/07/07 By xiaofeizhu 報表列印選項加入是否列印廠商料號額外品名規格
# Modify.........: No.MOD-870254 08/07/22 By Smapmin 恢復選擇是否列印請購單號與廠商料號的功能
# Modify.........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
# Modify.........: No.CHI-970025 09/07/13 By mike pmn_cur這個cursor的條件多加上pmm01 <> sr.pmm01
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0441 09/12/28 By sherry 列印次數沒有更新
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:CHI-A10024 10/02/08 By Smapmin 條件儲存功能只適用於CONSTRUCT
# Modify.........: No:MOD-A60083 10/06/12 By Carrier 连接符修改 & SQL调整
# Modify.........: No:CHI-A80047 10/09/06 By Summer 調整送貨地址與帳單地址
# Modify.........: No:MOD-AC0119 10/12/21 By Smapmin 修改變數定義型態
# Modify.........: No:MOD-B30618 11/03/21 By Summer 調整外部參數傳遞 
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-B90159 11/09/21 By Vampire 增加採購單項次的條件當子報表與主報表鏈結的條件 
# Modify.........: No:FUN-940043 11/11/03 By huangtao CR報表列印EF簽核圖檔 OR TIPTOP自訂簽核欄位
# Modify.........: No:MOD-BC0184 11/12/27 By Summer 產生報表時，子報表部分，未經排序導致資料順序亂跳
# Modify.........: No:TQC-C10039 12/01/12 By minpp  CR报表列印TIPTOP与EasyFlow签核图片修改
# Modify.........: No:MOD-BA0076 12/01/30 By Vampire l_str2前會有空白,請去掉空白 


DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
   DEFINE g_zaa04_value  LIKE zaa_file.zaa04
   DEFINE g_zaa10_value  LIKE zaa_file.zaa10
   DEFINE g_zaa11_value  LIKE zaa_file.zaa11
   DEFINE g_zaa17_value  LIKE zaa_file.zaa17     #FUN-560079
   DEFINE g_seq_item    LIKE type_file.num5   	#No.FUN-680136 SMALLINT
END GLOBALS
 
   DEFINE tm  RECORD				# Print condition RECORD
       	    	wc     	STRING,                 #MOD-820152 modify LIKE type_file.chr1000,	# Where condition 	  #No.FUN-680136 VARCHAR(500)
              a       LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    	        b      	LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1) 
    	        c     	LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    	        d       LIKE type_file.chr1,    #No.FUM-860075
             more     LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1) 
              END RECORD
   DEFINE g_zo          RECORD LIKE zo_file.*
   DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680136 INTEGER
   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose   #No.FUN-680136 SMALLINT
   DEFINE g_sma115      LIKE sma_file.sma115
   DEFINE g_sma116      LIKE sma_file.sma116
   DEFINE g_rlang_2     LIKE type_file.chr1   	#No.FUN-680136 VARCHAR(1) 
   DEFINE g_sql         STRING
   DEFINE g_str         STRING
   DEFINE l_table       STRING
   DEFINE l_table1      STRING
   DEFINE l_table2      STRING
   DEFINE l_table3      STRING
   DEFINE l_table4      STRING
   DEFINE l_table5      STRING                  #FUN-770064 add
   DEFINE l_table6      STRING                  #FUN-860075       
MAIN
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   LET g_pdate  = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   LET tm.d = ARG_VAL(11)            #No.FUN-860075 #MOD-B30618 mod 18->11
   #MOD-B30618 mod --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
  #LET g_xml.subject = ARG_VAL(15)
  #LET g_xml.body = ARG_VAL(16)
  #LET g_xml.recipient = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(15)      #No.FUN-7C0078
   #MOD-B30618 mod --end-- 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   IF cl_null(g_rlang) THEN
      LET g_rlang=g_lang
   END IF
   LET g_rlang_2 = g_rlang    #FUN-560229
 
   LET g_sql = "pmm01.pmm_file.pmm01,",   
               "smydesc.smy_file.smydesc,", 
               "pmm04.pmm_file.pmm04,",  
               "pmc081.pmc_file.pmc081,", 
               "pmc091.pmc_file.pmc091,", 
               "pmc10.pmc_file.pmc10 ,", 
               "pmc11.pmc_file.pmc11 ,",
               "pma02.pma_file.pma02,",  
               "pmm41.pmm_file.pmm41,",  
               "oah02.oah_file.oah02,",  
               "gec02.gec_file.gec02,",  
               "pmm09.pmm_file.pmm09,",  
               "pmm10.pmm_file.pmm10,",  
               "pmm11.pmm_file.pmm11,",  
               "pmm22.pmm_file.pmm22,",  
               "pmn02.pmn_file.pmn02,",  
               "pmn04.pmn_file.pmn04,",  
               "pmn041.pmn_file.pmn041,", 
               "pmn07.pmn_file.pmn07,",
               "pmn20.pmn_file.pmn20,",  
               "pmn31.pmn_file.pmn31,",  
               "pmn88.pmn_file.pmn88,",  
               "pmn33.pmn_file.pmn33,",  
               "pmn15.pmn_file.pmn15,",  
               "pmn14.pmn_file.pmn14,",  
               "pmn24.pmn_file.pmn24,",  
               "pmn25.pmn_file.pmn25,",  
               "pmn06.pmn_file.pmn06,",  
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "pmn31t.pmn_file.pmn31t,",  
               "pmn88t.pmn_file.pmn88t,",  
               "pmn08.pmn_file.pmn08,",   
               "pmn09.pmn_file.pmn09,",  
               "pmn80.pmn_file.pmn80,",   
               "pmn82.pmn_file.pmn82,",  
               "pmn83.pmn_file.pmn83,",  
               "pmn85.pmn_file.pmn85,",  
               "pmn86.pmn_file.pmn86,",  
               "pmn87.pmn_file.pmn87,",  
               "pme031.pme_file.pme031,",
               "pme032.pme_file.pme032,",
               "pme033.pme_file.pme033,",  #CHI-A80047 add
               "pme034.pme_file.pme034,",  #CHI-A80047 add
               "pme035.pme_file.pme035,",  #CHI-A80047 add
               "pme0311.pme_file.pme031,",
               "pme0322.pme_file.pme032,",
               "pme0333.pme_file.pme033,", #CHI-A80047 add
               "pme0344.pme_file.pme034,", #CHI-A80047 add
               "pme0355.pme_file.pme035,", #CHI-A80047 add
               "ima021.ima_file.ima021,",
               "l_str2.type_file.chr1000,",
               "sma115.sma_file.sma115,",
               "sma116.sma_file.sma116,",
               "gfe03.gfe_file.gfe03,",
               "gfe03b.gfe_file.gfe03,",
               "sign_type.type_file.chr1,", #FUN-940043 add
               "sign_img.type_file.blob,",  #FUN-940043 add
               "sign_show.type_file.chr1,",   #FUN-940043 add
               "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
   LET l_table = cl_prt_temptable('apmr900',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
 
   #最近採購記錄 
   LET g_sql = "pmm01.pmm_file.pmm01,",
               "pmn04.pmn_file.pmn04,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "sr1_pmm04.pmm_file.pmm04,",     #FUN-740224 add
               "sr1_pmm01.pmm_file.pmm01,",     #FUN-740224 add
               "sr1_pmc03.pmc_file.pmc03,",     #FUN-740224 add
               "sr1_pmn20.pmn_file.pmn20,",     #FUN-740224 add
               "sr1_pmn07.pmn_file.pmn07,",     #FUN-740224 add
               "sr1_pmm22.pmm_file.pmm22,",     #FUN-740224 add
               "sr1_pmn31.pmn_file.pmn31,",     #FUN-740224 add
               "sr1_pmn88.pmn_file.pmn88,",     #FUN-740224 add
               "sr1_pmn31t.pmn_file.pmn31t,",   #FUN-740224 add
               "sr1_pmn88t.pmn_file.pmn88t,",   #FUN-740224 add
               "sr1_gfe03.gfe_file.gfe03,",     #FUN-740224 add
               "pmn02.pmn_file.pmn02"           #MOD-B90159 add
   LET l_table1 = cl_prt_temptable('apmr9001',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
 
   #特別說明-單據前說明 
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmo06.pmo_file.pmo06"
   LET l_table2 = cl_prt_temptable('apmr9002',g_sql) CLIPPED
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF
 
   #特別說明-單據項次前說明 
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmo03.pmo_file.pmo03,",
               "pmo06.pmo_file.pmo06"
   LET l_table3 = cl_prt_temptable('apmr9003',g_sql) CLIPPED
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF
 
   #特別說明-單據項次後說明 
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmo03.pmo_file.pmo03,",
               "pmo06.pmo_file.pmo06"
   LET l_table4 = cl_prt_temptable('apmr9004',g_sql) CLIPPED
   IF  l_table4 = -1 THEN EXIT PROGRAM END IF
 
   #特別說明-單據後說明 
   LET g_sql = "pmo01.pmo_file.pmo01,",
               "pmo06.pmo_file.pmo06"
   LET l_table5 = cl_prt_temptable('apmr9005',g_sql) CLIPPED
   IF  l_table5 = -1 THEN EXIT PROGRAM END IF
   
     LET g_sql = "pmq01.pmq_file.pmq01,",
                 "pmq02.pmq_file.pmq02,",
                 "pmq03.pmq_file.pmq03,",
                 "pmq04.pmq_file.pmq04,",
                 "pmq05.pmq_file.pmq05,",
                 "pmm01.pmm_file.pmm01,",
                 "pmn02.pmn_file.pmn02"
   LET l_table6 = cl_prt_temptable('apmr9006',g_sql) CLIPPED
   IF  l_table6 = -1 THEN EXIT PROGRAM END IF 
 
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)    # If background job sw is off
      THEN CALL r900_tm(0,0)		# Input print condition
      ELSE CALL apmr900()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r900_tm(p_row,p_col)
#DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031   #CHI-A10024
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r900_w AT p_row,p_col WITH FORM "apm/42f/apmr900"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 'N'
   LET tm.b    = 'N'
   LET tm.c    = 0
   LET tm.d    = 'N'                  #FUN-860075
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_rlang_2 = g_rlang            #FUN-560229
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm12
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
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #-----CHI-A10024---------
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #-----END CHI-A10024-----
 
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      LET g_rlang_2 = g_rlang        #FUN-770064 add
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r900_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
 
   INPUT BY NAME tm.a,tm.b,tm.c,tm.more,tm.d WITHOUT DEFAULTS              #FUN-860075 Add tm.d
      #-----CHI-A10024---------
      #BEFORE INPUT
      #    CALL cl_qbe_display_condition(lc_qbe_sn)
      #-----CHI-A10024---------
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[YN]" THEN
            NEXT FIELD a
         END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES "[YN]" THEN
            NEXT FIELD b
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
                 LET g_rlang_2 = g_rlang        #MOD-5A0436
         END IF
         
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES "[YN]" THEN
            NEXT FIELD d
         END IF     
         
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG 
         CALL cl_cmdask()	# Command execution
 
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
 
      #-----CHI-A10024---------
      #ON ACTION qbe_save
      #   CALL cl_qbe_save()
      #-----END CHI-A10024-----
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r900_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr900'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr900','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'"  ,
                         " '",tm.d CLIPPED,"'",                 #No.FUN-860075 #MOD-B30618 mod
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078 #MOD-B30618 mod
                        #" '",tm.d CLIPPED,"'"                  #No.FUN-860075 #MOD-B30618 mark
         CALL cl_cmdat('apmr900',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr900()
   ERROR ""
END WHILE
   CLOSE WINDOW r900_w
END FUNCTION
 
FUNCTION apmr900()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	# Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sql 	STRING,                 #MOD-820152 modify LIKE type_file.chr1000,	# RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000) 
          l_space 	STRING,                 #MOD-BA0076 add
          l_space2 	STRING,                 #MOD-BA0076 add
          l_chr		LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(40)
          l_zaa08       LIKE zaa_file.zaa08,    #FUN-610028
          l_wc          STRING,                 #FUN-770064 add
          sr   RECORD
                     pmm01     LIKE pmm_file.pmm01,    #採購單號
                     smydesc   LIKE smy_file.smydesc,  #單別說明
                     pmm04     LIKE pmm_file.pmm04,    #採購日期
                     pmc081    LIKE pmc_file.pmc081,   #供應商全名
                     pmc091    LIKE pmc_file.pmc091,   #供應商地址   #MOD-AC0119
                     pmc10     LIKE pmc_file.pmc10 ,   #供應商電話
                     pmc11     LIKE pmc_file.pmc11 ,   #供應商傳真
                     pma02     LIKE pma_file.pma02,    #付款條件
                     pmm41     LIKE pmm_file.pmm41,    #價格條件
                     pnz02     LIKE pnz_file.pnz02,    #價格條件說明 #FUN-930113
                     gec02     LIKE gec_file.gec02,    #稅別
                     pmm09     LIKE pmm_file.pmm09,    #廠商編號
                     pmm10     LIKE pmm_file.pmm10,    #送貨地址
                     pmm11     LIKE pmm_file.pmm11,    #帳單地址
                     pmm22     LIKE pmm_file.pmm22,    #幣別
                     pmn02     LIKE pmn_file.pmn02,    #項次
                     pmn04     LIKE pmn_file.pmn04,    #料件編號
                     pmn041    LIKE pmn_file.pmn041,   #品名規格
                     pmn07     LIKE pmn_file.pmn07,    #單位
                     pmn20     LIKE pmn_file.pmn20,    #數量
                     pmn31     LIKE pmn_file.pmn31,    #未稅單價
                     pmn88     LIKE pmn_file.pmn88,    #未稅金額
                     pmn33     LIKE pmn_file.pmn33,    #交貨日
                     pmn15     LIKE pmn_file.pmn15,    #提前交貨
                     pmn14     LIKE pmn_file.pmn14,    #部份交貨
                     pmn24     LIKE pmn_file.pmn24,    #請購單號
                     pmn25     LIKE pmn_file.pmn25,    #請購項次
                     pmn06     LIKE pmn_file.pmn06,    #廠商料號
                     azi03     LIKE azi_file.azi03,
                     azi04     LIKE azi_file.azi04,
                     azi05     LIKE azi_file.azi05,
                     pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
                     pmn88t    LIKE pmn_file.pmn88t,   #含稅金額
                     pmn08     LIKE pmn_file.pmn08,               #FUN-560229
                     pmn09     LIKE pmn_file.pmn09,               #FUN-560229
                     pmn80     LIKE pmn_file.pmn80,               #FUN-560229
                     pmn82     LIKE pmn_file.pmn82,               #FUN-560229
                     pmn83     LIKE pmn_file.pmn83,               #FUN-560229
                     pmn85     LIKE pmn_file.pmn85,               #FUN-560229
                     pmn86     LIKE pmn_file.pmn86,    #計價單位  #FUN-560229
                     pmn87     LIKE pmn_file.pmn87    #計價數量  #FUN-560229
               END RECORD,
          sr1  RECORD
                     pmm04     LIKE pmm_file.pmm04,
                     pmm01     LIKE pmm_file.pmm01,
                     pmc03     LIKE pmc_file.pmc03,
                     pmn20     LIKE pmn_file.pmn20,
                     pmn07     LIKE pmn_file.pmn07,
                     pmm22     LIKE pmm_file.pmm22,
                     pmn31     LIKE pmn_file.pmn31,
                     pmn88     LIKE pmn_file.pmn88,
                     pmn31t    LIKE pmn_file.pmn31t,   #含稅單價
                     pmn88t    LIKE pmn_file.pmn88t,   #含稅金額
                     gfe03     LIKE gfe_file.gfe03
               END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5     #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE l_zab05            LIKE zab_file.zab05     #FUN-610028
     DEFINE l_pme031           LIKE pme_file.pme031
     DEFINE l_pme032           LIKE pme_file.pme032
     DEFINE l_pme0311          LIKE pme_file.pme031
     DEFINE l_pme0322          LIKE pme_file.pme032
     DEFINE l_ima021           LIKE ima_file.ima021
     DEFINE l_pmo06            LIKE pmo_file.pmo06
     DEFINE l_str2             LIKE type_file.chr1000
     DEFINE l_ima906           LIKE ima_file.ima906
     DEFINE l_pmn85            LIKE pmn_file.pmn85
     DEFINE l_pmn82            LIKE pmn_file.pmn82
     DEFINE l_pmn20            LIKE pmn_file.pmn20
     DEFINE l_gfe03            LIKE gfe_file.gfe03   
     DEFINE l_gfe03b           LIKE gfe_file.gfe03 
 
     DEFINE sr2  RECORD
                      pmq01    LIKE pmq_file.pmq01,
                      pmq02    LIKE pmq_file.pmq02,
                      pmq03    LIKE pmq_file.pmq03,
                      pmq04    LIKE pmq_file.pmq04,
                      pmq05    LIKE pmq_file.pmq05
                 END RECORD   
   DEFINE l_pmm01    LIKE pmm_file.pmm01   #MOD-9C0441
   #CHI-A80047 add --start--
   DEFINE l_pme033           LIKE pme_file.pme033
   DEFINE l_pme034           LIKE pme_file.pme034
   DEFINE l_pme035           LIKE pme_file.pme035
   DEFINE l_pme0333          LIKE pme_file.pme033
   DEFINE l_pme0344          LIKE pme_file.pme034
   DEFINE l_pme0355          LIKE pme_file.pme035
   #CHI-A80047 add --end--
#TQC-C10039--MOD--STR--
   #FUN-B940043 START
   DEFINE l_img_blob         LIKE type_file.blob
#  DEFINE l_ii               INTEGER 
#  DEFINE l_key              RECORD 
#         v1                 LIKE pmm_file.pmm01
#         END RECORD 
   #FUN-B940043 END
#TQC-C10039--MOD--END--   
   CALL g_zaa_dyn.clear()           #MOD-640173
 
   CALL cl_del_data(l_table)        #No.FUN-710091 add
   CALL cl_del_data(l_table1)       #FUN-770064 add
   CALL cl_del_data(l_table2)       #FUN-770064 add
   CALL cl_del_data(l_table3)       #FUN-770064 add
   CALL cl_del_data(l_table4)       #FUN-770064 add
   CALL cl_del_data(l_table5)       #FUN-770064 add
   CALL cl_del_data(l_table6)       #FUN-860075 add
   
   LOCATE l_img_blob IN MEMORY      #FUN-B940043 add
   
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-560229
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #FUN-740224 add
   SELECT * INTO g_zo.* FROM zo_file WHERE zo01 = g_rlang
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              #"        ?,?,?,?,?, ?,?,?,?,?, ?)" #FUN-7B0142 拿掉一個?  #FUN-770064 mod #CHI-A80047 mark
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)" #FUN-B940043 add 3?  #CHI-A80047  #TQC-C10039 ADD 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
 
   #最近採購記錄
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"              ##MOD-B90159 add ?
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   
   #特別說明-單據前說明 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
 
   #特別說明-單據項次前說明 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep3:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
 
   #特別說明-單據項次後說明 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep4 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep4:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
 
   #特別說明-單據後說明 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
               " VALUES(?,?)"
   PREPARE insert_prep5 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep5:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF
   
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
   PREPARE insert_prep6 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep6:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM
   END IF 
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
 
   LET g_rlang = g_rlang_2   #CHI-7A0017 mod  #FUN-560229
   
   LET l_sql = "SELECT pmm01,smydesc,pmm04,pmc081,pmc091,pmc10,pmc11,",    
               "       pma02,pmm41,pnz02,", #FUN-930113 oah-->pnz
               "       gec02,pmm09,pmm10,pmm11,pmm22,pmn02,pmn04,pmn041,",
               "       pmn07,pmn20,pmn31,pmn88,pmn33,pmn15,",
               "       pmn14,pmn24,pmn25,pmn06,azi03,azi04,azi05, ",          #FUN-7B0142 mod  將pmc911拿掉
               "       pmn31t,pmn88t,pmn08,pmn09,pmn80,pmn82,pmn83,pmn85,",
               "       pmn86,pmn87",   #FUN-560229
               #No.MOD-A60083  --Begin
               "  FROM pmm_file LEFT OUTER JOIN smy_file ON pmm01 like smy_file.smyslip || '-%' ",
               "                LEFT OUTER JOIN pmc_file ON pmc01 = pmm09 ",
               "                LEFT OUTER JOIN azi_file ON pmm22 = azi01 ",
               "                LEFT OUTER JOIN pma_file ON pmm20 = pma01 ",
               "                LEFT OUTER JOIN gec_file ON pmm21 = gec01 ",
              #"                LEFT OUTER JOIN oah_file ON pmm41 = oah01,pmn_file",
               "                LEFT OUTER JOIN pnz_file ON pmm41 = pnz01,pmn_file",
               " WHERE pmm01 = pmn01 ",
               "   AND pmm18 !='X' ",
               "   AND gec_file.gec011='1'",  #進項
               "   AND pmmacti='Y' ",
               "   AND pmm02 !='BKR' ",        #modi by kitty96-05-29
               "   AND ",tm.wc CLIPPED,
               "   ORDER BY pmm01,pmn02"    #No.FUN-710091 add
               #No.MOD-A60083  --End
 
   PREPARE r900_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE r900_cs1 CURSOR FOR r900_prepare1
#TQC-C10039--MARK--STR--
#  #FUN-940043 START
#     LET l_sql = "SELECT pmm01",    
#              "  FROM pmm_file LEFT OUTER JOIN smy_file ON pmm01 like smy_file.smyslip || '-%' ",
#              "                LEFT OUTER JOIN pmc_file ON pmc01 = pmm09 ",
#              "                LEFT OUTER JOIN azi_file ON pmm22 = azi01 ",
#              "                LEFT OUTER JOIN pma_file ON pmm20 = pma01 ",
#              "                LEFT OUTER JOIN gec_file ON pmm21 = gec01 ",
#              "                LEFT OUTER JOIN pnz_file ON pmm41 = pnz01,pmn_file",
#              " WHERE pmm01 = pmn01 ",
#              "   AND pmm18 !='X' ",
#              "   AND gec_file.gec011='1'",  
#              "   AND pmmacti='Y' ",
#              "   AND pmm02 !='BKR' ",        
#              "   AND ",tm.wc CLIPPED,
#              "   ORDER BY pmm01"    
#
#  PREPARE r900_prepare4 FROM l_sql
#  IF SQLCA.sqlcode != 0 THEN
#     CALL cl_err('r900_prepare4:',SQLCA.sqlcode,1) 
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
#     EXIT PROGRAM
#  END IF
#  DECLARE r900_cs4 CURSOR FOR r900_prepare4
   #FUN-940043 END
#TQC-C10039--MARK--END--   
   LET g_pageno = 0
   FOREACH r900_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      IF cl_null(sr.pmn20)  THEN LET sr.pmn20=0  END IF
      IF cl_null(sr.pmn31)  THEN LET sr.pmn31=0  END IF
      IF cl_null(sr.pmn31t) THEN LET sr.pmn31t=0 END IF
      IF cl_null(sr.pmn88)  THEN LET sr.pmn88=0  END IF
      IF cl_null(sr.pmn88t) THEN LET sr.pmn88t=0 END IF
 
      #送貨地址 
      #CHI-A80047 mod --start--
      #SELECT pme031,pme032 INTO l_pme031,l_pme032 FROM pme_file
      # WHERE pme01=sr.pmm10
      #IF SQLCA.SQLCODE THEN LET l_pme031='' LET l_pme032='' END IF
      SELECT pme031,pme032,pme033,pme034,pme035 
        INTO l_pme031,l_pme032,l_pme033,l_pme034,l_pme035 
        FROM pme_file
       WHERE pme01=sr.pmm10
      IF SQLCA.SQLCODE THEN 
         LET l_pme031='' 
         LET l_pme032='' 
         LET l_pme033='' 
         LET l_pme034='' 
         LET l_pme035='' 
      END IF
      #CHI-A80047 mod --end--
 
      #帳單地址
      #CHI-A80047 mod --start--
      #SELECT pme031,pme032 INTO l_pme0311,l_pme0322 FROM pme_file
      # WHERE pme01=sr.pmm11
      #IF SQLCA.SQLCODE THEN LET l_pme0311='' LET l_pme0322='' END IF  #TQC-780030
      SELECT pme031,pme032,pme033,pme034,pme035 
        INTO l_pme0311,l_pme0322,l_pme0333,l_pme0344,l_pme0355 
        FROM pme_file
       WHERE pme01=sr.pmm11
      IF SQLCA.SQLCODE THEN 
         LET l_pme0311='' 
         LET l_pme0322='' 
         LET l_pme0333='' 
         LET l_pme0344='' 
         LET l_pme0355='' 
      END IF
      #CHI-A80047 mod --end--
    
      #額外備註-項次前備註 
      DECLARE pmo_cur2 CURSOR FOR
         SELECT pmo06 FROM pmo_file 
          WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='0'
          ORDER BY pmo05                                        #No.TQC-740276
      FOREACH pmo_cur2 INTO l_pmo06                             #No.TQC-740276
         EXECUTE insert_prep3 USING sr.pmm01,sr.pmn02,l_pmo06   #No.TQC-740276    #FUN-770064 mod
      END FOREACH
      
      #額外備註-項次後備註 
      DECLARE pmo_cur3 CURSOR FOR
       SELECT pmo06 FROM pmo_file    
        WHERE pmo01=sr.pmm01 AND pmo03=sr.pmn02 AND pmo04='1'
        ORDER BY pmo05                                          #No.TQC-740276
      FOREACH pmo_cur3 INTO l_pmo06                             #No.TQC-740276
         EXECUTE insert_prep4 USING sr.pmm01,sr.pmn02,l_pmo06   #No.TQC-740276    #FUN-770064 mod
      END FOREACH
      
      #規格,單位使用方式 
      SELECT ima021,ima906 INTO l_ima021,l_ima906 FROM ima_file
       WHERE ima01=sr.pmn04
 
      #單位小數位數
      LET l_gfe03=0
      SELECT gfe03 INTO l_gfe03 FROM gfe_file
       WHERE gfe01=sr.pmn86
      LET l_gfe03b=0
      SELECT gfe03 INTO l_gfe03b FROM gfe_file
       WHERE gfe01=sr.pmn07
 
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN    #使用雙單位
         CASE l_ima906
            WHEN "2"   #母子單位
                #MOD-BA0076 --- start ---
                #CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                CALL cl_remove_zero(sr.pmn85) RETURNING l_space
                LET l_space = l_space.trim()
                LET l_space2 = sr.pmn83
                LET l_space2 = l_space2.trim()
                #LET l_str2 = l_pmn85 CLIPPED, sr.pmn83 CLIPPED   #FUN-750059 add CLIPPED
                LET l_str2 = l_space, l_space2
                #MOD-BA0076 ---  end  ---
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                    #MOD-BA0076 --- start ---
                    #CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_space
                    LET l_space = l_space.trim()
                    LET l_space2 = sr.pmn80
                    LET l_space2 = l_space2.trim()
                    #LET l_str2 = l_pmn82 CLIPPED, sr.pmn80 CLIPPED   #FUN-750059 add CLIPPED
                    LET l_str2 = l_space, l_space2
                    #MOD-BA0076 ---  end  ---
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                      #MOD-BA0076 --- start ---
                      #CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_space
                      LET l_space = l_space.trim()
                      LET l_space2 = sr.pmn80
                      LET l_space2 = l_space2.trim()
                      #LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED   #FUN-750059 add CLIPPED
                      LET l_str2 = l_str2,',', l_space, l_space2
                      #MOD-BA0076 ---  end  ---
                   END IF
                END IF
            WHEN "3"   #參考單位
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                    #MOD-BA0076 --- start ---
                    #CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_space
                    LET l_space = l_space.trim()       
                    LET l_space2 = sr.pmn83
                    LET l_space2 = l_space2.trim()       
                    #LET l_str2 = l_pmn85 CLIPPED, sr.pmn83 CLIPPED   #FUN-750059 add CLIPPED
                    LET l_str2 = l_space, l_space2
                    #MOD-BA0076 ---  end  ---
                END IF
         END CASE
      END IF
      #採購系統使用計價單位(sma116=1,3)
      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
         IF sr.pmn07 <> sr.pmn86 THEN  #TQC-6C0136
            #MOD-BA0076 --- start ---
            #CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
            CALL cl_remove_zero(sr.pmn20) RETURNING l_space
            LET l_space = l_space.trim()
            LET l_space2 = sr.pmn07
            LET l_space2 = l_space2.trim()
            #LET l_str2 = l_str2 CLIPPED,"(",l_pmn20 CLIPPED,sr.pmn07 CLIPPED,")"   #FUN-750059 add CLIPPED
            LET l_str2 = l_str2,"(",l_space, l_space2,")"
            #MOD-BA0076 ---  end  ---
         END IF
      END IF
 
      EXECUTE insert_prep USING 
         sr.*,
         l_pme031,l_pme032,l_pme033,l_pme034,l_pme035, #CHI-A80047 add l_pme033,l_pme034,l_pme035
         l_pme0311,l_pme0322,l_pme0333,l_pme0344,l_pme0355, #CHI-A80047 add l_pme0333,l_pme0344,l_pme0355
         l_ima021,l_str2,g_sma.sma115,
         g_sma.sma116,l_gfe03,l_gfe03b,
         "",l_img_blob,"N",""  #FUN-940043  #TQC-C10039 ADD ""
  
      #str FUN-740224 add   #列印最近採購紀錄最大筆數功能
      IF tm.c > 0 THEN
         DECLARE pmn_cur CURSOR FOR
            SELECT pmm04,pmm01,pmc03,pmn20,pmn07,pmm22,pmn31,
                   pmn88,pmn31t,pmn88t,''
              FROM pmm_file, pmn_file, OUTER pmc_file
             WHERE pmn04 = sr.pmn04 AND pmn01=pmm01 AND pmm_file.pmm09=pmc_file.pmc01
               AND pmm01<>sr.pmm01 #CHI-970025 
             ORDER BY pmm04 DESC
         LET g_cnt=0
         FOREACH pmn_cur INTO sr1.*
            IF STATUS THEN CALL cl_err('pmn_cur',STATUS,1) EXIT FOREACH END IF
            LET g_cnt = g_cnt + 1 IF g_cnt > tm.c THEN EXIT FOREACH END IF
 
            #單位小數位數
            LET sr1.gfe03=0
            SELECT gfe03 INTO sr1.gfe03 FROM gfe_file WHERE gfe01=sr1.pmn07
            IF cl_null(sr1.gfe03) THEN LET sr1.gfe03=0 END IF
 
            EXECUTE insert_prep1 USING 
               sr.pmm01,sr.pmn04,sr.azi03,sr.azi04,sr1.*,sr.pmn02   #MOD-B90159 add sr.pmn02
             
            INITIALIZE sr1.* TO NULL
         END FOREACH
      END IF
      
      IF tm.d = 'Y' THEN
         DECLARE pmq_cur CURSOR FOR
         SELECT * FROM pmq_file    
          WHERE pmq01=sr.pmn04 AND pmq02=sr.pmm09 
          ORDER BY pmq04                                        
         FOREACH pmq_cur INTO sr2.*                            
           EXECUTE insert_prep6 USING sr2.pmq01,sr2.pmq02,sr2.pmq03,sr2.pmq04,sr2.pmq05,sr.pmm01,sr.pmn02 
         END FOREACH
      END IF 
 
   END FOREACH
 
   #處理單據前、後特別說明
   LET l_sql = "SELECT pmm01 FROM pmm_file ",
               " WHERE ",tm.wc CLIPPED,
               "   ORDER BY pmm01"
   PREPARE r900_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   DECLARE r900_cs2 CURSOR FOR r900_prepare2
 
   FOREACH r900_cs2 INTO sr.pmm01
      #額外備註-單據前備註 
      DECLARE pmo_cur CURSOR FOR
         SELECT pmo06 FROM pmo_file
          WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='0'
          ORDER BY pmo05 #MOD-BC0184 add
      FOREACH pmo_cur INTO l_pmo06
         EXECUTE insert_prep2 USING sr.pmm01,l_pmo06   #No.TQC-740276    #FUN-770064 mod
      END FOREACH
     
      #額外備註-單據後備註 
      DECLARE pmo_cur4 CURSOR FOR
       SELECT pmo06 FROM pmo_file
        WHERE pmo01=sr.pmm01 AND pmo03=0 AND pmo04='1'
        ORDER BY pmo05 #MOD-BC0184 add
      FOREACH pmo_cur4 INTO l_pmo06
         EXECUTE insert_prep5 USING sr.pmm01,l_pmo06   #No.TQC-740276    #FUN-770064 mod
      END FOREACH
   END FOREACH
 
  #修改成新的子報表的寫法(可組一句主要SQL,五句子報表SQL)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED                              #FUN-860075
 
   LET l_wc = ""   #FUN-770064 add
   IF g_zz05 = 'Y' THEN   #是否列印列印條件
      CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm12')
           RETURNING l_wc
   END IF
   LET g_str =l_wc,";",tm.c                #FUN-740224 add tm.c
                  ,";",g_zo.zo041,";",g_zo.zo05,";",g_zo.zo09,";",tm.d   #FUN-810029 add   #FUN-860075 Add tm.d
                  ,";",tm.a,";",tm.b     #MOD-870254
#TQC-C10039--MOD--STR
   #FUN-940043  START
   LET g_cr_table = l_table
#  LET g_cr_gcx01 = "asmi300"
   LET g_cr_apr_key_f = "pmm01"

#  LET l_ii = 1

#  CALL g_cr_apr_key.clear()  

#  FOREACH r900_cs4 INTO l_key.* 
#    LET g_cr_apr_key[l_ii].v1 = l_key.v1
#    LET l_ii = l_ii + 1 
#  END FOREACH

   #FUN-940043  END
#TQC-C10039--MOD--END   
   CALL cl_prt_cs3('apmr900','apmr900',g_sql,g_str)
 
   LET l_sql = "SELECT DISTINCT pmm01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE r900_p3 FROM l_sql
   DECLARE r900_c3 CURSOR FOR r900_p3
   FOREACH r900_c3 INTO l_pmm01
      UPDATE pmm_file SET pmmprno = pmmprno + 1
                    WHERE pmm01 = l_pmm01
      IF sqlca.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pmm_file",l_pmm01,'',STATUS,"","upd pmmprno",1)
      END IF
   END FOREACH
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
