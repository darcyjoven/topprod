# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: artg213.4gl
# Descriptions...: 盤點差異分析匯總表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B40049 11/04/13 by huangtao
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No:FUN-C40071 12/04/26 By xujing 明細類CR轉GR

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           wc        STRING,                #Where condition 
           type1     LIKE type_file.chr1,
           cb1       LIKE type_file.chr1, 
           cb2       LIKE type_file.chr1, 
           cb3       LIKE type_file.chr1,
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
    rtz10 LIKE rtz_file.rtz10,
    ryf02 LIKE ryf_file.ryf02,
    azw01 LIKE azw_file.azw01,
    azw08 LIKE azw_file.azw08,
    rux03 LIKE rux_file.rux03,
    ima02 LIKE ima_file.ima02,
    ima131 LIKE ima_file.ima131,
    oba02 LIKE oba_file.oba02,
    rux01 LIKE rux_file.rux01,
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
   LET tm.cb1  = ARG_VAL(9)
   LET tm.cb2  = ARG_VAL(10)
   LET tm.cb3  = ARG_VAL(11)
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
               "rtz10.rtz_file.rtz10,",
               "ryf02.ryf_file.ryf02,",
               "azw01.azw_file.azw01,",
               "azw08.azw_file.azw08,",
               "rux03.rux_file.rux03,",
               "ima02.ima_file.ima02,",
               "ima131.ima_file.ima131,",
               "oba02.oba_file.oba02,",
               "rux01.rux_file.rux01,",
               "rux04.rux_file.rux04,",
               "rux05.rux_file.rux05,",
               "rux06.rux_file.rux06,",
               "rux07.rux_file.rux07,",
               "rux08.rux_file.rux08,",
               "rtg05.rtg_file.rtg05,",
               "income.type_file.num10"
    LET l_table = cl_prt_temptable('artg213',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF         

    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artg213_tm()        # Input print condition
    ELSE 
       CALL artg213() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
    CALL cl_gre_drop_temptable(l_table)  #FUN-C40071 add
END MAIN

FUNCTION artg213_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE l_sql          STRING

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW artg213_w AT p_row,p_col WITH FORM "art/42f/artg213" 
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
   LET tm.cb1 = 'Y'
   LET tm.cb2 = 'N'
   LET tm.cb3 = 'N'  

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
                  LET g_qryparam.form = "q_azw01_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azw01 IN ",g_auth
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
               LET INT_FLAG = 0 CLOSE WINDOW artg213_w 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time
               CALL cl_gre_drop_temptable(l_table)  #FUN-C40071 add 
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
         LET INT_FLAG = 0 CLOSE WINDOW artg213_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071 add 
         EXIT PROGRAM
      END IF
      DISPLAY BY NAME tm.type1,tm.cb1,tm.cb2,tm.cb3,tm.more
      INPUT BY NAME
                tm.type1,tm.cb1,tm.cb2,tm.cb3,tm.more WITHOUT DEFAULTS  
          BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
             IF tm.cb2 = 'Y' THEN
               CALL  cl_set_comp_entry("cb3",TRUE)
             ELSE
               LET tm.cb3 = 'N' 
               CALL  cl_set_comp_entry("cb3",FALSE)
             END IF
             DISPLAY BY NAME tm.cb3
          AFTER FIELD type1

          ON CHANGE cb2
             IF tm.cb2 = 'Y' THEN
               CALL  cl_set_comp_entry("cb3",TRUE)
             ELSE
               LET tm.cb3 = 'N' 
               CALL  cl_set_comp_entry("cb3",FALSE)
             END IF
             DISPLAY BY NAME tm.cb3
             
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
          AFTER INPUT 
             IF INT_FLAG THEN
                LET INT_FLAG = 0 CLOSE WINDOW artg213_w 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time 
                CALL cl_gre_drop_temptable(l_table)  #FUN-C40071 add
                EXIT PROGRAM
             END IF
             IF tm.cb2 = 'Y' AND (tm.type1 = '3' OR tm.type1 = '5') THEN
                 CALL cl_err('','art-826',0)
                 NEXT FIELD type1
             END IF
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artg213_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071 add 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg213'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artg213','9031',1)
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
                       " '",tm.type1 CLIPPED,"'" ,
                       " '",tm.cb1 CLIPPED,"'" ,
                       " '",tm.cb2 CLIPPED,"'" ,
                       " '",tm.cb3 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg213',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg213_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071 add 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg213()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg213_w

