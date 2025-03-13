# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aimr890.4gl
# Descriptions...: 库存分析表
# Date & Author..: #FUN-A80096 10/07/09 By wangxin
# Modify.........: #FUN-AA0024 10/10/15 By wangxin 報表改善
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,  
              wc1      STRING,   
              a       LIKE type_file.chr1, 
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "imgplant.img_file.imgplant,",
                "azp02.azp_file.azp02,",
                "ima131.ima_file.ima131,",
                "oba02.oba_file.oba02,",
                "ima02.ima_file.ima02,",
                "img10.img_file.img10,",
                "ogb12.ogb_file.ogb12"
                          
 
   LET l_table = cl_prt_temptable('aimr890',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr890_tm(0,0)        # Input print condition
      ELSE CALL aimr890()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION aimr890_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW aimr890_w AT p_row,p_col WITH FORM "aim/42f/aimr890" 
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
   LET tm.a = '1'


   WHILE TRUE
      CONSTRUCT BY NAME tm.wc1 ON azp01
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(azp01)        #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw01"     
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azp01
                   NEXT FIELD azp01
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
            
      END CONSTRUCT
       
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW aimr890_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 
   
   
      CONSTRUCT BY NAME tm.wc ON ima01,ima131
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima131_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
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
            
      END CONSTRUCT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW aimr890_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      #IF tm.wc = ' 1=1' THEN
      #   CALL cl_err('','9046',0) CONTINUE WHILE
      #END IF
      DISPLAY BY NAME tm.a,tm.more 
      
      INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
            
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
         LET INT_FLAG = 0 CLOSE WINDOW aimr890_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aimr890'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aimr890','9031',1)
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
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('aimr890',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW aimr890_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aimr890()
      ERROR ""
   END WHILE
   CLOSE WINDOW aimr890_w
END FUNCTION

FUNCTION aimr890()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,          
          sr        RECORD 
                    imgplant LIKE img_file.imgplant,
                    ima131   LIKE ima_file.ima131,
                    ima01    LIKE ima_file.ima01,  #FUN-AA0024 add
                    ima02    LIKE ima_file.ima02,
                    img10    LIKE img_file.img10,
                    ogb12    LIKE ogb_file.ogb12,
                    ohb12    LIKE ohb_file.ohb12   #FUN-AA0024 add
                    END RECORD,
          l_oba02   LIKE oba_file.oba02
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?) "                                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)            
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--                                                                            
       EXIT PROGRAM                                                                                                                 
    END IF
    LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
               " WHERE ",tm.wc1 CLIPPED ,   
               "   AND azw01 = azp01  ",
               " ORDER BY azp01 "

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 
   FOREACH sel_azp01_cs INTO l_plant,l_azp02  
       IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
          
       LET l_sql = " SELECT imgplant,ima131,ima01,ima02,SUM(img10)",  
               " FROM ",cl_get_target_table(l_plant,'img_file'),
               "     ,",cl_get_target_table(l_plant,'ima_file'), 				
               " WHERE ima01 = img01",  
               " AND imaag IS NULL", 
               " AND imgplant='",l_plant,"'",
               " AND ",tm.wc CLIPPED,  
               " GROUP BY imgplant,ima131,ima02,ima01 ",     
               " UNION ",
               " SELECT imgplant,ima131,ima01,ima02,SUM(img10)",  
               " FROM ",cl_get_target_table(l_plant,'img_file'),
               "     ,",cl_get_target_table(l_plant,'ima_file'),  
               "     ,",cl_get_target_table(l_plant,'imx_file'), 			
               " WHERE ima01 = imx00",
               " AND imx000 = img01",
               " AND ima151 = 'Y'",  
               " AND imgplant='",l_plant,"'",
               " AND imaag IS NOT NULL", 
               " AND ",tm.wc CLIPPED,  
               " GROUP BY imgplant,ima131,ima02,ima01 "  
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                 
    PREPARE aimr890_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE aimr890_curs1 CURSOR FOR aimr890_prepare1
    #FOREACH aimr890_curs1 INTO sr.*
    FOREACH aimr890_curs1 INTO sr.imgplant,sr.ima131,sr.ima01,sr.ima02,sr.img10
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET l_sql = " SELECT SUM(ogb12)",
                   " FROM ",cl_get_target_table(l_plant,'ima_file'), 
                   "     ,",cl_get_target_table(l_plant,'ogb_file'), 	 	
                   " WHERE ima01 = '",sr.ima01,"'",
                   " AND ima01=ogb04",
                   " AND ogbplant='",l_plant,"'",
                   " AND imaag IS NULL", 
                   " AND ",tm.wc CLIPPED,  
                   " UNION ", 
                   " SELECT (-1)*(CASE WHEN SUM(ohb12) IS NULL THEN 0 ELSE SUM(ohb12) END)",
                   " FROM ",cl_get_target_table(l_plant,'ima_file'), 
                   "     ,",cl_get_target_table(l_plant,'ohb_file'), 	 	
                   " WHERE ima01 = '",sr.ima01,"'",
                   " AND ima01=ohb04",
                   " AND ohbplant='",l_plant,"'",
                   " AND imaag IS NULL", 
                   " AND ",tm.wc CLIPPED
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                          
    PREPARE aimr890_prepare2 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF 
    DECLARE aimr890_curs2 CURSOR FOR aimr890_prepare2
    #FOREACH aimr890_curs2 INTO sr.*
    FOREACH aimr890_curs2 INTO sr.ogb12
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
    END FOREACH    
    #FUN-AA0024 add --------------begin-------------------
    LET l_sql = " SELECT (CASE WHEN SUM(ohb12) IS NULL THEN 0 ELSE SUM(ohb12) END)",
                   " FROM ",cl_get_target_table(l_plant,'ima_file'), 
                   "     ,",cl_get_target_table(l_plant,'ohb_file'), 	 	
                   " WHERE ima01 = '",sr.ima01,"'",
                   " AND ima01=ohb04",
                   " AND ohbplant='",l_plant,"'",
                   " AND imaag IS NULL", 
                   " AND ",tm.wc CLIPPED
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql                          
    PREPARE aimr890_prepare3 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF 
    DECLARE aimr890_curs3 CURSOR FOR aimr890_prepare3
    FOREACH aimr890_curs3 INTO sr.ohb12
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
    END FOREACH
    IF cl_null(sr.ogb12) THEN
       LET sr.ogb12 = 0
    END IF  
    IF cl_null(sr.ohb12) THEN
       LET sr.ohb12 = 0
    END IF  
    LET sr.ogb12 = sr.ogb12 - sr.ohb12
    #FUN-AA0024 add ---------------end--------------------
     
 
      
    LET l_sql = " SELECT oba02 FROM ",cl_get_target_table(l_plant,'oba_file'),
                " WHERE oba01 = '",sr.ima131,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
       PREPARE sel_oba02_pre1 FROM l_sql
       EXECUTE sel_oba02_pre1 INTO l_oba02 
       EXECUTE  insert_prep  USING  
       sr.imgplant,l_azp02,sr.ima131,l_oba02,sr.ima02,sr.img10,sr.ogb12
    END FOREACH                     
   
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = tm.wc1," and ",tm.wc
   CASE
      WHEN tm.a='1'
         CALL cl_prt_cs3('aimr890','aimr890_1',l_sql,g_str)  
      WHEN tm.a='2'
         CALL cl_prt_cs3('aimr890','aimr890_2',l_sql,g_str)  
   END CASE
   END FOREACH
END FUNCTION
#FUN-A80096


