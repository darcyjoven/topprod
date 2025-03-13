# Prog. Version..: '5.30.07-13.05.30(00004)'     #
#
# Pattern name...: apmx400.4gl
# Desc/riptions...: 請購清單
# Input parameter:
# Return code....:
# Date & Author..: 91/09/19 By MAY
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: No.FUN-4C0095 04/12/23 By Mandy 報表轉XML
# Modify.........: No.FUN-550060 05/05/30 By yoyo單據編號格式放大
# Modify.........: No.FUN-580004 05/08/03 By jackie 雙單位報表修改
# Modify.........: No.MOD-5A0180 05/10/21 By Nicola 列印位置調整
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0105 05/11/11 By Mandy 報表的單號/料號/品名/規各對齊調整
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0079 06/10/31 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-7C0054 07/12/20 By baofei 報表輸出至 Crystal Reports功能   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-CB0001 12/11/07 By yangtt CR轉XtraGrid
# Modify.........: No.FUN-D30053 13/03/18 By yangtt XtraGrid报表修改
# Modify.........: No.FUN-D30053 13/03/18 By yangtt mark grup_field后跳頁失效需還原
# Modify.........: No.FUN-D30070 13/03/21 By wangrr 頁脚排序順序mark
# Modify.........: No.FUN-D40129 13/05/28 By yangtt q_qcs3->q_pmc01_1
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17    #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD				#Print condition RECORD
	     #	wc   VARCHAR(500),		#Where condition
		wc  	STRING,	         	#TQC-630166             # Where condition
                bdate   LIKE type_file.chr20,   #No.FUN-680136 VARCHAR(13)
   		s    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3)  # Order by sequence
   		t    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3)  # Eject sw
                u       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                b       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  # print gkf_file detail(Y/N)
   		more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)	# Input more condition(Y/N)
              END RECORD,
          g_aza17       LIKE aza_file.aza17,    # 本國幣別
          g_dates       LIKE aab_file.aab02,    #No.FUN-680136 VARCHAR(6)
          g_datee       LIKE aab_file.aab02,    #No.FUN-680136 VARCHAR(6)
          l_bdates      LIKE type_file.dat,     #No.FUN-680136 DATE
          l_bdatee      LIKE type_file.dat,     #No.FUN-680136 DATE
          pmk12_tm      LIKE pmk_file.pmk12,
#         g_pmk01       VARCHAR(10),
          g_pmk01       LIKE pmk_file.pmk01,    #No.FUN-680136 VARCHAR(16)
          g_total       LIKE tlf_file.tlf18,    #No.FUN-680136 DECIMAL(13,3) 
          swth          LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
