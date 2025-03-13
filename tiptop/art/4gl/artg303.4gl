# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: artg303.4gl
# Descriptions...: 供應商統計表       
# Date & Author..: 10/07/13 By lixh1  
# Modify.........: No:TQC-B10099 11/01/12 By shiwuying 重新过单
# Modify.........: No.FUN-BA0063 11/10/18 By yangtt CR轉換成GRW
# Modify.........: No.FUN-BA0063 12/01/13 By yangtt 追單TWC-BB0034
# Modify.........: No.FUN-C20053 12/02/24 By xuxz GR調整


DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD                          # Print condition RECORD
              wc1      STRING,  
              wc       STRING,               
              w        LIKE type_file.chr1,   #FUN-BA0063 FROM TQC-BB0034
              x        LIKE type_file.chr1,   #FUN-BA0063 FROM TQC-BB0034
              s        LIKE type_file.chr3, 
              t        LIKE type_file.chr1,
              more     LIKE type_file.chr1    # Input more condition(Y/N)
              END RECORD
   DEFINE l_table      STRING,                  
          g_str        STRING,                  
          g_sql        STRING 
   DEFINE g_ord1_desc      STRING           #FUN-BA0063 add
   DEFINE g_ord2_desc      STRING           #FUN-BA0063 add
   DEFINE g_ord3_desc      STRING           #FUN-BA0063 add
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE aaf_file.aaf03,       #FUN-BA0063 add
    order2 LIKE aaf_file.aaf03,       #FUN-BA0063 add
    order3 LIKE aaf_file.aaf03,       #FUN-BA0063 add
    rvuplant LIKE rvu_file.rvuplant,
    azp02 LIKE azp_file.azp02,
    rvv39t LIKE rvv_file.rvv39t,
    ima131 LIKE ima_file.ima131,
    oba02 LIKE oba_file.oba02,
    rvv31 LIKE rvv_file.rvv31,
    ima02 LIKE ima_file.ima02,
    rvv35 LIKE rvv_file.rvv35,      #FUN-BA0063 FROM TQC-BB0034
    rvv17 LIKE rvv_file.rvv17,
    rvu04 LIKE rvu_file.rvu04,
    rvu05 LIKE rvu_file.rvu05,
    rvu03 LIKE rvu_file.rvu03
