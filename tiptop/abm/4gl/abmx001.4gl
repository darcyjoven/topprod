# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: abmx001.4gl
# Descriptions...: 產品結構表(如 BOM 多階展開清單)
# Input parameter:
# Return code....:
# Date & Author..: 94/07/25 By Nick
# Modify.........: No.FUN-4B0001 04/11/03 By Smapmin 主件料件開窗
# Modify.........: No.FUN-550095 05/05/24 By Mandy 特性BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-630096 06/04/03 By Claire BOM 元件若失效不可印出下階料
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/14 By baogui   報表問題修改
# Modify.........: No.TQC-740125 07/04/18 By Rayven abmi600里若料件維護了特性代碼，只能單階展開
# Modify.........: No.MOD-750098 07/05/28 By pengu 組成用量列印時應列印至小數5位
# Modify.........: No.TQC-8C0063 08/12/30 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-CB0145 08/12/30 By jan 下階料展BOM時，特性代碼抓ima910 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm
RECORD						# Print condition RECORD
   	wc              STRING,                 # Where condition No.TQC-630166
	bma01 		LIKE bma_file.bma01,	# 主件料號 	
	bma06 		LIKE bma_file.bma06,	# FUN-550095 add
	ima06		LIKE ima_file.ima06,	# 主件分群碼範圍
	version 	LIKE type_file.chr2,    #No.FUN-680096 VARCHAR(2)
	eff_date	LIKE type_file.dat,     #No.FUN-680096 DATE
	x       	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
	more		LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
	END RECORD,
 
	g_bma01		LIKE bma_file.bma01,
	g_bma06		LIKE bma_file.bma06,    #FUN-550095 add
	g_ima02		LIKE ima_file.ima02,
	l_flag 		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
	l_n 		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
	g_end		LIKE type_file.num5,    #No.FUN-680096 SMALLINT
	g_level_end ARRAY[20] OF LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose   #No.FUN-680096 SMALLINT
