# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: almg385.4gl
# Descriptions...: 終止信息統計表
# Date & Author..: No.FUN-C60062 12/06/20 by nanbing


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD   
           wc           LIKE type_file.chr1000,                  
           ljeplant     LIKE lje_file.ljeplant,
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
DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE g_chk_azw01   LIKE type_file.chr1
DEFINE g_chk_auth    STRING  
DEFINE g_azw01       LIKE azw_file.azw01 
DEFINE g_azw01_str   STRING 





###GENGRE###START
TYPE sr1_t RECORD
    lnt01    LIKE lnt_file.lnt01,  
    ljeplant LIKE lje_file.ljeplant,
    rtz13    LIKE rtz_file.rtz13,
    lnt08    LIKE lnt_file.lnt08,
    lmb03    LIKE lmb_file.lmb03,
    lnt09    LIKE lnt_file.lnt09,
    lmc04    LIKE lmc_file.lmc04,
    lnt06    LIKE lnt_file.lnt06,
    lmf13    LIKE lmf_file.lmf13,
    lnt04    LIKE lnt_file.lnt04,
    lne05    LIKE lne_file.lne05,
    lje14    LIKE lje_file.lje14,
    lje11    LIKE lje_file.lje11,
    lje12    LIKE lje_file.lje12,
    lje13    LIKE lje_file.lje13,  
    lnt64    LIKE lnt_file.lnt64,
    lnt65    LIKE lnt_file.lnt65,
    lnt66    LIKE lnt_file.lnt66,
    lje15    LIKE lje_file.lje15,
    l_sum_liw14 LIKE liw_file.liw14,
    lje20    LIKE lje_file.lje20,  
    lje17    LIKE lje_file.lje17,  
    lje22    LIKE lje_file.lje22
    
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
   LET g_sql=  "lnt01.lnt_file.lnt01, ",
               "ljeplant.lje_file.ljeplant,",
               "rtz13.rtz_file.rtz13,",
               "lnt08.lnt_file.lnt08,",
               "lmb03.lmb_file.lmb03,",
               "lnt09.lnt_file.lnt09,",
               "lmc04.lmc_file.lmc04,",
               "lnt06.lnt_file.lnt06,",
               "lmf13.lmf_file.lmf13,",
               "lnt04.lnt_file.lnt04,",
               "lne05.lne_file.lne05,",
               "lje14.lje_file.lje14,",
               "lje11.lje_file.lje11,",
               "lje12.lje_file.lje12,",
               "lje13.lje_file.lje13,",
               "lnt64.lnt_file.lnt64,",
               "lnt65.lnt_file.lnt65,",
               "lnt66.lnt_file.lnt66,",
               "lje15.lje_file.lje15,",
               "l_sum_liw14.liw_file.liw14,",
               "lje20.lje_file.lje20,",
               "lje17.lje_file.lje17,",
               "lje22.lje_file.lje22 "
    LET l_table = cl_prt_temptable('almg385',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL almg385_tm()        
    ELSE 
       CALL almg385() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION almg385_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          STRING,
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE l_sql          STRING

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW almg385_w AT p_row,p_col WITH FORM "alm/42f/almg385" 
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
      CONSTRUCT BY NAME tm.wc ON ljeplant,lmb02,lmc03,lmf01,lne01
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT 

         AFTER FIELD ljeplant
            LET g_chk_azw01 = TRUE 
            LET g_azw01_str = get_fldbuf(ljeplant)  
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
               WHEN INFIELD(ljeplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ljeplant_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azw01 IN ",g_auth," "  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ljeplant
                  LET tm.ljeplant = g_qryparam.multiret
                  NEXT FIELD ljeplant
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
               LET INT_FLAG = 0 CLOSE WINDOW almg385_w 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time 
               EXIT PROGRAM
            END IF  
            IF cl_null(GET_FLDBUF(ljeplant)) OR GET_FLDBUF(ljeplant) = "*" THEN   
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
         LET INT_FLAG = 0 CLOSE WINDOW almg385_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DISPLAY BY NAME tm.bdate,tm.edate,tm.cb,tm.more,tm.type1
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
         LET INT_FLAG = 0 CLOSE WINDOW almg385_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='almg385'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('almg385','9031',1)
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
            CALL cl_cmdat('almg385',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW almg385_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL almg385()
      ERROR ""
   END WHILE
   CLOSE WINDOW almg385_w

END FUNCTION


FUNCTION almg385() 
DEFINE    l_name    LIKE type_file.chr20,                
          l_sql     STRING ,                      
          sr        RECORD 
                     lnt01    LIKE lnt_file.lnt01, 
                     ljeplant LIKE lje_file.ljeplant,
                     rtz13    LIKE rtz_file.rtz13,
                     lnt08    LIKE lnt_file.lnt08,
                     lmb03    LIKE lmb_file.lmb03,
                     lnt09    LIKE lnt_file.lnt09,
                     lmc04    LIKE lmc_file.lmc04,
                     lnt06    LIKE lnt_file.lnt06,
                     lmf13    LIKE lmf_file.lmf13,
                     lnt04    LIKE lnt_file.lnt04,
                     lne05    LIKE lne_file.lne05,
                     lje14    LIKE lje_file.lje14,
                     lje11    LIKE lje_file.lje11,
                     lje12    LIKE lje_file.lje12, 
                     lje13    LIKE lje_file.lje13,  
                     lnt64    LIKE lnt_file.lnt64,
                     lnt65    LIKE lnt_file.lnt65,
                     lnt66    LIKE lnt_file.lnt66,
                     lje15    LIKE lje_file.lje15,
                     l_sum_liw14 LIKE liw_file.liw14,
                     lje20    LIKE lje_file.lje20,  
                     lje17    LIKE lje_file.lje17,  
                     lje22    LIKE lje_file.lje22 
                    END RECORD
DEFINE l_plant      LIKE azw_file.azw01
DEFINE l_azw08      LIKE azw_file.azw08
DEFINE l_lse01      LIKE lse_file.lse01
DEFINE l_lse02      LIKE lse_file.lse02
DEFINE l_rce05      LIKE rce_file.rce05
DEFINE l_rce05_sum  LIKE type_file.num20_6
DEFINE l_azi04      LIKE azi_file.azi04
  
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   
       EXIT PROGRAM
    END IF   
    INITIALIZE sr.* TO NULL
    CALL cl_del_data(l_table)
    LET l_sql = " SELECT DISTINCT azw01 FROM azw_file,azp_file ",
                " WHERE azw01 = azp01 AND azw01 IN ",g_chk_auth
    LET l_sql = l_sql," ORDER BY azw01 "
    PREPARE sel_azw01_pre FROM l_sql
    DECLARE sel_azw01_cs CURSOR FOR sel_azw01_pre           
    FOREACH sel_azw01_cs INTO l_plant
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      LET l_sql = " SELECT DISTINCT lnt01,ljeplant,rtz13,lnt08,lmb03,lnt09,lmc04,lnt06,lmf13,lnt04, ",
                  "  lne05,lje14,lje11,lje12,lje13,lnt64,lnt65,lnt66,lje15,'',lje20,lje17,lje22 ",
                  "   FROM ",cl_get_target_table(l_plant,'lje_file'),
                  " LEFT JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON rtz01 = ljeplant ,",
                             cl_get_target_table(l_plant,'lnt_file'),",",
                             cl_get_target_table(l_plant,'lne_file'),",",
                             cl_get_target_table(l_plant,'lmf_file'),  
                  " LEFT JOIN ",cl_get_target_table(l_plant,'lmb_file')," ON lmbstore = lmfstore AND lmb02 = lmf03 ",
                  " LEFT JOIN ",cl_get_target_table(l_plant,'lmc_file')," ON lmcstore = lmfstore AND lmc03 = lmf04 AND lmb02 = lmc02 ",           
                  " WHERE lje04 = lnt01 AND lmf01 = lnt06 ",
                  "   AND lne01 = lnt04 ",
                  "   AND lmfstore = ljeplant AND ljeplant = lntplant ",
                  "   AND ljeplant = '",l_plant,"'",
                  "   AND ljeconf = 'Y' ",
                  "   AND ",tm.wc CLIPPED
      IF NOT cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
        LET l_sql = l_sql," AND lje14 >= '",tm.bdate,"'"
      END IF 
      IF cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
         LET l_sql = l_sql," AND lje14 <= '",tm.edate,"'"
      END IF
      IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN 
         LET l_sql = l_sql," AND lje14 BETWEEN '",tm.bdate ,"' AND '",tm.edate,"'"
      END IF           
      
      CASE 
         WHEN tm.type1='1'
            LET l_sql = l_sql," AND lje01 IN (SELECT lji03 FROM ",cl_get_target_table(l_plant,'lji_file'),
                              "                WHERE ljiconf = 'Y') "
         WHEN tm.type1='2'
            LET l_sql = l_sql," AND lje01 NOT IN (SELECT lji03 FROM ",cl_get_target_table(l_plant,'lji_file'),
                              "                WHERE ljiconf = 'Y') "
      END CASE
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
      PREPARE almg385_prepare1 FROM l_sql  
      DECLARE almg385_curs1 CURSOR FOR almg385_prepare1 

      LET l_sql = "SELECT SUM(liw14) ",
                  "  FROM ",cl_get_target_table(l_plant,'liw_file'),
                  " WHERE liw01 = ? "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
      PREPARE almg385_prepare2 FROM l_sql  
      
      
      FOREACH almg385_curs1 INTO sr.* 
      
         EXECUTE almg385_prepare2 USING sr.lnt01
            INTO sr.l_sum_liw14
         
         EXECUTE insert_prep USING sr.*
      END FOREACH 
      
    END FOREACH
###GENGRE###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ljeplant,lmb02,lmc03,lmf01,lne01')
             RETURNING g_wc
        IF g_wc.getLength() > 1000 THEN
            LET g_wc = g_wc.subString(1,600)
            LET g_wc = g_wc,"..."
        END IF
    END IF
    LET g_template = 'almg385' 
    CALL almg385_grdata()    ###GENGRE###

END FUNCTION



FUNCTION almg385_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING
    
    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("almg385")
        IF handler IS NOT NULL THEN
            START REPORT almg385_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ljeplant,lnt08,lnt09,lnt06 "
            DECLARE almg385_datacur1 CURSOR FROM l_sql
            FOREACH almg385_datacur1 INTO sr1.*
                OUTPUT TO REPORT almg385_rep(sr1.*)
            END FOREACH
            FINISH REPORT almg385_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT almg385_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_liw09_sum    LIKE liw_file.liw09
    DEFINE l_liw10_sum    LIKE liw_file.liw10
    DEFINE l_liw14_sum    LIKE liw_file.liw14
    DEFINE l_lje11_sum    LIKE lje_file.lje11
    DEFINE l_lnt66_sum    LIKE lnt_file.lnt66
    DEFINE l_lje15_sum    LIKE lje_file.lje15
    DEFINE l_lje20_sum    LIKE lje_file.lje20
    DEFINE l_lje17_sum    LIKE lje_file.lje17
    DEFINE l_lje22_sum    LIKE lje_file.lje22
    DEFINE g_lla03        LIKE lla_file.lla03
    DEFINE g_lla04        LIKE lla_file.lla04
    DEFINE l_lje11_str    STRING 
    DEFINE l_lnt64_str    STRING 
    DEFINE l_lnt65_str    STRING 
    DEFINE l_lnt66_str    STRING 
    DEFINE l_lje15_str    STRING 
    DEFINE l_sum_liw14_str    STRING 
    DEFINE l_lje20_str    STRING 
    DEFINE l_lje17_str    STRING 
    DEFINE l_lje22_str    STRING 
    DEFINE l_liw09_sum_str    STRING
    DEFINE l_liw10_sum_str    STRING
    DEFINE l_liw14_sum_str    STRING
    DEFINE l_lje11_sum_str    STRING
    DEFINE l_lnt66_sum_str    STRING
    DEFINE l_lje15_sum_str    STRING
    DEFINE l_lje20_sum_str    STRING
    DEFINE l_lje17_sum_str    STRING
    DEFINE l_lje22_sum_str    STRING
    ORDER EXTERNAL BY sr1.ljeplant
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX tm.*
            PRINTX g_wc
        BEFORE GROUP OF sr1.ljeplant
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            SELECT lla03,lla04 INTO g_lla03,g_lla04 FROM lla_file
             WHERE llastore = sr1.ljeplant
            CASE g_lla03
               WHEN '0'   LET l_lje11_str = sr1.lje11 USING '--,---,---,---,---,--&'
                             
               WHEN '1'   LET l_lje11_str = sr1.lje11 USING '--,---,---,---,---,--&.&'
                          
               WHEN '2'   LET l_lje11_str = sr1.lje11 USING '--,---,---,---,---,--&.&&'
                           
               WHEN '3'   LET l_lje11_str = sr1.lje11 USING '--,---,---,---,---,--&.&&&'
                           
               WHEN '4'   LET l_lje11_str = sr1.lje11 USING '--,---,---,---,---,--&.&&&&'
                          
               WHEN '5'   LET l_lje11_str = sr1.lje11 USING '--,---,---,---,---,--&.&&&&&'
                        
               WHEN '6'   LET l_lje11_str = sr1.lje11 USING '--,---,---,---,---,--&.&&&&&&'
                             
            END CASE
            LET l_lje11_str = l_lje11_str.trim()    
            PRINTX l_lje11_str
            CASE g_lla04
               WHEN '0'  
                  LET l_lnt64_str = sr1.lnt64 USING '--,---,---,---,---,--&'
                  LET l_lnt65_str = sr1.lnt65 USING '--,---,---,---,---,--&'
                  LET l_lnt66_str = sr1.lnt66 USING '--,---,---,---,---,--&'
                  LET l_lje15_str = sr1.lje15 USING '--,---,---,---,---,--&'
                  LET l_sum_liw14_str = sr1.l_sum_liw14 USING '--,---,---,---,---,--&'
                  LET l_lje20_str = sr1.lje20 USING '--,---,---,---,---,--&'
                  LET l_lje17_str = sr1.lje17 USING '--,---,---,---,---,--&'
                  LET l_lje22_str = sr1.lje22 USING '--,---,---,---,---,--&'
               WHEN '1'  
                  LET l_lnt64_str = sr1.lnt64 USING '--,---,---,---,---,--&.&'
                  LET l_lnt65_str = sr1.lnt65 USING '--,---,---,---,---,--&.&'
                  LET l_lnt66_str = sr1.lnt66 USING '--,---,---,---,---,--&.&'
                  LET l_lje15_str = sr1.lje15 USING '--,---,---,---,---,--&.&'
                  LET l_sum_liw14_str = sr1.l_sum_liw14 USING '--,---,---,---,---,--&.&'
                  LET l_lje20_str = sr1.lje20 USING '--,---,---,---,---,--&.&'
                  LET l_lje17_str = sr1.lje17 USING '--,---,---,---,---,--&.&'
                  LET l_lje22_str = sr1.lje22 USING '--,---,---,---,---,--&.&'
               WHEN '2'  
                  LET l_lnt64_str = sr1.lnt64 USING '--,---,---,---,---,--&.&&'
                  LET l_lnt65_str = sr1.lnt65 USING '--,---,---,---,---,--&.&&'
                  LET l_lnt66_str = sr1.lnt66 USING '--,---,---,---,---,--&.&&'
                  LET l_lje15_str = sr1.lje15 USING '--,---,---,---,---,--&.&&'
                  LET l_sum_liw14_str = sr1.l_sum_liw14 USING '--,---,---,---,---,--&.&&'
                  LET l_lje20_str = sr1.lje20 USING '--,---,---,---,---,--&.&&'
                  LET l_lje17_str = sr1.lje17 USING '--,---,---,---,---,--&.&&'
                  LET l_lje22_str = sr1.lje22 USING '--,---,---,---,---,--&.&&'
               WHEN '3'  
                  LET l_lnt64_str = sr1.lnt64 USING '--,---,---,---,---,--&.&&&'
                  LET l_lnt65_str = sr1.lnt65 USING '--,---,---,---,---,--&.&&&'
                  LET l_lnt66_str = sr1.lnt66 USING '--,---,---,---,---,--&.&&&'
                  LET l_lje15_str = sr1.lje15 USING '--,---,---,---,---,--&.&&&'
                  LET l_sum_liw14_str = sr1.l_sum_liw14 USING '--,---,---,---,---,--&.&&&'
                  LET l_lje20_str = sr1.lje20 USING '--,---,---,---,---,--&.&&&'
                  LET l_lje17_str = sr1.lje17 USING '--,---,---,---,---,--&.&&&'
                  LET l_lje22_str = sr1.lje22 USING '--,---,---,---,---,--&.&&&'
               WHEN '4'  
                  LET l_lnt64_str = sr1.lnt64 USING '--,---,---,---,---,--&.&&&&'
                  LET l_lnt65_str = sr1.lnt65 USING '--,---,---,---,---,--&.&&&&'
                  LET l_lnt66_str = sr1.lnt66 USING '--,---,---,---,---,--&.&&&&'
                  LET l_lje15_str = sr1.lje15 USING '--,---,---,---,---,--&.&&&&'
                  LET l_sum_liw14_str = sr1.l_sum_liw14 USING '--,---,---,---,---,--&.&&&&'
                  LET l_lje20_str = sr1.lje20 USING '--,---,---,---,---,--&.&&&&'
                  LET l_lje17_str = sr1.lje17 USING '--,---,---,---,---,--&.&&&&'
                  LET l_lje22_str = sr1.lje22 USING '--,---,---,---,---,--&.&&&&'
               WHEN '5'  
                  LET l_lnt64_str = sr1.lnt64 USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lnt65_str = sr1.lnt65 USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lnt66_str = sr1.lnt66 USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lje15_str = sr1.lje15 USING '--,---,---,---,---,--&.&&&&&'
                  LET l_sum_liw14_str = sr1.l_sum_liw14 USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lje20_str = sr1.lje20 USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lje17_str = sr1.lje17 USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lje22_str = sr1.lje22 USING '--,---,---,---,---,--&.&&&&&'
               WHEN '6'  
                  LET l_lnt64_str = sr1.lnt64 USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lnt65_str = sr1.lnt65 USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lnt66_str = sr1.lnt66 USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lje15_str = sr1.lje15 USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_sum_liw14_str = sr1.l_sum_liw14 USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lje20_str = sr1.lje20 USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lje17_str = sr1.lje17 USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lje22_str = sr1.lje22 USING '--,---,---,---,---,--&.&&&&&&'
            END CASE 
            LET l_lnt64_str = l_lnt64_str.trim()
            LET l_lnt65_str = l_lnt65_str.trim() 
            LET l_lnt66_str = l_lnt66_str.trim()
            LET l_lje15_str = l_lje15_str.trim() 
            LET l_sum_liw14_str = l_sum_liw14_str.trim() 
            LET l_lje20_str = l_lje20_str.trim() 
            LET l_lje17_str = l_lje17_str.trim() 
            LET l_lje22_str = l_lje22_str.trim() 
                        
            PRINTX l_lnt64_str
            PRINTX l_lnt65_str
            PRINTX l_lnt66_str
            PRINTX l_lje15_str
            PRINTX l_sum_liw14_str
            PRINTX l_lje20_str
            PRINTX l_lje17_str
            PRINTX l_lje22_str                  
            PRINTX sr1.*
        AFTER GROUP OF sr1.ljeplant
              LET l_liw09_sum = GROUP SUM(sr1.lnt64)   
              LET l_liw10_sum = GROUP SUM(sr1.lnt65)  
              LET l_liw14_sum = GROUP SUM(sr1.l_sum_liw14)  
              LET l_lje11_sum = GROUP SUM(sr1.lje11)  
              LET l_lnt66_sum = GROUP SUM(sr1.lnt66)  
              LET l_lje15_sum = GROUP SUM(sr1.lje15)  
              LET l_lje20_sum = GROUP SUM(sr1.lje20)  
              LET l_lje17_sum = GROUP SUM(sr1.lje17)  
              LET l_lje22_sum = GROUP SUM(sr1.lje22)  
           CASE g_lla03
               WHEN '0'   LET l_lje11_sum_str = l_lje11_sum USING '--,---,---,---,---,--&'
                             
               WHEN '1'   LET l_lje11_sum_str = l_lje11_sum USING '--,---,---,---,---,--&.&'
                          
               WHEN '2'   LET l_lje11_sum_str = l_lje11_sum USING '--,---,---,---,---,--&.&&'
                           
               WHEN '3'   LET l_lje11_sum_str = l_lje11_sum USING '--,---,---,---,---,--&.&&&'
                           
               WHEN '4'   LET l_lje11_sum_str = l_lje11_sum USING '--,---,---,---,---,--&.&&&&'
                          
               WHEN '5'   LET l_lje11_sum_str = l_lje11_sum USING '--,---,---,---,---,--&.&&&&&'
                        
               WHEN '6'   LET l_lje11_sum_str = l_lje11_sum USING '--,---,---,---,---,--&.&&&&&&'
                             
            END CASE
            LET l_lje11_sum_str = l_lje11_sum_str.trim()    
            PRINTX l_lje11_sum_str  
            CASE g_lla04
               WHEN '0'  
                  LET l_liw09_sum_str = l_liw09_sum USING '--,---,---,---,---,--&'
                  LET l_liw10_sum_str = l_liw10_sum USING '--,---,---,---,---,--&'
                  LET l_lnt66_sum_str = l_lnt66_sum USING '--,---,---,---,---,--&'
                  LET l_lje15_sum_str = l_lje15_sum USING '--,---,---,---,---,--&'
                  LET l_liw14_sum_str = l_liw14_sum USING '--,---,---,---,---,--&'
                  LET l_lje20_sum_str = l_lje20_sum USING '--,---,---,---,---,--&'
                  LET l_lje17_sum_str = l_lje17_sum USING '--,---,---,---,---,--&'
                  LET l_lje22_sum_str = l_lje22_sum USING '--,---,---,---,---,--&'
               WHEN '1'  
                  LET l_liw09_sum_str = l_liw09_sum USING '--,---,---,---,---,--&.&'
                  LET l_liw10_sum_str = l_liw10_sum USING '--,---,---,---,---,--&.&'
                  LET l_lnt66_sum_str = l_lnt66_sum USING '--,---,---,---,---,--&.&'
                  LET l_lje15_sum_str = l_lje15_sum USING '--,---,---,---,---,--&.&'
                  LET l_liw14_sum_str = l_liw14_sum USING '--,---,---,---,---,--&.&'
                  LET l_lje20_sum_str = l_lje20_sum USING '--,---,---,---,---,--&.&'
                  LET l_lje17_sum_str = l_lje17_sum USING '--,---,---,---,---,--&.&'
                  LET l_lje22_sum_str = l_lje22_sum USING '--,---,---,---,---,--&.&'
               WHEN '2'  
                  LET l_liw09_sum_str = l_liw09_sum USING '--,---,---,---,---,--&.&&'
                  LET l_liw10_sum_str = l_liw10_sum USING '--,---,---,---,---,--&.&&'
                  LET l_lnt66_sum_str = l_lnt66_sum USING '--,---,---,---,---,--&.&&'
                  LET l_lje15_sum_str = l_lje15_sum USING '--,---,---,---,---,--&.&&'
                  LET l_liw14_sum_str = l_liw14_sum USING '--,---,---,---,---,--&.&&'
                  LET l_lje20_sum_str = l_lje20_sum USING '--,---,---,---,---,--&.&&'
                  LET l_lje17_sum_str = l_lje17_sum USING '--,---,---,---,---,--&.&&'
                  LET l_lje22_sum_str = l_lje22_sum USING '--,---,---,---,---,--&.&&'
               WHEN '3'  
                  LET l_liw09_sum_str = l_liw09_sum USING '--,---,---,---,---,--&.&&&'
                  LET l_liw10_sum_str = l_liw10_sum USING '--,---,---,---,---,--&.&&&'
                  LET l_lnt66_sum_str = l_lnt66_sum USING '--,---,---,---,---,--&.&&&'
                  LET l_lje15_sum_str = l_lje15_sum USING '--,---,---,---,---,--&.&&&'
                  LET l_liw14_sum_str = l_liw14_sum USING '--,---,---,---,---,--&.&&&'
                  LET l_lje20_sum_str = l_lje20_sum USING '--,---,---,---,---,--&.&&&'
                  LET l_lje17_sum_str = l_lje17_sum USING '--,---,---,---,---,--&.&&&'
                  LET l_lje22_sum_str = l_lje22_sum USING '--,---,---,---,---,--&.&&&'
               WHEN '4'  
                  LET l_liw09_sum_str = l_liw09_sum USING '--,---,---,---,---,--&.&&&&'
                  LET l_liw10_sum_str = l_liw10_sum USING '--,---,---,---,---,--&.&&&&'
                  LET l_lnt66_sum_str = l_lnt66_sum USING '--,---,---,---,---,--&.&&&&'
                  LET l_lje15_sum_str = l_lje15_sum USING '--,---,---,---,---,--&.&&&&'
                  LET l_liw14_sum_str = l_liw14_sum USING '--,---,---,---,---,--&.&&&&'
                  LET l_lje20_sum_str = l_lje20_sum USING '--,---,---,---,---,--&.&&&&'
                  LET l_lje17_sum_str = l_lje17_sum USING '--,---,---,---,---,--&.&&&&'
                  LET l_lje22_sum_str = l_lje22_sum USING '--,---,---,---,---,--&.&&&&'
               WHEN '5'  
                  LET l_liw09_sum_str = l_liw09_sum USING '--,---,---,---,---,--&.&&&&&'
                  LET l_liw10_sum_str = l_liw10_sum USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lnt66_sum_str = l_lnt66_sum USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lje15_sum_str = l_lje15_sum USING '--,---,---,---,---,--&.&&&&&'
                  LET l_liw14_sum_str = l_liw14_sum USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lje20_sum_str = l_lje20_sum USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lje17_sum_str = l_lje17_sum USING '--,---,---,---,---,--&.&&&&&'
                  LET l_lje22_sum_str = l_lje22_sum USING '--,---,---,---,---,--&.&&&&&'
               WHEN '6'  
                  LET l_liw09_sum_str = l_liw09_sum USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_liw10_sum_str = l_liw10_sum USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lnt66_sum_str = l_lnt66_sum USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lje15_sum_str = l_lje15_sum USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_liw14_sum_str = l_liw14_sum USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lje20_sum_str = l_lje20_sum USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lje17_sum_str = l_lje17_sum USING '--,---,---,---,---,--&.&&&&&&'
                  LET l_lje22_sum_str = l_lje22_sum USING '--,---,---,---,---,--&.&&&&&&'
            END CASE 
            LET l_liw09_sum_str = l_liw09_sum_str.trim()
            LET l_liw10_sum_str = l_liw10_sum_str.trim() 
            LET l_lnt66_sum_str = l_lnt66_sum_str.trim()
            LET l_lje15_sum_str = l_lje15_sum_str.trim() 
            LET l_liw14_sum_str = l_liw14_sum_str.trim() 
            LET l_lje20_sum_str = l_lje20_sum_str.trim() 
            LET l_lje17_sum_str = l_lje17_sum_str.trim() 
            LET l_lje22_sum_str = l_lje22_sum_str.trim()             
            PRINTX l_liw09_sum_str
            PRINTX l_liw10_sum_str
            PRINTX l_lnt66_sum_str
            PRINTX l_lje15_sum_str
            PRINTX l_liw14_sum_str
            PRINTX l_lje20_sum_str
            PRINTX l_lje17_sum_str
            PRINTX l_lje22_sum_str   
        ON LAST ROW

END REPORT
#FUN-C60062 END
