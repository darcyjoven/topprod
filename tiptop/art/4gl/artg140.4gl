# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: artg140.4gl
# Descriptions...: 條碼列印作業
# Date & Author..: FUN-A60077 10/06/30 By shenyang
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BA0063 11/10/17 By yangtt CR轉換成GRW
# Modify.........: No.FUN-BA0063 12/01/06 By qirl FUN-BB0014追單
# Modify.........: No.FUN-C50005 12/05/15 By qirl GR程式優化
# Modify.........: No.FUN-CA0118 12/10/22 By Sakura 重新過單
# Modify.........: NO.FUN-CB0058 12/11/23 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點
# Modify.........: NO.FUN-CC0088 12/12/24 By dongsz 過單處理

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD			               
                    wc1            STRING,   
                    wc            STRING,  
                 #  s    LIKE type_file.chr20,           #NO.FUN-BA0063 mark                  
                    b    LIKE type_file.chr1,          
                 #  c    LIKE type_file.chr1,            #NO.FUN-BA0063 mark
                    w    LIKE type_file.chr1,            #NO.FUN-BA0063 add
                    d    LIKE type_file.chr1,          
                    more LIKE type_file.chr1                               
                 END RECORD,
       l_n       LIKE type_file.num5,                  
       g_start   LIKE type_file.chr1
DEFINE azw01     LIKE azw_file.azw01
DEFINE ima131    LIKE ima_file.ima131          
DEFINE oba02     LIKE oba_file.oba02            # No.FUN-C50005 add
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

###GENGRE###START
TYPE sr1_t RECORD
#   order1 LIKE type_file.chr20,   #NO.FUN-BA0063 mark
    ima131 LIKE ima_file.ima131,
    oba02  LIKE oba_file.oba02,           # No.FUN-C50005 add
    azw01 LIKE azw_file.azw01,
    ima01 LIKE ima_file.ima01,
    azw08 LIKE azw_file.azw08,
    ima02 LIKE ima_file.ima02,
    gfe02 LIKE gfe_file.gfe02,
    rtg04 LIKE rtg_file.rtg04,
    rtg05 LIKE rtg_file.rtg05,
    rtg06 LIKE rtg_file.rtg06,
    rtg07 LIKE rtg_file.rtg07,
    rtg08 LIKE rtg_file.rtg08,
    rth04 LIKE rth_file.rth04,
    rth05 LIKE rth_file.rth05,
    rth06 LIKE rth_file.rth06
