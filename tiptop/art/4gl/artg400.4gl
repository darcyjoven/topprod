# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg400.4gl
# Descriptions...: 营运中心订货汇总表
# Date & Author..: FUN-A80101  10/08/01 By shenyang
# Modify.........: No:TQC-B70066 11/07/08 By guoch 將l_sql改為string類型
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BA0063 11/10/19 By yangtt CR轉換成GRW
# Modify.........: No.FUN-BA0063 12/01/16 By yangtt FUN-BB0032追單
# Modify.........: NO.FUN-CB0058 12/11/20 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD  
              wc1     STRING,              
              wc      STRING,    
              a       LIKE type_file.chr1,
              b       LIKE type_file.chr1,  
              w       LIKE type_file.chr1,      #FUN-BA0063 FROM FUN-BB0032
              x       LIKE type_file.chr1,      #FUN-BA0063 FROM FUN-BB0032
              more    LIKE type_file.chr1       # FUN-A80101 Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_azp01         LIKE azp_file.azp01 
DEFINE   g_azp01_str     STRING   

###GENGRE###START
TYPE sr1_t RECORD
    oeaplant LIKE oea_file.oeaplant,
    azp02 LIKE azp_file.azp02,
    ima131 LIKE ima_file.ima131,
    oba02 LIKE oba_file.oba02,
    ima01 LIKE ima_file.ima01,
    ima02 LIKE ima_file.ima02,
    oeb05 LIKE oeb_file.oeb05,  #FUN-BA0063 FROM FUN-BB0032
    oeb12 LIKE oeb_file.oeb12,  #FUN-BA0063 FROM FUN-BB0032
    oeb14t LIKE oeb_file.oeb14t,
    lpk01 LIKE lpk_file.lpk01,
    lpk04 LIKE lpk_file.lpk04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   LET g_sql =  "oeaplant.oea_file.oeaplant,",
                "azp02.azp_file.azp02,",
                "ima131.ima_file.ima131,",
                "oba02.oba_file.oba02,",
                "ima01.ima_file.ima01,",
                "ima02.ima_file.ima02,",
                "oeb05.oeb_file.oeb05,",  #FUN-BA0063 FROM FUN-BB0032
                "oeb12.oeb_file.oeb12,",  #FUN-BA0063 FROM FUN-BB0032
                "oeb14t.oeb_file.oeb14t,",
                "lpk01.lpk_file.lpk01,",
                "lpk04.lpk_file.lpk04"          
 
   LET l_table = cl_prt_temptable('artg400',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)
   LET tm.b = ARG_VAL(9)
   LET tm.w = ARG_VAL(10)   #FUN-BA0063 FROM FUN-BB0032
   LET tm.x = ARG_VAL(11)   #FUN-BA0063 FROM FUN-BB0032
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)   

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artg400_tm(0,0)        # Input print condition
      ELSE CALL artg400()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
END MAIN


