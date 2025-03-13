# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: abmr802.4gl
# Descriptions...: 尾階材料用量明細表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/07 By Lee
# Modify.........: 92/03/27 By Nora
#                  Add 主件料號數量
# Modify.........: 92/10/28 By Apple
# Modify.........: 94/08/16 By Danny 改由bmt_file取插件位置
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號開窗
# Modify.........: No.FUN-510033 05/02/17 By Mandy 報表轉XML
# Modify.........: No.FUN-550093 05/05/27 By kim 配方BOM
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.TQC-660046 06/06/23 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-6C0014 07/01/04 By Jackho 報表頭尾修改
# Modify.........: No.CHI-6A0034 07/01/30 By jamie abmq602->abmr802 
# Modify.........: No.TQC-7A0013 07/10/09 By dxfwo 轉CR
# Modify.........: No.FUN-7A0069 07/10/31 By jamie "主件編號"開窗資料應參考bma單頭的主件
# Modify.........: No.CHI-810006 08/01/24 By zhoufeng 調整插件位置及說明的列印  
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0161 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-A40058 10/04/27 By lilingyu bmb16增加規格替代的內容
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-C50120 12/05/15 By fengrui 抓BOM資料時，除去無效資料
# Modify.........: No:MOD-D10142 13/01/28 By bart "主件料件數量"同sfb08可入小數位數

DATABASE ds
#CHI-6A0034 add
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
	    	wc  	  VARCHAR(500),	# Where condition
   	    	revision  VARCHAR(02),		# 版本
       		effective DATE,   		# 有效日期
          	#a         INTEGER,      # Assembly Part QTY  #MOD-D10142
            a         LIKE sfb_file.sfb08,    #MOD-D10142
           	s         VARCHAR(1),      # Sort Sequence
           	b         VARCHAR(1),      # 是否列印說明資料
           	c         VARCHAR(1),      # 是否列印說明資料
       		more	  VARCHAR(1) 		# Input more condition(Y/N)
            END RECORD,
		g_tot INTEGER,
        g_bma01_a       LIKE bma_file.bma01,
        g_bma06         LIKE bma_file.bma06 #FUN-550093
 
