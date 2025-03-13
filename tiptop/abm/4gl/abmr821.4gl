# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmr821.4gl
# Descriptions...: 多階材料用量成本查詢
# Input parameter:
# Return code....:
# Date & Author..: 91/08/17 By Wu
#      Modify    : 92/05/11 By David
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4A0004 04/10/04 By Yuna 料件編號開窗
# Modify.........: No.FUN-510033 05/02/22 By Mandy 報表轉XML
# Modify.........: No.FUN-550093 05/06/03 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5B0107 05/11/12 By Pengu 報表料件、品名、規格之格式調整
# Modify.........: No.FUN-610092 06/05/24 By Joe 增加報表發料單位欄位
# Modify.........: No.TQC-6A0081 06/11/22 By baogui 報表問題修改
# Modify.........: No.TQC-6C0034 06/12/14 By Joe 將單位改為BOM單位
# Modify.........: No.FUN-6C0014 07/01/04 By Jackho 報表頭尾修改
# Modify.........: No.CHI-6A0034 07/01/30 By jamie abmq621->abmr821 
# Modify.........: No.TQC-7A0013 07/10/10 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-810030 08/02/18 By wujie  逆算成本公式有錯
# Modify.........: No.MOD-870159 08/07/14 By claire 欄位imb2151誤寫,應為imb1251
# Modify.........: No.CHI-870025 08/07/16 By sherry 階數排序印錯
# Modify.........: No.TQC-8C0063 08/12/30 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-970044 09/07/03 By sherry 跨階的組成用量沒有進行QPA換算
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-B90073 12/02/17 By bart 材料成本也需乘上QPA

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
		        wc  	  VARCHAR(500),		# Where condition
           		class	  VARCHAR(04),		# 分群碼
   	        	revision  VARCHAR(02),		# 版本
           		effective DATE,   		# 有效日期
           		arrange   VARCHAR(1),		# 資料排列方式
           		cost      VARCHAR(1),		# 選擇列印成本
   	        	pur       VARCHAR(1),		# 選擇採購成本
           		more	  VARCHAR(1) 		# Input more condition(Y/N)
              END RECORD,
          g_bma01_a     LIKE bma_file.bma01,    #產品結構單頭
          g_mcst        LIKE imb_file.imb111,    #材料成本
          g_imcstc      LIKE imb_file.imb121,    #下階間接材料成本
          g_labcstc     LIKE imb_file.imb121,    #下階直接人工成本
          g_fixo        LIKE imb_file.imb121,    #下階固定製費
          g_varo        LIKE imb_file.imb121,    #下階變動製費
          g_outc        LIKE imb_file.imb121,    #下階廠外加工成本
          g_outo        LIKE imb_file.imb121,    #下階廠外加工費用
          g_str1,g_str2   VARCHAR(12),
          m_total       DECIMAL(16,8),
          g_tot INTEGER
 
