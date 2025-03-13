# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aapr711.4gl
# Descriptions...: 預購付款憑証列印作業 
# Date & Author..: No.FUN-840242 08/06/17 By xiaofeizhu
# Modify.........: No.MOD-880006 08/08/06 By Sarah l_sql不需串alb_file
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alaplant該為ala97
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: NO.TQC-BC0013 12/01/16 By Elise 加入外幣、本幣支付銀行ala81、ala91之簡稱t_nma02、g_nma02
# Modify.........: No.TQC-C10034 12/01/18 By zhuhao 報表簽核 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   
              wc      STRING,                            # Where condition   
              more    LIKE type_file.chr1                # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i         LIKE type_file.num5   
DEFINE   g_sma116    LIKE sma_file.sma116     
DEFINE   g_sma115    LIKE sma_file.sma115      
DEFINE   g_sql       STRING                                                                                                        
DEFINE   l_table     STRING                                                                                                        
DEFINE   g_str       STRING                                                                                                        
DEFINE   l_title1    STRING                                                                                                        
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 mark 
   
#  LET g_sql= "alaplant.ala_file.alaplant,",                   #No.FUN-980017
   LET g_sql= "ala97.ala_file.ala97,",                         #No.FUN-980017     
              "ala01.ala_file.ala01,",
              "ala02.ala_file.ala02,",
              "ala05.ala_file.ala05,",
              "ala07.ala_file.ala07,",
              "ala08.ala_file.ala08,",
              "ala96.ala_file.ala96,",
              "ala20.ala_file.ala20,",
              "ala51.ala_file.ala51,",
              "ala86.ala_file.ala86,",
              "ala04.ala_file.ala04,",
              "ala21.ala_file.ala21,",
              "ala34.ala_file.ala34,",
              "ala23.ala_file.ala23,",
              "ala80.ala_file.ala80,",
              "ala74.ala_file.ala74,",
              "ala81.ala_file.ala81,",
              "ala82.ala_file.ala82,",
              "ala83.ala_file.ala83,",
              "ala84.ala_file.ala84,",
              "ala85.ala_file.ala85,",
              "ala91.ala_file.ala91,",
              "ala92.ala_file.ala92,",
              "ala931.ala_file.ala931,",
              "ala76.ala_file.ala76,",
              "ala932.ala_file.ala932,",
              "ala93.ala_file.ala93,",
              "ala94.ala_file.ala94,",         
              "ala951.ala_file.ala951,",
              "ala952.ala_file.ala952,",
              "ala953.ala_file.ala953,",
              "ala95.ala_file.ala95,",
              "alafirm.ala_file.alafirm,",
              "alaclos.ala_file.alaclos,",
              "ala78.ala_file.ala78,",
              "t_azi04.azi_file.azi04,",
              "t_azi07.azi_file.azi07,",
              "alb08.alb_file.alb08,",
              "gem02.gem_file.gem02,",
              "nmc02.nmc_file.nmc02,",
              "t_nma02.nma_file.nma02,",     #TQC-BC0013 外幣銀行簡稱
              "g_nma02.nma_file.nma02,",     #TQC-BC0013 本幣銀行簡稱
              #TQC-C10034---add---begin
               "sign_type.type_file.chr1,", 
               "sign_img.type_file.blob,",      
               "sign_show.type_file.chr1,",
               "sign_str.type_file.chr1000"
              #TQC-C10034---add---end
 
   LET l_table = cl_prt_temptable('aapr711',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"            #TQC-BC0013 add ?,?   #TQC-C10034 add 4?                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add 
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
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r711_tm(0,0)              # Input print condition
      ELSE CALL r711()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION r711_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,   
          l_cmd        LIKE type_file.chr1000 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r711_w AT p_row,p_col
        WITH FORM "aap/42f/aapr711"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition                                                        
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ala01,ala02,ala04,ala05,ala08,ala07
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
      LET INT_FLAG = 0 CLOSE WINDOW r711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
 
   INPUT BY NAME 
                 tm.more
                 WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
         
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aapr711'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr711','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,       
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", 
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",         
                         " '",g_rep_clas CLIPPED,"'",          
                         " '",g_template CLIPPED,"'",         
                         " '",g_rpt_name CLIPPED,"'"          
         CALL cl_cmdat('aapr711',g_time,l_cmd)    
      END IF
      CLOSE WINDOW r711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r711()
   ERROR ""
END WHILE
   CLOSE WINDOW r711_w
END FUNCTION
 
FUNCTION r711()
   DEFINE l_name    LIKE type_file.chr20,      
          l_sql     STRING,                
#         sr        RECORD alaplant LIKE ala_file.alaplant,                 #No.FUN-980017
          sr        RECORD ala97 LIKE ala_file.ala97,                       #No.FUN-980017
                           ala01 LIKE ala_file.ala01,
                           ala02 LIKE ala_file.ala02,
                           ala05 LIKE ala_file.ala05,
                           ala07 LIKE ala_file.ala07,
                           ala08 LIKE ala_file.ala08,
                           ala96 LIKE ala_file.ala96,
                           ala20 LIKE ala_file.ala20,
                           ala51 LIKE ala_file.ala51,
                           ala86 LIKE ala_file.ala86,
                           ala04 LIKE ala_file.ala04,
                           ala21 LIKE ala_file.ala21,
                           ala34 LIKE ala_file.ala34,
                           ala23 LIKE ala_file.ala23,
                           ala80 LIKE ala_file.ala80,
                           ala74 LIKE ala_file.ala74,
                           ala81 LIKE ala_file.ala81,
                           ala82 LIKE ala_file.ala82,
                           ala83 LIKE ala_file.ala83,
                           ala84 LIKE ala_file.ala84,
                           ala85 LIKE ala_file.ala85,
                           ala91 LIKE ala_file.ala91,
                           ala92 LIKE ala_file.ala92,
                           ala931 LIKE ala_file.ala931,
                           ala76 LIKE ala_file.ala76,
                           ala932 LIKE ala_file.ala932,
                           ala93 LIKE ala_file.ala93,
                           ala94 LIKE ala_file.ala94,         
                           ala951 LIKE ala_file.ala951,
                           ala952 LIKE ala_file.ala952,
                           ala953 LIKE ala_file.ala953,
                           ala95 LIKE ala_file.ala95,
                           alafirm LIKE ala_file.alafirm,
                           alaclos LIKE ala_file.alaclos,
                           ala78 LIKE ala_file.ala78,
                           t_azi04 LIKE azi_file.azi04,
                           t_azi07 LIKE azi_file.azi07,
                           alb08 LIKE alb_file.alb08,
                           gem02 LIKE gem_file.gem02,
                           nmc02 LIKE nmc_file.nmc02   
                      END RECORD
     DEFINE t_nma02 LIKE nma_file.nma02       #TQC-BC0013 add
     DEFINE g_nma02 LIKE nma_file.nma02       #TQC-BC0013 add
     #TQC-C10034--add--begin
     DEFINE l_img_blob     LIKE type_file.blob
     LOCATE l_img_blob IN MEMORY
     #TQC-C10034--add--end 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr711'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                          
     CALL cl_del_data(l_table)
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND alauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND alagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    
     #         LET tm.wc = tm.wc clipped," AND alagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup')
     #End:FUN-980030
 
#    LET l_sql = "SELECT alaplant,ala01,ala02,ala05,ala07,ala08,ala96,ala20,",           #No.FUN-980017
     LET l_sql = "SELECT ala97,ala01,ala02,ala05,ala07,ala08,ala96,ala20,",              #No.FUN-980017
                 " ala51,ala86,ala04,ala21,ala34,ala23,ala80,ala74,",
                 " ala81,ala82,ala83,ala84,ala85,ala91,ala92,ala931, ",
                 " ala76,ala932,ala93,ala94,ala951,ala952,ala953,ala95,",
                #" alafirm, alaclos,ala78,'','',alb08,'',''",  #MOD-880006 mark
                 " alafirm, alaclos,ala78,'','','','',''",     #MOD-880006
                #" FROM ala_file, alb_file",                   #MOD-880006 mark
                 " FROM ala_file",                             #MOD-880006
                #" WHERE alb01 = ala01 ",      # 開狀單號      #MOD-880006 mark
                 " WHERE ", tm.wc CLIPPED
 
     PREPARE r711_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM
     END IF
     DECLARE r711_curs1 CURSOR FOR r711_prepare1
                                          
     FOREACH r711_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
 
          SELECT azi04,azi07 INTO sr.t_azi04,sr.t_azi07 
            FROM azi_file
           WHERE azi01 = sr.ala20
           
          SELECT gem02 INTO sr.gem02
            FROM gem_file
           WHERE gem01 = sr.ala04
           
          SELECT nmc02 INTO sr.nmc02
            FROM nmc_file
           WHERE nmc01 = sr.ala96
             AND nmc03 = '2'

      #TQC-BC0013---add---str---
      LET t_nma02 = ''
      SELECT nma02 INTO t_nma02 FROM nma_file
       WHERE nma01=sr.ala81

      LET g_nma02 = ''
      SELECT nma02 INTO g_nma02 FROM nma_file
       WHERE nma01=sr.ala91
      #TQC-BC0013---add---end---   
        
      EXECUTE insert_prep USING
#                         sr.alaplant,sr.ala01,sr.ala02,sr.ala05,sr.ala07,sr.ala08,sr.ala96,sr.ala20,            #No.FUN-980017
                          sr.ala97,sr.ala01,sr.ala02,sr.ala05,sr.ala07,sr.ala08,sr.ala96,sr.ala20,               #No.FUN-980017
                          sr.ala51,sr.ala86,sr.ala04,sr.ala21,sr.ala34,sr.ala23,sr.ala80,sr.ala74,
                          sr.ala81,sr.ala82,sr.ala83,sr.ala84,sr.ala85,sr.ala91,sr.ala92,sr.ala931,
                          sr.ala76,sr.ala932,sr.ala93,sr.ala94,sr.ala951,sr.ala952,sr.ala953,sr.ala95,
                          sr.alafirm,sr. alaclos,sr.ala78,sr.t_azi04,sr.t_azi07,sr.alb08,sr.gem02,sr.nmc02,
                          t_nma02,g_nma02,    #No.TQC-BC0013 add t_nma02, g_nma022
                          "",  l_img_blob,   "N",""              #TQC-C10034  add 
     END FOREACH
 
     IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'ala01,ala02,ala04,ala05,ala08,ala07')                                     
        RETURNING tm.wc                                                                                                             
        LET g_str =tm.wc                                                                                                            
     END IF                                                                                                                         
     LET g_str =g_str,";",g_azi04                                             
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED      
     #TQC-C10034--add--begin
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "ala01" 
     #TQC-C10034--add--end                                                         
     CALL cl_prt_cs3('aapr711','aapr711',g_sql,g_str)
 
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80105 MARK
END FUNCTION
 
#No.FUN-840242 
