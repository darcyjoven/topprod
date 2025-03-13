# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abmr002.4gl
# Descriptions...: 產品結構表(如 BOM 多階展開清單)
# Input parameter: 
# Return code....: 
# Date & Author..: 94/07/25 By Nick 
# Modify.........: No.FUN-4B0001 04/11/03 By Smapmin 主件料件開窗
# Modify FOR CUST: 05/10/11 By DSC(台北) Yvonne 加上簽核欄
# Modify.........: 2005/11/20 By Jacken 新增欄位及調整報表格式
# Modify.........: No.FUN-6C0009 06/12/12 by rainy abmr001->掛成abmr002
# Modify.........: No.TQC-740149 07/04/20 By chenl 增加列印時對不同單位的換算。
# Modify.........: No.TQC-740145 07/04/23 By johnray 報表打印格式問題
# Modify.........: No.TQC-740149 07/05/08 By chenl 修改報表格式
# Modify.........: No.MOD-780075 07/09/20 By pengu 列印時會現"select temp:一個子查詢傳回了不只一列"錯誤訊息
# Modify.........: No.FUN-850061 08/05/14 By baofei 報表打印改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.MOD-880106 08/08/14 By claire 修改模組名
# Modify.........: No.MOD-880233 08/08/30 By Pengu CR報表在儲存組成用量的變數型態設錯
# Modify.........: No.CHI-890013 08/09/19 By claire 記錄每個BOM第二階的料件為KEY做為CR排序用
# Modify.........: No.MOD-8A0007 08/10/03 By claire 記錄每筆寫入temp的順序,供CR排序
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40040 10/04/09 By Summer FUN-8B0015需增加AND bma06=l_ima910[i]條件
# Modify.........: No:MOD-A60011 10/06/03 By Sarah BOM主件若失效不可印出
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-C50120 12/05/15 By fengrui 抓BOM資料時，除去無效資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm           RECORD
   	wc		LIKE type_file.chr1000,	# Where condition
	bma01 		LIKE bma_file.bma01,	# 主件料號 	
        bma06           LIKE bma_file.bma06,    # 特性代碼  #No.MOD-780075 add
	ima06		LIKE ima_file.ima06,	# 主件分群碼範圍
	version         LIKE type_file.chr2,		# Version of PRINT
	eff_date	DATE,		        # 有效日期(BOM)
	x       	LIKE type_file.num5,    #SMALLINT,	        # Level
	more	        LIKE type_file.chr1	# IF more condition
	END RECORD,
	g_bma01		LIKE bma_file.bma01,
	g_bma06		LIKE bma_file.bma06,    #No.MOD-780075 add
	g_ima02		LIKE ima_file.ima02,
	g_ima021	LIKE ima_file.ima021,
	l_flag 		LIKE type_file.num5,    #SMALLINT,
	l_n	        LIKE type_file.num5,    #SMALLINT,
	l_no	        LIKE type_file.num5,    #MOD-8A0007 
	g_end		LIKE type_file.num5,    #SMALLINT,
	g_level_end ARRAY[20] OF LIKE type_file.num5 #SMALLINT
 
DEFINE   g_i             LIKE type_file.num5   #SMALLINT   #count/index for any purpose
#FUN-6C0009
#No.FUN-850061---Begin                                                                                                              
DEFINE l_table    STRING                                                                                                            
DEFINE g_str      STRING                                                                                                            
DEFINE g_sql      STRING                                                                                                            
#No.FUN-850061---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   #051011 By DSC Yvonne
   IF (NOT cl_setup("ABM")) THEN    #MOD-880106 cancel mark
   #IF (NOT cl_setup("CBM")) THEN   #MOD-880106 mark
      EXIT PROGRAM
   END IF
 
