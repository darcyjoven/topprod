# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aapg711.4gl
# Descriptions...: 預購付款憑証列印作業 
# Date & Author..: No.FUN-840242 08/06/17 By xiaofeizhu
# Modify.........: No.MOD-880006 08/08/06 By Sarah l_sql不需串alb_file
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alaplant該為ala97
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40092 11/05/05 By xujing 憑證報表轉GRW 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.MOD-C30613 12/03/12 By xuxz GR顯示銀行名稱
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/04/28 By yangtt GR程式優化
# Modify.........: NO.FUN-C30085 12/06/25 By nanbing 加入外幣、本幣支付銀行ala81、ala91之簡稱t_nma02、g_nma02
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
 
###GENGRE###START
TYPE sr1_t RECORD
    ala97 LIKE ala_file.ala97,
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
    nmc02 LIKE nmc_file.nmc02,
    t_nma02 LIKE nma_file.nma02,     #FUN-C30085 外幣銀行簡稱
    g_nma02 LIKE nma_file.nma02,     #FUN-C30085 本幣銀行簡稱
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-B80105 

 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-BB0047 mark
   
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
              "t_nma02.nma_file.nma02,",     #FUN-C30085 外幣銀行簡稱
              "g_nma02.nma_file.nma02,",     #FUN-C30085 本幣銀行簡稱
              "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
              "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
              "sign_show.type_file.chr1,",                       #FUN-C40019 add
              "sign_str.type_file.chr1000"                       #FUN-C40019 add
 
   LET l_table = cl_prt_temptable('aapg711',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092  #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)              #FUN-B40092#FUN-C10036 mark
      EXIT PROGRAM 
   END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"       #FUN-C40019 add 4?  #FUN-C30085 add ?,?                                                                                                 
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      #CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092  #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)              #FUN-B40092#FUN-C10036 mark
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
                                                                                                                                    
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047
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
      THEN CALL g711_tm(0,0)              # Input print condition
      ELSE CALL g711()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
END MAIN
 
FUNCTION g711_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,   
          l_cmd        LIKE type_file.chr1000 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW g711_w AT p_row,p_col
        WITH FORM "aap/42f/aapg711"
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
      LET INT_FLAG = 0 CLOSE WINDOW g711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
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
      LET INT_FLAG = 0 CLOSE WINDOW g711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aapg711'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapg711','9031',1)
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
         CALL cl_cmdat('aapg711',g_time,l_cmd)    
      END IF
      CLOSE WINDOW g711_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g711()
   ERROR ""
END WHILE
   CLOSE WINDOW g711_w
END FUNCTION
 
FUNCTION g711()
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
     DEFINE t_nma02 LIKE nma_file.nma02       #FUN-C30085 add
     DEFINE g_nma02 LIKE nma_file.nma02       #FUN-C30085 add                      
     DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add

     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapg711'
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
                #" alafirm, alaclos,ala78,'','','','',''",     #MOD-880006         #FUN-C50003 mark
                 " alafirm, alaclos,ala78,azi04,azi07,'',gem02,nmc02",             #FUN-C50003 add
                #" FROM ala_file, alb_file",                   #MOD-880006 mark
                #" FROM ala_file",                             #MOD-880006         #FUN-C50003 mark
                 " FROM ala_file LEFT OUTER JOIN azi_file ON azi01 = ala20",       #FUN-C50003 add
                 " LEFT OUTER JOIN gem_file ON gem01 = ala04",                     #FUN-C50003 add
                 " LEFT OUTER JOIN nmc_file ON nmc01 = ala96 AND nmc03 = '2'",     #FUN-C50003 add
                #" WHERE alb01 = ala01 ",      # 開狀單號      #MOD-880006 mark
                 " WHERE ", tm.wc CLIPPED
 
     PREPARE g711_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
        EXIT PROGRAM
     END IF
     DECLARE g711_curs1 CURSOR FOR g711_prepare1
                                          
     FOREACH g711_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
 
