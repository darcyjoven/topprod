# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmr254.4gl
# Descriptions...: 
# Date & Author..: 06/03/22 By cl
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0217 06/12/30 By Rayven 報表格式調整
# Modify.........: No.FUN-760076 07/06/26 By yoyo 報表轉cr
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.FUN-980059 09/09/11 By arman GP5.2架構,修改SUB相關傳入參數  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10056 10/01/12 by dxfwo  跨DB處理  
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                      # Print condition RECORD
           a       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
           wc      LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(500)         # Where condition
           more    LIKE type_file.chr1              # Prog. Version..: '5.30.06-13.03.12(01)          # Input more condition(Y/N)
           END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20             #No.FUN-680120 VARCHAR(20)           # For TIPTOP 串 EasyFlow
DEFINE g_cnt       LIKE type_file.num10             #No.FUN-680120 INTEGER
DEFINE g_i         LIKE type_file.num5              #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg       LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(72)
#FUN-760076--start
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING
DEFINE  l_table2   STRING
DEFINE  l_table3   STRING
DEFINE  l_str      STRING
#FUN-760076--end
 
MAIN
   OPTIONS 
       
       INPUT NO WRAP
   DEFER INTERRUPT                      # Supress DEL key function
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF      
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   LET g_rpt_name = ''
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a= 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ARG_VAL(1)
   LET g_rpt_name = ARG_VAL(2)        
   LET g_rep_user = ARG_VAL(3)
   LET g_rep_clas = ARG_VAL(4)
   LET g_template = ARG_VAL(5)
   LET g_rpt_name = ARG_VAL(6)  #No.FUN-7C0078