FUNCTION artg400_tm(p_row,p_col) 
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03 
   DEFINE l_num          LIKE type_file.num10
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01 
   DEFINE l_n            LIKE type_file.num5
   DEFINE p_row,p_col    LIKE type_file.num5,  
           l_cmd          LIKE type_file.chr1000
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artg400_w AT p_row,p_col WITH FORM "art/42f/artg400" 
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
   LET tm.b = '1'  
   LET tm.w = 'Y'    #FUN-BA0063 FROM FUN-BB0032
   LET tm.x = 'Y'    #FUN-BA0063 FROM FUN-BB0032

    WHILE TRUE
     CONSTRUCT BY NAME tm.wc1 ON azp01
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         AFTER FIELD azp01 
            LET g_chk_azp01 = TRUE 
            LET g_azp01_str = get_fldbuf(azp01)  
            LET g_chk_auth = '' 
            IF NOT cl_null(g_azp01_str) AND g_azp01_str <> "*" THEN
               LET g_chk_azp01 = FALSE 
               LET tok = base.StringTokenizer.create(g_azp01_str,"|") 
               LET g_azp01 = ""
               WHILE tok.hasMoreTokens() 
                  LET g_azp01 = tok.nextToken()
                  SELECT zxy03 INTO l_zxy03 FROM zxy_file WHERE zxy01 = g_user AND zxy03 = g_azp01
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
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF  
            END IF 
            IF g_chk_azp01 THEN
               DECLARE g400_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH g400_zxy_cs1 INTO l_zxy03 
                 IF g_chk_auth IS NULL THEN
                    LET g_chk_auth = "'",l_zxy03,"'"
                 ELSE
                    LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
                 END IF
               END FOREACH
               IF g_chk_auth IS NOT NULL THEN
                  LET g_chk_auth = "(",g_chk_auth,")"
               END IF 
            END IF
   
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw01"     
                   LET g_qryparam.state = "c" 
                   LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
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
         LET INT_FLAG = 0 CLOSE WINDOW artg400_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF

      LET l_num = tm.wc1.getIndexOf('azp01',1)
      IF l_num = 0 THEN
         CALL cl_err('','art-926',0) CONTINUE WHILE
      END IF
      
       
      CONSTRUCT BY NAME tm.wc ON ima131,ima01,oea01,oea02,
                                 lpk01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT                                   

         ON ACTION controlp
            CASE
              
               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima131_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
               WHEN INFIELD(oea01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oea01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea01
                  NEXT FIELD oea01
               WHEN INFIELD(lpk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lpk"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lpk01
                  NEXT FIELD lpk01
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
         LET INT_FLAG = 0 CLOSE WINDOW artg400_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF

      
      #DISPLAY BY NAME tm.a,tm.b,tm.more
      DISPLAY BY NAME tm.a,tm.b,tm.w,tm.x,tm.more   #FUN-BA0063 FROM FUN-BB0032

     #INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
      INPUT BY NAME tm.a,tm.b,tm.w,tm.x,tm.more WITHOUT DEFAULTS  #FUN-BA0063 FROM FUN-BB0032
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)      

         AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
         END IF         
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
         LET INT_FLAG = 0 CLOSE WINDOW artg400_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg400'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artg400','9031',1)
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
                       " '",tm.a CLIPPED,"'" ,
                       " '",tm.b CLIPPED,"'" ,
                       " '",tm.w CLIPPED,"'" ,   #FUN-BA0063 FROM FUN-BB0032
                       " '",tm.x CLIPPED,"'" ,   #FUN-BA0063 FROM FUN-BB0032
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg400',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg400_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg400()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg400_w
END FUNCTION 

FUNCTION artg400()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_sql     STRING  #TQC-B70066
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
      #    l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT             #TQC-B70066 mark    
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,          
          sr        RECORD 
                    oeaplant LIKE oea_file.oeaplant,
                    azp02    LIKE azp_file.azp02,
                    ima131   LIKE ima_file.ima131,
                    oba02    LIKE oba_file.oba02,
                    ima01    LIKE ima_file.ima01,
                    ima02    LIKE ima_file.ima02,
                    oeb05    LIKE oeb_file.oeb05,  #FUN-BA0063 FROM FUN-BB0032
                    oeb12    LIKE oeb_file.oeb12,  #FUN-BA0063 FROM FUN-BB0032
                    oeb14t   LIKE oeb_file.oeb14t,
                    lpk01    LIKE lpk_file.lpk01,
                    lpk04    LIKE lpk_file.lpk04,
                    oea23    LIKE oea_file.oea23,
                    oea24    LIKE oea_file.oea24
                    END RECORD,
          l_oba02   LIKE oba_file.oba02,
          l_lpk01_find LIKE type_file.num10, 
          l_azi10 LIKE azi_file.azi10
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?) "       #FUN-BA0063 FROM FUN-BB0032  add ?,?                                                                                                 
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                       
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #RUN-B80085--add--                                                                 
       CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
       EXIT PROGRAM                                                                                                                 
    END IF

    DROP TABLE artg400_tmp    
    CREATE TEMP TABLE artg400_tmp( 
           oeaplant LIKE oea_file.oeaplant, 
           azp02    LIKE azp_file.azp02, 
           ima131   LIKE ima_file.ima131,
           oba02    LIKE oba_file.oba02, 
           ima01    LIKE ima_file.ima01,
           ima02    LIKE ima_file.ima02, 
           oeb05    LIKE oeb_file.oeb05,  #FUN-BA0063 FROM FUN-BB0032
           oeb12    LIKE oeb_file.oeb12,  #FUN-BA0063 FROM FUN-BB0032
           oeb14t   LIKE oeb_file.oeb14t,    
           lpk01    LIKE lpk_file.lpk01,
           lpk04    LIKE lpk_file.lpk04)   
    DELETE FROM artg400_tmp
LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
               " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth ,
               " ORDER BY azp01 "

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
   FOREACH sel_azp01_cs INTO l_plant,l_azp02  
       IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
 CASE tm.a
 WHEN '1' 
   LET l_lpk01_find = tm.wc.getIndexOf('lpk01',1) 
      IF l_lpk01_find = 0 THEN 
            #LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,",
             LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,oeb05,SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                        "SUM(oeb14t),'','',oea23,oea24", 
                        " FROM ",cl_get_target_table(l_plant,'oea_file'),
                        " ,",cl_get_target_table(l_plant,'oeb_file'),		
                        " ,",cl_get_target_table(l_plant,'ima_file'),					
                        " WHERE oea01=oeb01",
                        " AND oeaplant='",l_plant,"' AND oeaconf = 'Y' ",  
                        " AND oeb04 = ima01 AND ",tm.wc CLIPPED, 
                        " GROUP BY oeaplant,ima131,ima01,ima02,oeb05,oea23,oea24"   #FUN-BA0063   add oeb05 (FUN-BB0032追單)
      ELSE 
        #LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,",
         LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,oeb05,SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                     "SUM(oeb14t),lpk01,lpk04,oea23,oea24", 
                     " FROM ",cl_get_target_table(l_plant,'oea_file'),
                     " ,",cl_get_target_table(l_plant,'oeb_file'),	
                     " ,",cl_get_target_table(l_plant,'lpk_file'),	
                     " ,",cl_get_target_table(l_plant,'lpj_file'),			
                     " ,",cl_get_target_table(l_plant,'ima_file'),					
                     " WHERE oea01=oeb01",
                     " AND oeaplant='",l_plant,"' AND oeaconf = 'Y' ",  
                     " AND lpk01=lpj01 AND oea87=lpj03",
                     " AND oeb04 = ima01 AND ",tm.wc CLIPPED, 
                     " GROUP BY oeaplant,ima131,ima01,ima02,oeb05,lpk01,lpk04,oea23,oea24"  #FUN-BA0063   add oeb05 (FUN-BB0032追單)

      END IF   

        CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
    WHEN '2'
        LET l_lpk01_find = tm.wc.getIndexOf('lpk01',1) 
      IF l_lpk01_find = 0 THEN 
            #LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,",
             LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,oeb05,SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                        "SUM(oeb14t),'','',oea23,oea24", 
                        " FROM ",cl_get_target_table(l_plant,'oea_file'),
                        " ,",cl_get_target_table(l_plant,'oeb_file'),		
                        " ,",cl_get_target_table(l_plant,'ima_file'),					
                        " WHERE oea01=oeb01",
                        " AND oeaplant='",l_plant,"' AND oeaconf = 'Y' ", 
                        " AND oeb24 = 0 AND oeb70 != 'Y'" , 
                        " AND oeb04 = ima01 AND ",tm.wc CLIPPED, 
                        " GROUP BY oeaplant,ima131,ima01,ima02,oeb05,oea23,oea24"      #FUN-BA0063   add oeb05 (FUN-BB0032追單)
        
      ELSE 
        #LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,",
         LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,oeb05,SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                     "SUM(oeb14t),lpk01,lpk04,oea23,oea24", 
                     " FROM ",cl_get_target_table(l_plant,'oea_file'),
                     " ,",cl_get_target_table(l_plant,'oeb_file'),	
                     " ,",cl_get_target_table(l_plant,'lpk_file'),	
                     " ,",cl_get_target_table(l_plant,'lpj_file'),			
                     " ,",cl_get_target_table(l_plant,'ima_file'),					
                     " WHERE oea01=oeb01",
                     " AND oeaplant='",l_plant,"' AND oeaconf = 'Y' ",  
                     " AND lpk01=lpj01 AND oea87=lpj03",
                     " AND oeb24 = 0 AND oeb70 != 'Y'" ,
                     " AND oeb04 = ima01 AND ",tm.wc CLIPPED, 
                     " GROUP BY oeaplant,ima131,ima01,ima02,oeb05,lpk01,lpk04,oea23,oea24"   #FUN-BA0063   add oeb05 (FUN-BB0032追單)
                
      END IF   

        CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
     WHEN '3'
        LET l_lpk01_find = tm.wc.getIndexOf('lpk01',1) 
      IF l_lpk01_find = 0 THEN 
            #LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,",
             LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,oeb05,SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                        "SUM(oeb14t),'','',oea23,oea24", 
                        " FROM ",cl_get_target_table(l_plant,'oea_file'),
                        " ,",cl_get_target_table(l_plant,'oeb_file'),		
                        " ,",cl_get_target_table(l_plant,'ima_file'),					
                        " WHERE oea01=oeb01",
                        " AND oeaplant='",l_plant,"' AND oeaconf = 'Y' ",
                        " AND oeb24 > 0 " , 
                        " AND oeb04 = ima01 AND ",tm.wc CLIPPED, 
                        " GROUP BY oeaplant,ima131,ima01,ima02,oeb05,oea23,oea24"   #FUN-BA0063   add oeb05 (FUN-BB0032追單)

      ELSE 
            #LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,",
             LET l_sql = "SELECT oeaplant,'',ima131,'',ima01,ima02,oeb05,SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                     "SUM(oeb14t),lpk01,lpk04,oea23,oea24", 
                     " FROM ",cl_get_target_table(l_plant,'oea_file'),
                     " ,",cl_get_target_table(l_plant,'oeb_file'),	
                     " ,",cl_get_target_table(l_plant,'lpk_file'),	
                     " ,",cl_get_target_table(l_plant,'lpj_file'),			
                     " ,",cl_get_target_table(l_plant,'ima_file'),					
                     " WHERE oea01=oeb01",
                     " AND oeaplant='",l_plant,"' AND oeaconf = 'Y' ",
                     " AND oeb24 > 0 ",
                     " AND lpk01=lpj01 AND oea87=lpj03",
                     " AND oeb04 = ima01 AND ",tm.wc CLIPPED, 
                     " GROUP BY oeaplant,ima131,ima01,ima02,oeb05,lpk01,lpk04,oea23,oea24"   #FUN-BA0063   add oeb05 (FUN-BB0032追單)

      END IF   

        CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
        
        OTHERWISE EXIT CASE
     END CASE           
    PREPARE artg400_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
       EXIT PROGRAM
    END IF
    DECLARE artg400_curs1 CURSOR FOR artg400_prepare1

    FOREACH artg400_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF


    LET l_sql="SELECT oba02 FROM ",cl_get_target_table(l_plant,'oba_file'),
                   " WHERE oba01 = '",sr.ima131,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_oba02_pre FROM l_sql
         EXECUTE sel_oba02_pre INTO l_oba02
           IF (SQLCA.sqlcode) OR (l_oba02 IS NULL) OR (l_oba02 = '') THEN
            LET l_oba02 =''
         END IF 
         IF  cl_null(sr.ima131) OR sr.ima131 =' ' THEN LET sr.ima131 = ' ' END IF
    LET l_sql="SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                   " WHERE azi01 = '",sr.oea23,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_azi10_pre FROM l_sql
         EXECUTE sel_azi10_pre INTO l_azi10 
         CASE l_azi10
            WHEN '1'
               LET sr.oeb14t = sr.oeb14t*sr.oea24 
            WHEN '2'  
               LET sr.oeb14t = sr.oeb14t/sr.oea24 
         END CASE
         INSERT INTO artg400_tmp
         VALUES(sr.oeaplant,l_azp02,sr.ima131,l_oba02,sr.ima01,
        #sr.ima02,sr.oeb14t,sr.lpk01,sr.lpk04)
         sr.ima02,sr.oeb05,sr.oeb12,sr.oeb14t,sr.lpk01,sr.lpk04)   #FUN-BA0063 FROM FUN-BB0032
         LET l_oba02 =''          
      END FOREACH 
  END FOREACH 
  CASE
   WHEN tm.b='1'
        #LET l_sql = " SELECT oeaplant,azp02,'','','','',",
         LET l_sql = " SELECT oeaplant,azp02,'','','','','',SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                " SUM(oeb14t),lpk01,lpk04,'','' ", 
                " FROM artg400_tmp", 
                " GROUP BY oeaplant,azp02,lpk01,lpk04",
                " ORDER BY oeaplant,azp02"
       WHEN tm.b='2'
         #LET l_sql = " SELECT oeaplant,azp02,'','',ima01,ima02,",
          LET l_sql = " SELECT oeaplant,azp02,'','',ima01,ima02,oeb05,SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                " SUM(oeb14t),lpk01,lpk04,'','' ",
                " FROM artg400_tmp", 
                " GROUP BY oeaplant,azp02,ima01,ima02,oeb05,lpk01,lpk04",   #FUN-BA0063   add oeb05 (FUN-BB0032追單)
                " ORDER BY oeaplant,azp02,ima01,ima02,oeb05"   #FUN-BA0063   add oeb05 (FUN-BB0032追單)
       WHEN tm.b='3'
         #LET l_sql =" SELECT oeaplant,azp02,ima131,oba02,'','',",
          LET l_sql =" SELECT oeaplant,azp02,ima131,oba02,'','','',SUM(oeb12),",  #FUN-BA0063 FROM FUN-BB0032
                " SUM(oeb14t),lpk01,lpk04,'','' ",
                " FROM artg400_tmp", 
                " GROUP BY oeaplant,azp02,ima131,oba02,lpk01,lpk04",
                " ORDER BY oeaplant,azp02,ima131,oba02"
    END CASE

    PREPARE artg400_prepare2 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
       EXIT PROGRAM
    END IF
    DECLARE artg400_curs2 CURSOR FOR artg400_prepare2

    FOREACH artg400_curs2 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      
      EXECUTE  insert_prep  USING  
      sr.oeaplant,sr.azp02,sr.ima131,sr.oba02,sr.ima01,
     #sr.ima02,sr.oeb14t,sr.lpk01,sr.lpk04
      sr.ima02,sr.oeb05,sr.oeb12,sr.oeb14t,sr.lpk01,sr.lpk04 #FUN-BA0063 FROM FUN-BB0032
    
   END FOREACH

