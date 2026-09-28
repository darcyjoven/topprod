# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aapr824.4gl
# Descriptions...: 信用狀到單作業列印
# Date & Author..: No.FUN-B40092 11/07/30 by xujing
# Modify.........: No.FUN-BB0047 11/12/31 By fengrui 調整時間函數問題
# Modify.........: No:MOD-C10016 12/01/04 By Dido alh06 應依據 alh44 不同而抓取不同資料 
# Modify.........: No.TQC-C10034 12/01/18 By zhuhao CR報表簽核
# Modify.........: No:TQC-BC0013 12/02/10 By Elise  aapt820程式修改，增加說明欄位及修改金額進位、取位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   
              wc      STRING,                    #MOD-C10016 mod 1000 -> STRING            
              more    LIKE type_file.chr1     
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose 
#FUN-710091  --begin
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE g_str      STRING 



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
  # CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119  #FUN-BB0047 MARK

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
               #TQC-C10034---add---begin
                "sign_type.type_file.chr1,sign_img.type_file.blob,", 
                "sign_show.type_file.chr1,sign_str.type_file.chr1000,",
               #TQC-C10034---add---end
                "pma02.pma_file.pma02,",                              #TQC-BC0013 add pma02
                "gem02.gem_file.gem02,t_azi04.azi_file.azi04"         #TQC-BC0013

   LET l_table = cl_prt_temptable('aapr824',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF      
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r824_tm(0,0)        # Input print condition
      ELSE CALL r824()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION r824_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      
   DEFINE p_row,p_col    LIKE type_file.num5,      
          l_cmd          LIKE type_file.chr1000  
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW r824_w AT p_row,p_col WITH FORM "aap/42f/aapr824"
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
      LET INT_FLAG = 0 CLOSE WINDOW r824_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
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
      LET INT_FLAG = 0 CLOSE WINDOW r824_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file   
             WHERE zz01='aapr824'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr824','9031',1)
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
         CALL cl_cmdat('aapr824',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r824_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r824()
   ERROR ""
END WHILE
   CLOSE WINDOW r824_w
END FUNCTION

FUNCTION r824()
   DEFINE  l_name      LIKE type_file.chr20,         # External(Disk) file name   
           l_time      LIKE type_file.chr8,          # Used time for running the job
           l_sql       STRING      # RDSQL STATEMENT #MOD-C10016 mod 1000 -> STRING
   DEFINE  l_pmc03_1   LIKE pmc_file.pmc03
   DEFINE  l_pmc03_2   LIKE pmc_file.pmc03
   DEFINE  l_no        LIKE apa_file.apa01
   DEFINE        sr        RECORD LIKE alh_file.*
   #TQC-BC0013---add---str---               
   DEFINE l_pma02 LIKE pma_file.pma02
   DEFINE l_gem02 LIKE gem_file.gem02
   DEFINE l_t_azi04 LIKE azi_file.azi04
   #TQC-BC0013---add---end---
   #TQC-C10034--add--begin
   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY
   #TQC-C10034--add--end
          SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
          CALL cl_del_data(l_table)
          
          LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"   #TQC-C10034 add 4?    #TQC-BC0013 add ?,?,?
          PREPARE insert_prep FROM g_sql
          IF STATUS THEN
          CALL cl_err("insert_prep:",STATUS,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time
          EXIT PROGRAM
          END IF       
          
          LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmiuser', 'pmigrup')
          SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr824'
          
          LET l_sql = "SELECT * FROM alh_file WHERE ",tm.wc CLIPPED
          
          PREPARE r824_prepare1 FROM l_sql
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare:',SQLCA.sqlcode,1)
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
             EXIT PROGRAM
          END IF
     DECLARE r824_curs1 CURSOR FOR r824_prepare1
     FOREACH r824_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          SELECT nne01 INTO l_no FROM nne_file
          WHERE nne28=sr.alh01
          SELECT pmc03 INTO l_pmc03_1 FROM pmc_file
          WHERE pmc01 = sr.alh05
         #-MOD-C10016-add-
          LET l_pmc03_2 = ''
          IF sr.alh44 = '2' THEN   #付款方式為2.轉融資
             SELECT alg02 INTO l_pmc03_2
               FROM alg_file 
              WHERE alg01 = sr.alh06
          ELSE
         #-MOD-C10016-end-
             SELECT pmc03 INTO l_pmc03_2 
               FROM pmc_file
              WHERE pmc01 = sr.alh06
          END IF    #MOD-C10016
         #TQC-BC0013---add---str---
          LET l_pma02 = ''
          SELECT pma02 INTO l_pma02 FROM pma_file
           WHERE pma01 = sr.alh10

          LET l_gem02 = ''
          SELECT gem02 INTO l_gem02 FROM gem_file
           WHERE gem01 = sr.alh04

          LET l_t_azi04 = 0
          SELECT azi04 INTO l_t_azi04 FROM azi_file
           WHERE azi01 = sr.alh11
         #TQC-BC0013---add---end--- 
          EXECUTE insert_prep USING sr.alh00,sr.alh021,sr.alh45,sr.alh01,sr.alh02,
                                    sr.alh72,sr.alh10,sr.alh44,sr.alhfirm,l_no,
                                    sr.alh52,l_pmc03_1,l_pmc03_2,sr.alh51,sr.alh75,
                                    sr.alh03,sr.alh06,sr.alh11,sr.alh50,sr.alh07,
                                    sr.alh12,sr.alh18,sr.alh08,sr.alh13,sr.alh05,
                                    sr.alh09,sr.alh14,sr.alh04,sr.alh15,sr.alh16,
                                    sr.alh19,sr.alh17,sr.alh76,sr.alh77,sr.alh74,
                                    "",  l_img_blob,   "N","",            #TQC-C10034  add  
                                    l_pma02,l_gem02,t_azi04               #TQC-BC0013 add l_pma02,l_gem02,t_azi04
     END FOREACH
     
     CALL cl_wcchp(tm.wc,'alh01,alh021,alh02') RETURNING tm.wc 
     LET g_str = tm.wc,";",g_zz05
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #TQC-C10034--add--begin
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "alh01" 
    #TQC-C10034--add--end
     CALL cl_prt_cs3('aapr824','aapr824',l_sql,g_str)
     
END FUNCTION
#FUN-B40092


