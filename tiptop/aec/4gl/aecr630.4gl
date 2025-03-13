# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aecr630.4gl
# Descriptions...: 工作站資料列印
# Input parameter:
# Return code....:
# Date & Author..: 91/12/16 By Carol
# Modify.........: No.FUN-510032 05/02/21 By pengu 報表轉XML
# Modify.........: No.MOD-530146 05/03/17 By pengu 欄位QBE順序調整
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-690112 06/10/13 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/09 By Carrier 報表格式調整
# Modify.........: No.TQC-6C0190 06/12/27 By Ray 報表問題修改
# Modify.........: No.MOD-770009 07/07/09 By pengu 英文報表格式出現中文說明
# Modify.........: No.FUN-760085 07/07/13 By sherry  報表改由Crystal Report輸出                                                     
  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
	        wc  	STRING,	 		# Where condition
                b       LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1),  # 是否只列印主制程(Y/N
                more    LIKE type_file.chr1     #No.FUN-680073 VARCHAR(1)   # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680073 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(72)
#No.FUN-760085---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING,   
       l_sql          STRING                                                                                                        
#No.FUN-760085---End                                                                                                                
                                     
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
 
#No.FUN-760085---Begin
   LET g_sql = "eca01.eca_file.eca01,",
               "eca02.eca_file.eca02,",
               "eca03.eca_file.eca03,",
               "gem02.gem_file.gem02,",
               "eca04.eca_file.eca04,",
               "eca05_war.eca_file.eca05_war,",
               "imd02.imd_file.imd02,",
               "eca06.eca_file.eca06,",
               "eca05.eca_file.eca05,",
               "ime03.ime_file.ime03,",   
               "eca10.eca_file.eca10,",
               "eca12.eca_file.eca12,",
               "eca11.eca_file.eca11,",
               "eca13.eca_file.eca13,",
               "eca08.eca_file.eca08,",
               "eca50.eca_file.eca50,",
               "eca52.eca_file.eca52,",
               "eca51.eca_file.eca51,",
               "eca53.eca_file.eca53,",
               "ecb01.ecb_file.ecb01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ecb02.ecb_file.ecb02,",
               "ecb03.ecb_file.ecb03,",
               "ecb06.ecb_file.ecb06,",
               "ecb07.ecb_file.ecb07,"
                
   LET l_table = cl_prt_temptable('aecr630',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                                                   
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                           
#No.FUN-760085---End
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690112 by baogui
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r630_tm()	        	# Input print condition
      ELSE CALL aecr630()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
END MAIN
 
FUNCTION r630_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,         #No.FUN-680073 SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5  LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 8
   END IF
   OPEN WINDOW r630_w AT p_row,p_col
        WITH FORM "aec/42f/aecr630"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.b    = 'Y'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
    #--------MOD-530146------------------------------
     # CONSTRUCT BY NAME tm.wc ON eca01,eca03,ecb02
       CONSTRUCT BY NAME tm.wc ON eca01,ecb02,eca03
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
      LET INT_FLAG = 0 CLOSE WINDOW r630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.b,tm.more 		# Condition
   INPUT BY NAME tm.b,tm.more  WITHOUT DEFAULTS
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]"
            THEN NEXT FIELD b
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
      ON ACTION CONTROLP CALL r630_wc()          # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aecr630'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aecr630','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aecr630',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aecr630()
   ERROR ""
END WHILE
   CLOSE WINDOW r630_w
END FUNCTION
 
FUNCTION r630_wc()
   DEFINE l_wc        LIKE type_file.chr1000  #No.FUN-680073 VARCHAR(300)
 
   OPEN WINDOW r630_w2 AT 4,2
        WITH FORM "aec/42f/aeci600"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aeci600")
 
   CALL cl_ui_locale("aeci600")
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
	eca02, eca04, eca05_war,    eca05, eca06,
        eca07, eca08, eca09, eca10, eca11, eca12,
        eca13, eca54, eca50, eca51, eca52, eca53,
        ecauser,ecagrup,ecamodu,ecadate
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
   CLOSE WINDOW r630_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
      EXIT PROGRAM
         
   END IF
END FUNCTION
 
