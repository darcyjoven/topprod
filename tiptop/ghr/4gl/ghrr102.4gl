# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr102.4gl
# Descriptions...: 济南离职人员薪资
# Date & Author..: 14/01/21   by shenran

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
DEFINE g_byear        LIKE type_file.chr100
DEFINE g_bmonth       LIKE type_file.chr100
 
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
 
   LET g_sql ="hrat01.hrat_file.hrat01,",
              "hrat02.hrat_file.hrat02,",
              "hrao02.hrao_file.hrao02,",
              "hras04.hras_file.hras04,",
	          "hrat25.hrat_file.hrat25,", 
              "hrad03.hrad_file.hrad03,", 		  
              "sr01.type_file.num26_10,",
              "sr02.type_file.num26_10,",
              "sr03.type_file.num26_10,",
              "sr04.type_file.num26_10,",
              "sr05.type_file.num26_10,",
              "sr06.type_file.num26_10,",
              "sr07.type_file.num26_10,",
              "hrdxa08.hrdxa_file.hrdxa08,",
              "sr08.type_file.num26_10,",
              "sr09.type_file.num26_10,",
              "sr10.type_file.num26_10,",
              "sr11.type_file.num26_10,",
              "sr12.type_file.num26_10,",
              "sr13.type_file.num26_10,",
              "hrdxa14.hrdxa_file.hrdxa14,",
              "sr14.type_file.num26_10,",
              "sr15.type_file.num26_10,",
              "sr16.type_file.num26_10,",
              "sr17.type_file.num26_10,",
              "sr18.type_file.num26_10,",
              "sr19.type_file.num26_10,",
              "sr20.type_file.chr20,",
              "byear.type_file.chr100,",
              "bmonth.type_file.chr100,"
   LET l_table = cl_prt_temptable('ghrr102',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr102_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr102()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr102_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hrat01       LIKE hrat_file.hrat01
      ,l_hrao01       LIKE hrao_file.hrao01
      ,l_byear        LIKE type_file.chr100
      ,l_bmonth       LIKE type_file.chr100
      ,l_hrat02       LIKE hrat_file.hrat02
      ,l_hrao02       LIKE hrao_file.hrao02  
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr102_w AT p_row,p_col WITH FORM "ghr/42f/ghrr102"
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
    CONSTRUCT BY NAME tm.wc ON byear,bmonth,hrao01,hrat01

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       
       AFTER FIELD hrat01
          LET l_hrat01 = GET_FLDBUF(hrat01)
          IF NOT cl_null(l_hrat01) THEN 
          	 SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01 = l_hrat01
          	 DISPLAY l_hrat02 TO FORMONLY.hrat01_name
          END IF 
       AFTER FIELD hrao01
          LET l_hrao01 = GET_FLDBUF(hrao01)
          IF NOT cl_null(l_hrao01) THEN 
          	 SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = l_hrao01
          	 DISPLAY l_hrao02 TO FORMONLY.hrao01_name
          END IF 
       AFTER FIELD byear
          LET g_byear = GET_FLDBUF(byear)
          IF cl_null(g_byear) THEN 
          	 NEXT FIELD byear
          END IF 
          	
       AFTER FIELD bmonth
          LET g_bmonth = GET_FLDBUF(bmonth)
          IF cl_null(g_bmonth) THEN 
          	 NEXT FIELD bmonth
          END IF
          
          	
       ON ACTION controlp
          CASE 
          	  WHEN INFIELD(hrao01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.arg1 = "30"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrao01
                 NEXT FIELD hrao01
            
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 IF NOT cl_null(l_hrao01) THEN
                   LET g_qryparam.form = "q_hrat01_2" 
                   LET g_qryparam.arg1 = l_hrao01
                 ELSE
              	   LET g_qryparam.form = "q_hrat01_3"  
                 END IF
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
             
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
              WHERE zz01='ghrr102'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr102','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\" ")
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
      CALL cl_cmdat('ghrr102',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr102_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr102()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr102_w
END FUNCTION
 
FUNCTION ghrr102()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hrat01       LIKE hrat_file.hrat01,
                     hrat02       LIKE hrat_file.hrat02,
                     hrao02       LIKE hrao_file.hrao02,
                     hras04       LIKE hras_file.hras04,
                     hrat25       LIKE hrat_file.hrat25,
					 hrad03       LIKE hrad_file.hrad03,
                     sr01         LIKE type_file.num26_10,
                     sr02         LIKE type_file.num26_10,
                     sr03         LIKE type_file.num26_10,
                     sr04         LIKE type_file.num26_10,
                     sr05         LIKE type_file.num26_10,
                     sr06         LIKE type_file.num26_10,
                     sr07         LIKE type_file.num26_10, 
                     hrdxa08      LIKE hrdxa_file.hrdxa08,
                     sr08         LIKE type_file.num26_10,
                     sr09         LIKE type_file.num26_10,
                     sr10         LIKE type_file.num26_10,
                     sr11         LIKE type_file.num26_10,
                     sr12         LIKE type_file.num26_10,
                     sr13         LIKE type_file.num26_10,
                     hrdxa14      LIKE hrdxa_file.hrdxa14,
                     sr14         LIKE type_file.num26_10,
		             sr15         LIKE type_file.num26_10,
		             sr16         LIKE type_file.num26_10,
		             sr17         LIKE type_file.num26_10,
		             sr18         LIKE type_file.num26_10,
		             sr19         LIKE type_file.num26_10,
                     sr20         LIKE type_file.chr20
                    END RECORD

   DEFINE l_li     LIKE type_file.num5
   DEFINE l_hraa12  LIKE hraa_file.hraa12
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n   LIKE type_file.num5

   DEFINE            l_img_blob     LIKE type_file.blob



   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   LET tm.wc = cl_replace_str(tm.wc,"byear","hrct01")
   LET tm.wc = cl_replace_str(tm.wc,"bmonth","hrct02")
  
   LET l_sql = " select hrat01,hrat02,hrao02,hras04,hrat25,hrad03,sr01,sr02,sr04 as sr03,sr15 as sr04,sr03 as sr05,sr05+sr13 as sr06,sr06 as sr07,hrdxa08,sr07 as sr08,sr11 as sr09,sr09 as sr10,sr08 as sr11,sr14 as sr12,sr10 as sr13,hrdxa14,sr12 as sr14,sr18 as sr15,sr19 as sr16,sr20 as sr17,sr21 as sr18,sr17 as sr19,hrao01 as sr20",
                   " FROM hrdxa_file",		
                   " LEFT join hrct_file on hrct_file.hrct11=hrdxa_file.hrdxa01",	
                   " LEFT join hrat_file on hrat_file.hratid=hrdxa_file.hrdxa02",	
                   " LEFT join hrao_file on hrao_file.hrao01=hrat_file.hrat04",
                   " LEFT join hras_file on hras_file.hras01=hrat_file.hrat05",
				   " LEFT join hrad_file on hrad_file.hrad02=hrat_file.hrat19",
				   " LEFT join hrbh_file on hrat_file.hratid=hrbh_file.hrbh01",
                   " LEFT join(",  
                   " SELECT hrdxb01,hrdxb02,",
                   " MAX(decode(hrdxb03,5,hrdxb05,0)) sr01,",
                   " MAX(decode(hrdxb03,6,hrdxb05,0)) sr17,",
                   " MAX(decode(hrdxb03,7,hrdxb05,0)) sr02,",
                   " MAX(decode(hrdxb03,10,hrdxb05,0)) sr03,",
                   " MAX(decode(hrdxb03,8,hrdxb05,0)) sr04,",
                   " MAX(decode(hrdxb03,11,hrdxb05,0)) sr05,",
                   " MAX(decode(hrdxb03,12,hrdxb05,0)) sr06,",
                   " MAX(decode(hrdxb03,14,hrdxb05,0)) sr07,",
                   " MAX(decode(hrdxb03,20,hrdxb05,0)) sr08,",
                   " MAX(decode(hrdxb03,19,hrdxb05,0)) sr09,",
                   " MAX(decode(hrdxb03,23,hrdxb05,0)) sr10,",
                   " MAX(decode(hrdxb03,15,hrdxb05,0)) sr11,",
                   " MAX(decode(hrdxb03,17,hrdxb05,0)) sr12,",
                   " MAX(decode(hrdxb03,16,hrdxb05,0)) sr13,",
                   " MAX(decode(hrdxb03,18,hrdxb05,0)) sr14,",
                   " MAX(decode(hrdxb03,22,hrdxb05,0)) sr15,",
                   " MAX(decode(hrdxb03,21,hrdxb05,0)) sr16,",
                   " MAX(decode(hrdxb03,35,hrdxb05,0)) sr18,",
                   " MAX(decode(hrdxb03,40,hrdxb05,0)) sr19,",
                   " MAX(decode(hrdxb03,41,hrdxb05,0)) sr20,",
                   " MAX(decode(hrdxb03,42,hrdxb05,0)) sr21 ",
                   " FROM hrdxb_file",
                   " group by hrdxb01,hrdxb02) t0 on t0.hrdxb01=hrct_file.hrct11 and t0.hrdxb02=hrdxa_file.hrdxa02",
                   " where hrct_file.hrct03='30' and hrbh01 is not null and hrbh09 <>'Y' and nvl(hrat77,to_date('20991231','yyyymmdd')) between hrct07 and hrct08 "                  
      PREPARE r100_p FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr102_p:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r100_curs CURSOR FOR r100_p
      
      FOREACH r100_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
       
          EXECUTE insert_prep USING sr.*,g_byear,g_bmonth
       
                 
      END FOREACH

 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('ghrr102','ghrr102',l_sql,g_str)
   
END FUNCTION      
