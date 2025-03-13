# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aqcr523.4gl
# Descriptions...: PQC料件品質履歷報告
# Date & Autority: 01/05/21 By Kammy
# Modify.........: No.FUN-4C0099 05/01/31 By kim 報表轉XML功能
# Modify.........: No.MOD-530619 05/03/26 By Yuna 請將其他特殊列印條件 先給Default值'N'
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-590047 05/10/05 By kim 列印沒有公司名稱
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 單頭料件品名規格修改
# Modify.........: No.FUN-620041 06/03/28 By pengu 測量值和上下限值沒有顯示小數位
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850054 08/05/14 By ChenMoyan 老報表轉CR
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING 
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
#No.FUN-850054 --Begin
DEFINE   #g_sql           LIKE type_file.chr1000
         g_sql        STRING       #NO.FUN-910082  
DEFINE   #g_sql1          LIKE type_file.chr1000
         g_sql1        STRING       #NO.FUN-910082  
DEFINE   l_table         STRING  #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
DEFINE   l_table1        STRING  #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
DEFINE   g_str           LIKE type_file.chr1000
#No.FUN-850054 --End
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690121
#No.FUN-850054
   LET g_sql="qcm01.qcm_file.qcm01,",
             "qcm02.qcm_file.qcm02,",
             "qcm021.qcm_file.qcm021,",
             "ima02.ima_file.ima02,",
             "qcm04.qcm_file.qcm04,",
             "qcm22.qcm_file.qcm22,",
             "qcm091.qcm_file.qcm091,",
             "qcm09.qcm_file.qcm09,",
             "qcm13.qcm_file.qcm13,",
             "qcn03.qcn_file.qcn03,",
             "qcn04.qcn_file.qcn04,",
             "azf03.azf_file.azf03,",
             "qcn11.qcn_file.qcn11,",
             "qcn07.qcn_file.qcn07,",
             "qcn08.qcn_file.qcn08,",
             "qcn131.qcn_file.qcn131,",
             "qcn132.qcn_file.qcn132,",
             "l_qcm13.gen_file.gen02"
   LET l_table=cl_prt_temptable('aqcr523',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql1="qcm01.qcm_file.qcm01,",
              "qcn03.qcn_file.qcn03,",
              "l_str.type_file.chr1000"
   LET l_table1=cl_prt_temptable('aqcr523_sub',g_sql1) CLIPPED
   IF l_table1=-1 THEN EXIT PROGRAM END IF
#No.FUN-850054 --End
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
      THEN CALL r523_tm(0,0)
      ELSE CALL r523()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r523_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r523_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr523"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
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
      CONSTRUCT BY NAME tm.wc ON qcm021,qcm02,qcm13
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
#No.FUN-570243 --start
     ON ACTION CONTROLP
        IF INFIELD(qcm021) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO qcm021
           NEXT FIELD qcm021
        END IF
#No.FUN-570243 --end
 
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
   INPUT BY NAME tm.bdate,tm.edate,tm.ans,
                  tm.more WITHOUT DEFAULTS #MOD-530619
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
            NEXT FIELD edate
         END IF
 
      AFTER FIELD ans
         IF cl_null(tm.ans) OR tm.ans NOT MATCHES '[YN]' THEN
            NEXT FIELD ans
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      CLOSE WINDOW r523_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr523'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr523','9031',1)
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
         CALL cl_cmdat('aqcr523',g_time,l_cmd)
      END IF
      CLOSE WINDOW r523_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r523()
   ERROR ""
END WHILE
   CLOSE WINDOW r523_w
END FUNCTION
 
FUNCTION r523()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
#No.FUN-850054 --Begin
          l_flag    LIKE type_file.chr1,
          l_n1      LIKE type_file.num5,
          l_str1    LIKE type_file.chr1000,
          l_qcm13   LIKE qcm_file.qcm13,
