# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apmg100.4gl
# Descriptions...: 驗收單標籤
# Input parameter:
# Return code....:
# Date & Author..: 91/10/21 By Carol
# Modify ........: 92/12/05 By Apple
# Modify.........: No.FUN-550114 05/06/01 By echo 新增報表備註
# Modify.........: No.MOD-5A0120 05/10/14 By ice 料號/品名/規格欄位放大
# Modify.........: No.TQC-620091 06/02/20 By pengu 輸入QBE條件後即跳出程式
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B60002 11/06/09 By Sakura 報表改為GR呈現
# Modify.........: No.FUN-CA0118 12/10/22 By Sakura 重新過單
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
    	    	wc  	LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(500) # Where condition
      		sub  	LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       		s    	LIKE type_file.chr3,    #No.FUN-680136 VARCHAR(3) type(15)
         	more	LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1) # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE    l_table     STRING,               #FUN-B60002
          g_sql       STRING                #FUN-B60002

#FUN-B60002----------add-------str
TYPE sr1_t RECORD
	order1   LIKE rva_file.rva08,
	order2   LIKE rva_file.rva08,
	order3   LIKE rva_file.rva08,
	rva01    LIKE rva_file.rva01,    #驗收單號
	rva03    LIKE rva_file.rva03,    #優先等級
	rva05    LIKE rva_file.rva05,    #供應商
	pmc03    LIKE pmc_file.pmc03,    #供應商名稱
	rva06    LIKE rva_file.rva06,    #收貨日
	rva07    LIKE rva_file.rva07,    #收貨單號
	rva08    LIKE rva_file.rva08,    #進口報單
	rvb02    LIKE rvb_file.rvb02,    #驗收項次
	rvb03    LIKE rvb_file.rvb03,    #採購項次
	rvb04    LIKE rvb_file.rvb04,    #採購單
	rvb05    LIKE rvb_file.rvb05,    #料件編號
	rvb08    LIKE rvb_file.rvb08,    #收貨數量
	rvb10    LIKE rvb_file.rvb10,    #發票號碼
	rvb11    LIKE rvb_file.rvb11,    #代買項次
	rvb13    LIKE rvb_file.rvb13,    #廠商批號
	rvb14    LIKE rvb_file.rvb14,    #容器號碼
	rvb15    LIKE rvb_file.rvb15,    #容器數量
	rvb16    LIKE rvb_file.rvb16,    #容器數目
	rvb17    LIKE rvb_file.rvb17,    #檢驗批號
	rvb19    LIKE rvb_file.rvb19,    #收貨特性
	rvb22    LIKE rvb_file.rvb22,    #發票號碼
	pmm03    LIKE pmm_file.pmm03,    #更等版本
	pmn011   LIKE pmn_file.pmn011,   #項次性質
	pmn041   LIKE pmn_file.pmn041,   #品名規格
	pmn20    LIKE pmn_file.pmn20,    #訂購量
	pmn41    LIKE pmn_file.pmn41     #工單
