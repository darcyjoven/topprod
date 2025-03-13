# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr201.4gl
# Descriptions...: 供應商名條列印
# Date & Author..: 91/10/16 By MAY
# Modify.........: 99/12/23 By Kammy 原程式當列印選項選 2.發票地址,3.寄票地址時
#                                    抓的資料會參考pme_file，是錯的。
# Modify.........: No.FUN-550091 05/05/25 By Smapmin 加印地區
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-710091 07/02/18 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改out內有'(+)'的語法
# Modify.........: No.TQC-790077 07/09/19 By Carrier pmd05前加上table_name
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A40059 10/05/25 By Summer 增加QBE欄位可開窗、報表在地址前面多印郵遞區號
# Modify.........: No:TQC-C10039 12/01/12 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
# Modify.........: No.TQC-C20067 12/02/10 By zhuhao CR报表列印TIPTOP与EasyFlow签核图片還原
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
       		wc  	LIKE type_file.chr1000, # Where condition            #No.FUN-680136 VARCHAR(500)
    	       	b    	LIKE type_file.chr1,    # print gkf_file detail(Y/N) #No.FUN-680136 VARCHAR(1)
                c       LIKE type_file.chr1000,                              #No.FUN-680136 VARCHAR(500)                
                d       LIKE type_file.chr1,    # print gkf_file detail(Y/N) #No.FUN-680136 VARCHAR(1)
                e       LIKE type_file.chr10,   # print gkf_file detail(Y/N) #No.FUN-680136 VARCHAR(10) #No.TQC-6A0079
                more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-680136 VARCHAR(1)
              END RECORD,
         #g_name        like zx_file.zx02,      #TQC-C10039    #TQC-C20067--mark
          l_rec         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          i             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          j             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          b             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          a             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_string      LIKE zaa_file.zaa08,    #No.FUN-680136 VARCHAR(6)
          g_count       LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_str          LIKE type_file.chr1000  #No.FUN-710091
# DEFINE   g_sql        STRING    #TQC-C10039  #TQC-C20067--mark
# DEFINE   l_table      STRING    #TQC-C10039  #TQC-C20067--mark

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b  = ARG_VAL(8)
   LET tm.c  = ARG_VAL(9)
   LET tm.d  = ARG_VAL(10)
   LET tm.e  = ARG_VAL(11)
#-------------No.TQC-610085 modify
  #LET tm.more= ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#TQC-C20067--mark--begin
