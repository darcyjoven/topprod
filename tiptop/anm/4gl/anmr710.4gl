# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmr710.4gl
# Descriptions...: 銀行借款明細表列印
# Input parameter:
# Return code....:
# Date & Author..: 96/11/28 By jimmy
# Modify.........: 99/05/18 By Kammy (QBE及INPUT皆增加選項)NO:0161
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位對齊
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.MOD-680098 06/09/06 By Smapmin 依實際位數取位
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.CHI-6A0004 06/11/07 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-690036 06/12/01 By Smapmin 修改報表小計與總計部份的列印資料
# Modify.........: No.MOD-820180 08/02/29 By Smapmin 變數定義錯誤
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-830156 08/09/22 By dxfwo 老報表改CR
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B40255 11/04/28 By Dido 列印時若選 P:匯入 Excel 無資料呈現 
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-B90263 11/09/29 By Sarah R&M加權的計算應不需要再除以1000
# Modify.........: No:MOD-BB0093 12/02/09 By jt_chen 調整tm.t='2'THEN中的語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		                 # Print condition RECORD
              wc      STRING,                    #Where Condiction
              nne03_1 LIKE type_file.dat,        #No.FUN-680107 DATE
              nne03_2 LIKE type_file.dat,        #No.FUN-680107 DATE
              t       LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
              s       LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3)
              u       LIKE type_file.chr3,       #No.FUN-680107 VARCHAR(3)
              more    LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1) #是否列印其它條件
              END RECORD,
          l_t_amt1  LIKE nne_file.nne19,
          l_t_amt2  LIKE nne_file.nne12,
          l_dash    LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(140)
          l_sum     LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6) #總計銀行目前存款餘額
          l_sw      LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          first_sw  LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
DEFINE    g_orderA  ARRAY[3] OF LIKE type_file.chr12   #MOD-690036
DEFINE   g_i        LIKE type_file.num5          #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1    STRING
DEFINE   g_sql      STRING          #No.FUN-830156
DEFINE   l_table    STRING          #No.FUN-830156
DEFINE   l_table1   STRING          #No.FUN-830156
DEFINE   l_table2   STRING          #No.FUN-830156
DEFINE   l_table3   STRING          #No.FUN-830156
DEFINE   l_table4   STRING          #No.FUN-830156
DEFINE   l_table5   STRING          #No.FUN-830156
DEFINE   g_str      STRING          #No.FUN-830156
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT		    		 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-830156-----BEGIN-----
   LET g_sql = "order1.nne_file.nne01,",
	       "order2.nne_file.nne01,",
	       "order3.nne_file.nne01,",
	       "alg01.alg_file.alg01,",
               "alg02.alg_file.alg02,",
	       "nne01.nne_file.nne01,",
               "nne04.nne_file.nne04,",
	       "nne06.nnn_file.nnn02,",
	       "nne07.nne_file.nne07,",
	       "nne13.nne_file.nne13,",
	       "nnp09.nnp_file.nnp09,",
	       "nne19.nne_file.nne19,",
	       "amt.type_file.num20_6,",
	       "nne16.nne_file.nne16,",
	       "nne12.nne_file.nne12,",
               "nne111.type_file.chr20,",
	       "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('anmr710',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF 
 
   LET g_sql = "order1.nne_file.nne01,",
               "l_cur.type_file.chr20,",
               "amt1.type_file.num20_6,",
               "amt.type_file.num20_6,", 
               "azi05.azi_file.azi05"
   LET l_table1 = cl_prt_temptable('anmr710_1',g_sql) CLIPPED                      
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "order2.nne_file.nne01,",
               "l_cur.type_file.chr20,",
               "amt1.type_file.num20_6,",
               "amt.type_file.num20_6" 
   LET l_table2 = cl_prt_temptable('anmr710_2',g_sql) CLIPPED                   
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "order3.nne_file.nne01,",
               "l_cur.type_file.chr20,",
               "amt1.type_file.num20_6,",
               "amt.type_file.num20_6,", 
               "azi05.azi_file.azi05"
   LET l_table3 = cl_prt_temptable('anmr710_3',g_sql) CLIPPED                   
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "nne04.nne_file.nne04,",
               "l_cur.type_file.chr20,",
               "amt1.type_file.num20_6,",
               "amt.type_file.num20_6,", 
               "azi05.azi_file.azi05"
   LET l_table4 = cl_prt_temptable('anmr710_4',g_sql) CLIPPED                   
   IF  l_table4 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "l_cur.type_file.chr20,",
               "amt1.type_file.num20_6,",
               "amt.type_file.num20_6,", 
               "azi05.azi_file.azi05"
   LET l_table5 = cl_prt_temptable('anmr710_5',g_sql) CLIPPED                   
   IF  l_table5 = -1 THEN EXIT PROGRAM END IF 
   #No.FUN-830156-----END------
 