END RECORD
#FUN-B60002----------add-------end		  
		  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
	
   #FUN-B60002------add-----str-----
   LET g_sql = "order1.rva_file.rva08,",
			   "order2.rva_file.rva08,",
			   "order3.rva_file.rva08,",
			   "rva01.rva_file.rva01,",
			   "rva03.rva_file.rva03,",
			   "rva05.rva_file.rva05,",
			   "pmc03.pmc_file.pmc03,",
			   "rva06.rva_file.rva06,",
			   "rva07.rva_file.rva07,",
			   "rva08.rva_file.rva08,",
			   "rvb02.rvb_file.rvb02,",
			   "rvb03.rvb_file.rvb03,",
			   "rvb04.rvb_file.rvb04,",
			   "rvb05.rvb_file.rvb05,",
			   "rvb08.rvb_file.rvb08,",
			   "rvb10.rvb_file.rvb10,",
			   "rvb11.rvb_file.rvb11,",
			   "rvb13.rvb_file.rvb13,",
			   "rvb14.rvb_file.rvb14,",
			   "rvb15.rvb_file.rvb15,",
			   "rvb16.rvb_file.rvb16,",
			   "rvb17.rvb_file.rvb17,",
			   "rvb19.rvb_file.rvb19,",
			   "rvb22.rvb_file.rvb22,",
			   "pmm03.pmm_file.pmm03,",
			   "pmn011.pmn_file.pmn011,",
			   "pmn041.pmn_file.pmn041,",
			   "pmn20.pmn_file.pmn20,",
			   "pmn41.pmn_file.pmn41"

   LET l_table = cl_prt_temptable('apmg100',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #FUN-B60002------add-----end-----
 

   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.sub  = ARG_VAL(8)
#---------------No.TQC-610085 modify
   LET tm.s  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
#---------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL g100_tm(0,0)		# Input print condition
      ELSE CALL apmg100()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
   CALL cl_gre_drop_temptable(l_table)  #FUN-B60002 add
END MAIN
 
FUNCTION g100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680136 SMALLINT
          l_cmd		LIKE type_file.chr1000        #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
   OPEN WINDOW g100_w AT p_row,p_col WITH FORM "apm/42f/apmg100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.sub  = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rva01,rva03,rva07,rvb04,rva05,rva08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW g100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table)  #FUN-B60002 add
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.sub,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD sub
         IF tm.sub IS NULL OR tm.sub not matches'[123]'
         THEN NEXT FIELD sub
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
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW g100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table)  #FUN-B60002 add
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='apmg100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmg100','9031',1)
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
                         " '",tm.sub CLIPPED,"'",
                         " '",tm.s CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('apmg100',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW g100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table)  #FUN-B60002 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmg100()
   ERROR ""
END WHILE
   CLOSE WINDOW g100_w
END FUNCTION
 
FUNCTION apmg100()
   DEFINE l_name	LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680136 VARCHAR(20)
          l_time	LIKE type_file.chr8,  	      # Used time for running the job  #No.FUN-680136 VARCHAR(8)
          l_sql 	LIKE type_file.chr1000,	      # RDSQL STATEMENT                #No.FUN-680136 VARCHAR(1000)
          l_za05	LIKE za_file.za05,            #No.FUN-680136 VARCHAR(40)
          l_order	ARRAY[5] OF     LIKE rva_file.rva08,    #No.FUN-680136 VARCHAR(20)
          sr            RECORD order1   LIKE rva_file.rva08,    #No.FUN-680136 VARCHAR(20)
                               order2   LIKE rva_file.rva08,    #No.FUN-680136 VARCHAR(20)
                               order3   LIKE rva_file.rva08,    #No.FUN-680136 VARCHAR(20)
                               rva01    LIKE rva_file.rva01,    #驗收單號
                               rva03    LIKE rva_file.rva03,    #優先等級
                               rva05    LIKE rva_file.rva05,    #供應商
            		       pmc03    LIKE pmc_file.pmc03,    #供應商名稱
                               rva06    LIKE rva_file.rva06,    #收貨日
                               rva07    LIKE rva_file.rva07,    #收貨單號
                               rva08    LIKE rva_file.rva08,    #進口報單
                               rvb02    LIKE rvb_file.rvb02,    #驗收項次
                               rvb03    LIKE rvb_file.rvb03,    #採購項次
                               rvb04    LIKE rvb_file.rvb04,    #採購單
                               rvb05    LIKE rvb_file.rvb05,    #料件編號
                               rvb08    LIKE rvb_file.rvb08,    #收貨數量
                               rvb10    LIKE rvb_file.rvb10,    #發票號碼
                               rvb11    LIKE rvb_file.rvb11,    #代買項次
                               rvb13    LIKE rvb_file.rvb13,    #廠商批號
                               rvb14    LIKE rvb_file.rvb14,    #容器號碼
                               rvb15    LIKE rvb_file.rvb15,    #容器數量
                               rvb16    LIKE rvb_file.rvb16,    #容器數目
                               rvb17    LIKE rvb_file.rvb17,    #檢驗批號
                               rvb19    LIKE rvb_file.rvb19,    #收貨特性
                               rvb22    LIKE rvb_file.rvb22,    #發票號碼
                               pmm03    LIKE pmm_file.pmm03,    #更等版本
                               pmn011   LIKE pmn_file.pmn011,   #項次性質
                               pmn041   LIKE pmn_file.pmn041,   #品名規格
                               pmn20    LIKE pmn_file.pmn20,    #訂購量
                               pmn41    LIKE pmn_file.pmn41     #工單
                        END RECORD
	 CALL cl_del_data(l_table)  #FUN-B60002 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmg100'