DEFINE   g_chr           VARCHAR(1)
DEFINE   g_cnt           INTEGER
DEFINE   g_i             SMALLINT   #count/index for any purpose
DEFINE   l_table1        STRING     #No.TQC-7A0013                                                                                     
DEFINE   l_table2        STRING     #No.TQC-7A0013                                                                                     
DEFINE   l_table3        STRING     #No.TQC-7A0013                                                                                     
DEFINE   l_table4        STRING     #No.TQC-7A0013                                                                                     
DEFINE   g_str           STRING     #No.TQC-7A0013                                                                                     
DEFINE   g_sql           STRING     #No.TQC-7A0013
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   #No.TQC-7A0013  --Begin                                                                                                          
   LET g_sql = " p_bma01_a.bma_file.bma01,",                                                                                        
               " g_bma06_a.bma_file.bma06,",                                                                                        
               " p_level.type_file.num5,",                                                                                          
               " p_i.type_file.num5,",                                                                                              
               " p_total.csa_file.csa0301,",                                                                                        
               " order1.bmb_file.bmb03,",
               " l_ima05.ima_file.ima05,",
               " l_ima08.ima_file.ima08,",                                                                                                                                                                                   
               " l_ima63.ima_file.ima63,",                                                                                          
               " l_ima55.ima_file.ima55,",   
               " l_ima02.ima_file.ima02,",                                                                                          
               " l_ima021.ima_file.ima021,",
               " p_acode.bma_file.bma06,",                                                                                         
               " bmb02.bmb_file.bmb02,",                                                                                          
               " bmb03.bmb_file.bmb03,",                                                                                          
               " ima08.ima_file.ima08,",
               " bmb10.bmb_file.bmb10,",
               " bmb04.bmb_file.bmb04,",
               " bmb08.bmb_file.bmb08,",
               " bmb16.bmb_file.bmb16,",
               " ima15.ima_file.ima15,",
               " ima02.ima_file.ima02,",
               " bmb05.bmb_file.bmb05,",
               " ima021.ima_file.ima021,",                                                                                        
               " bmb01.bmb_file.bmb01,",                                                                                            
               " bmb29.bmb_file.bmb29,",                                                                                         
               " l_ver.ima_file.ima05   "                                                                                           
                                                                                                                                    
   LET l_table1 = cl_prt_temptable('abmr8021',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                        
                                                                                                                                    
   LET g_sql = " bmt01.bmt_file.bmt01,",                                                                                            
               " bmt02.bmt_file.bmt02,",                                                                                            
               " bmt03.bmt_file.bmt03,",                                                                                            
               " bmt04.bmt_file.bmt04,",                                                                                            
               " bmt08.bmt_file.bmt08,",                                                                                            
               " bmt05.bmt_file.bmt05,",                                                                                            
#               " bmt06.bmt_file.bmt06 "            #No.CHI-810006                                                                                 
               " bmt06.type_file.chr1000 "          #No.CHI-810006
                                                                                                                                     
   LET l_table2 = cl_prt_temptable('abmr8022',g_sql) CLIPPED                                                                        
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   LET g_sql = " bmc01.bmc_file.bmc01,",                                                                                            
               " bmc02 .bmc_file.bmc02 ,",                                                                                          
               " bmc021.bmc_file.bmc021,",                                                                                          
               " bmc03.bmc_file.bmc03,",                                                                                            
               " bmc06.bmc_file.bmc06,",                                                                                            
               " bmc04.bmc_file.bmc04,",                                                                                            
#               " bmc05.bmc_file.bmc05 "            #No.CHI-810006
               " bmc05.type_file.chr1000 "          #No.CHI-810006                                                                                 
                                                                                                                                    
   LET l_table3 = cl_prt_temptable('abmr8023',g_sql) CLIPPED                                                                        
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
   #No.TQC-7A0013  --End
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.revision  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.a  = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)
   LET tm.c  = ARG_VAL(12)
   LET tm.b  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r802_tm(0,0)			# Input print condition
      ELSE CALL r802()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION r802_tm(p_row,p_col)
   DEFINE   p_row,p_col	  SMALLINT,
            l_flag        SMALLINT,
            l_one         VARCHAR(01),          	#資料筆數
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_bma01       LIKE bma_file.bma01,	#
            l_bma06       LIKE bma_file.bma06,	#FUN-550093
            l_cmd	  VARCHAR(1000),
            l_sql         STRING                #FUN-550093
 
 
   IF p_row = 0 THEN
      LET p_row = 4
      LET p_col = 9
   END IF
   LET p_row = 4
   LET p_col = 9
 
   OPEN WINDOW r802_w AT p_row,p_col WITH FORM "abm/42f/abmr802"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.effective = g_today	#有效日期
   LET tm.a = 1
   LET tm.s = g_sma.sma65
   LET tm.c = 'N'
   LET tm.b = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bma01,ima06,ima09,ima10,ima11,ima12,bma06 FROM item,class,ima09,ima10,ima11,ima12,bma06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
   #--No.FUN-4B0022-------
   ON ACTION CONTROLP
     CASE WHEN INFIELD(item)      #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
              #LET g_qryparam.form = "q_ima1"   #FUN_7A0069 mod
               LET g_qryparam.form = "q_bma2"   #FUN-7A0069 mod
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO item
               NEXT FIELD item
     OTHERWISE EXIT CASE
     END CASE
   #--END---------------
   ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
