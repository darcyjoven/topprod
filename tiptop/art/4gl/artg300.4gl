# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: artg300.4gl
# Descriptions...: 營運中心統計表       
# Date & Author..: #FUN-A70005 10/07/06 By lixh1  
# Modify.........: No.FUN-BA0063 11/10/17 By yangtt CR轉換成GRW
# Modify.........: No.FUN-BA0063 12/01/13 By yangtt 追單TQC-BB0034
# Modify.........: NO.FUN-CB0058 12/11/20 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點


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
   DEFINE g_chk_auth   STRING 
DEFINE g_ord1_desc      STRING           #FUN-BA0063 add
DEFINE g_ord2_desc      STRING           #FUN-BA0063 add
DEFINE g_ord3_desc      STRING           #FUN-BA0063 add
###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE rvu_file.rvuplant,       #FUN-BA0063 add
    order2 LIKE rvu_file.rvuplant,       #FUN-BA0063 add
    order3 LIKE rvu_file.rvuplant,       #FUN-BA0063 add
    rvuplant LIKE rvu_file.rvuplant,
    azp02 LIKE azp_file.azp02,
    rvv39t LIKE rvv_file.rvv39t,
    ima131 LIKE ima_file.ima131,
    oba02 LIKE oba_file.oba02,
    rvv31 LIKE rvv_file.rvv31,
    ima02 LIKE ima_file.ima02,
    rvv35 LIKE rvv_file.rvv35,          #FUN-BA0063 FROM TQC-BB0034 add
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
    LET g_sql = 
                "order1.rvu_file.rvuplant,",       #FUN-BA0063 add
                "order2.rvu_file.rvuplant,",       #FUN-BA0063 add
                "order3.rvu_file.rvuplant,",       #FUN-BA0063 add
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

    LET l_table = cl_prt_temptable('artg300',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF  l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-BA0063 add
        CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
        EXIT PROGRAM 
    END IF                 # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"       #FUN-BA0063 add 3?         #FUN-BA0063 FROM TQC-BB0034 add 1?                                                                          
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
      THEN CALL artg300_tm(0,0)            # Input print condition
      ELSE CALL artg300()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
END MAIN 

FUNCTION artg300_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01   
   DEFINE p_row,p_col   LIKE type_file.num5,         
          l_cmd         LIKE type_file.chr1000      
   DEFINE azp01         LIKE azp_file.azp01
   DEFINE l_azp01       LIKE azp_file.azp01
   DEFINE l_n           LIKE type_file.num5 
   DEFINE l_zxy03       LIKE azp_file.azp01
   DEFINE l_sql         STRING   
   DEFINE l_err         STRING
   DEFINE l_azp01_str   STRING
   DEFINE tok           base.StringTokenizer      
   DEFINE l_combo        ui.ComboBox        #FUN-BA0063  add

   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artg300_w AT p_row,p_col WITH FORM "art/42f/artg300"
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
#  LET tm2.s1   = tm.s[1,1]      #FUN-BA0063 FROM TQC-BB0034 mark
#  LET tm2.s2   = tm.s[2,2]      #FUN-BA0063 FROM TQC-BB0034 mark
#  LET tm2.s3   = tm.s[3,3]      #FUN-BA0063 FROM TQC-BB0034 mark
   CALL r300_set_entry()       #FUN-BA0063 FROM TQC-BB0034
   CALL r300_setS() RETURNING tm2.s1,tm2.s2,tm2.s3  #FUN-BA0063 FROM TQC-BB0034
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
            DECLARE g300_zxy_cs  CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
            FOREACH g300_zxy_cs  INTO l_zxy03
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
      LET INT_FLAG = 0 CLOSE WINDOW artg300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
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
      LET INT_FLAG = 0 CLOSE WINDOW artg300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
   END IF
      IF cl_null(tm.wc) THEN
         LET tm.wc = " 1=1"
      END IF

   #INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm.t,tm.more  WITHOUT DEFAULTS #FUN-BA0063 xuxz from TQC-BB0034
   INPUT BY NAME tm.w,tm.x,tm.t,tm2.s1,tm2.s2,tm2.s3,tm.more  WITHOUT DEFAULTS   #FUN-BA0063 xuxz from TQC-BB0034
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
      #FUN-BA0063 FROM TQC-BB0034-----add----str---
      ON CHANGE t             
         CALL r300_set_entry() 
         CALL r300_setS() RETURNING tm2.s1,tm2.s2,tm2.s3 
         DISPLAY tm2.s1,tm2.s2,tm2.s3 TO s1,s2,s3 
      #FUN-BA0063 FROM TQC-BB0034-----add----end---
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
      LET INT_FLAG = 0 CLOSE WINDOW artg300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='artg300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('artg300','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,                #(at time fglgo xxxx p1 p2 p3)
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
         CALL cl_cmdat('artg300',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW artg300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL artg300()
   ERROR ""
END WHILE
   CLOSE WINDOW artg300_w
END FUNCTION 

FUNCTION artg300()
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name        LIKE type_file.chr20,         
          l_name1       LIKE type_file.chr20,         
          l_time        LIKE type_file.chr8,          
          l_sql         STRING,                       
          l_chr         LIKE type_file.chr1,          
          l_za05        LIKE type_file.chr1000,  
          sr            RECORD order1  LIKE aaf_file.aaf03,     
                               order2  LIKE aaf_file.aaf03,    
                               order3  LIKE aaf_file.aaf03,             
                               azp01   LIKE azp_file.azp01,        # 營運中心編號
                               azp02   LIKE azp_file.azp02,        # 名稱
                               rvv39t  LIKE rvv_file.rvv39t,       # 金額
                               ima131  LIKE ima_file.ima131,       # 產品分類
                               oba02   LIKE oba_file.oba02,        # 分類名稱
                               rvv31   LIKE rvv_file.rvv31,        # 產品編號
                               ima02   LIKE ima_file.ima02,        # 產品名稱
                               rvv35   LIKE rvv_file.rvv35,        #FUN-BA0063 FROM TQC-BB0034
                               rvv17   LIKE rvv_file.rvv17,        # 數量
                               rvu04   LIKE rvu_file.rvu04,        # 供應商編號
                               rvu05   LIKE rvu_file.rvu05,        # 簡稱
                               rvu03   LIKE rvu_file.rvu03,        # 進貨日期 
                               pmm22   LIKE pmm_file.pmm22,        # 採購單幣種
                               pmm42   LIKE pmm_file.pmm42,        # 採購單匯率
                               rva113  LIKE rva_file.rva113,       # 收貨單幣種
                               rva114  LIKE rva_file.rva114        # 收貨單匯率
                       END RECORD,
          l_oba02   LIKE oba_file.oba02,
          l_azi10   LIKE azi_file.azi10
         
          
   CALL cl_del_data(l_table)                                   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup')
   DROP TABLE artg300_tmp
   CREATE TEMP TABLE artg300_tmp(
                    azp01   LIKE azp_file.azp01,        
                    azp02   LIKE azp_file.azp02,        
                    rvv39t  LIKE rvv_file.rvv39t,       
                    ima131  LIKE ima_file.ima131,       
                    oba02   LIKE oba_file.oba02,        
                    rvv31   LIKE rvv_file.rvv31,        
                    ima02   LIKE ima_file.ima02,        
                    rvv35   LIKE rvv_file.rvv35,   #FUN-BA0063 FROM TQC-BB0034
                    rvv17   LIKE rvv_file.rvv17,       
                    rvu04   LIKE rvu_file.rvu04,        
                    rvu05   LIKE rvu_file.rvu05,        
                    rvu03   LIKE rvu_file.rvu03)
   DELETE FROM artg300_tmp   
   LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
               " WHERE azp01 IN ",g_chk_auth ,     
               "   AND azw01 = azp01  ",
               " ORDER BY azp01 "

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 

   FOREACH sel_azp01_cs INTO l_plant,l_azp02    #--最外围的FOREACH--跨營運中心

      IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
      END IF 
      LET l_sql = "SELECT  '','','',",                                           
            "  rvuplant,'',rvv39t,ima131,'',rvv31,ima02,rvv35,rvv17,rvu04,rvu05,rvu03,pmm22,pmm42,rva113,rva114 ",      #FUN-BA0063 FROM TQC-BB0034 add rvv35
            "  FROM ",cl_get_target_table(l_plant,'rvu_file'),",",
                      cl_get_target_table(l_plant,'ima_file'),",",                 
                      cl_get_target_table(l_plant,'rvv_file'),
                      " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'pmm_file')," ON pmm01 = rvv36 ",
                      " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'rva_file')," ON rva01 = rvv04 ",                     
            " WHERE rvu00=rvv03 AND rvu01=rvv01 ",
            "  AND  rvu00='1' ",
            "  AND  rvuconf='Y' ",
            "  AND  rvaconf='Y' ",
            "  AND  pmm18='Y'",
            "  AND  rvv31=ima01 ",
            "  AND  rvuplant='",l_plant,"'",    
            "  AND  rvvplant=rvuplant ",          
            "  AND ", tm.wc CLIPPED
               
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            
     PREPARE artg300_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
        EXIT PROGRAM
           
     END IF
     DECLARE artg300_curs1 CURSOR FOR artg300_p1

     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
        EXIT PROGRAM
           
     END IF
     LET g_pageno = 0
     FOREACH artg300_curs1 INTO sr.*
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
        INSERT INTO artg300_tmp VALUES(sr.azp01,sr.azp02,sr.rvv39t,sr.ima131,sr.oba02,sr.rvv31,
                                       sr.ima02,sr.rvv35,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03)         #FUN-BA0063 FROM TQC-BB0034 add sr.rvv35

        INITIALIZE sr TO NULL 
     END FOREACH
  END FOREACH
     CASE 
        WHEN tm.t='1'
           LET l_sql = "SELECT azp01,azp02,SUM(rvv39t),'','','','','',SUM(rvv17),'','',''",    #FUN-BA0063 FROM TQC-BB0034 add 1''
                       "  FROM artg300_tmp ",
                       " GROUP BY azp01,azp02 "
        WHEN tm.t='2' 
           LET l_sql = "SELECT azp01,azp02,SUM(rvv39t),ima131,oba02,'','','',SUM(rvv17),'','','' ",  #FUN-BA0063 FROM TQC-BB0034 add 1''
                       "  FROM artg300_tmp ",
                       " GROUP BY azp01,azp02,ima131,oba02 "       
       
        WHEN tm.t='3' 
           LET l_sql = "SELECT azp01,azp02,SUM(rvv39t),'','',rvv31,ima02,rvv35,SUM(rvv17),'','','' ",  #FUN-BA0063 FROM TQC-BB0034 add rvv35
                       "  FROM artg300_tmp ",
                       " GROUP BY azp01,azp02,rvv31,ima02,rvv35 "           
   END CASE
      PREPARE g300_prepare3 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare3:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      DECLARE g300_curs3 CURSOR FOR g300_prepare3  
      FOREACH g300_curs3 INTO sr.azp01,sr.azp02,sr.rvv39t,sr.ima131,sr.oba02,sr.rvv31,
                              sr.ima02,sr.rvv35,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03   #FUN-BA0063 FROM TQC-BB0034 add sr.rvv35

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
                sr.azp01,sr.azp02,sr.rvv39t,sr.ima131,sr.oba02,sr.rvv31,    
                sr.ima02,sr.rvv35,sr.rvv17,sr.rvu04,sr.rvu05,sr.rvu03    #FUN-BA0063 FROM TQC-BB0034 add sr.rvv35
        INITIALIZE sr TO NULL 
     END FOREACH                
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     IF g_zz05 = 'Y' THEN
     LET tm.wc = tm.wc1," AND ",tm.wc 
        CALL cl_wcchp(tm.wc,'azp01,ima131,rvv31,rvu04,rvu03')                   
              RETURNING tm.wc
        LET g_str = tm.wc
     END IF
###GENGRE###     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.w,";",tm.x  #FUN-BA0063 FROM TQC-BB0034 add tm.w,tm.x
   CASE
      WHEN tm.t='1'
###GENGRE###         CALL cl_prt_cs3('artg300','artg300',l_sql,g_str)  
         LET g_template = 'artg300'     #FUN-BA0063 add
    CALL artg300_grdata()    ###GENGRE###
      WHEN tm.t='2'
###GENGRE###         CALL cl_prt_cs3('artg300','artg300_1',l_sql,g_str)
         LET g_template = 'artg300_1'     #FUN-BA0063 add
         CALL artg300_grdata()    ###GENGRE###
      WHEN tm.t='3'
###GENGRE###         CALL cl_prt_cs3('artg300','artg300_2',l_sql,g_str)         
         LET g_template = 'artg300_2'     #FUN-BA0063 add
         CALL artg300_grdata()    ###GENGRE###
   END CASE
END FUNCTION    

#FUN-BA0063 FROM TQC-BB0034 add begin-----------
FUNCTION r300_set_entry()
   CASE
      WHEN tm.t='1'
         CALL cl_set_comp_entry("s1",FALSE)
         CALL cl_set_comp_entry("s2,s3",TRUE)
      WHEN tm.t='2' OR tm.t='3'
         CALL cl_set_comp_entry("s1,s2",FALSE)
         CALL cl_set_comp_entry("s3",TRUE)
   END CASE
END FUNCTION

FUNCTION r300_setS()
   CASE
      WHEN tm.t='1' OR tm.t='2'
         RETURN '1','2','3'
      WHEN tm.t='3'
         RETURN '1','3','2'
   END CASE
   RETURN '1','2','3'
END FUNCTION
#FUN-BA0063 FROM TQC-BB0034 add end-------------
#FUN-A70005
   

###GENGRE###START
FUNCTION artg300_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg300")
        IF handler IS NOT NULL THEN
            START REPORT artg300_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY lower(order1) asc nulls first,lower(order2) asc nulls first,lower(order3) asc nulls first"    #FUN-BA0063 add
          
            DECLARE artg300_datacur1 CURSOR FROM l_sql
            FOREACH artg300_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg300_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg300_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

#FUN-BA0063-------add-----str----
PRIVATE FUNCTION artg300_replace_ord_desc(p_desc)
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

REPORT artg300_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-BA0063----add----str---
    DEFINE l_aa00      STRING
    DEFINE l_display   LIKE type_file.chr1
    DEFINE l_display1  LIKE type_file.chr1
    DEFINE l_display2  LIKE type_file.chr1
    DEFINE l_display3  LIKE type_file.chr1
    DEFINE l_display4  LIKE type_file.chr1
    DEFINE l_display5  LIKE type_file.chr1
    DEFINE l_display6  LIKE type_file.chr1
    DEFINE sr1_o       sr1_t
    DEFINE l_rvv17_tot LIKE rvv_file.rvv17
    DEFINE l_rvv39t_tot LIKE rvv_file.rvv39t
    DEFINE l_rvv17_sum1 LIKE rvv_file.rvv17
    DEFINE l_rvv39t_sum1 LIKE rvv_file.rvv39t
    DEFINE l_rvv17_sum2 LIKE rvv_file.rvv17
    DEFINE l_rvv39t_sum2 LIKE rvv_file.rvv39t
    #FUN-BA0063----add----end---
    DEFINE l_rvuplant LIKE rvu_file.rvuplant#FUN-CB0058
    DEFINE l_azp02    LIKE azp_file.azp02   #FUN-CB0058
    DEFINE l_ima131   LIKE ima_file.ima131  #FUN-CB0058
    DEFINE l_oba02    LIKE oba_file.oba02   #FUN-CB0058
    DEFINE l_rvv31    LIKE rvv_file.rvv31   #FUN-CB0058
    DEFINE l_ima02    LIKE ima_file.ima02   #FUN-CB0058

    ORDER EXTERNAL BY sr1.rvuplant,sr1.rvv31,sr1.order1,sr1.order2,sr1.order3      #FUN-BA0063 add    
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-BA0063 add g_ptime,g_user_name
            PRINTX tm.*
            #FUN-BA0063----add----str---
            LET g_ord1_desc = artg300_replace_ord_desc(g_ord1_desc)
            LET g_ord2_desc = artg300_replace_ord_desc(g_ord2_desc)
            LET g_ord3_desc = artg300_replace_ord_desc(g_ord3_desc)
            LET l_aa00 = g_ord1_desc,' ',g_ord2_desc,' ',g_ord3_desc
            PRINTX l_aa00 
            LET sr1_o.rvuplant = NULL
            LET sr1_o.azp02 = NULL
            LET sr1_o.ima131 = NULL
            LET sr1_o.oba02 = NULL
            LET sr1_o.rvv31 = NULL
            LET sr1_o.ima02 = NULL
            LET sr1_o.rvv17 = NULL
            #FUN-BA0063----add----end---

        BEFORE GROUP OF sr1.order1        #FUN-BA0063 add
        BEFORE GROUP OF sr1.order2        #FUN-BA0063 add
        BEFORE GROUP OF sr1.order3        #FUN-BA0063 add
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-BA0063----add----str---
            IF NOT cl_null(sr1_o.rvuplant) THEN
          #    IF sr1_o.rvuplant = sr1.rvuplant THEN         #FUN-CB0058 mark
               IF sr1_o.rvuplant = sr1.rvuplant AND tm.w = 'N' THEN   #FUN-CB0058 add
          #       LET l_display = 'N'            #FUN-CB0058 mark
                  LET l_rvuplant = "  "          #FUN-CB0058 add
               ELSE
          #       LET l_display = 'Y'            #FUN-CB0058 mark
                  LET l_rvuplant = sr1.rvuplant  #FUN-CB0058 add
               END IF
            ELSE
          #    LET l_display = 'Y'            #FUN-CB0058 mark
               LET l_rvuplant = sr1.rvuplant  #FUN-CB0058 add
            END IF
            PRINTX l_display

            IF NOT cl_null(sr1_o.azp02) THEN
            #  IF sr1_o.azp02 = sr1.azp02 THEN    #FUN-CB0058 mark
               IF sr1_o.azp02 = sr1.azp02 AND tm.w = 'N' THEN   #FUN-CB0058 add
           #      LET l_display1 = 'N'     #FUN-CB0058 mark
                  LET l_azp02 = "  "       #FUN-CB0058 add
               ELSE
           #      LET l_display1 = 'Y'     #FUN-CB0058 mark
                  LET l_azp02 = sr1.azp02  #FUN-CB0058 add
               END IF
            ELSE
           #   LET l_display1 = 'Y'     #FUN-CB0058 mark
               LET l_azp02 = sr1.azp02  #FUN-CB0058 add
            END IF
            PRINTX l_display1

            IF NOT cl_null(sr1_o.ima131) THEN
               IF sr1_o.ima131 = sr1.ima131 THEN
            #     LET l_display2 = 'N'     #FUN-CB0058 mark
                  LET l_ima131= sr1.ima131 #FUN-CB0058 add
               ELSE
            #     LET l_display2 = 'Y'     #FUN-CB0058 mark
                  LET l_ima131= sr1.ima131 #FUN-CB0058 add
               END IF
            ELSE
            #  LET l_display2 = 'Y'     #FUN-CB0058 mark
               LET l_ima131= sr1.ima131 #FUN-CB0058 add
            END IF
            PRINTX l_display2

            IF NOT cl_null(sr1_o.oba02) THEN
               IF sr1_o.oba02 = sr1.oba02 THEN
            #     LET l_display3 = 'N'     #FUN-CB0058 mark
                  LET l_oba02 = sr1.oba02  #FUN-CB0058 add
               ELSE
            #     LET l_display3 = 'Y'     #FUN-CB0058 mark
                  LET l_oba02 = sr1.oba02  #FUN-CB0058 add
               END IF
            ELSE
            #  LET l_display3 = 'Y'     #FUN-CB0058 mark
               LET l_oba02 = sr1.oba02  #FUN-CB0058 add
            END IF
            PRINTX l_display3

            IF NOT cl_null(sr1_o.rvv31) THEN
               IF sr1_o.rvv31 = sr1.rvv31 THEN
            #     LET l_display4 = 'N'     #FUN-CB0058 mark
                  LET l_rvv31 = sr1.rvv31  #FUN-CB0058 add
               ELSE
            #     LET l_display4 = 'Y'     #FUN-CB0058 mark
                  LET l_rvv31 = sr1.rvv31  #FUN-CB0058 add
               END IF
            ELSE
            #  LET l_display4 = 'Y'     #FUN-CB0058 mark
               LET l_rvv31 = sr1.rvv31  #FUN-CB0058 add
            END IF
            PRINTX l_display4

            IF NOT cl_null(sr1_o.ima02) THEN
               IF sr1_o.ima02 = sr1.ima02 THEN
            #     LET l_display5 = 'N'  #FUN-CB0058 mark
                  LET l_ima02 = sr1.ima02  #FUN-CB0058 add
               ELSE
            #     LET l_display5 = 'Y'  #FUN-CB0058 mark
                  LET l_ima02 = sr1.ima02  #FUN-CB0058 add
               END IF
            ELSE
            #  LET l_display5 = 'Y'     #FUN-CB0058 mark
               LET l_ima02 = sr1.ima02  #FUN-CB0058 add
            END IF
            PRINTX l_display5

            IF NOT cl_null(sr1_o.rvv17) THEN
               IF sr1_o.rvv17 = sr1.rvv17 THEN
                  LET l_display6 = 'N'
               ELSE
                  LET l_display6 = 'Y'
               END IF
            ELSE
               LET l_display6 = 'Y'
            END IF
            PRINTX l_display6

            LET sr1_o.* = sr1.*
            #FUN-BA0063----add----end---
            PRINTX l_rvuplant   #FUN-CB0058
            PRINTX l_azp02      #FUN-CB0058
            PRINTX l_ima131     #FUN-CB0058
            PRINTX l_oba02      #FUN-CB0058
            PRINTX l_rvv31      #FUN-CB0058
            PRINTX l_ima02      #FUN-CB0058

            PRINTX sr1.*

        AFTER GROUP OF sr1.order1        #FUN-BA0063 add
        AFTER GROUP OF sr1.order2        #FUN-BA0063 add
        AFTER GROUP OF sr1.order3        #FUN-BA0063 add
        #xuxz --FUN-BA0063--add--str
        AFTER GROUP OF sr1.rvuplant
        LET l_rvv17_sum1 = GROUP SUM(sr1.rvv17)
        PRINTX l_rvv17_sum1
        LET l_rvv39t_sum1 = GROUP SUM(sr1.rvv39t)
        PRINTX l_rvv39t_sum1
        AFTER GROUP OF sr1.rvv31
        LET l_rvv17_sum2 = GROUP SUM(sr1.rvv17)
        PRINTX l_rvv17_sum2
        LET l_rvv39t_sum2 = GROUP SUM(sr1.rvv39t)
        PRINTX l_rvv39t_sum2
        #xuxz --FUN-BA0063--add--end
        
        ON LAST ROW
           #FUN-BA0063 xuxz add --str
           LET l_rvv17_tot = SUM(sr1.rvv17)
           PRINTX l_rvv17_tot
           LET l_rvv39t_tot = SUM(sr1.rvv39t)
           PRINTX l_rvv39t_tot
           #FUN-BA0063 xuxz add --end

END REPORT
###GENGRE###END