#    CALL cl_outnam('apmg100') RETURNING l_name   #No.TQC-620091 add ,#FUN-B60002 mark
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 106 END IF    #No.MOD-5A0120
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR      #FUN-B60002 mark  
#     FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR     #FUN-B60002 mark
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rvauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rvagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rvagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvauser', 'rvagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 " rva01,rva03,rva05,pmc03,rva06,rva07,rva08,",
                 " rvb02,rvb03,rvb04,rvb05,rvb08,rvb10,rvb11,",
                 " rvb13,rvb14,rvb15,rvb16,rvb17,rvb19,rvb22,",
                 " pmm03,pmn011,pmn041,pmn20,pmn41 ",
                 "  FROM rva_file, rvb_file,  ",
                 "  OUTER pmm_file, OUTER pmn_file, OUTER pmc_file",
                 " WHERE rva01 = rvb01 AND rvb_file.rvb04 = pmm_file.pmm01 ",
                 "   AND rvb_file.rvb04 = pmn_file.pmn01 AND rvb_file.rvb03 = pmn_file.pmn02 ",
                 "   AND rva_file.rva05 = pmc_file.pmc01 AND rvaconf !='X'",
                 "   AND ",tm.wc
     IF tm.sub = '1'
     THEN LET l_sql = l_sql clipped," AND rvb19 = '1' "
     END IF
     IF tm.sub = '2'
     THEN LET l_sql = l_sql clipped," AND rvb19 = '2' "
     END IF
     PREPARE g100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        CALL cl_gre_drop_temptable(l_table)  #FUN-B60002 add
        EXIT PROGRAM
           
     END IF
     DECLARE g100_curs1 CURSOR FOR g100_prepare1
 
    #CALL cl_outnam('apmg100') RETURNING l_name    #No.TQC-620091 mark
#    START REPORT g100_rep TO l_name               #FUN-B60002 mark
     LET g_pageno = 0
     FOREACH g100_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#FUN-B60002 mark---------begin       
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.rva01
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.rvb04
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.rva03
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.rva05
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.rva07
#               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.rva08
#               OTHERWISE LET l_order[g_i] = '-'
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT apmg100_rep(sr.*)  #FUN-B60002 alter
#FUN-B60002 mark---------end

#FUN-B60002----------add----begin
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.rva01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.rvb04
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.rva03
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.rva05
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.rva07
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.rva08
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       IF l_order[1] IS NULL THEN LET l_order[1] = ' ' END IF
       IF l_order[2] IS NULL THEN LET l_order[2] = ' ' END IF
       IF l_order[3] IS NULL THEN LET l_order[3] = ' ' END IF

       EXECUTE insert_prep USING l_order[1],l_order[2],l_order[3],
                                 sr.rva01,sr.rva03,sr.rva05,sr.pmc03,sr.rva06,sr.rva07,sr.rva08,
                                 sr.rvb02,sr.rvb03,sr.rvb04,sr.rvb05,sr.rvb08,sr.rvb10,sr.rvb11,
                                 sr.rvb13,sr.rvb14,sr.rvb15,sr.rvb16,sr.rvb17,sr.rvb19,sr.rvb22,
                                 sr.pmm03,sr.pmn011,sr.pmn041,sr.pmn20,sr.pmn41

#FUN-B60002----------add----end 
  
     END FOREACH
 
#    FINISH REPORT g100_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #FUN-B60002 mark
	 CALL apmg100_grdata()                         #FUN-B60002 add
END FUNCTION