###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_str = tm.wc,";",tm.w,";",tm.x   #FUN-BA0063 FROM FUN-BB0032 add tm.w,tm.x
   CASE
      WHEN tm.b='1'
###GENGRE###         CALL cl_prt_cs3('artg400','artg400_1',l_sql,g_str)  
         LET g_template = 'artg400'          #FUN-BA0063 add
         CALL artg400_grdata()    ###GENGRE###
      WHEN tm.b='2'
###GENGRE###         CALL cl_prt_cs3('artg400','artg400_2',l_sql,g_str) 
         LET g_template = 'artg400_1'          #FUN-BA0063 add
         CALL artg400_1_grdata()    ###GENGRE###
      WHEN tm.b='3'
###GENGRE###         CALL cl_prt_cs3('artg400','artg400_3',l_sql,g_str) 
         LET g_template = 'artg400_2'          #FUN-BA0063 add
         CALL artg400_2_grdata()    ###GENGRE###
   END CASE
   
END FUNCTION

###GENGRE###START
FUNCTION artg400_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg400")
        IF handler IS NOT NULL THEN
            START REPORT artg400_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(oeaplant)"  #FUN-BA0063 add
          
            DECLARE artg400_datacur1 CURSOR FROM l_sql
            FOREACH artg400_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg400_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg400_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg400_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-BA0063---------add------str-----
    DEFINE l_display  LIKE type_file.chr1
    DEFINE l_display1 LIKE type_file.chr1
    DEFINE sr1_o      sr1_t
    DEFINE l_oeb12_sum LIKE oeb_file.oeb12
    DEFINE l_oeb14t_sum LIKE oeb_file.oeb14t
    #FUN-BA0063---------add------end-----
    DEFINE l_oeaplant  LIKE oea_file.oeaplant  #FUN-CB0058    
    DEFINE l_azp02     LIKE azp_file.azp02     #FUN-CB0058    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-BA0063 add g_ptime,g_name_user
            PRINTX tm.*
            LET sr1_o.oeaplant = NULL  #FUN-BA0063
            LET sr1_o.azp02 = NULL     #FUN-BA0063
              
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-BA0063---------add------str-----
            IF NOT cl_null(sr1_o.oeaplant) THEN
               IF sr1_o.oeaplant = sr1.oeaplant AND tm.w = 'N'THEN
                  LET l_display = 'N'
                  LET l_oeaplant = "  "          #FUN-CB0058
               ELSE
                  LET l_display = 'Y'
                  LET l_oeaplant = sr1.oeaplant  #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_oeaplant = sr1.oeaplant   #FUN-CB0058
            END IF
            PRINTX l_display 

            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 = sr1.azp02 AND tm.w = 'N'THEN
                  LET l_display1 = 'N'
                  LET l_azp02 = sr1.azp02   #FUN-CB0058
               ELSE
                  LET l_display1 = 'Y'
                  LET l_azp02 = sr1.azp02   #FUN-CB0058
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azp02 = sr1.azp02   #FUN-CB0058
            END IF
            PRINTX l_display1 
     
            PRINTX l_oeaplant    #FUN-CB0058
            PRINTX l_azp02       #FUN-CB0058
            LET sr1_o.* = sr1.*
            #FUN-BA0063---------add------end-----

            PRINTX sr1.*

 
        ON LAST ROW
           #FUN-BA0063---------add------str-----
           LET l_oeb12_sum = SUM(sr1.oeb12)
           PRINTX l_oeb12_sum 
           LET l_oeb14t_sum = SUM(sr1.oeb14t)
           PRINTX l_oeb14t_sum 
           #FUN-BA0063---------add------end-----