DEFINE   g_cnt           INTEGER
DEFINE   g_i             SMALLINT   #count/index for any purpose
DEFINE   l_table         STRING     #No.TQC-7A0013
DEFINE   g_str           STRING     #No.TQC-7A0013
DEFINE   g_sql           STRING     #No.TQC-7A0013
DEFINE   g_no           LIKE type_file.num10    # #CHI-870025
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = " g_bma01_a.bma_file.bma01,",
               " p_level.type_file.num5,",
               " p_i.type_file.num5,",
               " bmb03.bmb_file.bmb03,",
               " bmb29.bmb_file.bmb29,",
               " bmb02.bmb_file.bmb02,",
               " bmb06.bmb_file.bmb06,",
               " bmb08.bmb_file.bmb08,",               #No.TQC-810030 
               " bmb10.bmb_file.bmb10,",
               " bmb10_fac.bmb_file.bmb10_fac,",
               " bma01.bma_file.bma01,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " ima08.ima_file.ima08,",
               " mcsts.imb_file.imb111,",
               " cstmbfs.imb_file.imb112,",
               " labcsts.imb_file.imb1131,",
               " cstsabs.imb_file.imb114,",
               " cstao2s.imb_file.imb115,",
               " outlabs.imb_file.imb116,",
               " outmbfs.imb_file.imb1171,",
               " purcost.imb_file.imb118,",
               " l_ima02.ima_file.ima02,",
               " l_ima021.ima_file.ima021,",
               " l_ima05.ima_file.ima05,",
               " l_ima06.ima_file.ima06,",
               " l_ima08.ima_file.ima08,",
               " l_imb211.imb_file.imb211,",
               " l_imb212.imb_file.imb212,",
               " l_imb2131.imb_file.imb2131,",
               " l_imb2132.imb_file.imb2132,",
               " l_imb214.imb_file.imb214,",
               " l_imb219.imb_file.imb219,",
               " l_imb220.imb_file.imb220,",
               " l_imb215.imb_file.imb215,",
               " l_imb216.imb_file.imb216,",
               " l_imb2151.imb_file.imb2151,",
               " l_imb2171.imb_file.imb2171,",
               " l_imb2172.imb_file.imb2172,",
               " l_imb221.imb_file.imb221,",
               " l_imb222.imb_file.imb222,",
               " l_imb2231.imb_file.imb2231,",
               " l_imb2232.imb_file.imb2232,",
               " l_imb224.imb_file.imb224,",
               " l_imb229.imb_file.imb229,",
               " l_imb225.imb_file.imb225,",
               " l_imb226.imb_file.imb226,",
               " l_imb2251.imb_file.imb2251,",
               " l_imb2271.imb_file.imb2271,",
               " l_imb2272.imb_file.imb2272,",
               " l_imb230.imb_file.imb230,",
               " l_ver.ima_file.ima05,",
               " p_acode.bma_file.bma06,",
               " l_str2.ze_file.ze03,   ",
               " p_bmb01.bmb_file.bmb01,",
               " p_bmb29.bmb_file.bmb29,",
               " g_no.type_file.num10 "        #CHI-870025
 
   LET l_table = cl_prt_temptable('abmr821',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_no = 1     # #CHI-870025
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A40116 mod
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?,?,?             ) "      #No.TQC-810030 #CHI-870025
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.class  = ARG_VAL(8)
   LET tm.revision  = ARG_VAL(9)
   LET tm.effective  = ARG_VAL(10)
   LET tm.arrange  = ARG_VAL(11)
   LET tm.cost  = ARG_VAL(12)
   LET tm.pur   = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL abmr821_tm(0,0)			# Input print condition
      ELSE CALL abmr821()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION abmr821_tm(p_row,p_col)
   DEFINE   p_row,p_col	  SMALLINT,
            l_flag        SMALLINT,
            l_one         VARCHAR(01),          	#資料筆數
            l_bdate       LIKE bmx_file.bmx07,
            l_edate       LIKE bmx_file.bmx08,
            l_bma01       LIKE bma_file.bma01,
            l_cmd	  VARCHAR(1000)
 
 
   LET p_row = 4
   LET p_col = 8
 
   OPEN WINDOW abmr821_w AT p_row,p_col WITH FORM "abm/42f/abmr821"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("acode",g_sma.sma118='Y')
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.arrange ='1'  #按元件料件編號遞增順序排列
   LET tm.cost ='1'   #現時成本
   LET tm.pur  ='1'   #採購成本
   LET tm.effective = g_today	#有效日期
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      LET m_total=0
      CONSTRUCT tm.wc ON bma01,ima06,bma06 FROM item,class,acode #FUN-550093
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         ON ACTION CONTROLP
           CASE WHEN INFIELD(item) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
         	  LET g_qryparam.form = "q_ima3"
         	  CALL cl_create_qry() RETURNING g_qryparam.multiret
         	  DISPLAY g_qryparam.multiret TO item
         	  NEXT FIELD item
            OTHERWISE EXIT CASE
            END CASE
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW abmr821_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET l_one='N'
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT COUNT(DISTINCT bma01),bma01 FROM bma_file,ima_file",
             " WHERE bma01=ima01 AND ",tm.wc CLIPPED," GROUP BY bma01"
         PREPARE abmr821_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('P0:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
            EXIT PROGRAM
         END IF
         DECLARE abmr821_cnt
         CURSOR FOR abmr821_precnt
         OPEN abmr821_cnt
         FETCH abmr821_cnt INTO g_cnt,l_bma01
         IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
            CALL cl_err(g_cnt,'mfg2601',0)
            CONTINUE WHILE
         ELSE
            IF g_cnt=1 THEN
               LET l_one='Y'
            END IF
         END IF
      END IF
 
      INPUT BY NAME tm.revision,tm.effective,tm.arrange,tm.cost,tm.pur,tm.more WITHOUT DEFAULTS
 
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
 
         AFTER FIELD arrange
            IF tm.arrange NOT MATCHES '[12]' THEN
               NEXT FIELD arrange
            END IF
 
         AFTER FIELD cost
            IF tm.cost NOT MATCHES '[1-3]' THEN
               NEXT FIELD cost
            END IF
 
         AFTER FIELD pur
            IF tm.pur  NOT MATCHES '[1-3]' THEN
               NEXT FIELD pur
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
         ON ACTION CONTROLP
            CALL abmr821_wc()   # Input detail Where Condition
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
 
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
         CLOSE WINDOW abmr821_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmr821'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmr821','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.class CLIPPED,"'",
                            " '",tm.revision CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.arrange CLIPPED,"'",
                            " '",tm.cost CLIPPED,"'",
                            " '",tm.pur CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('abmr821',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW abmr821_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL abmr821()
      ERROR ""
   END WHILE
   CLOSE WINDOW abmr821_w
END FUNCTION
 
FUNCTION abmr821_wc()
   DEFINE l_wc  STRING           #NO.FUN-910082 
   OPEN WINDOW abmr821_w2 AT 2,2
        WITH FORM "abm/42f/abmi600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi600")
 
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        bmb02,bmb03,bmb04,bmb05,bmb06,bmb07,bmb08,bmb10
        FROM
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
        s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb08,s_bmb[1].bmb10
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   CLOSE WINDOW abmr821_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# abmr821()      從單頭讀取合乎條件的主件資料
# abmr821_bom()  處理元件及其相關的展開資料
FUNCTION abmr821()
   DEFINE l_name VARCHAR(20),		# External(Disk) file name
          l_time VARCHAR(8),		# Usima time for running the job
          l_use_flag    VARCHAR(2),
          l_ute_flag    VARCHAR(2),
          l_sql  VARCHAR(1000),		# RDSQL STATEMENT
          l_za05 VARCHAR(40),
          l_labcst      LIKE imb_file.imb111,    #人工成本
          l_bma01 LIKE bma_file.bma01,          #主件料件
          l_bma06 LIKE bma_file.bma06           #FUN-550093
   DEFINE l_ima02   LIKE ima_file.ima02,    #品名規格
          l_ima021  LIKE ima_file.ima021,   #FUN-5100033
          l_ima05   LIKE ima_file.ima05,    #版本
          l_ima06   LIKE ima_file.ima06,    #分群碼
          l_ima08   LIKE ima_file.ima08,    #來源
          l_imb211  LIKE imb_file.imb211,
          l_imb212  LIKE imb_file.imb212,
          l_imb2131 LIKE imb_file.imb2131,
          l_imb2132 LIKE imb_file.imb2132,
          l_imb214  LIKE imb_file.imb214,
          l_imb219  LIKE imb_file.imb219,
          l_imb220  LIKE imb_file.imb220,
          l_imb215  LIKE imb_file.imb215,
          l_imb216  LIKE imb_file.imb216,
          l_imb2151 LIKE imb_file.imb2151,
          l_imb2171 LIKE imb_file.imb2171,
          l_imb2172 LIKE imb_file.imb2172,
          l_imb221  LIKE imb_file.imb221,
          l_imb222  LIKE imb_file.imb222,
          l_imb2231 LIKE imb_file.imb2231,
          l_imb2232 LIKE imb_file.imb2232,
          l_imb224  LIKE imb_file.imb224,
          l_imb229  LIKE imb_file.imb229,
          l_imb225  LIKE imb_file.imb225,
          l_imb226  LIKE imb_file.imb226,
          l_imb2251 LIKE imb_file.imb2251,
          l_imb2271 LIKE imb_file.imb2271,
          l_imb2272 LIKE imb_file.imb2272,
          l_imb230  LIKE imb_file.imb230,
          l_ver     LIKE ima_file.ima05 
   DEFINE l_cmd1        LIKE type_file.chr1000      #CHI-870025
 
     #No.FUN-B80100--mark--Begin---
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
     #No.FUN-B80100--mark--End-----
 
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
 
     LET l_sql = "SELECT bma01,bma06", #FUN-550093
                 " FROM bma_file, ima_file",
                 " WHERE ima01 = bma01",
                 " AND ",tm.wc
     PREPARE abmr821_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     DECLARE abmr821_curs1 CURSOR FOR abmr821_prepare1
 

     FOREACH abmr821_curs1 INTO l_bma01,l_bma06 #FUN-550093
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01_a=l_bma01
       LET g_imcstc=0   #間接材料成本
       LET g_labcstc=0  #下階直接人工成本
       LET g_fixo=0     #下階固定製造費用
       LET g_varo=0     #下階變動製造費用
       LET g_outc=0     #下階廠外加工成本
       LET g_outo=0     #下階廠外加工費用
       CALL abmr821_bom(0,l_bma01,1,l_bma06,1) RETURNING g_mcst  #TQC-970044 add
       #當下階的所有成本資料均列印後, 最後要列印主件的標準成本及
       #計算後成本資料, 表示方式, 以32700為其階層(level)
 
       CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
       SELECT ima02,ima021,ima05,ima06,ima08
           INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08
           FROM ima_file
           WHERE ima01=g_bma01_a
       IF SQLCA.sqlcode THEN
           LET l_ima02=''
           LET l_ima021=''
           LET l_ima05=''
           LET l_ima06=''
           LET l_ima08=''
       END IF
       LET l_imb211=0  LET l_imb212=0  LET l_imb2131=0 LET l_imb2132=0 
       LET l_imb214=0  LET l_imb219=0  LET l_imb220=0  LET l_imb215=0 
       LET l_imb2151=0 LET l_imb216=0  LET l_imb2171=0 LET l_imb2172=0 
       LET l_imb221=0  LET l_imb222=0  LET l_imb2231=0 LET l_imb2232=0 
       LET l_imb224=0  LET l_imb229=0  LET l_imb225=0  LET l_imb2251=0 
       LET l_imb226=0  LET l_imb2271=0 LET l_imb2272=0 LET l_imb230=0 
       CASE tm.cost
       WHEN '1'        #現時成本
           SELECT imb211, imb212, imb2131,imb2132,
                  imb214, imb219, imb220, imb215,
                  imb216, imb2171,imb2172,imb221,
                  imb222, imb2231,imb2232,imb224,
                  imb229, imb225, imb226, imb2271,
                  imb2272,imb230, imb2151,imb2251
             INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
                  l_imb214, l_imb219,  l_imb220,  l_imb215,
                  l_imb216, l_imb2171, l_imb2172, l_imb221,
                  l_imb222, l_imb2231, l_imb2232, l_imb224,
                  l_imb229, l_imb225,  l_imb226,  l_imb2271,
                  l_imb2272,l_imb230,  l_imb2151, l_imb2251
             FROM imb_file
             WHERE imb01=l_bma01 
       WHEN '2'        #目標成本
           SELECT imb311, imb312, imb3131, imb3132,
                  imb314, imb319, imb320,  imb315,
                  imb316, imb3171,imb3172, imb321,
                  imb322, imb3231,imb3232, imb324,
                  imb329, imb325, imb326,  imb3271,
                  imb3272,imb330, imb3151, imb3251
             INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
                  l_imb214, l_imb219,  l_imb220,  l_imb215,
                  l_imb216, l_imb2171, l_imb2172, l_imb221,
                  l_imb222, l_imb2231, l_imb2232, l_imb224,
                  l_imb229, l_imb225,  l_imb226,  l_imb2271,
                  l_imb2272,l_imb230,  l_imb2151, l_imb2251
             FROM imb_file
             WHERE imb01=l_bma01 
       WHEN '3'       #標準成本
           SELECT imb111, imb112, imb1131,imb1132,
                  imb114, imb119, imb120, imb115,
             			 imb116, imb1171,imb1172,imb121,
                  imb122, imb1231,imb1232,imb124,
                  imb129, imb125, imb126, imb1271,
                  imb1272,imb130, imb1151,imb1251 #MOD-870159 modify imb2151
             INTO l_imb211, l_imb212,  l_imb2131, l_imb2132,
                  l_imb214, l_imb219,  l_imb220,  l_imb215,
                  l_imb216, l_imb2171, l_imb2172, l_imb221,
                  l_imb222, l_imb2231, l_imb2232, l_imb224,
                  l_imb229, l_imb225,  l_imb226,  l_imb2271,
                  l_imb2272,l_imb230,  l_imb2151, l_imb2251
             FROM imb_file
             WHERE imb01=l_bma01 
       END CASE
       IF l_imb211 IS NULL THEN LET l_imb211=0 END IF
       IF l_imb212 IS NULL THEN LET l_imb212=0 END IF
       IF l_imb2131 IS NULL THEN LET l_imb2131=0 END IF
       IF l_imb2132 IS NULL THEN LET l_imb2132=0 END IF
       IF l_imb214 IS NULL THEN LET l_imb214=0 END IF
       IF l_imb219 IS NULL THEN LET l_imb219=0 END IF
       IF l_imb220 IS NULL THEN LET l_imb220=0 END IF
       IF l_imb215 IS NULL THEN LET l_imb215=0 END IF
       IF l_imb2151 IS NULL THEN LET l_imb2151=0 END IF
       IF l_imb216 IS NULL THEN LET l_imb216=0 END IF
       IF l_imb2171 IS NULL THEN LET l_imb2171=0 END IF
       IF l_imb2172 IS NULL THEN LET l_imb2172=0 END IF
       IF l_imb221 IS NULL THEN LET l_imb221=0 END IF
       IF l_imb222 IS NULL THEN LET l_imb222=0 END IF
       IF l_imb2231 IS NULL THEN LET l_imb2231=0 END IF
       IF l_imb2232 IS NULL THEN LET l_imb2232=0 END IF
       IF l_imb224 IS NULL THEN LET l_imb224=0 END IF
       IF l_imb229 IS NULL THEN LET l_imb229=0 END IF
       IF l_imb225 IS NULL THEN LET l_imb225=0 END IF
       IF l_imb2251 IS NULL THEN LET l_imb2251=0 END IF
       IF l_imb226 IS NULL THEN LET l_imb226=0 END IF
       IF l_imb2271 IS NULL THEN LET l_imb2271=0 END IF
       IF l_imb2272 IS NULL THEN LET l_imb2272=0 END IF
       IF l_imb230 IS NULL THEN LET l_imb230=0 END IF
       EXECUTE insert_prep USING l_bma01,'32700','0',l_bma01,l_bma06,
               '0','0','0','','1',     #No.TQC-810030 
               '','','','','0','0','0','0','0','0','0','0',
               l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
               l_imb211, l_imb212, l_imb2131, l_imb2132, l_imb214,
               l_imb219, l_imb220, l_imb215, l_imb216, l_imb2151,
               l_imb2171, l_imb2172, l_imb221, l_imb222, l_imb2231,
               l_imb2232, l_imb224, l_imb229, l_imb225, l_imb226,
               l_imb2251, l_imb2271, l_imb2272, l_imb230,l_ver,l_bma06,
               ' ',l_bma01,l_bma06,g_no #CHI-870025
       LET g_no = g_no + 1     #No.MOD-830140 add
     END FOREACH
 

     LET l_cmd1=l_cmd1 CLIPPED, " ORDER BY g_no"   # #CHI-870025
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,l_cmd1 CLIPPED   #CHI-870025
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'bma01,ima06,bma06')
             RETURNING g_str
     END IF
 
     LET g_str = g_str,";",tm.effective,";",tm.cost,";",tm.pur,";",
                 g_azi03,";",g_azi04,";",
                 g_azi05
     CALL cl_prt_cs3('abmr821','abmr821',g_sql,g_str)
     #No.FUN-B80100--mark--Begin---
     #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
     #No.FUN-B80100--mark--End-----
