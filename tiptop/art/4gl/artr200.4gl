# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: artr200.4gl
# Descriptions...: 營運中心庫存統計表
# Date & Author..: FUN-A80082 10/07/20 By sunchenxu
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.TQC-B70068 11/07/08 By guoch 將l_sql,wc的類型改為STRING
# Modify.........: No.FUN-B80085 11/08/09 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No:FUN-BB0018 11/11/07 By suncx 報表調整完善
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm          RECORD                          # Print condition RECORD
             #      wc1     LIKE type_file.chr1000, # Where condition   #TQC-B70068 mark
             #      wc2     LIKE type_file.chr1000, # Where condition   #TQC-B70068 mark
             #      wc3     LIKE type_file.chr1000, # Where condition   #TQC-B70068 mark
                   wc1     STRING,   #TQC-B70068
                   wc2     STRING,   #TQC-B70068
                   wc3     STRING,   #TQC-B70068
                   edate   LIKE type_file.dat,    
                   type    LIKE type_file.chr1, 
                   w       LIKE type_file.chr1,    #FUN-BB0018 add 
                   x       LIKE type_file.chr1,    #FUN-BB0018 add 
                   a       LIKE type_file.chr1, 
                   more    LIKE type_file.chr1     # Input more condition(Y/N)  
                   END RECORD
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   g_yy        LIKE type_file.num5,    
         g_mm        LIKE type_file.num5,    
         last_y      LIKE type_file.num5,    
         last_m      LIKE type_file.num5,
         l_flag      LIKE type_file.chr1,
         l_cnt       LIKE type_file.num5,
         m_bdate     LIKE type_file.dat,     
         m_edate     LIKE type_file.dat,
         l_syy       LIKE type_file.chr20, 
         l_smm       LIKE type_file.chr20, 
         l_lyy       LIKE type_file.chr20, 
         l_lmm       LIKE type_file.chr20     
