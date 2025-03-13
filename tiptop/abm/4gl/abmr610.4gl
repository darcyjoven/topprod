# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abmr610.4gl
# Descriptions...: 單階材料用途清單
# Input parameter:
# Return code....:
# Date & Author..: 91/08/05 By Lee
# Modify         : 92/05/27 By David
# Modify.........: 92/10/28 By Apple
# Modify.........: 93/04/28 By Apple
# Modify.........: 94/08/17 By Danny 改由bmt_file取插件位置
#	.........: 將組成用量(bmb06)/底數(bmb07) show QPA  改bmb06 show QPA
# Modify.........: No:8378 03/10/01 By Melody ima的欄位下QBE條件時,會出現-324的錯誤訊息,因 OUTER用法特殊,應改掉
# Modify.........: No.FUN-4A0002 04/10/02 By Yuna 元件編號開窗
# Modify.........: No.FUN-510033 05/02/15 By Mandy 報表轉XML
# Modify.........: No.FUN-550095 05/05/30 By Mandy 特性BOM
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.MOD-740054 07/04/24 By pengu PRINT COLUMN 88,l_bmt06[3]改成PRINT COLUMN g_c[46],l_bmt06[3]
# Modify.........: No.TQC-760170 07/06/26 By claire 調整列印的語法
# Modify.........: No.FUN-7C0066 07/12/27 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40058 10/04/27 By lilingyu bmb16增加規格替代的內容
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
       		wc  	  LIKE type_file.chr1000,# Where condition  #No.FUN-680096 VARCHAR(500)
            	effective LIKE type_file.dat,   # 有效日期  #No.FUN-680096 DATE
             	arrange   LIKE type_file.chr1,  # 資料排列方式  #No.FUN-680096 VARCHAR(1)
             	engine    LIKE type_file.chr1,  # 是否列印工程資料  #No.FUN-680096 VARCHAR(1)
                blow      LIKE type_file.chr1,  #No.FUN-680096 VARCHAR(1)
       	    	more	  LIKE type_file.chr1   # Input more condition(Y/N)  #No.FUN-680096 VARCHAR(1)
              END RECORD,
          sr  RECORD
              order1  LIKE bmb_file.bmb01,  #No.FUN-680096 VARCHAR(20),
              bmb01 LIKE bmb_file.bmb01,    #主件料件
              bmb29 LIKE bmb_file.bmb29,    #FUN-550095 add
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb11 LIKE bmb_file.bmb11,    #工程圖號
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              phatom LIKE bmb_file.bmb03,
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37     #補貨
          END RECORD,
          sr2 RECORD
              ima02  LIKE ima_file.ima02,
              ima05  LIKE ima_file.ima05,
              ima08  LIKE ima_file.ima08,
              ima37  LIKE ima_file.ima37
          END RECORD,
          g_bmb03  LIKE bmb_file.bmb03,
          g_ima02 LIKE ima_file.ima02,    #品名規格
          g_ima05 LIKE ima_file.ima05,    #版本
          g_ima06 LIKE ima_file.ima06,    #分群碼
          g_ima08 LIKE ima_file.ima08,    #來源
          g_ima37 LIKE ima_file.ima37     #補貨
 
DEFINE   g_cnt    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i      LIKE type_file.num5     #count/index for any purpose        #No.FUN-680096 SMALLINT
 