END RECORD
###GENGRE###END

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
 # LET g_sql =  "order1.type_file.chr20,",    #NO.FUN-BA0063 mark
   LET g_sql =  "ima131.ima_file.ima131,",
                "oba02.oba_file.oba02,",        # No.FUN-C50005 add
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

   LET l_table = cl_prt_temptable("artg140",g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                  
   LET g_pdate = ARG_VAL(1)		      # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
 # LET tm.s  = ARG_VAL(8)          #NO.FUN-BA0063 mark
   LET tm.b = ARG_VAL(9)
 # LET tm.c  = ARG_VAL(10)         #NO.FUN-BA0063 mark
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  
      CALL artg140_tm(0,0)                        
   ELSE
      CALL artg140()                              
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
END MAIN 
 
FUNCTION artg140_tm(p_row,p_col)
   DEFINE l_num          LIKE type_file.num10
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000  
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03 
       
   LET p_row = 3 LET p_col = 16 
   OPEN WINDOW artg140_w AT p_row,p_col WITH FORM "art/42f/artg140" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
 # LET tm.s  = ''     #NO.FUN-BA0063 mark
   LET tm.b = 'Y'
 # LET tm.c = 'N'     #NO.FUN-BA0063 mark
   LET tm.w = 'Y'     #NO.FUN-BA0063 add
   LET tm.d = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'  
#  LET tm2.s1   = tm.s[1,1]                             #NO.FUN-BA0063 mark
#  IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF      #NO.FUN-BA0063 mark
   
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
               DECLARE g140_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH g140_zxy_cs1 INTO l_zxy03 
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
         LET INT_FLAG = 0 CLOSE WINDOW artg140_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
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
         LET INT_FLAG = 0 CLOSE WINDOW artg140_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
  #  IF tm.wc= ' 1=1'  THEN
  #    CALL cl_err(' ','9046',0)
 #     CONTINUE WHILE
 #  END IF
 #     DISPLAY BY NAME tm.a,tm.b,tm.c,tm.more
  #   INPUT BY NAME   tm2.s1,tm.b,tm.c,tm.d,tm.more    #NO.FUN-BA0063 mark
      INPUT BY NAME   tm.b,tm.w,tm.d,tm.more           #NO.FUN-BA0063 add 
                     WITHOUT DEFAULTS   

        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        
      AFTER FIELD b
         IF tm.b    NOT MATCHES "[YN]"  OR tm.b IS NULL THEN
                NEXT FIELD b
         END IF
     #NO.FUN-BA0063 mark begin--------------------
     #AFTER FIELD c
     #   IF tm.c    NOT MATCHES "[YN]" OR tm.c IS NULL  THEN
     #          NEXT FIELD c
     # END IF
     #NO.FUN-BA0063 mark end----------------------
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
       # LET tm.s = tm2.s1[1,1]     #NO.FUN-BA0063 mark 
         
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
         LET INT_FLAG = 0 CLOSE WINDOW artg140_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artg140'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artg140','9031',1)
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
                  #    " '",tm.s CLIPPED,"'" ,   #NO.FUN-BA0063 mark
                       " '",tm.w CLIPPED,"'" ,   #NO.FUN-BA0063 add
                       " '",tm.b CLIPPED,"'" ,
                  #    " '",tm.c CLIPPED,"'" ,   #NO.FUN-BA0063 mark
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg140',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg140()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg140_w
END FUNCTION 

FUNCTION artg140()
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
           #          order1   LIKE type_file.chr20,    #NO.FUN-BA0063 mark
                      ima131   LIKE ima_file.ima131,
                      oba02    LIKE oba_file.oba02,    # No.FUN-C50005 add
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
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='artg140'
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oqtuser', 'oqtgrup')
    CALL cl_del_data(l_table)                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
           " VALUES(?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"      #NO.FUN-BA0063 del ? # No.FUN-C50005 add ?
   PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)         
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-BA0063--add--                                                                               
       CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
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
      
    LET l_sql= "SELECT unique ima131,oba02,azw01,ima01,azw08,ima02,gfe02,rtg04, ",   #NO.FUN-BA0063 del ''   # No.FUN-C50005 add  oba02 
              "rtg05,rtg06,rtg07,rtg08,'','','' ",
              "  FROM ",cl_get_target_table(l_plant,'azw_file'),
                ",",cl_get_target_table(l_plant,'rtd_file'),
                ",",cl_get_target_table(l_plant,'ima_file'),
                ",",cl_get_target_table(l_plant,'oba_file'),
                ",",cl_get_target_table(l_plant,'gfe_file'),
                ",",cl_get_target_table(l_plant,'rtz_file'),
                ",",cl_get_target_table(l_plant,'rtg_file'),
              " WHERE  rtg03=ima01 ",
              " AND ima131 = oba01 ",
              " AND azw01 ='",l_plant,"'", 
              " AND azw01=rtz01 AND rtz05=rtg01 AND rtg04=gfe01 ",
              "  AND ",tm.wc CLIPPED 
    #NO.FUN-BA0063 add begin--------------------------------------
    CASE tm.d
       WHEN '1'
          LET l_sql= l_sql," ORDER BY azw01,ima01,ima131"
       WHEN '2'
          LET l_sql= l_sql," ORDER BY ima131,ima01,azw01"
       WHEN '3'
          LET l_sql= l_sql," ORDER BY ima01,azw01,ima131"
    END CASE
   #NO.FUN-BA0063 add end----------------------------------------
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql 
    PREPARE g140_prepare  FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
       EXIT PROGRAM
    END IF
   DECLARE g140_curs1 CURSOR FOR g140_prepare
 
    FOREACH g140_curs1 INTO sr.*
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
#NO.FUN-BA0063 mark begin-----------------------------
#    let g_i = 1 
#        CASE 
#             WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.azw01
#             WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima131
#             WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima01
#             OTHERWISE LET l_order[g_i] = '-'
#        END CASE
#    
#     LET sr.order1 = l_order[1]
#NO.FUN-BA0063 mark end-----------------------------
      
   EXECUTE  insert_prep  USING 
  # sr.order1,sr.ima131,sr.azw01,sr.ima01,sr.azw08,sr.ima02,sr.gfe02,         #NO.FUN-BA0063 mark
    sr.ima131,sr.oba02,sr.azw01,sr.ima01,sr.azw08,sr.ima02,sr.gfe02,   # No.FUN-C50005 add sr.oba02       #NO.FUN-BA0063 add
    sr.rtg04,sr.rtg05,sr.rtg06,sr.rtg07,sr.rtg08,l_rth04,l_rth05,l_rth06 
  END FOREACH
