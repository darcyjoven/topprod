# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr210.4gl
# Descriptions...: 料件詢價歷史資料表
# Date & Author..: 91/09/17 By Lin
#         備忘錄.: 此程式有使用[料件成本要素資料檔](imb_file),日後
#                  此檔案架構若有修改,請記得更新之。
# Modify.........: No.FUN-4C0095 04/12/29 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 報表結束定位點修改
# Modify.........: No.TQC-5B0105 05/11/11 By Mandy 報表的單號/料號/品名/規各對齊調整
# Modify.........: No.FUN-650191 06/08/14 By rainy pmw03改抓pmx12
# Modify.........: No.FUN-680136 06/09/15 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-720010 07/02/07 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數,增加數字取位的處理
# Modify.........: No.FUN-740072 07/04/17 By Nicole 漏抓標準成本,現時成本及預設成本
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8B0018 08/12/08 By xiaofeizhu 新增選項"價格型態(1.一般，2.委外)"
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.TQC-B40060 11/04/11 By lilingyu sql變量長度定義過短
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	#	wc   VARCHAR(500),		# Where condition
		wc  	STRING,		#TQC-630166  # Where condition
                vdate   LIKE type_file.dat,     #No.FUN-680136 DATE  # 有效期間
                type    LIKE type_file.chr2,    #No.CHI-8B0018
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) # Input more condition(Y/N)
              END RECORD
 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE l_table     STRING                        ### FUN-720010 add ###
DEFINE g_sql       STRING                        ### FUN-720010 add ###
DEFINE g_str       STRING                        ### FUN-720010 add ###
DEFINE g_sma115    LIKE sma_file.sma115          ### FUN-720010 add ###
 
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
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720010 *** ##
   LET g_sql=
	"pmx08.pmx_file.pmx08," , 
	"ima02.ima_file.ima02,"  ,
	"ima021.ima_file.ima021," ,
	"ima05.ima_file.ima05,"  ,
	"ima08.ima_file.ima08,"  ,
	"ima37.ima_file.ima37,"  ,
	"ima25.ima_file.ima25,"  ,
	"pmx12.pmx_file.pmx12,"  ,
	"pmc03.pmc_file.pmc03,"  ,
	"pmh03.pmh_file.pmh03,"  ,
	"g_s_cost.oeb_file.oeb13,",
	"g_c_cost.oeb_file.oeb13,",
	"g_p_cost.oeb_file.oeb13,",
	"pmw06.pmw_file.pmw06,"   ,
	"pmw01.pmw_file.pmw01,"   ,
	"pmw04.pmw_file.pmw04,"   ,
	"pmx09.pmx_file.pmx09,"   ,
	"pmx02.pmx_file.pmx02,"   ,
	"pmx03.pmx_file.pmx03,"   ,
	"pmx06.pmx_file.pmx06,"   ,
	"pmx07.pmx_file.pmx07, "  ,
	"pmx04.pmx_file.pmx04, "  ,
	"pmx05.pmx_file.pmx05, " ,
	"switch.type_file.chr1, ",
	"pmx10.pmx_file.pmx10 "       #CHI-8B0018  
 LET l_table = cl_prt_temptable('apmr210',g_sql) CLIPPED   # 產生Temp Table
 IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
# LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,    # TQC-780054
 LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?,?,?,?, ?,?,?,?,?)"               #CHI-8B0018 Add ?
 PREPARE insert_prep FROM g_sql
 IF STATUS THEN
    CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
 END IF
 #------------------------------ CR (1) ------------------------------#
 
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.vdate = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(13)     #No.CHI-8B0018
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r210_tm(0,0)	         	# Input print condition
      ELSE CALL r210()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r210_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 18
 
   OPEN WINDOW r210_w AT p_row,p_col WITH FORM "apm/42f/apmr210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			       # Default condition
   LET tm.more = 'N'
   LET tm.vdate= g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type = '1'                   #CHI-8B0018
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmx08,pmx12 #NO:7178  #FUN-650191 pmw03->pmx12
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#No.FUN-570243 --start
      ON ACTION CONTROLP
            IF INFIELD(pmx08) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmx08
               NEXT FIELD pmx08
            END IF
