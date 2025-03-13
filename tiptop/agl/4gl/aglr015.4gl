# Prog. Version..: '5.30.06-13.04.01(00006)'     #
#
# Pattern name...: aglr015.4gl
# Descriptions...: 記帳幣別科餘檢核表
# Input parameter: 
# Return code....: 
# Date & Author..: 10/11/08 FUN-AB0027 BY Summer
# Modify.........: 10/11/12 TQC-AB0048 by Yiting 合併後科目相同者不要重複出現金額
# Modify.........: NO.TQC-AB0055 10/11/15 BY yiting 程式中有dblink寫法CALL cl_replace_sqldb(l_sql) RETURNING l_sql解析出來無法正確,axe_file拆離
# Modify.........: NO.FUN-AB0027 11/01/26 By lixia 追單
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: NO.CHI-D20029 13/03/12 By apo 要依據axz10的設定來判斷取axe_file or ayf_file

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-BA0006
DEFINE tm  RECORD
              wc       STRING,
              aej01   LIKE aej_file.aej01,      #族群代號  #FUN-AB0027
              aej02   LIKE aej_file.aej02,      #合併個體編號
              aej03   LIKE aej_file.aej03,      #合併個體帳別
              aej05   LIKE aej_file.aej05,      #會計年度
              aej06   LIKE aej_file.aej06,      #期別  
              t       LIKE type_file.chr1       #報表選項1.記帳幣別科餘檢核表 2.帳幣別異動碼科餘檢核表
           END RECORD,
       g_aaa04        LIKE aaa_file.aaa04,      #現行會計年度
       g_aaa05        LIKE aaa_file.aaa05,      #現行期別           
       g_bookno       LIKE axh_file.axh00       #帳別
