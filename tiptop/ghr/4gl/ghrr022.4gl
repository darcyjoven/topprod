# Prog. Version..: '5.30.03-12.09.18(00009)'     
#
# Pattern name...: ghrr022.4gl
# Descriptions...: 公司加班明细表打印
# Date & Author..: 13/08/30   by ye'anping

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
DEFINE g_hrcp03    LIKE hrcp_file.hrcp03  
DEFINE g_hrao00    LIKE hrao_file.hrao00 
DEFINE g_hrao10    LIKE type_file.chr1000  #added by yeap NO.130929
DEFINE g_byear     LIKE type_file.num5
DEFINE g_bmonth    LIKE type_file.num5

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
 
   LET g_sql ="hrat01.hrat_file.hrat01,hrat02.hrat_file.hrat02,",
              "hrat03.type_file.chr100,hrat04.type_file.chr100,",
              "hrat05.type_file.chr100,hrat21.type_file.chr100,",
              "hrcn04.hrcn_file.hrcn04,hrcn08.type_file.chr100,",
              "hrcn09.type_file.chr100,hrcn11.hrcn_file.hrcn11,",
              "year.type_file.num5,month.type_file.num5,",
              "l_num.type_file.num5"

   LET l_table = cl_prt_temptable('ghrr022',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   	
   	
   IF STATUS THEN CALL cl_err('create',STATUS,1) EXIT PROGRAM END IF  #yeap

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN        # If background job sw is off
      CALL ghrr022_tm(0,0)        # Input print condition
   ELSE
      CALL ghrr022()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION ghrr022_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680121 SMALLINT
       l_dir          LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)#Direction Flag
       l_cmd          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(400)
      ,l_hrat03       LIKE hrat_file.hrat03
      ,l_hrcp03       LIKE hrcp_file.hrcp03
      ,l_hraa12       LIKE hraa_file.hraa12 
      ,l_byear        LIKE type_file.num5
      ,l_bmonth       LIKE type_file.num5
  LET p_row = 6 LET p_col = 20
  OPEN WINDOW ghrr022_w AT p_row,p_col WITH FORM "ghr/42f/ghrr022"
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
    CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,byear,bmonth

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
          DISPLAY YEAR(g_today),MONTH(g_today) TO FORMONLY.byear,bmonth
          
       AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(l_hrat03) THEN 
          	 NEXT FIELD hrat03
          ELSE
          	SELECT hraa12 INTO l_hraa12 FROM hraa_file WHERE hraa01 = l_hrat03
          	DISPLAY l_hraa12 TO FORMONLY.hrat03_name
          	 LET g_hrao00 = l_hrat03
             LET l_byear = GET_FLDBUF(byear)
             LET l_bmonth = GET_FLDBUF(bmonth)
          	  IF cl_null(l_byear) OR cl_null(l_bmonth) THEN 
          	 	   NEXT FIELD byear
          	  ELSE 
          	     LET g_byear = l_byear
          	 	   LET g_bmonth = l_bmonth
          	  END IF 
          END IF 
       
       AFTER FIELD byear
          LET l_byear = GET_FLDBUF(byear)
          IF cl_null(l_byear) THEN 
          	 NEXT FIELD byear
          ELSE
          	 LET g_byear = l_byear
          	 LET l_bmonth = GET_FLDBUF(bmonth)
              IF cl_null(l_bmonth) THEN 
          	     NEXT FIELD bmonth
              END IF 
          END IF
          	
       AFTER FIELD bmonth
          LET l_bmonth = GET_FLDBUF(bmonth)
          IF cl_null(l_bmonth) THEN 
          	 NEXT FIELD bmonth
          ELSE
          	 LET g_bmonth = l_bmonth
          END IF
          	
       AFTER FIELD hrat04
         LET g_hrao10 = GET_FLDBUF(hrat04)
         LET l_byear = GET_FLDBUF(byear)
         LET l_bmonth = GET_FLDBUF(bmonth)
          IF cl_null(l_byear) OR cl_null(l_bmonth) THEN 
          	 NEXT FIELD byear
          ELSE 
          	 LET g_byear = l_byear
          	 LET g_bmonth = l_bmonth
          END IF  
          	
       ON ACTION controlp
          CASE 
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03
                 
             WHEN INFIELD(hrat04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrao01"
               LET g_qryparam.arg1 = l_hrat03 
               LET g_qryparam.state = 'c' 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat04
               NEXT FIELD hrat04
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
              WHERE zz01='ghrr022'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('ghrr022','9031',1)  
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
          CALL cl_cmdat('ghrr022',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW ghrr022_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL ghrr022()
    ERROR ""
  END WHILE
 
  CLOSE WINDOW ghrr022_w
END FUNCTION
 
FUNCTION ghrr022()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     STRING,                           # RDSQL STATEMENT   TQC-630166
          l_chr     LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(40)
          l_sfb02doc LIKE type_file.chr30,            #No:TQC-A60097 add
          sr        RECORD
                     hrat01      LIKE hrat_file.hrat01,
                     hrat02      LIKE hrat_file.hrat02,
                     hrat03      LIKE type_file.chr100,
                     hrat04      LIKE type_file.chr100,
                     hrat05      LIKE type_file.chr100,
                     hrat21      LIKE type_file.chr100,
                     hrcn04      LIKE hrcn_file.hrcn04,
                     hrcn08      LIKE hrcn_file.hrcn08,
                     hrcn09      LIKE hrcn_file.hrcn09,
                     hrcn11      LIKE hrcn_file.hrcn11,
                     year        LIKE type_file.num5,
                     month       LIKE type_file.num5
                    END RECORD,
       sr1           RECORD
                     hrao00      LIKE hrao_file.hrao00, 
                     hrao01      LIKE hrao_file.hrao01
                    END RECORD


   DEFINE l_hraa12  LIKE hraa_file.hraa12,
          l_hrao02  LIKE hrao_file.hrao02,
          l_hrbb00  LIKE hrbb_file.hrbb00
   DEFINE l_fdm,l_fdf,l_fim,l_fif LIKE type_file.num5  #foreign,direct/indirect,male/female
   DEFINE l_ldfm,l_ldff,l_ldpm,l_ldpf,l_lifm,l_liff,l_lipm,l_lipf LIKE type_file.num5  #local,direct/indirect,formal/probation,male/female
   DEFINE l_n,l_i   LIKE type_file.num5

   DEFINE  l_img_blob    LIKE type_file.blob
   DEFINE  l_abnormal    LIKE type_file.num5
   DEFINE  l_chidao      LIKE type_file.num5
   DEFINE  l_zaotui      LIKE type_file.num5  	
   DEFINE  l_kuanggong   LIKE type_file.num5
   DEFINE  l_qingjia     LIKE type_file.num5
   DEFINE  l_chuchai     LIKE type_file.num5
   DEFINE  l_nianjia     LIKE type_file.num5
   DEFINE  l_teshujia    LIKE type_file.num5
   DEFINE  l_tiaoxiujia  LIKE type_file.num5
   DEFINE  l_hrbm02      LIKE hrbm_file.hrbm02
   DEFINE  l_directe     LIKE type_file.num15_3 
   DEFINE  l_directn     LIKE type_file.num15_3 
   DEFINE  l_indirecte     LIKE type_file.num15_3 
   DEFINE  l_indirectn     LIKE type_file.num15_3 



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

   LET tm.wc = cl_replace_str(tm.wc,'byear','year(hrcn04)')
   LET tm.wc = cl_replace_str(tm.wc,'bmonth','month(hrcn04)')
   
   LET l_n = 0  
   IF tm.wc.getIndexOf("hrat04",1) THEN 
      LET g_hrao10 = cl_replace_str(g_hrao10,'|',"','")  #added by yeap NO.130929
      LET l_sql = " SELECT DISTINCT hrat01,hrat02,hraa12,hrao02,hras04,hrat21,hrcn04,hrcn08,hrbm04,hrcn11,YEAR(hrcn04),MONTH(hrcn04) ",
       	          "   FROM hrat_file LEFT JOIN hraa_file ON hraa01 = hrat03  LEFT JOIN hras_file ON hras01 = hrat05  ",
       	          "   LEFT JOIN hrao_file ON hrao01 = hrat04, ",
       	          "        hrcn_file LEFT JOIN hrbm_file ON hrbm03 = hrcn09  ", 
       	          "  WHERE hratid = hrcn03 AND hratacti = 'Y' ",
       	          "    AND hratconf = 'Y' AND hrcnacti = 'Y' ",
   	              "    AND hrcnconf = 'Y'  ", 
       	          "    AND hrat03 = '",g_hrao00 CLIPPED,"' AND hrat04 IN ('",g_hrao10 CLIPPED,
       	          "')  AND year(hrcn04) ='",g_byear CLIPPED,"' AND MONTH(hrcn04) ='",g_bmonth CLIPPED,"' ",
       	          "    AND hrat19 <> '3001'"
       	              
      LET l_sql = l_sql," ORDER BY hrat01,YEAR(hrcn04),MONTH(hrcn04) "
      PREPARE r018_p FROM l_sql 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('ghrr022_p:',SQLCA.sqlcode,1)
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
              EXIT PROGRAM
              END IF
      DECLARE r018_curs CURSOR FOR r018_p
           
      FOREACH r018_curs INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           
          CALL s_code('337',sr.hrat21) RETURNING g_hrag.*
           LET sr.hrat21 = g_hrag.hrag07       
          
          LET l_n = l_n + 1
       
          EXECUTE insert_prep USING sr.*,l_n
    	                 
      END FOREACH	
      
      LET l_sql = " SELECT DISTINCT hrao00,hrao01 FROM hrao_file ",
                  "  WHERE   hraoacti='Y' AND hrao00 = '",g_hrao00 CLIPPED,"' AND hrao10 IN ('",g_hrao10 CLIPPED,"')"
      PREPARE r022_p1 FROM l_sql 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('ghrr022_p1:',SQLCA.sqlcode,1)
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
              EXIT PROGRAM
           END IF
      DECLARE r022_curs1 CURSOR FOR r022_p1 
     
      FOREACH r022_curs1 INTO sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
	
           LET l_sql = " SELECT DISTINCT hrat01,hrat02,hraa12,hrao02,hras04,hrat21,hrcn04,hrcn08,hrbm04,hrcn11,YEAR(hrcn04),MONTH(hrcn04) ",
       	               "   FROM hrat_file LEFT JOIN hraa_file ON hraa01 = hrat03 LEFT JOIN hras_file ON hras01 = hrat05 ",
       	               "   LEFT JOIN hrao_file ON hrao01 = hrat04,  ",
       	               "        hrcn_file LEFT JOIN hrbm_file ON hrbm03 = hrcn09  ", 
       	               "  WHERE hratid = hrcn03 AND hratacti = 'Y' ",
       	               "    AND hratconf = 'Y' AND hrcnacti = 'Y' ",
   	                   "    AND hrcnconf = 'Y'  ", 
       	               "    AND hrat03 = '",g_hrao00 CLIPPED,"' AND hrat04 = '",sr1.hrao01 CLIPPED,
       	               "'   AND year(hrcn04) ='",g_byear CLIPPED,"' AND MONTH(hrcn04) ='",g_bmonth CLIPPED,"' ",
       	               "    AND hrat19 <> '3001'"
       	              
       	   LET l_sql = l_sql," ORDER BY hrat01,YEAR(hrcn04),MONTH(hrcn04) "
       	   PREPARE r018_p2 FROM l_sql 
                IF SQLCA.sqlcode != 0 THEN
                   CALL cl_err('ghrr022_p2:',SQLCA.sqlcode,1)
                   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                   EXIT PROGRAM
                END IF
           DECLARE r018_curs2 CURSOR FOR r018_p2
           
           FOREACH r018_curs2 INTO sr.*
                IF SQLCA.sqlcode != 0 THEN
                   CALL cl_err('foreach:',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
                
           CALL s_code('337',sr.hrat21) RETURNING g_hrag.*
           LET sr.hrat21 = g_hrag.hrag07     
           LET l_n = l_n + 1
           EXECUTE insert_prep USING sr.*,l_n
    	                 
           END FOREACH	 
      END FOREACH
  ELSE
  	
  	 LET l_sql = " SELECT DISTINCT hrat01,hrat02,hraa12,hrao02,hras04,hrat21,hrcn04,hrcn08,hrbm04,hrcn11,YEAR(hrcn04),MONTH(hrcn04) ",
       	          "   FROM hrat_file LEFT JOIN hraa_file ON hraa01 = hrat03  LEFT JOIN hras_file ON hras01 = hrat05  ",
       	          "   LEFT JOIN hrao_file ON hrao01 = hrat04,   ",
       	          "        hrcn_file LEFT JOIN hrbm_file ON hrbm03 = hrcn09  ", 
       	          "  WHERE hratid = hrcn03 AND hratacti = 'Y' ",
       	          "    AND hratconf = 'Y' AND hrcnacti = 'Y' ",
   	              "    AND hrcnconf = 'Y'  ", 
       	          "    AND hrat03 = '",g_hrao00 CLIPPED,
       	          "'   AND year(hrcn04) ='",g_byear CLIPPED,"' AND MONTH(hrcn04) ='",g_bmonth CLIPPED,"' ",
       	          "    AND hrat19 <> '3001'"
   	              
   	 LET l_sql = l_sql," ORDER BY hrat01,YEAR(hrcn04),MONTH(hrcn04) "
      PREPARE r018_p3 FROM l_sql 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('ghrr022_p3:',SQLCA.sqlcode,1)
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
              EXIT PROGRAM
              END IF
      DECLARE r018_curs3 CURSOR FOR r018_p3
           
      FOREACH r018_curs3 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
          
          CALL s_code('337',sr.hrat21) RETURNING g_hrag.*
          LET sr.hrat21 = g_hrag.hrag07      
          LET l_n = l_n + 1
       
          EXECUTE insert_prep USING sr.*,l_n
    	                 
      END FOREACH
   END IF 
    LET l_n = 0
 
    LET g_str=''
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('ghrr022','ghrr022',l_sql,g_str)
   
END FUNCTiON      
