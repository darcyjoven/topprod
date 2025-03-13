# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr013.4gl
# Descriptions...: 公司一级部门员工学历与年龄性别分析报表
# Date & Author..: 13/08/28   by ye'anping

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
 
   LET g_sql ="hrat03.type_file.chr100,hrao10.type_file.chr100,",
              "hrat25.hrat_file.hrat25,",
              "sum.type_file.num5,edu1.type_file.num5,",
              "edu2.type_file.num5,edu3.type_file.num5,",
              "edu4.type_file.num5,edu5.type_file.num5,",
              "prop.type_file.num5,prom.type_file.num5,",
              "pros.type_file.num5,cage1.type_file.num5,",
              "cage2.type_file.num5,cage3.type_file.num5,",
              "cage4.type_file.num5,cage5.type_file.num5,",
              "age1.type_file.num5,age2.type_file.num5,",
              "age3.type_file.num5,age4.type_file.num5,",
              "age5.type_file.num5,",
              "male.type_file.num5,female.type_file.num5"

   LET l_table = cl_prt_temptable('ghrr013',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr013_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr013()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr013_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hrat03       LIKE hrat_file.hrat03
      ,l_hrat25       LIKE hrat_file.hrat25
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr013_w AT p_row,p_col WITH FORM "ghr/42f/ghrr013"
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
    CONSTRUCT BY NAME tm.wc ON hrat03,hrat25

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          
       AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(l_hrat03) THEN 
          	 NEXT FIELD hrat03
          ELSE 
             LET g_hrao00 = l_hrat03
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
          	  WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03
             
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
              WHERE zz01='ghrr013'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr013','9031',1)  
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
          CALL cl_cmdat('ghrr013',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr013_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr013()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr013_w
END FUNCTION
 
FUNCTION ghrr013()
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
                     hrat22      LIKE hrat_file.hrat22,
                     hrat67      LIKE hrat_file.hrat67,
                     hrat25      LIKE hrat_file.hrat25,
                     hrat16      LIKE hrat_file.hrat16,
                     hrat17      LIKE hrat_file.hrat17,
                     hratid      LIKE hrat_file.hratid
                    END RECORD,
          sr3       RECORD
                     sum         LIKE type_file.num5, 
                     edu1        LIKE type_file.num5,
                     edu2        LIKE type_file.num5,
                     edu3        LIKE type_file.num5,
                     edu4        LIKE type_file.num5,
                     edu5        LIKE type_file.num5, 
                     prop        LIKE type_file.num5,
                     prom        LIKE type_file.num5,
                     pros        LIKE type_file.num5,
                     cage1       LIKE type_file.num5,
                     cage2       LIKE type_file.num5, 
                     cage3       LIKE type_file.num5,
                     cage4       LIKE type_file.num5,
                     cage5       LIKE type_file.num5, 
                     age1        LIKE type_file.num5,
                     age2        LIKE type_file.num5,
                     age3        LIKE type_file.num5,
                     age4        LIKE type_file.num5,
                     age5        LIKE type_file.num5,
                     male        LIKE type_file.num5,
                     female      LIKE type_file.num5
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
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   
   LET tm.wc = cl_replace_str(tm.wc,'hrat25=','hrat25<=')
   
   LET l_sql = " SELECT DISTINCT hrao00,hrao01  FROM hrao_file  WHERE  hrao10 is NULL AND hraoacti='Y' AND hrao00 = '",g_hrao00,"' "
   PREPARE r013_p1 FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr013_p1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
   DECLARE r013_curs1 CURSOR FOR r013_p1 
      
   FOREACH r013_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
           
      LET l_sql = "SELECT DISTINCT hrao00,hrao01,hrao10 FROM hrao_file,hrat_file  ",
                  " WHERE hrao00 = hrat03 AND hraoacti='Y' AND hratacti='Y' AND ",tm.wc CLIPPED,
                  "   AND hrao10 ='",sr.hrao10,"' "	 
      PREPARE r013_p2 FROM l_sql 
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('ghrr013_p2:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM
        END IF
      DECLARE r013_curs2 CURSOR FOR r013_p2
      
      LET sr3.sum = 0
      LET sr3.edu1 = 0
      LET sr3.edu2 = 0
      LET sr3.edu3 = 0
      LET sr3.edu4 = 0
      LET sr3.edu5 = 0
      LET sr3.cage1 = 0
      LET sr3.cage2 = 0
      LET sr3.cage3 = 0
      LET sr3.cage4 = 0
      LET sr3.cage5 = 0
      LET sr3.age1 = 0
      LET sr3.age2 = 0
      LET sr3.age3 = 0
      LET sr3.age4 = 0
      LET sr3.age5 = 0
      LET sr3.prop = 0
      LET sr3.prom = 0
      LET sr3.pros = 0
      LET sr3.male = 0
      LET sr3.female = 0
      
      FOREACH r013_curs2 INTO sr1.*
         IF SQLCA.sqlcode != 0  THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
         END IF 
         
         LET l_sql = "SELECT DISTINCT hrat22,hrat67,hrat25,hrat16,hrat17,hratid  FROM hrat_file  ",
                     " WHERE hratacti='Y' AND hratconf='Y' AND ",tm.wc CLIPPED,
                     "   AND hrat04 = '",sr1.hrao01,"' ",
                     "   AND hrat19 != '3001' "
                  
         LET l_sql = l_sql,"ORDER BY hratid  " 
           
         PREPARE r013_p3 FROM l_sql 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('ghrr013_p3:',SQLCA.sqlcode,1)
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
              EXIT PROGRAM
           END IF
         DECLARE r013_curs3 CURSOR FOR r013_p3

         FOREACH r013_curs3 INTO sr2.*
            IF SQLCA.sqlcode != 0  THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
           
            CASE sr2.hrat22
      	       WHEN '001'   LET sr3.edu1 = sr3.edu1 + 1
            	 WHEN '002'   LET sr3.edu2 = sr3.edu2 + 1
            	 WHEN '003'   LET sr3.edu3 = sr3.edu3 + 1
            	 WHEN '004'   LET sr3.edu4 = sr3.edu4 + 1
            	 WHEN '005'   LET sr3.edu5 = sr3.edu5 + 1
            END CASE 
            
            SELECT hraqa04 INTO sr2.hrat67 FROM hraqa_file WHERE hraqa01 = sr2.hrat67
            CASE sr2.hrat67
      	       WHEN '001'   LET sr3.prop = sr3.prop + 1
            	 WHEN '002'   LET sr3.prom = sr3.prom + 1
            	 WHEN '003'   LET sr3.pros = sr3.pros + 1
            END CASE
            
            LET sr2.hrat25 = (g_hrat25 - sr2.hrat25)/365 
            CASE 
      	       WHEN sr2.hrat25<1                     LET sr3.cage1 = sr3.cage1 + 1
            	 WHEN sr2.hrat25>=1 and sr2.hrat25<3   LET sr3.cage2 = sr3.cage2 + 1
            	 WHEN sr2.hrat25>=3 and sr2.hrat25<5   LET sr3.cage3 = sr3.cage3 + 1
            	 WHEN sr2.hrat25>=5 and sr2.hrat25<8   LET sr3.cage4 = sr3.cage4 + 1
            	 WHEN sr2.hrat25>=8                    LET sr3.cage5 = sr3.cage5 + 1
            END CASE
            
            CASE 
      	       WHEN sr2.hrat16>=20 and sr2.hrat16<30   LET sr3.age1 = sr3.age1 + 1
            	 WHEN sr2.hrat16>=30 and sr2.hrat16<40   LET sr3.age2 = sr3.age2 + 1
            	 WHEN sr2.hrat16>=40 and sr2.hrat16<50   LET sr3.age3 = sr3.age3 + 1
            	 WHEN sr2.hrat16>=50 and sr2.hrat16<55   LET sr3.age4 = sr3.age4 + 1
            	 WHEN sr2.hrat16>=55                     LET sr3.age5 = sr3.age5 + 1
            END CASE

            CASE sr2.hrat17
      	       WHEN '001'   LET sr3.male = sr3.male + 1
            	 WHEN '002'   LET sr3.female = sr3.female + 1
            END CASE
               
            LET sr3.sum = sr3.sum + 1
         
         END FOREACH
      END FOREACH
      
          LET l_sql = "SELECT DISTINCT hrat22,hrat67,hrat25,hrat16,hrat17,hratid  FROM hrat_file  ",
                     " WHERE hratacti='Y' AND hratconf='Y' AND ",tm.wc CLIPPED,
                     "   AND hrat04 = '",sr.hrao10,"' ",
                     "   AND hrat19 != '3001' "
                  
          LET l_sql = l_sql,"ORDER BY hratid  "  
           
          PREPARE r013_p4 FROM l_sql 
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('ghrr013_p4:',SQLCA.sqlcode,1)
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM
            END IF
          DECLARE r013_curs4 CURSOR FOR r013_p4
 
          FOREACH r013_curs4 INTO sr2.*
             IF SQLCA.sqlcode != 0  THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
           
            CASE sr2.hrat22
      	       WHEN '001'   LET sr3.edu1 = sr3.edu1 + 1
            	 WHEN '002'   LET sr3.edu2 = sr3.edu2 + 1
            	 WHEN '003'   LET sr3.edu3 = sr3.edu3 + 1
            	 WHEN '004'   LET sr3.edu4 = sr3.edu4 + 1
            	 WHEN '005'   LET sr3.edu5 = sr3.edu5 + 1
            END CASE 
            
            SELECT hraqa04 INTO sr2.hrat67 FROM hraqa_file WHERE hraqa01 = sr2.hrat67
            CASE sr2.hrat67
      	       WHEN '001'   LET sr3.prop = sr3.prop + 1
            	 WHEN '002'   LET sr3.prom = sr3.prom + 1
            	 WHEN '003'   LET sr3.pros = sr3.pros + 1
            END CASE
            
            LET sr2.hrat25 = (g_hrat25 - sr2.hrat25)/365 
            CASE 
      	       WHEN sr2.hrat25<1                     LET sr3.cage1 = sr3.cage1 + 1
            	 WHEN sr2.hrat25>=1 and sr2.hrat25<3   LET sr3.cage2 = sr3.cage2 + 1
            	 WHEN sr2.hrat25>=3 and sr2.hrat25<5   LET sr3.cage3 = sr3.cage3 + 1
            	 WHEN sr2.hrat25>=5 and sr2.hrat25<8   LET sr3.cage4 = sr3.cage4 + 1
            	 WHEN sr2.hrat25>=8                    LET sr3.cage5 = sr3.cage5 + 1
            END CASE
            
            CASE 
      	       WHEN sr2.hrat16>=20 and sr2.hrat16<30   LET sr3.age1 = sr3.age1 + 1
            	 WHEN sr2.hrat16>=30 and sr2.hrat16<40   LET sr3.age2 = sr3.age2 + 1
            	 WHEN sr2.hrat16>=40 and sr2.hrat16<50   LET sr3.age3 = sr3.age3 + 1
            	 WHEN sr2.hrat16>=50 and sr2.hrat16<55   LET sr3.age4 = sr3.age4 + 1
            	 WHEN sr2.hrat16>=55                     LET sr3.age5 = sr3.age5 + 1
            END CASE

            CASE sr2.hrat17
      	       WHEN '001'   LET sr3.male = sr3.male + 1
            	 WHEN '002'   LET sr3.female = sr3.female + 1
            END CASE
               
            LET sr3.sum = sr3.sum + 1
         
         END FOREACH
         SELECT hraa12 INTO sr.hrao00 FROM hraa_file WHERE hraa01 = sr.hrao00
         SELECT hrao02 INTO sr.hrao10 FROM hrao_file WHERE hrao01 = sr.hrao10 
         EXECUTE insert_prep USING 
                  sr.hrao00,sr.hrao10,g_hrat25,sr3.sum,sr3.edu1,sr3.edu2,sr3.edu3,sr3.edu4,sr3.edu5,
                  sr3.prop,sr3.prom,sr3.pros,sr3.cage1,sr3.cage2,sr3.cage3,sr3.cage4,sr3.cage5,
                  sr3.age1,sr3.age2,sr3.age3,sr3.age4,sr3.age5,sr3.male,sr3.female
     END FOREACH



 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('ghrr013','ghrr013',l_sql,g_str)
   
END FUNCTION      