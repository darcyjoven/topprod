# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: abxr604.4gl
# Descriptions...: 內銷登記簿(園區用)
# Date & Author..: 2012/01/05 FUN-BC0115 By Sakura
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                # Print condition RECORD
              wc     LIKE type_file.chr1000,
              a      LIKE type_file.chr2, 
              bdate  LIKE type_file.dat,    
              edate  LIKE type_file.dat, 
              more   LIKE type_file.chr1      # Input more condition(Y/N)
           END RECORD,
       g_bxr02       LIKE bxr_file.bxr02
 
DEFINE g_i           LIKE type_file.num5   #count/index for any purpose
DEFINE g_sql           STRING
DEFINE g_str           STRING
DEFINE l_table         STRING
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql = "bxi02.bxi_file.bxi02,",
               "bnb01.bnb_file.bnb01,",
               "bnb06.bnb_file.bnb06,",
               "bnb15.bnb_file.bnb15,",
               "ima02.ima_file.ima02,",
               "ogb14.ogb_file.ogb14"
  
      LET l_table = cl_prt_temptable('abxr604',g_sql) CLIPPED
      IF l_table = -1 THEN EXIT PROGRAM END IF
  
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?)"
  
   PREPARE insert_prep FROM g_sql
  
   IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.edate  = ARG_VAL(9)
   LET tm.a      = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'# If background job sw is off
      THEN CALL abxr604_tm(4,15)       # Input print condition
      ELSE CALL abxr604()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION abxr604_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,  
          l_cmd         LIKE type_file.chr1000   
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 22
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW abxr604_w AT p_row,p_col
        WITH FORM "abx/42f/abxr604" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_init()
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = '1=1' 
WHILE TRUE
   INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.more 
   WITHOUT DEFAULTS 
         BEFORE INPUT
             CALL cl_qbe_init()
             
      ON ACTION locale
          CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT INPUT
   
      AFTER FIELD bdate
           IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF 
          
      AFTER FIELD edate
           IF cl_null(tm.edate) OR tm.edate < tm.bdate
           THEN NEXT FIELD edate END IF 
          
      AFTER FIELD a
           IF cl_null(tm.a) THEN NEXT FIELD a END IF 
           SELECT bxr02 INTO g_bxr02 FROM bxr_file WHERE bxr01 = tm.a
           IF STATUS THEN
              CALL cl_err3("sel","bxr_file",tm.a,"",STATUS,"","err bxr01  ",0) 
              NEXT FIELD a      
           END IF  
           IF cl_null(g_bxr02) THEN LET g_bxr02 = tm.a END IF 
 
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
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr604_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='abxr604'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('abxr604','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate   CLIPPED,"'",
                         " '",tm.edate   CLIPPED,"'",
                         " '",tm.a       CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
                        
         CALL cl_cmdat('abxr604',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW abxr604_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL abxr604()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr604_w
END FUNCTION
 
FUNCTION abxr604()
   DEFINE l_name    LIKE type_file.chr20,       # External(Disk) file name
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT
          l_oga38   LIKE oga_file.oga38,
          l_oga39   LIKE oga_file.oga39,
          l_chr     LIKE type_file.chr1, 
          l_za05    LIKE za_file.za05,
          l_bnb14   LIKE bnb_file.bnb14,
          l_ima021  LIKE ima_file.ima021,
          l_sfa03   LIKE sfa_file.sfa03,
          sr               RECORD 
                                  bxi02  LIKE bxi_file.bxi02,
                                  bnb01  LIKE bnb_file.bnb01,
                                  bnb06  LIKE bnb_file.bnb06,
                                  bnb15  LIKE bnb_file.bnb15,
                                  ima02  LIKE ima_file.ima02,
                                  ogb14  LIKE ogb_file.ogb14
                        END RECORD
   CALL cl_del_data(l_table)
  #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     LET l_sql = "SELECT bxi02,bnb01,bnb06,bnb15, ",
                 "       ima02,ogb14   ",
                 "  FROM ima_file,(bxi_file INNER JOIN bxj_file ON bxi01 = bxj01 ) ",
                 "  LEFT OUTER JOIN (oga_file INNER JOIN ogb_file ON oga01 = ogb01) ",
                 "   ON bxi01 = oga01 AND ogaconf != 'X' and  bxj04 = ogb04 AND bxj03 = ogb03 ",
                 "  LEFT OUTER JOIN (bnb_file INNER JOIN bnc_file ON bnb01 = bnc01) ",
                 "   ON  bxi01 = bnb04 AND bxj04 = bnc03  AND bxj06 = bnc06 ",
                 " WHERE bxi08 = '",tm.a ,"'",
                 "   AND bxi02 BETWEEN '",tm.bdate,"'",
                 "   AND '",tm.edate,"'",
                 "   AND bxj04 = ima01 ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY bxi02,bnb01,bxi01,bxj04 "
 
     PREPARE abxr604_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM 
           
     END IF
     DECLARE abxr604_curs1 CURSOR FOR abxr604_prepare1
 
     LET g_pageno = 0
     FOREACH abxr604_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH 
       END IF
       # 若前面user 按下 control-t 則會顯示目前做到第 n 筆
       IF cl_null(sr.ogb14) THEN LET sr.ogb14 = 0 END IF
     EXECUTE insert_prep USING sr.*
     END FOREACH
 
   SELECT zz05 INTO g_zz05 FROM zz_file
       WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'') RETURNING tm.wc
      LET g_str = tm.wc
   ELSE
      LET g_str = ''
   END IF
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
 
    LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm.a,";",g_bxr02
    CALL cl_prt_cs3('abxr604','abxr604',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
END FUNCTION
#FUN-BC0115
