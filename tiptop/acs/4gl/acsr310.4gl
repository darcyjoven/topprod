# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acsr310.4gl
# Descriptions...: 料件作業成本表
# Input parameter:
# Return code....:
# Date & Author..: 92/01/28 By Nora
# Modify.........: No.FUN-570244 05/07/22 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.FUN-580013 05/08/11 By will 報表轉XML格式
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-690110 06/10/13 By xiake cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		               # Print condition RECORD
          wc  	STRING,                        # Where condition No.TQC-630166
          ecb02   LIKE  ecb_file.ecb02,          # Routing No.
          b       LIKE type_file.chr1,           #No.FUN-680071 VARCHAR(1)               # Method of Cost
          qty     LIKE type_file.num5,           #No.FUN-680071 SMALLINT              # Product Quality
          more    LIKE type_file.chr1            #No.FUN-680071 VARCHAR(1) # Input more condition(Y/N)
              END RECORD,
          g_tot_bal     LIKE csb_file.csb05     #No.FUN-680071 DECIMAL(13,5)# User defined variable
DEFINE    g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-680071 SMALLINT
#No.FUN-580013  --begin
#DEFINE   g_dash          VARCHAR(400)             #Dash line
#DEFINE   g_len           SMALLINT              #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT              #Report page no
#DEFINE   g_zz05          VARCHAR(1)               #Print tm.wc ?(Y/N)
#No.FUN-580013  --end
#CHI-710051 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-690110 by xiake
 
#No.CHI-6A0004--begin
#   SELECT azi03 INTO g_azi03 FROM azi_file
#          WHERE azi01 = g_aza.aza17             # 本國幣別之成本小數位數
#No.CHI-6A0004--end
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.ecb02= ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   LET tm.qty= ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r310_tm()	        	# Input print condition
      ELSE CALL r310()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-690110 by xiake
END MAIN
 