END CONSTRUCT
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         #FUN-550093................begin
        #LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01 ",
        #          " FROM bma_file,ima_file",
        #          " WHERE bma01=ima01 AND ima08 != 'A' AND ",
        #          tm.wc CLIPPED," GROUP BY bma01"
         LET l_cmd="SELECT DISTINCT bma01,bma06 ",
                   " FROM bma_file,ima_file",
                   " WHERE bma01=ima01 AND ima08 != 'A' AND ",
                   tm.wc CLIPPED," GROUP BY bma01,bma06"
         #FUN-550093................end
         PREPARE r802_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('P0:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
            EXIT PROGRAM
         END IF
         DECLARE r802_cnt
         CURSOR FOR r802_precnt
         OPEN r802_cnt
         #FUN-550093................begin
        #FETCH r802_cnt INTO g_cnt,l_bma01
         FETCH r802_cnt INTO l_bma01,l_bma06
         DROP TABLE r802_cnttemp

#FUN-A40058 --BEGIN-- 創建臨時表,改成LIKE XXX_FILE.XXX的格式
#         CREATE TEMP TABLE r802_cnttemp (
#                    bma01 VARCHAR(40),   #No.FUN-560074
#                    bma06 VARCHAR(20))

         CREATE TEMP TABLE r802_cnttemp (
                    bma01 LIKE type_file.chr50, 
                    bma06 LIKE type_file.chr20)
#FUN-A40058 --END--

         LET l_sql="INSERT INTO r802_cnttemp ",l_cmd
         PREPARE r802_cnttemp_sql FROM l_sql
         EXECUTE r802_cnttemp_sql
         SELECT COUNT(*) INTO g_cnt FROM r802_cnttemp
         #FUN-550093................end
 
         IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2602',0)   
            CONTINUE WHILE
         ELSE
            #LET g_cnt=sqlca.sqlerrd[3]
            IF g_cnt=1 THEN
               LET l_one='Y'
            END IF
         END IF
      END IF
 
      INPUT BY NAME tm.revision,tm.effective,tm.a,
               tm.s,tm.c,tm.b,tm.more WITHOUT DEFAULTS
 
         BEFORE FIELD revision
            IF l_one='N' THEN
               NEXT FIELD effective
            END IF
 
         AFTER FIELD revision
            IF tm.revision IS NOT NULL THEN
               CALL s_version(l_bma01,tm.revision)
               RETURNING l_bdate,l_edate,l_flag
               LET tm.effective = l_bdate
               DISPLAY BY NAME tm.effective
            END IF
 
         AFTER FIELD a
            IF tm.a IS NULL OR tm.a < 0 THEN
               LET tm.a = 1
               DISPLAY BY NAME tm.a
            END IF
 
         AFTER FIELD s
            IF tm.s IS NULL OR tm.s NOT MATCHES'[1-3]' THEN
               NEXT FIELD s
            END IF
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES'[YNyn]' THEN
               NEXT FIELD c
            END IF
 
         AFTER FIELD b
            IF tm.b IS NULL OR tm.b NOT MATCHES'[YNyn]' THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmr802'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('abmr802','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.revision CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('abmr802',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r802_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r802()
      ERROR ""
   END WHILE
   CLOSE WINDOW r802_w
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
FUNCTION r802()
   DEFINE l_name VARCHAR(20),		# External(Disk) file name
          l_time VARCHAR(8),		# Usima time for running the job
       #  l_ute_flag    VARCHAR(2),              #FUN-A40058
          l_ute_flag    LIKE type_file.chr3,     #FUN-A40058  
          l_cmd         STRING,                 #No.TQC-7A0013 
          l_sql  VARCHAR(1000),		# RDSQL STATEMENT
          l_za05 VARCHAR(40),
          l_bma01 LIKE bma_file.bma01,          #主件料件
          l_bma06 LIKE bma_file.bma06           #FUN-550093
 
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同部門的資料
     #         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
     #End:FUN-980030
 
    #FUN-550093................begin
    #LET l_sql = "SELECT bma01",
    #            " FROM bma_file, ima_file",
    #            " WHERE bma01 = ima01",
    #            " AND ",tm.wc,
    #            " ORDER BY 1 "
     LET l_sql = "SELECT bma01,bma06",
                 " FROM bma_file, ima_file",
                 " WHERE bma01 = ima01",
                 " AND ",tm.wc,
                 " ORDER BY bma01,bma06 "
    #FUN-550093................begin
     PREPARE r802_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
	CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r802_c1 CURSOR FOR r802_prepare1
 
#    CALL cl_outnam('abmr802') RETURNING l_name  #No.TQC-7A0013
#  	START REPORT r802_rep TO l_name          #No.TQC-7A0013 
     #No.TQC-7A0013  --Begin
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ? ) " 
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?  )        "
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?  )        "
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#    CALL r802_cur()
#---->產品結構插件位置
     LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                  " WHERE bmt01=?  AND bmt02= ? AND ",
                  " bmt03=? AND ",
                  " (bmt04 IS NULL OR bmt04 >= ?) ",
                  " AND bmt08 = ? ", #FUN-550093
                  " ORDER BY 1"
     PREPARE r802_prebmt     FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r802_bmt  CURSOR FOR r802_prebmt
#---->產品結構說明資料
     LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                  " WHERE bmc01=?  AND bmc02= ? AND ",
                  " bmc021=? AND ",
                  " (bmc03 IS NULL OR bmc03 >= ?) ",
                  " AND bmc06 = ? ", #FUN-550093
                  " ORDER BY 1"
     PREPARE r802_prebmc    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE r802_bmc CURSOR FOR r802_prebmc
     #No.TQC-7A0013  --End 
 
	LET g_tot=0
    FOREACH r802_c1 INTO l_bma01,l_bma06
      IF SQLCA.sqlcode THEN
	 CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_bma01_a=l_bma01
      LET g_bma06  =l_bma06
      CALL r802_bom(0,l_bma01,tm.a,l_bma06)
    END FOREACH
 
     #No.TQC-7A0013  --Begin 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'bma01,ima06,ima09,ima10,ima11,
        ima12,bma06 FROM item,class,ima09,ima10,ima11,ima12,bma06')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.effective,";",tm.a,";",tm.c,";",tm.b
     CALL cl_prt_cs3('abmr802','abmr802',g_sql,g_str)
  
