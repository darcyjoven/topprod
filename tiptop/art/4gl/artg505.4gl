# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: artg505.4gl
# Descriptions...: 進銷存統計表
# Date & Author..: 10/07/26 FUN-A70046 By vealxu
# Modify.........: No:TQC-B10181 11/01/18 By shiwuying Bug修改
# Modify.........: No:TQC-B70082 11/07/11 By guoch 將wc,l_sql的類型換成STRING
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BA0063 11/10/19 By yangtt CR轉換成GRW
# Modify.........: No.FUN-BA0063 12/01/05 By qirl FUN-B80085追單
# Modify.........: No.FUN-C20053 12/03/02 By xuxz GR

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm          RECORD                          # Print condition RECORD
           #        wc1     LIKE type_file.chr1000, # Where condition  #TQC-B70082  mark
           #        wc2     LIKE type_file.chr1000, # Where condition  #TQC-B70082  mark
           #        wc3     LIKE type_file.chr1000, # Where condition  #TQC-B70082  mark
                   wc1     STRING,  #TQC-B70082
                   wc2     STRING,  #TQC-B70082
                   wc3     STRING,  #TQC-B70082
                   yy01    LIKE type_file.dat,    
                   yy02    LIKE type_file.dat,    
                   type    LIKE type_file.chr1,     
                   more    LIKE type_file.chr1     # Input more condition(Y/N)  
                   END RECORD
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_sql2          STRING  
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   l_flag          LIKE type_file.chr1 
DEFINE   g_yy01,g_yy02   LIKE type_file.num5,    
         g_mm01,g_mm02   LIKE type_file.num5,
         last_y          LIKE type_file.num5,    
         last_m          LIKE type_file.num5
DEFINE   g_argv1         LIKE type_file.num5
DEFINE   g_chk_auth      STRING 