FUNCTION r310_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680071 SMALLINT
          l_cmd		LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW r310_w AT p_row,p_col WITH FORM "acs/42f/acsr310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET tm.ecb02 = 1
   LET tm.qty   = 1
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   #非使用製程,則無任何資料可提供
   IF g_sma.sma54 = 'N' THEN
      OPEN WINDOW r310_w3 AT 16,21 WITH 3 ROWS, 40 COLUMNS
 
      CALL cl_err('','mfg6021',1)
      CLOSE WINDOW r310_w3
      EXIT WHILE
   END IF
   #使用成本中心,則無任何資料可提供
   IF g_sma.sma23 = '1' THEN
      OPEN WINDOW r310_w3 AT 16,21 WITH 3 ROWS, 40 COLUMNS
 
      CALL cl_err('','mfg6020',1)
      CLOSE WINDOW r310_w3
      EXIT WHILE
   END IF
   CONSTRUCT BY NAME tm.wc ON ima01
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
#No.FUN-570244  --start-
      ON ACTION CONTROLP
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570244 --end--
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
   DISPLAY BY NAME tm.ecb02,tm.qty,tm.more 	# Condition
 
   INPUT BY NAME tm.ecb02,
                 tm.b,tm.qty,tm.more WITHOUT DEFAULTS
 
      AFTER FIELD ecb02
         IF tm.ecb02 IS NULL THEN
            LET tm.ecb02 = 1
            DISPLAY BY NAME tm.ecb02
         END IF
 
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES '[123]' THEN
            NEXT FIELD b
         END IF
 
      AFTER FIELD qty
         IF tm.qty IS NULL OR tm.qty = 0 THEN
            LET tm.qty = 1
            DISPLAY BY NAME tm.qty
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
      ON ACTION CONTROLP CALL r310_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
   IF tm.b IS NULL OR tm.b = ' ' THEN
      LET tm.b = '1'
   END IF
   DISPLAY BY NAME tm.b
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='acsr310'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acsr310','9031',1)   
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
                         " '",tm.ecb02 CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.qty CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('acsr310',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-690110 by xiake
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r310()
   ERROR ""
END WHILE
   CLOSE WINDOW r310_w
END FUNCTION
 
FUNCTION r310_wc()
   DEFINE l_wc LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(300)
 
   OPEN WINDOW r310_w2 AT 2,2 WITH FORM "acs/42f/acsu010"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("acsu010")
 
 
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
        ima06, ima05, ima08, ima02, ima03,
        ima13, ima14, ima24, ima70, ima57, ima15,
        ima09, ima10, ima11, ima12, ima07,
        ima16, ima37, ima38, ima51, ima52,
        ima04, ima18, ima19, ima20,
        ima21, ima22, ima34, ima42, ima40,
        ima41, ima29, imauser, imagrup
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
   CLOSE WINDOW r310_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690110 by xiake
      EXIT PROGRAM
         
   END IF
END FUNCTION
 
FUNCTION r310()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name  #No.FUN-680071 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0064
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_sql1 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_sql2 	LIKE type_file.chr1000,		# RDSQL STATEMENT  #No.FUN-680071 VARCHAR(600)
          l_chr		LIKE type_file.chr8,            #No.FUN-680071 VARCHAR(8), # 成本方式  #No.TQC-6A0079
          l_chr1	LIKE oea_file.oea01,            #No.FUN-680071 VARCHAR(12),# 來源碼
          l_za05	LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(40)
          l_ecb01       LIKE ecb_file.ecb01,    #製程編號
		  l_flag    LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
		  l_fac     LIKE ima_file.ima86_fac,    #轉換率
     sr  RECORD
    	 ima561 LIKE ima_file.ima561, #最少生產數量
         eca04 LIKE eca_file.eca04,   #工作站型態
         eca06 LIKE eca_file.eca06,   #產能型態
		 eca15 LIKE eca_file.eca15,   #製造費用分擔基準
		 eca16 LIKE eca_file.eca16,   #人工設置成本率
		 eca18 LIKE eca_file.eca18,   #人工生產成本率
		 eca20 LIKE eca_file.eca20,   #機器設置成本率
		 eca201 LIKE eca_file.eca201, #機器生產成本率
		 eca22 LIKE eca_file.eca22,   #固定製造費用分攤率
		 eca24 LIKE eca_file.eca24,   #變動製造費用分攤率
		 eca36 LIKE eca_file.eca36,   #加工單位成本
		 eca38 LIKE eca_file.eca38,   #加工固定製造費用分攤率
		 eca40 LIKE eca_file.eca40,   #加工變動製造費用分攤率
		 ecb13 LIKE ecb_file.ecb13,   #成本計算基準
		 ecb18 LIKE ecb_file.ecb18,   #人工設置時間
		 ecb19 LIKE ecb_file.ecb19,   #人工生產時間
		 ecb20 LIKE ecb_file.ecb20,   #機器設置時間
		 ecb21 LIKE ecb_file.ecb21,   #機器生產時間
		 ecb22 LIKE ecb_file.ecb22,   #廠外加工時間
		 ecb23 LIKE ecb_file.ecb23,   #廠外加工成本
         ecb15 LIKE ecb_file.ecb15,   #人工數
         ecb16 LIKE ecb_file.ecb16    #機器數
     END RECORD,
     sr1 RECORD
         ima01 LIKE ima_file.ima01,   #料件編號
         ima02 LIKE ima_file.ima02,   #品名規格
         ima05 LIKE ima_file.ima05,   #版本
         ima08 LIKE ima_file.ima08,   #來源
         ima34 LIKE ima_file.ima34,   #成本中心
         ima55 LIKE ima_file.ima55,   #生產單位
		 ima55_fac LIKE ima_file.ima55_fac,#生產/庫存轉換率
		 ima561 LIKE ima_file.ima561, #最少生產數量
		 ima571 LIKE ima_file.ima571, #主製程料件
		 ima86 LIKE ima_file.ima86,   #成本單位
		 ima86_fac LIKE ima_file.ima86_fac,#生產/庫存轉換率
         eca01 LIKE eca_file.eca01,   #工作站編號
         eca04 LIKE eca_file.eca04,   #工作站型態
         ecb02 LIKE ecb_file.ecb02,   #製程編號
         ecb03 LIKE ecb_file.ecb03,   #作業序號
         ecb06 LIKE ecb_file.ecb06,   #作業編號
         ecb17 LIKE ecb_file.ecb17    #說明
     END RECORD,
     sr2 RECORD
         l_scost     LIKE ima_file.ima121,  #No.FUN-680071 DECIMAL(20,6),   #人工設置成本
         l_rcost     LIKE ima_file.ima121,  #No.FUN-680071 DECIMAL(20,6),   #人工生產成本
         l_hour      LIKE eca_file.eca09,    #No.FUN-680071 DECIMAL(8,2),    #直接人工小時
         m_scost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器設置成本
         m_rcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器生產成本
         m_hour      LIKE eca_file.eca09,    #No.FUN-680071 DECIMAL(8,2),    #直接機器小時
         f_bcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #固定製造費用
         v_bcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #變動製造費用
         o_cost      LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #廠外加工成本
         fo_bcost    LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #固定廠外加工製造費用
         vo_bcost    LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #變動廠外加工製造費用
         l_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #人工成本小計
         m_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器成本小計
         b_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #製造費用小計
         o_total     LIKE type_file.num20_6  #No.FUN-680071 DECIMAL(20,6)    #廠外加工小計
     END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580013  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'acsr310'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580013  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     #先選出符合條件之料件編號及其主製程料件、製程序號
     #若此料件無製程則使用主製程料件之製程
     LET l_sql = "SELECT unique ima01,ima571,ecb02",
                 " FROM ima_file,OUTER ecb_file",
                 " WHERE ima08 IN ('M','P','X','K','U','V','R','S') AND ",
                 " ima_file.ima01 = ecb_file.ecb01 AND ",
                 " imaacti IN ('Y','y') AND ",tm.wc CLIPPED
     PREPARE r310_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-690110 by xiake
        EXIT PROGRAM 
     END IF
     DECLARE r310_c1 CURSOR FOR r310_p1
     LET l_sql = "SELECT ima01,ima02,ima05,ima08,ima34,",
				 "ima55,ima55_fac,ima561,ima571,ima86,ima86_fac",
                 " FROM ima_file",
                 " WHERE ima01 = ? "
     PREPARE r310_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-690110 by xiake
        EXIT PROGRAM 
     END IF
     DECLARE r310_c2 CURSOR FOR r310_p2
     CASE tm.b
         #標準成本
         WHEN '1'
         LET l_sql = "SELECT eca01,eca04,ecb02,ecb03,ecb06,ecb17,",
                     " 0,eca04,eca06,eca15,",
                     " eca16,eca18,eca20,eca201,eca22,eca24,eca36,",
                     " eca38,eca40,ecb13,ecb18,ecb19,ecb20,ecb21,ecb22 ,",
                     " ecb23,ecb15,ecb16 ",
                     " FROM ecb_file,eca_file" ,
                     " WHERE eca01 = ecb08 "
         LET l_chr = g_x[26]
#@@
{       #現時成本
        WHEN '2'
         LET l_chr = g_x[27]
  }
        #預設成本
        WHEN '3'
         LET l_sql = "SELECT eca01,eca04,ecb02,ecb03,ecb06,ecb17,",
                     " 0,eca04,eca06,eca15,",
                     " eca26,eca28,eca30,eca301,eca32,eca34,eca42,",
                     " eca44,eca46,ecb13,ecb30,ecb31,ecb32,ecb33,ecb34 ,",
                     " ecb35,ecb15,ecb16 ",
                     " FROM ecb_file,eca_file ",
                     " WHERE  eca01 = ecb08 "
         LET l_chr = g_x[28]
 
     END CASE
     CALL cl_outnam('acsr310') RETURNING l_name
     START REPORT r310_rep TO l_name
 
     LET g_pageno = 0
     FOREACH r310_c1 INTO sr1.ima01,sr1.ima571,sr1.ecb02
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
       IF sr1.ecb02 IS NOT NULL THEN
          IF sr1.ecb02 != tm.ecb02 THEN CONTINUE FOREACH END IF
          LET l_sql1 = " AND ecb01 = '",sr1.ima01,"'",
                       " AND ecb02 = ",tm.ecb02
       ELSE
          IF sr1.ima571 IS NULL THEN CONTINUE FOREACH END IF
          LET l_sql1 = " AND ecb01 = '",sr1.ima571,"'",
                       " AND ecb02 = ",tm.ecb02
       END IF
       OPEN r310_c2 USING sr1.ima01
       FETCH r310_c2 INTO sr1.ima01,sr1.ima02,sr1.ima05,sr1.ima08,
                          sr1.ima34,sr1.ima55,sr1.ima561,sr1.ima571,sr1.ima86
          IF SQLCA.sqlcode THEN CALL cl_err('fetch:',SQLCA.sqlcode,0) END IF
          #成本取得方式,依料件設定且成本中心欄位有值, 則無作業成本
          IF g_sma.sma23 = '3' AND
             sr1.ima34 != ' ' AND sr1.ima34 IS NOT NULL THEN
             CONTINUE FOREACH
          END IF
 
	    #取得生產/成本單位之轉換率
	    IF sr1.ima55 != sr1.ima86 THEN
	    CALL s_umfchk(sr1.ima01,sr1.ima55,sr1.ima86) RETURNING l_flag,l_fac
	    IF l_fac = 0 THEN
              ##Modify:98/11/13 單位換算率不存在 --->show error message
                CALL cl_err(sr1.ima01,'mfg6043',1)
                LET l_fac = sr1.ima55_fac / sr1.ima86_fac END IF
	    ELSE
			 LET l_fac = 1
	    END IF
 
       CASE sr1.ima08
           WHEN 'M' LET l_chr1 = g_x[31]
           WHEN 'P' LET l_chr1 = g_x[32]
           WHEN 'X' LET l_chr1 = g_x[33]
           WHEN 'K' LET l_chr1 = g_x[34]
           WHEN 'U' LET l_chr1 = g_x[35]
           WHEN 'V' LET l_chr1 = g_x[36]
           WHEN 'R' LET l_chr1 = g_x[37]
           WHEN 'S' LET l_chr1 = g_x[38]
           OTHERWISE LET l_chr1 = ''
       END CASE
       LET l_sql2 = l_sql CLIPPED,' ',l_sql1 CLIPPED
       PREPARE r310_p3 FROM l_sql2
       IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-690110 by xiake
          EXIT PROGRAM 
       END IF
       DECLARE r310_c3 CURSOR FOR r310_p3
       FOREACH r310_c3 INTO sr1.eca01,sr1.eca04,sr1.ecb02,sr1.ecb03,
                            sr1.ecb06,sr1.ecb17,sr.*
         IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH END IF
 
         LET sr.ima561   = sr1.ima561
         IF sr.ima561 = 0 OR sr.ima561 IS NULL THEN
            LET sr.ima561 = 1
         END IF
         CALL r310_cost(sr.*) RETURNING sr2.l_scost ,sr2.l_rcost ,sr2.l_hour  ,
                             sr2.m_scost ,sr2.m_rcost,sr2.m_hour  ,sr2.f_bcost ,
                             sr2.v_bcost ,sr2.o_cost ,sr2.fo_bcost,sr2.vo_bcost,
                             sr2.l_total ,sr2.m_total,sr2.b_total ,sr2.o_total
 
         LET sr2.l_scost = sr2.l_scost * tm.qty * l_fac
         LET sr2.l_rcost = sr2.l_rcost * tm.qty * l_fac
         LET sr2.m_scost = sr2.m_scost * tm.qty * l_fac
         LET sr2.m_rcost = sr2.m_rcost * tm.qty * l_fac
         LET sr2.f_bcost = sr2.f_bcost * tm.qty * l_fac
         LET sr2.v_bcost = sr2.v_bcost * tm.qty * l_fac
         LET sr2.o_cost  = sr2.o_cost  * tm.qty * l_fac
         LET sr2.fo_bcost= sr2.fo_bcost* tm.qty * l_fac
         LET sr2.vo_bcost= sr2.vo_bcost* tm.qty * l_fac
         LET sr2.l_total = sr2.l_total * tm.qty * l_fac
         LET sr2.m_total = sr2.m_total * tm.qty * l_fac
         LET sr2.b_total = sr2.b_total * tm.qty * l_fac
         LET sr2.o_total = sr2.o_total * tm.qty * l_fac
 
         OUTPUT TO REPORT r310_rep(sr1.*,sr2.*,l_chr,l_chr1)
 
       END FOREACH
     END FOREACH
 
     FINISH REPORT r310_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r310_rep(sr1,sr2,l_chr,l_chr1)
   DEFINE l_last_sw  LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1),
     sr1 RECORD
         ima01 LIKE ima_file.ima01,   #料件編號
         ima02 LIKE ima_file.ima02,   #品名規格
         ima05 LIKE ima_file.ima05,   #版本
         ima08 LIKE ima_file.ima08,   #來源
         ima34 LIKE ima_file.ima34,   #成本中心
         ima55 LIKE ima_file.ima55,   #生產單位
         ima55_fac LIKE ima_file.ima55_fac, #生產/庫存轉換率
		 ima561 LIKE ima_file.ima561, #最少生產數量
		 ima571 LIKE ima_file.ima571, #主製程料件
		 ima86 LIKE ima_file.ima86,   #成本單位
         ima86_fac LIKE ima_file.ima86_fac, #成本/庫存轉換率
         eca01 LIKE eca_file.eca01,   #工作站編號
         eca04 LIKE eca_file.eca04,   #工作站型態
         ecb02 LIKE ecb_file.ecb02,   #製程編號
         ecb03 LIKE ecb_file.ecb03,   #作業序號
         ecb06 LIKE ecb_file.ecb06,   #作業編號
         ecb17 LIKE ecb_file.ecb17    #說明
     END RECORD,
     sr2 RECORD
         l_scost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #人工設置成本
         l_rcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #人工生產成本
         l_hour      LIKE eca_file.eca09,    #No.FUN-680071 DECIMAL(8,2),    #直接人工小時
         m_scost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器設置成本
         m_rcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器生產成本
         m_hour      LIKE eca_file.eca09,    #No.FUN-680071 DECIMAL(8,2),    #直接機器小時
         f_bcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #固定製造費用
         v_bcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #變動製造費用
         o_cost      LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #廠外加工成本
         fo_bcost    LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #固定廠外加工製造費用
         vo_bcost    LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #變動廠外加工製造費用
         l_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #人工成本小計
         m_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器成本小計
         b_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #製造費用小計
         o_total     LIKE type_file.num20_6  #No.FUN-680071 DECIMAL(20,6)    #廠外加工小計
     END RECORD,
     l_chr	     LIKE type_file.chr8,    #No.FUN-680071 VARCHAR(8),          #成本方式   #No.TQC-6A0079
     l_chr1	     LIKE oea_file.oea01     #No.FUN-680071 VARCHAR(12)          #工作站型態
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr1.ima01,sr1.ecb02
  FORMAT
   PAGE HEADER