#  FINISH REPORT r802_rep
            LET INT_FLAG = 0  ######add for prompt bug
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
     #No.TQC-7A0013  --End  
END FUNCTION
 
FUNCTION r802_bom(p_level,p_key,p_total,p_acode)
   DEFINE p_level	SMALLINT,
          p_total       DECIMAL(13,5),
          p_acode       LIKE bma_file.bma06,
          p_bma01_a     LIKE bma_file.bma01,
          l_total       DECIMAL(13,5),
          p_key		LIKE bma_file.bma01,  #主件料件編號
          l_ac,i	SMALLINT,
          arrno		SMALLINT,	#BUFFER SIZE (可存筆數)
          b_seq	 VARCHAR(18),#當BUFFER滿時,重新讀單身之起始序號
          l_chr,l_cnt   VARCHAR(1),
          l_fac         DEC(13,5),
          l_ima06   LIKE ima_file.ima06,    #分群碼
          l_bmaacti LIKE bma_file.bmaacti,  #TQC-C50120 add
          sr DYNAMIC ARRAY OF RECORD        #每階存放資料
              order1 VARCHAR(20),
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb01 LIKE bmb_file.bmb01,    #本階主件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb14 LIKE bmb_file.bmb14,    #
              bmb15 LIKE bmb_file.bmb15,    #
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb17 LIKE bmb_file.bmb17,    #
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima55 LIKE ima_file.ima55,    #生產單位
              ima63 LIKE ima_file.ima63,    #發料單位
         #    rowid_no  VARCHAR(18),        #No.TQC-9A0161
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          l_cmd	 VARCHAR(1000),
          l_ima02 LIKE ima_file.ima02,      #品名規格                                                                               
          l_ima021 LIKE ima_file.ima02,      #品名規格                                                                              
          l_ima05 LIKE ima_file.ima05,      #版本                                                                                   
          l_ima08 LIKE ima_file.ima08,      #來源                                                                                   
          l_ima63 LIKE ima_file.ima63,      #發料單位                                                                               
          l_ima55 LIKE ima_file.ima55,      #生產單位                                                                               
          l_ver   LIKE ima_file.ima05,                                                                                              
          l_bmt05 LIKE bmt_file.bmt05,                                                                                              
          l_bmt06 ARRAY[200] OF VARCHAR(20),  #插件位置                                                                                
          l_bmc04 LIKE bmc_file.bmc04,                                                                                              