#No.FUN-570243 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.vdate,tm.type,tm.more 		# Condition                     #CHI-8B0018 Add tm.type
   INPUT BY NAME tm.vdate,tm.type,tm.more WITHOUT DEFAULTS                      #CHI-8B0018 Add tm.type 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         
      #CHI-8B0018--Begin--#   
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[12]' THEN
            NEXT FIELD type
         END IF
      #CHI-8B0018--End--#         
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
#     ON ACTION CONTROLP CALL r210_wc()       # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr210','9031',1)
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
                         " '",tm.vdate CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.type CLIPPED,"'"               #No.CHI-8B0018
         CALL cl_cmdat('apmr210',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r210()
   ERROR ""
END WHILE
   CLOSE WINDOW r210_w
END FUNCTION
 
FUNCTION r210()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job  #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680136 VARCHAR(2000)  #TQC-B40060
#         l_sql2	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680136 VARCHAR(2000)  #TQC-B40060
          l_sql 	STRING,                                  #TQC-B40060
          l_sql2	STRING,                                  #TQC-B40060
          l_chr		LIKE type_file.chr1,            #No.FUN-680136 VARCHAR(1)
          l_za05	LIKE za_file.za05,              #No.FUN-680136 VARCHAR(40)
          l_order	ARRAY[3] OF LIKE type_file.chr20   #No.FUN-680136 VARCHAR(20)
   DEFINE l_pmx10	LIKE pmx_file.pmx10       #CHI-8B0018
   DEFINE l_pmx11	LIKE pmx_file.pmx11,      #CHI-8C0017          
          sr               RECORD
                                  pmx08    LIKE pmx_file.pmx08,	#料件編號  NO:7178
                                  ima02    LIKE ima_file.ima02,	#品名
                                  ima021   LIKE ima_file.ima021,	#規格  #FUN-4C0095
                                  ima05    LIKE ima_file.ima05,	#目前使用版本
                                  ima08    LIKE ima_file.ima08,	#來源碼
                                  ima37    LIKE ima_file.ima37,	#補貨策略碼
                                  ima25    LIKE ima_file.ima25,	#庫存單位
                                  pmx12    LIKE pmx_file.pmx12,   #供應廠商編號         #FUN-650191
                                  pmc03    LIKE pmc_file.pmc03,   #簡稱
                                  pmh03    LIKE pmh_file.pmh03,   #主要供應商 NO:7178
                                  g_s_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #計算標準成本
                                  g_c_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #計算現時成本
                                  g_p_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #計算預設成本
                                  pmw06    LIKE pmw_file.pmw06,    #單據日期
                                  pmw01    LIKE pmw_file.pmw01,    #單據號碼
                                  pmw04    LIKE pmw_file.pmw04,    #幣別
                                  pmx09    LIKE pmx_file.pmx09,    #詢價單位
                                  pmx02    LIKE pmx_file.pmx02,    #序號
                                  pmx03    LIKE pmx_file.pmx03,    #上限數量
                                  pmx06    LIKE pmx_file.pmx06,    #採購價格
                                  pmx07    LIKE pmx_file.pmx07,    #折扣率
                                  pmx04    LIKE pmx_file.pmx04,    #生效日
                                  pmx05    LIKE pmx_file.pmx05,    #失效日
                                  switch   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)        #作為主要供應商之排序
                        END RECORD
 
 ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720010 *** ##
 CALL cl_del_data(l_table)
 #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmwuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmwgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmwgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmwuser', 'pmwgrup')
     #End:FUN-980030
 
     #NO:7178 串pmh_file改為OUTER ,改至FOREACH時再取值
     LET l_sql = "SELECT ",	   #組SQL條件,符合條件之料件編號及廠商
                 " pmx08,ima02,ima021,ima05,ima08,ima37,ima25,", #FUN-4C0095 add ima021
                 " pmx12,pmc03,''   ,'','','', ",  #FUN-650191 pmw03->pmx12
                 " pmw06,pmw01,pmw04,",           # 取料件之詢價資料
                 " pmx09,pmx02,pmx03,",
                 " pmx06,pmx07,pmx04,pmx05,' ',pmx10  ",                        #CHI-8B0018 Add pmx10
                 "  FROM pmw_file,pmx_file,ima_file,pmc_file ",
                 " WHERE pmw01=pmx01 ",
                 "   AND ",tm.wc CLIPPED,
                 "   AND pmwacti = 'Y' ",
                 "   AND pmx08 = ima01 ",
