# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr500.4gl  #No.TQC-750024
# Descriptions...: 集團銷售預測與實際比較表
# Date & Author..: No.FUN-740017 07/04/04 By rainy
# Modify.........: No.TQC-750024 07/05/08 By Carrier atmr161.4gl -->atmr500
# Modify.........: No.FUN-870029 08/07/02 BY TSD.zeak 轉CR報表  
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.TQC-750024
DEFINE tm    RECORD			        # Print condition RECORD
              wc	STRING,	                # Where condition
              wc2       STRING,	                # Where condition
              more	LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)               # IF more condition
 	     END RECORD,
       l_flag 	        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       l_n	        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       g_end	        LIKE type_file.num5,             #No.FUN-680120 SMALLINT
       g_level_end      ARRAY[5] OF LIKE type_file.num5,     #No.FUN-680120 SMALLINT
       g_unit           LIKE type_file.num10,                #No.FUN-680120 INTEGER               #金額單位基數
       g_odb09          LIKE odb_file.odb09     #幣別
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_sql   STRING
 
DEFINE g_title_cnt      LIKE type_file.num5,
       g_title          DYNAMIC ARRAY OF LIKE  odh_file.odh04
       
DEFINE   l_table    STRING                  # FUN-870029
DEFINE   g_str      STRING                  # FUN-870029
 
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			# Supress DEL key function
 
   LET g_pdate 	  = ARG_VAL(1)	# Get arguments from command line
   LET g_towhom	  = ARG_VAL(2)
   LET g_rlang 	  = ARG_VAL(3)
   LET g_bgjob 	  = ARG_VAL(4)
   LET g_prtway	  = ARG_VAL(5)
   LET g_copies	  = ARG_VAL(6)
   LET tm.wc 	  = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   #FUN-870029 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>  *** ##
   LET g_sql = "odh01.odh_file.odh01,",
               "odb02.odb_file.odb02,",
               "odh02.odh_file.odh02,",
               "tqb02.tqb_file.tqb02,",
               "odh03.odh_file.odh03,",
               "ima02.ima_file.ima02,",
               "ohd04.odh_file.odh04,",
               "foreqty.odh_file.odh05,",
               "soqty.oeb_file.oeb12,",
               "delqty.ogb_file.ogb12,",
               "so_foreqty.odh_file.odh05,",
               "del_foreqty.odh_file.odh05"
 
   LET l_table = cl_prt_temptable('atmr500',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?, ?,?,?,?,?,? ) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   #FUN-870029 - END
 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r500_tm(0,0)	        	# Input print condition
      ELSE CALL atmr500()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r500_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col	 LIKE type_file.num5,            
          l_flag	 LIKE type_file.num5,            
          l_one		 LIKE type_file.chr1,            
          l_bdate	 LIKE type_file.dat,              #No.FUN-680120 DATE
          l_edate	 LIKE type_file.dat,              #No.FUN-680120 DATE
          l_bma01	 LIKE bma_file.bma01,
          l_cmd		 LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col =14 END IF			
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r500_w AT p_row,p_col
        WITH FORM "atm/42f/atmr500"
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		# Default condition
   LET tm.more = "N"	
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON odh01,odh02,odh03 FROM odh01,odh02,odh03
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION CONTROLP
           CASE 
             WHEN INFIELD(odh01) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_odb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.odh01
               NEXT FIELD odh01
 
            WHEN INFIELD(odh02) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tqb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.odh02
               NEXT FIELD odh02
 
            WHEN INFIELD(odh03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO FORMONLY.odh03
               NEXT FIELD odh03
           END CASE
 
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         
            CALL cl_about()      
 
         ON ACTION help          
            CALL cl_show_help()  
 
         ON ACTION controlg      
            CALL cl_cmdask()     
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW r500_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
                WHERE zz01='atmr500'
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
            CALL cl_err('atmr500','9031',1)
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
                            " '",g_rep_user CLIPPED,"'",           
                            " '",g_rep_clas CLIPPED,"'",           
                            " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('atmr500',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL atmr500()
      ERROR ""
   END WHILE
   CLOSE WINDOW r500_w
END FUNCTION
 
 
FUNCTION atmr500()
   DEFINE l_name	LIKE type_file.chr20,           #No.FUN-680120 VARCHAR(20)		# External(Disk) file name
          l_sql 	LIKE type_file.chr1000		# RDSQL STATEMENT        #No.FUN-680120
   DEFINE l_day1   LIKE odh_file.odh04,                 #FUN-870029   
          l_day2   LIKE odh_file.odh04,                 #FUN-870029 
          l_title  LIKE odh_file.odh04,                 #FUN-870029  
          l_foreqty  LIKE odh_file.odh05,               #FUN-870029  
          l_soqty  LIKE oeb_file.oeb12,                 #FUN-870029
          l_so_foreqty LIKE odh_file.odh05,             #FUN-870029
          l_del_foreqty LIKE odh_file.odh05,            #FUN-870029
          l_delqty LIKE ogb_file.ogb12                  #FUN-870029
   DEFINE l_odb  RECORD LIKE odb_file.*,                #FUN-870029 
          sr            RECORD
			 odh01          LIKE odh_file.odh01,
                         odb02          LIKE odb_file.odb02,
			 odh02          LIKE odh_file.odh02,
                         tqb02          LIKE tqb_file.tqb02,
			 odh03          LIKE odh_file.odh03,
                         ima02          LIKE ima_file.ima02
	                END RECORD
 
   #FUN-870029 - ADD
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>*** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #------------------------------ CR (2) ----------------------------------#
   #FUN-870029 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'atmr500'
   IF g_len = 0 OR cl_null(g_len) THEN LET g_len = 75 END IF
   FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND odcuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND odcgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND odcgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('odcuser', 'odcgrup')
   #End:FUN-980030
 
   #抓最上層組織
   LET l_sql = " SELECT DISTINCT odh01,'',odh02,'',odh03,'' ",
               " FROM odh_file ",
               " WHERE ",tm.wc CLIPPED,
               " ORDER BY odh01,odh02,odh03 "
   PREPARE r500_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE r500_curs1 CURSOR FOR r500_prepare1
   FOREACH r500_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      SELECT odb02 INTO sr.odb02  FROM odb_file  WHERE odb01 = sr.odh01
      SELECT tqb02 INTO sr.tqb02  FROM tqb_file  WHERE tqb01 = sr.odh02
      SELECT ima02 INTO sr.ima02  FROM ima_file  WHERE ima01 = sr.odh03
 
     #FUN-870029 -START-
     LET g_sql = "SELECT DISTINCT odh04 FROM odh_file",
                 " WHERE odh01 = '",sr.odh01,"'",
                 "   AND odh02 = '",sr.odh02,"'",
                 "   AND odh03 = '",sr.odh03,"'"
     PREPARE q500_ppecnt_p1 FROM g_sql
     DECLARE q500_ppecnt_c1 CURSOR FOR q500_ppecnt_p1
     FOREACH q500_ppecnt_c1 INTO l_title
       SELECT * INTO l_odb.* FROM odb_file 
                WHERE odb01=sr.odh01
       
       LET l_foreqty = 0
       SELECT odh05 INTO l_foreqty
         FROM odh_file
        WHERE odh01 = sr.odh01
          AND odh02 = sr.odh02
          AND odh03 = sr.odh03
          AND odh04 = l_title
       IF cl_null(l_foreqty) THEN LET l_foreqty = 0 END IF
        
       LET l_day1 = l_title
       LET l_day2 = NULL
       SELECT top(1) odh04 INTO l_day2
         FROM odh_file
        WHERE odh01 = sr.odh01 AND odh02 = sr.odh02 
          AND odh03 = sr.odh03 AND odh04 > l_title
        ORDER BY odh04
 
       IF cl_null(l_day2) THEN
          CASE l_odb.odb04
             WHEN '1' #季
                LET l_day2 = l_day1 + 3 UNITS MONTH
             WHEN '2' #月
                LET l_day2 = l_day1 + 1 UNITS MONTH
             WHEN '3' #旬
                LET l_day2 = l_day1 + 10 UNITS DAY
             WHEN '4' #週
                LET l_day2 = l_day1 + 7 UNITS DAY
             WHEN '5' #天
                LET l_day2 = l_day1 + 1 UNITS DAY
          END CASE
       END IF
     
       #訂單數量/金額
        LET l_soqty = 0 
        SELECT SUM(oeb12) INTO l_soqty
          FROM oea_file,oeb_file,occ_file
         WHERE oea01=oeb01
           AND oeb04 NOT LIKE 'MISC%'
           AND occ01=oea03 
           AND occ1005 = sr.odh02
           AND oeb04   = sr.odh03
           AND oea02 >=l_day1
           AND oea02 < l_day2
           AND oeaconf='Y' 
        IF cl_null(l_soqty) THEN LET l_soqty = 0 END IF
 
       #出單數量/金額
        LET l_delqty = 0 
        SELECT SUM(ogb12*ogb05_fac) INTO l_delqty
          FROM oga_file,ogb_file,occ_file
         WHERE oga01=ogb01
           AND ogb04 NOT LIKE 'MISC%'
           AND occ01=oga03 
           AND occ1005 = sr.odh02
           AND ogb04   = sr.odh03
           AND oga02 >=l_day1
           AND oga02 < l_day2
           AND ogaconf='Y' 
           AND ogapost='Y'
           AND oga09 IN ('2','3','4','6','8') 
        IF cl_null(l_delqty) THEN LET l_delqty = 0 END IF
      
        LET l_so_foreqty = 0
        LET l_del_foreqty = 0
        LET l_so_foreqty = l_soqty - l_foreqty
        LET l_del_foreqty = l_delqty - l_foreqty
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>>  *** #
 
        EXECUTE insert_prep USING
             sr.odh01,   sr.odb02,   sr.odh02,     sr.tqb02,    sr.odh03,
             sr.ima02,   l_title,    l_foreqty,    l_soqty,     l_delqty,
             l_so_foreqty,           l_del_foreqty
        #------------------------------ CR (3) -------------------------------
     END FOREACH
     #FUN-870029 -START-
   END FOREACH	
 
   # FUN-870029 START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'tur01,tur02,tur03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
 
   CALL cl_prt_cs3('atmr500','atmr500',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   # FUN-870029 END 
END FUNCTION
#No.FUN-870144
