# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmr256.4gl
# Desc/riptions..: 採購核價單明細表
# Date & Author..: 97/08/25 By Kitty
# Modify.........: No:7279 03/08/29 By Mandy 應考慮分量計價時的顯示方式
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增核價單號,廠商編號開窗
# Modify.........: No.FUN-4C0095 05/02/17 By Mandy 報表轉XML
# Modify.........: No.FUN-550117 05/05/27 By Danny 採購含稅單價
# Modify.........: No.FUN-550060  05/05/31 By yoyo單據編號格式放大
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.FUN-610018 06/01/11 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6A0079 06/11/06 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0089 06/11/07 By xumin 對廠商簡稱截位
# Modify.........: No.TQC-6C0014 07/01/15 By claire 調整報表格式
# Modify.........: No.FUN-7C0054 07/12/19 By baofei 報表輸出至 Crystal Reports功能 
# Modify.........: No.CHI-8C0014 09/01/04 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B40104 11/04/13 By lilingyu sql變量長度定義過短
# Modify.........: No.FUN-B80088 11/08/10 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
               #  wc   VARCHAR(500),		# Where condition
                 wc  	STRING,	#TQC-630166	# Where condition
                 b    	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)	
                 s      LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3) # Order by sequence chr4  
                 t    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3) # Eject sw chr4
                 type   LIKE type_file.chr2,    #No.CHI-8C0014  
                 more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
          g_pmi01        LIKE pmi_file.pmi01,
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_total1       LIKE tlf_file.tlf18,   #No.FUN-680136 DECIMAL(13,3)
          g_total2       LIKE tlf_file.tlf18    #No.FUN-680136 DECIMAL(13,3)
   DEFINE g_i            LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-7C0054---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                  
                                                 