#TQC-C10039-ADD--STR
#  LET g_sql= "pmc01.pmc_file.pmc01,pmc02.pmc_file.pmc02,",
#             "pmc06.pmc_file.pmc06,pmc07.pmc_file.pmc07,",
#             "pmc904.pmc_file.pmc904,pmc908.pmc_file.pmc908,",
#             "pmc15.pmc_file.pmc15,pmc16.pmc_file.pmc16,",
#             "pmd02.pmd_file.pmd02,pmd06.pmd_file.pmd06,",
#             "pmc081.pmc_file.pmc081,pmc082.pmc_file.pmc082,",
#             "pmc52.pmc_file.pmc52,pmc53.pmc_file.pmc53,",
#             "pmc091.pmc_file.pmc091,pmc092.pmc_file.pmc092,",
#             "pmc093.pmc_file.pmc093,pmc094.pmc_file.pmc094,",
#             "pmc095.pmc_file.pmc095,",
#             "sign_type.type_file.chr1,",     
#             "sign_img.type_file.blob ,",      
#             "sign_show.type_file.chr1,",      
#             "sign_str.type_file.chr1000" 
#  LET l_table = cl_prt_temptable('apmr201',g_sql) CLIPPED
#  IF l_table = -1 THEN EXIT PROGRAM END IF
#  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  
#  PREPARE insert_prep FROM g_sql
#  IF STATUS THEN 
#     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#  END IF
#TQC-C10039-ADD--END   
#TQC-C20067--mark--end
#-------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL apmr201_tm(0,0)		# Input print condition
      ELSE CALL apmr201()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmr201_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01         #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,        #No.FUN-680136 SMALLINT
          l_direct      LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(01)
          l_cmd		LIKE type_file.chr1000      #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW apmr201_w AT p_row,p_col WITH FORM "apm/42f/apmr201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.b    = '1'
   LET tm.c    = '1'
   LET tm.d    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON pmc01,pmc07,pmd06,pmc02,pmc06,pmc908   #FUN-550091
   CONSTRUCT BY NAME tm.wc ON pmc01,pmc02,pmc908,pmc07,pmc06,pmd06   #FUN-550091
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
     #CHI-A40059 add --start--
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(pmc01) #供應廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_pmc"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmc01
              NEXT FIELD pmc01
           WHEN INFIELD(pmc908) #查詢地區檔
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_geo"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmc908
              NEXT FIELD pmc908
           WHEN INFIELD(pmc06) #查詢區域檔
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_gea"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmc06
              NEXT FIELD pmc06
           WHEN INFIELD(pmc02) #供應商類別
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_pmy"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmc02
              NEXT FIELD pmc02
           WHEN INFIELD(pmc07) #查詢國別檔
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_geb"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmc07
              NEXT FIELD pmc07
           WHEN INFIELD(pmd06) #查詢區域檔
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form = "q_pmd06"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmd06
              NEXT FIELD pmd06
           OTHERWISE EXIT CASE
        END CASE
     #CHI-A40059 add --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr201_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.b,tm.c,tm.d,tm.more # Condition
   INPUT BY NAME tm.b,tm.c,tm.d,tm.e,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[123]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
      AFTER FIELD c
         IF tm.c NOT MATCHES "[123]" OR cl_null(tm.c)
            THEN NEXT FIELD c
         END IF
 
      AFTER FIELD d
         IF tm.d NOT MATCHES "[1234]" OR tm.d IS NULL
            THEN NEXT FIELD d
         END IF
         IF tm.d != '4' THEN
            LET tm.e = ' '
            DISPLAY BY NAME tm.e
         END IF
         LET l_direct = 'D'
 
      BEFORE FIELD e
         IF tm.d != '4' THEN
            IF l_direct = 'D' THEN
                 NEXT FIELD more
            ELSE NEXT FIELD d
            END IF
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
         LET l_direct = 'U'
 
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
      LET INT_FLAG = 0 CLOSE WINDOW apmr201_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr201'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr201','9031',1)
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
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'"  ,        #No.TQC-610085 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr201',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW apmr201_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr201()
   ERROR ""
END WHILE
   CLOSE WINDOW apmr201_w
END FUNCTION
 
FUNCTION apmr201()
#  DEFINE  l_img_blob     LIKE type_file.blob   #TQC-C10039  #TQC-C20067--mark
   DEFINE l_name	LIKE type_file.chr20,       # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	    # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	    # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE za_file.za05,          #No.FUN-680136 VARCHAR(40)
          l_rec         LIKE type_file.num5,        #No.FUN-680136 SMALLINT
          sr               RECORD
                                  pmc01    LIKE pmc_file.pmc01,    # 供應廠商編號
                                  pmc02    LIKE pmc_file.pmc02,    # 供應廠商分類
                                  pmc06    LIKE pmc_file.pmc06,    # 區域代碼
                                  pmc07    LIKE pmc_file.pmc07,	   # 國別代碼
                                  pmc904   LIKE pmc_file.pmc904,   # 郵遞區號   #CHI-A40059 add 
                                  pmc908   LIKE pmc_file.pmc908,   # 地區代碼   #FUN-550091
                                  pmc15    LIKE pmc_file.pmc15,    # 送貨地址
                                  pmc16    LIKE pmc_file.pmc16,    # 帳單地址
                                  pmd02    LIKE pmd_file.pmd02,    # 聯絡人
                                  pmd06    LIKE pmd_file.pmd06,    # 聯絡人
                                  pmc081   LIKE pmc_file.pmc081,   # 全名1
                                  pmc082   LIKE pmc_file.pmc082,   # 全名2
                                  pmc52    LIKE pmc_file.pmc52,    # 發票地址
                                  pmc53    LIKE pmc_file.pmc53,    # 寄票地址
                                  l_pmc091 LIKE aaf_file.aaf03,    #No.FUN-680136 VARCHAR(40)
                                  l_pmc092 LIKE aaf_file.aaf03,    #No.FUN-680136 VARCHAR(40)
                                  l_pmc093 LIKE aaf_file.aaf03,    #No.FUN-680136 VARCHAR(40)
                                  l_pmc094 LIKE aaf_file.aaf03,    #No.FUN-680136 VARCHAR(40)
                                  l_pmc095 LIKE aaf_file.aaf03     #No.FUN-680136 VARCHAR(40)
                        END RECORD
   # LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039  #TQC-C20067--mark
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   # CALL cl_del_data(l_table)  #TQC-C10039   #TQC-C20067--mark
    
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmr201'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR

    #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmcgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmcuser', 'pmcgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT  ",
                 #"   pmc01,  pmc02,  pmc06,  pmc07,  pmc15,  pmc16 ,",   #FUN-550091
                 "   pmc01,  pmc02,  pmc06,  pmc07, pmc904, pmc908,pmc15,  pmc16 ,",   #FUN-550091  #CHI-A40059 add pmc904
                 "   pmd02,  pmd06,  pmc081, pmc082, pmc52,  pmc53,",
                 "   pmc091,pmc092,",
                 "   pmc093, pmc094, pmc095  ",
