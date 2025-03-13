# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almr141.4gl
# Descriptions...: 攤位明細統計表
# Date & Author..: No.FUN-C50042 12/05/14 By SunLM
# Modify.........: No.FUN-C50042 12/05/14 By SunLM
# Modify.........: No.TQC-C50192 12/05/22 By SunLM 調整畫面格式CheckBox--->RadioGroup
 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                       # Print condition RECORD
           wc       STRING, 
           lmf05   LIKE type_file.chr10,
           subt    LIKE type_file.chr1, # Order by sequence
           more    LIKE type_file.chr1  # Input more condition(Y/N)
           END RECORD 
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   l_store         STRING 

MAIN

   OPTIONS
      INPUT NO WRAP          #输入的方式：不打转
   DEFER INTERRUPT           #撷取中断键

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

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF     
   
   LET g_sql =  "lmf01.lmf_file.lmf01,",        
                "lmfstore.lmf_file.lmfstore,",       
                "rtz13.rtz_file.rtz13,",   
                "lmf03.lmf_file.lmf03,",    
                "lmb03.lmb_file.lmb03,",  
                "lmf04.lmf_file.lmf04,",  
                "lmc04.lmc_file.lmc04,",  
                "lmf09.lmf_file.lmf09,",  
                "lmf10.lmf_file.lmf10,",  
                "lmf11.lmf_file.lmf11,",  
                "tqa02.tqa_file.tqa02,",   
                "lmf05.lmf_file.lmf05,",
                "lmf13.lmf_file.lmf13,",
                "lmf06.lmf_file.lmf06,",
                "lmf07.lmf_file.lmf07,",
                "lmf08.lmf_file.lmf08,",
                "lmf14.lmf_file.lmf14"  
 
   LET l_table = cl_prt_temptable('almr141',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN #判斷是否是背景運行
      CALL r141_tm(5,10)                      #非背景運行，錄入打印報表條件
   ELSE 
      CALL r141()                             #按傳入條件背景列印報表
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION r141_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01,
          l_cmd          LIKE type_file.chr1000,
          l_sql          STRING 
   DEFINE l_where        STRING

   OPEN WINDOW almr141_w AT p_row,p_col WITH FORM "alm/42f/almr141" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')

   INITIALIZE tm.* TO NULL            # Default condition  
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.subt   = 'N'
   LET tm.more  = 'N'

   WHILE TRUE
         CONSTRUCT BY NAME tm.wc ON lmfstore,lmf03,lmf04,lmf01
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            
         ON ACTION controlp
            
            CASE
               WHEN INFIELD(lmfstore) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmf2"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmfstore
                  NEXT FIELD lmfstore
               WHEN INFIELD(lmf03)
                  CALL cl_init_qry_var()                             
                  LET g_qryparam.form = "q_lmf3"                     
                  LET g_qryparam.state = "c"                         
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO lmf03               
                  NEXT FIELD lmf03                                   
            
               WHEN INFIELD(lmf04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmf4"
                  LET g_qryparam.state = "c"            
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmf04
                  NEXT FIELD lmf04
    
               WHEN INFIELD(lmf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_lmf1"
                  LET g_qryparam.state= "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmf01
                  NEXT FIELD lmf01
            END CASE 

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT

         ON ACTION CONTROLG
            CALL cl_cmdask()
  
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION HELP
            CALL cl_show_help()

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
         LET INT_FLAG = 0 CLOSE WINDOW almr141_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DISPLAY BY NAME tm.lmf05,tm.subt,tm.more                # Condition 
      INPUT BY NAME tm.lmf05,tm.subt,tm.more ATTRIBUTE(WITHOUT DEFAULTS)
          BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
          AFTER FIELD more
             IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
                THEN NEXT FIELD more
             END IF
             IF tm.more = 'Y' THEN
                CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
             END IF 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
         LET INT_FLAG = 0 CLOSE WINDOW almr141_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='almr141'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('almr141','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"") #"
            LET l_cmd = l_cmd CLIPPED,               #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",tm.lmf05 CLIPPED,"'" ,    
                       " '",tm.subt CLIPPED,"'" ,                   
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('almr141',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW almr141_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r141()
      ERROR ""
   END WHILE 
   
   CLOSE WINDOW almr141_w
END FUNCTION 

FUNCTION r141() #FUN-C50042
DEFINE l_sql STRING 
DEFINE sr    RECORD 
             lmf01     LIKE lmf_file.lmf01,        
             lmfstore  LIKE lmf_file.lmfstore,       
             rtz13     like rtz_file.rtz13, 
             lmf03     like lmf_file.lmf03,  
             lmb03     like lmb_file.lmb03,
             lmf04     like lmf_file.lmf04,
             lmc04     like lmc_file.lmc04,
             lmf09     like lmf_file.lmf09,
             lmf10     like lmf_file.lmf10,
             lmf11     like lmf_file.lmf11,
             tqa02     like tqa_file.tqa02, 
             lmf05     like lmf_file.lmf05,
             lmf13     like lmf_file.lmf13,
             lmf06     like lmf_file.lmf06,
             lmf07     like lmf_file.lmf07,
             lmf08     like lmf_file.lmf08,
             lmf14     like lmf_file.lmf14 
             END RECORD

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                "        ?,?,?,?,?, ?,?)"                                                                                                         
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)            
       CALL cl_used(g_prog,g_time,2) RETURNING g_time                                  
       EXIT PROGRAM                                                                                                                 
    END IF
    LET l_sql = " SELECT lmf01,lmfstore,rtz13,lmf03,lmb03,lmf04,lmc04,lmf09, ",
                " lmf10,lmf11,tqa02,lmf05,lmf13,lmf06,lmf07,lmf08,lmf14 ",
                "  FROM lmf_file LEFT OUTER JOIN rtz_file ON lmfstore = rtz01 ",
                " LEFT OUTER JOIN lmb_file ON lmbstore = lmfstore AND lmb02 = lmf03 ",
                " LEFT OUTER JOIN lmc_file ON lmcstore = lmfstore AND lmc02 = lmf03 AND lmc03 = lmf04 ",
                " LEFT OUTER JOIN tqa_file ON tqa01 = lmf12 AND tqa03 = '30' ",
                " WHERE ",tm.wc CLIPPED
                
    CASE tm.lmf05  #TQC-C50192 add
       WHEN '1' LET l_sql=l_sql CLIPPED," AND lmf05='1' "
       WHEN '2' LET l_sql=l_sql CLIPPED," AND lmf05='2' "
       WHEN '3' LET l_sql=l_sql CLIPPED," AND lmf05='3' "
    END CASE
    LET l_sql=l_sql CLIPPED," ORDER BY lmf01,lmfstore,lmf03,lmf04 "
    PREPARE almr141_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE almr141_curs1 CURSOR FOR almr141_prepare1

    FOREACH almr141_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.lmf09) THEN LET sr.lmf09 = 0 END IF
       IF cl_null(sr.lmf10) THEN LET sr.lmf10 = 0 END IF
       IF cl_null(sr.lmf11) THEN LET sr.lmf11 = 0 END IF          
       EXECUTE  insert_prep  USING sr.*
    END FOREACH 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    INITIALIZE g_str TO NULL
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'lmfstore,lmf03,lmf04,lie04,lmf01,lmf05') RETURNING tm.wc
       LET g_str = tm.wc
       IF g_str.getLength() > 1000 THEN
          LET g_str = g_str.subString(1,600)
          LET g_str = g_str,"..."
       END IF
   END IF
   LET g_str = g_str,";",tm.subt
   CALL cl_prt_cs1('almr141','almr141',l_sql,g_str) 
END FUNCTION 