END FUNCTION

FUNCTION artg213()
DEFINE    l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     STRING ,         # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          sr        RECORD 
                    rtz10      LIKE rtz_file.rtz10,
                    ruwplant   LIKE ruw_file.ruwplant,
                    rux03      LIKE rux_file.rux03,
                    ima02      LIKE ima_file.ima02,
                    ima131     LIKE ima_file.ima131,
                    rux01      LIKE rux_file.rux01,
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
DEFINE l_ryf02   LIKE ryf_file.ryf02
DEFINE l_azw08   LIKE azw_file.azw08
DEFINE l_oba02   LIKE oba_file.oba02
DEFINE l_rtg05   LIKE rtg_file.rtg05
DEFINE l_income  LIKE type_file.num10
DEFINE l_rux03   LIKE rux_file.rux03
DEFINE l_rux04   LIKE rux_file.rux04
DEFINE l_ima131  LIKE ima_file.ima131
DEFINE l_order1  LIKE type_file.num10

    DROP TABLE artg213_tmp
    CREATE TEMP TABLE artg213_tmp(
                order1 LIKE type_file.num10,
                rtz10  LIKE rtz_file.rtz10,
                ryf02  LIKE ryf_file.ryf02,
                azw01 LIKE azw_file.azw01,
                azw08 LIKE azw_file.azw08, 
                rux03 LIKE rux_file.rux03, 
                ima02 LIKE ima_file.ima02, 
                ima131 LIKE ima_file.ima131, 
                oba02 LIKE oba_file.oba02, 
                rux01 LIKE rux_file.rux01, 
                rux04 LIKE rux_file.rux04, 
                rux05 LIKE rux_file.rux05, 
                rux06 LIKE rux_file.rux06, 
                rux07 LIKE rux_file.rux07, 
                rux08 LIKE rux_file.rux08, 
                rtg05 LIKE rtg_file.rtg05, 
                income LIKE type_file.num10 )
    DELETE FROM artg213_tmp
     
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
        LET l_sql = " SELECT rtz10,ruwplant,rux03,ima02,ima131,rux01,rux04,rux05,rux06,rux07,rux08 FROM ",
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
#       LET l_sql = l_sql,"   UNION SELECT rtz10,ruwplant,rux03,ima02,ima131,rux01,rux04,rux05,rux06,rux07,rux08 FROM ",             #TQC-B70204 mark
        LET l_sql = l_sql,"   UNION ALL SELECT rtz10,ruwplant,rux03,ima02,ima131,rux01,rux04,rux05,rux06,rux07,rux08 FROM ",             #TQC-B70204
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
          LET l_sql = " SELECT rtz10,ruwplant,rux03,ima02,ima131,rux01,rux04,rux05,rux06,rux07,rux08 FROM ",
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
      PREPARE artg213_prepare1 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time   
         CALL cl_gre_drop_temptable(l_table)  #FUN-C40071 add 
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artg213_curs1 CURSOR FOR artg213_prepare1 
      FOREACH artg213_curs1 INTO sr.*  
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         LET l_sql = "SELECT ryf02 FROM ",cl_get_target_table(l_plant,'ryf_file'),
                     "  WHERE ryf01 = '",sr.rtz10,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ryf02_pre FROM l_sql 
         EXECUTE sel_ryf02_pre INTO l_ryf02
         IF cl_null(l_ryf02) OR STATUS THEN 
            LET l_ryf02 = ' '
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
         
         INSERT INTO artg213_tmp VALUES(0,sr.rtz10,l_ryf02,sr.ruwplant,l_azw08,sr.rux03,sr.ima02,sr.ima131,l_oba02,sr.rux01,
                 sr.rux04,sr.rux05,sr.rux06,sr.rux07,sr.rux08,l_rtg05,l_income)
      END FOREACH
   END FOREACH


   IF tm.cb2='Y' THEN
      IF tm.type1='1' THEN
         LET l_sql = "SELECT ima131,rux04,SUM(income) FROM artg213_tmp "
      END IF
      IF tm.type1='2' THEN
         LET l_sql = "SELECT ima131,rux04,SUM(rux08) FROM artg213_tmp "
      END IF
      IF tm.cb1 = 'Y' THEN
         LET l_sql = l_sql," WHERE rux08 <> 0 "
      END IF
      LET l_sql = l_sql," GROUP BY ima131,rux04 "
      IF tm.type1 = '1' OR tm.type1 = '2' THEN
         PREPARE sel_sum_pre1 FROM l_sql  
         DECLARE r213_sum_curs1 CURSOR FOR sel_sum_pre1
         FOREACH r213_sum_curs1 INTO l_ima131,l_rux04,l_order1
            IF l_ima131 IS NOT NULL AND l_rux04 IS NOT NULL THEN 
               UPDATE artg213_tmp SET order1 = l_order1
                WHERE ima131 = l_ima131
                  AND rux04 = l_rux04
            ELSE
               IF l_ima131 IS NULL AND l_rux04 IS NOT NULL THEN
                 UPDATE artg213_tmp SET order1 = l_order1
                  WHERE ima131 IS NULL
                    AND rux04 = l_rux04
               END IF
               IF l_ima131 IS NOT NULL AND l_rux04 IS NULL THEN
                  UPDATE artg213_tmp SET order1 = l_order1
                  WHERE ima131 = l_ima131
                    AND rux04 IS NULL
               END IF
               IF l_ima131 IS  NULL AND l_rux04 IS NULL THEN
                  UPDATE artg213_tmp SET order1 = l_order1
                  WHERE ima131 IS NULL
                    AND rux04 IS NULL
               END IF
            END IF
         END FOREACH 
      END IF
   END IF
    
   DECLARE r213_curs CURSOR FOR SELECT * FROM artg213_tmp
   FOREACH r213_curs INTO l_order1,sr.rtz10,l_ryf02,sr.ruwplant,l_azw08,sr.rux03,sr.ima02,sr.ima131,l_oba02,sr.rux01,
                 sr.rux04,sr.rux05,sr.rux06,sr.rux07,sr.rux08,l_rtg05,l_income
      EXECUTE insert_prep USING l_order1,sr.rtz10,l_ryf02,sr.ruwplant,l_azw08,sr.rux03,sr.ima02,sr.ima131,l_oba02,sr.rux01,
                 sr.rux04,sr.rux05,sr.rux06,sr.rux07,sr.rux08,l_rtg05,l_income
   END FOREACH

   LET g_str = ''
