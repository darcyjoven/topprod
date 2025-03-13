# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: anmg606.4gl
# Descriptions...: 投資購買憑証列表
# Date & Author..: No.FUN-970003 09/07/13 By douzh
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40087 11/05/23 By yangtt  憑證報表轉GRW 
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/03 By minpp GR程式優化
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
 
###GENGRE###START
TYPE sr1_t RECORD
    gsh01 LIKE gsh_file.gsh01,
    gsh02 LIKE gsh_file.gsh02,
    gsh26 LIKE gsh_file.gsh26,
    gsh05 LIKE gsh_file.gsh05,
    gsh04 LIKE gsh_file.gsh04,
    gsh07 LIKE gsh_file.gsh07,
    gsh08 LIKE gsh_file.gsh08,
    gsh09 LIKE gsh_file.gsh09,
    gsh10 LIKE gsh_file.gsh10,
    gsh11 LIKE gsh_file.gsh11,
    gsh12 LIKE gsh_file.gsh12,
    gsh06 LIKE gsh_file.gsh06,
    gsh03 LIKE gsh_file.gsh03,
    gsh13 LIKE gsh_file.gsh13,
    gsh14 LIKE gsh_file.gsh14,
    gsh15 LIKE gsh_file.gsh15,
    gsh16 LIKE gsh_file.gsh16,
    gsh17 LIKE gsh_file.gsh17,
    gsh18 LIKE gsh_file.gsh18,
    gsh19 LIKE gsh_file.gsh19,
    gsh20 LIKE gsh_file.gsh20,
    gshconf LIKE gsh_file.gshconf,
    gsh21 LIKE gsh_file.gsh21,
    gsh22 LIKE gsh_file.gsh22,
    gsh27 LIKE gsh_file.gsh27,
    gsh28 LIKE gsh_file.gsh28,
    gsb05 LIKE gsb_file.gsb05,
    gsa02 LIKE gsa_file.gsa02,
    gsb06 LIKE gsb_file.gsb06,
    gsf02 LIKE gsf_file.gsf02,
    #FUN-C50007--ADD-STR
    nmc02 LIKE nmc_file.nmc02,
    nml02 LIKE nml_file.nml02,
    nmc02_1 LIKE nmc_file.nmc02,
    nml02_1 LIKE nml_file.nml02,
    #FUN-C50007--ADD-END
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD
###GENGRE###END

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
 
   LET g_prog = 'anmg606'
 
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
               "gsf02.gsf_file.gsf02,",
               
               
                #FUN-C50007--ADD-STR
                "nmc02.nmc_file.nmc02,",
                "nml02.nml_file.nml02,",
                "nmc02_1.nmc_file.nmc02,",
                "nml02_1.nml_file.nml02,",
                 #FUN-C50007--ADD-END
              
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add 
 
   LET l_table = cl_prt_temptable('anmg606',g_sql) CLIPPED 
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF    
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" #FUN-C40020 #FUN-C50007 ADD 4?
   PREPARE insert_prep FROM g_sql              
   IF STATUS THEN                              
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM    
   END IF                           
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL anmg606_tm()
   ELSE
      CALL anmg606()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION anmg606_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col   LIKE type_file.num5,  
          l_cmd         LIKE type_file.chr1000
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW anmg606_w AT p_row,p_col
     WITH FORM "anm/42f/anmg606"
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
         CLOSE WINDOW anmg606_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
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
         CLOSE WINDOW anmg606_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='anmg606'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmg606','9031',1)
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
            CALL cl_cmdat('anmg606',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW anmg606_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL anmg606()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW anmg606_w
 
END FUNCTION
 
FUNCTION anmg606()
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
   #FUN-C50007--ADD-STR
   DEFINE l_nmc02     LIKE nmc_file.nmc02
   DEFINE l_nmc02_1     LIKE nmc_file.nmc02
   DEFINE l_nml02     LIKE nml_file.nml02
   DEFINE l_nml02_1     LIKE nml_file.nml02
   #FUN-C50007--ADD-END
   DEFINE l_dbs1      LIKE type_file.chr21
   DEFINE l_dbs2      LIKE type_file.chr21 
   DEFINE l_prog      LIKE type_file.chr10  
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add                                             
     CALL cl_del_data(l_table)             
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 #LET l_sql = "SELECT gsh_file.*,'','','',''", #FUN-C50007--MARK
  LET l_sql = "SELECT gsh_file.*,gsb05,'',gsb06,gsf02,a.nmc02,a.nml02,b.nmc02,b.nml02 ", #FUN-C50007--add
           #  "  FROM gsh_file ",                #FUN-C50007--MARK
              "  FROM gsh_file LEFT OUTER JOIN gsb_file ON gsh03=gsb01  ",    #FUN-C50007
              "  LEFT OUTER JOIN gsf_file ON gsh13=gsf01 LEFT OUTER JOIN nmc_file a ON gsh10=a.nmc01 AND a.nmc03='2'", #FUN-C50007
              "  LEFT OUTER JOIN nml_file a ON gsh11=a.nml01 LEFT OUTER JOIN nmc_file b ON gsh17=b.nmc01 AND b.nmc03='2'", #FUN-C50007
              "  LEFT OUTER JOIN nml_file b ON gsh18=b.nml01 ", #FUN-C50007
              " WHERE ",tm.wc CLIPPED,
              " ORDER BY gsh01"
 
   PREPARE anmg606_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
   DECLARE anmg606_curs CURSOR FOR anmg606_prepare
 
   LET l_prog = g_prog    
   LET g_prog = 'anmg606' 
 
 # FOREACH anmg606_curs INTO sr.*                                       #FUN-C50007 MARK
   FOREACH anmg606_curs INTO sr.*,l_nmc02,l_nml02,l_nmc02_1,l_nml02_1   #FUN-C50007 ADD

      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
      END IF
 
     #FUN-C50007--MARK--str
     #SELECT gsb05,gsb06 INTO sr.gsb05,sr.gsb06
     #  FROM gsb_file
     # WHERE gsb01 = sr.gsh.gsh03
     #FUN-C50007--MARK--end 
     
       SELECT gsa02 INTO sr.gsa02
        FROM gsa_file
       WHERE gsa01 = sr.gsb05
     
     #FUN-C50007--MARK--str
     #SELECT gsf02 INTO sr.gsf02
     #  FROM gsf_file
     # WHERE gsf01 = sr.gsh.gsh13
     #FUN-C50007--mark--END
     
       EXECUTE insert_prep USING
         sr.gsh.gsh01,sr.gsh.gsh02,sr.gsh.gsh26,sr.gsh.gsh05,sr.gsh.gsh04,
         sr.gsh.gsh07,sr.gsh.gsh08,sr.gsh.gsh09,sr.gsh.gsh10,sr.gsh.gsh11,
         sr.gsh.gsh12,sr.gsh.gsh06,sr.gsh.gsh03,
         sr.gsh.gsh13,sr.gsh.gsh14,sr.gsh.gsh15,sr.gsh.gsh16,
         sr.gsh.gsh17,sr.gsh.gsh18,sr.gsh.gsh19,sr.gsh.gsh20,sr.gsh.gshconf,
         sr.gsh.gsh21,sr.gsh.gsh22,sr.gsh.gsh27,sr.gsh.gsh28,
         sr.gsb05,sr.gsa02,sr.gsb06,sr.gsf02,
         l_nmc02,l_nml02,l_nmc02_1,l_nml02_1, #FUN-C50007
         "",  l_img_blob,"N",""  # No.FUN-C40020 add
 
   END FOREACH
 
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                                   
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'gsh01') RETURNING tm.wc
     ELSE
        LET tm.wc = ' '
     END IF
 
