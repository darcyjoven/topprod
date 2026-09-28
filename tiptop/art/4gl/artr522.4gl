# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artr522.4gl
# Descriptions...: 產品銷貨折價統計表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B70053 11/07/19 by huangtao
# Modify.........: No:FUN-B80140 11/08/23 By huangtao 錄入*查詢不到資料

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           wc        STRING,                #Where condition 
           cb1       LIKE type_file.chr1, 
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD

DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE g_chk_azw01   LIKE type_file.chr1
DEFINE g_chk_auth    STRING  
DEFINE g_azw01       LIKE azw_file.azw01 
DEFINE g_azw01_str     STRING  



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
   LET tm.cb1  = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql=  "ogb04.ogb_file.ogb04,",
               "ima02.ima_file.ima02,",
               "ogb12.ogb_file.ogb12,",
               "ogb05.ogb_file.ogb05,",
               "ogb14t.ogb_file.ogb14t,",
               "rxc03.rxc_file.rxc03,",
               "rxc06.rxc_file.rxc06,",
               "ima131.ima_file.ima131,",
               "oba02.oba_file.oba02"
              
    LET l_table = cl_prt_temptable('artr522',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?)" 
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF         

    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL artr522_tm()        # Input print condition
    ELSE 
       CALL artr522() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artr522_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,   
       l_cmd          STRING,
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_azw01       LIKE azw_file.azw01
DEFINE  l_n           LIKE type_file.num5
DEFINE l_sql          STRING

   LET p_row = 6 LET p_col = 16
   OPEN WINDOW artr522_w AT p_row,p_col WITH FORM "art/42f/artr522" 
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
   LET tm.cb1 = 'N'
 

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ogaplant,rtz10,oga02,ima131,ima01
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT 

         AFTER FIELD ogaplant
            LET g_chk_azw01 = TRUE 
            LET g_azw01_str = get_fldbuf(ogaplant)  
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
               WHEN INFIELD(ogaplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw01_1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " azw01 IN ",g_auth
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ogaplant
                  NEXT FIELD ogaplant
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
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
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
               LET INT_FLAG = 0 CLOSE WINDOW artr522_w 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time 
               EXIT PROGRAM
            END IF  
            IF cl_null(GET_FLDBUF(ogaplant)) OR GET_FLDBUF(ogaplant) = "*" THEN #FUN-B80140 add
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
         LET INT_FLAG = 0 CLOSE WINDOW artr522_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DISPLAY BY NAME tm.cb1,tm.more
      INPUT BY NAME tm.cb1,tm.more WITHOUT DEFAULTS  
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
         LET INT_FLAG = 0 CLOSE WINDOW artr522_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr522'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('artr522','9031',1)
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
                       " '",tm.cb1 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr522',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr522_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr522()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr522_w

END FUNCTION

FUNCTION artr522()
DEFINE    l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     STRING ,         # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,  
         
          sr        RECORD 
                    ogb04      LIKE ogb_file.ogb04,
                    ima02      LIKE ima_file.ima02,
                    ogb12      LIKE ogb_file.ogb12,
                    ogb05      LIKE ogb_file.ogb05,
                    ogb14t     LIKE ogb_file.ogb14t,
                    rxc03      LIKE rxc_file.rxc03,
                    rxc06      LIKE rxc_file.rxc06,
                    ima131     LIKE ima_file.ima131
                    END RECORD
DEFINE l_plant   LIKE  azp_file.azp01
DEFINE l_azp02   LIKE  azp_file.azp02
DEFINE l_oba02   LIKE  oba_file.oba02
DEFINE l_azi04   LIKE  azi_file.azi04

     
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
      LET tm.wc = cl_replace_str(tm.wc,"ohaplant","ogaplant")
      LET tm.wc = cl_replace_str(tm.wc,"oha02","oga02")
      LET l_sql = " SELECT ogb04,ima02,ogb12,ogb05,ogb14t,rxc03,rxc06,ima131 FROM ",
                          cl_get_target_table(l_plant,'oga_file'),",",
                          cl_get_target_table(l_plant,'rtz_file'),",",
                          cl_get_target_table(l_plant,'ogb_file'),
                          " LEFT JOIN ",cl_get_target_table(l_plant,'rxc_file'),
                          " ON rxc00 = '02' AND rxc01 = ogb01 AND rxc02 = ogb03 ",
                          " LEFT JOIN ",cl_get_target_table(l_plant,'ima_file'),
                          " ON ogb04 = ima01 ",
                          " WHERE oga01 = ogb01 ",
                          " AND oga09 IN ('2','3','4','6') AND ogapost = 'Y' ",
                          "   AND ogaplant = rtz01 AND  ogaplant = '",l_plant,"'",
                          "   AND ",tm.wc CLIPPED   
      IF tm.cb1= 'N' THEN
         LET l_sql = l_sql," AND ogb14t>=0 "
      END IF
     LET tm.wc = cl_replace_str(tm.wc,"ogaplant","ohaplant")
     LET tm.wc = cl_replace_str(tm.wc,"oga02","oha02")
     LET l_sql = l_sql," UNION ALL SELECT ohb04,ima02,(-1)*ohb12,ohb05,(-1)*ohb14t,rxc03,(-1)*rxc06,ima131 FROM ",
                    cl_get_target_table(l_plant,'oha_file'),",",
                    cl_get_target_table(l_plant,'rtz_file'),",",
                    cl_get_target_table(l_plant,'ohb_file'),
                    " LEFT JOIN ",cl_get_target_table(l_plant,'rxc_file'),
                    " ON rxc00 = '03' AND rxc01 = ohb01 AND rxc02 = ohb03 ",
                    " LEFT JOIN ",cl_get_target_table(l_plant,'ima_file'),
                    " ON ohb04 = ima01 ",
                    " WHERE oha01 = ohb01  ",
                    " AND oha05 IN ('1','2') AND ohapost = 'Y' ",
                    "   AND ohaplant = rtz01 AND ohaplant = '",l_plant,"'",
                    "   AND ",tm.wc CLIPPED
      IF tm.cb1= 'N' THEN
         LET l_sql = l_sql," AND ohb14t<0 "
      END IF  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
      PREPARE artr522_prepare1 FROM l_sql                  
      IF SQLCA.sqlcode != 0 THEN                           
         CALL cl_err('prepare:',SQLCA.sqlcode,1)           
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    
         EXIT PROGRAM                                      
      END IF                                               
      DECLARE artr522_curs1 CURSOR FOR artr522_prepare1 
      FOREACH artr522_curs1 INTO sr.*  
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = sr.ima131
         IF STATUS OR cl_null(l_oba02) THEN LET l_oba02 = ' ' END IF
         EXECUTE insert_prep USING sr.*,l_oba02
      END FOREACH
   END FOREACH


   LET g_str = ''  
   LET l_sql = "SELECT ogb04,ima02,SUM(ogb12) ogb12,ogb05,SUM(rxc06) s_rxc06,",
               "SUM(ogb14t) ogb14t,rxc03,SUM(rxc06) rxc06,ima131,oba02 FROM ",
               g_cr_db_str CLIPPED,l_table CLIPPED,
               " GROUP BY ima131,oba02,ogb04,ima02,ogb05,rxc03" 

   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ogaplant,oga02,rtz10,ima01,ima131')
             RETURNING tm.wc
        LET g_str = tm.wc
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
   LET g_str = g_str,";",tm.cb1,";",l_azi04,";"
   CALL cl_prt_cs3('artr522','artr522',l_sql,g_str)  
    
END FUNCTION
#FUN-B70053


   