FUNCTION aecr630()
   DEFINE
          l_name        LIKE type_file.chr20,     #No.FUN-680073 VARCHAR(20) # External(Disk) file name   
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0100
          l_sql 	LIKE type_file.chr1000,	  # RDSQL STATEMENT #No.FUN-680073 VARCHAR(600) 
          l_za05        LIKE type_file.chr1000,   #No.FUN-680073 VARCHAR(40)
          l_order       ARRAY[5] OF LIKE cre_file.cre08,          #No.FUN-680073 VARCHAR(10)
          sr            RECORD  eca01     LIKE eca_file.eca01,	  #工作站編號
				eca02     LIKE eca_file.eca02,    #說明
				eca03     LIKE eca_file.eca03,    #部門編號
				eca04     LIKE eca_file.eca04,    #工作站型態
				eca05_war LIKE eca_file.eca05_war,#倉庫代號
				eca06     LIKE eca_file.eca06,    #產能型態
				eca05     LIKE eca_file.eca05,    #存放位置
				eca10     LIKE eca_file.eca10,    #機器數目
				eca12     LIKE eca_file.eca12,    #效率調整
				eca11     LIKE eca_file.eca11,    #人工數目
				eca13     LIKE eca_file.eca13,    #星期工作天數
				eca08     LIKE eca_file.eca08,    #產能小時
				eca50     LIKE eca_file.eca50,    #每天機器產能
				eca52     LIKE eca_file.eca52,    #每天人工產能
				eca51     LIKE eca_file.eca51,    #星期機器產能
				eca53     LIKE eca_file.eca53,    #星期人工產能
			     	ecb01     LIKE ecb_file.ecb01,    #料件編號
			     	ecb02     LIKE ecb_file.ecb02,    #製程編號
			     	ecb03     LIKE ecb_file.ecb03,    #作業序號
			     	ecb06     LIKE ecb_file.ecb06,    #作業編號
			     	ecb07     LIKE ecb_file.ecb07     #機器編號
                        END RECORD
 #No.FUN-760085---Begin
   DEFINE l_ima02       LIKE ima_file.ima02,                                    
          l_ima021      LIKE ima_file.ima021,   
          l_gem02 LIKE gem_file.gem02, #部門名稱                                
          l_imd02 LIKE imd_file.imd02, #倉庫名稱                                
          l_ime03 LIKE ime_file.ime03, #存放位置                                
          l_msg   LIKE type_file.chr8 
 #No.FUN-760085---End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog    
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND aecuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND aecgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND aecgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aecuser', 'aecgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT eca01, eca02, eca03, eca04, eca05_war, eca06,",
                 "       eca05, eca10, eca12, eca11, eca13, eca08,",
                 "       eca50, eca52, eca51, eca53, ecb01, ecb02,",
                 "       ecb03, ecb06, ecb07 ",
                 "  FROM eca_file, ecb_file ",
                 " WHERE eca01 = ecb08"," AND ecaacti ='Y' AND ecbacti ='Y'",
                 "   AND ",tm.wc
 
     IF tm.b = 'Y' THEN LET l_sql = l_sql CLIPPED, " AND ecb03 ='1' " END IF
     PREPARE r630_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690112 by baogui
        EXIT PROGRAM 
     END IF
     DECLARE r630_curs1 CURSOR FOR r630_prepare1
 #No.FUN-760085---Begin
 #   CALL cl_outnam('aecr630') RETURNING l_name
 #   START REPORT r630_rep TO l_name
     CALL cl_del_data(l_table)         
 #No.FUN-760085---End
     LET g_pageno = 0
     FOREACH r630_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH END IF
 #No.FUN-760085---Begin 
      #部門名稱                                                                 
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.eca03            
       IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF                           
      #工作站型態                                                               
{       IF sr.eca04 ='0' THEN CALL cl_getmsg('mfg4004',g_lang) RETURNING g_msg    
       ELSE IF sr.eca04 = '1' THEN CALL cl_getmsg('mfg4005',g_lang) RETURNING g_msg
            ELSE IF sr.eca04='2' THEN CALL cl_getmsg('mfg4006',g_lang) RETURNING g_msg
                 ELSE LET g_msg = null                                           
                 END IF                                                          
            END IF                                                               
       END IF                                                                    
      #產能型態                                                                 
       IF sr.eca06 = '1' THEN CALL cl_getmsg('mfg4082',g_lang) RETURNING l_msg   
       ELSE IF sr.eca06 = '2' THEN CALL cl_getmsg('mfg4083',g_lang) RETURNING l_m
            ELSE LET l_msg = NULL                                                
            END IF                                                               
       END IF                    }                                                
      #倉庫名稱                                                                 
       SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = sr.eca05_war        
       IF SQLCA.sqlcode THEN LET l_imd02 = NULL END IF                           
      #存放位置                                                                 
       SELECT ime03 INTO l_ime03 FROM ime_file                                   
        WHERE ime01 = sr.eca05_war AND ime02 = sr.eca05       
        SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059                   
        FROM ima_file WHERE ima01=sr.ecb01      
        IF SQLCA.sqlcode THEN LET l_ime03 = NULL END IF   