DEFINE    g_orderA ARRAY[3] OF LIKE zaa_file.zaa08    #No.FUN-680136 VARCHAR(40)  #排列順序項目的中文說明
DEFINE   g_i             LIKE type_file.num5          #No.FUN-680136 SMALLINT  #count/index for any purpose    
#No.FUN-580004 --start--
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
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
   LET g_sql = "pmk01.pmk_file.pmk01,pmk02.pmk_file.pmk02,",
               "pmk04.pmk_file.pmk04,pmk09.pmk_file.pmk09,",
               "pmk12.pmk_file.pmk12,pmk22.pmk_file.pmk22,pmc02.pmc_file.pmc02,",
               "pmc03.pmc_file.pmc03,gen02.gen_file.gen02,ima021.ima_file.ima021,",
               "ima08.ima_file.ima08,ima37.ima_file.ima37,l_str4.type_file.chr1000,",    
               "pml02.pml_file.pml02,pml04.pml_file.pml04,pml041.pml_file.pml041,",
               "pml07.pml_file.pml07,pml08.pml_file.pml08,l_pml09.type_file.chr10,",
               "pml16.pml_file.pml16,pml18.pml_file.pml18,pml20.pml_file.pml20,",
               "pml33.pml_file.pml33,pml34.pml_file.pml34,pml35.pml_file.pml35,",
               "l_num1.type_file.num5,l_num2.type_file.num5,l_pml16.type_file.chr100" #FUN-CB0001
   LET l_table = cl_prt_temptable('apmx400',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "   #FUN-CB0001 add3?      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF  
#No.FUN-7C0054---End
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
#---------------No.TQC-610085 modify
  #LET tm.bdate = ARG_VAL(8)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#---------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL x400_tm(0,0)		# Input print condition
      ELSE CALL apmx400()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION x400_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW x400_w AT p_row,p_col WITH FORM "apm/42f/apmx400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.t    = 'Y  '
   LET tm.b    = 'N'
   LET tm.u    = 'N'
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
 
WHILE TRUE
   DISPLAY BY NAME tm.b,tm.s,tm.t,tm.more
                  ,tm.u  # Condition
   CONSTRUCT BY NAME tm.wc ON pmk01,pmk04,pmk12,pmk09,pml04,pml33
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           #FUN-CB0001-----add----str---
           IF INFIELD(pmk01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmk2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmk01
              NEXT FIELD pmk01
           END IF
           #FUN-CB0001-----add----end---
           IF INFIELD(pmk12) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmk12
              NEXT FIELD pmk12
           END IF
           IF INFIELD(pmk09) THEN
              CALL cl_init_qry_var()
	     #LET g_qryparam.form = "q_qcs3"      #FUN-D40129 mark
              LET g_qryparam.form = "q_pmc01_1"   #FUN-D40129 add
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmk09
              NEXT FIELD pmk09
           END IF
           IF INFIELD(pml04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pml04
              NEXT FIELD pml04
           END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW x400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.b,tm.s,tm.t,tm.more
                  ,tm.u  # Condition
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,tm.b,tm.u,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD u
         IF tm.u NOT MATCHES "[YN]" OR tm.u IS NULL
            THEN NEXT FIELD u
         END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
            THEN NEXT FIELD b
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
      LET INT_FLAG = 0 CLOSE WINDOW x400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmx400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmx400','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.u CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmx400',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW x400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmx400()
   ERROR ""
END WHILE
   CLOSE WINDOW x400_w
END FUNCTION
 
FUNCTION apmx400()
   DEFINE l_name	LIKE type_file.chr20, 	     # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	     # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	     # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
          l_za05	LIKE za_file.za05,           #No.FUN-680136 VARCHAR(40)
          l_gen02       LIKE gen_file.gen02,          #No.FUN-7C0054                                                                       
          l_pmc02       LIKE pmc_file.pmc02,          #No.FUN-7C0054                                                               
          l_pmc03       LIKE pmc_file.pmc03,          #No.FUN-7C0054                                                               
          l_ima021      LIKE ima_file.ima021,         #No.FUN-7C0054                                                                          
          l_ima08       LIKE ima_file.ima08,          #No.FUN-7C0054                                                                                            
          l_ima37       LIKE ima_file.ima08,          #No.FUN-7C0054
          l_pml09       LIKE type_file.chr10,         #No.FUN-7C0054
#         l_order	ARRAY[6] OF VARCHAR(10),
          l_order	ARRAY[6] OF LIKE pml_file.pml04,    #No.FUN-680136 VARCHAR(40)
          i             LIKE type_file.num5,                #No.FUN-580004 #No.FUN-680136 SMALLINT
#          sr               RECORD order1 VARCHAR(10),
#                                  order2 VARCHAR(10),
#                                  order3 VARCHAR(10),
#No.FUN-550060 --start--
          sr               RECORD order1 LIKE pml_file.pml04,    #No.FUN-680136 VARCHAR(40) 
                                  order2 LIKE pml_file.pml04,    #No.FUN-680136 VARCHAR(40)
                                  order3 LIKE pml_file.pml04,    #No.FUN-680136 VARCHAR(40)
#No.FUN_550060 --end--
                                  pmk01 LIKE pmk_file.pmk01,	# 單號
                                  pmk02 LIKE pmk_file.pmk02, 	# 性質
                                  pmk03 LIKE pmk_file.pmk03, 	# 更動序號
                                  pmk04 LIKE pmk_file.pmk04, 	#
                                  pmk09 LIKE pmk_file.pmk09,	# 廠商編號
                                  pmk22 LIKE pmk_file.pmk22,    # 幣別
                                  pml02 LIKE pml_file.pml02,	# 項次
                                  pml04 LIKE pml_file.pml04,	# 料件編號
                                  pml041 LIKE pml_file.pml041,	# 品名規格
                                  pml07 LIKE pml_file.pml07,	# 請購單位
                                  pml08 LIKE pml_file.pml08,	# 庫存單
                                  pml09 LIKE pml_file.pml09,	#轉換因子
                                  pml18 LIKE pml_file.pml18,	# 需求日期
                                  pml33 LIKE pml_file.pml33,	# 交貨日期
                                  pml34 LIKE pml_file.pml34,	# 到廠日期
                                  pml35 LIKE pml_file.pml35,	# 到庫日期
                                  pml20 LIKE pml_file.pml20,	# 訂購量
                                  pml16 LIKE pml_file.pml16, 	# 狀況
                                  pmk07 LIKE pmk_file.pmk07, 	#
                                  pmk12 LIKE pmk_file.pmk12, 	#
#No.FUN-580004 --start--
                                  pml80 LIKE pml_file.pml80,
                                  pml82 LIKE pml_file.pml81,
                                  pml83 LIKE pml_file.pml83,
                                  pml85 LIKE pml_file.pml85,
                                  pml86 LIKE pml_file.pml86,
                                  pml87 LIKE pml_file.pml87
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE l_ima906           LIKE ima_file.ima906         #No.FUN-7C0054
     DEFINE l_str4             LIKE type_file.chr1000       #No.FUN-7C0054
     DEFINE l_pml85            STRING                       #No.FUN-7C0054
     DEFINE l_pml82            STRING                       #No.FUN-7C0054
#No.FUN-580004 --end--
     DEFINE l_num1             LIKE type_file.num5          #No.FUN-CB0001
     DEFINE l_num2             LIKE type_file.num5          #No.FUN-CB0001
     DEFINE l_pml16            LIKE type_file.chr100        #No.FUN-CB0001
     DEFINE l_str              STRING                       #No.FUN-CB0001
 
     CALL cl_del_data(l_table)                                   #No.FUN-7C0054
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-7C0054
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.CHI-6A0004-----------Begin----------
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#No.CHI-6A0004----------End------------
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
 
     LET l_sql = "SELECT '','','',",
                 "   pmk01,  pmk02,  pmk03,  pmk04,  pmk09,  pmk22,  pml02,",
                 "   pml04,  pml041, pml07,  pml08,  pml09,",
                 "   pml18,  pml33,  pml34,  pml35,  pml20,",
                 "   pml16,  pmk07,  pmk12, ",
                 "   pml80,  pml82,  pml83,  pml85 ",   #No.FUN-580004
                 " FROM pmk_file,pml_file  ",
                 " WHERE pmk01 = pml01 " ,
                 " AND ",tm.wc
# 不包括已轉成採購單的請購單
         IF tm.b ='N' THEN LET l_sql =l_sql CLIPPED,
               " AND  pml16 != '2' "
          END IF
# 不包括已作廢的請購單
         IF tm.u ='N' THEN LET l_sql =l_sql CLIPPED,
               " AND  pml16 != '9'  AND pmk18 != 'X'"
         END IF
     LET l_sql = l_sql CLIPPED," ORDER BY pmk01,pmk12,pml02  "
     INITIALIZE pmk12_tm TO NULL
     LET  g_total = 0
 
     PREPARE x400_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE x400_cs1 CURSOR FOR x400_prepare1
#No.FUN-7C0054---Begin
#     LET l_name = 'apmx400.out'
#     CALL cl_outnam('apmx400') RETURNING l_name
 
#No.FUN-580004  --start
#     IF g_sma115 = "Y" THEN
#            LET g_zaa[45].zaa06 = "N"
#     ELSE
#            LET g_zaa[45].zaa06 = "Y"
#     END IF
#     CALL cl_prt_pos_len()
#No.FUN-580004 --end--
 IF g_sma115 = "Y" THEN 
    LET l_name='apmx400'
 ELSE
    LET l_name='apmx400_1'
 END IF 
#     START REPORT x400_rep TO l_name
#No.FUN-7C0054---End
     FOREACH x400_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF sr.pmk01 IS NULL THEN LET sr.pmk01 = ' ' END IF
       IF sr.pmk04 IS NULL THEN LET sr.pmk04 = ' ' END IF
       IF sr.pmk07 IS NULL THEN LET sr.pmk07 = ' ' END IF
       IF sr.pmk12 IS NULL THEN LET sr.pmk12 = ' ' END IF
       IF sr.pmk09 IS NULL THEN LET sr.pmk09 = ' ' END IF
       #BugNo:5766
#No.FUN-7C0054---Begin
#       FOR g_i = 1 TO 3
#      CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pmk01
#                                    LET g_orderA[g_i]= g_x[28]
#           WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmk04 USING 'YYYYMMDD'
#                                    LET g_orderA[g_i]= g_x[29]
#           WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pmk12
#                                    LET g_orderA[g_i]= g_x[30]
#           WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pmk09
#                                    LET g_orderA[g_i]= g_x[31]
#           WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pml04
#                                    LET g_orderA[g_i]= g_x[32]
#           WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.pml33 USING 'YYYYMMDD'
#                                    LET g_orderA[g_i]= g_x[33]
#        OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#No.FUN-7C0054---End
       INITIALIZE g_pmk01 TO NULL
       IF sr.pml20 IS NULL THEN LET sr.pml20=0  END IF
#No.FUN-7C0054---Begin
      SELECT pmc02,pmc03
        INTO l_pmc02,l_pmc03
        FROM pmc_file
       WHERE pmc01 = sr.pmk09
      IF SQLCA.sqlcode THEN
          LET l_pmc02 = NULL
          LET l_pmc03 = NULL
      END IF
      SELECT gen02
        INTO l_gen02
        FROM gen_file
       WHERE gen01 = sr.pmk12
      IF SQLCA.sqlcode THEN
          LET l_gen02 = NULL
      END IF
      SELECT ima08,ima37,ima021
        INTO l_ima08,l_ima37,l_ima021
        FROM ima_file
       WHERE ima01=sr.pml04
      IF SQLCA.sqlcode THEN
          LET l_ima08 = NULL
          LET l_ima37 = NULL
          LET l_ima021 = NULL
      END IF
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pml04
      LET l_str4 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
                LET l_str4 = l_pml85 , sr.pml83 CLIPPED
                IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN
                    CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                    LET l_str4 = l_pml82, sr.pml80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN
                      CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
                      LET l_str4 = l_str4 CLIPPED,',',l_pml82, sr.pml80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN
                    CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
                    LET l_str4 = l_pml85 , sr.pml83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      LET l_pml09 = cl_facfor(sr.pml09) CLIPPED
      LET l_num1 = 0   #FUN-CB0001 
      LET l_num2 = 3   #FUN-CB0001 
      #FUN-CB0001----add---str--
      CASE sr.pml16
         WHEN 'X' LET l_pml16 = sr.pml16,':',cl_getmsg('apm-370',g_lang)
         WHEN '0' LET l_pml16 = sr.pml16,':',cl_getmsg('aem-010',g_lang)
         WHEN '1' LET l_pml16 = sr.pml16,':',cl_getmsg('aqc-010',g_lang)
         WHEN '2' LET l_pml16 = sr.pml16,':',cl_getmsg('axd-063',g_lang)
         WHEN '6' LET l_pml16 = sr.pml16,':',cl_getmsg('apm-371',g_lang)
         WHEN '7' LET l_pml16 = sr.pml16,':',cl_getmsg('apm-372',g_lang)
         WHEN '8' LET l_pml16 = sr.pml16,':',cl_getmsg('apm-373',g_lang)
         WHEN '9' LET l_pml16 = sr.pml16,':',cl_getmsg('arm-046',g_lang)
      END CASE
      #FUN-CB0001----add---end--
      EXECUTE insert_prep  USING  sr.pmk01,sr.pmk02,sr.pmk04,sr.pmk09,sr.pmk12,sr.pmk22,
                                  l_pmc02,l_pmc03,l_gen02,l_ima021,l_ima08,l_ima37,l_str4,
                                  sr.pml02,sr.pml04,sr.pml041,sr.pml07,sr.pml08,l_pml09,
                                  sr.pml16,sr.pml18,sr.pml20,sr.pml33,sr.pml34,sr.pml35,
                                  l_num1,l_num2,l_pml16    #FUN-CB0001
#       OUTPUT TO REPORT x400_rep(sr.*)
#No.FUN-7C0054---End
     END FOREACH
#No.FUN-7C0054---Begin
#     FINISH REPORT x400_rep
###XtraGrid###      LET g_str=tm.wc ,";",tm.s[1,1],";", tm.s[2,2],";",
###XtraGrid###                      tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3]
                      
                                                                          
###XtraGrid###   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
###XtraGrid###   CALL cl_prt_cs3('apmx400',l_name,l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    #FUN-CB0001-----add---str---
    IF g_zz05 = 'Y' THEN                                                      
       CALL cl_wcchp(tm.wc,'pmk01,pmk04,pmk12,pmk09,pml04,pml33')                         
            RETURNING tm.wc                                                   
    END IF                                                                    
    LET g_xgrid.template = l_name
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"pmk01,pmk04,pmk12,pmk09,pml04,pml33")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"pmk01,pmk04,pmk12,pmk09,pml04,pml33")  #FUN-D30053 mark
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"pmk01,pmk04,pmk12,pmk09,pml04,pml33")
   #LET l_str = cl_wcchp(g_xgrid.order_field,"pmk01,pmk04,pmk12,pmk09,pml04,pml33") #FUN-D30070 mark
   #LET l_str = cl_replace_str(l_str,',','-') #FUN-D30070 mark
   #LET g_xgrid.footerinfo1 = cl_getmsg('lib-626',g_lang),l_str #FUN-D30070 mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
    #FUN-CB0001-----add---end---
    CALL cl_xg_view()    ###XtraGrid###
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0054---End
END FUNCTION
#No.FUN-7C0054---Begin
#REPORT x400_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         l_str         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(50)  #列印排列順序說明
#       # l_str1        LIKE apm_file.apm08,    #No.FUN-680136 VARCHAR(10)  #列印合計的前置說明   #No.TQC-6A0079
#       # l_str2        LIKE apm_file.apm08,    #No.FUN-680136 VARCHAR(10)  #列印合計的前置說明   #No.TQC-6A0079
#       # l_str3        LIKE apm_file.apm08,    #No.FUN-680136 VARCHAR(10)  #列印合計的前置說明   #No.TQC-6A0079
#         l_pml20       LIKE pml_file.pml20,
#         sq1           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         sq2           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         sq3           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#         l_gen02       LIKE gen_file.gen02,    #FUN-4C0095
#         l_pmc02       LIKE pmc_file.pmc02,    #FUN-4C0095
#         l_pmc03       LIKE pmc_file.pmc03,    #FUN-4C0095
#         l_ima021      LIKE ima_file.ima021,   #FUN-4C0095
#         l_ima08       LIKE ima_file.ima08,
#         l_ima37       LIKE ima_file.ima08,
#         sr               RECORD order1 LIKE pml_file.pml04,   #No.FUN-680136 VARCHAR(40)
#                                 order2 LIKE pml_file.pml04,   #No.FUN-680136 VARCHAR(40)
#                                 order3 LIKE pml_file.pml04,   #No.FUN-680136 VARCHAR(40)
#                                 pmk01 LIKE pmk_file.pmk01,	# 單號
#                                 pmk02 LIKE pmk_file.pmk02, 	# 性質
#                                 pmk03 LIKE pmk_file.pmk03, 	# 更動序號
#                                 pmk04 LIKE pmk_file.pmk04, 	#
#                                 pmk09 LIKE pmk_file.pmk09,	# 廠商編號
#                                 pmk22 LIKE pmk_file.pmk22,    # 幣別
#                                 pml02 LIKE pml_file.pml02,	# 項次
#                                 pml04 LIKE pml_file.pml04,	# 料件編號
#                                 pml041 LIKE pml_file.pml041,	# 品名規格
#                                 pml07 LIKE pml_file.pml07,	# 請購單位
#                                 pml08 LIKE pml_file.pml08,	# 庫存單位
#                                 pml09 LIKE pml_file.pml09,	#轉換因子
#                                 pml18 LIKE pml_file.pml18,	# 需求日期
#                                 pml33 LIKE pml_file.pml33,	# 交貨日期
#                                 pml34 LIKE pml_file.pml34,	# 到廠日期
#                                 pml35 LIKE pml_file.pml35,	# 到庫日期
#                                 pml20 LIKE pml_file.pml20,	# 訂購量
#                                 pml16 LIKE pml_file.pml16, 	# 狀況
#                                 pmk07 LIKE pmk_file.pmk07, 	#
#                                 pmk12 LIKE pmk_file.pmk12, 	#
##No.FUN-580004 --start--
#                                 pml80 LIKE pml_file.pml80,
#                                 pml82 LIKE pml_file.pml81,
#                                 pml83 LIKE pml_file.pml83,
#                                 pml85 LIKE pml_file.pml85,
#                                 pml86 LIKE pml_file.pml86,
#                                 pml87 LIKE pml_file.pml87
#                       END RECORD
# DEFINE l_ima906       LIKE ima_file.ima906
# DEFINE l_str4         LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(100)
# DEFINE l_pml85        STRING
# DEFINE l_pml82        STRING
##No.FUN-580004 --end--
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3,sr.pmk01,sr.pml02
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET l_str=g_x[27] CLIPPED,g_orderA[1] CLIPPED,'-',
#                               g_orderA[2] CLIPPED,'-',
#                               g_orderA[3] CLIPPED
#     PRINT l_str
#     PRINT g_dash
#     #---
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40], #FUN-4C0095 印表頭
#           g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50], #FUN-4C0095 印表頭
#           g_x[51],g_x[52],g_x[53],g_x[54]  #No.FUN-580004
#     #---
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y'
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y'
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y'
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  #FUN-4C0095----
#  BEFORE GROUP OF sr.pmk01
#     SELECT pmc02,pmc03
#       INTO l_pmc02,l_pmc03
#       FROM pmc_file
#      WHERE pmc01 = sr.pmk09
#     IF SQLCA.sqlcode THEN
#         LET l_pmc02 = NULL
#         LET l_pmc03 = NULL
#     END IF
#     SELECT gen02
#       INTO l_gen02
#       FROM gen_file
#      WHERE gen01 = sr.pmk12
#     IF SQLCA.sqlcode THEN
#         LET l_gen02 = NULL
#     END IF
#    #PRINT COLUMN g_c[31],sr.pmk01,'-',sr.pmk03 USING '####',#TQC-5B0105 &051112
#     PRINT COLUMN g_c[31],sr.pmk01,                          #TQC-5B0105 &051112
#           COLUMN g_c[32],sr.pmk02,
#           COLUMN g_c[33],sr.pmk09,
#           COLUMN g_c[34],l_pmc02,
#           COLUMN g_c[35],l_pmc03,
#           COLUMN g_c[36],sr.pmk22,
#           COLUMN g_c[37],sr.pmk12,
#           COLUMN g_c[38],l_gen02;
 
