# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimr843.4gl
# Descriptions...: 刻號/BIN差異分析表－現有庫存
# Date & Author..: 11/08/05 #FUN-B70032

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-B70032 ref.aimr883
DEFINE tm  RECORD			# Print condition RECORD
           wc   STRING,                 # Where Condition  
           c    LIKE type_file.chr1,    # 資料選擇  
           b    LIKE type_file.chr1,                          
           d    LIKE type_file.chr1,                          
           s    LIKE type_file.chr3,                           
           t    LIKE type_file.chr3,                           
           more LIKE type_file.chr1                           
           END RECORD
DEFINE g_i            LIKE type_file.num5,              #count/index for any purpose  
       l_orderA       ARRAY[3] OF LIKE imm_file.imm13    
DEFINE    g_sql       STRING            
DEFINE    g_str       STRING            
DEFINE    l_table     STRING            
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET g_sql = "piad04.piad_file.piad04,",
               "piad01.piad_file.piad01,",
               "piad02.piad_file.piad02,",
               "ima05.ima_file.ima05,",
               "ima08.ima_file.ima08,",
               "ima07.ima_file.ima07,",
               "ima06.ima_file.ima06,",
               "piad10.piad_file.piad10,",
               "piad09.piad_file.piad09,",
               "stk1.piad_file.piad09,",
               "stk2.piad_file.piad09,",
               "l_diff1.type_file.num15_3,", 
               "l_diff2.type_file.num15_3,", 
               "piad05.piad_file.piad05,",
               "piad06.piad_file.piad06,",
               "piad07.piad_file.piad07,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,", 
               "piad03.piad_file.piad03" 
   LET l_table = cl_prt_temptable('aimr843',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM 
   END IF                         
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.c     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   LET tm.d     = ARG_VAL(10)
   LET tm.s     = ARG_VAL(11)
   LET tm.t     = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
   THEN CALL r850_tm(0,0)    	       	# Input print condition
   ELSE
        CALL r850_1()		
   END IF
 
 CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION r850_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,                           
          l_cmd		LIKE type_file.chr1000,                          
	  l_direct      LIKE type_file.chr1                           
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 10 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 10
   END IF
 
   OPEN WINDOW r850_w AT p_row,p_col
        WITH FORM "aim/42f/aimr843"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.c      = '1'
   LET tm.b      = 'N'
   LET tm.d      = 'N'
   IF g_sma.sma12 = 'Y' THEN
        LET tm.s      = '123'
   ELSE LET tm.s      = '126'
   END IF
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
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
   IF g_sma.sma12 = 'N' THEN
      CONSTRUCT BY NAME tm.wc ON piad01,piad02,ima08
 
      ON ACTION controlp
         IF INFIELD(piad02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO piad02
            NEXT FIELD piad02
         END IF
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) 
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   ELSE
      CONSTRUCT BY NAME tm.wc ON piad01,piad02,piad03,piad04,piad05,ima08
 
      ON ACTION controlp
         IF INFIELD(piad02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO piad02
            NEXT FIELD piad02
         END IF
 
      ON ACTION locale
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
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r850_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
#UI
   INPUT BY NAME tm.c,tm.b,tm.d,
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more
                 WITHOUT DEFAULTS
 
     AFTER FIELD c
         IF tm.c IS NULL OR tm.c = ' ' OR tm.c NOT MATCHES'[12]'
			THEN NEXT FIELD c
		 END IF
 
     AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES'[YN]'
         THEN NEXT FIELD b
         END IF
 
     AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[YN]'
         THEN NEXT FIELD d
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW r850_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimr843'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr843','9031',1)
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
                         " '",tm.c CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",                         
                         " '",g_rep_clas CLIPPED,"'",                         
                         " '",g_template CLIPPED,"'"                          
         CALL cl_cmdat('aimr843',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r850_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r850_1()		        
   ERROR ""
END WHILE
CLOSE WINDOW r850_w
END FUNCTION
 
 
FUNCTION r850_1()
   DEFINE l_name     LIKE type_file.chr20,            # External(Disk) file name  
          l_sql      STRING,                          # RDSQL STATEMENT    
          l_za05     LIKE za_file.za05,                                      
          l_order    ARRAY[3] OF LIKE ima_file.ima01,                                            
          sr         RECORD
                     order1   LIKE  ima_file.ima01,                                            
                     order2   LIKE  ima_file.ima01,                                            
                     order3   LIKE  ima_file.ima01,                                            
                     piad01    LIKE  piad_file.piad01, #標籤號碼
                     piad02    LIKE  piad_file.piad02, #料件編號
                     piad03    LIKE  piad_file.piad03, #倉庫別
                     piad04    LIKE  piad_file.piad04, #存放位置
                     piad05    LIKE  piad_file.piad05, #批號
                     piad06    LIKE  piad_file.piad06, #刻號
                     piad07    LIKE  piad_file.piad07, #BIN
                     piad10    LIKE  piad_file.piad10, #庫存單位                    
                     piad30    LIKE  piad_file.piad30, #初盤數量(一)
                     piad40    LIKE  piad_file.piad40, #初盤數量(二)
                     piad50    LIKE  piad_file.piad50, #複盤數量(一)
                     piad60    LIKE  piad_file.piad60, #複盤數量(二)
                     piad09    LIKE  piad_file.piad09, #應盤數量
                     stk1     LIKE  piad_file.piad09,
                     stk2     LIKE  piad_file.piad09,
                     ima02    LIKE  ima_file.ima02, #品名
                     ima021   LIKE  ima_file.ima021,#規格
                     ima05    LIKE  ima_file.ima05, #版本
                     ima06    LIKE  ima_file.ima06, #分群碼
                     ima07    LIKE  ima_file.ima07, #ABC 碼
                     ima08    LIKE  ima_file.ima08  #來源
                     END RECORD
      DEFINE          l_diff1    LIKE type_file.num15_3 
      DEFINE          l_diff2    LIKE type_file.num15_3 
     
     CALL cl_del_data(l_table)
     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr843'
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = " SELECT  '','','',",
                 " piad01,piad02,piad03,piad04,piad05,piad06,piad07,",                
                 " piad10,piad30,piad40,piad50,",          
                 " piad60,piad09,'','',",
                 " ima02,ima021,ima05,ima06,ima07,ima08",   
                 " FROM piad_file,ima_file",                
                 " WHERE piad02 = ima01 ",
                 "  AND piad02 IS NOT NULL ",
                 "  AND ",tm.wc CLIPPED
 
     #--->不包含初/複相同者
     IF tm.d = 'N'
     THEN  IF tm.c = '1'
           THEN LET l_sql = l_sql clipped,
                            " AND ((piad30 != piad50 )",
                            "  OR piad30 IS NULL OR piad50 IS NULL)"
           ELSE LET l_sql = l_sql clipped,
                            " AND ((piad40 != piad60 )",
                            "  OR piad40 IS NULL OR piad60 IS NULL)"
           END IF
     END IF
 
     #--->不包含未做盤點者
     IF tm.b = 'N'
     THEN  IF tm.c = '1'
           THEN LET l_sql = l_sql clipped,
                            " AND (piad30 IS NOT NULL OR piad50 IS NOT NULL) "
           ELSE LET l_sql = l_sql clipped,
                            " AND (piad40 IS NOT NULL OR piad60 IS NOT NULL) "
           END IF
     END IF
     PREPARE r850_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE r850_c1 CURSOR FOR r850_prepare1 
 
      LET l_name = 'aimr843'
      
      CALL cl_prt_pos_len()
 
     LET g_pageno = 0
     FOREACH r850_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
	   IF sr.piad01 IS NULL THEN LET sr.piad01 = ' ' END IF
	   IF sr.piad02 IS NULL THEN LET sr.piad02 = ' ' END IF
	   IF sr.piad03 IS NULL THEN LET sr.piad03 = ' ' END IF
	   IF sr.piad04 IS NULL THEN LET sr.piad04 = ' ' END IF
	   IF sr.piad05 IS NULL THEN LET sr.piad05 = ' ' END IF
       IF tm.c = '1' THEN
            LET sr.stk1 = sr.piad30
            LET sr.stk2 = sr.piad50
       ELSE LET sr.stk1 = sr.piad40
            LET sr.stk2 = sr.piad60
       END IF
       IF cl_null(sr.stk1) THEN     
          LET sr.stk1 = 0           
       END IF                       
       IF cl_null(sr.stk2) THEN      
          LET sr.stk2 = 0            
       END IF                        
       IF cl_null(sr.piad09) THEN    
          LET sr.piad09 = 0          
       END IF
       
        #---->初/複盤差異量
        LET l_diff1 = sr.stk1  - sr.stk2
       
        #---->盤盈虧量
        IF sr.stk2  IS NOT NULL AND sr.stk2 !=' ' THEN
             LET l_diff2 = sr.stk2  - sr.piad09
        ELSE LET l_diff2 = sr.stk1  - sr.piad09
        END IF       
        EXECUTE insert_prep USING
            sr.piad04,sr.piad01,sr.piad02,sr.ima05,sr.ima08,sr.ima07,sr.ima06,
            sr.piad10,sr.piad09,sr.stk1,sr.stk2,l_diff1,l_diff2,sr.piad05,sr.piad06,
            sr.piad07,sr.ima02,sr.ima021,sr.piad03
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'piad01,piad02,piad03,piad04,piad05,ima08')
        RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.c,";",tm.b,";",tm.d
                 
     CALL cl_prt_cs3('aimr843',l_name,g_sql,g_str)            
END FUNCTION
 