#       OUTPUT TO REPORT r630_rep(sr.*)
        EXECUTE insert_prep USING sr.eca01,sr.eca02,sr.eca03,l_gem02,sr.eca04,
                                  sr.eca05_war,l_imd02,sr.eca06,sr.eca05,l_ime03,
                                  sr.eca10,sr.eca12,sr.eca11,sr.eca13,sr.eca08,
                                  sr.eca50,sr.eca52,sr.eca51,sr.eca53,sr.ecb01,
                                  l_ima02,l_ima021,sr.ecb02,sr.ecb03,sr.ecb06,
                                  sr.ecb07 
 #No.FUN-760085---End
     END FOREACH
 #No.FUN-760085---Begin
 #   FINISH REPORT r630_rep
     IF g_zz05 = 'Y' THEN           
        CALL cl_wcchp(tm.wc,'eca01,ecb02,eca0')         
            RETURNING tm.wc                                                     
        LET g_str = tm.wc     
     END IF                                                                                                                          
     LET g_str = tm.wc    
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
 #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL cl_prt_cs3('aecr630','aecr630',l_sql,g_str)
 #No.FUN-760085---End 
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT r630_rep(sr)
   DEFINE
          l_last_sw     LIKE type_file.chr1,    #No.FUN-680073 VARCHAR(1)  
          l_ima02       LIKE ima_file.ima02,
          l_ima021      LIKE ima_file.ima021,   #FUN-5A0059
          sr            RECORD  eca01     LIKE eca_file.eca01,	  #工作站編號
				eca02     LIKE eca_file.eca02,    #說明
				eca03     LIKE eca_file.eca03,    #部門編號
				eca04     LIKE eca_file.eca04,    #工作站型態
				eca05_war LIKE eca_file.eca05_war,#倉庫代號
				eca06     LIKE eca_file.eca06,    #產能型態
				eca05     LIKE eca_file.eca05,    #存放位置
				eca10     LIKE eca_file.eca10,    #機器數目
				eca12     LIKE eca_file.eca12,    #效率調整
				eca11     LIKE eca_file.eca11,    #人工數目
				eca13     LIKE eca_file.eca13,    #星期工作天數
				eca08     LIKE eca_file.eca08,    #產能小時
				eca50     LIKE eca_file.eca50,    #每天機器產能
				eca52     LIKE eca_file.eca52,    #每天人工產能
				eca51     LIKE eca_file.eca51,    #星期機器產能
				eca53     LIKE eca_file.eca53,    #星期人工產能
			     	ecb01     LIKE ecb_file.ecb01,    #料件編號
			     	ecb02     LIKE ecb_file.ecb02,    #製程編號
			     	ecb03     LIKE ecb_file.ecb03,    #作業序號
			     	ecb06     LIKE ecb_file.ecb06,    #作業編號
			     	ecb07     LIKE ecb_file.ecb07     #機器編號
                        END RECORD,
	  l_gem02 LIKE gem_file.gem02, #部門名稱
	  l_imd02 LIKE imd_file.imd02, #倉庫名稱
	  l_ime03 LIKE ime_file.ime03, #存放位置
          l_msg   LIKE type_file.chr8    #No.FUN-680073 VARCHAR(8) #產能型態
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.eca01, sr.ecb01, sr.ecb02, sr.ecb03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED #No.TQC-6A0093
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
 
      #部門名稱
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.eca03
      IF SQLCA.sqlcode THEN LET l_gem02 = NULL END IF
      #工作站型態
      IF sr.eca04 ='0' THEN CALL cl_getmsg('mfg4004',g_lang) RETURNING g_msg             #MOD-770009 modify 
      ELSE IF sr.eca04 = '1' THEN CALL cl_getmsg('mfg4005',g_lang) RETURNING g_msg       #MOD-770009 modify
	   ELSE IF sr.eca04='2' THEN CALL cl_getmsg('mfg4006',g_lang) RETURNING g_msg    #MOD-770009 modify
		ELSE LET g_msg = null
		END IF
	   END IF
      END IF
      #產能型態
      IF sr.eca06 = '1' THEN CALL cl_getmsg('mfg4082',g_lang) RETURNING l_msg        #MOD-770009 modify 
      ELSE IF sr.eca06 = '2' THEN CALL cl_getmsg('mfg4083',g_lang) RETURNING l_msg   #MOD-770009 modify
	   ELSE LET l_msg = NULL
	   END IF
      END IF
      #倉庫名稱
      SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = sr.eca05_war
      IF SQLCA.sqlcode THEN LET l_imd02 = NULL END IF
      #存放位置
      SELECT ime03 INTO l_ime03 FROM ime_file
       WHERE ime01 = sr.eca05_war AND ime02 = sr.eca05
      IF SQLCA.sqlcode THEN LET l_ime03 = NULL END IF
 
      #No.TQC-6A0093  --Begin
      PRINT g_x[11] CLIPPED,COLUMN 23, sr.eca01,
            COLUMN 75,g_x[12] CLIPPED,COLUMN 98, sr.eca02
      PRINT g_x[13] CLIPPED, COLUMN 23,sr.eca03,' ',l_gem02,
            COLUMN 75,g_x[14] CLIPPED,COLUMN 98, sr.eca04,' ',g_msg CLIPPED
      PRINT g_x[15] CLIPPED, COLUMN 23,sr.eca05_war,' ', l_imd02,
            COLUMN 75,g_x[16] CLIPPED, COLUMN 98,sr.eca06,' ',l_msg
      PRINT g_x[17] CLIPPED, COLUMN 23,sr.eca05,' ',l_ime03,
 	    COLUMN 75,g_x[18] CLIPPED, COLUMN 98,sr.eca10 USING '#####'
      PRINT g_x[19] CLIPPED, COLUMN 23,sr.eca12 USING '##&.&&',
            COLUMN 75,g_x[20] CLIPPED, COLUMN 98,sr.eca11 USING '#####'
      PRINT g_x[21] CLIPPED, COLUMN 23,sr.eca13 USING '&.&&',
            COLUMN 75,g_x[22] CLIPPED, COLUMN 98,sr.eca08 USING '#&.&&'
      PRINT g_x[23] CLIPPED, COLUMN 23,sr.eca50 USING '###,###,##&.&&',
            COLUMN 75,g_x[24] CLIPPED, COLUMN 98,sr.eca52 USING '###,###,##&.&&'
      PRINT g_x[25] CLIPPED, COLUMN 23,sr.eca51 USING '###,###,##&.&&',
            COLUMN 75,g_x[26] CLIPPED, COLUMN 98,sr.eca53 USING '###,###,##&.&&'
      #No.TQC-6A0093  --End  
      PRINT
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED   #FUN-5A0059
      PRINT g_dash1
      LET l_last_sw = 'n'
 # 34567890123456789012345678901234567890123456789012345678901234567890123456