#                "   AND pmx10 = ' ' ",                                #CHI-860042     #CHI-8B0018 Mark                                                  
#                "   AND pmx11 = '1' ",                                #CHI-860042     #CHI-8B0018 Mark
                 "   AND pmc01 = pmx12 ",  #FUN-650191 pmw03->pmx12
                 "   AND pmcacti = 'Y' ",
                 "   AND imaacti = 'Y' "
      #組SQL,符合有效期間之資料
       IF tm.vdate IS NOT NULL THEN
             LET l_sql =l_sql  CLIPPED,
                  "   AND (pmx04 <='",tm.vdate,"' OR pmx04 IS NULL) ",
                  "   AND ('",tm.vdate ,"' < pmx05 OR pmx05 IS NULL) "
       END IF
      #CHI-8B0018--Begin--#
       IF tm.type = '1' THEN
             LET l_pmx11 = '1'                              #CHI-8C0017
             LET l_sql =l_sql  CLIPPED,
                  "   AND pmx11 = '1' "
       ELSE
             LET l_pmx11 = '2'                              #CHI-8C0017
             LET l_sql =l_sql  CLIPPED,
                  "   AND pmx11 = '2' "                  
       END IF      
      #CHI-8B0018--End--#       
       LET l_sql =l_sql  CLIPPED,      #以詢價日期及詢價單號排序
                  " ORDER BY pmx08,pmx12,pmw06,pmw01 "  #FUN-650191 pmw03->pmx12
     PREPARE r210_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
 
     DECLARE r210_cs1 CURSOR FOR r210_prepare1
 
#     CALL cl_outnam('apmr210') RETURNING l_name
#     START REPORT r210_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r210_cs1 INTO sr.*,l_pmx10                      #CHI-8B0018 Add l_pmx10
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       #若為主要廠商則顯示'主',且排列順序最優先
       #NO:7178
       SELECT pmh03 INTO sr.pmh03
         FROM pmh_file
        WHERE pmh01 = sr.pmx08
          AND pmh02 = sr.pmx12   #FUN-650191 pmw03->pmx12
          AND pmh13 = sr.pmw04