END REPORT
###GENGRE###END
#FUN-BA0063-------add---str-------
FUNCTION artg400_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg400")
        IF handler IS NOT NULL THEN
            START REPORT artg400_1_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(oeaplant),lower(ima01)"          #FUN-BA0063 add

            DECLARE artg400_datacur2 CURSOR FROM l_sql
            FOREACH artg400_datacur2 INTO sr1.*
                OUTPUT TO REPORT artg400_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg400_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg400_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_display  LIKE type_file.chr1
    DEFINE l_display1 LIKE type_file.chr1
    DEFINE sr1_o      sr1_t
    #FUN-BA0063---------add------str-----
    DEFINE l_oeb12_sum LIKE oeb_file.oeb12
    DEFINE l_oeb14t_sum LIKE oeb_file.oeb14t
    DEFINE l_oeb12_sum1 LIKE oeb_file.oeb12
    DEFINE l_oeb14t_sum1 LIKE oeb_file.oeb14t
    #FUN-BA0063---------add------end-----
    DEFINE l_oeaplant  LIKE oea_file.oeaplant  #FUN-CB0058
    DEFINE l_azp02     LIKE azp_file.azp02     #FUN-CB0058


    ORDER EXTERNAL BY sr1.oeaplant,sr1.ima01

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-BA0063 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.oeaplant = NULL  #FUN-BA0063
            LET sr1_o.azp02 = NULL     #FUN-BA0063

        BEFORE GROUP OF sr1.oeaplant
        BEFORE GROUP OF sr1.ima01


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            IF NOT cl_null(sr1_o.oeaplant) THEN
               IF sr1_o.oeaplant = sr1.oeaplant AND tm.w = 'N'THEN
                  LET l_display = 'N'
                  LET l_oeaplant = "   "      #FUN-CB0058
               ELSE
                  LET l_display = 'Y'
                  LET l_oeaplant = sr1.oeaplant  #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_oeaplant = sr1.oeaplant  #FUN-CB0058
            END IF
            PRINTX l_display 

            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 = sr1.azp02 AND tm.w = 'N'THEN
                  LET l_display1 = 'N'
                  LET l_azp02 = "   "       #FUN-CB0058 
               ELSE
                  LET l_display1 = 'Y'
                  LET l_azp02 = sr1.azp02   #FUN-CB0058 
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azp02 = sr1.azp02   #FUN-CB0058 
            END IF
            PRINTX l_display1 
     
            PRINTX l_oeaplant    #FUN-CB0058
            PRINTX l_azp02       #FUN-CB0058
            LET sr1_o.* = sr1.*
            PRINTX sr1.*

        AFTER GROUP OF sr1.oeaplant
           #FUN-BA0063---------add------str-----
           LET l_oeb12_sum1 =GROUP SUM(sr1.oeb12)
           PRINTX l_oeb12_sum1
           LET l_oeb14t_sum1 =GROUP SUM(sr1.oeb14t)
           PRINTX l_oeb14t_sum1
           #FUN-BA0063---------add------end-----
        AFTER GROUP OF sr1.ima01


        ON LAST ROW
           #FUN-BA0063---------add------str-----
           LET l_oeb12_sum = SUM(sr1.oeb12)
           PRINTX l_oeb12_sum
           LET l_oeb14t_sum = SUM(sr1.oeb14t)
           PRINTX l_oeb14t_sum
           #FUN-BA0063---------add------end-----