#No.FUN-580013  -begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      PRINT
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<'
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT l_chr
      PRINT g_dash
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT COLUMN 63,l_chr   #列印成本選擇
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
      PRINT COLUMN  3,g_x[11] CLIPPED,sr1.ima01 CLIPPED,
            COLUMN 42,g_x[14] CLIPPED,sr1.ima02 CLIPPED,
            COLUMN 83,g_x[12] CLIPPED,sr1.ima05,
            COLUMN 103,g_x[13] CLIPPED,sr1.ima08,
            ' ',l_chr1
      PRINT COLUMN  3,g_x[15] CLIPPED,sr1.ecb02 USING'<<<<<',
            COLUMN 42,g_x[16] CLIPPED,tm.qty  USING'<<<<<',
            ' ',sr1.ima55,COLUMN 103,g_x[43] CLIPPED,sr1.ima86
#     PRINT "-------------------------------------------------------",
#           "-------------------------------------------------------",
#           "----------------------"
      PRINT g_dash2
#     PRINT COLUMN 104,g_x[17] CLIPPED
#     PRINT g_x[18],g_x[19],g_x[20],g_x[21] CLIPPED
#     PRINT g_x[22],g_x[23] CLIPPED,g_x[24],g_x[25] CLIPPED
#     PRINT "---- ------ ---------- ---- -------------- ",
#           "-------------- -------------- -------------- ",
#           "-------------- -------------- --------------"
      PRINT COLUMN g_c[60],g_x[17] CLIPPED
      PRINTX name=H1 g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],
                     g_x[56],g_x[57],g_x[58],g_x[59],g_x[60],g_x[61]
      PRINTX name=H2 g_x[62],g_x[63],g_x[64],g_x[65],g_x[66],
                     g_x[67],g_x[68],g_x[69],g_x[70],g_x[71],g_x[72]
      PRINT g_dash1
