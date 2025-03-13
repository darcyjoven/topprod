# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr811.4gl
# Desc/riptions...: 已請未訂一覽表
# Date & Author..: 92/09/21 By Jones
# Modify.........: No.FUN-4C0095 05/01/05 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-580004 05/08/09 By jackie 雙單位報表格式修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.MOD-640372 06/04/11 BY yiting 以廠商做跳頁，但卻沒印出廠商?
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6A0079 06/11/6 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0086 06/11/13 By baogui  規格沒顯示
# Modify.........: NO.MOD-6B0109 06/12/11 BY claire 已結案請購單不需印出
# Modify.........: NO.MOD-720116 07/02/27 BY claire 未訂數量為0不需印出
# Modify.........: No.FUN-750093 07/06/18 By jan 報表改為使用crystal report
# Modify.........: No.FUN-760086 07/07/31 By jan 報表模板名稱修改
# Modify.........: NO.MOD-770045 07/08/24 BY claire 原來以pmn20做為已訂量的計算,現以pml20做為已訂量,可避免請購未結採購已結造成資料誤判的情況
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AC0080 10/12/10 By Smapmin 請購單身已結案的不需印出
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-C30787 12/06/07 By Vampire 將l_pmn20宣告為動態陣列變數
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17     #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5     #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD				# Print condition RECORD
               #wc  	LIKE type_file.chr1000,	# Where condition   #TQC-630166 mark 	#No.FUN-680136 VARCHAR(500) 
         	wc  	STRING,		        # Where condition   #TQC-630166 
                vdate   LIKE type_file.dat,     #No.FUN-680136 DATE
                s       LIKE type_file.chr3,   	#No.FUN-680136 VARCHAR(3)
                t       LIKE type_file.chr3,   	#No.FUN-680136 VARCHAR(3) 
	        more	LIKE type_file.chr1    	# Input more condition(Y/N) 	#No.FUN-680136 VARCHAR(1) 
              END RECORD
   DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680136 INTEGER
   DEFINE g_i           LIKE type_file.num5     #count/index for any purpose    #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end-- 
