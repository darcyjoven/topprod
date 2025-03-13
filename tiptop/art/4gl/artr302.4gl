# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: artr302.4gl
# Descriptions...: 產品編號統計表       
# Date & Author..: #FUN-A70005 10/07/12 By lixh1 
# Modify.........: No.TQC-BB0034 11/11/14 By suncx 報表功能完善

DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD                          # Print condition RECORD
              wc1      STRING,     
              wc       STRING,   
              w        LIKE type_file.chr1,   #TQC-BB0034
              x        LIKE type_file.chr1,   #TQC-BB0034
              s        LIKE type_file.chr3, 
              t        LIKE type_file.chr1,
              more     LIKE type_file.chr1    # Input more condition(Y/N)
              END RECORD
   DEFINE l_table      STRING,                  
          g_str        STRING,                  
          g_sql        STRING 
   DEFINE g_chk_auth   STRING 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
    LET g_sql = "rvuplant.rvu_file.rvuplant,",
                "azp02.azp_file.azp02,",
                "rvv39t.rvv_file.rvv39t,",
                "ima131.ima_file.ima131,",
                "oba02.oba_file.oba02,",
                "rvv31.rvv_file.rvv31,",
                "ima02.ima_file.ima02,",
                "rvv35.rvv_file.rvv35,",  #TQC-BB0034
                "rvv17.rvv_file.rvv17,",
                "rvu04.rvu_file.rvu04,",
                "rvu05.rvu_file.rvu05,",
                "rvu03.rvu_file.rvu03"

    LET l_table = cl_prt_temptable('artr302',g_sql) CLIPPED    # 產生Temp Table                                                      
    IF  l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"    #TQC-BB0034 add ?                                                                            
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF 
   LET g_pdate = ARG_VAL(1)                # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.w  = ARG_VAL(8)  #TQC-BB0034
   LET tm.x  = ARG_VAL(9)  #TQC-BB0034
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL artr302_tm(0,0)            # Input print condition
      ELSE CALL artr302()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN 

