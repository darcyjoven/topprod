# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: artr460.4gl
# Descriptions...: 會員銷售明細表
# Date & Author..: #FUN-A60075 10/07/07 By sunchenxu
# Modify.........: #FUN-AA0024 10/10/13 By wangxin 報表改善
# Modify.........: #FUN-B60106 11/06/21 By yangxf tm.wc2 oha02與oga02互換
# Modify.........: No:TQC-B70204 11/07/28 By yangxf UNION 改成UNION ALL
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc1      STRING,    
              wc2      STRING,    
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
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc2 = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  
   IF (NOT cl_user()) THEN
      
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   LET g_sql =  "lpk01.lpk_file.lpk01,",
                "lpk04.lpk_file.lpk04,",
                "oga87.oga_file.oga87,",
                "ogaplant.oga_file.ogaplant,",
                "azp02.azp_file.azp02,",
                "oga02.oga_file.oga02,",
                "ogb04.ogb_file.ogb04,",
                "ima02.ima_file.ima02,",
                "ogb13.ogb_file.ogb13,",
                "oga24.oga_file.oga24,",
                "ogb12.ogb_file.ogb12,",
                "ogb14t.ogb_file.ogb14t"
 
   LET l_table = cl_prt_temptable('artr460',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artr460_tm(0,0)        # Input print condition
      ELSE CALL artr460()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION artr460_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000  
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artr460_w AT p_row,p_col WITH FORM "art/42f/artr460" 
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
   
         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT CONSTRUCT      
            
         ON ACTION controlp
            CASE
              WHEN INFIELD(azp01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
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
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr450_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      #IF cl_null(tm.wc1) OR tm.wc1 = ' 1=1' THEN
      #   LET tm.wc1 = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
      #END IF 
      
      CONSTRUCT BY NAME tm.wc2 ON lpk01,oga02

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

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
         LET INT_FLAG = 0 CLOSE WINDOW artr460_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      DISPLAY BY NAME tm.more 
      
      INPUT BY NAME tm.more WITHOUT DEFAULTS

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
         LET INT_FLAG = 0 CLOSE WINDOW artr460_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr460'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr460','9031',1)
         ELSE
            LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc2 CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('artr460',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr460_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr460()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr460_w
END FUNCTION

FUNCTION artr460() 
   DEFINE l_plant   LIKE  azp_file.azp01
   DEFINE l_azp02   LIKE  azp_file.azp02
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 
          l_chr     LIKE type_file.chr1,       
          l_za05    LIKE type_file.chr1000,
          sr        RECORD 
                    lpk01    LIKE lpk_file.lpk01,
                    lpk04    LIKE lpk_file.lpk04,
                    oga87    LIKE oga_file.oga87,
                    ogaplant LIKE oga_file.ogaplant,
                    azp02    LIKE azp_file.azp02,
                    oga02    LIKE oga_file.oga02,
                    ogb04    LIKE ogb_file.ogb04,
                    ima02    LIKE ima_file.ima02,
                    ogb13    LIKE ogb_file.ogb13,
                    oga24    LIKE oga_file.oga24,
                    ogb12    LIKE ogb_file.ogb12,
                    ogb14t   LIKE ogb_file.ogb14t
                    END RECORD     
    DEFINE l_wc         STRING                   #FUN-BC0026 add
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    LET tm.wc2 = tm.wc2 CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')

    CALL cl_del_data(l_table)
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) "                                                                                                        
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                   
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--                                                                                       
       EXIT PROGRAM                                                                                                                 
    END IF

  #FUN-BC0026 add START
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc2,'lpk01,oga02')
       RETURNING l_wc
       LET g_str = l_wc
       IF g_str.getLength() > 1000 THEN
          LET g_str = g_str.subString(1,600)
          LET g_str = g_str,"..."
       END IF
    END IF
  #FUN-BC0026 add END

    LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
                " WHERE azw01 = azp01  ",
                " AND azp01 IN ",g_chk_auth,
                " ORDER BY azp01 " 
                
    PREPARE sel_azp01_pre FROM l_sql
    DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
 
    FOREACH sel_azp01_cs INTO l_plant,l_azp02  
       IF STATUS THEN
         CALL cl_err('PLANT:',SQLCA.sqlcode,1)
         RETURN
       END IF
       LET tm.wc2 = cl_replace_str(tm.wc2,'oha02','oga02')            #FUN-B60106
       LET l_sql = "SELECT lpk01,lpk04,oga87,ogaplant,'',oga02, ",
                   "ogb04,ima02,ogb13,oga24,ogb12,ogb14t ",								
                   " FROM ",cl_get_target_table(l_plant,'oga_file'),
                   " ,",cl_get_target_table(l_plant,'ogb_file'),	
                   " ,",cl_get_target_table(l_plant,'lpk_file'),	
                   " ,",cl_get_target_table(l_plant,'lpj_file'),			
                   " ,",cl_get_target_table(l_plant,'ima_file'),									
                   " WHERE oga01=ogb01 AND ima01=ogb04 ",  
                   " AND lpk01=lpj01 AND oga87=lpj03 ", 
                   " AND ogaplant='",l_plant,"' AND ogapost='Y' ", 