#No.FUN-580013  --end
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr1.ima01
      LET g_tot_bal = 0
      IF PAGENO > 0 OR LINENO > 9 THEN
         SKIP TO TOP OF PAGE
      END IF
 
   ON EVERY ROW
      LET g_tot_bal = g_tot_bal +
                        sr2.l_total +     #人工成本
                        sr2.m_total +     #機器成本
                        sr2.b_total +     #製造費用
                        sr2.o_total       #廠外加工
#No.FUN-580013  -begin
#     PRINT sr1.ecb03 USING'####',' ',sr1.ecb06,' ',
#           sr1.eca01,' ';
      PRINTX name=D1
            COLUMN g_c[51],sr1.ecb03 USING'####',
            COLUMN g_c[52],sr1.ecb06,
            COLUMN g_c[53],sr1.eca01;
      CASE sr1.eca04
#          WHEN '0' PRINT g_x[40] CLIPPED;
#          WHEN '1' PRINT g_x[41] CLIPPED;
#          WHEN '2' PRINT g_x[42] CLIPPED;
           WHEN '0' PRINTX name=D1 COLUMN g_c[54],g_x[40] CLIPPED;
           WHEN '1' PRINTX name=D1 COLUMN g_c[54],g_x[41] CLIPPED;
           WHEN '2' PRINTX name=D1 COLUMN g_c[54],g_x[42] CLIPPED;
      END CASE
