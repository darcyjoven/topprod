# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asrr220.4gl (copy from asr210.4gl)
# Descriptions...: 工單退料單列印
# Input parameter:
# Return code....:
# Date & Author..: 06/03/02 By kim
 
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0143 06/12/25 By Ray 背景作業報表無法打印
# Modify.........: No.TQC-770003 07/07/01 By hongmei help按鈕不可用
# Modify.........: No.FUN-7C0034 07/12/17 By ChenMoyan 轉CR報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		             # Print condition RECORD
        wc      LIKE type_file.chr1000,      # Where Condition  #No.FUN-680130 VARCHAR(600)
        p       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
        q       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
        r       LIKE type_file.chr1,         #No.FUN-680130 VARCHAR(1)
   	more	LIKE type_file.chr1   	     # Input more condition(Y/N)     #No.FUN-680130 VARCHAR(1)
        END RECORD,
        g_argv1       LIKE sfp_file.sfp01,
        g_no          LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE  g_sql,g_sql1,g_sql2         STRING   #No.FUN-7C0034
DEFINE  l_table       STRING                 #No.FUN-7C0034
DEFINE  l_table1      STRING                 #No.FUN-7C0034
DEFINE  l_table2      STRING                 #No.FUN-7C0034
DEFINE  g_str         STRING                 #No.FUN-7C0034 
DEFINE  g_cnt         LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE  g_i           LIKE type_file.num5    #count/index for any purpose        #No.FUN-680130 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
   
   ##No.FUN-7C0034  --Begin 錄入CR所需的暫存檔
   LET g_sql="sfp01.sfp_file.sfp01,",
             "sfp02.sfp_file.sfp02,",
             "sfp03.sfp_file.sfp03,",
             "gen02.gen_file.gen02,",
             "sfp07.sfp_file.sfp07,",
             "sfp04.sfp_file.sfp04,",
             "ima23.ima_file.ima23,",
             "order1.sfs_file.sfs04,",
             "order2.sfs_file.sfs03,",
             "sfs02.sfs_file.sfs02"
   LET l_table = cl_prt_temptable('asrr220',g_sql)CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql1="sfq02.sfq_file.sfq02,",                                                                                              
              "sfq04.sfq_file.sfq04,",                                                                                              
              "sfq05.sfq_file.sfq05,",                                                                                              
              "sfq03.sfq_file.sfq03,",                                                                                              
              "ima02.ima_file.ima02,",
              "sfp01.sfp_file.sfp01"
   LET l_table1 = cl_prt_temptable('asrr220_1',g_sql1)CLIPPED                                                                          
   IF l_table1 = -1 THEN EXIT PROGRAM END IF 
   LET g_sql2="sfs02.sfs_file.sfs02,",         
              "sfs03.sfs_file.sfs03,",
              "sfs06.sfs_file.sfs06,",
              "sfs07.sfs_file.sfs07,",
              "sfs08.sfs_file.sfs08,",
              "sfs09.sfs_file.sfs09,",
              "sfs04.sfs_file.sfs04,",
              "sfs05.sfs_file.sfs05,",
              "img10.img_file.img10,",
              "ima02_2.ima_file.ima02,",
              "ima23.ima_file.ima23,",
              "order1.sfs_file.sfs04,",
              "order2.sfs_file.sfs03,",
              "sfp01.sfp_file.sfp01"
   LET l_table2 = cl_prt_temptable('asrr220_2',g_sql2)CLIPPED                                                                         
   IF l_table2 = -1 THEN EXIT PROGRAM END IF   
   #No.FUN-7C0034  --End   
   
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_argv1  = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
  #No.FUN-570264 ---end---
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
      IF cl_null(g_argv1) THEN
         CALL r220_tm()
      ELSE
         LET tm.wc=" sfp01 = '",g_argv1,"'"
         CALL cl_wait()
   #      CALL r220_out()                       #No.FUN-7C0034
         CALL asrr220()                         #No.FUN-7C0034 
      END IF
   ELSE                                  	# Read data and create out-file
       LET tm.wc=" sfp01 = '",g_argv1,"'"       #No.TQC-6C0143
   #    CALL r220_out()                         #No.FUN-7C0034
       CALL asrr220()                           #No.FUN-7C0034
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION r220_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE l_cmd	     LIKE type_file.chr1000     #No.FUN-680130 VARCHAR(400) 
DEFINE p_row,p_col   LIKE type_file.num5        #No.FUN-680130 SMALLINT
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW r220_w AT p_row,p_col
        WITH FORM "asr/42f/asrr220"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET tm.p='Y'
   LET tm.q= '1'
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'   
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfp01,sfp02,sfp03,sfp07
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
           ON ACTION locale
               LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               EXIT CONSTRUCT
         #### No.FUN-4A0005
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(sfp01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfp3"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfp01
                   NEXT FIELD sfp01
 
                 WHEN INFIELD(sfp07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gem"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfp07
                   NEXT FIELD sfp07
              END CASE
         ### END  No.FUN-4A0005
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
           ON ACTION CONTROLG
              CALL cl_cmdask()  # Command execution
 
           ON ACTION exit
              LET INT_FLAG = 1
              EXIT CONSTRUCT
              
            ON ACTION help           #No.TQC-770003                                                                                                     
              CALL cl_show_help()   #No.TQC-770003  
              
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
   DISPLAY BY NAME tm.p,tm.q,tm.more # Condition
   INPUT BY NAME tm.p,tm.q,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD p
         IF cl_null(tm.p) THEN NEXT FIELD p END IF
    	 IF tm.p NOT MATCHES '[YN]' THEN
    	    NEXT FIELD p
    	 END IF
      AFTER FIELD q
         IF cl_null(tm.q) THEN NEXT FIELD q END IF
    	 IF tm.q NOT MATCHES '[12]' THEN
    	    NEXT FIELD q
    	 END IF
      AFTER FIELD more
    	 IF tm.more NOT MATCHES '[YN]' THEN
    	    NEXT FIELD more
    	 END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON ACTION CONTROLP
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
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='asrr220'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asrr220','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asrr220',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r220_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   #CALL r220_out()                             #No.FUN-7C0034
   CALL asrr220()                               #No.FUN-7C0034
   ERROR ""
 END WHILE
 CLOSE WINDOW r220_w
END FUNCTION
 
#No.FUN-7C0034  ------BEGIN
FUNCTION asrr220()
DEFINE    l_name   LIKE type_file.chr20,         #No.FUN-680130 VARCHAR(20)
          l_sql    LIKE type_file.chr1000,       #No.FUN-680130 VARCHAR(1000)
          l_sfp		RECORD LIKE sfp_file.*,
          l_sfq		RECORD LIKE sfq_file.*,
          l_gen02       LIKE gen_file.gen02,
          l_ima02       LIKE ima_file.ima02,
          sr  RECORD
              order1	LIKE type_file.chr20,    #No.FUN-680130 VARCHAR(20)
              order2	LIKE type_file.chr20,    #No.FUN-680130 VARCHAR(20)
              sfs02	LIKE sfs_file.sfs02,
              sfs03	LIKE sfs_file.sfs03,
              sfs04	LIKE sfs_file.sfs04,
              sfs05	LIKE sfs_file.sfs05,
              sfs06	LIKE sfs_file.sfs06,
              sfs07	LIKE sfs_file.sfs07,
              sfs08	LIKE sfs_file.sfs08,
              sfs09	LIKE sfs_file.sfs09,
              sfs10	LIKE sfs_file.sfs10,
              sfs26	LIKE sfs_file.sfs26,
              ima02	LIKE ima_file.ima02,
              ima23	LIKE ima_file.ima23,
              img10	LIKE img_file.img10
              END RECORD
#NO.FUN-7C0034-----START---------
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                 " VALUES(?,?,?,?,?,?,?,?,?,?)"             
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                  
         CALL cl_err('insert_prep:',status,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM                                                                          
     END IF
     
     LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                      
                " VALUES(?,?,?,?,?,?)"           
     PREPARE insert_prep1 FROM g_sql1                                                                                              
     IF STATUS THEN                                                                                                                  
         CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM                                                                      
     END IF
     LET g_sql2 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                         
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                                                                                              
     PREPARE insert_prep2 FROM g_sql2                                                                                                
     IF STATUS THEN                                                                                                                 
         CALL cl_err('insert_prep2:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM                                                                         
     END IF      
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
#NO.FUN-7C0034------------END----
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='asrr220'
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN
     #        LET tm.wc = tm.wc clipped,"AND oqauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN
     #        LET tm.wc = tm.wc clipped,"AND oqagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN
     #        LET tm.wc = tm.wc clipped,"AND oqagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oqauser', 'oqagrup')
     #End:FUN-980030
     LET l_sql = " SELECT * FROM sfp_file",
                 "  WHERE ",tm.wc CLIPPED,
                 "    AND sfp06 ='B' AND sfpconf!='X' " #FUN-660106
     PREPARE r220_pr1 FROM l_sql
     IF STATUS THEN 
        CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM END IF
     DECLARE r220_cs1 CURSOR FOR r220_pr1
 
    # CALL cl_outnam('asrr220') RETURNING l_name
 
     LET g_pageno = 0
     LET g_no = 0
     #START REPORT r220_rep TO l_name
 
     FOREACH r220_cs1 INTO l_sfp.*           #子報表
       IF STATUS THEN 
          CALL cl_err('for sfp:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
          EXIT PROGRAM 
       END IF
       DECLARE r220_cs3 CURSOR FOR                                                                                                    
                  SELECT * FROM sfq_file                                                                                            
                   WHERE sfq01=l_sfp.sfp01                                                                                          
       FOREACH r220_cs3 INTO l_sfq.*                                                                                                  
          IF SQLCA.SQLCODE THEN CONTINUE FOREACH END IF                                                                               
          SELECT ima02 INTO l_ima02 FROM ima_file                                                                                     
            WHERE ima01=l_sfq.sfq02                                                                                                  
          IF SQLCA.sqlcode THEN                                                                                                       
             LET l_ima02=''                                                                                                           
          END IF 
          EXECUTE insert_prep1 USING
              l_sfq.sfq02,l_sfq.sfq04,l_sfq.sfq05,l_sfq.sfq03,l_ima02,l_sfp.sfp01
       END FOREACH 
       IF l_sfp.sfp04='N' THEN 
          LET l_sql="SELECT '','',sfs02,sfs03,sfs04,sfs05,sfs06,sfs07,",
                    "          sfs08,sfs09,sfs10,sfs26,'','',0",
                    "  FROM sfs_file WHERE sfs01='",l_sfp.sfp01,"'"
       ELSE 
          LET l_sql="SELECT '','',sfe28,sfe01,sfe07,sfe16,sfe17,sfe08,",
                    "          sfe09,sfe10,sfe14,sfe26,'','',0",
                    "  FROM sfe_file WHERE sfe02='",l_sfp.sfp01,"'"
       END IF
       PREPARE r220_pr2 FROM l_sql
       IF STATUS THEN 
          CALL cl_err('prepare2:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
          EXIT PROGRAM 
       END IF
       DECLARE r220_cs2 CURSOR FOR r220_pr2
       FOREACH r220_cs2 INTO sr.*
          CASE tm.q WHEN '1'  LET sr.order1=sr.sfs04 LET sr.order2=sr.sfs03
                    OTHERWISE LET sr.order1=sr.sfs03 LET sr.order2=sr.sfs04
          END CASE
          SELECT ima02,ima23 INTO sr.ima02,sr.ima23 FROM ima_file
             WHERE ima01=sr.sfs04
          IF SQLCA.sqlcode THEN
             LET sr.ima02=''
             LET sr.ima23=''
          END IF
          
          SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.ima23
          IF STATUS THEN 
             LET l_gen02=' ' 
          END IF
          SELECT img10 INTO sr.img10 FROM img_file 
             WHERE img01=sr.sfs04
               AND img02=sr.sfs07
               AND img03=sr.sfs08
               AND img04=sr.sfs09
          IF SQLCA.sqlcode OR cl_null(sr.img10) THEN
             LET sr.img10=0
          END IF
          EXECUTE insert_prep USING
              l_sfp.sfp01,l_sfp.sfp02,l_sfp.sfp03,l_gen02,l_sfp.sfp07,l_sfp.sfp04,
              sr.ima23,sr.order1,sr.order2,sr.sfs02
          EXECUTE insert_prep2 USING 
              sr.sfs02,sr.sfs03,sr.sfs06,sr.sfs07,sr.sfs08,sr.sfs09,sr.sfs04,sr.sfs05,
              sr.img10,sr.ima02,sr.ima23,sr.order1,sr.order2,l_sfp.sfp01          
       END FOREACH
     END FOREACH
     
      LET g_sql = "SELECT * FROM ",
                   g_cr_db_str CLIPPED,l_table CLIPPED,
                   "|","SELECT * FROM ",
                   g_cr_db_str CLIPPED,l_table1 CLIPPED,
                   "|","SELECT * FROM ",                                                                                            
                   g_cr_db_str CLIPPED,l_table2 CLIPPED 
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
      IF g_zz05='Y' THEN
         CALL cl_wcchp(tm.wc,'sfp01,sfp02,sfp03,sfp07')
             RETURNING tm.wc
      ELSE
         LET tm.wc=""
      END IF
      LET g_str=tm.wc
   #   g_sql = g_sql1|g_sql2
     IF tm.p = 'N' THEN   #不依倉管員排序                                                               
        CALL cl_prt_cs3('asrr220','asrr220',g_sql,g_str)                                                                            
     ELSE                                                                                                                           
        CALL cl_prt_cs3('asrr220','asrr220_1',g_sql,g_str)                                                                          
     END IF      
     #FINISH REPORT r220_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
     #No.FUN-BB0047--mark--End----- 
END FUNCTION
#No.FUN-7C0034  -----END
 
#FUNCTION r220_out()
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6B0014
#DEFINE    l_name   LIKE type_file.chr20,         #No.FUN-680130 VARCHAR(20)
#          l_sql    LIKE type_file.chr1000,       #No.FUN-680130 VARCHAR(1000)
#          l_sfp		RECORD LIKE sfp_file.*,
#          sr  RECORD
#              order1	LIKE type_file.chr20,    #No.FUN-680130 VARCHAR(20)
#              order2	LIKE type_file.chr20,    #No.FUN-680130 VARCHAR(20)
#              sfs02	LIKE sfs_file.sfs02,
#              sfs03	LIKE sfs_file.sfs03,
#              sfs04	LIKE sfs_file.sfs04,
#              sfs05	LIKE sfs_file.sfs05,
#              sfs06	LIKE sfs_file.sfs06,
#              sfs07	LIKE sfs_file.sfs07,
#              sfs08	LIKE sfs_file.sfs08,
#              sfs09	LIKE sfs_file.sfs09,
#              sfs10	LIKE sfs_file.sfs10,
#              sfs26	LIKE sfs_file.sfs26,
#              ima02	LIKE ima_file.ima02,
#              ima23	LIKE ima_file.ima23,
#              img10	LIKE img_file.img10
#             END RECORD
 
#     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
#     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     LET l_sql = " SELECT * FROM sfp_file",
#                 "  WHERE ",tm.wc CLIPPED,
#                 "    AND sfp06 ='B' AND sfpconf!='X' " #FUN-660106
#     PREPARE r220_pr1 FROM l_sql
#     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) EXIT PROGRAM END IF
#     DECLARE r220_cs1 CURSOR FOR r220_pr1
 
#     CALL cl_outnam('asrr220') RETURNING l_name
 
#     LET g_pageno = 0
#     LET g_no = 0
#     START REPORT r220_rep TO l_name
#
#     FOREACH r220_cs1 INTO l_sfp.*
#       IF STATUS THEN CALL cl_err('for sfp:',STATUS,1) EXIT PROGRAM END IF
#       IF l_sfp.sfp04='N' THEN 
#          LET l_sql="SELECT '','',sfs02,sfs03,sfs04,sfs05,sfs06,sfs07,",
#                    "          sfs08,sfs09,sfs10,sfs26,'','',0",
#                    "  FROM sfs_file WHERE sfs01='",l_sfp.sfp01,"'"
#       ELSE 
#          LET l_sql="SELECT '','',sfe28,sfe01,sfe07,sfe16,sfe17,sfe08,",
#                    "          sfe09,sfe10,sfe14,sfe26,'','',0",
#                    "  FROM sfe_file WHERE sfe02='",l_sfp.sfp01,"'"
#       END IF
#       PREPARE r220_pr2 FROM l_sql
#       IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) EXIT PROGRAM END IF
#       DECLARE r220_cs2 CURSOR FOR r220_pr2
#       FOREACH r220_cs2 INTO sr.*
#          CASE tm.q WHEN '1'  LET sr.order1=sr.sfs04 LET sr.order2=sr.sfs03
#                    OTHERWISE LET sr.order1=sr.sfs03 LET sr.order2=sr.sfs04
#          END CASE
#          SELECT ima02,ima23 INTO sr.ima02,sr.ima23 FROM ima_file
#             WHERE ima01=sr.sfs04
#          IF SQLCA.sqlcode THEN
#             LET sr.ima02=''
#             LET sr.ima23=''
#          END IF
#          SELECT img10 INTO sr.img10 FROM img_file 
#             WHERE img01=sr.sfs04
#               AND img02=sr.sfs07
#               AND img03=sr.sfs08
#               AND img04=sr.sfs09
#          IF SQLCA.sqlcode OR cl_null(sr.img10) THEN
#             LET sr.img10=0
#          END IF
#          OUTPUT TO REPORT r220_rep(l_sfp.*, sr.*)
#       END FOREACH
#     END FOREACH
#     FINISH REPORT r220_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6B0014
#END FUNCTION
 
#REPORT r220_rep(l_sfp, sr)
#   DEFINE
#      l_item        LIKE type_file.num5,          #No.FUN-680130 SMALLINT
#      l_gen02       LIKE gen_file.gen02,
#      l_cnt,l_count LIKE type_file.num5,          #No.FUN-680130 SMALLINT
#      l_last_sw     LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
#      l_sql         LIKE type_file.chr1000,       #No.FUN-680130 VARCHAR(1000)
#      l_t1          LIKE type_file.num10,         #No.FUN-680130 INTEGER
#      l_desc        LIKE smy_file.smydesc,
#      l_ima02       LIKE ima_file.ima02,          #No.FUN-680130 VARCHAR(30)
#          l_sfp		RECORD LIKE sfp_file.*,
#          l_sfq		RECORD LIKE sfq_file.*,
#          sr  RECORD
#              order1	LIKE type_file.chr20,     #No.FUN-680130 VARCHAR(20)
#              order2	LIKE type_file.chr20,     #No.FUN-680130 VARCHAR(20)
#              sfs02	LIKE sfs_file.sfs02,
#              sfs03	LIKE sfs_file.sfs03,
#              sfs04	LIKE sfs_file.sfs04,
#              sfs05	LIKE sfs_file.sfs05,
#              sfs06	LIKE sfs_file.sfs06,
#              sfs07	LIKE sfs_file.sfs07,
#              sfs08	LIKE sfs_file.sfs08,
#              sfs09	LIKE sfs_file.sfs09,
#              sfs10	LIKE sfs_file.sfs10,
#              sfs26	LIKE sfs_file.sfs26,
#              ima02	LIKE ima_file.ima02,
#              ima23	LIKE ima_file.ima23,
#              img10	LIKE img_file.img10
#              END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 
#  ORDER BY l_sfp.sfp01, sr.order1, sr.order2,sr.sfs02 #sr.ima23,
 
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#      PRINT
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<'
#      PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED;
#      PRINT COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
#      PRINT ' '
#      LET g_no = g_no + 1
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.ima23
#      IF STATUS THEN LET l_gen02=' ' END IF
#      PRINT g_dash
#      PRINT g_x[12] CLIPPED,l_sfp.sfp01,' ',
#           COLUMN 27,g_x[13] CLIPPED,l_sfp.sfp02,'   ',
#           COLUMN 48,g_x[14] CLIPPED,l_sfp.sfp03,' ',
#           COLUMN 73,g_x[11] CLIPPED,l_gen02
#      PRINT g_x[15] CLIPPED,l_sfp.sfp07,' ',
           #COLUMN 27,g_x[16] CLIPPED,l_sfp.sfp06,' ',g_x[64],
#           COLUMN 73,g_x[18] CLIPPED,l_sfp.sfp04
#      PRINT g_dash2
#      IF g_no=1 THEN
#          PRINT
#          PRINT COLUMN  1, g_x[53],
#                COLUMN 40, g_x[55],
#                COLUMN 53, g_x[56],
#                COLUMN 62, g_x[57],
#                COLUMN 78, g_x[58]
#          PRINT COLUMN  1, g_x[60]
#          PRINT "-------------------------------------- ------------ ",
#                "-------- ------------- =============="
#      ELSE
#         PRINTX name=H1 g_x[41],g_x[43],g_x[45],g_x[46],g_x[51],g_x[52]
#         PRINTX name=H2 g_x[61],g_x[42],g_x[47],g_x[48],g_x[49]
#         PRINTX name=H3 g_x[62],g_x[50]
#        PRINT g_dash1
#      END IF
#      LET l_last_sw = 'n'
 
#    BEFORE GROUP OF sr.ima23
#      IF tm.p='Y' THEN SKIP TO TOP OF PAGE END IF
#    BEFORE GROUP OF l_sfp.sfp01
#      SKIP TO TOP OF PAGE
#      DECLARE r220_cs3 CURSOR FOR
#                   SELECT * FROM sfq_file
#NO.FUN-7B0026---------satrt------
#     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
#     IF g_zz05 ='Y' THEN 
#       CALL cl_wcchp(tm.wc,'nne01,nne02,nne03,nne06')
#            RETURNING tm.wc
#     END IF 
#     LET  g_str=tm.wc,";",tm.edate,";",tm.rate_op
#     CALL cl_prt_cs3('anmr770','anmr770',g_sql,g_str)
##NO.FUN-7B0026-------end-------
#                    WHERE sfq01=l_sfp.sfp01
#      FOREACH r220_cs3 INTO l_sfq.*
#        IF SQLCA.SQLCODE THEN CONTINUE FOREACH END IF
#        SELECT ima02 INTO l_ima02 FROM ima_file
#           WHERE ima01=l_sfq.sfq02
#        IF SQLCA.sqlcode THEN
#           LET l_ima02=''
#        END IF
#        PRINT COLUMN  1,l_sfq.sfq02,
#              COLUMN 40,l_sfq.sfq04,
#              COLUMN 53,l_sfq.sfq05,
#              COLUMN 62,cl_numfor(l_sfq.sfq03,13,3)
#        PRINT COLUMN  1,l_ima02 CLIPPED
#      END FOREACH
#      PRINT g_dash2
#         PRINTX name=H1 g_x[41],g_x[43],g_x[45],g_x[46],g_x[51],g_x[52]
#         PRINTX name=H2 g_x[61],g_x[42],g_x[47],g_x[48],g_x[49]
#         PRINTX name=H3 g_x[62],g_x[50]
#      PRINT g_dash1
#      SELECT COUNT(*) INTO g_cnt FROM sfq_file WHERE sfq01=l_sfp.sfp01
 
#    AFTER GROUP OF l_sfp.sfp01
#      UPDATE sfp_file SET sfp05='Y' WHERE sfp01=l_sfp.sfp01
#      IF STATUS OR SQLCA.sqlerrd[3]=0
#         THEN
#        CALL cl_err('upd sfp_file',STATUS,1)   #No.FUN-660138
#         CALL cl_err3("upd","sfp_file",l_sfp.sfp01,"",STATUS,"","upd sfp_file",1) #No.FUN-660138
#      END IF
#      LET g_no=0   ##不同發料單,頁次重新計算
 
#     ON EVERY ROW
 
#      PRINTX name=D1 COLUMN g_c[41],sr.sfs02 USING '###&',
#                     COLUMN g_c[43],sr.sfs03 CLIPPED,
#                     COLUMN g_c[45],sr.sfs06 CLIPPED,
#                     COLUMN g_c[46],sr.sfs07 CLIPPED,
#                     COLUMN g_c[51],sr.sfs08 CLIPPED,
#                     COLUMN g_c[52],sr.sfs09 CLIPPED
#      PRINTX name=D2 COLUMN g_c[42],sr.sfs04 CLIPPED,
#                     COLUMN g_c[47],cl_numfor(sr.img10,47,3),
#                     COLUMN g_c[48],cl_numfor(sr.sfs05,48,3),
#                     COLUMN g_c[49],g_x[35]
#      PRINTX name=D3 COLUMN g_c[50],sr.ima02
 
#    AFTER GROUP OF sr.order1
#      IF tm.q='1' THEN
#         IF g_cnt>1 THEN
#            PRINTX name=D2 COLUMN g_c[47], 'SubTotal:',
#                           COLUMN g_c[48], GROUP SUM(sr.sfs05) 
#                                           USING '---,---,--&.---'
#         END IF
#         PRINT ' '
#      END IF
#    ON LAST ROW
#      LET l_last_sw = 'y'
 
#    PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      PRINT '(asrr220)'
#      SKIP 1 LINE
#      #PRINT g_x[5] CLIPPED,g_x[6] CLIPPED
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[5]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[5]
#            PRINT g_memo
#      END IF
#END REPORT
#Patch....NO.TQC-610037 <> #
