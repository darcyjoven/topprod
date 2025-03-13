# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abmr651.4gl
# Descriptions...: 主件總表
# Input parameter:
# Return code....:
# Date & Author..: 91/08/06 By Lee
# Modify         : 92/05/28 By David
# Modify.........: 93/04/30 By Apple
#                : 建檔日期範圍選擇
#                : By Lynn 建立日期(imadate)改為(ima901)
# Modify.........: No.FUN-4B0024 04/11/02 By Smapmin 料件編號開窗
# Modify.........: No.FUN-510033 05/01/17 By Mandy 報表轉XML
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-7A0067 08/04/03 By jamie 1. QBE "料件編號" 統一改為 "主件料號"
#                                                  2. QBE 需於主件料號下，加上"特性代碼" 查詢欄位
#                                                  3. 列印結果需顯示 "特性代碼" 內容欄位
# Modify.........: No.FUN-850057 08/05/15 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/19 By vealxu ima26x 調整
# Modify.........: No.CHI-C20061 12/05/08 By bart 增加條件bmb05為空或bmb05大於失效日期基準日的才印

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				       # Print condition RECORD
		        wc  	STRING,    	       # Where condition No.TQC-630166
   	        	s    	LIKE type_file.chr3,   #No.FUN-680096 VARCHAR(3)
   		        t    	LIKE type_file.chr3,   #No.FUN-680096 VARCHAR(3)
   		        y    	LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
                d       LIKE type_file.dat,    #CHI-C20061
   		        more	LIKE type_file.chr1    #No.FUN-680096 VARCHAR(1)
              END RECORD
 
DEFINE   g_i     LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_str   STRING   #NO.FUN-850057
DEFINE   g_sql   STRING   #NO.FUN-850057
DEFINE   l_table   STRING   #NO.FUN-850057
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
   #NO.FUN-850057-----BEGIN-----
   LET g_sql = "order1.ima_file.ima01,", 
               "order2.ima_file.ima01,",
               "order3.ima_file.ima01,",
               "star.type_file.chr1,", 
               "ima01.ima_file.ima01,",   
               "ima02.ima_file.ima02,", 
               "ima021.ima_file.ima021,",
               "bma06.bma_file.bma06,", 
               "ima05.ima_file.ima05,", 
               "ima08.ima_file.ima08,",
               "ima25.ima_file.ima25,",
               "ima901.ima_file.ima901,", 
               "ima15.ima_file.ima15"
   LET l_table = cl_prt_temptable('abmr651',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-850057------END-------
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.y  = ARG_VAL(10)
   LET tm.d  = ARG_VAL(11)   #CHI-C20061
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12) #CHI-C20061
   LET g_rep_clas = ARG_VAL(13) #CHI-C20061
   LET g_template = ARG_VAL(14) #CHI-C20061
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r651_tm(0,0)		# Input print condition
      ELSE CALL abmr651()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r651_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_cmd		LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 9 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 2 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 9
   END IF
 
   OPEN WINDOW r651_w AT p_row,p_col
        WITH FORM "abm/42f/abmr651"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')  #FUN-7A0067 add
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s    = '123'
   LET tm.y    = '0'
   LET tm.d    = g_today  #CHI-C20061
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,bma06,ima05,ima08,ima06,  #FUN-7A0067 add bma06
                       ima09,ima10,ima11,ima12,ima37,ima901
 
   ON ACTION CONTROLP #FUN-4B0024
      IF INFIELD(ima01) THEN
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_ima5"
         LET g_qryparam.state = "c"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO ima01
         NEXT FIELD ima01
      END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r651_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.s,tm.y,tm.more 		# Condition
#UI
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,tm.y,tm.d,tm.more WITHOUT DEFAULTS  #CHI-C20061 add d
      AFTER FIELD y
         IF  tm.y IS NULL OR tm.y NOT MATCHES '[0-4]' THEN
             NEXT FIELD y
         END IF
      #CHI-C20061---begin
      AFTER FIELD d
         IF cl_null(tm.d) THEN
            LET tm.d = g_today
            DISPLAY tm.d TO d
            NEXT FIELD d
         END IF 
      #CHI-C20061---end
      AFTER FIELD more
         IF  tm.more IS NULL OR tm.more NOT MATCHES '[YN]' THEN
             NEXT FIELD more
         END IF
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
      ON ACTION CONTROLP CALL r651_wc()   # Input detail Where Condition
          IF INT_FLAG THEN EXIT INPUT END IF
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW r651_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr651'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr651','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",  #CHI-C20061
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr651',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r651_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr651()
   ERROR ""
END WHILE
   CLOSE WINDOW r651_w
END FUNCTION
 
FUNCTION r651_wc()
   DEFINE l_wc    LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(500)
 
   OPEN WINDOW r651_w2 AT 2,2
        WITH FORM "aim/42f/aimi101"