#No.FUN-850054 --End          
          sr               RECORD
                                  qcm01 LIKE qcm_file.qcm01,
                                  qcm02 LIKE qcm_file.qcm02,
                                  qcm05 LIKE qcm_file.qcm05,
                                  qcm03 LIKE qcm_file.qcm03,
                                  pmc03 LIKE pmc_file.pmc03,
                                  qcm021 LIKE qcm_file.qcm021,
                                  ima02 LIKE ima_file.ima02,
                                  qcm04 LIKE qcm_file.qcm04,
                                  qcm22 LIKE qcm_file.qcm22,
                                  qcm091 LIKE qcm_file.qcm091,
                                  qcm09 LIKE qcm_file.qcm09,
                                  qcm13 LIKE qcm_file.qcm13,
                                  qcn03 LIKE qcn_file.qcn03,
                                  qcn04 LIKE qcn_file.qcn04,
                                  azf03 LIKE azf_file.azf03,
                                  qcn11 LIKE qcn_file.qcn11,
                                  qcn07 LIKE qcn_file.qcn07,
                                  qcn08 LIKE qcn_file.qcn08,
                                  qcn131 LIKE qcn_file.qcn131,
                                  qcn132 LIKE qcn_file.qcn132,
                                  qcnn04 LIKE qcnn_file.qcnn04
                        END RECORD
