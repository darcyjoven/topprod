# Prog. Version..: '5.30.03-12.09.18(00009)'     #
#
# Pattern name...: ghrr001.4gl
# Descriptions...: 职位说明书
# Date & Author..: 13/08/07   by ye'anping

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
DEFINE l_table1    STRING 
DEFINE l_table2    STRING   
DEFINE l_table3    STRING                                              
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
  # LET g_rep_user = ARG_VAL(14)
  # LET g_rep_clas = ARG_VAL(15)
  # LET g_template = ARG_VAL(16)
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047
 
   display "g_pdate  =",g_pdate
   display "g_towhom =",g_towhom
   display "g_rlang  =",g_rlang
   display "g_bgjob  =",g_bgjob
   display "g_prtway =",g_prtway
   display "g_copies =",g_copies
   display "tm.wc    =",tm.wc
   
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
 
   LET g_sql ="hras01.hras_file.hras01,hrap01.hrap_file.hrap01,",
              "hras04.hras_file.hras04,hras06_1.type_file.chr100,",
              "hras03_1.type_file.chr100,hrar02_1.type_file.chr100,",
              "hras05.hras_file.hras05,hras07.hras_file.hras07,",
              "hras08_1.type_file.chr100,hras09.hras_file.hras09,",      
              "hras10.hras_file.hras10,hras11.hras_file.hras11,",
              "hras12.hras_file.hras12,hras13.hras_file.hras13"    #TQC-C10039 add sign_str

   LET l_table = cl_prt_temptable('ghrr001',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
 
   LET g_sql ="hras01.hras_file.hras01,hrap01.hrap_file.hrap01,hrasb02.hrasb_file.hrasb02,",
              "hrasb03.hrasb_file.hrasb03,hrasb04.hrasb_file.hrasb04,",
              "hrasb05.hrasb_file.hrasb05,hrasb06.hrasb_file.hrasb06"

   LET l_table1 = cl_prt_temptable('ghrr001_b',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   	
  
   LET g_sql ="hras01.hras_file.hras01,hrap01.hrap_file.hrap01,hrasa02.hrasa_file.hrasa02,",
              "hrasa03.hrasa_file.hrasa03,hrasa04.hrasa_file.hrasa04,",
              "hrasa05.hrasa_file.hrasa05"

   LET l_table2 = cl_prt_temptable('ghrr001_a',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
   	
   LET g_sql ="hras01.hras_file.hras01,hrap01.hrap_file.hrap01,",
              "hrasc02.hrasc_file.hrasc02,hrasc03.hrasc_file.hrasc03,",
              "hrasc04.hrasc_file.hrasc04,hrasc05.hrasc_file.hrasc05,",
              "hrasc06.hrasc_file.hrasc06,hrasc07.hrasc_file.hrasc07"

   LET l_table3 = cl_prt_temptable('ghrr001_c',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF

   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr001_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr001()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr001_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hras02         LIKE hras_file.hras02
 
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr001_w AT p_row,p_col WITH FORM "ghr/42f/ghrr001"
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
    CONSTRUCT BY NAME tm.wc ON hras02,hrap01,hrar02,hras03,hras01,hras06

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
       AFTER FIELD hras02
          LET l_hras02 = GET_FLDBUF(hras02)
          IF cl_null(l_hras02) THEN 
          	 NEXT FIELD hras02
          END IF #yeapyeap
          	
       ON ACTION controlp
          CASE
          	  WHEN INFIELD(hrap01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.arg1 = l_hras02  
               LET g_qryparam.state = "c"   #added by yeap NO.130929
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
              WHERE zz01='ghrr001'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr001','9031',1)  
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
          CALL cl_cmdat('ghrr001',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr001_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr001()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr001_w
END FUNCTION
 
FUNCTION ghrr001()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#         l_time    LIKE type_file.chr8               #No.FUN-6A0090
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,  #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                     hras03      LIKE hras_file.hras03,    
                     hras02      LIKE hras_file.hras02,   
                     hras06      LIKE hras_file.hras06,   
                     hras08      LIKE hras_file.hras08,
                     hras01      LIKE hras_file.hras01,
                     hras04      LIKE hras_file.hras04,
                     hras06_1    LIKE type_file.chr100,
                     hras03_1    LIKE type_file.chr100,
                     hrar02_1    LIKE type_file.chr100,
                     hras05      LIKE hras_file.hras05,
                     hras07      LIKE hras_file.hras07,
                     hras08_1    LIKE type_file.chr100,
                     hras09      LIKE hras_file.hras09,
                     hras10      LIKE hras_file.hras10 ,    
                     hras11      LIKE hras_file.hras11,
                     hras12      LIKE hras_file.hras12,
                     hras13      LIKE hras_file.hras13,
                     hrar02      LIKE hrar_file.hrar02,
                     hrap01      LIKE hrap_file.hrap01
                    END RECORD


DEFINE    sr1       RECORD
                     hrasb02     LIKE hrasb_file.hrasb02,
                     hrasb03     LIKE hrasb_file.hrasb03,
                     hrasb04     LIKE hrasb_file.hrasb04,
                     hrasb05     LIKE hrasb_file.hrasb05,
                     hrasb06     LIKE hrasb_file.hrasb06
                    END RECORD,
          sr2       RECORD
                     hrasa02     LIKE hrasa_file.hrasa02,
                     hrasa03     LIKE hrasa_file.hrasa03,
                     hrasa04     LIKE hrasa_file.hrasa04,
                     hrasa05     LIKE hrasa_file.hrasa05,
                     name        LIKE type_file.chr100
                    END RECORD,
          sr3       RECORD 
                     hrasc02     LIKE hrasc_file.hrasc02,
                     hrasc03     LIKE hrasc_file.hrasc03,
                     hrasc04     LIKE hrasc_file.hrasc04,
                     hrasc05     LIKE hrasc_file.hrasc05,
                     hrasc06     LIKE hrasc_file.hrasc06,
                     hrasc07     LIKE hrasc_file.hrasc07
                    END RECORD
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_dept    LIKE pmc_file.pmc03,          #No.MOD-580275
          l_occ02   LIKE occ_file.occ02,
          l_eca04   LIKE eca_file.eca04,
          l_eca04d  LIKE eca_file.eca04,          #TQC-740275 add
          l_sum1,l_sum2,l_sum3    LIKE smh_file.smh103,        #No.FUN-680121 DEC(13,5)
          l_cnt     LIKE type_file.num5           #No.FUN-680121 SMALLINT
   DEFINE l_oea01   LIKE oea_file.oea01
   DEFINE l_ofb01   LIKE ofb_file.ofb01
   DEFINE l_oea04   LIKE oea_file.oea04
   DEFINE l_oea44   LIKE oea_file.oea44
   DEFINE l_sfw02   LIKE sfw_file.sfw02
   DEFINE l_sfw03   LIKE sfw_file.sfw03
   DEFINE l_hrar04  LIKE hrar_file.hrar04 

   DEFINE l_short_qty   LIKE sfa_file.sfa07   #FUN-940008 add
   DEFINE l_sfa  RECORD LIKE sfa_file.*       #FUN-940008 add

   DEFINE            l_img_blob     LIKE type_file.blob



   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) " #No.TQC-A60097 #FUN-A60027 add 3?#MOD-A60129 add ? #FUN-B940042 ADD 3?#TQC-C10039 add 1?
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)" 
   PREPARE insert_prepb FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prepb:",STATUS,1) EXIT PROGRAM
   END IF 
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?,?)" 
   PREPARE insert_prepa FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prepa:",STATUS,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?)" 
   PREPARE insert_prepc FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prepc:",STATUS,1) EXIT PROGRAM
   END IF
     
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#



   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hrasuser', 'hrasgrup')
 
   
   LET l_sql = " SELECT DISTINCT hras03,hras02,hras06,hras08, hras01,hras04,'','','',hras05,",
               "        hras07,'',hras09,hras10,hras11,hras12,hras13,hrar02,''",  #NO.130820   用hrar02代替了‘’
               "   FROM hras_file  LEFT JOIN hrap_file ON hrap03 = hras02 AND hrap05 = hras01",
               "   LEFT JOIN hrar_file ON hras03 = hrar03 ",   #marked by yeap  NO.130820 AND hrar01 = hras02 ",                 #FUN-A60027
               "  WHERE hrasacti='Y' AND ",tm.wc CLIPPED
 
   LET l_sql=l_sql CLIPPED,"  ORDER BY hras01 "   
   PREPARE ghrr001_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('ghrr001_p1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE ghrr001_curs1 CURSOR FOR ghrr001_p1
  
    LET l_sql = "SELECT DISTINCT hrasb02,hrasb03,hrasb04,hrasb05,hrasb06 ",
                  "  FROM hrasb_file",  #  ,hras_file,hrap_file   NO.130812  modified by yeap
                  " WHERE hrasb01 = ?  ",  #AND hrap01 = ?  AND hras01 = hrasb01 AND hras01 = hrap05 AND hras02 = hrap03  NO.130812  modified by yeap
                  " ORDER BY hrasb02 "
      PREPARE ghrr001_p2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr001_p2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE ghrr001_curs2 CURSOR FOR ghrr001_p2 
   
    LET l_sql = "SELECT DISTINCT hrasa02,hrasa03,hrasa04,hrasa05 ",
                  "  FROM hrasa_file ", #  ,hras_file,hrap_file   NO.130812  modified by yeap
                  " WHERE hrasa01 = ?",   #AND hrap01 = ? AND hras01 = hrasa01 AND hras01 = hrap05 AND hras02 = hrap03   NO.130812  modified by yeap
                  " ORDER BY hrasa02 "
      PREPARE ghrr001_p3 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr001_p3:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE ghrr001_curs3 CURSOR FOR ghrr001_p3

    LET l_sql = "SELECT DISTINCT hrasc02,hrasc03,hrasc04,hrasc05,hrasc06,hrasc07 ",
                  "  FROM hrasc_file", #  ,hras_file,hrap_file   NO.130812  modified by yeap
                  " WHERE hrasc01 = ? ", # AND hrap01 = ? AND hras01 = hrasc01 AND hras01 = hrap05 AND hras02 = hrap03   NO.130812  modified by yeap
                  " ORDER BY hrasc02 "
      PREPARE ghrr001_p4 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr001_p4:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE ghrr001_curs4 CURSOR FOR ghrr001_p4

   FOREACH ghrr001_curs1 INTO sr.*
   
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
   
   
   
     	
     		
     	IF NOT cl_null(sr.hras03) THEN 
     		SELECT hrar04 INTO l_hrar04 FROM hrar_file WHERE hrar03 = sr.hras03
     		   LET sr.hras03_1 = l_hrar04
     	END IF 
     		
     	IF NOT cl_null(sr.hrar02) THEN 
     		 CALL s_code('203',sr.hrar02) RETURNING g_hrag.*
     		  LET sr.hrar02_1 = g_hrag.hrag07
     	ELSE
     	   LET sr.hrar02_1 = '暂无'
     	END IF 
     		
     	IF NOT cl_null(sr.hras06) THEN 
     		 CALL s_code('205',sr.hras06) RETURNING g_hrag.*
     		  LET sr.hras06_1 = g_hrag.hrag07
     	END IF
     			
     	IF NOT cl_null(sr.hras08) THEN 
     		 CALL s_code('317',sr.hras08) RETURNING g_hrag.*
     		  LET sr.hras08_1 = g_hrag.hrag07
      ELSE
         LET sr.hras08_1 = '无'
     	END IF 
     	
     	IF NOT cl_null(sr.hras09) THEN 
     	   CASE 
     	   	   WHEN 1 LET sr.hras09 = '不限制'
     	   	   WHEN 2 LET sr.hras09 = '30岁以下'
     	   	   WHEN 3 LET sr.hras09 = '30~40'
     	   	   WHEN 4 LET sr.hras09 = '40岁以下'
     	   	   OTHERWISE LET sr.hras09 = '无'
     	   END CASE 
     	END IF
     	
     	IF NOT cl_null(sr.hras10) THEN 
     	   CASE 
     	   	   WHEN 1 LET sr.hras10 = '不限制'
     	   	   WHEN 2 LET sr.hras10 = '男'
     	   	   WHEN 3 LET sr.hras10 = '女'
     	   	   OTHERWISE LET sr.hras10 = '无'
     	   END CASE 
     	END IF
     	
     	IF cl_null(sr.hras11) THEN 
     		 LET sr.hras11 = '无'
     	END IF
     	
     	IF cl_null(sr.hras12) THEN 
     		 LET sr.hras12 = '无'
     	END IF
     	
     	IF cl_null(sr.hras13) THEN 
     		 LET sr.hras13 = '无'
     	END IF
      
      LET sr.hras07 = cl_replace_str(sr.hras07,'\n   ','')
      
       
       FOREACH ghrr001_curs2 USING sr.hras01 INTO sr1.*  # ,sr.hrap01  NO.130812  modified by yeap
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            
       IF cl_null(sr1.hrasb02) THEN 
     	 	  LET sr1.hrasb02 = '无'
       END IF
       IF cl_null(sr1.hrasb03) THEN 
     	 	  LET sr1.hrasb03 = '无'
       END IF
       IF cl_null(sr1.hrasb04) THEN 
     	 	  LET sr1.hrasb04 = '无'
       END IF
       IF cl_null(sr1.hrasb05) THEN 
     	 	  LET sr1.hrasb05 = '无'
       END IF
       IF cl_null(sr1.hrasb06) THEN 
     	 	  LET sr1.hrasb06 = '无'
       END IF
            
       EXECUTE insert_prepb USING 
               sr.hras01,sr.hrap01,sr1.hrasb02,sr1.hrasb03,sr1.hrasb04,sr1.hrasb05,sr1.hrasb06   
       END FOREACH 
    
    
       FOREACH ghrr001_curs3 USING sr.hras01 INTO sr2.*  # ,sr.hrap01   NO.130812  modified by yeap
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            
       IF cl_null(sr2.hrasa02) THEN 
      		 LET sr2.hrasa02 = '无'
      	END IF
      	IF cl_null(sr2.hrasa03) THEN 
     	  	 LET sr2.hrasa03 = '无'
      	END IF
     	 IF cl_null(sr2.hrasa04) THEN 
     	 	 LET sr2.hrasa04 = '无'
      	END IF
      	IF cl_null(sr2.hrasa05) THEN 
      		 LET sr2.hrasa05 = '无'
      	END IF     
            
       EXECUTE insert_prepa USING 
               sr.hras01,sr.hrap01,sr2.hrasa02,sr2.hrasa03,sr2.hrasa04,sr2.hrasa05   
       END FOREACH 

     
    FOREACH ghrr001_curs4 USING sr.hras01 INTO sr3.*  # ,sr.hrap01  NO.130812  modified by yeap
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            
       IF cl_null(sr3.hrasc02) THEN 
     	 	  LET sr3.hrasc02 = '无'
       END IF
       IF cl_null(sr3.hrasc03) THEN 
     	 	  LET sr3.hrasc03 = '无'
       END IF
       IF cl_null(sr3.hrasc04) THEN 
     	 	  LET sr3.hrasc04 = '无'
       END IF
       IF cl_null(sr3.hrasc07) THEN 
     	 	  LET sr3.hrasc07 = '无'
       END IF
       
       IF NOT cl_null(sr3.hrasc05) THEN 
     	    CASE 
     	   	   WHEN 1 LET sr3.hrasc05 = '内训'
     	   	   WHEN 2 LET sr3.hrasc05 = '外训'
     	    END CASE
     	 ELSE 
     	    LET sr3.hrasc05 = '无' 
     	 END IF 
     		
     	 IF NOT cl_null(sr3.hrasc06) THEN 
     	    CASE 
     	   	   WHEN 1 LET sr3.hrasc06 = '必修'
     	   	   WHEN 2 LET sr3.hrasc06 = '选修'
     	    END CASE 
     	 ELSE 
     	    LET sr3.hrasc06 = '无' 
      	END IF
            
       EXECUTE insert_prepc USING 
               sr.hras01,sr.hrap01,sr3.hrasc02,sr3.hrasc03,sr3.hrasc04,sr3.hrasc05,sr3.hrasc06,sr3.hrasc07  
       END FOREACH   
        
             
       EXECUTE insert_prep USING 
               sr.hras01,sr.hrap01,sr.hras04,sr.hras06_1,sr.hras03_1,sr.hrar02_1,sr.hras05,sr.hras07,  #sr.hrar02_1
               sr.hras08_1,sr.hras09,sr.hras10,sr.hras11,sr.hras12,sr.hras13     
    END FOREACH  
    

 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
              "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
   CALL cl_prt_cs3('ghrr001','ghrr001',l_sql,g_str)
   
END FUNCTiON      