#          l_bmc05 LIKE bmc_file.bmc05,     #說明        #No.CHI-810006                                                                            
          l_bmt06_s      VARCHAR(20),                                                                                                  
          l_bmtstr       VARCHAR(20),                                                                                                  
       #  l_ute_flag   VARCHAR(2)                #FUN-A40058 
          l_ute_flag   LIKE type_file.chr3       #FUN-A40058  
          #No.CHI-810006 --start--                                              
          DEFINE                                                                
          l_now,l_now2  SMALLINT,                                               
          l_byte,l_len   SMALLINT,                                              
          l_bmc05 ARRAY[200] OF VARCHAR(10),                                       
          l_bmc051 ARRAY[200] OF VARCHAR(30)                                       
          #No.CHI-810006 --end--
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
 

    #TQC-C50120--add--str--
    LET l_bmaacti = NULL
    SELECT bmaacti INTO l_bmaacti
      FROM bma_file
     WHERE bma01 = p_key
       AND bma06 = p_acode 
    IF l_bmaacti <> 'Y' THEN RETURN END IF
    #TQC-C50120--add--end--
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
    END IF
    LET arrno = 602
 
    WHILE TRUE
        LET l_cmd=
            "SELECT '',bma01, bmb01, bmb02, bmb03, bmb04, bmb05,",
            "       (bmb06/bmb07),  bmb08, bmb09, bmb10,",
            "       bmb13,bmb14, bmb15, bmb16, bmb17,",
          # "ima02,ima021,ima05, ima08, ima15,ima55,ima63,bmb_file.rowid,bmb29",  #No.TQC-9A0161
            "ima02,ima021,ima05, ima08, ima15,ima55,ima63,bmb29",                 #No.TQC-9A0161
            "  FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01 LEFT OUTER JOIN bma_file ON bmb03 = bma01",
            " WHERE bmb01='", p_key,"' ",#AND bmb_file.rowid >",b_seq,
            "   AND bmb29 = '",p_acode,"'" #FUN-550093
 
        #生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED,
                      " AND (bmb04 <='",tm.effective,"' OR bmb04 IS NULL)",
                      " AND (bmb05 > '",tm.effective,"' OR bmb05 IS NULL)"
        END IF
        #---->排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY 19"
        PREPARE r802_precur FROM l_cmd
        IF SQLCA.sqlcode THEN
	   CALL cl_err('P1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
           EXIT PROGRAM
        END IF
        DECLARE r802_cur CURSOR FOR r802_precur
        LET l_ac = 1
        FOREACH r802_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
           #FUN-8B0015--BEGIN--
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #FUN-8B0015--END--
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac = arrno THEN EXIT FOREACH END IF
         END FOREACH
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            LET l_fac = 1
            IF sr[i].ima55 !=sr[i].bmb10 THEN
               CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,sr[i].ima55)
                    RETURNING l_cnt,l_fac    #單位換算
               IF l_cnt = '1'  THEN #有問題
                  CALL cl_err(sr[i].bmb03,'abm-731',1)
                  LET g_success = 'N'
                  EXIT FOR
                  RETURN
               END IF
            END IF
           #與多階展開不同之處理在此:
           #尾階在展開時, 其展開之
            IF sr[i].bma01 IS NOT NULL THEN         #若為主件(有BOM單頭)
               #CALL r802_bom(p_level,sr[i].bmb03,p_total*sr[i].bmb06*l_fac,' ') #FUN-8B0015
                CALL r802_bom(p_level,sr[i].bmb03,p_total*sr[i].bmb06*l_fac,l_ima910[i])#FUN-8B0015
            ELSE
                LET l_total=p_total*sr[i].bmb06
                CASE tm.s
                  WHEN '1'  LET sr[i].order1 = sr[i].bmb02 USING'#####'
                  WHEN '2'  LET sr[i].order1 = sr[i].bmb03
                  WHEN '3'  LET sr[i].order1 = sr[i].bmb13
                  OTHERWISE  LET sr[i].order1 = sr[i].bmb03
                END CASE
                LET l_ute_flag='USZ'                          #FUN-A40058 add 'Z'                                                                                                       
                #No.TQC-7A0013         ---Begin
                #---->改變替代特性的表示方式                                                                                              
                IF sr[i].bmb16 MATCHES '[127]' THEN           #FUN-A40058 add '7'                                                                                  
                   LET g_cnt=sr[i].bmb16 USING '&'                                                                                          
                   LET sr[i].bmb16=l_ute_flag[g_cnt,g_cnt]                                                                                  
                ELSE                                                                                                                      
                   LET sr[i].bmb16=' '                                                                                                      
                END IF
                CALL s_effver(p_bma01_a,tm.effective) RETURNING l_ver                                                                         
                                                                                                                                    
                SELECT ima02,ima021,ima05,ima08,ima63,ima55                                                                                   
                INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55                                                                       
                FROM ima_file                                                                                                               
                WHERE ima01 = g_bma01_a                                                                                                      
                IF SQLCA.sqlcode THEN                                                                                                         
                LET l_ima02='' LET l_ima05='' LET l_ima08=''                                                                               
                LET l_ima63='' LET l_ima55=''                                                                                              
                END IF
#               OUTPUT TO REPORT r802_rep(p_level,i,l_total,sr[i].*,g_bma01_a,g_bma06) #FUN-550093
                EXECUTE insert_prep USING g_bma01_a,g_bma06,p_level,i,                                                            
                        l_total,sr[i].order1,l_ima05,l_ima08,l_ima63,                                                                   
                        l_ima55,l_ima02,l_ima021,p_acode,sr[i].bmb02,                                                                    
                        sr[i].bmb03,sr[i].ima08,sr[i].bmb10,sr[i].bmb04,sr[i].bmb08,
                        sr[i].bmb16,sr[i].ima15,sr[i].ima02,
                        sr[i].bmb05,sr[i].ima021,sr[i].bmb01,sr[i].bmb29,l_ver                                                                  
                #子報表-插件                                                                                                        
                #No.CHI-810006  --add--                                         
                IF tm.c = 'Y' THEN                                              
                   FOR g_cnt=1 TO 200                                           
                       LET l_bmt06[g_cnt]=NULL                                  
                   END FOR                                                      
                   LET l_now2=1                                                 
                   LET l_len =20                                                
                   LET l_bmtstr = ''                                            
                #No.CHI-810006 --end-- 
                   FOREACH r802_bmt                                                                                                    
                   USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,                                                                          
                         sr[i].bmb04,sr[i].bmb29                                                                                       
                   INTO l_bmt05,l_bmt06_s                                                                                              
                      IF SQLCA.sqlcode THEN                                                                                            
                         CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                          
                      END IF 
                      #No.CHI-810006 --add--                                    
                      IF l_now2 > 200 THEN                                      
                         CALL cl_err('','9036',1)                               
                         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
                         EXIT PROGRAM                                           
                      END IF                                                    
                      LET l_byte = length(l_bmt06_s) + 1                        
                      IF l_len >= l_byte THEN                                   
                         LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','  
                         LET l_len = l_len - l_byte                             
                      ELSE                                                      
                         LET l_bmt06[l_now2] = l_bmtstr                         
                         LET l_now2 = l_now2 + 1                                
                         LET l_len = 20                                         
                         LET l_len = l_len - l_byte                             
                         LET l_bmtstr = ''                                      
                         LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','  
                      END IF                                                    
                      #No.CHI-810006 --end--                                                                                                           
