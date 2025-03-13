# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aqcr301.4gl
# Descriptions...: 料件品質履歷報告
# Date & Author..: 96/09/23  By  Star
# Modify.........: 01/05/08 By Kammy
# Modify.........: No.FUN-4B0001 04/11/02 By Smapmin 料件編號,廠商編號,檢驗員開窗
# Modify.........: No.FUN-4C0099 05/01/28 By kim 報表轉XML功能
# Modify.........: No.TQC-590047 05/10/05 By kim 列印沒有公司名稱
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 修改單頭料件品名規格位置
# Modify.........: No.FUN-5C0078 05/12/20 By jackie 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.FUN-620041 06/03/24 By pengu測量值和上下限值沒有顯示小數位
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-770115 07/07/28 By pengu 當同一張收貨單分批QC時其列印資料會出現異常
# Modify.........: No.MOD-810105 08/03/24 By Pengu 各個檢驗測量值均相同
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850059 08/05/15 By Cockroach  報表轉CR   
#                                08/08/01 By Cockroach  21區追至31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30001 10/03/31 By Summer 將aqc-005改成apm-244
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              bdate   LIKE type_file.dat,          #No.FUN-680104 DATE
              edate   LIKE type_file.dat,          #No.FUN-680104 DATE
              ans     LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
              more    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