#                " FROM pmc_file LEFT OUTER JOIN pmd_file ON pmc01 = pmd01",                       #TQC-780054
                 " FROM pmc_file LEFT OUTER JOIN pmd_file ON pmc01 = pmd01",                 #TQC-780054
#                " WHERE pmc01 = pmd01(+) AND pmd05 = 'Y' " ,      #TQC-780054
                 " WHERE pmd05 = 'Y' " ,#TQC-780054  #No.TQC-790077
                 "  AND  NOT (pmc091 IS  NULL",
                 "  AND  pmc092 IS  NULL",
                 "  AND  pmc093 IS  NULL",
                 "  AND  pmc094 IS  NULL",
                 "  AND  pmc095 IS  NULL)",
                 " AND ",tm.wc
#TQC-C20067--mark--begin
##TQC-C10039--ADD-STR
#   PREPARE apmr201_prepare1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare1:',SQLCA.sqlcode,1)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time  
#       EXIT PROGRAM
#    END IF
#    DECLARE apmr201_curs1 CURSOR FOR apmr201_prepare1
#
#    SELECT zx02 INTO g_name FROM zx_file WHERE zx01=g_user
#    LET g_pageno = 0
#    FOREACH apmr201_curs1 INTO sr.*
#      IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
#      EXECUTE insert_prep USING sr.*,"",l_img_blob, "N","" 
#    END FOREACH

#    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
#    CALL cl_wcchp(tm.wc,'pmc01,pmc02,pmc06') RETURNING tm.wc
#    LET g_str = tm.wc,";",g_zz05
#    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
#    LET g_cr_table = l_table                 #主報表的temp table名稱 
#    LET g_cr_apr_key_f = "pmc01"       #報表主鍵欄位名稱 
#    CASE
#    WHEN tm.c='1' 
#         CALL cl_prt_cs3('apmr201','apmr201_1',l_sql,g_str)   #FUN-710080 modify
#    WHEN tm.c='2'
#         CALL cl_prt_cs3('apmr201','apmr201_2',l_sql,g_str)   #FUN-710080 modify
#   WHEN tm.c='3'
#         CALL cl_prt_cs3('apmr201','apmr201_3',l_sql,g_str)   #FUN-710080 modify
#   END CASE
##TQC-C10039--ADD--END 
#TQC-C20067--mark--end
#TQC-C20067--add--begin
#No.FUN-710091  --begin
      LET g_str = ''
      LET g_str = tm.b,';',tm.d
      IF tm.d='4' THEN
         LET g_str = g_str,';',tm.e
      END IF
      CASE
        WHEN tm.c='1'
         #   CALL cl_prt_cs1('apmr201_1',l_sql,g_str)  #TQC-730088
             CALL cl_prt_cs1('apmr201','apmr201_1',l_sql,g_str)
        WHEN tm.c='2'
         #   CALL cl_prt_cs1('apmr201_2',l_sql,g_str)  #TQC-730088
             CALL cl_prt_cs1('apmr201','apmr201_2',l_sql,g_str)
       WHEN tm.c='3'
         #   CALL cl_prt_cs1('apmr201_3',l_sql,g_str)  #TQC-730088
             CALL cl_prt_cs1('apmr201','apmr201_3',l_sql,g_str)
      END CASE
