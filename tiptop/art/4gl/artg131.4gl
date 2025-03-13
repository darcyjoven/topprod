# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg131.4gl
# Descriptions...: 会员邮递标签
# Date & Author..: #FUN-A60075 10/06/28 By sunchenxu
# Modify.........: No.FUN-B40097 11/05/23 By chenying 憑證類CR報表轉成GR
# Modify.........: No.FUN-C10036 12/01/12 By qirl FUN-B80085追單

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,    
              a1      LIKE type_file.num20,
              a2      LIKE type_file.num20,
              c       LIKE type_file.chr1,            
              d       LIKE type_file.chr1,
              e       LIKE type_file.chr10,
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 

###GENGRE###START
TYPE sr1_t RECORD
    lpk16 LIKE lpk_file.lpk16,
    lpk15 LIKE lpk_file.lpk15,
    lpk01 LIKE lpk_file.lpk01,
    lpk04 LIKE lpk_file.lpk04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql = "lpk16.lpk_file.lpk16,",  
               "lpk15.lpk_file.lpk15,", 
               "lpk01.lpk_file.lpk01,",
               "lpk04.lpk_file.lpk04,"
 
   LET l_table = cl_prt_temptable('artg131',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
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

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artg131_tm(0,0)        # Input print condition
      ELSE CALL artg131()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)
 
END MAIN

FUNCTION artg131_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_direct       LIKE type_file.chr1,  
          l_cmd          LIKE type_file.chr1000 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artg131_w AT p_row,p_col WITH FORM "art/42f/artg131" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.c    = '1'
   LET tm.d    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON lpk01,lpk13,lpk10,lpk11,lpk05

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(lpk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk01
                  NEXT FIELD lpk01
               WHEN INFIELD(lpk13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk13"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk13
                  NEXT FIELD lpk13
               WHEN INFIELD(lpk10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk10"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk10
                  NEXT FIELD lpk10
               WHEN INFIELD(lpk11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk11"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk11
                  NEXT FIELD lpk11
            END CASE
            
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
         LET INT_FLAG = 0 CLOSE WINDOW artg131_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097 
         EXIT PROGRAM
      END IF
      
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF

      LET tm.a1 = 0
      DISPLAY BY NAME tm.a1,tm.a2,tm.c,tm.d,tm.more 
      
      INPUT BY NAME tm.a1,tm.a2,tm.c,tm.d,tm.e,tm.more  WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         AFTER FIELD a1
            IF tm.a1 < 0 THEN 
               CALL cl_err('','art-929',0)
               NEXT FIELD a1  
            END IF  
            
         AFTER FIELD a2
            IF tm.a2 < 0 THEN 
               CALL cl_err('','art-929',0)
               NEXT FIELD a2  
            END IF 
            IF tm.a2 < tm.a1 THEN  CALL cl_err('','art-930',0) 
               NEXT FIELD a2
            END IF             
         AFTER FIELD c
            IF tm.c NOT MATCHES "[123]" OR cl_null(tm.c)
               THEN NEXT FIELD c
            END IF
 
         AFTER FIELD d
            IF tm.d NOT MATCHES "[1234]" OR tm.d IS NULL
               THEN NEXT FIELD d
            END IF
            IF tm.d != '4' THEN
              LET tm.e = ' '
               DISPLAY BY NAME tm.e
            END IF
            LET l_direct = 'D'

         BEFORE FIELD e
            IF tm.d != '4' THEN
               IF l_direct = 'D' THEN
                  NEXT FIELD more
               ELSE 
                  NEXT FIELD d
               END IF
            END IF
            
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
         LET INT_FLAG = 0 CLOSE WINDOW artg131_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg131'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artg131','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg131',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg131_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg131()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg131_w
END FUNCTION

FUNCTION artg131()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,
          l_sum     LIKE type_file.num5,         
          sr        RECORD 
                    lpk16  LIKE lpk_file.lpk16,  
                    lpk15  LIKE lpk_file.lpk15, 
                    lpk01  LIKE lpk_file.lpk01,
                    lpk04  LIKE lpk_file.lpk04
                    END RECORD
           
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?) "
    
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)           
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-C10036 ADD                                                                       
       CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097 
       EXIT PROGRAM                                                                                                                 
    END IF

    LET l_sql = " SELECT lpk16,lpk15,lpk01,lpk04 ", 
                " FROM lpk_file ",
                " WHERE ",tm.wc CLIPPED
    PREPARE artg131_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #No.FUN-C10036 ADD
       CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097 
       EXIT PROGRAM
    END IF
    DECLARE artg131_curs1 CURSOR FOR artg131_prepare1

    FOREACH artg131_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT SUM(lpj15) INTO l_sum FROM lpj_file WHERE lpj01 = sr.lpk01
      IF tm.a2 IS NOT NULL THEN
         IF l_sum >= tm.a1 AND l_sum <= tm.a2 THEN
            EXECUTE  insert_prep  USING  
            sr.lpk16,sr.lpk15,sr.lpk01,sr.lpk04
         END IF
      ELSE
         EXECUTE  insert_prep  USING  
         sr.lpk16,sr.lpk15,sr.lpk01,sr.lpk04
      END IF
      
   END FOREACH
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = tm.d
   IF tm.d='4' THEN
###GENGRE###      LET g_str = g_str,';',tm.e
   END IF
   CASE
      WHEN tm.c='1'
###GENGRE###         CALL cl_prt_cs3('artg131','artg131_1',l_sql,g_str) 
    LET g_template = 'artg131_1'   #FUN-B40097 
    CALL artg131_grdata()    ###GENGRE###
      WHEN tm.c='2'
###GENGRE###         CALL cl_prt_cs3('artg131','artg131_2',l_sql,g_str) 
    LET g_template = 'artg131_2'   #FUN-B40097 
    CALL artg131_grdata()    ###GENGRE###
      WHEN tm.c='3'
###GENGRE###         CALL cl_prt_cs3('artg131','artg131_3',l_sql,g_str) 
    LET g_template = 'artg131_3'   #FUN-B40097 
    CALL artg131_grdata()    ###GENGRE###
   END CASE
END FUNCTION
#FUN-A60075

###GENGRE###START
FUNCTION artg131_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg131")
        IF handler IS NOT NULL THEN
            START REPORT artg131_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY lpk01" 
            DECLARE artg131_datacur1 CURSOR FROM l_sql
            FOREACH artg131_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg131_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg131_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg131_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_greet  STRING
    
    ORDER EXTERNAL BY sr1.lpk01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.lpk01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B40097 add---------str------
            IF tm.d = '1' OR tm.d = '2' OR tm.d = '3' THEN
               LET l_greet = cl_gr_getmsg("gre-106",g_lang,tm.d)
            ELSE
               IF tm.d = '4' THEN
                  LET l_greet = tm.e
               ELSE
                  LET l_greet = NULL
               END IF
            END IF
            PRINTX l_greet
            #FUN-B40097 add--------end-----

            PRINTX sr1.*

        AFTER GROUP OF sr1.lpk01

        
        ON LAST ROW

END REPORT
###GENGRE###END
