# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: aimr882.4gl
# Descriptions...: 批/序號複盤差異分析表
# Input parameter: 
# Return code....: 
# Date & Author..: 08/05/28 #FUN-850151 By jamie
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A40038 10/04/20 By houlia 追單 MOD-9B0029
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-850151 ref.aimr830
 
DEFINE tm  RECORD                                      # Print condition RECORD
           wc   STRING,                                # Where Condition             
           diff LIKE type_file.chr1,                                         
           s    LIKE type_file.chr3,                   # Order by sequence                        
           t    LIKE type_file.chr3,                   # Eject sw                        
           more LIKE type_file.chr1                    # Input more condition(Y/N)                        
           END RECORD
DEFINE g_i           LIKE type_file.num5               #count/index for any purpose                         
DEFINE g_q_point     LIKE zaa_file.zaa08,                                     
       l_orderA      ARRAY[3] OF LIKE imm_file.imm13                 
DEFINE g_star        LIKE zaa_file.zaa08                                      
DEFINE l_table       STRING
DEFINE g_sql         STRING
DEFINE g_str         STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = " pias01.pias_file.pias01,  ",
               " pias02.pias_file.pias02,  ",
               " pias03.pias_file.pias03,  ",
               " pias04.pias_file.pias04,  ",
               " pias05.pias_file.pias05,  ",
               " pias08.pias_file.pias08,  ",
               " pias50.pias_file.pias50,  ",
               " pias51.pias_file.pias51,  ",
               " pias54.pias_file.pias54,  ",
               " pias55.pias_file.pias55,  ",
               " pias60.pias_file.pias60,  ",
               " pias61.pias_file.pias61,  ",
               " pias64.pias_file.pias64,  ",
               " pias65.pias_file.pias65,  ",
               " ima02.ima_file.ima02,  ",
               " ima021.ima_file.ima021,",
               " gen02_1.gen_file.gen02,",
               " gen02_2.gen_file.gen02,",
               " gen02_pias51.gen_file.gen02,",
               " gen02_pias61.gen_file.gen02,",
               " azi03.azi_file.azi03,  ", 
               " azi04.azi_file.azi04,  ", 
               " azi05.azi_file.azi05   "  
 
   LET l_table = cl_prt_temptable('aimr882',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
#  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,     #CHI-A40038
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#CHI-A40038
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?) " 
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.diff  = ARG_VAL(8)   
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
      CALL r882_tm(0,0)                            # Input print condition
   ELSE 
      CALL r882()                                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION r882_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01                   
