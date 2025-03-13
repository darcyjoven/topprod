# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axcg480.4gl
# Descriptions...: 成本分錄底稿明細資料
# Date & Author..: 12/11/30  By Bart #FUN-C70119
 
DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE tm  RECORD  
              wc      STRING,               # Where condition  
              more    LIKE type_file.chr1   # Input more condition(Y/N)
              END RECORD,
       g_ksc00        LIKE ksc_file.ksc00,
       g_program      LIKE apm_file.apm01     
 
#DEFINE g_i            LIKE type_file.num5     #count/index for any purpose     
DEFINE g_cdn01        LIKE cdn_file.cdn01
DEFINE g_cdn02        LIKE cdn_file.cdn02
DEFINE g_sql          STRING                                                       
DEFINE l_table        STRING                                                       
#DEFINE l_str          STRING   

 
###GENGRE###START
TYPE sr1_t RECORD
    cdn01 LIKE cdn_file.cdn01,
    cdn02 LIKE cdn_file.cdn02,
    cdn03 LIKE cdn_file.cdn03,
    cdn031 LIKE cdn_file.cdn031,
    cdn04 LIKE cdn_file.cdn04,
    cdn05 LIKE cdn_file.cdn05,
    cdn06 LIKE cdn_file.cdn06,
    cdn07 LIKE cdn_file.cdn07,
    cdn07f LIKE cdn_file.cdn07f,
    cdn08 LIKE cdn_file.cdn08,
    sign_type LIKE type_file.chr1,  
    sign_img  LIKE type_file.blob,   
    sign_show LIKE type_file.chr1,   
    sign_str  LIKE type_file.chr1000 
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
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

   LET g_sql ="cdn01.cdn_file.cdn01,",
              "cdn02.cdn_file.cdn02,",
              "cdn03.cdn_file.cdn03,",
              "cdn031.cdn_file.cdn031,",
              "cdn04.cdn_file.cdn04,",
              "cdn05.cdn_file.cdn05,",
              "cdn06.cdn_file.cdn06,",
              "cdn07.cdn_file.cdn07,",
              "cdn07f.cdn_file.cdn07f,",
              "cdn08.cdn_file.cdn08,",
              "sign_type.type_file.chr1,sign_img.type_file.blob,",  
              "sign_show.type_file.chr1,sign_str.type_file.chr1000" 
   LET l_table = cl_prt_temptable('axcg480',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_gre_drop_temptable(l_table) 
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_gre_drop_temptable(l_table)           
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   IF cl_null(g_program) THEN LET g_program = 'axcg480' END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g480_tm(0,0)        # Input print condition
      ELSE CALL g480()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g480_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5      
DEFINE l_cmd          LIKE type_file.chr1000      
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW g480_w AT p_row,p_col WITH FORM "axc/42f/axcg480"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON cdn01,cdn02

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()               
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION EXIT
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
         LET INT_FLAG = 0 CLOSE WINDOW g480_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM  
      END IF
   
      INPUT BY NAME tm.more WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD MORE
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
         
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         
         ON ACTION CONTROLG 
            CALL cl_cmdask()   
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW g480_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
   
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axcg480'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axcg480','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",          
                         " '",g_rep_clas CLIPPED,"'",          
                         " '",g_template CLIPPED,"'",          
                         " '",g_rpt_name CLIPPED,"'"          
            CALL cl_cmdat('axcg480',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g480_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g480()
      ERROR ""
   END WHILE
   CLOSE WINDOW g480_w
END FUNCTION
 
FUNCTION g480()
   DEFINE l_img_blob        LIKE type_file.blob 
   DEFINE l_name    LIKE type_file.chr20,         
          l_sql     STRING,   
          sr        RECORD
                    cdn01   LIKE cdn_file.cdn01,
                    cdn02   LIKE cdn_file.cdn02,
                    cdn03   LIKE cdn_file.cdn03,
                    cdn031   LIKE cdn_file.cdn031,
                    cdn04   LIKE cdn_file.cdn04,
                    cdn05   LIKE cdn_file.cdn05,
                    cdn06   LIKE cdn_file.cdn06,
                    cdn07   LIKE cdn_file.cdn07,
                    cdn07f   LIKE cdn_file.cdn07f,
                    cdn08   LIKE cdn_file.cdn08
                    END RECORD
   DEFINE l_i,l_cnt          LIKE type_file.num5                 
   #DEFINE l_zaa02            LIKE zaa_file.zaa02     
   #DEFINE l_str2        LIKE type_file.chr1000        
   #DEFINE l_ksd35       STRING     
   #DEFINE l_ksd32       STRING     
   #DEFINE l_ima906      LIKE ima_file.ima906     
   LOCATE l_img_blob        IN MEMORY            
   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('kscuser', 'kscgrup')

     LET l_sql = "SELECT cdn01,cdn02,cdn03,cdn031,cdn04, ",        
                 "       cdn05,cdn06,cdn07,cdn07f,cdn08  ", 
                 " FROM cdn_file ",
                 " WHERE ",tm.wc CLIPPED,
                 " ORDER BY cdn01,cdn02 "
                 
     PREPARE g480_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE g480_curs1 CURSOR FOR g480_prepare1
 
     CALL cl_del_data(l_table) 
 
     FOREACH g480_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
        EXECUTE insert_prep USING sr.cdn01,sr.cdn02,sr.cdn03,sr.cdn031,sr.cdn04,   
                                   sr.cdn05,sr.cdn06,sr.cdn07,sr.cdn07f,sr.cdn08,
                                   "",  l_img_blob,"N",""
     END FOREACH
 
     LET l_sql = "SELECT * FROM ",l_table CLIPPED                                 
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'cdn01,cdn02')  
        RETURNING tm.wc                                                           
     END IF                      

    LET g_cr_table = l_table                 
    LET g_cr_apr_key_f = "cdn01"             
    CALL axcg480_grdata()    ###GENGRE###
END FUNCTION

 
###GENGRE###START
FUNCTION axcg480_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY 
    CALL cl_gre_init_apr()            
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axcg480")
        IF handler IS NOT NULL THEN
            START REPORT axcg480_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY cdn01,cdn02 " 
            DECLARE axcg480_datacur1 CURSOR FROM l_sql
            FOREACH axcg480_datacur1 INTO sr1.*
                OUTPUT TO REPORT axcg480_rep(sr1.*)
            END FOREACH
            FINISH REPORT axcg480_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axcg480_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5     
    DEFINE l_cdn06_desc  STRING  
    
    ORDER EXTERNAL BY sr1.cdn01,sr1.cdn02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.cdn01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.cdn02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_cdn06_desc = cl_gr_getmsg("gre-055",g_lang,sr1.cdn06)
            PRINTX l_cdn06_desc
            #LET l_ksc04_gem02 = sr1.ksc04, ' ',sr1.gem02
            #PRINTX l_ksc04_gem02

            #LET l_ksc05_azf03 = sr1.ksc05, ' ',sr1.azf03
            #PRINTX l_ksc05_azf03

            #LET l_ksc05_ksd06_ksd07 = '(',sr1.ksd05,'/',sr1.ksd06,'/',sr1.ksd07,')'
            #PRINTX l_ksc05_ksd06_ksd07

            #PRINTX g_sma115

            PRINTX sr1.*

        AFTER GROUP OF sr1.cdn01
        AFTER GROUP OF sr1.cdn02
        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C70119