# bank sub tot control
   LET l_sw = 'Y'
   LET l_t_amt1 = 0
   LET l_t_amt2 = 0
   LET g_pdate = ARG_VAL(1)	   	         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.nne03_1  = ARG_VAL(8)
   LET tm.nne03_2  = ARG_VAL(9)
   LET tm.t        = ARG_VAL(10)
   LET tm.s        = ARG_VAL(11)
   LET tm.u        = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   #No.FUN-570264 ---end---
   #no.5195
   DROP TABLE curr_tmp
#No.FUN-680107 --start
#  CREATE TEMP TABLE curr_tmp
# Prog. Version..: '5.30.06-13.03.12(04),                    #幣別
# Prog. Version..: '5.30.06-13.03.12(08),                    #信貸銀行編號
#    amt   DEC(20,6),                   #融資金額
#    amt1  DEC(20,6),                   #本幣融資金額
#    order1  VARCHAR(20),
#    order2  VARCHAR(20),
#    order3  VARCHAR(20)
#   );
 
   #No.FUN-680107--欄位類型修改                                                    
   CREATE TEMP TABLE curr_tmp(
    curr LIKE azi_file.azi01,
    nne04 LIKE nne_file.nne04,
    amt LIKE nne_file.nne12,
    amt1 LIKE nne_file.nne19,
    order1 LIKE nne_file.nne01,
    order2 LIKE nne_file.nne01,
    order3 LIKE nne_file.nne01);
#No.FUN-680107 --end
   #no.5195(end)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr710_tm()	        	# Input print condition
      ELSE CALL anmr710()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr710_tm()
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col  LIKE type_file.num5,     #No.FUN-680107 SMALLINT
       l_cmd	    LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(400)
       l_flag       LIKE type_file.chr1,     #是否必要欄位有輸入 #No.FUN-680107 VARCHAR(1)
       l_jmp_flag   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW anmr710_w AT p_row,p_col
        WITH FORM "anm/42f/anmr710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s = '361'
   LET tm.t = '3'
   LET tm.nne03_2=g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nne01, nne02, nne04, nne112, nne06, nne16
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.nne03_1,tm.nne03_2,
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.t  ,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD nne03_1
	   IF tm.nne03_1 IS NULL OR tm.nne03_1 = ' ' THEN
		  DISPLAY BY NAME tm.nne03_1
		  NEXT FIELD nne03_1
           END IF
           IF NOT cl_null(tm.nne03_2) THEN
           IF tm.nne03_1 > tm.nne03_2 THEN
              NEXT FIELD nne03_1
           END IF
           END IF
      AFTER FIELD nne03_2
	   IF tm.nne03_2 IS NULL OR tm.nne03_2 = ' ' THEN
		 #LET tm.nne03_2 = g_lastdat
		  LET tm.nne03_2 = g_today
		  DISPLAY BY NAME tm.nne03_2
		  NEXT FIELD nne03_2
           END IF
           IF tm.nne03_1 > tm.nne03_2 THEN
              NEXT FIELD nne03_1
           END IF
      AFTER FIELD t
           IF tm.t NOT MATCHES "[123]" THEN NEXT FIELD t END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL OR tm.more = ' '
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF tm.nne03_1 IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.nne03_1
           NEXT FIELD nne03_1
       END IF
       IF tm.nne03_2 IS NULL THEN
           LET l_flag='Y'
           DISPLAY BY NAME tm.nne03_2
           NEXT FIELD nne03_2
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          NEXT FIELD nne03_1
       END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr710'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr710','9031',1)
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
                         " '",tm.nne03_1 CLIPPED,"'",
                         " '",tm.nne03_2 CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264"
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr710',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr710()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr710_w
END FUNCTION
 
