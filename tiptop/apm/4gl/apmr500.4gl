# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmr500.4gl
# Desc/riptions..: 採購清單
# Input parameter:
# Return code....:
# Date & Author..: 91/09/30 By Lin
# Modify.........: No.FUN-4C0095 04/12/31 By Mandy 報表轉XML
# Modify.........: No.MOD-530173 05/03/21 By Mandy Input順序,系統日期沒有show
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-580004 05/08/04 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: NO.MOD-640368 06/04/11 BY yiting 小計錯誤
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.MOD-6C0110 06/12/22 By Sarah 計算sr.g_pmn與sr.amt時,pmn20應改成pmn87
# Modify.........: NO.MOD-710032 07/04/01 BY claire 勾選小計時,資料及小計跳頁分開後造成小計歸 0
# Modify.........: NO.MOD-810086 08/01/11 BY claire 排序異常,因order1,order2,order3長度定義錯誤
# Modify.........: No.FUN-840047 08/04/16 By sherry 報表改由CR輸出  
# Modify.........: No.MOD-870132 08/07/11 By Smapmin 未交量應該要把驗退量加回去
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程 
# Modify.........: No.MOD-960325 09/06/30 By Smapmin 修改核准否的篩選條件
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:FUN-A40073 10/05/05 By liuxqa 追单FUN-950090 
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/29 By vealxu 製造功能優化-平行制程
# Modify.........: No:CHI-A80003 10/08/25 By Summer 調整"報表單價*數量取位後的結果相加總"與"總金額欄位"數值不同
# Modify.........: No:CHI-AA0017 10/11/04 By Summer 增加料件編號開窗功能
# Modify.........: No:TQC-B40066 11/04/11 By lilingyu sql變量長度定義過短
# Modify.........: No:MOD-C80147 12/09/17 By jt_chen 未交量計算應包含退貨換貨量
# Modify.........: No:MOD-C80151 12/11/08 By jt_chen 報表列印出的資料為採購單單身明細,但狀況碼列印為整張採購單的狀況碼(pmm25),調整為改抓單身個別狀況碼(pmn16)做列印
# Modify.........: No:TQC-CC0078 12/12/13 By qirl 欄位開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item    LIKE type_file.num5    #FUN-680136 SMALLINT
END GLOBALS
DEFINE   g_str           STRING                                                 
DEFINE   g_sql           STRING                                                 
DEFINE   l_table         STRING                                                 
 
 
   DEFINE tm  RECORD
	   #	wc   VARCHAR(500),		
		wc  	STRING,		#TQC-630166
                pmn04   LIKE pmn_file.pmn04,
                pmn24   LIKE pmn_file.pmn24,
   		s    	LIKE type_file.chr3,    #FUN-680136 VARCHAR(3) # Order by sequence
   		t    	LIKE type_file.chr3,    #FUN-680136 VARCHAR(3) # Eject sw
   		u    	LIKE type_file.chr3,    #FUN-680136 VARCHAR(3) # 合計
                a       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) # 核准
                b       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) # 確認
                c       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) # 過期
                vdate   LIKE type_file.dat,     #FUN-680136 DATE    # 系統日期
                d       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) # 結案
                e       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) # 取消
                z       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) # 列印採購單小計
                x       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) # 價差率
   		more	LIKE type_file.chr1     #FUN-680136 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
           g_total       LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           g_total1      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6) 
           g_total2      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           g_pmn20       LIKE pmn_file.pmn20,   #MOD-530190
           g_pmn50       LIKE pmn_file.pmn50,   #MOD-530190
          g_aza17        LIKE aza_file.aza17,   # 本國幣別
          g_sw           LIKE type_file.chr1    #FUN-680136 VARCHAR(1) 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
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
 
   LET g_sql = "pmm01.pmm_file.pmm01,",
               "pmm04.pmm_file.pmm04,",
               "pmm03.pmm_file.pmm03,",
               "pmm02.pmm_file.pmm02,",
               "pmm09.pmm_file.pmm09,",
               "pmc03.pmc_file.pmc03,",
               "pmm12.pmm_file.pmm12,",
               "gen02.gen_file.gen02,",
              #"pmm25.pmm_file.pmm25,",   #MOD-C80151 mark
               "pmn16.pmn_file.pmn16,",   #MOD-C80151 add
               "pmm22.pmm_file.pmm22,",
               "pmm21.pmm_file.pmm21,",
               "pmn02.pmn_file.pmn02,",
               "pmn011.pmn_file.pmn011,",
               "pmn04.pmn_file.pmn04,",
               "pmn041.pmn_file.pmn041,",
               "ima021.ima_file.ima021,",
               "pmn24.pmn_file.pmn24,",
               "l_str4.type_file.chr1000,",
               "pmn07.pmn_file.pmn07,",
               "pmn86.pmn_file.pmn86,",
               "l_print.aab_file.aab02,",
               "pmn20.pmn_file.pmn20,",
               "pmn87.pmn_file.pmn87,",
               "qqq.pmn_file.pmn20,",
               "pmn31.pmn_file.pmn31,",
               "g_pmn.pmn_file.pmn31,",
               "pmn44.pmn_file.pmn44,",
               "amt.pmn_file.pmn20,",
               "pmn14.pmn_file.pmn14,",
               "pmn15.pmn_file.pmn15,",
               "pmn33.pmn_file.pmn33,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04"     
 
   LET l_table = cl_prt_temptable('apmr500',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",          
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,? ) "                     
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET tm.b  = ARG_VAL(12)
   LET tm.c  = ARG_VAL(13)
   LET tm.vdate  = ARG_VAL(14)
   LET tm.d  = ARG_VAL(15)
   LET tm.e  = ARG_VAL(16)
   LET tm.z  = ARG_VAL(17)
   LET tm.x  = ARG_VAL(18)
   LET g_rep_user = ARG_VAL(21)
   LET g_rep_clas = ARG_VAL(22)
   LET g_template = ARG_VAL(23)
   LET g_rpt_name = ARG_VAL(24)    #FUN-A40073 add

   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r500_tm(0,0)		# Input print condition
      ELSE CALL r500()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r500_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 11
 
   OPEN WINDOW r500_w AT p_row,p_col WITH FORM "apm/42f/apmr500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.u    = 'Y  '
   LET tm.a    = '3'
   LET tm.b    = '3'
   LET tm.c    = '3'
   LET tm.vdate= g_today
   LET tm.d    = '3'
   LET tm.e    = 'N'
   LET tm.z    = 'N'
   LET tm.x    = '1'
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
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm04,pmm09,pmm12,pmn04,pmn24

     #CHI-AA0017 add --start--
     ON ACTION CONTROLP
        CASE WHEN INFIELD(pmn04) #料件編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
     	      LET g_qryparam.form = "q_ima"
     	      CALL cl_create_qry() RETURNING g_qryparam.multiret
     	      DISPLAY g_qryparam.multiret TO pmn04
     	      NEXT FIELD pmn04
     #--TQC-CC0078--add---star---
              WHEN INFIELD(pmm01)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm011"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm01
              NEXT FIELD pmm01
              WHEN INFIELD(pmm09)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm091"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm09
              NEXT FIELD pmm09
              WHEN INFIELD(pmm12)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm121"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmm12
              NEXT FIELD pmm12
              WHEN INFIELD(pmn24)
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmn24"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmn24
              NEXT FIELD pmn24
     #--TQC-CC0078--add---end---
        OTHERWISE EXIT CASE
        END CASE
     #CHI-AA0017 add --end--

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
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
    DISPLAY BY NAME tm.vdate #MOD-530173