#No.FUN-7C0054---End   
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
#No.FUN-7C0054---Begin                                                          
   LET g_sql = "pmi01.pmi_file.pmi01,pmi02.pmi_file.pmi02,pmi03.pmi_file.pmi03,",
               "pmi05.pmi_file.pmi05,pmi08.pmi_file.pmi08,pmi081.pmi_file.pmi081,",
               "pmc03.pmc_file.pmc03,pmj02.pmj_file.pmj02,pmj03.pmj_file.pmj03,",
               "pmj031.pmj_file.pmj031,pmj032.pmj_file.pmj032,pmj04.pmj_file.pmj04,",    
               "pmj05.pmj_file.pmj05,pmj06.pmj_file.pmj06,pmj06t.pmj_file.pmj06t,",
               "pmj07.pmj_file.pmj07,pmj07t.pmj_file.pmj07t,pmj08.pmj_file.pmj08,",
               "pmj09.pmj_file.pmj09,pmj10.pmj_file.pmj10,azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('apmr256',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "pmr01.pmr_file.pmr01,",
               "pmr02.pmr_file.pmr02,",
               "pmr03.pmr_file.pmr03,",
               "pmr04.pmr_file.pmr04,",
               "pmr05.pmr_file.pmr05,",   
               "pmr05t.pmr_file.pmr05t,",
               "azi03.azi_file.azi03"
   LET l_table1 = cl_prt_temptable('apmr2561',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF      
#No.FUN-7C0054---End
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(15)     #No.CHI-8C0014
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r256_tm(0,0)		# Input print condition
      ELSE CALL apmr256()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r256_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r256_w AT p_row,p_col WITH FORM "apm/42f/apmr256"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.b    = '3'
   LET tm.s    = '123'
   LET tm.t    = ' '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
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
   LET tm.type = '1'       #CHI-8C0014
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmi01,pmi02,pmi03
   #--No.FUN-4B0022-------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    ON ACTION CONTROLP
      CASE WHEN INFIELD(pmi01)      #核價單號
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_pmi"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmi01
                NEXT FIELD pmi01
           WHEN INFIELD(pmi03)      #廠商編號
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_pmc"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO pmi03
                NEXT FIELD pmi03
 
      OTHERWISE EXIT CASE
      END CASE
    #--END---------------
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
      LET INT_FLAG = 0 CLOSE WINDOW r256_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.b,tm.s,tm.t,tm.more
                   # Condition
#UI
   INPUT BY NAME tm.b,tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,tm.type,tm.more             #CHI-8C0014 Add tm.type
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[123]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
         
      #CHI-8C0014--Begin--#   
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[12]' THEN
            NEXT FIELD type
         END IF
      #CHI-8C0014--End--#         
         
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more)
            THEN NEXT FIELD more
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
      LET INT_FLAG = 0 CLOSE WINDOW r256_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr256'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr256','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.type CLIPPED,"'"               #No.CHI-8C0014
         CALL cl_cmdat('apmr256',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r256_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr256()
   ERROR ""
END WHILE
   CLOSE WINDOW r256_w
END FUNCTION
 
FUNCTION apmr256()
   DEFINE l_name	LIKE type_file.chr20,                   # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,             	# Used time for running the job   #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,		        # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)   #TQC-B40104 
          l_sql 	STRING,                                                                   #TQC-B40104 
          l_chr		LIKE type_file.chr1,                    #No.FUN-680136 VARCHAR(1)
          l_za05	LIKE za_file.za05,                      #No.FUN-680136 VARCHAR(40)
          l_order	ARRAY[6] OF LIKE pmi_file.pmi01,        #No.FUN-680136 VARCHAR(16)
          l_pmr             RECORD LIKE pmr_file.*,              #No.FUN-7C0054
#No:7279
#No.FUN-550060 --start--
         sr               RECORD order1 LIKE pmi_file.pmi01,    #No.FUN-680136 VARCHAR(16)
                                 order2 LIKE pmi_file.pmi01,    #No.FUN-680136 VARCHAR(16)
                                 order3 LIKE pmi_file.pmi01,    #No.FUN-680136 VARCHAR(16)
#No.FUN-550060 --end--
                                  pmi01 LIKE pmi_file.pmi01,	# 單號
                                  pmi02 LIKE pmi_file.pmi02, 	# 日期
                                  pmi03 LIKE pmi_file.pmi03, 	# 廠商編號
                                  pmi05 LIKE pmi_file.pmi05, 	# 分量計價
                                  pmc03 LIKE pmc_file.pmc03, 	# 廠商簡稱
                                  pmj02 LIKE pmj_file.pmj03,    # 項次
                                  pmj03 LIKE pmj_file.pmj03,    # 料號
                                  pmj031 LIKE pmj_file.pmj031,  # 品名
                                  pmj032 LIKE pmj_file.pmj032,  #FUN-4C0095
                                  pmj04 LIKE pmj_file.pmj04,    # 廠商料號
                                  pmj05 LIKE pmj_file.pmj05,    # 幣別
                                  pmj06 LIKE pmj_file.pmj06,    # 原單價
                                  pmj07 LIKE pmj_file.pmj07,    # 新單價
                                  pmj08 LIKE pmj_file.pmj08,    # 原核價日
                                  pmj09 LIKE pmj_file.pmj09,    # 新核價日
                                  pmj10 LIKE pmj_file.pmj10,    # 作業編號
                                  #No.FUN-550117
                                  pmi08  LIKE pmi_file.pmi08,   #稅別
                                  pmi081 LIKE pmi_file.pmi081,  #稅率
                                  pmj06t LIKE pmj_file.pmj06t,  #原含稅單價
                                  pmj07t LIKE pmj_file.pmj07t,  #新含稅單價
                                  gec07  LIKE gec_file.gec07    #含稅否
                                  #end No.FUN-550117
                        END RECORD
#No:7279(end)
#No.FUN-7C0054---Begin
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM                         
   END IF  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
               " VALUES(?,?,?,?,?,?,?) "      
   PREPARE insert_prep1 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
      EXIT PROGRAM                         
   END IF  
     CALL cl_del_data(l_table)     
     CALL cl_del_data(l_table1)    
SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog     
#No.FUN-7C0054---End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004-------Begin--------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004------End---------
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmiuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmigrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmigrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmiuser', 'pmigrup')
     #End:FUN-980030
 
#No:7279
     LET l_sql = "SELECT '','','',",
                 "   pmi01,pmi02,pmi03,pmi05,pmc03,pmj02,pmj03,pmj031,pmj032,pmj04,", #No:7279 add pmj02,pmi05, #FUN-4C0095 add pmj032
                 "   pmj05,pmj06,pmj07,pmj08,pmj09,pmj10,",                    #No:7279 add pmj10
                 #No.FUN-550117
                 "   pmi08,pmi081,pmj06t,pmj07t,gec07 ",
                 " FROM pmi_file,pmj_file, ",
                 " OUTER pmc_file,OUTER gec_file ",
                 " WHERE pmi01 = pmj01 ",
                 "   AND pmi_file.pmi03 = pmc_file.pmc01 ",
                 "   AND pmi_file.pmi08 = gec_file.gec01 ",
                 "   AND ",tm.wc CLIPPED
                 #end No.FUN-550117
#No:7279(end)
    IF tm.b ='1' THEN
       LET l_sql = l_sql CLIPPED, " AND pmiconf = 'Y' "
    END IF
    IF tm.b ='2' THEN
       LET l_sql = l_sql CLIPPED, " AND pmiconf = 'N' "
    END IF
    IF tm.b ='3' THEN
       LET l_sql = l_sql CLIPPED, " AND pmiconf != 'X' "
    END IF
    
     #CHI-8C0014--Begin--#
     IF tm.type = '1' THEN
        LET l_sql =l_sql  CLIPPED,
             "   AND pmj12 = '1' "
     ELSE
        LET l_sql =l_sql  CLIPPED,
             "   AND pmj12 = '2' "                  
     END IF      
     #CHI-8C0014--End--#    
    
    LET l_sql = l_sql CLIPPED," ORDER BY pmi01  "
     LET  g_total1 = 0
     LET  g_total2 = 0
     PREPARE r256_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r256_cs1 CURSOR FOR r256_prepare1
#     LET l_name = 'apmr256.out'                 #No.FUN-7C0054
#     CALL cl_outnam('apmr256') RETURNING l_name #No.FUN-7C0054 
#     START REPORT r256_rep TO l_name            #No.FUN-7C0054 
 
#     LET g_pageno = 0                           #No.FUN-7C0054 
     INITIALIZE g_pmi01 TO NULL
     FOREACH r256_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-7C0054---Begin 
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pmi01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmi02 USING 'YYYYMMDD'
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pmi03
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#No.FUN-7C0054---End 
#No.FUN-610018
#      #No.FUN-550117
#      IF sr.gec07 = 'Y' THEN      #No.FUN-560102
#         LET sr.pmj06 = sr.pmj06t
#         LET sr.pmj07 = sr.pmj07t
#      END IF
       #end No.FUN-550117
#No.FUN-7C0054---Begin 
      SELECT azi03,azi04,azi05                                                                                                      
       INTO t_azi03,t_azi04,t_azi05                                                   
       FROM azi_file WHERE azi01=sr.pmj04  
      IF sr.pmi05 = 'Y' THEN                                                                                        
         DECLARE pmr_curs CURSOR FOR                                                                                                
           SELECT *                                                                                                                 
             FROM pmr_file                                                                                                          
            WHERE pmr01 = sr.pmi01                                                                                  
              AND pmr02 = sr.pmj02                                                                                             
            ORDER BY pmr03                                                                                                          
         INITIALIZE l_pmr.* TO NULL                                                                                                 
         FOREACH pmr_curs INTO l_pmr.*  
             EXECUTE insert_prep1 USING  l_pmr.pmr01,l_pmr.pmr02,l_pmr.pmr03,l_pmr.pmr04,
                                         l_pmr.pmr05,l_pmr.pmr05t,t_azi03
             INITIALIZE l_pmr.* TO NULL                                                                                             
                                                                                  
         END FOREACH         
      END IF
        LET  g_pmi01 =sr.pmi01 
        EXECUTE insert_prep USING  sr.pmi01,sr.pmi02,sr.pmi03,sr.pmi05,sr.pmi08,sr.pmi081,sr.pmc03,
                                   sr.pmj02,sr.pmj03,sr.pmj031,sr.pmj032,sr.pmj04,sr.pmj05,sr.pmj06,
                                   sr.pmj06t,sr.pmj07,sr.pmj07t,sr.pmj08,sr.pmj09,sr.pmj10,
                                   t_azi03,t_azi04,t_azi05
#       OUTPUT TO REPORT r256_rep(sr.*)
#No.FUN-7C0054---End
     END FOREACH
#No.FUN-7C0054---Begin
#     FINISH REPORT r256_rep
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'pmi01,pmi02,pmi03')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc ,";",tm.s[1,1],";", tm.s[2,2],";",
                      tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]
   
   #CHI-8C0014-Begin--#                   
   IF tm.type = '1' THEN                                                                                                  
      LET l_name = 'apmr256_1'                                                                                          
   ELSE                                                                                                                
      LET l_name = 'apmr256'                                                                                   
   END IF
   #CHI-8C0014-End--#                                            
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED          
#  CALL cl_prt_cs3('apmr256','apmr256',l_sql,g_str)                               #CHI-8C0014 Mark
   CALL cl_prt_cs3('apmr256',l_name,l_sql,g_str)                                  #CHI-8C0014
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0054---End
END FUNCTION
#No.FUN-7C0054---Begin
#REPORT r256_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)   
#          l_flag        LIKE type_file.chr1,        #No.TQC-6B0121
#         l_str         LIKE zaa_file.zaa08,        #No.FUN-680136 VARCHAR(50)  #列印排列順序說明
#         swth          LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
#         sq1           LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
#         sq2           LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
#         sq3           LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
#         l_str1        LIKE zaa_file.zaa08,        #No.FUN-680136 VARCHAR(10)  #列印合計的前置說明
#         l_str2        LIKE zaa_file.zaa08,        #No.FUN-680136 VARCHAR(10)  #列印合計的前置說明
#         l_str3        LIKE zaa_file.zaa08,        #No.FUN-680136 VARCHAR(10)  #列印合計的前置說明
#         l_str4        LIKE type_file.chr10,       #No.FUN-680136 VARCHAR(10)  #No.FUN-550117 #No.TQC-6A0079
##No:7279
#         sr               RECORD order1 LIKE pmi_file.pmi01,   #No.FUN-680136 VARCHAR(16)
#                                 order2 LIKE pmi_file.pmi01,   #No.FUN-680136 VARCHAR(16)
#                                 order3 LIKE pmi_file.pmi01,   #No.FUN-680136 VARCHAR(16)
#                                 pmi01 LIKE pmi_file.pmi01,	# 單號
#                                 pmi02 LIKE pmi_file.pmi02, 	# 日期
#                                 pmi03 LIKE pmi_file.pmi03, 	# 廠商編號
#                                 pmi05 LIKE pmi_file.pmi05, 	# 分量計價
#                                 pmc03 LIKE pmc_file.pmc03, 	# 廠商簡稱
#                                 pmj02 LIKE pmj_file.pmj03,    # 項次
#                                 pmj03 LIKE pmj_file.pmj03,    # 料號
#                                 pmj031 LIKE pmj_file.pmj031,  # 品名
#                                 pmj032 LIKE pmj_file.pmj032,  #FUN-4C0095
#                                 pmj04 LIKE pmj_file.pmj04,    # 廠商料號
#                                 pmj05 LIKE pmj_file.pmj05,    # 幣別
#                                 pmj06 LIKE pmj_file.pmj06,    # 原單價
#                                 pmj07 LIKE pmj_file.pmj07,    # 新單價
#                                 pmj08 LIKE pmj_file.pmj08,    # 原核價日
#                                 pmj09 LIKE pmj_file.pmj09,    # 新核價日
#                                 pmj10 LIKE pmj_file.pmj10,    # 作業編號
#                                 #No.FUN-550117
#                                 pmi08  LIKE pmi_file.pmi08,   #稅別
#                                 pmi081 LIKE pmi_file.pmi081,  #稅率
#                                 pmj06t LIKE pmj_file.pmj06t,  #原含稅單價
#                                 pmj07t LIKE pmj_file.pmj07t,  #新含稅單價
#                                 gec07  LIKE gec_file.gec07    #含稅否
#                                 #end No.FUN-550117
#                       END RECORD,
#     l_pmr             RECORD LIKE pmr_file.*  #NO:7279 分量計價資料
##No:7279(end)
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
 
