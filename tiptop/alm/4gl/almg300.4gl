# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almg300.4gl
# Descriptions...: 商戶明細表
# Date & Author..: No.FUN-C60062 12/06/19 By fanbj
# Modify.........: No.FUN-C60062 12/06/30 By yangxf

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD                    # Print condition RECORD
          wc         STRING,          
          MORE       LIKE type_file.chr1           
                  END RECORD
DEFINE g_i        LIKE type_file.num5       #count/index for any purpose
DEFINE g_lne01    LIKE lne_file.lne01   
DEFINE g_lne02    LIKE lne_file.lne02   
DEFINE g_sql      STRING                                                       
DEFINE l_table    STRING                                                                                                            
DEFINE l_str      STRING   
DEFINE g_wc       STRING
#FUN-C60062---ADD-----STR
DEFINE g_wc1      STRING
DEFINE g_wc2      STRING
DEFINE g_wc3      STRING
DEFINE g_wc4      STRING
DEFINE g_wc5      STRING
DEFINE g_wc6      STRING
#FUN-C60062---ADD-----END

###GENGRE###START
TYPE sr1_t        RECORD
        lne01        LIKE lne_file.lne01,
        lne05        LIKE lne_file.lne05,
        lne02        LIKE lne_file.lne02,
        lne03        LIKE lne_file.lne03,
        lne67        LIKE lne_file.lne67,
        lne08        LIKE lne_file.lne08,
        tqa02        LIKE tqa_file.tqa02,
        lne07        LIKE lne_file.lne07,
        lne14        LIKE lne_file.lne14,
        lne15        LIKE lne_file.lne15,
        lne24        LIKE lne_file.lne24,
        lne36        LIKE lne_file.lne36,
        lne37        LIKE lne_file.lne37,
        lne38        LIKE lne_file.lne38,
        lne39        LIKE lne_file.lne39
                  END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   LET tm.wc = ARG_VAL(1)
   LET g_rlang = ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)        # Get arguments from command line
   LET g_bgjob = ARG_VAL(4)
   LET g_wc1 = ARG_VAL(5) 
   LET g_wc2 = ARG_VAL(6)
   LET g_wc3 = ARG_VAL(7)
   LET g_towhom = ARG_VAL(8)
   LET g_prtway = ARG_VAL(9)
   LET g_copies = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14) 

   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql ="lne01.lne_file.lne01,",
              "lne05.lne_file.lne05,",
              "lne02.lne_file.lne02,",
              "lne03.lne_file.lne03,",
              "lne67.lne_file.lne67,",
              "lne08.lne_file.lne08,",
              "tqa02.tqa_file.tqa02,",
              "lne07.lne_file.lne07,",
              "lne14.lne_file.lne14,",
              "lne15.lne_file.lne15,",
              "lne24.lne_file.lne24,",
              "lne36.lne_file.lne36,",
              "lne37.lne_file.lne37,",
              "lne38.lne_file.lne38,",
              "lne39.lne_file.lne39"             
   LET l_table = cl_prt_temptable('almg300',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM 
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN    # If background job sw is off
      CALL g300_tm(0,0)                         # Input print condition
   ELSE
      CALL almg300()                            # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
# Description: 讀入批次執行條件
FUNCTION g300_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col	 LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW g300_w AT p_row,p_col WITH FORM "alm/42f/almg300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   LET tm.more   = 'N'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON lne01,lne67,lne08,lne38
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
             
         ON ACTION controlp
            CASE 
               WHEN INFIELD(lne01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_lne01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lne01
                  NEXT FIELD lne01

               WHEN INFIELD(lne67)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_lne67"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lne67
                  NEXT FIELD lne67

              WHEN INFIELD(lne08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_lne08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lne08
                  NEXT FIELD lne08  
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
            CONTINUE CONSTRUCT
              
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
         CLOSE WINDOW g300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      # Condition
      DISPLAY BY NAME tm.more
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN 
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
            
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW g300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd
           FROM zz_file	
          WHERE zz01='almg300'
 
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('almg300','9031',1)
         ELSE
            # time fglgo xxxx p1 p2 p3
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate  CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_lang   CLIPPED,"'",
                        " '",g_bgjob  CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc    CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'" ,
                        " '",g_rpt_name CLIPPED,"'"
 
            #Execute cmd at later time
            CALL cl_cmdat('almg300',g_time,l_cmd)
         END IF
         CLOSE WINDOW g300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      
      CALL cl_wait()
      CALL almg300()
      ERROR ""
   END WHILE
   CLOSE WINDOW g300_w
END FUNCTION
 
FUNCTION almg300()
   DEFINE l_sql        STRING
   DEFINE l_table_str  STRING    #FUN-C60062 add
   DEFINE l_where      STRING    #FUN-C60062 add
   DEFINE sr           RECORD
             lne01        LIKE lne_file.lne01,
             lne05        LIKE lne_file.lne05,
             lne02        LIKE lne_file.lne02,
             lne03        LIKE lne_file.lne03,
             lne67        LIKE lne_file.lne67,
             lne08        LIKE lne_file.lne08,
             tqa02        LIKE tqa_file.tqa02,
             lne07        LIKE lne_file.lne07,
             lne14        LIKE lne_file.lne14,
             lne15        LIKE lne_file.lne15,
             lne24        LIKE lne_file.lne24,
             lne36        LIKE lne_file.lne36,
             lne37        LIKE lne_file.lne37,
             lne38        LIKE lne_file.lne38,
             lne39        LIKE lne_file.lne39
                       END RECORD
   DEFINE l_img_blob   LIKE type_file.blob

   LOCATE l_img_blob IN MEMORY
  
   SELECT zo02 INTO g_company
     FROM zo_file
    WHERE zo01 = g_rlang
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('', '')
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   #FUN-C60062 add begin ---
   LET l_sql = " SELECT lne01,lne05,lne02,lne03,lne67,lne08,tqa02,lne07,",
               "        lne14,lne15,lne24,lne36,lne37,lne38,lne39"
   LET l_table_str = " FROM lne_file LEFT JOIN tqa_file ON lne08 = tqa01 "
   LET l_where  = "  WHERE tqa03 = '2' AND lne36 = 'Y' AND ",tm.wc CLIPPED
   IF NOT cl_null(g_wc1) AND g_wc1 <> " 1=1" THEN
     LET l_table_str = l_table_str,",lng_file"
     LET l_where = l_where," AND lne01 = lng01 AND ",g_wc1 CLIPPED 
   END IF 
   IF NOT cl_null(g_wc2) AND g_wc2 <> " 1=1" THEN
     LET l_table_str = l_table_str,",lnf_file"
     LET l_where = l_where," AND lne01 = lnf01 AND ",g_wc2 CLIPPED
   END IF
   IF NOT cl_null(g_wc3) AND g_wc3 <> " 1=1" THEN
     LET l_table_str = l_table_str,",lng_file"
     LET l_where = l_where," AND lne01 = lnh01 AND ",g_wc3 CLIPPED
   END IF
   LET l_sql = l_sql,l_table_str,l_where CLIPPED," ORDER BY lne01,lne02"
   #FUN-C60062 add end ----    
#FUN-C60062 mark begin ---
#   LET l_sql = " SELECT lne01,lne05,lne02,lne03,lne67,lne08,tqa02,lne07,",
#               "        lne14,lne15,lne24,lne36,lne37,lne38,lne39", 
#               "   FROM lne_file LEFT JOIN tqa_file ON lne08 = tqa01",
#               "  WHERE tqa03 = '2' ",
#               "    AND lne36 = 'Y' ", 
#               "    AND ",tm.wc CLIPPED
#   LET l_sql=l_sql CLIPPED," ORDER BY lne01,lne02"   
#FUN-C60062 mark end ---
   PREPARE g300_pr1 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   DECLARE g300_cs1 CURSOR FOR g300_pr1
  
   FOREACH g300_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      EXECUTE insert_prep USING sr.lne01,sr.lne05,sr.lne02,sr.lne03,sr.lne67,
                                sr.lne08,sr.tqa02,sr.lne07,sr.lne14,sr.lne15,
                                sr.lne24,sr.lne36,sr.lne37,sr.lne38,sr.lne39
   END FOREACH
######################################################################
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'lne01,lne67,lne08,lne38')
                   RETURNING g_wc
      CALL cl_wcchp(g_wc1,'lng03,lng04,lng05,lng06,lng07')
                   RETURNING g_wc4
      IF NOT cl_null(g_wc4) OR g_wc4 <> " 1=1" THEN              
         LET g_wc = g_wc," AND ",g_wc4
      END IF    
      CALL cl_wcchp(g_wc2,'lnf03,lnf04')
                   RETURNING g_wc5
      IF NOT cl_null(g_wc5) OR g_wc5 <> " 1=1" THEN                   
         LET g_wc = g_wc," AND ",g_wc5
      END IF    
      CALL cl_wcchp(g_wc3,'lnhstore,lnhlegal,lnh04,lnh05,lnh06,lnh07')
                   RETURNING g_wc6
      IF NOT cl_null(g_wc6) OR g_wc6 <> " 1=1" THEN                   
         LET g_wc = g_wc," AND ",g_wc6
      END IF    
      IF g_wc.getLength() > 1000 THEN
         LET g_wc = g_wc.subString(1,600)
         LET g_wc = g_wc,"..."
     END IF
   END IF
   LET g_template = 'almg300' 
#####################################################################
   CALL almg300_grdata() 
END FUNCTION

###GENGRE###START
FUNCTION almg300_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10
   DEFINE l_msg    STRING

   LET l_cnt = cl_gre_rowcnt(l_table)
   
   IF l_cnt <= 0 THEN
      RETURN
   END IF

   WHILE TRUE
      CALL cl_gre_init_pageheader()            
      LET handler = cl_gre_outnam("almg300")
      IF handler IS NOT NULL THEN
         START REPORT almg300_rep TO XML HANDLER handler
         LET l_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     "  ORDER BY lne01"
         DECLARE g300_datacur1 CURSOR FROM l_sql
         FOREACH g300_datacur1 INTO sr1.*
            OUTPUT TO REPORT almg300_rep(sr1.*)
         END FOREACH
         FINISH REPORT almg300_rep
      END IF
      IF INT_FLAG = TRUE THEN
         LET INT_FLAG = FALSE
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT almg300_rep(sr1)
   DEFINE sr1 sr1_t
   DEFINE l_lineno LIKE type_file.num5
   DEFINE l_lne07  STRING
   DEFINE l_lne36  STRING     #FUN-C60062 add 
    
   FORMAT
      FIRST PAGE HEADER
         PRINTX g_grPageHeader.*    
         PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
         PRINTX tm.*
         PRINTX g_wc

      ON EVERY ROW
         LET l_lineno = l_lineno + 1
         PRINTX l_lineno  
         LET l_lne07 = cl_gr_getmsg('gre-289',g_lang,sr1.lne07)
         LET l_lne07 = sr1.lne07,":",l_lne07
         PRINTX l_lne07 
         LET l_lne36 = cl_gr_getmsg('gre-292',g_lang,sr1.lne36)       #FUN-C60062 add
         PRINTX l_lne36                                               #FUN-C60062 add
         PRINTX sr1.*

      ON LAST ROW
END REPORT
#FUN-C60062-----------------------------------------