#No.FUN-830156-----------begin-----------------
FUNCTION anmr710()
   DEFINE l_name	LIKE type_file.chr20, 		     # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		     # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,              #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[5] OF LIKE nne_file.nne01,     #No.FUN-680107 ARRAY[3] OF VARCHAR(20)  #排列順序
          sr            RECORD
			   order1   LIKE nne_file.nne01,     #No.FUN-680107 VARCHAR(20)
			   order2   LIKE nne_file.nne01,     #No.FUN-680107 VARCHAR(20)
			   order3   LIKE nne_file.nne01,     #No.FUN-680107 VARCHAR(20)
			   nne04    LIKE nne_file.nne04,
			   nne03    LIKE nne_file.nne03,
                           nne01    LIKE nne_file.nne01,
                           nne02    LIKE nne_file.nne02,
			   nne06    LIKE nne_file.nne06,
			   nne07    LIKE nne_file.nne07,
			   nne13    LIKE nne_file.nne13,
			   nne19    LIKE nne_file.nne19,
			   nne16    LIKE nne_file.nne16,
			   nne12    LIKE nne_file.nne12,
			   nne111   LIKE nne_file.nne111,
			   nne112   LIKE nne_file.nne112,
                           nne20    LIKE nne_file.nne20,
                           nne21    LIKE nne_file.nne21,
                           nne27    LIKE nne_file.nne27,
                           nne30    LIKE nne_file.nne30,
			   amt      LIKE type_file.num20_6   #No.FUN-680107 DEC(20,6)
                        END RECORD
   DEFINE l_pma03		    LIKE pma_file.pma03      #No.FUN-680107 VARCHAR(1)
   DEFINE l_pma08,l_pma09,l_pma10   LIKE pma_file.pma08      #No.FUN-680107 SMALLINT
   DEFINE l_gga03,l_gga04	    LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
   DEFINE l_gga05,l_gga051,l_gga07,l_gga071 LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE l_rate,l_days		    LIKE type_file.num5      #No.FUN-680107 SMALLINT
   DEFINE l_alg     RECORD LIKE alg_file.*
   DEFINE l_nne06   LIKE nnn_file.nnn02
   DEFINE l_nnp09   LIKE nnp_file.nnp09
   DEFINE l_curr    LIKE nne_file.nne16
   DEFINE l_cur     LIKE type_file.chr20
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_nne111  LIKE type_file.chr20
   DEFINE sr1       RECORD
                      curr      LIKE azi_file.azi01,    
                      amt       LIKE nne_file.nne12,
                      amt1      LIKE nne_file.nne19
                    END RECORD
     LET first_sw = 'y'
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-830156-----------begin-----------------
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,               
                             ?, ?, ?)"
     PREPARE insert_prep FROM g_sql                                               
     IF STATUS THEN                                                               
        CALL cl_err('insert_prep:',status,1)                                      
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM                                                              
     END IF
   
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?)"
     PREPARE insert_prep1 FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep1:',status,1)                                    
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM                                                            
     END IF
    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?, ?, ?, ?)"
     PREPARE insert_prep2 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep2:',status,1)                                   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM                                                            
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,           
                 " VALUES(?, ?, ?, ?, ?)"                                       
     PREPARE insert_prep3 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep3:',status,1)                                   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM                                                            
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,           
                 " VALUES(?, ?, ?, ?, ?)"                                       
     PREPARE insert_prep4 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep4:',status,1)                                   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM                                                            
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,           
                 " VALUES(?, ?, ?, ?)"                                       
     PREPARE insert_prep5 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep5:',status,1)                                   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80067--add--
        EXIT PROGRAM                                                            
     END IF
#No.FUN-830156--------------end----------------------     
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nneuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nnegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nnegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nneuser', 'nnegrup')
     #End:FUN-980030
 
#No.FUN-830156-----------begin-----------------
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)                                                                                                     
     CALL cl_del_data(l_table5)
