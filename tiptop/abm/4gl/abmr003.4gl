# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abmr003.4gl
# Descriptions...: 製程產品結構表
# Input parameter: 
# Return code....: 
# Date & Author..: 11/02/09 By vealxu   FUN-B20002 
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm           RECORD
   	wc		LIKE type_file.chr1000,	# Where condition
	bra01 		LIKE bra_file.bra01,	# 主件料號 	
        bra06           LIKE bra_file.bra06,    # 特性代碼
	bra011  	LIKE bra_file.bra011,	# 製程編號 
	version         LIKE type_file.chr2,		# Version of PRINT
	eff_date	DATE,		        # 有效日期(BOM)
	more	        LIKE type_file.chr1	# IF more condition
	END RECORD,
	g_bra01		LIKE bra_file.bra01,
        g_bra06         LIKE bra_file.bra06,
        g_bra011        LIKE bra_file.bra011,
        g_ecu03         LIKE ecu_file.ecu03,
        g_ecu014        LIKE ecu_file.ecu014,  
        g_bra012        LIKE bra_file.bra012,
        g_bra013        LIKE bra_file.bra013,  
        g_ecb06         LIKE ecb_file.ecb06,
        g_ecb17        LIKE ecb_file.ecb17,
	g_ima02		LIKE ima_file.ima02,
	g_ima021	LIKE ima_file.ima021,
	l_flag 		LIKE type_file.num5,    #SMALLINT,
	l_n	        LIKE type_file.num5,    #SMALLINT,
	l_no	        LIKE type_file.num5,    #MOD-8A0007 
	g_end		LIKE type_file.num5,    #SMALLINT,
	g_level_end ARRAY[20] OF LIKE type_file.num5 #SMALLINT
 
DEFINE   g_i             LIKE type_file.num5   #SMALLINT   #count/index for any purpose
#FUN-6C0009
DEFINE l_table    STRING                                                                                                            
DEFINE g_str      STRING                                                                                                            
DEFINE g_sql      STRING                                                                                                            

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   #051011 By DSC Yvonne
   IF (NOT cl_setup("ABM")) THEN  
      EXIT PROGRAM
   END IF
 
