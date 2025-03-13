# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg143.4gl
# Descriptions...: 營運中心業績分配表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B60147 11/06/28 by huangtao
# Modify.........: No:TQC-B70078 11/07/11 by pauline 修改銷售金額選取條件
# Modify.........: No:FUN-B70100 11/07/27 By baogc 抓取實際銷售金額時，扣掉銷退金額
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No:FUN-C40071 12/04/27 By linlin CR轉GR 
#                                         By chenying  CR轉GR修改
# Modify.........: No.CHI-C80041 12/12/27 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           azw01     STRING,
           rtz10     STRING,
           yy        LIKE type_file.num5,
           mm        LIKE type_file.num5,
           cb1       LIKE type_file.chr1,
           cb2       LIKE type_file.chr1, 
           cb3       LIKE type_file.chr1,  
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


###GENGRE###START
TYPE sr1_t RECORD
    azw01 LIKE azw_file.azw01,
    azw08 LIKE azw_file.azw08,
    oga02 LIKE oga_file.oga02,
    cost LIKE type_file.num20_6,
    rwv03 LIKE rwv_file.rwv03,
    rww03 LIKE rww_file.rww03,
    gen02 LIKE gen_file.gen02,
    rww04 LIKE rww_file.rww04,
    rww04sum    LIKE type_file.num20_6,#FUN-C40071 add
    oga02_rww04 LIKE type_file.num20_6,#FUN-C40071 add
    costsum  LIKE type_file.num20_6,
    rwv03sum LIKE type_file.num20_6
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
   LET tm.rtz10 = ARG_VAL(8)
   LET tm.yy = ARG_VAL(9)
   LET tm.mm = ARG_VAL(10)
   LET tm.cb1  = ARG_VAL(11) 
   LET tm.cb2  = ARG_VAL(12)
   LET tm.cb3  = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)

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
               "oga02.oga_file.oga02,",
               "cost.type_file.num20_6,",
               "rwv03.rwv_file.rwv03,",
               "rww03.rww_file.rww03,",
               "gen02.gen_file.gen02,",
               "rww04.rww_file.rww04,",
               "rww04sum.type_file.num20_6,",     #FUN-C40071 add
               "oga02_rww04.type_file.num20_6,",  #FUN-C40071 add
               "costsum.type_file.num20_6,",
               "rwv03sum.type_file.num20_6"
    LET l_table = cl_prt_temptable('artg143',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"    #FUN-C40071 add 2?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF         

    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artg143_tm()        # Input print condition
    ELSE 
       CALL artg143() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artg143_tm()
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
   OPEN WINDOW artg143_w AT p_row,p_col WITH FORM "art/42f/artg143" 
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
   LET tm.cb1 = 'N' 
   LET tm.cb2 = 'N'
   LET tm.cb3 = 'N'
   WHILE TRUE
      INPUT BY NAME  tm.azw01,tm.rtz10,tm.yy,tm.mm,tm.cb1,tm.cb2,tm.cb3,tm.more WITHOUT DEFAULTS 
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
               DECLARE r143_ryf_cs1 CURSOR FOR SELECT ryf01 FROM ryf_file WHERE ryfacti = 'Y'
               FOREACH r143_ryf_cs1 INTO g_rtz10 
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
         LET INT_FLAG = 0 CLOSE WINDOW artg143_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C40071
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
          WHERE zz01='artg143'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('artg143','9031',1)
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
                       " '",tm.cb1 CLIPPED,"'" ,
                       " '",tm.cb2 CLIPPED,"'" ,
                       " '",tm.cb3 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg143',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg143_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table) #FUN-C40071
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg143()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg143_w
    
END FUNCTION


FUNCTION artg143() 
DEFINE    l_name    LIKE type_file.chr20,                
          l_sql     STRING ,                      
          sr        RECORD 
                    oga02 LIKE oga_file.oga02,
                    cost LIKE type_file.num20_6,
                    rwv03 LIKE rwv_file.rwv03,
                    rww03 LIKE rww_file.rww03,
                    rww04 LIKE rww_file.rww03
                    END RECORD
       
DEFINE l_plant      LIKE azw_file.azw01
DEFINE l_azw08      LIKE azw_file.azw08
DEFINE l_gen02      LIKE gen_file.gen02
DEFINE l_costsum    LIKE type_file.num20_6
DEFINE l_rww04sum   LIKE type_file.num20_6   #FUN-C40071
DEFINE l_oga02_rww04   LIKE type_file.num20_6   #FUN-C40071
DEFINE l_rwv03sum   LIKE type_file.num20_6
DEFINE l_azi04      LIKE azi_file.azi04
    DROP TABLE artg143_tmp1
    CREATE TEMP TABLE artg143_tmp1(
                    oga02 LIKE oga_file.oga02,
                    cost LIKE type_file.num20_6)
    DELETE FROM artg143_tmp1
    CREATE TEMP TABLE artg143_tmp2(
                    rwv02 LIKE rwv_file.rwv02,
                    rwv03 LIKE rwv_file.rwv03,
                    rww03 LIKE rww_file.rww03,
                    rww04 LIKE rww_file.rww04)
    DELETE FROM artg143_tmp2
   
    #FUN-C40071---add----str----------
    CREATE TEMP TABLE artg143_tmp3(
                    azw01 LIKE azw_file.azw01,
                    rww04 LIKE rww_file.rww04)
    DELETE FROM artg143_tmp3                               
    #FUN-C40071---add----end----------
  
  
    INITIALIZE sr.* TO NULL
    LET g_days1 = cl_days(tm.yy,tm.mm)
    LET g_bdate1 = MDY(tm.mm,1,tm.yy)
    LET g_edate1 = MDY(tm.mm,g_days1,tm.yy) 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    CALL cl_del_data(l_table)
    LET l_sql = " SELECT DISTINCT azw01,azw08 FROM azw_file,rtz_file ",
                " WHERE azw01 = rtz01  ",
                " AND azw01 IN ",g_chk_auth
    IF NOT cl_null(tm.rtz10) THEN
       LET l_sql = l_sql," AND rtz10 IN ",g_chk_rtz10
    END IF
    LET l_sql = l_sql," ORDER BY azw01 "
    PREPARE sel_azw01_pre FROM l_sql
    DECLARE sel_azw01_cs CURSOR FOR sel_azw01_pre           
    FOREACH sel_azw01_cs INTO l_plant,l_azw08
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      DELETE FROM artg143_tmp1
      DELETE FROM artg143_tmp2
      LET l_sql = " INSERT INTO artg143_tmp1 ",
                  " SELECT oga02 ,SUM(ogb14t) FROM(",
                  #" SELECT oga02,ogb14t",              #TQC-B70078
                  " SELECT oga01,oga02,ogb03,ogb14t",   #TQC-B70078
                  " FROM ",cl_get_target_table(l_plant,'ogb_file'),
                  " ,",cl_get_target_table(l_plant,'oga_file'),
                  " WHERE oga01=ogb01",
                  " AND ogaplant='",l_plant,"' AND ogapost='Y' ",
                 #" AND ogb14 > 0 ",        #FUN-B70100 MARK
                  #" AND oga00 = '1'",      #TQC-B70078
                  "AND oga09 IN('2','3','4','6')",
                  " AND oga02 BETWEEN '",g_bdate1,"' AND '",g_edate1,"'",                   
                  #" UNION SELECT oha02 oga02,ohb14t*(-1) ogb14t",
#                 " UNION SELECT oha01 oga01,oha02 oga02,ohb03 ogb03,ohb14t*(-1) ogb14t",   #TQC-B70078    #TQC-B70204 mark
                  " UNION ALL SELECT oha01 oga01,oha02 oga02,ohb03 ogb03,ohb14t*(-1) ogb14t",    #TQC-B70204
                  " FROM ",cl_get_target_table(l_plant,'oha_file'),
                  " ,",cl_get_target_table(l_plant,'ohb_file'),
                  " WHERE oha01=ohb01",
                  " AND ohaplant='",l_plant,"' AND ohapost='Y' ",
                 #" AND ohb14 < 0 ",        #FUN-B70100 MARK
                  #" AND oha05 = '1'",      #TQC-B70078
                  " AND oha05 IN ('1','2')",
                  " AND oha02 BETWEEN '",g_bdate1,"' AND '",g_edate1,"')",
                  " GROUP BY oga02 "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE artg143_prepare1 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table) #FUN-C40071
         EXIT PROGRAM                                      
      END IF         
      EXECUTE artg143_prepare1  
      LET l_sql = " INSERT INTO artg143_tmp2 ",
                  " SELECT rwv02,rwv03,rww03,rww04 FROM ",cl_get_target_table(l_plant,'rwv_file'),
                  ",",cl_get_target_table(l_plant,'rww_file'),
                  " WHERE rwv01 = rww01 ",
                  " AND rwv02 BETWEEN '",g_bdate1,"' AND '",g_edate1,"'"
      IF tm.cb1 = 'N' THEN
         LET l_sql = l_sql," AND rwvconf = 'Y' "
      ELSE  #CHI-C80041
         LET l_sql = l_sql," AND rwvconf <> 'X' "  #CHI-C80041
      END IF
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE artg143_prepare2 FROM l_sql          
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) #FUN-C40071
         EXIT PROGRAM                                      
      END IF   
      EXECUTE artg143_prepare2

      #FUN-C40071---add----str---------
      LET l_sql = "INSERT INTO artg143_tmp3 ",
                  " SELECT rww04 FROM ",cl_get_target_table(l_plant,'rww_file')
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE artg143_prepare3_1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare3_1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      EXECUTE artg143_prepare3_1

      LET l_sql = "SELECT SUM(rww04) FROM artg143_tmp3 "
      PREPARE artg143_prepare3_2 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare3_2:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table) 
         EXIT PROGRAM
      END IF
      EXECUTE artg143_prepare3_2 INTO l_rww04sum
      IF cl_null(l_rww04sum) THEN LET l_rww04sum = 0 END IF

      #FUN-C40071---add----end---------

      LET l_sql = " SELECT SUM(cost),SUM(rwv03),SUM(rww04) FROM (",    #FUN-C40071 add SUM(rww04)
                  " SELECT DISTINCT oga02,cost,rwv03,rww04 FROM artg143_tmp1 LEFT JOIN artg143_tmp2 ",  #FUN-C40071 add SUM(rww04)
                  " ON oga02 = rwv02 )  "
      PREPARE artg143_prepare3 FROM l_sql   
       IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   
         CALL cl_gre_drop_temptable(l_table) #FUN-C40071
         EXIT PROGRAM                                      
      END IF  
      EXECUTE artg143_prepare3 INTO l_costsum,l_rwv03sum,l_oga02_rww04     #FUN-C40071 add l_oga02_rww04
      IF cl_null(l_rwv03sum) THEN LET l_rwv03sum = 0 END IF
      IF cl_null(l_oga02_rww04) THEN LET l_oga02_rww04 = 0 END IF          #FUN-C40071 add 

      LET l_sql = " SELECT oga02,cost,rwv03,rww03,rww04 FROM artg143_tmp1 LEFT JOIN artg143_tmp2 ",
                  " ON oga02 = rwv02 "
      PREPARE pre_oga_rwv FROM l_sql
      DECLARE sel_oga_rwv  CURSOR FOR pre_oga_rwv  
      FOREACH  sel_oga_rwv INTO sr.*
          IF NOT cl_null(sr.rww03) THEN
            LET l_sql = "SELECT gen02 FROM ",cl_get_target_table(l_plant,'gen_file'),
                        " WHERE gen01 = '",sr.rww03,"'",
                        " AND gen07 = '",g_plant,"'"
            PREPARE sel_gen02 FROM l_sql  
            EXECUTE  sel_gen02  INTO l_gen02
            IF STATUS = 100 THEN
               LET l_gen02 = ' ' 
            END IF
          ELSE
            LET l_gen02 = ' '
          END IF
       
          EXECUTE insert_prep USING l_plant,l_azw08,sr.oga02,sr.cost,sr.rwv03,sr.rww03,l_gen02,sr.rww04,
                                    l_rww04sum,l_oga02_rww04,l_costsum,l_rwv03sum  #FUN-C40071 add l_rww04sum,l_oga02_rww04
      END FOREACH
    END FOREACH

    
    LET g_str = ''
    LET g_wc = " azw01 in ",g_chk_auth
    IF NOT cl_null(tm.rtz10) THEN
       LET g_wc = g_wc," and rtz10 in ",g_chk_rtz10
    END IF