#No.FUN-B60002  --begin 
#REPORT g100_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,                    #No.FUN-680136 VARCHAR(1)
#          sr            RECORD order1   LIKE rva_file.rva08,    #No.FUN-680136 VARCHAR(20)
#                               order2   LIKE rva_file.rva08,    #No.FUN-680136 VARCHAR(20)
#                               order3   LIKE rva_file.rva08,    #No.FUN-680136 VARCHAR(20)
#                               rva01    LIKE rva_file.rva01,    #驗收單號
#                               rva03    LIKE rva_file.rva03,    #優先等級
#                               rva05    LIKE rva_file.rva05,    #供應商
#                               pmc03    LIKE pmc_file.pmc03,    #供應商名稱
#                               rva06    LIKE rva_file.rva06,    #收貨日
#                               rva07    LIKE rva_file.rva07,    #收貨單號
#                               rva08    LIKE rva_file.rva08,    #進口報單
#                               rvb02    LIKE rvb_file.rvb02,    #驗收項次
#                               rvb03    LIKE rvb_file.rvb03,    #採購項次
#                               rvb04    LIKE rvb_file.rvb04,    #採購單
#                               rvb05    LIKE rvb_file.rvb05,    #料件編號
#                               rvb08    LIKE rvb_file.rvb08,    #收貨數量
#                               rvb10    LIKE rvb_file.rvb10,    #發票號碼
#                               rvb11    LIKE rvb_file.rvb11,    #代買項次
#                               rvb13    LIKE rvb_file.rvb13,    #容器號碼
#                               rvb14    LIKE rvb_file.rvb14,    #容器號碼
#                               rvb15    LIKE rvb_file.rvb15,    #容器數量
#                               rvb16    LIKE rvb_file.rvb16,    #容器數目
#                               rvb17    LIKE rvb_file.rvb17,    #檢驗批號
#                               rvb19    LIKE rvb_file.rvb19,    #收貨特性
#                               rvb22    LIKE rvb_file.rvb22,    #發票號碼
#                               pmm03    LIKE pmm_file.pmm03,    #更動序號
#                               pmn011   LIKE pmn_file.pmn011,   #項次性質
#                               pmn041   LIKE pmn_file.pmn041,   #品名規格
#                               pmn20    LIKE pmn_file.pmn20,    #訂購量
#                               pmn41    LIKE pmn_file.pmn41     #工單
#                       END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.rva01,sr.rvb02
#  FORMAT
# 
#   ON EVERY ROW
#      PRINT COLUMN  30,g_x[10] clipped
#      PRINT g_dash[1,g_len]
##      PRINT COLUMN  3,g_x[11] clipped,sr.rva01,
##           COLUMN 46,g_x[12] clipped,sr.pmc03
#            COLUMN 72,g_x[12] clipped,sr.pmc03    #No.MOD-5A0120
#      PRINT COLUMN  3,g_x[13] clipped,sr.rva06,
#           COLUMN 46,g_x[17] clipped,sr.rva07
#            COLUMN 72,g_x[17] clipped,sr.rva07    #No.MOD-5A0120
#      PRINT COLUMN  3,g_x[15] clipped,sr.rva03,
#           COLUMN 46,g_x[16] clipped,sr.rva08
#            COLUMN 72,g_x[16] clipped,sr.rva08    #No.MOD-5A0120
#      PRINT g_dash2[1,g_len]
#      PRINT COLUMN  3,g_x[18] clipped,sr.rvb02;
#      IF cl_null(sr.pmm03) THEN
#           PRINT COLUMN 46,g_x[19] clipped,sr.rvb04
#            PRINT COLUMN 72,g_x[19] clipped,sr.rvb04                       #No.MOD-5A0120
#      ELSE
#           PRINT COLUMN 46,g_x[19] clipped,sr.rvb04 clipped,'-',sr.pmm03
#            PRINT COLUMN 72,g_x[19] clipped,sr.rvb04 clipped,'-',sr.pmm03  #No.MOD-5A0120
#      END IF
#      PRINT COLUMN  3,g_x[20] clipped,sr.rvb05;
#     PRINT COLUMN 46,g_x[21] clipped,sr.rvb03
#      PRINT COLUMN 72,g_x[21] clipped,sr.rvb03       #No.MOD-5A0120
# 
#      PRINT COLUMN  3,g_x[22] clipped,sr.pmn041,
#           COLUMN 46,g_x[23] clipped,sr.rvb13
#            COLUMN 72,g_x[23] clipped,sr.rvb13       #No.MOD-5A0120
# 
#      PRINT COLUMN  3,g_x[24] clipped,sr.rvb17,
#           COLUMN 46,g_x[31] clipped,sr.rvb22
#            COLUMN 72,g_x[31] clipped,sr.rvb22       #No.MOD-5A0120
#      IF sr.rvb19 ='2'
#     THEN PRINT COLUMN 46,g_x[29] clipped,sr.pmn41
#      THEN PRINT COLUMN 72,g_x[29] clipped,sr.pmn41  #No.MOD-5A0120
#      ELSE PRINT ''
#      END IF
# 
#      PRINT COLUMN  3,g_x[25] clipped,sr.rvb08;
#      IF sr.rvb19 ='2'
#     THEN PRINT COLUMN 46,g_x[30] clipped,sr.rvb11
#      THEN PRINT COLUMN 72,g_x[30] clipped,sr.rvb11  #No.MOD-5A0120
#      ELSE PRINT ''
#      END IF
# 
#      PRINT g_dash2[1,g_len]
#      PRINT COLUMN 03,g_x[26] clipped,sr.rvb14,
#            COLUMN 25,g_x[27] clipped,sr.rvb15,
#            COLUMN 52,g_x[28] clipped,sr.rvb16
#      PRINT g_dash[1,g_len]
## FUN-550114
#      PRINT g_x[32]
#      PRINT g_memo
## END FUN-550114
# 
#      SKIP 3 LINES
#END REPORT
#No.FUN-B60002  --end
#Patch....NO.TQC-610036 <002> #


