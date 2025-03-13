# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almg381.4gl
# Descriptions...: 优惠信息统计表 
# Date & Author..: No.FUN-C60062 12/06/19 by nanbing


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD   
           wc           LIKE type_file.chr1000,                  
           ljaplant     LIKE lja_file.ljaplant,
           lmb02        LIKE lmb_file.lmb02,
           lmc03        LIKE lmc_file.lmc03,
           lmf01        LIKE lmf_file.lmf01,
           lne01        LIKE lne_file.lne01,
           bdate        LIKE type_file.dat,
           edate        LIKE type_file.dat,
           type1        LIKE type_file.chr3,
           cb           LIKE type_file.chr1,
           more         LIKE type_file.chr1     
           END RECORD
DEFINE g_wc          STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE g_chk_azw01   LIKE type_file.chr1
DEFINE g_chk_auth    STRING  
DEFINE g_azw01       LIKE azw_file.azw01 
DEFINE g_azw01_str   STRING 





###GENGRE###START
TYPE sr1_t RECORD
    ljaplant LIKE lja_file.ljaplant,
    rtz13 LIKE rtz_file.rtz13,
    lja06 LIKE lja_file.lja06,
    lmf13 LIKE lmf_file.lmf13,
    lja12 LIKE lja_file.lja12,
    lne05 LIKE lne_file.lne05,
    lja10 LIKE lja_file.lja10,
    ljb03 LIKE ljb_file.ljb03,
    ljb08 LIKE ljb_file.ljb08,
    ljb04 LIKE ljb_file.ljb04,
    oaj02 LIKE oaj_file.oaj02,
    ljb05 LIKE ljb_file.ljb05,
    ljb06 LIKE ljb_file.ljb06,
    ljb07 LIKE ljb_file.ljb07
    
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT 
   
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.type1 = ARG_VAL(10)
   LET tm.cb  = ARG_VAL(11) 
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)


   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql=  "ljaplant.lja_file.ljaplant,",
               "rtz13.rtz_file.rtz13,",
               "lja06.lja_file.lja06,",
               "lmf13.lmf_file.lmf13,",
               "lja12.lja_file.lja12,",
               "lne05.lne_file.lne05,",
               "lja10.lja_file.lja10,",
               "ljb03.ljb_file.ljb03,",
               "ljb08.ljb_file.ljb08,",
               "ljb04.ljb_file.ljb04,",
               "oaj02.oaj_file.oaj02,",
               "ljb05.ljb_file.ljb05,",
               "ljb06.ljb_file.ljb06,",
               "ljb07.ljb_file.ljb07 "
    LET l_table = cl_prt_temptable('almg381',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL almg381_tm()        
    ELSE 
       CALL almg381() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
    CALL cl_gre_drop_temptable(l_table)  
END MAIN

FUNCTION almg381_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          STRING,
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE l_sql          STRING

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW almg381_w AT p_row,p_col WITH FORM "alm/42f/almg381" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'

   LET tm.type1='0'
   LET tm.cb = 'N' 

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ljaplant,lmb02,lmc03,lmf01,lne01
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT 

         AFTER FIELD ljaplant
            LET g_chk_azw01 = TRUE 
            LET g_azw01_str = get_fldbuf(ljaplant)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_azw01_str) AND g_azw01_str <> "*" THEN
               LET g_chk_azw01 = FALSE 
               LET tok = base.StringTokenizer.create(g_azw01_str,"|") 
               LET g_azw01 = ""
               WHILE tok.hasMoreTokens() 
                   LET g_azw01 = tok.nextToken()
                   LET l_sql = " SELECT COUNT(*) FROM azw_file",
                               " WHERE azw01 ='",g_azw01,"'",
                               " AND azw01 IN ",g_auth,
                               " AND azwacti = 'Y'"
                   PREPARE sel_num_pre FROM l_sql
                   EXECUTE sel_num_pre INTO l_n 
                      IF l_n > 0 THEN
                          IF g_chk_auth IS NULL THEN
                             LET g_chk_auth = "'",g_azw01,"'"
                          ELSE
                             LET g_chk_auth = g_chk_auth,",'",g_azw01,"'"
                          END IF 
                      ELSE
                         CONTINUE WHILE
                      END IF
               END WHILE
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF
            END IF
          
         ON ACTION controlp
            CASE
               WHEN INFIELD(ljaplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ljaplant_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azw01 IN ",g_auth," "  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljaplant
                  LET tm.ljaplant = g_qryparam.multiret
                  NEXT FIELD ljaplant
              WHEN INFIELD(lmb02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmf03_1" 
                  LET g_qryparam.where = " lmbstore IN",g_auth," " 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmb02
                  NEXT FIELD lmb02
               WHEN INFIELD(lmc03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmf04_1"
                  LET g_qryparam.where = " lmcstore IN ",g_auth," "  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmc03
                  NEXT FIELD lmc03
               WHEN INFIELD(lmf01)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lmf1"
                  LET g_qryparam.where = " lmfstore IN ",g_auth," "  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lmf01
                  NEXT FIELD lmf01
               WHEN INFIELD(lne01)               
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lne02"
                  LET g_qryparam.where = " lne36 = 'Y' "  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lne01
                  NEXT FIELD lne01
            
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

         AFTER CONSTRUCT
            IF INT_FLAG THEN
               LET INT_FLAG = 0 CLOSE WINDOW almg381_w 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time
               CALL cl_gre_drop_temptable(l_table)   
               EXIT PROGRAM
            END IF  
            IF cl_null(GET_FLDBUF(ljaplant)) OR GET_FLDBUF(ljaplant) = "*" THEN   
               LET g_chk_auth = g_auth
            END IF
            
      END CONSTRUCT   
      
      IF cl_null(tm.wc) THEN
         LET tm.wc = " 1=1"
      END IF

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW almg381_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)   
         EXIT PROGRAM
      END IF
      DISPLAY BY NAME tm.bdate,tm.edate,tm.type1,tm.cb,tm.more
      INPUT BY NAME tm.bdate,tm.edate,tm.type1,tm.cb,tm.more WITHOUT DEFAULTS  
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
          ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

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
         LET INT_FLAG = 0 CLOSE WINDOW almg381_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)   
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='almg381'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('almg381','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd1 CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc CLIPPED,"'" ,
                       " '",tm.bdate CLIPPED,"'",
                       " '",tm.edate CLIPPED,"'",
                       " '",tm.type1 CLIPPED,"'",
                       " '",tm.cb CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('almg381',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW almg381_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)   
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL almg381()
      ERROR ""
   END WHILE
   CLOSE WINDOW almg381_w

END FUNCTION


FUNCTION almg381() 
DEFINE    l_name    LIKE type_file.chr20,                
          l_sql     STRING ,                      
          sr        RECORD 
                   ljaplant LIKE lja_file.ljaplant,
                   rtz13 LIKE rtz_file.rtz13,
                   lja06 LIKE lja_file.lja06,
                   lmf13 LIKE lmf_file.lmf13,
                   lja12 LIKE lja_file.lja12,
                   lne05 LIKE lne_file.lne05,
                   lja10 LIKE lja_file.lja10,
                   ljb03 LIKE ljb_file.ljb03,
                   ljb08 LIKE ljb_file.ljb08,
                   ljb04 LIKE ljb_file.ljb04,
                   oaj02 LIKE oaj_file.oaj02,
                   ljb05 LIKE ljb_file.ljb05,
                   ljb06 LIKE ljb_file.ljb06,
                   ljb07 LIKE ljb_file.ljb07
                    END RECORD
DEFINE l_plant      LIKE azw_file.azw01
DEFINE l_azw08      LIKE azw_file.azw08
DEFINE l_lse01      LIKE lse_file.lse01
DEFINE l_lse02      LIKE lse_file.lse02
DEFINE l_rce05      LIKE rce_file.rce05
DEFINE l_rce05_sum  LIKE type_file.num20_6
DEFINE l_azi04      LIKE azi_file.azi04
  
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table)    
       EXIT PROGRAM
    END IF   
    INITIALIZE sr.* TO NULL
    CALL cl_del_data(l_table)
    LET l_sql = " SELECT DISTINCT azw01 FROM azw_file,rtz_file ",
                " WHERE azw01 = rtz01 AND azw01 IN ",g_chk_auth
    LET l_sql = l_sql," ORDER BY azw01 "
    PREPARE sel_azw01_pre FROM l_sql
    DECLARE sel_azw01_cs CURSOR FOR sel_azw01_pre           
    FOREACH sel_azw01_cs INTO l_plant
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      LET l_sql = " SELECT ljaplant,rtz13,lja06,lmf13,lja12,lne05,lja10,ljb03,ljb08,ljb04,oaj02,ljb05,ljb06,ljb07 ",
                  "   FROM ",cl_get_target_table(l_plant,'lja_file'),
                  " LEFT JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON rtz01 = ljaplant ,",
                             cl_get_target_table(l_plant,'ljb_file'),
                  " LEFT JOIN ",cl_get_target_table(l_plant,'oaj_file')," ON oaj01 = ljb04 ,",           
                             cl_get_target_table(l_plant,'lne_file'),",",
                             cl_get_target_table(l_plant,'lmf_file'),  
                  " LEFT JOIN ",cl_get_target_table(l_plant,'lmb_file')," ON lmbstore = lmfstore AND lmb02 = lmf03 ",
                  " LEFT JOIN ",cl_get_target_table(l_plant,'lmc_file')," ON lmcstore = lmfstore AND lmc03 = lmf04 AND lmb02 = lmc02 ",           
                  " WHERE lja01 = ljb01  AND lja06 = lmf01",
                  "   AND lne01 = lja12 ",
                  "   AND lmfstore = ljaplant AND ljaplant = ljbplant ",
                  "   AND ljaplant = '",l_plant,"'",
                  "   AND ljaconf = 'Y' ",
                  "   AND ",tm.wc CLIPPED
      IF NOT cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
        LET l_sql = l_sql," AND ljb05 >= '",tm.bdate,"'"
      END IF 
      IF cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
         LET l_sql = l_sql," AND ljb06 <= '",tm.edate,"'"
      END IF
      IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
         LET l_sql = l_sql," AND ljb05 >= '",tm.bdate ,"' AND ljb06 <= '",tm.edate,"'"
      END IF           
      
      CASE 
         WHEN tm.type1='1'
            LET l_sql = l_sql," AND lja01 IN (SELECT lit05 FROM ",cl_get_target_table(l_plant,'lit_file'),
                                                               ",",cl_get_target_table(l_plant,'lnt_file'),
                              "                WHERE  lit01 = lnt01 AND lnt26 = 'Y') "
         WHEN tm.type1='2'
            LET l_sql = l_sql," AND lja01 NOT IN (SELECT lit05 FROM ",cl_get_target_table(l_plant,'lit_file'),
                                                               ",",cl_get_target_table(l_plant,'lnt_file'),
                              "                WHERE  lit01 = lnt01 AND lnt26 = 'Y') "
      END CASE
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
      PREPARE almg381_prepare1 FROM l_sql  
      DECLARE almg381_curs1 CURSOR FOR almg381_prepare1 
      FOREACH almg381_curs1 INTO sr.* 
         
         EXECUTE insert_prep USING sr.*
      END FOREACH 
      
    END FOREACH
###GENGRE###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ljaplant,lmb02,lmc03,lmf01,lne01')
             RETURNING g_wc
        IF g_wc.getLength() > 1000 THEN
            LET g_wc = g_wc.subString(1,600)
            LET g_wc = g_wc,"..."
        END IF
    END IF
   LET g_template = 'almg381' 
   CALL almg381_grdata()    ###GENGRE###

END FUNCTION



FUNCTION almg381_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    
    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("almg381")
        IF handler IS NOT NULL THEN
            START REPORT almg381_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ljaplant,lja06 "
            DECLARE almg381_datacur1 CURSOR FROM l_sql
            FOREACH almg381_datacur1 INTO sr1.*
                OUTPUT TO REPORT almg381_rep(sr1.*)
            END FOREACH
            FINISH REPORT almg381_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT almg381_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sum    LIKE ljb_file.ljb07
    DEFINE l_ljb03  STRING 
    DEFINE g_lla03        LIKE lla_file.lla03
    DEFINE g_lla04        LIKE lla_file.lla04
    DEFINE l_lja10_str    STRING 
    DEFINE l_sum_str    STRING
    DEFINE l_ljb07_str    STRING 
    ORDER EXTERNAL BY sr1.ljaplant
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX tm.*
            PRINTX g_wc
        BEFORE GROUP OF sr1.ljaplant
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            SELECT lla03,lla04 INTO g_lla03,g_lla04 FROM lla_file
             WHERE llastore = sr1.ljaplant
            LET l_ljb03 = cl_gr_getmsg('gre-288',g_lang,sr1.ljb03)
            PRINTX l_ljb03
            CASE g_lla03
               WHEN '0'   LET l_lja10_str = sr1.lja10 USING '--,---,---,---,---,--&'
                             
               WHEN '1'   LET l_lja10_str = sr1.lja10 USING '--,---,---,---,---,--&.&'
                          
               WHEN '2'   LET l_lja10_str = sr1.lja10 USING '--,---,---,---,---,--&.&&'
                           
               WHEN '3'   LET l_lja10_str = sr1.lja10 USING '--,---,---,---,---,--&.&&&'
                           
               WHEN '4'   LET l_lja10_str = sr1.lja10 USING '--,---,---,---,---,--&.&&&&'
                          
               WHEN '5'   LET l_lja10_str = sr1.lja10 USING '--,---,---,---,---,--&.&&&&&'
                        
               WHEN '6'   LET l_lja10_str = sr1.lja10 USING '--,---,---,---,---,--&.&&&&&&'
                             
            END CASE
            LET l_lja10_str = l_lja10_str.trim()    
            PRINTX l_lja10_str
            CASE g_lla04
               WHEN '0'   LET l_ljb07_str = sr1.ljb07 USING '--,---,---,---,---,--&'
                             
               WHEN '1'   LET l_ljb07_str = sr1.ljb07 USING '--,---,---,---,---,--&.&'
                          
               WHEN '2'   LET l_ljb07_str = sr1.ljb07 USING '--,---,---,---,---,--&.&&'
                           
               WHEN '3'   LET l_ljb07_str = sr1.ljb07 USING '--,---,---,---,---,--&.&&&'
                           
               WHEN '4'   LET l_ljb07_str = sr1.ljb07 USING '--,---,---,---,---,--&.&&&&'
                          
               WHEN '5'   LET l_ljb07_str = sr1.ljb07 USING '--,---,---,---,---,--&.&&&&&'
                        
               WHEN '6'   LET l_ljb07_str = sr1.ljb07 USING '--,---,---,---,---,--&.&&&&&&'
                             
            END CASE
            LET l_ljb07_str = l_ljb07_str.trim()  
            PRINTX l_ljb07_str 
            PRINTX sr1.*
        AFTER GROUP OF sr1.ljaplant
           LET l_sum = GROUP SUM(sr1.ljb07)  
           CASE g_lla04
               WHEN '0'   LET l_sum_str = l_sum USING '--,---,---,---,---,--&'
                             
               WHEN '1'   LET l_sum_str = l_sum USING '--,---,---,---,---,--&.&'
                          
               WHEN '2'   LET l_sum_str = l_sum USING '--,---,---,---,---,--&.&&'
                           
               WHEN '3'   LET l_sum_str = l_sum USING '--,---,---,---,---,--&.&&&'
                           
               WHEN '4'   LET l_sum_str = l_sum USING '--,---,---,---,---,--&.&&&&'
                          
               WHEN '5'   LET l_sum_str = l_sum USING '--,---,---,---,---,--&.&&&&&'
                        
               WHEN '6'   LET l_sum_str = l_sum USING '--,---,---,---,---,--&.&&&&&&'
                             
            END CASE
            LET l_sum_str = l_sum_str.trim()    
            PRINTX l_sum_str
        ON LAST ROW

END REPORT
#FUN-C60062 END
