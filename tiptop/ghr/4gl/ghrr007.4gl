# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr007.4gl
# Descriptions...: 员工直/简介分布情况打印
# Date & Author..: 13/08/13   by ye'anping

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD         #TQC-BA0010
            wc     STRING,                 #No.TQC-630166 VARCHAR(600) #Where condition
            more   LIKE type_file.chr1     #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
           END RECORD
DEFINE g_count     LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_i         LIKE type_file.num5     #No.FUN-680121 SMALLINT #count/index for any purpose
DEFINE g_msg       LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(72)
DEFINE g_po_no     LIKE oea_file.oea10     #No.MOD-530401
DEFINE g_ctn_no1,g_ctn_no2   LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20) #MOD-530401
DEFINE g_sql       STRING                                                   
DEFINE l_table     STRING                                                 
DEFINE g_str       STRING
DEFINE g_hrag    RECORD LIKE hrag_file.*   
DEFINE g_hrat25    LIKE hrat_file.hrat25  
DEFINE g_hrao00    LIKE hrao_file.hrao00 
DEFINE g_hrao01    LIKE type_file.chr1000   #modified by yeap NO.130929
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc
   
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
 
   LET g_sql ="hras02_1.type_file.chr100,hrap01.type_file.chr100,",
              "hrat25.hrat_file.hrat25,",
              "Fstaffs_11.type_file.num5,Fstaffs_12.type_file.num5,",
              "Fstaffs_21.type_file.num5,Fstaffs_22.type_file.num5,",
              "Lstaffs_111.type_file.num5,Lstaffs_112.type_file.num5,",      
              "Lstaffs_121.type_file.num5,Lstaffs_122.type_file.num5,",
              "Lstaffs_211.type_file.num5,Lstaffs_212.type_file.num5,",
              "Lstaffs_221.type_file.num5,Lstaffs_222.type_file.num5" 

   LET l_table = cl_prt_temptable('ghrr007',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr007_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr007()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr007_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hras02       LIKE hras_file.hras02
      ,l_hrat25       LIKE hrat_file.hrat25
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr007_w AT p_row,p_col WITH FORM "ghr/42f/ghrr007"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

  LET tm.more = 'N'
  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON hras02,hrap01,hrat25

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       DISPLAY g_today TO FORMONLY.hrat25
          
       AFTER FIELD hras02
          LET l_hras02 = GET_FLDBUF(hras02)
          IF cl_null(l_hras02) THEN 
          	 NEXT FIELD hras02
          ELSE 
          	 LET g_hrao00 = l_hras02
             LET l_hrat25 = GET_FLDBUF(hrat25)
          	  IF cl_null(l_hrat25) THEN 
          	     NEXT FIELD hrat25
              ELSE 
          	     LET g_hrat25 = l_hrat25
              END IF
          END IF 
       
       AFTER FIELD hrat25
          LET l_hrat25 = GET_FLDBUF(hrat25)
          IF cl_null(l_hrat25) THEN 
          	 NEXT FIELD hrat25
          ELSE 
          	 LET g_hrat25 = l_hrat25
          END IF 
          	
       AFTER FIELD hrap01
          LET g_hrao01 = GET_FLDBUF(hrap01)
          LET l_hrat25 = GET_FLDBUF(hrat25)
          IF cl_null(l_hrat25) THEN 
          	 NEXT FIELD hrat25
          ELSE 
          	 LET g_hrat25 = l_hrat25
          END IF
          	
       ON ACTION controlp
          CASE
          	 WHEN INFIELD(hrap01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hrao01"
                  LET g_qryparam.arg1 = l_hras02  
                  LET g_qryparam.state = "c"  #added by yeap NO.130929 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrap01
                  NEXT FIELD hrap01
                  
             WHEN INFIELD(hras02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hraa01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hras02
                  NEXT FIELD hras02
             
             OTHERWISE
                  EXIT CASE
           END CASE
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
  
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
  
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
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.more                  
    INPUT BY NAME tm.more WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG 
          CALL cl_cmdask()    # Command execution
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
       #No.FUN-580031 --start--
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 ---end---
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='ghrr007'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr007','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc CLIPPED,"'",               #FUN-750047 add
                       #   " '",g_argv1 CLIPPED,"'",
                       #   " '",g_argv2 CLIPPED,"'"
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('ghrr007',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr007_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr007()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr007_w
END FUNCTION
 
FUNCTION ghrr007()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hrao00      LIKE hrao_file.hrao00,
                     hraa12      LIKE hraa_file.hraa12, 
                     hrao01      LIKE hrao_file.hrao01, 
	     	             hrao10      LIKE hrao_file.hrao10,
                     Fstaffs_11  LIKE type_file.num5,
                     Fstaffs_12  LIKE type_file.num5,
                     Fstaffs_21  LIKE type_file.num5,
                     Fstaffs_22  LIKE type_file.num5,
                     Lstaffs_111 LIKE type_file.num5,
                	   Lstaffs_112 LIKE type_file.num5,
                     Lstaffs_121 LIKE type_file.num5,
                     Lstaffs_122 LIKE type_file.num5,
                     Lstaffs_211 LIKE type_file.num5,
                     Lstaffs_212 LIKE type_file.num5,
                     Lstaffs_221 LIKE type_file.num5,
                     Lstaffs_222 LIKE type_file.num5
                    END RECORD,
          sr1       RECORD
                     hrao00      LIKE hrao_file.hrao00, 
                     hrao01      LIKE hrao_file.hrao01, 
	     	             hrao10      LIKE hrao_file.hrao10
                    END RECORD


   DEFINE l_hraa12  LIKE hraa_file.hraa12,
          l_hrao02  LIKE hrao_file.hrao02
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5

   DEFINE            l_img_blob     LIKE type_file.blob



   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   
   LET tm.wc = cl_replace_str(tm.wc,'hras02','hrat03')
   LET tm.wc = cl_replace_str(tm.wc,'hrat25=','hrat25<=')
   
   IF tm.wc.getIndexOf("hrap01",1) THEN 
      LET tm.wc = cl_replace_str(tm.wc,'hrap01','hrao01')
      LET g_hrao01 = cl_replace_str(g_hrao01,'|',"','")
#      LET l_sql = " SELECT DISTINCT hrao00,hrao01 FROM hrao_file,hrat_file ",
#                  "  WHERE hrao10 is NULL AND hrao05 = 'N' AND  hrao00 = hrat03 AND hraoacti='Y' AND hratacti='Y' AND hratconf = 'Y' AND ",tm.wc CLIPPED  #added by yeap NO.130821 加了hrao05 = 'N'和 hratconf = 'Y'
       LET l_sql = " SELECT DISTINCT hrao00,hrao01 FROM hrao_file ",
                   "  WHERE hrao10 is NULL AND hrao05 = 'N' AND hraoacti='Y' AND hrao00 = '",g_hrao00,"' AND hrao01 IN ('",g_hrao01,"') "
   
      PREPARE r007_p1 FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr007_p1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r007_curs1 CURSOR FOR r007_p1
      
      FOREACH r007_curs1 INTO sr.hrao00,sr.hrao10
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
        LET tm.wc = cl_replace_str(tm.wc,'hrao01','hrao10')   
        LET l_sql = " SELECT DISTINCT hrao00,hrao01,hrao10 FROM hrao_file,hrat_file  WHERE hrao00 = hrat03 AND hraoacti='Y' AND hratacti='Y' AND hratconf = 'Y' AND ",tm.wc CLIPPED
        PREPARE r007_p11 FROM l_sql 
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('ghrr007_p11:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM
        END IF
      DECLARE r007_curs11 CURSOR FOR r007_p11
      
       LET sr.Fstaffs_11 = 0
       LET sr.Fstaffs_12 = 0
       LET sr.Fstaffs_21 = 0
       LET sr.Fstaffs_22 = 0
       LET sr.Lstaffs_111 = 0
       LET sr.Lstaffs_112 = 0
       LET sr.Lstaffs_121 = 0
       LET sr.Lstaffs_122 = 0
       LET sr.Lstaffs_211 = 0
       LET sr.Lstaffs_212 = 0
       LET sr.Lstaffs_221 = 0
       LET sr.Lstaffs_222 = 0
      
      FOREACH r007_curs11 INTO sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           
        SELECT COUNT(DISTINCT hratid) INTO l_fdm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fdf FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fim FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '002'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fif FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '002'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldfm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '2001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldff FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '2001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldpm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '1001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldpf FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '1001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lifm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '2001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_liff FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '2001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lipm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '1001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lipf FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '1001'
	          AND hrat17 = '002'  
	          
	                LET sr.Fstaffs_11 = l_fdm + sr.Fstaffs_11
                  LET sr.Fstaffs_12 = l_fdf + sr.Fstaffs_12
                  LET sr.Fstaffs_21 = l_fim + sr.Fstaffs_21
                  LET sr.Fstaffs_22 = l_fif + sr.Fstaffs_22
                  LET sr.Lstaffs_111 = l_ldfm + sr.Lstaffs_111
                	LET sr.Lstaffs_112 = l_ldff + sr.Lstaffs_112
                  LET sr.Lstaffs_121 = l_ldpm + sr.Lstaffs_121
                  LET sr.Lstaffs_122 = l_ldpf + sr.Lstaffs_122
                  LET sr.Lstaffs_211 = l_lifm + sr.Lstaffs_211
                  LET sr.Lstaffs_212 = l_liff + sr.Lstaffs_212
                  LET sr.Lstaffs_221 = l_lipm + sr.Lstaffs_221
                  LET sr.Lstaffs_222 = l_lipf + sr.Lstaffs_222
                  
       END FOREACH 
       
          
          SELECT COUNT(DISTINCT hratid) INTO l_fdm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fdf FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fim FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '002'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fif FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '002'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldfm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '2001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldff FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '2001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldpm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '1001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldpf FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '1001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lifm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '2001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_liff FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '2001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lipm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '1001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lipf FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '1001'
	          AND hrat17 = '002'  
	          
	          LET sr.Fstaffs_11 = l_fdm + sr.Fstaffs_11
            LET sr.Fstaffs_12 = l_fdf + sr.Fstaffs_12
            LET sr.Fstaffs_21 = l_fim + sr.Fstaffs_21
            LET sr.Fstaffs_22 = l_fif + sr.Fstaffs_22
            LET sr.Lstaffs_111 = l_ldfm + sr.Lstaffs_111
            LET sr.Lstaffs_112 = l_ldff + sr.Lstaffs_112
            LET sr.Lstaffs_121 = l_ldpm + sr.Lstaffs_121
            LET sr.Lstaffs_122 = l_ldpf + sr.Lstaffs_122
            LET sr.Lstaffs_211 = l_lifm + sr.Lstaffs_211
            LET sr.Lstaffs_212 = l_liff + sr.Lstaffs_212
            LET sr.Lstaffs_221 = l_lipm + sr.Lstaffs_221
            LET sr.Lstaffs_222 = l_lipf + sr.Lstaffs_222
	     
	     SELECT hraa12 INTO sr.hraa12 FROM hraa_file WHERE hraa01 = sr.hrao00
       SELECT hrao02 INTO sr.hrao10 FROM hrao_file WHERE hrao01 = sr.hrao10
	                
          EXECUTE insert_prep USING 
	          	  sr.hraa12,sr.hrao10,g_hrat25,sr.Fstaffs_11,sr.Fstaffs_12,
	          	  sr.Fstaffs_21,sr.Fstaffs_22,sr.Lstaffs_111,sr.Lstaffs_112,
	          	  sr.Lstaffs_121,sr.Lstaffs_122,sr.Lstaffs_211,sr.Lstaffs_212,
                sr.Lstaffs_221,sr.Lstaffs_222 
                           
      END FOREACH 
      
      
	         
           	  
   ELSE 
#   	  LET l_sql = " SELECT DISTINCT hrao00,hrao01  FROM hrao_file,hrat_file ",
#   	              "  WHERE hrao00 = hrat03 AND hrao10 is NULL AND hrao05 = 'N' AND hraoacti='Y' AND hratacti='Y'  AND hratconf = 'Y' AND ",tm.wc CLIPPED
   	  LET l_sql = " SELECT DISTINCT hrao00,hrao01 FROM hrao_file ",
                  "  WHERE hrao10 is NULL AND hrao05 = 'N' AND hraoacti='Y' AND hrao00 = '",g_hrao00,"'"
      PREPARE r007_p2 FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr007_p2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r007_curs2 CURSOR FOR r007_p2 
      
      FOREACH r007_curs2 INTO sr.hrao00,sr.hrao10
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           
        LET l_sql = "SELECT DISTINCT hrao00,hrao01,hrao10 FROM hrao_file,hrat_file  WHERE hrao00 = hrat03 AND hraoacti='Y' AND hratacti='Y' AND hratconf = 'Y' AND ",tm.wc CLIPPED,"AND hrao10 ='",sr.hrao10,"' "	
        PREPARE r007_p21 FROM l_sql 
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('ghrr007_p21:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM
        END IF
      DECLARE r007_curs21 CURSOR FOR r007_p21
      
       LET sr.Fstaffs_11 = 0
       LET sr.Fstaffs_12 = 0
       LET sr.Fstaffs_21 = 0
       LET sr.Fstaffs_22 = 0
       LET sr.Lstaffs_111 = 0
       LET sr.Lstaffs_112 = 0
       LET sr.Lstaffs_121 = 0
       LET sr.Lstaffs_122 = 0
       LET sr.Lstaffs_211 = 0
       LET sr.Lstaffs_212 = 0
       LET sr.Lstaffs_221 = 0
       LET sr.Lstaffs_222 = 0

      FOREACH r007_curs21 INTO sr1.*
         IF SQLCA.sqlcode != 0  THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           
           LET l_n = 1
           
        SELECT COUNT(DISTINCT hratid) INTO l_fdm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fdf FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fim FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '002'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fif FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '002'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldfm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '2001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldff FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '2001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldpm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '1001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldpf FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '1001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lifm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '2001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_liff FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '2001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lipm FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '1001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lipf FROM hrat_file
	        WHERE hrat03 = sr1.hrao00 AND hrat04 = sr1.hrao01 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '1001'
	          AND hrat17 = '002'  
	          
	                LET sr.Fstaffs_11 = l_fdm + sr.Fstaffs_11
                  LET sr.Fstaffs_12 = l_fdf + sr.Fstaffs_12
                  LET sr.Fstaffs_21 = l_fim + sr.Fstaffs_21
                  LET sr.Fstaffs_22 = l_fif + sr.Fstaffs_22
                  LET sr.Lstaffs_111 = l_ldfm + sr.Lstaffs_111
                	LET sr.Lstaffs_112 = l_ldff + sr.Lstaffs_112
                  LET sr.Lstaffs_121 = l_ldpm + sr.Lstaffs_121
                  LET sr.Lstaffs_122 = l_ldpf + sr.Lstaffs_122
                  LET sr.Lstaffs_211 = l_lifm + sr.Lstaffs_211
                  LET sr.Lstaffs_212 = l_liff + sr.Lstaffs_212
                  LET sr.Lstaffs_221 = l_lipm + sr.Lstaffs_221
                  LET sr.Lstaffs_222 = l_lipf + sr.Lstaffs_222
                  
       END FOREACH


          SELECT COUNT(DISTINCT hratid) INTO l_fdm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fdf FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fim FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '002'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_fif FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 != '001'
	          AND hrat21 = '002'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldfm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '2001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldff FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '2001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldpm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '1001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_ldpf FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '001'
	          AND hrat19 = '1001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lifm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '2001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_liff FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '2001'
	          AND hrat17 = '002'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lipm FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '1001'
	          AND hrat17 = '001'
	          
	       SELECT COUNT(DISTINCT hratid) INTO l_lipf FROM hrat_file
	        WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratacti = 'Y' AND hrat25 <= g_hrat25 AND hratconf = 'Y'
	          AND hrat28 = '001'
	          AND hrat21 = '002'
	          AND hrat19 = '1001'
	          AND hrat17 = '002'  
	          
	                LET sr.Fstaffs_11 = l_fdm + sr.Fstaffs_11
                  LET sr.Fstaffs_12 = l_fdf + sr.Fstaffs_12
                  LET sr.Fstaffs_21 = l_fim + sr.Fstaffs_21
                  LET sr.Fstaffs_22 = l_fif + sr.Fstaffs_22
                  LET sr.Lstaffs_111 = l_ldfm + sr.Lstaffs_111
                	LET sr.Lstaffs_112 = l_ldff + sr.Lstaffs_112
                  LET sr.Lstaffs_121 = l_ldpm + sr.Lstaffs_121
                  LET sr.Lstaffs_122 = l_ldpf + sr.Lstaffs_122
                  LET sr.Lstaffs_211 = l_lifm + sr.Lstaffs_211
                  LET sr.Lstaffs_212 = l_liff + sr.Lstaffs_212
                  LET sr.Lstaffs_221 = l_lipm + sr.Lstaffs_221
                  LET sr.Lstaffs_222 = l_lipf + sr.Lstaffs_222
                  
	     
	     SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = sr.hrao00
          LET sr.hraa12 = l_hraa12
       SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = sr.hrao10
     	    LET sr.hrao10 = l_hrao02 

          EXECUTE insert_prep USING 
	          	  sr.hraa12,sr.hrao10,g_hrat25,sr.Fstaffs_11,sr.Fstaffs_12,
	          	  sr.Fstaffs_21,sr.Fstaffs_22,sr.Lstaffs_111,sr.Lstaffs_112,
	          	  sr.Lstaffs_121,sr.Lstaffs_122,sr.Lstaffs_211,sr.Lstaffs_212,
                sr.Lstaffs_221,sr.Lstaffs_222 

                 
      END FOREACH
              
   END IF 


 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('ghrr007','ghrr007',l_sql,g_str)
   
END FUNCTiON      