#                      EXECUTE insert_prep1 USING sr[i].bmb01,sr[i].bmb02,  #No.CHI-810006                                                            
#                              sr[i].bmb03,sr[i].bmb04,sr[i].bmb29,         #No.CHI-810006                                                            
#                              l_bmt05,l_bmt06_s                            #No.CHI-810006                                                            
                   END FOREACH                                                                                                         
                      #No.CHI-810006 --add--                                    
                      LET l_bmt06[l_now2] = l_bmtstr                            
                      FOR g_cnt = 1 TO l_now2                                   
                         IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '      
                            THEN                                                
                            EXIT FOR                                            
                         END IF                                                 
                       EXECUTE insert_prep1 USING sr[i].bmb01,sr[i].bmb02,      
                               sr[i].bmb03,sr[i].bmb04,sr[i].bmb29,             
                               l_bmt05,l_bmt06[g_cnt]                           
                      END FOR                                                   
                END IF                                                          
                #No.CHI-810006 --end--  
                #子報表-說明            
                #No.CHI-810006 --add--                                          
                IF tm.b = 'Y' THEN                                              
                   FOR g_cnt=1 TO 100                                           
                       LET l_bmc05[g_cnt]=NULL                                  
                   END FOR                                                      
                   LET l_now = 1                                                
                #No.CHI-810006 --end--                                                                                             
                   FOREACH r802_bmc                                                                                                    
                   USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,                                                                          
                         sr[i].bmb04,sr[i].bmb29                                                                                       
#                   INTO l_bmc04,l_bmc05                          #No.CHI-810006
                   INTO l_bmc04,l_bmc05[l_now]                    #No.CHI-810006
                       IF SQLCA.sqlcode THEN                                                                                           
                          CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                         
                       END IF  
                       #No.CHI-810006 --add--                                   
                       IF l_now > 200 THEN                                      
                          CALL cl_err('','9036',1)                              
                          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
                          EXIT PROGRAM                                          
                       END IF                                                   
                       LET l_now=l_now+1                                                                                                         
#                       EXECUTE insert_prep2 USING sr[i].bmb01,sr[i].bmb02,                                                             
#                               sr[i].bmb03,sr[i].bmb04,sr[i].bmb29,                                                                    
#                               l_bmc04,l_bmc05   
                       #No.CHI-810006 --end-- 
                   #No.TQC-7A0013         ---End                                                                                      
                   END FOREACH 
                #No.CHI-810006 --add--                                          
                   LET l_now=l_now-1                                            
                   IF l_now >= 1 THEN                                           
                      FOR g_cnt = 1 TO l_now STEP 2                             
                          LET l_bmc051[g_cnt] = l_bmc05[g_cnt],' ',l_bmc05[g_cnt+1]
                          EXECUTE insert_prep2 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,
                                                     sr[i].bmb29,l_bmc04,l_bmc051[g_cnt]
                      END FOR                                                   
                   END IF                                                       
                END IF                                                          
                #No.CHI-810006 --end--  
            END IF
        END FOR
        IF l_ac < arrno THEN                        # BOM單身已讀完
            EXIT WHILE
        ELSE
#           LET b_seq = sr[arrno-1].rowid_NO   #No.TQC-9A0161
        END IF
    END WHILE
END FUNCTION
 