DEFINE p_row,p_col    LIKE type_file.num5,                           
       l_cmd          LIKE type_file.chr1000                           
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col =17
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r882_w AT p_row,p_col
        WITH FORM "aim/42f/aimr882" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.diff = 'N'
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pias01,pias03,pias04,pias05,pias02,pias51,pias61
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(pias02) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO pias02                                                                                 
            NEXT FIELD pias02                                                                                                     
         END IF                                                            
 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r882_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
 
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#UI
   INPUT BY NAME tm.diff, tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3,
                 tm.more WITHOUT DEFAULTS 
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD diff 
         IF tm.diff IS NULL OR tm.diff NOT MATCHES'[YNyn]'
         THEN NEXT FIELD diff
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about                    
         CALL cl_about()                 
 
      ON ACTION help                     
         CALL cl_show_help()             
   
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r882_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr882'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr882','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.diff CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",                         
                         " '",g_rep_clas CLIPPED,"'",                         
                         " '",g_template CLIPPED,"'",                         
                         " '",g_rpt_name CLIPPED,"'"                          
         CALL cl_cmdat('aimr882',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r882_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                         
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r882()
   ERROR ""
END WHILE
   CLOSE WINDOW r882_w
END FUNCTION
 
FUNCTION r882()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name
          l_sql     STRING,                       # RDSQL STATEMENT   
          l_chr     LIKE type_file.chr1,                                
          l_za05    LIKE za_file.za05,                                   
          l_order   ARRAY[5] OF LIKE ima_file.ima01,                                              
          sr        RECORD order1 LIKE ima_file.ima01,                                            
                           order2 LIKE ima_file.ima01,                                            
                           order3 LIKE ima_file.ima01,                                            
                           pias01  LIKE pias_file.pias01,
                           pias02  LIKE pias_file.pias02,
                           pias03  LIKE pias_file.pias03,
                           pias04  LIKE pias_file.pias04,
                           pias05  LIKE pias_file.pias05,
                           pias08  LIKE pias_file.pias08,
                           pias50  LIKE pias_file.pias50,
                           pias51  LIKE pias_file.pias51,
                           pias54  LIKE pias_file.pias54,
                           pias55  LIKE pias_file.pias55,
                           pias60  LIKE pias_file.pias60,
                           pias61  LIKE pias_file.pias61,
                           pias64  LIKE pias_file.pias64,
                           pias65  LIKE pias_file.pias65,
                           ima02  LIKE ima_file.ima02,
                           ima021 LIKE ima_file.ima021,
                           gen02_1     LIKE gen_file.gen02,
                           gen02_2     LIKE gen_file.gen02,
                           gen02_pias51 LIKE gen_file.gen02,
                           gen02_pias61 LIKE gen_file.gen02
                        END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> *** ##
   CALL cl_del_data(l_table)
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT '','','',",
                 "pias01, pias02, pias03, pias04,",
                 "pias05, pias08, pias50, pias51, pias54, pias55,",
                 "pias60, pias61, pias64, pias65, ima02,ima021, gen02",
                 "  FROM pias_file ,OUTER gen_file ,OUTER ima_file",
                 " WHERE pias_file.pias54=gen_file.gen01 AND pias_file.pias02=ima_file.ima01",
                 " AND (pias02 IS NOT NULL OR  pias02 != ' ') ",
                 " AND ( (pias50 IS NOT NULL OR  pias50 != 0) ", 
                 "  OR (pias60 IS NOT NULL OR  pias60 != 0 )) ",
                 " AND ",tm.wc
 
     #複盤資料輸入員(一)與資料輸入員(二)
     IF tm.diff ='N' THEN 
        LET l_sql = l_sql clipped," AND (pias50 != pias60 )"
     END IF
 
     PREPARE r882_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE r882_curs1 CURSOR FOR r882_prepare1
 
     FOR g_i = 1 TO 80 LET g_q_point[g_i,g_i] = '?' END FOR
     FOR g_i = 1 TO 80 LET g_star[g_i,g_i] = '*' END FOR
 
     LET g_pageno = 0
     FOREACH r882_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       IF sr.pias03 IS NULL THEN LET sr.pias03 = ' ' END IF
       IF sr.pias04 IS NULL THEN LET sr.pias04 = ' ' END IF
       IF sr.pias05 IS NULL THEN LET sr.pias05 = ' ' END IF
       SELECT gen02 INTO sr.gen02_2 FROM gen_file WHERE gen01 = sr.pias64
       SELECT gen02 INTO sr.gen02_pias51 FROM gen_file WHERE gen01 = sr.pias51
       SELECT gen02 INTO sr.gen02_pias61 FROM gen_file WHERE gen01 = sr.pias61
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> *** ##
       EXECUTE insert_prep USING
          sr.pias01, sr.pias02, sr.pias03, sr.pias04, sr.pias05,
          sr.pias08, sr.pias50, sr.pias51, sr.pias54, sr.pias55,
          sr.pias60, sr.pias61, sr.pias64, sr.pias65, sr.ima02,
          sr.ima021,sr.gen02_1,sr.gen02_2,sr.gen02_pias51,sr.gen02_pias61,
          g_azi03,g_azi04,g_azi05
     END FOREACH
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
     #是否列印選擇條件
     LET g_str = NULL
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'pias01,pias03,pias04,pias05,pias02,pias51,pias61')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.s,";",tm.t
 
     CALL cl_prt_cs3('aimr882','aimr882',l_sql,g_str)   
 
END FUNCTION
 