#No.FUN-850061---Begin                                                                                                              
   LET g_sql = "g_bma01.bma_file.bma01,",                                                                                           
               "g_bma06.bma_file.bma06,",                                                                                             
               "g_ima02.ima_file.ima02,",                                                                                             
               "g_ima021.ima_file.ima021,",
               "bmb03.bmb_file.bmb03,",
               "bmb02.bmb_file.bmb02,",
               "l_ima05.ima_file.ima05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "p_level.type_file.num5,",
               "lb_qty.type_file.num20_6,",      #No.MOD-880233 modify
               "lc_qty.type_file.num20_6,",      #No.MOD-880233 modify
               "bmb10.bmb_file.bmb10,", 
               "bmb19.bmb_file.bmb19,",
               "bmb01.bmb_file.bmb01,", 
               "l_bmb01.bmb_file.bmb01,",        #CHI-890013  add
               "l_bmb02.bmb_file.bmb02,",        #CHI-890013  add
               "l_no.type_file.num5,",           #MOD-8A0007  add
               "g_sma118.sma_file.sma118"                                                               
                                                                                                
   LET l_table = cl_prt_temptable('abmr002',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "   #CHI-890013 add ?,?   #MOD-8A0007 add ?                                                                                               
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                         
#No.FUN-850061---End    
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

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r002_tm(0,0)	        	# Input print condition
      ELSE CALL abmr002()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION r002_tm(p_row,p_col)
   DEFINE 	p_row,p_col	LIKE type_file.num5,   #SMALLINT,	
                l_flag		LIKE type_file.num5,   #SMALLINT,
                l_one	        LIKE type_file.chr1,    #CHAR(01)
                l_bdate		LIKE type_file.dat,    #DATE,		
                l_edate		LIKE type_file.dat,    #DATE,	
                l_bma01		LIKE bma_file.bma01,
                l_cmd	        LIKE type_file.chr1000  #CHAR(1000)
   IF p_row = 0 THEN LET p_row = 4 LET p_col =14 END IF			
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r002_w AT p_row,p_col
        WITH FORM "abm/42f/abmr002" 
################################################################################
# START genero shell script ADD
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')   #No.MOD-780075 add
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
      CONSTRUCT BY NAME tm.wc ON bma01,bma06,ima06    #No.MOD-780075 add bma06
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
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION controlg      #BUG-4C0121
        CALL cl_cmdask()     #BUG-4C0121
 
   
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r002_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
#UI
   INPUT BY NAME tm.version,tm.eff_date,tm.x,
				 tm.more WITHOUT DEFAULTS 
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
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
   
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r002_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr002'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('abmr002','9031',1)
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
                         " '",tm.x CLIPPED,"'"
         CALL cl_cmdat('abmr002',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r002_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr002()
   ERROR ""
END WHILE
   CLOSE WINDOW r002_w
END FUNCTION
   
FUNCTION abmr002()
   DEFINE l_name   LIKE type_file.chr20,     #CHAR(20),		# External(Disk) file name
          l_time   LIKE type_file.chr8,      #CHAR(8),		# Used time for running the job
          l_sql    LIKE type_file.chr1000,   #CHAR(1000),		# RDSQL STATEMENT
          l_chr	   LIKE type_file.chr1,      #CHAR(1),
	  p_level  LIKE type_file.num5,      #SMALLINT,	
          sr               RECORD  
				bmb02	LIKE bmb_file.bmb02,
				bmb03	LIKE bmb_file.bmb03,
                                bmb29   LIKE bmb_file.bmb29,  #No.MOD-780075 add
				ima02	LIKE ima_file.ima02,
				lc_qty,lb_qty   LIKE type_file.num20_6,  #decimal(9,5),
				ima021	LIKE ima_file.ima021,
                                bmb10   LIKE bmb_file.bmb10,
                                bmb01   LIKE bmb_file.bmb01,
                                bmb19   LIKE bmb_file.bmb19
	END RECORD, 
          sr_null               RECORD  
				bmb02	LIKE bmb_file.bmb02,
				bmb03	LIKE bmb_file.bmb03,
                                bmb29   LIKE bmb_file.bmb29,  #No.MOD-780075 add
				ima02	LIKE ima_file.ima02,
				lc_qty,lb_qty	LIKE type_file.num20_6,  #decimal(9,5),
				ima021	LIKE ima_file.ima021,
                                bmb10   LIKE bmb_file.bmb10,
                                bmb01   LIKE bmb_file.bmb01,
                                bmb19   LIKE bmb_file.bmb19
	END RECORD 
 
       #No.TQC-740149--begin--
        DROP TABLE abmr002_tmp
        #MOD-A40040 mod VARCHAR --start-- 
        CREATE TEMP TABLE abmr002_tmp
        (bmb01      LIKE bmb_file.bmb01, 
         bmb29      LIKE bmb_file.bmb29,     #No.MOD-780075 add
         bmb03      LIKE bmb_file.bmb03, 
         bmb06      LIKE bmb_file.bmb06, 
         bmb10      LIKE bmb_file.bmb10, 
         ima55      LIKE ima_file.ima55  )
        #MOD-A40040 mod --end-- 
       #No.TQC-740149--end--
      
     #No.FUN-B80100--mark--Begin---
     #CALL cl_used('abmr002',l_time,1) RETURNING l_time
     #No.FUN-B80100--mark--End-----
     CALL cl_del_data(l_table)      #No.FUN-850061
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr002'
     IF g_len = 0 OR cl_null(g_len) THEN LET g_len = 160 END IF
     FOR  g_i = 1 TO g_len LET g_dash[g_i,g_i] = '-' END FOR
#    FOR  g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR     #No.TQC-740145
     FOR  g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR     #No.TQC-740145
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND bmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     LET l_sql = "SELECT bma01,bma06,ima02,ima021 ",    #No.MOD-780075 add bma06
                 " FROM bma_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 " AND bma01=ima01",
                 " AND bmaacti='Y'",   #MOD-A60011 add
                 " AND ima08 !='A'"
     PREPARE r002_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM 
     END IF
     DECLARE r002_curs1 CURSOR FOR r002_prepare1
     INITIALIZE sr_null.* TO NULL
#    CALL cl_outnam('abmr002') RETURNING l_name        #No.FUN-850061
# START REPORT r002_rep TO l_name                       #No.FUN-850061 
     LET g_pageno = 1 
     LET p_level = 0
     LET l_no = 0      #MOD-8A0007
     FOREACH r002_curs1 INTO sr.bmb03,sr.bmb29,sr.ima02,sr.ima021  #No.MOD-780075 add bmb29
        IF SQLCA.sqlcode != 0 THEN 
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
        LET g_bma01	= sr.bmb03
        LET g_bma06	= sr.bmb29   #No.MOD-780075 add
        LET g_ima02  = sr.ima02
        LET g_ima021 = sr.ima021
        LET g_pageno = 0
#       OUTPUT TO REPORT r002_rep(p_level,sr.*)          #No.FUN-850061
#       OUTPUT TO REPORT r002_rep(p_level+1,sr_null.*)   #No.FUN-850061
        LET g_end = 0
        CALL r002_bom(0,sr.bmb03,sr.bmb29,' ')            #No.MOD-780075 add bmb29   #CHI-890013 add ' '
        LET g_end = 1	
     END FOREACH	
# FINISH REPORT r002_rep                                  #No.FUN-850061
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)         #No.FUN-850061
     LET g_str= g_towhom,";",tm.eff_date,";",tm.version   #No.FUN-850061                                                                                     
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED   #No.FUN-850061                                                            
     CALL cl_prt_cs3('abmr002','abmr002',l_sql,g_str)  #No.FUN-850061
     #No.FUN-B80100--mark--Begin---
     #CALL cl_used('abmr002',l_time,2) RETURNING l_time 
     #No.FUN-B80100--mark--End-----
END FUNCTION
#No.FUN-870144 
   
FUNCTION r002_bom(p_level,p_key,p_key2,p_key3)      #No.MOD-780075 add p_key2   #CHI-890013 add p_key3
	DEFINE	p_level LIKE type_file.num5,        #SMALLINT,
                p_total	LIKE type_file.num20_6,     #DECIMAL(10,2),
                l_bmb01	LIKE bmb_file.bmb01,        #CHI-890013 add
                l_bmb02	LIKE bmb_file.bmb02,        #CHI-890013 add
                p_key	LIKE bma_file.bma01, 
                p_key2  LIKE bma_file.bma06,     #No.MOD-780075 add
                p_key3	LIKE bmb_file.bmb02,        #CHI-890013 add
                l_ac,i,j    LIKE type_file.num5,    #SMALLINT,
                l_total     LIKE type_file.num5,    #SMALLINT,
                l_time      LIKE type_file.num5,    #SMALLINT,
                l_count     LIKE type_file.num5,    #SMALLINT,
                arr_size    LIKE type_file.num5,    #SMALLINT,
                begin_no    LIKE type_file.num5,    #SMALLINT,
                l_chr	    LIKE type_file.chr1,    #CHAR(1),
                l_sql       LIKE type_file.chr1000, #CHAR(1000),
                l_ima05     LIKE ima_file.ima05,    #No.FUN-850061
                l_bmaacti   LIKE bma_file.bmaacti,  #No.TQC-C50120 add
                sr DYNAMIC ARRAY OF RECORD
                   bmb02	LIKE bmb_file.bmb02,
                   bmb03	LIKE bmb_file.bmb03,
                   bmb29        LIKE bmb_file.bmb29,   #No.MOD-780075 add
                   ima02	LIKE ima_file.ima02,
                   lc_qty,lb_qty	LIKE type_file.num20_6,  #decimal(9,5),
		   ima021	LIKE ima_file.ima021,
                   bmb10        LIKE bmb_file.bmb10,
                   bmb01        LIKE bmb_file.bmb01,
                   bmb19        LIKE bmb_file.bmb19
                END RECORD
    DEFINE      l_qty           LIKE bmb_file.bmb06     #No.TQC-740149
    DEFINE      l_ima910        DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
 

        #TQC-C50120--add--str--
        LET l_bmaacti = NULL
        SELECT bmaacti INTO l_bmaacti
          FROM bma_file
         WHERE bma01 = p_key
           AND bma06 = p_key2
        IF l_bmaacti <> 'Y' THEN RETURN END IF
        #TQC-C50120--add--end-- 
	INITIALIZE sr[600].* TO NULL
        IF cl_null(tm.eff_date) THEN
           #051011 By DSC Yvonne
           #LET l_sql="SELECT bmb02,bmb03,ima02,bmb06,bmb07,''",
           LET l_sql="SELECT bmb02,bmb03,bmb29,ima02,bmb06,bmb07,ima021,bmb10,bmb01,bmb19,''",  #No.MOD-780075 modify
		     "  FROM bmb_file,ima_file",
	             " WHERE bmb01 = '",p_key,"' AND ima01 = bmb03 ",
                     "   AND bmb29 = '",p_key2,"' ",   #No.MOD-780075 add
	             " ORDER BY bmb02"
        ELSE
           #051011 By DSC Yvonne
           #LET l_sql="SELECT bmb02,bmb03,ima02,bmb06,bmb07,''",
           LET l_sql="SELECT bmb02,bmb03,bmb29,ima02,bmb06,bmb07,ima021,bmb10,bmb01,bmb19,''",   #No.MOD-780075
		     "  FROM bmb_file,ima_file",
	             " WHERE bmb01 = '",p_key,"' AND ima01 = bmb03 ",
                     "   AND bmb29 = '",p_key2,"' ",   #No.MOD-780075 add
                     " AND (bmb04 <='",tm.eff_date,"' OR bmb04 IS NULL) ",
                     " AND (bmb05 > '",tm.eff_date,"' OR bmb05 IS NULL) ",
	             " ORDER BY bmb02"
        END IF
         
        PREPARE bom_prepare FROM l_sql
        IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
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
          #----------No.MOD-780075 mark
          ##No.TQC-740149--begin-- 
          #IF p_level > 1 THEN
          #   CALL r002_qty(p_level,p_key,sr[l_count].bmb03,sr[l_count].lc_qty,sr[l_count].bmb10) 
          #        RETURNING l_qty 
          #   LET sr[l_count].lc_qty = l_qty
          #END IF 
          ##No.TQC-740149--end--
          #----------No.MOD-780075 end
           #FUN-8B0015--BEGIN--                                                                                                     
           LET l_ima910[l_count]=''
           SELECT ima910 INTO l_ima910[l_count] FROM ima_file WHERE ima01=sr[l_count].bmb03
           IF cl_null(l_ima910[l_count]) THEN LET l_ima910[l_count]=' ' END IF
           #FUN-8B0015--END--
           LET	l_count = l_count + 1
	END FOREACH			
        LET l_count = l_count - 1
        LET g_level_end[p_level] = 0
	FOR i = 1 TO l_count
          IF l_count = i THEN LET g_level_end[p_level] = 1 END IF
#          OUTPUT TO REPORT r002_rep(p_level,sr[i].*)
          SELECT ima05 INTO l_ima05 FROM ima_file WHERE ima01=sr[i].bmb03   #No.FUN-850061
          ##CHI-890013-begin-add
          IF p_level = 1 THEN 
             LET l_bmb01 = sr[i].bmb03
             LET l_bmb02 = sr[i].bmb02
          ELSE 
             LET l_bmb01 = p_key
             LET l_bmb02 = p_key3
          END IF 
          ##CHI-890013-end-add
          LET l_no = l_no + 1   #MOD-8A0007 
          EXECUTE  insert_prep USING g_bma01,g_bma06,g_ima02,g_ima021,sr[i].bmb03,sr[i].bmb02,l_ima05,sr[i].ima02,sr[i].ima021,
                   p_level,sr[i].lb_qty,sr[i].lc_qty,sr[i].bmb10,sr[i].bmb19,sr[i].bmb01,l_bmb01,l_bmb02,l_no,g_sma.sma118      #No.FUN-850061  #CHI-890013 add l_bmb01,l_bmb02  #MOD-8A0007 add l_no
 
          SELECT bma01 FROM bma_file
                       WHERE bma01 = sr[i].bmb03 
                         AND bma06 = l_ima910[i]  #MOD-A40040 add
          IF status != NOTFOUND AND p_level < tm.x THEN
#             OUTPUT TO REPORT r002_rep(p_level+1,sr[600].*)   #No.FUN-850061
            #CALL r002_bom(p_level,sr[i].bmb03,' ',sr[i].bmb02)     #No.MOD-780075 modify   #CHI-890013 add bmb02#FUN-8B0015
             CALL r002_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb02) #No.FUN-8B0015
          END IF
	END FOR
