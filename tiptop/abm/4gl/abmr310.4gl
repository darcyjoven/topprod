# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abmr310.4gl
# Descriptions...: 料件/製造商承認資料表列印
# Input parameter:
# Return code....:
# Date & Author..: 97/11/06 By Chiayi
# Modify.........: No.FUN-4B0024 04/11/03 By Smapmin 料件編號開窗
# Modify.........: No.FUN-510033 05/01/17 By Mandy 報表轉XML
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-720054 07/03/01 By Judy 跳頁功能無效
# Modify.........: No.FUN-850057 08/05/12 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.TQC-930137 09/03/23 By Carrier 制造商簡稱串mse01
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-AB0025 10/11/23 By Summer 增加abmi310相關欄位 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		       	# Print condition RECORD
       	        wc 	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
                h       LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                s  	LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(3)
                t       LIKE type_file.chr3,    #No.FUN-680096 VARCHAR(3)
                more	LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
              END RECORD
 
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE   g_sql          STRING     #NO.FUN-850057
DEFINE   g_str          STRING     #NO.FUN-850057
DEFINE   l_table        STRING     #NO.FUN-850057
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT		        # Supress DEL key function
 
   #CHI-AB0025 add --start--
   LET g_pdate = ARG_VAL(1)	        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.h     = ARG_VAL(8)
   LET tm.s     = ARG_VAL(9)
   LET tm.t     = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #CHI-AB0025 add --end--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
   #NO.FUN-850057-----BEGIN-----
  #CHI-AB0025 mod --start--
  #LET g_sql = "order1.bmj_file.bmj01,", 
  #              "order2.bmj_file.bmj01,", 
  #              "order3.bmj_file.bmj01,", 
  #              "bmj01.bmj_file.bmj01,",
  #              "ima02.ima_file.ima02,",
  #              "ima021.ima_file.ima021,",
  #              "bmj06.bmj_file.bmj06,",
  #              "bmj10.bmj_file.bmj10,",
  #              "bmj11.bmj_file.bmj11,",
  #              "bmj02.bmj_file.bmj02,",
  #              "pmc03.pmc_file.pmc03,",
  #              "bmj04.bmj_file.bmj04,",
  #              "bmj07.bmj_file.bmj07,",
  #              "gen02.gen_file.gen02"
   LET g_sql = "order1.bmj_file.bmj01,", 
               "order2.bmj_file.bmj01,", 
               "order3.bmj_file.bmj01,", 
               "bmj01.bmj_file.bmj01,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "bmj02.bmj_file.bmj02,",
               "mse02.mse_file.mse02,",                          
               "bmj03.bmj_file.bmj03,", 
               "pmc03.pmc_file.pmc03,",
               "bmj04.bmj_file.bmj04,",
               "bmj05.bmj_file.bmj05,",      
               "bmj06.bmj_file.bmj06,",  
               "bmj07.bmj_file.bmj07,",
               "gen02.gen_file.gen02,",  
               "bmj08.bmj_file.bmj08,",
               "bmj10.bmj_file.bmj10,",  
               "bmj11.bmj_file.bmj11,",
               "bmj12.bmj_file.bmj12"
  #CHI-AB0025 mod --end--
   LET l_table = cl_prt_temptable('abmr310',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  #CHI-AB0025                                                                                           
                #" VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"  #CHI-AB0025 mark                                                                                           
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-850057-----END-------
 
  #CHI-AB0025 mark --start--
  #LET g_pdate = ARG_VAL(1)	        # Get arguments from command line
  #LET g_towhom = ARG_VAL(2)
  #LET g_rlang  = ARG_VAL(3)
  #LET g_bgjob  = ARG_VAL(4)
  #LET g_prtway = ARG_VAL(5)
  #LET g_copies = ARG_VAL(6)
  #LET tm.wc    = ARG_VAL(7)
  #LET tm.h     = ARG_VAL(8)
  #LET tm.s     = ARG_VAL(9)
  #LET tm.t     = ARG_VAL(10)
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(11)
  #LET g_rep_clas = ARG_VAL(12)
  #LET g_template = ARG_VAL(13)
  ##No.FUN-570264 ---end---
  #CHI-AB0025 mark --end--
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL r310_tm(0,0)	     	# Input print condition
      ELSE CALL abmr310()	     	# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION r310_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_cmd	      LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 10
 
   OPEN WINDOW r310_w AT p_row,p_col
        WITH FORM "abm/42f/abmr310"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.h    = '3'
   LET tm.s    = '123'
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
      CONSTRUCT BY NAME tm.wc ON bmj01,bmj02,bmj10,bmj11,bmj06
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION CONTROLP #FUN-4B0024
            IF INFIELD(bmj01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bmj"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bmj01
               NEXT FIELD bmj01
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
      LET INT_FLAG = 0 CLOSE WINDOW r310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.h,tm.s,tm.more  # Condition
 
#UI
   INPUT BY NAME tm.h,tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,tm.more
      WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD h
         IF tm.h IS NULL OR tm.h NOT MATCHES '[0-5]' THEN
            NEXT FIELD h
         END IF
 
      AFTER FIELD more
         IF tm.more IS NULL OR tm.more NOT MATCHES '[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r310_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr310'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abmr310','9031',1)
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
                         " '",tm.h CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmr310',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r310_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr310()
   ERROR ""
END WHILE
   CLOSE WINDOW r310_w
END FUNCTION
 
FUNCTION abmr310()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_time2       LIKE type_file.chr8,  	# Used time for running the job        #No.FUN-680096 VARCHAR(8)
          l_time_used	LIKE ogd_file.ogd15,    #No.FUN-680096 DEC(8,2)
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT      #No.FUN-680096 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
          l_order	ARRAY[5] OF LIKE bmj_file.bmj01,    #No.FUN-680096 VARCHAR(40)
          sr RECORD
            #CHI-AB0025 mod --start--
            #order1 LIKE bmj_file.bmj01,     #No.FUN-680096 VARCHAR(40)
            #order2 LIKE bmj_file.bmj01,     #No.FUN-680096 VARCHAR(40)
            #order3 LIKE bmj_file.bmj01,     #No.FUN-680096 VARCHAR(40)
            #bmj01 LIKE bmj_file.bmj01,        #料件編號
            #ima02 LIKE ima_file.ima02,        #品名
            #bmj10 LIKE bmj_file.bmj10,        #承認號碼
            #bmj11 LIKE bmj_file.bmj11,        #承認日期
            #bmj02 LIKE bmj_file.bmj02,        #製造商
            #bmj07 LIKE bmj_file.bmj07,        #製造商
            #bmj06 LIKE bmj_file.bmj06,        #製造商
            #bmj04 LIKE bmj_file.bmj04,        #製造商
            #bmj03 LIKE bmj_file.bmj03,        #代理商
            #bmj12 LIKE bmj_file.bmj12         #MEMO
             order1 LIKE bmj_file.bmj01,   
             order2 LIKE bmj_file.bmj01,  
             order3 LIKE bmj_file.bmj01, 
             bmj01 LIKE bmj_file.bmj01,        #料件編號
             ima02 LIKE ima_file.ima02,        #品名
             bmj02 LIKE bmj_file.bmj02,        #製造商
             bmj03 LIKE bmj_file.bmj03,        #代理商
             bmj04 LIKE bmj_file.bmj04,        #製造商
             bmj05 LIKE bmj_file.bmj05,  
             bmj06 LIKE bmj_file.bmj06,        #製造商
             bmj07 LIKE bmj_file.bmj07,        #製造商
             bmj08 LIKE bmj_file.bmj08,
             bmj10 LIKE bmj_file.bmj10,        #承認號碼
             bmj11 LIKE bmj_file.bmj11,        #承認日期
             bmj12 LIKE bmj_file.bmj12         #MEMO
            #CHI-AB0025 mod --end--
          END RECORD,
          l_mse02       LIKE mse_file.mse02,   #CHI-AB0025 add                                                                          
          l_gen02       LIKE gen_file.gen02,   #NO.FUN-850057
          l_pmc03       LIKE pmc_file.pmc03,   #NO.FUN-850057
          l_ima021      LIKE ima_file.ima021   #NO.FUN-850057
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmjuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bmjgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmjgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmjuser', 'bmjgrup')
     #End:FUN-980030
 
     ##No.B488 010507
     IF tm.h='5' THEN
     LET l_sql = "SELECT '','','',",
                #" bmj01,ima02,bmj10,bmj11,bmj02,bmj07,bmj06,bmj04,bmj03,bmj12", #CHI-AB0025 mark
                 " bmj01,ima02,bmj02,bmj03,bmj04,bmj05,bmj06,bmj07,bmj08,bmj10,bmj11,bmj12", #CHI-AB0025
                 " FROM bmj_file,OUTER ima_file ",
                 " WHERE bmj_file.bmj01 = ima_file.ima01 ",
                 " AND ",tm.wc
     ELSE
     LET l_sql = "SELECT '','','',",
                #" bmj01,ima02,bmj10,bmj11,bmj02,bmj07,bmj06,bmj04,bmj03,bmj12", #CHI-AB0025 mark
                 " bmj01,ima02,bmj02,bmj03,bmj04,bmj05,bmj06,bmj07,bmj08,bmj10,bmj11,bmj12", #CHI-AB0025
                 " FROM bmj_file,OUTER ima_file ",
                 " WHERE bmj_file.bmj01 = ima_file.ima01 ",
                 " AND bmj08= ",tm.h,
                 " AND ",tm.wc
     END IF
 
     PREPARE r310_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE r310_cs1 CURSOR FOR r310_prepare1
     CALL cl_del_data(l_table)   #NO.FUN-850057
#     CALL cl_outnam('abmr310') RETURNING l_name         #NO.FUN-850057
#     START REPORT r310_rep TO l_name                    #NO.FUN-850057
 
#     LET g_pageno = 0            #NO.FUN-850057
#     LET g_cnt=0                 #NO.FUN-850057
     FOREACH r310_cs1 INTO sr.*
       IF SQLCA.sqlcode THEN
         CALL cl_err('ForEACH:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#       LET g_cnt=g_cnt+1    #NO.FUN-850057
       FOR g_i = 1 TO 3
        CASE
          WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bmj01
          WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.bmj02
          WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.bmj10
          WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.bmj11 USING 'yyyymmdd'
          WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.bmj06 USING 'yyyymmdd'  #TQC-720054
        END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       #NO.FUN-850057----BEGIN---
       #No.TQC-930137  --Begin
      #SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.bmj02
       #CHI-AB0025 add --start--
       SELECT mse02 INTO l_mse02 FROM mse_file WHERE mse01 = sr.bmj02                                                                                                
       IF STATUS THEN LET l_mse02='' END IF
       #CHI-AB0025 add --end--
      #SELECT mse02 INTO l_pmc03 FROM mse_file WHERE mse01=sr.bmj02 #CHI-AB0025 mark
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.bmj03 #CHI-AB0025
       #No.TQC-930137  --End  
       IF STATUS THEN LET l_pmc03='' END IF
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.bmj07
       IF STATUS THEN LET l_gen02='' END IF
       SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01 = sr.bmj01
       IF STATUS THEN LET l_ima021='' END IF
      #CHI-AB0025 mod --start--
      #EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.bmj01,
      #                          sr.ima02,l_ima021,sr.bmj06,sr.bmj10,
      #                          sr.bmj11,sr.bmj02,l_pmc03,sr.bmj04,
      #                          sr.bmj07,l_gen02
       EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,sr.bmj01,sr.ima02,
                                 l_ima021,sr.bmj02,l_mse02,sr.bmj03,l_pmc03,
                                 sr.bmj04,sr.bmj05,sr.bmj06,sr.bmj07,l_gen02,
                                 sr.bmj08,sr.bmj10,sr.bmj11,sr.bmj12
      #CHI-AB0025 mod --end--                           
       #NO.FUN-850057---END------
       #OUTPUT TO REPORT r310_rep(sr.*)    #NO.FUN-850057
     END FOREACH
     #NO.FUN-850057-----BEGIN------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'bmj01,bmj02,bmj10,bmj11,bmj06')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF
     LET g_str = tm.wc,";",tm.h,";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
     CALL cl_prt_cs3('abmr310','abmr310',g_sql,g_str)
     #NO.FUN-850057-----BEGIN------
     #DISPLAY "" AT 2,1
     #FINISH REPORT r310_rep                         #NO.FUN-850057
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #NO.FUN-850057
END FUNCTION
#NO.FUN-870144
#NO.FUN-850057----BEGIN----
#REPORT r310_rep(sr)
#  DEFINE l_ima021  LIKE ima_file.ima021
#  DEFINE l_last_sw LIKE type_file.chr1,       #No.FUN-680096 VARCHAR(1)
#         sr RECORD
#            order1 LIKE bmj_file.bmj01,     #No.FUN-680096 VARCHAR(40)
#            order2 LIKE bmj_file.bmj01,     #No.FUN-680096 VARCHAR(40)
#            order3 LIKE bmj_file.bmj01,     #No.FUN-680096 VARCHAR(40)
#            bmj01 LIKE bmj_file.bmj01,        #料件編號
#            ima02 LIKE ima_file.ima02,        #品名
#            bmj10 LIKE bmj_file.bmj10,        #承認號碼
#            bmj11 LIKE bmj_file.bmj11,        #承認日期
#            bmj02 LIKE bmj_file.bmj02,        #製造商
#            bmj07 LIKE bmj_file.bmj07,        #製造商
#            bmj06 LIKE bmj_file.bmj06,        #製造商
#            bmj04 LIKE bmj_file.bmj04,        #製造商
#            bmj03 LIKE bmj_file.bmj03,        #代理商
#            bmj12 LIKE bmj_file.bmj12         #MEMO
#         END RECORD,
#         l_gen02       LIKE gen_file.gen02,
#         l_pmc03       LIKE pmc_file.pmc03,
#         l_chr		LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
#         l_title       LIKE aab_file.aab02    #No.FUN-680096 VARCHAR(6)
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#     CASE
#     WHEN tm.h = "0"
#        LET l_title = g_x[20];
#     WHEN tm.h = "1"
#        LET l_title = g_x[21];
#     WHEN tm.h = "2"
#        LET l_title = g_x[22];
#     WHEN tm.h = "3"
#        LET l_title = g_x[23];
#     ##No.B488 010507
#     WHEN tm.h = "4"
#        LET l_title = g_x[24];
#     WHEN tm.h = "5"
#        LET l_title = g_x[25];
#     END CASE
#     ##No.B488 END
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_x[11] CLIPPED,l_title
#     PRINT g_dash
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#           g_x[41]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 11)  #TQC-720054 mark
#     IF tm.t[1,1] = 'Y'   #TQC-720054
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 11)  #TQC-720054 mark
#     IF tm.t[2,2] = 'Y'   #TQC-720054
#        THEN SKIP TO TOP OF PAGE
#     END IF
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 11)  #TQC-720054 mark
#     IF tm.t[3,3] = 'Y'   #TQC-720054
#        THEN SKIP TO TOP OF PAGE
#     END IF
 
#  ON EVERY ROW
#     SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.bmj02
#     IF STATUS THEN LET l_pmc03='' END IF
#     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.bmj07
#     IF STATUS THEN LET l_gen02='' END IF
#     SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01 = sr.bmj01
#     IF STATUS THEN LET l_ima021='' END IF
 
#     PRINT COLUMN g_c[31],sr.bmj01,
#           COLUMN g_c[32],sr.ima02,
#           COLUMN g_c[33],l_ima021,
#           COLUMN g_c[34],sr.bmj06,
#           COLUMN g_c[35],sr.bmj10,
#           COLUMN g_c[36],sr.bmj11,
#           COLUMN g_c[37],sr.bmj02,
#           COLUMN g_c[38],l_pmc03,
#           COLUMN g_c[39],sr.bmj04,
#           COLUMN g_c[40],sr.bmj07,
#           COLUMN g_c[41],l_gen02
 
#  ON LAST ROW
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[41], g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[41], g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-850057---END----