#  IF tm.cb2 = 'N' THEN                                                   #FUN-C40071 add
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#  END IF                                                                 #FUN-C40071 add
#  IF tm.cb2 = 'Y' THEN                                                   #FUN-C40071 add
#     LET l_sql = "SELECT order1,rtz10,ryf02,azw01,azw08,rux03,",         #FUN-C40071 add
#                 "ima02,ima131,oba02,rux01,rux04,SUM(rux05),SUM(rux06),",#FUN-C40071 add
#                 "SUM(rux07),SUM(rux08),rtg05,SUM(income)",              #FUN-C40071 add    
#                 " FROM ",g_cr_db_str CLIPPED,l_table CLIPPED            #FUN-C40071 add
#  END IF                                                                 #FUN-C40071 add
   IF tm.cb1 = 'Y' THEN
      LET l_sql = l_sql," WHERE rux08 <> 0 "
   END IF
#  IF tm.cb2 = 'Y' THEN                                      #FUN-C40071 add
#     LET l_sql = l_sql," GROUP BY order1,rtz10,ryf02,azw01,ima131,rux04,azw08,rux03,ima02,oba02,rux01,rtg05 " #FUN-C40071 add
#  END IF                                                    #FUN-C40071 add
   LET l_sql = l_sql," ORDER BY rtz10,azw01"
   IF tm.cb2 = 'N' THEN
      IF tm.type1 = '1' THEN LET l_sql = l_sql,",income " END IF
      IF tm.type1 = '2' THEN LET l_sql = l_sql,",rux08 " END IF
      IF tm.type1 = '3' THEN LET l_sql = l_sql,",rux03 " END IF
      IF tm.type1 = '4' THEN LET l_sql = l_sql,",ima131 " END IF
