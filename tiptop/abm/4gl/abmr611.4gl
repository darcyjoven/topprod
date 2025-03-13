# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: abmr611.4gl
# Descriptions...: 多階材料用途清單
# Input parameter: 
# Return code....: 
# Date & Author..: 91/08/05 By Lee
#      Modify    : 92/05/27 By David 
# Modify.........: 93/09/17 By Apple
# Modify.........: 94/08/17 By Danny 改由bmt_file取插件位置
# Modify.........: No.FUN-510033 05/02/15 By Mandy 報表轉XML
# Modify.........: No.MOD-530217 05/03/23 By kim 列印結果,每頁下面都為 "(結束)"
# Modify.........: No.FUN-550095 05/05/30 By Mandy 特性BOM
# Modify.........: No.FUN-570240 05/07/26 By jackie 料件編號欄位加開窗查詢
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-7A0013 07/10/11 By mike 報表格式修改為Crystal Reports
# Modify.........: No.CHI-810006 08/01/21 By zhoufeng 調整插件位置及說明的列印 
# Modify.........: No.MOD-880089 08/08/13 By claire 報表連續二次列印資料排序不同
# Modify.........: No.TQC-8C0063 09/01/12 By jan 加入特性BOM,下階料展BOM時，特性代碼抓ima910
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A40116 10/04/26 By liuxqa modify sql
# Modify.........: No.FUN-A40058 10/04/27 By lilingyu bmb16增加規格替代的內容
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 12/01/06 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			    	# Print condition RECORD
        		wc  	  LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(500)
   	        	effective LIKE type_file.dat,      #No.FUN-680096 DATE
           		arrange   LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
           		engine    LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
           		more	  LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
              END RECORD,
          g_bmb03_a       LIKE bmb_file.bmb03
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680096 SMALLINT
DEFINE   l_table1        STRING                  #TQC-7A0013 
DEFINE   l_table2        STRING                  #TQC-7A0013
DEFINE   l_table3        STRING                  #TQC-7A0013
 
DEFINE   g_sql           STRING                  #TQC-7A0013
DEFINE   g_str           STRING                  #TQC-7A0013
DEFINE   g_cntt          LIKE type_file.num5     #MOD-880089  add
 
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
 
   #TQC-7A0013  -STR
   LET g_sql = "bmb15.bmb_file.bmb15,",
               "bmb16.bmb_file.bmb16,",
               "bmb03.bmb_file.bmb03,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima05.ima_file.ima05,",
               "ima08.ima_file.ima08,",
               "ima37.ima_file.ima37,",
               "ima63.ima_file.ima63,",
               "ima55.ima_file.ima55,",
               "bmb02.bmb_file.bmb02,",
               "bmb06.bmb_file.bmb06,",
               "bmb08.bmb_file.bmb08,",
               "bmb10.bmb_file.bmb10,",
               "bmb23.bmb_file.bmb23,",
               "bmb18.bmb_file.bmb18,",
               "bmb09.bmb_file.bmb09,",
               "bmb04.bmb_file.bmb04,",
               "bmb05.bmb_file.bmb05,",
               "bmb14.bmb_file.bmb14,",
               "bmb17.bmb_file.bmb17,",
               "bmb11.bmb_file.bmb11,",
               "bmb13.bmb_file.bmb13,",
               "bmb01.bmb_file.bmb01,",
               "bmb29.bmb_file.bmb29,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "l_ima05.ima_file.ima05,",
               "l_ima06.ima_file.ima06,",
               "l_ima08.ima_file.ima08,",
               "l_ima15.ima_file.ima15,",
               "l_ima37.ima_file.ima37,",
               "l_ima63.ima_file.ima63,",
               "l_ima55.ima_file.ima55,",
               "l_imz02.imz_file.imz02,",
               "l_ver.ima_file.ima05,",
               "l_point.cre_file.cre08,",
               "l_print32.type_file.chr1000,",
               "g_bmb03_a.bmb_file.bmb03,",
               "p_level.type_file.num5,",
               "p_i.type_file.num5,",
               "p_total.csa_file.csa0301,",
               "l_total.csa_file.csa0301"
              ,",i.type_file.num5,"          #MOD-880089 add
 
   LET l_table1 = cl_prt_temptable('abmr6111',g_sql)  CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
    
   LET g_sql = "bmt01.bmt_file.bmt01,",
               "bmt02.bmt_file.bmt02,",
               "bmt03.bmt_file.bmt03,",
               "bmt04.bmt_file.bmt04,",
               "bmt08.bmt_file.bmt08,",
               "bmt05.bmt_file.bmt05,",