DEFINE   l_table1 STRING                  #FUN-7C0066
DEFINE   l_table2 STRING                  #FUN-7C0066
DEFINE   l_table3 STRING                  #FUN-7C0066
DEFINE   g_sql    STRING                  #FUN-7C0066
DEFINE   g_str    STRING                  #FUN-7C0066
 
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107 #FUN-BB0047 mark
 
   #FUN-7C0066 --START
   LET g_sql = "order1.bmb_file.bmb01,",                                                                
               "bmb01.bmb_file.bmb01,",    #主件料件                                                                               
               "bmb29.bmb_file.bmb29,",                                                                         
               "bmb15.bmb_file.bmb15,",    #元件耗用特性                                                                           
               "bmb16.bmb_file.bmb16,",    #替代特性                                                                               
               "bmb03.bmb_file.bmb03,",    #元件料號                                                                               
               "bmb02.bmb_file.bmb02,",    #項次                                                                                   
               "bmb06.bmb_file.bmb06,",    #QPA                                                                                    
               "bmb07.bmb_file.bmb07,",    #底數                                                                                   
               "bmb08.bmb_file.bmb08,",    #損耗率%                                                                                
               "bmb10.bmb_file.bmb10,",    #發料單位                                                                               
               "bmb18.bmb_file.bmb18,",    #投料時距                                                                               
               "bmb09.bmb_file.bmb09,",    #制程序號                                                                               
               "bmb04.bmb_file.bmb04,",    #有效日期                                                                               
               "bmb05.bmb_file.bmb05,",    #失效日期                                                                               
               "bmb14.bmb_file.bmb14,",    #元件使用特性                                                                           
               "bmb17.bmb_file.bmb17,",    #Feature                                                                                
               "bmb11.bmb_file.bmb11,",    #工程圖號                                                                               
               "bmb13.bmb_file.bmb13,",    #插件位置                                                                               
               "phatom.bmb_file.bmb03,",                                                                                           
               "ima02.ima_file.ima02,",    #品名規格                                                                               
               "ima05.ima_file.ima05,",    #版本      
               "ima06.ima_file.ima06,",    #分群碼                                                                                 
               "ima08.ima_file.ima08,",    #來源                                                                                   
               "ima15.ima_file.ima15,",    #保稅否                                                                                 
               "ima37.ima_file.ima37,",    #補貨  
               "l_ima02.ima_file.ima02,",                                                                                             
               "l_ima05.ima_file.ima05,",                                                                                           
               "l_ima08.ima_file.ima08,",                                                                                           
               "l_ima37.ima_file.ima37,",
               "l_imz02.imz_file.imz02,",
               "l_ima021.ima_file.ima021,",
               "l_ver.ima_file.ima05,",
               "l_m_item.type_file.chr1000"
 
   LET l_table1 = cl_prt_temptable('abmr6101',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "bmt01.bmt_file.bmt01,",
               "bmt02.bmt_file.bmt02,",
               "bmt03.bmt_file.bmt03,",
               "bmt04.bmt_file.bmt04,",
               "bmt08.bmt_file.bmt08,",
               "bmt05.bmt_file.bmt05,",
               "bmt06.type_file.chr1000"
 
   LET l_table2 = cl_prt_temptable('abmr6102',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "bmc01.bmc_file.bmc01,",
               "bmc02.bmc_file.bmc02,",
               "bmc021.bmc_file.bmc021,",
               "bmc03.bmc_file.bmc03,",
               "bmc06.bmc_file.bmc06,",
               "bmc04.bmc_file.bmc04,",
               "bmc05.type_file.chr1000"
 
   LET l_table3 = cl_prt_temptable('abmr6103',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
   #FUN-7C0066 --END
     
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.effective  = ARG_VAL(8)
   LET tm.arrange  = ARG_VAL(9)
   LET tm.engine  = ARG_VAL(10)
   LET tm.blow    = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL abmr610_tm(0,0)			# Input print condition
      ELSE CALL abmr610()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION abmr610_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT,
          l_one         LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01),   #資料筆數
          l_bdate       LIKE bmx_file.bmx07,
          l_edate       LIKE bmx_file.bmx08,
          l_bmb03       LIKE bmb_file.bmb01,	#工程變異之生效日期
          l_ima06       LIKE ima_file.ima06,	#工程變異之生效日期
          l_cmd		LIKE type_file.chr1000  #No.FUN-680096  VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 15
   ELSE
       LET p_row = 4 LET p_col = 11
   END IF
 
   OPEN WINDOW abmr610_w AT p_row,p_col
        WITH FORM "abm/42f/abmr610"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.arrange ='1'              #按元件料件編號遞增順序排列
   LET tm.engine ='N'               #不列印工程技術資料
   LET tm.effective = g_today	    #有效日期
  #---------No.FUN-670041 modify
  #LET tm.blow = g_sma.sma29
   LET tm.blow = 'Y'
  #---------No.FUN-670041 modify
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON bmb03,ima06,ima09,ima10,ima11,ima12
 
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
     #--No.FUN-4A0002--------
     ON ACTION CONTROLP
        CASE WHEN INFIELD(bmb03) #元件編號
           CALL cl_init_qry_var()
 	   LET g_qryparam.state= "c"
 	   LET g_qryparam.form = "q_ima"
 	   CALL cl_create_qry() RETURNING g_qryparam.multiret
 	   DISPLAY g_qryparam.multiret TO bmb03
 	   NEXT FIELD bmb03
       OTHERWISE EXIT CASE
     END CASE
    #--END---------------
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abmr610_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT bmb03 FROM bmb_file,ima_file",
           " WHERE bmb03 = ima01  AND ", tm.wc CLIPPED
       MESSAGE " SEARCHING ! "
       CALL ui.Interface.refresh()
       PREPARE r610_cnt_p FROM l_cmd
       DECLARE r610_cnt CURSOR FOR r610_cnt_p
       IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
       END IF
       FOREACH r610_cnt
       INTO l_bmb03
         IF SQLCA.sqlcode  THEN
            CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
            CONTINUE WHILE
         ELSE
            LET l_one = 'Y'
            EXIT FOREACH
         END IF
       END FOREACH
       MESSAGE " "
       CALL ui.Interface.refresh()
       IF l_bmb03 IS NULL OR l_bmb03 = ' ' THEN
          CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
          CONTINUE WHILE
       END IF
   END IF
   INPUT BY NAME tm.effective,tm.arrange,tm.engine,tm.blow,
                  tm.more WITHOUT DEFAULTS
      AFTER FIELD arrange
         IF tm.arrange NOT MATCHES '[12]' THEN
             NEXT FIELD arrange
         END IF
      AFTER FIELD engine
         IF tm.engine NOT MATCHES '[YN]' THEN
             NEXT FIELD engine
         END IF
      AFTER FIELD blow
         IF tm.blow IS NULL OR tm.blow NOT MATCHES'[yYnN]'
         THEN NEXT FIELD blow
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON ACTION CONTROLP CALL abmr610_wc()   # Input detail Where Condition
         IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW abmr610_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr610'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr610','9031',1)
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
                         " '",tm.effective CLIPPED,"'",
                         " '",tm.arrange CLIPPED,"'",
                         " '",tm.engine  CLIPPED,"'",
                         " '",tm.blow    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr610',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW abmr610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr610()
   ERROR ""
END WHILE
   CLOSE WINDOW abmr610_w
END FUNCTION
 
FUNCTION abmr610_wc()
   DEFINE l_wc LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW abmr610_w2 AT 2,2
        WITH FORM "abm/42f/abmi600"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi600")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        bmb02,bmb03,bmb04,bmb05,bmb06,bmb07,bmb08,bmb10
        FROM
        bma01,bma04,bmauser,bmagrup,bmamodu,bmadate,bmaacti,
        s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb04,s_bmb[1].bmb05,
        s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb08,s_bmb[1].bmb10
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
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
 
   CLOSE WINDOW abmr610_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
FUNCTION r610_cur()
DEFINE l_cmd  LIKE type_file.chr1000,    #No.FUN-680096 VARCHAR(1000)
       l_sql  LIKE type_file.chr1000     #No.FUN-680096 VARCHAR(1000)
 
     #-->產品結構插件位置
     LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                  " WHERE bmt01=?  AND bmt02= ? AND ",
                  " bmt03=? AND ",
                  " (bmt04 IS NULL OR bmt04 >= ?) ",
                  " AND bmt08 = ? ", #FUN-550095 add
                  " ORDER BY 1"
     PREPARE r610_prebmt     FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r610_bmt  CURSOR FOR r610_prebmt
 
     #-->產品結構說明資料
     LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                  " WHERE bmc01=?  AND bmc02= ? AND ",
                  " bmc021=? AND ",
                  " (bmc03 IS NULL OR bmc03 >= ?) ",
                  " AND bmc06 = ? ", #FUN-550095 add
                  " ORDER BY 1"
     PREPARE r610_prebmc    FROM l_cmd
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r610_bmc CURSOR FOR r610_prebmc
 
#    LET l_sql = "SELECT '',",    #95/12/22 Modify By Lynn
#                " bma01,bmb15,bmb16,bmb03,",
#                " bmb02,bmb06,bmb07,bmb08,",
#                " bmb10,bmb18,bmb09,bmb04,bmb05,",
#                " bmb14,bmb17,bmb11,bmb13,'',",
#                " A.ima02,A.ima05,A.ima06,A.ima08,A.ima15,A.ima37,",
#                " B.ima02,B.ima05,B.ima08,B.ima37 ",
#                " FROM bmb_file,OUTER ima_file A,",
#                "      bma_file,OUTER ima_file B ",
#                " WHERE bma01=bmb01 AND ",
#                " bmb03 = A.ima01 AND bma01 = B.ima01 ",
#                " AND bmb03 = ? "
#No:8378
  LET l_sql = "SELECT '',",    #95/12/22 Modify By Lynn
                 " bma01,bma06,bmb15,bmb16,bmb03,", #FUN-550095 add bma06
                 " bmb02,bmb06,bmb07,bmb08,",
                 " bmb10,bmb18,bmb09,bmb04,bmb05,",
                 " bmb14,bmb17,bmb11,bmb13,'',",
                 " ima02,ima05,ima06,ima08,ima15,ima37,'','','','' ",
                 " FROM bmb_file,OUTER ima_file,bma_file ",    #-----No:8378
                 " WHERE bma01=bmb01 AND bmb_file.bmb03 = ima_file.ima01 AND bmb03 = ? ",
                 "   AND bma06=bmb29" #FUN-550095 add
#No:8378(end)
 
     #生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
          LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
          "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
          "' OR bmb05 IS NULL)"
     END IF
     PREPARE r610_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r610_cs2 CURSOR WITH HOLD FOR r610_prepare2
END FUNCTION
 
FUNCTION r610_phatom(p_phatom,p_qpa)
   DEFINE p_phatom      LIKE bmb_file.bmb01,
          p_qpa         LIKE bmb_file.bmb06,
          l_ac,l_i      LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_tot,l_times LIKE type_file.num5,     #No.FUN-680096 SMALLINT,
          arrno		LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #BUFFER SIZE (可存筆數)
          b_seq		LIKE type_file.num5,     #No.FUN-680096 SMALLINT,  #當BUFFER滿時,重新讀單身之起始序號
          l_chr		LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          l_ute_flag    LIKE type_file.chr3,     #No.FUN-680096 VARCHAR(2),   #FUN-A40058 chr2->chr3
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              order1  LIKE bmb_file.bmb01,  #No.FUN-680096 VARCHAR(20),
              bmb01 LIKE bmb_file.bmb01,    #主件料件
              bmb29 LIKE bmb_file.bmb29,    #FUN-550095 add
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb07 LIKE bmb_file.bmb07,    #底數
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb11 LIKE bmb_file.bmb11,    #工程圖號
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              phatom LIKE bmb_file.bmb03,
              ima02 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima06 LIKE ima_file.ima06,    #分群碼
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15,    #保稅否
              ima37 LIKE ima_file.ima37     #補貨
          END RECORD,
          sr2 DYNAMIC ARRAY OF RECORD       #每階存放資料
              ima02  LIKE ima_file.ima02,
              ima05  LIKE ima_file.ima05,
              ima08  LIKE ima_file.ima08,
              ima37  LIKE ima_file.ima37
          END RECORD,
          l_bmb01  LIKE bmb_file.bmb01
 
   #FUN-7C0066 --STR                                                                                                                   
   DEFINE l_ima021 LIKE ima_file.ima021,  #FUN-510033                                                                               
          l_imz02 LIKE imz_file.imz02,    #說明內容                                                                                 
          l_bmt05 LIKE bmt_file.bmt05,                                                                                              
          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06,  #插件位置  #No.FUN-680096 VARCHAR(20)                                            
          l_bmc05 ARRAY[200] OF LIKE bmc_file.bmc05,  #說明      #No.FUN-680096 VARCHAR(10)                                            
          l_bmc04 LIKE bmc_file.bmc04,                                                                                              
          l_ver   LIKE ima_file.ima05,                                                                                              
          l_byte,l_len        LIKE type_file.num5,    #No.FUN-680096 SMALLINT,                                                      
          l_bmt06_s           LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20),                                                      
          l_bmtstr            LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20),                                                      
          l_now,l_now2,l_now3 LIKE type_file.num5,    #No.FUN-680096 SMALLINT,                                                      
          l_m_item            LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(100) #FUN-550095 add                                      
   DEFINE l_bmc051 ARRAY[200] OF VARCHAR(30)
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                        
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                                                            
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"                                                                           
                                                                                                                                   
    PREPARE insert_prep3 FROM g_sql                                                                                                 
    IF STATUS THEN                                                                                                                 
       CALL cl_err('insert_prep3:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM                                                                           
    END IF 
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                        
                 " VALUES(?,?,?,?,?, ?,?)"                                                                                        
                                                                                                                                    
    PREPARE insert_prep4 FROM g_sql                                                                                                
    IF STATUS THEN                                                                                                                 
       CALL cl_err('insert_prep4:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM                                                                          
    END IF                                                                                                                         
                                                                                                                                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                                        
                " VALUES(?,?,?,?,?, ?,?)"                                                                                      
                                                                                                                                    
    PREPARE insert_prep5 FROM g_sql                                                                                                
    IF STATUS THEN                                                                                                                 
       CALL cl_err('insert_prep5:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM                                                                          
    END IF            
    #FUN-7C0066 --END
 
    LET l_ac = 1
    LET arrno = 600
    LET l_ute_flag='USZ'           #FUN-A40058 add 'Z'
    FOREACH r610_cs2
    USING p_phatom
    INTO sr[l_ac].*,sr2[l_ac].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #-----No:8378
       SELECT ima02,ima05,ima08,ima37
          INTO sr2[l_ac].ima02,sr2[l_ac].ima05, sr2[l_ac].ima08, sr2[l_ac].ima37
       FROM bma_file,OUTER ima_file
       WHERE bma01 = sr[l_ac].bmb01
          AND bma01 = ima_file.ima01
       IF STATUS THEN
          LET sr2[l_ac].ima02=' '
          LET sr2[l_ac].ima05=' '
          LET sr2[l_ac].ima08=' '
          LET sr2[l_ac].ima37=' '
       END IF
       #-----
 
       LET sr[l_ac].phatom = p_phatom
       LET sr[l_ac].bmb06= sr[l_ac].bmb06 * p_qpa
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
    LET l_tot=l_ac-1
    FOR l_i = 1 TO l_tot		# 讀BUFFER傳給REPORT
       IF sr2[l_i].ima08 = 'X' AND tm.blow = 'Y' THEN
          CALL r610_phatom(sr[l_i].bmb01,sr[l_i].bmb06)
          CONTINUE FOR
       END IF
       IF tm.arrange='1' THEN
          LET sr[l_i].order1=sr[l_i].bmb01
       ELSE LET sr[l_i].order1=sr[l_i].bmb02 using'#####'
       END IF
       #---->使用特性
       IF sr[l_i].bmb14='1' THEN
          LET sr[l_i].bmb14='O'
       ELSE
          LET sr[l_i].bmb14=''
       END IF
       #---->消耗特性
       IF sr[l_i].bmb15 = 'Y' THEN
          LET sr[l_i].bmb15 = '*'
       ELSE LET sr[l_i].bmb15 = ' '
       END IF
       #--->改變替代特性的表示方式
       IF sr[l_i].bmb16 MATCHES '[127]' THEN                    #FUN-A40058 add '7'
           LET g_cnt=sr[l_i].bmb16 USING '&'
           LET sr[l_i].bmb16=l_ute_flag[g_cnt,g_cnt]
       ELSE
           LET sr[l_i].bmb16=' '
       END IF
       #--->特性料件
       IF sr[l_i].bmb17='Y' THEN
          LET sr[l_i].bmb17='F'
       ELSE
          LET sr[l_i].bmb17=' '
       END IF
       LET sr[l_i].bmb03= g_bmb03
       LET sr[l_i].ima02= g_ima02
       LET sr[l_i].ima05= g_ima05
       LET sr[l_i].ima06= g_ima06
       LET sr[l_i].ima08= g_ima08
       LET sr[l_i].ima37= g_ima37
 
       #FUN-7C0066 --STR
       #OUTPUT TO REPORT abmr610_rep(sr[l_i].*,sr2[l_i].*) 
 
       SELECT imz02 INTO l_imz02 FROM imz_file                                                                                       
          WHERE imz01 = sr[l_i].ima06                                                                                                 
       IF SQLCA.sqlcode THEN  LET l_imz02 = NULL END IF
 
       #-->讀取插件位置                                                                                                              
       FOR g_cnt=1 TO 200                                                                                                            
          LET l_bmt06[g_cnt]=NULL                                                                                                   
       END FOR                                                                                                                       
       LET l_now2=1                                                                                                                  
       LET l_len =20                                                                                                                 
       LET l_bmtstr = ''                                                                                                             
       FOREACH r610_bmt                                                                                                              
       USING sr[l_i].bmb01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bmb29                                                       
       INTO l_bmt05,l_bmt06_s                                                                                                        
          IF SQLCA.sqlcode THEN                                                                                                      
             CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                                    
          END IF                                                                                                                     
          IF l_now2 > 200 THEN                                                                                                       
             CALL cl_err('','9036',1)                                                                                                
             CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                            
             EXIT PROGRAM                                                                                                            
          END IF                                                                                                                     
          LET l_byte = length(l_bmt06_s) + 1                                                                                         
          IF l_len >=l_byte THEN                                                                                                     
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
       END FOREACH
       IF l_now2 > 0 THEN LET l_bmt06[l_now2] = l_bmtstr END IF
       FOR g_cnt=4 TO l_now2
          IF l_bmt06[g_cnt]='' OR l_bmt06[g_cnt] IS NULL THEN
             EXIT FOR
          END IF       
          EXECUTE insert_prep4 USING sr[l_i].bmb01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,
                                     sr[l_i].bmb29, l_bmt05,l_bmt06[g_cnt]
       END FOR                                                                                                         
                                                                                                                   
       #-->讀取說明的部份                                                                                                            
       FOR g_cnt=1 TO 200                                                                                                            
          LET l_bmc05[g_cnt]=NULL                                                                                                   
       END FOR                                                                                                                       
       LET l_now=1                                                                                                                   
       FOREACH r610_bmc                                                                                                              
       USING sr[l_i].bmb01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,sr[l_i].bmb29                                                       
       INTO l_bmc04,l_bmc05[l_now]                                                                                                   
          IF SQLCA.sqlcode THEN                                                                                                     
             CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                                   
          END IF                                                                                                                    
          IF l_now > 200 THEN                                                                                                       
             CALL cl_err('','9036',1)                                                                                              
             CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                          
             EXIT PROGRAM  
          END IF     
          LET l_now=l_now+1
       END FOREACH
       LET l_now=l_now+1   
       IF l_now>=1 THEN
          FOR g_cnt=1 TO l_now STEP 2
             IF not cl_null(l_bmc05[g_cnt+1]) THEN
                LET l_bmc051[g_cnt]=l_bmc05[g_cnt],' ',l_bmc05[g_cnt+1]
             ELSE
                LET l_bmc051[g_cnt]=l_bmc05[g_cnt]
             END IF                                                                                                             
             EXECUTE insert_prep5 USING sr[l_i].bmb01,sr[l_i].bmb02,sr[l_i].bmb03,sr[l_i].bmb04,
                                     sr[l_i].bmb29,l_bmc04,l_bmc051[g_cnt]
          END FOR
       END IF                                                                                                                          
       CALL s_effver(sr[l_i].bmb01,tm.effective) RETURNING l_ver                                                                          
       LET l_m_item=sr[l_i].bmb01 CLIPPED,' ',sr[l_i].bmb29 CLIPPED
       SELECT ima021 INTO l_ima021 FROM ima_file                                                                                     
          WHERE ima01=sr[l_i].bmb01 
       
       EXECUTE insert_prep3 USING sr[l_i].order1,sr[l_i].bmb01, sr[l_i].bmb29, sr[l_i].bmb15,
                                  sr[l_i].bmb16,sr[l_i].bmb03, sr[l_i].bmb02, sr[l_i].bmb06,
                                  sr[l_i].bmb07, sr[l_i].bmb08,sr[l_i].bmb10, sr[l_i].bmb18,
                                  sr[l_i].bmb09, sr[l_i].bmb04, sr[l_i].bmb05,sr[l_i].bmb14,   
                                  sr[l_i].bmb17, sr[l_i].bmb11, sr[l_i].bmb13, sr[l_i].phatom,
                                  sr[l_i].ima02, sr[l_i].ima05, sr[l_i].ima06, sr[l_i].ima08, 
                                  sr[l_i].ima15,sr[l_i].ima37, sr2[l_i].ima02,sr2[l_i].ima05,
                                  sr2[l_i].ima08,sr2[l_i].ima37,l_imz02,l_ima021,l_ver,l_m_item
       #FUN-7C0066 --END         
    
    END FOR
END FUNCTION
 
FUNCTION abmr610()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20), # External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_use_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2),
          l_ute_flag    LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(2),       #FUN-A40058 chr2->chr3
          l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_cmd 	LIKE type_file.chr1000,	# RDSQL STATEMENT        #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(40)
 
#FUN-7C0066 --STR
   DEFINE l_ima021 LIKE ima_file.ima021,  #FUN-510033                                                                              
          l_imz02 LIKE imz_file.imz02,    #說明內容                                                                                
          l_bmt05 LIKE bmt_file.bmt05,                                                                                             
          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06,  #插件位置  #No.FUN-680096 VARCHAR(20)                                           
          l_bmc05 ARRAY[200] OF LIKE bmc_file.bmc05,  #說明      #No.FUN-680096 VARCHAR(10)                                           
          l_bmc04 LIKE bmc_file.bmc04,                                                                                             
          l_ver   LIKE ima_file.ima05,                                                                                             
          l_byte,l_len        LIKE type_file.num5,    #No.FUN-680096 SMALLINT,                                                     
          l_bmt06_s           LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20),                                                     
          l_bmtstr            LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20),                                                     
          l_now,l_now2,l_now3 LIKE type_file.num5,    #No.FUN-680096 SMALLINT,                                                     
          l_m_item            LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(100) #FUN-550095 add   
   DEFINE l_bmc052 ARRAY[200] OF VARCHAR(30)