################################################################################
# START genero shell script ADD
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimi101")
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('q')
   CONSTRUCT BY NAME l_wc ON                               # 螢幕上取條件
        ima01, ima05, ima08, ima02, ima03,
#        ima07, ima15, ima70, ima25, ima26, ima262,ima261, #FUN-A20044
        ima07, ima15, ima70, ima25,                        #FUN-A20044
        ima23, ima35, ima36, ima71, ima271,ima27,
        ima28, ima29, ima30, ima73, ima74,
        ima63, ima63_fac,    ima64, ima641,
        imauser, imagrup, imamodu, imadate, imaacti
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
 
   CLOSE WINDOW r651_w2
   LET tm.wc = tm.wc CLIPPED,' AND ',l_wc
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r651_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
END FUNCTION
 
FUNCTION abmr651()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-680096 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_order	ARRAY[5] OF LIKE ima_file.ima01,  #No.FUN-680096 VARCHAR(40)
          sr RECORD
             order1 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             order2 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             order3 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
             star   LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(01)
             ima01 LIKE ima_file.ima01,	       # 料件編號
             bma06 LIKE bma_file.bma06,	       # 特性代碼  #FUN-7A0067 add
             ima02 LIKE ima_file.ima02,        #品名規格
             ima021 LIKE ima_file.ima021,      #品名規格 #FUN-510033
             ima05 LIKE ima_file.ima05,        #版本
             ima06 LIKE ima_file.ima06,        # group code
             ima09 LIKE ima_file.ima09,        # group code
             ima10 LIKE ima_file.ima10,        # group code
             ima11 LIKE ima_file.ima11,        # group code
             ima12 LIKE ima_file.ima12,        # group code
             ima08 LIKE ima_file.ima08,        #來源
             ima15 LIKE ima_file.ima15,        #保稅否
             ima25 LIKE ima_file.ima25,        #單位
             ima37 LIKE ima_file.ima37,
             ima901 LIKE ima_file.ima901    #建檔日期(修改日期)
             #bmb03 LIKE bmb_file.bmb03 	       # 料件編號  #CHI-C20061
          END RECORD
   DEFINE l_cnt LIKE type_file.num5  #CHI-C20061
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
     LET l_sql = "SELECT UNIQUE '','','','',",
                 " ima01, bma06, ima02, ima021,ima05, ima06, ima09 ,ima10, ", #FUN-7A0067 add bma06#FUN-510017
                 " ima11, ima12, ima08, ima15, ima25, ima37, ",
                 #" ima901,bmb03",  #CHI-C20061
                 " ima901",  #CHI-C20061  
                 #" FROM ima_file,bma_file,OUTER bmb_file",  #CHI-C20061 mark
                 " FROM ima_file,bma_file",   #CHI-C20061
                 " WHERE ima01=bma01",
                 " AND EXISTS (SELECT 1 FROM bmb_file WHERE bmb01 = bma01 ", #CHI-C20061
                 #" AND bmb_file.bmb03=bma_file.bma01", #CHI-C20061
                 " AND (bmb_file.bmb05 >= '", tm.d,"' OR bmb_file.bmb05 IS NULL))",  #CHI-C20061
                 " AND ",tm.wc
     LET l_sql = l_sql CLIPPED," ORDER BY 1"
     PREPARE r651_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r651_cs1 CURSOR FOR r651_prepare1
     #NO.FUN-850057---BEGIN----
     #CALL cl_outnam('abmr651') RETURNING l_name    
    
    #FUN-7A0067---add---str--- 
    # IF g_sma.sma118 MATCHES 'Y' THEN
    #    LET g_zaa[40].zaa06 = "N"
    # ELSE
    #    LET g_zaa[40].zaa06 = "Y"
    # END IF
    # CALL cl_prt_pos_len()
    #FUN-7A0067---add---end--- 
 
     #START REPORT r651_rep TO l_name   
 
     #LET g_pageno = 0
     CALL cl_del_data(l_table)
     #NO.FUN-850057-----end----
     FOREACH r651_cs1 INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       #CHI-C20061---begin
       IF NOT cl_null(sr.ima01) THEN
          LET l_cnt = 0
          SELECT count(*) INTO l_cnt FROM bmb_file 
           WHERE bmb01 = sr.ima01
             AND bmb03 IS NOT NULL 
          IF l_cnt = 0 THEN
             LET sr.star='*'
          END IF 
       END IF 
       #CHI-C20061---end
       IF sr.ima01 IS NULL THEN LET sr.ima01 = ' ' END IF
       IF sr.bma06 IS NULL THEN LET sr.bma06 = ' ' END IF  #FUN-7A0067 add
       IF sr.ima05 IS NULL THEN LET sr.ima05 = ' ' END IF
       IF sr.ima08 IS NULL THEN LET sr.ima08 = ' ' END IF
       #IF sr.bmb03 IS NULL THEN LET sr.star='*' END IF  #CHI-C20061
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ima01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima05
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima08
               WHEN tm.s[g_i,g_i] = '4'
               CASE
				 WHEN tm.y ='0' LET l_order[g_i] = sr.ima06
				 WHEN tm.y ='1' LET l_order[g_i] = sr.ima09
				 WHEN tm.y ='2' LET l_order[g_i] = sr.ima10
				 WHEN tm.y ='3' LET l_order[g_i] = sr.ima11
				 WHEN tm.y ='4' LET l_order[g_i] = sr.ima12
               END CASE
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.ima37
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.ima901
						USING 'yyyymmdd'
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
         
       EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.star,    #NO.FUN-850057
                                 sr.ima01,sr.ima02,sr.ima021,sr.bma06,
                                 sr.ima05,sr.ima08,sr.ima25,sr.ima901,
                                 sr.ima15
       #OUTPUT TO REPORT r651_rep(sr.*)   #NO.FUN-850057
     END FOREACH
 
    #DISPLAY '' AT 2,1
    #NO.FUN-850057----begin-----
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
    IF g_zz05='Y' THEN
       CALL cl_wcchp(tm.wc,'ima01,bma06,ima05,ima08,ima06,ima09,ima10,ima11,ima12,ima37,ima901')
            RETURNING tm.wc
    ELSE
       LET tm.wc = ""
    END IF
    LET g_str = tm.wc,";",g_sma.sma888[1,1],";",tm.t[1,1],";",tm.t[2,2],";",
                tm.t[3,3],";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
    IF g_sma.sma118 MATCHES 'Y' THEN
       CALL cl_prt_cs3('abmr651','abmr651',g_sql,g_str)
    ELSE
       CALL cl_prt_cs3('abmr651','abmr651_1',g_sql,g_str)
    END IF
     #FINISH REPORT r651_rep
 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #NO.FUN-850057-----end----- 
