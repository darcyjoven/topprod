# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artr140.4gl
# Descriptions...: 條碼列印作業
# Date & Author..: FUN-A60077 10/06/30 By shenyang
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No:FUN-BB0014 11/11/04 By suncx 報表調整完善 
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項
DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD			               
                    wc1            STRING,   
                    wc            STRING,  
                   #s    LIKE type_file.chr20,      #FUN-BB0014 mark                       
                    b    LIKE type_file.chr1,          
                   #c    LIKE type_file.chr1,       #FUN-BB0014 mark
                    w    LIKE type_file.chr1,       #FUN-BB0014 add
                    d    LIKE type_file.chr1,          
                    more LIKE type_file.chr1                               
                 END RECORD,
       l_n       LIKE type_file.num5,                  
       g_start   LIKE type_file.chr1
DEFINE azw01     LIKE azw_file.azw01
DEFINE ima131   LIKE ima_file.ima131
DEFINE ima01     LIKE ima_file.ima01
DEFINE g_cnt     LIKE type_file.num10         
DEFINE g_type    LIKE type_file.chr1          
DEFINE g_i       LIKE type_file.num5     
DEFINE l_table   STRING 
# DEFINE l_table1  STRING   
DEFINE g_sql     STRING
DEFINE g_str     STRING
DEFINE   g_chk_azp01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING  
DEFINE   g_azp01         LIKE azp_file.azp01 
DEFINE   g_azp01_str     STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 #  CALL cl_used(g_prog,g_time,1) RETURNING g_time 
  #LET g_sql =  "order1.type_file.chr20,",  #FUN-BB0014 mark
   LET g_sql =  "ima131.ima_file.ima131,",  
                "azw01.azw_file.azw01,",
                "ima01.ima_file.ima01,",
                "azw08.azw_file.azw08,",
                "ima02.ima_file.ima02,",
                "gfe02.gfe_file.gfe02,",    
                "rtg04.rtg_file.rtg04,",
                "rtg05.rtg_file.rtg05,",    
                "rtg06.rtg_file.rtg06,",
                "rtg07.rtg_file.rtg07,", 
                "rtg08.rtg_file.rtg08,", 
                "rth04.rth_file.rth04,",
                "rth05.rth_file.rth05,",
                "rth06.rth_file.rth06"

   LET l_table = cl_prt_temptable("artr140",g_sql) CLIPPED                                                                          
 #  IF  l_table = -1 THEN EXIT PROGRAM END IF  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                  
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.s  = ARG_VAL(8)    #FUN-BB0014 mark
   LET tm.b = ARG_VAL(8) 
  #LET tm.c  = ARG_VAL(10)   #FUN-BB0014 mark
   LET tm.d  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  
      CALL artr140_tm(0,0)                        
   ELSE
      CALL artr140()                              
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN 
 
FUNCTION artr140_tm(p_row,p_col)
   DEFINE l_num          LIKE type_file.num10
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000  
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03 
       
   LET p_row = 3 LET p_col = 16 
   OPEN WINDOW artr140_w AT p_row,p_col WITH FORM "art/42f/artr140" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.s  = ''     #FUN-BB0014 mark
   LET tm.b = 'Y'
  #LET tm.c = 'N'     #FUN-BB0014 mark
   LET tm.w = 'Y'     #FUN-BB0014 add
   LET tm.d = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
  #LET tm2.s1   = tm.s[1,1]   #FUN-BB0014 mark
  #IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF  #FUN-BB0014 mark
   
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
               DECLARE r140_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r140_zxy_cs1 INTO l_zxy03 
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
              WHEN INFIELD(azp01)   #來源營運中心 #FUN-A60077
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
         LET INT_FLAG = 0 CLOSE WINDOW artr140_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      LET l_num = tm.wc1.getIndexOf('azp01',1)
      IF l_num = 0 THEN
         CALL cl_err('','art-926',0) CONTINUE WHILE
      END IF
      
CONSTRUCT BY NAME tm.wc ON ima131,ima01
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
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_ima131"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima131
               NEXT FIELD ima131
            WHEN INFIELD(ima01)
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_ima01"
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
            
      END CONSTRUCT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = "" 
         CALL cl_dynamic_locale()    
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr140_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
  #  IF tm.wc= ' 1=1'  THEN
  #    CALL cl_err(' ','9046',0)
 #     CONTINUE WHILE
 #  END IF
 #     DISPLAY BY NAME tm.a,tm.b,tm.c,tm.more
    #INPUT BY NAME   tm2.s1,tm.b,tm.c,tm.d,tm.more  #FUN-BB0014 mark
     INPUT BY NAME   tm.b,tm.w,tm.d,tm.more
                     WITHOUT DEFAULTS   

        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        
      AFTER FIELD b
         IF tm.b    NOT MATCHES "[YN]"  OR tm.b IS NULL THEN
                NEXT FIELD b
         END IF
      #FUN-BB0014 mark begin--------------------
      #AFTER FIELD c
      #   IF tm.c    NOT MATCHES "[YN]" OR tm.c IS NULL  THEN
      #          NEXT FIELD c
      # END IF
      #FUN-BB0014 mark end----------------------
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL  THEN
             NEXT FIELD more
         END IF
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
         AFTER INPUT         
        #LET tm.s = tm2.s1[1,1]  #FUN-BB0014 mark  
         
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
         LET INT_FLAG = 0 CLOSE WINDOW artr140_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr140'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr140','9031',1)
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
                      #" '",tm.s CLIPPED,"'" ,   #FUN-BB0014 mark
                       " '",tm.w CLIPPED,"'" ,   #FUN-BB0014 add
                       " '",tm.b CLIPPED,"'" ,
                      #" '",tm.c CLIPPED,"'" ,   #FUN-BB0014 mark
                       " '",tm.d CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr140',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr140()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr140_w