#No.FUN-850054 --Begin
     LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
           CALL cl_err('insert_prep:',status,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
           EXIT PROGRAM
     END IF
     LET g_sql1="INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?)"
     PREPARE insert_prep1 FROM g_sql1
     IF STATUS THEN
           CALL cl_err('insert_prep1:',status,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
           EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='aqcr523'
#No.FUN-850054 --End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang #TQC-590047
 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND qcmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND qcmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND qcmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcmuser', 'qcmgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT qcm01,qcm02,qcm05,qcm03,' ',qcm021,' ',",
                 "       qcm04,qcm22,qcm091,qcm09,qcm13,qcn03,qcn04,' ',",
                 "       qcn11,qcn07,qcn08,qcn131,qcn132,0 ",
                 "  FROM qcm_file,qcn_file ",
                 " WHERE  qcm01 = qcn01 ",
                 "   AND  qcm18 = '1' ",
                 "   AND  qcm14='Y' ",
                 "   AND  qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r523_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r523_curs1 CURSOR FOR r523_prepare1
#No.FUN-850054 --Begin
#    CALL cl_outnam('aqcr523') RETURNING l_name   
#    START REPORT r523_rep TO l_name              
#    LET g_pageno = 0
     DECLARE qcnn04_cs CURSOR FOR                                                                                         
               SELECT qcnn04 FROM qcnn_file                                                                                         
                WHERE qcnn01 = sr.qcm01 AND qcnn03 = sr.qcn03
#No.FUN-850054 --End
     FOREACH r523_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT ima02 INTO sr.ima02 FROM ima_file
          WHERE ima01 = sr.qcm021
         SELECT azf03 INTO sr.azf03 FROM azf_file
          WHERE azf01 = sr.qcn04 AND azf02='6' 
#No.FUN-850054 --Begin
         SELECT gen02 INTO l_qcm13 FROM gen_file WHERE gen01=sr.qcm13                                                          
         IF STATUS THEN LET l_qcm13='' END IF 
         IF tm.ans = 'Y' THEN                                                                                                       
               LET l_n1=0                                                                                                           
               LET l_str1 = NULL                                                                                                    
               FOREACH qcnn04_cs INTO sr.qcnn04                                                                                     
               LET l_n1 = l_n1 +1                                                                                                   
                  IF l_n1 < 33 THEN                                                                                                 
                     LET l_str1 = l_str1 CLIPPED,' ',cl_numfor(sr.qcnn04,6,2)                                                       
                     LET l_flag = 'N'                                                                                               
                  ELSE                                                                                                              
                     LET l_n1=0                                                                                                     
                     LET l_str1 = l_str1 CLIPPED,' ', cl_numfor(sr.qcnn04,6,2)                                                      
                     EXECUTE insert_prep1 USING sr.qcm01,sr.qcn03,l_str1                                                            
                     LET l_flag = 'Y'                                                                                               
                     LET l_str1 = NULL                                                                                              
                  END IF                                                                                                            
              END FOREACH                                                                                                           
              IF l_flag = 'N' THEN                                                                                                  
                  EXECUTE insert_prep1 USING sr.qcm01,sr.qcn03,l_str1                                                               
              END IF                                                                                                                
         END IF      
         EXECUTE insert_prep USING sr.qcm01,sr.qcm02,sr.qcm021,sr.ima02,sr.qcm04,
                                   sr.qcm22,sr.qcm091,sr.qcm09,sr.qcm13,sr.qcn03,
                                   sr.qcn04,sr.azf03,sr.qcn11,sr.qcn07,sr.qcn08,
                                   sr.qcn131,sr.qcn132,l_qcm13
#No.FUN-850054 --End
#        OUTPUT TO REPORT r523_rep(sr.*)           #No.FUN-850054
     END FOREACH
#No.FUN-850054 --Begin
#    FINISH REPORT r523_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,'|',
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'qcm021,qcm02,qcm13')
        RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
     LET g_str=tm.wc,';',tm.bdate,';',tm.edate,';',tm.ans
     CALL cl_prt_cs3('aqcr523','aqcr523',g_sql,g_str)
#No.FUN-850054 --End
END FUNCTION
 
#No.FUN-850054 --Begin
#REPORT r523_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#         l_num        LIKE ecb_file.ecb18,       #No.FUN-680104 DEC(12,2)
#         l_rate       LIKE gec_file.gec04,       #No.FUN-680104 DEC(5,2) #TQC-840066
#         l_qcz        RECORD LIKE qcz_file.*,
#         l_qcm09      LIKE qcf_file.qcf062,       #No.FUN-680104 VARCHAR(04)
#         l_qcm13      LIKE gen_file.gen02,       #No.FUN-680104 VARCHAR(10)
#         l_str        LIKE qcf_file.qcf062,       #No.FUN-680104 VARCHAR(04)
#         l_str1       LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(300)    #No.FUN-620041 add
# Prog. Version..: '5.30.06-13.03.12(01)     #No.FUN-620041 add
#         l_n          LIKE type_file.num5,          #No.FUN-680104 SMALLINT
#         l_n1         LIKE type_file.num5,          #No.FUN-680104 SMALLINT
#         sr               RECORD
#                                 qcm01 LIKE qcm_file.qcm01,
#                                 qcm02 LIKE qcm_file.qcm02,
#                                 qcm05 LIKE qcm_file.qcm05,
#                                 qcm03 LIKE qcm_file.qcm03,  #供應廠商
#                                 pmc03 LIKE pmc_file.pmc03,  #供應廠商
#                                 qcm021 LIKE qcm_file.qcm021,
#                                 ima02 LIKE ima_file.ima02,
#                                 qcm04 LIKE qcm_file.qcm04,
#                                 qcm22 LIKE qcm_file.qcm22,
#                                 qcm091 LIKE qcm_file.qcm091,
#                                 qcm09 LIKE qcm_file.qcm09,
#                                 qcm13 LIKE qcm_file.qcm13,
#                                 qcn03 LIKE qcn_file.qcn03,
#                                 qcn04 LIKE qcn_file.qcn04,
#                                 azf03 LIKE azf_file.azf03,
#                                 qcn11 LIKE qcn_file.qcn11,
#                                 qcn07 LIKE qcn_file.qcn07,
#                                 qcn08 LIKE qcn_file.qcn08,
#                                 qcn131 LIKE qcn_file.qcn131,
#                                 qcn132 LIKE qcn_file.qcn132,
#                                 qcnn04 LIKE qcnn_file.qcnn04
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.qcm021,sr.qcm01
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
#     PRINT g_x[15] CLIPPED,sr.qcm021 CLIPPED #TQC-5B0034
#     PRINT g_x[16] CLIPPED,sr.ima02 CLIPPED #TQC-5B0034
#     PRINT
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#           g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.qcm021
#     SKIP TO TOP OF PAGE
##    PRINT g_x[13] CLIPPED,sr.qcm021,' ',
##          g_x[14] CLIPPED,sr.ima02
##    PRINT ''
##    PRINT g_x[15] CLIPPED,COLUMN 39,g_x[16] CLIPPED,
##          COLUMN 78,g_x[17] CLIPPED,COLUMN 114,g_x[22] CLIPPED
##    PRINT g_x[23] CLIPPED,COLUMN 41,g_x[24] CLIPPED,
##          COLUMN 68,g_x[25] CLIPPED,COLUMN 107,g_x[26] CLIPPED
 
#  BEFORE GROUP OF sr.qcm01
#     SELECT gen02 INTO l_qcm13 FROM gen_file WHERE gen01=sr.qcm13
#     IF STATUS THEN LET l_qcm13='' END IF
#     CASE sr.qcm09
#       WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_qcm09
#       WHEN '2' CALL cl_getmsg('aqc-005',g_lang) RETURNING l_qcm09
#       WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_qcm09
#     END CASE
#
#     PRINT COLUMN g_c[31], sr.qcm01 CLIPPED,
#           COLUMN g_c[32], sr.qcm04 ,
#           COLUMN g_c[33], sr.qcm02,
#           COLUMN g_c[34], sr.qcm22 USING '#######&',
#           COLUMN g_c[35], sr.qcm091 USING '#######&',
#           COLUMN g_c[36], l_qcm09 CLIPPED,
#           COLUMN g_c[37], sr.qcm13 CLIPPED,
#           COLUMN g_c[38], l_qcm13 CLIPPED;
 
#  ON EVERY ROW
#     CASE sr.qcn08
#       WHEN '1' LET l_str = g_x[11] CLIPPED
#       WHEN '2' LET l_str = g_x[12] CLIPPED
#       WHEN '3' LET l_str = g_x[13] CLIPPED
#     END CASE
#     PRINT COLUMN g_c[39],sr.qcn04,
#           COLUMN g_c[40],sr.azf03,
#           COLUMN g_c[41],cl_numfor(sr.qcn11,41,0),
#           COLUMN g_c[42],cl_numfor(sr.qcn07,42,0),
#           COLUMN g_c[43],l_str,
#           COLUMN g_c[44],cl_numfor(sr.qcn131,44,2),      #No.FUN-620041 modify 
#           COLUMN g_c[45],cl_numfor(sr.qcn132,45,2)       #No.FUN-620041 modify
#     IF tm.ans = 'Y' THEN
#        LET l_n = 0
#        DECLARE qcnn04_cs CURSOR FOR
#         SELECT qcnn04 FROM qcnn_file
#          WHERE qcnn01 = sr.qcm01 AND qcnn03 = sr.qcn03
#        LET l_n1=10
#        LET l_str1 = NULL    #No.FUN-620041 add
#        PRINT
#      #------------No.FUN-620041 modify
#       #PRINT COLUMN 4,g_x[10] CLIPPED;
#        FOREACH qcnn04_cs INTO sr.qcnn04
#            LET l_n = l_n +1
#            IF l_n1 < (g_len-14) THEN
#               LET l_flg='N'
#               LET l_str1 = l_str1 CLIPPED,' ',cl_numfor(sr.qcnn04,6,2)
#               LET l_n1=l_n1+7
#            ELSE
#              LET l_str1 = l_str1 CLIPPED,' ', cl_numfor(sr.qcnn04,6,2)
#              PRINT COLUMN g_c[31],g_x[10] CLIPPED;
#              PRINT l_str1 CLIPPED
#              LET l_str1 = NULL
#              LET l_flg='Y'
#              LET l_n1=10
#            END IF
#        END FOREACH
#        IF l_flg = 'N' THEN
#           PRINT COLUMN g_c[31],g_x[10] CLIPPED;
#           PRINT l_str1 CLIPPED
#           LET l_str1 = NULL
#        END IF
#      #------------No.FUN-620041 end
#        PRINT
#      END IF
#      IF tm.ans = 'Y' THEN
#        PRINT
#      END IF
 
#
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
#No.FUN-850054 --End