#FUN-7C0066 --END 
    
     #FUN-7C0066 --STR
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
 
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?)"
 
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?)"
 
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM 
     END IF
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     #FUN-7C0066 --END 
 
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
 
#    LET l_sql = "SELECT '',",    #95/12/22 Modify By Lynn
#                " bma01,bmb15,bmb16,bmb03,",
#                " bmb02,bmb06,bmb07,bmb08,",
#                " bmb10,bmb18,bmb09,bmb04,bmb05,",
#                " bmb14,bmb17,bmb11,bmb13,'',",
#                " A.ima02,A.ima05,A.ima06,A.ima08,A.ima15,A.ima37,",
#                " B.ima02,B.ima05,B.ima08,B.ima37 ",
#                " FROM bmb_file,OUTER ima_file A,",
#                "      bma_file,OUTER ima_file B ",
#                " WHERE bma01=bmb01 AND ",
#                " bmb03 = A.ima01 AND bma01 = B.ima01 ",
#                " AND ",tm.wc
#No:8378
  LET l_sql = "SELECT '',",    #95/12/22 Modify By Lynn
                 " bma01,bma06,bmb15,bmb16,bmb03,", #FUN-550095 add bma06
                 " bmb02,bmb06,bmb07,bmb08,",
                 " bmb10,bmb18,bmb09,bmb04,bmb05,",
                 " bmb14,bmb17,bmb11,bmb13,'',",
                 " ima02,ima05,ima06,ima08,ima15,ima37,'','','',''",
                 " FROM bmb_file,OUTER ima_file,bma_file ",           #-----No:8378
                 " WHERE bma01=bmb01 AND bmb_file.bmb03 = ima_file.ima01 ",
                 " AND ",tm.wc,
                 " AND bma06=bmb29 "  #FUN-550095 add
 
 
     #生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
          LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
          "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
          "' OR bmb05 IS NULL)"
     END IF
     PREPARE abmr610_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE abmr610_curs1 CURSOR FOR abmr610_prepare1
 
     #CALL cl_outnam('abmr610') RETURNING l_name   #FUN-7C0066
     #START REPORT abmr610_rep TO l_name           #FUN-7C0066
     CALL r610_cur()
     LET l_ute_flag='USZ'                  #FUN-A40058 add 'Z'
 
     FOREACH abmr610_curs1 INTO sr.*,sr2.*
       IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #-----No:8378
      #FUN-550095
      #SELECT ima02,ima05,ima08,ima37
      #  INTO sr2.ima02, sr2.ima05, sr2.ima08, sr2.ima37
      #  FROM bma_file,OUTER ima_file
      # WHERE bma01 = sr.bmb01
      #   AND bma01 = ima_file.ima01
       SELECT ima02,ima05,ima08,ima37
         INTO sr2.ima02, sr2.ima05, sr2.ima08, sr2.ima37
         FROM ima_file
        WHERE ima01 = sr.bmb01
      #FUN-550095
       IF STATUS THEN
          LET sr2.ima02=' '
          LET sr2.ima05=' '
          LET sr2.ima08=' '
          LET sr2.ima37=' '
       END IF
      #-----
 
       IF sr2.ima08 = 'X' AND tm.blow = 'Y' THEN
          LET g_bmb03 = sr.bmb03
          LET g_ima02 = sr.ima02
          LET g_ima05 = sr.ima05
          LET g_ima06 = sr.ima06
          LET g_ima08 = sr.ima08
          LET g_ima37 = sr.ima37
          CALL r610_phatom(sr.bmb01,sr.bmb06)
          CONTINUE FOREACH
       END IF
       IF tm.arrange='1' THEN
           LET sr.order1=sr.bmb01
       ELSE
           LET sr.order1=sr.bmb02 using'#####'
       END IF
       #---->使用特性
       IF sr.bmb14='1' THEN
           LET sr.bmb14='O'
       ELSE
           LET sr.bmb14=''
       END IF
       #---->消耗性料件
       IF sr.bmb15 = 'Y' THEN
            LET sr.bmb15 = '*'
       ELSE LET sr.bmb15 = ' '
       END IF
       #---->改變替代特性的表示方式
       IF sr.bmb16 MATCHES '[127]' THEN               #FUN-A40058 add '7'
           LET g_cnt=sr.bmb16 USING '&'
           LET sr.bmb16=l_ute_flag[g_cnt,g_cnt]
       ELSE
           LET sr.bmb16=' '
       END IF
       #---->特性料件
       IF sr.bmb17='Y' THEN
           LET sr.bmb17='F'
       ELSE
           LET sr.bmb17=' '
       END IF
       
       #FUN-7C0066 --STR
 
       #OUTPUT TO REPORT abmr610_rep(sr.*,sr2.*)
   
       SELECT imz02 INTO l_imz02 FROM imz_file                                                                                      
          WHERE imz01 = sr.ima06                                                                                               
       IF SQLCA.sqlcode THEN  LET l_imz02 = NULL END IF                                                                             
            
       CALL s_effver(sr.bmb01,tm.effective) RETURNING l_ver                                                                         
       LET l_m_item=sr.bmb01 CLIPPED,' ',sr.bmb29 CLIPPED                                                                           
       SELECT ima021 INTO l_ima021 FROM ima_file                                                                                    
          WHERE ima01=sr.bmb01                                                                                                      
                                                                                                                                    
       EXECUTE insert_prep                                                                                                          
       USING sr.order1,sr.bmb01, sr.bmb29, sr.bmb15, sr.bmb16,                                                                      
             sr.bmb03, sr.bmb02, sr.bmb06, sr.bmb07, sr.bmb08,                                                                      
             sr.bmb10, sr.bmb18, sr.bmb09, sr.bmb04, sr.bmb05,                                                                      
             sr.bmb14, sr.bmb17, sr.bmb11, sr.bmb13, sr.phatom,                                                                     
             sr.ima02, sr.ima05, sr.ima06, sr.ima08, sr.ima15,                                                                      
             sr.ima37, sr2.ima02,sr2.ima05,sr2.ima08,sr2.ima37,                                                                     
             l_imz02,       l_ima021,      l_ver,         l_m_item
                                                                                                                        
       #-->讀取插件位置                                                                                                             
       FOR g_cnt=1 TO 200                                                                                                           
          LET l_bmt06[g_cnt]=NULL                                                                                                   
       END FOR                                                                                                                      
       LET l_now2=1                                                                                                                 
       LET l_len =20                                                                                                                
       LET l_bmtstr = ''                                                                                                            
       FOREACH r610_bmt                                                                                                             
       USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29                                                  
       INTO l_bmt05,l_bmt06_s                                                                                                       
          IF SQLCA.sqlcode THEN                                                                                                     
             CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                                   
          END IF                                                                                                                    
          IF l_now2 > 200 THEN                                                                                                      
             CALL cl_err('','9036',1)                                                                                               
             CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                         
             EXIT PROGRAM                                                                                                           
          END IF                                                                                                                    
          LET l_byte = length(l_bmt06_s) + 1
          IF l_len >=l_byte THEN                                                                                                    
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
       END FOREACH
       IF l_now2 > 0 THEN LET l_bmt06[l_now2] = l_bmtstr END IF                                                                                                                    
       FOR g_cnt=4 TO l_now2 
          IF l_bmt06[g_cnt]='' OR l_bmt06[g_cnt] IS NULL THEN
             EXIT FOR
          END IF
          EXECUTE insert_prep1                                                                                                      
          USING   sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29,                                            
                  l_bmt05,l_bmt06[g_cnt]
       END FOR
 
       #-->讀取說明的部份                                                                                                           
       FOR g_cnt=1 TO 200                                                                                                           
          LET l_bmc05[g_cnt]=NULL                                                                                                   
       END FOR                                                                                                                      
       LET l_now=1                                                                                                                  
       FOREACH r610_bmc                                                                                                             
       USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29                                                  
       INTO l_bmc04,l_bmc05[l_now]                                                                                                  
          IF SQLCA.sqlcode THEN                                                                                                     
             CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                                   
          END IF                                                                                                                    
          IF l_now > 200 THEN                                                                                                       
             CALL cl_err('','9036',1)                                                                                               
             CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                         
             EXIT PROGRAM                                                                                                           
          END IF
          LET l_now=l_now+1
       END FOREACH
       LET l_now=l_now-1
       IF l_now >= 1 THEN 
          FOR g_cnt=1 TO l_now STEP 2
             IF not cl_null(l_bmc05[g_cnt]) THEN
                LET l_bmc052[g_cnt]=l_bmc05[g_cnt],l_bmc05[g_cnt+1] CLIPPED
             ELSE
                LET l_bmc052[g_cnt]=l_bmc05[g_cnt]
             END IF
             EXECUTE insert_prep2                                                                                                      
             USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29,                                              
                   l_bmc04,l_bmc052[g_cnt] 
          END FOR
       END IF                                                                           
                                                                        
                                                                                                                                    
       #FUN-7C0066 --END                     
     END FOREACH
 
    #DISPLAY "" AT 2,1
 
     #FUN-7C0066 --STR
 
     #FINISH REPORT abmr610_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
    
     LET g_str = ''
     #是否打印選擇條件
     IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'bmb03,ima06,ima09,ima10,ima11,ima12')
         RETURNING tm.wc
     END IF
     LET g_str = tm.wc,';',g_sma.sma888[1,1],';',tm.effective,';',tm.engine
     CALL cl_prt_cs3('abmr610','abmr610',g_sql,g_str)
     
     #FUN-7C0066 -END
  