#                  " AND ",tm.wc2 CLIPPED,                            #FUN-B60106
#FUN-B60106 -------------------STA
                   " AND ",tm.wc2 CLIPPED
      LET tm.wc2 = cl_replace_str(tm.wc2,'oga02','oha02')
      LET l_sql =  l_sql,
#FUN-B60106 -------------------END
                   #FUN-AA0024 add ###begin###
#                  "UNION SELECT lpk01,lpk04,oha87,ohaplant,'',oha02, ",        #TQC-B70204 mark
                   "UNION ALL SELECT lpk01,lpk04,oha87,ohaplant,'',oha02, ",        #TQC-B70204 
                   "ohb04,ima02,(ohb13*-1),oha24,(ohb12*-1),(ohb14t*-1) ",								
                   " FROM ",cl_get_target_table(l_plant,'oha_file'),
                   " ,",cl_get_target_table(l_plant,'ohb_file'),	
                   " ,",cl_get_target_table(l_plant,'lpk_file'),	
                   " ,",cl_get_target_table(l_plant,'lpj_file'),			
                   " ,",cl_get_target_table(l_plant,'ima_file'),									
                   " WHERE oha01=ohb01 AND ima01=ohb04 ",  
                   " AND lpk01=lpj01 AND oha87=lpj03 ", 
                   " AND ohaplant='",l_plant,"' AND ohapost='Y' ", 
                   " AND ",tm.wc2 CLIPPED
                   #FUN-AA0024 add ###end### 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
       CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
       PREPARE artr460_prepare1 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time 
          EXIT PROGRAM
       END IF
       DECLARE artr460_curs1 CURSOR FOR artr460_prepare1
       
       FOREACH artr460_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         #FUN-AA0024 add ------------begin------------------
         IF  cl_null(sr.ogb13) OR sr.ogb13 =' ' THEN LET sr.ogb13 = 0 END IF
         IF  cl_null(sr.oga24) OR sr.oga24 =' ' THEN LET sr.oga24 = 1 END IF
         IF  cl_null(sr.ogb14t) OR sr.ogb14t =' ' THEN LET sr.ogb14t = 0 END IF
         #FUN-AA0024 add ------------end--------------------
         EXECUTE  insert_prep  USING  
         sr.lpk01,sr.lpk04,sr.oga87,sr.ogaplant,l_azp02,sr.oga02,
         sr.ogb04,sr.ima02,sr.ogb13,sr.oga24,sr.ogb12,sr.ogb14t
         
       END FOREACH 
    END FOREACH
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #LET g_str = tm.wc2  #FUN-BC0026 mark
    CALL cl_prt_cs3('artr460','artr460',l_sql,g_str) 
END FUNCTION
#FUN-A60075