#No.FUN-850061---Begin                                                                                                              
   LET g_sql = "g_bra01.bra_file.bra01,",                                                                                           
               "g_bra06.bra_file.bra06,",  
               "g_bra011.bra_file.bra011,",
               "ecu03.ecu_file.ecu03,",                                                                                             
               "g_bra012.bra_file.bra012,",
               "ecu014.ecu_file.ecu014,",
               "g_bra013.bra_file.bra013,",
               "ecb06.ecb_file.ecb06,", 
               "ecb17.ecb_file.ecb17,",
               "g_ima02.ima_file.ima02,",                                                                                             
               "g_ima021.ima_file.ima021,",
               "brb03.brb_file.brb03,",
               "brb02.brb_file.brb02,",
               "l_ima05.ima_file.ima05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "p_level.type_file.num5,",
               "lb_qty.type_file.num20_6,",   
               "lc_qty.type_file.num20_6,",  
               "brb10.brb_file.brb10,", 
               "brb19.brb_file.brb19,",
               "brb01.brb_file.brb01,", 
               "l_brb01.brb_file.brb01,",      
               "l_brb02.brb_file.brb02,",    
               "l_no.type_file.num5,",      
               "g_sma118.sma_file.sma118"                                                               
                                                                                                
   LET l_table = cl_prt_temptable('abmr003',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "                                                                                                  
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r003_tm(0,0)	        	# Input print condition
      ELSE CALL abmr003()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add-- 
END MAIN
 
FUNCTION r003_tm(p_row,p_col)
   DEFINE 	p_row,p_col	LIKE type_file.num5,   #SMALLINT,	
                l_flag		LIKE type_file.num5,   #SMALLINT,
                l_one	        LIKE type_file.chr1,    #CHAR(01)
                l_bdate		LIKE type_file.dat,    #DATE,		
                l_edate		LIKE type_file.dat,    #DATE,	
                l_bra01		LIKE bra_file.bra01,
                l_cmd	        LIKE type_file.chr1000  #CHAR(1000)
   IF p_row = 0 THEN LET p_row = 4 LET p_col =14 END IF			
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 7 LET p_col = 20
   ELSE
       LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r003_w AT p_row,p_col
        WITH FORM "abm/42f/abmr003" 
################################################################################
# START genero shell script ADD
      ATTRIBUTE (STYLE = g_win_style)
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("bra06",g_sma.sma118='Y')  
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL		# Default condition
   LET tm.eff_date=g_today
   LET tm.more    = "N"	
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON bra01,bra06,bra011 
      ON ACTION CONTROLP #FUN-4B0001
            IF INFIELD(bra01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_bra01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bra01
               NEXT FIELD bra01
            END IF
      ON ACTION locale
         #CALL cl_dynamic_locale()
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
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('brauser', 'bragrup') 
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r003_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
#UI
   INPUT BY NAME tm.version,tm.eff_date,
				 tm.more WITHOUT DEFAULTS 
      BEFORE FIELD version
         IF l_one='N' THEN 
            NEXT FIELD eff_date
         END IF
 
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
 
     ON ACTION about      
        CALL cl_about()  
 
     ON ACTION help     
        CALL cl_show_help() 
 
   
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT INPUT

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r003_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='abmr003'
      IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
         CALL cl_err('abmr003','9031',1)
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
                         " '",tm.eff_date CLIPPED,"'" 
         CALL cl_cmdat('abmr003',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r003_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abmr003()
   ERROR ""
END WHILE
   CLOSE WINDOW r003_w
END FUNCTION
   
FUNCTION abmr003()
   DEFINE l_name   LIKE type_file.chr20,     #CHAR(20),		# External(Disk) file name
          l_time   LIKE type_file.chr8,      #CHAR(8),		# Used time for running the job
          l_sql    LIKE type_file.chr1000,   #CHAR(1000),		# RDSQL STATEMENT
          l_chr	   LIKE type_file.chr1,      #CHAR(1),
	  p_level  LIKE type_file.num5,      #SMALLINT,	
          sr               RECORD  
				bra01	LIKE bra_file.bra01,
				bra06	LIKE bra_file.bra06,
                                bra011  LIKE bra_file.bra011,
				ima02	LIKE ima_file.ima02,
				ima021	LIKE ima_file.ima021 
	END RECORD 
        
     #No.FUN-B80100--mark--Begin---
     #CALL cl_used('abmr003',l_time,1) RETURNING l_time
     #No.FUN-B80100--mark--End-----
     CALL cl_del_data(l_table)      #No.FUN-850061
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     LET l_sql = "SELECT bra01,bra06,bra011,bra012,bra013,ima02,ima021 ",    
                 " FROM bra_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 " AND bra01=ima01",
                 " AND braacti='Y'",   #MOD-A60011 add
                 " AND ima08 !='A'"
     PREPARE r003_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
        EXIT PROGRAM 
     END IF
     DECLARE r003_curs1 CURSOR FOR r003_prepare1
     LET g_pageno = 1 
     LET p_level = 0
     LET l_no = 0      
     FOREACH r003_curs1 INTO g_bra01,g_bra06,g_bra011,g_bra012,g_bra013,g_ima02,g_ima021  
        IF SQLCA.sqlcode != 0 THEN 
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
        END IF
        SELECT ecu03,ecu014 INTO g_ecu03,g_ecu014 FROM ecu_file
         WHERE ecu01 = g_bra01    
           AND ecu02 =  g_bra011
           AND ecu012 = g_bra012
        SELECT ecb06,ecb17 INTO g_ecb06,g_ecb17 FROM ecb_file
         WHERE ecb01 = g_bra01    AND ecb02 = g_bra011
           AND ecb03 = g_bra013    AND ecb012 = g_bra012  AND ecbacti = 'Y'
        LET g_pageno = 0
        LET g_end = 0
        CALL r003_bom(0,g_bra01,g_bra06,g_bra011,g_bra012,g_bra013,' ')           
        LET g_end = 1	
     END FOREACH	
     LET g_str= g_towhom,";",tm.eff_date,";",tm.version                                                                                        
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                            
     CALL cl_prt_cs3('abmr003','abmr003',l_sql,g_str) 
     #No.FUN-B80100--mark--Begin---
     #CALL cl_used('abmr003',l_time,2) RETURNING l_time 
     #No.FUN-B80100--mark--End-----
END FUNCTION
   
FUNCTION r003_bom(p_level,p_key1,p_key2,p_key3,p_key4,p_key5,p_key6)     
	DEFINE	p_level LIKE type_file.num5,        #SMALLINT,
                p_total	LIKE type_file.num20_6,     #DECIMAL(10,2),
                l_brb01	LIKE brb_file.brb01,       
                l_brb02	LIKE brb_file.brb02,     
                p_key1	LIKE brb_file.brb01, 
                p_key2  LIKE brb_file.brb29,
                p_key3  LIKE brb_file.brb011,
                p_key4  LIKE brb_file.brb012,
                p_key5  LIKE brb_file.brb013,
                p_key6  LIKE brb_file.brb02,  
                l_ac,i,j    LIKE type_file.num5,    #SMALLINT,
                l_total     LIKE type_file.num5,    #SMALLINT,
                l_time      LIKE type_file.num5,    #SMALLINT,
                l_count     LIKE type_file.num5,    #SMALLINT,
                arr_size    LIKE type_file.num5,    #SMALLINT,
                begin_no    LIKE type_file.num5,    #SMALLINT,
                l_chr	    LIKE type_file.chr1,    #CHAR(1),
                l_sql       LIKE type_file.chr1000, #CHAR(1000),
                l_ima05     LIKE ima_file.ima05,  
                sr DYNAMIC ARRAY OF RECORD
                   brb02	LIKE brb_file.brb02,
                   brb03	LIKE brb_file.brb03,
                   brb29        LIKE brb_file.brb29,  
                   ima02	LIKE ima_file.ima02,
                   lc_qty,lb_qty	LIKE type_file.num20_6,  #decimal(9,5),
		   ima021	LIKE ima_file.ima021,
                   brb10        LIKE brb_file.brb10,
                   brb01        LIKE brb_file.brb01,
                   brb19        LIKE brb_file.brb19
                END RECORD
    DEFINE      l_qty           LIKE brb_file.brb06   
    DEFINE      l_ima910        DYNAMIC ARRAY OF LIKE ima_file.ima910         
 
 
	INITIALIZE sr[600].* TO NULL
        IF cl_null(tm.eff_date) THEN
           LET l_sql="SELECT brb02,brb03,brb29,ima02,brb06,brb07,ima021,brb10,brb01,brb19,''",  
		     "  FROM brb_file,ima_file",
	             " WHERE brb01 = '",p_key1,"'  AND ima01 = brb03 ",
                     "   AND brb29 = '",p_key2,"'  AND brb011 = '",p_key3,"'", 
                     "   AND brb012 = '",p_key4,"' AND brb013 = '",p_key5,"'",
	             " ORDER BY brb02"
        ELSE
           LET l_sql="SELECT brb02,brb03,brb29,ima02,brb06,brb07,ima021,brb10,brb01,brb19,''",  
		     "  FROM brb_file,ima_file",
	             " WHERE brb01 = '",p_key1,"' AND ima01 = brb03 ",
                     "   AND brb29 = '",p_key2,"' AND brb011 = '",p_key3,"'", 
                     "   AND brb012 = '",p_key4,"' AND brb013 = '",p_key5,"'",
                     " AND (brb04 <='",tm.eff_date,"' OR brb04 IS NULL) ",
                     " AND (brb05 > '",tm.eff_date,"' OR brb05 IS NULL) ",
	             " ORDER BY brb02"
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
           LET l_ima910[l_count]=''
           SELECT ima910 INTO l_ima910[l_count] FROM ima_file WHERE ima01=sr[l_count].brb03
           IF cl_null(l_ima910[l_count]) THEN LET l_ima910[l_count]=' ' END IF
           LET	l_count = l_count + 1
	END FOREACH			
        LET l_count = l_count - 1
        LET g_level_end[p_level] = 0
	FOR i = 1 TO l_count
          IF l_count = i THEN LET g_level_end[p_level] = 1 END IF
          SELECT ima05 INTO l_ima05 FROM ima_file WHERE ima01=sr[i].brb03   
          IF p_level = 1 THEN 
             LET l_brb01 = sr[i].brb03
             LET l_brb02 = sr[i].brb02
          ELSE 
             LET l_brb01 = p_key1
             LET l_brb02 = p_key4
          END IF 
          LET l_no = l_no + 1 
          EXECUTE  insert_prep USING g_bra01,g_bra06,g_bra011,g_ecu03,g_bra012,g_ecu014,g_bra013,g_ecb06,g_ecb17,g_ima02,g_ima021,sr[i].brb03,
                                     sr[i].brb02,l_ima05,sr[i].ima02,sr[i].ima021,
                                     p_level,sr[i].lb_qty,sr[i].lc_qty,sr[i].brb10,sr[i].brb19,sr[i].brb01,l_brb01,l_brb02,l_no,g_sma.sma118    
      #暫不考慮展開--------------- 
      #   SELECT bra01 FROM bra_file
      #                WHERE bra01 = sr[i].brb03 
      #                  AND bra06 = l_ima910[i]  
      #   IF status != NOTFOUND  THEN
      #      CALL r003_bom(p_level,sr[i].brb03,l_ima910[i],'xxx ','xxx ',sr[i].brb02) 
      #   END IF
      # -----------------------
	END FOR
END FUNCTION
#FUN-B20002 ------------end