END FUNCTION
 
#FUN-7C0066 -STR
#REPORT abmr610_rep(sr,sr2)
#   DEFINE l_last_sw	LIKE type_file.chr1,  #No.FUN-680096 VARCHAR(1),
#          sr  RECORD
#              order1  LIKE bmb_file.bmb01,  #No.FUN-680096 VARCHAR(20),
#              bmb01 LIKE bmb_file.bmb01,    #主件料件
#              bmb29 LIKE bmb_file.bmb29,    #FUN-550095 add
#              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
#              bmb16 LIKE bmb_file.bmb16,    #替代特性
#              bmb03 LIKE bmb_file.bmb03,    #元件料號
#              bmb02 LIKE bmb_file.bmb02,    #項次
#              bmb06 LIKE bmb_file.bmb06,    #QPA
#              bmb07 LIKE bmb_file.bmb07,    #底數
#              bmb08 LIKE bmb_file.bmb08,    #損耗率%
#              bmb10 LIKE bmb_file.bmb10,    #發料單位
#              bmb18 LIKE bmb_file.bmb18,    #投料時距
#              bmb09 LIKE bmb_file.bmb09,    #製程序號
#              bmb04 LIKE bmb_file.bmb04,    #有效日期
#              bmb05 LIKE bmb_file.bmb05,    #失效日期
#              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
#              bmb17 LIKE bmb_file.bmb17,    #Feature
#              bmb11 LIKE bmb_file.bmb11,    #工程圖號
#              bmb13 LIKE bmb_file.bmb13,    #插件位置
#              phatom LIKE bmb_file.bmb01,
#              ima02 LIKE ima_file.ima02,    #品名規格
#              ima05 LIKE ima_file.ima05,    #版本
#              ima06 LIKE ima_file.ima06,    #分群碼
#              ima08 LIKE ima_file.ima08,    #來源
#              ima15 LIKE ima_file.ima15,    #保稅否
#              ima37 LIKE ima_file.ima37     #補貨
#          END RECORD,
#          sr2 RECORD
#              ima02  LIKE ima_file.ima02,
#              ima05  LIKE ima_file.ima05,
#              ima08  LIKE ima_file.ima08,
#              ima37  LIKE ima_file.ima37
#          END RECORD,
#          l_ima021 LIKE ima_file.ima021,  #FUN-510033
#          l_imz02 LIKE imz_file.imz02,    #說明內容
#          l_bmt05 LIKE bmt_file.bmt05,
#          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06,  #插件位置  #No.FUN-680096 VARCHAR(20)
#          l_bmc05 ARRAY[200] OF LIKE bmc_file.bmc05,  #說明      #No.FUN-680096 VARCHAR(10)
#          l_bmc04 LIKE bmc_file.bmc04,
#          l_ver   LIKE ima_file.ima05,
#          l_byte,l_len        LIKE type_file.num5,    #No.FUN-680096 SMALLINT,
#          l_bmt06_s           LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20),
#          l_bmtstr            LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20),
#          l_now,l_now2,l_now3 LIKE type_file.num5,    #No.FUN-680096 SMALLINT,
#          l_m_item            LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(100) #FUN-550095 add
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.bmb03,sr.order1
#  FORMAT
#   PAGE HEADER
#      SELECT imz02 INTO l_imz02 FROM imz_file
#             WHERE imz01 = sr.ima06
#          IF SQLCA.sqlcode THEN  LET l_imz02 = NULL END IF
#
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash
#      #----
#      PRINT g_x[16] CLIPPED, sr.ima06,' ',l_imz02
#      PRINT g_x[17] CLIPPED, sr.bmb03,' ',sr.ima02
#
#   #-----No.TQC-5B0030 modify
#      PRINT COLUMN 1, g_x[18] CLIPPED, sr.ima05,
#            COLUMN 10, g_x[19] CLIPPED, sr.ima08,
#            COLUMN 20, g_x[20] CLIPPED, sr.ima37
#   #----end
#      IF g_sma.sma888[1,1] ='Y'
#      THEN PRINT g_x[22] clipped,sr.ima15
#      ELSE PRINT ' '
#      END IF
#      PRINT ' '
#      #----
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#      PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.bmb03  #元件編號
#     #IF (PAGENO > 1 OR LINENO > 13)  #FUN-550095
#     #   THEN SKIP TO TOP OF PAGE     #FUN-550095
#     #END IF                          #FUN-550095
#      SKIP TO TOP OF PAGE             #FUN-550095 add
#
#   ON EVERY ROW
#      #-->讀取插件位置
#      FOR g_cnt=1 TO 200
#          LET l_bmt06[g_cnt]=NULL
#      END FOR
#      LET l_now2=1
#      LET l_len =20
#      LET l_bmtstr = ''
#      FOREACH r610_bmt
#      USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550095 add bmb29
#      INTO l_bmt05,l_bmt06_s
#         IF SQLCA.sqlcode THEN
#            CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#         END IF
#         IF l_now2 > 200 THEN
#            CALL cl_err('','9036',1)
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#            EXIT PROGRAM
#         END IF
#         LET l_byte = length(l_bmt06_s) + 1
#         IF l_len >=l_byte THEN
#            LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
#            LET l_len = l_len - l_byte
#         ELSE
#            LET l_bmt06[l_now2] = l_bmtstr
#            LET l_now2 = l_now2 + 1
#            LET l_len = 20
#            LET l_len = l_len - l_byte
#            LET l_bmtstr = ''
#            LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','
#         END IF
#      END FOREACH
#      IF l_now2 > 0 THEN LET l_bmt06[l_now2] = l_bmtstr END IF
#      #-->讀取說明的部份
#      FOR g_cnt=1 TO 200
#          LET l_bmc05[g_cnt]=NULL
#      END FOR
#      LET l_now=1
#      FOREACH r610_bmc
#      USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550095 add bmb29
#      INTO l_bmc04,l_bmc05[l_now]
#          IF SQLCA.sqlcode THEN
#             CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
#          END IF
#          IF l_now > 200 THEN
#              CALL cl_err('','9036',1)
#              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#              EXIT PROGRAM
#          END IF
#          LET l_now=l_now+1
#      END FOREACH
#      LET l_now=l_now-1
#
#      CALL s_effver(sr.bmb01,tm.effective) RETURNING l_ver
#      LET l_m_item=sr.bmb01 CLIPPED,' ',sr.bmb29 CLIPPED
#      PRINTX name=D1 COLUMN g_c[31],sr.bmb02 USING '---&',
#                     COLUMN g_c[32],l_m_item CLIPPED, #FUN-550095 add bmb29
#                     COLUMN g_c[33],sr2.ima02,
#                     COLUMN g_c[34],l_ver,
#                     COLUMN g_c[35],sr2.ima08,
#                     COLUMN g_c[36],cl_numfor(sr.bmb06,36,4),
#                     COLUMN g_c[37],sr.bmb04,
#                     COLUMN g_c[38],l_bmt06[1],
#                     COLUMN g_c[39],sr.bmb08 USING '---&.&&&',
#                     COLUMN g_c[40],sr.bmb09 USING '---&',
#                     COLUMN g_c[41],sr.bmb14,'/',sr.bmb15
#      IF sr.phatom IS NOT NULL AND sr.phatom !=' ' THEN
#         PRINT COLUMN 27,g_x[28] clipped,sr.phatom;
#      END IF
#      SELECT ima021 INTO l_ima021 FROM ima_file
#       WHERE ima01=sr.bmb01
#      PRINTX name=D2 COLUMN g_c[42],' ',
#                     COLUMN g_c[43],l_ima021,
#                     COLUMN g_c[44],cl_numfor(sr.bmb07,36,4),
#                     COLUMN g_c[45],sr.bmb05,
#                     COLUMN g_c[46],l_bmt06[2],
#                     COLUMN g_c[47],sr.bmb18 USING '-------&',
#                     COLUMN g_c[48],' ',
#                     COLUMN g_c[49],sr.bmb16,'/',sr.bmb17
#      IF tm.engine='Y' THEN
#          IF sr.bmb11 IS NOT NULL AND sr.bmb11 !=' '
#          THEN PRINT COLUMN 27,g_x[29] CLIPPED,sr.bmb11
#               PRINTX name=D2 COLUMN g_c[46],l_bmt06[3]     #No.MOD-740054 modify  #TQC-760170 modify
#          END IF
#      ELSE
#          IF l_bmt06[3] IS NOT NULL AND l_bmt06[3] != ' '
#          THEN PRINTX name=D2 COLUMN g_c[46],l_bmt06[3]      #No.MOD-740054 modify  #TQC-760170 modify
#          END IF
#      END IF
#      #-->列印插件位置
#         LET l_bmt06[l_now2] = l_bmtstr
#      FOR g_cnt = 4 TO l_now2
#         IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '
#         THEN EXIT FOR
#         END IF
#          PRINTX name=D2 COLUMN g_c[46],l_bmt06[g_cnt]        #No.MOD-740054 modify  #TQC-760170 modify
#      END FOR
#      #-->列印說明
#      IF l_now >= 1 THEN
#         FOR g_cnt = 1 TO l_now STEP 2
#             IF g_cnt =1 THEN PRINTX name=D1 COLUMN g_c[34],g_x[23] clipped; END IF   #TQC-760170 modify
#             #TQC-760170-begin-add
#             IF NOT cl_null(l_bmc05[g_cnt+1]) THEN 
#                PRINTX name=D1 COLUMN g_c[35],l_bmc05[g_cnt],l_bmc05[g_cnt+1] CLIPPED    #TQC-760170 modify 
#             ELSE 
#                PRINTX name=D1 COLUMN g_c[35],l_bmc05[g_cnt]    #TQC-760170 modify 
#             END IF 
#             #TQC-760170-end-add
#         END FOR
#      END IF
#
#  #AFTER GROUP OF sr.bmb03
#  #   LET g_pageno=0
#
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT ' '
#      PRINT g_x[26] CLIPPED,'  ',g_x[27] CLIPPED
#      PRINT g_dash
#     #IF pageno = 0 OR l_last_sw = 'y'
#      IF l_last_sw = 'y'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      END IF
#END REPORT
 
#FUN-7C0066 -END