#  3                   24       33       42       51       60       71
 
   BEFORE GROUP OF sr.eca01
      IF (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.ecb01
     #SELECT ima02 INTO l_ima02                   #FUN-5A0059 mark
      SELECT ima02,ima021 INTO l_ima02,l_ima021   #FUN-5A0059
        FROM ima_file WHERE ima01=sr.ecb01
      PRINT COLUMN g_c[31],sr.ecb01,
            COLUMN g_c[32],l_ima02;
      PRINT COLUMN g_c[33],l_ima021;   #FUN-5A0059
 
  #start FUN-5A0059
   BEFORE GROUP OF sr.ecb02
      PRINT COLUMN g_c[34], sr.ecb02
 
   BEFORE GROUP OF sr.ecb03
#     PRINT COLUMN g_c[35], sr.ecb03 USING '####';     #No.TQC-6C0190
      PRINT COLUMN g_c[35], sr.ecb03 USING '########';     #No.TQC-6C0190
 
   ON EVERY ROW
      PRINT COLUMN g_c[36],sr.ecb06 CLIPPED,
            COLUMN g_c[37],sr.ecb07
  #end FUN-5A0059
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         PRINT g_dash[1,g_len]
       #-- TQC-630166 begin
         #IF tm.wc[001,070] > ' ' THEN			# for 80
	 #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
         #IF tm.wc[071,140] > ' ' THEN
	 #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
         #IF tm.wc[141,210] > ' ' THEN
	 #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
         #IF tm.wc[211,280] > ' ' THEN
	 #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#        IF tm.wc[001,120] > ' ' THEN			# for 132
#	    PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#        IF tm.wc[121,240] > ' ' THEN
#	    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#        IF tm.wc[241,300] > ' ' THEN
#	    PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
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
}
#No.FUN-760085---End