DEFINE   g_chr        LIKE type_file.chr1 
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
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc1 = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.wc3 = ARG_VAL(9)
   LET tm.w = ARG_VAL(10)
   LET tm.a = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15) 
   LET tm.x = ARG_VAL(16) 


   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL artr200_tm(0,0)        # Input print condition
      ELSE CALL artr200()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION artr200_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000  
   DEFINE tok            base.StringTokenizer 
   DEFINE l_zxy03        LIKE zxy_file.zxy03 
           
           
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW artr200_w AT p_row,p_col WITH FORM "art/42f/artr200" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
       
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.edate = g_today   
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc1 = ' 1=1'
   LET tm.wc2 = ' 1=1'
   LET tm.wc3 = ' 1=1'
   LET tm.type = '1'
   LET tm.w = 'Y'   #FUN-BB0018 add 
   LET tm.x = 'Y'   #FUN-BB0018 add 
   LET tm.a = '1' 
   

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
            IF INFIELD(azp01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azp"
               LET g_qryparam.state = 'c'
               LET g_qryparam.where = " exists (SELECT 1 FROM zxy_file WHERE zxy03 = azp_file.azp01 AND zxy01 = '",g_user,"')"
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
            
      END CONSTRUCT 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr450_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      # IF cl_null(tm.wc1) OR tm.wc1 = ' 1=1' THEN
      #   LET tm.wc1 = " azp01 = '",g_plant,"'"  #为空则默认为当前营运中心
      #END IF
      CONSTRUCT BY NAME tm.wc2 ON ima131,ima01
            
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
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr450_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      
      CONSTRUCT BY NAME tm.wc3 ON img02

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
            
      END CONSTRUCT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW artr200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      IF tm.wc1 = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
     #DISPLAY BY NAME  tm.edate,tm.type,tm.a,tm.more
      DISPLAY BY NAME  tm.edate,tm.type,tm.w,tm.x,tm.a,tm.more #FUN-BB0018 add tm.x,tm.w
      
     #INPUT BY NAME tm.edate,tm.type,tm.a,tm.more WITHOUT DEFAULTS
      INPUT BY NAME tm.edate,tm.type,tm.w,tm.x,tm.a,tm.more WITHOUT DEFAULTS  #FUN-BB0018 add tm.x,tm.w

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
            IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
            CALL s_yp(tm.edate) RETURNING g_yy,g_mm 
           
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
            
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
            
         AFTER INPUT
            IF  INT_FLAG THEN EXIT INPUT END IF
            LET l_flag = 'N'
            IF  cl_null(tm.edate) THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME tm.edate
            END IF
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
         LET INT_FLAG = 0 CLOSE WINDOW artr200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF

      LET last_y = g_yy LET last_m = g_mm - 1
      IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='artr200'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('artr200','9031',1)
         ELSE
            LET tm.wc1=cl_replace_str(tm.wc1, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.wc1 CLIPPED,"'" ,
                       " '",tm.w CLIPPED,"'" ,    #FUN-BB0018 add
                       " '",tm.a CLIPPED,"'" ,
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'",
                       " '",tm.x CLIPPED,"'"     #FUN-BB0018 add
            CALL cl_cmdat('artr200',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW artr200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr200()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr200_w
END FUNCTION

FUNCTION artr200()
#   DEFINE l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT     #TQC-B70068 mark   
   DEFINE l_sql     STRING,               
          sr        RECORD 
                    azw01 LIKE azw_file.azw01,
                    img01 LIKE img_file.img01,   #--料號
                    img02 LIKE img_file.img02,   #--倉
                    img03 LIKE img_file.img03,   #--儲
                    img04 LIKE img_file.img04,   #--批
                    img09 LIKE img_file.img09,   #--單位      #FUN-BB0018
                    img10 LIKE img_file.img10,   #--庫存數量  
                    imk09 LIKE imk_file.imk09,   #--上期期末庫存
                    tmp01 LIKE imk_file.imk05,   #--上期期末年度  
                    tmp02 LIKE imk_file.imk06,   #--上期期末期別  
                    ima01 LIKE ima_file.ima01,   #--料件編號
                    ima02 LIKE ima_file.ima02,   #--品名
                    ima131 LIKE ima_file.ima131, #--產品分類碼
                    tlfcost LIKE tlf_file.tlfcost
                    END RECORD 
   DEFINE l_img10 LIKE img_file.img10,  #庫存數量
          l_amt   LIKE type_file.num15_3,  #金額
          l_amts  LIKE type_file.num15_3,  #總金額
          l_yy      LIKE type_file.num5,   
          l_mm      LIKE type_file.num5,
          l_ccc23_1 LIKE ccc_file.ccc23, 
          l_ccc23_2 LIKE ccc_file.ccc23,
          l_azp02   LIKE azp_file.azp02,
          l_oba02   LIKE oba_file.oba02,
          l_percent LIKE type_file.num15_3,
          l_plant   LIKE  azp_file.azp01,
          l_imk09   LIKE imk_file.imk09,
          l_tlf10   LIKE tlf_file.tlf10,
          l_rtz04     LIKE rtz_file.rtz04
   DEFINE l_db_type  STRING       #FUN-B40029
          
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
   LET g_sql = "azp01.azp_file.azp01,",
               "azp02.azp_file.azp02,",
               "ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
               "ima131.ima_file.ima131,",
               "oba02.oba_file.oba02,",
               "img02.img_file.img02,", 
               "img09.img_file.img09,",  #FUN-BB0018 
               "img10.img_file.img10,",
               "amt.type_file.num15_3,",
               "percent.type_file.num15_3"
                   
   LET l_table = cl_prt_temptable('artr200',g_sql) CLIPPED
   IF  l_table = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add-- 
       EXIT PROGRAM 
   END IF
 
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                                       
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)      
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80085--add--      
      EXIT PROGRAM                                                                                                                 
   END IF
   DROP TABLE artr200_tmp

   CREATE TEMP TABLE artr200_tmp(
          azp01  LIKE azp_file.azp01,
          azp02  LIKE azp_file.azp02,
          ima01  LIKE ima_file.ima01,
          ima02  LIKE ima_file.ima02,
          ima131 LIKE ima_file.ima131,
          oba02  LIKE oba_file.oba02, 
          img02  LIKE img_file.img02,
          img09  LIKE img_file.img09,   #FUN-BB0018 單位
          img10  LIKE img_file.img10,   #--庫存數量
          amt  LIKE type_file.num15_3)   #--金额
   DELETE FROM artr200_tmp
   LET l_sql = "SELECT DISTINCT azp01,azp02 FROM azp_file,azw_file ",
              #" WHERE ",tm.wc1 CLIPPED ,   
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
      #mark by suncx 20100908 NO.FUN-A80082 begin--------
      #LET l_sql = "SELECT rtz04 ",
      #            "  FROM ",cl_get_target_table(l_plant,'rtz_file'),
      #            " WHERE  rtz01 = '",l_plant,"' "
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      #PREPARE pre12 FROM l_sql
      #EXECUTE pre12 INTO l_rtz04
      #IF cl_null(l_rtz04) THEN  
      #mark by suncx 20100908 NO.FUN-A80082 end--------
      LET l_sql = "SELECT imgplant, img01, img02, img03, img04, '', '', ima01,",
                 #" ima02, ima131",
                  " ima02, ima131, img09",  #FUN-BB0018
                  "  FROM ",cl_get_target_table(l_plant,'ima_file'), 
                  " ,",cl_get_target_table(l_plant,'img_file'),		
                 #"  LEFT OUTER JOIN ",cl_get_target_table(l_plant,'imk_file'),	
                 #"    ON img01 = imk01 AND img02 = imk02",
                 #"   AND img03 = imk03 AND img04 = imk04",
                 #"   AND imk05 =",g_yy,
                 #"   AND imk06 =",g_mm,
                  " WHERE imgplant='",l_plant,"'",
                  "   AND ", tm.wc2 CLIPPED," AND ", tm.wc3 CLIPPED,                            
                  "   AND ima01 = img01" 
     #mark by suncx 20100908 NO.FUN-A80082 begin--------
     # ELSE 
     #  	 LET l_sql = "SELECT imgplant, img01, img02, img03, img04, '', '',ima01,",
     #                  " ima02, ima131",
     #                  "  FROM ",cl_get_target_table(l_plant,'ima_file'), 
     #                  " ,",cl_get_target_table(l_plant,'rte_file'),
     #                  " ,",cl_get_target_table(l_plant,'img_file'),		
     #                  #"  LEFT OUTER JOIN ",cl_get_target_table(l_plant,'imk_file'),	
     #                  #"    ON img01 = imk01 AND img02 = imk02",
     #                  #"   AND img03 = imk03 AND img04 = imk04",
     #                  #"   AND imk05 =",g_yy,
     #                  #"   AND imk06 =",g_mm,
     #                  " WHERE imgplant='",l_plant,"'",
     #                  "   AND rte01 = '",l_rtz04,"' ",
     #                  "   AND rte03 = ima01 ", 
     #                  "   AND ", tm.wc2 CLIPPED," AND ", tm.wc3 CLIPPED,                            
     #                  "   AND ima01 = img01"
     # END IF 
     #mark by suncx 20100908 NO.FUN-A80082 end--------
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql    
      PREPARE r200_prepare1 FROM l_sql
      IF SQLCA.sqlcode THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM 
      END IF
      DECLARE r200_curs1 CURSOR FOR r200_prepare1
      FOREACH r200_curs1 INTO sr.azw01,sr.img01,sr.img02,sr.img03,sr.img04,
                              sr.tmp01,sr.tmp02,sr.ima01,sr.ima02,sr.ima131,
                              sr.img09   #FUN-BB0018
         SELECT COUNT(*) INTO l_cnt FROM artr200_tmp  #--己存在不覆蓋
          WHERE img01 = sr.img01 AND img02 = sr.img02
            AND   img03 = sr.img03 AND img04 = sr.img04
         IF NOT cl_null(l_cnt) AND l_cnt <> 0 THEN
            CONTINUE FOREACH
         END IF  
         LET l_lyy = last_y  
         LET l_lmm = last_m 
         LET l_syy = g_yy  
         LET l_smm = g_mm 
         INITIALIZE l_ccc23_1 TO NULL
         CALL s_azm(g_yy,g_mm)             # 抓取本期的起始日期
            RETURNING g_chr,m_bdate,m_edate
         CASE tm.type
            WHEN '2'
               LET l_sql = "SELECT SUM(cxa08)-SUM(cxc08),SUM(cxa09)-SUM(cxc09) ",
                           "  FROM ",cl_get_target_table(l_plant,'cxc_file'),
                           " ,",cl_get_target_table(l_plant,'cxa_file'),		  
                           " WHERE cxa01 = cxc01 AND cxa01 = '",sr.img01,"'", 
                           "   AND cxa02 = ",g_yy," AND cxa03 = ",g_mm,
                           "   AND cxa010 = '",tm.type,"'"," AND cxa011 = '",sr.img04,"'",
                           "   AND cxa04 <= ",tm.edate 
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
               CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
               PREPARE sel_cxa_pre FROM l_sql
               EXECUTE sel_cxa_pre INTO l_img10,l_amt
               IF (l_img10 IS NULL) OR (l_img10 = 0) THEN
                  IF tm.edate = g_today THEN
                     LET l_sql = "SELECT img10 FROM ",cl_get_target_table(l_plant,'img_file'), 
                                 " WHERE img01 = '",sr.img01,"'",
                                 "   AND img02 = '",sr.img02,"'",
                                 "   AND img03 = '",sr.img03,"'",
                                 "   AND img04 = '",sr.img04,"'" 
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
                     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
                     PREPARE sel_img10_pre1 FROM l_sql
                     EXECUTE sel_img10_pre1 INTO l_img10
                  ELSE
                     #mark by suncx NO.FUN-A80082 begin------------------ 
                     #LET l_sql = "SELECT sum(imk09) FROM ",cl_get_target_table(l_plant,'imk_file'),
                     #            " WHERE imk01 = '",sr.img01,"'"," AND imk02 = '",sr.img02,"'",
                     #            "   AND imk03 = '",sr.img03,"'"," AND imk04 = '",sr.img04,"'",
                     #            "   AND imk05||substr(100+imk06,2) IN(SELECT MAX(imk05||substr(100+imk06,2)) FROM  ",
                     #                cl_get_target_table(l_plant,'imk_file') ,
                     #            " WHERE imk05||substr(100+imk06,2) <= '",l_lyy,"'||substr(100+'",l_lmm,"',2)",
                     #            "   AND imk01 = '",sr.img01,"'"," AND imk02 = '",sr.img02,"'",
                     #            "   AND imk03 = '",sr.img03,"'"," AND imk04 = '",sr.img04,"')"
                     #mark by suncx NO.FUN-A80082 end------------------ 
                     
                     #add by suncx NO.FUN-A80082 begin------------------
                     LET l_sql = "SELECT sum(imk09) FROM ",cl_get_target_table(l_plant,'imk_file'),
                                 " WHERE imk01 = '",sr.img01,"' AND imk02 = '",sr.img02,"'",
                                 "   AND imk03 = '",sr.img03,"' AND imk04 = '",sr.img04,"'",
                                 "   AND imk05 = '",l_lyy,"' AND imk06 ='",l_lmm,"'"
                     #add by suncx NO.FUN-A80082 end  ------------------
                     
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
                     PREPARE sel_imk09_pre1 FROM l_sql
                     EXECUTE sel_imk09_pre1 INTO l_imk09 
                     LET l_sql = " SELECT SUM(tlf10*tlf907) FROM ",cl_get_target_table(l_plant,'tlf_file'),
                                 " WHERE tlf01 = '",sr.img01,"'", " AND tlf902 = '",sr.img02,"'",
                                 "   AND tlf903 = '",sr.img03,"'"," AND tlf904 = '",sr.img04,"'", 
                                 "   AND tlf06 BETWEEN '",m_bdate,"' AND '",tm.edate,"'" 
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
                     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
                     PREPARE sel_tlf10_pre1 FROM l_sql
                     EXECUTE sel_tlf10_pre1 INTO l_tlf10  
                     IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF  
                     IF cl_null(l_tlf10) THEN LET l_tlf10 = 0 END IF  
                     LET l_img10 = l_imk09 + l_tlf10
                  END IF
               END IF
            OTHERWISE
               CASE tm.type
                  WHEN '1'  LET sr.tlfcost = ' '
                  WHEN '3'  LET sr.tlfcost = sr.img04
                  WHEN '4'  LET sr.tlfcost = ' '
                  WHEN '5'  
                     LET l_sql = "SELECT imd16 FROM ",cl_get_target_table(l_plant,'imd_file'),
                                 " WHERE imd01 = '",sr.img02,"'" 
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
                     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
                     PREPARE sel_imd16_pre FROM l_sql
                     EXECUTE sel_imd16_pre INTO sr.tlfcost           
               END CASE
                      
               LET l_db_type=cl_db_get_database_type()    #FUN-B40029
               #FUN-B40029-add-start--
               IF l_db_type='MSV' THEN #SQLSERVER的版本
               LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                           " WHERE ccc01 = '",sr.img01,"' ",
                           "   AND ccc07='",tm.type,"'"," AND ccc08 ='",sr.tlfcost,"'",
                           "   AND ccc02||substring(100+ccc03,2) in(",
                           " SELECT max(ccc02||substring(100+ccc03,2)) FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                           "  WHERE ccc02||substring(100+ccc03,2) <= '",l_syy,"'||substring(100+'",l_smm,"',2)",
                           "    AND ccc01 = '",sr.img01,"'",
                           "    AND ccc07='",tm.type,"'"," AND ccc08 ='",sr.tlfcost,"')"
               ELSE
               #FUN-B40029-add-end--
               LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                           " WHERE ccc01 = '",sr.img01,"' ", 
                           "   AND ccc07='",tm.type,"'"," AND ccc08 ='",sr.tlfcost,"'",
                           "   AND ccc02||substr(100+ccc03,2) in(",
                           " SELECT max(ccc02||substr(100+ccc03,2)) FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                           "  WHERE ccc02||substr(100+ccc03,2) <= '",l_syy,"'||substr(100+'",l_smm,"',2)",
                           "    AND ccc01 = '",sr.img01,"'",
                           "    AND ccc07='",tm.type,"'"," AND ccc08 ='",sr.tlfcost,"')"            
               END IF   #FUN-B40029
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
               CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
               PREPARE sel_ccc23_pre1 FROM l_sql   
               EXECUTE sel_ccc23_pre1 INTO l_ccc23_1                   
               IF (SQLCA.sqlcode) OR (l_ccc23_1 IS NULL) THEN 
                  LET l_ccc23_1 = 0 
               END IF
               IF tm.edate = g_today THEN
                  LET l_sql = "SELECT img10 FROM ",cl_get_target_table(l_plant,'img_file'), 
                              " WHERE img01 = '",sr.img01,"'",
                              "   AND img02 = '",sr.img02,"'",
                              "   AND img03 = '",sr.img03,"'",
                              "   AND img04 = '",sr.img04,"'" 
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
                  PREPARE sel_img10_pre2 FROM l_sql
                  EXECUTE sel_img10_pre2 INTO l_img10 
                  LET l_amt = l_img10*l_ccc23_1
               ELSE
                  #mark by suncx NO.FUN-A80082 begin------------------
                  #LET l_sql = "SELECT sum(imk09) FROM ",cl_get_target_table(l_plant,'imk_file'),
                  #            " WHERE imk01 = '",sr.img01,"'"," AND imk02 = '",sr.img02,"'",
                  #            "   AND imk03 = '",sr.img03,"'"," AND imk04 = '",sr.img04,"'",
                  #            "   AND imk05||substr(100+imk06,2) IN(SELECT MAX(imk05||substr(100+imk06,2)) FROM  ",
                  #                cl_get_target_table(l_plant,'imk_file') ,
                  #            " WHERE imk05||substr(100+imk06,2) <= '",l_lyy,"'||substr(100+'",l_lmm,"',2)",
                  #            "   AND imk01 = '",sr.img01,"'"," AND imk02 = '",sr.img02,"'",
                  #            "   AND imk03 = '",sr.img03,"'"," AND imk04 = '",sr.img04,"')"
                  #mark by suncx NO.FUN-A80082 end------------------ 
                     
                  #add by suncx NO.FUN-A80082 begin------------------
                  LET l_sql = "SELECT sum(imk09) FROM ",cl_get_target_table(l_plant,'imk_file'),
                              " WHERE imk01 = '",sr.img01,"' AND imk02 = '",sr.img02,"'",
                              "   AND imk03 = '",sr.img03,"' AND imk04 = '",sr.img04,"'",
                              "   AND imk05 = '",l_lyy,"' AND imk06 ='",l_lmm,"'"
                  #add by suncx NO.FUN-A80082 end  ------------------
                  
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
                  PREPARE sel_imk09_pre2 FROM l_sql
                  EXECUTE sel_imk09_pre2 INTO l_imk09 
                  LET l_sql = " SELECT SUM(tlf10*tlf907) FROM ",cl_get_target_table(l_plant,'tlf_file'),
                              " WHERE tlf01 = '",sr.img01,"'", " AND tlf902 = '",sr.img02,"'",
                              "   AND tlf903 = '",sr.img03,"'"," AND tlf904 = '",sr.img04,"'", 
                              "   AND tlf06 BETWEEN '",m_bdate,"' AND '",tm.edate,"'" 
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
                  CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
                  PREPARE sel_tlf10_pre2 FROM l_sql
                  EXECUTE sel_tlf10_pre2 INTO l_tlf10
                  IF cl_null(l_imk09) THEN LET l_imk09 = 0 END IF  
                  IF cl_null(l_tlf10) THEN LET l_tlf10 = 0 END IF    
                  LET l_img10 = l_imk09 + l_tlf10 
                  #LET l_sql = "SELECT ccc23 FROM ",cl_get_target_table(l_plant,'ccc_file'),
                  #            " WHERE ccc01 = '",sr.img01,"' ", 
                  #            "   AND ccc07='",tm.type,"'"," AND ccc08 ='",sr.tlfcost,"'",
                  #            "   AND ccc02||substr(100+ccc03,2) in(",
                  #            " SELECT max(ccc02||substr(100+ccc03,2)) FROM ",cl_get_target_table(l_plant,'ccc_file') ,
                  #            "  WHERE ccc02||substr(100+ccc03,2) <= '",l_lyy,"'||substr(100+'",l_lmm,"',2)",
                  #            "    AND ccc01 = '",sr.img01,"'",
                  #            "    AND ccc07='",tm.type,"'"," AND ccc08 ='",sr.tlfcost,"')"            
                  #CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      
                  #CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql  
                  #PREPARE sel_ccc23_pre2 FROM l_sql   
                  #EXECUTE sel_ccc23_pre2 INTO l_ccc23_2                   
                  #IF (SQLCA.sqlcode) OR (l_ccc23_2 IS NULL) THEN 
                  #   LET l_ccc23_2 = 0 
                  #END IF 
                  #LET l_amt = (l_imk09*l_ccc23_2)+(l_tlf10*l_ccc23_1) 
                   LET l_amt =  l_img10 * l_ccc23_1
               END IF     
         END CASE
         LET l_sql="SELECT oba02 FROM ",cl_get_target_table(l_plant,'oba_file'),
                   " WHERE oba01 = '",sr.ima131,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
         PREPARE sel_oba02_pre FROM l_sql
         EXECUTE sel_oba02_pre INTO l_oba02
         IF SQLCA.sqlcode THEN                                                     
            LET l_oba02 = ''                                                                                                        
         END IF
         INSERT INTO artr200_tmp 
         VALUES(sr.azw01,l_azp02,sr.ima01,sr.ima02,sr.ima131,l_oba02,sr.img02,sr.img09,l_img10,l_amt)  ##FUN-BB0018 add img09
      END FOREACH
   END FOREACH 
   CASE
      WHEN tm.a='1'
        #LET l_sql = "SELECT azp01,azp02,'','','','',img02,SUM(img10),SUM(amt) ",
         LET l_sql = "SELECT azp01,azp02,'','','','',img02,'',SUM(img10),SUM(amt) ",    #FUN-BB0018 add ''
                     " FROM artr200_tmp ",
                     " GROUP BY azp01,azp02,img02"
      WHEN tm.a='2'
        #LET l_sql = "SELECT azp01,azp02,'','',ima131,oba02,img02,SUM(img10),SUM(amt) ",
         LET l_sql = "SELECT azp01,azp02,'','',ima131,oba02,img02,'',SUM(img10),SUM(amt) ",   #FUN-BB0018 add ''
                     " FROM artr200_tmp ",
                     " GROUP BY azp01,azp02,ima131,oba02,img02"
      WHEN tm.a='3'
        #LET l_sql = "SELECT azp01,azp02,ima01,ima02,'','',img02,SUM(img10),SUM(amt) ",
         LET l_sql = "SELECT azp01,azp02,ima01,ima02,'','',img02,img09,SUM(img10),SUM(amt) ",   #FUN-BB0018 add img09
                     " FROM artr200_tmp ",
                     " GROUP BY azp01,azp02,ima01,ima02,img02,img09"
   END CASE

   PREPARE artr200_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE artr200_curs2 CURSOR FOR artr200_prepare2

   FOREACH artr200_curs2 INTO sr.azw01,l_azp02,sr.ima01,sr.ima02,
                             #sr.ima131,l_oba02,sr.img02,l_img10,l_amt
                              sr.ima131,l_oba02,sr.img02,sr.img09,l_img10,l_amt   #FUN-BB0018 add img09
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT SUM(amt) INTO l_amts FROM artr200_tmp WHERE azp01 = sr.azw01
      IF l_amts  <> 0 THEN
         LET l_percent = (100*l_amt)/l_amts
      ELSE 
         LET l_percent = 0
      END IF
      EXECUTE  insert_prep  USING  
      sr.azw01,l_azp02,sr.ima01,sr.ima02,sr.ima131,
     #l_oba02,sr.img02,l_img10,l_amt,l_percent
      l_oba02,sr.img02,sr.img09,l_img10,l_amt,l_percent   #FUN-BB0018 add img09
   END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #FUN-BB0018 add by suncx start----------------------
   CASE
      WHEN tm.a='1'
         LET l_sql = l_sql CLIPPED," ORDER BY azp01,img02"
      WHEN tm.a='2'
         LET l_sql = l_sql CLIPPED," ORDER BY azp01,ima131,img02"
      WHEN tm.a='3'
         LET l_sql = l_sql CLIPPED," ORDER BY azp01,ima01,img02"
   END CASE
   #FUN-BB0018 add by suncx end------------------------
  #LET g_str = tm.wc1," AND ",tm.wc2," AND ",tm.wc3  #FUN-BC0026 mark
  #FUN-BC0026 add START
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc1,'azp01')
      RETURNING tm.wc1
      CALL cl_wcchp(tm.wc2,'ima131,ima01')
      RETURNING tm.wc2
      CALL cl_wcchp(tm.wc3,'img02')
      RETURNING tm.wc3
      LET g_str =tm.wc1," AND ",tm.wc2," AND ",tm.wc3
      IF g_str.getLength() > 1000 THEN
         LET g_str = g_str.subString(1,600)
         LET g_str = g_str,"..."
      END IF
   END IF
  #FUN-BC0026 add END
   LET g_str = g_str,";",tm.w,";",tm.x    #FUN-BB0018
   CASE
      WHEN tm.a='1'
         CALL cl_prt_cs3('artr200','artr200_1',l_sql,g_str)  
      WHEN tm.a='2'
         CALL cl_prt_cs3('artr200','artr200_2',l_sql,g_str) 
      WHEN tm.a='3'
         CALL cl_prt_cs3('artr200','artr200_3',l_sql,g_str) 
   END CASE
END FUNCTION 
#FUN-A80082