#     PRINT cl_numfor(sr2.l_scost,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.m_scost,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.f_bcost,14,g_azi03) CLIPPED;
      PRINTX name=D1
            COLUMN g_c[55],cl_numfor(sr2.l_scost,55,g_azi03) CLIPPED,
            COLUMN g_c[56],cl_numfor(sr2.m_scost,56,g_azi03) CLIPPED,
            COLUMN g_c[57],cl_numfor(sr2.f_bcost,57,g_azi03) CLIPPED;
#     PRINT COLUMN 88,cl_numfor(sr2.fo_bcost,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.l_total,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.b_total,14,g_azi03) CLIPPED
      PRINTX name=D1
            COLUMN g_c[59],cl_numfor(sr2.fo_bcost,59,g_azi03) CLIPPED,
            COLUMN g_c[60],cl_numfor(sr2.l_total,60,g_azi03) CLIPPED,
            COLUMN g_c[61],cl_numfor(sr2.b_total,61,g_azi03) CLIPPED
#     PRINT COLUMN 28,cl_numfor(sr2.l_rcost,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.m_rcost,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.v_bcost,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.o_cost,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.vo_bcost,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.m_total,14,g_azi03) CLIPPED,
#           cl_numfor(sr2.o_total,14,g_azi03) CLIPPED
      PRINTX name=D2
            COLUMN g_c[66],cl_numfor(sr2.l_rcost,66,g_azi03) CLIPPED,
            COLUMN g_c[67],cl_numfor(sr2.m_rcost,67,g_azi03) CLIPPED,
            COLUMN g_c[68],cl_numfor(sr2.v_bcost,68,g_azi03) CLIPPED,
            COLUMN g_c[69],cl_numfor(sr2.o_cost,69,g_azi03) CLIPPED,
            COLUMN g_c[70],cl_numfor(sr2.vo_bcost,70,g_azi03) CLIPPED,
            COLUMN g_c[71],cl_numfor(sr2.m_total,71,g_azi03) CLIPPED,
            COLUMN g_c[72],cl_numfor(sr2.o_total,72,g_azi03) CLIPPED