#  ON EVERY ROW
#     SELECT ima08,ima37,ima021
#       INTO l_ima08,l_ima37,l_ima021
#       FROM ima_file
#      WHERE ima01=sr.pml04
#     IF SQLCA.sqlcode THEN
#         LET l_ima08 = NULL
#         LET l_ima37 = NULL
#         LET l_ima021 = NULL
#     END IF
##No.FUN-580004 --start--
#     SELECT ima906 INTO l_ima906 FROM ima_file
#                        WHERE ima01=sr.pml04
#     LET l_str4 = ""
#     IF g_sma115 = "Y" THEN
#        CASE l_ima906
#           WHEN "2"
#               CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
#               LET l_str4 = l_pml85 , sr.pml83 CLIPPED
#               IF cl_null(sr.pml85) OR sr.pml85 = 0 THEN
#                   CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
#                   LET l_str4 = l_pml82, sr.pml80 CLIPPED
#               ELSE
#                  IF NOT cl_null(sr.pml82) AND sr.pml82 > 0 THEN
#                     CALL cl_remove_zero(sr.pml82) RETURNING l_pml82
#                     LET l_str4 = l_str4 CLIPPED,',',l_pml82, sr.pml80 CLIPPED
#                  END IF
#               END IF
#           WHEN "3"
#               IF NOT cl_null(sr.pml85) AND sr.pml85 > 0 THEN
#                   CALL cl_remove_zero(sr.pml85) RETURNING l_pml85
#                   LET l_str4 = l_pml85 , sr.pml83 CLIPPED
#               END IF
#        END CASE
#     ELSE
#     END IF
##No.FUN-580004 --end--
#         # PRINT COLUMN g_c[31],sr.pmk01,'-',sr.pmk03 USING '####',
#         #       COLUMN g_c[32],sr.pmk02,
#         #       COLUMN g_c[33],sr.pmk09,
#         #       COLUMN g_c[34],l_pmc02,
#         #       COLUMN g_c[35],l_pmc03,
#         #       COLUMN g_c[36],sr.pmk22,
#         #       COLUMN g_c[37],sr.pmk12,
#         #       COLUMN g_c[38],l_gen02,
#           PRINT COLUMN g_c[39],sr.pml02 USING '####',
#                 COLUMN g_c[40],sr.pml04 CLIPPED, #FUN-5B0014 [1,20], #No.FUN-580004
#                 COLUMN g_c[41],sr.pml041,
#                 COLUMN g_c[42],l_ima021,
#                 COLUMN g_c[43],l_ima08,
#                 COLUMN g_c[44],l_ima37,
#No.FUN-580004 --start
#                 COLUMN g_c[45],l_str4 CLIPPED,   #No.FUN-580004
#                 COLUMN g_c[46],sr.pml07,
#                 COLUMN g_c[47],sr.pml08,
#                 COLUMN g_c[48],cl_facfor(sr.pml09) CLIPPED,
#                 COLUMN g_c[49],sr.pml18,
#                 COLUMN g_c[50],sr.pml33,
#                 COLUMN g_c[51],sr.pml34,
#                 COLUMN g_c[52],sr.pml35,
#                 COLUMN g_c[53],cl_numfor(sr.pml20,53,3),   #No.MOD-5A0180
#                 COLUMN g_c[54],sr.pml16
##No.FUN-580004 --end--
##FUN-4C0095----
 
##  AFTER GROUP OF sr.pmk01   #No.MOD-5A0180
##        LET g_pageno = 0
 
# ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN
#             PRINT g_dash[1,g_len]
##             IF tm.wc[001,070] > ' ' THEN			# for 80
##	         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##             IF tm.wc[071,140] > ' ' THEN
## 	         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##             IF tm.wc[141,210] > ' ' THEN
## 	         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##             IF tm.wc[211,280] > ' ' THEN
## 	         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##             IF tm.wc[001,120] > ' ' THEN			# for 132
##		 PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##		 PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##		 PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#     #TQC-630166
#      CALL cl_prt_pos_wc(tm.wc)
#     END IF
#     PRINT g_dash #FUN-4C0095
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9), g_x[7] CLIPPED #FUN-4C0095 #No.MOD-5A0180
 
#  PAGE TRAILER
#   IF l_last_sw = 'n'
#       THEN PRINT g_dash
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED #FUN-4C0095 #No.MOD-5A0180
#       ELSE SKIP 2 LINES
#    END IF
# END REPORT
#No.FUN-7C0054---End
#Patch....NO.TQC-610036 <001> #


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