#FUN-C50003-----mark---str--
#         SELECT azi04,azi07 INTO sr.t_azi04,sr.t_azi07 
#           FROM azi_file
#          WHERE azi01 = sr.ala20
#          
#         SELECT gem02 INTO sr.gem02
#           FROM gem_file
#          WHERE gem01 = sr.ala04
#          
#         SELECT nmc02 INTO sr.nmc02
#           FROM nmc_file
#          WHERE nmc01 = sr.ala96
#            AND nmc03 = '2'
#FUN-C50003-----mark---str--
      #FUN-C30085---add---str---
      LET t_nma02 = ''
      SELECT nma02 INTO t_nma02 FROM nma_file
       WHERE nma01=sr.ala81

      LET g_nma02 = ''
      SELECT nma02 INTO g_nma02 FROM nma_file
       WHERE nma01=sr.ala91
      #FUN-C30085---add---end---              
      EXECUTE insert_prep USING
#                         sr.alaplant,sr.ala01,sr.ala02,sr.ala05,sr.ala07,sr.ala08,sr.ala96,sr.ala20,            #No.FUN-980017
                          sr.ala97,sr.ala01,sr.ala02,sr.ala05,sr.ala07,sr.ala08,sr.ala96,sr.ala20,               #No.FUN-980017
                          sr.ala51,sr.ala86,sr.ala04,sr.ala21,sr.ala34,sr.ala23,sr.ala80,sr.ala74,
                          sr.ala81,sr.ala82,sr.ala83,sr.ala84,sr.ala85,sr.ala91,sr.ala92,sr.ala931,
                          sr.ala76,sr.ala932,sr.ala93,sr.ala94,sr.ala951,sr.ala952,sr.ala953,sr.ala95,
                          sr.alafirm,sr. alaclos,sr.ala78,sr.t_azi04,sr.t_azi07,sr.alb08,sr.gem02,sr.nmc02,
                          t_nma02,g_nma02,    #No.FUN-C30085 add t_nma02, g_nma02
                          "",l_img_blob,"N",""    #FUN-C40019 add
     END FOREACH
 
     IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'ala01,ala02,ala04,ala05,ala08,ala07')                                     
        RETURNING tm.wc                                                                                                             
        LET g_str =tm.wc                                                                                                            
     END IF                                                                                                                         
###GENGRE###     LET g_str =g_str,";",g_azi04                                             
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
###GENGRE###     CALL cl_prt_cs3('aapg711','aapg711',g_sql,g_str)
    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "ala01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
    CALL aapg711_grdata()    ###GENGRE###
 
    #   CALL  cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B80105 MARK
END FUNCTION
 
#No.FUN-840242 

