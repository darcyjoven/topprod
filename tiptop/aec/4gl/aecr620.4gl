# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aecr620.4gl
# Descriptions...: 製程資料列印
# Input parameter:
# Return code....:
# Date & Author..: 91/12/16 By Nora
# Modify.........: No.MOD-530132 05/03/17 By pengu 欄位QBE順序調整
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-610070 01/19 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-690112 06/10/13 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改 
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-840139 08/04/29 By TSD.Leeway 改為 CR 報表 
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-7A0072 08/10/07 By jamie 1.新增樣板,順序與欄位與維護程式(aeci100)一致。
#                                                  2.per檔增加 Input"維護說明資料"勾選，增加列印"製程說明資料"功能。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:MOD-AB0202 10/11/23 By sabrina 當l_prog<>'aeci100'時標準人工工時(秒)才需除以60
# Modify.........: No:MOD-AC0001 10/12/01 By zhangll ecb03条件错误修正
# Modify.........: No.TQC-B30187 11/03/28 by destiny 定义栏位时不能like mlc_file，此为synonmy table
# Modify.........: No:MOD-B50220 11/07/17 By Summer 當l_prog='aeci100'時抓取條件用'ecb01=ima01'
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
# Modify.........: No.TQC-C10034 12/01/18 By zhuhao CR報表簽核 
# Modify.........: No:TQC-BC0033 12/02/10 By Elise 加入金額取位參數, 加入品名l_ima02, 說明l_ecu03, 作業名稱l_ebc17, 工作站名稱l_eca02, 機器說明l_eci06

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	        wc  	STRING,   		# Where condition
                b       LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1), # 是否印列主制程
                c       LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1), # 標准時間
                d       LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1), # 排程時間
                e       LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1), # 預設時間
               #f       DATE,                   # 有效日    #TQC-610070
                g       LIKE type_file.chr1,    #FUN-7A0072 add
                more    LIKE type_file.chr1     #No.FUN-680073 VARCHAR(1) #Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   l_table       STRING                   #NO.FUN-840139 080429 By TSD.Leeway
