# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: artr141.4gl
# Descriptions...: 銷售預測目標與實際比較表 
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B50068 11/05/16 by huangtao
# Modify.........: No.FUN-B50163 11/06/02 By huangtao  切換語言別
# Modify.........: No:TQC-B70078 11/07/11 by pauline 修改銷售金額選取條件  
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No:TQC-B80072 11/08/05 By baogc 抓取銷售金額時應扣除銷退金額

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           azw01     STRING,
           rtz10     STRING,
           yy        LIKE type_file.num5,
           mm        LIKE type_file.num5,
           cb        LIKE type_file.chr1, 
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD
DEFINE g_wc          STRING 
DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE g_chk_azw01   LIKE type_file.chr1
DEFINE g_chk_auth    STRING  
DEFINE g_azw01       LIKE azw_file.azw01 
DEFINE g_azw01_str   STRING 
DEFINE g_chk_rtz10   STRING 
DEFINE g_rtz10        LIKE rtz_file.rtz10
DEFINE g_days1        LIKE type_file.num5
DEFINE g_bdate1       LIKE type_file.dat
DEFINE g_edate1       LIKE type_file.dat
DEFINE g_days2        LIKE type_file.num5
DEFINE g_bdate2       LIKE type_file.dat
DEFINE g_edate2       LIKE type_file.dat

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
   LET tm.rtz10 = ARG_VAL(8)
   LET tm.yy = ARG_VAL(9)
   LET tm.mm = ARG_VAL(10)
   LET tm.cb  = ARG_VAL(11) 
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql=  "rtz10.rtz_file.rtz10,",
               "ryf02.ryf_file.ryf02,",
               "azw01.azw_file.azw01,",
               "azw08.azw_file.azw08,",
               "oga02.oga_file.oga02,",
               "cost1.type_file.num20_6,",
               "rwt201.rwt_file.rwt201,",
               "rwt202.rwt_file.rwt202,",
               "rwt203.rwt_file.rwt203,",
               "rwt204.rwt_file.rwt204,", #
               "rwt205.rwt_file.rwt205,",
               "rwt206.rwt_file.rwt206,",
               "rwt207.rwt_file.rwt207,",
               "rwt208.rwt_file.rwt208,",
               "rwt209.rwt_file.rwt209,",
               "rwt210.rwt_file.rwt210,",
               "rwt211.rwt_file.rwt211,",
               "rwt212.rwt_file.rwt212,",
               "cost2.type_file.num20_6,", 
               "cost_sum1.type_file.num20_6,", #
               "cost_sum2.type_file.num20_6"
               
    LET l_table = cl_prt_temptable('artr141',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF         

    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artr141_tm()        # Input print condition
    ELSE 
       CALL artr141() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artr141_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          STRING,   
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE  l_n1           LIKE type_file.num5
DEFINE l_sql          STRING


   LET p_row = 6 LET p_col = 16
   OPEN WINDOW artr141_w AT p_row,p_col WITH FORM "art/42f/artr141" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today) 
   LET tm.cb = '1' 
   WHILE TRUE
      INPUT BY NAME  tm.azw01,tm.rtz10,tm.yy,tm.mm,tm.cb,tm.more WITHOUT DEFAULTS 
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
            
        AFTER FIELD rtz10
            LET g_chk_rtz10 = ''
            IF NOT cl_null(tm.rtz10) AND tm.rtz10 <> "*" THEN
               LET tok = base.StringTokenizer.create(tm.rtz10,"|") 
               LET g_rtz10 = ""
               WHILE tok.hasMoreTokens() 
                   LET g_rtz10 = tok.nextToken()
                   IF g_chk_rtz10 IS NULL THEN
                      LET g_chk_rtz10 = "'",g_rtz10,"'"
                   ELSE
                      LET g_chk_rtz10 = g_chk_rtz10,",'",g_rtz10,"'"
                   END IF 
               END WHILE
               IF g_chk_rtz10 IS NOT NULL THEN
                  LET g_chk_rtz10 = "(",g_chk_rtz10,")"
               END IF
            END IF
            IF tm.rtz10 = "*" THEN
               DECLARE r141_ryf_cs1 CURSOR FOR SELECT ryf01 FROM ryf_file WHERE ryfacti = 'Y'
               FOREACH r141_ryf_cs1 INTO g_rtz10 
                 IF g_chk_rtz10 IS NULL THEN
                    LET g_chk_rtz10 = "'",g_rtz10,"'"
                 ELSE
                    LET g_chk_rtz10 = g_chk_rtz10,",'",g_rtz10,"'"
                 END IF
               END FOREACH
               IF g_chk_rtz10 IS NOT NULL THEN
                  LET g_chk_rtz10 = "(",g_chk_rtz10,")"
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
               WHEN INFIELD(rtz10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ryf"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tm.rtz10 = g_qryparam.multiret
                  DISPLAY tm.rtz10 TO rtz10
                  NEXT FIELD rtz10 
            END CASE
            
         ON ACTION CONTROLR
             CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

#FUN-B50163 -------------STA
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT INPUT
#FUN-B50163 -------------END         
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
         LET INT_FLAG = 0 CLOSE WINDOW artr141_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 

#FUN-B50163 -------------STA
     IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
#FUN-B50163 -------------END
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr141'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('artr141','9031',1)
         ELSE
            LET l_cmd = l_cmd1 CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.azw01 CLIPPED,"'",
                       " '",tm.rtz10 CLIPPED,"'",
                       " '",tm.yy CLIPPED,"'" ,
                       " '",tm.mm CLIPPED,"'" ,
                       " '",tm.cb CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr141',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr141_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr141()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr141_w
    
END FUNCTION


FUNCTION artr141() 
DEFINE    l_name    LIKE type_file.chr20,                
          l_sql     STRING ,                      
          sr        RECORD
                    oga01 LIKE oga_file.oga01,    #TQC-B70078
                    oga02 LIKE oga_file.oga02,
                    ogb03 LIKE oga_file.oga03,    #TQC-B70078
                    cost LIKE type_file.num20_6
                    END RECORD,
          sr1        RECORD 
                    rwt201 LIKE rwt_file.rwt201,
                    rwt202 LIKE rwt_file.rwt202,
                    rwt203 LIKE rwt_file.rwt203,
                    rwt204 LIKE rwt_file.rwt204,
                    rwt205 LIKE rwt_file.rwt205,
                    rwt206 LIKE rwt_file.rwt206,
                    rwt207 LIKE rwt_file.rwt207,
                    rwt208 LIKE rwt_file.rwt208,
                    rwt209 LIKE rwt_file.rwt209,
                    rwt210 LIKE rwt_file.rwt210,
                    rwt211 LIKE rwt_file.rwt211,
                    rwt212 LIKE rwt_file.rwt212
                    END RECORD
DEFINE l_plant      LIKE azw_file.azw01
DEFINE l_azw08      LIKE azw_file.azw08
DEFINE l_rtz10      LIKE rtz_file.rtz10
DEFINE l_ryf02      LIKE ryf_file.ryf02
DEFINE l_oga02      LIKE oga_file.oga02
DEFINE l_cost1       LIKE type_file.num20_6
DEFINE l_cost2       LIKE type_file.num20_6
DEFINE l_cost_sum1   LIKE type_file.num20_6
DEFINE l_cost_sum2   LIKE type_file.num20_6

    DROP TABLE artr141_tmp1
    CREATE TEMP TABLE artr141_tmp1(
                    azw01 LIKE azw_file.azw01,
                    oga02 LIKE oga_file.oga02,
                    cost LIKE type_file.num20_6)
    DELETE FROM artr141_tmp1
  
  
    INITIALIZE sr.* TO NULL
    INITIALIZE sr1.* TO NULL
    LET g_days1 = cl_days(tm.yy,tm.mm)
    LET g_days2 = cl_days(tm.yy-1,tm.mm)
    LET g_bdate1 = MDY(tm.mm,1,tm.yy)
    LET g_edate1 = MDY(tm.mm,g_days1,tm.yy) 
    LET g_bdate2 = MDY(tm.mm,1,tm.yy-1)
    LET g_edate2 = MDY(tm.mm,g_days2,tm.yy-1) 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    CALL cl_del_data(l_table)
    LET l_sql = " SELECT DISTINCT azw01,azw08,rtz10 FROM azw_file,rtz_file ",
                " WHERE azw01 = rtz01  ",
                " AND azw01 IN ",g_chk_auth
    IF NOT cl_null(tm.rtz10) THEN
       LET l_sql = l_sql," AND rtz10 IN ",g_chk_rtz10
    END IF
    LET l_sql = l_sql," ORDER BY rtz10,azw01 "
    PREPARE sel_azw01_pre FROM l_sql
    DECLARE sel_azw01_cs CURSOR FOR sel_azw01_pre           
    FOREACH sel_azw01_cs INTO l_plant,l_azw08,l_rtz10
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      #LET l_sql = "SELECT oga02,ogb14t",   #TQC-B70078
      LET l_sql = "SELECT oga01,oga02,ogb03,ogb14t",
                  " FROM ",cl_get_target_table(l_plant,'ogb_file'),
                  " ,",cl_get_target_table(l_plant,'oga_file'),
                  " WHERE oga01=ogb01",
                  " AND oga09 IN ('2','3','4','6')",       #TQC-B70078
                  " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
                 #" AND ogb14 > 0 ",   #TQC-B80072
                  " AND oga02 BETWEEN '",g_bdate1,"' AND '",g_edate1,"'"                   
      #LET l_sql= l_sql," UNION SELECT oha02,ohb14t*(-1)",   #TQC-B70078
#     LET l_sql= l_sql," UNION SELECT oha01 ,oha02 ,ohb03 ,ohb14t*(-1) ",     #TQC-B70204 mark
      LET l_sql= l_sql," UNION ALL SELECT oha01 ,oha02 ,ohb03 ,ohb14t*(-1) ",     #TQC-B70204 
                  " FROM ",cl_get_target_table(l_plant,'oha_file'),        
                  " ,",cl_get_target_table(l_plant,'ohb_file'),
                  " WHERE oha01=ohb01",
                  " AND oha05 IN ('1','2')",       #TQC-B70078
                  " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
                 #" AND ohb14 < 0 ",   #TQC-B80072
                  " AND oha02 BETWEEN '",g_bdate1,"' AND '",g_edate1,"'" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE artr141_prepare1 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artr141_curs1 CURSOR FOR artr141_prepare1 
      INITIALIZE sr.* TO NULL
      FOREACH artr141_curs1 INTO sr.* 
         INSERT INTO artr141_tmp1 VALUES(l_plant,sr.oga02,sr.cost)
      END FOREACH
      LET l_oga02 = ''
      LET l_cost1 = ''
      SELECT MAX(oga02),SUM(cost) INTO l_oga02,l_cost1 FROM artr141_tmp1 
       GROUP BY azw01
       IF cl_null(l_cost1) THEN
          LET l_cost1 = 0
       END IF
       DELETE FROM  artr141_tmp1
       #LET l_sql = "SELECT SUM(ogb14t)",   #TQC-B70078
       LET l_sql = " SELECT oga01,oga02, ogb03, ogb14t",
                  " FROM ",cl_get_target_table(l_plant,'ogb_file'),
                  " ,",cl_get_target_table(l_plant,'oga_file'),
                  " WHERE oga01=ogb01",
                  " AND oga09 IN ('2','3','4','6')",       #TQC-B70078
                  " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
                 #" AND ogb14 > 0 ",   #TQC-B80072
                  " AND oga02 BETWEEN '",g_bdate2,"' AND '",g_edate2,"'"                   
      #LET l_sql= l_sql," UNION SELECT SUM(ohb14t)*(-1)",     #TQC-B70078
#      LET l_sql= l_sql," UNION SELECT oha01,oha02, ohb03, ohb14t*(-1)",         #TQC-B70204 mark
       LET l_sql= l_sql," UNION ALL  SELECT oha01,oha02, ohb03, ohb14t*(-1)",         #TQC-B70204 
                  " FROM ",cl_get_target_table(l_plant,'oha_file'),
                  " ,",cl_get_target_table(l_plant,'ohb_file'),
                  " WHERE oha01=ohb01",
                  " AND oha05 IN ('1','2')",       #TQC-B70078
                  " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
                 #" AND ohb14 < 0 ",   #TQC-B80072
                  " AND oha02 BETWEEN '",g_bdate2,"' AND '",g_edate2,"'" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE artr141_prepare2 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artr141_curs2 CURSOR FOR artr141_prepare2 
      INITIALIZE sr.* TO NULL
      #FOREACH artr141_curs2 INTO sr.cost   #TQC-B70078
      FOREACH artr141_curs2 INTO sr.* #sr.oga01, sr.ogb03, sr.cost   #TQC-B70078 
         INSERT INTO artr141_tmp1 VALUES(l_plant,'',sr.cost)
      END FOREACH
      LET l_cost2 = ''
      SELECT SUM(cost) INTO l_cost2 FROM artr141_tmp1 
       GROUP BY azw01
       IF cl_null(l_cost2) THEN
          LET l_cost2 = 0
       END IF
      DELETE FROM  artr141_tmp1
      #LET l_sql = "SELECT SUM(ogb14t)",  #TQC-B70078
      LET l_sql = "SELECT oga01,oga02, ogb03, ogb14t",
                  " FROM ",cl_get_target_table(l_plant,'ogb_file'),
                  " ,",cl_get_target_table(l_plant,'oga_file'),
                  " WHERE oga01=ogb01",
                  " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
                  " AND oga09 IN ('2','3','4','6')",       #TQC-B70078
                 #" AND ogb14 > 0 ",   #TQC-B80072
                  " AND oga02 BETWEEN '",MDY(1,1,tm.yy),"' AND '",g_edate1,"'"                   
      #LET l_sql= l_sql," UNION SELECT SUM(ohb14t)*(-1)",
#     LET l_sql= l_sql," UNION SELECT oha01,oha02, ohb03, ohb14t*(-1)",  #TQC-B70078   #TQC-B70204 mark   
      LET l_sql= l_sql," UNION ALL SELECT oha01,oha02, ohb03, ohb14t*(-1)",            #TQC-B70204
                  " FROM ",cl_get_target_table(l_plant,'oha_file'),
                  " ,",cl_get_target_table(l_plant,'ohb_file'),
                  " WHERE oha01=ohb01",
                  " AND oha05 IN ('1','2')",       #TQC-B70078
                  " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
                 #" AND ohb14 < 0 ",   #TQC-B80072
                  " AND oha02 BETWEEN '",MDY(1,1,tm.yy),"' AND '",g_edate1,"'" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
       PREPARE artr141_prepare3 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artr141_curs3 CURSOR FOR artr141_prepare3 
      INITIALIZE sr.* TO NULL
      #FOREACH artr141_curs2 INTO sr.cost   #TQC-B70078
      FOREACH artr141_curs3 INTO sr.*  #sr.oga01, sr.ogb03, sr.cost   #TQC-B70078
         INSERT INTO artr141_tmp1 VALUES(l_plant,'',sr.cost)
      END FOREACH
      LET l_cost_sum1 = ''
      SELECT SUM(cost) INTO l_cost_sum1 FROM artr141_tmp1 
       GROUP BY azw01
       IF cl_null(l_cost_sum1) THEN
          LET l_cost_sum1 = 0
       END IF
      DELETE FROM  artr141_tmp1
      #LET l_sql = "SELECT SUM(ogb14t)",      #TQC-B70078
      LET l_sql = "SELECT oga01, oga02,ogb03,ogb14t",
                  " FROM ",cl_get_target_table(l_plant,'ogb_file'),
                  " ,",cl_get_target_table(l_plant,'oga_file'),
                  " WHERE oga01=ogb01",
                  " AND oga09 IN ('2','3','4','6')",       #TQC-B70078
                  " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
                 #" AND ogb14 > 0 ",   #TQC-B80072
                  " AND oga02 BETWEEN '",MDY(1,1,tm.yy-1),"' AND '",g_edate2,"'" 
      #LET l_sql= l_sql," UNION SELECT SUM(ohb14t)*(-1)",   #TQC-B70078                 
#      LET l_sql= l_sql," UNION SELECT oha01,oha02, ohb03, ohb14t*(-1)",        #TQC-B70204   mark     
       LET l_sql= l_sql," UNION ALL SELECT oha01,oha02, ohb03, ohb14t*(-1)",    #TQC-B70204
                  " FROM ",cl_get_target_table(l_plant,'oha_file'),
                  " ,",cl_get_target_table(l_plant,'ohb_file'),
                  " WHERE oha01=ohb01",
                  " AND oha05 IN ('1','2')",       #TQC-B70078
                  " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
                 #" AND ohb14 < 0 ",   #TQC-B80072
                  " AND oha02 BETWEEN '",MDY(1,1,tm.yy-1),"' AND '",g_edate2,"'" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
       PREPARE artr141_prepare4 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artr141_curs4 CURSOR FOR artr141_prepare4
     INITIALIZE sr.* TO NULL
      #FOREACH artr141_curs4 INTO sr.cost    #TQC-B70078
      FOREACH artr141_curs4 INTO sr.* #sr.oga01, sr.ogb03,sr.cost
         INSERT INTO artr141_tmp1 VALUES(l_plant,'',sr.cost)
      END FOREACH
      LET l_cost_sum2 = ''
      SELECT SUM(cost) INTO l_cost_sum2 FROM artr141_tmp1 
       GROUP BY azw01
       IF cl_null(l_cost_sum2) THEN
          LET l_cost_sum2 = 0
       END IF
      DELETE FROM  artr141_tmp1
      LET l_sql = " SELECT rwt201,rwt202,rwt203,rwt204,rwt205,rwt206,rwt207,",
                  " rwt208,rwt209,rwt210,rwt211,rwt212 FROM ",cl_get_target_table(l_plant,'rwt_file'),
                  " WHERE rwt01 = '",l_plant,"'",
                  " AND rwt02 = '",tm.yy,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE sel_rwt FROM l_sql 
      INITIALIZE sr1.* TO NULL
      EXECUTE sel_rwt INTO sr1.*
      IF cl_null(sr1.rwt201) THEN LET sr1.rwt201 = 0 END IF
      IF cl_null(sr1.rwt202) THEN LET sr1.rwt202 = 0 END IF
      IF cl_null(sr1.rwt203) THEN LET sr1.rwt203 = 0 END IF
      IF cl_null(sr1.rwt204) THEN LET sr1.rwt204 = 0 END IF
      IF cl_null(sr1.rwt205) THEN LET sr1.rwt205 = 0 END IF
      IF cl_null(sr1.rwt206) THEN LET sr1.rwt206 = 0 END IF
      IF cl_null(sr1.rwt207) THEN LET sr1.rwt207 = 0 END IF
      IF cl_null(sr1.rwt208) THEN LET sr1.rwt208 = 0 END IF
      IF cl_null(sr1.rwt209) THEN LET sr1.rwt209 = 0 END IF
      IF cl_null(sr1.rwt210) THEN LET sr1.rwt210 = 0 END IF
      IF cl_null(sr1.rwt211) THEN LET sr1.rwt211 = 0 END IF
      IF cl_null(sr1.rwt212) THEN LET sr1.rwt212 = 0 END IF
      EXECUTE insert_prep USING l_rtz10,l_ryf02,l_plant,l_azw08,l_oga02,l_cost1,
                                sr1.*,l_cost2,l_cost_sum1,l_cost_sum2
     
    END FOREACH

    
    LET g_str = ''
    LET g_wc = " azw01 in ",g_chk_auth
    IF NOT cl_null(tm.rtz10) THEN
       LET g_wc = g_wc," and rtz10 in ",g_chk_rtz10
    END IF 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'azw01,rtz10')
             RETURNING g_wc
        LET g_str = g_wc
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
   LET g_str = g_str,";",tm.yy,";",tm.mm,';',tm.cb,";"

   CALL cl_prt_cs3('artr141','artr141',l_sql,g_str)  

END FUNCTION
#FUN-B50068