#FUNCTION r802_cur()
#DEFINE l_cmd   VARCHAR(1000)
#No.TQC-7A0013         ---Begin
#---->產品結構插件位置
#    LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
#                 " WHERE bmt01=?  AND bmt02= ? AND ",
#                 " bmt03=? AND ",
#                 " (bmt04 IS NULL OR bmt04 >= ?) ",
#                 " AND bmt08 = ? ", #FUN-550093
#                 " ORDER BY 1"
#    PREPARE r802_prebmt     FROM l_cmd
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
#    END IF
#    DECLARE r802_bmt  CURSOR FOR r802_prebmt
#---->產品結構說明資料
#    LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
#                 " WHERE bmc01=?  AND bmc02= ? AND ",
#                 " bmc021=? AND ",
#                 " (bmc03 IS NULL OR bmc03 >= ?) ",
#                 " AND bmc06 = ? ", #FUN-550093
#                 " ORDER BY 1"
#    PREPARE r802_prebmc    FROM l_cmd
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('prepare:',SQLCA.sqlcode,1) EXIT PROGRAM
#    END IF
#    DECLARE r802_bmc CURSOR FOR r802_prebmc
#END FUNCTION   
#No.TQC-7A0013         ---End
{    #No.TQC-7A0013 
REPORT r802_rep(p_level,p_i,p_total,sr,p_bma01_a,p_acode) #FUN-550093
   DEFINE l_last_sw VARCHAR(1),
          p_level,p_i	SMALLINT,
          p_total       DECIMAL(13,5),
          p_bma01_a  LIKE bma_file.bma01,
          p_acode    LIKE bma_file.bma06, #FUN-550093
          sr  RECORD
              order1  VARCHAR(20),
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb01 LIKE bmb_file.bmb01,    #本階主件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb14 LIKE bmb_file.bmb14,    #
              bmb15 LIKE bmb_file.bmb15,    #
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb17 LIKE bmb_file.bmb17,    #
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima55 LIKE ima_file.ima55,    #生產單位
              ima63 LIKE ima_file.ima63,    #發料單位
#             rowid_NO  VARCHAR(18),        #No.TQC-9A0161
              bmb29 LIKE bmb_file.bmb29     #FUN-550093
          END RECORD,
          l_ima02 LIKE ima_file.ima02,      #品名規格
          l_ima021 LIKE ima_file.ima02,      #品名規格
          l_ima05 LIKE ima_file.ima05,      #版本
          l_ima06 LIKE ima_file.ima06,      #版本
          l_ima08 LIKE ima_file.ima08,      #來源
          l_ima63 LIKE ima_file.ima63,      #發料單位
          l_ima55 LIKE ima_file.ima55,      #生產單位
          l_ver   LIKE ima_file.ima05,
          l_bmt05 LIKE bmt_file.bmt05,
          l_bmt06 ARRAY[200] OF VARCHAR(20),  #插件位置
          l_bmc04 LIKE bmc_file.bmc04,
          l_bmc05 ARRAY[200] OF VARCHAR(10),  #說明
          l_byte,l_len   SMALLINT,
          l_bmt06_s      VARCHAR(20),
          l_bmtstr       VARCHAR(20),
       #  l_ute_flag   VARCHAR(2),                 #FUN-A40058
          l_ute_flag   LIKE type_file.chr3,        #FUN-A40058 
          l_now,l_now2 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 #ORDER BY p_bma01_a,sr.order1
  ORDER BY p_bma01_a,p_acode,sr.order1 #FUN-550093
  FORMAT
   PAGE HEADER
      CALL s_effver(p_bma01_a,tm.effective) RETURNING l_ver
 
      SELECT ima02,ima021,ima05,ima08,ima63,ima55
        INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55
        FROM ima_file
       WHERE ima01 = p_bma01_a
      IF SQLCA.sqlcode THEN
         LET l_ima02='' LET l_ima05='' LET l_ima08=''
         LET l_ima63='' LET l_ima55=''
      END IF
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
      PRINT                                              #No.FUN-6C0014
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      PRINT g_x[19] CLIPPED,tm.effective,COLUMN 20,g_x[28] CLIPPED,l_ver
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]                              #No.FUN-6C0014         
      #----
 
#------No.TQC-5B0030 modify
      PRINT COLUMN  1,g_x[15] CLIPPED, p_bma01_a,
          #-----No.TQC-5B0107 modify   #&051112
            COLUMN 51,g_x[22] clipped,l_ima05,
            COLUMN 63,g_x[23] clipped,l_ima08,
            COLUMN 71,g_x[16] CLIPPED,l_ima63,
            COLUMN 85,g_x[18] CLIPPED,l_ima55
          #-----No.TQC-5B0107 end