DEFINE   l_table1      STRING                   #NO.FUN-840139 080429 By TSD.Leeway
DEFINE   l_table2      STRING                   #FUN-7A0072 add
DEFINE   g_sql         STRING                   #NO.FUN-840139 080429 By TSD.Leeway
DEFINE   g_str         STRING                   #NO.FUN-840139 080429 By TSD.Leeway
DEFINE   l_prog        LIKE type_file.chr10     #FUN-7A0072 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-840139 080429 By TSD.Leeway----------------------(S)
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ecb01.ecb_file.ecb01,ecb03.ecb_file.ecb03,",
               "ecb06.ecb_file.ecb06,ecb07.ecb_file.ecb07,",
               "ecb09.ecb_file.ecb09,ecb11.ecb_file.ecb11,",
               "ecb13.ecb_file.ecb13,ecb17.ecb_file.ecb17,",
               "ecb02.ecb_file.ecb02,ecb08.ecb_file.ecb08,",
               "ecb10.ecb_file.ecb10,ecb12.ecb_file.ecb12,",
               "ecb14.ecb_file.ecb14,ecb15.ecb_file.ecb15,",
               "ecb16.ecb_file.ecb16,ecb26.ecb_file.ecb26,",
               "ecb27.ecb_file.ecb27,ecb28.ecb_file.ecb28,",
               "ecb18.ecb_file.ecb18,ecb19.ecb_file.ecb19,",
               "ecb20.ecb_file.ecb20,ecb21.ecb_file.ecb21,",
               "ecb22.ecb_file.ecb22,ecb23.ecb_file.ecb23,",
               "ecb30.ecb_file.ecb30,ecb31.ecb_file.ecb31,",
               "ecb32.ecb_file.ecb32,ecb33.ecb_file.ecb33,",
               "ecb34.ecb_file.ecb34,ecb35.ecb_file.ecb35,",
               "ecb24.ecb_file.ecb24,ecb25.ecb_file.ecb25,",
               "ima02.ima_file.ima02,pmc03.pmc_file.pmc03,",
               "l_sta.tod_file.tod09,",
              #FUN-7A0072---add---str---
               "ecu01.ecu_file.ecu01, ima021.ima_file.ima021,",
               "ecu02.ecu_file.ecu02, ecu03.ecu_file.ecu03 ,",
               "ecu04.ecu_file.ecu04, ecu05.ecu_file.ecu05 ,",
               "eca02.eca_file.eca02, ecb38.ecb_file.ecb38 ,",
               "ecb04.ecb_file.ecb04, ecb39.ecb_file.ecb39 ,",
               "ecb40.ecb_file.ecb40, ecb41.ecb_file.ecb41 ,",
               "ecb42.ecb_file.ecb42, ecb43.ecb_file.ecb43 ,",
               "ecb44.ecb_file.ecb44, ecb45.ecb_file.ecb45 ,",
               "ecb46.ecb_file.ecb46,",
              #FUN-7A0072---add---end---
              #TQC-C10034---add---begin
               "sign_type.type_file.chr1,sign_img.type_file.blob,",      
               "sign_show.type_file.chr1,sign_str.type_file.chr1000,",
              #TQC-C10034---add---end
              #TQC-BC0033---add---str---
               "l_ima02.ima_file.ima02, l_ecu03.ecu_file.ecu03,",
               "l_ecb17.ecb_file.ecb17, l_eca02.eca_file.eca02,",
               "l_eci06.eci_file.eci06"
              #TQC-BC0033---add---end----
               
 
   LET l_table = cl_prt_temptable('aecr620',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   #------------------------------ CR (1) ------------------------------#
 
   LET g_sql= "ecw06.ecw_file.ecw06,ecw06_1.ecw_file.ecw06,",
              "ecb01.ecb_file.ecb01,ecb02.ecb_file.ecb02,",
              "ecb03.ecb_file.ecb03"
   LET l_table1 = cl_prt_temptable('aecr6201',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
 
   #No.FUN-840139 080429 By TSD.Leeway----------------------(E)
 
  #FUN-7A00072---add---str---
   LET g_sql= "ecbb01.ecbb_file.ecbb01,ecbb02.ecbb_file.ecbb02,",
              "ecbb03.ecbb_file.ecbb03,ecbb09.ecbb_file.ecbb09,",
              "ecbb10.ecbb_file.ecbb10"
   LET l_table2 = cl_prt_temptable('aecr6202',g_sql) CLIPPED   # 產生Temp Table
   IF l_table2 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生
  #FUN-7A00072---add---end---
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690112 by baogui
 
#No.CHI-6A0004--begin
#   SELECT azi03 INTO g_azi03 FROM azi_file      # 成本之小數位數
#          WHERE azi01 = g_aza.aza17
#   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aza.aza17,SQLCA.sqlcode,0) #No.FUN-660091
#      CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0) #FUN-660091
#   END IF
#No.CHI-6A0004--end
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b  = ARG_VAL(8)
   LET tm.c  = ARG_VAL(9)
   LET tm.d  = ARG_VAL(10)
   LET tm.e  = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   LET l_prog = ARG_VAL(15)   #FUN-7A0072 add
   LET tm.g  = ARG_VAL(16)    #FUN-7A0072 add
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r620_tm()	        	# Input print condition
      ELSE CALL r620()	                        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
END MAIN
 
FUNCTION r620_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,     #No.FUN-680073 SMALLINT
          l_cmd		LIKE type_file.chr1000   #No.FUN-680073
 
      LET p_row = 3 LET p_col = 20
   OPEN WINDOW r620_w AT p_row,p_col WITH FORM "aec/42f/aecr620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   LET tm.d = 'Y'
   LET tm.e = 'Y'
   LET tm.g = 'Y'                #FUN-7A0072 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    #----------MOD-530132----------------------------------------------------
     # CONSTRUCT BY NAME tm.wc ON ecb01,ima06,ima09,ima10,ima11,ima12,ecb02
       CONSTRUCT BY NAME tm.wc ON ecb01,ima09,ima11,ecb02,ima06,ima10,ima12
   #--------------------END-------------------------------------------------
 
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
 
#No.FUN-570240 --start
     ON ACTION controlp
        IF INFIELD(ecb01) THEN
#FUN-AA0059 --Begin--
         #  CALL cl_init_qry_var()
         #  LET g_qryparam.form = "q_ima"
         #  LET g_qryparam.state = "c"
         #  CALL cl_create_qry() RETURNING g_qryparam.multiret
           CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
           DISPLAY g_qryparam.multiret TO ecb01
           NEXT FIELD ecb01
        END IF
#No.FUN-570240 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.b,tm.c,tm.d,tm.e,tm.g,tm.more              #FUN-7A0072 add tm.g
                  		# Condition 
   INPUT BY NAME tm.b,tm.c,tm.d,tm.e,tm.g,tm.more WITHOUT DEFAULTS  #FUN-7A0072 add tm.g
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES'[YN]' THEN
            NEXT FIELD b
         END IF
 
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES'[YN]' THEN
            NEXT FIELD c
         END IF
 
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[YN]' THEN
            NEXT FIELD d
         END IF
 
      AFTER FIELD e
         IF tm.e IS NULL OR tm.e NOT MATCHES'[YN]' THEN
            NEXT FIELD e
         END IF
 
     #FUN-7A0072---add---str---
      AFTER FIELD g
         IF tm.g IS NULL OR tm.g NOT MATCHES'[YN]' THEN
            NEXT FIELD g
         END IF
     #FUN-7A0072---add---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aecr620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aecr620','9031',1)
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
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",       #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",       #No.FUN-570264
                         " '",g_template CLIPPED,"'",       #No.FUN-570264
                         " '",l_prog CLIPPED,"'",           #FUN-7A0072 add
                         " '",tm.g CLIPPED,"'"              #FUN-7A0072 add
         CALL cl_cmdat('aecr620',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r620()
   ERROR ""
END WHILE
   CLOSE WINDOW r620_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80046 ADD
END FUNCTION
 
FUNCTION r620()
   DEFINE	
          l_name        LIKE type_file.chr20,  #No.FUN-680073 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0100
          l_sql 	LIKE type_file.chr1000,# RDSQL STATEMENT        #No.FUN-680073 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,   #No.FUN-680073 VARCHAR(1)
          l_za05        LIKE type_file.chr1000, #No.FUN-680073 VARCHAR(40)
          l_order       ARRAY[5] OF LIKE cre_file.cre08,        #No.FUN-680073 VARCHAR(10)
          l_sta         LIKE tod_file.tod09,   #成本說明 No.FUN-840139 080429 By TSD.Leeway
	  l_ecw05       LIKE ecw_file.ecw05,   #No.FUN-840139 080429 By TSD.Leeway
	  l_ecw06 ARRAY[99] OF LIKE ecw_file.ecw06,  #No.FUN-840139 080429 By TSD.Leeway
          l_i           LIKE type_file.num5,         #No.FUN-840139 080429 By TSD.Leeway
          l_str1,l_str2 LIKE bnb_file.bnb09,    #No.FUN-840139 080429 By TSD.Leeway
          sr               RECORD ecb01 LIKE ecb_file.ecb01,	#料件編號
                                  ecb02 LIKE ecb_file.ecb02,	#製程編號
                                  ecb03 LIKE ecb_file.ecb03,	#作業序號
                                  ecb06 LIKE ecb_file.ecb06,    #作業編號
                                  ecb07 LIKE ecb_file.ecb07,    #機器編號
                                  ecb08 LIKE ecb_file.ecb08,    #工作站號
                                  ecb09 LIKE ecb_file.ecb09,    #盤點作業
                                  ecb10 LIKE ecb_file.ecb10,    #搬運時間
                                  ecb11 LIKE ecb_file.ecb11,    #作業重壘程度
                                  ecb12 LIKE ecb_file.ecb12,    #輸出裝置
                                  ecb13 LIKE ecb_file.ecb13,    #成本計算基準
                                  ecb14 LIKE ecb_file.ecb14,    #產出率
                                  ecb15 LIKE ecb_file.ecb15,    #人工數
                                  ecb16 LIKE ecb_file.ecb16,    #機器數
                                  ecb17 LIKE ecb_file.ecb17,    #備註
                                  ecb18 LIKE ecb_file.ecb18,    #人工設置時間
                                  ecb19 LIKE ecb_file.ecb19,    #人工生產時間
                                  ecb20 LIKE ecb_file.ecb20,    #機器設置時間
                                  ecb21 LIKE ecb_file.ecb21,    #機器生產時間
                                  ecb22 LIKE ecb_file.ecb22,    #廠外加工時間
                                  ecb23 LIKE ecb_file.ecb23,    #廠外加工成本
                                  ecb24 LIKE ecb_file.ecb24,    #廠外加工時間
                                  ecb25 LIKE ecb_file.ecb25,    #廠外加工廠商
                                  ecb26 LIKE ecb_file.ecb26,    #設置時間
                                  ecb27 LIKE ecb_file.ecb27,    #生產時間
                                  ecb28 LIKE ecb_file.ecb28,    #廠外加工時間
                                  ecb30 LIKE ecb_file.ecb30,    #人工設置時間
                                  ecb31 LIKE ecb_file.ecb31,    #人工生產時間
                                  ecb32 LIKE ecb_file.ecb32,    #機器設置時間
                                  ecb33 LIKE ecb_file.ecb33,    #機器生產時間
                                  ecb34 LIKE ecb_file.ecb34,    #廠外加工時間
                                  ecb35 LIKE ecb_file.ecb35,    #廠外加工成本
                                  ima02 LIKE ima_file.ima02,    #品名規格
                                  pmc03 LIKE pmc_file.pmc03,    #廠商簡稱
                                 #FUN-7A0072---add---str---
                                  ecu01  LIKE ecu_file.ecu01 ,
                                  ima021 LIKE ima_file.ima021,
                                  ecu02  LIKE ecu_file.ecu02 ,
                                  ecu03  LIKE ecu_file.ecu03 ,
                                  ecu04  LIKE ecu_file.ecu04 ,
                                  ecu05  LIKE ecu_file.ecu05 ,
                                  eca02  LIKE eca_file.eca02 ,
                                  ecb38  LIKE ecb_file.ecb38 ,
                                  ecb04  LIKE ecb_file.ecb04 ,
                                  ecb39  LIKE ecb_file.ecb39 ,
                                  ecb40  LIKE ecb_file.ecb40 ,
                                  ecb41  LIKE ecb_file.ecb41 ,
                                  ecb42  LIKE ecb_file.ecb42 ,
                                  ecb43  LIKE ecb_file.ecb43 ,
                                  ecb44  LIKE ecb_file.ecb44 ,
                                  ecb45  LIKE ecb_file.ecb45 ,
                                  ecb46  LIKE ecb_file.ecb46 
                                 #FUN-7A0072---add---end--- 
                        END RECORD
 
     DEFINE sr2     RECORD LIKE ecbb_file.*      #FUN-7A0072 add

    #TQC-BC0033---add---str---        
     DEFINE l_ima02 LIKE ima_file.ima02
     DEFINE l_ecu03 LIKE ecu_file.ecu03
     DEFINE l_ecb17 LIKE ecb_file.ecb17
     DEFINE l_eca02 LIKE eca_file.eca02
     DEFINE l_eci06 LIKE eci_file.eci06
    #TQC-BC0033---add---end--- 

     #TQC-C10034--add--begin
     DEFINE l_img_blob     LIKE type_file.blob
     LOCATE l_img_blob IN MEMORY
     #TQC-C10034--add--end 

     #No.FUN-840139 080429 By TSD.Leeway------------(S)
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)  #FUN-7A0072 add
     #------------------------------ CR (2) ------------------------------#
     #No.FUN-840139 080429 By TSD.Leeway------------(E)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aecr620'
 
     #NO.FUN-840139 080429 By TSD.Leeway  Start--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                          ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                          ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                          ?)"    #FUN-7A0052 35?->52? #TQC-C10034 add 4?
                                 #TQC-BC0033 add 5 ?
                                                                 
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80046 ADD
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80046 ADD
         EXIT PROGRAM
     END IF
 
    #FUN-7A0072---add---str---
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?,?,?,?,?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80046 ADD
        EXIT PROGRAM
     END IF
    #FUN-7A0072---add---end---
 
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    IF tm.c = 'Y' THEN
#       LET g_x[43] = g_x[43] CLIPPED,' ',g_x[28]
#    END IF
#    IF tm.d = 'Y' THEN
#       LET g_x[43] = g_x[43] CLIPPED,' ',g_x[29]
#    END IF
#    IF tm.e = 'Y' THEN
#       LET g_x[43] = g_x[43] CLIPPED,' ',g_x[30]
#    END IF
     #NO.FUN-840139 080429 By TSD.Leeway End  --
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ecbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ecbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ecbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ecbuser', 'ecbgrup')
     #End:FUN-980030
 
    #MOD-B50220---add---start---
     IF l_prog = 'aeci100' THEN          
     LET l_sql = "SELECT ecb01,ecb02,ecb03,ecb06,ecb07,ecb08,",
                 " ecb09,ecb10,ecb11,ecb12,ecb13,ecb14,ecb15,ecb16,ecb17,",
                 " ecb18,ecb19,ecb20,ecb21,ecb22,ecb23,ecb24,ecb25,ecb26,",
                 " ecb27,ecb28,ecb30,ecb31,ecb32,ecb33,ecb34,ecb35,",
                 " ima02,pmc03,",
                 " ecu01,ima021,ecu02,ecu03,ecu04,ecu05,'',ecb38,ecb04,",    
                 " ecb39,ecb40,ecb41,ecb42,ecb43,ecb44,ecb45,ecb46",          
                 "  FROM ecu_file, ecb_file, OUTER ima_file,OUTER pmc_file",  
                 "  WHERE ecb_file.ecb01 = ima_file.ima01 AND ecb_file.ecb25 = pmc_file.pmc01 ",
                 "    AND ecu01 = ecb01 AND ecu02 = ecb02 "                  
     ELSE
    #MOD-B50220---add---end---
     LET l_sql = "SELECT ecb01,ecb02,ecb03,ecb06,ecb07,ecb08,",
                 " ecb09,ecb10,ecb11,ecb12,ecb13,ecb14,ecb15,ecb16,ecb17,",
                 " ecb18,ecb19,ecb20,ecb21,ecb22,ecb23,ecb24,ecb25,ecb26,",
                 " ecb27,ecb28,ecb30,ecb31,ecb32,ecb33,ecb34,ecb35,",
                 " ima02,pmc03,",
                 " ecu01,ima021,ecu02,ecu03,ecu04,ecu05,'',ecb38,ecb04,",     #FUN-7A0072 add
                 " ecb39,ecb40,ecb41,ecb42,ecb43,ecb44,ecb45,ecb46",          #FUN-7A0072 add
                 "  FROM ecu_file, ecb_file, OUTER ima_file,OUTER pmc_file",  #FUN-7A0072 add 
                #"  FROM ecb_file,OUTER ima_file,OUTER pmc_file",             #FUN-7A0072 mark
                 "  WHERE ecb_file.ecb24 = ima_file.ima01 AND ecb_file.ecb25 = pmc_file.pmc01 ",
                 "    AND ecu01 = ecb01 AND ecu02 = ecb02 "                   #FUN-7A0072 add
     END IF   #MOD-B50220 add
 
     IF tm.b = 'Y' THEN    #是否只列印主製程料件
       #Mod MOD-AC0001  #改抓ecb03最小值，ecb03编码是根据参数设置决定间距的
       #LET l_sql = l_sql CLIPPED," AND ecb03 = '1' "
        LET l_sql = l_sql CLIPPED,
                " AND (ecb01,ecb02,ecb03) in (select ecb01,ecb02,min(ecb03) from ecu_file, ecb_file ",
                                     "  where ecu01 = ecb01 AND ecu02 = ecb02 ",
                                     "    and ",tm.wc,
                                     "  group by ecb01,ecb02 ",
                                     " ) "
       #End Mod MOD-AC0001
     END IF
     LET l_sql = l_sql CLIPPED," AND ",tm.wc
     PREPARE r620_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
        EXIT PROGRAM 
     END IF
     DECLARE r620_c1 CURSOR FOR r620_p1
 
     #NO.FUN-840139 080429 By TSD.Leeway Start Mark  --
#    CALL cl_outnam('aecr620') RETURNING l_name
#    START REPORT r620_rep TO l_name
     #NO.FUN-840139 080429 By TSD.Leeway End Mark --
 
     LET g_pageno = 0
     FOREACH r620_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
 
       # ecb18,ecb19,ecb20,ecb21 單位已改為秒
          IF l_prog != 'aeci100' OR cl_null(l_prog) THEN             #MOD-AB0202 add
             IF sr.ecb18>0 THEN LET sr.ecb18=sr.ecb18/60 END IF
             IF sr.ecb19>0 THEN LET sr.ecb19=sr.ecb19/60 END IF
             IF sr.ecb20>0 THEN LET sr.ecb20=sr.ecb20/60 END IF
             IF sr.ecb21>0 THEN LET sr.ecb21=sr.ecb21/60 END IF
          END IF               #MOD-AB0202 add
#         OUTPUT TO REPORT r620_rep(sr.*)  #NO.FUN-840139 080429 By TSD.Leeway Mark
 
       #NO.FUN-840139 080429 By TSD.Leeway Start--
       LET l_sta = s_ecbsta(sr.ecb13)
 
       IF sr.ecb23 IS NOT NULL THEN
          CALL cl_numfor(sr.ecb23,14,g_azi03) RETURNING l_str1
          LET l_i = 1
          FOR g_i = 1 TO 22
              IF cl_null(l_str1[g_i,g_i]) THEN CONTINUE FOR END IF
              LET l_str2[l_i,l_i] = l_str1[g_i,g_i]
              LET l_i = l_i + 1
          END FOR
          LET sr.ecb23= l_str2 
       END IF
 
       IF sr.ecb35 IS NOT NULL THEN
          CALL cl_numfor(sr.ecb35,14,g_azi03) RETURNING l_str1
          LET l_i = 1
          FOR g_i = 1 TO 22
              IF cl_null(l_str1[g_i,g_i]) THEN CONTINUE FOR END IF
              LET l_str2[l_i,l_i] = l_str1[g_i,g_i]
              LET l_i = l_i + 1
          END FOR
          LET sr.ecb35= l_str2
       END IF
 
      #FUN-7A0072---add---str---
       SELECT eca02 INTO sr.eca02 FROM eca_file
        WHERE eca01 = sr.ecb08
       IF SQLCA.sqlcode THEN LET sr.eca02 = ' ' END IF
      #FUN-7A0072---add---end---
 
       DECLARE r620_c0 CURSOR FOR SELECT ecw05,ecw06 FROM ecw_file
               WHERE ecw01 = sr.ecb01 AND ecw02 = sr.ecb02 AND
                     ecw03 = sr.ecb03
               ORDER BY 1
       LET l_i = 1
       LET g_i = 0  #判斷此製程是否有作業說明
       FOREACH r620_c0 INTO l_ecw05,l_ecw06[l_i]
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0) 
             EXIT FOREACH
          END IF
          IF l_i > 99 THEN
             CALL cl_err('',9036,0)
             EXIT FOREACH
          END IF
          LET l_i = l_i + 1
       END FOREACH
       LET l_i = l_i - 1  #正確的資料筆數
       IF l_i > 0 THEN   #7926
          FOR g_i = 1 TO l_i STEP 2
              EXECUTE insert_prep1 USING l_ecw06[g_i],l_ecw06[g_i+1],
                                         sr.ecb01,sr.ecb02,sr.ecb03
          END FOR
       END IF
 
      #FUN-7A0072---add---str---
       IF tm.g = 'Y' THEN  
          DECLARE r620_c3 CURSOR FOR 
           SELECT * FROM ecbb_file
            WHERE ecbb01 = sr.ecu01 
              AND ecbb02 = sr.ecu02 
              AND ecbb03 = sr.ecb03
            ORDER BY 1
          LET l_i = 1
          LET g_i = 0 
          FOREACH r620_c3 INTO sr2.*
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach1:',SQLCA.sqlcode,0) 
                EXIT FOREACH
             END IF
             IF NOT cl_null(sr2.ecbb10) THEN 
                EXECUTE insert_prep2 USING sr.ecu01,sr.ecu02,sr.ecb03,sr2.ecbb09,sr2.ecbb10
             END IF
             LET l_i = l_i + 1
          END FOREACH
       END IF 
 
      #FUN-7A0072---add---end---

      #TQC-BC0033---add---srt---
       LET l_ima02 = ''
       SELECT ima02 INTO l_ima02 FROM ima_file
        WHERE ima01 = sr.ecb01

       LET l_ecu03 = ''
       SELECT ecu03 INTO l_ecu03 FROM ecu_file
        WHERE ecu02 = sr.ecb02

       LET l_ecb17 = ''
       SELECT ecb17 INTO l_ecb17 FROM ecb_file
        WHERE ecb06 = sr.ecb06

       LET l_eca02 = ''
       SELECT eca02 INTO l_eca02 FROM eca_file
        WHERE eca01 = sr.ecb08

       LET l_eci06 = ''
       SELECT eci06 INTO l_eci06 FROM eci_file
        WHERE eci01 = sr.ecb07
      #TQC-BC0033---add---end---
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING 
               sr.ecb01,sr.ecb03,sr.ecb06,sr.ecb07,sr.ecb09,
               sr.ecb11,sr.ecb13,sr.ecb17,sr.ecb02,sr.ecb08,
               sr.ecb10,sr.ecb12,sr.ecb14,sr.ecb15,sr.ecb16,
               sr.ecb26,sr.ecb27,sr.ecb28,sr.ecb18,sr.ecb19,
               sr.ecb20,sr.ecb21,sr.ecb22,sr.ecb23,sr.ecb30,
               sr.ecb31,sr.ecb32,sr.ecb33,sr.ecb34,sr.ecb35,
               sr.ecb24,sr.ecb25,sr.ima02,sr.pmc03,l_sta,
              #FUN-7A0072---add---str---
               sr.ecu01,sr.ima021,sr.ecu02,sr.ecu03,sr.ecu04,
               sr.ecu05,sr.eca02,sr.ecb38,sr.ecb04,sr.ecb39,
               sr.ecb40,sr.ecb41,sr.ecb42,sr.ecb43,sr.ecb44,
               sr.ecb45,sr.ecb46,
              #FUN-7A0072---add---end---
               "",  l_img_blob,   "N","",              #TQC-C10034  add
              #TQC-BC0033---add---str---
               l_ima02,l_ecu03,l_ecb17,l_eca02,l_eci06
              #TQC-BC0033---add---end---
       #------------------------------ CR (3) -----------------------------
 
  
       #NO.FUN-840139 080429 By TSD.Leeway End  --
 
     END FOREACH
 
     
     #NO.FUN-840139 080429 By TSD.Leeway Start--
#    FINISH REPORT r620_rep
#
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ecb01,ima09,ima11,ecb02,ima06,ima10,ima12')
        RETURNING tm.wc 
     ELSE
        LET tm.wc = ''
     END IF    
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED      #FUN-7A0072 add
     LET g_str = tm.wc,";",tm.c,";",tm.d,";",tm.e,";",tm.g,";",g_azi03      #FUN-7A0072 add tm.g  #TQC-BC0033 add g_azi03 
    #FUN-7A0072---add---str---
     IF l_prog='aeci100' THEN 
        LET l_name='aecr620_1'
     ELSE 
        LET l_name='aecr620' 
     END IF
    #FUN-7A0072---add---end---
    #CALL cl_prt_cs3('aecr620','aecr620',g_sql,g_str) #FUN-7A0072 mark
    #TQC-C10034--add--begin
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "ecb01" 
    #TQC-C10034--add--end
     CALL cl_prt_cs3('aecr620',l_name,g_sql,g_str)    #FUN-7A0072 add
     #------------------------------ CR (4) ------------------------------#
 
 
     #NO.FUN-840139 080429 By TSD.Leeway End  --
END FUNCTION
 
REPORT r620_rep(sr)
   DEFINE
          l_last_sw     LIKE type_file.chr1,    #No.FUN-680073  VARCHAR(1)
          sr               RECORD ecb01 LIKE ecb_file.ecb01,	#料件編號
                                  ecb02 LIKE ecb_file.ecb02,	#製程編號
                                  ecb03 LIKE ecb_file.ecb03,	#作業序號
                                  ecb06 LIKE ecb_file.ecb06,    #作業編號
                                  ecb07 LIKE ecb_file.ecb07,    #機器編號
                                  ecb08 LIKE ecb_file.ecb08,    #工作站號
                                  ecb09 LIKE ecb_file.ecb09,    #盤點作業
                                  ecb10 LIKE ecb_file.ecb10,    #搬運時間
                                  ecb11 LIKE ecb_file.ecb11,    #作業重壘程度
                                  ecb12 LIKE ecb_file.ecb12,    #輸出裝置
                                  ecb13 LIKE ecb_file.ecb13,    #成本計算基準
                                  ecb14 LIKE ecb_file.ecb14,    #產出率
                                  ecb15 LIKE ecb_file.ecb15,    #人工數
                                  ecb16 LIKE ecb_file.ecb16,    #機器數
                                  ecb17 LIKE ecb_file.ecb17,    #備註
                                  ecb18 LIKE ecb_file.ecb18,    #人工設置時間
                                  ecb19 LIKE ecb_file.ecb19,    #人工生產時間
                                  ecb20 LIKE ecb_file.ecb20,    #機器設置時間
                                  ecb21 LIKE ecb_file.ecb21,    #機器生產時間
                                  ecb22 LIKE ecb_file.ecb22,    #廠外加工時間
                                  ecb23 LIKE ecb_file.ecb23,    #廠外加工成本
                                  ecb24 LIKE ecb_file.ecb24,    #廠外加工時間
                                  ecb25 LIKE ecb_file.ecb25,    #廠外加工廠商
                                  ecb26 LIKE ecb_file.ecb26,    #設置時間
                                  ecb27 LIKE ecb_file.ecb27,    #生產時間
                                  ecb28 LIKE ecb_file.ecb28,    #廠外加工時間
                                  ecb30 LIKE ecb_file.ecb30,    #人工設置時間
                                  ecb31 LIKE ecb_file.ecb31,    #人工生產時間
                                  ecb32 LIKE ecb_file.ecb32,    #機器設置時間
                                  ecb33 LIKE ecb_file.ecb33,    #機器生產時間
                                  ecb34 LIKE ecb_file.ecb34,    #廠外加工時間
                                  ecb35 LIKE ecb_file.ecb35,    #廠外加工成本
                                  ima02 LIKE ima_file.ima02,    #品名規格
                                  pmc03 LIKE pmc_file.pmc03     #廠商簡稱
                        END RECORD,
          l_i     LIKE type_file.num5,          #No.FUN-680073 SMALLINT
          l_sw    LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(01)
         #l_ecb13 LIKE mlc_file.mlc05,          #No.FUN-680073 VARCHAR(14)  #TQC-B30187
          l_ecb13 LIKE type_file.chr20,         #No.TQC-B30187
          l_str1,l_str2 LIKE bnb_file.bnb09,    #No.FUN-680073 VARCHAR(22)  
	  l_ecw05 LIKE ecw_file.ecw05,
	  l_ecw06 ARRAY[99] OF LIKE ecw_file.ecw06
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ecb01,sr.ecb02,sr.ecb03
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN (g_len-FGL_WIDTH(g_x[43]))/2,g_x[43] CLIPPED,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
      PRINT g_x[11] CLIPPED,' ',sr.ecb01,COLUMN 39,
            g_x[12] CLIPPED,' ',sr.ecb02
      PRINT g_x[13] CLIPPED,' ',sr.ecb03 USING'<<<<<'
      PRINT g_x[15] CLIPPED,' ',sr.ecb06
      PRINT g_x[17] CLIPPED,' ',sr.ecb07,COLUMN 39,
            g_x[18] CLIPPED,' ',sr.ecb08
      PRINT g_x[19] CLIPPED,' ',sr.ecb09,COLUMN 39,
            g_x[20] CLIPPED,' ',sr.ecb10 USING'<<<<<'
      PRINT g_x[21] CLIPPED,' ',sr.ecb11 USING'<<<.<<<',COLUMN 39,
            g_x[22] CLIPPED,' ',sr.ecb12,COLUMN 62,
            g_x[23] CLIPPED,' ',sr.ecb15 USING'<<<<<'
      PRINT g_x[24] CLIPPED,' ',sr.ecb13,' ',s_ecbsta(sr.ecb13),COLUMN 39,
            g_x[25] CLIPPED,' ',sr.ecb14 USING'<<<.<<<',' ',COLUMN 62,
            g_x[26] CLIPPED,' ',sr.ecb16 USING'<<<<<'
      PRINT g_x[27] CLIPPED,' ',sr.ecb17
      PRINT
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ecb03
     SKIP TO TOP OF PAGE
 
   ON EVERY ROW
      LET l_sw = 'N'
      IF tm.c = 'Y' THEN
         PRINT g_x[28] CLIPPED,g_x[44] CLIPPED;
         LET l_sw = 'Y'
      END IF
      IF tm.d = 'Y' THEN
         PRINT COLUMN 26,g_x[29] CLIPPED,g_x[44] CLIPPED;
         LET l_sw = 'Y'
      END IF
      IF tm.e = 'Y' THEN
         PRINT COLUMN 54,g_x[30] CLIPPED,g_x[44] CLIPPED;
         LET l_sw = 'Y'
      END IF
      IF l_sw = 'Y' THEN PRINT END IF
      IF tm.c = 'Y' THEN PRINT '-----------------------'; END IF
      IF tm.d = 'Y' THEN PRINT COLUMN 26,'-------------------------'; END IF
      IF tm.e = 'Y' THEN PRINT COLUMN 54,'---------------------------'; END IF
      IF l_sw = 'Y' THEN PRINT END IF
      IF tm.c = 'Y' THEN
         PRINT g_x[31] CLIPPED,' ',sr.ecb26 USING'<<<<<<.<<';
      END IF
      IF tm.d = 'Y' THEN
         PRINT COLUMN 26,g_x[32] CLIPPED,' ',sr.ecb18 USING'<<<<<<.<<';
      END IF
      IF tm.e = 'Y' THEN
         PRINT COLUMN 54,g_x[32] CLIPPED,' ',sr.ecb30 USING'<<<<<<.<<';
      END IF
      IF l_sw = 'Y' THEN PRINT END IF
      IF tm.c = 'Y' THEN
         PRINT g_x[33] CLIPPED,' ',sr.ecb27 USING'<<<<<<.<<';
      END IF
      IF tm.d = 'Y' THEN
         PRINT COLUMN 26,g_x[34] CLIPPED,' ',sr.ecb19 USING'<<<<<<.<<';
      END IF
      IF tm.e = 'Y' THEN
         PRINT COLUMN 54,g_x[34] CLIPPED,' ',sr.ecb31 USING'<<<<<<.<<';
      END IF
      IF l_sw = 'Y' THEN PRINT END IF
      IF tm.c = 'Y' THEN
         PRINT g_x[35] CLIPPED,' ',sr.ecb28 USING'<<<<<<.<<';
      END IF
      IF tm.d = 'Y' THEN
         PRINT COLUMN 26,g_x[36] CLIPPED,' ',sr.ecb20 USING'<<<<<<.<<';
      END IF
      IF tm.e = 'Y' THEN
         PRINT COLUMN 54,g_x[36] CLIPPED,' ',sr.ecb32 USING'<<<<<<.<<';
      END IF
      IF l_sw = 'Y' THEN PRINT END IF
      LET l_sw='N'
      IF tm.d = 'Y' THEN
         PRINT COLUMN 26,g_x[37] CLIPPED,' ',sr.ecb21 USING'<<<<<<.<<';
         LET l_sw = 'Y'
      END IF
      IF tm.e = 'Y' THEN
         PRINT COLUMN 54,g_x[37] CLIPPED,' ',sr.ecb33 USING'<<<<<<.<<';
         LET l_sw = 'Y'
      END IF
      IF l_sw = 'Y' THEN PRINT END IF
      IF tm.d = 'Y' THEN
         PRINT COLUMN 26,g_x[38] CLIPPED,' ',sr.ecb22 USING'<<<<<<.<<';
      END IF
      IF tm.e = 'Y' THEN
         PRINT COLUMN 54,g_x[38] CLIPPED,' ',sr.ecb34 USING'<<<<<<.<<';
      END IF
      IF l_sw = 'Y' THEN PRINT END IF
      IF tm.d = 'Y' THEN
         PRINT COLUMN 26,g_x[39] CLIPPED,' ';
         IF sr.ecb23 IS NOT NULL THEN
            CALL cl_numfor(sr.ecb23,14,g_azi03) RETURNING l_str1
            LET l_i = 1
            FOR g_i = 1 TO 22
                IF cl_null(l_str1[g_i,g_i]) THEN CONTINUE FOR END IF
                LET l_str2[l_i,l_i] = l_str1[g_i,g_i]
                LET l_i = l_i + 1
            END FOR
         END IF
         PRINT l_str2 CLIPPED;
      END IF
      IF tm.e = 'Y' THEN
         PRINT COLUMN 54,g_x[39] CLIPPED,' ';
         IF sr.ecb35 IS NOT NULL THEN
            CALL cl_numfor(sr.ecb35,14,g_azi03) RETURNING l_str1
            LET l_i = 1
            FOR g_i = 1 TO 22
                IF cl_null(l_str1[g_i,g_i]) THEN CONTINUE FOR END IF
                LET l_str2[l_i,l_i] = l_str1[g_i,g_i]
                LET l_i = l_i + 1
            END FOR
         END IF
         PRINT l_str2 CLIPPED
      END IF
      IF l_sw = 'Y' THEN PRINT END IF
      SKIP 1 LINE
      PRINT g_x[40] CLIPPED,' ',sr.ecb24,sr.ima02
      PRINT g_x[41] CLIPPED,' ',sr.ecb25,COLUMN 35,sr.pmc03
      SKIP 2 LINE
      DECLARE r620_c2 CURSOR FOR SELECT ecw05,ecw06 FROM ecw_file
              WHERE ecw01 = sr.ecb01 AND ecw02 = sr.ecb02 AND
                    ecw03 = sr.ecb03
              ORDER BY 1
      LET l_i = 1
      LET g_i = 0  #判斷此製程是否有作業說明
      FOREACH r620_c2 INTO l_ecw05,l_ecw06[l_i]
         IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH END IF
         IF l_i > 99 THEN
            CALL cl_err('',9036,0)
            EXIT FOREACH
         END IF
         LET l_i = l_i + 1
      END FOREACH
      LET l_i = l_i - 1  #正確的資料筆數
      IF l_i > 0 THEN   #7926
         PRINT g_x[42] CLIPPED,' ',l_ecw06[1] CLIPPED,' ',l_ecw06[2]
         FOR g_i = 3 TO l_i STEP 2
             PRINT COLUMN 15,l_ecw06[g_i] CLIPPED,' ',l_ecw06[g_i+1]
         END FOR
      END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
         THEN PRINT g_dash[1,g_len]
            #-- TQC-630166 begin
              #IF tm.wc[001,070] > ' ' THEN			# for 80
              #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
              #IF tm.wc[071,140] > ' ' THEN
	      #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
              #IF tm.wc[141,210] > ' ' THEN
	      #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
              #IF tm.wc[211,280] > ' ' THEN
	      #	  PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
              CALL cl_prt_pos_wc(tm.wc)
            #-- TQC-630166 end
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO.TQC-610035 <001,002> #
#FUN-870144