#UI
   INPUT BY NAME
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                  tm.x,tm.e,tm.z,              #MOD-530173
                 tm.a,tm.b,tm.c,tm.d,tm.more
                WITHOUT DEFAULTS
      AFTER FIELD a          #核准
         IF tm.a NOT MATCHES "[123]"
            THEN NEXT FIELD a
         END IF
      AFTER FIELD b          #確認
         IF tm.b NOT MATCHES "[123]"
            THEN NEXT FIELD b
         END IF
      AFTER FIELD c          #過期
         IF tm.c NOT MATCHES "[123]"
            THEN NEXT FIELD c
         END IF
         IF tm.c MATCHES "[12]" THEN
            CALL r500_tm_c()   #輸入系統日期
         END IF
      AFTER FIELD d          #結案
         IF tm.d NOT MATCHES "[123]"
            THEN NEXT FIELD d
         END IF
      AFTER FIELD e          #取消
         IF tm.e NOT MATCHES "[YN]"
            THEN NEXT FIELD e
         END IF
      AFTER FIELD z          #列印採購單小計
         IF tm.z NOT MATCHES "[YN]"
            THEN NEXT FIELD z
         END IF
      AFTER FIELD x          #價差率
         IF tm.x NOT MATCHES "[123]"
            THEN NEXT FIELD x
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r500_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmr500'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr500','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.vdate CLIPPED,"'",
                         " '",tm.d CLIPPED,"'"  ,
                         " '",tm.e CLIPPED,"'",
                         " '",tm.z CLIPPED,"'",
                         " '",tm.x CLIPPED,"'"  ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #FUN-A40073 add
         CALL cl_cmdat('apmr500',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r500_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r500()
   ERROR ""
END WHILE
   CLOSE WINDOW r500_w
END FUNCTION
 
FUNCTION r500_tm_c()  #當選擇'已過期'或'未過期'時必須輸入系統日期
   LET tm.vdate = g_today
   DISPLAY BY NAME tm.vdate      # Condition
   INPUT BY NAME tm.vdate
                WITHOUT DEFAULTS
      AFTER FIELD vdate
         IF tm.vdate IS NULL OR tm.vdate=' '
            THEN NEXT FIELD vdate
         END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0 RETURN
      END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
END FUNCTION
 
FUNCTION r500()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name      #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  		# Used time for running the job #No.FUN-680136 VARCHAR(8)
#         l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT               #No.FUN-680136 VARCHAR(1000)  #TQC-B40066
          l_sql 	STRING,                          #TQC-B40066
          l_chr		LIKE type_file.chr1,            #No.FUN-680136 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,         #No.FUN-680136 VARCHAR(40)
          l_order	ARRAY[6] OF LIKE type_file.chr20,        #FUN-680136 VARCHAR(20) 
          i             LIKE type_file.num5,     #No.FUN-580004  #FUN-680136 SMALLINT
          sr               RECORD order1 LIKE type_file.chr20,   #FUN-680136 VARCHAR(20) 
                                  order2 LIKE type_file.chr20,   #FUN-680136 VARCHAR(20) 
                                  order3 LIKE type_file.chr20,   #FUN-680136 VARCHAR(20) 
                                  pmm01 LIKE pmm_file.pmm01,	# 單號
                                  pmm02 LIKE pmm_file.pmm02, 	# 性質
                                  pmm03 LIKE pmm_file.pmm03, 	# 更動序號
                                  pmm04 LIKE pmm_file.pmm04, 	# 單據日期
                                  pmm09 LIKE pmm_file.pmm09,	# 廠商編號
                                  pmm12 LIKE pmm_file.pmm12,	# 採購員
                                 #pmm25 LIKE pmm_file.pmm25,	# 狀況碼   #MOD-C80151 mark
                                  pmn16 LIKE pmn_file.pmn16,    # 狀況碼   #MOD-C80151 add
                                  pmm22 LIKE pmm_file.pmm22,    # 幣別
                                  pmm21 LIKE pmm_file.pmm21,    # 稅別
                                  pmn02 LIKE pmn_file.pmn02,	# 項次
                                  pmn011 LIKE pmn_file.pmn011,	# 性質
                                  pmn04 LIKE pmn_file.pmn04,	# 料件編號
                                  pmn041 LIKE pmn_file.pmn041,#品名規格
                                  pmn24 LIKE pmn_file.pmn24,	# 請購單號
                                  pmn07 LIKE pmn_file.pmn07,	# 採購單位
                                  pmn20 LIKE pmn_file.pmn20,	# 訂購量
                                  pmn50 LIKE pmn_file.pmn50,	# 收貨量
                                  pmn31 LIKE pmn_file.pmn31,	# 單價
                                  g_pmn LIKE pmn_file.pmn31,    #MOD-530190#金額(單價*訂購量)
                                  pmn14 LIKE pmn_file.pmn14,	# 部份交貨
                                  pmn15 LIKE pmn_file.pmn15,	# 提前交貨
                                  pmn33 LIKE pmn_file.pmn33,	# 交貨日期
                                  pmn44 LIKE pmn_file.pmn44, 	# 本幣單價
                                  ima33 LIKE ima_file.ima33, 	# 銷售單價
                                  ima531 LIKE ima_file.ima531, 	# 最近市價
                                  pmn55 LIKE pmn_file.pmn55,	# 驗退量
                                  pmn58 LIKE pmn_file.pmn58,    # 退貨換貨量 #MOD-C80147 add
                                  ppp   LIKE type_file.num20_6, #FUN-680136 DECIMAL(20,6)  # 本幣未交貨量金額
                                  pmn80 LIKE pmn_file.pmn80,
                                  pmn82 LIKE pmn_file.pmn82,
                                  pmn83 LIKE pmn_file.pmn83,
                                  pmn85 LIKE pmn_file.pmn85,
                                  pmn86 LIKE pmn_file.pmn86,
                                  pmn87 LIKE pmn_file.pmn87,
                                  qqq   LIKE pmn_file.pmn20,  #NO.MOD-640368 
                                  amt   LIKE pmn_file.pmn20   #NO.MOD-640368
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
    DEFINE l_ima021     LIKE ima_file.ima021    
    DEFINE l_pmc03      LIKE pmc_file.pmc03     
    DEFINE l_gen02      LIKE gen_file.gen02     
    DEFINE l_print      LIKE aab_file.aab02 
    DEFINE l_ima906       LIKE ima_file.ima906
    DEFINE l_str4         LIKE type_file.chr1000  
    DEFINE l_pmn85        STRING
    DEFINE l_pmn82        STRING
    DEFINE l_sum_g11      LIKE pmn_file.pmn20
    DEFINE l_sum_g21      LIKE pmn_file.pmn20
    DEFINE l_sum_g31      LIKE pmn_file.pmn20
    DEFINE l_sum_g12      LIKE pmn_file.pmn20
    DEFINE l_sum_g22      LIKE pmn_file.pmn20
    DEFINE l_sum_g32      LIKE pmn_file.pmn20
    DEFINE l_sum_g13      LIKE pmn_file.pmn20
    DEFINE l_sum_g23      LIKE pmn_file.pmn20
    DEFINE l_sum_g33      LIKE pmn_file.pmn20
    DEFINE l_sum_g14      LIKE pmn_file.pmn20
    DEFINE l_sum_g24      LIKE pmn_file.pmn20
    DEFINE l_sum_g34      LIKE pmn_file.pmn20
    DEFINE l_cnt1         LIKE pmn_file.pmn20
    DEFINE l_cnt2         LIKE pmn_file.pmn20
    DEFINE l_cnt3         LIKE pmn_file.pmn20
    DEFINE l_last_sw	LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) 
           l_flag        LIKE type_file.chr1,    #FUN-680136 VARCHAR(1)
           l_ima08       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1)  
           l_ima37       LIKE type_file.chr1,    #FUN-680136 VARCHAR(1)  
           l_str         LIKE type_file.chr1000, #FUN-680136 VARCHAR(50) 
           l_str1        LIKE type_file.chr8,    #FUN-680136 VARCHAR(8)  
           l_str2        LIKE type_file.chr8,    #FUN-680136 VARCHAR(8) 
           l_str3        LIKE type_file.chr8,    #FUN-680136 VARCHAR(8) 
           l_s1          LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) 
           l_s2          LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) 
           l_s3          LIKE type_file.chr1,    #FUN-680136 VARCHAR(1) 
           l_pmn31       LIKE pmn_file.pmn31,
           l_pmn20       LIKE pmn_file.pmn20,   #MOD-530190
           l_pmn201      LIKE pmn_file.pmn20,   #MOD-530190
           l_pmn202      LIKE pmn_file.pmn20,   #MOD-530190
           l_pmn203      LIKE pmn_file.pmn20,   #MOD-530190
           l_pmn50       LIKE pmn_file.pmn50,   #MOD-530190
           l_pmn501      LIKE pmn_file.pmn50,   #MOD-530190
           l_pmn502      LIKE pmn_file.pmn50,   #MOD-530190
           l_pmn503      LIKE pmn_file.pmn50,   #MOD-530190
           l_total       LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6) 
           l_total1      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6) 
           l_total2      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6) 
           l_total3      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6) 
           l_total4      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_total5      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_total6      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_total7      LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_sum         LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_sum1        LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_sum2        LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_sum3        LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_ppp1        LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_ppp2        LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_ppp3        LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_ppp4        LIKE type_file.num20_6,#FUN-680136 DECIMAL(20,6)
           l_qqq         LIKE pmn_file.pmn20,   #MOD-530190
           l_pmh12       LIKE pmh_file.pmh12,
           l_pmh14       LIKE pmh_file.pmh14,
           l_rate        LIKE apa_file.apa16
    DEFINE  l_pmn18   LIKE pmn_file.pmn18,   #No.CHI-8C0017  
            l_pmn41   LIKE pmn_file.pmn41,   #No.CHI-8C0017
            l_pmn43   LIKE pmn_file.pmn43,   #No.CHI-8C0017
            l_pmh21   LIKE pmh_file.pmh21,   #No.CHI-8C0017
            l_pmh22   LIKE pmh_file.pmh22    #No.CHI-8C0017
    DEFINE  l_pmn012  LIKE pmn_file.pmn012   #No.FUN-A60027
 
     CALL cl_del_data(l_table)                   #No.FUN-840047
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 ='apmr500' #No.FUN-840047
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
 
     LET l_sql = "SELECT '','','',",
                 "   pmm01,  pmm02,  pmm03,  pmm04,  pmm09,  pmm12,",
                 "   pmn16,  pmm22,  pmm21,  pmn02,  ",            #MOD-C80151 pmm25 -> pmn16
                 "   pmn011, pmn04,  pmn041, pmn24,  pmn07,  pmn20,",
                 "   pmn50,  pmn31,  ' '  ,  pmn14,  pmn15,",
                 "   pmn33,  pmn44 ,ima33, ima531,pmn55,pmn58,",   #MOD-C80147 add pmn58
                 "   '',pmn80,  pmn82, pmn83,pmn85,pmn86,pmn87,'','',pmn18,pmn41,pmn43,pmn012 ",  #No.FUN-580004 #CHI-8C0017 Add '','',pmn18,pmn41,pmn43  #FUN-A60027 add pmn012
                 " FROM pmm_file,pmn_file,",
                 " OUTER ima_file  ",
                 " WHERE pmm01 = pmn01 AND pmm02 NOT IN ('BKR') " ,
                 " AND pmn_file.pmn04 = ima_file.ima01 AND pmm18 !='X' ",
                 " AND ",tm.wc
        # '1' 已核准 : 簽核碼為'Y' 且應簽核順序 = 已簽核順序  或
        #            簽核碼為'N' 者.
        # '2' 未核准 : 簽核碼為'Y' 且應簽核順序 != 已簽核順序.
         IF tm.a  ='1' THEN LET l_sql =l_sql CLIPPED,  #已核准
            " AND ( pmmmksg ='N' OR ( pmmmksg='Y' AND pmn16 NOT IN ('0','S','R','W')) ) "   #MOD-960325   #MOD-C80151 pmm25 -> pmn16
         ELSE
            IF tm.a  ='2' THEN LET l_sql =l_sql CLIPPED,  #未核准
             " AND  ( pmmmksg='Y' AND pmn16 IN ('0','S','R','W')  ) "   #MOD-960325   #MOD-C80151 pmm25 -> pmn16
            END IF
         END IF
        # '1' 已確認 : 確認碼為'Y'者.
        # '2' 未確認 : 確認碼為'N'者.
         IF tm.b  ='1' THEN LET l_sql =l_sql CLIPPED, " AND pmn11='Y'  "
         ELSE                                          #未確認
            IF tm.b  ='2' THEN LET l_sql =l_sql CLIPPED, " AND  pmn11='N'  "
            END IF
         END IF
         # '1' 已過期 : 到廠日期 > 系統日期者.
         # '2' 未過期 : 到廠日期 <= 系統日期者.
         IF tm.c  ='1' THEN LET l_sql =l_sql CLIPPED,
              " AND pmn34 > '",tm.vdate,"' "
         ELSE
            IF tm.c  ='2' THEN LET l_sql =l_sql CLIPPED,
                 " AND pmn34 <= '",tm.vdate,"' "
            END IF
         END IF
        # '1' 已結案 : 狀況碼屬於'6','7','8'者.
        # '2' 未結案 : 狀況碼不屬於'6','7','8'者.
         IF tm.d  ='1' THEN LET l_sql =l_sql CLIPPED,
              " AND pmn16 IN ('6','7','8')  "
         ELSE
            IF tm.d  ='2' THEN LET l_sql =l_sql CLIPPED,
                  " AND pmn16 NOT IN ('6','7','8')  "
            END IF
         END IF
         IF tm.e  ='N' THEN LET l_sql =l_sql CLIPPED,
               " AND  pmn16 != '9' "
         END IF
     LET  g_total = 0
     LET  g_total1 = 0
     LET  g_total2 = 0
     LET  g_pmn20 = 0
     LET  g_pmn50 = 0
 
     PREPARE r500_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r500_cs1 CURSOR FOR r500_prepare1
     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
             LET l_name = 'apmr500'
     ELSE
             LET l_name = 'apmr500_1'
     END IF
 
     FOREACH r500_cs1 INTO sr.*,l_pmn18,l_pmn41,l_pmn43,l_pmn012        #CHI-8C0017 Add l_pmn18,l_pmn41,l_pmn43  #FUN-A60027 add l_pmn012
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.pmm01 IS NULL THEN LET sr.pmm01=' ' END IF
       IF sr.pmm04 IS NULL THEN LET sr.pmm04=' ' END IF
       IF sr.pmm09 IS NULL THEN LET sr.pmm09=' ' END IF
       IF sr.pmm12 IS NULL THEN LET sr.pmm12=' ' END IF
       IF cl_null(sr.ima33) THEN LET sr.ima33 = 0 END IF
       IF cl_null(sr.ima531) THEN LET sr.ima531 = 0 END IF
       IF sr.pmn20 - sr.pmn50 <= 0 THEN                 #NO.MOD-640368
          LET sr.ppp = 0
       ELSE
          LET sr.ppp = sr.pmn44 * (sr.pmn20 - sr.pmn50)
          IF cl_null(sr.ppp) THEN LET sr.ppp = 0 END IF  #NO.MOD-640368
       END IF
       IF sr.pmn20-(sr.pmn50-sr.pmn55-sr.pmn58) < =0 THEN   #MOD-870132   #MOD-C80147 pmn58
          LET sr.qqq = 0       #未交量
       ELSE
          LET sr.qqq = sr.pmn20 -(sr.pmn50 - sr.pmn55 - sr.pmn58)   #MOD-870132   #MOD-C80147 pmn58
       END IF
       IF sr.pmn31 IS NULL THEN LET sr.pmn31=0  END IF
       IF sr.pmn20 IS NULL THEN LET sr.pmn20=0  END IF
       IF sr.pmn44 IS NULL THEN LET sr.pmn44=0  END IF
       LET sr.g_pmn =  sr.pmn31 * sr.pmn87   #MOD-6C0110 modify sr.pmn20->sr.pmn87
       LET sr.amt   =  sr.pmn44 * sr.pmn87   #MOD-6C0110 modify sr.pmn20->sr.pmn87
       LET sr.amt   =  cl_digcut(sr.amt,g_azi04) #CHI-A80003 add
       IF cl_null(sr.g_pmn) THEN LET sr.g_pmn = 0 END IF
       IF cl_null(sr.amt) THEN LET sr.amt = 0 END IF
       LET l_total=0
       LET l_pmn20=0
       LET l_pmn50=0
       LET l_sum_g11 = 0
       LET l_sum_g21 = 0
       LET l_sum_g31 = 0
       LET l_sum_g12 = 0
       LET l_sum_g22 = 0
       LET l_sum_g32 = 0
       LET l_sum_g13 = 0
       LET l_sum_g23 = 0
       LET l_sum_g33 = 0
       LET l_cnt1 = 0
       LET l_cnt2 = 0
       LET l_cnt3 = 0
       SELECT pmc03 INTO l_pmc03 FROM pmc_file
        WHERE pmc01 = sr.pmm09
       IF SQLCA.sqlcode THEN
           LET l_pmc03 = NULL
       END IF
       SELECT gen02 INTO l_gen02 FROM gen_file
        WHERE gen01 = sr.pmm12
       IF SQLCA.sqlcode THEN
           LET l_gen02 = NULL
       END IF
       IF tm.x = '3' THEN
         IF sr.pmm02='SUB' THEN
            LET l_pmh22='2'
            IF l_pmn43 = 0 OR cl_null(l_pmn43) THEN  
               LET l_pmh21 =' '
            ELSE
              IF NOT cl_null(l_pmn18) THEN
               SELECT sgm04 INTO l_pmh21 FROM sgm_file
                WHERE sgm01=l_pmn18
                  AND sgm02=l_pmn41
                  AND sgm03=l_pmn43
                  AND sgm012 = l_pmn012   #FUN-A60076   
              ELSE
               SELECT ecm04 INTO l_pmh21 FROM ecm_file 
                WHERE ecm01=l_pmn41
                  AND ecm03=l_pmn43
                  AND ecm012 = l_pmn012   #FUN-A60027
              END IF
            END IF       #TQC-910033  
         ELSE
            LET l_pmh22='1'
            LET l_pmh21=' '
         END IF
         SELECT pmh12, pmh14
           INTO l_pmh12, l_pmh14
           FROM pmh_file
           WHERE pmh01 = sr.pmn04    
           AND   pmh02 = sr.pmm09   
           AND   pmh13 = sr.pmm22
           AND   pmh21 = l_pmh21                                                         #CHI-8C0017
           AND   pmh22 = l_pmh22                                                         #CHI-8C0017
           AND   pmh23 = ' '                                             #No.CHI-960033
           AND   pmhacti = 'Y'                                           #CHI-910021           
       END IF
       LET l_flag = 'N'
       IF  tm.x = '1' AND sr.ima33 != 0 THEN
           LET l_rate = (sr.pmn44-sr.ima33)/sr.ima33*100
           LET l_flag = 'Y'
       END IF
       IF  tm.x = '2' AND sr.ima531 != 0 THEN
           LET tm.x = '2' LET l_rate = (sr.pmn44-sr.ima531)/sr.ima531*100
           LET l_flag = 'Y'
       END IF
       IF  tm.x = '3' AND ( NOT cl_null(l_pmh12) OR l_pmh12*l_pmh14 != 0 ) THEN
           LET tm.x = '3' LET l_rate = (sr.pmn44-l_pmh12*l_pmh14)/l_pmh12*l_pmh14*100
           LET l_flag = 'Y'
       END IF
       SELECT azi03,azi04,azi05
         INTO t_azi03,t_azi04,t_azi05         
         FROM azi_file
        WHERE azi01=sr.pmm22 
       IF NOT cl_null(l_rate) AND l_flag ='Y' THEN
          LET l_print = l_rate USING '#&.&&','%'
       END IF
       SELECT ima021
         INTO l_ima021
         FROM ima_file
        WHERE ima01=sr.pmn04
       IF SQLCA.sqlcode THEN
           LET l_ima021 = NULL
       END IF
 
       SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01=sr.pmn04
       LET l_str4 = ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906
             WHEN "2"
                 CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                 LET l_str4 = l_pmn85 , sr.pmn83 CLIPPED
                 IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                     CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                     LET l_str4 = l_pmn82, sr.pmn80 CLIPPED
                 ELSE
                    IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                       CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                       LET l_str4 = l_str4 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                    END IF
                 END IF
             WHEN "3"
                 IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                     CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                     LET l_str4 = l_pmn85 , sr.pmn83 CLIPPED
                 END IF
          END CASE
       ELSE
       END IF
       IF g_sma.sma116 MATCHES '[13]' THEN    
            IF sr.pmn07 <> sr.pmn86 THEN    
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
               LET l_str4 = l_str4 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
            END IF
       END IF
       LET l_cnt1 = l_cnt1 + sr.amt                  
       LET l_cnt2 = l_cnt2 + (sr.qqq * sr.pmn44)     
       EXECUTE insert_prep USING sr.pmm01,sr.pmm04,sr.pmm03,sr.pmm02,sr.pmm09,
                                 l_pmc03,sr.pmm12,l_gen02,sr.pmn16,sr.pmm22,     #MOD-C80151 pmm25 -> pmn16
                                 sr.pmm21,sr.pmn02,sr.pmn011,sr.pmn04,sr.pmn041,
                                 l_ima021,sr.pmn24,l_str4,sr.pmn07,sr.pmn86,
                                 l_print,sr.pmn20,sr.pmn87,sr.qqq,sr.pmn31,
                                 sr.g_pmn,sr.pmn44,sr.amt,sr.pmn14,sr.pmn15,
                                 sr.pmn33,t_azi03,t_azi04      
     END FOREACH
 
     IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(tm.wc,'pmm01,pmm04,pmm09,pmm12,pmn04,pmn24')                          
             RETURNING g_str                                                    
     END IF                                                                     
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1]
                 ,";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",tm.u[2,2],";",
                 tm.u[3,3],";",g_aza.aza17,";",g_azi05,";",tm.z,";",g_sma.sma116
                 ,";",g_azi03,";",g_azi04,";",tm.a,";",tm.b,";",tm.c,";",tm.d                                
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED         
     CALL cl_prt_cs3('apmr500',l_name,l_sql,g_str)                           
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