#No.FUN-850059 --ADD START--                                                                                                        
DEFINE   g_sql           STRING                                                                                                     
DEFINE   g_str           STRING                                                                                                     
DEFINE   l_table         STRING                                                                                                     
#No.FUN-850059 --ADD END--      
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
#No.FUN-850059 --ADD START--                                                                                                        
 LET g_sql =      "qcs01.qcs_file.qcs01,",                                                                                          
                  "qcs02.qcs_file.qcs02,",                                                                                          
                  "qcs05.qcs_file.qcs05,",                                                                                          
                  "qcs03.qcs_file.qcs03,",                                                                                          
                  "pmc03.pmc_file.pmc03,",                                                                                          
                  "qcs021.qcs_file.qcs021,",                                                                                        
                  "ima02.ima_file.ima02,",                                                                                          
                  "ima021.ima_file.ima021,",                                                                                        
                  "qcs04.qcs_file.qcs04,",                                                                                          
                  "qcs22.qcs_file.qcs22,",                                                                                          
                  "qcs091.qcs_file.qcs091,",                                                                                        
                  "qcs09.ze_file.ze03,",                                                                                            
                  "qcs13.gen_file.gen02,",                                                                                          
                  "qct02.qct_file.qct02,",                                                                                          
                  "qct03.qct_file.qct03,",                                                                                          
                  "qct04.qct_file.qct04,",                                                                                          
                  "azf03.azf_file.azf03,",                                                                                          
                  "qct11.qct_file.qct11,",                                                                                          
                  "qct07.qct_file.qct07,",                                                                                          
                  "qct08.qct_file.qct08,",                                                                                          
                  "qct131.qct_file.qct131,",  
                  "qct132.qct_file.qct132,",                                                                                        
                  "l_str1.type_file.chr1000 "                                                                                       
                                                                                                                                    
                                                                                                                                    
   LET l_table = cl_prt_temptable('aqcr301',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
#No.FUN-850059 --ADD END--                                                                                                          
                                                            
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690121
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(08)
   LET tm.edate  = ARG_VAL(09)
   LET tm.ans    = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r301_tm(0,0)
      ELSE CALL r301()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r301_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680104 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r301_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr301"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.ans  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON qcs021,qcs03,qcs13
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP    #FUN-4B0001
      CASE WHEN INFIELD(qcs021)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcs021
              NEXT FIELD qcs021
           WHEN INFIELD(qcs03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs3"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcs03
              NEXT FIELD qcs03
           WHEN INFIELD(qcs13)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs5"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcs13
              NEXT FIELD qcs13
      END CASE
 
   ON ACTION locale
      #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      LET g_action_choice = "locale"
      EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   ON ACTION exit
      LET INT_FLAG = 1
      EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   INPUT BY NAME tm.bdate,tm.edate,tm.ans,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF NOT cl_null(tm.edate) THEN
            IF tm.edate < tm.bdate THEN
               NEXT FIELD edate
            END IF
         END IF
 
      AFTER FIELD ans
         IF NOT cl_null(tm.ans) THEN
            IF tm.ans NOT MATCHES '[YN]' THEN
               NEXT FIELD ans
            END IF
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r301_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr301'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr301','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate    CLIPPED,"'",
                         " '",tm.edate    CLIPPED,"'",
                         " '",tm.ans CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aqcr301',g_time,l_cmd)
      END IF
      CLOSE WINDOW r301_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r301()
   ERROR ""
END WHILE
   CLOSE WINDOW r301_w
END FUNCTION
 
FUNCTION r301()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(40)
          sr               RECORD
                                  qcs01 LIKE qcs_file.qcs01,
                                  qcs02 LIKE qcs_file.qcs02,
                                  qcs05 LIKE qcs_file.qcs05,
                                  qcs03 LIKE qcs_file.qcs03,  #供應廠商
                                  pmc03 LIKE pmc_file.pmc03,  #供應廠商
                                  qcs021 LIKE qcs_file.qcs021,
                                  ima02 LIKE ima_file.ima02,
                                  qcs04 LIKE qcs_file.qcs04,
                                  qcs22 LIKE qcs_file.qcs22,
                                  qcs091 LIKE qcs_file.qcs091,
                                  qcs09 LIKE qcs_file.qcs09,
                                  qcs13 LIKE qcs_file.qcs13,
                                  qct02 LIKE qct_file.qct02,
                                  qct03 LIKE qct_file.qct03,    #No.MOD-810105 add
                                  qct04 LIKE qct_file.qct04,
                                  azf03 LIKE azf_file.azf03,
                                  qct11 LIKE qct_file.qct11,
                                  qct07 LIKE qct_file.qct07,
                                  qct08 LIKE qct_file.qct08,
                                  qct131 LIKE qct_file.qct131,
                                  qct132 LIKE qct_file.qct132,
                                  qctt04 LIKE qctt_file.qctt04
                        END RECORD
#No.FUN-850059 --ADD START--                                                                                                        
   DEFINE l_qcs09      LIKE ze_file.ze03,                                                                                           
          l_qcs13      LIKE gen_file.gen02,                                                                                         
          l_ima021     LIKE ima_file.ima021,                                                                                        
          l_str1       LIKE type_file.chr1000                                                                                       
#No.FUN-850059 --ADD END--   
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang #TQC-590047
 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND qcsuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND qcsgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND qcsgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup')
     #End:FUN-980030
#No.FUN-850059 --ADD START--                                                                                                        
     CALL cl_del_data(l_table)                                                                                                      
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                            
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                            
               "        ?, ?, ?          )"                                                                                         
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM                                                                                                                
     END IF                                                                                                                         
#No.FUN-850059 --ADD END--    
 
     LET l_sql = "SELECT qcs01,qcs02,qcs05,qcs03,' ',qcs021,' ',",
                 "       qcs04,qcs22,qcs091,qcs09,qcs13,qct02,qct03,qct04,' ',",  #No.MOD-810105 add qct03
                 "       qct11,qct07,qct08,qct131,qct132,0 ",
                 "  FROM qcs_file,qct_file ",
                 " WHERE  qcs01 = qct01 ",
                 "   AND  qcs02 = qct02 ",
                 "   AND  qcs05 = qct021 ",
                 "   AND  qcs14='Y' ",
                 "   AND  qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 "   AND  qcs00<'5' ",  #No.FUN-5C0078
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r301_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r301_curs1 CURSOR FOR r301_prepare1
#    CALL cl_outnam('aqcr301') RETURNING l_name        #No.FUN-850059 --MARK 
#    START REPORT r301_rep TO l_name                   #No.FUN-850059 --MARK 
#    LET g_pageno = 0                                  #No.FUN-850059 --MARK  
     FOREACH r301_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file
          WHERE pmc01 = sr.qcs03
         SELECT ima02 INTO sr.ima02 FROM ima_file
          WHERE ima01 = sr.qcs021
         SELECT azf03 INTO sr.azf03 FROM azf_file
          WHERE azf01 = sr.qct04 AND azf02='6' #6818
#No.FUN-850059 --ADD START--                                                                                                        
        SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.qcs021                                                             
            IF SQLCA.sqlcode THEN LET l_ima021 = NULL END IF                                                                        
        SELECT gen02 INTO l_qcs13 FROM gen_file WHERE gen01=sr.qcs13                                                                
            IF STATUS THEN LET l_qcs13='' END IF                                                                                    
        CASE sr.qcs09                                                                                                               
            WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_qcs09                                                             
            WHEN '2' CALL cl_getmsg('apm-244',g_lang) RETURNING l_qcs09 #MOD-A30001 aqc-005->apm-244                                                            
            WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_qcs09                                                             
        END CASE                                                                                                                    
                                                                                                                                    
         DECLARE qctt04_cs CURSOR FOR                                                                                               
          SELECT qctt04 FROM qctt_file                                                                                              
           WHERE qctt01 = sr.qcs01 AND qctt02 = sr.qcs02                                                                            
             AND qctt021= sr.qcs05 AND qctt03 = sr.qct03                                                                            
             LET l_str1 = NULL                                                                                                      
         FOREACH qctt04_cs INTO sr.qctt04                                 
             LET l_str1 = l_str1 CLIPPED,' ', cl_numfor(sr.qctt04,6,2)                                                              
         END FOREACH                                                                                                                
              IF cl_null(l_str1) THEN LET l_str1 = '0' END IF                                                                       
         EXECUTE  insert_prep  USING                                                                                                
          sr.qcs01,sr.qcs02,sr.qcs05,sr.qcs03,sr.pmc03,sr.qcs021,sr.ima02,                                                          
          l_ima021,sr.qcs04,sr.qcs22,sr.qcs091,l_qcs09,sr.qcs13,sr.qct02,                                                           
          sr.qct03,sr.qct04,sr.azf03,sr.qct11,sr.qct07,sr.qct08,sr.qct131,                                                          
          sr.qct132,l_str1                                                                                                          
      END FOREACH                                                                                                                   
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                              
      LET g_str = ''                                                                                                                
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                      
      IF g_zz05 = 'Y' THEN                                                                                                          
      CALL cl_wcchp(tm.wc,'qcs021,qcs03,qcs13')                                                                                     
           RETURNING tm.wc                                                                                                          
      LET g_str = tm.wc                                                                                                             
   END IF                                                                                                                           
   LET g_str = g_str,";",tm.bdate,";",tm.edate,";",tm.ans                                                                           
   CALL cl_prt_cs3('aqcr301','aqcr301',l_sql,g_str)                                                                                 
#No.FUN-850059 --ADD END--                  
#No.FUN-850059 --MARK START-- 
#        SELECT SUM(qctt04) FROM qctt_file
#         WHERE qctt01 = sr.qcs01 AND qctt02 = sr.qcs02
#           AND qctt021= sr.qcs05 AND qctt03 = sr.qct02
#        IF cl_null(sr.qctt04) THEN LET sr.qctt04 = 0 END IF
#        OUTPUT TO REPORT r301_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT r301_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#REPORT r301_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,       #No.FUN-680104 VARCHAR(1)
#         l_num        LIKE alb_file.alb06,       #No.FUN-680104 DEC(20,6)
#         l_rate       LIKE gec_file.gec04,       #No.FUN-680104 DEC(5,2) #TQC-840066
#         l_qcz        RECORD LIKE qcz_file.*,
#         l_qcs09      LIKE ze_file.ze03,      #No.FUN-680104 VARCHAR(04)
#         l_qcs13      LIKE gen_file.gen02,       #No.FUN-680104 VARCHAR(10)
#         l_str        LIKE type_file.chr4,        #No.FUN-680104 VARCHAR(04)
#         l_n          LIKE type_file.num5,       #No.FUN-680104 SMALLINT
#         l_n1         LIKE type_file.num5,       #No.FUN-680104 SMALLINT
#         l_ima021     LIKE ima_file.ima021,
#         l_str1       LIKE type_file.chr1000,    #No.FUN-680104 VARCHAR(300)   #No.FUN-620041 add
# Prog. Version..: '5.30.06-13.03.12(01)     #No.FUN-620041 add
#         sr               RECORD
#                                 qcs01 LIKE qcs_file.qcs01,
#                                 qcs02 LIKE qcs_file.qcs02,
#                                 qcs05 LIKE qcs_file.qcs05,
#                                 qcs03 LIKE qcs_file.qcs03,  #供應廠商
#                                 pmc03 LIKE pmc_file.pmc03,  #供應廠商
#                                 qcs021 LIKE qcs_file.qcs021,
#                                 ima02 LIKE ima_file.ima02,
#                                 qcs04 LIKE qcs_file.qcs04,
#                                 qcs22 LIKE qcs_file.qcs22,
#                                 qcs091 LIKE qcs_file.qcs091,
#                                 qcs09 LIKE qcs_file.qcs09,
#                                 qcs13 LIKE qcs_file.qcs13,
#                                 qct02 LIKE qct_file.qct02,
#                                 qct03 LIKE qct_file.qct03,     #No.MOD-810105 add
#                                 qct04 LIKE qct_file.qct04,
#                                 azf03 LIKE azf_file.azf03,
#                                 qct11 LIKE qct_file.qct11,
#                                 qct07 LIKE qct_file.qct07,
#                                 qct08 LIKE qct_file.qct08,
#                                 qct131 LIKE qct_file.qct131,
#                                 qct132 LIKE qct_file.qct132,
#                                 qctt04 LIKE qctt_file.qctt04
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.qcs03,sr.qcs021,sr.qcs01,sr.qcs02,sr.qcs05
# FORMAT
#  PAGE HEADER
#     SELECT * INTO l_qcz.* FROM qcz_file WHERE qcz00='0'
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED,pageno_total
#     PRINT g_x[9] CLIPPED,tm.bdate ,' - ',tm.edate
#     PRINT g_dash
#     SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.qcs021
#     IF SQLCA.sqlcode THEN LET l_ima021 = NULL END IF
 
#     PRINT COLUMN 01,g_x[10] CLIPPED,sr.qcs03,' ',sr.pmc03
#           #TQC-5B0034 mark
#           {COLUMN 31,g_x[11] CLIPPED,sr.qcs021,
#           COLUMN 81,g_x[12] CLIPPED,sr.ima02, #TQC-590047 61->81
#           COLUMN 111,g_x[13] CLIPPED,l_ima021 #TQC-590047 91->111}
#     #TQC-5B0034 add
#     PRINT g_x[11] CLIPPED,sr.qcs021 CLIPPED
#     PRINT COLUMN 5,g_x[12] CLIPPED,sr.ima02 CLIPPED
#     PRINT COLUMN 5,g_x[13] CLIPPED,l_ima021 CLIPPED
#     PRINT ''
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],    #No.FUN-620041 modify
#                    g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#                    g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.qcs03
#     SKIP TO TOP OF PAGE
 
##------------No.MOD-770115 modify
# #BEFORE GROUP OF sr.qcs01
#  BEFORE GROUP OF sr.qcs05
##------------No.MOD-770115 end
#     SELECT gen02 INTO l_qcs13 FROM gen_file WHERE gen01=sr.qcs13
#     IF STATUS THEN LET l_qcs13='' END IF
#     CASE sr.qcs09
#       WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_qcs09
#       WHEN '2' CALL cl_getmsg('aqc-005',g_lang) RETURNING l_qcs09
#       WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_qcs09
#     END CASE
#
#     PRINTX name=D1 COLUMN g_c[31],sr.qcs01 CLIPPED,      #No.FUN-620041 modify
#                    COLUMN g_c[32],sr.qcs02 USING '####',
#                    COLUMN g_c[33],sr.qcs05 USING '####',
#                    COLUMN g_c[34],sr.qcs04,
#                    COLUMN g_c[35],cl_numfor(sr.qcs22,35,0),
#                    COLUMN g_c[36],cl_numfor(sr.qcs091,36,0),
#                    COLUMN g_c[37],l_qcs09,
#                    COLUMN g_c[38],l_qcs13 CLIPPED;
 
#  ON EVERY ROW
#     CASE sr.qct08
#       WHEN '1' LET l_str = g_x[15] CLIPPED
#       WHEN '2' LET l_str = g_x[16] CLIPPED
#       WHEN '3' LET l_str = g_x[17] CLIPPED
#     END CASE
#     PRINTX name=D1 COLUMN g_c[39],sr.qct04,              #No.FUN-620041 modify
#                    COLUMN g_c[40],sr.azf03,
#                    COLUMN g_c[41],cl_numfor(sr.qct11,41,0),
#                    COLUMN g_c[42],cl_numfor(sr.qct07,42,0),
#                    COLUMN g_c[43],l_str,
#                    COLUMN g_c[44],cl_numfor(sr.qct131,44,2), #No.FUN-620041 modify
#                    COLUMN g_c[45],cl_numfor(sr.qct132,45,2)  #No.FUN-620041 modify
#     IF tm.ans = 'Y' THEN
#        LET l_n = 0
#        DECLARE qctt04_cs CURSOR FOR
#         SELECT qctt04 FROM qctt_file
#          WHERE qctt01 = sr.qcs01 AND qctt02 = sr.qcs02
#           #--------No.MOD-810105 modify
#           #AND qctt021= sr.qcs05 AND qctt03 = sr.qct02
#            AND qctt021= sr.qcs05 AND qctt03 = sr.qct03
#           #--------No.MOD-810105 end
#        LET l_n1=10
#        LET l_str1 = NULL    #No.FUN-620041 add
#        PRINT
#      #------------No.FUN-620041 modify
#       #PRINT COLUMN g_c[31],g_x[14] CLIPPED;
#        FOREACH qctt04_cs INTO sr.qctt04
#            LET l_n = l_n +1
#            IF l_n1 < (g_len-14) THEN
#               LET l_flg='N'
#               LET l_str1 = l_str1 CLIPPED,' ',cl_numfor(sr.qctt04,6,2)
#               LET l_n1=l_n1+7
#            ELSE
#               LET l_str1 = l_str1 CLIPPED,' ', cl_numfor(sr.qctt04,6,2)
#               PRINT COLUMN g_c[31],g_x[14] CLIPPED;
#               PRINT l_str1 CLIPPED
#               LET l_str1 = NULL
#               LET l_flg='Y'
#               LET l_n1=10
#            END IF
#        END FOREACH
#        IF l_flg = 'N' THEN
#           PRINT COLUMN g_c[31],g_x[14] CLIPPED;
#           PRINT l_str1 CLIPPED
#           LET l_str1 = NULL
#        END IF
#      #------------No.FUN-620041 end
#        PRINT
#     END IF
#     IF tm.ans = 'Y' THEN
#        PRINT
#     END IF
#  ON LAST ROW
#     PRINT
#     PRINT g_dash
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-850059 --MARK END-- 