END FUNCTION
#No.FUN-850061---Begin			
#REPORT r002_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1,  #CHAR(1),
#       sr               RECORD 
#		p_level LIKE type_file.num5,   #SMALLINT,
#        	bmb02	LIKE bmb_file.bmb02,
#	        bmb03	LIKE bmb_file.bmb03,
#                bmb29   LIKE bmb_file.bmb29,    #No.MOD-780075 add
#        	ima02	LIKE ima_file.ima02,
#	        lc_qty,lb_qty	LIKE type_file.num20_6,   #decimal(9,5),
#	        ima021	LIKE ima_file.ima021,
#                bmb10        LIKE bmb_file.bmb10,
#                bmb01        LIKE bmb_file.bmb01,
#                bmb19        LIKE bmb_file.bmb19
#	END RECORD ,
#	l_col,i      LIKE type_file.num5,       #SMALLINT,
#        l_ima25      LIKE ima_file.ima25,
#        l_ima05      LIKE ima_file.ima05,
#        l_char       LIKE type_file.chr10,   #CHAR(10),
#        l_qty        LIKE type_file.num20_6 #decimal(9,5) 
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  FORMAT
#    PAGE HEADER
# #No.TQC-740145 -- begin --
# #      PRINT (g_len-length(g_company))/2 SPACES,g_company
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
# #No.TQC-740145 -- end --
#      IF cl_null(g_towhom) OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      #PRINT COLUMN (g_len-length(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-length(g_x[1]))/2 SPACES,g_x[1]
#      SKIP 1 LINES
#      LET g_pageno =g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,' ',g_x[11] CLIPPED,
#            tm.eff_date,'  ',g_x[12] CLIPPED,tm.version,
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      SKIP 1 LINES
#      LET l_last_sw = 'n'
# #No.TQC-740145 -- begin --
# #      PRINT '料號:',g_bma01 CLIPPED,'   品名:',g_ima02,'   規格:',g_ima021
# #      PRINT '  '
# #      PRINT COLUMN 10,'層級',
# #            COLUMN 32,'料件編號',
# #            COLUMN 45,'版本',
# #            COLUMN 54,'品名',
# #            COLUMN 86,'規格',
# #            COLUMN 116,'單位',
# #            COLUMN 123,'數量',
# #            COLUMN 141,'比例',
# #            COLUMN 152,'上階料件'
#     PRINT g_x[17] CLIPPED,g_bma01 CLIPPED
#     PRINT g_x[18] CLIPPED,g_ima02 CLIPPED
#     PRINT g_x[19] CLIPPED,g_ima021 CLIPPED
#    #---------No.MOD-780075 modify
#     IF g_sma.sma118 = 'Y' THEN
#     PRINT g_x[29] CLIPPED,g_bma06
#     ELSE
#        PRINT ''
#     END IF
#    #---------No.MOD-780075 end
#     PRINT g_dash2
#     PRINT g_x[20] CLIPPED
##No.TQC-740145 -- end --
#     PRINT g_dash
 
