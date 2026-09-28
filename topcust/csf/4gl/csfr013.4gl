# Prog. Version..:
#
# Pattern name...: csfr013.4gl
# Descriptions...: 在制呆滞工单明细查询
# Date & Author..: 22/05/16 By darcy
#HFBG-16030001
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
              END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="sfb01.sfb_file.sfb01,",
             "sfb06.sfb_file.sfb06,",
             "sfb81.sfb_file.sfb81,",
             "sfb08.sfb_file.sfb08,",
             "sfbud07.sfb_file.sfbud07,",
             "sfb081.sfb_file.sfb081,",
             "sfb09.sfb_file.sfb09,",
             "sfb12.sfb_file.sfb12,",
             "sfbud12.sfb_file.sfbud12,",
             "wipsfa.sgm_file.sgm311,",
             "sgm01.sgm_file.sgm01,",
             "sgm02.sgm_file.sgm02,",
             "sgm03.sgm_file.sgm03,",
             "sgm06.sgm_file.sgm06,",
             "eca02.eca_file.eca02,",
             "sgm04.sgm_file.sgm04,",
             "ecd02.ecd_file.ecd02,",
             "ta_sgm06.sgm_file.ta_sgm06,",
             "sgm65.sgm_file.sgm65,",
             "sgm301.sgm_file.sgm301,",
             "sgm311.sgm_file.sgm311,",
             "sgm313.sgm_file.sgm313,",
             "wipsgm.sgm_file.sgm311"
             

   LET  l_table = cl_prt_temptable('csfr013',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"                     
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11) 
   
   IF cl_null(tm.wc)
      THEN CALL csfr013_tm(0,0)          
      ELSE
           CALL csfr013()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION csfr013_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW csfr013_w AT p_row,p_col WITH FORM "csf/42f/csfr013"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb81,sfb05,sgm06,sgm01,ta_sgm06,sgm04,sfb06                  
     
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
 
       ON ACTION locale 
          CALL cl_show_fld_cont()                    
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(sfb01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfb"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfu01
                 NEXT FIELD sfb01

               WHEN INFIELD(sfb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima18"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfb05
                 NEXT FIELD sfb05

               WHEN INFIELD(sgm01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_sgm01"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgm01
                 NEXT FIELD sgm01

               WHEN INFIELD(sgm04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ecb06"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgm04
                 NEXT FIELD sgm04

               WHEN INFIELD(sgm06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ctg01"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sgm06
                 NEXT FIELD sgm06
               OTHERWISE
                  EXIT CASE
           END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW csfr013_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW csfr013_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='csfr013'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('csfr013','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,'\\\"', "'")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('csfr013',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW csfr013_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL csfr013()
   ERROR ""
END WHILE
   CLOSE WINDOW csfr013_w
END FUNCTION


FUNCTION csfr013()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     STRING ,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    sfb01      LIKE sfb_file.sfb01,
                    sfb06      LIKE sfb_file.sfb06,
                    sfb81      LIKE sfb_file.sfb81,
                    sfb08      LIKE sfb_file.sfb08,
                    sfbud07    LIKE sfb_file.sfbud07,
                    sfb081     LIKE sfb_file.sfb081,
                    sfb09      LIKE sfb_file.sfb09,
                    sfb12      LIKE sfb_file.sfb12,
                    sfbud12    LIKE sfb_file.sfbud12,
                    wipsfa     LIKE sgm_file.sgm311,
                    sgm01      LIKE sgm_file.sgm01,
                    sgm02      LIKE sgm_file.sgm02,
                    sgm03      LIKE sgm_file.sgm03,
                    sgm06      LIKE sgm_file.sgm06,
                    eca02      LIKE eca_file.eca02,
                    sgm04      LIKE sgm_file.sgm04,
                    ecd02      LIKE ecd_file.ecd02,
                    ta_sgm06   LIKE sgm_file.ta_sgm06,
                    sgm65      LIKE sgm_file.sgm65,
                    sgm301     LIKE sgm_file.sgm301,
                    sgm311     LIKE sgm_file.sgm311,
                    sgm313     LIKE sgm_file.sgm313,
                    wipsgm     LIKE sgm_file.sgm311
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='csfr013' 
 
     LET tm.wc = tm.wc CLIPPED 
     
      LET l_sql="SELECT sfb01,
                        sfb06,
                        sfb81,
                        sfb08,
                        sfbud07,
                        sfb081,
                        sfb09,
                        sfb12,
                        sfbud12,
                        sfb081 - sfb09 - sfb12 AS wipsfa,
                        sgm01,
                        sgm02,
                        sgm03,
                        sgm06,
                        eca02,
                        sgm04,
                        ecd02,
                        ta_sgm06,
                        sgm65,
                        sgm301,
                        sgm311,
                        sgm313,
                        sgm301 - sgm311 - sgm313 AS wipsgm
                  FROM sfb_file
                  LEFT JOIN (SELECT sgm01,
                                    sgm02,
                                    sgm03,
                                    sgm06,
                                    eca02,
                                    sgm04,
                                    ta_sgm06,
                                    ecd02,
                                    sgm65,
                                    sgm301,
                                    sgm311,
                                    sgm313,
                                    sgm301 - sgm311 - sgm313 在制
                                 FROM sgm_file, eca_file, ecd_file
                              WHERE sgm301 - sgm311 - sgm313 > 0
                                 AND sgm06 = eca01
                                 AND sgm04 = ecd01)
                     ON sfb01 = sgm02
                  WHERE sfb87 = 'Y'
                     AND sfb04 <> '8'
                     AND sfb081 - sfb09 - sfb12 > 0 and ",tm.wc 
 
     PREPARE csfr013_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE csfr013_curs1 CURSOR FOR csfr013_prepare1
 
     FOREACH csfr013_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

       EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = tm.wc

     CALL cl_prt_cs3('csfr013','csfr013',g_sql,g_str)

END FUNCTION