DEFINE g_axz03            LIKE type_file.chr21
#DEFINE g_dbs_gl           LIKE  azp_file.azp03       
DEFINE g_cnt              LIKE type_file.num10       
DEFINE l_table        STRING
DEFINE l_table1       STRING
DEFINE g_sql          STRING
DEFINE g_str          STRING

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
   
   
   LET g_pdate  = ARG_VAL(1)                 # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)

   LET tm.aej01 = ARG_VAL(7)
   LET tm.aej02 = ARG_VAL(8)
   LET tm.aej03 = ARG_VAL(9)
   LET tm.aej05 = ARG_VAL(10)
   LET tm.aej06 = ARG_VAL(11)
   LET tm.t     = ARG_VAL(12)
   
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)
   
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 mark
   
   LET g_sql = "aej01.aej_file.aej01,",
               "aej02.aej_file.aej02,",
               "aej03.aej_file.aej03,",
               "aej11.aej_file.aej11,",
               "aah01.aah_file.aah01,",
               "aag02.aag_file.aag02,",
               "aah04.aah_file.aah04,",
               "aah05.aah_file.aah05,",
               "amt1.type_file.num20_6,",
               "aej04.aej_file.aej04,",
               "aag02_1.aag_file.aag02,",
               "aej07.aej_file.aej07,",
               "aej08.aej_file.aej08,",
               "amt2.type_file.num20_6,"
   
   LET l_table = cl_prt_temptable('aglr015',g_sql) CLIPPED # 產生TEMP TABLE
   IF l_table = -1 THEN EXIT PROGRAM END IF

   LET g_sql = "aek01.aek_file.aek01,",
               "aek02.aek_file.aek02,",
               "aek03.aek_file.aek03,",
               "aek12.aek_file.aek12,",
               "aed01.aed_file.aed01,",
               "aag02_2.aag_file.aag02,",
               "aed011.aed_file.aed011,",
               "aed02.aed_file.aed02,",
               "aed05.aed_file.aed05,",
               "aed06.aed_file.aed06,",
               "amt3.type_file.num20_6,",
               "aek04.aek_file.aek04,",
               "aag02_3.aag_file.aag02,",
               "aek05.aek_file.aek05,",
               "aek08.aek_file.aek08,",
               "aek09.aek_file.aek09,",
               "amt4.type_file.num20_6,"
   
   LET l_table1 = cl_prt_temptable('aglr015_1',g_sql) CLIPPED # 產生TEMP TABLE
   IF l_table1 = -1 THEN EXIT PROGRAM END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r015_tm()
   ELSE
      IF tm.t = '1' THEN
         CALL r015_1()
      ELSE
         CALL r015_2()
      END IF
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION r015_tm()
   DEFINE p_row,p_col    LIKE type_file.num5
   DEFINE l_aej03        LIKE aej_file.aej03
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_cmd          LIKE type_file.chr1000
   
   CALL s_dsmark(g_bookno)

   LET p_row = 2 LET p_col = 20

   OPEN WINDOW r015_w AT p_row,p_col WITH FORM "agl/42f/aglr015" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   
   WHILE TRUE
   
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
        FROM aaa_file 
       WHERE aaa01 = g_bookno

      LET tm.aej05 = g_aaa04
      LET tm.t = '1'
      LET g_bgjob = 'N'

      INPUT BY NAME tm.aej01,tm.aej02,tm.aej03,tm.aej05,tm.aej06,tm.t WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_init()

         AFTER FIELD aej01
            IF NOT cl_null(tm.aej01) THEN
               SELECT DISTINCT aej01 FROM aej_file WHERE aej01=tm.aej01
               IF STATUS THEN
                  CALL cl_err('',SQLCA.sqlcode,0)
                  NEXT FIELD aej01 
               END IF
            END IF

         AFTER FIELD aej02  #公司編號
            IF NOT cl_null(tm.aej02) THEN
               SELECT DISTINCT aej02 FROM aej_file 
                WHERE aej01=tm.aej01 AND aej02=tm.aej02
               IF STATUS THEN 
                  CALL cl_err('',SQLCA.sqlcode,0)
                  NEXT FIELD aej02 
               END IF
               SELECT DISTINCT aej03 INTO l_aej03 FROM aej_file
                WHERE aej01=tm.aej01
                  AND aej02=tm.aej02
               LET tm.aej03 = l_aej03
               DISPLAY l_aej03 TO aej03
            END IF

         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
  
         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aej01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aej1"
                  LET g_qryparam.default1 = tm.aej01
                  CALL cl_create_qry() RETURNING tm.aej01,tm.aej02,tm.aej03
                  DISPLAY BY NAME tm.aej01,tm.aej02,tm.aej03
                  NEXT FIELD aej03
               WHEN INFIELD(aej02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_axz"
                  LET g_qryparam.default1 = tm.aej02
                  CALL cl_create_qry() RETURNING tm.aej02
                  DISPLAY BY NAME tm.aej02
                  NEXT FIELD aej02
            END CASE

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

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r015_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr015'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr015','9031',1)  
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.aej01 CLIPPED,"'",
                        " '",tm.aej02 CLIPPED,"'",
                        " '",tm.aej03 CLIPPED,"'",
                        " '",tm.aej05 CLIPPED,"'",
                        " '",tm.aej06 CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'",
                        " '",g_rpt_name CLIPPED,"'"
                        
            CALL cl_cmdat('aglr015',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r015_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      IF tm.t = '1' THEN
         CALL r015_1()
      ELSE
         CALL r015_2()
      END IF
          
      ERROR ""
   END WHILE
   CLOSE WINDOW r015_w
END FUNCTION

FUNCTION r015_1()
   DEFINE l_sql     STRING
   DEFINE l_axz04   LIKE axz_file.axz04
   DEFINE sr       RECORD
                       aah01    LIKE aah_file.aah01,
                       aag02    LIKE aag_file.aag02,
                       aah04    LIKE aah_file.aah04,
                       aah05    LIKE aah_file.aah05,
                       amt1     LIKE type_file.num20_6,
                       aej04    LIKE aej_file.aej04,
                       aag02_1  LIKE aag_file.aag02,
                       aej07    LIKE aej_file.aej07,
                       aej08    LIKE aej_file.aej08,
                       amt2     LIKE type_file.num20_6
                    END RECORD
   DEFINE l_aej11   LIKE aej_file.aej11
   DEFINE l_aej04_o LIKE aej_file.aej04
   DEFINE l_gae04 LIKE gae_file.gae04   
   DEFINE l_cnt     LIKE type_file.num5   #TQC-AB0055 
   DEFINE l_axz10   LIKE axz_file.axz10   #CHI-D20029 
   DEFINE l_aeh02   LIKE aeh_file.aeh02   #CHI-D20029 
   DEFINE l_ayf10   LIKE ayf_file.ayf10   #CHI-D20029
   DEFINE l_ayf11   LIKE ayf_file.ayf11   #CHI-D20029

   
   CALL cl_del_data(l_table)
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
   #依輸入合併個體取資料庫代碼
   SELECT axz03 INTO g_axz03 FROM axz_file WHERE axz01 = tm.aej02
   #SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = g_axz03
   #IF STATUS THEN
   #   LET g_dbs_new = NULL
   #END IF
   #LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED)

   LET g_cnt = 1
   

   #判斷輸入公司是否為TIPTOP公司，如果為TIPTOP公司，則SELECT aah_file/aed_file (總帳科目餘額) ELSE SELECT axq_file (公司科目餘額暫存資料(非TIPTOP公司))
  #SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01= tm.aej02                  #CHI-D20029 mark
   SELECT axz04,axz10 INTO l_axz04,l_axz10 FROM axz_file WHERE axz01= tm.aej02    #CHI-D20029
   #--CHI-D20029 start--
   IF l_axz10 = 'Y' THEN
       SELECT UNIQUE ayf10,ayf11 INTO l_ayf10,l_ayf11
         FROM ayf_file    
        WHERE ayf01 = tm.aej02
          AND ayf09 = tm.aej01
          AND ayf10 = tm.aej05
          AND ayf11 = tm.aej06
       IF STATUS  THEN
           SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
             FROM ayf_file    
            WHERE ayf01 = tm.aej02
              AND ayf09 = tm.aej01
       END IF
   END IF
   #--CHI-D20029 end--
   IF l_axz04='Y' THEN   #是否屬於TIPTOP公司
       IF l_axz10 = 'N' OR cl_null(l_axz10)  THEN                                    #CHI-D20029 add
         #LET l_sql = "SELECT UNIQUE aah01,aag02,aah04,aah05,(aah04-aah05)",             #CHI-D20029 mark
          LET l_sql = "SELECT UNIQUE '',aah01,aag02,aah04,aah05,(aah04-aah05)",          #CHI-D20029
                      #" FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",",axe_file",   #TQC-AB0055 mark
                      #" FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",   #TQC-AB0055 mod
                      " FROM ",cl_get_target_table(g_axz03,'aah_file'),",",
                               cl_get_target_table(g_axz03,'aag_file'), 
                      " WHERE aag00 = aah00 ",
                      "   AND aag01 = aah01 ",
                      "   AND aah00 = '",tm.aej03,"'",
                      "   AND aah02 = '",tm.aej05,"'",
                      "   AND aah03 = '",tm.aej06,"'",
                     #"   AND aah01 = axe04 ",         #TQC-AB0055 mark
                     #"   AND axe13 = '",tm.aej01,"'", #TQC-AB0055 mark
                     #"   AND axe01 = '",tm.aej02,"'", #TQC-AB0055 mark
                      "   AND aag00 = aah00 ",
                      "   AND aag01 = aah01 ",
                      "  ORDER BY aah01 "
       #---CHI-D20029 add start----------------
       ELSE
           LET l_sql=" SELECT UNIQUE aeh02,aeh01,aag02,aeh11,aeh12,(aeh11-aeh12)",  
                     "   FROM ",cl_get_target_table(g_axz03,'aeh_file'),",", 
                                cl_get_target_table(g_axz03,'aag_file'),    
                     " WHERE aeh01 = aag01 ",
                     "   AND aeh00 = aag00 ",
                     "   AND aeh00 = '",tm.aej03,"'",
                     "   AND aeh09 = '",tm.aej05,"'",
                     "   AND aeh10 = '",tm.aej06,"'",
                     " GROUP BY aeh01,aeh02,aeh09,aeh10,aag02,aeh11,aeh12 ",
                     " ORDER BY aeh01"
       END IF
       #---CHI-D20029 add end-------------------
   ELSE
      #LET l_sql = " SELECT axq05,axq051,axq08,axq09,(axq08-axq09)",         #CHI-D20029 mark
       LET l_sql = " SELECT axq29,axq05,axq051,axq08,axq09,(axq08-axq09)",   #CHI-D20029 
                    " FROM axq_file ",
                    "  WHERE axq01 = '",tm.aej01,"'", 
                    "    AND axq04 = '",tm.aej02,"'", 
                    "    AND axq041 ='",tm.aej03,"'", 
                    "    AND axq06 = '",tm.aej05,"'", 
                    "    AND axq07 = '",tm.aej06,"'",
                    " ORDER BY axq05 "
   END IF
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                
   CALL cl_parse_qry_sql(l_sql,g_axz03) RETURNING l_sql
   PREPARE r015_aej_p FROM l_sql
   DECLARE r015_aej_c CURSOR FOR r015_aej_p          #BODY CURSOR
  #FOREACH r015_aej_c INTO sr.*                      #CHI-D20029 mark
   FOREACH r015_aej_c INTO l_aeh02,sr.*              #CHI-D20029
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          IF l_axz10 = 'N' OR cl_null(l_axz10) THEN    #CHI-D20029 add
          #--TQC-AB0055 start--
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt
            FROM axe_file
           WHERE axe04= sr.aah01
             AND axe13=tm.aej01
             AND axe01=tm.aej02
          IF l_cnt = 0 THEN CONTINUE FOREACH END IF
          #--TQC-AB0055 end---
          #---CHI-D20029 start- 
          ELSE
              LET l_cnt = 0
              IF cl_null(l_aeh02) OR l_aeh02 ='' THEN                
                   SELECT COUNT(*) INTO l_cnt
                     FROM ayf_file    
                    WHERE ayf01 = tm.aej02
	              AND ayf04 = sr.aah01
                      AND ayf09 = tm.aej01
                      AND ayf02 = ' '
                      AND ayf03 = ' '
                      AND ayf10 = l_ayf10
                      AND ayf11 = l_ayf11
              ELSE
                   SELECT COUNT(*) INTO l_cnt
                     FROM ayf_file    
                    WHERE ayf01 = tm.aej02
	              AND ayf04 = sr.aah01
                      AND ayf09 = tm.aej01
                      AND (ayf02 <= l_aeh02 AND ayf03 >= l_aeh02)
                      AND ayf10 = l_ayf10
                      AND ayf11 = l_ayf11
              END IF        
              IF l_cnt = 0 THEN CONTINUE FOREACH END IF
          END IF 
          #--CHI-D20029 end-----

          IF NOT cl_null(sr.aah01) THEN
             IF l_axz10 = 'N' OR cl_null(l_axz10) THEN            #CHI-D20029 add
             LET l_sql =  "SELECT aej04,aag02,aej07,aej08,(aej07-aej08),aej11",
                          "  FROM aej_file,aag_file,axe_file ",
                          " WHERE aag00 = aej00 ",
                          "   AND aag01 = aej04 ",
                          "   AND axe13 = '",tm.aej01,"'",
                          "   AND axe01 = '",tm.aej02,"'",
                          "   AND axe04 = '",sr.aah01,"'",
                          "   AND axe06 = aej04",
                          "   AND axe13 = aej01",
                          "   AND axe01 = aej02",
                          "   AND aej03 = '",tm.aej03,"'",
                          "   AND aej05 = '",tm.aej05,"'",
                          "   AND aej06 = '",tm.aej06,"'"
             #---CHI-D20029 start---
             ELSE
                 LET l_sql =  "SELECT aej04,aag02,aej07,aej08,(aej07-aej08)",
                              "  FROM aej_file,aag_file,ayf_file ",  
                              " WHERE aag00 = aej00 ",
                              "   AND aag01 = aej04 ",
                              "   AND ayf09 = '",tm.aej01,"'",
                              "   AND ayf01 = '",tm.aej02,"'",
                              "   AND ayf04 = '",sr.aah01,"'",
                              "   AND ayf06 = aej04",
                              "   AND ayf09 = aej01",
                              "   AND ayf01 = aej02",     
                              "   AND aej03 = '",tm.aej03,"'",
                              "   AND aej05 = '",tm.aej05,"'",
                              "   AND aej06 = '",tm.aej06,"'",
                              "   AND ayf10 = '",l_ayf10,"'",
                              "   AND ayf11 = '",l_ayf11,"'" 
                 IF cl_null(l_aeh02) OR l_aeh02 ='' THEN                
                     LET l_sql = l_sql CLIPPED,
                                 "  AND ayf02 = ' ' ",
                                 "  AND ayf03 = ' ' "
                 ELSE
                     LET l_sql = l_sql CLIPPED, " AND (ayf02 <= '",l_aeh02,"' AND ayf03 >= '",l_aeh02,"') "
                 END IF
             END IF 
             #---CHI-D20029 end---
             PREPARE r015_aej_p2 FROM l_sql
             DECLARE r015_aej_c2 CURSOR FOR r015_aej_p2          #BODY CURSOR
             FOREACH r015_aej_c2 INTO sr.aej04,
                                      sr.aag02_1,
                                      sr.aej07,
                                      sr.aej08,
                                      sr.amt2,
                                      l_aej11
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                    EXIT FOREACH
                 END IF
             END FOREACH
          END IF
       END IF
       IF g_cnt > 1 THEN
           IF sr.aej04 = l_aej04_o THEN
               #LET sr.aej04 = ''   #TQC-AB0048 mark
               #LET sr.aag02_1 = '' #TQC-AB0048 mark
               LET sr.aej07 = ''
               LET sr.aej08 = ''
               LET sr.amt2 = ''
           END IF
       END IF
       IF NOT cl_null(sr.aej04) THEN   #TQC-AB0048
           LET l_aej04_o = sr.aej04
       END IF    #TQC-AB0048
       LET g_cnt = g_cnt + 1      

       EXECUTE insert_prep USING                                              
                        tm.aej01,tm.aej02,tm.aej03,l_aej11,sr.*
   END FOREACH

   SELECT gae04 INTO l_gae04 FROM gae_file WHERE gae01='aglr015' AND gae02='t_1' AND gae03=g_rlang

   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = l_gae04,";",tm.aej05,";",tm.aej06
 
   CALL cl_prt_cs3('aglr015','aglr015',g_sql,g_str)
     
END FUNCTION

FUNCTION r015_2()
   DEFINE l_sql     STRING
   DEFINE l_axz04   LIKE axz_file.axz04
   DEFINE sr       RECORD
                       aed01    LIKE aed_file.aed01,
                       aag02_2  LIKE aag_file.aag02,
                       aed011   LIKE aed_file.aed011,
                       aed02    LIKE aed_file.aed02,
                       aed05    LIKE aed_file.aed05,
                       aed06    LIKE aed_file.aed06,
                       amt3     LIKE type_file.num20_6,
                       aek04    LIKE aek_file.aek04,
                       aag02_3  LIKE aag_file.aag02,
                       aek05    LIKE aek_file.aek05,
                       aek08    LIKE aek_file.aek08,
                       aek09    LIKE aek_file.aek09,
                       amt4     LIKE type_file.num20_6
                    END RECORD
   DEFINE l_aek12   LIKE aek_file.aek12
   DEFINE l_aek04_o LIKE aek_file.aek04
   DEFINE l_aek05_o LIKE aek_file.aek05
   DEFINE l_gae04 LIKE gae_file.gae04
   DEFINE l_cnt     LIKE type_file.num5    #TQC-AB0048
   DEFINE l_axz10   LIKE axz_file.axz10   #CHI-D20029 
   DEFINE l_aeh02   LIKE aeh_file.aeh02   #CHI-D20029 
   DEFINE l_ayf10   LIKE ayf_file.ayf10   #CHI-D20029
   DEFINE l_ayf11   LIKE ayf_file.ayf11   #CHI-D20029

   CALL cl_del_data(l_table1)
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF    
   
      #--TQC-AB0048 start--
   DROP TABLE r015_tmp
   CREATE TEMP TABLE r015_tmp(
      cnt      LIKE type_file.num5,
      aek04    LIKE aek_file.aek04,
      aek05    LIKE aek_file.aek05)

   DELETE FROM r015_tmp
   LET l_sql = "INSERT INTO r015_tmp VALUES(?,?,?)"
   PREPARE insert_temp_prep FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('insert_temp_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   #--TQC-AB0048 end---

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   
   #依輸入合併個體取資料庫代碼
   SELECT axz03 INTO g_axz03 FROM axz_file WHERE axz01 = tm.aej02
   #SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = g_axz03
   #IF STATUS THEN
   #   LET g_dbs_new = NULL
   #END IF
   #LET g_dbs_gl = s_dbstring(g_dbs_new CLIPPED)
   
   LET g_cnt = 1

   #3.判斷輸入公司是否為TIPTOP公司，如果為TIPTOP公司，則SELECT aah_file/aed_file (總帳科目餘額) ELSE SELECT axq_file (公司科目餘額暫存資料(非TIPTOP公司))
   #SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01= tm.aej02                 #CHI-D20029 mark
   SELECT axz04,axz10 INTO l_axz04,l_axz10 FROM axz_file WHERE axz01= tm.aej02    #CHI-D20029
   #--CHI-D20029 start--
   IF l_axz10 = 'Y' THEN
       SELECT UNIQUE ayf10,ayf11 INTO l_ayf10,l_ayf11
         FROM ayf_file    
        WHERE ayf01 = tm.aej02
          AND ayf09 = tm.aej01
          AND ayf10 = tm.aej05
          AND ayf11 = tm.aej06
       IF STATUS  THEN
           SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
             FROM ayf_file    
            WHERE ayf01 = tm.aej02
              AND ayf09 = tm.aej01
       END IF
   END IF
   #--CHI-D20029 end--
   IF l_axz04='Y' THEN   #是否屬於TIPTOP公司
       IF l_axz10 = 'N' OR cl_null(l_axz10)  THEN                                         #CHI-D20029 add
           #LET l_sql = "SELECT UNIQUE aed01,aag02,aed011,aed02,aed05,",                  #CHI-D20029 mark
           LET l_sql = "SELECT UNIQUE '',aed01,aag02,aed011,aed02,aed05,",                #CHI-D20029 
                   "              aed06,(aed05-aed06)",
#                  "  FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",",axe_file",   #TQC-AB0055 mark
                  # "  FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",   #TQC-AB0055 mod
                   " FROM ",cl_get_target_table(g_axz03,'aed_file'),",",
                            cl_get_target_table(g_axz03,'aag_file'),
                   " WHERE aag00 =aed00 ",
                   "   AND aag01 =aed01 ",
                   "   AND aed00 = '",tm.aej03,"'",
                   "   AND aed03 = '",tm.aej05,"'",
                   "   AND aed04 = '",tm.aej06,"'",
#                  "   AND aed01 = axe04 ",             #TQC-AB0055 mark
#                  "   AND axe13 = '",tm.aej01,"'",     #TQC-AB0055 mark
#                  "   AND axe01 = '",tm.aej02,"'",     #TQC-AB0055 mark
                   "   AND aed011 = '99'",
                   "  ORDER BY aed01 "
       #---CHI-D20029 START--
   ELSE
           LET l_sql=" SELECT UNIQUE aeh02,aeh01,aag02,'99',aeh37,aeh11,aeh12,(aeh11-aeh12) ",  
                     "   FROM ",cl_get_target_table(g_axz03,'aeh_file'),",", 
                                cl_get_target_table(g_axz03,'aag_file'),    
                     " WHERE aeh01 = aag01 ",
                     "   AND aeh00 = aag00 ",
                     "   AND aeh00 = '",tm.aej03,"'",
                     "   AND aeh09 = '",tm.aej05,"'",
                     "   AND aeh10 = '",tm.aej06,"'",
                     "   AND aeh37 <> ' '",      
                     "   AND aeh37 IS NOT NULL ", 
                     " GROUP BY aeh01,aeh02,aag02,aeh37,aeh11,aeh12 ",
                     " ORDER BY aeh01"
       END IF  
       #----CHI-D20029 end---------
   ELSE
       #LET l_sql = " SELECT axq05,axq051,'99',axq13,axq08,axq09,(axq08-axq09)",          #CHI-D20029 mark
       LET l_sql = " SELECT axq29,axq05,axq051,'99',axq13,axq08,axq09,(axq08-axq09)",     #CHI-D20029
                    " FROM axq_file ",
                    "  WHERE axq01 = '",tm.aej01,"'", 
                    "    AND axq04 = '",tm.aej02,"'", 
                    "    AND axq041 ='",tm.aej03,"'", 
                    "    AND axq06 = '",tm.aej05,"'", 
                    "    AND axq07 = '",tm.aej06,"'",
                    "    AND (axq13 IS NOT NULL AND axq13 <> ' ')",
                    " ORDER BY axq05 "
   END IF

   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                
   CALL cl_parse_qry_sql(l_sql,g_axz03) RETURNING l_sql
   PREPARE r015_aed_p FROM l_sql
   DECLARE r015_aed_c CURSOR FOR r015_aed_p          #BODY CURSOR
   #FOREACH r015_aed_c INTO sr.*          #CHI-D20029 mark
   FOREACH r015_aed_c INTO l_aeh02,sr.*   #CHI-D20029 
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
           IF l_axz10 = 'N' OR cl_null(l_axz10) THEN    #CHI-D20029 add
           #--TQC-AB0055 start--
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM axe_file
            WHERE axe04= sr.aed01
              AND axe13 =tm.aej01
              AND axe01 =tm.aej02
           IF l_cnt = 0 THEN CONTINUE FOREACH END IF
           #--TQC-AB0055 end---
           #---CHI-D20029 start- 
           ELSE
               LET l_cnt = 0
               IF cl_null(l_aeh02) OR l_aeh02 ='' THEN                
                    SELECT COUNT(*) INTO l_cnt
                      FROM ayf_file    
                     WHERE ayf01 = tm.aej02
	               AND ayf04 = sr.aed01
                       AND ayf09 = tm.aej01
                       AND ayf02 = ' '
                       AND ayf03 = ' '
                       AND ayf10 = l_ayf10
                       AND ayf11 = l_ayf11
               ELSE
                    SELECT COUNT(*) INTO l_cnt
                      FROM ayf_file    
                     WHERE ayf01 = tm.aej02
	               AND ayf04 = sr.aed01
                       AND ayf09 = tm.aej01
                       AND (ayf02 <= l_aeh02 AND ayf03 >= l_aeh02)
                       AND ayf10 = l_ayf10
                       AND ayf11 = l_ayf11
               END IF        
           END IF 
           #---CHI-D20029 end--------------------------
           IF l_axz10 = 'N' OR cl_null(l_axz10) THEN    #CHI-D20029 add
           LET l_sql =  "SELECT aek04,aag02,aek05,aek08,aek09,(aek08-aek09),aek12",
                        "  FROM aek_file,aag_file,axe_file ",
                        " WHERE aag00 = aek00 ",
                        "   AND aag01 = aek04 ",
                        "   AND axe13 = '",tm.aej01,"'",
                        "   AND axe01 = '",tm.aej02,"'",
                        "   AND axe04 = '",sr.aed01,"'",
                        "   AND axe06 = aek04",
                        "   AND axe13 = aek01",
                        "   AND axe01 = aek02",
                        "   AND aek05 = '",sr.aed02,"'",
                        "   AND aek03 = '",tm.aej03,"'",
                        "   AND aek06 = '",tm.aej05,"'",
                        "   AND aek07 = '",tm.aej06,"'"
           #---CHI-D20029 start--
           ELSE
               LET l_sql =  "SELECT aek04,aag02,aek05,aek08,aek09,(aek08-aek09)",
                            "  FROM aek_file,aag_file,ayf_file ", 
                            " WHERE aag00 = aek00 ",
                            "   AND aag01 = aek04 ",
                            "   AND ayf09 = '",tm.aej01,"'",
                            "   AND ayf01 = '",tm.aej02,"'",
                            "   AND ayf04 = '",sr.aed01,"'",
                            "   AND ayf06 = aek04",
                            "   AND ayf09 = aek01",
                            "   AND ayf01 = aek02",                
                            "   AND aek05 = '",sr.aed02,"'",   
                            "   AND aek03 = '",tm.aej03,"'",
                            "   AND aek06 = '",tm.aej05,"'",
                            "   AND aek07 = '",tm.aej06,"'",
                            "   AND ayf10 = '",l_ayf10,"'",
                            "   AND ayf11 = '",l_ayf11,"'" 
               IF cl_null(l_aeh02) OR l_aeh02 ='' THEN                
                   LET l_sql = l_sql CLIPPED,
                               "  AND ayf02 = ' ' ",
                               "  AND ayf03 = ' ' "
               ELSE
                   LET l_sql = l_sql CLIPPED, " AND (ayf02 <= '",l_aeh02,"' AND ayf03 >= '",l_aeh02,"') "
               END IF
           END IF
           #---CHI-D20029 end---
           PREPARE r015_aek_p2 FROM l_sql
           DECLARE r015_aek_c2 CURSOR FOR r015_aek_p2          #BODY CURSOR
           FOREACH r015_aek_c2 INTO sr.aek04,
                                    sr.aag02_3,
                                    sr.aek05,
                                    sr.aek08,
                                    sr.aek09,
                                    sr.amt4,
                                    l_aek12
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               EXECUTE insert_temp_prep USING g_cnt,sr.aek04,sr.aek05    #TQC-AB0048
           END FOREACH
       END IF
       IF g_cnt > 1 THEN
           #---TQC-AB0048 start---
           LET l_cnt = 0
           DECLARE r015_tmp_cs CURSOR FOR
           SELECT COUNT(*) FROM r015_tmp
            WHERE aek04 = sr.aek04
              AND aek05 = sr.aek05
              AND cnt <> g_cnt
           OPEN r015_tmp_cs
           FETCH r015_tmp_cs INTO l_cnt
           IF l_cnt > 0 THEN
           #--TQC-AB0048 end------
               LET sr.aek08 = ''
               LET sr.aek09 = ''
               LET sr.amt4 = ''
           END IF
       END IF
       LET l_aek04_o = sr.aek04
       LET g_cnt = g_cnt + 1
       
       EXECUTE insert_prep1 USING                                              
                        tm.aej01,tm.aej02,tm.aej03,l_aek12,sr.*
                               
   END FOREACH
   
   SELECT gae04 INTO l_gae04 FROM gae_file WHERE gae01='aglr015' AND gae02='t_2' AND gae03=g_rlang
   
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
   LET g_str = l_gae04,";",tm.aej05,";",tm.aej06
 
   CALL cl_prt_cs3('aglr015','aglr015_1',g_sql,g_str)   

END FUNCTION

#FUN-AB0027
