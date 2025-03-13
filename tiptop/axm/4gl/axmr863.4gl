# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axmr863.4gl
# Descriptions...: 同期績效分析表
# Date & Author..: #FUN-A70025 10/07/20 By wangxin
# Modify.........: #FUN-AA0024 10/10/15 By wangxin 報表改善
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc      STRING,    
              wc1     STRING,    #记录营运中心
              type01  LIKE type_file.chr1,
              type02  LIKE type_file.num5,
              yy01    LIKE type_file.num5,
              yy02    LIKE type_file.num5,
              mm01    LIKE type_file.num5,
              mm02    LIKE type_file.num5,
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
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql =  "ogbplant.ogb_file.ogbplant,",
                "azp02.azp_file.azp02,",
                "ogb14t.ogb_file.ogb14t,",
                "ccc23.ccc_file.ccc23,",
                "ogb12.ogb_file.ogb12,",
                "ogb14t_2.ogb_file.ogb14t,",
                "ogb14t_3.ogb_file.ogb14t,"
                          
 
   LET l_table = cl_prt_temptable('axmr863',g_sql) CLIPPED
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
      THEN CALL axmr863_tm(0,0)        # Input print condition
      ELSE CALL axmr863()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION axmr863_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000 
   DEFINE tok            base.StringTokenizer        
   DEFINE l_zxy03        LIKE zxy_file.zxy03 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW axmr863_w AT p_row,p_col WITH FORM "axm/42f/axmr863" 
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
   LET tm.type01 = '1'
   LET tm.type02 = '1'
   
   IF tm.type02 = '1' THEN 
       CALL cl_set_comp_entry("mm01,mm02",false)
   ELSE 
   	   CALL cl_set_comp_entry("mm01,mm02",true)    
   END IF	   

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
               DECLARE r450_zxy_cs1 CURSOR FOR SELECT zxy03 FROM zxy_file WHERE zxy01 = g_user
               FOREACH r450_zxy_cs1 INTO l_zxy03 
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
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(azp01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azp01
                  NEXT FIELD azp01         
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
         LET INT_FLAG = 0
         CLOSE WINDOW r863_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
     IF cl_null(tm.wc1) OR tm.wc1 = ' 1=1' THEN
         LET tm.wc1 = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
     END IF     
 
     CONSTRUCT BY NAME tm.wc ON ima131,ima1005
                                 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima131_1"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131
                  NEXT FIELD ima131
               WHEN INFIELD(ima1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima1005"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima1005
                  NEXT FIELD ima1005                     
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr863_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
     
      #IF tm.wc = ' 1=1' THEN
      #   CALL cl_err('','9046',0) CONTINUE WHILE
      #END IF
      DISPLAY BY NAME tm.more 
      
      INPUT BY NAME tm.type01,tm.type02,tm.yy01,tm.mm01,tm.yy02,
                    tm.mm02,tm.more WITHOUT DEFAULTS

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
         AFTER FIELD type02
            IF tm.type02 = '1' THEN
               CALL cl_set_comp_entry("mm01,mm02",false)
               LET tm.mm01 = null
               LET tm.mm02 = null
               DISPLAY BY NAME tm.mm01,tm.mm02
            ELSE  
   	           CALL cl_set_comp_entry("mm01,mm02",true)    
            END IF
            
         AFTER FIELD yy01
            IF cl_null(tm.yy01) THEN NEXT FIELD yy01 END IF
         
         BEFORE FIELD yy02
            IF cl_null(tm.yy02) THEN
               IF tm.type02 = '1' THEN
                  LET tm.yy02 = tm.yy01- 1
                  DISPLAY BY NAME tm.yy01
               END IF
            END IF
            
         AFTER FIELD mm01
            IF cl_null(tm.mm01) THEN NEXT FIELD mm01 END IF 
            IF tm.mm01 <=0 OR tm.mm01 >12 THEN
               NEXT FIELD mm01
            END IF                                                                                                             
            IF tm.type02 = '2' THEN
               IF cl_null(tm.yy02) THEN
                  LET tm.yy02 = tm.yy01
                  DISPLAY BY NAME tm.yy02
               END IF   
               IF cl_null(tm.mm02) THEN
                  LET tm.mm02 = tm.mm01 - 1
                  DISPLAY BY NAME tm.mm02
               END IF
            END IF
            IF tm.mm02 <=0 OR tm.mm02 >12 THEN                                                                                             
               LET tm.mm02 =12
               LET tm.yy02 = tm.yy01-1                                                                                                         
               DISPLAY BY NAME tm.yy02,tm.mm02                                                                                                             
            END IF              
    
         AFTER FIELD mm02                                                                                                            
         IF tm.mm02 <=0 OR tm.mm02 >12 THEN                                                                                             
            LET tm.mm02 =null                                                                                                         
            NEXT FIELD mm02                                                                                                           
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr863_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='axmr863'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axmr863','9031',1)
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
            CALL cl_cmdat('axmr863',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axmr863_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmr863()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmr863_w
END FUNCTION

FUNCTION axmr863_1(l_plant,l_ima01,l_ccc08,l_oga02)          #抓取金額和成本
   DEFINE l_plant    LIKE azp_file.azp01,
          l_ima01    LIKE ima_file.ima01,
          l_ccc08    LIKE ccc_file.ccc08,
          l_yy       LIKE type_file.num5,
          l_mm       LIKE type_file.num5,
          l_sql      STRING,
          l_ccc23    LIKE ccc_file.ccc23,
          l_oga02    LIKE oga_file.oga02
   IF tm.type02 = '2' THEN       
      IF (YEAR(l_oga02) = tm.yy01 AND MONTH(l_oga02) = tm.mm01) THEN    #判斷ima01是否在基準時間段中     
         LET l_sql = " SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                     "  WHERE ccc01 = '",l_ima01,"' ",
                     "    AND ccc02 = '",tm.yy01,"'",
                     "    AND ccc03 = '",tm.mm01,"'",
                     "    AND ccc07 = '",tm.type01,"'",
                     "    AND ccc08 = '",l_ccc08,"'" 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ccc23_pre1 FROM l_sql
         EXECUTE sel_ccc23_pre1 INTO l_ccc23           #抓取單價成本   
         IF cl_null(l_ccc23) THEN
            LET l_ccc23 = 0
         END IF
      END IF                     
   ELSE
      IF YEAR(l_oga02) = tm.yy01  THEN    #判斷ima01是否在基準時間段中     
         LET l_sql = " SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                     "  WHERE ccc01 = '",l_ima01,"' ",
                     "    AND ccc02 = '",tm.yy01,"'",
                     "    AND ccc07 = '",tm.type01,"'",
                     "    AND ccc08 = '",l_ccc08,"'"  
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ccc23_pre2 FROM l_sql
         EXECUTE sel_ccc23_pre2 INTO l_ccc23           #抓取單價成本
         IF cl_null(l_ccc23) THEN
            LET l_ccc23 = 0
         END IF
      END IF  
    END IF  
    RETURN l_ccc23  
END FUNCTION 

FUNCTION axmr863()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,          
          sr        RECORD 
                    ogbplant     LIKE ogb_file.ogbplant,
                    ogb01        LIKE ogb_file.ogb01,
                    oga02        LIKE oga_file.oga02,
                    ogb03        LIKE ogb_file.ogb03,
                    ogb09        LIKE ogb_file.ogb09,
                    ogb41        LIKE ogb_file.ogb41,
                    ogb092       LIKE ogb_file.ogb092,
                    ima01        LIKE ima_file.ima01,
                    ogb14t       LIKE ogb_file.ogb14t,    #銷售金額
                    ccc23        LIKE ccc_File.ccc23,     #單價成本
                    ogb12        LIKE ogb_file.ogb12,     #銷售數量
                    ogb14t_2     LIKE ogb_file.ogb14t,    #基準時段銷售金額
                    ogb14t_3     LIKE ogb_file.ogb14t     #比較時段銷售金額
                    END RECORD,   
          #FUN-AA0024 add --------------------------------begin---------------------------------- 
          sr1       RECORD 
                    ohbplant     LIKE ohb_file.ohbplant,
                    ohb01        LIKE ohb_file.ohb01,
                    oha02        LIKE oha_file.oha02,
                    ohb03        LIKE ohb_file.ohb03,
                    ohb09        LIKE ohb_file.ohb09,
                    #ohb41        LIKE ohb_file.ohb41,
                    ohb092       LIKE ohb_file.ohb092,
                    ima01        LIKE ima_file.ima01,
                    ohb14t       LIKE ohb_file.ohb14t,    
                    ccc23        LIKE ccc_File.ccc23,     
                    ohb12        LIKE ohb_file.ohb12,     
                    ohb14t_2     LIKE ohb_file.ohb14t,    
                    ohb14t_3     LIKE ohb_file.ohb14t                                                 
                    END RECORD,
          #FUN-AA0024 add --------------------------------end------------------------------------          
          l_imd16   LIKE imd_file.imd16,                   
          l_yy      LIKE type_file.num5,
          l_mm      LIKE type_file.num5,
          l_plant   LIKE azp_file.azp01,
          l_azp02   LIKE azp_file.azp02,
          l_azi10   LIKE azi_file.azi10,
          l_oga23   LIKE oga_file.oga23,
          l_oga24   LIKE oga_file.oga24,
          l_oha23   LIKE oha_file.oha23,          #FUN-AA0024 add
          l_oha24   LIKE oha_file.oha24,          #FUN-AA0024 add
          l_rtz04   LIKE rtz_file.rtz04,
          l_yy_max  LIKE type_file.num5,
          l_mm_max  LIKE type_file.num5,
          l_yy_min  LIKE type_file.num5,
          l_mm_min  LIKE type_file.num5

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?) "                                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1)                                                                                        
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
       EXIT PROGRAM                                                                                                                 
    END IF
    
    IF tm.yy01>tm.yy02 THEN 
       LET l_yy_max = tm.yy01 
       LET l_yy_min = tm.yy02
    ELSE
       LET l_yy_max = tm.yy02
       LET l_yy_min = tm.yy01  
    END IF
    
    IF tm.mm01>tm.mm02 THEN 
       LET l_mm_max = tm.mm01 
       LET l_mm_min = tm.mm02
    ELSE
       LET l_mm_max = tm.mm02
       LET l_mm_min = tm.mm01  
    END IF 
    
   DROP TABLE axmr863_tmp
   CREATE TEMP TABLE axmr863_tmp(
          ogbplant   LIKE ogb_file.ogbplant,
          azp02      LIKE azp_file.azp02,
          ogb14t     LIKE ogb_file.ogb14t,
          ccc23      LIKE ccc_file.ccc23,
          ogb12      LIKE ogb_file.ogb12,
          ogb14t_2   LIKE ogb_file.ogb14t,
          ogb14t_3   LIKE ogb_file.ogb14t)     
   DELETE FROM axmr863_tmp
   #FUN-AA0024 add --------------------------------begin----------------------------------
    DROP TABLE axmr863_tmp1
    CREATE TEMP TABLE axmr863_tmp1(
          ohbplant   LIKE ohb_file.ohbplant,
          azp02      LIKE azp_file.azp02,
          ohb14t     LIKE ohb_file.ohb14t,
          ccc23      LIKE ccc_file.ccc23,
          ohb12      LIKE ohb_file.ohb12,
          ohb14t_2   LIKE ohb_file.ohb14t,
          ohb14t_3   LIKE ohb_file.ohb14t)     
    DELETE FROM axmr863_tmp1
    #FUN-AA0024 add --------------------------------end------------------------------------
    
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
       
    LET l_sql = "SELECT rtz04 ",
                "  FROM ",cl_get_target_table(l_plant,'rtz_file'),
                " WHERE  rtz01 = '",l_plant,"' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql
        CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
        PREPARE pre12 FROM l_sql
        EXECUTE pre12 INTO l_rtz04 
        
    IF cl_null(l_rtz04) THEN              
       LET l_sql = " SELECT ogbplant,ogb01,oga02,ogb03,ogb09,ogb41,ogb092,ima01,0,0,ogb12,0,0",
                   "   FROM ",cl_get_target_table(l_plant,'oga_file'),
                   "  ,",cl_get_target_table(l_plant,'ogb_file'),	
                   "  LEFT JOIN ",cl_get_target_table(l_plant,'ima_file'), 
                   "     ON ima01=ogb04 ",				
                   "  WHERE ogbplant='",l_plant,"'",
                   "    AND oga01 = ogb01", 
                   "    AND ",tm.wc CLIPPED  
      IF tm.type02 = '1' THEN LET l_sql = l_sql," AND YEAR(oga02) BETWEEN'",l_yy_min,"'",
                                                " AND'",l_yy_max,"'" 
      END IF
      IF tm.type02 = '2' THEN LET l_sql = l_sql," AND (YEAR(oga02) BETWEEN'",l_yy_min,"'",
                                                " AND'",l_yy_max,"'",")",
                                                " AND (MONTH(oga02) BETWEEN '",l_mm_min,"'",
                                                " AND'",l_mm_max,"'",")"
      END IF           
    ELSE
       LET l_sql = " SELECT ogbplant,ogb01,oga02,ogb03,ogb09,ogb41,ogb092,ima01,0,0,ogb12,0,0",
                   "   FROM ",cl_get_target_table(l_plant,'rte_file'),
                   "       ,",cl_get_target_table(l_plant,'oga_file'),
                   "       ,",cl_get_target_table(l_plant,'ogb_file'),
                   "  LEFT JOIN ",cl_get_target_table(l_plant,'ima_file'), 
                   "     ON ima01=ogb04 ",
                   "  WHERE rte01 = '",l_rtz04,"' ",
                   "    AND rte03 = ima01 ",
                   "    AND oga01 = ogb01",
                   "    AND ogbplant='",l_plant,"'",  
                   "    AND ",tm.wc CLIPPED
       IF tm.type02 = '1' THEN LET l_sql = l_sql," AND YEAR(oga02) BETWEEN'",l_yy_min,"'",
                                                 " AND'",l_yy_max,"'" 
       END IF
       IF tm.type02 = '2' THEN LET l_sql = l_sql," AND (YEAR(oga02) BETWEEN'",l_yy_min,"'",
                                                " AND'",l_yy_max,"'",")",
                                                " AND (MONTH(oga02) BETWEEN '",l_mm_min,"'",
                                                " AND'",l_mm_max,"'",")"   
       END IF                          
    END IF   
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql               
    PREPARE axmr863_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF

             
    DECLARE axmr863_curs1 CURSOR FOR axmr863_prepare1
    FOREACH axmr863_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
       
       
         
    LET l_sql=" SELECT oga23,oga24 FROM ",cl_get_target_table(l_plant,'oga_file'),
                   "  WHERE oga01 = '",sr.ogb01,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            PREPARE sel_oga24_pre FROM l_sql
            EXECUTE sel_oga24_pre INTO l_oga23,l_oga24
            IF cl_null(l_oga24) THEN LET l_oga24=1 END IF
    LET l_sql = " SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                     "  WHERE azi01 = '",l_oga23,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            PREPARE sel_azi10_pre FROM l_sql
            EXECUTE sel_azi10_pre INTO l_azi10
            
    IF tm.type02 = '1' THEN 
         LET l_sql = " SELECT SUM(ogb14t) FROM ",cl_get_target_table(l_plant,'ogb_file'),",",
                                                 cl_get_target_table(l_plant,'oga_file'),
                     "  WHERE ogaplant = '",l_plant,"'", 
                     "    AND ogb01 = '",sr.ogb01,"'", 
                     "    AND ogb03 = '",sr.ogb03,"'",
                     "    AND oga01 = ogb01 ", 
                     "    AND ogaconf = 'Y' ", 
                     "    AND ogaplant = ogbplant ",
                     "    AND YEAR(oga02) = '",tm.yy01,"'"
    ELSE 
         LET l_sql = " SELECT SUM(ogb14t) FROM ",cl_get_target_table(l_plant,'ogb_file'),",",
                                                 cl_get_target_table(l_plant,'oga_file'),
                     "  WHERE ogaplant = '",l_plant,"'", 
                     "    AND ogb01 = '",sr.ogb01,"'", 
                     "    AND ogb03 = '",sr.ogb03,"'",
                     "    AND oga01 = ogb01 ", 
                     "    AND ogaconf = 'Y' ", 
                     "    AND ogaplant = ogbplant ",
                     "    AND YEAR(oga02) = '",tm.yy01,"'",
                     "    AND MONTH(oga02) = '",tm.mm01,"'" 
    END IF            
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ogb14t_pre3 FROM l_sql
         EXECUTE sel_ogb14t_pre3 INTO sr.ogb14t_2            #抓取基準時間銷售金額 
         
    IF tm.type02 = '1' THEN 
         LET l_sql = " SELECT SUM(ogb14t) FROM ",cl_get_target_table(l_plant,'ogb_file'),",",
                                                 cl_get_target_table(l_plant,'oga_file'),
                     "  WHERE ogaplant = '",l_plant,"'", 
                     "    AND ogb01 = '",sr.ogb01,"'", 
                     "    AND ogb03 = '",sr.ogb03,"'",
                     "    AND oga01 = ogb01 ", 
                     "    AND ogaconf = 'Y' ", 
                     "    AND ogaplant = ogbplant ",
                     "    AND YEAR(oga02) = '",tm.yy02,"'"
    ELSE 
         LET l_sql = " SELECT SUM(ogb14t) FROM ",cl_get_target_table(l_plant,'ogb_file'),",",
                                                 cl_get_target_table(l_plant,'oga_file'),
                     "  WHERE ogaplant = '",l_plant,"'", 
                     "    AND ogb01 = '",sr.ogb01,"'", 
                     "    AND ogb03 = '",sr.ogb03,"'",
                     "    AND oga01 = ogb01 ", 
                     "    AND ogaconf = 'Y' ", 
                     "    AND ogaplant = ogbplant ",
                     "    AND YEAR(oga02) = '",tm.yy02,"'",
                     "    AND MONTH(oga02) = '",tm.mm02,"'" 
    END IF  
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ogb14t_pre4 FROM l_sql
         EXECUTE sel_ogb14t_pre4 INTO sr.ogb14t_3            #抓取比較時間銷售金額
            
         CASE l_azi10 
                WHEN '1' 
                   LET sr.ogb14t_2 = sr.ogb14t_2*l_oga24
                   LET sr.ogb14t_3 = sr.ogb14t_3*l_oga24 
                WHEN '2'
                   LET sr.ogb14t_2 = sr.ogb14t_2/l_oga24
                   LET sr.ogb14t_3 = sr.ogb14t_3/l_oga24  
         END CASE
     
    CASE tm.type01 
       WHEN '1'           
         CALL axmr863_1(l_plant,sr.ima01,'',sr.oga02) 
            RETURNING sr.ccc23
            LET sr.ccc23 = sr.ccc23*sr.ogb12     
       WHEN '2' 
             
         LET l_sql = " SELECT SUM(cxc09) FROM ",cl_get_target_table(l_plant,'ima_file'),",",
                                                cl_get_target_table(l_plant,'cxc_file'),
                     "  WHERE cxc01 = '",sr.ima01,"'",
                     "    AND cxc04 = '",sr.ogb01,"'",
                     "    AND cxc05 = '",sr.ogb03,"'",
                     "    AND cxcplant = '",l_plant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_cxc09_pre1 FROM l_sql
         EXECUTE sel_cxc09_pre1 INTO sr.ccc23             #抓取單價成本
         IF cl_null(sr.ccc23) THEN
               LET sr.ccc23 = 0 
         END IF
         LET sr.ccc23 = sr.ccc23*sr.ogb12
       WHEN '3'     
          CALL axmr863_1(l_plant,sr.ima01,sr.ogb092,sr.oga02) 
             RETURNING sr.ccc23   
             LET sr.ccc23 = sr.ccc23*sr.ogb12
       WHEN '4'     
          CALL axmr863_1(l_plant,sr.ima01,sr.ogb41,sr.oga02) 
             RETURNING sr.ccc23 
             LET sr.ccc23 = sr.ccc23*sr.ogb12
       WHEN '5'     
          LET l_sql = " SELECT imd16 FROM ",cl_get_target_table(l_plant,'imd_file'),
                      "  WHERE imd01 = '",sr.ogb09,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
             PREPARE sel_ima16_pre FROM l_sql
             EXECUTE sel_ima16_pre INTO l_imd16
          LET l_sql = " SELECT SUM(ccc23) FROM ",cl_get_target_table(l_plant,'ccc_file'),",",
                                                 cl_get_target_table(l_plant,'imd_file'), 
                      "  WHERE ccc01 = '",sr.ima01,"'",
                      "    AND ccc02 = '",tm.yy01,"'", 
                      "    AND ccc03 = '",tm.mm01,"'", 
                      "    AND ccc07 = '",tm.type01,"'",
                      "    AND ccc08 = '",l_imd16,"'",
                      "    AND imd01 = '",sr.ogb09,"'" 
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
          PREPARE sel_ccc23_pre4 FROM l_sql
          EXECUTE sel_ccc23_pre4 INTO sr.ccc23              #抓取單價成本
          LET sr.ccc23 = sr.ccc23*sr.ogb12
       END CASE
       
   INSERT INTO axmr863_tmp 
         VALUES(sr.ogbplant,l_azp02,sr.ogb14t_2,sr.ccc23,sr.ogb12,sr.ogb14t_2,sr.ogb14t_3)
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      END FOREACH
      
   #FUN-AA0024 add --------------------------------begin----------------------------------

IF cl_null(l_rtz04) THEN              
       LET l_sql = " SELECT ohbplant,ohb01,oha02,ohb03,ohb09,ohb092,ima01,0,0,ohb12,0,0",
                   "   FROM ",cl_get_target_table(l_plant,'oha_file'),
                   "  ,",cl_get_target_table(l_plant,'ohb_file'),	
                   "  LEFT JOIN ",cl_get_target_table(l_plant,'ima_file'), 
                   "     ON ima01=ohb04 ",				
                   "  WHERE ohbplant='",l_plant,"'",
                   "    AND oha01 = ohb01", 
                   "    AND ",tm.wc CLIPPED  
      IF tm.type02 = '1' THEN LET l_sql = l_sql," AND YEAR(oha02) BETWEEN'",l_yy_min,"'",
                                                " AND'",l_yy_max,"'" 
      END IF
      IF tm.type02 = '2' THEN LET l_sql = l_sql," AND (YEAR(oha02) BETWEEN'",l_yy_min,"'",
                                                " AND'",l_yy_max,"'",")",
                                                " AND (MONTH(oha02) BETWEEN '",l_mm_min,"'",
                                                " AND'",l_mm_max,"'",")"
      END IF           
    ELSE
       LET l_sql = " SELECT ohbplant,ohb01,oha02,ohb03,ohb09,ohb092,ima01,0,0,ohb12,0,0",
                   "   FROM ",cl_get_target_table(l_plant,'rte_file'),
                   "       ,",cl_get_target_table(l_plant,'oha_file'),
                   "       ,",cl_get_target_table(l_plant,'ohb_file'),
                   "  LEFT JOIN ",cl_get_target_table(l_plant,'ima_file'), 
                   "     ON ima01=ohb04 ",
                   "  WHERE rte01 = '",l_rtz04,"' ",
                   "    AND rte03 = ima01 ",
                   "    AND oha01 = ohb01",
                   "    AND ohbplant='",l_plant,"'",  
                   "    AND ",tm.wc CLIPPED
       IF tm.type02 = '1' THEN LET l_sql = l_sql," AND YEAR(oha02) BETWEEN'",l_yy_min,"'",
                                                 " AND'",l_yy_max,"'" 
       END IF
       IF tm.type02 = '2' THEN LET l_sql = l_sql," AND (YEAR(oha02) BETWEEN'",l_yy_min,"'",
                                                " AND'",l_yy_max,"'",")",
                                                " AND (MONTH(oha02) BETWEEN '",l_mm_min,"'",
                                                " AND'",l_mm_max,"'",")"   
       END IF                          
    END IF   
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
    CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql               
    PREPARE axmr863_prepare11 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM
    END IF

             
    DECLARE axmr863_curs11 CURSOR FOR axmr863_prepare11
    FOREACH axmr863_curs11 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
       
       
         
    LET l_sql=" SELECT oha23,oha24 FROM ",cl_get_target_table(l_plant,'oha_file'),
                   "  WHERE oha01 = '",sr1.ohb01,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            PREPARE sel_oha24_pre FROM l_sql
            EXECUTE sel_oha24_pre INTO l_oha23,l_oha24
            IF cl_null(l_oha24) THEN LET l_oha24=1 END IF
    LET l_sql = " SELECT azi10 FROM ",cl_get_target_table(l_plant,'azi_file'),
                     "  WHERE azi01 = '",l_oha23,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
            PREPARE sel_azi10_pre1 FROM l_sql
            EXECUTE sel_azi10_pre1 INTO l_azi10
            
    IF tm.type02 = '1' THEN 
         LET l_sql = " SELECT SUM(ohb14t) FROM ",cl_get_target_table(l_plant,'ohb_file'),",",
                                                 cl_get_target_table(l_plant,'oha_file'),
                     "  WHERE ohaplant = '",l_plant,"'", 
                     "    AND ohb01 = '",sr1.ohb01,"'", 
                     "    AND ohb03 = '",sr1.ohb03,"'",
                     "    AND oha01 = ohb01 ", 
                     "    AND ohaconf = 'Y' ", 
                     "    AND ohaplant = ohbplant ",
                     "    AND YEAR(oha02) = '",tm.yy01,"'"
    ELSE 
         LET l_sql = " SELECT SUM(ohb14t) FROM ",cl_get_target_table(l_plant,'ohb_file'),",",
                                                 cl_get_target_table(l_plant,'oha_file'),
                     "  WHERE ohaplant = '",l_plant,"'", 
                     "    AND ohb01 = '",sr1.ohb01,"'", 
                     "    AND ohb03 = '",sr1.ohb03,"'",
                     "    AND oha01 = ohb01 ", 
                     "    AND ohaconf = 'Y' ", 
                     "    AND ohaplant = ohbplant ",
                     "    AND YEAR(oha02) = '",tm.yy01,"'",
                     "    AND MONTH(oha02) = '",tm.mm01,"'" 
    END IF            
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ohb14t_pre3 FROM l_sql
         EXECUTE sel_ohb14t_pre3 INTO sr1.ohb14t_2            #抓取基準時間銷退金額 
         
    IF tm.type02 = '1' THEN 
         LET l_sql = " SELECT SUM(ohb14t) FROM ",cl_get_target_table(l_plant,'ohb_file'),",",
                                                 cl_get_target_table(l_plant,'oha_file'),
                     "  WHERE ohaplant = '",l_plant,"'", 
                     "    AND ohb01 = '",sr1.ohb01,"'", 
                     "    AND ohb03 = '",sr1.ohb03,"'",
                     "    AND oha01 = ohb01 ", 
                     "    AND ohaconf = 'Y' ", 
                     "    AND ohaplant = ohbplant ",
                     "    AND YEAR(oha02) = '",tm.yy02,"'"
    ELSE 
         LET l_sql = " SELECT SUM(ohb14t) FROM ",cl_get_target_table(l_plant,'ohb_file'),",",
                                                 cl_get_target_table(l_plant,'oha_file'),
                     "  WHERE ohaplant = '",l_plant,"'", 
                     "    AND ohb01 = '",sr1.ohb01,"'", 
                     "    AND ohb03 = '",sr1.ohb03,"'",
                     "    AND oha01 = ohb01 ", 
                     "    AND ohaconf = 'Y' ", 
                     "    AND ohaplant = ohbplant ",
                     "    AND YEAR(oha02) = '",tm.yy02,"'",
                     "    AND MONTH(oha02) = '",tm.mm02,"'" 
    END IF  
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_ohb14t_pre4 FROM l_sql
         EXECUTE sel_ohb14t_pre4 INTO sr1.ohb14t_3            #抓取比較時間銷退金額
         IF cl_null(sr1.ohb14t_2) THEN
            LET sr1.ohb14t_2 = 0
         END IF   
         IF cl_null(sr1.ohb14t_3) THEN
            LET sr1.ohb14t_3 = 0
         END IF 
         CASE l_azi10 
                WHEN '1' 
                   LET sr1.ohb14t_2 = sr1.ohb14t_2*l_oha24
                   LET sr1.ohb14t_3 = sr1.ohb14t_3*l_oha24 
                WHEN '2'
                   LET sr1.ohb14t_2 = sr1.ohb14t_2/l_oha24
                   LET sr1.ohb14t_3 = sr1.ohb14t_3/l_oha24  
         END CASE
     
    CASE tm.type01 
       WHEN '1'           
         CALL axmr863_1(l_plant,sr1.ima01,'',sr1.oha02) 
            RETURNING sr1.ccc23
            LET sr1.ccc23 = sr1.ccc23*sr1.ohb12     
       WHEN '2' 
             
         LET l_sql = " SELECT SUM(cxc09) FROM ",cl_get_target_table(l_plant,'ima_file'),",",
                                                cl_get_target_table(l_plant,'cxc_file'),
                     "  WHERE cxc01 = '",sr1.ima01,"'",
                     "    AND cxc04 = '",sr1.ohb01,"'",
                     "    AND cxc05 = '",sr1.ohb03,"'",
                     "    AND cxcplant = '",l_plant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_cxc09_pre11 FROM l_sql
         EXECUTE sel_cxc09_pre11 INTO sr1.ccc23             #抓取單價成本
         IF cl_null(sr1.ccc23) THEN
               LET sr1.ccc23 = 0 
         END IF
         LET sr1.ccc23 = sr1.ccc23*sr1.ohb12
       WHEN '3'     
          CALL axmr863_1(l_plant,sr1.ima01,sr1.ohb092,sr1.oha02) 
             RETURNING sr1.ccc23   
             LET sr1.ccc23 = sr1.ccc23*sr1.ohb12
       WHEN '4'     
          CALL axmr863_1(l_plant,sr1.ima01,'',sr1.oha02) 
             RETURNING sr1.ccc23 
             LET sr1.ccc23 = sr1.ccc23*sr1.ohb12
       WHEN '5'     
          LET l_sql = " SELECT imd16 FROM ",cl_get_target_table(l_plant,'imd_file'),
                      "  WHERE imd01 = '",sr1.ohb09,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
             PREPARE sel_ima16_pre1 FROM l_sql
             EXECUTE sel_ima16_pre1 INTO l_imd16
          LET l_sql = " SELECT SUM(ccc23) FROM ",cl_get_target_table(l_plant,'ccc_file'),",",
                                                 cl_get_target_table(l_plant,'imd_file'), 
                      "  WHERE ccc01 = '",sr1.ima01,"'",
                      "    AND ccc02 = '",tm.yy01,"'", 
                      "    AND ccc03 = '",tm.mm01,"'", 
                      "    AND ccc07 = '",tm.type01,"'",
                      "    AND ccc08 = '",l_imd16,"'",
                      "    AND imd01 = '",sr1.ohb09,"'" 
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
          PREPARE sel_ccc23_pre41 FROM l_sql
          EXECUTE sel_ccc23_pre41 INTO sr1.ccc23              #抓取單價成本
          LET sr1.ccc23 = sr1.ccc23*sr1.ohb12
       END CASE
       
   INSERT INTO axmr863_tmp1 
         VALUES(sr1.ohbplant,l_azp02,sr1.ohb14t_2,sr1.ccc23,sr1.ohb12,sr1.ohb14t_2,sr1.ohb14t_3)
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
END FOREACH
#FUN-AA0024 add --------------------------------end------------------------------------   
   END FOREACH
      LET l_sql = " SELECT a.ogbplant,a.azp02,0, ",
                  " SUM(a.ccc23)-(SELECT CASE WHEN SUM(b.ccc23) IS NULL THEN 0 ELSE SUM(b.ccc23) END FROM axmr863_tmp1 b),",        #FUN-AA0024 add
                  " SUM(a.ogb12),",
                  " SUM(a.ogb14t_2)-(SELECT CASE WHEN SUM(b.ohb14t_2) IS NULL THEN 0 ELSE SUM(b.ohb14t_2) END FROM axmr863_tmp1 b),",  #FUN-AA0024 add
                  " SUM(a.ogb14t_3)-(SELECT CASE WHEN SUM(b.ohb14t_3) IS NULL THEN 0 ELSE SUM(b.ohb14t_3) END FROM axmr863_tmp1 b)",   #FUN-AA0024 add
                  "   FROM axmr863_tmp a ",
                  "  GROUP BY a.ogbplant,a.azp02"
      PREPARE axmr863_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE axmr863_curs2 CURSOR FOR axmr863_prepare2

   FOREACH axmr863_curs2 INTO sr.ogbplant,l_azp02,sr.ogb14t_2,
                              sr.ccc23,sr.ogb12,sr.ogb14t_2,sr.ogb14t_3 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF          
      EXECUTE  insert_prep  USING  
      sr.ogbplant,l_azp02,sr.ogb14t_2,
      sr.ccc23,sr.ogb12,sr.ogb14t_2,sr.ogb14t_3 
   END FOREACH
   LET l_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = tm.wc1," and ",tm.wc
         CALL cl_prt_cs3('axmr863','axmr863',l_sql,g_str)  
END FUNCTION
#FUN-A70025