#               "bmt06.bmt_file.bmt06"              #No.CHI-810006
               "bmt06.type_file.chr1000"            #No.CHI-810006              
 
   LET l_table2 = cl_prt_temptable('abmr6112',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "bmc01.bmc_file.bmc01,",
               "bmc02.bmc_file.bmc02,",
               "bmc021.bmc_file.bmc021,",
               "bmc03.bmc_file.bmc03,",
               "bmc06.bmc_file.bmc06,",
               "bmc04.bmc_file.bmc04,",
#               "bmc05.bmc_file.bmc05"              #No.CHI-810006
               "bmc05.type_file.chr1000"            #No.CHI-810006              
 
   LET l_table3 = cl_prt_temptable('abmr6113',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   #TQC-7A0013  -END
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
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r611_tm(0,0)			# Input print condition
      ELSE CALL abmr611()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r611_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_flag        LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_one         LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_bdate       LIKE bmx_file.bmx07, 
          l_edate       LIKE bmx_file.bmx08,
          l_bmb03       LIKE bmb_file.bmb03,
          l_cmd		LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 9 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 9
   END IF
 
   OPEN WINDOW r611_w AT p_row,p_col
        WITH FORM "abm/42f/abmr611" 
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
 
#No.FUN-570240  --start-                                                                                                            
      ON ACTION controlp                                                                                                            
            IF INFIELD(bmb03) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                        
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO bmb03                                                                             
               NEXT FIELD bmb03                                                                                                     
            END IF                                                                                      
#No.FUN-570240 --end--  
END CONSTRUCT
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r611_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   LET l_one='N'
   IF tm.wc != ' 1=1' THEN
       LET l_cmd="SELECT COUNT(DISTINCT bmb03),bmb03 ",
                 " FROM bmb_file,ima_file", 
                 " WHERE bmb03=ima01 AND ima08!='A' ",
                 " AND ",tm.wc CLIPPED," GROUP BY bmb03"
       PREPARE r611_cnt_p FROM l_cmd
       DECLARE r611_cnt CURSOR FOR r611_cnt_p
       IF SQLCA.sqlcode THEN 
          CALL cl_err('P0:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
          EXIT PROGRAM 
             
       END IF
       MESSAGE " SEARCHING ! " 
       CALL ui.Interface.refresh()
       OPEN r611_cnt
       FETCH r611_cnt INTO g_cnt,l_bmb03
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
   INPUT BY NAME tm.effective,tm.arrange,tm.engine,tm.more 
             WITHOUT DEFAULTS 
 
      AFTER FIELD arrange
         IF tm.arrange NOT MATCHES '[12]' THEN
             NEXT FIELD arrange
         END IF
      AFTER FIELD engine
         IF tm.engine NOT MATCHES '[YN]' THEN
             NEXT FIELD engine
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
      ON ACTION CONTROLP CALL r611_wc()   # Input detail Where Condition
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
      LET INT_FLAG = 0 CLOSE WINDOW r611_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr611'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr611','9031',1)
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
                         " '",tm.engine CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('abmr611',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r611_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr611()
   ERROR ""
END WHILE
   CLOSE WINDOW r611_w
END FUNCTION
 
FUNCTION r611_wc()
   DEFINE l_wc  LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW r611_w2 AT 2,2
        WITH FORM "abm/42f/abmi600" 
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi600")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT l_wc ON                               # 螢幕上取條件
        bmb02,bmb03,bmb04,bmb05,bmb06,bmb07,bmb08,bmb10
        FROM
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
   CLOSE WINDOW r611_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc CLIPPED
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# abmr611()      從單頭讀取合乎條件的元件資料
# r611_bom()  處理主件及其相關的展開資料
#-----------------------------------------------------------------
FUNCTION abmr611()
   DEFINE l_name	LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000,# RDSQL STATEMENT     #No.FUN-680096 VARCHAR(1000)
          l_cmd 	LIKE type_file.chr1000,# RDSQL STATEMENT     #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(40)
          l_bmb03       LIKE bmb_file.bmb03,    #主件料件
          l_bmb29       LIKE bmb_file.bmb29     #特性代碼 #TQC-8C0063
 
     #TQC-7A0013 -STR
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     LET g_cntt = 1              #MOD-880089 add       
   
     #LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,  #TQC-A40116 mod
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                 "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #MOD-880089 add ?
     
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     #LET g_sql = "INSERT INTO ds_report.",l_table2 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,  #TQC-A40116 mod
                 " VALUES(?,?,?,?,?,?,?)"
     
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM
     END IF
 
     #LET g_sql = "INSERT INTO ds_report.",l_table3 CLIPPED,
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,  #TQC-A40116 mod
                 " VALUES(?,?,?,?,?,?,?)"
     
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM 
     END IF
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     #No.TQC-7A0013
                      
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
     LET l_sql = "SELECT UNIQUE bmb03,bmb29",  #TQC-8C0063 add bmb29
                 " FROM bmb_file, ima_file",
                 " WHERE ima01 = bmb03",
                 " AND ima08!='A' AND ",tm.wc
     PREPARE r611_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
		 CALL cl_err('prepare:',SQLCA.sqlcode,1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   EXIT PROGRAM 
   END IF
     DECLARE r611_curs1 CURSOR FOR r611_prepare1
 
     #CALL cl_outnam('abmr611') RETURNING l_name   #TQC-7A0013
     #START REPORT r611_rep TO l_name              #TQC-7A0013
     CALL r611_cur()
 #    LET g_pageno = 0  #MOD-530217
     FOREACH r611_curs1 INTO l_bmb03,l_bmb29    #TQC-8C0063
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       LET g_bmb03_a=l_bmb03
       CALL r611_bom(0,l_bmb03,l_bmb29,1)   #TQC-8C0063
     END FOREACH
    
    #DISPLAY "" AT 2,1
    #TQC-7A0013 -STR
  
    #FINISH REPORT r611_rep        
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
 
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'bmb03,ima06,ima09,ima10,ima11,ima12')
        RETURNING  tm.wc
     END IF
     LET g_str = tm.wc,';',tm.effective,';',g_sma.sma888[1,1]
     CALL cl_prt_cs3('abmr611','abmr611',g_sql,g_str)
     #No.TQC-7A0013 -END 
END FUNCTION
   
FUNCTION r611_cur()
  DEFINE l_cmd    LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(1000)
 
     #-->產品結構插件位置
     LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                  " WHERE bmt01=?  AND bmt02= ? AND ",
                  " bmt03=? AND ",
                  " (bmt04 IS NULL OR bmt04 >= ?) ",
                  "  AND bmt08 = ? ", #FUN-550095 add
                  " ORDER BY bmt05"   #MOD-880089
                 #" ORDER BY 1"       #MOD-880089 mark
     PREPARE r611_prebmt     FROM l_cmd
     IF SQLCA.sqlcode THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
           
     END IF
     DECLARE r611_bmt  CURSOR WITH HOLD FOR r611_prebmt 
 
     #-->產品結構說明資料
     LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                  " WHERE bmc01=?  AND bmc02= ? AND ",
                  " bmc021=? AND ",
                  " (bmc03 IS NULL OR bmc03 >= ?) ",
                  "  AND bmc06 = ? ", #FUN-550095 add
                  " ORDER BY bmc04"   #MOD-880089
                 #" ORDER BY 1"       #MOD-880089 mark
     PREPARE r611_prebmc    FROM l_cmd
     IF SQLCA.sqlcode THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM 
           
     END IF
     DECLARE r611_bmc CURSOR WITH HOLD FOR r611_prebmc
END FUNCTION
   
FUNCTION r611_bom(p_level,p_key,p_key2,p_total) #TQC-8C0063 add p_key2
   DEFINE p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_total       LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          l_total       LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          p_key		LIKE bma_file.bma01,    #主件料件編號
          p_key2        LIKE bma_file.bma06,    #TQC-8C0063
          l_ac,i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          arrno		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          b_seq		LIKE bmb_file.bmb02,    #滿時,重新讀單身之起始序號
          l_chr		LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_ima06       LIKE ima_file.ima06,    #分群碼
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,  #FUN-510033
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima37 LIKE ima_file.ima37,    #補貨
              ima63 LIKE ima_file.ima63,    #發料單位
              ima55 LIKE ima_file.ima55,    #生產單位
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb23 LIKE bmb_file.bmb23,    #選中率  
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb11 LIKE bmb_file.bmb11,    #工程圖號
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb01 LIKE bmb_file.bmb01,
              bmb29 LIKE bmb_file.bmb29     #FUN-550095 add
          END RECORD,
          l_cmd     LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
#No.TQC-7A0013 -STR
DEFINE    l_ima02 LIKE ima_file.ima02,    #品名規格                                                                                 
          l_ima021 LIKE ima_file.ima021,  #FUN-510033                                                                               
          l_ima05 LIKE ima_file.ima05,    #版本                                                                                     
          l_ima08 LIKE ima_file.ima08,    #來源                                                                                     
          l_ima15 LIKE ima_file.ima15,    #保稅否                                                                                   
          l_ima37 LIKE ima_file.ima37,    #補貨                                                                                     
          l_ima63 LIKE ima_file.ima63,    #發料單位                                                                                 
          l_ima55 LIKE ima_file.ima55,    #生產單位                                                                                 
          l_imz02 LIKE imz_file.imz02,    #說明內容                                                                                 
          l_ver   LIKE ima_file.ima05,                                                                                              
          l_use_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)                                                              
          l_ute_flag    LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(2)           #FUN-A40058 chr2->chr3                                                   
          l_point       LIKE cre_file.cre08,    #No.FUN-680096 VARCHAR(10)                                                             
          l_p           LIKE type_file.num5,    #No.FUN-680096 SMALLINT                                                             
          l_bmt05      LIKE bmt_file.bmt05,                                                                                         
          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06,  #No.FUN-680096 VARCHAR(20)                                                       
          l_bmc05 ARRAY[200] OF LIKE bmc_file.bmc05,  #No.FUN-680096 VARCHAR(10)                                                       
          l_bmc04      LIKE bmc_file.bmc04,                                                                                         
          l_byte,l_len   LIKE type_file.num5,   #No.FUN-680096 SMALLINT        
          l_bmt06_s      LIKE bmt_file.bmt06,   #No.FUN-680096 VARCHAR(20)                                                             
          l_bmtstr       LIKE bmt_file.bmt06,   #No.FUN-680096 VARCHAR(20)                                                             
          l_dash       LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)                                                              
          l_now,l_now2 LIKE type_file.num5,     #No.FUN-680096 SMALLINT                                                             
          l_print32    LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(100)  
#TQC-7A0013 -END
DEFINE    l_bmc051 ARRAY[200]  OF VARCHAR(30)      #No.CHI-810006  
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.TQC-8C0063 
	IF p_level > 20 THEN
		CALL cl_err('','mfg2733',1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
   EXIT PROGRAM
   
    END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
 #       LET g_pageno = 0  #MOD-530217
        LET sr[1].bmb03 = p_key
        #TQC-7A0013 -STR
        #OUTPUT TO REPORT r611_rep(1,0,1,sr[1].*)	#第0階主件資料  #TQC-7A0013	
        CALL s_effver(sr[1].bmb01,tm.effective) RETURNING l_ver 
        SELECT ima02,ima021,ima05,ima06,ima08,ima15,                                                                                  
             ima37,ima63,ima55,imz02                                                                                                
        INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima15,                                                                      
             l_ima37,l_ima63,l_ima55,l_imz02                                                                                        
        FROM ima_file,OUTER imz_file                                                                                                
       WHERE ima01=g_bmb03_a AND ima_file.ima06 = imz_file.imz01                                                                                      
          IF SQLCA.sqlcode THEN                                                                                                     
              LET l_ima02='' LET l_ima05=''                                                                                         
              LET l_ima021=''                                                                                                       
              LET l_ima06='' LET l_ima08=''                                                                                         
              LET l_ima37='' LET l_ima63=''                                                                                         
              LET l_ima55='' LET l_imz02=''                                                                                         
          END IF 
          LET l_point = ' '                                                                                                         
          IF p_level > 1 THEN                                                                                                       
             FOR l_p = 1 TO p_level - 1                                                                                             
                 LET l_point = l_point clipped,'.'                                                                                  
             END FOR                                                                                                                
          END IF 
          LET l_print32 = l_point CLIPPED,sr[1].bmb01 CLIPPED,' ',sr[1].bmb29 CLIPPED                      
          EXECUTE insert_prep USING sr[1].*,l_ima02,l_ima021,l_ima05,l_ima06,
                  l_ima08,l_ima15,l_ima37,l_ima63,l_ima55,l_imz02,l_ver,
                  l_point,l_print32,g_bmb03_a,'1','0','1','',g_cntt  #MOD-880089 add g_cntt
          #TQC-7A0013 -END
          LET g_cntt = g_cntt + 1  #MOD-880089 add
    END IF
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=
            "SELECT bmb15,bmb16,bmb03,ima02,ima021,ima05,ima08,",  #FUN-510033 add ima021
            "ima37,ima63,ima55,bmb02,bmb06/bmb07,bmb08,bmb10,",
            "bmb23,bmb18,bmb09,bmb04,bmb05,bmb14,",
            "bmb17,bmb11,bmb13,bmb01,bmb29 ", #FUN-550095 add bmb29
            " FROM bmb_file, ima_file",
            " WHERE bmb03='", p_key,"' AND bmb02 > ",b_seq,
            "   AND bmb29='", p_key2,"'", #TQC-8C0063
            " AND bmb01 = ima01"
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
        PREPARE r611_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN 
           CALL cl_err('P1:',SQLCA.sqlcode,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
           EXIT PROGRAM 
              
        END IF
        DECLARE r611_cur CURSOR for r611_ppp
 
        LET l_ac = 1
        FOREACH r611_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
           #TQC-8C0063--BEGIN--
           LET l_ima910[l_ac]=''
           SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03 
           IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
           #TQC-8C0063--END-- 
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            LET l_total=p_total*sr[i].bmb06
            #No.TQC-7A0013 -STR
            CALL s_effver(sr[i].bmb01,tm.effective) RETURNING l_ver
            SELECT ima02,ima021,ima05,ima06,ima08,ima15,                                                                                  
                   ima37,ima63,ima55,imz02                                                                                                
              INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima15,                                                                      
                   l_ima37,l_ima63,l_ima55,l_imz02                                                                                        
            FROM ima_file,OUTER imz_file                                                                                                
            WHERE ima01=g_bmb03_a AND ima_file.ima06 = imz_file.imz01                                                                                      
            IF SQLCA.sqlcode THEN                                                                                                     
              LET l_ima02='' LET l_ima05=''                                                                                         
              LET l_ima021=''                                                                                                       
              LET l_ima06='' LET l_ima08=''                                                                                         
              LET l_ima37='' LET l_ima63=''                                                                                         
              LET l_ima55='' LET l_imz02=''                                                                                         
            END IF                  
#            LET l_now2=1                     #No.CHI-810006                                                               
#            LET l_len =20                    #No.CHI-810006                                                                                        
#            LET l_bmtstr = ''                #No.CHI-810006
            #---->使用特性(O/R)                                                                                                     
            IF sr[i].bmb14 ='1'                                                                                                        
               THEN LET sr[i].bmb14='O'                                                                                                
            ELSE LET sr[i].bmb14 =''                                                                                                   
            END IF                                                                                                                  
            #---->消耗特性                                                                                                          
            IF sr[i].bmb15 = 'Y' THEN                                                                                                  
               LET sr[i].bmb15 = '*'                                                                                                   
            ELSE LET sr[i].bmb15 =' '                                                                                                  
            END IF                                                                                                                  
            #---->改變替代特性的表示方式                                                                                            
            IF sr[i].bmb16 MATCHES '[127]' THEN          #FUN-A40058 add '7'                                                                                
               LET l_ute_flag='USZ'                      #FUN-A40058 add 'Z'                                                                                                  
               LET g_cnt=sr[i].bmb16 USING '&'                                                                                         
               LET sr[i].bmb16=l_ute_flag[g_cnt,g_cnt]                                                                                 
            ELSE       
               LET sr[i].bmb16=' '                                                                                                      
            END IF                                                                                                                    
            #---->特性旗標                                                                                                            
            IF sr[i].bmb17='Y' THEN                                                                                                      
               LET sr[i].bmb17='F'                                                                                                      
            ELSE                                                                                                                      
               LET sr[i].bmb17=' '                                                                                                      
            END IF                                                                                                                    
                                                                                                                                    
            IF p_level> 10 THEN LET p_level=10 END IF                                                                                 
            LET l_point = ' '                                                                                                         
            IF p_level > 1 THEN                                                                                                       
               FOR l_p = 1 TO p_level - 1                                                                                             
                  LET l_point = l_point clipped,'.'                                                                                  
               END FOR                                                                                                                
            END IF
            LET l_print32 = l_point CLIPPED,sr[i].bmb01 CLIPPED,' ',sr[i].bmb29 CLIPPED
            EXECUTE insert_prep USING sr[i].*,l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,
                    l_ima15,l_ima37,l_ima63,l_ima55,l_imz02,l_ver,l_point,l_print32,
                    g_bmb03_a,p_level,i,l_total,l_total,g_cntt   #MOD-880089 add g_cntt 
            LET g_cntt = g_cntt + 1  #MOD-880089 add
            #No.CHI-810006 --add--                                              
            #子報表--插件                                                       
            FOR g_cnt=1 TO 200                                                  
                LET l_bmt06[g_cnt]=NULL                                         
            END FOR                                                             
            LET l_now2=1                                                        
            LET l_len =20                                                       
            LET l_bmtstr = ''                                                   
            #No.CHI-810006 --end--
            FOREACH r611_bmt                                                                                                           
            USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,sr[i].bmb29    #FUN-550095 add bmb29                                                   
            INTO l_bmt05,l_bmt06_s                                                                                                     
               IF SQLCA.sqlcode THEN                                                                                                   
                  CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                                 
               END IF                                                                                                                  
               IF l_now2 > 200 THEN                                                                                                    
                  CALL cl_err('','9036',1)                                                                                             
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107                                                        
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
#               EXECUTE insert_prep1 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,#No.CHI-810006
#                       sr[i].bmb29,l_bmt05,l_bmt06_s                                      #No.CHI-810006                                              
            END FOREACH                                                                                                                
            IF l_now2 > 0 THEN LET l_bmt06[l_now2] = l_bmtstr END IF                                                                   
            #No.CHI-810006 --add--                                              
            FOR g_cnt = 1 TO l_now2                                             
                IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '               
                   THEN                                                         
                       EXIT FOR                                                 
                END IF                                                          
                EXECUTE insert_prep1 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,
                                           sr[i].bmb29,l_bmt05,l_bmt06[g_cnt]   
            END FOR                                                             
            #No.CHI-810006 --end--                                              
 
            #-->處理說明的部份        
            #No.CHI-810006 --add--                                              
            FOR g_cnt=1 TO 200                                                  
                LET l_bmc05[g_cnt]=NULL                                         
            END FOR                                                             
            #No.CHI-810006 --end--          
            LET l_now=1                                                                                                               
            FOREACH r611_bmc                                                                                                          
            USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,sr[i].bmb29   #FUN-550095 add bmb29                                                  
            INTO l_bmc04,l_bmc05[l_now]                                                                                               
               IF SQLCA.sqlcode THEN                                                                                                 
                  CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH                                                               
               END IF                                                                                                                
               IF l_now > 200 THEN                                                                                                   
                  CALL cl_err('','9036',1)       
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107                                                     
                  EXIT PROGRAM                                                                                                      
               END IF                                                                                                                
#               EXECUTE insert_prep2 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,#No.CHI-810006
#                       sr[i].bmb29,l_bmc04,l_bmc05[l_now]                                 #No.CHI-810006                                   
               LET  l_now=l_now+1                    
            END FOREACH                                                                                                               
            LET l_now=l_now-1                                                                                                         
            #No.CHI-810006 --add--                                              
            IF l_now >= 1 THEN                                                  
                FOR g_cnt = 1 TO l_now STEP 2                                   
                    LET l_bmc051[g_cnt] = l_bmc05[g_cnt],' ',l_bmc05[g_cnt+1]   
                    EXECUTE insert_prep2 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,
                                               sr[i].bmb29,l_bmc04,l_bmc051[g_cnt]
                END FOR                                                         
             END IF                                                             
             #NO.CHI-810006 --end-- 
            #OUTPUT TO REPORT r611_rep(p_level,i,l_total,sr[i].*) 
            #TQC-7A0013 -end
           #CALL r611_bom(p_level,sr[i].bmb01,p_total*sr[i].bmb06)             #TQC-8C0063
            CALL r611_bom(p_level,sr[i].bmb01,l_ima910[i],p_total*sr[i].bmb06) #TQC-8C0063
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN         # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
END FUNCTION
 
#TQC-7A0013 -str
{
REPORT r611_rep(p_level,p_i,p_total,sr)
   DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          p_level,p_i	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          p_total       LIKE csa_file.csa0301,  #No.FUN-680096 DEC(13,5)
          sr  RECORD
              bmb15 LIKE bmb_file.bmb15,    #元件耗用特性
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima021,  #FUN-510033
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima37 LIKE ima_file.ima37,    #補貨
              ima63 LIKE ima_file.ima63,    #發料單位
              ima55 LIKE ima_file.ima55,    #生產單位
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb23 LIKE bmb_file.bmb23,    #選中率  
              bmb18 LIKE bmb_file.bmb18,    #投料時距
              bmb09 LIKE bmb_file.bmb09,    #製程序號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb14 LIKE bmb_file.bmb14,    #元件使用特性
              bmb17 LIKE bmb_file.bmb17,    #Feature
              bmb11 LIKE bmb_file.bmb11,    #工程圖號
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb01 LIKE bmb_file.bmb01,
              bmb29 LIKE bmb_file.bmb29     #FUN-550095 add
          END RECORD,
          l_ima02 LIKE ima_file.ima02,    #品名規格
          l_ima021 LIKE ima_file.ima021,  #FUN-510033
          l_ima05 LIKE ima_file.ima05,    #版本
          l_ima06 LIKE ima_file.ima06,    #版本
          l_ima08 LIKE ima_file.ima08,    #來源
          l_ima15 LIKE ima_file.ima15,    #保稅否
          l_ima37 LIKE ima_file.ima37,    #補貨
          l_ima63 LIKE ima_file.ima63,    #發料單位
          l_ima55 LIKE ima_file.ima55,    #生產單位
          l_imz02 LIKE imz_file.imz02,    #說明內容
          l_ver   LIKE ima_file.ima05,
          l_use_flag    LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
          l_ute_flag    LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(2)  #FUN-A40058 chr2->chr3 
          l_point       LIKE cre_file.cre08,    #No.FUN-680096 VARCHAR(10)
          l_p           LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_bmt05      LIKE bmt_file.bmt05,    
          l_bmt06 ARRAY[200] OF LIKE bmt_file.bmt06,  #No.FUN-680096 VARCHAR(20)
          l_bmc05 ARRAY[200] OF LIKE bmc_file.bmc05,  #No.FUN-680096 VARCHAR(10)
          l_bmc04      LIKE bmc_file.bmc04,
          l_byte,l_len   LIKE type_file.num5,   #No.FUN-680096 SMALLINT     
          l_bmt06_s      LIKE bmt_file.bmt06,   #No.FUN-680096 VARCHAR(20)
          l_bmtstr       LIKE bmt_file.bmt06,   #No.FUN-680096 VARCHAR(20)
          l_dash       LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
          l_now,l_now2 LIKE type_file.num5,     #No.FUN-680096 SMALLINT
          l_print32    LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(100)
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      SELECT ima02,ima021,ima05,ima06,ima08,ima15,
             ima37,ima63,ima55,imz02
        INTO l_ima02,l_ima021,l_ima05,l_ima06,l_ima08,l_ima15,
             l_ima37,l_ima63,l_ima55,l_imz02
        FROM ima_file,OUTER imz_file
       WHERE ima01=g_bmb03_a AND ima_file.ima06 = imz_file.imz01
          IF SQLCA.sqlcode THEN
              LET l_ima02='' LET l_ima05=''
              LET l_ima021=''
              LET l_ima06='' LET l_ima08=''
              LET l_ima37='' LET l_ima63=''
              LET l_ima55='' LET l_imz02=''
          END IF
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total     
      PRINT g_x[19] CLIPPED,tm.effective
      PRINT g_dash
      #----
      PRINT g_x[11] CLIPPED, l_ima06,' ',l_imz02
      PRINT COLUMN   1,g_x[12] CLIPPED, g_bmb03_a,' ',l_ima02 CLIPPED,' ',l_ima021
      PRINT COLUMN   1,g_x[13] CLIPPED, l_ima05 CLIPPED,
            COLUMN   9,g_x[14] CLIPPED, l_ima08 CLIPPED,
            COLUMN  17,g_x[15] CLIPPED, l_ima37 CLIPPED,
            COLUMN  25,g_x[16] CLIPPED, l_ima63 CLIPPED,
            COLUMN  39,g_x[17] CLIPPED, l_ima55 CLIPPED
      IF g_sma.sma888[1,1] ='Y' THEN
          PRINT g_x[18] CLIPPED,l_ima15 CLIPPED
      ELSE 
          PRINT ' '
      END IF
      PRINT ' '
      #----
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50]
      PRINT g_dash1 
      LET l_last_sw = 'n'
      LET l_dash='N'
 
    ON EVERY ROW
      IF p_level = 1 AND p_i = 0 THEN
           IF (PAGENO > 1 OR LINENO > 14) THEN
 #               LET g_pageno = 0   MOD-530217
                SKIP TO TOP OF PAGE
           END IF
      ELSE
         FOR g_cnt=1 TO 200
             LET l_bmt06[g_cnt]=NULL
         END FOR
         LET l_now2=1
         LET l_len =20
         LET l_bmtstr = ''
         FOREACH r611_bmt  
         USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550095 add bmb29
         INTO l_bmt05,l_bmt06_s
            IF SQLCA.sqlcode THEN 
               CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH 
            END IF
            IF l_now2 > 200 THEN
               CALL cl_err('','9036',1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
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
         END FOREACH
         IF l_now2 > 0 THEN LET l_bmt06[l_now2] = l_bmtstr END IF
         #-->處理說明的部份
          FOR g_cnt=1 TO 200
              LET l_bmc05[g_cnt]=NULL
          END FOR
          LET l_now=1
          FOREACH r611_bmc 
          USING sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb29 #FUN-550095 add bmb29
          INTO l_bmc04,l_bmc05[l_now] 
              IF SQLCA.sqlcode THEN 
                 CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH 
              END IF
              IF l_now > 200 THEN
                  CALL cl_err('','9036',1)
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
                  EXIT PROGRAM 
              END IF
              LET l_now=l_now+1
          END FOREACH
          LET l_now=l_now-1
          #---->使用特性(O/R)
          IF sr.bmb14 ='1' 
          THEN LET sr.bmb14='O'
          ELSE LET sr.bmb14 =''
          END IF
          #---->消耗特性
          IF sr.bmb15 = 'Y' THEN 
             LET sr.bmb15 = '*'
          ELSE LET sr.bmb15 =' '
          END IF
          #---->改變替代特性的表示方式
          IF sr.bmb16 MATCHES '[127]' THEN        #FUN-A40058 add '7'
              LET l_ute_flag='USZ'                #FUN-A40058 add 'Z'
              LET g_cnt=sr.bmb16 USING '&'
              LET sr.bmb16=l_ute_flag[g_cnt,g_cnt]
          ELSE 
              LET sr.bmb16=' '
          END IF
          #---->特性旗標
          IF sr.bmb17='Y' THEN
              LET sr.bmb17='F'
          ELSE
              LET sr.bmb17=' '
          END IF
 
          IF p_level> 10 THEN LET p_level=10 END IF
          IF p_level=1 AND l_dash='Y' THEN
               PRINT g_dash1
          END IF
          LET l_point = ' '
          IF p_level > 1 THEN 
             FOR l_p = 1 TO p_level - 1
                 LET l_point = l_point clipped,'.'
             END FOR
          END IF
          CALL s_effver(sr.bmb01,tm.effective) RETURNING l_ver
          LET l_print32 = l_point CLIPPED,sr.bmb01 CLIPPED,' ',sr.bmb29 CLIPPED #FUN-550095 add
          PRINTX name=D1 COLUMN g_c[31],sr.bmb02 USING '---&',
                         COLUMN g_c[32],l_print32 CLIPPED,
                         COLUMN g_c[33],sr.ima02,
                         COLUMN g_c[34],l_ver,
                         COLUMN g_c[35],sr.bmb10,
                         COLUMN g_c[36],cl_numfor(sr.bmb06,36,5),
                         COLUMN g_c[37],sr.bmb04,
                         COLUMN g_c[38],l_bmt06[1],
                         COLUMN g_c[39],cl_numfor(sr.bmb08,39,3),
                         COLUMN g_c[40],sr.bmb14,'/',sr.bmb15 clipped
          PRINTX name=D2 COLUMN g_c[41],' ',
                         COLUMN g_c[42],' ',
                         COLUMN g_c[43],sr.ima021,
                         COLUMN g_c[44],sr.ima08,
                         COLUMN g_c[45],' ',
                         COLUMN g_c[46],cl_numfor(p_total,46,5),
                         COLUMN g_c[47],sr.bmb05,
                         COLUMN g_c[48],l_bmt06[2],
                         COLUMN g_c[49],cl_numfor(sr.bmb18,49,0),
                         COLUMN g_c[50],sr.bmb16,'/',sr.bmb17 clipped
          IF tm.engine='Y' THEN
              IF sr.bmb11 IS NOT NULL AND sr.bmb11 != ' '
              THEN PRINTX name=D1 COLUMN g_c[32],g_x[23] CLIPPED,
                                  COLUMN g_c[33],sr.bmb11,
                                  COLUMN g_c[38],l_bmt06[3]
              END IF
          ELSE
              IF l_bmt06[3] IS NOT NULL AND l_bmt06[3] != ' ' THEN
                  PRINTX name=D1 COLUMN g_c[38],l_bmt06[3]
              END IF
          END IF
          LET l_bmt06[l_now2] = l_bmtstr 
          FOR g_cnt = 4 TO l_now2 
              IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '
              THEN EXIT FOR 
              END IF
              PRINTX name=D1 COLUMN g_c[38],l_bmt06[g_cnt]
          END FOR
          IF l_now >= 1 THEN 
             FOR g_cnt = 1 TO l_now STEP 2
                 IF g_cnt =1 THEN 
                     PRINTX name=D1 COLUMN g_c[37],g_x[20] clipped; 
                 END IF
                 PRINTX name=D1 COLUMN g_c[38],l_bmc05[g_cnt] CLIPPED,l_bmc05[g_cnt+1] CLIPPED
            END FOR
          END IF
          LET l_dash='Y'
      END IF
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT ' ' 
      PRINT g_x[21] CLIPPED,'  ',g_x[22] CLIPPED
      PRINT g_dash
      IF l_last_sw = 'y'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      END IF
END REPORT
}
#TQC-7A0013 -end
