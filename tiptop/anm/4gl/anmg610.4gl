# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: anmg610.4gl
# Descriptions...: 票券外匯平倉憑証列印 
# Date & Author..: No.FUN-970003 09/07/13 By hongmei 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B20040 11/02/14 By Dido gse04~07 不需重新給值
# Modify.........: No.FUN-B40092 11/05/12 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50007 12/05/07 By minpp GR程序優化 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
               wc      STRING,
               more    LIKE type_file.chr1 
           END RECORD
DEFINE g_cnt   LIKE type_file.num5 
DEFINE g_i     LIKE type_file.num5 
DEFINE g_msg   LIKE type_file.chr1000 
DEFINE l_table       STRING
DEFINE g_sql         STRING
DEFINE g_str         STRING
DEFINE g_bookno1     LIKE aza_file.aza81
DEFINE g_bookno2     LIKE aza_file.aza82
DEFINE g_flag        LIKE type_file.chr1
DEFINE g_gse01       LIKE gse_file.gse01
 
###GENGRE###START
TYPE sr1_t RECORD
    gse01 LIKE gse_file.gse01,
    gse02 LIKE gse_file.gse02,
    gse03 LIKE gse_file.gse03,
    gse04 LIKE gse_file.gse04,
    gse05 LIKE gse_file.gse05,
    gse06 LIKE gse_file.gse06,
    gse07 LIKE gse_file.gse07,
    gse08 LIKE gse_file.gse08,
    gse09 LIKE gse_file.gse09,
    gse10 LIKE gse_file.gse10,
    gse11 LIKE gse_file.gse11,
    gse12 LIKE gse_file.gse12,
    gse13 LIKE gse_file.gse13,
    gse14 LIKE gse_file.gse14,
    gse15 LIKE gse_file.gse15,
    gse16 LIKE gse_file.gse16,
    gse17 LIKE gse_file.gse17,
    gse18 LIKE gse_file.gse18,
    gse19 LIKE gse_file.gse19,
    gse20 LIKE gse_file.gse20,
    gse21 LIKE gse_file.gse21,
    gse22 LIKE gse_file.gse22,
    gse23 LIKE gse_file.gse23,
    gse24 LIKE gse_file.gse24,
    gse25 LIKE gse_file.gse25,
    gse26 LIKE gse_file.gse26,
    gse27 LIKE gse_file.gse27,
    gseconf LIKE gse_file.gseconf,
    gseuser LIKE gse_file.gseuser,
    gsemodu LIKE gse_file.gsemodu,
    gsegrup LIKE gse_file.gsegrup,
    gsedate LIKE gse_file.gsedate,
    gsb05 LIKE gsb_file.gsb05,
    gsa02 LIKE gsa_file.gsa02,
    gsb06 LIKE gsb_file.gsb06,
    gsf02 LIKE gsf_file.gsf02,
    gem02 LIKE gem_file.gem02,  #FUN-C50007 ADD
    nmc02 LIKE nmc_file.nmc02,  #FUN-C50007 ADD
    nmc02_1 LIKE nmc_file.nmc02,#FUN-C50007 ADD
    nml02 LIKE nml_file.nml02,  #FUN-C50007 ADD
    nml02_1 LIKE nml_file.nml02,#FUN-C50007 ADD
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
   LET g_gse01  = ARG_VAL(7)
   LET tm.more = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)
 
   IF NOT cl_null(g_gse01) THEN
      LET tm.wc=" gse01='",g_gse01,"'"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_sql = "gse01.gse_file.gse01,",
               "gse02.gse_file.gse02,",
               "gse03.gse_file.gse03,",
               "gse04.gse_file.gse04,",
               "gse05.gse_file.gse05,",
               "gse06.gse_file.gse06,",
               "gse07.gse_file.gse07,",
               "gse08.gse_file.gse08,",
               "gse09.gse_file.gse09,",      
               "gse10.gse_file.gse10,",
               "gse11.gse_file.gse11,",
               "gse12.gse_file.gse12,",
               "gse13.gse_file.gse13,",
               "gse14.gse_file.gse14,",
               "gse15.gse_file.gse15,",
               "gse16.gse_file.gse16,",
               "gse17.gse_file.gse17,",
               "gse18.gse_file.gse18,",
               "gse19.gse_file.gse19,",
               "gse20.gse_file.gse20,",
               "gse21.gse_file.gse21,",
               "gse22.gse_file.gse22,",
               "gse23.gse_file.gse23,",
               "gse24.gse_file.gse24,",
               "gse25.gse_file.gse25,",
               "gse26.gse_file.gse26,",
               "gse27.gse_file.gse27,",
               "gseconf.gse_file.gseconf,",
               "gseuser.gse_file.gseuser,",
               "gsemodu.gse_file.gsemodu,",
               "gsegrup.gse_file.gsegrup,",
               "gsedate.gse_file.gsedate,",
               "gsb05.gsb_file.gsb05,",
               "gsa02.gsa_file.gsa02,",
               "gsb06.gsb_file.gsb06,",
               "gsf02.gsf_file.gsf02,",
               "gem02.gem_file.gem02,",   #FUN-C50007 ADD
               "nmc02.nmc_file.nmc02,",   #FUN-C50007 ADD
               "nmc02_1.nmc_file.nmc02,", #FUN-C50007 ADD
               "nml02.nml_file.nml02,",   #FUN-C50007 ADD
               "nml02_1.nml_file.nml02,", #FUN-C50007 ADD
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
                                               
   LET l_table = cl_prt_temptable('anmg610',g_sql) CLIPPED 
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM 
   END IF    
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",           # No.FUN-C40020 add4?
               "        ?,?,?,?,?)" #FUN-C50007 ADD 5?
   PREPARE insert_prep FROM g_sql              
   IF STATUS THEN                              
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40092
      CALL cl_gre_drop_temptable(l_table)              #FUN-B40092
      EXIT PROGRAM    
   END IF                           
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL anmg610_tm()
   ELSE
      CALL anmg610()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION anmg610_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col   LIKE type_file.num5,   
          l_cmd         LIKE type_file.chr1000 
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW anmg610_w AT p_row,p_col
     WITH FORM "anm/42f/anmg610"
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
 
      CONSTRUCT BY NAME tm.wc ON gse01
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('gseuser', 'gsegrup') #FUN-980030
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmg610_w
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
         CLOSE WINDOW anmr910_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='anmg610'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmg610','9031',1)
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
            CALL cl_cmdat('anmg610',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW anmg610_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL anmg610()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW anmg610_w
 
END FUNCTION
 
FUNCTION anmg610()
   DEFINE l_name      LIKE type_file.chr20,  
          l_buf       LIKE type_file.chr1000,
          l_sql       STRING,
          sr          RECORD
                         gse      RECORD LIKE gse_file.*,
                         gsb05    LIKE gsb_file.gsb05,
                         gsa02    LIKE gsa_file.gsa02,
                         gsb06    LIKE gsb_file.gsb06,
                         gsf02    LIKE gsf_file.gsf02,
                         gem02    LIKE gem_file.gem02,   #FUN-C50007 add
                         nmc02    LIKE nmc_file.nmc02,   #FUN-C50007 add
                         nmc02_1  LIKE nmc_file.nmc02,   #FUN-C50007 add
                         nml02    LIKE nml_file.nml02,   #FUN-C50007 add
                         nml02_1  LIKE nml_file.nml02    #FUN-C50007 add
                      END RECORD
  DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add                                           
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
  CALL cl_del_data(l_table)             
  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
 
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  #FUN-C50007--MOD--STR 
 #LET l_sql = "SELECT gse_file.*,'','','','' ",
 #             "  FROM gse_file",
  LET l_sql = "SELECT gse_file.*,gsb05,'',gsb06,gsf02,gem02,a.nmc02,b.nmc02,a.nml02,b.nml02",
               "  FROM gse_file LEFT OUTER JOIN gsb_file ON gse03=gsb01  AND gsbconf !='X' ",
               "  LEFT OUTER JOIN gsf_file ON gse13=gsf01 LEFT OUTER JOIN gem_file ON gse27=gem01",
               "  LEFT OUTER JOIN nmc_file a ON gse10=a.nmc01  AND a.nmc03='1' ",
               "  LEFT OUTER JOIN nmc_file b ON gse17=b.nmc01  AND b.nmc03='2' ",
               "  LEFT OUTER JOIN nml_file a ON gse11=a.nml01 ",
               "  LEFT OUTER JOIN nml_file b ON gse18=b.nml01",
  #FUN-C50007--MOD--END
               " WHERE ",tm.wc CLIPPED,
               " ORDER BY gse01"
 
   PREPARE anmg610_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
   DECLARE anmg610_curs CURSOR FOR anmg610_prepare
 
   FOREACH anmg610_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
     #-MOD-B20040-mark-
     #SELECT gsb05,gsb06,gsb09,gsb12,gsb121,gsb13
     #  INTO sr.gsb05,sr.gsb06,sr.gse.gse04,sr.gse.gse05,sr.gse.gse06,
     #       sr.gse.gse07
     #-MOD-B20040-end-

     #FUN-C50007--MARK--STR
     #SELECT gsb05,gsb06         #MOD-B20040
     #  INTO sr.gsb05,sr.gsb06   #MOD-B20040
     #  FROM gsb_file
     # WHERE gsb01 = sr.gse.gse03
     #   AND gsbconf !='X'
     #FUN-C50007--MARK--END

     SELECT gsa02 INTO sr.gsa02 FROM gsa_file
      WHERE gsa01 = sr.gsb05

    #FUN-C50007--MARK--STR 
    # SELECT gsf02 INTO sr.gsf02
    #   FROM gsf_file
    #  WHERE gsf01 = sr.gse.gse13
    # #FUN-C50007--MARK--END       
      EXECUTE insert_prep USING sr.gse.gse01,sr.gse.gse02,sr.gse.gse03,sr.gse.gse04,sr.gse.gse05,
                                sr.gse.gse06,sr.gse.gse07,sr.gse.gse08,sr.gse.gse09,sr.gse.gse10,
                                sr.gse.gse11,sr.gse.gse12,sr.gse.gse13,sr.gse.gse14,sr.gse.gse15,
                                sr.gse.gse16,sr.gse.gse17,sr.gse.gse18,sr.gse.gse19,sr.gse.gse20,
                                sr.gse.gse21,sr.gse.gse22,sr.gse.gse23,sr.gse.gse24,sr.gse.gse25,
                                sr.gse.gse26,sr.gse.gse27,sr.gse.gseconf,sr.gse.gseuser,sr.gse.gsemodu,
                                sr.gse.gsegrup,sr.gse.gsedate,sr.gsb05,sr.gsa02,sr.gsb06,
                                sr.gsf02 ,sr.gem02,sr.nmc02,sr.nmc02_1,sr.nml02,sr.nml02_1,    #FUN-C50007
                                "",  l_img_blob,"N",""  # No.FUN-C40020 add 
   END FOREACH
  
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'gse01') RETURNING tm.wc
   ELSE
      LET tm.wc = ' '
   END IF
   