#No.FUN-710091  --end
#TQC-C20067--add--end
#TQC-C10039--mark--str 
#No.FUN-710091  --begin
#     LET g_str = ''
#     LET g_str = tm.b,';',tm.d
#     IF tm.d='4' THEN
#        LET g_str = g_str,';',tm.e
#     END IF
#     CASE
#       WHEN tm.c='1'
#        #   CALL cl_prt_cs1('apmr201_1',l_sql,g_str)  #TQC-730088
#            CALL cl_prt_cs1('apmr201','apmr201_1',l_sql,g_str) 
#       WHEN tm.c='2'
#        #   CALL cl_prt_cs1('apmr201_2',l_sql,g_str)  #TQC-730088
#            CALL cl_prt_cs1('apmr201','apmr201_2',l_sql,g_str) 
#      WHEN tm.c='3'
#        #   CALL cl_prt_cs1('apmr201_3',l_sql,g_str)  #TQC-730088
#            CALL cl_prt_cs1('apmr201','apmr201_3',l_sql,g_str) 
#     END CASE
#No.FUN-710091  --end  
#TQC-C10039--mark--end 
#No.FUN-710091  --begin
#    LET l_rec = 0
#    LET i     = 0
#    LET j     = 0
#    PREPARE apmr201_prepare1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
#       EXIT PROGRAM
#          
#    END IF
#     DECLARE apmr201_curs1 CURSOR FOR apmr201_prepare1
#     #LET l_name = 'apmr201.out'
#    #CALL cl_outnam('apmr201') RETURNING l_name  #No.FUN-710091
#    #START REPORT apmr201_rep TO l_name  #No.FUN-710091 
#     LET g_cnt = 0
#     FOREACH apmr201_curs1 INTO sr.*
#       IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
#       END IF
#       LET g_cnt = g_cnt + 1
#     # OUTPUT TO REPORT apmr201_rep(sr.*)  #No.FUN-710091 
#     END FOREACH
#
#     FINISH REPORT apmr201_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 END FUNCTION
#
#REPORT apmr201_rep(sr)
#   DEFINE
#          l_no             LIKE type_file.num5,                 #No.FUN-680136 SMALLINT
#          sr               RECORD
#                                  pmc01 LIKE pmc_file.pmc01,	# 供應廠商編號
#                                  pmc02 LIKE pmc_file.pmc02, 	# 供應廠商分類
#                                  pmc06 LIKE pmc_file.pmc06, 	# 區域代碼
#                                  pmc07 LIKE pmc_file.pmc07,	# 國別代碼
#                                  pmc908 LIKE pmc_file.pmc908,	# 地區代碼
#                                  pmc15 LIKE pmc_file.pmc15,    # 送貨地址
#                                  pmc16 LIKE pmc_file.pmc16,    # 帳單地址
#                                  pmd02 LIKE pmd_file.pmd02,    # 聯絡人
#                                  pmd06 LIKE pmd_file.pmd06,    # 聯絡人
#                                  pmc081 LIKE pmc_file.pmc081,  # 全名1
#                                  pmc082 LIKE pmc_file.pmc082,  # 全名2
#                                  pmc52  LIKE pmc_file.pmc52,  # 發票地址
#                                  pmc53  LIKE pmc_file.pmc53,  # 寄票地址
#                                  l_pmc091 LIKE pmc_file.pmc091, #No.FUN-680136 VARCHAR(40)
#                                  l_pmc092 LIKE pmc_file.pmc092, #No.FUN-680136 VARCHAR(40)
#                                  l_pmc093 LIKE pmc_file.pmc093, #No.FUN-680136 VARCHAR(40)
#                                  l_pmc094 LIKE pmc_file.pmc094, #No.FUN-680136 VARCHAR(40)
#                                  l_pmc095 LIKE pmc_file.pmc095  #No.FUN-680136 VARCHAR(40)
#                        END RECORD,
#          tmp           ARRAY[66,3] OF LIKE pmc_file.pmc091     #No.FUN-680136 VARCHAR(40)
#  OUTPUT TOP MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 0 PAGE LENGTH g_page_line
#  ORDER BY sr.pmc01
#FORMAT
#ON EVERY ROW
## 所輸入每個LABEL的長度
#         IF j = 0 THEN
#            FOR a = 1 TO tm.a
#               LET tmp[a,1]=NULL LET tmp[a,2]=NULL LET tmp[a,3]=NULL
#            END FOR
#         END IF
#         LET i = 1 LET j = j + 1
##將資料丟入陣列，並判斷若地址或全名有任何一行為NULL時,則不列印
#         CASE tm.b
#         WHEN '1'
#              IF sr.l_pmc091 IS NOT NULL THEN
#                  LET tmp[i,j] = sr.l_pmc091
#                  LET i = i + 1
#              END IF
#              IF sr.l_pmc092 IS NOT NULL THEN
#                  LET tmp[i,j]= sr.l_pmc092
#                  LET i = i + 1
#              END IF
#              IF sr.l_pmc093 IS NOT NULL THEN
#                  LET tmp[i,j]= sr.l_pmc093
#                  LET i = i + 1
#              END IF
#              IF sr.l_pmc094 IS NOT NULL THEN
#                  LET tmp[i,j]= sr.l_pmc094
#                  LET i = i + 1
#              END IF
#              IF sr.l_pmc095 IS NOT NULL THEN
#                  LET tmp[i,j]= sr.l_pmc095
#                  LET i = i + 1
#              END IF
#         WHEN '2'
#              IF sr.pmc52 IS NOT NULL THEN
#                  LET tmp[i,j] = sr.pmc52
#                  LET i = i + 1
#              END IF
#         WHEN '3'
#              IF sr.pmc53 IS NOT NULL THEN
#                  LET tmp[i,j] = sr.pmc53
#                  LET i = i + 1
#              END IF
#         END CASE
#         LET tmp[i,j] = ' '
#         LET i = i + 1
##判斷若全名有任何一行為NULL時,則不列印
#         IF sr.pmc081 IS NOT NULL THEN
#             LET tmp[i,j]= sr.pmc081
#             LET i = i + 1
#         END IF
#         IF sr.pmc082 IS NOT NULL THEN
#             LET tmp[i,j]= sr.pmc082
#             LET i = i + 1
#         END IF
#         LET tmp[i,j] = ' '
#         LET i = i + 1
##判斷所選擇敬啟語並附加入陣列
#         IF tm.d = 1 THEN
#            LET l_string = g_x[1] CLIPPED
#         END IF
#         IF tm.d = 2 THEN
#            LET l_string = g_x[2] CLIPPED
#         END IF
#         IF tm.d = 3  THEN
#            LET l_string = g_x[3] CLIPPED
#         END IF
#         IF tm.d = 4  THEN
#            LET l_string = tm.e CLIPPED
#         END IF
#         LET tmp[i,j] =sr.pmd02,l_string
#
## 當所選擇所需綜列列數為1
#         IF tm.c= 1 THEN
#            FOR a = 1 TO tm.a PRINT tmp[a,j] END FOR
#            LET j = 0
#         END IF
## 當所選擇所需綜列列數為2
#         IF tm.c= '2' AND j = 2 THEN
#            FOR a = 1 TO tm.a PRINT tmp[a,1];PRINT COLUMN 30,tmp[a,2] END FOR
#            LET j = 0
#         END IF
## 當所選擇所需綜列列數為3
#         IF tm.c= '3' AND j = 3 THEN
#            FOR a = 1 TO tm.a PRINT tmp[a,1];PRINT COLUMN 30,tmp[a,2];PRINT COLUMN 60,tmp[a,3] END FOR
#            LET j = 0
#         END IF
#
#   ON LAST ROW
##當陣列中還有尚未列印的資料時
##若綜列列數是貳時，所可能剩餘的只能一筆
#       IF tm.c = '2' AND (j < 2 AND j<> 0 ) THEN
#          FOR a = 1 TO tm.a PRINT tmp[a,j] END FOR
#       END IF
##若綜列列數是三時，所可能剩餘的只能一筆或兩筆
#       IF tm.c = '3' AND j < 3 THEN
#          FOR a = 1 TO tm.a PRINT tmp[a,1],tmp[a,2] END FOR
#       END IF
##FUN-550091
#AFTER GROUP OF sr.pmc01
#      SKIP TO TOP OF PAGE
##END FUN-550091
#END REPORT
#No.FUN-710091  --end 
#Patch....NO.TQC-610036 <001> #
