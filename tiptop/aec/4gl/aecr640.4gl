# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aecr640.4gl
# Descriptions...: 作業資料列印
# Input parameter:
# Return code....:
# Date & Author..: 91/12/16 By Nora
# Modify.........: No.MOD-530132 05/03/17 By pengu 欄位QBE順序調整
# Modify.........: No.FUN-590110 05/09/28 By jackie 報表轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-610070 01/19 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-690112 06/10/13 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-840139 08/04/29 By TSD.Lori 改為CR報表
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	        wc  	STRING,			# Where condition
               #b    	DATE,		        # 有效日期    #TQC-610070
                more    LIKE type_file.chr1     #No.FUN-680073 VARCHAR(1) # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680073 SMALLINT
DEFINE   l_table         STRING       #No.FUN-840139 080429 By TSD.Lori
DEFINE   l_table1        STRING       #No.FUN-840139 080429 By TSD.Lori
DEFINE   g_str           STRING       #No.FUN-840139 080429 By TSD.Lori
DEFINE   g_sql           STRING       #No.FUN-840139 080429 By TSD.Lori
 
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
 
   #No.FUN-840139 080429 By TSD.Lori------------------------(S)
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ecd01.ecd_file.ecd01,",    #作業編號
               "ecd05.ecd_file.ecd05,",    #作業型態
               "ecd16.ecd_file.ecd16,",    #人工設置時間
               "ecd17.ecd_file.ecd17,",    #人工生產時間
               "ecd18.ecd_file.ecd18,",    #機器設置時間
               "ecd19.ecd_file.ecd19,",    #機器生產時間
               "ecd20.ecd_file.ecd20,",    #廠外加工時間
               "ecd21.ecd_file.ecd21,",    #廠外加工成本
               "ecd24.ecd_file.ecd24,",    #設置時間
               "ecd25.ecd_file.ecd25,",    #生產時間
               "ecd26.ecd_file.ecd26,",    #廠外加工時間
               "ecb01.ecb_file.ecb01,",    #料件編號
               "ecb02.ecb_file.ecb02,",    #製程編號
               "ecb03.ecb_file.ecb03,",    #作業序號
               "ecb07.ecb_file.ecb07,",    #機器編號
               "ecb08.ecb_file.ecb08"
 
   LET l_table = cl_prt_temptable('aecr640',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "ecd01.ecd_file.ecd01,",
               "ecz04.ecz_file.ecz04,",
               "ecz05.type_file.chr1000"
   
   LET l_table1 = cl_prt_temptable('aecr6401',g_sql) CLIPPED   # 產生Temp Table
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   #------------------------------ CR (1) ------------------------------#
   #No.FUN-840139 080429 By TSD.Lori------------------------(E)
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690112 by baogui
 
#No.CHI-6A0004--begin
#   SELECT azi03 INTO g_azi03 FROM azi_file      # 成本之小數位數
#          WHERE azi01 = g_aza.aza17
#  IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aza.aza17,SQLCA.sqlcode,0) #No.FUN-660091
#     CALL cl_err3("sel","azi_file",g_aza.aza17,"",SQLCA.sqlcode,"","",0) #FUN-660091
#  END IF
#No.CHI-6A0004--end
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.b  = ARG_VAL(8)       #TQC-610070
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r640_tm()	        	# Input print condition
      ELSE CALL r640()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
END MAIN
 
FUNCTION r640_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680073 SMALLINT 
          l_cmd		LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 9
   END IF
   OPEN WINDOW r640_w AT p_row,p_col
        WITH FORM "aec/42f/aecr640"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    #-------------MOD-530132----------------------------
      # CONSTRUCT BY NAME tm.wc ON ecd01,ecd06,ecd07
        CONSTRUCT BY NAME tm.wc ON ecd01,ecd07,ecd06
   #-------------END----------------------------------
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
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r640_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.more 		# Condition
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
 
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
      ON ACTION CONTROLP CALL r640_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r640_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aecr640'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aecr640','9031',1)
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
                        #" '",tm.b CLIPPED,"'",                 #TQC-610037
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aecr640',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r640_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r640()
   ERROR ""
END WHILE
   CLOSE WINDOW r640_w
END FUNCTION
 