FUNCTION artr302_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   
   DEFINE p_row,p_col   LIKE type_file.num5,         
          l_cmd         LIKE type_file.chr1000
   DEFINE l_zxy03       LIKE zxy_file.zxy03
   DEFINE l_azp01       LIKE azp_file.azp01
   DEFINE l_sql,l_err   STRING
   DEFINE l_azp01_str   STRING
   DEFINE tok           base.StringTokenizer             
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artr302_w AT p_row,p_col WITH FORM "art/42f/artr302"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.wc   = ' 1=1'
   LET tm.w    = 'Y'  #TQC-BB0034
   LET tm.x    = 'Y'  #TQC-BB0034
   LET tm.s    = '123'
   LET tm.t    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
   #genero版本default 排序
   #LET tm2.s1   = tm.s[1,1]   #TQC-BB0034 mark
   #LET tm2.s2   = tm.s[2,2]   #TQC-BB0034 mark
   #LET tm2.s3   = tm.s[3,3]   #TQC-BB0034 mark
   CALL r302_set_entry()       #TQC-BB0034
   CALL r302_setS() RETURNING tm2.s1,tm2.s2,tm2.s3  #TQC-BB0034
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF   
WHILE TRUE
   DISPLAY BY NAME tm.more
   CONSTRUCT BY NAME tm.wc1 ON azp01 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      AFTER FIELD azp01            
         LET l_azp01_str = get_fldbuf(azp01)  
         LET l_err='' 
         LET g_chk_auth = ''         
         IF NOT cl_null(l_azp01_str) AND l_azp01_str <> "*" THEN
            LET tok = base.StringTokenizer.create(l_azp01_str,"|")
            LET l_azp01 = ""
            WHILE tok.hasMoreTokens()
               LET l_azp01 = tok.nextToken()
               SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy03 = l_azp01 AND zxy01 = g_user
               IF STATUS THEN
                  CONTINUE WHILE
               ELSE
                  IF g_chk_auth IS NULL THEN
                     LET g_chk_auth = "'",l_zxy03,"'"
                  ELSE
                     LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                  END IF    
               END IF                  
            END WHILE
         ELSE
            DECLARE r302_zxy_cs  CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
            FOREACH r302_zxy_cs  INTO l_zxy03
               IF g_chk_auth IS NULL THEN
                  LET g_chk_auth = "'",l_zxy03,"'"
               ELSE
                  LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
               END IF
            END FOREACH
         END IF           
         IF g_chk_auth IS NOT NULL THEN
            LET g_chk_auth = "(",g_chk_auth,")"
         END IF                   
     ON ACTION controlp            
        IF INFIELD(azp01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_azw01"
           LET g_qryparam.state = "c"
           LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"                      
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO azp01
           NEXT FIELD azp01
        END IF  
      ON ACTION locale
         CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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
 
      END CONSTRUCT 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW artr302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF       
 
   IF cl_null(tm.wc1) THEN
         LET tm.wc1 = " azp01 = '",g_plant,"'"        #为空则默认为当前营运中心
   END IF           
   CONSTRUCT BY NAME tm.wc ON ima131,rvv31,rvu04,rvu03
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
    ON ACTION CONTROLP
        CASE
           WHEN INFIELD(ima131) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima131_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131
           WHEN INFIELD(rvv31) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvv31
               NEXT FIELD rvv31
           WHEN INFIELD(rvu04) 
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_rvu_1"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvu04
               NEXT FIELD rvu04
          END CASE          

     ON ACTION locale
         CALL cl_show_fld_cont()                   
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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
 
    END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW artr302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF

   #INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.t,tm.more  WITHOUT DEFAULTS
   INPUT BY NAME tm.w,tm.x,tm.t,tm2.s1,tm2.s2,tm2.s3,tm.more  WITHOUT DEFAULTS   #TQC-BB0034
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
      ON CHANGE t                    #TQC-BB0034
         CALL r302_set_entry()       #TQC-BB0034
         CALL r302_setS() RETURNING tm2.s1,tm2.s2,tm2.s3  #TQC-BB0034
         DISPLAY tm2.s1,tm2.s2,tm2.s3 TO s1,s2,s3  #TQC-BB0034
      AFTER FIELD t
         IF cl_null(tm.t) THEN NEXT FIELD t  END IF
      AFTER FIELD more
         IF cl_null(tm.more) OR tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT         
         IF INT_FLAG THEN EXIT INPUT END IF
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW artr302_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='artr302'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('artr302','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",    #TQC-BB0034
                         " '",tm.x CLIPPED,"'",    #TQC-BB0034
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('artr302',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW artr302_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL artr302()
   ERROR ""
END WHILE
   CLOSE WINDOW artr302_w
END FUNCTION 

FUNCTION artr302()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name        LIKE type_file.chr20,          
          l_name1       LIKE type_file.chr20,          
          l_time        LIKE type_file.chr8,          
          l_sql         STRING,                       
          l_chr         LIKE type_file.chr1,          
          l_za05        LIKE type_file.chr1000,  
          sr            RECORD order1 LIKE aaf_file.aaf03,     
                               order2 LIKE aaf_file.aaf03,    
                               order3 LIKE aaf_file.aaf03,
                               azp01  LIKE azp_file.azp01,       # 營運中心編號
                               azp02  LIKE azp_file.azp02,       # 名稱
                               rvv39t  LIKE rvv_file.rvv39t,     # 金額
                               ima131  LIKE ima_file.ima131,     # 產品分類
                               oba02  LIKE oba_file.oba02,       # 分類名稱
                               rvv31  LIKE rvv_file.rvv31,       # 產品編號
                               ima02 LIKE ima_file.ima02,        # 產品名稱
                               rvv35   LIKE rvv_file.rvv35,      #TQC-BB0034
                               rvv17 LIKE rvv_file.rvv17,        # 數量
                               rvu04 LIKE rvu_file.rvu04,        # 供應商編號
                               rvu05 LIKE rvu_file.rvu05,        # 簡稱
                               rvu03 LIKE rvu_file.rvu03,        # 進貨日期 
                               pmm22   LIKE pmm_file.pmm22,      # 採購單幣種
                               pmm42   LIKE pmm_file.pmm42,      # 採購單匯率
                               rva113  LIKE rva_file.rva113,     # 收貨單幣種
                               rva114  LIKE rva_file.rva114      # 收貨單匯率
                       END RECORD,

          l_oba02   LIKE oba_file.oba02,
          l_azi10   Like azi_file.azi10

     CALL cl_del_data(l_table)                                   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
     DROP TABLE artr302_tmp
     CREATE TEMP TABLE artr302_tmp(
                    azp01   LIKE azp_file.azp01,        
                    azp02   LIKE azp_file.azp02,        
                    rvv39t  LIKE rvv_file.rvv39t,       
                    ima131  LIKE ima_file.ima131,       
                    oba02   LIKE oba_file.oba02,        
                    rvv31   LIKE rvv_file.rvv31,        
                    ima02   LIKE ima_file.ima02,
                    rvv35   LIKE rvv_file.rvv35,   #TQC-BB0034         
                    rvv17   LIKE rvv_file.rvv17,       
                    rvu04   LIKE rvu_file.rvu04,        
                    rvu05   LIKE rvu_file.rvu05,        
                    rvu03   LIKE rvu_file.rvu03)
     DELETE FROM artr302_tmp        
     LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
               " WHERE azp01 IN ",g_chk_auth ,     
               "   AND azw01 = azp01  ",
               " ORDER BY azp01 "

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 

   FOREACH sel_azp01_cs INTO l_plant,l_azp02                                 ##--最外围的FOREACH--

      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF      

      LET l_sql = "SELECT  '','','',",                                           
            #"  rvuplant,'',rvv39t,ima131,'',rvv31,ima02,rvv17,rvu04,rvu05,rvu03,pmm22,pmm42,rva113,rva114 ",
            "  rvuplant,'',rvv39t,ima131,'',rvv31,ima02,rvv35,rvv17,rvu04,rvu05,rvu03,pmm22,pmm42,rva113,rva114 ", #TQC-BB0034 add rvv35
            "  FROM ",cl_get_target_table(l_plant,'rvu_file'),",",
                      cl_get_target_table(l_plant,'ima_file'),",",                 
                      cl_get_target_table(l_plant,'rvv_file'),
                      " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'pmm_file')," ON pmm01 = rvv36 ",
                      " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rva_file')," ON rva01 = rvv04 ",                     
            " WHERE rvu00=rvv03 AND rvu01=rvv01 ",
            "  AND  rvu00='1' ",
            "  AND  rvuconf='Y' ",
            "  AND  rvv31=ima01 ",
            "  AND  rvuplant='",l_plant,"'",    
            "  AND  rvvplant=rvuplant ",          
            "  AND ", tm.wc CLIPPED
               
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
     PREPARE artr302_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     DECLARE artr302_curs1 CURSOR FOR artr302_p1

     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
           
     END IF
     LET g_pageno = 0
     FOREACH artr302_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF NOT cl_null(sr.pmm22) THEN 
           IF NOT cl_null(sr.pmm42) THEN
              LET l_azi10 = ' '
              LET l_sql = "SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                          " WHERE azi01 = '",sr.pmm22,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
              PREPARE sel_azi10_pre FROM l_sql
              EXECUTE sel_azi10_pre INTO l_azi10
           ELSE
              LET sr.pmm42 = 1
           END IF
           CASE l_azi10
              WHEN '1'
                 LET sr.rvv39t = sr.rvv39t * sr.pmm42
              WHEN '2'
                 LET sr.rvv39t = sr.rvv39t/sr.pmm42  
           END CASE            
        ELSE     
           IF NOT cl_null(sr.rva113) THEN
              IF NOT cl_null(sr.rva114) THEN
                 LET l_azi10 = ' '
                 LET l_sql = "SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                             " WHERE azi01 = '",sr.rva113,"'"
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                 CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
                 PREPARE sel_azi10_pre1 FROM l_sql
                 EXECUTE sel_azi10_pre1 INTO l_azi10 
              ELSE 
                 LET sr.rva114 = 1
              END IF
           END IF 
           CASE l_azi10
              WHEN '1'
                 LET sr.rvv39t = sr.rvv39t * sr.rva114
              WHEN '2'
                 LET sr.rvv39t = sr.rvv39t/sr.rva114  
           END CASE              
        END IF          

        LET l_oba02 = ' '
        LET l_sql="SELECT oba02 FROM ",cl_get_target_table(l_plant,'oba_file'),
                  " WHERE oba01 = '",sr.ima131,"'"
                  
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql

        PREPARE sel_oba02_pre FROM l_sql
        EXECUTE sel_oba02_pre INTO l_oba02
        LET sr.azp02 = l_azp02
        LET sr.oba02 = l_oba02
        INSERT INTO artr302_tmp VALUES(sr.azp01,sr.azp02,sr.rvv39t,sr.ima131,sr.oba02,sr.rvv31,
                                      #sr.ima02,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03)
                                       sr.ima02,sr.rvv35,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03)   #TQC-BB0034 add rvv35
        INITIALIZE sr TO NULL
     END FOREACH
  END FOREACH 
     CASE 
        WHEN tm.t='1'
           #LET l_sql = "SELECT '','',SUM(rvv39t),'','',rvv31,ima02,SUM(rvv17),'','','' ",
           LET l_sql = "SELECT '','',SUM(rvv39t),'','',rvv31,ima02,rvv35,SUM(rvv17),'','','' ",  #TQC-BB0034 add rvv35
                       "  FROM artr302_tmp ",
                       " GROUP BY rvv31,ima02,rvv35 "
        WHEN tm.t='2' 
           #LET l_sql = "SELECT azp01,azp02,SUM(rvv39t),'','',rvv31,ima02,SUM(rvv17),'','','' ",
           LET l_sql = "SELECT azp01,azp02,SUM(rvv39t),'','',rvv31,ima02,rvv35,SUM(rvv17),'','','' ",  #TQC-BB0034 add rvv35
                       "  FROM artr302_tmp ",
                       " GROUP BY azp01,azp02,rvv31,ima02,rvv35 "
   END CASE
      PREPARE r302_prepare3 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare3:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r302_curs3 CURSOR FOR r302_prepare3  
      FOREACH r302_curs3 INTO sr.azp01,sr.azp02,sr.rvv39t,sr.ima131,sr.oba02,sr.rvv31,
                             #sr.ima02,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03 
                              sr.ima02,sr.rvv35,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03   #TQC-BB0034 add rvv35
        EXECUTE insert_prep USING
                sr.azp01,sr.azp02,sr.rvv39t,sr.ima131,sr.oba02,sr.rvv31,    
               #sr.ima02,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03
                sr.ima02,sr.rvv35,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03  #TQC-BB0034 add rvv35
        INITIALIZE sr TO NULL
     END FOREACH
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
     LET tm.wc = tm.wc1," AND ",tm.wc      
        CALL cl_wcchp(tm.wc,'azp01,ima131,rvv31,rvu04,rvu03')                   
              RETURNING tm.wc
        LET g_str = tm.wc
     END IF
    #LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.w,";",tm.x  #TQC-BB0034
   CASE
      WHEN tm.t='1'
         CALL cl_prt_cs3('artr302','artr302',l_sql,g_str)  
      WHEN tm.t='2'
         CALL cl_prt_cs3('artr302','artr302_1',l_sql,g_str) 
   END CASE
END FUNCTION   
#TQC-BB0034 add begin-----------
FUNCTION r302_set_entry()
   CASE 
      WHEN tm.t='1' 
         CALL cl_set_comp_entry("s1",FALSE)
         CALL cl_set_comp_entry("s2,s3",TRUE)
      WHEN tm.t='2'
         CALL cl_set_comp_entry("s1,s2",FALSE)
         CALL cl_set_comp_entry("s3",TRUE)
   END CASE 
END FUNCTION
 
FUNCTION r302_setS()
   CASE 
      WHEN tm.t='1' 
         RETURN '3','1','2'
      WHEN tm.t='2'
         RETURN '3','1','2'
   END CASE
   RETURN '3','1','2'
END FUNCTION  
#TQC-BB0034 add end-------------    
#FUN-A70005
