# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axmr867
# Descriptions...: 客单价分析表
# Date & Author..: #FUN-A70024 10/07/07 By wangxin
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.FUN-C80043 12/08/24 By yangxf 修改中间库表

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                              
              wc      STRING, 
              bdate   LIKE type_file.dat,   
              edate   LIKE type_file.dat,
              more    LIKE type_file.chr1      
              END RECORD 
DEFINE g_i             LIKE type_file.num5            
DEFINE g_head1         STRING
DEFINE g_sql           STRING
DEFINE g_str           STRING
DEFINE g_posdb         LIKE ryg_file.ryg00
DEFINE g_posdb_link    LIKE ryg_file.ryg02
DEFINE l_table         STRING 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT               
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "SHOP.oga_file.ogaplant,",
                "azp02.azp_file.azp02,",
                "TOT_QTY.type_file.num15_3,",
                "TOT_AMT.oga_file.oga51,",
                "num.type_file.num5,"
                          
   LET l_table = cl_prt_temptable('axmr867',g_sql) CLIPPED
   IF  l_table = -1 THEN 
      EXIT PROGRAM 
   END IF 

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)       
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

   IF cl_null(g_bgjob) OR g_bgjob = 'N'       
      THEN CALL axmr867_tm(0,0)                
      ELSE CALL axmr867()                     
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION axmr867_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW axmr867_w AT p_row,p_col WITH FORM "axm/42f/axmr867" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL           
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'



   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON azp01
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT   
               
                 
         ON ACTION controlp
            IF INFIELD(azp01) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azw01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azp01
                  NEXT FIELD azp01
             END IF
            
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr867_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF cl_null(tm.wc) THEN
         LET tm.wc = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      DISPLAY BY NAME tm.bdate,tm.edate,tm.more 
      
      INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
            
         AFTER FIELD edate  
            IF tm.edate < tm.bdate THEN 
               MESSAGE 'Begin Date should less than or equal to End Date'
               NEXT FIELD edate
            END IF 
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()   
            
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr867_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file   
          WHERE zz01='axmr867'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr867','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        
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
            CALL cl_cmdat('axmr867',g_time,l_cmd)    
         END IF
         CLOSE WINDOW axmr867_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmr867()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmr867_w
END FUNCTION

FUNCTION axmr867()
   DEFINE l_name    LIKE type_file.chr20,              
          l_sql     LIKE type_file.chr1000,                       
          l_chr     LIKE type_file.chr1,              
          sr        RECORD 
                    SHOP       LIKE oga_file.ogaplant,
                    azp02      LIKE azp_file.azp02,
                    TOT_QTY    LIKE type_file.num15_3,
                    TOT_AMT    LIKE oga_file.oga51,
                    num        LIKE type_file.num5
                    END RECORD
DEFINE l_ryg00        LIKE ryg_file.ryg00
DEFINE l_posdb        LIKE ryg_file.ryg00
DEFINE l_posdb_link   LIKE ryg_file.ryg02
DEFINE l_bdate        LIKE type_file.chr8
DEFINE l_edate        LIKE type_file.chr8

    LET l_ryg00= 'ds_pos1' 
    SELECT ryg00,ryg02 INTO l_posdb,l_posdb_link FROM ryg_file WHERE ryg00=l_ryg00
    LET g_posdb=s_dbstring(l_posdb)
    LET g_posdb_link=r867_dblinks(l_posdb_link)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
    
    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?) "                                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                                                                                        
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
       EXIT PROGRAM                                                                                                                 
    END IF
    
    IF cl_null(tm.bdate) AND cl_null(tm.edate) THEN 
       LET l_sql = " SELECT UNIQUE SHOP,azp02,SUM(TOT_QTY),SUM(TOT_AMT),COUNT(*) ",
                  #" FROM ",g_posdb,"POSDA",g_posdb_link," LEFT JOIN azp_file ON azp01 = SHOP ",          #FUN-C80043 mark
                   " FROM ",g_posdb,"td_sale",g_posdb_link," LEFT JOIN azp_file ON azp01 = SHOP ",        #FUN-C80043 add
                   " WHERE ",tm.wc CLIPPED,
                   " GROUP BY SHOP,azp02"
    ELSE 
        
       LET l_bdate=tm.bdate USING "YYYYMMDD"
       LET l_edate=tm.edate USING "YYYYMMDD"
       IF NOT cl_null(tm.bdate) AND NOT cl_null(tm.edate) THEN    #FUN-C80043 add
          LET l_sql = " SELECT UNIQUE SHOP,azp02,SUM(TOT_QTY),SUM(TOT_AMT),COUNT(*) ",
                     #" FROM ",g_posdb,"POSDA",g_posdb_link," LEFT JOIN azp_file ON azp01 = SHOP ",          #FUN-C80043 mark
                      " FROM ",g_posdb,"td_sale",g_posdb_link," LEFT JOIN azp_file ON azp01 = SHOP ",        #FUN-C80043 add				
                      " WHERE ",tm.wc CLIPPED,      
                     #" AND FDATE BETWEEN ",l_bdate," AND ",l_edate, #FUN-C80043 mark
                      " AND BDATE >= '",l_bdate,"'",                 #FUN-C80043 add
                      " AND BDATE <= '",l_edate,"'",                 #FUN-C80043 add
                      " GROUP BY SHOP,azp02"
       #FUN-C80043 add begin ---
       ELSE 
          IF NOT cl_null(tm.bdate) THEN
             LET l_sql = " SELECT UNIQUE SHOP,azp02,SUM(TOT_QTY),SUM(TOT_AMT),COUNT(*) ",
                         " FROM ",g_posdb,"td_sale",g_posdb_link," LEFT JOIN azp_file ON azp01 = SHOP ",
                         " WHERE ",tm.wc CLIPPED,
                         " AND BDATE >= '",l_bdate,"'",
                         " GROUP BY SHOP,azp02"
          ELSE 
             LET l_sql = " SELECT UNIQUE SHOP,azp02,SUM(TOT_QTY),SUM(TOT_AMT),COUNT(*) ",
                         " FROM ",g_posdb,"td_sale",g_posdb_link," LEFT JOIN azp_file ON azp01 = SHOP ",     
                         " WHERE ",tm.wc CLIPPED,
                         " AND BDATE <= '",l_edate,"'",
                         " GROUP BY SHOP,azp02" 
          END IF 
       END IF 
       #FUN-C80043 add end ------
    END IF 
    PREPARE axmr867_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF
    
    DECLARE axmr867_curs1 CURSOR FOR axmr867_prepare1
    FOREACH axmr867_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
    EXECUTE  insert_prep  USING  
      sr.SHOP,sr.azp02,sr.TOT_QTY,sr.TOT_AMT,sr.num
    END FOREACH   
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED        
    LET g_str = tm.wc
    #FUN-C80043 add begin ---
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_str,'azp01')
            RETURNING g_str 
    ELSE
       LET g_str = ''
    END IF
    #FUN-C80043 add end ----
    CALL cl_prt_cs3('axmr867','axmr867',l_sql,g_str)
END FUNCTION


FUNCTION r867_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02
   
  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE 
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
   
END FUNCTION
#FUN-A70024