DEFINE   g_sql           STRING        #No.FUN-750093
DEFINE   g_str           STRING        #No.FUN-750093
DEFINE   l_table         STRING        #No.FUN-750093
 
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
 
 
    IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
       CALL cl_err(g_sma.sma31,'mfg0032',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
       EXIT PROGRAM
    END IF
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.vdate= ARG_VAL(8)
   LET tm.s   = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r811_tm(0,0)		# Input print condition
      ELSE CALL apmr811()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r811_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r811_w AT p_row,p_col WITH FORM "apm/42f/apmr811"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.vdate = g_today
   LET tm.s = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
 
WHILE TRUE
   DISPLAY BY NAME  tm.vdate,tm.s,tm.more  # Condition
   CONSTRUCT BY NAME tm.wc ON pml04,pmk09,pmk04,pml35,pmk12  #No.TQC-640132
#No.FUN-570243 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
            IF INFIELD(pml04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pml04
               NEXT FIELD pml04
            END IF
#No.FUN-570243 --end--
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
      LET INT_FLAG = 0 CLOSE WINDOW r811_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.vdate,tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL  THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
   #  ON ACTION CONTROLP CALL r811_wc()       # Input detail Where Condition
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW r811_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr811'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr811','9031',1)
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
                         " '",tm.vdate CLIPPED,"'",
                         " '",tm.s     CLIPPED,"'",
                         " '",tm.t     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr811',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r811_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr811()
   ERROR ""
END WHILE
   CLOSE WINDOW r811_w
END FUNCTION
 
FUNCTION apmr811()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name               #No.FUN-680136 VARCHAR(20)
          l_name1       LIKE type_file.chr20,           # No.FUN-750093
          l_time	LIKE type_file.chr8,  		# Used time for running the job          #No.FUN-680136 VARCHAR(8)
         #l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       #TQC-630166 mark #No.FUN-680136 VARCHAR(1000) 
          l_sql 	STRING,		                # RDSQL STATEMENT       #TQC-630166
          l_imc04       LIKE type_file.chr10,           # No.FUN-750093
          l_ans         LIKE type_file.chr1,            # No.FUN-750093
          l_str2        LIKE type_file.chr1000,         # No.FUN-750093
          l_order    ARRAY[3] of LIKE ima_file.ima01,   # FUN-5B0105 20->40 	#No.FUN-680136 VARCHAR(40) 
          l_za05	LIKE type_file.chr1000,         # No.FUN-680136 VARCHAR(40)
          #l_pmn20    ARRAY[30] OF LIKE pmn_file.pmn20,  # 訂購量  #MOD-720116 add  #MOD-C30787 mark
          l_pmn20       DYNAMIC ARRAY OF LIKE pmn_file.pmn20,  # 訂購量  #MOD-C30787 add
          i             LIKE type_file.num5,            # No.FUN-680136 SMALLINT
          sr            RECORD
                                  order1 LIKE ima_file.ima01,  # FUN-5B0105 20->40   #No.FUN-680136 VARCHAR(40) 
                                  order2 LIKE ima_file.ima01,  # FUN-5B0105 20->40   #No.FUN-680136 VARCHAR(40) 
                                  order3 LIKE ima_file.ima01,  # FUN-5B0105 20->40   #No.FUN-680136 VARCHAR(40) 
                                  pml01  LIKE pml_file.pml01,  # 請購單號
                                  pml02  LIKE pml_file.pml02,  # 項次
                                  pml04  LIKE pml_file.pml04,  # 料件編號
                                  pml041 LIKE pml_file.pml041, # 品名規格
                                  pmk01  LIKE pmk_file.pmk01,  # 請購單號
                                  pmk04  LIKE pmk_file.pmk04,  # 單據性質
                                  pmk12  LIKE pmk_file.pmk12,
                                  gen02  LIKE gen_file.gen02,
                                  pmk13  LIKE pmk_file.pmk13,
                                  gem02  LIKE gem_file.gem02,
                                  pml33  LIKE pml_file.pml33,  # 交貨日期
                                  pml34  LIKE pml_file.pml34,  # No.TQC-640132
                                  pml35  LIKE pml_file.pml35,  # No.TQC-640132
                                  pml18  LIKE pml_file.pml18,  # No.TQC-640132
                                  pml20  LIKE pml_file.pml20,  # 請購數量
                                  pml07  LIKE pml_file.pml07,  # 請購單位
                                  pmc03  LIKE pmc_file.pmc03,  # 廠商
                                  imc041 LIKE imc_file.imc04,  # 機種
                                  imc042 LIKE imc_file.imc04,  # 規格
                                #  pmk12  LIKE pmk_file.pmk12,  # 採購員
                                  pmk09  LIKE pmk_file.pmk09,  # 廠商編號
                                  pml16  LIKE pml_file.pml16,  # 狀況碼
                                  pmk10  LIKE pmk_file.pmk10,  # 地點
#No.FUN-580004 --start--
                                  pml80  LIKE pml_file.pml80,
                                  pml82  LIKE pml_file.pml82,
                                  pml83  LIKE pml_file.pml83,
                                  pml85  LIKE pml_file.pml85,
                                 #MOD-720116-begin-add
                                  diff   LIKE pml_file.pml21,#已訂數量 
                                  qty    LIKE pml_file.pml21 #未訂數量
                                 #MOD-720116-end-add
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5             #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
#No.FUN-580004 ---end--
     DEFINE l_ima906       LIKE ima_file.ima906       #No.FUN-750093
     DEFINE l_pml85        STRING                     #No.FUN-750093
     DEFINE l_pml82        STRING                     #No.FUN-750093
 
#No.FUN-750093--Begin
     LET g_sql = " pml04.pml_file.pml04,",
                 " pml041.pml_file.pml041,",
                 " imc041.imc_file.imc04,",
                 " pmk01.pmk_file.pmk01,",
                 " pmk04.pmk_file.pmk04,",
                 " pmk12.pmk_file.pmk12,",
                 " gen02.gen_file.gen02,",
                 " pmk13.pmk_file.pmk13,",
                 " gem02.gem_file.gem02,",
                 " pml33.pml_file.pml33,",
                 " pml34.pml_file.pml34,",
                 " pml35.pml_file.pml35,",
                 " pml18.pml_file.pml18,",
                 " pmk09.pmk_file.pmk09,",
                 " pmc03.pmc_file.pmc03,",
                 " pml20.pml_file.pml20,",
                 " diff.pml_file.pml21,",
                 " qty.pml_file.pml21,",
                 " l_str2.type_file.chr1000,",
                 " pml07.pml_file.pml07,",
                 " l_imc04.type_file.chr10,",
                 " l_ans.type_file.chr1,"
                # ," pmk12.pmk_file.pmk12"
 
     LET l_table = cl_prt_temptable('apmr811',g_sql) CLIPPED
     IF l_table = -1 THEN
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#No.FUN-750093--End
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmkuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT '','','',pml01,pml02,pml04,pml041,pmk01,",
                 " pmk04,pmk12,gen02,pmk13,gem02,pml33,pml34,pml35,pml18,pml20,pml07,",  #No.TQC-640132
               #  " pmc03,'','',pmk12,pmk09,pml16,pmk10,pml80,pml82,pml83,",#No.FUN-580004
                 " pmc03,'','',pmk09,pml16,pmk10,pml80,pml82,pml83,",#No.FUN-580004
                 " pml85,'','' ",  #No.FUN-580004  #MOD-720116 modify
                 " FROM pml_file,pmk_file LEFT OUTER JOIN pmc_file ON pmc01 = pmk09 ",
                 "    LEFT OUTER JOIN gen_file ON gen01 = pmk12 ",
                  "   LEFT OUTER JOIN gem_file ON gem01 = pmk13 ",
                 " WHERE pml01 = pmk01 AND pmk18 !='X'",
                 " AND pml35 <= '",tm.vdate,"'",  #No.TQC-640132
                 " AND pmk25 != '6' AND pmk25 != '9'  ",   #MOD-6B0109 add
                 " AND pml16 NOT IN ('6','7','8','9') ",   #MOD-AC0080
                 " AND ",tm.wc
     LET l_sql = l_sql CLIPPED ," ORDER BY pml01"
     PREPARE r811_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r811_curs1 CURSOR FOR r811_prepare1
     LET l_sql = "SELECT pmn20 FROM pmn_file",
                 " WHERE pmn24 = ?",
                 " AND pmn25 = ?",
                 " AND pmn33 <= '",tm.vdate,"'",
                #" AND pmn16 = '2'"                    #MOD-770045 mark
                 " AND pmn16 IN ('2','6','7','8') "    #MOD-770045 
     PREPARE r811_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r811_curs2 CURSOR FOR r811_prepare2
 
#No.FUN-750093--Begin
#    CALL cl_outnam('apmr811') RETURNING l_name
#No.FUN-580004  --start
#    IF g_sma115 = "Y" THEN
#           LET g_zaa[44].zaa06 = "N"
#    ELSE
#           LET g_zaa[44].zaa06 = "Y"
#    END IF
#    CALL cl_prt_pos_len()
#No.FUN-580004 --end--
#    START REPORT r811_rep TO l_name
     IF g_sma115 = "Y" THEN
#           LET l_name1 = 'apmr811b'    #No.FUN-760086
            LET l_name1 = 'apmr811_1'  #No.FUN-760086
     ELSE
#           LET l_name1 = 'apmr811a'    #No.FUN-760086
            LET l_name1 = 'apmr811'  #No.FUN-760086
     END IF
#No.FUN-750093--End
 
     FOREACH r811_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr.pml01 IS NULL THEN LET sr.pml01 = ' ' END IF
 
#No.FUN-750093--Begin
       IF sr.pml35 < g_today THEN                                    
          LET l_ans = 'Y'                                                           
       ELSE                                                                         
          LET l_ans = ' '                                                           
       END IF                                                                       
       SELECT imc04 INTO sr.imc041 FROM imc_file                                    
       WHERE imc01 = sr.pml04 AND imc02 = 'IMA' AND imc03 = 1                       
       IF SQLCA.SQLCODE THEN                                                        
          LET sr.imc041 = ' '                                                      
       END IF
       SELECT imc04 INTO sr.imc042 FROM imc_file                                    
       WHERE imc01 = sr.pml04 AND imc02 = 'IMA' AND imc03 = 3                       
       IF SQLCA.sqlcode THEN                                                        
         LET sr.imc042 = ' '                                                        
      END IF
      LET l_imc04 = sr.imc042[1,10]
#No.FUN-750093--End
 
      #MOD-720116-begin-add
       LET sr.diff=0
       IF sr.pml16 MATCHES '[X01]' THEN   # 若請購單的狀態碼為 X,0,1 時
          LET sr.diff = 0    # 令已訂數量為 0
       ELSE 
          IF sr.pml16 = '2' THEN # 若為 2 :發出時須檢查採購單單身的項次
             LET g_cnt = 1
             FOREACH r811_curs2 USING sr.pml01,sr.pml02 INTO l_pmn20[g_cnt]
                IF SQLCA.sqlcode THEN
                   CALL cl_err('FOREACH',SQLCA.sqlcode,0)
                   EXIT FOREACH
                END IF       
                LET sr.diff = sr.diff + l_pmn20[g_cnt]
                LET g_cnt = g_cnt + 1
             END FOREACH
          END IF
       END IF  
       LET sr.qty = sr.pml20 - sr.diff 
       IF sr.qty = 0 THEN CONTINUE FOREACH END IF 
       #MOD-720116-end-add
 
#No.FUN-750093--Begin
       SELECT ima906 INTO l_ima906 FROM ima_file                                
                         WHERE ima01=sr.pml04                                   
       LET l_str2 = ""                                                          
       IF g_sma115 = "Y" THEN                                                   
         CASE l_ima906                                                          
            WHEN "2"                                                            
                CALL cl_remove_zero(sr.pml85) RETURNING l_pml85                 
                LET l_str2 = l_pml85 , sr.pml83 CLIPPED                         
                IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN                       
                    CALL cl_remove_zero(sr.pml82) RETURNING l_pml82             
                    LET l_str2 = l_pml82, sr.pml80 CLIPPED                      
                ELSE                                                            
                   IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN               
                      CALL cl_remove_zero(sr.pml82) RETURNING l_pml82           
                      LET l_str2 = l_str2 CLIPPED,',',l_pml82, sr.pml80 CLIPPED 
                   END IF                                                       
                END IF                                                          
            WHEN "3"                                                            
                IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN                  
                    CALL cl_remove_zero(sr.pml85) RETURNING l_pml85             
                    LET l_str2 = l_pml85 , sr.pml83 CLIPPED                     
                END IF                                                          
         END CASE
       ELSE
       END IF
#No.FUN-750093--End
 
       #NO.MOD-640372 start--
       SELECT pmc03 INTO sr.pmc03
         FROM pmc_file
        WHERE pmc01 = sr.pmk09
       #NO.MOD-640372 end--
#No.FUN-750093--Begin
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pml04
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmk09
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pmk04 USING 'yyyymmdd'
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pml35 USING 'yyyymmdd'  #No.TQC-640132
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pmk12
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#      OUTPUT TO REPORT r811_rep(sr.*)
 
       EXECUTE insert_prep USING
               sr.pml04,sr.pml041,sr.imc041,sr.pmk01,sr.pmk04,sr.pmk12,sr.gen02,sr.pmk13,sr.gem02,sr.pml33,sr.pml34,
               sr.pml35,sr.pml18,sr.pmk09,sr.pmc03,sr.pml20,sr.diff,sr.qty,l_str2,
               sr.pml07,l_imc04,l_ans
     END FOREACH
 
#    FINISH REPORT r811_rep
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pml04,pmk09,pmk04,pml35,pmk12')
              RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.vdate
     CALL cl_prt_cs3('apmr811',l_name1,l_sql,g_str)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750093--End
END FUNCTION
 
#No.FUN-750093--Begin
{
REPORT r811_rep(sr)
   DEFINE l_str         STRING #FUN-4C0095
   DEFINE l_last_sw	LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1) 
          l_diff,l_qty  LIKE eca_file.eca50,    #No.FUN-680136 DECIMAL(11,2),
          l_pmn20       ARRAY[30] OF LIKE bnf_file.bnf12,  # 訂購量 #No.FUN-680136 DECIMAL(11,3)
          l_imc04       LIKE type_file.chr10, 	#No.FUN-680136 VARCHAR(10) #No.TQC-6A0079
          l_ans         LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
         #l_sql1        LIKE type_file.chr1000, #TQC-630166 mark    #No.FUN-680136 VARCHAR(1000)
          l_sql1        STRING,                 #TQC-630166
          l_za05	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(40)
          sr               RECORD
                                  order1    LIKE ima_file.ima01, #FUN-5B0105 20->40 #No.FUN-680136 VARCHAR(40)
                                  order2    LIKE ima_file.ima01, #FUN-5B0105 20->40 #No.FUN-680136 VARCHAR(40)
                                  order3    LIKE ima_file.ima01, #FUN-5B0105 20->40 #No.FUN-680136 VARCHAR(40)
                                  pml01  LIKE pml_file.pml01,  # 請購單號
                                  pml02  LIKE pml_file.pml02,  # 項次
                                  pml04  LIKE pml_file.pml04,  # 料件編號
                                  pml041 LIKE pml_file.pml041, #品名規格
                                  pmk01  LIKE pmk_file.pmk01,  # 請購單號
                                  pmk04  LIKE pmk_file.pmk04,  # 單據性質
                                  pml33  LIKE pml_file.pml33,  # 交貨日期
                                  pml34  LIKE pml_file.pml34,  #No.TQC-640132
                                  pml35  LIKE pml_file.pml35,  #No.TQC-640132
                                  pml18  LIKE pml_file.pml18,  #No.TQC-640132
                                  pml20  LIKE pml_file.pml20,  # 請購數量
                                  pml07  LIKE pml_file.pml07,  # 請購單位
                                  pmc03  LIKE pmc_file.pmc03,  # 廠商
                                  imc041 LIKE imc_file.imc04,  # 機種
                                  imc042 LIKE imc_file.imc04,  # 規格
                                  pmk12  LIKE pmk_file.pmk12,  # 採購員
                                  pmk09  LIKE pmk_file.pmk09,  # 廠商編號
                                  pml16  LIKE pml_file.pml16,  # 狀況碼
                                  pmk10  LIKE pmk_file.pmk10,  # 地點
#No.FUN-580004 --start--
                                  pml80  LIKE pml_file.pml80,
                                  pml82  LIKE pml_file.pml82,
                                  pml83  LIKE pml_file.pml83,
                                  pml85  LIKE pml_file.pml85,
                                 #MOD-720116-begin-add
                                  diff   LIKE pml_file.pml21,#已訂數量 
                                  qty    LIKE pml_file.pml21 #未訂數量
                                 #MOD-720116-end-add
                           END RECORD
  DEFINE l_ima906       LIKE ima_file.ima906
 #DEFINE l_str2         LIKE type_file.chr1000  #TQC-630166 mark #No.FUN-680136 VARCHAR(100)
  DEFINE l_str2         STRING                  #TQC-630166
  DEFINE l_pml85        STRING
  DEFINE l_pml82        STRING
#No.FUN-580004 ---end--
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.pmk01
  FORMAT
   PAGE HEADER
      LET l_str = NULL
      LET l_str = l_str CLIPPED,g_x[12] CLIPPED
      FOR g_i = 1 TO 3
         CASE tm.s[g_i,g_i]
            WHEN '1' LET l_str = l_str CLIPPED,g_x[22] CLIPPED,'-'
            WHEN '2' LET l_str = l_str CLIPPED,g_x[23] CLIPPED,'-'
            WHEN '3' LET l_str = l_str CLIPPED,g_x[24] CLIPPED,'-'
            WHEN '4' LET l_str = l_str CLIPPED,g_x[25] CLIPPED,'-'
            WHEN '5' LET l_str = l_str CLIPPED,g_x[26] CLIPPED,'-'
            OTHERWISE EXIT CASE
         END CASE
      END FOR
      LET l_str = l_str CLIPPED,' ',g_x[11] CLIPPED,tm.vdate
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT l_str
      PRINT g_dash[1,g_len]               #TQC-6A0086
      #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[44],g_x[40],  #No.FUN-580004
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
            g_x[45],g_x[49],  #NO.MOD-640372
            g_x[37],g_x[38],g_x[39],g_x[44],g_x[40],  #No.FUN-580004
            g_x[41],g_x[42],g_x[43],g_x[46],g_x[47],g_x[48]  #No.TQC-640132
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
ON EVERY ROW
   IF sr.pml35 < g_today THEN  #No.TQC-640132
      LET l_ans = 'Y'
   ELSE
      LET l_ans = ' '
   END IF
   SELECT imc04 INTO sr.imc041 FROM imc_file
   WHERE imc01 = sr.pml04 AND imc02 = 'IMA' AND imc03 = 1
   IF SQLCA.SQLCODE THEN
      LET sr.imc041 = ' '
   END IF
   SELECT imc04 INTO sr.imc042 FROM imc_file
   WHERE imc01 = sr.pml04 AND imc02 = 'IMA' AND imc03 = 3
   IF SQLCA.sqlcode THEN
      LET sr.imc042 = ' '
   END IF
   LET l_imc04 = sr.imc042[1,10]
#  SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.pmk12
#  IF SQLCA.sqlcode THEN
#     LET l_gen02 = ' '
#  END IF
  #MOD-720116-begin-mark
   #LET l_diff = 0
   #IF sr.pml16 MATCHES '[X01]' THEN   # 若請購單的狀態碼為 X,0,1 時
   #   LET l_diff = 0    # 令已訂數量為 0
   #ELSE
   #   IF sr.pml16 = '2' THEN # 若為 2 :發出時須檢查採購單單身的項次
   #      LET g_cnt = 1
   #      FOREACH r811_curs2 USING sr.pml01,sr.pml02 INTO l_pmn20[g_cnt]
   #         SELECT ima021 INTO sr.imc041 FROM ima_file WHERE ima01 = sr.pml04                 #TQC-6A0086
   #         IF SQLCA.sqlcode THEN
   #            CALL cl_err('FOREACH',SQLCA.sqlcode,0)
   #            EXIT FOREACH
   #         END IF
   #         LET l_diff = l_diff + l_pmn20[g_cnt]
   #         LET g_cnt = g_cnt + 1
   #      END FOREACH
   #   END IF
   #END IF
   #LET l_qty = sr.pml20 - l_diff
  #MOD-720116-end-mark
#No.FUN-580004 --start--
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pml04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
                LET l_str2 = l_pml85 , sr.pml83 CLIPPED
                IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN
                    CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                    LET l_str2 = l_pml82, sr.pml80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN
                      CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                      LET l_str2 = l_str2 CLIPPED,',',l_pml82, sr.pml80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN
                    CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
                    LET l_str2 = l_pml85 , sr.pml83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
   PRINT COLUMN g_c[31],sr.pml04 CLIPPED,  #FUN-5B0014 [1,20] CLIPPED,
         COLUMN g_c[32],sr.pml041 CLIPPED,
         COLUMN g_c[33],sr.imc041,
         COLUMN g_c[34],sr.pmk01 CLIPPED,
         COLUMN g_c[35],sr.pmk04 CLIPPED,
         COLUMN g_c[36],sr.pml33 CLIPPED,
         COLUMN g_c[46],sr.pml34 CLIPPED,   #No.TQC-640132
         COLUMN g_c[47],sr.pml35 CLIPPED,   #No.TQC-640132
         COLUMN g_c[48],sr.pml18 CLIPPED,   #No.TQC-640132
         COLUMN g_c[45],sr.pmk09 CLIPPED,
         COLUMN g_c[49],sr.pmc03 CLIPPED,   #NO.MOD-640372
         COLUMN g_c[37],cl_numfor(sr.pml20,37,0) CLIPPED,
         COLUMN g_c[38],cl_numfor(sr.diff,38,0) CLIPPED,   #MOD-720116 modify
         COLUMN g_c[39],cl_numfor(sr.qty,39,0) CLIPPED,    #MOD-720116 modify
         COLUMN g_c[44],l_str2 CLIPPED,  #No.FUN-580004
         COLUMN g_c[40],sr.pml07 CLIPPED,
         COLUMN g_c[41],l_imc04,
         COLUMN g_c[42],l_ans
#No.FUN-580004 ---end--
 
ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN
              PRINT g_dash[1,g_len]               #TQC-6A0086
             #TQC-630166
             #IF tm.wc[001,070] > ' ' THEN			# for 80
 	     #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
             #IF tm.wc[071,140] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
             #IF tm.wc[141,210] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
             #IF tm.wc[211,280] > ' ' THEN
  	     #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
             CALL cl_prt_pos_wc(tm.wc)
             #END TQC-630166
      END IF
      PRINT g_dash[1,g_len]               #TQC-6A0086
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
     END IF
END REPORT}
#No.FUN-750093--End