FUNCTION r640_wc()
   DEFINE l_wc      LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(300) 
 
   OPEN WINDOW r640_w2 AT 2,2
        WITH FORM "aec/42f/aecu010"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aecu010")
 
   CALL cl_ui_locale("aecu010")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
        ecd02,ecd05,
        ecd08,ecd09,ecd10,ecd11,ecd12,ecd13,ecd14,
        ecd15,ecd24,ecd25,ecd26,ecd21,ecd23,ecd16,
        ecd17,ecd18,ecd19,ecd20,ecd22,
        ecduser,ecdgrup,ecdmodu,ecddate,ecdacti
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
   CLOSE WINDOW r640_w2
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET l_wc = l_wc clipped," AND ecduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET l_wc = l_wc clipped," AND ecdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET l_wc = l_wc clipped," AND ecdgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET l_wc = l_wc CLIPPED,cl_get_extra_cond('ecduser', 'ecdgrup')
   #End:FUN-980030
 
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r640_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
END FUNCTION
 
FUNCTION r640()
   DEFINE
          l_name        LIKE type_file.chr20,     #No.FUN-680073 VARCHAR(20) # External(Disk) file name 
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0100
          l_sql 	LIKE type_file.chr1000,   #No.FUN-680073 VARCHAR(1000) # RDSQL STATEMENT 
          l_chr		LIKE type_file.chr1,      #No.FUN-680073 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,   #No.FUN-680073 VARCHAR(40) 
          l_order       ARRAY[5] OF LIKE cre_file.cre08,        #No.FUN-680073 VARCHAR(10)
          sr               RECORD ecd01 LIKE ecd_file.ecd01,	#作業編號
                                  ecd05 LIKE ecd_file.ecd05,    #作業型態
                                  ecd16 LIKE ecd_file.ecd16,    #人工設置時間
                                  ecd17 LIKE ecd_file.ecd17,    #人工生產時間
                                  ecd18 LIKE ecd_file.ecd18,    #機器設置時間
                                  ecd19 LIKE ecd_file.ecd19,    #機器生產時間
                                  ecd20 LIKE ecd_file.ecd20,    #廠外加工時間
                                  ecd21 LIKE ecd_file.ecd21,    #廠外加工成本
                                  ecd24 LIKE ecd_file.ecd24,    #設置時間
                                  ecd25 LIKE ecd_file.ecd25,    #生產時間
                                  ecd26 LIKE ecd_file.ecd26,    #廠外加工時間
                                  ecb01 LIKE ecb_file.ecb01,    #料件編號
                                  ecb02 LIKE ecb_file.ecb02,    #製程編號
                                  ecb03 LIKE ecb_file.ecb03,    #作業序號
                                  ecb07 LIKE ecb_file.ecb07,    #機器編號
                                  ecb08 LIKE ecb_file.ecb08     #工作站編號
                        END RECORD
     #No.FUN-840139 080429 By TSD.Lori--------------(S)
     DEFINE l_ecz04      LIKE ecz_file.ecz04,
            l_ecz05      LIKE ecz_file.ecz05,
            l_str        LIKE type_file.chr1000,
            l_i          LIKE type_file.num5,
            l_cnt        LIKE type_file.num5
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80046 ADD
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80046 ADD
        EXIT PROGRAM
     END IF
 
     #------------------------------ CR (2) ------------------------------#
     #No.FUN-840139 080429 By TSD.Lori--------------(E)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ecduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ecdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ecdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     #End:FUN-980030
 
     LET l_sql = "SELECT ecd01,ecd05,ecd16,ecd17,ecd18,",
                 " ecd19,ecd20,ecd21,ecd24,ecd25,ecd26,ecb01,",
                 " ecb02,ecb03,ecb07,ecb08",
                 "  FROM ecd_file, ecb_file",
                 " WHERE ecd01 = ecb06"  CLIPPED,
                 "   AND ",tm.wc CLIPPED
     PREPARE r640_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
        EXIT PROGRAM 
        END IF
     DECLARE r640_c1 CURSOR FOR r640_p1
 
     #No.FUN-840139 080429 By TSD.Lori----------------(S)
     LET l_sql = "SELECT ecz04,ecz05 FROM ecz_file WHERE ecz01 = ? ",
                 " ORDER BY ecz04 "
     PREPARE r640_p3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
        END IF
     DECLARE r640_c3 CURSOR FOR r640_p3
     #No.FUN-840139 080429 By TSD.Lori----------------(E)
 
     CALL cl_outnam('aecr640') RETURNING l_name
     #START REPORT r640_rep TO l_name   #No.FUN-840139 080429 By TSD.Lori mark
     LET g_pageno = 0
     FOREACH r640_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
      #No.FUN-840139 080429 By TSD.Lori-----------------------------(S)
      #OUTPUT TO REPORT r640_rep(sr.*)
       LET l_str = ''
       LET l_cnt = 0
       LET l_i = 0
       FOREACH r640_c3 USING sr.ecd01 INTO l_ecz04,l_ecz05
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET l_str = l_str CLIPPED,' ',l_ecz05
          LET l_cnt = l_cnt + 1
          LET l_i = l_ecz04 mod 3
          IF l_i = 0 THEN
             EXECUTE insert_prep1 USING sr.ecd01,l_ecz04,l_str
             LET l_str = ''
          END IF
       END FOREACH
       IF NOT cl_null(l_str) THEN
          EXECUTE insert_prep1 USING sr.ecd01,l_ecz04,l_str
       END IF
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.*
      #------------------------------ CR (3) -----------------------------
      #No.FUN-840139 080429 By TSD.Lori-----------------------------(E)
 
     END FOREACH
    #No.FUN-840139 080429 By TSD.Lori----------------(S)
    #FINISH REPORT r640_rep
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ecd01,ecd06,ecd07')
        RETURNING tm.wc
     ELSE
        LET tm.wc = ''
     END IF
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table1 CLIPPED
     LET g_str = tm.wc,";",g_azi03
     CALL cl_prt_cs3('aecr640','aecr640',g_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
    #No.FUN-840139 080429 By TSD.Lori----------------(E)
 
END FUNCTION
 
#No.FUN-840139 080429 By TSD.Lori mark-------------(S)
#REPORT r640_rep(sr)
#   DEFINE
#          l_last_sw     LIKE type_file.chr1,    #No.FUN-680073  VARCHAR(1)
#          sr               RECORD ecd01 LIKE ecd_file.ecd01,	#作業編號
#                                  ecd05 LIKE ecd_file.ecd05,    #作業型態
#                                  ecd16 LIKE ecd_file.ecd16,    #人工設置時間
#                                  ecd17 LIKE ecd_file.ecd17,    #人工生產時間
#                                  ecd18 LIKE ecd_file.ecd18,    #機器設置時間
#                                  ecd19 LIKE ecd_file.ecd19,    #機器生產時間
#                                  ecd20 LIKE ecd_file.ecd20,    #廠外加工時間
#                                  ecd21 LIKE ecd_file.ecd21,    #廠外加工成本
#                                  ecd24 LIKE ecd_file.ecd24,    #設置時間
#                                  ecd25 LIKE ecd_file.ecd25,    #生產時間
#                                  ecd26 LIKE ecd_file.ecd26,    #廠外加工時間
#                                  ecb01 LIKE ecb_file.ecb01,    #料件編號
#                                  ecb02 LIKE ecb_file.ecb02,    #製程編號
#                                  ecb03 LIKE ecb_file.ecb03,    #作業序號
#                                  ecb07 LIKE ecb_file.ecb07,    #機器編號
#                                  ecb08 LIKE ecb_file.ecb08     #工作站編號
#                        END RECORD,
#          l_str1,l_str2 LIKE bnb_file.bnb09,    #No.FUN-680073 VARCHAR(22)
#          l_i     LIKE type_file.num5,          #No.FUN-680073 SMALLINT
#          l_ecd05 LIKE mld_file.mld01,          #No.FUN-680073 VARCHAR(12)
#	  l_ecz04 LIKE ecz_file.ecz04,
#	  l_ecz05 ARRAY[99] OF LIKE ecz_file.ecz05
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.ecd01,sr.ecb01,sr.ecb02,sr.ecb03
#  FORMAT
#   PAGE HEADER
##No.FUN-590110 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
##No.FUN-590110 --end--
#      PRINT g_dash[1,g_len]
#      PRINT g_x[11] CLIPPED,' ',sr.ecd01,COLUMN 46,g_x[12] CLIPPED,
#            ' ',sr.ecd05,' ';
#      CASE sr.ecd05
#           WHEN '1'  LET l_ecd05 = g_x[28] CLIPPED
#           WHEN '2'  LET l_ecd05 = g_x[29] CLIPPED
#           WHEN '3'  LET l_ecd05 = g_x[30] CLIPPED
#           WHEN '4'  LET l_ecd05 = g_x[31] CLIPPED
#      END CASE
#      PRINT l_ecd05
#      PRINT
#      PRINT g_x[15] CLIPPED,COLUMN 42,g_x[16] CLIPPED
##      PRINT '   -------------------       ----------',
##            '--------------------------------'
#      PRINT g_x[26],g_x[27]   #No.FUN-590110
#      PRINT COLUMN 5,g_x[17] CLIPPED,sr.ecd24 USING'<<<<<<.<<',COLUMN 30,
#            g_x[18] CLIPPED,sr.ecd16 USING'<<<<<<.<<',
#            COLUMN 54,g_x[19] CLIPPED,sr.ecd18 USING'<<<<<<.<<'
#      PRINT COLUMN 5,g_x[20] CLIPPED,sr.ecd25 USING'<<<<<<.<<',COLUMN 30,
#            g_x[21] CLIPPED,sr.ecd17 USING'<<<<<<.<<',COLUMN 54,
#            g_x[22] CLIPPED,sr.ecd19 USING'<<<<<<.<<'
#      PRINT COLUMN 5,g_x[23] CLIPPED,sr.ecd26 USING'<<<<<<.<<',COLUMN 30,
#            g_x[23] CLIPPED,sr.ecd20 USING'<<<<<<.<<',COLUMN 54,
#            g_x[24] CLIPPED;
#      IF sr.ecd21 IS NOT NULL THEN
#         CALL cl_numfor(sr.ecd21,14,g_azi03) RETURNING l_str1
#         LET l_i = 1
#         FOR g_i = 1 TO 22
#             IF cl_null(l_str1[g_i,g_i]) THEN CONTINUE FOR END IF
#             LET l_str2[l_i,l_i] = l_str1[g_i,g_i]
#             LET l_i = l_i + 1
#         END FOR
#      END IF
#      PRINT l_str2 CLIPPED
#      SKIP 2 LINE
#      DECLARE r640_c2 CURSOR FOR SELECT ecz04,ecz05 FROM ecz_file
#              WHERE ecz01 = sr.ecd01
#              ORDER BY 1
#      LET l_i = 1
#      LET g_i = 0  #判斷此作業是否有作業描述
#      FOREACH r640_c2 INTO l_ecz04,l_ecz05[l_i]
#         IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH END IF
#         IF l_i > 100 THEN
#            CALL cl_err('',9036,0)
#            EXIT FOREACH
#         END IF
#         LET l_i = l_i + 1
#      END FOREACH
#      LET l_i = l_i - 1  #正確的資料筆數
#      LET g_i = l_i
#      CLOSE r640_c2
#
#   BEFORE GROUP OF sr.ecd01
#      IF (PAGENO > 1 OR LINENO > 9) THEN
#         SKIP TO TOP OF PAGE
#      END IF
#      IF g_i > 0 THEN   #印出作業描述之TITLE
#         PRINT g_x[25] CLIPPED,' ',l_ecz05[1] CLIPPED,' ',
#               l_ecz05[2] CLIPPED,' ',l_ecz05[3] CLIPPED
#      END IF
#      FOR g_i = 4 TO l_i STEP 3  #印出作業描述(將三個描述印在同一列上)
#         PRINT COLUMN 11,l_ecz05[g_i] CLIPPED,' ',
#               l_ecz05[g_i+1] CLIPPED,' ',l_ecz05[g_i+2]
#      END FOR
#      PRINT
##No.FUN-590110 --start--
#      PRINTX name=H1 g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.ecb01
#      PRINTX name=D1 COLUMN g_c[32],sr.ecb01 CLIPPED; #FUN-5B0014 [1,20];
#
#   BEFORE GROUP OF sr.ecb02
#      PRINTX name=D1 COLUMN g_c[33],sr.ecb02 CLIPPED;
#
#   BEFORE GROUP OF sr.ecb03
#      PRINTX name=D1 COLUMN g_c[34],sr.ecb03 USING'########';
#
#   ON EVERY ROW
#      PRINTX name=D1
#            COLUMN g_c[35],sr.ecb07 CLIPPED,
#            COLUMN g_c[36],sr.ecb08 CLIPPED
##No.FUN-590110 --end--
#
#   ON LAST ROW
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash[1,g_len]
#            #-- TQC-630166 begin
#              #IF tm.wc[001,070] > ' ' THEN			# for 80
#              #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#              #IF tm.wc[071,140] > ' ' THEN
#	      #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#              #IF tm.wc[141,210] > ' ' THEN
#	      #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#              #IF tm.wc[211,280] > ' ' THEN
#	      #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#              CALL cl_prt_pos_wc(tm.wc)
#            #-- TQC-630166 end
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-840139 080429 By TSD.Lori--------------(E)
#Patch....NO.TQC-610035 <001> #
#FUN-870144