# ORDER BY sr.order1,sr.order2,sr.order3,sr.pmi01
# FORMAT
#  PAGE HEADER
## 處理排列順序於列印時所需控制
#     LET sq1=tm.s[1,1]
#     LET sq2=tm.s[2,2]
#     LET sq3=tm.s[3,3]
#     LET l_str=g_x[19] CLIPPED
#     CASE
#        WHEN sq1='1'    LET l_str=l_str CLIPPED,g_x[11]
#                        LET l_str1=g_x[11] CLIPPED
#        WHEN sq1='2'    LET l_str=l_str CLIPPED,g_x[12]
#                        LET l_str1=g_x[12] CLIPPED
#        WHEN sq1='3'    LET l_str=l_str CLIPPED,g_x[13]
#                        LET l_str1=g_x[13] CLIPPED
#     END CASE
#     CASE
#        WHEN sq2='1'    LET l_str=l_str CLIPPED,' ',g_x[11]
#                        LET l_str2=g_x[11] CLIPPED
#        WHEN sq2='2'    LET l_str=l_str CLIPPED,' ',g_x[12]
#                        LET l_str2=g_x[12] CLIPPED
#        WHEN sq2='3'    LET l_str=l_str CLIPPED,' ',g_x[13]
#                        LET l_str2=g_x[13] CLIPPED
#     END CASE
#     CASE
#        WHEN sq3='1'    LET l_str=l_str CLIPPED,' ',g_x[11]
#                        LET l_str3=g_x[11] CLIPPED
#        WHEN sq3='2'    LET l_str=l_str CLIPPED,' ',g_x[12]
#                        LET l_str3=g_x[12] CLIPPED
#        WHEN sq3='3'    LET l_str=l_str CLIPPED,' ',g_x[13]
#                        LET l_str3=g_x[13] CLIPPED
#     END CASE
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT l_str
#     PRINT g_dash
#    #TQC-6C0014-end-add
#     #No.FUN-610018
#    #PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[38],g_x[39],g_x[40],g_x[57]
##      PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[59],g_x[37],g_x[46],g_x[48],g_x[49],g_x[50],g_x[58]
#    #PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[59],g_x[37],g_x[48],g_x[49],g_x[50],g_x[58]    #No.TQC-6B0121
#     #No.FUN-550117
#    #PRINTX name=H3 g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[60],g_x[47]
#     #endNo.FUN-550117
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[38],g_x[39]
#     PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[59],g_x[37],g_x[40],g_x[57]
#     PRINTX name=H3 g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[60],g_x[47],g_x[48],g_x[49],g_x[50],g_x[58]
#    #TQC-6C0014-end-add
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' THEN
#         SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.pmi01
#     IF g_pmi01 IS NULL OR  g_pmi01!=sr.pmi01 THEN
#         LET swth = 'Y'
#     ELSE
#         LET swth='N'
#     END IF
#     PRINTX name=D1 COLUMN g_c[31],sr.pmi01,
#                    COLUMN g_c[32],sr.pmi02,
#                    COLUMN g_c[33],sr.pmi03,
#          #          COLUMN g_c[34],sr.pmc03;
#                    COLUMN g_c[34],sr.pmc03[1,10];   #No.TQC-6A0089
 