#FUN-760076--start
   LET g_sql = "tsk01.tsk_file.tsk01,",
               "tsk18.tsk_file.tsk18,",
               "tsk03.tsk_file.tsk03,",
               "tsk17.tsk_file.tsk17,",
               "tsl02.tsl_file.tsl02,",
               "tsl03.tsl_file.tsl03,",
               "tsl04.tsl_file.tsl04,",
               "tsl05.tsl_file.tsl05,",
               "tsk05.tsk_file.tsk05,",
               "tsk06.tsk_file.tsk06,",
               "tsk07.tsk_file.tsk07,",
               "l_sum1.ogb_file.ogb12,",
               "l_sum2.rvv_file.rvv17,",
               "l_sum3.rvv_file.rvv17 "
 
   LET l_table = cl_prt_temptable('atmr254',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   
   LET g_sql = "tsk01.tsk_file.tsk01,",
               "tsl02.tsl_file.tsl02,",   
               "oga01.oga_file.oga01,",
               "ogb03.ogb_file.ogb03,",
               "poy04.poy_file.poy04,",
               "poy11.poy_file.poy11,",
               "ogb05.ogb_file.ogb05,",
               "ogb12.ogb_file.ogb12 "  
   LET l_table1 = cl_prt_temptable('atmr2541',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF 
   
   LET g_sql = "tsk01.tsk_file.tsk01,",
               "tsl02.tsl_file.tsl02,",
               "rvv01.rvv_file.rvv01,",
               "rvv02.rvv_file.rvv02,",
               "rvv35.rvv_file.rvv35,",
               "rvv17.rvv_file.rvv17 "
   LET l_table2 = cl_prt_temptable('atmr2542',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF               
                           
   LET g_sql = "tsk01.tsk_file.tsk01,",
               "tsl02.tsl_file.tsl02,",
               "rvv01b.rvv_file.rvv01,",
               "rvv02b.rvv_file.rvv02,",
               "rvv35b.rvv_file.rvv35,",
               "rvv17b.rvv_file.rvv17 "
   LET l_table3 = cl_prt_temptable('atmr2543',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF 
#FUN-760076--end              
                           
   IF cl_null(tm.wc) THEN
        CALL atmr254_tm(0,0)             # Input print condition
   ELSE LET tm.wc="tsK01= '",tm.wc CLIPPED,"'"
        CALL atmr254()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION atmr254_tm(p_row,p_col)
DEFINE lc_qbe_sn    LIKE gbm_file.gbm01
DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       l_cmd        LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(1000)
       
  LET p_row=7 LET p_col=7
  
  OPEN WINDOW atmr254_w AT p_row,p_col WITH FORM "atm/42f/atmr254"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
  CALL cl_ui_init()
  
  CALL cl_opmsg('p')
  
  WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON tsk01,tsk18,tsk03,tsk17,tsk05,tsl03
    
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tsk01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tsk"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsk01      
           WHEN INFIELD(tsk03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azp"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsk03
           WHEN INFIELD(tsk17)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_imd"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsk17           
           WHEN INFIELD(tsl03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tsl03
           OTHERWISE EXIT CASE           
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
       LET INT_FLAG = 0 CLOSE WINDOW atmr254_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
       EXIT PROGRAM
          
    END IF
    IF tm.wc=" 1=1" THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
    
    INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
    
      AFTER FIELD more
        IF tm.more = 'Y' THEN 
           CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                RETURNING g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies
        END IF
        
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()   
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
         
    END INPUT
    
    IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW atmr254_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='atmr254'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr254','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'" ,
                     " '",tm.more CLIPPED,"'"  ,
                     " '",g_rep_user CLIPPED,"'",
                     " '",g_rep_clas CLIPPED,"'",
                     " '",g_template CLIPPED,"'"  
         CALL cl_cmdat('atmr254',g_time,l_cmd)    
      END IF
      CLOSE WINDOW atmr254_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL atmr254()
   ERROR ""
END WHILE
   CLOSE WINDOW atmr254_w
END FUNCTION   
 
FUNCTION atmr254()
DEFINE sum1  LIKE  ogb_file.ogb12,
       sum2  LIKE  rvv_file.rvv17,
       sum3  LIKE  rvv_file.rvv17,
#       l_sql       LIKE type_file.chr1000,         #No.FUN-680120 VARCHAR(3000)
       l_name      LIKE type_file.chr20            #No.FUN-680120 VARCHAR(20)
#      l_time      LIKE type_file.chr8             #No.FUN-6B0014
DEFINE sr    RECORD
             tsk01   LIKE tsk_file.tsk01,
             tsk18   LIKE tsk_file.tsk18,
             tsk03   LIKE tsk_file.tsk03,
             tsk17   LIKE tsk_file.tsk17,
             tsl02   LIKE tsl_file.tsl02,
             tsl03   LIKE tsl_file.tsl03,
             tsl04   LIKE tsl_file.tsl04,
             tsl05   LIKE tsl_file.tsl05,
             tsk05   LIKE tsk_file.tsk05,
             tsk06   LIKE tsk_file.tsk06,
             tsk07   LIKE tsk_file.tsk07
             END RECORD
#FUN-760076--start 
 DEFINE  l_count1     LIKE type_file.num5,             #No.FUN-680120 SMALLINT               #統計出貨單記錄數目
         l_count2     LIKE type_file.num5,             #No.FUN-680120 SMALLINT               #統計入庫單記錄數目
         l_count3     LIKE type_file.num5,             #No.FUN-680120 SMALLINT               #統計倉退單記錄數目
         l_fac        LIKE ima_file.ima31_fac,         #No.FUN-680120 SMALLINT               #TQC-840066
         l_tsk05      LIKE bnb_file.bnb06,             #No.FUN-680120 SMALLINT
         l_ogb05  LIKE  ogb_file.ogb05,
         l_rvv35  LIKE  rvv_file.rvv35,
         l_sum1   LIKE  ogb_file.ogb12,
         l_sum2   LIKE  rvv_file.rvv17,
         l_sum3   LIKE  rvv_file.rvv17,
         l_poy04  LIKE  poy_file.poy04,
         l_tsl05  LIKE  tsl_file.tsl05,
         l_sql        STRING,
         l_count1a    STRING,
         l_count2a    STRING,
         l_count3a    STRING,
         l_flag       LIKE type_file.num5, 
         l_n          LIKE type_file.num5,
         l_sql1       LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(1000)
         l_dbs        LIKE azp_file.azp03,             #No.FUN-680120 VARCHAR(10)
         l_plant      LIKE azp_file.azp01,             #No.FUN-980059 VARCHAR(10)
         t_plant      LIKE azp_file.azp01,             #No.FUN-980059 VARCHAR(10)
         t_dbs        LIKE azp_file.azp03,             #No.FUN-680120 VARCHAR(10)         
         l_tsl02  LIKE  tsl_file.tsl02
  DEFINE sr1   RECORD
               oga01   LIKE oga_file.oga01,
               ogb03   LIKE ogb_file.ogb03,
               poy04   LIKE poy_file.poy04,
               poy11   LIKE poy_file.poy11,
               ogb05   LIKE ogb_file.ogb05,
               ogb12   LIKE ogb_file.ogb12
               END RECORD
  DEFINE sr2   RECORD
               rvv01   LIKE rvv_file.rvv01,
               rvv02   LIKE rvv_file.rvv02,
               rvv35   LIKE rvv_file.rvv35,
               rvv17   LIKE rvv_file.rvv17
               END RECORD
  DEFINE sr3   RECORD
               rvv01b  LIKE rvv_file.rvv01,
               rvv02b  LIKE rvv_file.rvv02,
               rvv35b  LIKE rvv_file.rvv35,
               rvv17b  LIKE rvv_file.rvv17
               END RECORD
 
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "  #FUN-720014 add 2欄位
      PREPARE insert1 FROM g_sql
      IF STATUS THEN
         CALL cl_err("insert_prep:",STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
         EXIT PROGRAM
      END IF
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED," values(?,?,?,?,?,?,?,?) "
      PREPARE insert2 FROM g_sql
      IF STATUS THEN
         CALL cl_err("insert_prep:",STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
         EXIT PROGRAM
      END IF   
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED," values(?,?,?,?,?,?) "
      PREPARE insert3 FROM g_sql
      IF STATUS THEN
         CALL cl_err("insert_prep:",STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
         EXIT PROGRAM
      END IF 
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED," values(?,?,?,?,?,?) "
      PREPARE insert4 FROM g_sql
      IF STATUS THEN
         CALL cl_err("insert_prep:",STATUS,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80061   ADD
         EXIT PROGRAM
      END IF         
   
#FUN-760076--end
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND tskuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND tskgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN      #群組權限
     #         LET tm.wc = tm.wc clipped," AND tskgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tskuser', 'tskgrup')
     #End:FUN-980030
     
     LET l_sql=" SELECT tsk01,tsk18,tsk03,tsk17,tsl02,tsl03,tsl04,tsl05, ",
               "        tsk05,tsk06,tsk07 ",
               " FROM tsk_file,tsl_file ",
               " WHERE tsk01= tsl01 ",
               " AND ",tm.wc CLIPPED
     PREPARE r254_prepare FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     DECLARE r254_curs CURSOR FOR r254_prepare
#FUN-760076--start
#     CALL cl_outnam('atmr254') RETURNING l_name
#     START REPORT r254_rep TO l_name
#     LET g_pageno = 0
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table3)
#FUN-760076--end     
     FOREACH r254_curs INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#FUN-760076--start
            
            LET l_n    = 0
            LET l_dbs  = '' 
            LET t_dbs  = ''
            LET l_flag = 1  
            LET l_sum1 = 0
            LET l_sum2 = 0
            LET l_sum3 = 0
            LET l_count1=0
            LET l_count2=0
            LET l_count3=0    
            
            CALL s_mtrade_last_plant(sr.tsk07)
                 RETURNING l_n,l_poy04
           
            SELECT azp03 INTO l_dbs FROM azp_file
               WHERE azp01= l_poy04
            SELECT azp03 INTO t_dbs FROM azp_file
               WHERE azp01= sr.tsk03
#TQC-940177   ---start             
            LET l_plant = l_poy04     #No.FUN-980059
            LET t_plant = sr.tsk03     #No.FUN-980059
           #LET l_dbs= l_dbs CLIPPED,"."
           #LET t_dbs= t_dbs CLIPPED,"." 
            LET l_dbs= s_dbstring(l_dbs CLIPPED)  
            LET t_dbs= s_dbstring(t_dbs CLIPPED) 
#TQC-940177   ---end               
           #出貨量 
            INITIALIZE sr1.* TO NULL
            LET l_sql = " SELECT '','','','',ogb05,ogb12 ",
#                       " FROM ", l_dbs CLIPPED,"oga_file,",l_dbs CLIPPED,"ogb_file,",
#                       l_dbs CLIPPED,"oea_file,","poy_file ",            
                        " FROM ",cl_get_target_table(l_plant, 'oga_file'),",",cl_get_target_table(l_plant, 'ogb_file'),",", #NO.FUN-A10056
                        cl_get_target_table(l_plant, 'oea_file'),",","poy_file ",                                          #NO.FUN-A10056
                        " WHERE ogb01=oga01 and oea99= '",sr.tsk06 ,"'" ,
                        " and ogapost='Y' and poy01=oea904 and oga16=oea01 ",
                        " and poy04 = '",l_poy04,"' and ogb04='",sr.tsl03,"'"   
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql   #NO.FUN-A10056
            PREPARE atmr254_prepare1 FROM l_sql
            IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
               EXIT PROGRAM 
            END IF
            DECLARE atmr254_curs1 CURSOR FOR atmr254_prepare1
            IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
            FOREACH atmr254_curs1 INTO sr1.*
              IF SQLCA.SQLCODE = 100 THEN
                 LET l_sum1=0
                 LET l_count1=0
                 EXIT FOREACH
              END IF
              IF STATUS THEN
                 EXIT FOREACH
              END IF
              LET l_count1=l_count1+1
#             CALL s_umfchk1(sr.tsl03,sr1.ogb05,sr.tsl04,l_dbs) RETURNING l_flag,l_fac     #No.FUN-980059
              CALL s_umfchk1(sr.tsl03,sr1.ogb05,sr.tsl04,l_plant) RETURNING l_flag,l_fac   #No.FUN-980059
              IF l_flag=0 THEN
                 LET sr1.ogb12= sr1.ogb12*l_fac
                 LET l_sum1 = l_sum1+sr1.ogb12
              ELSE
                 LET l_sum1=l_sum1+sr1.ogb12
              END IF
            END FOREACH
         
            CALL cl_remove_zero(l_sum1) RETURNING l_sum1
         
            #入庫量 
            INITIALIZE sr2.* TO NULL
            LET l_sql = " SELECT '','',rvv35,rvv17 ",
#                       " FROM ",t_dbs CLIPPED,"rvu_file,",t_dbs CLIPPED,"rvv_file,",
#                       t_dbs CLIPPED,"rva_file,",t_dbs CLIPPED,"pmm_file",
                        " FROM ",cl_get_target_table(t_plant, 'rvu_file'),",",cl_get_target_table(t_plant, 'rvv_file'),",", #NO.FUN-A10056
                        cl_get_target_table(t_plant, 'rva_file'),",",cl_get_target_table(t_plant, 'pmm_file'),              #NO.FUN-A10056
                        " WHERE rvu01=rvv01 and rvu02=rva01 and rva02=pmm01 ",
                        " and rvv03='1' and rvuconf='Y' and pmm99='",sr.tsk06,"'",
                        " and rvv31='",sr.tsl03,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,t_plant) RETURNING l_sql   #NO.FUN-A10056
            PREPARE atmr254_prepare2 FROM l_sql
            IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
               EXIT PROGRAM 
            END IF
            DECLARE atmr254_curs2 CURSOR FOR atmr254_prepare2
            IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
            FOREACH atmr254_curs2 INTO sr2.*
              IF SQLCA.SQLCODE = 100 THEN
                 LET l_sum2=0
                 LET l_count2 = 0
                 EXIT FOREACH
              END IF
              IF STATUS THEN EXIT FOREACH END IF
              LET l_count2=l_count2+1
#             CALL s_umfchk1(sr.tsl03,sr2.rvv35,sr.tsl04,t_dbs) RETURNING l_flag,l_fac  #No.FUN-980059
              CALL s_umfchk1(sr.tsl03,sr2.rvv35,sr.tsl04,t_plant) RETURNING l_flag,l_fac  #NO.FUN-980059
              IF l_flag = 0 THEN
                 LET  sr2.rvv17= sr2.rvv17*l_fac       
                 LET  l_sum2=l_sum2+ sr2.rvv17
              ELSE
                 LET  l_sum2=l_sum2+sr2.rvv17
              END IF
            END FOREACH
            
            #倉退量
            INITIALIZE sr3.* TO NULL
            LET l_sql = " SELECT '','',rvv35,rvv17 ",
#                       " FROM ",t_dbs CLIPPED,"rvu_file,",t_dbs CLIPPED,"rvv_file,",
#                       t_dbs CLIPPED,"rva_file,",t_dbs CLIPPED,"pmm_file",
                        " FROM ",cl_get_target_table(t_plant, 'rvu_file'),",",cl_get_target_table(t_plant, 'rvv_file'),",", #NO.FUN-A10056
                        cl_get_target_table(t_plant, 'rva_file'),",",cl_get_target_table(t_plant, 'pmm_file'),              #NO.FUN-A10056
                        " WHERE rvu01=rvv01 and rvu02=rva01 and rva02=pmm01 ",
                        " and rvv03='3' and rvuconf='Y' and pmm99='",sr.tsk06,"'",
                        " and rvv31='",sr.tsl03,"'"
 	          CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,t_plant) RETURNING l_sql   #NO.FUN-A10056
            PREPARE atmr254_prepare3 FROM l_sql
            IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
               EXIT PROGRAM 
            END IF
            DECLARE atmr254_curs3 CURSOR FOR atmr254_prepare3
            IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
            FOREACH atmr254_curs3 INTO sr3.*
              IF SQLCA.SQLCODE = 100 THEN
                 LET l_count3=0
                 LET l_sum3=0
                 EXIT FOREACH
              END IF
              IF STATUS THEN EXIT FOREACH END IF
              LET l_count3=l_count3+1
#             CALL s_umfchk1(sr.tsl03,sr3.rvv35b,sr.tsl04,t_dbs) RETURNING l_flag,l_fac     #No.FUN-980059
              CALL s_umfchk1(sr.tsl03,sr3.rvv35b,sr.tsl04,t_plant) RETURNING l_flag,l_fac   #No.FUN-980059
              IF l_flag = 0 THEN
                 LET sr3.rvv17b=sr3.rvv17b*l_fac
                 LET l_sum3=l_sum3+sr3.rvv17b
              ELSE
                 LET l_sum3=l_sum3+sr3.rvv17b
              END IF
         
            END FOREACH
            CALL cl_remove_zero(l_sum3) RETURNING l_sum3
            CALL cl_remove_zero(sr.tsl05) RETURNING l_tsl05
         
            #出貨明細 
            INITIALIZE sr1.* TO NULL
            IF tm.a='Y' AND l_count1 !=0 THEN
               LET l_sql1= " SELECT oga01,ogb03,poy04,poy11,ogb05,ogb12 ",
#                          " FROM ", l_dbs CLIPPED,"oga_file, ",l_dbs CLIPPED,"ogb_file,",
#                          l_dbs CLIPPED,"oea_file, ","poy_file ",                             #   l_dbs CLIPPED,"poy_file ",            
                           " FROM ",cl_get_target_table(l_plant, 'oga_file'),",",cl_get_target_table(l_plant, 'ogb_file'),",", #NO.FUN-A10056
                           cl_get_target_table(l_plant, 'oea_file'),",","poy_file ",                                          #NO.FUN-A10056
                           " WHERE ogb01=oga01 and oea99= '",sr.tsk06 ,"'" ,
                           " and ogapost='Y' and poy01=oea904 and ogb31=oea01 ",
                           " and poy04 = '",l_poy04,"' and ogb04='",sr.tsl03,"'"
 	             CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql1,l_plant) RETURNING l_sql1   #NO.FUN-A10056
               PREPARE atmr254_prepare4 FROM l_sql1
               IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
                  EXIT PROGRAM 
               END IF
               DECLARE atmr254_curs4 CURSOR FOR atmr254_prepare4
               IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
               FOREACH atmr254_curs4 INTO sr1.*
                  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
                  EXECUTE insert2 USING sr.tsk01,sr.tsl02,sr1.oga01,sr1.ogb03,sr1.poy04,
                                        sr1.poy11,sr1.ogb05,sr1.ogb12 
               END FOREACH
            END IF
            
            #入庫明細
            INITIALIZE sr2.* TO NULL
            IF tm.a='Y' AND l_count2 != 0 THEN 
               LET l_sql1= "SELECT rvv01,rvv02,rvv35,rvv17 ",
#                          " FROM ",t_dbs CLIPPED,"rvu_file,",t_dbs CLIPPED,"rvv_file,",
#                          t_dbs CLIPPED,"rva_file,",t_dbs CLIPPED,"pmm_file",
                           " FROM ",cl_get_target_table(t_plant, 'rvu_file'),",",cl_get_target_table(t_plant, 'rvv_file'),",", #NO.FUN-A10056
                           cl_get_target_table(t_plant, 'rva_file'),",",cl_get_target_table(t_plant, 'pmm_file'),              #NO.FUN-A10056
                           " WHERE rvu01=rvv01 and rvu02=rva01 and rva02=pmm01 ",
                           " and rvv03='1' and rvuconf='Y' and pmm99='",sr.tsk06,"'",
                           " and rvv31='",sr.tsl03,"'"
 	             CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql1,t_plant) RETURNING l_sql1   #NO.FUN-A10056
               PREPARE atmr254_prepare5 FROM l_sql1
               IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
                  EXIT PROGRAM 
               END IF
               DECLARE atmr254_curs5 CURSOR FOR atmr254_prepare5
               IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF 
               FOREACH atmr254_curs5 INTO sr2.*
                  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
                  EXECUTE insert3 USING sr.tsk01,sr.tsl02,sr2.rvv01,sr2.rvv02,sr2.rvv35,sr2.rvv17
               END FOREACH
            END IF
            
            #倉退明細
            INITIALIZE sr3.* TO NULL
            IF tm.a='Y' AND l_count3 !=0 THEN            
               LET l_sql1= "SELECT rvv01,rvv02,rvv35,rvv17 ",
#                          " FROM ",t_dbs CLIPPED,"rvu_file,",t_dbs CLIPPED,"rvv_file,",
#                          t_dbs CLIPPED,"rva_file,",t_dbs CLIPPED,"pmm_file",
                           " FROM ",cl_get_target_table(t_plant, 'rvu_file'),",",cl_get_target_table(t_plant, 'rvv_file'),",", #NO.FUN-A10056
                           cl_get_target_table(t_plant, 'rva_file'),",",cl_get_target_table(t_plant, 'pmm_file'),              #NO.FUN-A10056
                           " WHERE rvu01=rvv01 and rvu02=rva01 and rva02=pmm01 ",
                           " and rvv03='3' and rvuconf='Y' and pmm99='",sr.tsk06,"'",
                           " and rvv31='",sr.tsl03,"'"
            	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
               CALL cl_parse_qry_sql(l_sql1,t_plant) RETURNING l_sql1   #NO.FUN-A10056
               PREPARE atmr254_prepare6 FROM l_sql1
               IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
                  EXIT PROGRAM 
               END IF
               DECLARE atmr254_curs6 CURSOR FOR atmr254_prepare6
               IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
               FOREACH atmr254_curs6 INTO sr3.*
                  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
                  EXECUTE insert4 USING sr.tsk01,sr.tsl02,sr3.rvv01b,sr3.rvv02b,sr3.rvv35b,sr3.rvv17b
               END FOREACH
            END IF
                                    
            EXECUTE insert1 USING sr.tsk01,sr.tsk18,sr.tsk03,sr.tsk17,sr.tsl02,
                                 sr.tsl03,sr.tsl04,l_tsl05,sr.tsk05,sr.tsk06,
                                 sr.tsk07,l_sum1,l_sum2,l_sum3
#         OUTPUT TO REPORT r254_rep(sr.*)
#FUN-760076--end
     END FOREACH
 
#FUN-760076--start
#     FINISH REPORT r254_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      LET l_sql = " SELECT A.*,B.oga01,B.ogb03,B.poy04,B.poy11,",
                  "        B.ogb05,B.ogb12,C.rvv01,C.rvv02,C.rvv35,",
                  "        C.rvv17,D.rvv01b,D.rvv02b,D.rvv35b,D.rvv17b ",
                  "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
                             g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON(A.tsk01=B.tsk01 AND A.tsl02=B.tsl02)  ",
                  " LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C ON(A.tsk01=C.tsk01 AND A.tsl02=C.tsl02) ",
                  " LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table3 CLIPPED," D ON(A.tsk01=D.tsk01 AND A.tsl02=D.tsl02) "
      IF l_count1 != 0 THEN
         LET l_count1a = 'Y' 
      ELSE 
         LET l_count1a = 'N'
      END IF
      IF l_count2 != 0 THEN
         LET l_count2a = 'Y' 
      ELSE 
         LET l_count2a = 'N'
      END IF   
      IF l_count3 != 0 THEN
         LET l_count3a = 'Y' 
      ELSE 
         LET l_count3a = 'N'
      END IF         
      LET l_str = tm.a clipped,";",l_count1a clipped,";",l_count2a clipped,";",
                  l_count3a clipped            
      SELECT zz05 INTO g_zz05 FROM zz_file where zz01='atmr254'
      IF g_zz05 = 'Y' THEN
         CALL cl_wcchp(tm.wc,'tsk01,tsk18,tsk03,tsk17,tsk05,tsl03')
              RETURNING tm.wc
         LET l_str = l_str CLIPPED,";",tm.wc         
      END IF
      CALL cl_prt_cs3('atmr254','atmr254',l_sql,l_str)  
#FUN-760076--end                             
                       
END FUNCTION 
 
#FUN-760076--start
#REPORT r254_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#         l_dbs        LIKE azp_file.azp03,             #No.FUN-680120 VARCHAR(10)
#         t_dbs        LIKE azp_file.azp03,             #No.FUN-680120 VARCHAR(10)
#         l_sql        LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(1000)
#         l_sql1       LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(1000)
#         l_flag       LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#         l_n          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#         l_lineno     LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#         l_count1     LIKE type_file.num5,             #No.FUN-680120 SMALLINT               #統計出貨單記錄數目
#         l_count2     LIKE type_file.num5,             #No.FUN-680120 SMALLINT               #統計入庫單記錄數目
#         l_count3     LIKE type_file.num5,             #No.FUN-680120 SMALLINT               #統計倉退單記錄數目
#         l_tsk05      LIKE bnb_file.bnb06,             #No.FUN-680120 SMALLINT
#         l_ogb05  LIKE  ogb_file.ogb05,
#         l_rvv35  LIKE  rvv_file.rvv35,
#         l_sum1   LIKE  ogb_file.ogb12,
#         l_sum2   LIKE  rvv_file.rvv17,
#         l_sum3   LIKE  rvv_file.rvv17,
#         l_poy04  LIKE  poy_file.poy04,
#         l_tsl05  LIKE  tsl_file.tsl05,
#         l_tsl02  LIKE  tsl_file.tsl02
#  DEFINE sr    RECORD
#               tsk01   LIKE tsk_file.tsk01,
#               tsk18   LIKE tsk_file.tsk18,
#               tsk03   LIKE tsk_file.tsk03,
#               tsk17   LIKE tsk_file.tsk17,
#               tsl02   LIKE tsl_file.tsl02,
#               tsl03   LIKE tsl_file.tsl03,
#               tsl04   LIKE tsl_file.tsl04,
#               tsl05   LIKE tsl_file.tsl05,
#               tsk05   LIKE tsk_file.tsk05,
#               tsk06   LIKE tsk_file.tsk06,
#               tsk07   LIKE tsk_file.tsk07
#               END RECORD
#  DEFINE sr1   RECORD
#               oga01   LIKE oga_file.oga01,
#               ogb03   LIKE ogb_file.ogb03,
#               poy04   LIKE poy_file.poy04,
#               poy11   LIKE poy_file.poy11,
#               ogb05   LIKE ogb_file.ogb05,
#               ogb12   LIKE ogb_file.ogb12
#               END RECORD
#  DEFINE sr2   RECORD
#               rvv01   LIKE rvv_file.rvv01,
#               rvv02   LIKE rvv_file.rvv02,
#               rvv35   LIKE rvv_file.rvv35,
#               rvv17   LIKE rvv_file.rvv17
#               END RECORD
#  DEFINE sr3   RECORD
#               rvv01b  LIKE rvv_file.rvv01,
#               rvv02b  LIKE rvv_file.rvv02,
#               rvv35b  LIKE rvv_file.rvv35,
#               rvv17b  LIKE rvv_file.rvv17
#               END RECORD
#
#  
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.tsk01,sr.tsl02  
#  
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      #No.TQC-6C0217 --start--
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      #No.TQC-6C0217 --end--
#      PRINT g_dash[1,g_len]
#      PRINT g_x[19],g_x[20],g_x[21],g_x[22],g_x[30],g_x[23],g_x[24],g_x[25],
#            g_x[26],g_x[27],g_x[28],g_x[29]         
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#     
#    BEFORE GROUP OF sr.tsk01
#      CASE 
#        WHEN sr.tsk05='1' LET l_tsk05=g_x[31]
#        WHEN sr.tsk05='2' LET l_tsk05=g_x[32] 
#        WHEN sr.tsk05='3' LET l_tsk05=g_x[33] 
#        WHEN sr.tsk05='4' LET l_tsk05=g_x[34] 
#        OTHERWISE         LET l_tsk05= ' '
#      END CASE
#
#      PRINT COLUMN g_c[19],sr.tsk01 CLIPPED,
#            COLUMN g_c[20],sr.tsk18 CLIPPED,
#            COLUMN g_c[21],sr.tsk03 CLIPPED,
#            COLUMN g_c[22],sr.tsk17 CLIPPED,
#            COLUMN g_c[30],l_tsk05 CLIPPED;
#  
#    BEFORE GROUP OF sr.tsl02
#      LET l_n    = 0
#      LET l_dbs  = '' 
#      LET t_dbs  = ''
#      LET l_flag = 1  
#      LET l_sum1 = 0
#      LET l_sum2 = 0
#      LET l_sum3 = 0
#      LET l_count1=0
#      LET l_count2=0
#      LET l_count3=0
#
#      CALL s_mtrade_last_plant(sr.tsk07)
#         RETURNING l_n,l_poy04
#
#      SELECT azp03 INTO l_dbs FROM azp_file
#         WHERE azp01= l_poy04
#      SELECT azp03 INTO t_dbs FROM azp_file
#         WHERE azp01= sr.tsk03
#
#         LET l_dbs= l_dbs CLIPPED,"."
#         LET t_dbs= t_dbs CLIPPED,"." 
#        
#        #出貨量 
#         INITIALIZE sr1.* TO NULL
#         LET l_sql = " SELECT '','','','',ogb05,ogb12 ",
#                     " FROM ", l_dbs CLIPPED,"oga_file,",l_dbs CLIPPED,"ogb_file,",
#                     l_dbs CLIPPED,"oea_file,","poy_file ",            
#                     " WHERE ogb01=oga01 and oea99= '",sr.tsk06 ,"'" ,
#                     " and ogapost='Y' and poy01=oea904 and oga16=oea01 ",
#                     " and poy04 = '",l_poy04,"' and ogb04='",sr.tsl03,"'"   
#         PREPARE atmr254_prepare1 FROM l_sql
#         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#            EXIT PROGRAM 
#         END IF
#         DECLARE atmr254_curs1 CURSOR FOR atmr254_prepare1
#         IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#         FOREACH atmr254_curs1 INTO sr1.*
#           IF SQLCA.SQLCODE = 100 THEN
#              LET l_sum1=0
#              LET l_count1=0
#              EXIT FOREACH
#           END IF
#           IF STATUS THEN
#              EXIT FOREACH
#           END IF
#           LET l_count1=l_count1+1
#           CALL s_umfchk1(sr.tsl03,sr1.ogb05,sr.tsl04,l_dbs) RETURNING l_flag,l_fac
#           IF l_flag=0 THEN
#              LET sr1.ogb12= sr1.ogb12*l_fac
#              LET l_sum1 = l_sum1+sr1.ogb12
#           ELSE
#              LET l_sum1=l_sum1+sr1.ogb12
#           END IF
#         END FOREACH
#      
#         CALL cl_remove_zero(l_sum1) RETURNING l_sum1
# 
#         #入庫量 
#         INITIALIZE sr2.* TO NULL
#         LET l_sql = " SELECT '','',rvv35,rvv17 ",
#                     " FROM ",t_dbs CLIPPED,"rvu_file,",t_dbs CLIPPED,"rvv_file,",
#                     t_dbs CLIPPED,"rva_file,",t_dbs CLIPPED,"pmm_file",
#                     " WHERE rvu01=rvv01 and rvu02=rva01 and rva02=pmm01 ",
#                     " and rvv03='1' and rvuconf='Y' and pmm99='",sr.tsk06,"'",
#                     " and rvv31='",sr.tsl03,"'"
#         PREPARE atmr254_prepare2 FROM l_sql
#         IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#            EXIT PROGRAM 
#         END IF
#         DECLARE atmr254_curs2 CURSOR FOR atmr254_prepare2
#         IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#         FOREACH atmr254_curs2 INTO sr2.*
#           IF SQLCA.SQLCODE = 100 THEN
#              LET l_sum2=0
#              LET l_count2 = 0
#              EXIT FOREACH
#           END IF
#           IF STATUS THEN EXIT FOREACH END IF
#           LET l_count2=l_count2+1
#           CALL s_umfchk1(sr.tsl03,sr2.rvv35,sr.tsl04,t_dbs) RETURNING l_flag,l_fac
#           IF l_flag = 0 THEN
#              LET  sr2.rvv17= sr2.rvv17*l_fac       
#              LET  l_sum2=l_sum2+ sr2.rvv17
#           ELSE
#              LET  l_sum2=l_sum2+sr2.rvv17
#           END IF
#         END FOREACH
#         
#         #倉退量
#         INITIALIZE sr3.* TO NULL
#         LET l_sql = " SELECT '','',rvv35,rvv17 ",
#                     " FROM ",t_dbs CLIPPED,"rvu_file,",t_dbs CLIPPED,"rvv_file,",
#                     t_dbs CLIPPED,"rva_file,",t_dbs CLIPPED,"pmm_file",
#                     " WHERE rvu01=rvv01 and rvu02=rva01 and rva02=pmm01 ",
#                     " and rvv03='3' and rvuconf='Y' and pmm99='",sr.tsk06,"'",
#                     " and rvv31='",sr.tsl03,"'"
#         PREPARE atmr254_prepare3 FROM l_sql
#         IF STATUS THEN CALL cl_err('prepare3:',STATUS,1) 
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#            EXIT PROGRAM 
#         END IF
#         DECLARE atmr254_curs3 CURSOR FOR atmr254_prepare3
#         IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#         FOREACH atmr254_curs3 INTO sr3.*
#           IF SQLCA.SQLCODE = 100 THEN
#              LET l_count3=0
#              LET l_sum3=0
#              EXIT FOREACH
#           END IF
#           IF STATUS THEN EXIT FOREACH END IF
#           LET l_count3=l_count3+1
#           CALL s_umfchk1(sr.tsl03,sr3.rvv35b,sr.tsl04,t_dbs) RETURNING l_flag,l_fac
#           IF l_flag = 0 THEN
#              LET sr3.rvv17b=sr3.rvv17b*l_fac
#              LET l_sum3=l_sum3+sr3.rvv17b
#           ELSE
#              LET l_sum3=l_sum3+sr3.rvv17b
#           END IF
#
#         END FOREACH
#         CALL cl_remove_zero(l_sum3) RETURNING l_sum3
#         CALL cl_remove_zero(sr.tsl05) RETURNING l_tsl05
#
#         SELECT MAX(tsl02) INTO l_tsl02 FROM tsl_file WHERE tsl01=sr.tsk01
# 
#   ON EVERY ROW
#      PRINT COLUMN g_c[23],sr.tsl02 USING '<<<<<',
#            COLUMN g_c[24],sr.tsl03 CLIPPED,
#            COLUMN g_c[25],sr.tsl04 CLIPPED,
#            COLUMN g_c[26],l_tsl05 USING '####,###,###,##&.###',
#            COLUMN g_c[27],l_sum1 USING '###,###,##&.###',
#            COLUMN g_c[28],l_sum2 USING '###,###,##&.###',
#            COLUMN g_c[29],l_sum3 USING '##,###,##&.###'
#      #出貨明細 
#      IF tm.a='Y' AND l_count1 !=0 THEN
#         PRINT COLUMN g_c[23],g_dash2[1,g_w[23]+1+g_w[24]+1+g_w[25]+1+g_w[26]+1+g_w[27]+1+g_w[28]+1+g_w[29]]
#         PRINT COLUMN g_c[24],g_x[9] CLIPPED,
#               COLUMN g_c[25],g_x[10] CLIPPED,
#               COLUMN g_c[26],g_x[11] CLIPPED,
#               COLUMN g_c[27],g_x[12] CLIPPED,
#               COLUMN g_c[28],g_x[13] CLIPPED,
#               COLUMN g_c[29],g_x[14] CLIPPED
#         PRINT COLUMN g_c[24],g_dash2[1,g_w[24]],
#               COLUMN g_c[25],g_dash2[1,g_w[25]],
#               COLUMN g_c[26],g_dash2[1,g_w[26]],
#               COLUMN g_c[27],g_dash2[1,g_w[27]],
#               COLUMN g_c[28],g_dash2[1,g_w[28]],
#               COLUMN g_c[29],g_dash2[1,g_w[29]]
# 
#         INITIALIZE sr1.* TO NULL
#         LET l_sql1= " SELECT oga01,ogb03,poy04,poy11,ogb05,ogb12 ",
#                     " FROM ", l_dbs CLIPPED,"oga_file, ",l_dbs CLIPPED,"ogb_file,",
#                     l_dbs CLIPPED,"oea_file, ","poy_file ",                             #   l_dbs CLIPPED,"poy_file ",            
#                     " WHERE ogb01=oga01 and oea99= '",sr.tsk06 ,"'" ,
#                     " and ogapost='Y' and poy01=oea904 and ogb31=oea01 ",
#                     " and poy04 = '",l_poy04,"' and ogb04='",sr.tsl03,"'"
#         PREPARE atmr254_prepare4 FROM l_sql1
#         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#            EXIT PROGRAM 
#         END IF
#         DECLARE atmr254_curs4 CURSOR FOR atmr254_prepare4
#         IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#         FOREACH atmr254_curs4 INTO sr1.*
#            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#            NEED 2 LINES
#            PRINT COLUMN g_c[24] ,sr1.oga01 CLIPPED,
#                  COLUMN g_c[25],sr1.ogb03 USING '<<<<<',
#                  COLUMN g_c[26],sr1.poy04 CLIPPED,
#                  COLUMN g_c[27],sr1.poy11 CLIPPED,
#                  COLUMN g_c[28],sr1.ogb05 CLIPPED,
#                  COLUMN g_c[29],sr1.ogb12 USING '#####,##&.##'
#         END FOREACH                   
#         IF l_count2 = 0 AND l_count3 = 0 THEN
#            PRINT
#         END IF
#      END IF
#      
#      #入庫明細
#      IF tm.a='Y' AND l_count2 != 0 THEN
#         PRINT COLUMN g_c[24],g_dash2[1,g_w[24]+1+g_w[25]+1+g_w[26]+1+g_w[27]+1+g_w[28]+1+g_w[29]]
#         PRINT COLUMN g_c[24],g_x[15] CLIPPED,
#               COLUMN g_c[25],g_x[10] CLIPPED,
#               COLUMN g_c[26],g_x[13] CLIPPED,
#               COLUMN g_c[27],g_x[16] CLIPPED
#         PRINT COLUMN g_c[24],g_dash2[1,g_w[24]],
#               COLUMN g_c[25],g_dash2[1,g_w[25]],
#               COLUMN g_c[26],g_dash2[1,g_w[26]],
#               COLUMN g_c[27],g_dash2[1,g_w[27]]
#         
#         INITIALIZE sr2.* TO NULL
#         LET l_sql1= "SELECT rvv01,rvv02,rvv35,rvv17 ",
#                     " FROM ",t_dbs CLIPPED,"rvu_file,",t_dbs CLIPPED,"rvv_file,",
#                     t_dbs CLIPPED,"rva_file,",t_dbs CLIPPED,"pmm_file",
#                     " WHERE rvu01=rvv01 and rvu02=rva01 and rva02=pmm01 ",
#                     " and rvv03='1' and rvuconf='Y' and pmm99='",sr.tsk06,"'",
#                     " and rvv31='",sr.tsl03,"'"
#         PREPARE atmr254_prepare5 FROM l_sql1
#         IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#            EXIT PROGRAM 
#         END IF
#         DECLARE atmr254_curs5 CURSOR FOR atmr254_prepare5
#         IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF 
#         FOREACH atmr254_curs5 INTO sr2.*
#            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#            NEED 2 LINES
#            PRINT COLUMN g_c[24],sr2.rvv01 CLIPPED,
#                  COLUMN g_c[25],sr2.rvv02 USING '<<<<<',
#                  COLUMN g_c[26],sr2.rvv35 CLIPPED,
#                  COLUMN g_c[27],sr2.rvv17 USING '####,###,##&.##'
#         END FOREACH
#         IF l_count3 = 0 THEN
#            PRINT
#         END IF
#      END IF
#      
#      #倉退明細
#      IF tm.a='Y' AND l_count3 !=0 THEN
#         PRINT COLUMN g_c[24],g_dash2[1,g_w[24]+1+g_w[25]+1+g_w[26]+1+g_w[27]+1+g_w[28]+1+g_w[29]]
#         PRINT COLUMN g_c[24],g_x[17] CLIPPED,       
#               COLUMN g_c[25],g_x[10] CLIPPED,
#               COLUMN g_c[26],g_x[13] CLIPPED,
#               COLUMN g_c[27],g_x[18] CLIPPED
#         PRINT COLUMN g_c[24],g_dash2[1,g_w[24]],
#               COLUMN g_c[25],g_dash2[1,g_w[25]],
#               COLUMN g_c[26],g_dash2[1,g_w[26]],
#               COLUMN g_c[27],g_dash2[1,g_w[27]]
#
#         INITIALIZE sr3.* TO NULL
#         LET l_sql1= "SELECT rvv01,rvv02,rvv35,rvv17 ",
#                     " FROM ",t_dbs CLIPPED,"rvu_file,",t_dbs CLIPPED,"rvv_file,",
#                     t_dbs CLIPPED,"rva_file,",t_dbs CLIPPED,"pmm_file",
#                     " WHERE rvu01=rvv01 and rvu02=rva01 and rva02=pmm01 ",
#                     " and rvv03='3' and rvuconf='Y' and pmm99='",sr.tsk06,"'",
#                     " and rvv31='",sr.tsl03,"'"
#         PREPARE atmr254_prepare6 FROM l_sql1
#         IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
#            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
#            EXIT PROGRAM 
#         END IF
#         DECLARE atmr254_curs6 CURSOR FOR atmr254_prepare6
#         IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
#         FOREACH atmr254_curs6 INTO sr3.*
#            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#            NEED 2 LINES
#            PRINT COLUMN g_c[24],sr3.rvv01b CLIPPED,                
#                  COLUMN g_c[25],sr3.rvv02b USING '<<<<<',          
#                  COLUMN g_c[26],sr3.rvv35b CLIPPED,                
#                  COLUMN g_c[27],sr3.rvv17b USING '####,###,##&.##'
#         END FOREACH                   
#           PRINT
#      END IF
#
#         NEED 2 LINES
#      IF sr.tsl02=l_tsl02  THEN
#    #    PRINT g_dash1 
#      PRINT g_dash2[1,g_len]
#      END IF
#
#   ON LAST ROW
#      #No.TQC-6C0217 --start--
#      NEED 4 LINES                                                                                                                
#      IF g_zz05 = 'Y' THEN
#         CALL cl_wcchp(tm.wc,'tsk01,tsk18,tsk03,tsk17,tsk05,tsl03')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      #No.TQC-6C0217 --end--
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
#
#      PAGE TRAILER
#         IF l_last_sw ='n' THEN
#            PRINT g_dash[1,g_len] 
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),g_x[6] CLIPPED   
#         ELSE 
#            SKIP 2 LINE 
#         END IF  
#         PRINT  
#         IF l_last_sw = 'N' THEN 
#            IF g_memo_pagetrailer THEN   
#               PRINT g_memo 
#            ELSE
#               PRINT   
#            #  PRINT  
#            END IF  
#         ELSE  
#            PRINT g_memo  
#         END IF
# 
#END REPORT
#FUN--760076--end
 