###GENGRE###     LET g_str = tm.wc
 
###GENGRE###     CALL cl_prt_cs3('anmg606','anmg606',g_sql,g_str)                                                                                         
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "gsh01"                    # No.FUN-C40020 add
    CALL anmg606_grdata()    ###GENGRE###
 
END FUNCTION
#FUN-970003

###GENGRE###START
FUNCTION anmg606_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
    LOCATE sr1.sign_img IN MEMORY    # No.FUN-C40020 add
    CALL cl_gre_init_apr()           # No.FUN-C40020 add
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("anmg606")
        IF handler IS NOT NULL THEN
            START REPORT anmg606_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE anmg606_datacur1 CURSOR FROM l_sql
            FOREACH anmg606_datacur1 INTO sr1.*
                OUTPUT TO REPORT anmg606_rep(sr1.*)
            END FOREACH
            FINISH REPORT anmg606_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT anmg606_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-C50007--ADD--STR
    DEFINE l_gsh10_nmc02   STRING
    DEFINE l_gsh11_nml02   STRING
    DEFINE l_gsh17_nmc02_1 STRING
    DEFINE l_gsh18_nml02_1 STRING
    #FUN-C50007--ADD--END
    ORDER EXTERNAL BY sr1.gsh01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.gsh01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
 
            #FUN-C50007--ADD--STR
            LET l_gsh10_nmc02=sr1.gsh10,' ',sr1.nmc02
            PRINTX l_gsh10_nmc02
            LET l_gsh11_nml02=sr1.gsh11,' ',sr1.nml02
            PRINTX l_gsh11_nml02
            LET l_gsh17_nmc02_1=sr1.gsh17,' ',sr1.nmc02_1
            PRINTX l_gsh17_nmc02_1
            LET l_gsh18_nml02_1 =sr1.gsh18,' ',sr1.nml02_1
            PRINTX l_gsh18_nml02_1
            #FUN-C50007--ADD--END
            PRINTX sr1.*

        AFTER GROUP OF sr1.gsh01

        
        ON LAST ROW

END REPORT
#FUN-B40087
###GENGRE###END