#     PRINT COLUMN 13,sr1.ecb17
      PRINT COLUMN g_c[53],sr1.ecb17
#No.FUN-580013  --end
      SKIP 1  LINE
 
   AFTER GROUP OF sr1.ima01
      LET g_pageno = 0
#No.FUN-580013  --begin
#     PRINT COLUMN 114,g_x[30] CLIPPED,
#           cl_numfor(g_tot_bal,14,g_azi03) CLIPPED
#     PRINT g_dash[1,g_len]
      PRINT COLUMN g_c[60],g_x[30] CLIPPED,
            COLUMN g_c[61],cl_numfor(g_tot_bal,61,g_azi03) CLIPPED
#No.FUN-580013  --end
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
         #No.TQC-630166 --start--
#        IF tm.wc[001,120] > ' ' THEN			# for 132
#		    PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED
#        END IF
#        IF tm.wc[121,240] > ' ' THEN
#		    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED
#        END IF
#        IF tm.wc[241,300] > ' ' THEN
#		    PRINT COLUMN 10,     tm.wc[241,300] CLIPPED
#        END IF
         CALL cl_prt_pos_wc(tm.wc)
         #No.TQC-630166 ---end---
      END IF
      LET l_last_sw = 'y'
      PRINT g_dash
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
 
