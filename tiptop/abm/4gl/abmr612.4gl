# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abmr612.4gl
# Descriptions...: 單階材料用途清單-family
# Input parameter:
# Return code....:
# Date & Author..: 92/03/19 By Nora
#      Modify    : 92/05/27 By David
# Modify.........: No.FUN-550095 05/06/03 By Mandy 特性BOM
# Modify.........: No.TQC-5A0030 05/10/13 By Carrier 報表格式調整
# Modify.........: No.MOD-640141 06/04/09 By Echo 執行列印後會直接跳出
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
#
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6B0096 06/11/20 By Ray 有效日期只有時間沒有文字，而且應該居中
# Modify.........: No.FUN-850057 08/05/13 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 12/01/06 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		      wc  	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
   		      revision  LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
   		      effective LIKE type_file.dat,     #No.FUN-680096 DATE
   		      c         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
   	              more      LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD,
          g_sw      LIKE type_file.num5,     #No.FUN-680096 SMALLINT
	  g_bmb01   ARRAY[37] OF LIKE  bmb_file.bmb01,
	  g_bmb29   ARRAY[37] OF LIKE  bmb_file.bmb29 #FUN-550095 add
 
DEFINE   g_cnt      LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_i        LIKE type_file.num5      #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_msg      LIKE ze_file.ze03        #No.FUN-680096 VARCHAR(72)
DEFINE   g_str      STRING     #NO.FUN-850057
DEFINE   g_sql      STRING     #NO.FUN-850057
DEFINE   l_table    STRING     #NO.FUN-850057
DEFINE   l_table1   STRING     #NO.FUN-850057
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
   #NO.FUN-850057---BEGIN---
   LET g_sql = "bmb01.bmb_file.bmb01,",
               "bmb29.bmb_file.bmb29,",
               "bmb03.bmb_file.bmb03,",
               "ima02.ima_file.ima02,",
               "temp1.type_file.num5,",
               "temp2.type_file.num5,",
               "temp3.type_file.num5,",
               "temp4.type_file.num5,",
               "temp5.type_file.num5,",
               "temp6.type_file.num5,",
               "temp7.type_file.num5,",
               "temp8.type_file.num5,",
               "temp9.type_file.num5,",
               "temp10.type_file.num5,",
               "temp11.type_file.num5,",
               "temp12.type_file.num5,",                                         
               "temp13.type_file.num5,",                                         
               "temp14.type_file.num5,",                                         
               "temp15.type_file.num5,",                                         
               "temp16.type_file.num5,",                                         
               "temp17.type_file.num5,",                                         
               "temp18.type_file.num5,",                                         
               "temp19.type_file.num5,",                                         
               "temp20.type_file.num5,",                                         
               "temp21.type_file.num5,",                                         
               "temp22.type_file.num5,",
               "temp23.type_file.num5,",                                         
               "temp24.type_file.num5,",                                         
               "temp25.type_file.num5,",                                         
               "temp26.type_file.num5,",                                         
               "temp27.type_file.num5,",                                         
               "temp28.type_file.num5,",                                         
               "temp29.type_file.num5,",                                         
               "temp30.type_file.num5,",                                         
               "temp31.type_file.num5,",                                         
               "temp32.type_file.num5,",                                         
               "temp33.type_file.num5,",
               "temp34.type_file.num5,",                                         
               "temp35.type_file.num5,",                                         
               "temp36.type_file.num5,",                                         
               "temp37.type_file.num5,",
               "flag.type_file.chr1"
   LET l_table = cl_prt_temptable('abmr612',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "bmb01.bmb_file.bmb01,",                                         
               "bmb29.bmb_file.bmb29,",                                         
               "ima02.ima_file.ima02"
   LET l_table1 = cl_prt_temptable('abmr612_1',g_sql)                              
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   #NO.FUN-850057---END----
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.revision  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL abmr612_tm(0,0)			# Input print condition
      ELSE CALL abmr612()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION abmr612_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07, 
          l_edate       LIKE bmx_file.bmx08,
          l_bmb03       LIKE bmb_file.bmb03,
          l_cmd		LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 9 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 9
   END IF
 
   OPEN WINDOW abmr612_w AT p_row,p_col
        WITH FORM "abm/42f/abmr612"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c ='N'   #不列印品名規格
   LET tm.effective = g_today	#有效日期
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
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abmr612_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT COUNT(DISTINCT bmb03),bmb03 FROM bmb_file,ima_file",
                 " WHERE bmb03=ima01 AND ",tm.wc CLIPPED," GROUP BY bmb03"
       PREPARE abmr612_cnt_p FROM l_cmd
       DECLARE abmr612_cnt CURSOR FOR abmr612_cnt_p
       IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM
             
       END IF
       MESSAGE " SEARCHING ! "
       CALL ui.Interface.refresh()
       OPEN abmr612_cnt
       FETCH abmr612_cnt INTO g_cnt,l_bmb03
       IF SQLCA.sqlcode OR g_cnt IS NULL OR g_cnt = 0 THEN
          CALL cl_err(g_cnt,'mfg2601',0)
          CONTINUE WHILE
       ELSE
           IF g_cnt=1 THEN
               LET l_one='Y'
           END IF
       END IF
       MESSAGE " "
       CALL ui.Interface.refresh()
   END IF
 
   DISPLAY BY NAME tm.revision,tm.effective,tm.c,tm.more
   INPUT BY NAME tm.revision,tm.effective,tm.c,tm.more WITHOUT DEFAULTS
 
      BEFORE FIELD revision
         IF l_one='N' THEN
             NEXT FIELD effective
         END IF
 
      AFTER FIELD revision
         IF tm.revision IS NOT NULL THEN
            CALL s_version(l_bmb03,tm.revision)
            RETURNING l_bdate,l_edate,l_flag
            LET tm.effective = l_bdate
            DISPLAY BY NAME tm.effective
         END IF
 
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES '[YN]' THEN
            NEXT FIELD c
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
      ON ACTION CONTROLP CALL abmr612_wc()   # Input detail Where Condition
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
   LET g_sw = TRUE
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abmr612_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr612'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr612','9031',1)
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
                         " '",tm.revision CLIPPED,"'",
                         " '",tm.effective CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr612',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW abmr612_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr612()
   ERROR ""