END FOREACH

###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
               #NO.FUN-BA0063 add begin--------------------------------------
###GENGRE###   CASE tm.d
###GENGRE###      WHEN '1'
###GENGRE###         LET l_sql= l_sql," ORDER BY azw01,ima01,ima131"
###GENGRE###      WHEN '2'
###GENGRE###         LET l_sql= l_sql," ORDER BY ima131,ima01,azw01"
###GENGRE###      WHEN '3'
###GENGRE###         LET l_sql= l_sql," ORDER BY ima01,azw01,ima131"
###GENGRE###   END CASE
###GENGRE###   LET g_str = tm.wc1,";",tm.wc,";",tm.w,";",tm.b
              #NO.FUN-BA0063 add end----------------------------------------
###GENGRE###   LET g_str = tm.wc1,";",tm.wc              #NO.FUN-BA0063 mark
  
 CASE
      WHEN tm.d='1'
###GENGRE###         CALL cl_prt_cs3('artg140','artg140',l_sql,g_str)  
         LET g_template = 'artg140'    #FUN-BA0063 add
         CALL artg140_grdata()    ###GENGRE###
      WHEN tm.d='2'
###GENGRE###         CALL cl_prt_cs3('artg140','artg140_1',l_sql,g_str) 
         LET g_template = 'artg140_1'    #FUN-BA0063 add
         CALL artg140_1_grdata()    ###GENGRE###
      WHEN tm.d='3'
###GENGRE###         CALL cl_prt_cs3('artg140','artg140_2',l_sql,g_str) 
         LET g_template = 'artg140_2'    #FUN-BA0063 add
         CALL artg140_2_grdata()    ###GENGRE###
   END CASE
END FUNCTION   