#  ON EVERY ROW
# #     IF swth = 'Y' THEN
# #          IF g_pmi01 IS NULL OR g_pmi01  !=sr.pmi01  THEN
# #           PRINT COLUMN 01,sr.pmi01,
# #                 COLUMN 12,sr.pmi02,
# #                 COLUMN 21,sr.pmi03,
# #                 COLUMN 32,sr.pmc03;
# #        END IF
# #     END IF
#    #IF sr.pmj03[1,4] = 'MISC' THEN LET sr.ima02 = sr.pmj031 END IF #No:7279
 
#     SELECT azi03,azi04,azi05
#      INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取   #No.CHI-6A0004
#      FROM azi_file WHERE azi01=sr.pmj04
##No:7279
#     #No.FUN-610018
#     PRINTX name=D1 COLUMN g_c[35],sr.pmj03,
#                    COLUMN g_c[36],sr.pmj04,
#                    COLUMN g_c[38],sr.pmj10,
#                    COLUMN g_c[39],' '
#                   #COLUMN g_c[40],cl_numfor(sr.pmj06,40,t_azi03),   #No.CHI-6A0004 #TQC-6C0014 mark
#                   #COLUMN g_c[57],cl_numfor(sr.pmj06t,57,t_azi03)   #No.CHI-6A0004 #TQC-6C0014 mark
#     PRINTX name=D2 COLUMN g_c[41],' ',
#                    COLUMN g_c[42],' ',
#                    COLUMN g_c[43],' ',
#                    COLUMN g_c[44],' ',
#                    COLUMN g_c[45],sr.pmj031,
#                    COLUMN g_c[46],sr.pmj05,
#                    COLUMN g_c[37],sr.pmj08,
#                    COLUMN g_c[40],cl_numfor(sr.pmj06,40,t_azi03),   #TQC-6C0014 add
#                     COLUMN g_c[57],cl_numfor(sr.pmj06t,57,t_azi03)   #TQC-6C0014 add
##No.FUN-550117
##     #不為分量計量時,列印 pmj07
##     IF sr.pmi05 <> 'Y' OR sr.pmi05 IS NULL THEN
##         PRINTX name=D2 COLUMN g_c[48],' ',
##                        COLUMN g_c[49],' ',
##                        COLUMN g_c[50],cl_numfor(sr.pmj07,50,t_azi03);  #No.CHI-6A0004
##     ELSE
##         PRINTX name=D2 COLUMN g_c[48],' ',
##                        COLUMN g_c[49],' ',
##                        COLUMN g_c[50],' ';
##     END IF
##end No.FUN-550117
#    #TQC-6C0014-begin
#     PRINTX name=D3 COLUMN g_c[51],' ',
#                    COLUMN g_c[52],' ',
#                    COLUMN g_c[53],' ',
#                    COLUMN g_c[54],' ',
#                    COLUMN g_c[55],sr.pmj032;     #No.FUN-550117
#     #No.FUN-550117
#     LET l_str4 = sr.pmi08 CLIPPED,'   ',sr.pmi081 USING '##&','%'   #No.FUN-610018
#     PRINTX name=D3 COLUMN g_c[56],l_str4 CLIPPED,
#                    COLUMN g_c[47],sr.pmj09;
#     #end No.FUN-550117
#    #TQC-6C0014-end
#     IF sr.pmi05 = 'Y' THEN #分量計價
#        LET l_flag = 'N'   #No.TQC-6B0121
#        DECLARE pmr_curs CURSOR FOR
#          SELECT *
#            FROM pmr_file
#           WHERE pmr01 = sr.pmi01 #核價單號
#             AND pmr02 = sr.pmj02 #項次
#           ORDER BY pmr03
#        INITIALIZE l_pmr.* TO NULL
#        FOREACH pmr_curs INTO l_pmr.*
#            #No.FUN-550117
##No.FUN-610018
##            IF sr.gec07 = 'Y' THEN      #No.FUN-560102
##               LET l_pmr.pmr05 = l_pmr.pmr05t
##            END IF
#            #end No.FUN-550117
#            PRINTX name=D3 COLUMN g_c[48],cl_numfor(l_pmr.pmr03,48,0),  #TQC-6C0014 D2->D3
#                           COLUMN g_c[49],cl_numfor(l_pmr.pmr04,49,0),
#                           COLUMN g_c[50],cl_numfor(l_pmr.pmr05,50,t_azi03),  #No.CHI-6A0004
#                           COLUMN g_c[58],cl_numfor(l_pmr.pmr05t,58,t_azi03)  #No.CHI-6A0004
#            INITIALIZE l_pmr.* TO NULL
#            LET l_flag = 'Y'   #No.TQC-6B0121
#        END FOREACH
#        IF l_flag = 'N' THEN    #No.TQC-6B0121
#           PRINTX name = D3     #No.TQC-6B0121   #TQC-6C0014 D2->D3
#        END IF                  #No.TQC-6B0121
#     #No.FUN-550117
#     ELSE        #不為分量計量時,列印 pmj07
#        PRINTX name=D3 COLUMN g_c[48],' ',       #TQC-6C0014 D2->D3
#                       COLUMN g_c[49],' ',
#                       COLUMN g_c[50],cl_numfor(sr.pmj07,50,t_azi03),  #No.CHI-6A0004
#                       COLUMN g_c[58],cl_numfor(sr.pmj07t,58,t_azi03)  #No.CHI-6A0004
#     #end No.FUN-550117
#     END IF
#    #TQC-6C0014-begin-mark
#     #PRINTX name=D3 COLUMN g_c[51],' ',
#     #               COLUMN g_c[52],' ',
#     #               COLUMN g_c[53],' ',
#     #               COLUMN g_c[54],' ',
#     #               COLUMN g_c[55],sr.pmj032;     #No.FUN-550117
#     ##No.FUN-550117
#     #LET l_str4 = sr.pmi08 CLIPPED,'   ',sr.pmi081 USING '##&','%'   #No.FUN-610018
#     #PRINTX name=D3 COLUMN g_c[56],l_str4 CLIPPED,
#     #               COLUMN g_c[47],sr.pmj09
#     ##end No.FUN-550117
#    #TQC-6C0014-end-mark
#     LET  g_pmi01 =sr.pmi01
##No:7279(end)
 
#ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN
#             PRINT g_dash
#          #  IF tm.wc[001,120] > ' ' THEN			# for 132
#	   #     PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#          #  IF tm.wc[121,240] > ' ' THEN
#	   #     PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#          #  IF tm.wc[241,300] > ' ' THEN
#	   #	 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#          #TQC-630166
#       	CALL cl_prt_pos_wc(tm.wc)
#     END IF
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#   IF l_last_sw = 'n'
#       THEN PRINT g_dash
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE SKIP 2 LINES
#    END IF
#END REPORT
#No.FUN-7C0054---End
#Patch....NO.TQC-610036 <001> #