#----end
 
      PRINT COLUMN  1,g_x[17] CLIPPED, l_ima02,
	    COLUMN 71,g_x[20] CLIPPED,tm.a USING'<<<<<'   #No.TQC-5B0107 modify #&051112
      PRINT COLUMN  1,g_x[30] CLIPPED,l_ima021,COLUMN 71,g_x[49],p_acode   #No.TQC-5B0107 modify #051112
      PRINT ' '
      #----
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
      PRINTX name=H2 g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
      PRINTX name=H3 g_x[47],g_x[48]
      PRINT g_dash1
 
      LET l_last_sw = 'n'
 
   #BEFORE GROUP OF p_bma01_a
    BEFORE GROUP OF p_acode #FUN-550093
           IF (PAGENO > 1 OR LINENO > 13) THEN
                SKIP TO TOP OF PAGE
           END IF
 
    ON EVERY ROW
          LET l_ute_flag='USZ'                   #FUN-A40058 add 'Z'
          #---->改變替代特性的表示方式
          IF sr.bmb16 MATCHES '[127]' THEN       #FUN-A40058 add '7'
              LET g_cnt=sr.bmb16 USING '&'
              LET sr.bmb16=l_ute_flag[g_cnt,g_cnt]
          ELSE
              LET sr.bmb16=' '
          END IF
          PRINTX name=D1 COLUMN g_c[31],sr.bmb02 USING '###&',
                         COLUMN g_c[32],sr.bmb03,
                         COLUMN g_c[33],sr.ima08,
                         COLUMN g_c[34],sr.bmb10,
                         COLUMN g_c[35],cl_numfor(p_total,35,4),
                         COLUMN g_c[36],sr.bmb04,
                         COLUMN g_c[37],cl_numfor(sr.bmb08,37,3),
                         COLUMN g_c[38],sr.bmb16,
                         COLUMN g_c[39],sr.ima15
          PRINTX name=D2 COLUMN g_c[40],' ',
                         COLUMN g_c[41],sr.ima02,
                         COLUMN g_c[42],' ',
                         COLUMN g_c[43],' ',
                         COLUMN g_c[44],' ',
                         COLUMN g_c[45],sr.bmb05,
                         COLUMN g_c[46],' '
          PRINTX name=D3 COLUMN g_c[47],' ',
                         COLUMN g_c[48],sr.ima021
      #-->列印插件位置
      IF tm.c ='Y' THEN
         FOR g_cnt=1 TO 200
             LET l_bmt06[g_cnt]=NULL
         END FOR
         LET l_now2=1
         LET l_len =20
         LET l_bmtstr = ''
         FOREACH r802_bmt
         USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550093
         INTO l_bmt05,l_bmt06_s
            IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            IF l_now2 > 200 THEN
               CALL cl_err('','9036',1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
               EXIT PROGRAM
            END IF
            LET l_byte = length(l_bmt06_s) + 1
            IF l_len >= l_byte THEN
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
               LET l_len = l_len - l_byte
            ELSE
               LET l_bmt06[l_now2] = l_bmtstr
               LET l_len = 20
               LET l_now2 = l_now2 + 1
               LET l_len = l_len - l_byte
               LET l_bmtstr = ''
               LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
            END IF
         END FOREACH
         LET l_bmt06[l_now2] = l_bmtstr
         FOR g_cnt = 1 TO l_now2
             IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '
             THEN IF l_now2 = 1 THEN PRINT ' ' END IF
                  EXIT FOR
             END IF
             PRINT COLUMN 48,g_x[29] CLIPPED,l_bmt06[g_cnt] #FUN-510033
         END FOR
      ELSE PRINT ''
      END IF
          #處理說明部份
          IF tm.b ='Y' THEN
           LET l_now = 1
           FOREACH r802_bmc
           USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550093
           INTO l_bmc04,l_bmc05[l_now]
               IF SQLCA.sqlcode THEN
                  CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
               END IF
               IF l_now > 200 THEN
                   CALL cl_err('','9036',1)
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
                   EXIT PROGRAM
               END IF
               LET l_now=l_now+1
           END FOREACH
           LET l_now=l_now-1
           #--->列印剩下說明
           IF l_now >= 1 THEN
              FOR g_cnt = 1 TO l_now STEP 2
                  IF g_cnt =1 THEN PRINT COLUMN 52,g_x[27] clipped; END IF
                  PRINT COLUMN 59,l_bmc05[g_cnt],l_bmc05[g_cnt+1]
              END FOR
           END IF
         END IF
 
   #AFTER GROUP OF p_bma01_a
   #LET g_pageno = 0
   ON LAST ROW
#No.FUN-6C0014--begin
      NEED 4 LINES
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'bma01,ima06,ima09,ima10')                   
              RETURNING tm.wc                                                   
         PRINT g_dash[1,g_len]
         CALL cl_prt_pos_wc(tm.wc)
      END IF                                                                    
      PRINT g_dash[1,g_len]                                                     
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#No.FUN-6C0014--end
 
   PAGE TRAILER
      PRINT ' '
      PRINT g_x[21] CLIPPED
      PRINT g_dash[1,g_len]                                                     
      IF l_last_sw = 'n' THEN
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 1 LINE
      END IF
END REPORT
}                                 #No.TQC-7A0013