#  ON EVERY ROW
 
#     IF sr.p_level = 0 THEN 
# 	 SKIP TO TOP OF PAGE
#     ELSE 
#     FOR i = 1 to (sr.p_level -1) 
#      	IF g_level_end[i] THEN 
#      	   PRINT COLUMN (2 * i ), '  '  CLIPPED;
#	ELSE
#	   PRINT COLUMN (2 * i ),g_x[13] CLIPPED;
#	END IF 
#      END FOR
#      LET i = sr.p_level
#      IF cl_null(sr.bmb03) THEN
#   	 PRINT COLUMN ( sr.p_level * 2 ) CLIPPED,g_x[13]
#      ELSE 
#         IF g_level_end[i]  THEN 
#      	    PRINT COLUMN ( sr.p_level * 2) CLIPPED,g_x[14] CLIPPED;
#         ELSE
#            PRINT COLUMN ( sr.p_level * 2) CLIPPED,g_x[15] CLIPPED;
#        END IF
## SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=sr.bmb03
#        SELECT ima05 INTO l_ima05 FROM ima_file WHERE ima01=sr.bmb03
#        PRINT sr.bmb02 USING '<<<<' CLIPPED,g_x[16] CLIPPED;
##              g_dash2[(sr.p_level*2),24],    
###060627 TSC:Janne 
#              IF sr.p_level*2>24 THEN
##                  PRINT g_dash2[24,24];                #No.TQC-740145
#                 PRINT g_dash[24,24];                  #No.TQC-740145
#              ELSE
##                  PRINT g_dash2[(sr.p_level*2),24];    #No.TQC-740145
#                 PRINT g_dash[(sr.p_level*2),24];      #No.TQC-740145
#              END IF
###    
#            # PRINT COLUMN 32,sr.bmb03 CLIPPED,'                        ',l_ima05,    #No.TQC-740149 mark
#              PRINT COLUMN 32,sr.bmb03 CLIPPED, #No.TQC-740149 
#                    COLUMN 63,l_ima05 CLIPPED,  #No.TQC-740149    
#      	       #'(',sr.ima02 CLIPPED ,',' ',',sr.ima021 CLIPPED,') *';
#      	      #COLUMN 54,sr.ima02 CLIPPED,   #No.TQC-740149 mark 
#             #COLUMN 86,sr.ima021 CLIPPED;  #No.TQC-740149 mark
#      	       COLUMN 69,sr.ima02 CLIPPED,   #No.TQC-740149 
#              COLUMN 101,sr.ima021 CLIPPED; #No.TQC-740149
#        IF sr.lb_qty > 1 THEN 
#           ## No:2371 modify 1998/07/16 ----------------------
#           LET l_qty = 0
#           LET l_qty = sr.lc_qty/sr.lb_qty
#          #PRINT COLUMN 117,sr.bmb10,                         #No.TQC-740149 mark 
#          #      COLUMN 121,l_qty USING "###&.&&&&" CLIPPED;  #No.TQC-740149 mark
#           PRINT COLUMN 132,sr.bmb10,                         #No.TQC-740149 
#                 COLUMN 136,l_qty USING "###&.&&&&" CLIPPED;  #No.TQC-740149 
#           #PRINT COLUMN 143,sr.lc_qty USING "###&.&&&" CLIPPED,
#           #	  '/' CLIPPED , sr.lb_qty USING "###&.&&&";  
#        ELSE
#          #PRINT COLUMN 117,sr.bmb10,                             #No.TQC-740149 mark   
#          #      COLUMN 121,sr.lc_qty USING "###&.&&&&" CLIPPED;  #No.TQC-740149 mark 
#           PRINT COLUMN 132,sr.bmb10,                             #No.TQC-740149       
#                 COLUMN 136,sr.lc_qty USING "###&.&&&&" CLIPPED;  #No.TQC-740149 
#           ### -----------------------------------------------
#        END IF
#        LET l_char = ' ' 
#        IF sr.bmb19 = '3' THEN
#           LET l_char = '*'
#        ELSE
#           LET l_char = ' '
#        END IF
#        PRINT '     ',sr.lc_qty USING "###&.&&&&" CLIPPED,'/' CLIPPED,
#                      sr.lb_qty USING "###&.&&&&" CLIPPED,'     ',
#                      sr.bmb01,' ',l_char
#        IF g_level_end[i]  THEN 
#           FOR i = 1 to (sr.p_level - 1) 
#               IF g_level_end[i] THEN 
#       	   PRINT COLUMN (2 * i ), '  '  CLIPPED;
#               ELSE
#                  PRINT COLUMN (2 * i ),g_x[13] CLIPPED;
#               END IF 
#           END FOR
#           PRINT 
#        END IF
#       END IF
#    END IF
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#  IF g_end = 0 AND l_last_sw = 'n'
#   THEN
##        PRINT '(abmr002)',g_dash     #No.TQC-740145
##        PRINT '  '                   #No.TQC-740145
#       PRINT g_dash2              #No.TQC-740145
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#  ELSE 
#   #  IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#   #     CALL cl_wcchp(tm.wc,'bma01')
#   #          RETURNING tm.wc
#   #     LET tm.wc= tm.wc CLIPPED
#   #     PRINT g_dash[1,g_len]
#   #	IF tm.wc[001,75] > ' ' THEN            # for 132
#   #		PRINT g_x[8] CLIPPED,tm.wc[001,75] CLIPPED 
#   #	END IF
#   #	IF tm.wc[076,150] > ' ' THEN            # for 132
#   #		PRINT g_x[8] CLIPPED,tm.wc[076,150] CLIPPED 
#   #	END IF
#   #  END IF
##      PRINT '(abmr002)',g_dash  #No.TQC-740145
##      PRINT '  '                #No.TQC-740145
#     PRINT g_dash2              #No.TQC-740145
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#END IF
#END REPORT
#No.FUN-850061---End
#-----------------No.MOD-780075 mark
#No.TQC-740149--begin--
#此函數用于料件不同單位時，數量上的轉換。
#處理方式，將主料件的生產單位取出，同時將主料件在上一階中的發料單位轉換成生產單位，同時換算數量。
#將子料件的發料單位換算成主料件的生產單位，同時換算用量。再將換算后的子料件用量和主料件用量相乘，
#得出的結果再換算成子料件發料單位用量。
#FUNCTION r002_qty(p_level,p_key,p_bmb03,p_bmb06,p_bmb10)
#DEFINE   p_level    LIKE type_file.num5
#DEFINE   p_key      LIKE bma_file.bma01         #主料件
#DEFINE   p_bmb03    LIKE bmb_file.bmb03         #子料件
#DEFINE   p_bmb06    LIKE bmb_file.bmb06         #子料件發料單位用量
#DEFINE   p_bmb10    LIKE bmb_file.bmb10         #子料件發料單位
#DEFINE   l_bmb10    LIKE bmb_file.bmb10         #主料件發料單位
#DEFINE   l_bmb06    LIKE bmb_file.bmb06         #主料件發料單位用量
#DEFINE   l_ima55    LIKE ima_file.ima55         #主料件生產單位
#DEFINE   l_fac1     LIKE ima_file.ima31_fac     #主料件生產單位與發料單位換算率
#DEFINE   l_fac2     LIKE ima_file.ima31_fac     #主料件生產單位與子料件發料單位換算率
#DEFINE   l_flag     LIKE type_file.num5         #換算成功否
#DEFINE   l_qty1     LIKE bmb_file.bmb06         #換算后主料件生產單位用量
#DEFINE   l_qty2     LIKE bmb_file.bmb06         #換算后子料件對應于主料件換算單位用量
#DEFINE   l_qty3     LIKE bmb_file.bmb06         #換算后子料件發料單位用量
#DEFINE   l_msg      LIKE type_file.chr1000
 