END WHILE
   CLOSE WINDOW abmr612_w
END FUNCTION
 
FUNCTION abmr612_wc()
   DEFINE l_wc   LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW abmr612_w2 AT 2,2
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
 
   CLOSE WINDOW abmr612_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
FUNCTION abmr612()
   DEFINE l_name	LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000,# RDSQL STATEMENT   #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(40)
          sr  RECORD
              bmb01 LIKE bmb_file.bmb01,    #主件料件
              bmb29 LIKE bmb_file.bmb29,    #FUN-550095
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02     #品名規格
          END RECORD
DEFINE  l_t      LIKE type_file.chr1000
DEFINE l_str     LIKE type_file.chr1000   #NO.FUN-850057
DEFINE l_bmb01   ARRAY[37] OF LIKE bmb_file.bmb01   #NO.FUN-850057
DEFINE l_bmb03_t   LIKE bmb_file.bmb03    #NO.FUN-850057
DEFINE l_temp      ARRAY[37] OF LIKE type_file.num5   #NO.FUN-850057
DEFINE l_i         LIKE type_file.num5
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #MOD-640141
     #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr612'
     #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 193 END IF
     #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #END MOD-640141
 
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
     #NO.FUN-850057----BEGIN----
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table,                      
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                        
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                        
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                        
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                       
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)                                      
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM                                                              
   END IF 
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1,                      
               " VALUES(?, ?, ?)"                        
     PREPARE insert_prep1 FROM g_sql                                               
     IF STATUS THEN                                                               
        CALL cl_err('insert_prep1:',status,1)                                      
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM                                                              
     END IF
     #NO.FUN-850057----END-----
     LET l_sql = "SELECT bmb01,bmb29,bmb03,ima02", #FUN-550095 add bmb29
                 " FROM bma_file,bmb_file,ima_file",
                 " WHERE bma01 = bmb01 AND ima01 = bmb03",
                 "   AND bma06 = bmb29 ", #FUN-550095 add
                 " AND ",tm.wc
     #生效日及失效日的判斷
     IF tm.effective IS NOT NULL THEN
          LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
          "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
          "' OR bmb05 IS NULL)"
     END IF
	#LET l_sql = l_sql CLIPPED," ORDER BY 2,1"               #FUN-550095
     LET l_sql = l_sql CLIPPED," ORDER BY bmb03,bmb01,bmb29" #FUN-550095
     PREPARE abmr612_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE abmr612_curs1 CURSOR FOR abmr612_prepare1
 
