# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aapg824.4gl
# Descriptions...: 信用狀到單作業列印
# Date & Author..: FUN-B40092 11/07/30  By  xujing
# Modify.........: FUN-BB0047 11/12/31  By  fengrui 調整時間函數問題
# Modify.........: MOD-C30574 12/03/12  By  xuxz  GR報表添加部門名稱顯示
# Modify.........: No.FUN-C40019 12/04/09 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片 
# Modify.........: No.FUN-C50003 12/05/02 By yangtt GR程式優化
# Modify.........: NO.FUN-C30085 12/06/26 By nanbing 追單MOD-C10016，TQC-BC0013
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   
              wc      LIKE type_file.chr1000,            
              more    LIKE type_file.chr1     
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose 
#FUN-710091  --begin
DEFINE g_sql      STRING
DEFINE l_table    STRING

TYPE sr1_t RECORD 
     alh00          LIKE alh_file.alh00,   
     alh021         LIKE alh_file.alh021, 
     alh45          LIKE alh_file.alh45, 
     alh01          LIKE alh_file.alh01, 
     alh02          LIKE alh_file.alh02, 
     alh72          LIKE alh_file.alh72, 
     alh10          LIKE alh_file.alh10,
     alh44          LIKE alh_file.alh44,  
     alhfirm        LIKE alh_file.alhfirm,
     nne01          LIKE nne_file.nne01,
     alh52          LIKE alh_file.alh52,
     pmc03_1        LIKE pmc_file.pmc03,
     pmc03_2        LIKE pmc_file.pmc03, 
     alh51          LIKE alh_file.alh51,
     alh75          LIKE alh_file.alh75,  
     alh03          LIKE alh_file.alh03, 
     alh06          LIKE alh_file.alh06,   
     alh11          LIKE alh_file.alh11,  
     alh50          LIKE alh_file.alh50, 
     alh07          LIKE alh_file.alh07,
     alh12          LIKE alh_file.alh12,  
     alh18          LIKE alh_file.alh18, 
     alh08          LIKE alh_file.alh08,
     alh13          LIKE alh_file.alh13,  
     alh05          LIKE alh_file.alh05, 
     alh09          LIKE alh_file.alh09,
     alh14          LIKE alh_file.alh14,
     alh04          LIKE alh_file.alh04,
     alh15          LIKE alh_file.alh15,
     alh16          LIKE alh_file.alh16, 
     alh19          LIKE alh_file.alh19,
     alh17          LIKE alh_file.alh17,   
     alh76          LIKE alh_file.alh76,  
     alh77          LIKE alh_file.alh77, 
     alh74          LIKE alh_file.alh74,
     sign_type      LIKE type_file.chr1,     #FUN-C40019 add
     sign_img       LIKE type_file.blob,      #FUN-C40019 add
     sign_show      LIKE type_file.chr1,     #FUN-C40019 add
     sign_str       LIKE type_file.chr1000    #FUN-C40019 add 
     ,pma02         LIKE pma_file.pma02, #FUN-C30085 add
     t_azi04        LIKE azi_file.azi04  #FUN-C30085 add
           END RECORD

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
#   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119  #FUN-BB0047 mark
 
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
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

   LET g_sql=   "alh00.alh_file.alh00,alh021.alh_file.alh021,alh45.alh_file.alh45,",
                "alh01.alh_file.alh01,alh02.alh_file.alh02,alh72.alh_file.alh72,",
                "alh10.alh_file.alh10,alh44.alh_file.alh44,alhfirm.alh_file.alhfirm,",
                "nne01.nne_file.nne01,alh52.alh_file.alh52,pmc03_1.pmc_file.pmc03,",
                "pmc03_2.pmc_file.pmc03,alh51.alh_file.alh51,alh75.alh_file.alh75,",
                "alh03.alh_file.alh03,alh06.alh_file.alh06,alh11.alh_file.alh11,",
                "alh50.alh_file.alh50,alh07.alh_file.alh07,alh12.alh_file.alh12,",
                "alh18.alh_file.alh18,alh08.alh_file.alh08,alh13.alh_file.alh13,",
                "alh05.alh_file.alh05,alh09.alh_file.alh09,alh14.alh_file.alh14,",
                "alh04.alh_file.alh04,alh15.alh_file.alh15,alh16.alh_file.alh16,",
                "alh19.alh_file.alh19,alh17.alh_file.alh17,alh76.alh_file.alh76,",
                "alh77.alh_file.alh77,alh74.alh_file.alh74,",
                "sign_type.type_file.chr1,   sign_img.type_file.blob,",   #簽核方式, 簽核圖檔  #FUN-C40019 add
                "sign_show.type_file.chr1,  sign_str.type_file.chr1000"                        #FUN-C40019 add  
                ,",pma02.pma_file.pma02,t_azi04.azi_file.azi04"         #FUN-C30085
   LET l_table = cl_prt_temptable('aapg824',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
         

         
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-BB0047 ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g824_tm(0,0)        # Input print condition
      ELSE CALL g824()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)
