# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg806.4gl
# Descriptions...: 競爭對手銷售比較表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B50163 11/06/01 by huangtao

# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-C40071 12/04/23 By nanbing CR轉換成GRW
# Modify.........: NO.FUN-CB0058 12/11/22 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           azw01     STRING,
           lse01     STRING,
           bdate     LIKE type_file.dat,
           edate     LIKE type_file.dat,
           type1     LIKE type_file.chr3,
           cb        LIKE type_file.chr1, 
           more      LIKE type_file.chr1    
           END RECORD
DEFINE g_wc          STRING 
DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE g_chk_azw01   LIKE type_file.chr1
DEFINE g_chk_auth    STRING  
DEFINE g_azw01       LIKE azw_file.azw01 
DEFINE g_azw01_str   STRING 
DEFINE g_chk_lse01   STRING 
DEFINE g_lse01        LIKE lse_file.lse01



###GENGRE###START
TYPE sr1_t RECORD
    azw01 LIKE azw_file.azw01,
    azw08 LIKE azw_file.azw08,
    rcf02 LIKE rcf_file.rcf02,
    lse01 LIKE lse_file.lse01,
    lse02 LIKE lse_file.lse02,
    rcg04 LIKE rcg_file.rcg04,
    rce05 LIKE rce_file.rce05,
    rce05_sum LIKE type_file.num20_6
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
   LET tm.azw01 = ARG_VAL(7)
   LET tm.lse01 = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.type1 = ARG_VAL(11)
   LET tm.cb  = ARG_VAL(12) 
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql=  "azw01.azw_file.azw01,",
               "azw08.azw_file.azw08,",
               "rcf02.rcf_file.rcf02,",
               "lse01.lse_file.lse01,",
               "lse02.lse_file.lse02,",
               "rcg04.rcg_file.rcg04,",
               "rce05.rce_file.rce05,",
               "rce05_sum.type_file.num20_6"
    LET l_table = cl_prt_temptable('artg806',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artg806_tm()        
    ELSE 
       CALL artg806() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artg806_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          STRING,   
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE  l_n1          LIKE type_file.num5
DEFINE l_sql          STRING
DEFINE l_days         LIKE type_file.num5


   LET p_row = 6 LET p_col = 16
   OPEN WINDOW artg806_w AT p_row,p_col WITH FORM "art/42f/artg806" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_days = cl_days(YEAR(g_today),MONTH(g_today))
   LET tm.bdate = MDY(MONTH(g_today),1,YEAR(g_today))
   LET tm.edate = MDY(MONTH(g_today),l_days,YEAR(g_today)) 
   LET tm.type1='N'
   LET tm.cb = 'N' 
   WHILE TRUE
      INPUT BY NAME  tm.azw01,tm.lse01,tm.bdate,tm.edate,tm.type1,tm.cb,tm.more WITHOUT DEFAULTS 
         BEFORE INPUT 
           CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD azw01
            LET g_chk_azw01 = TRUE 
            LET g_azw01_str = tm.azw01 
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
                   SELECT COUNT(*) INTO l_n1 FROM zxy_file
                    WHERE zxy01 = g_user
                      AND zxy03 = g_azw01
                      IF l_n > 0 AND l_n1 > 0 THEN
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
            IF g_chk_azw01 THEN
               LET g_chk_auth = g_auth     
            END IF
            
        AFTER FIELD lse01
            LET g_chk_lse01 = ''
            IF NOT cl_null(tm.lse01) AND tm.lse01 <> "*" THEN
               LET tok = base.StringTokenizer.create(tm.lse01,"|") 
               LET g_lse01 = ""
               WHILE tok.hasMoreTokens() 
                   LET g_lse01 = tok.nextToken()
                   IF g_chk_lse01 IS NULL THEN
                      LET g_chk_lse01 = "'",g_lse01,"'"
                   ELSE
                      LET g_chk_lse01 = g_chk_lse01,",'",g_lse01,"'"
                   END IF 
               END WHILE
               IF g_chk_lse01 IS NOT NULL THEN
                  LET g_chk_lse01 = "(",g_chk_lse01,")"
               END IF
            END IF
            IF tm.lse01 = "*" THEN
               DECLARE r806_lse_cs1 CURSOR FOR SELECT lse01 FROM lse_file WHERE lse04 = 'Y'
               FOREACH r806_lse_cs1 INTO g_lse01 
                 IF g_chk_lse01 IS NULL THEN
                    LET g_chk_lse01 = "'",g_lse01,"'"
                 ELSE
                    LET g_chk_lse01 = g_chk_lse01,",'",g_lse01,"'"
                 END IF
               END FOREACH
               IF g_chk_lse01 IS NOT NULL THEN
                  LET g_chk_lse01 = "(",g_chk_lse01,")"
               END IF   
            END IF

         ON ACTION controlp
            CASE
               WHEN INFIELD(azw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zxy01"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azp01 IN ",g_auth
                  LET g_qryparam.arg1 = g_user
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tm.azw01 = g_qryparam.multiret
                  DISPLAY tm.azw01 TO azw01
                  NEXT FIELD azw01
               WHEN INFIELD(lse01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lse01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tm.lse01 = g_qryparam.multiret
                  DISPLAY tm.lse01 TO lse01
                  NEXT FIELD lse01 
            END CASE
            
         ON ACTION CONTROLR
             CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT INPUT
         ON ACTION about        
            CALL cl_about()     
 
         ON ACTION help         
            CALL cl_show_help()  
        
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artg806_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg806'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('artg806','9031',1)
         ELSE
            LET l_cmd = l_cmd1 CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.azw01 CLIPPED,"'",
                       " '",tm.lse01 CLIPPED,"'",
                       " '",tm.bdate CLIPPED,"'",
                       " '",tm.edate CLIPPED,"'",
                       " '",tm.type1 CLIPPED,"'",
                       " '",tm.cb CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg806',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg806_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg806()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg806_w
    
END FUNCTION


FUNCTION artg806() 
DEFINE    l_name    LIKE type_file.chr20,                
          l_sql     STRING ,                      
          sr        RECORD 
                    rcf02   LIKE rcf_file.rcf02,
                    rcg03   LIKE rcg_file.rcg03,
                    rcg04   LIKE rcg_file.rcg04
                    END RECORD
DEFINE l_plant      LIKE azw_file.azw01
DEFINE l_azw08      LIKE azw_file.azw08
DEFINE l_lse01      LIKE lse_file.lse01
DEFINE l_lse02      LIKE lse_file.lse02
DEFINE l_rce05      LIKE rce_file.rce05
DEFINE l_rce05_sum  LIKE type_file.num20_6
DEFINE l_azi04      LIKE azi_file.azi04
  
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--
       EXIT PROGRAM
    END IF   
    INITIALIZE sr.* TO NULL
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
    CALL cl_del_data(l_table)
    LET l_sql = " SELECT DISTINCT azw01,azw08 FROM azw_file ",
                " WHERE azw01 IN ",g_chk_auth
    LET l_sql = l_sql," ORDER BY azw01 "
    PREPARE sel_azw01_pre FROM l_sql
    DECLARE sel_azw01_cs CURSOR FOR sel_azw01_pre           
    FOREACH sel_azw01_cs INTO l_plant,l_azw08
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      LET l_sql = " SELECT rcf02,rcg03,rcg04 FROM ",cl_get_target_table(l_plant,'rcf_file'),",",
                                                    cl_get_target_table(l_plant,'rcg_file'),
                  " WHERE rcf01 = rcg01 ",
                  " AND rcfplant = '",l_plant,"'",
                  " AND rcf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
      IF NOT cl_null(tm.lse01) THEN
         LET l_sql = l_sql," AND rcg03 IN ",g_chk_lse01
      END IF
      CASE 
         WHEN tm.type1='Y'
            LET l_sql = l_sql," AND rcfconf = 'Y' "
         WHEN tm.type1='N'
            LET l_sql = l_sql," AND rcfconf = 'N' "
         WHEN tm.type1='ALL'
            LET l_sql = l_sql," AND rcfconf <> 'X' "
      END CASE
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
      PREPARE artg806_prepare1 FROM l_sql  
      DECLARE artg806_curs1 CURSOR FOR artg806_prepare1 
      FOREACH artg806_curs1 INTO sr.* 
         LET l_sql = " SELECT lse02 FROM ",cl_get_target_table(l_plant,'lse_file'),
                     " WHERE lse01 = '",sr.rcg03,"'",
                     " AND lse04 = 'Y' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
         PREPARE sel_lse02_pre FROM l_sql
         EXECUTE sel_lse02_pre INTO l_lse02

         LET l_sql = " SELECT SUM(rce05) FROM ",cl_get_target_table(l_plant,'rcd_file'),",",
                                                cl_get_target_table(l_plant,'rce_file'),
                     " WHERE rcd01 = rce01 ",
                     " AND rcd02 = '",sr.rcf02,"'",
                     " AND rcdplant = '",l_plant,"'"
         CASE 
            WHEN tm.type1='Y'
                LET l_sql = l_sql," AND rcdconf = 'Y' "
            WHEN tm.type1='N'
                LET l_sql = l_sql," AND rcdconf = 'N' "
            WHEN tm.type1='ALL'
                LET l_sql = l_sql," AND rcdconf <> 'X' "
         END CASE
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_rce05_pre1 FROM l_sql
         EXECUTE sel_rce05_pre1 INTO l_rce05  
         IF cl_null(l_rce05) THEN
            LET l_rce05 = 0 
         END IF
         LET l_sql = " SELECT SUM(rce05) FROM ",cl_get_target_table(l_plant,'rcd_file'),",",
                                                cl_get_target_table(l_plant,'rce_file'),
                     " WHERE rcd01 = rce01 ",
                     " AND rcd02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                     " AND rcdplant = '",l_plant,"'"
         CASE 
            WHEN tm.type1='Y'
                LET l_sql = l_sql," AND rcdconf = 'Y' "
            WHEN tm.type1='N'
                LET l_sql = l_sql," AND rcdconf = 'N' "
            WHEN tm.type1='ALL'
                LET l_sql = l_sql," AND rcdconf <> 'X' "
         END CASE
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_rce05_pre2 FROM l_sql
         EXECUTE sel_rce05_pre2 INTO l_rce05_sum  
         IF cl_null(l_rce05_sum) THEN
            LET l_rce05_sum = 0 
         END IF
         EXECUTE insert_prep USING l_plant,l_azw08,sr.rcf02,sr.rcg03,l_lse02,sr.rcg04,l_rce05,l_rce05_sum
      END FOREACH 
      
    END FOREACH
    LET g_str = ''
    LET g_wc = " azw01 in ",g_chk_auth
    IF NOT cl_null(tm.lse01) THEN
       LET g_wc = g_wc," and lse01 in ",g_chk_lse01
    END IF
###GENGRE###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'azw01,lse01')
             RETURNING g_wc
        LET g_str = g_wc
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
###GENGRE###   LET g_str = g_str,";",tm.bdate,";",tm.edate,';',tm.type1,";",tm.cb,";",l_azi04
   #FUN-C40071 sta
   IF NOT cl_null(g_str) THEN
      LET g_str = g_str,";",tm.bdate,";",tm.edate,';',tm.type1,";",tm.cb,";",l_azi04
   ELSE
      LET g_Str = g_wc,";",tm.bdate,";",tm.edate,';',tm.type1,";",tm.cb,";",l_azi04
   END IF 
   #FUN-C40071 end  
   IF tm.cb = 'N' THEN 
###GENGRE###      CALL cl_prt_cs3('artg806','artg806_1',l_sql,g_str)  
   LET g_template = 'artg806_1' #FUN-C40071 
   CALL artg806_1_grdata()    ###GENGRE###
   ELSE
###GENGRE###      CALL cl_prt_cs3('artg806','artg806_2',l_sql,g_str)  
   LET g_template = 'artg806_2' #FUN-C40071
   CALL artg806_2_grdata()    ###GENGRE###
   END IF

END FUNCTION
#FUN-B50163

###GENGRE###START#FUN-C40071
FUNCTION artg806_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg806")
        IF handler IS NOT NULL THEN
            START REPORT artg806_rep1 TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY azw01,lse01 "  #FUN-C40071
            DECLARE artg806_datacur1 CURSOR FROM l_sql
            FOREACH artg806_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg806_rep1(sr1.*)
            END FOREACH
            FINISH REPORT artg806_rep1
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg806_rep1(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_rcg04_sum LIKE type_file.num10 #FUN-C40071 add
    DEFINE l_display  STRING #FUN-C40071 add
    DEFINE l_display1 STRING #FUN-C40071 add
    DEFINE l_display2 STRING #FUN-C40071 add
    DEFINE l_display3 STRING #FUN-C40071 add
    DEFINE sr1_o      sr1_t  #FUN-C40071 add  
    DEFINE l_azw01      LIKE azw_file.azw01       #FUN-CB0058
    DEFINE l_azw08      LIKE azw_file.azw08       #FUN-CB0058
    DEFINE l_lse01      LIKE lse_file.lse01       #FUN-CB0058
    DEFINE l_lse02      LIKE lse_file.lse02       #FUN-CB0058
    DEFINE l_rce05_sum  LIKE type_file.num20_6    #FUN-CB0058

    ORDER EXTERNAL BY sr1.azw01,sr1.lse01 #FUN-C40071
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-C40071
            PRINTX tm.*
            #FUN-C40071 sta
            PRINTX g_str 
            LET sr1_o.azw01 = NULL
            LET sr1_o.azw08 = NULL
            LET sr1_o.rce05_sum = NULL 
            #FUN-C40071 end   
        BEFORE GROUP OF sr1.azw01  
        BEFORE GROUP OF sr1.lse01


        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-C40071 sta
            IF NOT cl_null(sr1_o.azw01) THEN
               IF sr1_o.azw01 != sr1.azw01  THEN
                  LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01    #FUN-CB0058
               ELSE
                  LET l_display = 'N'
                  LET l_azw01 = "  "         #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_azw01 = sr1.azw01    #FUN-CB0058
            END IF
            PRINTX l_display

            IF NOT cl_null(sr1_o.azw08) THEN
               IF sr1_o.azw08 != sr1.azw08  THEN
                  LET l_display1 = 'Y'
                  LET l_azw08 = sr1.azw08    #FUN-CB0058
               ELSE
                  LET l_display1 = 'N'
                  LET l_azw08 = "  "         #FUN-CB0058
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azw08 = sr1.azw08    #FUN-CB0058
            END IF
            PRINTX l_display1
            IF l_display = 'Y' THEN
               LET l_display2 = 'Y'
               LET l_rce05_sum = sr1.rce05_sum    #FUN-CB0058
            ELSE
               IF NOT cl_null(sr1_o.rce05_sum) THEN
                  IF sr1_o.rce05_sum != sr1.rce05_sum  THEN
                     LET l_display2 = 'Y'
                     LET l_rce05_sum = sr1.rce05_sum    #FUN-CB0058
                  ELSE
                     LET l_display2 = 'N'
                     LET l_rce05_sum = 0                #FUN-CB0058
                  END IF
               ELSE
                  LET l_display2 = 'Y'
                  LET l_rce05_sum = sr1.rce05_sum    #FUN-CB0058
               END IF
            END IF    
            PRINTX l_display2
            IF l_display = 'Y' THEN
               LET l_display3 = 'Y'
               LET l_lse01 = sr1.lse01    #FUN-CB0058
               LET l_lse02 = sr1.lse02    #FUN-CB0058
            ELSE
               IF NOT cl_null(sr1_o.lse01) THEN
                  IF sr1_o.lse01 != sr1.lse01  THEN
                     LET l_display3 = 'Y'
		     LET l_lse01 = sr1.lse01    #FUN-CB0058
		     LET l_lse02 = sr1.lse02    #FUN-CB0058
                  ELSE
                     LET l_display3 = 'N'
                     LET l_lse01 = "  "         #FUN-CB0058
                     LET l_lse02 = "  "         #FUN-CB0058
                  END IF
               ELSE
                  LET l_display3 = 'Y'
                  LET l_lse01 = sr1.lse01    #FUN-CB0058
                  LET l_lse02 = sr1.lse02    #FUN-CB0058
               END IF
            END IF    
            PRINTX l_display3
            PRINTX l_azw01         #FUN-CB0058
            PRINTX l_azw08         #FUN-CB0058
            PRINTX l_rce05_sum     #FUN-CB0058
            PRINTX l_lse01         #FUN-CB0058
            PRINTX l_lse02         #FUN-CB0058
            LET sr1_o.* = sr1.*
            #FUN-C40071 end
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01 
        AFTER GROUP OF sr1.lse01
           LET l_rcg04_sum = GROUP SUM(sr1.rcg04)  #FUN-C40071
           PRINTX l_rcg04_sum   #FUN-C40071
        
        ON LAST ROW

END REPORT
#FUN-C40071 END
###GENGRE###START
FUNCTION artg806_2_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg806")
        IF handler IS NOT NULL THEN
            START REPORT artg806_rep2 TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY azw01,rcf02,lse01 " #FUN-C40071
            DECLARE artg806_datacur2 CURSOR FROM l_sql
            FOREACH artg806_datacur2 INTO sr1.*
                OUTPUT TO REPORT artg806_rep2(sr1.*)
            END FOREACH
            FINISH REPORT artg806_rep2
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg806_rep2(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_rcg04_sum LIKE type_file.num10 #FUN-C40071 add
    DEFINE l_display4  STRING #FUN-C40071 add
    DEFINE l_display5 STRING #FUN-C40071 add
    DEFINE l_display6 STRING #FUN-C40071 add
    DEFINE sr1_o      sr1_t  #FUN-C40071 add      
    DEFINE l_azw01      LIKE azw_file.azw01       #FUN-CB0058
    DEFINE l_azw08      LIKE azw_file.azw08       #FUN-CB0058
    DEFINE l_lse01      LIKE lse_file.lse01       #FUN-CB0058
    DEFINE l_lse02      LIKE lse_file.lse02       #FUN-CB0058
    DEFINE l_rcf02      LIKE rcf_file.rcf02       #FUN-CB0058
    DEFINE l_rce05      LIKE rce_file.rce05       #FUN-CB0058

    ORDER EXTERNAL BY sr1.azw01,sr1.rcf02,sr1.lse01 #FUN-C40071
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-C40071
            PRINTX tm.*
            #FUN-C40071 sta
            PRINTX g_str #FUN-C40071 
            LET sr1_o.azw01 = NULL
            LET sr1_o.azw08 = NULL
            LET sr1_o.rcf02 = NULL 
            LET sr1_o.rce05 = NULL 
            #FUN-C40071 end    
        BEFORE GROUP OF sr1.azw01

        BEFORE GROUP OF sr1.rcf02    #FUN-C40071
 
        BEFORE GROUP OF sr1.lse01


        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-C40071 sta 
                     
           IF NOT cl_null(sr1_o.azw01) THEN
              IF sr1_o.azw01 != sr1.azw01  THEN
                 LET l_display4 = 'Y'
                 LET l_azw01 = sr1.azw01      #FUN-CB0058
                 LET l_azw08 = sr1.azw08      #FUN-CB0058
              ELSE
                 LET l_display4 = 'N'
                 LET l_azw01 = "   "          #FUN-CB0058
                 LET l_azw08 = "   "          #FUN-CB0058
              END IF
           ELSE
              LET l_display4 = 'Y'
              LET l_azw01 = sr1.azw01      #FUN-CB0058
              LET l_azw08 = sr1.azw08      #FUN-CB0058
           END IF
           PRINTX l_display4
           IF l_display4 = 'Y' THEN 
              LET l_display5 = 'Y' 
              LET l_rcf02 = sr1.rcf02      #FUN-CB0058
              LET l_rce05 = sr1.rce05      #FUN-CB0058
           ELSE
              IF cl_null(sr1_o.rcf02) THEN 
                 LET l_display5= 'Y'
                 LET l_rcf02 = sr1.rcf02      #FUN-CB0058
                 LET l_rce05 = sr1.rce05      #FUN-CB0058
              ELSE
                 IF sr1_o.rcf02 != sr1.rcf02 THEN
                    LET l_display5 = 'Y'
                    LET l_rcf02 = sr1.rcf02      #FUN-CB0058
                    LET l_rce05 = sr1.rce05      #FUN-CB0058
                 ELSE
                    LET l_display5 = 'N'
                    LET l_rcf02 = "   "          #FUN-CB0058
                    LET l_rce05 = 0              #FUN-CB0058
                 END IF 
              END IF  
           END IF   
           PRINTX l_display5 
           IF l_display4 = 'Y' OR l_display5 = 'Y' THEN
               LET l_display6 = 'Y'
               LET l_lse01 = sr1.lse01        #FUN-CB0058
               LET l_lse02 = sr1.lse02        #FUN-CB0058
            ELSE
               IF NOT cl_null(sr1_o.lse01) THEN
                  IF sr1_o.lse01 != sr1.lse01  THEN
                     LET l_display6 = 'Y'
                     LET l_lse01 = sr1.lse01        #FUN-CB0058
                     LET l_lse02 = sr1.lse02        #FUN-CB0058
                  ELSE
                     LET l_display6 = 'N'
                     LET l_lse01 = "  "             #FUN-CB0058
                     LET l_lse02 = "   "            #FUN-CB0058
                  END IF
               ELSE
                  LET l_display6 = 'Y'
                  LET l_lse01 = sr1.lse01        #FUN-CB0058
                  LET l_lse02 = sr1.lse02        #FUN-CB0058
               END IF
            END IF    
            PRINTX l_display6
            PRINTX l_azw01         #FUN-CB0058
            PRINTX l_azw08         #FUN-CB0058
            PRINTX l_rcf02         #FUN-CB0058
            PRINTX l_rce05         #FUN-CB0058
            PRINTX l_lse01         #FUN-CB0058
            PRINTX l_lse02         #FUN-CB0058
            LET sr1_o.* = sr1.*
            #FUN-C40071 end
            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
        AFTER GROUP OF sr1.rcf02 #FUN-C40071 
        AFTER GROUP OF sr1.lse01
           LET l_rcg04_sum = GROUP SUM(sr1.rcg04)  #FUN-C40071
           PRINTX l_rcg04_sum   #FUN-C40071
        
        ON LAST ROW

END REPORT          