END REPORT

FUNCTION artg400_2_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg400")
        IF handler IS NOT NULL THEN
            START REPORT artg400_2_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(oeaplant),lower(ima131)"          #FUN-BA0063 add

            DECLARE artg400_datacur3 CURSOR FROM l_sql
            FOREACH artg400_datacur3 INTO sr1.*
                OUTPUT TO REPORT artg400_2_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg400_2_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg400_2_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_display  LIKE type_file.chr1
    DEFINE l_display1 LIKE type_file.chr1
    DEFINE sr1_o      sr1_t
    #FUN-BA0063---------add------str-----
    DEFINE l_oeb12_sum LIKE oeb_file.oeb12
    DEFINE l_oeb14t_sum LIKE oeb_file.oeb14t
    DEFINE l_oeb12_sum1 LIKE oeb_file.oeb12
    DEFINE l_oeb14t_sum1 LIKE oeb_file.oeb14t
    #FUN-BA0063---------add------end-----
    DEFINE l_oeaplant  LIKE oea_file.oeaplant  #FUN-CB0058
    DEFINE l_azp02     LIKE azp_file.azp02     #FUN-CB0058



    ORDER EXTERNAL BY sr1.oeaplant,sr1.ima131

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-BA0063 add g_ptime,g_user_name
            PRINTX tm.*
            LET sr1_o.oeaplant = NULL  #FUN-BA0063
            LET sr1_o.azp02 = NULL     #FUN-BA0063

        BEFORE GROUP OF sr1.oeaplant
        BEFORE GROUP OF sr1.ima131


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            IF NOT cl_null(sr1_o.oeaplant) THEN
               IF sr1_o.oeaplant = sr1.oeaplant AND tm.w = 'N'THEN
                  LET l_display = 'N'
                  LET l_oeaplant = "   "       #FUN-CB0058 
               ELSE
                  LET l_display = 'Y'
                  LET l_oeaplant = sr1.oeaplant   #FUN-CB0058 
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_oeaplant = sr1.oeaplant   #FUN-CB0058 
            END IF
            PRINTX l_display

            IF NOT cl_null(sr1_o.azp02) THEN
               IF sr1_o.azp02 = sr1.azp02 AND tm.w = 'N'THEN
                  LET l_display1 = 'N'
                  LET l_azp02 = "   "       #FUN-CB0058 
               ELSE
                  LET l_display1 = 'Y'
                  LET l_azp02 = sr1.azp02   #FUN-CB0058 
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azp02 = sr1.azp02   #FUN-CB0058 
            END IF
            PRINTX l_display1

            LET sr1_o.* = sr1.*

            PRINTX l_oeaplant    #FUN-CB0058
            PRINTX l_azp02       #FUN-CB0058
            PRINTX sr1.*

        AFTER GROUP OF sr1.oeaplant
           #FUN-BA0063---------add------str-----
           LET l_oeb12_sum1 =GROUP SUM(sr1.oeb12)
           PRINTX l_oeb12_sum1
           LET l_oeb14t_sum1 =GROUP SUM(sr1.oeb14t)
           PRINTX l_oeb14t_sum1
           #FUN-BA0063---------add------end-----
        AFTER GROUP OF sr1.ima131


        ON LAST ROW
           #FUN-BA0063---------add------str-----
           LET l_oeb12_sum = SUM(sr1.oeb12)
           PRINTX l_oeb12_sum
           LET l_oeb14t_sum = SUM(sr1.oeb14t)
           PRINTX l_oeb14t_sum
           #FUN-BA0063---------add------end-----
END REPORT
#FUN-BA0063-------add---end-------