#========================================================================
#   CALL cl_outnam('anmr710') RETURNING l_name
#   START REPORT anmr710_rep TO l_name
#   LET g_pageno = 0
#------------------------------------------------------------------------
#No.FUN-830156--------------end----------------------
     #no.5195   (針對幣別加總)
     DELETE FROM curr_tmp;
 
     LET l_sql=" SELECT curr,SUM(amt),SUM(amt1) FROM curr_tmp ",#group 1 小計
               "  WHERE order1=? ",
               #"    AND nne04 =? ",   #MOD-690036
               "  GROUP BY curr"
     PREPARE tmp1_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_1:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp1_cs CURSOR FOR tmp1_pre
 
     LET l_sql=" SELECT curr,SUM(amt),SUM(amt1) FROM curr_tmp ",#group 2 小計
               "  WHERE order1=? ",
               "    AND order2=? ",
               #"    AND nne04 =? ",   #MOD-690036
               "  GROUP BY curr  "
     PREPARE tmp2_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_2:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp2_cs CURSOR FOR tmp2_pre
 
     LET l_sql=" SELECT curr,SUM(amt),SUM(amt1) FROM curr_tmp ",#group 3 小計
               "  WHERE order1=? ",
               "    AND order2=? ",
               "    AND order3=? ",
               #"    AND nne04 =? ",    #MOD-690036
               "  GROUP BY curr  "
     PREPARE tmp3_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_3:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp3_cs CURSOR FOR tmp3_pre
 
     LET l_sql=" SELECT curr,SUM(amt),SUM(amt1) FROM curr_tmp ",#nne04 小計
               "  WHERE nne04 =? ",
               "  GROUP BY curr  "
     PREPARE tmp4_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre_4:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp4_cs CURSOR FOR tmp4_pre
 
     LET l_sql=" SELECT curr,SUM(amt),SUM(amt1) FROM curr_tmp ",#on last row 總計
               "  GROUP BY curr  "
     PREPARE tmp_pre FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('pre:',SQLCA.sqlcode,1) RETURN END IF
     DECLARE tmp_cs CURSOR FOR tmp_pre
     #no.5195(end)
 
     LET l_sql = "SELECT '','','',nne04,nne03,nne01,nne02,nne06,nne07,nne13,",
                 " nne19,nne16,nne12,nne111,nne112,nne20,nne21,nne27,nne30,0",
                 " FROM nne_file",
                 " WHERE nneconf='Y'",
                 "   AND nne03 >= ","'",tm.nne03_1,"'",
                 "   AND nne03 <= ","'",tm.nne03_2,"'",
                 "   AND ",tm.wc CLIPPED
    IF tm.t = '1' THEN
        LET l_sql = l_sql CLIPPED," AND (nne26 is not null )"
    END IF
    IF tm.t = '2' THEN
       #LET l_sql = l_sql CLIPPED," AND (nne26 is null ) "                             #MOD-BB0093  --mark
       LET l_sql = l_sql CLIPPED," AND (nne26 is null OR nne26 >=","'",tm.nne03_2,"')" #MOD-BB0093 add
    END IF
    PREPARE anmr710_pre0 FROM l_sql
     DECLARE anmr710_cu0 CURSOR FOR anmr710_pre0
     FOREACH anmr710_cu0 INTO sr.*
       IF STATUS THEN CALL cl_err('p00:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM 
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.nne01
                                        LET g_orderA[g_i] = g_x[12]   #MOD-690036
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.nne02
                                                    USING 'yyyymmdd'
                                        LET g_orderA[g_i] = g_x[13]   #MOD-690036
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.nne04
                                        LET g_orderA[g_i] = g_x[14]   #MOD-690036
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.nne112
                                                    USING 'yyyymmdd'
                                        LET g_orderA[g_i] = g_x[15]   #MOD-690036
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.nne06
                                        LET g_orderA[g_i] = g_x[16]   #MOD-690036
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.nne16
                                        LET g_orderA[g_i] = g_x[17]   #MOD-690036
               OTHERWISE LET l_order[g_i] = '-'
                             LET g_orderA[g_i] = '-'   #MOD-690036
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
       IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
       IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
       IF cl_null(sr.nne12) THEN LET sr.nne12 = 0 END IF
       IF cl_null(sr.nne13) THEN LET sr.nne13 = 0 END IF
       IF cl_null(sr.nne19) THEN LET sr.nne19 = 0 END IF
      #LET sr.amt = sr.nne19 * sr.nne13 / 100 / 1000   #MOD-B90263 mark
       LET sr.amt = sr.nne19 * sr.nne13 / 100          #MOD-B90263
       IF cl_null(sr.amt) THEN LET sr.amt = 0 END IF
      #no.5195
      INSERT INTO curr_tmp VALUES(sr.nne16,sr.nne04,sr.nne12,sr.nne19,
                                  sr.order1,sr.order2,sr.order3)
      #no.5195(end)
#       OUTPUT TO REPORT anmr710_rep(sr.*)
     END FOREACH
#------------------------------------------------------------------------
#     FINISH REPORT anmr710_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    FOREACH anmr710_cu0 INTO sr.*
       IF STATUS THEN CALL cl_err('p00:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM 
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.nne01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.nne02
                                                    USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.nne04
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.nne112
                                                    USING 'yyyymmdd'
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.nne06
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.nne16
               OTHERWISE LET l_order[g_i] = '-'
                             LET g_orderA[g_i] = '-'   #MOD-690036
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
       IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
       IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
       IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
       IF cl_null(sr.nne12) THEN LET sr.nne12 = 0 END IF
       IF cl_null(sr.nne13) THEN LET sr.nne13 = 0 END IF
       IF cl_null(sr.nne19) THEN LET sr.nne19 = 0 END IF
      #LET sr.amt = sr.nne19 * sr.nne13 / 100 / 1000   #MOD-B90263 mark
       LET sr.amt = sr.nne19 * sr.nne13 / 100          #MOD-B90263
       IF cl_null(sr.amt) THEN LET sr.amt = 0 END IF
      SELECT * INTO l_alg.* FROM alg_file WHERE alg01 = sr.nne04
      IF SQLCA.sqlcode THEN
         INITIALIZE l_alg.* TO NULL
      END IF
      SELECT nnn02 INTO l_nne06 FROM nnn_file WHERE nnn01=sr.nne06
      IF SQLCA.sqlcode THEN
         LET l_nne06 = ''
      END IF
      SELECT nnp09 INTO l_nnp09 FROM nnp_file
        WHERE nnp01=sr.nne30 AND nnp03=sr.nne06
      IF SQLCA.sqlcode THEN
         LET l_nnp09 = 0
      END IF
 
      SELECT azi03,azi04,azi05
        INTO t_azi03,t_azi04,t_azi05
        FROM azi_file
       WHERE azi01=sr.nne16
      LET l_nne111=sr.nne111,'-',sr.nne112
      EXECUTE insert_prep USING sr.order1,sr.order2,sr.order3,l_alg.alg01,
                l_alg.alg02,sr.nne01,sr.nne04,l_nne06,sr.nne07,sr.nne13,l_nnp09,
                sr.nne19,sr.amt,sr.nne16,sr.nne12,l_nne111,t_azi05
 
      #after group or order1
      IF tm.u[1,1] = 'Y' THEN
         FOREACH tmp1_cs USING sr.order1 INTO sr1.*  
             SELECT azi05 INTO t_azi05 FROM azi_file  
              WHERE azi01 = sr1.curr
            
             EXECUTE insert_prep1 USING sr.order1,sr1.curr,sr1.amt1,
                                        sr1.amt,t_azi05 
         END FOREACH
      END IF
      #after group or order2
      IF tm.u[2,2] = 'Y' THEN
         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*  
            SELECT azi05 INTO t_azi05 FROM azi_file   
                WHERE azi01 = sr1.curr
   
            EXECUTE insert_prep2 USING                
                sr.order2,sr1.curr,sr1.amt1,sr1.amt
         END FOREACH
      END IF
      #after group or order3
      IF tm.u[3,3] = 'Y' THEN
         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*  
            SELECT azi05 INTO g_azi05 FROM azi_file 
               WHERE azi01 = sr1.curr
 
            EXECUTE insert_prep3 USING sr.order3,sr1.curr,sr1.amt1,                
                                       sr1.amt,t_azi05
         END FOREACH
      END IF
      #after group of nne04
      FOREACH tmp4_cs USING sr.nne04 INTO sr1.*
         SELECT azi05 INTO t_azi05 FROM azi_file  
             WHERE azi01 = sr1.curr
         EXECUTE insert_prep4 USING sr.nne04,sr1.curr,sr1.amt1,                 
                                   sr1.amt,t_azi05
      END FOREACH
      #no.5195(end)
#      OUTPUT TO REPORT anmr710_rep(sr.*)
     END FOREACH
#------------------------------------------------------------------------
#     FINISH REPORT anmr710_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #on last row
     FOREACH tmp_cs INTO sr1.* 
        SELECT azi05 INTO t_azi05 FROM azi_file 
           WHERE azi01 = sr1.curr
 
        LET l_cur=g_x[18],sr1.curr,':' 
        EXECUTE insert_prep5 USING sr1.curr,sr1.amt1,                    
                                   sr1.amt,t_azi05
     END FOREACH
 
    #LET g_sql = "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|", #MOD-B40255 mark 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",          #MOD-B40255
                 "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",     
                 "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",     
                 "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",    
                 "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
                 "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED 
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog                     
     IF g_zz05='Y' THEN                                                         
         CALL cl_wcchp(tm.wc,'nne01,nne02,nne04,nne112,nne06,nne16')                          
              RETURNING tm.wc                                                    
     ELSE                                                                       
        LET tm.wc = ""                                                             
     END IF
     LET g_str=tm.wc,";",g_azi05,";",tm.u[1,1],";",tm.u[2,2],";",
                   tm.u[3,3],";",tm.nne03_1,";",tm.nne03_2,";",
                   tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3]
     CALL cl_prt_cs3('anmr710','anmr710',g_sql,g_str)      
END FUNCTION
 
#REPORT anmr710_rep(sr)
#   DEFINE         l_last_sw LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
#		  a,l_amt,l_amt1,l_amt2 LIKE type_file.num20_6,#No.FUN-680107 DECIMAL(20,6)
#		  l_s_amt1,l_s_amt2     LIKE type_file.num20_6,#No.FUN-680107 DECIMAL(20,6) #TQC-840066
#		  l_nne06   LIKE nnn_file.nnn02,     #LIKE nne_file.nne06,     #No.FUN-680107 VARCHAR(12)   #MOD-820180
#		  l_nne07   LIKE nne_file.nne07,     #No.FUN-680107 VARCHAR(7)
#                  l_nne111  LIKE type_file.chr20,    #No.FUN-680107 VARCHAR(20)
#                  l_nnp09   LIKE nnp_file.nnp09,
#		  l_alg     RECORD LIKE alg_file.*,
#		  l_rate    LIKE nne_file.nne17,
#                #  l_azi03   LIKE azi_file.azi03,    #NO.CHI-6A0004  
#                #  l_azi04   LIKE azi_file.azi04,    #NO.CHI-6A0004 
#                #  l_azi05   LIKE azi_file.azi05,    #NO.CHI-6A0004 
#                  l_cur     LIKE type_file.chr20,    #No.FUN-680107 VARCHAR(5)
#          sr   RECORD
#                  order1   LIKE nne_file.nne01,      #No.FUN-680107 VARCHAR(20)
#	          order2   LIKE nne_file.nne01,      #No.FUN-680107 VARCHAR(20)
#	          order3   LIKE nne_file.nne01,      #No.FUN-680107 VARCHAR(20)
#	          nne04    LIKE nne_file.nne04,
#                  nne03    LIKE nne_file.nne03,
#	          nne01    LIKE nne_file.nne01,
#	          nne02    LIKE nne_file.nne02,
#	          nne06    LIKE nne_file.nne06,
#		  nne07    LIKE nne_file.nne07,
#		  nne13    LIKE nne_file.nne13,
#		  nne19    LIKE nne_file.nne19,
#		  nne16    LIKE nne_file.nne16,
#		  nne12    LIKE nne_file.nne12,
#		  nne111   LIKE nne_file.nne111,
#		  nne112   LIKE nne_file.nne112,
#                  nne20    LIKE nne_file.nne20,
#                  nne21    LIKE nne_file.nne21,
#                  nne27    LIKE nne_file.nne27,
#                  nne30    LIKE nne_file.nne30,
#	          amt      LIKE type_file.num20_6    #No.FUN-680107
#               END RECORD ,
#          sr1  RECORD
#                 curr      LIKE azi_file.azi01,      #No.FUN-680107
#                 amt       LIKE nne_file.nne12,
#                 amt1      LIKE nne_file.nne19
#               END RECORD
#  DEFINE l_curr   LIKE nne_file.nne16
#  DEFINE l_oamt   LIKE nne_file.nne12
#  DEFINE l_lamt   LIKE nne_file.nne19
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#  ORDER BY sr.nne04,sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1=g_x[9] CLIPPED, ' ',tm.nne03_1,g_x[10] CLIPPED,' ',tm.nne03_2
#      #PRINT g_head1                         #FUN-660060 remark
#      PRINT COLUMN (g_len-25)/2+1, g_head1   #FUN-660060
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.nne04
#      LET l_alg.alg02 = NULL LET l_sum = 0
#      LET l_sw = 'Y'
#      LET l_amt1 = 0
#      LET l_amt2 = 0
#      LET l_s_amt1 = 0
#      LET l_s_amt2 = 0
#      IF cl_null(l_sum) THEN LET l_sum = 0 END IF
#      SELECT * INTO l_alg.* FROM alg_file WHERE alg01 = sr.nne04
#
#   ON EVERY ROW
#      IF l_sw = 'N' THEN
#          LET l_alg.alg02 = '            '
#         ELSE
#          LET l_sw = 'N'
#      END IF
#      #no.0246
#      SELECT nnn02 INTO l_nne06 FROM nnn_file WHERE nnn01=sr.nne06
#      #no.0246(end)
#      SELECT nnp09 INTO l_nnp09 FROM nnp_file
#        WHERE nnp01=sr.nne30 AND nnp03=sr.nne06
#
#      SELECT azi03,azi04,azi05
#        INTO t_azi03,t_azi04,t_azi05             #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.nne16
#      LET l_nne111=sr.nne111,'-',sr.nne112
#
#      PRINT COLUMN g_c[31],l_alg.alg01,
#            COLUMN g_c[32],l_alg.alg02,
#            COLUMN g_c[33],sr.nne01,
#            COLUMN g_c[34],l_nne06 CLIPPED,
#            COLUMN g_c[35],l_nne07 CLIPPED,
#            #COLUMN g_c[36],sr.nne13 USING "############.##", #No.TQC-5C0051   #MOD-680098
#            COLUMN g_c[36],cl_numfor(sr.nne13,36,4),   #MOD-680098
#            COLUMN g_c[37],cl_numfor(l_nnp09,37,g_azi05),
#            COLUMN g_c[38],cl_numfor(sr.nne19,38,g_azi05),
#            COLUMN g_c[39],l_amt USING "###,###",
#            COLUMN g_c[40],sr.nne16,
#            COLUMN g_c[41],cl_numfor(sr.nne12,41,t_azi05),      #NO.CHI-6A0004 
#            COLUMN g_c[42],l_nne111
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_s_amt1 = GROUP SUM(sr.nne19)
#         LET l_s_amt2 = GROUP SUM(sr.nne12)
#         IF cl_null(l_s_amt1) THEN LET l_s_amt1 = 0 END IF
#         IF cl_null(l_s_amt2) THEN LET l_s_amt2 = 0 END IF
#         #no.5195
#         #FOREACH tmp1_cs USING sr.order1,sr.nne04 INTO sr1.*   #MOD-690036
#         FOREACH tmp1_cs USING sr.order1 INTO sr1.*   #MOD-690036
#             SELECT azi05 INTO t_azi05 FROM azi_file               #NO.CHI-6A0004 
#              WHERE azi01 = sr1.curr
#             #LET l_cur='Sub Tot ',sr1.curr,':'   #MOD-690036
#             LET l_cur=g_orderA[1],sr1.curr,':'   #MOD-690036
#             PRINT COLUMN g_c[31],l_cur,
#                   COLUMN g_c[38],cl_numfor(sr1.amt1,38,g_azi05),
#                   COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05)   #NO.CHI-6A0004 
#         END FOREACH
#         #no.5195(end)
#         #PRINT l_dash[1,g_len]
#         PRINT g_dash2
#      END IF
#
#    AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_s_amt1 = GROUP SUM(sr.nne19)
#         LET l_s_amt2 = GROUP SUM(sr.nne12)
#         IF cl_null(l_s_amt1) THEN LET l_s_amt1 = 0 END IF
#         IF cl_null(l_s_amt2) THEN LET l_s_amt2 = 0 END IF
#         #no.5195
#         #FOREACH tmp2_cs USING sr.order1,sr.order2,sr.nne04 INTO sr1.*   #MOD-690036
#         FOREACH tmp2_cs USING sr.order1,sr.order2 INTO sr1.*   #MOD-690036
#             SELECT azi05 INTO t_azi05 FROM azi_file              #NO.CHI-6A0004 
#              WHERE azi01 = sr1.curr
#             #LET l_cur='Sub Tot ',sr1.curr,':'   #MOD-690036
#             LET l_cur=g_orderA[2],sr1.curr,':'   #MOD-690036
#             PRINT COLUMN g_c[31],l_cur,
#                   COLUMN g_c[38],cl_numfor(sr1.amt1,38,g_azi05),
#                   COLUMN g_c[41],cl_numfor(sr1.amt,41,g_azi05)    #NO.CHI-6A0004 
#         END FOREACH
#         #no.5195(end)
#         #PRINT l_dash[1,g_len]
#         PRINT g_dash2
#      END IF
# 
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         LET l_s_amt1 = GROUP SUM(sr.nne19)
#         LET l_s_amt2 = GROUP SUM(sr.nne12)
#         IF cl_null(l_s_amt1) THEN LET l_s_amt1 = 0 END IF
#         IF cl_null(l_s_amt2) THEN LET l_s_amt2 = 0 END IF
#         #no.5195
#         #FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3,sr.nne04 INTO sr1.*   #MOD-690036
#         FOREACH tmp3_cs USING sr.order1,sr.order2,sr.order3 INTO sr1.*   #MOD-690036
#             SELECT azi05 INTO g_azi05 FROM azi_file         #NO.CHI-6A0004 
#              WHERE azi01 = sr1.curr
#             #LET l_cur='Sub Tot ',sr1.curr,':'   #MOD-690036
#             LET l_cur=g_orderA[3],sr1.curr,':'   #MOD-690036
#             PRINT COLUMN g_c[31],l_cur,
#                   COLUMN g_c[38],cl_numfor(sr1.amt1,38,g_azi05),
#                   COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05)              #NO.CHI-6A0004 
#         END FOREACH
#         #no.5195(end)
#         #PRINT l_dash[1,g_len]
#         PRINT g_dash2
#      END IF
# 
# 
#   AFTER GROUP OF sr.nne04
#      LET l_s_amt1 = GROUP SUM(sr.nne19)
#      LET l_s_amt2 = GROUP SUM(sr.nne12)
#      IF cl_null(l_s_amt1) THEN LET l_s_amt1 = 0 END IF
#      IF cl_null(l_s_amt2) THEN LET l_s_amt2 = 0 END IF
#      #PRINT g_x[11] CLIPPED;   #MOD-690036
#      #no.5195
#      FOREACH tmp4_cs USING sr.nne04 INTO sr1.*
#          SELECT azi05 INTO t_azi05 FROM azi_file               #NO.CHI-6A0004 
#           WHERE azi01 = sr1.curr
#          #LET l_cur=sr1.curr,':'   #MOD-690036
#          LET l_cur=g_x[11],sr1.curr,':'   #MOD-690036
#          #PRINT COLUMN g_c[36],l_cur,   #MOD-690036
#          PRINT COLUMN g_c[31],l_cur,   #MOD-690036
#                COLUMN g_c[38],cl_numfor(sr1.amt1,38,g_azi05),
#                COLUMN g_c[41],cl_numfor(sr1.amt,41, t_azi05)  #NO.CHI-6A0004 
#      END FOREACH
#      #no.5195(end)
#      #PRINT l_dash[1,g_len]
#      PRINT g_dash2
#   ON LAST ROW
#      LET l_t_amt1 = SUM(sr.nne19)
#      LET l_t_amt2 = SUM(sr.nne12)
#      IF cl_null(l_t_amt1) THEN LET l_t_amt1 = 0 END IF
#      IF cl_null(l_t_amt2) THEN LET l_t_amt2 = 0 END IF
#
#      #no.5195
#      #FOREACH tmp4_cs USING sr.nne04 INTO sr1.*   #MOD-690036
#      FOREACH tmp_cs INTO sr1.*   #MOD-690036
#          SELECT azi05 INTO t_azi05 FROM azi_file           #NO.CHI-6A0004 
#           WHERE azi01 = sr1.curr
#          #LET l_cur='Sub Tot ',sr1.curr,':'   #MOD-690036
#          LET l_cur=g_x[18],sr1.curr,':'   #MOD-690036
#          PRINT COLUMN g_c[31],l_cur,
#                COLUMN g_c[38],cl_numfor(sr1.amt1,38,g_azi05),
#                COLUMN g_c[41],cl_numfor(sr1.amt,41,t_azi05)   #NO.CHI-6A0004 
#      END FOREACH
#      #no.5195(end)
# 
#      #PRINT l_dash[1,g_len]
#      PRINT g_dash2
#      PRINT g_dash[1,g_len]
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN #PRINT g_dash[1,g_len]
#              #TQC-630166
#              #IF tm.wc[001,120] > ' ' THEN			# for 132
# 		# PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#              #IF tm.wc[121,240] > ' ' THEN
# 		# PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#              #IF tm.wc[241,300] > ' ' THEN
# 		# PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#              CALL cl_prt_pos_wc(tm.wc)
#                #END TQC-630166
#
#      END IF
#      #PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_sum = 0
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-830156--------------end----------------------