#FUN-BA0063---------add-----str----
FUNCTION artg140_2_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg140")
        IF handler IS NOT NULL THEN
            START REPORT artg140_2_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
               #         ," ORDER BY lower(ima01)" #FUN-BA0063 add
                       ," ORDER BY lower(ima01),azw01,ima131" #FUN-BA0063 add
            DECLARE artg140_datacur3 CURSOR FROM l_sql
            FOREACH artg140_datacur3 INTO sr1.*
                OUTPUT TO REPORT artg140_2_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg140_2_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg140_2_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE sr1_o       sr1_t
    DEFINE l_display   LIKE type_file.chr1
    DEFINE l_display1  LIKE type_file.chr1
    DEFINE l_display2  LIKE type_file.chr1
    DEFINE l_display3  LIKE type_file.chr1
    DEFINE l_display4  LIKE type_file.chr1
    DEFINE l_oba02     STRING          # No.FUN-C50005 add
    DEFINE l_azw01     LIKE azw_file.azw01        #FUN-CB0058
    DEFINE l_azw08     LIKE azw_file.azw08        #FUN-CB0058
    DEFINE l_ima01     LIKE ima_file.ima01        #FUN-CB0058
    DEFINE l_ima02     LIKE ima_file.ima02        #FUN-CB0058


    ORDER EXTERNAL BY sr1.ima01      

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-BA0063 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-BA0063------add----str---
            LET sr1_o.azw01 = NULL
            LET sr1_o.azw08 = NULL
            LET sr1_o.ima01 = NULL
            LET sr1_o.ima02 = NULL
            LET sr1_o.ima131 = NULL
            #FUN-BA0063------add----end---

        BEFORE GROUP OF sr1.ima01


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            IF NOT cl_nulL(sr1.azw01) THEN
               IF sr1_o.azw01 = sr1.azw01 AND tm.w = 'N' THEN
                  LET l_display = 'N'
                  LET l_azw01 = "    "        #FUN-CB0058
               ELSE
                  LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01     #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_azw01 = sr1.azw01     #FUN-CB0058
            END IF
            PRINTX l_display

            IF NOT cl_nulL(sr1.azw08) THEN
               IF sr1_o.azw08 = sr1.azw08 AND tm.w = 'N' THEN
                  LET l_display1 = 'N'
                  LET l_azw08 = "    "        #FUN-CB0058
               ELSE
                  LET l_display1 = 'Y'
                  LET l_azw08 = sr1.azw08     #FUN-CB0058
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azw08 = sr1.azw08     #FUN-CB0058
            END IF
            PRINTX l_display1

            IF NOT cl_nulL(sr1.ima01) THEN
               IF sr1_o.ima01 = sr1.ima01 AND tm.w = 'N' THEN
                  LET l_display2 = 'N'
                  LET l_ima01 = sr1.ima01     #FUN-CB0058
               ELSE
                  LET l_display2 = 'Y'
                  LET l_ima01 = "   "         #FUN-CB0058
               END IF
            ELSE
               LET l_display2 = 'Y'
               LET l_ima01 = sr1.ima01     #FUN-CB0058
            END IF
            PRINTX l_display2

            IF NOT cl_nulL(sr1.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02 AND tm.w = 'N' THEN
                  LET l_display3 = 'N'
                  LET l_ima02 = "   "         #FUN-CB0058
               ELSE
                  LET l_display3 = 'Y'
                  LET l_ima02 = sr1.ima02     #FUN-CB0058
               END IF
            ELSE
               LET l_display3 = 'Y'
               LET l_ima02 = sr1.ima02     #FUN-CB0058
            END IF
            PRINTX l_display3

            LET l_oba02 = sr1.ima131,' ',sr1.oba02    # No.FUN-C50005 add
            IF NOT cl_nulL(sr1.ima131) AND tm.w = 'N' THEN
               IF sr1_o.ima131 = sr1.ima131 THEN
                  LET l_display4 = 'N'
                  LET l_oba02 = "   "         #FUN-CB0058
               ELSE
                  LET l_display4 = 'Y'
                  LET l_oba02 = l_oba02       #FUN-CB0058
               END IF
            ELSE
               LET l_display4 = 'Y'
               LET l_oba02 = l_oba02       #FUN-CB0058
            END IF
            PRINTX l_display4
            PRINTX l_oba02                            # No.FUN-C50005 add
            PRINTX l_azw01      #FUN-CB0058
            PRINTX l_azw08      #FUN-CB0058
            PRINTX l_ima01      #FUN-CB0058
            PRINTX l_ima02      #FUN-CB0058

            PRINTX sr1.*

        AFTER GROUP OF sr1.ima01


        ON LAST ROW

END REPORT

FUNCTION artg140_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg140")
        IF handler IS NOT NULL THEN
            START REPORT artg140_1_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#                        ," ORDER BY lower(ima131)" #FUN-BA0063 add
                      ," ORDER BY lower(ima131),ima01,azw01" #FUN-BA0063 add

            DECLARE artg140_datacur2 CURSOR FROM l_sql
            FOREACH artg140_datacur2 INTO sr1.*
                OUTPUT TO REPORT artg140_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg140_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg140_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE sr1_o       sr1_t
    DEFINE l_display   LIKE type_file.chr1
    DEFINE l_display1  LIKE type_file.chr1
    DEFINE l_display2  LIKE type_file.chr1
    DEFINE l_display3  LIKE type_file.chr1
    DEFINE l_display4  LIKE type_file.chr1
    DEFINE l_oba02     STRING       # No.FUN-C50005 add
    DEFINE l_azw01     LIKE azw_file.azw01        #FUN-CB0058
    DEFINE l_azw08     LIKE azw_file.azw08        #FUN-CB0058
    DEFINE l_ima01     LIKE ima_file.ima01        #FUN-CB0058
    DEFINE l_ima02     LIKE ima_file.ima02        #FUN-CB0058


    ORDER EXTERNAL BY sr1.ima131

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-BA0063 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-BA0063------add----str---
            LET sr1_o.azw01 = NULL
            LET sr1_o.azw08 = NULL
            LET sr1_o.ima01 = NULL
            LET sr1_o.ima02 = NULL
            LET sr1_o.ima131 = NULL
            #FUN-BA0063------add----end---

        BEFORE GROUP OF sr1.ima131


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            IF NOT cl_nulL(sr1.azw01) THEN
               IF sr1_o.azw01 = sr1.azw01 AND tm.w = 'N' THEN
                  LET l_display = 'N'
                  LET l_azw01 = "   "          #FUN-CB0058
               ELSE
                  LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01      #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_azw01 = sr1.azw01      #FUN-CB0058
            END IF
            PRINTX l_display

            IF NOT cl_nulL(sr1.azw08) THEN
               IF sr1_o.azw08 = sr1.azw08 AND tm.w = 'N' THEN
                  LET l_display1 = 'N'
                  LET l_azw08 = "    "         #FUN-CB0058
               ELSE
                  LET l_display1 = 'Y'
                  LET l_azw08 = sr1.azw08      #FUN-CB0058
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azw08 = sr1.azw08      #FUN-CB0058
            END IF
            PRINTX l_display1

            IF NOT cl_nulL(sr1.ima01) THEN
               IF sr1_o.ima01 = sr1.ima01 AND tm.w = 'N' THEN
                  LET l_display2 = 'N'
                  LET l_ima01 = "    "        #FUN-CB0058
               ELSE
                  LET l_display2 = 'Y'
                  LET l_ima01 = sr1.ima01     #FUN-CB0058
               END IF
            ELSE
               LET l_display2 = 'Y'
               LET l_ima01 = sr1.ima01     #FUN-CB0058
            END IF
            PRINTX l_display2

            IF NOT cl_nulL(sr1.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02 AND tm.w = 'N' THEN
                  LET l_display3 = 'N'
                  LET l_ima02 = "    "        #FUN-CB0058
               ELSE
                  LET l_display3 = 'Y'
                  LET l_ima02 = sr1.ima02     #FUN-CB0058
               END IF
            ELSE
               LET l_display3 = 'Y'
               LET l_ima02 = sr1.ima02     #FUN-CB0058
            END IF
            PRINTX l_display3

            LET l_oba02 = sr1.ima131,' ',sr1.oba02    # No.FUN-C50005 add
            IF NOT cl_nulL(sr1.ima131) THEN
               IF sr1_o.ima131 = sr1.ima131 AND tm.w = 'N' THEN
                  LET l_display4 = 'N'
                  LET l_oba02 = "    "     #FUN-CB0058
               ELSE
                  LET l_display4 = 'Y'
                  LET l_oba02 = l_oba02    #FUN-CB0058
               END IF
            ELSE
               LET l_display4 = 'Y'
               LET l_oba02 = l_oba02    #FUN-CB0058
            END IF
            PRINTX l_display4
            PRINTX l_azw01      #FUN-CB0058
            PRINTX l_azw08      #FUN-CB0058
            PRINTX l_ima01      #FUN-CB0058
            PRINTX l_ima02      #FUN-CB0058

            PRINTX sr1.*

            PRINTX l_oba02                            # No.FUN-C50005 add
        AFTER GROUP OF sr1.ima131


        ON LAST ROW

END REPORT
#FUN-BA0063---------add-----end----

###GENGRE###START
FUNCTION artg140_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg140")
        IF handler IS NOT NULL THEN
            START REPORT artg140_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
              #          ," ORDER BY lower(azw01)" #FUN-BA0063 add
                   ," ORDER BY lower(azw01),ima01,ima131" #FUN-BA0063 add
            DECLARE artg140_datacur1 CURSOR FROM l_sql
            FOREACH artg140_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg140_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg140_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg140_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_oba02  STRING                # No.FUN-C50005 add
    #FUN-BA0063------add---str---
    DEFINE sr1_o       sr1_t
    DEFINE l_display   LIKE type_file.chr1
    DEFINE l_display1  LIKE type_file.chr1
    DEFINE l_display2  LIKE type_file.chr1
    DEFINE l_display3  LIKE type_file.chr1
    DEFINE l_display4  LIKE type_file.chr1
    #FUN-BA0063------add---end---
    DEFINE l_azw01     LIKE azw_file.azw01        #FUN-CB0058
    DEFINE l_azw08     LIKE azw_file.azw08        #FUN-CB0058

    
    ORDER EXTERNAL BY sr1.azw01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-BA0063 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-BA0063------add----str---
            LET sr1_o.azw01 = NULL
            LET sr1_o.azw08 = NULL
            LET sr1_o.ima01 = NULL
            LET sr1_o.ima02 = NULL
            LET sr1_o.ima131 = NULL
            #FUN-BA0063------add----end---
              
        BEFORE GROUP OF sr1.azw01

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-BA0063-------add----str----
            IF NOT cl_nulL(sr1.azw01) THEN
               IF sr1_o.azw01 = sr1.azw01 AND tm.w = 'N' THEN
                  LET l_display = 'N'
                  LET l_azw01 = "    "         #FUN-CB0058
               ELSE
                  LET l_display = 'Y'
                  LET l_azw01 = sr1.azw01      #FUN-CB0058
               END IF
            ELSE
               LET l_display = 'Y'
               LET l_azw01 = sr1.azw01      #FUN-CB0058
            END IF
            PRINTX l_display 

            IF NOT cl_nulL(sr1.azw08) THEN
               IF sr1_o.azw08 = sr1.azw08 AND tm.w = 'N' THEN
                  LET l_display1 = 'N'
                  LET l_azw08 = "   "          #FUN-CB0058
               ELSE
                  LET l_display1 = 'Y'
                  LET l_azw08 = sr1.azw08      #FUN-CB0058
               END IF
            ELSE
               LET l_display1 = 'Y'
               LET l_azw08 = sr1.azw08      #FUN-CB0058
            END IF
            PRINTX l_display1 

            IF NOT cl_nulL(sr1.ima01) THEN
               IF sr1_o.ima01 = sr1.ima01 THEN
                  LET l_display2 = 'N'
               ELSE
                  LET l_display2 = 'Y'
               END IF
            ELSE
               LET l_display2 = 'Y'
            END IF
            PRINTX l_display2 

            IF NOT cl_nulL(sr1.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02 THEN
                  LET l_display3 = 'N'
               ELSE
                  LET l_display3 = 'Y'
               END IF
            ELSE
               LET l_display3 = 'Y'
            END IF
            PRINTX l_display3 

            LET l_oba02 = sr1.ima131,' ',sr1.oba02    # No.FUN-C50005 add
            IF NOT cl_nulL(sr1.ima131) THEN
               IF sr1_o.ima131 = sr1.ima131 THEN
                  LET l_display4 = 'N'
               ELSE
                  LET l_display4 = 'Y'
               END IF
            ELSE
               LET l_display4 = 'Y'
            END IF
            PRINTX l_display4
            #FUN-BA0063-------add----end----
            PRINTX l_oba02                            # No.FUN-C50005 add
            PRINTX l_azw01      #FUN-CB0058
            PRINTX l_azw08      #FUN-CB0058
            LET sr1_o.* = sr1.*     #FUN-CB0058

            PRINTX sr1.*

        AFTER GROUP OF sr1.azw01

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-CA0118
#FUN-CC0088
