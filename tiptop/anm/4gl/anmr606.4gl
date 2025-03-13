# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: anmr606.4gl
# Descriptions...: 投資購買憑証列表
# Date & Author..: No.FUN-970003 09/07/13 By douzh
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
               wc      STRING,
               more    LIKE type_file.chr1  
           END RECORD
DEFINE g_i           LIKE type_file.num5   
DEFINE g_msg         LIKE type_file.chr1000
DEFINE l_table       STRING                 
DEFINE g_sql         STRING                 
DEFINE g_str         STRING                
DEFINE g_flag        LIKE   type_file.chr1 
DEFINE g_gsh01       LIKE   gsh_file.gsh01
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_gsh01 = ARG_VAL(7)
   LET tm.more = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)
 
   LET g_prog = 'anmr606'
 
   IF NOT cl_null (g_gsh01) THEN
      LET tm.wc = " gsh01 = '",g_gsh01,"' "
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_sql = "gsh01.gsh_file.gsh01,",
               "gsh02.gsh_file.gsh02,",
               "gsh26.gsh_file.gsh26,",
               "gsh05.gsh_file.gsh05,",
               "gsh04.gsh_file.gsh04,",
               "gsh07.gsh_file.gsh07,",
               "gsh08.gsh_file.gsh08,",
               "gsh09.gsh_file.gsh09,",
               "gsh10.gsh_file.gsh10,",
               "gsh11.gsh_file.gsh11,",
               "gsh12.gsh_file.gsh12,",
               "gsh06.gsh_file.gsh06,",
               "gsh03.gsh_file.gsh03,",
               "gsh13.gsh_file.gsh13,",
               "gsh14.gsh_file.gsh14,",
               "gsh15.gsh_file.gsh15,",
               "gsh16.gsh_file.gsh16,",
               "gsh17.gsh_file.gsh17,",
               "gsh18.gsh_file.gsh18,",
               "gsh19.gsh_file.gsh19,",
               "gsh20.gsh_file.gsh20,",
               "gshconf.gsh_file.gshconf,",
               "gsh21.gsh_file.gsh21,",
               "gsh22.gsh_file.gsh22,",
               "gsh27.gsh_file.gsh27,",
               "gsh28.gsh_file.gsh28,",                                               
               "gsb05.gsb_file.gsb05,",
               "gsa02.gsa_file.gsa02,",
               "gsb06.gsb_file.gsb06,",
               "gsf02.gsf_file.gsf02,",  #No.TQC-C10034 add , ,
               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add 
 
   LET l_table = cl_prt_temptable('anmr606',g_sql) CLIPPED 
   IF l_table = -1 THEN EXIT PROGRAM END IF    
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,
                        ?,?,?,?,?,?,?,?,?,? ,?,?,?,?)"   #No.TQC-C10034 add 4?
   PREPARE insert_prep FROM g_sql              
   IF STATUS THEN                              
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM    
   END IF                           
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL anmr606_tm()
   ELSE
      CALL anmr606()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION anmr606_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col   LIKE type_file.num5,  
          l_cmd         LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW anmr606_w AT p_row,p_col
     WITH FORM "anm/42f/anmr606"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON gsh01
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gshuser', 'gshgrup') #FUN-980030
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr606_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE 
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
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
         LET INT_FLAG = 0
         CLOSE WINDOW anmr606_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='anmr606'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmr606','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        " '",g_rlang CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.more CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'"
            CALL cl_cmdat('anmr606',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW anmr606_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL anmr606()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW anmr606_w
 
END FUNCTION
 
FUNCTION anmr606()
   DEFINE l_name      LIKE type_file.chr20, 
          l_buf       LIKE type_file.chr1000,
          l_sql       STRING,
          sr          RECORD
                         gsh      RECORD LIKE gsh_file.*,
                         gsb05    LIKE gsb_file.gsb05,
                         gsa02    LIKE gsa_file.gsa02,
                         gsb06    LIKE gsb_file.gsb06,
                         gsf02    LIKE gsf_file.gsf02 
                      END RECORD
   DEFINE l_dbs1      LIKE type_file.chr21
   DEFINE l_dbs2      LIKE type_file.chr21 
   DEFINE l_prog      LIKE type_file.chr10  
   DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
   LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
                                             
     CALL cl_del_data(l_table)             
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
  LET l_sql = "SELECT gsh_file.*,'','','',''",
               "  FROM gsh_file",
               " WHERE ",tm.wc CLIPPED,
               " ORDER BY gsh01"
 
   PREPARE anmr606_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
 
   DECLARE anmr606_curs CURSOR FOR anmr606_prepare
 
   LET l_prog = g_prog    
   LET g_prog = 'anmr606' 
 
   FOREACH anmr606_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
      END IF
 
      SELECT gsb05,gsb06 INTO sr.gsb05,sr.gsb06
        FROM gsb_file
       WHERE gsb01 = sr.gsh.gsh03
 
      SELECT gsa02 INTO sr.gsa02
        FROM gsa_file
       WHERE gsa01 = sr.gsb05
   
      SELECT gsf02 INTO sr.gsf02
        FROM gsf_file
       WHERE gsf01 = sr.gsh.gsh13
      
      EXECUTE insert_prep USING
         sr.gsh.gsh01,sr.gsh.gsh02,sr.gsh.gsh26,sr.gsh.gsh05,sr.gsh.gsh04,
         sr.gsh.gsh07,sr.gsh.gsh08,sr.gsh.gsh09,sr.gsh.gsh10,sr.gsh.gsh11,
         sr.gsh.gsh12,sr.gsh.gsh06,sr.gsh.gsh03,
         sr.gsh.gsh13,sr.gsh.gsh14,sr.gsh.gsh15,sr.gsh.gsh16,
         sr.gsh.gsh17,sr.gsh.gsh18,sr.gsh.gsh19,sr.gsh.gsh20,sr.gsh.gshconf,
         sr.gsh.gsh21,sr.gsh.gsh22,sr.gsh.gsh27,sr.gsh.gsh28,
         sr.gsb05,sr.gsa02,sr.gsb06,sr.gsf02
         ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add
 
   END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                                   
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'gsh01') RETURNING tm.wc
     ELSE
        LET tm.wc = ' '
     END IF
 
     LET g_str = tm.wc
     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
     LET g_cr_apr_key_f = "gsh01"             #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
     CALL cl_prt_cs3('anmr606','anmr606',g_sql,g_str)                                                                                         
 
END FUNCTION
#FUN-970003