#   LET l_qty1 = 0
#   LET l_qty2 = 0
#   LET l_qty3 = 0
#   LET l_fac1 = 1
#   LET l_fac2 = 1
 
 
#   #取出主料件在上階中的發料單位用量，發料單位及生產單位
#   IF p_level = 2 THEN 
#      SELECT bmb06,bmb10,ima55 INTO l_bmb06,l_bmb10,l_ima55 FROM bmb_file,ima_file
#       WHERE ima01=bmb03 AND bmb03 = p_key
#   END IF 
#   IF p_level >2 THEN 
#      SELECT bmb06,bmb10,ima55 INTO l_bmb06,l_bmb10,l_ima55 FROM abmr002_tmp
#        WHERE bmb03 = p_key    
#      IF SQLCA.sqlcode THEN 
#         CALL cl_err('select temp:',SQLCA.sqlcode,1)
#      END IF 
#   END IF 
#   #比較主料件的用量單位和生產單位是否相同
#   IF l_bmb10 <> l_ima55 THEN 
#      CALL s_umfchk(p_key,l_bmb10,l_ima55) RETURNING l_flag,l_fac1
#      #若換算失敗，提示錯誤信息后，采用1比1的方式繼續，不中斷程序。
#      IF l_flag = 1 THEN 
#         LET l_msg = p_key,' ',l_bmb10,'/',l_ima55
#         CALL cl_err(l_msg,'mfg6044',1)
#         LET l_qty1 = l_bmb06
#         LET l_fac1 = 1  
#      END IF        
#      LET l_qty1 = l_bmb06*l_fac1
#   ELSE 
#      LET l_qty1 = l_bmb06
#   END IF
#   #比較子料件的用量單位與主料件的生產單位是否相同。
#   IF l_ima55 <> p_bmb10 THEN 
#      CALL s_umfchk(p_bmb03,p_bmb10,l_ima55) RETURNING l_flag,l_fac2
#      #若換算失敗，提示錯誤信息后，采用1比1的方式繼續，不中斷程序。
#      IF l_flag = 1 THEN 
#         LET l_msg = p_bmb03,' ',p_bmb10,'/',l_ima55
#         CALL cl_err(l_msg,'mfg6044',1)
#         LET l_qty2 = p_bmb06
#         LET l_fac2 = 1     	  
#      END IF 
#      LET l_qty2 = p_bmb06*l_fac2
#   ELSE
#      LET l_qty2 = p_bmb06
#   END IF   
#   #計算最終子料件發料單位用量。
#   LET l_qty3 = (l_qty1*l_qty2)/l_fac2
#   
#   INSERT INTO abmr002_tmp VALUES(p_key,p_bmb03,l_qty3,p_bmb10,l_ima55)
#   IF SQLCA.sqlcode THEN 
#      CALL cl_err('insert temp:',SQLCA.sqlcode,1)
#   END IF 
#   RETURN l_qty3
 
#END FUNCTION 
#No.TQC-740149--end--
#-----------------No.MOD-780075 mark
