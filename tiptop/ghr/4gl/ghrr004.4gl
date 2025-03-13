# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr004.4gl
# Descriptions...: 员工信息简表
# Date & Author..: 13/08/12   by ye'anping

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
 
   LET g_sql ="hras01_1.type_file.chr100,hras02_1.type_file.chr100,",
              "hrao10_1.type_file.chr100,hrap01_1.type_file.chr100,",
              "hrar02_1.type_file.chr100,hraqa04_1.type_file.chr100,",
              "hrat01.hrat_file.hrat01,hrat02.hrat_file.hrat02,",
              "hrat15.hrat_file.hrat15,hrat17_1.type_file.chr100,",      
              "hrat19_1.type_file.chr100,hrat20_1.type_file.chr100,",
              "hrat22_1.type_file.chr100,hrat23.hrat_file.hrat23,",
              "hrat24_1.type_file.chr100,hrat25.hrat_file.hrat25,",
              "hrat29_1.type_file.chr100,hrat40_1.type_file.chr100,",
              "hrat41_1.type_file.chr100,hrat42_1.type_file.chr100,",
              "hrat49.hrat_file.hrat49,hrat50.hrat_file.hrat50"     

   LET l_table = cl_prt_temptable('ghrr004',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr004_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr004()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr004_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hras02       LIKE hras_file.hras02
      ,l_hrat25       LIKE hrat_file.hrat25
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr004_w AT p_row,p_col WITH FORM "ghr/42f/ghrr004"
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
    CONSTRUCT BY NAME tm.wc ON hras02,hrat25,hrap01,hrar02,hras03,hras01,hras06,hrat19,hrat17

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
       AFTER FIELD hras02
          LET l_hras02 = GET_FLDBUF(hras02)
          IF cl_null(l_hras02) THEN 
          	 NEXT FIELD hras02
          END IF 
       
       AFTER FIELD hrat25
          LET l_hrat25 = GET_FLDBUF(hrat25)
          IF cl_null(l_hrat25) THEN 
          	 NEXT FIELD hrat25
          END IF 
          	
       ON ACTION controlp
          CASE
          	  WHEN INFIELD(hrap01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.arg1 = l_hras02  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrap01
               NEXT FIELD hrap01
               
          	  WHEN INFIELD(hrar02)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag06"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = '203'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrar02
               NEXT FIELD hrar02
               
              WHEN INFIELD(hras01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hras01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras01
                 NEXT FIELD hras01
                  
              WHEN INFIELD(hras02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras02
                 NEXT FIELD hras02
                 
              WHEN INFIELD(hras03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrar03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras03
                 NEXT FIELD hras03
                 
             WHEN INFIELD(hras06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '205'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hras06
                 NEXT FIELD hras06
                 
             WHEN INFIELD(hrat17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '333'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat17
                 NEXT FIELD hrat17
                 
              WHEN INFIELD(hrat19)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form = "q_hrad02"
                 LET g_qryparam.state = "c" 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat19
                 NEXT FIELD hrat19 

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
              WHERE zz01='ghrr004'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr004','9031',1)  
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
          CALL cl_cmdat('ghrr004',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr004_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr004()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr004_w
END FUNCTION
 
FUNCTION ghrr004()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hras01      LIKE hras_file.hras01,    
                     hras02      LIKE hras_file.hras02, 
                     hrao10      LIKE hrao_file.hrao10,  
                     hrap01      LIKE hrap_file.hrap01,   
                     hrar02      LIKE type_file.chr100,
                     hraqa04     LIKE hraqa_file.hraqa04,    
                     hrat01      LIKE hrat_file.hrat01,  
                     hrat02      LIKE hrat_file.hrat02,  
                     hrat15      LIKE hrat_file.hrat15,
                     hrat17      LIKE hrat_file.hrat17,
                     hrat19      LIKE type_file.chr100,
                     hrat20      LIKE type_file.chr100,
                     hrat22      LIKE hrat_file.hrat22,
                     hrat23      LIKE hrat_file.hrat23,
                     hrat24      LIKE hrat_file.hrat24,
                     hrat25      LIKE hrat_file.hrat25,
                     hrat29      LIKE hrat_file.hrat29,
                     hrat40      LIKE type_file.chr100,
                     hrat41      LIKE type_file.chr100,
                     hrat42      LIKE hrat_file.hrat42,
                     hrat49      LIKE hrat_file.hrat49,
                     hrat50      LIKE hrat_file.hrat50,
                     hrat67      LIKE hrat_file.hrat67
                    END RECORD

   DEFINE l_hras04  LIKE hras_file.hras04,
          l_hrao10  LIKE hrao_file.hrao10,
          l_hraa12  LIKE hraa_file.hraa12,
          l_hrap02  LIKE hrap_file.hrap02,
          l_hrad03  LIKE hrad_file.hrad03,
          l_hrai04  LIKE hrai_file.hrai04,
          l_hraf02  LIKE hraf_file.hraf02

   DEFINE            l_img_blob     LIKE type_file.blob



   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?) " #No.TQC-A60097 #FUN-A60027 add 3?#MOD-A60129 add ? #FUN-B940042 ADD 3?#TQC-C10039 add 1?
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#



   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   IF tm.wc.getIndexOf("hrap01",1) THEN 
      LET tm.wc = cl_replace_str(tm.wc,'hrap01','hrat04')
   END IF 
   LET tm.wc = cl_replace_str(tm.wc,'hrat25=','hrat25<=')
   LET tm.wc = cl_replace_str(tm.wc,'hras02','hrat03') 
   IF tm.wc.getIndexOf("'3001'",1) THEN  #NO.130813  added by yeap
      LET l_sql = " SELECT DISTINCT hras01,hras02,'',hrat04,hrar02,'',hrat01,hrat02,hrat15,",
                               " hrat17,hrat19,hrat20,hrat22,hrat23,hrat24,hrat25,hrat29,",
                               " hrat40,hrat41,hrat42,hrat49,hrat50,hrat67",
                #  "   FROM hrat_file LEFT JOIN (hras_file  LEFT JOIN hrar_file ON hras03 = hrar03 AND hrar01 = hras02 ) ON hras01 = hrat05 AND hras02 = hrat03 ",  marked by yeap NO.130819
                  "   FROM hrat_file LEFT JOIN (hras_file  LEFT JOIN hrar_file ON hras03 = hrar03 ) ON hras01 = hrat05 AND hras02 = hrat03 ",  #added by yeap NO.130819
                # "   LEFT JOIN hrar_file ON hras03 = hrar03 AND hrar01 = hras02 ",              
                # "  WHERE hrasacti='Y' AND hratacti='Y' AND ",tm.wc CLIPPED
                  "  WHERE hratacti='Y' AND ",tm.wc CLIPPED
   ELSE  #added by yeap
      LET l_sql = " SELECT DISTINCT hras01,hras02,'',hrat04,hrar02,'',hrat01,hrat02,hrat15,",
                               " hrat17,hrat19,hrat20,hrat22,hrat23,hrat24,hrat25,hrat29,",
                               " hrat40,hrat41,hrat42,hrat49,hrat50,hrat67",
                #  "   FROM hrat_file LEFT JOIN (hras_file  LEFT JOIN hrar_file ON hras03 = hrar03 AND hrar01 = hras02 ) ON hras01 = hrat05 AND hras02 = hrat03 ",  marked by yeap NO.130819
                  "   FROM hrat_file LEFT JOIN (hras_file  LEFT JOIN hrar_file ON hras03 = hrar03 ) ON hras01 = hrat05 AND hras02 = hrat03 ",  #added by yeap NO.130819 
                # "   LEFT JOIN hrar_file ON hras03 = hrar03 AND hrar01 = hras02 ",                 #FUN-A60027
                # "  WHERE hrasacti='Y' AND hratacti='Y' AND ",tm.wc CLIPPED
                  "  WHERE hratacti='Y' AND ",tm.wc CLIPPED
                 ,"    AND hrat19 ! = '3001' " #  added by yeap
   END IF         #  added by yeap
   
 
   LET l_sql=l_sql CLIPPED,"  ORDER BY hrat04 "   
   PREPARE ghrr004_p FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('ghrr004_p:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE ghrr004_curs CURSOR FOR ghrr004_p
  
   FOREACH ghrr004_curs INTO sr.*
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF

     	IF NOT cl_null(sr.hras02) THEN 
         SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = sr.hras02
             LET sr.hras02 = l_hraa12
     	END IF 
     		
     	IF NOT cl_null(sr.hrap01) THEN
     	   SELECT hrao10 INTO l_hrao10 FROM hrao_file WHERE hrao01 = sr.hrap01 AND hrao05 = 'N'  #added by yeap NO.130821  加了条件 AND hrao05 = 'N'
     	   IF cl_null(l_hrao10) THEN LET l_hrao10 = sr.hrap01 END IF  #added by yeap NO.130819  当部门的一级部门为空时默认其为一级部门
         SELECT hrao02 INTO sr.hrao10 FROM hrao_file WHERE hrao01 = l_hrao10
     	   SELECT hrap02 INTO l_hrap02 FROM hrap_file WHERE hrap01 = sr.hrap01 AND hrap05 = sr.hras01
     	       LET sr.hrap01 = l_hrap02 
     	END IF 
     	
     	IF NOT cl_null(sr.hrat19) THEN
     	   SELECT hrad03 INTO sr.hrat19 FROM hrad_file WHERE hrad02 = sr.hrat19
     	END IF

     	IF NOT cl_null(sr.hrat40) THEN
     	   SELECT hraf02 INTO sr.hrat40 FROM hraf_file WHERE hraf01 = sr.hrat40
     	END IF
     	
     	IF NOT cl_null(sr.hrat42) THEN
     	   SELECT hrai04 INTO sr.hrat42 FROM hrai_file WHERE hrai03 = sr.hrat42
     	END IF
     		
     	IF NOT cl_null(sr.hrat24) THEN 
     		 CALL s_code('334',sr.hrat24) RETURNING g_hrag.*
     		  LET sr.hrat24 = g_hrag.hrag07
     	END IF
     			
     	IF NOT cl_null(sr.hrat22) THEN 
     		 CALL s_code('317',sr.hrat22) RETURNING g_hrag.*
     		  LET sr.hrat22 = g_hrag.hrag07
     	END IF 
 			
     	IF NOT cl_null(sr.hrat20) THEN 
     		 CALL s_code('313',sr.hrat20) RETURNING g_hrag.*
     		  LET sr.hrat20 = g_hrag.hrag07
     	END IF 
 			
     	IF NOT cl_null(sr.hrar02) THEN 
     		 CALL s_code('203',sr.hrar02) RETURNING g_hrag.*
     		  LET sr.hrar02 = g_hrag.hrag07
     	END IF 
 			
     	IF NOT cl_null(sr.hrat17) THEN 
     		 CALL s_code('333',sr.hrat17) RETURNING g_hrag.*
     		  LET sr.hrat17 = g_hrag.hrag07
     	END IF 
 			
     	IF NOT cl_null(sr.hrat41) THEN 
     		 CALL s_code('325',sr.hrat41) RETURNING g_hrag.*
     		  LET sr.hrat41 = g_hrag.hrag07
     	END IF 
 			
     	IF NOT cl_null(sr.hrat29) THEN 
     		 CALL s_code('301',sr.hrat29) RETURNING g_hrag.*
     		  LET sr.hrat29 = g_hrag.hrag07
     	END IF 
 
     IF NOT cl_null(sr.hrat67) THEN 
     	   SELECT hraqa03 INTO sr.hraqa04 FROM hraqa_file WHERE hraqa01 = sr.hrat67
     	END IF 
     	
     SELECT hras04 INTO l_hras04 FROM hras_file WHERE hras01 = sr.hras01
         LET sr.hras01 = l_hras04 
         
     
         
       EXECUTE insert_prep USING
           sr.hras01,sr.hras02,sr.hrao10,sr.hrap01,sr.hrar02,sr.hraqa04,sr.hrat01,
           sr.hrat02,sr.hrat15,sr.hrat17,sr.hrat19,sr.hrat20,sr.hrat22,sr.hrat23,
           sr.hrat24,sr.hrat25,sr.hrat29,sr.hrat40,sr.hrat41,sr.hrat42,sr.hrat49,
           sr.hrat50  
                     
    END FOREACH  
    

 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('ghrr004','ghrr004',l_sql,g_str)
   
END FUNCTiON      
