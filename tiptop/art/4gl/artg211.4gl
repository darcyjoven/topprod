# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artg211.4gl
# Descriptions...: 盤點差異分析匯總表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B40023 11/04/13 by huangtao
# Modify.........: No.FUN-B40049 11/05/05 By huangtao 營運中心開窗抓取到最下級營運中心
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No.FUN-C40071 12/04/24 By xianghui CR-->GR

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           wc        STRING,                #Where condition 
           type1     LIKE type_file.chr1,
           type2     LIKE type_file.chr1, 
           cb1       LIKE type_file.chr1, 
           cb2       LIKE type_file.chr1, 
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD

DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE g_chk_azw01   LIKE type_file.chr1
DEFINE g_chk_auth    STRING  
DEFINE g_azw01       LIKE azw_file.azw01 
DEFINE g_azw01_str     STRING  



###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.num10,
    azw01 LIKE azw_file.azw01,
    azw08 LIKE azw_file.azw08,
    rux03 LIKE rux_file.rux03,
    ima02 LIKE ima_file.ima02,
    ima131 LIKE ima_file.ima131,
    oba02 LIKE oba_file.oba02,
    rux01 LIKE rux_file.rux01,
    rux02 LIKE rux_file.rux02,
    rux04 LIKE rux_file.rux04,
    rux05 LIKE rux_file.rux05,
    rux06 LIKE rux_file.rux06,
    rux07 LIKE rux_file.rux07,
    rux08 LIKE rux_file.rux08,
    rtg05 LIKE rtg_file.rtg05,
    income LIKE type_file.num10
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
   LET tm.type1  = ARG_VAL(8) 
   LET tm.type2   = ARG_VAL(9)
   LET tm.cb1  = ARG_VAL(10)
   LET tm.cb2  = ARG_VAL(11)
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
   LET g_sql=  "order1.type_file.num10,",
               "azw01.azw_file.azw01,",
               "azw08.azw_file.azw08,",
               "rux03.rux_file.rux03,",
               "ima02.ima_file.ima02,",
               "ima131.ima_file.ima131,",
               "oba02.oba_file.oba02,",
               "rux01.rux_file.rux01,",
               "rux02.rux_file.rux02,",
               "rux04.rux_file.rux04,",
               "rux05.rux_file.rux05,",
               "rux06.rux_file.rux06,",
               "rux07.rux_file.rux07,",
               "rux08.rux_file.rux08,",
               "rtg05.rtg_file.rtg05,",
               "income.type_file.num10"
    LET l_table = cl_prt_temptable('artg211',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF         

    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artg211_tm()        # Input print condition
    ELSE 
       CALL artg211() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artg211_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          STRING,
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE l_sql          STRING

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW artg211_w AT p_row,p_col WITH FORM "art/42f/artg211" 
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
   LET tm.type1 = '1'  
   LET tm.type2 = '1' 
   LET tm.cb1 = 'Y'
   LET tm.cb2 = 'N'  

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ruw02,ruw04,ruwplant,rtz10,ima131,rty05
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT 

         AFTER FIELD ruwplant
            LET g_chk_azw01 = TRUE 
            LET g_azw01_str = get_fldbuf(ruwplant)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_azw01_str) AND g_azw01_str <> "*" THEN
               LET g_chk_azw01 = FALSE 
               LET tok = base.StringTokenizer.create(g_azw01_str,"|") 
               LET g_azw01 = ""
               WHILE tok.hasMoreTokens() 
                   LET g_azw01 = tok.nextToken()
                 #FUN-B40049 -------------STA
                 #     SELECT COUNT(*) INTO l_n FROM azw_file
                 #      WHERE azw01 = g_azw01
                 #        AND azw07 = g_plant 
                 #         OR azw01 = g_plant
                   LET l_sql = " SELECT COUNT(*) FROM azw_file",
                               " WHERE azw01 ='",g_azw01,"'",
                               " AND azw01 IN ",g_auth,
                               " AND azwacti = 'Y'"
                   PREPARE sel_num_pre FROM l_sql
                   EXECUTE sel_num_pre INTO l_n 
                 #FUN-B40049 -------------END
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
            IF g_chk_azw01 THEN
                LET g_chk_auth = g_auth
            END IF
         ON ACTION controlp
            CASE
               WHEN INFIELD(ruw02)
                  CALL q_rus(TRUE,TRUE,g_plant,'','','') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruw02
                  NEXT FIELD ruw02
               WHEN INFIELD(ruwplant)
                  CALL cl_init_qry_var()
                  #FUN-B40049 ------------STA
                  #LET g_qryparam.form = "q_azw01_2"
                  #LET g_qryparam.state = "c"
                  #LET g_qryparam.arg1 = g_plant
                  LET g_qryparam.form = "q_azw01_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  #FUN-B40049 -------------END
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruwplant
                  NEXT FIELD ruwplant
               WHEN INFIELD(rtz10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ryf"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rtz10
                  NEXT FIELD rtz10  
               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oba_13"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
               WHEN INFIELD(rty05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc18"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rty05
                  NEXT FIELD rty05
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
               LET INT_FLAG = 0 CLOSE WINDOW artg211_w 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time 
               EXIT PROGRAM
            END IF  
            IF cl_null(GET_FLDBUF(ruwplant)) THEN
                CALL cl_err('','art-825',0)
                NEXT FIELD ruwplant
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
         LET INT_FLAG = 0 CLOSE WINDOW artg211_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DISPLAY BY NAME tm.type1,tm.type2,tm.cb1,tm.cb2,tm.more
      INPUT BY NAME
                tm.type1,tm.type2,tm.cb1,tm.cb2,tm.more WITHOUT DEFAULTS  
          BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
          AFTER FIELD type1                                               
             IF tm.type1 NOT MATCHES '[12]' THEN NEXT FIELD type1 END IF
          AFTER FIELD type2
             IF tm.type2 NOT MATCHES '[1234]' THEN NEXT FIELD type2 END IF
             IF (tm.type1 = '1' AND tm.type2 = '4')
               OR (tm.type1 = '2' AND tm.type2 = '3') THEN
               CALL cl_err('','art-860',0)
               NEXT FIELD type2
             END IF
          AFTER FIELD more
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
         LET INT_FLAG = 0 CLOSE WINDOW artg211_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg211'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('artg211','9031',1)
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
                       " '",tm.type1 CLIPPED,"'" ,
                       " '",tm.type2 CLIPPED,"'" ,
                       " '",tm.cb1 CLIPPED,"'" ,
                       " '",tm.cb2 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg211',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg211_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg211()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg211_w

END FUNCTION

FUNCTION artg211()
DEFINE    l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     STRING ,         # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          sr        RECORD 
                    ruwplant   LIKE ruw_file.ruwplant,
                    rux03      LIKE rux_file.rux03,
                    ima02      LIKE ima_file.ima02,
                    ima131     LIKE ima_file.ima131,
                    rux01      LIKE rux_file.rux01,
                    rux02      LIKE rux_file.rux02,
                    rux04      LIKE rux_file.rux04,
                    rux05      LIKE rux_file.rux05,
                    rux06      LIKE rux_file.rux06,
                    rux07      LIKE rux_file.rux07,
                    rux08      LIKE rux_file.rux08
                    END RECORD
DEFINE l_plant   LIKE  azp_file.azp01
DEFINE l_azp02   LIKE  azp_file.azp02
DEFINE l_i       LIKE  type_file.num5
DEFINE l_j       LIKE  type_file.num5
DEFINE l_m       LIKE  type_file.num5
DEFINE  l_str    STRING
DEFINE l_azw08   LIKE azw_file.azw08
DEFINE l_oba02   LIKE oba_file.oba02
DEFINE l_rtg05   LIKE  rtg_file.rtg05
DEFINE l_income  LIKE  type_file.num10
DEFINE l_rux03   LIKE rux_file.rux03
DEFINE l_rux04   LIKE rux_file.rux04
DEFINE l_ima131  LIKE ima_file.ima131
DEFINE l_order1  LIKE type_file.num10
#FUN-C40071-add-str--
DEFINE l_rux05   LIKE rux_file.rux05
DEFINE l_rux06   LIKE rux_file.rux06
DEFINE l_rux07   LIKE rux_file.rux07
DEFINE l_rux08   LIKE rux_file.rux08
#FUN-C40071-add-end--

    DROP TABLE artg211_tmp
    CREATE TEMP TABLE artg211_tmp(
                order1 LIKE type_file.num10,
                azw01 LIKE azw_file.azw01,
                azw08 LIKE azw_file.azw08, 
                rux03 LIKE rux_file.rux03, 
                ima02 LIKE ima_file.ima02, 
                ima131 LIKE ima_file.ima131, 
                oba02 LIKE oba_file.oba02, 
                rux01 LIKE rux_file.rux01, 
                rux02 LIKE rux_file.rux02, 
                rux04 LIKE rux_file.rux04, 
                rux05 LIKE rux_file.rux05, 
                rux06 LIKE rux_file.rux06, 
                rux07 LIKE rux_file.rux07, 
                rux08 LIKE rux_file.rux08, 
                rtg05 LIKE rtg_file.rtg05, 
                income LIKE type_file.num10 )
    DELETE FROM artg211_tmp
     
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
    CALL cl_del_data(l_table)
    LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth,
                " ORDER BY azp01 "
    PREPARE sel_azp01_pre FROM l_sql
    DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre           
    FOREACH sel_azp01_cs INTO l_plant,l_azp02 
      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      LET tm.wc = cl_replace_str(tm.wc,"ima54","rty05")
      LET l_i = tm.wc.getIndexOf('rty05',1) 
      IF l_i THEN
        LET l_sql = " SELECT ruwplant,rux03,ima02,ima131,rux01,rux02,rux04,rux05,rux06,rux07,rux08 FROM ",
                    cl_get_target_table(l_plant,'ruw_file'),",",
                    cl_get_target_table(l_plant,'rux_file'),",",
                    cl_get_target_table(l_plant,'ima_file'),",",
                    cl_get_target_table(l_plant,'rtz_file'),",",
                    cl_get_target_table(l_plant,'rty_file'),
                    " WHERE ruw00 = rux00 AND ruw01 = rux01 ",
                    "   AND ruw00 = '1' AND rux03 = ima01 ",
                    "   AND ruwplant = rtz01 AND ruwplant = rty01 ",
                    "   AND rux03 = rty02 AND ruwplant = '",l_plant,"'",
                    "   AND ",tm.wc CLIPPED
        IF NOT tm.wc.getIndexOf('rty05=',1) THEN
           LET l_m = tm.wc.getIndexOf('in',l_i)
           LET l_j =  tm.wc.getIndexOf(')',l_m)
        ELSE
           LET l_j =  tm.wc.getIndexOf(' ',l_i)
        END IF
        LET l_str = tm.wc.subString(l_i,l_j) 
        LET tm.wc = cl_replace_str(tm.wc,"rty05","ima54")
#       LET l_sql = l_sql,"   UNION SELECT ruwplant,rux03,ima02,ima131,rux01,rux02,rux04,rux05,rux06,rux07,rux08 FROM ",    #TQC-B70204 mark
        LET l_sql = l_sql,"   UNION ALL SELECT ruwplant,rux03,ima02,ima131,rux01,rux02,rux04,rux05,rux06,rux07,rux08 FROM ",    #TQC-B70204
                          cl_get_target_table(l_plant,'ruw_file'),",",
                          cl_get_target_table(l_plant,'rux_file'),",",
                          cl_get_target_table(l_plant,'ima_file'),",",
                          cl_get_target_table(l_plant,'rtz_file'),
                          " WHERE ruw00 = rux00 AND ruw01 = rux01 ",
                          "   AND ruw00 = '1' AND rux03 = ima01 ",
                          "   AND ruwplant = rtz01 AND  ruwplant = '",l_plant,"'",
                          "   AND rux03 NOT IN (SELECT rty02 FROM ",cl_get_target_table(l_plant,'rty_file'),
                                                " WHERE rty01 = '",l_plant,"'",
                                                " AND ",l_str,")",
                          "   AND ",tm.wc CLIPPED   
      ELSE
          LET l_sql = " SELECT ruwplant,rux03,ima02,ima131,rux01,rux02,rux04,rux05,rux06,rux07,rux08 FROM ",
                    cl_get_target_table(l_plant,'ruw_file'),",",
                    cl_get_target_table(l_plant,'rux_file'),",",
                    cl_get_target_table(l_plant,'ima_file'),",",
                    cl_get_target_table(l_plant,'rtz_file'),
                    " WHERE ruw00 = rux00 AND ruw01 = rux01 ",
                    "   AND ruw00 = '1' AND rux03 = ima01 ",
                    "   AND ruwplant = rtz01 AND ruwplant = '",l_plant,"'",
                    "   AND ",tm.wc CLIPPED
      END IF      
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
      PREPARE artg211_prepare1 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artg211_curs1 CURSOR FOR artg211_prepare1 
      FOREACH artg211_curs1 INTO sr.*  
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         LET l_sql = "SELECT azw08 FROM ",cl_get_target_table(l_plant,'azw_file'),
                     " WHERE azw01 = '",sr.ruwplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_azw08_pre FROM l_sql
         EXECUTE sel_azw08_pre INTO l_azw08
         IF cl_null(l_azw08) OR STATUS THEN 
            LET l_azw08 = ' '
         END IF
         LET l_sql = "SELECT oba02  FROM ",cl_get_target_table(l_plant,'oba_file'),
                     " WHERE oba01 = '",sr.ima131,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_oba02_pre FROM l_sql
         EXECUTE sel_oba02_pre INTO l_oba02
         IF cl_null(l_oba02) OR STATUS THEN
            LET l_oba02 = ' '
         END IF
         LET l_sql = "SELECT rtg05 FROM ",cl_get_target_table(l_plant,'rtz_file'),",",
                                         cl_get_target_table(l_plant,'rtg_file'),
                     " WHERE rtz01 ='",l_plant,"'",
                     " AND rtz05 = rtg01 ",
                     " AND rtg03 = '",sr.rux03,"'",
                     " AND rtg04 = '",sr.rux04,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_rtg05_pre FROM l_sql
         EXECUTE sel_rtg05_pre INTO l_rtg05
         IF cl_null(l_rtg05) OR STATUS THEN
            LET l_rtg05 = 0
         END IF
         LET l_income =l_rtg05*sr.rux08 
         INSERT INTO artg211_tmp VALUES(0,sr.ruwplant,l_azw08,sr.rux03,sr.ima02,sr.ima131,l_oba02,sr.rux01,sr.rux02,
                 sr.rux04,sr.rux05,sr.rux06,sr.rux07,sr.rux08,l_rtg05,l_income)
      END FOREACH
   END FOREACH

   IF tm.type1='1' THEN 
      IF tm.type2='1' THEN
         LET l_sql = "SELECT rux03,rux04,SUM(income) FROM artg211_tmp "
      END IF
      IF tm.type2='2' THEN
         LET l_sql = "SELECT rux03,rux04,SUM(rux08) FROM artg211_tmp "
      END IF
      IF tm.cb1  = 'Y' THEN
         LET l_sql = l_sql," WHERE rux08 <> 0 "
      END IF
      LET l_sql = l_sql," GROUP BY rux03,rux04 "
      IF tm.type2 = '1' OR tm.type2 = '2' THEN
         PREPARE sel_sum_pre FROM l_sql  
         DECLARE g211_sum_curs CURSOR FOR sel_sum_pre
         FOREACH g211_sum_curs INTO l_rux03,l_rux04,l_order1
            UPDATE artg211_tmp SET order1 = l_order1
             WHERE rux03 = l_rux03
               AND rux04 = l_rux04
         END FOREACH
      END IF
   END IF
   IF tm.type1='2' THEN
      IF tm.type2='1' THEN
         LET l_sql = "SELECT ima131,rux04,SUM(income) FROM artg211_tmp " 
      END IF
      IF tm.type2='2' THEN
         LET l_sql = "SELECT ima131,rux04,SUM(rux08) FROM artg211_tmp " 
      END IF
      IF tm.cb1 = 'Y' THEN
         LET l_sql = l_sql," WHERE rux08 <> 0 "
      END IF
      LET l_sql = l_sql," GROUP BY ima131,rux04 "
      IF tm.type2 = '1' OR tm.type2 = '2' THEN
         PREPARE sel_sum_pre1 FROM l_sql  
         DECLARE g211_sum_curs1 CURSOR FOR sel_sum_pre1
         FOREACH g211_sum_curs1 INTO l_ima131,l_rux04,l_order1
           IF l_ima131 IS NOT NULL AND l_rux04 IS NOT NULL THEN 
             UPDATE artg211_tmp SET order1 = l_order1
              WHERE ima131 = l_ima131
                AND rux04 = l_rux04
           ELSE
               IF l_ima131 IS NULL AND l_rux04 IS NOT NULL THEN
                 UPDATE artg211_tmp SET order1 = l_order1
                  WHERE ima131 IS NULL
                    AND rux04 = l_rux04
               END IF
               IF l_ima131 IS NOT NULL AND l_rux04 IS NULL THEN
                  UPDATE artg211_tmp SET order1 = l_order1
                  WHERE ima131 = l_ima131
                    AND rux04 IS NULL
               END IF
               IF l_ima131 IS  NULL AND l_rux04 IS NULL THEN
                  UPDATE artg211_tmp SET order1 = l_order1
                  WHERE ima131 IS NULL
                    AND rux04 IS NULL
               END IF
            END IF
         END FOREACH 
      END IF
   END IF
    
   DECLARE g211_curs CURSOR FOR SELECT * FROM artg211_tmp
   FOREACH g211_curs INTO l_order1,sr.ruwplant,l_azw08,sr.rux03,sr.ima02,sr.ima131,l_oba02,sr.rux01,sr.rux02,
                 sr.rux04,sr.rux05,sr.rux06,sr.rux07,sr.rux08,l_rtg05,l_income
      EXECUTE insert_prep USING l_order1,sr.ruwplant,l_azw08,sr.rux03,sr.ima02,sr.ima131,l_oba02,sr.rux01,sr.rux02,
                 sr.rux04,sr.rux05,sr.rux06,sr.rux07,sr.rux08,l_rtg05,l_income
   END FOREACH

   LET g_str = ''  
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   IF tm.cb1 = 'Y' THEN
      LET l_sql = l_sql," WHERE rux08 <> 0 "
   END IF
   IF tm.type2 = '1' OR tm.type2 = '2' THEN 
       LET l_sql = l_sql," ORDER BY order1"
   END IF
   IF tm.type2 = '3' THEN
       LET l_sql = l_sql," ORDER BY rux03"
   END IF
   IF tm.type2 = '4' THEN
      LET l_sql = l_sql," ORDER BY ima131"
   END IF
   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ruw02,ruw04,ruwplant,rtz10,ima131,rty05')
             RETURNING tm.wc
        LET g_str = tm.wc
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
###GENGRE###   LET g_str = g_str,";",tm.type1,";",tm.type2,';',tm.cb1,";",tm.cb2,";"
    CASE
      WHEN tm.type1='1'
###GENGRE###         CALL cl_prt_cs3('artg211','artg211_1',l_sql,g_str)  
         LET g_template = 'artg211'    #FUN-C40071 add
         CALL artg211_grdata()    ###GENGRE###
      WHEN tm.type1='2'
###GENGRE###         CALL cl_prt_cs3('artg211','artg211_2',l_sql,g_str) 
         LET g_template = 'artg211_1'    #FUN-C40071 add
         CALL artg211_1_grdata()    ###GENGRE###
    END CASE

   
END FUNCTION
#FUN-B40023


   


###GENGRE###START
FUNCTION artg211_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg211")
        IF handler IS NOT NULL THEN
            START REPORT artg211_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
            #FUN-C40071-add-str--
            IF tm.cb1 = 'Y' THEN
               LET l_sql = l_sql," WHERE rux08 <> 0 "
            END IF
            IF tm.type2 = '1' OR tm.type2 = '2' THEN
                LET l_sql = l_sql," ORDER BY order1,rux03,rux04"
            END IF
            IF tm.type2 = '3' THEN
                LET l_sql = l_sql," ORDER BY rux03"
            END IF
            IF tm.type2 = '4' THEN
               LET l_sql = l_sql," ORDER BY ima131"
            END IF          
            #FUN-C40071-add-str--
            DECLARE artg211_datacur1 CURSOR FROM l_sql
            FOREACH artg211_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg211_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg211_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION
REPORT artg211_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE sr2 sr1_t                               #FUN-C40071
    DEFINE sr2_o sr1_t                             #FUN-C40071
    DEFINE l_rux06_07_show  LIKE rux_file.rux06    #FUN-C40071
    DEFINE l_sql     STRING                        #FUN-C40071
    DEFINE l_rux05_sum  LIKE rux_file.rux05        #FUN-C40071
    DEFINE l_rux06_07_sum LIKE rux_file.rux06      #FUN-C40071
    DEFINE l_rux08_sum  LIKE rux_file.rux08        #FUN-C40071
    DEFINE l_income_sum LIKE type_file.num10       #FUN-C40071
    
    ORDER EXTERNAL BY sr1.order1,sr1.rux03,sr1.rux04
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name      #FUN-C40071  add g_ptime,g_user_name
            PRINTX tm.*
            LET sr2_o.azw01 =NULL     #FUN-C40071
              
        BEFORE GROUP OF sr1.rux04 
           #FUN-C40071--add-str--
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " WHERE rux03='",sr1.rux03,"'",
                       "   AND rux04='",sr1.rux04,"'" 
           IF tm.cb1 = 'Y' THEN
              LET l_sql = l_sql," AND rux08 <> 0 ORDER BY azw01,rux01"
           END IF
           START REPORT artg211_subrep01
           DECLARE artg211_repcur1 CURSOR FROM l_sql
           FOREACH artg211_repcur1 INTO sr2.*
              OUTPUT TO REPORT artg211_subrep01(sr2.*,sr2_o.*)
              LET sr2_o.* = sr2.*  
           END FOREACH 
           FINISH REPORT artg211_subrep01

           LET l_rux06_07_show = sr1.rux06 + sr1.rux07
           PRINTX l_rux06_07_show
           #FUN-C40071--add--end--   

        ON EVERY ROW
           LET l_lineno = l_lineno + 1
           PRINTX l_lineno

           PRINTX sr1.*
 
        AFTER GROUP OF sr1.rux04
           LET l_rux05_sum = GROUP SUM(sr1.rux05)
           LET l_rux06_07_sum = GROUP SUM(sr1.rux06)+GROUP SUM(sr1.rux07)
           LET l_rux08_sum = GROUP SUM(sr1.rux08)
           LET l_income_sum = GROUP SUM(sr1.income)
           PRINTX l_rux05_sum,l_rux06_07_sum,l_rux08_sum,l_income_sum
           LET sr2_o.azw01 = NULL

        ON LAST ROW

END REPORT
###GENGRE###END

#FUN-C40071--add--str--
REPORT artg211_subrep01(sr2,sr2_o)
   DEFINE sr2  sr1_t
   DEFINE l_rux06_07_show   LIKE rux_file.rux06
   DEFINE l_display   STRING
   DEFINE sr2_o sr1_t

   ORDER EXTERNAL BY sr2.azw01,sr2.rux01
   FORMAT
      ON EVERY ROW 
         IF NOT cl_null(sr2_o.azw01) THEN
            IF sr2_o.azw01 != sr2.azw01  THEN
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF
         ELSE
            LET l_display = 'Y'
         END IF
         PRINTX l_display
      
         LET l_rux06_07_show = sr2.rux06 + sr2.rux07
         PRINTX l_rux06_07_show

         PRINTX sr2.*

END REPORT
#FUN-C40071--add--end--

#FUN-C40071--------------------BEGIN------------------------
FUNCTION artg211_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg211")
        IF handler IS NOT NULL THEN
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
            IF tm.cb1 = 'Y' THEN
               LET l_sql = l_sql," WHERE rux08 <> 0 "
            END IF
            IF tm.type2 = '1' OR tm.type2 = '2' THEN
                LET l_sql = l_sql," ORDER BY order1,ima131,rux04"
            END IF
            IF tm.type2 = '3' THEN
                LET l_sql = l_sql," ORDER BY rux03"
            END IF
            IF tm.type2 = '4' THEN
               LET l_sql = l_sql," ORDER BY ima131"
            END IF
            START REPORT artg211_1_rep TO XML HANDLER handler
            DECLARE artg211_1_datacur1 CURSOR FROM l_sql
            FOREACH artg211_1_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg211_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg211_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION
REPORT artg211_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE sr2 sr1_t                             
    DEFINE sr2_o sr1_t                          
    DEFINE l_rux06_07_show  LIKE rux_file.rux06
    DEFINE l_sql     STRING                   
    DEFINE l_rux05_sum  LIKE rux_file.rux05  
    DEFINE l_rux06_07_sum LIKE rux_file.rux06
    DEFINE l_rux08_sum  LIKE rux_file.rux08  
    DEFINE l_income_sum LIKE type_file.num10 


    ORDER EXTERNAL BY sr1.order1,sr1.ima131,sr1.rux04

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX tm.*
            LET sr2_o.azw01 =NULL   

        BEFORE GROUP OF sr1.order1
        BEFORE GROUP OF sr1.ima131
        BEFORE GROUP OF sr1.rux04
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " WHERE ima131='",sr1.ima131,"'",
                       "   AND rux04='",sr1.rux04,"'"
           IF tm.cb1 = 'Y' THEN
              LET l_sql = l_sql," AND rux08 <> 0 ORDER BY rux02"
           END IF
           START REPORT artg211_1_subrep01
           DECLARE artg211_1_repcur1 CURSOR FROM l_sql
           FOREACH artg211_1_repcur1 INTO sr2.*
              OUTPUT TO REPORT artg211_1_subrep01(sr2.*,sr2_o.*)
              LET sr2_o.* = sr2.*
           END FOREACH
           FINISH REPORT artg211_1_subrep01

        ON EVERY ROW
           LET l_lineno = l_lineno + 1
           PRINTX l_lineno

           PRINTX sr1.*

        AFTER GROUP OF sr1.order1
        AFTER GROUP OF sr1.ima131
        AFTER GROUP OF sr1.rux04
           LET l_rux05_sum = GROUP SUM(sr1.rux05)
           LET l_rux06_07_sum = GROUP SUM(sr1.rux06)+GROUP SUM(sr1.rux07)
           LET l_rux08_sum = GROUP SUM(sr1.rux08)
           LET l_income_sum = GROUP SUM(sr1.income)
           PRINTX l_rux05_sum,l_rux06_07_sum,l_rux08_sum,l_income_sum
           LET sr2_o.azw01 = NULL

        ON LAST ROW

END REPORT

REPORT artg211_1_subrep01(sr2,sr2_o)
   DEFINE sr2  sr1_t
   DEFINE l_rux06_07_show   LIKE rux_file.rux06
   DEFINE l_display   STRING
   DEFINE sr2_o sr1_t
   DEFINE l_rux05_sum  LIKE rux_file.rux05        #FUN-C40071
   DEFINE l_rux06_07_sum LIKE rux_file.rux06      #FUN-C40071
   DEFINE l_rux08_sum  LIKE rux_file.rux08        #FUN-C40071
   DEFINE l_income_sum LIKE type_file.num10       #FUN-C40071

   ORDER EXTERNAL BY sr2.azw01
   FORMAT

      BEFORE GROUP OF sr2.azw01
         IF NOT cl_null(sr2_o.azw01) THEN
            IF sr2_o.azw01 != sr2.azw01  THEN
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF
         ELSE
            LET l_display = 'Y'
         END IF
         PRINTX l_display

         PRINTX sr2.*
    
      AFTER GROUP OF sr2.azw01
         LET l_rux05_sum = GROUP SUM(sr2.rux05)
         LET l_rux06_07_sum = GROUP SUM(sr2.rux06)+GROUP SUM(sr2.rux07)
         LET l_rux08_sum = GROUP SUM(sr2.rux08)
         LET l_income_sum = GROUP SUM(sr2.income)
         PRINTX l_rux05_sum,l_rux06_07_sum,l_rux08_sum,l_income_sum

END REPORT
#FUN-C40071---------------------END-------------------------