###GENGRE###START
FUNCTION aapg711_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aapg711")
        IF handler IS NOT NULL THEN
            START REPORT aapg711_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ala01" 
            DECLARE aapg711_datacur1 CURSOR FROM l_sql
            FOREACH aapg711_datacur1 INTO sr1.*
                OUTPUT TO REPORT aapg711_rep(sr1.*)
            END FOREACH
            FINISH REPORT aapg711_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aapg711_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_ala80 STRING
    DEFINE l_ala80_1 STRING
    DEFINE l_ala85_ala95  LIKE ala_file.ala85
    DEFINE l_lineno       LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_ala84_fmt        STRING
    DEFINE l_ala34_fmt        STRING
    DEFINE l_ala85_fmt        STRING
    DEFINE l_ala94_fmt        STRING
    DEFINE l_ala951_fmt       STRING
    DEFINE l_ala952_fmt       STRING
    DEFINE l_ala953_fmt       STRING
    DEFINE l_ala95_fmt        STRING
    DEFINE l_ala85_ala95_fmt  STRING
    #FUN-B40092------add------end
    DEFINE l_nma03_1 LIKE nma_file.nma03 #MOD-C30613
    DEFINE l_nma03_2 LIKE nma_file.nma03 #MOD-C30613
    DEFINE l_ala82            STRING  #FUN-C30085 add
    DEFINE l_ala82_1          STRING  #FUN-C30085 add
    DEFINE l_ala92            STRING  #FUN-C30085 add
    DEFINE l_ala92_1          STRING  #FUN-C30085 add
    ORDER EXTERNAL BY sr1.ala01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ala01
            LET l_lineno = 0
            #FUN-B40092------add------str
            LET l_ala85_ala95 = sr1.ala85+sr1.ala95
            PRINTX l_ala85_ala95

            IF sr1.ala80 = '0' THEN
                LET l_ala80_1 = cl_gr_getmsg("gre-010",g_lang,'0')
                LET l_ala80 = '0',':',l_ala80_1
            ELSE
                LET l_ala80_1 = cl_gr_getmsg("gre-010",g_lang,'1')
                LET l_ala80 = '1',':',l_ala80_1
            END IF
            PRINTX l_ala80
            #FUN-C30085 add sta
            CASE 
               WHEN sr1.ala82 ='1' 
                  LET l_ala82_1 = cl_gr_getmsg("gre-019",g_lang,'1')
                  LET l_ala82 = '1',':',l_ala82_1
               WHEN sr1.ala82 ='2' 
                  LET l_ala82_1 = cl_gr_getmsg("gre-019",g_lang,'2')
                  LET l_ala82 = '2',':',l_ala82_1
               WHEN sr1.ala82 ='3' 
                  LET l_ala82_1 = cl_gr_getmsg("gre-019",g_lang,'3')
                  LET l_ala82 = '3',':',l_ala82_1 
               OTHERWISE 
                  LET l_ala82 = sr1.ala82
            END CASE  
            PRINTX l_ala82 
            CASE 
               WHEN sr1.ala92 ='1' 
                  LET l_ala92_1 = cl_gr_getmsg("gre-019",g_lang,'1')
                  LET l_ala92 = '1',':',l_ala92_1
               WHEN sr1.ala92 ='2' 
                  LET l_ala92_1 = cl_gr_getmsg("gre-019",g_lang,'2')
                  LET l_ala92 = '2',':',l_ala92_1
               WHEN sr1.ala92 ='3' 
                  LET l_ala92_1 = cl_gr_getmsg("gre-019",g_lang,'3')
                  LET l_ala92 = '3',':',l_ala92_1 
               OTHERWISE 
                  LET l_ala92 = sr1.ala92
            END CASE  
            PRINTX l_ala92 
            #FUN-C30085 add end 
            LET l_ala84_fmt = cl_gr_numfmt('ala_file','ala84',sr1.t_azi07)
            PRINTX l_ala84_fmt

            LET l_ala34_fmt = cl_gr_numfmt('ala_file','ala34',sr1.t_azi04)
            PRINTX l_ala34_fmt

            LET l_ala85_fmt = cl_gr_numfmt('ala_file','ala85',g_azi04)
            PRINTX l_ala85_fmt

            LET l_ala94_fmt = cl_gr_numfmt('ala_file','ala94',sr1.t_azi07)
            PRINTX l_ala94_fmt

            LET l_ala951_fmt = cl_gr_numfmt('ala_file','ala951',g_azi04)
            PRINTX l_ala951_fmt

            LET l_ala952_fmt = cl_gr_numfmt('ala_file','ala952',g_azi04)
            PRINTX l_ala952_fmt

            LET l_ala953_fmt = cl_gr_numfmt('ala_file','ala953',g_azi04)
            PRINTX l_ala953_fmt

            LET l_ala95_fmt = cl_gr_numfmt('ala_file','ala95',g_azi04)
            PRINTX l_ala95_fmt

            LET l_ala85_ala95_fmt = cl_gr_numfmt('ala_file','ala95',g_azi04)
            PRINTX l_ala85_ala95_fmt
            #FUN-B40092------add------end
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #MOD-C30613--add--str
            LET l_nma03_1 = ''
            LET l_nma03_2 = ''
            SELECT nma03 INTO l_nma03_1 FROM nma_file
             WHERE nma01 = sr1.ala81
            LET l_nma03_1 = sr1.ala81 CLIPPED,'   ',l_nma03_1
            PRINTX l_nma03_1
            SELECT nma03 INTO l_nma03_2 FROM nma_file
             WHERE nma01 = sr1.ala91
            LET l_nma03_2 = sr1.ala91 CLIPPED,'   ',l_nma03_2
            PRINTX l_nma03_2
            #MOD-C30613--add--end
            PRINTX sr1.*

        AFTER GROUP OF sr1.ala01

        
        ON LAST ROW

END REPORT
###GENGRE###END