###GENGRE###    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
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
    SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
###GENGRE###   LET g_str = g_str,";",tm.yy,";",tm.mm,';',tm.cb1,";",tm.cb2,";",tm.cb3,";",l_azi04,";"
   CASE 
     WHEN tm.cb3 = 'N'
###GENGRE###        CALL cl_prt_cs3('artg143','artg143_1',l_sql,g_str) 
    LET g_template = 'artg143_1'   #FUN-C40071
    CALL artg143_1_grdata()    ###GENGRE###
     WHEN tm.cb3 = 'Y'
###GENGRE###        CALL cl_prt_cs3('artg143','artg143_2',l_sql,g_str)  
    LET g_template = 'artg143_2'   #FUN-C40071    
    CALL artg143_2_grdata()    ###GENGRE###
   END CASE
END FUNCTION
#No.FUN-B60147


###GENGRE###START
FUNCTION artg143_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg143")
        IF handler IS NOT NULL THEN
            START REPORT artg143_1_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE artg143_datacur1 CURSOR FROM l_sql
            FOREACH artg143_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg143_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg143_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg143_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno        LIKE type_file.num5
    DEFINE l_rww03_rww04_sum     LIKE  rww_file.rww04
    DEFINE l_fmt           STRING
    DEFINE l_azi04         LIKE azi_file.azi04

    
    ORDER EXTERNAL BY sr1.azw01,sr1.rww03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-C40071 add g_ptime,g_user_name
            PRINTX tm.*,g_str   #FUN-C40071 add g_str
              
        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.rww03
            #FUN-C40071------add--------str---------------
            SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
            LET l_fmt = cl_gr_numfmt('type_file','num20_6',l_azi04)
            PRINTX l_fmt
            #FUN-C40071------add--------end---------------
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
        AFTER GROUP OF sr1.rww03
            #FUN-C40071------add--------str---------------
            LET l_rww03_rww04_sum = GROUP SUM(sr1.rww04)
            PRINTX l_rww03_rww04_sum
            #FUN-C40071------add--------end---------------

        ON LAST ROW