###GENGRE###   LET g_str = tm.wc
###GENGRE###   CALL cl_prt_cs3('anmg610','anmg610',g_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "gse01"                    # No.FUN-C40020 add
    CALL anmg610_grdata()    ###GENGRE###
END FUNCTION
#FUN-970003

###GENGRE###START
FUNCTION anmg610_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
  
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("anmg610")
        IF handler IS NOT NULL THEN
            START REPORT anmg610_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY gse01"         
 
            DECLARE anmg610_datacur1 CURSOR FROM l_sql
            FOREACH anmg610_datacur1 INTO sr1.*
                OUTPUT TO REPORT anmg610_rep(sr1.*)
            END FOREACH
            FINISH REPORT anmg610_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT anmg610_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_gse27_gem02  STRING   #FUN-C50007
    DEFINE l_gse10_nmc02  STRING   #FUN-C50007
    DEFINE l_gse17_nmc02  STRING   #FUN-C50007
    DEFINE l_gse11_nml02  STRING   #FUN-C50007
    DEFINE l_gse18_nml02  STRING   #FUN-C50007
    ORDER EXTERNAL BY sr1.gse01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.gse01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            
           #FUN-C50007--ADD--str
            LET l_gse27_gem02 = sr1.gse27,' ',sr1.gem02  #FUN-C50007--ADD
            PRINTX l_gse27_gem02
            LET l_gse10_nmc02 = sr1.gse10,' ',sr1.nmc02
            PRINTX l_gse10_nmc02
            LET l_gse17_nmc02 = sr1.gse17,' ',sr1.nmc02_1
            PRINTX l_gse17_nmc02
            LET l_gse11_nml02 = sr1.gse11,' ',sr1.nml02
            PRINTX l_gse11_nml02
            LET l_gse18_nml02 = sr1.gse18,' ',sr1.nml02_1
            PRINTX l_gse18_nml02 
           #FUN-C50007--ADD--end  
            PRINTX sr1.*

        AFTER GROUP OF sr1.gse01

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-B40092