#--->人工成本取得方式為 -------製程與工作站--------------------
FUNCTION  r310_cost(sr)
  DEFINE
     sr  RECORD
         ima561 LIKE ima_file.ima561, #最少生產數量
         eca04 LIKE eca_file.eca04,   #工作站型態
         eca06 LIKE eca_file.eca06,   #產能型態
		 eca15 LIKE eca_file.eca15,   #製造費用分擔基準
		 eca16 LIKE eca_file.eca16,   #人工設置成本率
		 eca18 LIKE eca_file.eca18,   #人工生產成本率
		 eca20 LIKE eca_file.eca20,   #機器設置成本率
		 eca201 LIKE eca_file.eca201, #機器生產成本率
		 eca22 LIKE eca_file.eca22,   #固定製造費用分攤率
		 eca24 LIKE eca_file.eca24,   #變動製造費用分攤率
		 eca36 LIKE eca_file.eca36,   #加工單位成本
		 eca38 LIKE eca_file.eca38,   #加工固定製造費用分攤率
		 eca40 LIKE eca_file.eca40,   #加工變動製造費用分攤率
		 ecb13 LIKE ecb_file.ecb13,   #成本計算基準
		 ecb18 LIKE ecb_file.ecb18,   #人工設置時間
		 ecb19 LIKE ecb_file.ecb19,   #人工生產時間
		 ecb20 LIKE ecb_file.ecb20,   #機器設置時間
		 ecb21 LIKE ecb_file.ecb21,   #機器生產時間
		 ecb22 LIKE ecb_file.ecb22,   #廠外加工時間
		 ecb23 LIKE ecb_file.ecb23,   #廠外加工成本
         ecb15 LIKE ecb_file.ecb15,   #人工數
         ecb16 LIKE ecb_file.ecb16    #機器數
     END RECORD,
     sr2 RECORD
         l_scost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #人工設置成本
         l_rcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #人工生產成本
         l_hour      LIKE eca_file.eca09,    #No.FUN-680071 DECIMAL(8,2),    #直接人工小時
         m_scost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器設置成本
         m_rcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器生產成本
         m_hour      LIKE eca_file.eca09,    #No.FUN-680071 DECIMAL(8,2),    #直接機器小時
         f_bcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #固定製造費用
         v_bcost     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #變動製造費用
         o_cost      LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #廠外加工成本
         fo_bcost    LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #固定廠外加工製造費用
         vo_bcost    LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #變動廠外加工製造費用
         l_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #人工成本小計
         m_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #機器成本小計
         b_total     LIKE type_file.num20_6, #No.FUN-680071 DECIMAL(20,6),   #製造費用小計
         o_total     LIKE type_file.num20_6  #No.FUN-680071 DECIMAL(20,6)    #廠外加工小計
     END RECORD
  LET sr2.l_scost  =  0   LET sr2.l_rcost  =  0   LET sr2.l_hour  =  0
  LET sr2.m_scost  =  0   LET sr2.m_rcost  =  0   LET sr2.m_hour  =  0
  LET sr2.f_bcost  =  0   LET sr2.v_bcost  =  0   LET sr2.o_cost  =  0
  LET sr2.fo_bcost =  0   LET sr2.vo_bcost =  0
  LET sr2.l_total =  0    LET sr2.m_total  =  0
  LET sr2.b_total  =  0   LET sr2.o_total =  0
  IF sr.eca04 ='0' THEN #正常工作站
	   CASE sr.eca06
	   WHEN '2'   #人工產能
          #人工設置成本及生產成本計算 (機器成本為0)
		  IF sr.ecb13='2' THEN            #unit/hour   #僅run time 考慮
             IF sr.ecb19 != 0 THEN
			    LET sr2.l_rcost=(1/sr.ecb19/60*sr.eca18)              #生產成本
             END IF
             #用以計算固定製造費用
    	     LET sr2.l_hour = (sr.ecb18/sr.ima561/60)              #直接人工小時
             #若生產時間為零
             IF sr.ecb19 != 0 THEN
    	        LET sr2.l_hour = sr2.l_hour                        #直接人工小時
     		                 +(1/sr.ecb19/60)
             END IF
		  ELSE
             LET sr2.l_rcost=(sr.ecb19/60*sr.eca18)                #生產成本
             #用以計算固定製造費用
    	     LET sr2.l_hour = (sr.ecb18/sr.ima561/60)              #直接人工小時
     		                 +(sr.ecb19/60)
		  END IF
     	  LET sr2.l_scost=(sr.ecb18/sr.ima561/60*sr.eca16)         #設置成本
          #人工成本小計
          LET sr2.l_total= sr2.l_scost+   #設置成本
		                   sr2.l_rcost    #生產成本
	   WHEN '1'  #機器產能
		  IF sr.ecb13='2'  THEN                          #unit/hour
			 #--------直接人工成本-----#
           IF sr.ima561=0 OR sr.ecb16=0 THEN
              LET sr2.l_scost=0
           ELSE
     	      LET sr2.l_scost=(sr.ecb20/sr.ima561/60*sr.ecb15/sr.ecb16*sr.eca16)
           END IF
             #若機器生產時間不為零
             IF sr.ecb21 != 0 THEN
        	    LET sr2.l_rcost= (1/sr.ecb21/60*sr.ecb15/sr.ecb16*sr.eca18)
             END IF
			 #--------直接人工小時----#
             #用以計算固定製造費用
             IF sr.ima561 = 0 OR sr.ecb16 = 0 THEN
                LET sr2.l_hour = 0
             ELSE
     	        LET sr2.l_hour = (sr.ecb20/sr.ima561/60*sr.ecb15/sr.ecb16)
             END IF
             #若機器生產時間不為零
             IF sr.ecb21 != 0 THEN
                LET sr2.l_hour = sr2.l_hour
     				  +(1/sr.ecb21/60*sr.ecb15/sr.ecb16)#直接人工小時
             END IF
             #--------機器成本---------#
     		  LET sr2.m_scost =(sr.ecb20/sr.ima561/60*sr.eca20) #機器設置成本
             #若機器生產時間不為零
              IF sr.ecb21 != 0 THEN
 	             LET sr2.m_rcost =(1/sr.ecb21/60*sr.eca201)        #機器生產成本
              END IF
              #機器成本小計
		      LET sr2.m_total = sr2.m_scost +       #機器設置成本
						        sr2.m_rcost         #機器生產成本
		     #------機器小時----------#
             #用以計算固定製造費用
	          LET sr2.m_hour = (sr.ecb20/sr.ima561/60)            #機器小時
             #若機器生產時間不為零
              IF sr.ecb21 != 0 THEN
                 LET sr2.m_hour = sr2.m_hour
		        		        +(1/sr.ecb21/60)
              END IF
		  ELSE  #--------直接人工成本-----#
		     LET sr2.l_scost=(sr.ecb20/sr.ima561/60*sr.ecb15/sr.ecb16*sr.eca16)
		     LET sr2.l_rcost=(sr.ecb21/60*sr.ecb15/sr.ecb16*sr.eca18)
             #人工成本小計
             LET sr2.l_total= sr2.l_scost+   #設置成本
		                      sr2.l_rcost    #生產成本
		        #--------直接人工小時----#
		     LET sr2.l_hour = (sr.ecb20/sr.ima561/60*sr.ecb15/sr.ecb16)
					         +(sr.ecb21/60*sr.ecb15/sr.ecb16)  #直接人工小時
               #--------機器成本---------#
		     LET sr2.m_scost =(sr.ecb20/sr.ima561/60*sr.eca20) #機器設置成本
		     LET sr2.m_rcost=(sr.ecb21/60*sr.eca201)         #機器生產成本
             #機器成本小計
		     LET sr2.m_total= sr2.m_scost+         #機器設置成本
			   			      sr2.m_rcost          #機器生產成本
		     #------機器小時----------#
		     LET sr2.m_hour = (sr.ecb20/sr.ima561/60)      #機器小時
			   		         +(sr.ecb21/60)
	   	  END IF
   	   END CASE
