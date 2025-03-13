# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr216
# Descriptions...: 集團組織架構明細表
# Date & Author..: 06/04/07 By Elva
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-740129 07/04/24 By sherry 打印結果中，每頁的最后都顯示“結束”資料。
# Modify.........: No.FUN-850061 08/06/24 By Sunyanchun  老報表轉CR 
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm
RECORD						# Print condition RECORD
   	wc              STRING,                 # Where condition No.TQC-630166
	tqc01 		LIKE tqc_file.tqc01,	# 上級組織機構代碼
	more		LIKE type_file.chr1     #No.FUN-680120 VARCHAR(1)			# IF more condition
	END RECORD,
	g_tqc01		LIKE tqc_file.tqc01,
	g_tqb02		LIKE tqb_file.tqb02,
	l_flag 		LIKE type_file.num5,             #No.FUN-680120 SMALLINT
	l_n 		LIKE type_file.num5,             #No.FUN-680120 SMALLINT
	g_end		LIKE type_file.num5,             #No.FUN-680120 SMALLINT
	g_level_end ARRAY[20] OF LIKE type_file.num5     #No.FUN-680120 SMALLINT
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE  g_sql           STRING     #NO.FUN-850061
DEFINE  l_table         STRING     #NO.FUN-850061
DEFINE  g_str           STRING     #NO.FUN-850061
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_pdate 		= ARG_VAL(1)	# Get arguments from command line
   LET g_towhom		= ARG_VAL(2)
   LET g_rlang 		= ARG_VAL(3)
   LET g_bgjob 		= ARG_VAL(4)
   LET g_prtway		= ARG_VAL(5)
   LET g_copies		= ARG_VAL(6)
   LET tm.wc 		= ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(08)
   LET g_rep_clas = ARG_VAL(09)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   #NO.FUN-850061-----BEGIN------
   LET g_sql = "g_tqc01.tqc_file.tqc01,",
                "g_tqb02.tqb_file.tqb02,",
                "tqd02.tqd_file.tqd02,",
                "tqd03.tqd_file.tqd03,",
                "tqb02.tqb_file.tqb02,",
                "tqd01.tqd_file.tqd01,",
                "p_level.type_file.num5"
   LET l_table = cl_prt_temptable('atmr216',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?, ?, ?, ?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-850061------END-------
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r216_tm(0,0)	        	# Input print condition
      ELSE CALL atmr216()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
FUNCTION r216_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE 	p_row,p_col	LIKE type_file.num5,             #No.FUN-680120 SMALLINT
                l_flag		LIKE type_file.num5,             #No.FUN-680120 SMALLINT
                l_one		LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
                l_bdate		LIKE type_file.dat,              #No.FUN-680120 DATE
                l_edate		LIKE type_file.dat,              #No.FUN-680120 DATE
                l_tqc01		LIKE tqc_file.tqc01,
                l_cmd		LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(1000)
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW r216_w AT p_row,p_col
        WITH FORM "atm/42f/atmr216"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		# Default condition
   LET tm.more    = "N"	
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tqc01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP #FUN-4B0001
            IF INFIELD(tqc01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_tqb"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tqc01
               NEXT FIELD tqc01
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
      LET INT_FLAG = 0 CLOSE WINDOW r216_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='atmr216'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('atmr216','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('atmr216',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r216_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         END IF
   CALL cl_wait()
   CALL atmr216()
   ERROR ""
END WHILE
   CLOSE WINDOW r216_w
END FUNCTION
 
FUNCTION atmr216()
   DEFINE l_name	LIKE type_file.chr20,           #No.FUN-680120 VARCHAR(20)		# External(Disk) file name
#       l_time          LIKE type_file.chr8	    #No.FUN-6B0014
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680120 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
          l_za05	LIKE ima_file.ima01,          #No.FUN-680120 VARCHAR(40) 
	  p_level	LIKE type_file.num5,          #No.FUN-680120 SMALLINT	
          sr               RECORD
				tqd02	LIKE tqd_file.tqd02,
				tqd03	LIKE tqd_file.tqd03,
				tqb02	LIKE tqb_file.tqb02 
	END RECORD,
          sr_null               RECORD
				tqd02	LIKE tqd_file.tqd02,
				tqd03	LIKE tqd_file.tqd03,
				tqb02	LIKE tqb_file.tqb02 
	END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'atmr216'
     IF g_len = 0 OR cl_null(g_len) THEN LET g_len = 75 END IF
     FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tqcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tqcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND tqcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tqcuser', 'tqcgrup')
     #End:FUN-980030
 
        LET l_sql = "SELECT tqc01,tqb02 ",
                    " FROM tqc_file, tqb_file",
                    " WHERE ",tm.wc CLIPPED,
                    " AND tqc01=tqb01" 
     PREPARE r216_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
           
     END IF
     DECLARE r216_curs1 CURSOR FOR r216_prepare1
	INITIALIZE sr_null.* TO NULL
     #CALL cl_outnam('atmr216') RETURNING l_name    #NO.FUN-850061
     #START REPORT r216_rep TO l_name               #NO.FUN-850061
     CALL cl_del_data(l_table)                      #NO.FUN-850061
     LET g_pageno = 1
     LET p_level = 0
     FOREACH r216_curs1 INTO sr.tqd03,sr.tqb02
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_tqc01 = sr.tqd03
       LET g_tqb02 = sr.tqb02
       LET g_pageno = 0
       #OUTPUT TO REPORT r216_rep(p_level,sr.*)          #NO.FUN-850061
       #OUTPUT TO REPORT r216_rep(p_level+1,sr_null.*)   #NO.FUN-850061
       LET g_end = 0
       CALL r216_bom(0,sr.tqd03) 
       LET g_end = 1	
     END FOREACH	
     #NO.FUN-850061---begin----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'tqc01')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF
     LET g_str = tm.wc,";",g_towhom
     CALL cl_prt_cs3('atmr216','atmr216',g_sql,g_str)
     #FINISH REPORT r216_rep     
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   
     #NO.FUN-850061-----end-----
END FUNCTION
 
FUNCTION r216_bom(p_level,p_key) 
	DEFINE	p_level LIKE type_file.num5,             #No.FUN-680120 SMALLINT
                p_total	LIKE feb_file.feb10,             #No.FUN-680120 DECIMAL(10,2)
                p_key	LIKE tqc_file.tqc01,
                l_ac,i,j    LIKE type_file.num5,         #No.FUN-680120 SMALLINT
                l_total     LIKE type_file.num5,         #No.FUN-680120 SMALLINT
                l_time      LIKE type_file.num5,         #No.FUN-680120 SMALLINT
                l_count     LIKE type_file.num5,         #No.FUN-680120 SMALLINT
                arr_size    LIKE type_file.num5,         #No.FUN-680120 SMALLINT
                begin_no    LIKE type_file.num5,         #No.FUN-680120 SMALLINT
                l_chr	    LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
                l_sql       LIKE type_file.chr1000,      #No.FUN-680120 VARCHAR(1000)
                sr DYNAMIC ARRAY OF RECORD
                   tqd01        LIKE tqd_file.tqd01,     #NO.FUN-850061
                   tqd02	LIKE tqd_file.tqd02,
                   tqd03	LIKE tqd_file.tqd03,
                   tqb02	LIKE tqb_file.tqb02 
                END RECORD
	INITIALIZE sr[600].* TO NULL
        LET l_sql="SELECT tqd01,tqd02,tqd03,tqb02",       #NO.FUN-850061
	          "  FROM tqd_file,tqb_file",
	          " WHERE tqd01 = '",p_key,"' AND tqb01 = tqd03 ",
	          " ORDER BY tqd02"
        PREPARE bom_prepare FROM l_sql
        IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
          EXIT PROGRAM
        END IF
       	DECLARE bom_cs CURSOR FOR bom_prepare
        LET p_level = p_level + 1
        IF p_level > 20 THEN RETURN END IF
        LET l_count = 1
	FOREACH bom_cs INTO sr[l_count].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('bom_cs',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           LET	l_count = l_count + 1
	END FOREACH			
        LET l_count = l_count - 1
        LET g_level_end[p_level] = 0
	FOR i = 1 TO l_count
          IF l_count = i THEN LET g_level_end[p_level] = 1 END IF
          #NO.FUN-850061---begin-----
          #OUTPUT TO REPORT r216_rep(p_level,sr[i].*)               
          EXECUTE insert_prep USING g_tqc01,g_tqb02,sr[i].tqd02,
                                    sr[i].tqd03,sr[i].tqb02,
                                    sr[i].tqd01,p_level           
          #NO.FUN-850061----end------
          SELECT tqc01 FROM tqc_file
                       WHERE tqc01 = sr[i].tqd03
          IF status != NOTFOUND THEN
             #NO.FUN-850061----BEGIN----
             #OUTPUT TO REPORT r216_rep(p_level+1,sr[600].*)
             #NO.FUN-850061-----END-----
             CALL r216_bom(p_level,sr[i].tqd03) 
          END IF
	END FOR
END FUNCTION
#NO.FUN-850061-----BEING----			
#REPORT r216_rep(sr)
#DEFINE l_last_sw	LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#      sr               RECORD
#       			p_level LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#       			tqd02	LIKE tqd_file.tqd02,
#       			tqd03	LIKE tqd_file.tqd03,
#       			tqb02	LIKE tqb_file.tqb02 
#       END RECORD ,
#       l_col,i      LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF cl_null(g_towhom) OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#       	SKIP 1 LINES
#       	LET g_pageno =g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#       	SKIP 1 LINES
#     LET l_last_sw = 'y'
#     PRINT g_tqc01 CLIPPED,'   ',g_tqb02
#       
#  ON EVERY ROW
 
#     IF sr.p_level = 0 THEN
#        SKIP TO TOP OF PAGE
#     ELSE
# 	 FOR i = 1 to (sr.p_level - 1)
#   	     IF g_level_end[i] THEN
#       	PRINT COLUMN (4 * i ), '  '  CLIPPED;
#            ELSE
#       	PRINT COLUMN (4 * i ),g_x[13] CLIPPED;
#            END IF
#        END FOR
#        LET i = sr.p_level
#        IF cl_null(sr.tqd03) THEN
#    	    PRINT COLUMN ( sr.p_level * 4 ) CLIPPED,g_x[13]
#        ELSE IF g_level_end[i]  THEN
#     	         PRINT COLUMN ( sr.p_level * 4) CLIPPED,g_x[14] CLIPPED;
#             ELSE
#     		 PRINT COLUMN ( sr.p_level * 4) CLIPPED,g_x[15] CLIPPED;
#             END IF
#             PRINT sr.tqd02 USING '<<<<' CLIPPED,g_x[16] CLIPPED,
#       			sr.tqd03 CLIPPED,'  ',sr.tqb02 CLIPPED  
#        END IF
#     END IF
 
#  ON LAST ROW
#  #  LET l_last_sw = 'y'   #No.TQC-740129
#     IF g_zz05 = 'Y' THEN     
#        CALL cl_wcchp(tm.wc,'tqc01') RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#        CALL cl_prt_pos_wc(tm.wc)
#     END IF
#    PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'n'    #No.TQC-740129
 
#  PAGE TRAILER
#    IF l_last_sw = 'y'       #No.TQC-740129
#    THEN 
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#    ELSE
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#    END IF
#END REPORT
#NO.FUN-850061-----END-----
#No.FUN-870144
