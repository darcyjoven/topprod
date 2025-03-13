# Prog. Version..: '5.30.03-12.09.18(00009)'     #
#
# Pattern name...: ghrr041.4gl
# Descriptions...: 考勤专员信息提醒
# Date & Author..: 2015/04/18   by yinbq
#xie150424
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                
            wc     STRING,                
            qj   LIKE type_file.chr1     
           END RECORD               
DEFINE g_sql       STRING                                                   
DEFINE l_table     STRING       
DEFINE l_table1    STRING 
DEFINE l_table2    STRING                                              
DEFINE g_str       STRING
DEFINE g_hrag    RECORD LIKE hrag_file.*   
DEFINE g_hraa01     LIKE hraa_file.hraa01 
MAIN
DEFINE b_date     LIKE hrat_file.hrat25
DEFINE e_date     LIKE hrat_file.hrat25
DEFINE l_hraa     LIKE hraa_file.hraa01


   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT               
 
   LET g_bgjob = ARG_VAL(1)
  # LET b_date = ARG_VAL(2)        # Get arguments from command line
  # LET e_date = ARG_VAL(3)
   LET g_hraa01 = ARG_VAL(2)
#   LET l_hrao = ARG_VAL(3)
 #  LET tm.wc = ARG_VAL(4)
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047
 
   display "g_bgjob =",g_bgjob
   display "b_date =",b_date
   display "e_date =",e_date
   #display "l_hraa  =",l_hraa
  # display "l_hrao  =",l_hrao
   display "tm.wc   =",tm.wc
   
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   LET g_sql =" CR01.hrao_file.hrao02,",
              " CR02.hrat_file.hrat01,",
              " CR03.hrat_file.hrat02,",
              " CR04.hras_file.hras04,",
              " CR05.hrag_file.hrag07,",
              " CR06.hrat_file.hrat25,",
              " CR07.hrao_file.hraoud02"
   LET l_table = cl_prt_temptable('ghrr041',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
 
   LET g_sql =" CR11.hrao_file.hrao02,",
              " CR12.hrat_file.hrat01,",
              " CR13.hrat_file.hrat02,",
              " CR14.hras_file.hras04,",
              " CR15.hrag_file.hrag07,",
              " CR16.hray_file.hray02,",
              " CR17.hrao_file.hraoud02"

   LET l_table1 = cl_prt_temptable('ghrr041_a',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
   	
  
   LET g_sql =" CR21.hrat_file.hrat01,",
              " CR22.hrat_file.hrat02,",
              " CR23.hrao_file.hrao02,",
              " CR24.hraz_file.hraz05,",
              " CR25.hrag_file.hrag07,",
              " CR26.hras_file.hras04,",
              " CR27.hraf_file.hraf02,",
              " CR28.hrao_file.hraoud02"
              

   LET l_table2 = cl_prt_temptable('ghrr041_b',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF

   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr041_tm(0,0)        # Input print condition
   ELSE
      INITIALIZE tm.* TO NULL
       LET tm.wc = " hrat03 = '",g_hraa01,"' AND hrat25 = '",g_today,"'"
#      IF b_date=e_date THEN 
#         LET tm.wc = " bdate ='",b_date,"'"
#      ELSE 
#         LET tm.wc = " bdate between '",b_date,"' and '",e_date,"'"
#      END IF
      CALL ghrr041()            # Read data and create out-file
   END IF
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr041_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_dir          LIKE type_file.chr1,        
       l_cmd          LIKE type_file.chr1000,      
       l_hrat03       LIKE hrat_file.hrat03,
       l_hrat04       LIKE hrat_file.hrat04
 
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr041_w AT p_row,p_col WITH FORM "ghr/42f/ghrr041"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
  CALL cl_ui_init()
  CALL cl_opmsg('p')
 
  INITIALIZE tm.* TO NULL            # Default condition

  LET g_pdate = g_today
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies = '1'
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON bdate,hrat03,hrat04

      BEFORE CONSTRUCT
        CALL cl_qbe_init()
          
        AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(l_hrat03) THEN
            NEXT FIELD hrat03
          END IF
        AFTER FIELD hrat04
          LET l_hrat04 = GET_FLDBUF(hrat04)
        ON ACTION controlp
          CASE
            WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 =l_hrat03
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING l_hrat03
              DISPLAY l_hrat03 TO hrat03
              NEXT FIELD hrat03
              
            WHEN INFIELD(hrat04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrao01"
              LET g_qryparam.arg1 = l_hrat03
              CALL cl_create_qry() RETURNING l_hrat04
              DISPLAY l_hrat04 TO hrat04
              NEXT FIELD hrat04
              
            OTHERWISE
              EXIT CASE
          END CASE 
                    	      
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
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
    
    DISPLAY BY NAME tm.qj                  
    INPUT BY NAME tm.qj WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD qj
          IF tm.qj = 'Y' THEN
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
          
       ON ACTION qbe_save
          CALL cl_qbe_save()

 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='ghrr041'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr041','9031',1)  
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")          #"
          LET l_cmd = l_cmd    CLIPPED,               #(at time fglgo xxxx p1 p2 p3)
               " '",g_pdate    CLIPPED,"'",
               " '",g_towhom   CLIPPED,"'",
               " '",g_rlang    CLIPPED,"'",           #No.FUN-7C0078
               " '",g_bgjob    CLIPPED,"'",
               " '",g_prtway   CLIPPED,"'",
               " '",g_copies   CLIPPED,"'",
               " '",tm.wc      CLIPPED,"'",           #FUN-750047 add
               " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
               " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
               " '",g_template CLIPPED,"'",           #No.FUN-570264
               " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('ghrr041',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr041_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr041()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr041_w
END FUNCTION
 
FUNCTION ghrr041()
DEFINE l_name     LIKE type_file.chr20,             
       l_sql      STRING,                          
       l_chr      LIKE type_file.chr1,              
       l_za05     LIKE type_file.chr1000,          
       l_sfb02doc LIKE type_file.chr30 ,
      l_rep_name STRING      

DEFINE sr        RECORD
       CR01    LIKE   hrao_file.hrao02,
       CR02    LIKE   hrat_file.hrat01,
       CR03    LIKE   hrat_file.hrat02,
       CR04    LIKE   hras_file.hras04,
       CR05    LIKE   hrag_file.hrag07,
       CR06    LIKE   hrat_file.hrat25,
       CR07    LIKE   hrao_file.hraoud02
                 END RECORD
                 
DEFINE sr1       RECORD
       CR11    LIKE   hrao_file.hrao02,
       CR12    LIKE   hrat_file.hrat01,
       CR13    LIKE   hrat_file.hrat02,
       CR14    LIKE   hras_file.hras04,
       CR15    LIKE   hrag_file.hrag07,
       CR16    LIKE   hray_file.hray02,
       CR17    LIKE   hrao_file.hraoud02     
                 END RECORD
                 
DEFINE sr2       RECORD
       CR21    LIKE   hrat_file.hrat01,
       CR22    LIKE   hrat_file.hrat02,
       CR23    LIKE   hrao_file.hrao02,
       CR24    LIKE   hraz_file.hraz05,
       CR25    LIKE   hrag_file.hrag07,
       CR26    LIKE   hras_file.hras04,
       CR27    LIKE   hraf_file.hraf02,
       CR28    LIKE   hrao_file.hraoud02       
                    END RECORD

DEFINE l_img_blob     LIKE type_file.blob
   
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,
                        ?,?) " 
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,  
                        ?,?)" 
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1) EXIT PROGRAM
   END IF 
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?,
                        ?,?,?)" 
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1) EXIT PROGRAM
   END IF
     
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#
   
   LET tm.wc = cl_replace_str(tm.wc,'bdate', 'hrat25')
   
   LET l_sql = " SELECT hrao02,hrat01,hrat02,hras04,hrag07,hrat25,case hraoud02 when '001' then '萧山' when '002' then '海宁' when '003' then '非基地' end",
               " FROM hrat_file",
               " LEFT JOIN hrao_file ON hrao01=hrat04",
               " LEFT JOIN hras_file ON hras01=hrat05",
               " LEFT JOIN hrag_file ON hrag01='337' AND hrag06=hrat21 where ",tm.wc CLIPPED
 
   LET l_sql=l_sql CLIPPED,"  ORDER BY hrat01 "   
   PREPARE ghrr041_p FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('ghrr041_p:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE ghrr041_curs CURSOR FOR ghrr041_p
  
   LET tm.wc = cl_replace_str(tm.wc,'hrat25', 'hray02')
   LET l_sql = " SELECT hrao02,hrat01,hrat02,hras04,hrag07,hray02,case hraoud02 when '001' then '萧山' when '002' then '海宁' when '003' then '非基地' end",
               " FROM hray_file",
               " LEFT JOIN hrat_file ON hratid=hray01",
               " LEFT JOIN hrao_file ON hrao01=hrat04",
               " LEFT JOIN hras_file ON hras01=hrat05",
               " LEFT JOIN hrag_file ON hrag01='337' AND hrag06=hrat21 where ",tm.wc CLIPPED
   PREPARE ghrr041_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('ghrr041_p1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE ghrr041_curs1 CURSOR FOR ghrr041_p1 
   
   LET tm.wc = cl_replace_str(tm.wc,'hray02', 'hraz05')
   LET l_sql = " SELECT hrat01,hrat02,hrao02,hraz05,hrag07,hras04,hraf02,case hraoud02 when '001' then '萧山' when '002' then '海宁' when '003' then '非基地' end",
               " FROM hraz_file",
               " LEFT JOIN hrat_file ON hratid=hraz03",
               " LEFT JOIN hrao_file ON hrao01=hraz08",
               " LEFT JOIN hras_file ON hras01=hraz10",
               " LEFT JOIN hraf_file ON hraf01=hraz14",
               " LEFT JOIN hrag_file ON hrag01='337' AND hrag06=hrat21 where ",tm.wc CLIPPED

   PREPARE ghrr041_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('ghrr041_p2:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE ghrr041_curs2 CURSOR FOR ghrr041_p2
   
   INITIALIZE sr.* TO NULL
   FOREACH ghrr041_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      EXECUTE insert_prep USING sr.*
   END FOREACH   
   
   INITIALIZE sr1.* TO NULL
   FOREACH ghrr041_curs1 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      EXECUTE insert_prep1 USING sr1.*
   END FOREACH 
   
   INITIALIZE sr2.* TO NULL
   FOREACH ghrr041_curs2 INTO sr2.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      EXECUTE insert_prep2 USING sr2.*
   END FOREACH 
 #xie150424            
--{   LET g_str=''
   --LET l_sql= " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED ,"|",
              --" SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
              --" SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
   --CALL cl_prt_cs3('ghrr041','ghrr041',l_sql,g_str)}
--
    LET l_rep_name="ghr/KaoQin.cpt" #&p2=",tm.s_year,"&p3=",tm.s_month  
    LET l_sql= " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
    ,"|",
              " SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
              " SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
IF NOT cl_null(sr.CR02) or NOT cl_null(sr1.CR12)  OR not cl_null(sr2.CR21) THEN  #工号为空不发邮件
                 CALL cl_prt_fine_mail(l_rep_name,l_sql,l_table)  
    END IF 



    
END FUNCTION      
   
 
   