###GENGRE###      IF tm.type1 = '5' THEN LET l_sql = l_sql,",rux01 " END IF    #FUN-C40071 mark
      IF tm.type1 = '5' THEN LET l_sql = l_sql,",rux01 " END IF              #FUN-C40071 add
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
###GENGRE###   LET g_str = g_str,";",tm.type1,";",tm.cb1,';',tm.cb2,";",tm.cb3,";"
    CASE
      WHEN tm.cb2='N'
###GENGRE###         CALL cl_prt_cs3('artg213','artg213_1',l_sql,g_str) 
    LET g_template = 'artg213'    #FUN-C40071 add 
    CALL artg213_grdata(l_sql)    ###GENGRE###     #FUN-C40071 add (l_sql)
      WHEN tm.cb2='Y'
###GENGRE###         CALL cl_prt_cs3('artg213','artg213_2',l_sql,g_str) 
    LET g_template = 'artg213_1'  #FUN-C40071 add
#   CALL artg213_grdata()    ###GENGRE### #FUN-C40071 mark
    CALL artg213_1_grdata(l_sql)               #FUN-C40071 add
    END CASE

   
END FUNCTION


#FUN-B40049 






   


   


###GENGRE###START
FUNCTION artg213_grdata(p_sql)
    DEFINE p_sql    STRING                  #FUN-C40071 add                  
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg213")
        IF handler IS NOT NULL THEN
            START REPORT artg213_rep TO XML HANDLER handler
#           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED #FUN-C40071 mark 
          
#           DECLARE artg213_datacur1 CURSOR FROM l_sql  #FUN-C40071 mark
            DECLARE artg213_datacur1 CURSOR FROM p_sql  #FUN-C40071 add
            FOREACH artg213_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg213_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg213_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg213_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_rux06_rux07 LIKE rux_file.rux06
    
    ORDER EXTERNAL BY sr1.rtz10,sr1.azw01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company
                  ,g_ptime,g_user_name               #FUN-C40071 add
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.rtz10
        BEFORE GROUP OF sr1.azw01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            
            LET l_rux06_rux07 = sr1.rux06 + sr1.rux07
            PRINTX l_rux06_rux07
            PRINTX sr1.*

        AFTER GROUP OF sr1.rtz10
        AFTER GROUP OF sr1.azw01

        
        ON LAST ROW

END REPORT
###GENGRE###END

#FUN-C40071 add---str----
FUNCTION artg213_1_grdata(p_sql)
    DEFINE p_sql    STRING               #FUN-C40071 add
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg213_1")
        IF handler IS NOT NULL THEN
            START REPORT artg213_1_rep TO XML HANDLER handler
#           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-C40071 mark
           
#           DECLARE artg213_1_datacur1 CURSOR FROM l_sql                       #FUN-C40071 mark
            DECLARE artg213_1_datacur1 CURSOR FROM p_sql                       #FUN-C40071 add
            FOREACH artg213_1_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg213_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg213_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg213_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sql STRING
    DEFINE l_rux06_rux07 LIKE rux_file.rux06
    DEFINE sr2 sr1_t
    DEFINE l_rux05_sum   LIKE rux_file.rux05
    DEFINE l_rux06_sum   LIKE rux_file.rux06
    DEFINE l_rux07_sum   LIKE rux_file.rux07
    DEFINE l_rux08_sum   LIKE rux_file.rux08
    DEFINE l_income_sum  LIKE type_file.num10
    
    ORDER EXTERNAL BY sr1.rtz10,sr1.azw01,sr1.order1,
                      sr1.ima131,sr1.rux04
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.rtz10
        BEFORE GROUP OF sr1.azw01
        BEFORE GROUP OF sr1.order1
        BEFORE GROUP OF sr1.ima131
        BEFORE GROUP OF sr1.rux04
   #        LET l_sql =" SELECT order1,rtz10,ryf02,azw01,azw08,rux03,",       
   #                   "ima02,ima131,oba02,rux01,rux04,SUM(rux05),SUM(rux06),",
   #                   "SUM(rux07),SUM(rux08),rtg05,SUM(income)",            
   #                   " FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
            LET l_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE 1=1 "
   #        IF NOT cl_null(sr1.rux03) THEN
   #           LET l_sql=l_sql," AND rux03='",sr1.rux03,"'"
   #        END IF
            IF NOT cl_null(sr1.ima131) OR sr1.ima131 IS NOT NULL THEN
               LET l_sql=l_sql," AND ima131='",sr1.ima131,"'"
            END IF
            IF NOT cl_null(sr1.rux04) OR sr1.rux04 IS NOT NULL THEN
               LET l_sql=l_sql," AND rux04='",sr1.rux04,"'"
            END IF
            IF NOT cl_null(sr1.rtz10) OR sr1.rtz10 IS NOT NULL THEN
               LET l_sql=l_sql," AND rtz10='",sr1.rtz10,"'"
            END IF
            IF NOT cl_null(sr1.azw01) OR sr1.azw01 IS NOT NULL THEN
               LET l_sql=l_sql," AND azw01='",sr1.azw01,"'"
            END IF
            IF tm.cb1 = 'Y' THEN
               LET l_sql = l_sql," AND rux08 <> 0 "
            END IF
