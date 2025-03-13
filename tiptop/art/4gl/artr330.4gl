# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artr330.4gl
# Descriptions...: 营运中心补货汇总表
# Date & Author..: FUN-A60077 10/07/04 By shenyang
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.TQC-BB0036 11/11/11 By suncx 報表功能完善
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING, 
              wc1      STRING,    
              a       LIKE type_file.chr1,
              b       LIKE type_file.chr1,
              w       LIKE type_file.chr1,      #TQC-BB0036  add
              x       LIKE type_file.chr1,      #TQC-BB0036  add
              more    LIKE type_file.chr1       # Input more condition(Y/N)
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

   LET g_sql =  "azw01.azw_file.azw01,",
                "azp02.azp_file.azp02,",
                "ruc04.ruc_file.ruc04,",
                "ima02.ima_file.ima02,",
                "ruc13.ruc_file.ruc13,",  #TQC-BB0036
                "ruc07.ruc_file.ruc07,",
                "ruc18.ruc_file.ruc18,",
                "ruc19.ruc_file.ruc19,",
                "ruc20.ruc_file.ruc20,",
                "ruc21.ruc_file.ruc21,",
                "ruc27.ruc_file.ruc27"    #TQC-BB0036

   LET l_table = cl_prt_temptable('artr330',g_sql) CLIPPED
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
   LET tm.w = ARG_VAL(10)  #TQC-BB0036 
   LET tm.x = ARG_VAL(11)  #TQC-BB0036 
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artr330_tm(0,0)        # Input print condition
      ELSE CALL artr330()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN 
FUNCTION artr330_tm(p_row,p_col)
   DEFINE l_num          LIKE type_file.num10
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03        
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artr330_w AT p_row,p_col WITH FORM "art/42f/artr330" 
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
   LET tm.b = 'Y' 
   LET tm.w = 'Y'      #TQC-BB0036 add
   LET tm.x = 'Y'      #TQC-BB0036 add
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
               DECLARE r330_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r330_zxy_cs1 INTO l_zxy03 
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
         LET INT_FLAG = 0 CLOSE WINDOW artr330_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      LET l_num = tm.wc1.getIndexOf('azp01',1)
      IF l_num = 0 THEN
         CALL cl_err('','art-926',0) CONTINUE WHILE
      END IF
      CONSTRUCT BY NAME tm.wc ON ima131,ruc04,ruc07,ruc27
                                  
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
                  LET g_qryparam.form = "q_ima131"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
               WHEN INFIELD(ruc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ruc04"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ruc04
                  NEXT FIELD ruc04
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
         LET INT_FLAG = 0 CLOSE WINDOW artr330_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

    
     #DISPLAY BY NAME tm.a,tm.b,tm.more 
      DISPLAY BY NAME tm.a,tm.b,tm.w,tm.x,tm.more   #TQC-BB0036 add tm.w,tm.x
      
     #INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
      INPUT BY NAME tm.a,tm.b,tm.w,tm.x,tm.more WITHOUT DEFAULTS  #TQC-BB0036 add tm.w,tm.x

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)  
    AFTER FIELD b
         IF tm.b    NOT MATCHES "[YN]"  OR tm.b IS NULL THEN
                NEXT FIELD b
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
         LET INT_FLAG = 0 CLOSE WINDOW artr330_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr330'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr330','9031',1)
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
                       " '",tm.w CLIPPED,"'" ,      #TQC-BB0036 add
                       " '",tm.x CLIPPED,"'" ,      #TQC-BB0036 add
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr330',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr330_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr330()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr330_w
END FUNCTION 

