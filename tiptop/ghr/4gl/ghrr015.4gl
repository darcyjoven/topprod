# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr015.4gl
# Descriptions...: 公司部门离职人员年资与原因统计
# Date & Author..: 13/08/19   by ye'anping

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
DEFINE g_hrat25    LIKE hrat_file.hrat25
DEFINE g_hrao00    LIKE hrao_file.hrao00
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
 
   LET g_sql ="hrao00.type_file.chr100,hrat25.hrat_file.hrat25,",
              "hrao10.type_file.chr100,",
              "how.type_file.chr100,hlong.type_file.chr100,",
              "count.type_file.num5,sum1.type_file.num5,",
              "rate.type_file.num5,cause.type_file.chr100," ,
              "cause1.type_file.num5,cause2.type_file.num5," ,
              "cause3.type_file.num5,sum2.type_file.num5" 

   LET l_table = cl_prt_temptable('ghrr015',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr015_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr015()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr015_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hras02       LIKE hras_file.hras02
      ,l_hrat25       LIKE hrat_file.hrat25
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr015_w AT p_row,p_col WITH FORM "ghr/42f/ghrr015"
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
    CONSTRUCT BY NAME tm.wc ON hras02,hrat25

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
       AFTER FIELD hras02
          LET l_hras02 = GET_FLDBUF(hras02)
          IF cl_null(l_hras02) THEN 
          	 NEXT FIELD hras02
          ELSE 
             LET g_hrao00 = l_hras02
          	 NEXT FIELD hrat25 
          END IF 
       
       AFTER FIELD hrat25
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
              WHERE zz01='ghrr015'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr015','9031',1)  
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
          CALL cl_cmdat('ghrr015',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr015_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr015()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr015_w
END FUNCTION
 
FUNCTION ghrr015()
   DEFINE l_name      LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql       STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr       LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05      LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc  LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hrao00      LIKE type_file.chr100, 
                     hrao10      LIKE type_file.chr100
                    END RECORD,
          sr1       RECORD
                     hrao00      LIKE hrao_file.hrao00, 
                     hrao01      LIKE hrao_file.hrao01,
                     hrao10      LIKE hrao_file.hrao10
                    END RECORD,
          sr2       RECORD
                     hlong       LIKE type_file.chr100, 
                     count       LIKE type_file.num5
                    END RECORD,
          sr3       RECORD
                     cause       LIKE type_file.chr100, 
                     count       LIKE type_file.num5
                    END RECORD,
          sr4       RECORD
                     sum         LIKE type_file.num5, 
                     rate        LIKE type_file.num5,
                     count       LIKE type_file.num5,
                     cause1      LIKE type_file.num5,
                     cause2      LIKE type_file.num5,
                     cause3      LIKE type_file.num5
                    END RECORD


   DEFINE            l_img_blob     LIKE type_file.blob
   DEFINE            l_str          LIKE type_file.chr100
   DEFINE            l_hraa12       LIKE hraa_file.hraa12
   DEFINE            l_hrao02       LIKE hrao_file.hrao02
   DEFINE            l_hrat16       LIKE type_file.chr100
   DEFINE            l_count        LIKE type_file.num5
   DEFINE            l_n            LIKE type_file.num5
   DEFINE            l_sum1         LIKE type_file.num10
   DEFINE            l_sum2         LIKE type_file.num10
   DEFINE            l_hlong        LIKE type_file.chr100
   DEFINE            l_how          LIKE type_file.chr100
   DEFINE            l_cause        LIKE type_file.chr100
   DEFINE            l_cause1       LIKE type_file.num5
   DEFINE            l_cause2       LIKE type_file.num5
   DEFINE            l_cause3       LIKE type_file.num5
   


   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   
   LET tm.wc = cl_replace_str(tm.wc,'hras02','hrat03')
   LET tm.wc = cl_replace_str(tm.wc,'hrat25=','hrat25<=')
   
   LET l_sql = " SELECT DISTINCT hrao00,hrao01  FROM hrao_file  WHERE  hrao10 is NULL AND hraoacti='Y' AND hrao00 = '",g_hrao00,"' "
   PREPARE r015_p1 FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr015_p1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
   DECLARE r015_curs1 CURSOR FOR r015_p1 
      
   FOREACH r015_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
           
      LET l_sql = "SELECT DISTINCT hrao00,hrao01,hrao10 FROM hrao_file,hrat_file  ",
                  " WHERE hrao00 = hrat03 AND hraoacti='Y' AND hratacti='Y' AND ",tm.wc CLIPPED,
                  "   AND hrao10 ='",sr.hrao10,"' "	 
      PREPARE r015_p2 FROM l_sql 
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('ghrr015_p2:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM
        END IF
      DECLARE r015_curs2 CURSOR FOR r015_p2
      LET l_n = 0
   #   INITIALIZE sr4.* TO NULL 
      LET sr4.sum = 0
      LET sr4.rate = 0
      LET sr4.count = 0
      LET sr4.cause1 = 0
      LET sr4.cause2 = 0
      LET sr4.cause3 = 0
      
      FOREACH r015_curs2 INTO sr1.*
         IF SQLCA.sqlcode != 0  THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
         END IF
         LET l_n = 1 
         LET l_sql = "SELECT DISTINCT CASE WHEN ((hrbh04-hrat25)/365<=0.5) THEN 1 WHEN ((hrbh04-hrat25)/365>0.5 AND (hrbh04-hrat25)/365<=1 ) THEN 2 ",
                                        "  WHEN ((hrbh04-hrat25)/365>1 AND (hrbh04-hrat25)/365<=3) THEN 3 WHEN ((hrbh04-hrat25)/365>3 AND (hrbh04-hrat25)/365<=5) THEN 4 ",
                                        "  WHEN ((hrbh04-hrat25)/365>5) THEN 5 END ,COUNT(hratid)  FROM hrat_file,hrbh_file  ",
                     " WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND ",tm.wc CLIPPED,
                     "   AND (hrat04 = '",sr1.hrao01,"' OR hrat04 ='",sr1.hrao10,"')",
                     "   AND hrat19 = '3001' "
                  
         LET l_sql = l_sql,"GROUP BY (hrbh04-hrat25)/365  " 
           
         PREPARE r015_p3 FROM l_sql 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('ghrr015_p3:',SQLCA.sqlcode,1)
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
              EXIT PROGRAM
           END IF
         DECLARE r015_curs3 CURSOR FOR r015_p3

         FOREACH r015_curs3 INTO sr2.*
            IF SQLCA.sqlcode != 0  THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
           
            CASE sr2.hlong
      	       WHEN 1   LET l_hlong = "6个月以内"
            	 WHEN 2   LET l_hlong = "6个月~1年"
            	 WHEN 3   LET l_hlong = "1年~3年"
            	 WHEN 4   LET l_hlong = "3年~5年"
            	 WHEN 5   LET l_hlong = "5年~以上"
            END CASE 

            LET sr4.count = sr4.count + sr2.count
            
            SELECT  COUNT(DISTINCT hratid) INTO l_sum1 FROM hrat_file 
             WHERE hrat03 = sr.hrao00 AND (hrat04 = sr1.hrao01 OR hrat04 = sr1.hrao10) AND hratconf = 'Y' 
               AND hrat25<=g_hrat25 
               
            SELECT  COUNT(DISTINCT hratid) INTO l_sum2 FROM hrat_file,hrbh_file 
             WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratconf = 'Y' 
               AND hrat25<=g_hrat25 AND hrat19 = '3001' 
               AND hratid = hrbh01  AND hrbhconf = '2' 
               
            LET sr4.sum = sr4.sum + l_sum1
            LET sr4.rate = sr4.rate + l_sum2 
         
         END FOREACH
         
         
         LET l_sql = "SELECT DISTINCT CASE WHEN (hrbh05 = '001') THEN 1 WHEN (hrbh05 = '002') THEN 2 ",
                                        "  WHEN (hrbh05 = '003') THEN 3 END AS a,COUNT(hratid) FROM hrat_file,hrbh_file  ",
                     " WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND ",tm.wc CLIPPED,
                     "   AND (hrat04 ='",sr1.hrao01,"' OR hrat04 = '",sr1.hrao10 ,"' )"	,
                     "   AND hrat19 = '3001' "
                  
         LET l_sql = l_sql,"GROUP BY hrbh05  ORDER BY a "  
           
         PREPARE r015_p4 FROM l_sql 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('ghrr015_p4:',SQLCA.sqlcode,1)
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
              EXIT PROGRAM
           END IF
         DECLARE r015_curs4 CURSOR FOR r015_p4


         FOREACH r015_curs4 INTO sr3.*
            IF SQLCA.sqlcode != 0  THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
           
            CASE sr3.cause
      	       WHEN 1   LET l_cause = "家庭问题"
      	       WHEN 2   LET l_cause = "学习深造"
      	       WHEN 3   LET l_cause = "身体问题"
            END CASE
            
            
            SELECT COUNT(hratid) INTO l_cause1 FROM hrat_file,hrbh_file 
             WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND hrat03 = sr.hrao00 
               AND hrat25<=g_hrat25 AND (hrat04 = sr1.hrao01 OR hrat04 = sr1.hrao10 )
               AND hrat19 = '3001' AND hrbh05 = '001'
         
            SELECT COUNT(hratid) INTO l_cause2 FROM hrat_file,hrbh_file 
             WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND hrat03 = sr.hrao00 
               AND hrat25<=g_hrat25 AND (hrat04 = sr1.hrao01 OR hrat04 = sr1.hrao10 )
               AND hrat19 = '3001' AND hrbh05 = '002' 
         
            SELECT COUNT(hratid) INTO l_cause3 FROM hrat_file,hrbh_file 
             WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND hrat03 = sr.hrao00 
               AND hrat25<=g_hrat25 AND (hrat04 = sr1.hrao01 OR hrat04 = sr1.hrao10 )
               AND hrat19 = '3001' AND hrbh05 = '003'
               
               
               LET sr4.cause1 = sr4.cause1 + l_cause1
               LET sr4.cause2 = sr4.cause2 + l_cause2
               LET sr4.cause3 = sr4.cause3 + l_cause3

         END FOREACH  
       
      END FOREACH
         
       IF l_n !=1 THEN 
          LET l_sql = "SELECT DISTINCT CASE WHEN ((hrbh04-hrat25)/365<=0.5) THEN 1 WHEN ((hrbh04-hrat25)/365>0.5 AND (hrbh04-hrat25)/365<=1 ) THEN 2 ",
                                        "  WHEN ((hrbh04-hrat25)/365>1 AND (hrbh04-hrat25)/365<=3) THEN 3 WHEN ((hrbh04-hrat25)/365>3 AND (hrbh04-hrat25)/365<=5) THEN 4 ",
                                        "  WHEN ((hrbh04-hrat25)/365>5) THEN 5 END ,COUNT(hratid)  FROM hrat_file,hrbh_file  ",
                      " WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND ",tm.wc CLIPPED,
                      "   AND hrat04 ='",sr.hrao10,"'",
                      "   AND hrat19 = '3001' "
                  
          LET l_sql = l_sql,"GROUP BY (hrbh04-hrat25)/365  "  
           
          PREPARE r015_p5 FROM l_sql 
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('ghrr015_p5:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM
            END IF
          DECLARE r015_curs5 CURSOR FOR r015_p5
 
          FOREACH r015_curs5 INTO sr2.*
             IF SQLCA.sqlcode != 0  THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
           
             CASE sr2.hlong
                WHEN 1   LET l_hlong = "6个月以内"
              	WHEN 2   LET l_hlong = "6个月~1年"
         	      WHEN 3   LET l_hlong = "1年~3年"
      	        WHEN 4   LET l_hlong = "3年~5年"
      	        WHEN 5   LET l_hlong = "5年以上"
             END CASE 

             LET sr4.count = sr4.count + sr2.count
             
             SELECT  COUNT(DISTINCT hratid) INTO l_sum1 FROM hrat_file 
             WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratconf = 'Y' 
               AND hrat25<=g_hrat25 
               
            SELECT  COUNT(DISTINCT hratid) INTO l_sum2 FROM hrat_file,hrbh_file 
             WHERE hrat03 = sr.hrao00 AND hrat04 = sr.hrao10 AND hratconf = 'Y' 
               AND hrat25<=g_hrat25 AND hrat19 = '3001' 
               AND hratid = hrbh01  AND hrbhconf = '2'
               
            LET sr4.sum = sr4.sum + l_sum1
            LET sr4.rate = sr4.rate + l_sum2
         
          END FOREACH
          
          LET l_sql = "SELECT DISTINCT CASE WHEN (hrbh05 = '001') THEN 1 WHEN (hrbh05 = '002') THEN 2 ",
                                         "  WHEN (hrbh05 = '003') THEN 3 END AS a ,COUNT(hratid) FROM hrat_file,hrbh_file  ",
                      " WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND ",tm.wc CLIPPED,
                      "   AND hrat04 ='",sr.hrao10,"'",
                      "   AND hrat19 = '3001' "
                  
          LET l_sql = l_sql,"GROUP BY hrbh05  ORDER BY a "   
           
          PREPARE r015_p6 FROM l_sql 
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('ghrr015_p6:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM
            END IF
          DECLARE r015_curs6 CURSOR FOR r015_p6


          FOREACH r015_curs6 INTO sr3.*
             IF SQLCA.sqlcode != 0  THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
           
             CASE sr3.cause
      	        WHEN 1   LET l_cause = "家庭问题"
      	        WHEN 2   LET l_cause = "学习深造"
      	        WHEN 3   LET l_cause = "身体问题"
             END CASE
             
             
             SELECT COUNT(hratid) INTO l_cause1 FROM hrat_file,hrbh_file 
             WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND hrat03 = sr.hrao00 
               AND hrat25<=g_hrat25 AND hrat04 = sr.hrao10
               AND hrat19 = '3001' AND hrbh05 = '001'
         
            SELECT COUNT(hratid) INTO l_cause2 FROM hrat_file,hrbh_file 
             WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND hrat03 = sr.hrao00 
               AND hrat25<=g_hrat25 AND hrat04 = sr.hrao10
               AND hrat19 = '3001' AND hrbh05 = '002' 
         
            SELECT COUNT(hratid) INTO l_cause3 FROM hrat_file,hrbh_file 
             WHERE hratid = hrbh01 AND hratacti='Y' AND hrbhconf='2' AND hrat03 = sr.hrao00 
               AND hrat25<=g_hrat25 AND hrat04 = sr.hrao10
               AND hrat19 = '3001' AND hrbh05 = '003'
               
               LET sr4.cause1 = sr4.cause1 + l_cause1
               LET sr4.cause2 = sr4.cause2 + l_cause2
               LET sr4.cause3 = sr4.cause3 + l_cause3
          END FOREACH  
       END IF 

       SELECT hrao02 INTO sr.hrao10 FROM hrao_file WHERE hrao01 = sr.hrao10
       SELECT hraa12 INTO sr.hrao00 FROM hraa_file WHERE hraa01 = sr.hrao00  
       
       LET l_how = "离职人员年资"
       
       EXECUTE insert_prep USING 
           sr.hrao00,g_hrat25,sr.hrao10,l_how,l_hlong,sr4.count,sr4.sum,sr4.rate,
           l_cause,sr4.cause1,sr4.cause2,sr4.cause3,sr3.count
       

   END FOREACH



 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('ghrr015','ghrr015',l_sql,g_str)
   
END FUNCTION      