END FUNCTION 

FUNCTION artr140()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000, 
        #  l_sql1     LIKE type_file.chr1000,		
        #  l_sql2     LIKE type_file.chr1000, 
        #  rtg08    LIKE rtg_file.rtg08,          
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,       
          l_order   ARRAY[5] OF LIKE type_file.chr20,       
          sr        RECORD  
                     #order1   LIKE type_file.chr20,  #FUN-BB0014 MARK
                      ima131   LIKE ima_file.ima131,
                      azw01    LIKE azw_file.azw01,
                      ima01    LIKE ima_file.ima01,
                      azw08    LIKE azw_file.azw08,
                      ima02    LIKE ima_file.ima02,
                      gfe02    LIKE gfe_file.gfe02,
                      rtg04    LIKE rtg_file.rtg04,
                      rtg05    LIKE rtg_file.rtg05,
                      rtg06    LIKE rtg_file.rtg06,
                      rtg07    LIKE rtg_file.rtg07,
                      rtg08    LIKE rtg_file.rtg08,
                      rth04    LIKE rth_file.rth04,
                      rth05    LIKE rth_file.rth05,
                      rth06    LIKE rth_file.rth06
                     END RECORD,
         l_rth04     LIKE rth_file.rth04,           
         l_rth05     LIKE rth_file.rth05, 
         l_rth06     LIKE rth_file.rth06          
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='artr140'
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oqtuser', 'oqtgrup')
    CALL cl_del_data(l_table)                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
           " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  
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
      
    LET l_sql= "SELECT unique ima131,azw01,ima01,azw08,ima02,gfe02,rtg04, ",   
              "rtg05,rtg06,rtg07,rtg08,'','','' ",
              "  FROM ",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'rtd_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                ",",cl_get_target_table(l_plant,'gfe_file'),
                ",",cl_get_target_table(l_plant,'rtz_file'),
                ",",cl_get_target_table(l_plant,'rtg_file'),
              " WHERE  rtg03=ima01 ",
              " AND azw01 ='",l_plant,"'", 
              " AND azw01=rtz01 AND rtz05=rtg01 AND rtg04=gfe01 ",
              "  AND ",tm.wc CLIPPED 
   #FUN-BB0014 add begin--------------------------------------
    CASE tm.d
       WHEN '1'
          LET l_sql= l_sql," ORDER BY azw01,ima01,ima131"
       WHEN '2'
          LET l_sql= l_sql," ORDER BY ima131,ima01,azw01"
       WHEN '3'
          LET l_sql= l_sql," ORDER BY ima01,azw01,ima131"
    END CASE 
   #FUN-BB0014 add end----------------------------------------
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
    PREPARE r140_prepare  FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
   DECLARE r140_curs1 CURSOR FOR r140_prepare
 
    FOREACH r140_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
        
 IF sr.rtg08='Y'  THEN
    SELECT rth04,rth05,rth06 INTO l_rth04,l_rth05,l_rth06 
    FROM  rth_file,rtg_file  
    WHERE rth02=sr.rtg04  
ELSE
  LET   l_rth04=null
  LET   l_rth05=null
  LET   l_rth06=null 
 END IF
#FUN-BB0014 mark begin----------------------------- 
#     let g_i = 1 
#         CASE 
#              WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.azw01
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima131
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima01
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#     
#      LET sr.order1 = l_order[1]
#FUN-BB0014 mark end-------------------------------
   EXECUTE  insert_prep  USING 
   #sr.order1,sr.ima131,sr.azw01,sr.ima01,sr.azw08,sr.ima02,sr.gfe02,   #FUN-BB0014 mark
    sr.ima131,sr.azw01,sr.ima01,sr.azw08,sr.ima02,sr.gfe02,
    sr.rtg04,sr.rtg05,sr.rtg06,sr.rtg07,sr.rtg08,l_rth04,l_rth05,l_rth06 
  END FOREACH
END FOREACH

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #FUN-BB0014 add begin--------------------------------------
   CASE tm.d
      WHEN '1'
         LET l_sql= l_sql," ORDER BY azw01,ima01,ima131"
      WHEN '2'
         LET l_sql= l_sql," ORDER BY ima131,ima01,azw01"
      WHEN '3'
         LET l_sql= l_sql," ORDER BY ima01,azw01,ima131"
   END CASE
  #LET g_str = tm.wc1,";",tm.wc,";",tm.w,";",tm.b  #FUN-BC0026 mark
   #FUN-BB0014 add end----------------------------------------
  #FUN-BC0026 add START
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'azp01')
      RETURNING tm.wc1
      CALL cl_wcchp(tm.wc,'ima131,ima01')
      RETURNING tm.wc
      LET g_str = tm.wc1,";",tm.wc
      IF g_str.getLength() > 1000 THEN
         LET g_str = g_str.subString(1,600)
         LET g_str = g_str,"..."
      END IF
   END IF
   LET g_str = g_str,";",tm.w,";",tm.b
  #FUN-BC0026 add END  
   CASE
      WHEN tm.d='1'
         CALL cl_prt_cs3('artr140','artr140',l_sql,g_str)  
      WHEN tm.d='2'
         CALL cl_prt_cs3('artr140','artr140_1',l_sql,g_str) 
      WHEN tm.d='3'
         CALL cl_prt_cs3('artr140','artr140_2',l_sql,g_str) 
   END CASE
END FUNCTION   