#FUN-B60002------add-------str----------
FUNCTION apmg100_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    PREPARE apmg100_precnt FROM l_sql
    EXECUTE apmg100_precnt INTO l_cnt
    IF SQLCA.SQLCODE THEN
        CALL cl_err('apmg100_precnt:', SQLCA.SQLCODE, 1)
        RETURN
    ELSE
        IF l_cnt <= 0 THEN
            CALL cl_msgany(0, 0, "No Data!!")
            RETURN
        END IF
    END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("apmg100")
        IF handler IS NOT NULL THEN
            START REPORT apmg100_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
						" ORDER BY order1,order2,order3,rva01,rvb02"

            DECLARE apmg100_datacur1 CURSOR FROM l_sql
            FOREACH apmg100_datacur1 INTO sr1.*
                OUTPUT TO REPORT apmg100_rep(sr1.*)
            END FOREACH
            FINISH REPORT apmg100_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg100_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE  l_rvb04  STRING
    DEFINE  l_pmn41  LIKE pmn_file.pmn41
    DEFINE  l_pmn41_show  STRING
    DEFINE  l_rvb11  LIKE rvb_file.rvb11
    DEFINE  l_rvb11_show  STRING
    DEFINE l_lineno LIKE type_file.num5

    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            IF cl_null(sr1.pmm03) THEN
                LET l_rvb04 = sr1.rvb04                     
            ELSE
                LET l_rvb04 = sr1.rvb04, "-" ,sr1.pmm03
            END IF
            PRINTX  l_rvb04

            IF sr1.rvb19 ='2' THEN 
                LET l_pmn41 = sr1.pmn41
            ELSE
                LET l_pmn41 =''
            END IF
            PRINTX l_pmn41
            
            #是否顯示工單
            IF sr1.rvb19 ='2' THEN
                LET l_pmn41_show = 'Y'
            ELSE 
                LET l_pmn41_show = 'N'
            END IF
            PRINTX l_pmn41_show

            IF sr1.rvb19 ='2' THEN 
                LET l_rvb11 = sr1.rvb11
            ELSE 
                LET l_rvb11 =''
            END IF
            PRINTX l_rvb11
            
            #是否顯示代買項次
            IF sr1.rvb19 ='2' THEN
                LET l_rvb11_show = 'Y'
            ELSE 
                LET l_rvb11_show = 'N'
            END IF
            PRINTX l_rvb11_show
            

            PRINTX sr1.*

END REPORT

#FUN-B60002------add-------end----------
#FUN-CA0118