DEFINE g_id,g_pid       LIKE type_file.num5 #XtraGrid Demo
DEFINE g_sql            STRING
DEFINE l_table          STRING  #FUN-CB0145   FUN-CB0145  FUN-CB0145   FUN-CB0145
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107
 
 
   LET g_pdate 		= ARG_VAL(1)	# Get arguments from command line
   LET g_towhom		= ARG_VAL(2)
   LET g_rlang 		= ARG_VAL(3)
   LET g_bgjob 		= ARG_VAL(4)
   LET g_prtway		= ARG_VAL(5)
   LET g_copies		= ARG_VAL(6)
   LET tm.wc 		= ARG_VAL(7)
   LET tm.version	= ARG_VAL(8)
   LET tm.eff_date	= ARG_VAL(9)
   LET tm.x		= ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
 
  #XtraGrid Demo -----------------------------(S) #FUN-CB0145
       LET g_sql ="bmb02.bmb_file.bmb02,",
                  "bmb03.bmb_file.bmb03,",
                  "bmb06.bmb_file.bmb06,",
                  "bmb07.bmb_file.bmb07,",
                  "ima02.ima_file.ima02,",
                  "ima910.ima_file.ima910,",
                  "id.type_file.num10,",
                  "pid.type_file.num10"
   LET l_table = cl_prt_temptable('axmr600',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
  #XtraGrid Demo -----------------------------(E)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL x001_tm(0,0)	        	# Input print condition
      ELSE CALL abmx001()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN
 
FUNCTION x001_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_flag	      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
       l_one	      LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
       l_bdate	      LIKE type_file.dat,     #No.FUN-680096 DATE
       l_edate	      LIKE type_file.dat,     #No.FUN-680096 DATE
       l_bma01	      LIKE bma_file.bma01,
       l_cmd	      LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 4 LET p_col =14 END IF			
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
  #FUN-CB0145
  #FUN-CB0145
  #FUN-CB0145
  #FUN-CB0145
  #FUN-CB0145
   OPEN WINDOW x001_w AT p_row,p_col
        WITH FORM "abm/42f/abmx001"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		# Default condition
   LET tm.eff_date=g_today
   LET tm.x       = 99
   LET tm.more    = "N"	
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bma01,bma06,ima06 #FUN-550095 add
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP #FUN-4B0001
            IF INFIELD(bma01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bma4"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bma01
               NEXT FIELD bma01
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
      LET INT_FLAG = 0 CLOSE WINDOW x001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
#UI
   INPUT BY NAME tm.version,tm.eff_date,tm.x,
				 tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      BEFORE FIELD version
         IF l_one='N' THEN
            NEXT FIELD eff_date
         END IF
      AFTER FIELD x
         IF cl_null(tm.x) THEN NEXT FIELD x END IF
         IF tm.x <=0 then next field x end if
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
	IF INT_FLAG THEN EXIT INPUT END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      LET INT_FLAG = 0 CLOSE WINDOW x001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmx001'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('abmx001','9031',1)
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
                         " '",tm.version CLIPPED,"'",
                         " '",tm.eff_date CLIPPED,"'",
                         " '",tm.x CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('abmx001',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW x001_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM
         END IF
   CALL cl_wait()
   CALL abmx001()
   ERROR ""
END WHILE
   CLOSE WINDOW x001_w
END FUNCTION
 
FUNCTION abmx001()
   DEFINE l_name	LIKE type_file.chr20,   #No.FUN-680096 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0060
          l_sql 	LIKE type_file.chr1000, # RDSQL STATEMENT    #No.FUN-680096 VARCHAR(1000)
          l_chr		LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
          l_za05	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(40)
 	  p_level	LIKE type_file.num5,    #No.FUN-680096 SMALLINT
          l_bmb06       LIKE bmb_file.bmb06,  #XtraGrid Demo
          l_bmb07       LIKE bmb_file.bmb07,  #XtraGrid Demo
          l_ima910      LIKE ima_file.ima910, #XtraGrid Demo
          sr               RECORD
				bmb02	LIKE bmb_file.bmb02,
				bmb03	LIKE bmb_file.bmb03,
				ima02	LIKE ima_file.ima02,
				lc_qty,lb_qty   LIKE cae_file.cae07  #No.FUN-680096 DEC(15,5)
	END RECORD,
          sr_null               RECORD
				bmb02	LIKE bmb_file.bmb02,
				bmb03	LIKE bmb_file.bmb03,
				ima02	LIKE ima_file.ima02,
				lc_qty,lb_qty	LIKE cae_file.cae07  #No.FUN-680096 DEC(15,5)
	END RECORD
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmx001'
#     IF g_len = 0 OR cl_null(g_len) THEN LET g_len = 75 END IF
     LET g_len = 90
     FOR  g_i = 1 TO 90 LET g_dash[g_i,g_i] = '=' END FOR
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
     #End:FUN-980030
 
        LET l_sql = "SELECT bma01,ima02,bma06 ", #FUN-550095 add bma06
                    " FROM bma_file, ima_file",
                    " WHERE ",tm.wc CLIPPED,
                    " AND bma01=ima01",
                    " AND bmaacti='Y'",   #FUN-630096
                    " AND ima08 !='A'"
     PREPARE x001_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
        EXIT PROGRAM
           
     END IF
     DECLARE x001_curs1 CURSOR FOR x001_prepare1
	INITIALIZE sr_null.* TO NULL
#    CALL cl_outnam('abmx001') RETURNING l_name
#START REPORT x001_rep TO l_name
     LET g_pageno = 1
     LET p_level = 0
     LET g_id = 0
     LET g_pid = NULL
     FOREACH x001_curs1 INTO sr.bmb03,sr.ima02,g_bma06 #FUN-550095 add
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01	= sr.bmb03
       LET g_ima02 = sr.ima02
       LET g_pageno = 0
     # XtraGrid Demo
     # OUTPUT TO REPORT x001_rep(p_level,sr.*)
     # OUTPUT TO REPORT x001_rep(p_level+1,sr_null.*)
       LET l_ima910 = NULL
       SELECT ima910 INTO l_ima910
         FROM ima_file WHERE ima01 = sr.bmb03
       LET g_id = g_id + 1
       EXECUTE insert_prep USING
         sr_null.bmb02,sr.bmb03,l_bmb06,l_bmb07,
         sr.ima02,l_ima910,g_id,g_pid
     #
     # XtraGrid Demo
       LET g_end = 0
       IF cl_null(g_bma06) THEN LET g_bma06 = ' ' END IF #FUN-550095 add
       # Prog. Version..: '5.30.07-13.05.16(0,sr.bmb03,g_bma06) #FUN-550095 add g_bma06
       CALL x001_bom(0,sr.bmb03,g_bma06,g_id) #XtraGrid Demo
       LET g_end = 1	
     END FOREACH	
 #FINISH REPORT x001_rep
 #    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_xgrid.table = l_table
     LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
     CALL cl_xg_view()
END FUNCTION
 
#FUNCTION x001_bom(p_level,p_key,p_key2) #FUN-550014 add p_key2
FUNCTION x001_bom(p_level,p_key,p_key2,p_pid) #FUN-550014 add p_key2
DEFINE p_pid   LIKE type_file.num10 #XtraGrid Demo
	DEFINE	p_level     LIKE type_file.num5,    #No.FUN-680096 SMALLINT
                p_total	    LIKE feb_file.feb10,    #No.FUN-680096 DEC(10,2)
                p_key	    LIKE bma_file.bma01,
                p_key2	    LIKE bma_file.bma06,    #FUN-550014 add p_key2
                l_ac,i,j    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
                l_total     LIKE type_file.num5,    #No.FUN-680096 SMALLINT 
                l_time      LIKE type_file.num5,    #No.FUN-680096 SMALLINT
                l_count     LIKE type_file.num5,    #No.FUN-680096 SMALLINT
                arr_size    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
                begin_no    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
                l_chr	    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
                l_sql       LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(1000)
                sr DYNAMIC ARRAY OF RECORD
                   bmb02	LIKE bmb_file.bmb02,
                   bmb03	LIKE bmb_file.bmb03,
                   ima02	LIKE ima_file.ima02,
                   lc_qty,lb_qty	LIKE cae_file.cae07  #No.FUN-680096 DEC(15,5)
                END RECORD
        DEFINE  l_bma06         LIKE bma_file.bma06 #No.TQC-740125
        DEFINE  l_ima910        DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.TQC-8C0063 
 
	INITIALIZE sr[600].* TO NULL
        IF cl_null(tm.eff_date) THEN
           LET l_sql="SELECT bmb02,bmb03,ima02,bmb06,bmb07,''",
		     "  FROM bmb_file,ima_file",
	             " WHERE bmb01 = '",p_key,"' AND ima01 = bmb03 ",
                     "   AND bmb29 = '",p_key2,"'", #FUN-550095 add
	             " ORDER BY bmb02"
        ELSE
           LET l_sql="SELECT bmb02,bmb03,ima02,bmb06,bmb07,''",
		     "  FROM bmb_file,ima_file",
	             " WHERE bmb01 = '",p_key,"' AND ima01 = bmb03 ",
                     "   AND bmb29 = '",p_key2,"'", #FUN-550095 add
                     " AND (bmb04 <='",tm.eff_date,"' OR bmb04 IS NULL) ",
                     " AND (bmb05 > '",tm.eff_date,"' OR bmb05 IS NULL) ",
	             " ORDER BY bmb02"
        END IF
 
        PREPARE bom_prepare FROM l_sql
        IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
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
           #TQC-8C0063--BEGIN--
           LET l_ima910[l_count]=''
           SELECT ima910 INTO l_ima910[l_count] FROM ima_file WHERE ima01=sr[l_count].bmb03
           IF cl_null(l_ima910[l_count]) THEN LET l_ima910[l_count]=' ' END IF
           #TQC-8C0063--END--
           LET	l_count = l_count + 1
	END FOREACH			
        LET l_count = l_count - 1
        LET g_level_end[p_level] = 0
      #FUN-CB0145
	FOR i = 1 TO l_count
          IF l_count = i THEN LET g_level_end[p_level] = 1 END IF
       #XtraGrid Demo---------(S)
         #OUTPUT TO REPORT x001_rep(p_level,sr[i].*)
          LET g_id = g_id + 1
          EXECUTE insert_prep USING
            sr[i].bmb02,sr[i].bmb03,sr[i].lc_qty,
            sr[i].lb_qty,sr[i].ima02,l_ima910[i],g_id,p_pid
       #XtraGrid Demo---------(E)
          SELECT bma01 FROM bma_file
                       WHERE bma01 = sr[i].bmb03
          IF status != NOTFOUND AND p_level < tm.x THEN
            #OUTPUT TO REPORT x001_rep(p_level+1,sr[600].*)
             #No.TQC-740125 --start--
#            CALL x001_bom(p_level,sr[i].bmb03,' ') #FUN-550095 add #No.TQC-740125 mark
             SELECT bma06 INTO l_bma06 FROM bma_file
              WHERE bma01 = sr[i].bmb03
             IF cl_null(l_bma06) THEN LET l_bma06 = ' ' END IF
            #CALL x001_bom(p_level,sr[i].bmb03,l_bma06)  #TQC-8C0063
             #CALL x001_bom(p_level,sr[i].bmb03,l_ima910[i])  #TQC-8C0063
             CALL x001_bom(p_level,sr[i].bmb03,l_ima910[i],g_id) #XtraGrid Demo
             #No.TQC-740125 --end--
          END IF
	END FOR
END FUNCTION
			
REPORT x001_rep(sr)
DEFINE l_last_sw	LIKE type_file.chr1,     #No.FUN-680096 VARCHAR(1)
       sr               RECORD    
				p_level LIKE type_file.num5,    #No.FUN-680096 SMALLINT
				bmb02	LIKE bmb_file.bmb02,
				bmb03	LIKE bmb_file.bmb03,
				ima02	LIKE ima_file.ima02,
				lc_qty,lb_qty	LIKE cae_file.cae07 #No.FUN-680096 DEC(15,5)
	END RECORD ,
	l_col,i      LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  FORMAT
   PAGE HEADER
      PRINT (90-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED     #TQC-6A0081
      IF cl_null(g_towhom) OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (90-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED      #TQC-6A0081
      PRINT (90-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED     #TQC-6A0081
		SKIP 1 LINES
		LET g_pageno =g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,' ',g_x[11] CLIPPED,
	  		tm.eff_date,'  ',g_x[12] CLIPPED,tm.version,
            COLUMN 90-7,g_x[3] CLIPPED,g_pageno USING '<<<'     #TQC-6A0081
		SKIP 1 LINES
      LET l_last_sw = 'n'
		PRINT g_bma01 CLIPPED,' ',g_bma06,'  (',g_ima02,')' #FUN-550095 add g_bma06
	
   ON EVERY ROW
 
IF sr.p_level = 0 THEN
			SKIP TO TOP OF PAGE
			
ELSE
			FOR i = 1 to (sr.p_level - 1)
				IF g_level_end[i] THEN
					PRINT COLUMN (4 * i ), '  '  CLIPPED;
									  ELSE
					PRINT COLUMN (4 * i ),g_x[13] CLIPPED;
				END IF
			END FOR
		LET i = sr.p_level
   IF cl_null(sr.bmb03) THEN
   		PRINT COLUMN ( sr.p_level * 4 ) CLIPPED,g_x[13]
   ELSE IF g_level_end[i]  THEN
      		PRINT COLUMN ( sr.p_level * 4) CLIPPED,g_x[14] CLIPPED;
							  ELSE
      		PRINT COLUMN ( sr.p_level * 4) CLIPPED,g_x[15] CLIPPED;
		END IF
	  		PRINT sr.bmb02 USING '<<<<' CLIPPED,g_x[16] CLIPPED,
					sr.bmb03 CLIPPED,'  ',
            		'(',sr.ima02 CLIPPED ,') *';
		IF sr.lb_qty > 1 THEN
## No:2371 modify 1998/07/16 ----------------------
                   PRINT sr.lc_qty USING "###&.&&&&&" CLIPPED,       #MOD-750098 modify   
			'/' CLIPPED , sr.lb_qty USING "###&.&&&&&"   #MOD-750098 modify
		 ELSE
                   PRINT sr.lc_qty USING "###&.&&&&&" CLIPPED        #MOD-750098 modify
### -----------------------------------------------
		END IF
        IF g_level_end[i]  THEN
			FOR i = 1 to (sr.p_level - 1)
				IF g_level_end[i] THEN
					PRINT COLUMN (4 * i ), '  '  CLIPPED;
									  ELSE
					PRINT COLUMN (4 * i ),g_x[13] CLIPPED;
				END IF
			END FOR
			PRINT
		END IF
   END IF
END IF
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
IF g_end = 0 AND l_last_sw = 'n'
   THEN # PRINT g_dash[1,g_len]
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (90-9), g_x[6] CLIPPED   #TQC-6A0081
   ELSE
    #  IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
    #     CALL cl_wcchp(tm.wc,'bma01')
    #          RETURNING tm.wc
    #     LET tm.wc= tm.wc CLIPPED
    #     PRINT g_dash[1,g_len]
	#	IF tm.wc[001,75] > ' ' THEN            # for 132
	#		PRINT g_x[8] CLIPPED,tm.wc[001,75] CLIPPED
	#	END IF
	#	IF tm.wc[076,150] > ' ' THEN            # for 132
	#		PRINT g_x[8] CLIPPED,tm.wc[076,150] CLIPPED
	#	END IF
    #  END IF
    #  PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (90-9), g_x[7] CLIPPED   #TQC-6A0081
END IF
END REPORT
#Patch....NO.TQC-610035 <001> #