#     CALL cl_outnam('abmr612') RETURNING l_name    #NO.FUN-850057
 
     #MOD-640141
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr612'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 193 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #END MOD-640141
 
#     START REPORT abmr612_rep TO l_name     #NO.FUN-850057
 
     FOR g_i = 1 TO 37 LET g_bmb01[g_i] = NULL END FOR  #FUN-550095
     FOR g_i = 1 TO 37 LET g_bmb29[g_i] = NULL END FOR  #FUN-550095 add
     LET g_pageno = 0
	 LET g_cnt = 0
     FOREACH abmr612_curs1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #將所有相異的主件料號, 暫存在array 中
	   IF g_cnt = 0 THEN
		  LET g_bmb01[1] = sr.bmb01
		  LET g_bmb29[1] = sr.bmb29
		  LET g_cnt = 1
	   ELSE
              FOR g_i = 1 TO g_cnt
	       #IF g_bmb01[g_i] = sr.bmb01 THEN
	        IF g_bmb01[g_i] = sr.bmb01 AND g_bmb29[g_i] = sr.bmb29 THEN  #FUN-550095 add
		   EXIT FOR
	        END IF
	      END FOR
	      IF g_i = g_cnt + 1 THEN
		 LET g_cnt = g_cnt + 1
	         IF g_cnt > 37 THEN
          	    LET g_cnt = 37
    	            CALL cl_getmsg('mfg2731',g_lang) RETURNING g_msg
                    CALL cl_prompt(0,0,g_msg) RETURNING g_sw
                    EXIT FOREACH
	         END IF
		 LET g_bmb01[g_cnt] = sr.bmb01
		 LET g_bmb29[g_cnt] = sr.bmb29 #FUN-550095 add29 #FUN-550095 add
	      END IF
	   END IF
       #NO.FUN-850057----BEGIN----
       EXECUTE insert_prep1 USING sr.bmb01,sr.bmb29,sr.ima02
       FOR g_i = 1 TO g_cnt
          IF g_bmb01[g_i] = sr.bmb01 AND g_bmb29[g_i] = sr.bmb29 THEN
             LET l_bmb01[g_i] = g_i 
             EXIT FOR
	  END IF
       END FOR
       
       IF l_bmb03_t<>sr.bmb03 OR cl_null(l_bmb03_t) THEN
          FOR g_i = 1 TO 37
     	     IF l_bmb01[g_i] != 0 AND NOT cl_null(l_bmb01[g_i]) THEN
	        LET l_temp[g_i] = g_i 
	     END IF
	  END FOR
          EXECUTE insert_prep USING sr.bmb01,sr.bmb29,sr.bmb03,sr.ima02,l_temp[1],                                             
                                      l_temp[2],l_temp[3],l_temp[4],l_temp[5],                                                   
                                      l_temp[6],l_temp[7],l_temp[8],l_temp[9],                                                   
                                      l_temp[10],l_temp[11],l_temp[12],l_temp[13],                                               
                                      l_temp[14],l_temp[15],l_temp[16],l_temp[17],                                               
                                      l_temp[18],l_temp[19],l_temp[20],l_temp[21],                                               
                                      l_temp[22],l_temp[23],l_temp[24],l_temp[25],                                               
                                      l_temp[26],l_temp[27],l_temp[28],l_temp[29],                                               
                                      l_temp[30],l_temp[31],l_temp[32],l_temp[33],                                               
                                      l_temp[34],l_temp[35],l_temp[36],l_temp[37],'0'
          LET l_bmb03_t = sr.bmb03
          FOR g_i = 1 TO 37 LET l_temp[g_i] = 0 END FOR
          FOR g_i = 1 TO 37 LET l_bmb01[g_i] = 0 END FOR
       END IF
       #OUTPUT TO REPORT abmr612_rep(sr.*)
       #NO.FUN-850057----END----
       
     END FOREACH
 
    #DISPLAY "" AT 2,1
    #NO.FUN-850057----BEGIN----
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
    IF g_zz05='Y' THEN
       CALL cl_wcchp(tm.wc,'bmb03,ima06,ima09,ima10,ima11,ima12')
           RETURNING tm.wc
    ELSE
       LET tm.wc=""
    END IF
    LET g_str = tm.wc,";",g_towhom,";",tm.revision,";",tm.effective,";",tm.c
    CALL cl_prt_cs3('abmr612','abmr612',g_sql,g_str)
    # FINISH REPORT abmr612_rep
    # IF g_sw THEN
    #   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    # END IF
    #NO.FUN-850057----END-----