#         AND pmh21 = " "                                             #CHI-860042     #CHI-8C0017 Mark
#         AND pmh22 = '1'                                             #CHI-860042     #CHI-8C0017 Mark
          AND pmh21 = l_pmx10                                                         #CHI-8C0017 
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmh22 = l_pmx11                                                         #CHI-8C0017
          AND pmhacti = 'Y'                                           #CHI-910021          
       IF sr.pmh03='Y' THEN LET sr.switch='1'
                            LET sr.pmh03=g_x[24] CLIPPED
                       ELSE LET sr.switch='2'
                            LET sr.pmh03=' '
       END IF
       #str FUN-740072 add
       #計算標準成本,現時成本及預設成本
       CALL r210_ima01(sr.pmx08,sr.ima08) RETURNING sr.g_s_cost,sr.g_c_cost,
                                                    sr.g_p_cost
       #end FUN-740072 add
       EXECUTE insert_prep USING sr.*,l_pmx10               #CHI-8B0018 Add l_pmx10 
 
       IF STATUS THEN
          CALL cl_err('insert_prep:',status,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
          EXIT PROGRAM
       END IF
   #------------------------------ CR (3) ------------------------------#
 
   #        OUTPUT TO REPORT r210_rep(sr.*)
     END FOREACH
 
 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720010 **** ##
 LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
 #是否列印選擇條件
 IF g_zz05 = 'Y' THEN
    CALL cl_wcchp(tm.wc,'pmx08,pmx02')
         RETURNING tm.wc
 ELSE
    LET tm.wc = ''
 END IF
 LET g_str = tm.wc
 LET g_str = g_str,";",tm.vdate,";",g_azi03,";",t_azi03               #FUN-710080 add
 IF tm.type = '1' THEN                                                #CHI-8B0018
    LET l_name = 'apmr210'                                            #CHI-8B0018
 ELSE                                                                 #CHI-8B0018
    LET l_name = 'apmr210_1'                                          #CHI-8B0018
 END IF	                                                              #CHI-8B0018 
#CALL cl_prt_cs3('apmr210','apmr210',l_sql,g_str)  #FUN-710080 modify #CHI-8B0018 Mark
 CALL cl_prt_cs3('apmr210',l_name,l_sql,g_str)                        #CHI-8B0018 
 #------------------------------ CR (4) ------------------------------#
 
  #   FINISH REPORT r210_rep
 
 #    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#計算標準成本,現時成本及預設成本
FUNCTION  r210_ima01(l_imb01,l_ima08)
    DEFINE l_imb01     LIKE imb_file.imb01,
           l_ima08     LIKE ima_file.ima08,
           imb  RECORD LIKE imb_file.*,
           l_s_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #計算標準成本
           l_c_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #計算現時成本
           l_p_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #計算預設成本
           s_cost   LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #本階標準成本
           s_cost2  LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #下階標準成本
           c_cost   LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #本階現時成本
           c_cost2  LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #下階現時成本
           p_cost   LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #本階預設成本
           p_cost2  LIKE oeb_file.oeb13  #No.FUN-680136 DECIMAL(20,6) #FUN-4C0095  #下階預設成本
 
  #料件成本要素資料檔(imb_file) 80/12/20 修改,所有成本都用加的,沒有比率關係
  SELECT  *  INTO imb.*
         FROM imb_file WHERE imb01 = l_imb01
  IF l_ima08 NOT MATCHES '[PUZ]'  THEN   #成本計算方式分為採購料件及非採購料件
     #計算標準成本
     LET s_cost = imb.imb111 + imb.imb112 + imb.imb1131 + imb.imb1132
                      + imb.imb114 + imb.imb115 + imb.imb116 +
                        imb.imb1171 + imb.imb1172 +imb.imb119
     LET s_cost2  = imb.imb121+imb.imb122 + imb.imb1231 + imb.imb1232
                      + imb.imb124 + imb.imb125 +
                        imb.imb126 + imb.imb1271+ imb.imb1272 +imb.imb129
     LET l_s_cost = s_cost + s_cost2
     #計算現時成本
     LET c_cost = imb.imb211 + imb.imb212 + imb.imb2131 + imb.imb2132
                      + imb.imb214 + imb.imb215 + imb.imb216 +
                        imb.imb2171 + imb.imb2172 +imb.imb219
     LET c_cost2  = imb.imb221+imb.imb222 + imb.imb2231 + imb.imb2232
                      + imb.imb224 + imb.imb225 +
                        imb.imb226 + imb.imb2271+ imb.imb2272 +imb.imb229
     LET l_c_cost = c_cost + c_cost2
     #計算預設成本
     LET p_cost = imb.imb311 + imb.imb312 + imb.imb3131 + imb.imb3132
                      + imb.imb314 + imb.imb315 + imb.imb316 +
                        imb.imb3171 + imb.imb3172 +imb.imb319
     LET p_cost2  = imb.imb321+imb.imb322 + imb.imb3231 + imb.imb3232
                      + imb.imb324 + imb.imb325 +
                        imb.imb326 + imb.imb3271+ imb.imb3272 +imb.imb329
     LET l_p_cost = p_cost + p_cost2
 ELSE
    LET l_s_cost=imb.imb118  #計算標準成本(採購料件)
    LET l_c_cost=imb.imb218  #計算現時成本(採購料件)
    LET l_p_cost=imb.imb318  #計算預設成本(採購料件)
 END IF
  RETURN l_s_cost,l_c_cost,l_p_cost
END FUNCTION
 
REPORT r210_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
          #l_pmw03 LIKE pmw_file.pmw03,#NO:7178  #FUN-65191 remark
          l_pmx12 LIKE pmx_file.pmx12,           #FUN-650191
          sr               RECORD
                                  pmx08  LIKE pmx_file.pmx01,	#料件編號 NO:7178
                                  ima02  LIKE ima_file.ima02,	#品名規格
                                  ima021 LIKE ima_file.ima021,	#規格  #FUN-4C0095
                                  ima05  LIKE ima_file.ima05,	#目前使用版本
                                  ima08  LIKE ima_file.ima08,	#來源碼
                                  ima37  LIKE ima_file.ima37,	#補貨策略碼
                                  ima25  LIKE ima_file.ima25,	#庫存單位
                                 #pmw03  LIKE pmw_file.pmw03,   #供應廠商編號 NO:7178 #FUN-650191 remark
                                  pmx12  LIKE pmx_file.pmx12,   #供應廠商編號         #FUN-650191             
                                  pmc03  LIKE pmc_file.pmc03,   #簡稱
                                  pmh03  LIKE pmh_file.pmh03,   #主要供應商 NO:7178
                                  g_s_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6),#FUN-4C0095  #計算標準成本
                                  g_c_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6),#FUN-4C0095  #計算現時成本
                                  g_p_cost LIKE oeb_file.oeb13, #No.FUN-680136 DECIMAL(20,6),#FUN-4C0095  #計算預設成本
                                  pmw06 LIKE pmw_file.pmw06,    #單據日期
                                  pmw01 LIKE pmw_file.pmw01,    #單據號碼
                                  pmw04 LIKE pmw_file.pmw04,    #幣別
                                  pmx09 LIKE pmx_file.pmx09,    #詢價單位
                                  pmx02 LIKE pmx_file.pmx02,    #序號
                                  pmx03 LIKE pmx_file.pmx03,    #上限數量
                                  pmx06 LIKE pmx_file.pmx06,    #採購價格
                                  pmx07 LIKE pmx_file.pmx07,    #折扣率
                                  pmx04 LIKE pmx_file.pmx04,    #生效日
                                  pmx05 LIKE pmx_file.pmx05,    #失效日
                                  switch LIKE type_file.chr1   #No.FUN-680136 VARCHAR(1)        #作為主要供應商之排序
                        END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmx08,sr.switch,sr.pmx12,sr.pmw06,sr.pmw01  #FUN-650191 pmw03->pmx12
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
   #計算標準成本,現時成本及預設成本
       #NO:7178
       CALL r210_ima01(sr.pmx08,sr.ima08) RETURNING sr.g_s_cost,sr.g_c_cost,
                                                        sr.g_p_cost
      PRINT COLUMN  01,g_x[11] CLIPPED,sr.pmx08,
            COLUMN  71,g_x[16] CLIPPED,sr.ima05,                         #TQC-5B0105 &051112
            COLUMN  86,g_x[18] CLIPPED,sr.ima08,                         #TQC-5B0105 &051112
            COLUMN 100,g_x[13] CLIPPED,cl_numfor(sr.g_s_cost,15,g_azi03) #TQC-5B0105 &051112
      PRINT COLUMN  01,g_x[12] CLIPPED,sr.ima02,
            COLUMN  71,g_x[17] CLIPPED,sr.ima37,                         #TQC-5B0105 &051112
            COLUMN  86,g_x[19] CLIPPED,sr.ima25,                         #TQC-5B0105 &051112
            COLUMN 100,g_x[14] CLIPPED,cl_numfor(sr.g_c_cost,15,g_azi03) #TQC-5B0105 &051112
      PRINT COLUMN  01,g_x[20] CLIPPED,sr.ima021,
            COLUMN 100,g_x[15] CLIPPED,cl_numfor(sr.g_p_cost,15,g_azi03) #TQC-5B0105 &051112
      PRINT ' '
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43]
      PRINT g_dash1
      LET l_last_sw = 'n'
   BEFORE GROUP OF sr.pmx08
      IF PAGENO > 1 OR LINENO > 9
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.pmx12               #FUN-650191 pmw03->pmx12
      PRINT COLUMN g_c[31],sr.pmx12,      #FUN-650191 pmw03->pmx12
            COLUMN g_c[32],sr.pmc03,
            COLUMN g_c[33],sr.pmh03;
 
   BEFORE GROUP OF sr.pmw06
      PRINT COLUMN g_c[34],sr.pmw06;
 
   BEFORE GROUP OF sr.pmw01
      PRINT COLUMN g_c[35],sr.pmw01,
            COLUMN g_c[36],sr.pmw04;
 
   ON EVERY ROW
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05   #No.CHI-6A0004
        FROM azi_file WHERE azi01=sr.pmw04
      PRINT COLUMN g_c[37],sr.pmx02 USING "###&",
            COLUMN g_c[38],sr.pmx09,
            COLUMN g_c[39],cl_numfor(sr.pmx03,39,3),
            COLUMN g_c[40],cl_numfor(sr.pmx06,40,t_azi03),   #No.CHI-6A0004
            COLUMN g_c[41],sr.pmx07 USING "#&.&&&%",
            COLUMN g_c[42],sr.pmx04,
            COLUMN g_c[43],sr.pmx05
 
      #LET l_pmw03=sr.pmw03 #NO:7178  #FUN-650191 remark
      LET l_pmx12=sr.pmx12            #FUN-650191   
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash
      CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              #PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[43], g_x[6] CLIPPED  #TQC-5B0037 mark
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-5B0037 add
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610036 <001> #