END REPORT
#FUN-C40071----add---begin--
FUNCTION artg143_2_grdata() 
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg143")
        IF handler IS NOT NULL THEN
            START REPORT artg143_2_rep TO XML HANDLER handler
            LET l_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY oga02"   #FUN-C40071
          
            DECLARE artg143_datacur2 CURSOR FROM l_sql
            FOREACH artg143_datacur2 INTO sr1.*
                OUTPUT TO REPORT artg143_2_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg143_2_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg143_2_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno        LIKE type_file.num5
    DEFINE l_cost_1_subtot LIKE type_file.num20_6
    DEFINE l_oga02_rww04_sum     LIKE  rww_file.rww04
    DEFINE l_fmt           STRING
    DEFINE l_azi04         LIKE azi_file.azi04

    
    ORDER EXTERNAL BY sr1.azw01,sr1.oga02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-C40071 add g_ptime,g_user_name
            PRINTX tm.*,g_str   #FUN-C40071 add g_str
              
        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.oga02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
           
            #FUN-C40071------add--------str---------------
            SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17  
            LET l_fmt = cl_gr_numfmt('type_file','num20_6',l_azi04)
            PRINTX l_fmt
            #FUN-C40071------add--------end---------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01
        AFTER GROUP OF sr1.oga02

        ON LAST ROW

END REPORT
#FUN-C40071---add---end----
###GENGRE###END