END FUNCTION
#NO.FUN-870144
REPORT abmr612_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
	  l_flag        LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
	  l_sql         LIKE type_file.chr1000,       #No.FUN-680096 VARCHAR(1000)
	  l_bmb01       ARRAY[37] OF LIKE bmb_file.bmb01,  #No.FUN-680096 SMALLINT
	 #l_buf         ARRAY[37] OF VARCHAR(56),        #FUN-550095
	  l_buf         ARRAY[37] OF LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(200)
	  l_ima02       LIKE ima_file.ima02,
          sr  RECORD
              bmb01 LIKE bmb_file.bmb01,    #主件料件
              bmb29 LIKE bmb_file.bmb29,    #FUN-550095
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02     #品名規格
          END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.bmb03,sr.bmb01,sr.bmb29 #FUN-550095 add sr.bmb29
  FORMAT
  FIRST PAGE HEADER
         #公司名稱
         PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
         IF g_towhom IS NULL OR g_towhom = ' '
            THEN PRINT '';
            ELSE PRINT 'TO:',g_towhom;
         END IF
         #報表名稱
         PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
         PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
         #有效日期
         LET g_pageno = g_pageno + 1
         PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#No.TQC-6B0096 --begin
#              COLUMN (g_len-FGL_WIDTH(g_x[21])-6)/2,
#              g_x[21] CLIPPED,tm.effective,
               COLUMN (g_len-17)/2,
               g_x[16] CLIPPED,tm.effective,