END RECORD
###GENGRE###END

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
    LET g_sql = "order1.aaf_file.aaf03,",       #FUN-BA0063 add
                "order2.aaf_file.aaf03,",       #FUN-BA0063 add
                "order3.aaf_file.aaf03,",       #FUN-BA0063 add
                "rvuplant.rvu_file.rvuplant,",
                "azp02.azp_file.azp02,",
                "rvv39t.rvv_file.rvv39t,",
                "ima131.ima_file.ima131,",
                "oba02.oba_file.oba02,",
                "rvv31.rvv_file.rvv31,",
                "ima02.ima_file.ima02,",
                "rvv35.rvv_file.rvv35,",  #FUN-BA0063 FROM TQC-BB0034
                "rvv17.rvv_file.rvv17,",
                "rvu04.rvu_file.rvu04,",
                "rvu05.rvu_file.rvu05,",
                "rvu03.rvu_file.rvu03"

    LET l_table = cl_prt_temptable('artg303',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF  l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-BA0063 add
        CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
        EXIT PROGRAM 
     END IF                 # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"     #FUN-BA0063 add 3?    #FUN-BA0063 FROM TQC-BB0034 add 1?                                                                              
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-BA0063 add
       CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
       EXIT PROGRAM                                                                            
    END IF 
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.w  = ARG_VAL(8)  #FUN-BA0063 FROM TQC-BB0034
   LET tm.x  = ARG_VAL(9)  #FUN-BA0063 FROM TQC-BB0034
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL artg303_tm(0,0)            # Input print condition
      ELSE CALL artg303()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
END MAIN 

FUNCTION artg303_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   
   DEFINE p_row,p_col   LIKE type_file.num5,         
          l_cmd         LIKE type_file.chr1000      
   DEFINE azp01      LIKE azp_file.azp01
   DEFINE l_combo        ui.ComboBox        #FUN-BA0063  add
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artg303_w AT p_row,p_col WITH FORM "art/42f/artg303"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.wc   = ' 1=1'
   LET tm.w    = 'Y'  #FUN-BA0063 FROM TQC-BB0034
   LET tm.x    = 'Y'  #FUN-BA0063 FROM TQC-BB0034
   LET tm.s    = '123'
   LET tm.t    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
   #genero版本default 排序
   #LET tm2.s1   = tm.s[1,1]   #FUN-BA0063 FROM TQC-BB0034 mark
   #LET tm2.s2   = tm.s[2,2]   #FUN-BA0063 FROM TQC-BB0034 mark
   #LET tm2.s3   = tm.s[3,3]   #FUN-BA0063 FROM TQC-BB0034 mark
   CALL r303_set_entry()       #FUN-BA0063 FROM TQC-BB0034
   CALL r303_setS() RETURNING tm2.s1,tm2.s2,tm2.s3  #FUN-BA0063 FROM TQC-BB0034
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF   
WHILE TRUE
   DISPLAY BY NAME tm.more
   CONSTRUCT BY NAME tm.wc1 ON azp01 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
     ON ACTION controlp            
        IF INFIELD(azp01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_azw01"
           LET g_qryparam.state = "c"
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
      LET INT_FLAG = 0 CLOSE WINDOW artg303_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
   END IF         
 
   IF cl_null(tm.wc1) THEN
         LET tm.wc1 = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
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
      LET INT_FLAG = 0 CLOSE WINDOW artg303_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
   END IF
      IF cl_null(tm.wc) THEN
         LET tm.wc = " 1=1"
      END IF

#  INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.t,tm.more  WITHOUT DEFAULTS
   INPUT BY NAME tm.w,tm.x,tm.t,tm2.s1,tm2.s2,tm2.s3,tm.more  WITHOUT DEFAULTS   #FUN-BA0063 FROM TQC-BB0034
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
      ON CHANGE t                    #FUN-BA0063 FROM TQC-BB0034
         CALL r303_set_entry()       #FUN-BA0063 FROM TQC-BB0034
         CALL r303_setS() RETURNING tm2.s1,tm2.s2,tm2.s3  #FUN-BA0063 FROM TQC-BB0034
         DISPLAY tm2.s1,tm2.s2,tm2.s3 TO s1,s2,s3  #FUN-BA0063 FROM TQC-BB0034
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
         #FUN-BA0063-------add-----str---
         LET l_combo = ui.ComboBox.forName("formonly.s1")
         LET g_ord1_desc = l_combo.getTextOf(tm2.s1[1])
         LET l_combo = ui.ComboBox.forName("formonly.s2")
         LET g_ord2_desc = l_combo.getTextOf(tm2.s2[1])
         LET l_combo = ui.ComboBox.forName("formonly.s3")
         LET g_ord3_desc = l_combo.getTextOf(tm2.s3[1])
         #FUN-BA0063-------add-----end---   
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
      LET INT_FLAG = 0 CLOSE WINDOW artg303_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='artg303'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('artg303','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,  #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",    #FUN-BA0063 FROM TQC-BB0034
                         " '",tm.x CLIPPED,"'",    #FUN-BA0063 FROM TQC-BB0034
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'",           
                         " '",g_rpt_name CLIPPED,"'"            
         CALL cl_cmdat('artg303',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW artg303_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL artg303()
   ERROR ""
END WHILE
   CLOSE WINDOW artg303_w
END FUNCTION 

FUNCTION artg303()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name        LIKE type_file.chr20,         # External(Disk) file name           #No.FUN-680136 VARCHAR(20)
          l_name1       LIKE type_file.chr20,         # VARCHAR(20)
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
                               rvv35   LIKE rvv_file.rvv35,      #FUN-BA0063 FROM TQC-BB0034
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
   LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
               " WHERE ",tm.wc1 CLIPPED ,   
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
            "  rvuplant,'',rvv39t,ima131,'',rvv31,ima02,rvv35,rvv17,rvu04,rvu05,rvu03,pmm22,pmm42,rva113,rva114 ",    #FUN-BA0063 FROM TQC-BB0034 add rvv35
            "  FROM ",cl_get_target_table(l_plant,'rvu_file'),",",
                      cl_get_target_table(l_plant,'ima_file'),",",                 
                      cl_get_target_table(l_plant,'rvv_file'),
                      " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'pmm_file')," ON pmm01 = rvv36 ",
                      " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rva_file')," ON rva01 = rvv04 ",                     
            " WHERE rvu00=rvv03 AND rvu01=rvv01 ",
            "  AND  rvv31=ima01 ",
            "  AND  rvuplant='",l_plant,"'",    
            "  AND  rvvplant=rvuplant ",          
            "  AND ", tm.wc CLIPPED
               
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            
     PREPARE artg303_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
        EXIT PROGRAM
           
     END IF
     DECLARE artg303_curs1 CURSOR FOR artg303_p1

     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
        EXIT PROGRAM
           
     END IF
     LET g_pageno = 0
     FOREACH artg303_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        IF NOT cl_null(sr.pmm22) THEN 
           IF NOT cl_null(sr.pmm42) THEN
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
        #FUN-BA0063-----add----str-----
        CASE tm.s[1,1]
           WHEN '1'  LET sr.order1 = sr.azp01
           WHEN '2'  LET sr.order1 = sr.ima131
           WHEN '3'  LET sr.order1 = sr.rvv31
           WHEN '4'  LET sr.order1 = sr.rvu04
           WHEN '5'  LET sr.order1 = sr.rvu03
        END CASE

        CASE tm.s[2,2]
           WHEN '1'  LET sr.order2 = sr.azp01
           WHEN '2'  LET sr.order2 = sr.ima131
           WHEN '3'  LET sr.order2 = sr.rvv31
           WHEN '4'  LET sr.order2 = sr.rvu04
           WHEN '5'  LET sr.order2 = sr.rvu03
        END CASE

        CASE tm.s[3,3]
           WHEN '1'  LET sr.order3 = sr.azp01
           WHEN '2'  LET sr.order3 = sr.ima131
           WHEN '3'  LET sr.order3 = sr.rvv31
           WHEN '4'  LET sr.order3 = sr.rvu04
           WHEN '5'  LET sr.order3 = sr.rvu03
        END CASE

        #FUN-BA0063-----add----end-----
        EXECUTE insert_prep USING
                sr.order1,sr.order2,sr.order3,             #FUN-BA0063
                sr.azp01,l_azp02,sr.rvv39t,sr.ima131,l_oba02,sr.rvv31,    
                sr.ima02,sr.rvv35,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03    #FUN-BA0063 FROM TQC-BB0034 add rvv35
     END FOREACH
  END FOREACH     
 
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
     LET tm.wc = tm.wc1," AND ",tm.wc      
        CALL cl_wcchp(tm.wc,'azp01,ima131,rvv31,rvu04,rvu03')                   
              RETURNING tm.wc
        LET g_str = tm.wc
     END IF
###GENGRE###     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.w,";",tm.x  #FUN-BA0063 FROM TQC-BB0034  add tm.w,tm.x
   CASE
      WHEN tm.t='1'
###GENGRE###         CALL cl_prt_cs3('artg303','artg303',l_sql,g_str)  
         LET g_template = 'artg303'    #FUN-BA0063 add
         CALL artg303_grdata()    ###GENGRE###
      WHEN tm.t='2'
###GENGRE###         CALL cl_prt_cs3('artg303','artg303_1',l_sql,g_str)
         LET g_template = 'artg303_1'    #FUN-BA0063 add
         CALL artg303_1_grdata()    ###GENGRE###
      WHEN tm.t='3'
###GENGRE###         CALL cl_prt_cs3('artg303','artg303_2',l_sql,g_str)         
         LET g_template = 'artg303_2'    #FUN-BA0063 add
         CALL artg303_2_grdata()    ###GENGRE###
   END CASE
END FUNCTION 

#FUN-BA0063--------------add------str---
FUNCTION r303_set_entry()
   CASE
      WHEN tm.t='1'
         CALL cl_set_comp_entry("s1",FALSE)
         CALL cl_set_comp_entry("s2,s3",TRUE)
      WHEN tm.t='2' OR tm.t='3'
         CALL cl_set_comp_entry("s1,s2",FALSE)
         CALL cl_set_comp_entry("s3",TRUE)
   END CASE
END FUNCTION

FUNCTION r303_setS()
   CASE
      WHEN tm.t='1'
         RETURN '4','1','3'
      WHEN tm.t='2'
         RETURN '4','1','3'
      WHEN tm.t='3'
         RETURN '4','3','1'
   END CASE
   RETURN '4','1','3'
END FUNCTION
#FUN-BA0063--------------add------end---
#TQC-B10099

###GENGRE###START
FUNCTION artg303_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg303")
        IF handler IS NOT NULL THEN
            START REPORT artg303_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(rvu04) asc nulls first,order1,order2,order3"   #FUN-BA0063 add
          
            DECLARE artg303_datacur1 CURSOR FROM l_sql
            FOREACH artg303_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg303_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg303_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

#FUN-BA0063-------add-----str----
PRIVATE FUNCTION artg303_replace_ord_desc(p_desc)
    DEFINE p_desc   STRING
    DEFINE l_pos    LIKE type_file.num10
    DEFINE l_str    STRING

    IF p_desc IS NOT NULL THEN
        LET l_pos = p_desc.getIndexOf(":",1)
        IF l_pos >= 1 THEN
            LET l_str = p_desc.subString(l_pos + 1,p_desc.getLength())
        ELSE
            LET l_str = p_desc
        END IF
    END IF

    RETURN l_str
END FUNCTION
#FUN-BA0063-------add-----end----

REPORT artg303_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-BA0063-------add---str-----
    DEFINE l_rvv17_sum   LIKE rvv_file.rvv17
    DEFINE l_rvv39t_sum  LIKE rvv_file.rvv39t
    DEFINE l_rvv17_tot   LIKE rvv_file.rvv17
    DEFINE l_rvv39t_tot  LIKE rvv_file.rvv39t
    DEFINE l_display     LIKE type_file.chr1
    DEFINE l_display1    LIKE type_file.chr1
    DEFINE sr1_o         sr1_t
    DEFINE l_aa00        STRING
    #FUN-BA0063-------add---end-----

    
#   ORDER EXTERNAL BY sr1.rvu04,sr1.rvv31                          #FUN-BA0063 mark
    ORDER EXTERNAL BY sr1.rvu04,sr1.order1,sr1.order2,sr1.order3   #FUN-BA0063 add
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name  #FUN-BA0063 add g_ptime,g_user_name
            PRINTX tm.*

            #FUN-BA0063----add----str---
            LET g_ord1_desc = artg303_replace_ord_desc(g_ord1_desc)
            LET g_ord2_desc = artg303_replace_ord_desc(g_ord2_desc)
            LET g_ord3_desc = artg303_replace_ord_desc(g_ord3_desc)
            LET l_aa00 = g_ord1_desc,' ',g_ord2_desc,' ',g_ord3_desc
            PRINTX l_aa00
            LET sr1_o.rvu04 = NULL
            #FUN-BA0063----add----end---
              
        BEFORE GROUP OF sr1.rvu04
        BEFORE GROUP OF sr1.order1
        BEFORE GROUP OF sr1.order2
        BEFORE GROUP OF sr1.order3

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.rvu04
            #FUN-BA0063----add----end---
            IF NOT cl_null(sr1_o.rvu04) THEN
               IF sr1_o.rvu04 != sr1.rvu04 THEN
                  LET l_display = 'Y'
               ELSE
                  LET l_display = 'N'
               END IF
            ELSE
               LET l_display = 'Y'
            END IF
            PRINTX l_display

            LET sr1_o.rvu04 = sr1.rvu04
 
            LET l_rvv17_sum = GROUP SUM(sr1.rvv17)
            PRINTX l_rvv17_sum
            LET l_rvv39t_sum = GROUP SUM(sr1.rvv39t)
            PRINTX l_rvv39t_sum
            #FUN-BA0063----add----end---
        AFTER GROUP OF sr1.order1            #FUN-BA0063 add
        AFTER GROUP OF sr1.order2            #FUN-BA0063 add
        AFTER GROUP OF sr1.order3            #FUN-BA0063 add

        
        ON LAST ROW
           #xuxz --add--str
           LET l_rvv17_tot = SUM(sr1.rvv17)
           PRINTX l_rvv17_tot
           LET l_rvv39t_tot = SUM(sr1.rvv39t)
           PRINTX l_rvv39t_tot
           #xuxz -add-end

END REPORT
###GENGRE###END
#FUN-BA0063--------add---------str----
FUNCTION artg303_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg303")
        IF handler IS NOT NULL THEN
            START REPORT artg303_1_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(rvu04) asc nulls first,rvuplant,order1,order2,order3"   #FUN-BA0063 add

            DECLARE artg303_datacur2 CURSOR FROM l_sql
            FOREACH artg303_datacur2 INTO sr1.*
                OUTPUT TO REPORT artg303_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg303_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg303_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-BA0063-------add---str-----
    DEFINE l_rvv17_sum   LIKE rvv_file.rvv17
    DEFINE l_rvv39t_sum  LIKE rvv_file.rvv39t
    DEFINE l_rvv17_sum2  LIKE rvv_file.rvv17
    DEFINE l_rvv39t_sum2 LIKE rvv_file.rvv39t
    DEFINE l_rvv17_tot   LIKE rvv_file.rvv17
    DEFINE l_rvv39t_tot  LIKE rvv_file.rvv39t
    DEFINE l_display     LIKE type_file.chr1
    DEFINE l_display1    LIKE type_file.chr1
    DEFINE l_display2    LIKE type_file.chr1
    DEFINE l_display3    LIKE type_file.chr1
    DEFINE sr1_o         sr1_t
    DEFINE l_aa00        STRING
    #FUN-BA0063-------add---end-----


    ORDER EXTERNAL BY sr1.rvu04,sr1.rvuplant,sr1.order1,sr1.order2,sr1.order3

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*

         
            LET g_ord1_desc = artg303_replace_ord_desc(g_ord1_desc)
            LET g_ord2_desc = artg303_replace_ord_desc(g_ord2_desc)
            LET g_ord3_desc = artg303_replace_ord_desc(g_ord3_desc)
            LET l_aa00 = g_ord1_desc,' ',g_ord2_desc,' ',g_ord3_desc
            PRINTX l_aa00
            LET sr1_o.rvu04 = NULL  
            LET sr1_o.rvu05 = NULL  
            LET sr1_o.rvuplant= NULL  
            LET sr1_o.azp02 = NULL  

        BEFORE GROUP OF sr1.rvu04
        BEFORE GROUP OF sr1.rvuplant
        BEFORE GROUP OF sr1.order1  
        BEFORE GROUP OF sr1.order2  
        BEFORE GROUP OF sr1.order3  


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.rvu04
           #xuxz --add--str
           LET l_rvv17_sum2 = GROUP SUM(sr1.rvv17)
           PRINTX l_rvv17_sum2
           LET l_rvv39t_sum2 = GROUP SUM(sr1.rvv39t)
           PRINTX l_rvv39t_sum2
           #xuxz -add-end
        AFTER GROUP OF sr1.rvuplant
            IF NOT cl_null(sr1_o.rvu04) THEN
               IF sr1_o.rvu04 != sr1.rvu04 THEN
                  LET l_display = 'Y'
               ELSE
                  LET l_display = 'N'
               END IF
            ELSE  
               LET l_display = 'Y'
            END IF
            PRINTX l_display

            LET sr1_o.rvu04 = sr1.rvu04
 
            LET l_rvv17_sum = GROUP SUM(sr1.rvv17)
            PRINTX l_rvv17_sum
            LET l_rvv39t_sum = GROUP SUM(sr1.rvv39t)
            PRINTX l_rvv39t_sum
        AFTER GROUP OF sr1.order1  
        AFTER GROUP OF sr1.order2  
        AFTER GROUP OF sr1.order3  


        ON LAST ROW
           #xuxz --add--str
           LET l_rvv17_tot = SUM(sr1.rvv17)
           PRINTX l_rvv17_tot
           LET l_rvv39t_tot = SUM(sr1.rvv39t)
           PRINTX l_rvv39t_tot
           #xuxz -add-end

END REPORT

FUNCTION artg303_2_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg303")
        IF handler IS NOT NULL THEN
            START REPORT artg303_2_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(rvu04) asc nulls first,rvv31,order1,order2,order3"   #FUN-BA0063 add

            DECLARE artg303_datacur3 CURSOR FROM l_sql
            FOREACH artg303_datacur3 INTO sr1.*
                OUTPUT TO REPORT artg303_2_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg303_2_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg303_2_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-BA0063-------add---str-----
    DEFINE l_rvv17_sum   LIKE rvv_file.rvv17
    DEFINE l_rvv39t_sum  LIKE rvv_file.rvv39t
    DEFINE l_rvv17_sum2  LIKE rvv_file.rvv17
    DEFINE l_rvv39t_sum2 LIKE rvv_file.rvv39t
    DEFINE l_rvv17_tot   LIKE rvv_file.rvv17
    DEFINE l_rvv39t_tot  LIKE rvv_file.rvv39t
    DEFINE l_display     LIKE type_file.chr1
    DEFINE l_display1    LIKE type_file.chr1
    DEFINE l_display2    LIKE type_file.chr1
    DEFINE l_display3    LIKE type_file.chr1
    DEFINE sr1_o         sr1_t
    DEFINE l_aa00        STRING
    #FUN-BA0063-------add---end-----


    ORDER EXTERNAL BY sr1.rvu04,sr1.rvv35,sr1.order1,sr1.order2,sr1.order3

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*

            LET g_ord1_desc = artg303_replace_ord_desc(g_ord1_desc)
            LET g_ord2_desc = artg303_replace_ord_desc(g_ord2_desc)
            LET g_ord3_desc = artg303_replace_ord_desc(g_ord3_desc)
            LET l_aa00 = g_ord1_desc,' ',g_ord2_desc,' ',g_ord3_desc
            PRINTX l_aa00
            LET sr1_o.rvu04 = NULL  
            LET sr1_o.rvu05 = NULL  
            LET sr1_o.rvv31 = NULL  
            LET sr1_o.ima02 = NULL  

        BEFORE GROUP OF sr1.rvu04
        BEFORE GROUP OF sr1.rvv31
        BEFORE GROUP OF sr1.order1
        BEFORE GROUP OF sr1.order2
        BEFORE GROUP OF sr1.order3


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.rvu04
           #xuxz --add--str
           LET l_rvv17_sum2 = GROUP SUM(sr1.rvv17)
           PRINTX l_rvv17_sum2
           LET l_rvv39t_sum2 = GROUP SUM(sr1.rvv39t)
           PRINTX l_rvv39t_sum2
           #xuxz -add-end
        AFTER GROUP OF sr1.rvv35
            IF NOT cl_null(sr1_o.rvv35) THEN
               IF sr1_o.rvv35 != sr1.rvv35 THEN
                  LET l_display = 'Y'
               ELSE
                  LET l_display = 'N'
               END IF
            ELSE
               LET l_display = 'Y'
            END IF
            PRINTX l_display

            LET sr1_o.rvv35 = sr1.rvv35

            LET l_rvv17_sum = GROUP SUM(sr1.rvv17)
            PRINTX l_rvv17_sum
            LET l_rvv39t_sum = GROUP SUM(sr1.rvv39t)
            PRINTX l_rvv39t_sum
        AFTER GROUP OF sr1.order1
        AFTER GROUP OF sr1.order2#FUN-C20053 md 2-->3
        AFTER GROUP OF sr1.order3


        ON LAST ROW
        #xuxz --add--str
           LET l_rvv17_tot = SUM(sr1.rvv17)
           PRINTX l_rvv17_tot
           LET l_rvv39t_tot = SUM(sr1.rvv39t)
           PRINTX l_rvv39t_tot
           #xuxz -add-end

END REPORT
#FUN-BA0063--------add---------end----
