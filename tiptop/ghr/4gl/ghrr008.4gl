# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr008.4gl
# Descriptions...: 员工学历统计表打印
# Date & Author..: 13/08/15   by ye'anping

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
 
   LET g_sql ="str_cord.type_file.chr100,hrat25.hrat_file.hrat25,",
              "hrat22.type_file.chr100,",
              "count.type_file.num5,rate.type_file.num5" 

   LET l_table = cl_prt_temptable('ghrr008',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr008_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr008()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr008_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hras02       LIKE hras_file.hras02
      ,l_hrat25       LIKE hrat_file.hrat25
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr008_w AT p_row,p_col WITH FORM "ghr/42f/ghrr008"
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
          
       AFTER FIELD hras02
          LET l_hras02 = GET_FLDBUF(hras02)
          IF cl_null(l_hras02) THEN 
          	 NEXT FIELD hras02
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
              WHERE zz01='ghrr008'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr008','9031',1)  
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
          CALL cl_cmdat('ghrr008',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr008_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr008()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr008_w
END FUNCTION
 
FUNCTION ghrr008()
   DEFINE l_name      LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql       STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr       LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05      LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc  LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hrat03      LIKE hrat_file.hrat03, 
                     hrat04      LIKE hrat_file.hrat04,
                     hrat22      LIKE hrat_file.hrat22, 
	     	             count       LIKE type_file.num5
                    END RECORD


   DEFINE            l_img_blob     LIKE type_file.blob
   DEFINE            l_str          LIKE type_file.chr100
   DEFINE            l_hraa12       LIKE hraa_file.hraa12
   DEFINE            l_hrao02       LIKE hrao_file.hrao02
   DEFINE            l_count        LIKE type_file.num5



   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

   CALL cl_del_data(l_table) 
   
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?) "
   PREPARE insert_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   
   
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-940042
   #------------------------------ CR (2) ------------------------------#

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
   
   LET tm.wc = cl_replace_str(tm.wc,'hras02','hrat03')
   LET tm.wc = cl_replace_str(tm.wc,'hrat25=','hrat25<')
   
   IF tm.wc.getIndexOf("hrap01",1) THEN 
      LET tm.wc = cl_replace_str(tm.wc,'hrap01','hrat04')
      LET l_sql = " SELECT DISTINCT hrat03,hrat04,hrat22,COUNT(hratid) FROM hrat_file ",
                  "  WHERE hratacti='Y' AND ",tm.wc CLIPPED
      LET l_sql = l_sql,"  GROUP BY hrat03,hrat04,hrat22  ORDER BY hrat03,hrat04,hrat22 "
      PREPARE r008_p1 FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr008_p1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r008_curs1 CURSOR FOR r008_p1
      
      FOREACH r008_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
        
           
           CALL s_code('317',sr.hrat22) RETURNING g_hrag.*
           LET sr.hrat22 = g_hrag.hrag07 
           
           SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = sr.hrat04
           SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = sr.hrat03
           
           LET l_str = l_hraa12,'-',l_hrao02
           SELECT COUNT(hratid) INTO l_count FROM hrat_file WHERE hrat03 = sr.hrat03 AND hrat04 = sr.hrat04 AND hratacti = 'Y' AND hrat25 < g_hrat25
           
          EXECUTE insert_prep USING 
	          	  l_str,g_hrat25,sr.hrat22,sr.count,l_count
                    
      END FOREACH 
      	  
   ELSE 
   	  LET l_sql = " SELECT DISTINCT hrat03,'',hrat22,COUNT(hratid) FROM hrat_file ",
                  "  WHERE hratacti='Y' AND ",tm.wc CLIPPED
      LET l_sql = l_sql,"  GROUP BY hrat03,hrat22  ORDER BY hrat03,hrat22 "
      PREPARE r008_p2 FROM l_sql 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('ghrr008_p2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
      DECLARE r008_curs2 CURSOR FOR r008_p2 
      
      FOREACH r008_curs2 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           
          CALL s_code('317',sr.hrat22) RETURNING g_hrag.*
           LET sr.hrat22 = g_hrag.hrag07 
          
          SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = sr.hrat03
          
          SELECT COUNT(hratid) INTO l_count FROM hrat_file WHERE hrat03 = sr.hrat03 AND hratacti = 'Y' AND hrat25 < g_hrat25
          
           
          EXECUTE insert_prep USING 
	          	  l_hraa12,g_hrat25,sr.hrat22,sr.count,l_count
      
      END FOREACH
              
   END IF 


 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('ghrr008','ghrr008',l_sql,g_str)
   
END FUNCTiON      