#No.TQC-6B0096 --end
               COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
         PRINT g_dash[1,g_len]
             #No.TQC-5A0030  --begin
	     PRINT COLUMN  2,g_x[11] CLIPPED,                                                                 #FUN-550095
                   COLUMN 69,g_x[19] CLIPPED
	    #PRINT COLUMN 20,"---- -------------------- ----------------", "--------------"                      #FUN-550095
	     PRINT COLUMN 2,'---- -----------------------------------------',
                            '-------------------- ',
                            '----------------------------------------------',
                            '--------------' #FUN-550095
             #No.TQC-5A0030  --end
	
	     LET l_sql = " SELECT ima02 FROM ima_file WHERE ima01 = ?"
	     PREPARE r612_p2 FROM l_sql
	     IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) END IF
	     DECLARE r612_c2 CURSOR FOR r612_p2
	     FOR g_i = 1 TO g_cnt
		     OPEN r612_c2 USING g_bmb01[g_i]
		     FETCH r612_c2 INTO l_ima02
		     IF SQLCA.sqlcode!= 0 AND SQLCA.sqlcode != 100 THEN
			    CALL cl_err('fetch:',SQLCA.sqlcode,0)
			 END IF
			 IF SQLCA.sqlcode = 100 THEN LET l_ima02 = ' ' END IF
		    #LET l_buf[g_i] = g_i USING'####',
		    #		  ' ',g_bmb01[g_i],' ',l_ima02
                     LET l_buf[g_i][ 1, 4] = g_i USING '####'
                     LET l_buf[g_i][ 5, 5] = ' '
                   #FUN-550095
                   # LET l_buf[g_i][ 6,25] = g_bmb01[g_i]
                   # LET l_buf[g_i][26,26] = ' '
                   # LET l_buf[g_i][27,56] = l_ima02
                     #No.TQC-5A0030  --begin
                     LET l_buf[g_i][ 6,66] = g_bmb01[g_i] CLIPPED,' ',g_bmb29[g_i] CLIPPED
                     LET l_buf[g_i][67,67] = ' '
                     LET l_buf[g_i][68,127] = l_ima02
                     #No.TQC-5A0030  --end
                   #FUN-550095(end)
	     END FOR
                 #FUN-550095 COLUMN 20,改成COLUMN 2
                 #MOD-640141 
		 PRINT COLUMN 2,l_buf[1] CLIPPED PRINT COLUMN 2,l_buf[2] CLIPPED 
		 PRINT COLUMN 2,l_buf[3] CLIPPED PRINT COLUMN 2,l_buf[4] CLIPPED 
		 PRINT COLUMN 2,l_buf[5] CLIPPED PRINT COLUMN 2,l_buf[6] CLIPPED 
		 PRINT COLUMN 2,l_buf[7] CLIPPED PRINT COLUMN 2,l_buf[8] CLIPPED 
		 PRINT COLUMN 2,l_buf[9] CLIPPED PRINT COLUMN 2,l_buf[10] CLIPPED
		 PRINT COLUMN 2,l_buf[11]CLIPPED PRINT COLUMN 2,l_buf[12] CLIPPED
		 PRINT COLUMN 2,l_buf[13]CLIPPED PRINT COLUMN 2,l_buf[14] CLIPPED
		 PRINT COLUMN 2,l_buf[15]CLIPPED PRINT COLUMN 2,l_buf[16] CLIPPED
		 PRINT COLUMN 2,l_buf[17]CLIPPED PRINT COLUMN 2,l_buf[18] CLIPPED
		 PRINT COLUMN 2,l_buf[19]CLIPPED PRINT COLUMN 2,l_buf[20] CLIPPED
		 PRINT COLUMN 2,l_buf[21]CLIPPED PRINT COLUMN 2,l_buf[22] CLIPPED
		 PRINT COLUMN 2,l_buf[23]CLIPPED PRINT COLUMN 2,l_buf[24] CLIPPED
		 PRINT COLUMN 2,l_buf[25]CLIPPED PRINT COLUMN 2,l_buf[26] CLIPPED
		 PRINT COLUMN 2,l_buf[27]CLIPPED PRINT COLUMN 2,l_buf[28] CLIPPED
		 PRINT COLUMN 2,l_buf[29]CLIPPED PRINT COLUMN 2,l_buf[30] CLIPPED
		 PRINT COLUMN 2,l_buf[31]CLIPPED PRINT COLUMN 2,l_buf[32] CLIPPED
		 PRINT COLUMN 2,l_buf[33]CLIPPED PRINT COLUMN 2,l_buf[34] CLIPPED
		 PRINT COLUMN 2,l_buf[35]CLIPPED PRINT COLUMN 2,l_buf[36] CLIPPED
		 PRINT COLUMN 2,l_buf[37]CLIPPED 
                 #END MOD-640141 
                 #FUN-550095(end)
		 LET l_last_sw = 'n'
		 LET l_flag = 'y'
 
   PAGE HEADER
      #公司名稱
      PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      #報表名稱
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      #有效日期
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
            COLUMN (g_len-FGL_WIDTH(g_x[21])-6)/2,
            g_x[21] CLIPPED,tm.effective,
            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
      PRINT g_dash[1,g_len]
      #No.TQC-5A0030  --begin
      PRINT COLUMN 01,g_x[12] CLIPPED,
            COLUMN 42,g_x[18] CLIPPED,
            COLUMN 85,g_x[17] CLIPPED,'  ',g_x[13] CLIPPED,g_x[14] CLIPPED,
            ' ',g_x[15] CLIPPED
      PRINT '-----------------------------------------',
            '-----------------------------------------',
            '-----------------------------------------------------------',
            '----------------------------------------------------'
      #No.TQC-5A0030  --end
 
   ON EVERY ROW
	  FOR g_i = 1 TO g_cnt
		 #IF g_bmb01[g_i] = sr.bmb01 THEN
	          IF g_bmb01[g_i] = sr.bmb01 AND g_bmb29[g_i] = sr.bmb29 THEN  #FUN-550095 add
	              LET l_bmb01[g_i] = g_i
		      EXIT FOR
		  END IF
	  END FOR
 
   AFTER GROUP OF sr.bmb03
	  IF l_flag = 'y' THEN SKIP TO TOP OF PAGE LET l_flag = 'n' END IF
	  PRINT sr.bmb03;
	  FOR g_i = 1 TO 37
		  IF l_bmb01[g_i] != 0 THEN
                         #No.TQC-5A0030  --begin
			 #PRINT COLUMN (g_i-1)*3+22,g_i USING'###';
			 PRINT COLUMN (g_i-1)*3+83,g_i USING'###';
                         #No.TQC-5A0030  --end
		  END IF
	  END FOR
	  PRINT
	  FOR g_i = 1 TO 37 LET l_bmb01[g_i] = 0 END FOR
 
   ON LAST ROW
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
#Patch....NO.TQC-610035 <001> #