#           LET l_sql = l_sql," GROUP BY order1,rtz10,ryf02,azw01,ima131,rux04,azw08,rux03,ima02,oba02,rux01,rtg05"
            LET l_sql = l_sql," ORDER BY rtz10,azw01"
            START REPORT artg213_1_subrep01
            DECLARE artg213_1_repcur1 CURSOR FROM l_sql
        #   IF cl_null(sr2.rux05) THEN LET sr2.rux05=0 END IF
        #   IF cl_null(sr2.rux06) THEN LET sr2.rux06=0 END IF
        #   IF cl_null(sr2.rux07) THEN LET sr2.rux07=0 END IF
        #   IF cl_null(sr2.rux08) THEN LET sr2.rux08=0 END IF
        #   IF cl_null(sr2.income) THEN LET sr2.income=0 END IF
            FOREACH artg213_1_repcur1 INTO sr2.*
        #       LET sr1.rux05 = sr1.rux05+sr2.rux05
        #       LET sr1.rux06 = sr1.rux06+sr2.rux06
        #       LET sr1.rux07 = sr1.rux07+sr2.rux07
        #       LET sr1.rux08 = sr1.rux08+sr2.rux08
        #       LET sr1.income = sr1.income+sr2.income 
                OUTPUT TO REPORT artg213_1_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT artg213_1_subrep01

 
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            

     #      LET l_rux06_rux07 = sr1.rux06 + sr1.rux07
     #      PRINTX l_rux06_rux07
            PRINTX sr1.*


        AFTER GROUP OF sr1.rtz10
        AFTER GROUP OF sr1.azw01
        AFTER GROUP OF sr1.order1
        AFTER GROUP OF sr1.ima131
           LET l_rux05_sum = GROUP SUM(sr1.rux05)
           LET l_rux06_sum = GROUP SUM(sr1.rux06)
           LET l_rux07_sum = GROUP SUM(sr1.rux07)
           LET l_rux08_sum = GROUP SUM(sr1.rux08)
           LET l_income_sum = GROUP SUM(sr1.income) 
           LET l_rux06_rux07 = l_rux06_sum + l_rux07_sum
           PRINTX l_rux06_rux07,l_rux05_sum,l_rux06_sum,
                  l_rux07_sum,l_rux08_sum,l_income_sum
        AFTER GROUP OF sr1.rux04
        
        ON LAST ROW

END REPORT

REPORT artg213_1_subrep01(sr2)
    DEFINE sr2 sr1_t
    DEFINE l_rux06_rux07 LIKE rux_file.rux06
    DEFINE l_lineno LIKE type_file.num5   
 
    ORDER EXTERNAL BY sr2.rux03,sr2.rux04

    FORMAT
  #     BEFORE GROUP OF sr2.rux04
  #        LET l_rux06_rux07 = sr2.rux06 + sr2.rux07
  #         PRINTX l_rux06_rux07
  #         PRINTX sr2.*
        ON EVERY ROW
            LET l_rux06_rux07 = sr2.rux06 + sr2.rux07
            PRINTX l_rux06_rux07
            PRINTX sr2.*

END REPORT
#FUN-C40071 add---end