END FUNCTION
#NO.FUN-870144
#NO.FUN-850057---BEGIN----
#REPORT r651_rep(sr)
#  DEFINE l_last_sw LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
#         sr RECORD
#            order1 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
#            order2 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
#            order3 LIKE ima_file.ima01,     #No.FUN-680096 VARCHAR(40)
#            star   LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
#            ima01 LIKE ima_file.ima01,	       # 料件編號
#            bma06 LIKE bma_file.bma06,	       # 特性代碼  #FUN-7A0067 add
#            ima02 LIKE ima_file.ima02,        #品名規格
#            ima021 LIKE ima_file.ima021,      #品名規格 #FUN-510033
#            ima05 LIKE ima_file.ima05,        #版本
#            ima06 LIKE ima_file.ima06,        # group code
#            ima09 LIKE ima_file.ima09,        # group code
#            ima10 LIKE ima_file.ima10,        # group code
#            ima11 LIKE ima_file.ima11,        # group code
#            ima12 LIKE ima_file.ima12,        # group code
#            ima08 LIKE ima_file.ima08,        #來源
#            ima15 LIKE ima_file.ima15,        #保稅否
#            ima25 LIKE ima_file.ima25,        #單位
#            ima37 LIKE ima_file.ima37,        #OPC
#            ima901 LIKE ima_file.ima901,    #建檔日期(修改日期)
#            bmb03 LIKE bmb_file.bmb03         #單位
#         END RECORD
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]   #FUN-7A0067 add g_x[40]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#     PRINT COLUMN g_c[31],sr.star,
#           COLUMN g_c[32],sr.ima01,
#           COLUMN g_c[33],sr.ima02,
#           COLUMN g_c[34],sr.ima021,
#           COLUMN g_c[40],sr.bma06,  #FUN-7A0067 add
#           COLUMN g_c[35],sr.ima05,
#           COLUMN g_c[36],sr.ima08,
#           COLUMN g_c[37],sr.ima25,
#           COLUMN g_c[38],sr.ima901;
#     IF g_sma.sma888[1,1] ='Y'
#     THEN PRINT COLUMN g_c[39],sr.ima15
#     ELSE PRINT COLUMN g_c[39],' '
#     END IF
#  ON LAST ROW
#     PRINT ' '
#     PRINT g_x[15] clipped
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'ima01,bma06,ima05,ima08,ima06,ima37,ima901')  #FUN-7A0067 add bma06
#             RETURNING tm.wc
#        PRINT g_dash
#        #No.TQC-630166 --start--
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#         #No.TQC-630166 ---end---
#     END IF
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #No.TQC-5B0030 modify
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT ' '
#             PRINT g_x[15] clipped
#             PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-10), g_x[6] CLIPPED   #No.TQC-5B0030 modify
#        ELSE SKIP 4 LINE
#     END IF
#END REPORT
#NO.FUN-850057---END---