#---->計算indirect labor cost (固定製造費用及變動製造費用)
#---->當為人工產能只能以[1256]計算其製造費用
#---->當為機器產能只能以[3456]計算其製造費用
#     直接人工成本*直接人工製/費用分攤率
#      IF sr.eca15 IS NULL THEN LET sr.eca15 = 1 END IF
 
       CASE sr.eca15
          WHEN '1' #直接人工成本
            IF sr.eca06 = '2'  THEN #人工產能
               LET sr2.f_bcost = sr2.l_total * sr.eca22
               LET sr2.v_bcost = sr2.l_total * sr.eca24
            END IF
 
          WHEN '2' #直接人工小時
            IF sr.eca06 = '2' THEN
               LET sr2.f_bcost = sr2.l_hour * sr.eca22
               LET sr2.v_bcost = sr2.l_hour * sr.eca24
            END IF
 
          WHEN '3' #機器成本
            IF sr.eca06='1' THEN     #機器產能
               LET sr2.f_bcost = sr2.m_total * sr.eca22
               LET sr2.v_bcost = sr2.m_total * sr.eca24
            END IF
 
          WHEN '4' #機器小時
            IF sr.eca06='1'  THEN    #機器產能
               LET sr2.f_bcost = sr2.m_hour * sr.eca22
               LET sr2.v_bcost = sr2.m_hour * sr.eca24
            END IF
#@@
          WHEN '5' #直接材料成本
             LET sr2.f_bcost = 0 * sr.eca22
             LET sr2.v_bcost = 0 * sr.eca24
 
          WHEN '6' #生產數量
             LET sr2.f_bcost =sr.eca22
             LET sr2.v_bcost =sr.eca24
 
          OTHERWISE EXIT CASE
       END CASE
       LET sr2.b_total = sr2.f_bcost + sr2.v_bcost
 
    ELSE   #廠外/廠內加工
       LET sr2.o_cost = sr.ecb23
       LET sr2.fo_bcost = sr2.o_cost * sr.eca38
       LET sr2.vo_bcost = sr2.o_cost * sr.eca40
       LET sr2.o_total  = sr2.o_cost + sr2.fo_bcost + sr2.vo_bcost
    END IF
    RETURN sr2.l_scost ,sr2.l_rcost ,sr2.l_hour  ,sr2.m_scost ,sr2.m_rcost,
           sr2.m_hour  ,sr2.f_bcost ,sr2.v_bcost ,sr2.o_cost  ,sr2.fo_bcost,
           sr2.vo_bcost,sr2.l_total ,sr2.m_total ,sr2.b_total ,sr2.o_total
END FUNCTION
#Patch....NO.TQC-610035 <002> #
#TQC-790177