FUNCTION artr330()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,          
          sr        RECORD 
                    azw01    LIKE azw_file.azw01,
                    azp02    LIKE azp_file.azp02,
                    ruc04    LIKE ruc_file.ruc04,
                    ima02    LIKE ima_file.ima02,
                    ruc13    LIKE ruc_file.ruc13,   #TQC-BB0036
                    ruc07    LIKE ruc_file.ruc07,
                    ruc18    LIKE ruc_file.ruc18,
                    ruc19    LIKE ruc_file.ruc19,
                    ruc20    LIKE ruc_file.ruc20,
                    ruc21    LIKE ruc_file.ruc21,
                    ruc27    LIKE ruc_file.ruc27    #TQC-BB0036
                    END RECORD
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?) "       #TQC-BB0036 add ?,?                                                                                                 
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                                   
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--                                                     
       EXIT PROGRAM                                                                                                                 
    END IF
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
CASE
   when tm.b = 'Y'
       CASE
       WHEN tm.a='1'
          LET l_sql =  " SELECT azw01,'','','','','', ",   
               #"ruc18,ruc19,ruc20,ruc21",
                "ruc18,ruc19,ruc20,ruc21,ruc27",   #TQC-BB0036
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED
       WHEN tm.a='2'
         #LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc07,",
          LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc13,'',",  #TQC-BB0036
               #"ruc18,ruc19,ruc20,ruc21",
                "ruc18,ruc19,ruc20,ruc21,ruc27",   #TQC-BB0036
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED
       WHEN tm.a='3'
          LET l_sql =  " SELECT azw01,'','','','',ruc07,",
               #"ruc18,ruc19,ruc20,ruc21",
                "ruc18,ruc19,ruc20,ruc21,ruc27",   #TQC-BB0036
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED
       #TQC-BB0036 add begin------------------------------------------
       WHEN tm.a='4'
          LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc13,ruc07,",  
                "ruc18,ruc19,ruc20,ruc21,ruc27",   
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED
       #TQC-BB0036 add end--------------------------------------------
    END CASE
   
   when  tm.b = 'N' 
        CASE
       WHEN tm.a='1'
          #LET l_sql =  " SELECT azw01,'','','','',",
          LET l_sql =  " SELECT azw01,'','','','','',", #TQC-BB0036
               #"SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21)",
                "SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21),''",  #TQC-BB0036
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED,
                " GROUP BY azw01 "  
       WHEN tm.a='2'
          #LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc07,",
          LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc13,'',",  #TQC-BB0036
               #"SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21)",
                "SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21),''",  #TQC-BB0036
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED,
                #" GROUP BY azw01,ruc04,ima02 " 
                " GROUP BY azw01,ruc04,ima02,ruc13"   #TQC-BB0036
       WHEN tm.a='3'
          #LET l_sql =  " SELECT azw01,'','','',ruc07,",
          LET l_sql =  " SELECT azw01,'','','','',ruc07,",  #TQC-BB0036 
               #"SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21)",
                "SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21),''",  #TQC-BB0036
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED,
                " GROUP BY azw01,ruc07"  
       #TQC-BB0036 add begin------------------------------------------
       WHEN tm.a='4'
          LET l_sql =  " SELECT azw01,'',ruc04,ima02,ruc13,ruc07,",  
                "SUM(ruc18),SUM(ruc19),SUM(ruc20),SUM(ruc21),''", 
                "  FROM ",cl_get_target_table(l_plant,'ruc_file'),
                ",",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                " WHERE ruc01=azw01 ",
                 " AND azw01 ='",l_plant,"'", 
                " AND ruc04=ima01 AND ",tm.wc CLIPPED,
                " GROUP BY azw01,ruc04,ima02,ruc07,ruc13" 
       #TQC-BB0036 add end--------------------------------------------
    END CASE   
 CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql     
 END CASE               
    PREPARE artr330_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    DECLARE artr330_curs1 CURSOR FOR artr330_prepare1

      FOREACH artr330_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF            
      EXECUTE  insert_prep  USING  
      #sr.azw01,l_azp02,sr.ruc04,sr.ima02,
      sr.azw01,l_azp02,sr.ruc04,sr.ima02,sr.ruc13, #TQC-BB0036
      sr.ruc07,sr.ruc18,sr.ruc19,sr.ruc20,sr.ruc21,sr.ruc27
   END FOREACH   
   END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #TQC-BB0036 add begin-----------
   CASE
      WHEN tm.a='1'
           LET l_sql = l_sql CLIPPED," ORDER BY azw01,ruc27"
      WHEN tm.a='2'
           LET l_sql = l_sql CLIPPED," ORDER BY azw01,ruc04,ruc27"
      WHEN tm.a='3'
           LET l_sql = l_sql CLIPPED," ORDER BY azw01,ruc07,ruc27"
      WHEN tm.a='4'
           LET l_sql = l_sql CLIPPED," ORDER BY azw01,ruc04,ruc07,ruc27"
   END CASE 
   #TQC-BB0036 add end------------
   #LET g_str = tm.wc1,";",tm.wc
  #LET g_str = tm.wc1,";",tm.wc,";",tm.w,";",tm.b,";",tm.x   #TQC-BB0036  #FUN-BC0026 mark
  #FUN-BC0026 add START
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'azp01')
      RETURNING tm.wc1
      CALL cl_wcchp(tm.wc,'ima131,ruc04,ruc07,ruc27')
      RETURNING tm.wc
      LET g_str =tm.wc1,";",tm.wc
      IF g_str.getLength() > 1000 THEN
         LET g_str = g_str.subString(1,600)
         LET g_str = g_str,"..."
      END IF
   END IF
   LET g_str = g_str,";",tm.w,";",tm.b,";",tm.x
  #FUN-BC0026 add END
   CASE
      WHEN tm.a='1'
         CALL cl_prt_cs3('artr330','artr330_1',l_sql,g_str)  
      WHEN tm.a='2'
         CALL cl_prt_cs3('artr330','artr330_2',l_sql,g_str) 
      WHEN tm.a='3'
         CALL cl_prt_cs3('artr330','artr330_3',l_sql,g_str) 
      WHEN tm.a='4'    #TQC-BB0036
         CALL cl_prt_cs3('artr330','artr330_4',l_sql,g_str)    #TQC-BB0036
   END CASE
END FUNCTION



      