END FUNCTION
 
FUNCTION abmr821_bom(p_level,p_key,p_total,p_acode,p_qpa) #FUN-550093 #TQC-970044 add p_qpa
   DEFINE p_level	SMALLINT,
          p_total       DECIMAL(16,8),
          l_total       DECIMAL(16,8),
          p_acode       LIKE bma_file.bma06,  #FUN-550093
          p_key		LIKE bma_file.bma01,  #主件料件編號
          l_ac,i	SMALLINT,
          arrno		SMALLINT,	#BUFFER SIZE (可存筆數)
          b_seq		SMALLINT,	#當BUFFER滿時,重新讀單身之起始序號
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb03       LIKE bmb_file.bmb03,    #元件料號
              bmb29       LIKE bmb_file.bmb29,    #No.TQC-7A0013
              bmb02       LIKE bmb_file.bmb02,    #項次
              bmb06       LIKE bmb_file.bmb06,    #QPA
              bmb08       LIKE bmb_file.bmb08,    #損耗率      #No.TQC-810030 
              bmb10       LIKE bmb_file.bmb10,    #發料單位    ## No.FUN-610092 #NO.TQC-6C0034
              bmb10_fac   LIKE bmb_file.bmb10_fac,    #發料單位
              bma01       LIKE bma_file.bma01,    #No.MOD-490217
              ima02       LIKE ima_file.ima02,    #品名規格
              ima021      LIKE ima_file.ima021,   #FUN-510033
              ima08       LIKE ima_file.ima08,    #來源
              mcsts       LIKE imb_file.imb111,   #直接材料成本
              cstmbfs     LIKE imb_file.imb112,   #間接材料
              labcsts     LIKE imb_file.imb1131,  #直接人工成本
              cstsabs     LIKE imb_file.imb114,   #固定製造費用
              cstao2s     LIKE imb_file.imb115,   #變動製造費用
              outlabs     LIKE imb_file.imb116,   #廠外加工成本
              outmbfs     LIKE imb_file.imb1171,  #廠外加工製造費用成本
              purcost     LIKE imb_file.imb118    #本階採購成本
          END RECORD,
          l_material    LIKE imb_file.imb111,  #材料成本
          l_material_t  LIKE imb_file.imb111,  #材料成本
          l_unit        LIKE bmb_file.bmb10,
          l_unit_fac    LIKE bmb_file.bmb10_fac,
          l_ima44_fac   LIKE ima_file.ima44_fac,
          l_cmd	 VARCHAR(1000),
          g_sw          SMALLINT
   DEFINE l_ima02   LIKE ima_file.ima02,    #品名規格
          l_ima021  LIKE ima_file.ima021,   #FUN-5100033
          l_ima05   LIKE ima_file.ima05,    #版本
          l_ima06   LIKE ima_file.ima06,    #分群碼
          l_ima08   LIKE ima_file.ima08,    #來源
          l_ver     LIKE ima_file.ima05,
          l_str2    LIKE ze_file.ze03,
          l_k       LIKE type_file.num5,
          l_level   LIKE type_file.num5
  DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.TQC-8C0063 
  DEFINE p_qpa      LIKE bmb_file.bmb06     #TQC-970044
  
    LET p_level = p_level + 1
    IF p_level > 25 THEN
        CALL cl_err(p_level,'mfg2733',2)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
    END IF
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
        LET sr[1].bmb29 = p_acode
        CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
        SELECT ima02,ima021,ima05,ima06,ima08
            INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08
            FROM ima_file
            WHERE ima01=g_bma01_a
        IF SQLCA.sqlcode THEN
            LET l_ima02=''
            LET l_ima021=''
            LET l_ima05=''
            LET l_ima06=''
            LET l_ima08=''
        END IF
        LET l_str2 = ' '
        IF p_level>10 THEN LET l_level=10 ELSE LET l_level = p_level END IF
        IF l_level > 1 THEN
           FOR l_k = 1 TO l_level - 1
               LET l_str2 = l_str2 clipped,'.' clipped
           END FOR
        ELSE 
           LET l_str2 =''
        END IF
        EXECUTE insert_prep USING g_bma01_a,'1','0',sr[1].*,
                l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
                '0','0','0','0','0','0', '0','0','0','0','0','0',
                '0','0','0','0','0','0', '0','0','0','0','0','0',
                l_ver,p_acode,l_str2,p_key,p_acode,g_no #CHI-870025
        LET g_no = g_no + 1    #CHI-870025
    END IF
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb03,bmb29,bmb02,bmb06/bmb07,bmb08,bmb10,bmb10_fac,bma01,ima02,ima021,ima08,"        #FUN-610092 #No.TQC-7A0013   #No.TQC-810030
        #皆以本階為主 +下階  #CHI-870025
        CASE tm.cost
           WHEN '1'
            LET l_cmd=l_cmd CLIPPED,
                "((imb211+imb221)*bmb10_fac2),((imb212+imb222)*bmb10_fac2),", #CHI-870025
                "((imb2131+imb2231)+(imb2132+imb2232))*bmb10_fac2,", #CHI-870025
                "((imb214+imb224)+(imb219+imb229))*bmb10_fac2,(imb215+imb225)*bmb10_fac2,", #CHI-870025
                "(imb216+imb226)*bmb10_fac2,", #CHI-870025
                "((imb2151+imb2251)+(imb2171+imb2271)+(imb2172+imb2272))*bmb10_fac2,(imb218)*bmb10_fac2" #CHI-870025
           WHEN '2'
            LET l_cmd=l_cmd CLIPPED,
                "(imb311+imb321)*bmb10_fac2,(imb312+imb322)*bmb10_fac2,", #CHI-870025
                "((imb3131+imb3231)+(imb3132+imb3232))*bmb10_fac2,", #CHI-870025
                "((imb314+imb324)+(imb319+imb329))*bmb10_fac2,(imb315+imb325)*bmb10_fac2,", #CHI-870025
                "(imb316+imb326)*bmb10_fac2,", #CHI-870025
                "((imb3151+imb3251)+(imb3171+imb3271)+(imb2172+imb2272))*bmb10_fac2,imb318*bmb10_fac2" #CHI-870025
           WHEN '3'
            LET l_cmd=l_cmd CLIPPED,
                "(imb111+imb121)*bmb10_fac2,(imb112+imb122)*bmb10_fac2,", #CHI-870025
                "((imb1131+imb1231)+(imb1132+imb1232))*bmb10_fac2,", #CHI-870025
                "((imb114+imb124)+(imb119+imb129))*bmb10_fac2,(imb115+imb125)*bmb10_fac2,", #CHI-870025
                "(imb116+imb126)*bmb10_fac2,", #CHI-870025
                "((imb1151+imb1251)+(imb1171+imb1271)+(imb1172+imb1272))*bmb10_fac2,imb118*bmb10_fac2" #CHI-870025
        END CASE
        LET l_cmd=l_cmd CLIPPED,
            " FROM bmb_file,OUTER imb_file, OUTER ima_file, OUTER bma_file",
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
            " AND imb_file.imb01 = bmb_file.bmb03",
            " AND bmb_file.bmb03 = ima_file.ima01",
            " AND bmb_file.bmb03 = bma_file.bma01",
            " AND ima_file.ima08 != 'A' ",
            " AND bmb29 = '",p_acode,"'" #FUN-550093
 
        #生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.effective,
            "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
            "' OR bmb05 IS NULL)"
        END IF
        #排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY"
        IF tm.arrange='1' THEN
            LET l_cmd=l_cmd CLIPPED," bmb03"
        ELSE
            LET l_cmd=l_cmd CLIPPED," bmb02"
        END IF
        #組完之後的句子, 將之準備成可以用的查詢命令
        PREPARE abmr821_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('P1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
           EXIT PROGRAM
        END IF
        DECLARE abmr821_cur CURSOR FOR abmr821_ppp
 
        LET l_material_t=0
        LET l_ac = 1
        FOREACH abmr821_cur INTO sr[l_ac].*
            IF sr[l_ac].ima08 MATCHES '[PVZ]' THEN #採購件, 使用採購成本
               CASE tm.pur
                    WHEN '1'    #材料成本
                      LET sr[l_ac].mcsts=sr[l_ac].purcost
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                    WHEN '2'    #最近單價
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                      SELECT ima53,ima44,ima44_fac
                        INTO sr[l_ac].mcsts,l_unit,l_ima44_fac
                        FROM ima_file WHERE ima01=sr[l_ac].bmb03
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                   ##當發料單位與採購單位不同，直接由ima44_fac 與 bmb10_fac換算
                      LET l_unit_fac = sr[l_ac].bmb10_fac / l_ima44_fac
                      LET sr[l_ac].mcsts = sr[l_ac].mcsts * l_unit_fac
 
                    WHEN '3'
                      LET sr[l_ac].cstmbfs=0
                      LET sr[l_ac].labcsts=0
                      LET sr[l_ac].cstsabs=0
                      LET sr[l_ac].cstao2s=0
                      LET sr[l_ac].outlabs=0
                      LET sr[l_ac].outmbfs=0
                      SELECT ima531,ima44,ima44_fac
                        INTO sr[l_ac].mcsts,l_unit,l_ima44_fac
                        FROM ima_file WHERE ima01=sr[l_ac].bmb03
                      IF cl_null(l_ima44_fac) THEN LET l_ima44_fac = 1 END IF
                   ##當發料單位與採購單位不同，直接由ima44_fac 與 bmb10_fac換算
                      LET l_unit_fac = sr[l_ac].bmb10_fac / l_ima44_fac
                      LET sr[l_ac].mcsts = sr[l_ac].mcsts * l_unit_fac
               END CASE
            END IF
            IF sr[l_ac].mcsts   IS NULL THEN LET sr[l_ac].mcsts=0   END IF
            IF sr[l_ac].cstmbfs IS NULL THEN LET sr[l_ac].cstmbfs=0 END IF
            IF sr[l_ac].labcsts IS NULL THEN LET sr[l_ac].labcsts=0 END IF
            IF sr[l_ac].cstsabs IS NULL THEN LET sr[l_ac].cstsabs=0 END IF
            IF sr[l_ac].cstao2s IS NULL THEN LET sr[l_ac].cstao2s=0 END IF
            IF sr[l_ac].outlabs IS NULL THEN LET sr[l_ac].outlabs=0 END IF
            IF sr[l_ac].outmbfs IS NULL THEN LET sr[l_ac].outmbfs=0 END IF
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           LET sr[l_ac].bmb06 = p_qpa * sr[l_ac].bmb06   #TQC-970044 add
            LET l_ac = l_ac + 1
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH
 
        FOR i = 1 TO l_ac-1
            LET l_total=p_total*sr[i].bmb06               #元件之終階QPA
            LET sr[i].mcsts=sr[i].mcsts*l_total           #元件之本階直接材料成本     #MOD-B90073 add
            LET sr[i].labcsts=sr[i].labcsts*l_total       #元件之本階直人成本
            LET sr[i].cstsabs=sr[i].cstsabs*l_total       #元件之本階固定製費
            LET sr[i].cstao2s=sr[i].cstao2s*l_total       #元件之本階變動製費
            LET sr[i].outlabs=sr[i].outlabs*l_total       #元件之本階加工成本
            LET sr[i].outmbfs=sr[i].outmbfs*l_total       #本階託外費用
            LET g_fixo=g_fixo+sr[i].cstsabs               #主件之下階固定成本
            LET g_varo=g_varo+sr[i].cstao2s               #主件之下階變動成本
            LET g_labcstc=g_labcstc+sr[i].labcsts         #主件之下階直人成本
            LET g_outc=g_outc+sr[i].outlabs               #主件之下階加工成本
            LET g_outo=g_outo+sr[i].outmbfs               #主件之下階加工費用
            #材料成本之算法和其他的幾個成本的計算方式不同
            IF sr[i].bma01 IS NOT NULL AND sr[i].ima08 NOT MATCHES '[PVZ]' THEN
 
            CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
            SELECT ima02,ima021,ima05,ima06,ima08
                INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08
                FROM ima_file
                WHERE ima01=g_bma01_a
            IF SQLCA.sqlcode THEN
                LET l_ima02=''
                LET l_ima021=''
                LET l_ima05=''
                LET l_ima06=''
                LET l_ima08=''
            END IF
            LET l_str2 = ' '
            IF p_level>10 THEN LET l_level=10 ELSE LET l_level = p_level END IF
            IF l_level > 1 THEN
               FOR l_k = 1 TO l_level - 1
                   LET l_str2 = l_str2 clipped,'.' clipped
               END FOR
            ELSE 
               LET l_str2 =''
            END IF
            EXECUTE insert_prep USING g_bma01_a,p_level,i,sr[i].*,
                    l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
                    '0','0','0','0','0','0', '0','0','0','0','0','0',
                    '0','0','0','0','0','0', '0','0','0','0','0','0',
                    l_ver,p_acode,l_str2,p_key,p_acode,g_no #CHI-870025
            LET g_no = g_no + 1    #CHI-870025
 
                CALL abmr821_bom(p_level,sr[i].bmb03,l_total,l_ima910[i],sr[i].bmb06)  #TQC-970044 add 
                     RETURNING l_material
 
                #由下階所得之本階材料成本
                LET l_material_t=l_material_t+l_material
 
                #由下階累計之本階間接成本
                LET g_imcstc=g_imcstc+(sr[i].cstmbfs*l_total)
 
                #本階材料成本
                LET sr[i].mcsts=l_material+(sr[i].cstmbfs*l_total)
            ELSE #無下階之元件
                #由下階累計之下階間接成本
                LET g_imcstc=g_imcstc+(sr[i].cstmbfs*l_total)
 
                #由下階所得之本階材料成本
                LET l_material_t=l_material_t+(sr[i].mcsts * l_total)
 
                #本階材料成本
                LET sr[i].mcsts=sr[i].mcsts+(sr[i].cstmbfs * l_total)
            CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
            SELECT ima02,ima021,ima05,ima06,ima08
                INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08
                FROM ima_file
                WHERE ima01=g_bma01_a
            IF SQLCA.sqlcode THEN
                LET l_ima02=''
                LET l_ima021=''
                LET l_ima05=''
                LET l_ima06=''
                LET l_ima08=''
            END IF
            LET l_str2 = ' '
            IF p_level>10 THEN LET l_level=10 ELSE LET l_level = p_level END IF
            IF l_level > 1 THEN
               FOR l_k = 1 TO l_level - 1
                   LET l_str2 = l_str2 clipped,'.' clipped
               END FOR
            ELSE 
               LET l_str2 =''
            END IF
            EXECUTE insert_prep USING g_bma01_a,p_level,i,sr[i].*,
                    l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
                    '0','0','0','0','0','0', '0','0','0','0','0','0',
                    '0','0','0','0','0','0', '0','0','0','0','0','0',
                    l_ver,p_acode,l_str2,p_key,p_acode,g_no #CHI-870025
            LET g_no = g_no + 1     #CHI-870025
           END IF #CHI-870025
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
    RETURN l_material_t
END FUNCTION
 
#No.FUN-9C0077 程式精簡