###GENGRE###START
TYPE sr1_t RECORD
    imkplant LIKE imk_file.imkplant,
    azp02 LIKE azp_file.azp02,
    ima131 LIKE ima_file.ima131,
    oba02 LIKE oba_file.oba02,
    ima01 LIKE ima_file.ima01,
    ima02 LIKE ima_file.ima02,
    imk02 LIKE imk_file.imk02,
    num01 LIKE type_file.num15_3,
    cost01 LIKE type_file.num15_3,
    num02 LIKE type_file.num15_3,
    cost02 LIKE type_file.num15_3,
    num03 LIKE type_file.num15_3,
    cost03 LIKE type_file.num15_3,
    num04 LIKE type_file.num15_3,
    cost04 LIKE type_file.num15_3,
    num05 LIKE type_file.num15_3,
    cost05 LIKE type_file.num15_3,
    num06 LIKE type_file.num15_3,
    cost06 LIKE type_file.num15_3,
    num07 LIKE type_file.num15_3,
    cost07 LIKE type_file.num15_3,
    cost08 LIKE type_file.num15_3
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT             
       
   LET g_argv1 = ARG_VAL(1)                   #調用時傳遞的參數  

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "imkplant.imk_file.imkplant,",        #運營中心
                "azp02.azp_file.azp02,",        #運營中心名稱
                "ima131.ima_file.ima131,",      #產品分類
                "oba02.oba_file.oba02,",        #分類名稱
                "ima01.ima_file.ima01,",        #產品編號
                "ima02.ima_file.ima02,",        #產品名稱  
                "imk02.imk_file.imk02,",        #仓库"
                "num01.type_file.num15_3,",       #期初量
                "cost01.type_file.num15_3,",      #期初金额
                "num02.type_file.num15_3,",       #入库数量 
                "cost02.type_file.num15_3,",     
                "num03.type_file.num15_3,",       #销售数量 
                "cost03.type_file.num15_3,",      
                "num04.type_file.num15_3,",       #领出数量 
                "cost04.type_file.num15_3,",     
                "num05.type_file.num15_3,",       #调拨数量 
                "cost05.type_file.num15_3,",      
                "num06.type_file.num15_3,",       #调整数量 
                "cost06.type_file.num15_3,",  
                "num07.type_file.num15_3,",       #期末量
                "cost07.type_file.num15_3,",      
                "cost08.type_file.num15_3"        #差額   
 
   LET l_table = cl_prt_temptable('artg505',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

  ##FUN-C20053--mark----add-------- 
   CASE 
      WHEN g_argv1='1'
           LET g_prog='artg505'
      WHEN g_argv1='2'
           LET g_prog='artg506'
      WHEN g_argv1='3'
           LET g_prog='artg507'
      OTHERWISE
           CALL cl_err('','art-777',1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
           EXIT PROGRAM
   END CASE     
  ##FUN-C20052---mark--end--------- 
 
   LET g_pdate = ARG_VAL(1)     
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc1 = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'  THEN 
      CALL artg505_tm(0,0)   
   ELSE
      CALL artg505()          
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
END MAIN

FUNCTION artg505_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   DEFINE l_zxy03        LIKE zxy_file.zxy03
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artg505_w AT p_row,p_col WITH FORM "art/42f/artg505" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc2 = ' 1=1'
   LET tm.wc3 = '1=1' 
   LET tm.type = '1' 
   LET tm.yy01 = g_today
   LET tm.yy02 = g_today
 

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
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.where = " EXISTS (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
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

      END CONSTRUCT

      IF INT_FLAG THEN
        #LET INT_FLAG = 0 CLOSE WINDOW artr512_w #TQC-B10181
         LET INT_FLAG = 0 CLOSE WINDOW artg505_w #TQC-B10181
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      IF cl_null(tm.wc1) THEN
         LET tm.wc1 = "1=1"
      END IF
 
      CONSTRUCT BY NAME tm.wc2 ON ima131,ima01
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
                  LET g_qryparam.form = "q_ima131_3"
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
            
      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artg505_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      
      IF cl_null(tm.wc2) THEN
         LET tm.wc2 = '1=1' 
      END IF

      CONSTRUCT BY NAME tm.wc3 ON imk02

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

            EXIT CONSTRUCT
      END CONSTRUCT
     
      IF cl_null(tm.wc3) THEN
         LET tm.wc3 = '1=1'
      END IF
     
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
        #LET INT_FLAG = 0 CLOSE WINDOW artr200_w #TQC-B10181
         LET INT_FLAG = 0 CLOSE WINDOW artg505_w #TQC-B10181
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF

      DISPLAY BY NAME  tm.yy01,tm.yy02,tm.type,tm.more
      
      INPUT BY NAME  tm.yy01,tm.yy02,tm.type,tm.more WITHOUT DEFAULTS 

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
            END IF
            
         AFTER FIELD yy01
            IF NOT cl_null(tm.yy01) THEN
                IF tm.yy01 > g_today THEN
                  CALL cl_err('','asr-049',0)
                  NEXT FIELD yy01
               END IF

               IF tm.yy01 > tm.yy02 THEN 
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD yy01
               END IF 
            ELSE
               CALL cl_err('','abx-801',0)
               NEXT FIELD yy01
            END IF
            LET g_yy01 = YEAR(tm.yy01)
            LET g_mm01 = MONTH(tm.yy01)  
          
         AFTER FIELD yy02
            IF NOT cl_null(tm.yy02) THEN 
                IF tm.yy02 > g_today THEN
                  CALL cl_err('','asr-049',0)
                  NEXT FIELD yy02
               END IF
               IF tm.yy02 < tm.yy01 THEN 
                  CALL cl_err('','aap-100',0)
                  NEXT FIELD yy02
               END IF 
            ELSE
               CALL cl_err('','abx-801',0)
               NEXT FIELD yy02
            END IF
            LET g_yy02 = YEAR(tm.yy02)
            LET g_mm02 = MONTH(tm.yy02)  
            
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()  
            
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF  cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME tm.more
            END IF
            IF  l_flag = 'Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD edate
            END IF 
           
            
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
         LET INT_FLAG = 0 CLOSE WINDOW artg505_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      
      LET g_chk_auth = ''
      DECLARE r520_zxy_cs CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
      FOREACH r520_zxy_cs INTO l_zxy03 
        IF g_chk_auth IS NULL THEN
           LET g_chk_auth = "'",l_zxy03,"'"
        ELSE
           LET g_chk_auth = g_chk_auth,",'",l_zxy03,"'"
        END IF
      END FOREACH
      IF g_chk_auth IS NOT NULL THEN
         LET g_chk_auth = "(",g_chk_auth,")"
      END IF
 
      LET g_yy01 = YEAR(tm.yy01)                                                                                                        
      LET g_mm01 = MONTH(tm.yy01)                                                                                                       

      LET last_y = g_yy01 LET last_m = g_mm01 - 1
      IF last_m = 0 THEN
         LET last_y = last_y - 1 
         LET last_m = 12
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file   
          WHERE zz01='artg505'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artg505','9031',1)
         ELSE
            LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,              
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc2 CLIPPED,"'" ,
                       " '",tm.wc3 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artg505',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artg505_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artg505()
      ERROR ""
   END WHILE
   CLOSE WINDOW artg505_w
END FUNCTION

FUNCTION artg505()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
       #   l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #TQC-B70082  mark  
          l_sql     STRING,       
          u_flag    LIKE type_file.chr1,
          l_plant   LIKE azw_file.azw01,
          sr        RECORD 
                    imkplant    LIKE imk_file.imkplant, 
                    azp02       LIKE azp_file.azp02,
                    ima131      LIKE ima_file.ima131,
                    oba02       LIKE oba_file.oba02,
                    ima01       LIKE ima_file.ima01, 
                    ima02       LIKE ima_file.ima02, 
                    imk02       LIKE imk_file.imk02,
                    num01       LIKE type_file.num15_3,
                    cost01      LIKE type_file.num15_3,
                    num02       LIKE type_file.num15_3,
                    cost02      LIKE type_file.num15_3,
                    num03       LIKE type_file.num15_3,
                    cost03      LIKE type_file.num15_3,
                    num04       LIKE type_file.num15_3,
                    cost04      LIKE type_file.num15_3,
                    num05       LIKE type_file.num15_3,
                    cost05      LIKE type_file.num15_3, 
                    num06       LIKE type_file.num15_3,
                    cost06      LIKE type_file.num15_3,
                    num07       LIKE type_file.num15_3,
                    cost07      LIKE type_file.num15_3,
                    cost08      LIKE type_file.num15_3 
                    END RECORD,
          l_azp02   LIKE azp_file.azp02,
          l_oba02   LIKE oba_file.oba02,
          l_ccc23   LIKE ccc_file.ccc23,
          l_start,l_end      LIKE type_file.dat,
          l_imk09   LIKE imk_file.imk09,
          l_sum_num07   LIKE type_file.num15_3,
          l_sum_cost07  LIKE type_file.num15_3,
          l_flag        LIKE type_file.chr1,
          l_ccc08       LIKE ccc_file.ccc08,
          l_imk02       LIKE imk_file.imk02,
          l_imk03       LIKE imk_file.imk03,  
          l_imk04       LIKE imk_file.imk04,
          l_rtz04       LIKE rtz_file.rtz04,
          l_tlf21       LIKE tlf_file.tlf21
   DEFINE l_num02   LIKE type_file.num15_3,
          l_cost02  LIKE type_file.num15_3,
          l_num03   LIKE type_file.num15_3,
          l_cost03  LIKE type_file.num15_3,
          l_num04   LIKE type_file.num15_3,
          l_cost04  LIKE type_file.num15_3,
          l_num05   LIKE type_file.num15_3,
          l_cost05  LIKE type_file.num15_3,
          l_num06   LIKE type_file.num15_3,
          l_cost06  LIKE type_file.num15_3
   DEFINE l_zxy03   LIKE zxy_file.zxy03


   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
       LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

       CALL cl_del_data(l_table)
       LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                   " VALUES(?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,   ?, ?, ?, ?, ?,  ?, ? )"
       PREPARE insert_prep FROM g_sql
       IF STATUS THEN
          CALL cl_err('insert_prep:',status,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-BA0063--add--
          CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
          EXIT PROGRAM
       END IF

      DROP TABLE artg505_tmp
      CREATE TEMP TABLE artg505_tmp(
                    imkplant    LIKE imk_file.imkplant,
                    azp02       LIKE azp_file.azp02,
                    ima131      LIKE ima_file.ima131,
                    oba02       LIKE oba_file.oba02,
                    ima01       LIKE ima_file.ima01,
                    ima02       LIKE ima_file.ima02,
                    imk02       LIKE imk_file.imk02,
                    num01       LIKE type_file.num15_3,
                    cost01      LIKE type_file.num15_3,
                    num02       LIKE type_file.num15_3,
                    cost02      LIKE type_file.num15_3,
                    num03       LIKE type_file.num15_3,
                    cost03      LIKE type_file.num15_3,
                    num04       LIKE type_file.num15_3,
                    cost04      LIKE type_file.num15_3,
                    num05       LIKE type_file.num15_3,
                    cost05      LIKE type_file.num15_3,
                    num06       LIKE type_file.num15_3,
                    cost06      LIKE type_file.num15_3,
                    num07       LIKE type_file.num15_3,
                    cost07      LIKE type_file.num15_3,
                    cost08      LIKE type_file.num15_3 )
     DELETE FROM artg505_tmp
   
     LET l_sql = "SELECT DISTINCT zxy03 FROM zxy_file ",
                 " WHERE zxy01 = '",g_user,"' "
     PREPARE g505_pre FROM l_sql
     DECLARE g505_db_cs CURSOR FOR g505_pre
     LET g_sql2 = ''
     IF tm.wc1 = "1=1"  THEN
        FOREACH g505_db_cs INTO l_zxy03 
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:g505_db_cs',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF     
 
           LET g_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                       " WHERE ",tm.wc1 CLIPPED ,
                       "   AND azp01 = azw01  ",
                       "   AND azp01 = '",l_zxy03 CLIPPED,"'" 
           IF g_sql2 IS NULL THEN
              LET g_sql2 = g_sql
           ELSE
              LET g_sql = g_sql2," UNION ALL ",g_sql
              LET g_sql2 = g_sql
           END IF
        END FOREACH
     ELSE
        LET g_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                    " WHERE ",tm.wc1 CLIPPED ,
                    "   AND azp01 = azw01  ",
                    "   AND azp01 IN ",g_chk_auth  
     END IF 

     PREPARE sel_pre FROM g_sql
     DECLARE sel_cs CURSOR FOR sel_pre

     FOREACH sel_cs INTO l_plant,l_azp02
       IF STATUS THEN
          CALL cl_err('SELECT:',SQLCA.sqlcode,1)
          RETURN
       END IF
          
       LET l_sql = "SELECT rtz04 ",
                   "  FROM ",cl_get_target_table(l_plant,'rtz_file'),
                   " WHERE  rtz01 = '",l_plant,"' "
        CALL g505_predb(l_sql,l_plant) RETURNING l_sql
        PREPARE artg505_pre12 FROM l_sql
        EXECUTE artg505_pre12 INTO l_rtz04
 
       CALL g505_case(tm.type,tm.wc2,tm.wc3,l_plant,l_rtz04) RETURNING l_sql
       CALL g505_predb(l_sql,l_plant) RETURNING l_sql
       PREPARE artg505_prepare1 FROM l_sql

       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
          EXIT PROGRAM
       END IF
       DECLARE artg505_curs1 CURSOR FOR artg505_prepare1

       FOREACH artg505_curs1 INTO sr.*,l_ccc08,l_imk02,l_imk03,l_imk04
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF sr.ima131 IS NOT NULL THEN
            SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = sr.ima131
         ELSE
            LET l_oba02 = ''
         END IF   
         #先進先出時期初計算方法
         IF tm.type = '2' THEN   
            LET l_sql = "SELECT SUM(cxa08)-SUM(cxc08),SUM(cxa09)-SUM(cxc09) ",
                        "  FROM ",cl_get_target_table(l_plant,'cxc_file'),",",
                                  cl_get_target_table(l_plant,'cxa_file'),
                        " WHERE cxa01 = cxc01 AND cxa01 = '",sr.ima01,"'",
                        "   AND cxa02 = cxc02 AND cxa03 = cxc03 AND cxa010 = cxc010  AND cxa011 = cxc011", 
                        "   AND cxa02 = '",YEAR(tm.yy01),"' AND cxa03 ='",MONTH(tm.yy01),"'",
                        "   AND cxa010 = '",tm.type,"'"," AND cxa011 = '",l_imk04,"'",
                        "   AND cxa04 <= '",tm.yy01,"'"
            CALL g505_predb(l_sql,l_plant) RETURNING l_sql
            PREPARE pre_sql0 FROM l_sql
            EXECUTE pre_sql0 INTO sr.num01,sr.cost01
            IF cl_null(sr.num01) OR sr.num01 = 0 THEN
             #不再撈取當期庫存（img_file）----------mark----------------
             # IF tm.yy01 = g_today  THEN           
             #    LET l_sql = "SELECT img10 FROM ",cl_get_target_table(l_plant,'img_file'),
             #                " WHERE img01 = '",sr.ima01,"'",
             #                "   AND img02 = '",l_imk02,"'",
             #                "   AND img03 = '",l_imk03,"'",
             #                "   AND img04 = '",l_imk04,"'"
             #    CALL g505_predb(l_sql,l_plant) RETURNING l_sql
             #    PREPARE pre_sql01 FROM l_sql
             #    EXECUTE pre_sql01 INTO sr.num01
             # ELSE
             #-------------------------mark ---------------------------
                  CALL g505_getnum01(sr.ima01,sr.imk02,l_imk03,l_imk04,last_y,last_m,l_plant) RETURNING sr.num01
                  CALL s_azn01(last_y,last_m) RETURNING l_start,l_end   #返回當前計算月份的第一天 最後一天
                  LET l_sql = " SELECT SUM(tlf907*tlf10) FROM ", cl_get_target_table(l_plant,'tlf_file'),
                              "  WHERE tlf01 ='", sr.ima01,"' AND (tlf06 BETWEEN '",l_end + 1 ,"' AND '",tm.yy01-1,"')",
                              "    AND tlf902 = '",l_imk02,"' AND tlf903 = '",l_imk03,"'",
                              "    AND tlf904 = '",l_imk04,"'"  
                  CALL g505_predb(l_sql,l_plant) RETURNING l_sql
                  PREPARE pre_sql02 FROM l_sql
                  EXECUTE pre_sql02 INTO l_imk09
                  IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF
                  LET sr.num01 = sr.num01 + l_imk09
            END IF  
             # CALL g505_getprice(sr.ima01,YEAR(tm.yy01),MONTH(tm.yy01),tm.type,l_ccc08,l_plant) RETURNING l_ccc23
               LET sr.cost01 = 0          #金额不算，置为 0  
           #END IF                 #mark 
         ELSE#成本類型不為2時
            LET l_imk09 = 0 
            #還原到起始的日期的前一月
            LET last_y = g_yy01 LET last_m = g_mm01 - 1
            IF last_m = 0 THEN
               LET last_y = last_y - 1
               LET last_m = 12
            END IF

            #- -> 撈上月期末數量,若沒有就給0，不抓上期 
            CALL g505_getnum01(sr.ima01,sr.imk02,l_imk03,l_imk04,last_y,last_m,l_plant) RETURNING sr.num01
            #直接計算日期區間異動量------>期初量              
            CALL s_azn01(last_y,last_m) RETURNING l_start,l_end   #返回當前計算月份的第一天 最後一天
            LET l_sql = " SELECT SUM(tlf907*tlf10) FROM ", cl_get_target_table(l_plant,'tlf_file'),
                        "  WHERE tlf01 ='", sr.ima01,"' AND (tlf06 BETWEEN '",l_end + 1 ,"' AND '",tm.yy01-1,"')",
                        "    AND tlf902 = '",l_imk02,"' AND tlf903 = '",l_imk03,"'",
                        "    AND tlf904 = '",l_imk04,"'"
            CALL g505_predb(l_sql,l_plant) RETURNING l_sql
            PREPARE pre_sql2 FROM l_sql
            EXECUTE pre_sql2 INTO l_imk09
            IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF       
            LET sr.num01 = sr.num01 + l_imk09
            CALL g505_getprice(sr.ima01,YEAR(tm.yy01),MONTH(tm.yy01),tm.type,l_ccc08,l_plant) RETURNING l_ccc23 
            LET sr.cost01 = sr.num01 * l_ccc23
         END IF 

         LET sr.num07 = sr.num01
         LET sr.cost07 = sr.cost01
                                        
         #- ->入/銷/調/領/調量統計及金額,不用考慮跨月  
         CALL g505_getcount(sr.ima01,tm.yy01,tm.yy02,l_imk02,l_imk03,l_imk04,l_plant)
                  RETURNING l_num02,l_cost02,l_num03,l_cost03,l_num04,l_cost04,l_num05,l_cost05,l_num06,l_cost06
         
         LET sr.num02 = sr.num02 + l_num02 
         LET sr.cost02 = sr.cost02 + l_cost02
         LET sr.num03 = sr.num03 + l_num03 
         LET sr.cost03 = sr.cost03 + l_cost03
         LET sr.num04 = sr.num04 + l_num04 
         LET sr.cost04 = sr.cost04 + l_cost04
         LET sr.num05 = sr.num05 + l_num05 
         LET sr.cost05 = sr.cost05 + l_cost05
         LET sr.num06 = sr.num06 + l_num06 
         LET sr.cost06 = sr.cost06 + l_cost06
   
         #統計期間异动量--->期末量
         LET l_sum_num07 = 0
         LET l_sql = "SELECT SUM(tlf907*tlf10) FROM ", cl_get_target_table(l_plant,'tlf_file'),
                     " WHERE tlf01 = '",sr.ima01,"' AND (tlf06 BETWEEN '", tm.yy01,"' AND '", tm.yy02,"')",
                     "    AND tlf902 = '",l_imk02,"' AND tlf903 = '",l_imk03,"'",
                     "    AND tlf904 = '",l_imk04,"'"
         CALL g505_predb(l_sql,l_plant) RETURNING l_sql
         PREPARE pre_sql4 FROM l_sql
         EXECUTE pre_sql4 INTO l_sum_num07 
         IF cl_null(l_sum_num07) THEN LET l_sum_num07 = 0 END IF

         CALL g505_getprice(sr.ima01,YEAR(tm.yy02),MONTH(tm.yy02),tm.type,l_ccc08,l_plant) RETURNING l_ccc23
        #統計期間异动金額--->期末金額
         LET l_sum_cost07 = l_sum_num07*l_ccc23
         LET sr.num07 = sr.num07 + l_sum_num07
         LET sr.cost07 = sr.cost07 + l_sum_cost07
      #######################################################
      #跨月,期末量直接撈畫面日期區間的,
      # ELSE                                                                                                       
      #  LET l_cnt = 1 
      #  LET l_yy02 = YEAR(tm.yy02)  
      #  LET l_mm02 = MONTH(tm.yy02)
      #  LET l_mm = MONTH(tm.yy01) 
      #  LET l_yy = YEAR(tm.yy01)
      #  LET l_month  = YEAR(tm.yy02)*12 + MONTH(tm.yy02) - YEAR(tm.yy01)*12 - MONTH(tm.yy01)
      #  WHILE l_cnt < l_month 
      #      CALL s_azn01(l_yy,l_mm) RETURNING l_time01,l_time02      
      #      #判斷是否截止日期的月份.如果是則需用截至日期，而不用該月份的最後一天
      #      IF l_yy = l_yy02 AND l_mm = l_mm02 AND l_time02 > tm.yy02 THEN    
      #         LET l_time02 = tm.yy02 
      #      END IF       
      #     #起始日期至該月最後一天，再下月第一天至最後一天 ，再下下月第一天至截止日期。類推
      #      IF l_cnt = 1 THEN LET l_time01 = tm.yy01 END IF    
      #
      #      #統計此月异动量--->期末量
      #      LET l_sum_num07 = 0
      #      LET l_sql = "SELECT SUM(tlf907*tlf10) FROM", cl_get_target_table(l_plant,'tlf_file'),
      #                 "  WHERE tlf01 = ",sr.ima01," AND (tlf06 BETWEEN", l_time01," AND", l_time02,")",
      #                 "  GROUP BY tlf01"
      #      CALL g505_predb(l_sql,l_plant) RETURNING l_sql
      #      PREPARE pre_sql5 FROM l_sql
      #      DECLARE cur_sql5 CURSOR FOR pre_sql5
      #      OPEN cur_sql5
      #      FETCH cur_sql5 INTO l_sum_num07   
      #      IF cl_null(l_sum_num07) THEN LET l_sum_num07 = 0 END IF
      #
      #      CALL g505_getprice(sr.ima01,YEAR(tm.yy01),MONTH(tm.yy01),tm.type,l_imk04,l_plant) RETURNING l_ccc23
      #      #統計异动金額--->期末金額
      #      LET l_sum_cost07 = l_sum_num07 * l_ccc23
      #      LET sr.num07 = sr.num07 + l_sum_num07
      #      LET sr.cost07 = sr.cost07 + l_sum_cost07
      #
      #     LET l_cnt  = l_cnt + 1 
      # END WHILE       
      #END IF 
      ################################################### 
          LET sr.cost08 = sr.cost01+sr.cost02-sr.cost03-sr.cost04-sr.cost05-sr.cost06-sr.cost07 
          INSERT INTO artg505_tmp VALUES(
          sr.imkplant,l_azp02,sr.ima131,l_oba02,sr.ima01,sr.ima02,
          sr.imk02,sr.num01,sr.cost01,sr.num02,sr.cost02,sr.num03,
          sr.cost03,sr.num04,sr.cost04,sr.num05,sr.cost05,sr.num06,
          sr.cost06,sr.num07,sr.cost07,sr.cost08)  
      END FOREACH 
   END FOREACH
   
   CASE
      WHEN g_argv1='1'
         LET l_sql = "SELECT imkplant,azp02,'','','','','',",
                     "       sum(num01),sum(cost01),sum(num02),sum(cost02),sum(num03),sum(cost03), ",
                     "       sum(num04),sum(cost04),sum(num05),sum(cost05),sum(num06),sum(cost06), ",                                                            
                     "       sum(num07),sum(cost07),sum(cost08)",
                     " FROM artg505_tmp ",
                     " GROUP BY imkplant,azp02"
      WHEN g_argv1='2'
         LET l_sql = "SELECT imkplant,azp02,ima131,oba02,'','','',",
                     "       sum(num01),sum(cost01),sum(num02),sum(cost02),sum(num03),sum(cost03), ",
                     "       sum(num04),sum(cost04),sum(num05),sum(cost05),sum(num06),sum(cost06), ",
                     "       sum(num07),sum(cost07),sum(cost08)",
                     " FROM artg505_tmp ",
                     " GROUP BY imkplant,azp02,ima131,oba02"
      WHEN g_argv1='3'
         LET l_sql = "SELECT imkplant,azp02,'','',ima01,ima02,'',",
                     "       sum(num01),sum(cost01),sum(num02),sum(cost02),sum(num03),sum(cost03), ",
                     "       sum(num04),sum(cost04),sum(num05),sum(cost05),sum(num06),sum(cost06), ",
                     "       sum(num07),sum(cost07),sum(cost08)",
                     " FROM artg505_tmp ",
                     " GROUP BY imkplant,azp02,ima01,ima02"
   END CASE
   PREPARE artg505_prepare3 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)               #FUN-BA0063 add
      EXIT PROGRAM
   END IF
   DECLARE artg505_curs3 CURSOR FOR artg505_prepare3

   INITIALIZE sr.* TO NULL 
   FOREACH artg505_curs3 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      EXECUTE  insert_prep  USING sr.* 
   END FOREACH

###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###   LET g_str = tm.wc1," AND ",tm.wc2," AND ",tm.wc3 
   CASE
      WHEN g_argv1='1'
###GENGRE###         CALL cl_prt_cs3(g_prog,'artg505',l_sql,g_str)  
         LET g_prog = "artg505"   #FUN-C20053 
         LET g_template = 'artg505'          #FUN-BA0063 add
         CALL artg505_grdata()    ###GENGRE###
         LET g_prog = "artg505"   #FUN-C20053
      WHEN g_argv1='2'
###GENGRE###         CALL cl_prt_cs3(g_prog,'artr505_1',l_sql,g_str) #FUN-C20053 506--->505_1
         LET g_prog = "artg505"   #FUN-C20053 
         LET g_template = 'artg505_1'          #FUN-BA0063 add #FUN-C20053 506--->505_1
         CALL artg505_1_grdata()    ###GENGRE###
         LET g_prog = "artg506"   #FUN-C20053
      WHEN g_argv1='3'
###GENGRE###         CALL cl_prt_cs3(g_prog,'artr505_2',l_sql,g_str)  #FUN-C20053 507--->505_1
         LET g_prog = "artg505"   #FUN-C20053 
         LET g_template = 'artg505_2'          #FUN-BA0063 add #FUN-C20053 507--->505_1
         CALL artg505_2_grdata()    ###GENGRE###
         LET g_prog = "artg507"   #FUN-C20053
   END CASE
END FUNCTION

#抓取（出/入）庫量，金額以及類型 
FUNCTION g505_getcount(p_tlf01,p_tlf06_s,p_tlf06_e,p_tlf902,p_tlf903,p_tlf904,p_plant)
     DEFINE p_tlf01   LIKE tlf_file.tlf01
     DEFINE p_tlf06_s LIKE tlf_file.tlf06,
            p_tlf06_e LIKE tlf_file.tlf06,
            p_tlf902  LIKE tlf_file.tlf902,
            p_tlf903  LIKE tlf_file.tlf903,
            p_tlf904  LIKE tlf_file.tlf904 
     DEFINE l_tlf02   LIKE tlf_file.tlf02,
            l_tlf026  LIKE tlf_file.tlf026,
            l_tlf03   LIKE tlf_file.tlf03,
            l_tlf036  LIKE tlf_file.tlf036, 
            l_tlf10   LIKE tlf_file.tlf10,
            l_tlf21   LIKE tlf_file.tlf21 
     DEFINE l_temp    LIKE smy_file.smyslip
     DEFINE l_flag    LIKE smy_file.smydmy2   
     DEFINE p_plant   LIKE azw_file.azw01     
     DEFINE l_sql     STRING 
     DEFINE l_num02   LIKE type_file.num15_3,
            l_cost02  LIKE type_file.num15_3,
            l_num03   LIKE type_file.num15_3,
            l_cost03  LIKE type_file.num15_3,
            l_num04   LIKE type_file.num15_3,
            l_cost04  LIKE type_file.num15_3,
            l_num05   LIKE type_file.num15_3,
            l_cost05  LIKE type_file.num15_3,
            l_num06   LIKE type_file.num15_3,
            l_cost06  LIKE type_file.num15_3  
             
       
    LET l_num02 = 0     LET l_cost02 = 0 
    LET l_num03 = 0     LET l_cost03 = 0
    LET l_num04 = 0     LET l_cost04 = 0
    LET l_num05 = 0     LET l_cost05 = 0
    LET l_num06 = 0     LET l_cost06 = 0

    LET l_sql = "SELECT tlf02,tlf026,tlf03,tlf036,tlf10,tlf21",
                "  FROM ", cl_get_target_table(p_plant,'tlf_file') ,
                " WHERE tlf01  = '", p_tlf01 ,"' AND tlf907 ! = 0  AND (tlf06 BETWEEN '",p_tlf06_s,"' AND '",p_tlf06_e,"')",
                "   AND tlf902 = '", p_tlf902,"' AND tlf903 = '",p_tlf903,"'",
                "   AND tlf904 = '", p_tlf904,"'"   
   CALL g505_predb(l_sql,p_plant) RETURNING l_sql
   PREPARE pre_sql6 FROM l_sql
   DECLARE sel_cs6  CURSOR FOR pre_sql6 

   FOREACH sel_cs6 INTO l_tlf02,l_tlf026,l_tlf03,l_tlf036,l_tlf10,l_tlf21
      IF STATUS THEN
          CALL s_errmsg('','','Foreach tlf_file error !',SQLCA.SQLCODE,1)
          EXIT FOREACH
       END IF
      #-->出庫 
      IF (l_tlf02 >= 50 AND l_tlf02 <= 59 ) AND (l_tlf02 != 57 ) THEN
         LET l_temp = s_get_doc_no(l_tlf026)
         SELECT smydmy2 INTO l_flag FROM smy_file WHERE smyslip = l_temp
      END IF 
      #-->入庫
      IF (l_tlf03 >= 50 AND l_tlf03 <= 59 ) AND (l_tlf03 != 57 ) THEN
          LET l_temp = s_get_doc_no(l_tlf036)
          SELECT smydmy2 INTO l_flag FROM smy_file WHERE smyslip = l_temp
      END IF  
      IF cl_null(l_tlf10) THEN LET l_tlf10 = 0 END IF 
      IF cl_null(l_tlf21) THEN LET l_tlf21 = 0 END IF 
      CASE
         WHEN l_flag = 1 LET l_num02 = l_num02 + l_tlf10
                         LET l_cost02 = l_cost02 + l_tlf21
         WHEN l_flag = 2 LET l_num03 = l_num03 + l_tlf10
                         LET l_cost03 = l_cost03 + l_tlf21
         WHEN l_flag = 3 LET l_num04 = l_num04 + l_tlf10
                         LET l_cost04 = l_cost04 + l_tlf21
         WHEN l_flag = 4 LET l_num05 = l_num05 + l_tlf10
                         LET l_cost05 = l_cost05 + l_tlf21
         WHEN l_flag = 5 LET l_num06 = l_num06 + l_tlf10
                         LET l_cost06 = l_cost06 + l_tlf21
         OTHERWISE EXIT CASE
     END CASE
  END FOREACH  

  RETURN l_num02,l_cost02,l_num03,l_cost03,l_num04,l_cost04,l_num05,l_cost05,l_num06,l_cost06
 
END FUNCTION    

FUNCTION g505_predb(p_sql,p_plant)
   DEFINE p_sql   STRING
   DEFINE l_sql   STRING
   DEFINE p_plant LIKE azw_file.azw01
     CALL cl_replace_sqldb(p_sql) RETURNING l_sql
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
     RETURN l_sql
END FUNCTION    

#依條件抓取月平均價ccc23,若沒有，撈上月的
FUNCTION g505_getprice(p_ccc01,p_ccc02,p_ccc03,p_ccc07,p_ccc08,p_plant)
  DEFINE  p_ccc01  LIKE ccc_file.ccc01,
          p_ccc02  LIKE ccc_file.ccc02,
          p_ccc03  LIKE ccc_file.ccc03,
          p_ccc07  LIKE ccc_file.ccc07,
          p_ccc08  LIKE ccc_file.ccc08,
          p_plant  LIKE azw_file.azw01
  DEFINE  l_flag   LIKE type_file.chr1,
          l_ccc23  LIKE ccc_file.ccc23,
          l_sql    STRING     
   
      LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(p_plant,'ccc_file'),
                       " WHERE ccc01 = '",p_ccc01,"'",                          
                       "   AND ccc07 = '",p_ccc07,"' AND ccc08 = '",p_ccc08,"'", 
                       "   AND ccc02 = '",p_ccc02,"' AND ccc03 = '",p_ccc03,"'"  
   #                   "   AND ccc02||(100+ccc03)[2,3] in(",                 
   #                   " SELECT max(ccc02||(100+ccc03)[2,3]) FROM ",cl_get_target_table(p_plant,'ccc_file'),
   #                   " WHERE ccc02||(100+ccc03)[2,3]  < '", p_ccc02,"'||(100+'", p_ccc03,"')[2,3] ",
   #                   " AND   ccc01 = '",p_ccc01,"'",
   #                   " AND   ccc07 = '",p_ccc07,"' AND ccc08 = '",p_ccc08,"')"
     CALL g505_predb(l_sql,p_plant) RETURNING l_sql
     PREPARE pre_sql13 FROM  l_sql
     EXECUTE pre_sql13 INTO l_ccc23
     IF cl_null(l_ccc23) THEN
        LET l_ccc23 = 0 
     END IF        
   ######################################### 
   #  LET l_flag = TRUE
   #  WHILE l_flag  
   #      LET l_sql = " SELECT ccc23 FROM ",cl_get_target_table(p_plant,'ccc_file'),
   #                  " WHERE  ccc01 = '",p_ccc01,"' AND ccc02 = ",p_ccc02,
   #                  "   AND  ccc03 = ",p_ccc03," AND ccc07 = '",p_ccc07,
   #                  "'  AND  ccc08 = '",p_ccc08,"'"      
   #      CALL g505_predb(l_sql,p_plant) RETURNING l_sql
   #      PREPARE pre_sql13 FROM  l_sql
   #      EXECUTE pre_sql13 INTO l_ccc23
   #      IF cl_null(l_ccc23) THEN 
   #         LET p_ccc03 = p_ccc03 - 1
   #         IF p_ccc03 = 0 THEN
   #            LET p_ccc03 = 12 
   #            LET p_ccc02 = p_ccc02 - 1
   #         END IF
   #      ELSE
   #         LET l_flag = FALSE
   #     END IF   
   #  END WHILE 
   #######################################   
      RETURN l_ccc23
END FUNCTION         

#抓取上期期末量,為空為0,返回期末量imk09
FUNCTION g505_getnum01(p_imk01,p_imk02,p_imk03,p_imk04,p_imk05,p_imk06,p_plant)
   DEFINE p_imk01       LIKE imk_file.imk01
   DEFINE p_imk02       LIKE imk_file.imk02
   DEFINE p_imk03       LIKE imk_file.imk03
   DEFINE p_imk04       LIKE imk_file.imk04
   DEFINE p_plant       LIKE azw_file.azw01
   DEFINE p_imk05       LIKE imk_file.imk05 
   DEFINE p_imk06       LIKE imk_file.imk06
   DEFINE l_sql         STRING 
   DEFINE l_imk09       LIKE imk_file.imk09,
          l_imk05       LIKE imk_file.imk05,
          l_imk06       LIKE imk_file.imk06 
                                            
   LET l_sql = " SELECT sum(imk09) FROM ",
               cl_get_target_table(p_plant,'imk_file'),
               " WHERE imk01 = '",p_imk01,"' AND imk02 = '", p_imk02,"'",
               "   AND imk03 = '",p_imk03,"' AND imk04 = '", p_imk04,"'",
               "   AND imk05 = '",p_imk05,"' AND imk06 = '", p_imk06,"'"  
             #-----------------mark  為空不再抓取上期，直接置0-----------------------------
             # "   AND imk05||(100+imk06)[2,3] in(SELECT max(imk05||(100+imk06)[2,3]) ",
             # "  FROM  ", cl_get_target_table(p_plant,'imk_file') ,  
             # " WHERE imk05||(100+imk06)[2,3]  < '", p_imk05,"'||(100+'", p_imk06,"')[2,3] ",
             # "   AND imk01 = '",p_imk01,"' AND imk02 = '", p_imk02,"'",
             # "   AND imk03 = '",p_imk03,"' AND imk04 = '", p_imk04,"')"     
             #----------------mark ----------------------------------------------------------
   CALL g505_predb(l_sql,p_plant) RETURNING l_sql
   PREPARE pre_sql1 FROM l_sql
   EXECUTE pre_sql1 INTO l_imk09
   IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF  
   RETURN l_imk09
#########################################
#  LET l_flag = TRUE
#  WHILE l_flag
#     LET l_sql = " SELECT imk09 FROM ", cl_get_target_table(p_plant,'imk_file'),
#                 " WHERE imk01 = ",p_imk01 ," AND imk02 = ", p_imk02,
#                 "   AND imk04 = ",p_imk04  ," AND imk05 = '",p_imk05, "' AND imk06 = '",p_imk06,"'" 
#     CALL g505_predb(l_sql,p_plant) RETURNING l_sql
#     PREPARE pre_sql1 FROM l_sql
#     DECLARE cur_sql1 CURSOR FOR pre_sql1
#     OPEN cur_sql1
#     FETCH cur_sql1 INTO l_imk09
#     IF NOT cl_null(l_imk09) AND l_imk09 != 0  THEN
#        LET l_flag = FALSE
#     ELSE
#        LET p_imk06 = p_imk06 - 1
#        IF p_imk06 = 0 THEN
#           LET p_imk06 = 12
#           LET  p_imk05 = p_imk05 - 1
#        END IF
#     END IF
#  END WHILE
#  RETURN l_imk09,p_imk05,p_imk06 
#################################
END FUNCTION

#营运中心关联商品策略，有则商品策略勾稽ima_file ，否则 直接抓取ima_file
FUNCTION g505_case(p_type,p_wc2,p_wc3,p_plant,p_rtz04)
   DEFINE p_type  LIKE type_file.chr1,
      #    p_wc2   LIKE type_file.chr1000, #TQC-B70082  mark
      #    p_wc3   LIKE type_file.chr1000, #TQC-B70082  mark
          p_wc2   STRING,   #TQC-B70082
          p_wc3   STRING,   #TQC-B70082
          p_plant LIKE azw_file.azw01,
          p_rtz04 LIKE rtz_file.rtz04 
   DEFINE l_sql   STRING 
   
   CASE p_type
          WHEN "2"
             #商品策略为NULL 原逻辑处理
             IF cl_null(p_rtz04) THEN  
                LET l_sql = "SELECT imkplant,'',ima131,'',ima01,ima02,imk02,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0,0,0,0,imk03,imk02,imk03,imk04 ",
                            " FROM ",cl_get_target_table(p_plant,'imk_file'),",",
                                     cl_get_target_table(p_plant,'ima_file'),
                            " WHERE ima01 = imk01 ",
                            " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                            " AND imkplant = '",p_plant,"'"
            ELSE
               LET l_sql = "SELECT imkplant,'',ima131,'',ima01,ima02,imk02,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0,0,0,0,imk03,imk02,imk03,imk04 ",
                            " FROM ",cl_get_target_table(p_plant,'imk_file'),",",
                                     cl_get_target_table(p_plant,'ima_file'),",",
                                     cl_get_target_table(p_plant,'rtz_file'),",",
                                     cl_get_target_table(p_plant,'rte_file'),  
                            " WHERE ima01 = imk01 AND ima01 = rte03 ",
                            " AND rtz04 = rte01  AND rtz01 = imkplant AND rtz04 = '",p_rtz04 ,"'", 
                            " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                            " AND imkplant = '",p_plant,"'"   
             END IF 
          WHEN "5"
             IF cl_null(p_rtz04) THEN
                LET l_sql = "SELECT imkplant,'',ima131,'',ima01,ima02,imk02,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0,0,0,0,imd16,imk02,imk03,imk04 ",
                            " FROM ",cl_get_target_table(p_plant,'ima_file'),",'",
                                     cl_get_target_table(p_plant,'imk_file'),",",
                                     cl_get_target_table(p_plant,'imd_file'),
                            " WHERE ima01 = imk01  AND imk02 = imd01",
                            " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                            " AND imkplant = '",p_plant,"'"
             ELSE
                LET l_sql = "SELECT imkplant,'',ima131,'',ima01,ima02,imk02,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0,0,0,0,imd16,imk02,imk03,imk04 ",
                            " FROM ",cl_get_target_table(p_plant,'ima_file'),",",
                                     cl_get_target_table(p_plant,'imk_file'),",",
                                     cl_get_target_table(p_plant,'imd_file'),",",
                                     cl_get_target_table(p_plant,'rtz_file'),",",
                                     cl_get_target_table(p_plant,'rte_file'),
                            " WHERE ima01 = imk01  AND imk02 = imd01",
                            " AND   ima01 = rte03  AND  rtz04 = rte01  AND rtz01 = imkplant AND rtz04 ='",p_rtz04 ,"'",
                            " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                            " AND imkplant = '",p_plant,"'"
             END IF 
          WHEN "1"
             IF cl_null(p_rtz04) THEN   
                LET l_sql = "SELECT imkplant,'',ima131,'',ima01,ima02,imk02,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0,0,0,0,'',imk02,imk03,imk04 ",
                            " FROM ",cl_get_target_table(p_plant,'ima_file'),",",
                                     cl_get_target_table(p_plant,'imk_file'),
                            " WHERE ima01 = imk01",
                            " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                            " AND imkplant = '",p_plant,"'"
             ELSE
                LET l_sql = "SELECT imkplant,'',ima131,'',ima01,ima02,imk02,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0,0,0,0,'',imk02,imk03,imk04 ",
                            " FROM ",cl_get_target_table(p_plant,'ima_file'),",",
                                     cl_get_target_table(p_plant,'imk_file'),",",
                                     cl_get_target_table(p_plant,'rtz_file'),",",
                                     cl_get_target_table(p_plant,'rte_file'),
                            " WHERE ima01 = imk01",
                            " AND ima01 = rte03  AND  rtz04 = rte01  AND rtz01 = imkplant AND rtz04 = '",p_rtz04 ,"'",
                            " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                            " AND imkplant = '",p_plant,"'"  
             END IF 
          WHEN "3"
             IF cl_null(p_rtz04) THEN
                LET l_sql = "SELECT imkplant,'',ima131,'',ima01,ima02,imk02,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0,0,0,0,imk03,imk02,imk03,imk04 ",
                            " FROM ",cl_get_target_table(p_plant,'ima_file'),",",
                                     cl_get_target_table(p_plant,'imk_file'),
                            " WHERE ima01 = imk01",
                            " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                            " AND imkplant = '",p_plant,"'"
             ELSE
                LET l_sql = "SELECT imkplant,'',ima131,'',ima01,ima02,imk02,0,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0 ,0,0,0,0,imk03,imk02,imk03,imk04 ",
                            " FROM ",cl_get_target_table(p_plant,'ima_file'),",",
                                     cl_get_target_table(p_plant,'imk_file'),",",
                                     cl_get_target_table(p_plant,'rtz_file'),",",
                                     cl_get_target_table(p_plant,'rte_file'),
                            " WHERE ima01 = imk01",
                            " AND ima01 = rte03  AND  rtz04 = rte01  AND rtz01 = imkplant AND rtz04 = '",p_rtz04 ,"'",
                            " AND ",p_wc2 CLIPPED," AND ",p_wc3 CLIPPED,
                            " AND imkplant = '",p_plant,"'"
             END IF 
          WHEN "4"
            #LET l_sql = #######################################################暫不處理
       END CASE
       RETURN l_sql

END FUNCTION
#FUN-A70046 --------------end-------------------


###GENGRE###START
FUNCTION artg505_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("artg505")
        IF handler IS NOT NULL THEN
            START REPORT artg505_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY imkplant "   #FUN-BA0063 add
          
            DECLARE artg505_datacur1 CURSOR FROM l_sql
            FOREACH artg505_datacur1 INTO sr1.*
                OUTPUT TO REPORT artg505_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg505_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg505_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_cost01_1_subtot LIKE type_file.num15_3
    DEFINE l_cost02_2_subtot LIKE type_file.num15_3
    DEFINE l_cost03_3_subtot LIKE type_file.num15_3
    DEFINE l_cost04_4_subtot LIKE type_file.num15_3
    DEFINE l_cost05_5_subtot LIKE type_file.num15_3
    DEFINE l_cost06_6_subtot LIKE type_file.num15_3
    DEFINE l_cost07_7_subtot LIKE type_file.num15_3
    DEFINE l_cost08_8_subtot LIKE type_file.num15_3

    
    ORDER EXTERNAL BY sr1.imkplant
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime    #FUN-BA0063 add g_user_name,g_ptime
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.imkplant

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.imkplant
            LET l_cost08_8_subtot = GROUP SUM(sr1.cost08)
            PRINTX l_cost08_8_subtot
            LET l_cost07_7_subtot = GROUP SUM(sr1.cost07)
            PRINTX l_cost07_7_subtot
            LET l_cost06_6_subtot = GROUP SUM(sr1.cost06)
            PRINTX l_cost06_6_subtot
            LET l_cost05_5_subtot = GROUP SUM(sr1.cost05)
            PRINTX l_cost05_5_subtot
            LET l_cost04_4_subtot = GROUP SUM(sr1.cost04)
            PRINTX l_cost04_4_subtot
            LET l_cost03_3_subtot = GROUP SUM(sr1.cost03)
            PRINTX l_cost03_3_subtot
            LET l_cost02_2_subtot = GROUP SUM(sr1.cost02)
            PRINTX l_cost02_2_subtot
            LET l_cost01_1_subtot = GROUP SUM(sr1.cost01)
            PRINTX l_cost01_1_subtot

        
        ON LAST ROW

END REPORT
###GENGRE###END

#FUN-BA0063-------add-----str----
FUNCTION artg505_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg505")
        IF handler IS NOT NULL THEN
            START REPORT artg505_1_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY imkplant,ima131"   #FUN-BA0063 add

            DECLARE artg505_datacur2 CURSOR FROM l_sql
            FOREACH artg505_datacur2 INTO sr1.*
                OUTPUT TO REPORT artg505_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg505_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg505_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_num01_subtot LIKE type_file.num15_3
    DEFINE l_num02_subtot LIKE type_file.num15_3
    DEFINE l_num03_subtot LIKE type_file.num15_3
    DEFINE l_num04_subtot LIKE type_file.num15_3
    DEFINE l_num05_subtot LIKE type_file.num15_3
    DEFINE l_num06_subtot LIKE type_file.num15_3
    DEFINE l_num07_subtot LIKE type_file.num15_3
    DEFINE l_cost01_1_subtot LIKE type_file.num15_3
    DEFINE l_cost02_2_subtot LIKE type_file.num15_3
    DEFINE l_cost03_3_subtot LIKE type_file.num15_3
    DEFINE l_cost04_4_subtot LIKE type_file.num15_3
    DEFINE l_cost05_5_subtot LIKE type_file.num15_3
    DEFINE l_cost06_6_subtot LIKE type_file.num15_3
    DEFINE l_cost07_7_subtot LIKE type_file.num15_3
    DEFINE l_cost08_8_subtot LIKE type_file.num15_3


    ORDER EXTERNAL BY sr1.imkplant,sr1.ima131

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime    #FUN-BA0063 add g_user_name,g_ptime
            PRINTX tm.*

        BEFORE GROUP OF sr1.imkplant
        BEFORE GROUP OF sr1.ima131  


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.imkplant
        AFTER GROUP OF sr1.ima131  
            LET l_cost08_8_subtot = GROUP SUM(sr1.cost08)
            PRINTX l_cost08_8_subtot
            LET l_cost07_7_subtot = GROUP SUM(sr1.cost07)
            PRINTX l_cost07_7_subtot
            LET l_cost06_6_subtot = GROUP SUM(sr1.cost06)
            PRINTX l_cost06_6_subtot
            LET l_cost05_5_subtot = GROUP SUM(sr1.cost05)
            PRINTX l_cost05_5_subtot
            LET l_cost04_4_subtot = GROUP SUM(sr1.cost04)
            PRINTX l_cost04_4_subtot
            LET l_cost03_3_subtot = GROUP SUM(sr1.cost03)
            PRINTX l_cost03_3_subtot
            LET l_cost02_2_subtot = GROUP SUM(sr1.cost02)
            PRINTX l_cost02_2_subtot
            LET l_cost01_1_subtot = GROUP SUM(sr1.cost01)
            PRINTX l_cost01_1_subtot
            LET l_num01_subtot = GROUP SUM(sr1.num01)
            PRINTX l_num01_subtot
            LET l_num02_subtot = GROUP SUM(sr1.num02)
            PRINTX l_num02_subtot
            LET l_num03_subtot = GROUP SUM(sr1.num03)
            PRINTX l_num03_subtot
            LET l_num04_subtot = GROUP SUM(sr1.num04)
            PRINTX l_num04_subtot
            LET l_num05_subtot = GROUP SUM(sr1.num05)
            PRINTX l_num05_subtot
            LET l_num06_subtot = GROUP SUM(sr1.num06)
            PRINTX l_num06_subtot
            LET l_num07_subtot = GROUP SUM(sr1.num07)
            PRINTX l_num07_subtot


        ON LAST ROW

END REPORT


FUNCTION artg505_2_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("artg505")
        IF handler IS NOT NULL THEN
            START REPORT artg505_2_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY imkplant,ima01"      #FUN-BA0063 add

            DECLARE artg505_datacur3 CURSOR FROM l_sql
            FOREACH artg505_datacur3 INTO sr1.*
                OUTPUT TO REPORT artg505_2_rep(sr1.*)
            END FOREACH
            FINISH REPORT artg505_2_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT artg505_2_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_num01_subtot LIKE type_file.num15_3
    DEFINE l_num02_subtot LIKE type_file.num15_3
    DEFINE l_num03_subtot LIKE type_file.num15_3
    DEFINE l_num04_subtot LIKE type_file.num15_3
    DEFINE l_num05_subtot LIKE type_file.num15_3
    DEFINE l_num06_subtot LIKE type_file.num15_3
    DEFINE l_num07_subtot LIKE type_file.num15_3
    DEFINE l_cost01_1_subtot LIKE type_file.num15_3
    DEFINE l_cost02_2_subtot LIKE type_file.num15_3
    DEFINE l_cost03_3_subtot LIKE type_file.num15_3
    DEFINE l_cost04_4_subtot LIKE type_file.num15_3
    DEFINE l_cost05_5_subtot LIKE type_file.num15_3
    DEFINE l_cost06_6_subtot LIKE type_file.num15_3
    DEFINE l_cost07_7_subtot LIKE type_file.num15_3
    DEFINE l_cost08_8_subtot LIKE type_file.num15_3


    ORDER EXTERNAL BY sr1.imkplant,sr1.ima01 

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime    #FUN-BA0063 add g_user_name,g_ptime
            PRINTX tm.*

        BEFORE GROUP OF sr1.imkplant
        BEFORE GROUP OF sr1.ima01   


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.imkplant
        AFTER GROUP OF sr1.ima01   
            LET l_cost08_8_subtot = GROUP SUM(sr1.cost08)
            PRINTX l_cost08_8_subtot
            LET l_cost07_7_subtot = GROUP SUM(sr1.cost07)
            PRINTX l_cost07_7_subtot
            LET l_cost06_6_subtot = GROUP SUM(sr1.cost06)
            PRINTX l_cost06_6_subtot
            LET l_cost05_5_subtot = GROUP SUM(sr1.cost05)
            PRINTX l_cost05_5_subtot
            LET l_cost04_4_subtot = GROUP SUM(sr1.cost04)
            PRINTX l_cost04_4_subtot
            LET l_cost03_3_subtot = GROUP SUM(sr1.cost03)
            PRINTX l_cost03_3_subtot
            LET l_cost02_2_subtot = GROUP SUM(sr1.cost02)
            PRINTX l_cost02_2_subtot
            LET l_cost01_1_subtot = GROUP SUM(sr1.cost01)
            PRINTX l_cost01_1_subtot
            LET l_num01_subtot = GROUP SUM(sr1.num01)
            PRINTX l_num01_subtot
            LET l_num02_subtot = GROUP SUM(sr1.num02)
            PRINTX l_num02_subtot
            LET l_num03_subtot = GROUP SUM(sr1.num03)
            PRINTX l_num03_subtot
            LET l_num04_subtot = GROUP SUM(sr1.num04)
            PRINTX l_num04_subtot
            LET l_num05_subtot = GROUP SUM(sr1.num05)
            PRINTX l_num05_subtot
            LET l_num06_subtot = GROUP SUM(sr1.num06)
            PRINTX l_num06_subtot
            LET l_num07_subtot = GROUP SUM(sr1.num07)
            PRINTX l_num07_subtot


        ON LAST ROW

END REPORT
#FUN-BA0063-------add-----end----