END MAIN

FUNCTION g824_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      
   DEFINE p_row,p_col    LIKE type_file.num5,      
          l_cmd          LIKE type_file.chr1000  
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW g824_w AT p_row,p_col WITH FORM "aap/42f/aapg824"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON alh01,alh021,alh02
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
      LET INT_FLAG = 0 CLOSE WINDOW g824_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME  tm.more WITHOUT DEFAULTS
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
      LET INT_FLAG = 0 CLOSE WINDOW g824_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aapg824'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapg824','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
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
         CALL cl_cmdat('aapg824',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g824_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g824()
   ERROR ""
END WHILE
   CLOSE WINDOW g824_w
END FUNCTION


FUNCTION g824()
   DEFINE  l_name      LIKE type_file.chr20,         # External(Disk) file name   
           l_time      LIKE type_file.chr8,          # Used time for running the job
           l_sql       LIKE type_file.chr1000      # RDSQL STATEMENT
   DEFINE  l_pmc03_1   LIKE pmc_file.pmc03
   DEFINE  l_pmc03_2   LIKE pmc_file.pmc03
   DEFINE  l_no        LIKE apa_file.apa01
   DEFINE        sr        RECORD LIKE alh_file.*
   DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add
   #FUN-C30085---add---str---               
   DEFINE l_pma02 LIKE pma_file.pma02
   DEFINE l_t_azi04 LIKE azi_file.azi04
   #FUN-C30085---add---end---
          LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add

          SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
          CALL cl_del_data(l_table)
          LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"   #FUN-C40019 add 4? #FUN-C30085 add 2?
          PREPARE insert_prep FROM g_sql
          IF STATUS THEN
          CALL cl_err("insert_prep:",STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          EXIT PROGRAM
          END IF
          LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmiuser', 'pmigrup')
          
        # LET l_sql = "SELECT * FROM alh_file WHERE ",tm.wc CLIPPED               #FUN-C50003 mark
          LET l_sql = "SELECT alh_file.*,nne01 ",                        #FUN-C50003 add
                      "  FROM alh_file LEFT OUTER JOIN nne_file ON alh01 = nne28",   #FUN-C50003 add
                      "  WHERE ",tm.wc CLIPPED                                    #FUN-C50003 add
          
          PREPARE g824_prepare1 FROM l_sql
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare:',SQLCA.sqlcode,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time
             CALL cl_gre_drop_temptable(l_table)
             EXIT PROGRAM
          END IF
          DECLARE g824_curs1 CURSOR FOR g824_prepare1
          FOREACH g824_curs1 INTO sr.*,l_no     #FUN-C50003 add l_no
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
         #FUN-C50003----mark----str---
         #SELECT nne01 INTO l_no FROM nne_file
         #WHERE nne28=sr.alh01
         #FUN-C50003----mark----end---
          SELECT pmc03 INTO l_pmc03_1 FROM pmc_file
          WHERE pmc01 = sr.alh05
          #-FUN-C30085-add-
          LET l_pmc03_2 = ''
          IF sr.alh44 = '2' THEN   #付款方式為2.轉融資
             SELECT alg02 INTO l_pmc03_2
               FROM alg_file 
              WHERE alg01 = sr.alh06
          ELSE
         #-FUN-C30085-end-
             SELECT pmc03 INTO l_pmc03_2 FROM pmc_file
              WHERE pmc01 = sr.alh06
          END IF    #FUN-C30085 
          #FUN-C30085---add---str---
          LET l_pma02 = ''
          SELECT pma02 INTO l_pma02 FROM pma_file
           WHERE pma01 = sr.alh10

          LET l_t_azi04 = 0
          SELECT azi04 INTO l_t_azi04 FROM azi_file
           WHERE azi01 = sr.alh11
         #FUN-C30085---add---end--- 
          EXECUTE insert_prep USING sr.alh00,sr.alh021,sr.alh45,sr.alh01,sr.alh02,
                                    sr.alh72,sr.alh10,sr.alh44,sr.alhfirm,l_no,
                                    sr.alh52,l_pmc03_1,l_pmc03_2,sr.alh51,sr.alh75,
                                    sr.alh03,sr.alh06,sr.alh11,sr.alh50,sr.alh07,
                                    sr.alh12,sr.alh18,sr.alh08,sr.alh13,sr.alh05,
                                    sr.alh09,sr.alh14,sr.alh04,sr.alh15,sr.alh16,
                                    sr.alh19,sr.alh17,sr.alh76,sr.alh77,sr.alh74,   
                                    "",        l_img_blob,    "N",           ""    #FUN-C40019 add
                                    ,l_pma02,t_azi04               #FUN-C30085 add
     END FOREACH
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapg824'
     CALL cl_wcchp(tm.wc,'alh01,alh021,alh02') RETURNING tm.wc
     LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
     LET g_cr_apr_key_f = "alh01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add 
     CALL aapg824_grdata()
END FUNCTION

FUNCTION aapg824_grdata()
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
        LET handler = cl_gre_outnam("aapg824")
        IF handler IS NOT NULL THEN
            START REPORT aapg824_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY alh01"
          
            DECLARE aapg824_datacur1 CURSOR FROM l_sql
            FOREACH aapg824_datacur1 INTO sr1.*
                OUTPUT TO REPORT aapg824_rep(sr1.*)
            END FOREACH
            FINISH REPORT aapg824_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

 REPORT aapg824_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_alh05_pmc03_1  STRING  #FUN-C30085 LIKE pmc_file.pmc03 ->STRING
    DEFINE l_alh05_pmc03_12 STRING  #FUN-C30085 LIKE pmc_file.pmc03 ->STRING
    DEFINE l_alh05_pmc03_13 STRING  #FUN-C30085 LIKE pmc_file.pmc03 ->STRING
    DEFINE l_alh06_pmc03_2  STRING  #FUN-C30085 LIKE pmc_file.pmc03 ->STRING
    DEFINE l_alh00_1        STRING
    DEFINE l_alh00_alh00_1  STRING
    DEFINE l_alh51_1        STRING
    DEFINE l_alh51_alh51_1  STRING
    DEFINE l_alh75_1        STRING
    DEFINE l_alh75_alh75_1  STRING
    DEFINE l_display        STRING
    DEFINE l_gem02          LIKE gem_file.gem02 #MOD-C30574 add


    ORDER EXTERNAL BY sr1.alh01

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name

        BEFORE GROUP OF sr1.alh01
            LET l_lineno = 0

            IF cl_null(sr1.alh18) THEN
               LET l_display = 'N '
            ELSE
               LET l_display = 'Y '
            END IF
            PRINTX l_display

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            
            LET l_alh05_pmc03_1 = sr1.alh05,' ',sr1.pmc03_1
            LET l_alh05_pmc03_12 = sr1.alh05,' ',sr1.pmc03_1
            LET l_alh05_pmc03_13 = sr1.alh05,' ',sr1.pmc03_1
            LET l_alh06_pmc03_2 = sr1.alh06,' ',sr1.pmc03_2
            PRINTX l_alh05_pmc03_1
            PRINTX l_alh05_pmc03_12
            PRINTX l_alh05_pmc03_13
            PRINTX l_alh06_pmc03_2
            IF sr1.alh00 = '1' THEN
               LET l_alh00_1 = cl_gr_getmsg("gre-009",g_lang,'1')
            ELSE
               LET l_alh00_1 = cl_gr_getmsg("gre-009",g_lang,'0')
            END IF
            PRINTX l_alh00_1

            LET l_alh00_alh00_1 = sr1.alh00,' ',l_alh00_1
            PRINTX l_alh00_alh00_1

            IF sr1.alh51 = '1' THEN
               LET l_alh51_1 = cl_gr_getmsg("gre-041",g_lang,'1')
            ELSE
               LET l_alh51_1 = cl_gr_getmsg("gre-041",g_lang,'2')
            END IF
            PRINTX l_alh51_1

            LET l_alh51_alh51_1 = sr1.alh51,' ',l_alh51_1
            PRINTX l_alh51_alh51_1

            IF sr1.alh75 = '1' THEN
               LET l_alh75_1 = cl_gr_getmsg("gre-040",g_lang,'1')
            ELSE
               LET l_alh75_1 = cl_gr_getmsg("gre-040",g_lang,'0')
            END IF
            PRINTX l_alh75_1

            LET l_alh75_alh75_1 = sr1.alh75,' ',l_alh75_1
            PRINTX l_alh75_alh75_1

            #MOD-C30574--add--str
            LET l_gem02 =  ''
            SELECT gem02 INTO l_gem02 FROM gem_file 
             WHERE gem01 = sr1.alh04
            LET l_gem02 = sr1.alh04 CLIPPED,'   ',l_gem02
            PRINTX l_gem02
            #MOD-C30574--add--end

            PRINTX sr1.*
            PRINTX tm.*

        AFTER GROUP OF sr1.alh01


        ON LAST ROW
END REPORT
#FUN-B40092
