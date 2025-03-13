# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aqcr413.4gl
# Descriptions...: FQC料件品質履歷報告
# Date & Autority: 01/05/21 By Kammy
# Modify.........: No.FUN-4C0099 05/01/28 By kim 報表轉XML功能
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-5B0034 05/11/08 by Rosayu 單頭料件品名規格調整
# Modify.........: No.FUN-620041 06/03/28 By pengu 測量值和上下限值沒有顯示小數位
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850046 08/08/04 By lutingting報表轉為使用CR
# Modify.........: No.MOD-8B0031 08/11/06 By claire 子報表值錯給
# Modify.........: No.MOD-8B0028 08/11/06 By claire PRINT  mark
# Modify.........: No.MOD-8B0242 08/11/24 By claire l_qcf13給值為gen02
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B50110 11/05/19 By zhangll wc定義為STRING
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
             #wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              wc      STRING,                      #TQC-B50110 mod
              bdate   LIKE type_file.dat,          #No.FUN-680104 DATE
              edate   LIKE type_file.dat,          #No.FUN-680104 DATE
              ans     LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
              more    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_sql           STRING                  #No.FUN-850046
DEFINE   g_str           STRING                  #No.FUN-850046
DEFINE   l_table         STRING                  #No.FUN-850046
DEFINE   l_table1        STRING                  #No.FUN-850046
 
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
 
   #No.FUN-850046---start--
   LET g_sql = "qcf021.qcf_file.qcf021,",
               "ima02.ima_file.ima02,", 
               "qcf01.qcf_file.qcf01,", 
               "qcf04.qcf_file.qcf04,", 
               "qcf02.qcf_file.qcf02,", 
               "qcf22.qcf_file.qcf22,", 
               "qcf091.qcf_file.qcf091,",
               "l_qcf09.ze_file.ze03,", 
              #"l_qcf13.qcf_file.qcf13,",   #MOD-8B0242 mark
               "l_qcf13.gen_file.gen02,",   #MOD-8B0242
               "qcg04.qcg_file.qcg04,", 
               "azf03.azf_file.azf03,", 
               "qcg11.qcg_file.qcg11,", 
               "qcg07.qcg_file.qcg07,", 
               "qcg131.qcg_file.qcg131,",
               "qcg132.qcg_file.qcg132,",
               "qcg03.qcg_file.qcg03,",
               "l_str1.type_file.chr1000,",
               "qcg08.qcg_file.qcg08,", 
               "l_flg.type_file.chr1" 
   LET l_table = cl_prt_temptable('aqcr413',g_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   
   LET g_sql =  "qcf01.qcf_file.qcf01,", 
                "qcg03.qcg_file.qcg03,", 
                "qcgg03.qcgg_file.qcgg03,",
                "l_str1.type_file.chr1000,",
                "qcgg01.qcgg_file.qcgg01" 
   LET l_table1 = cl_prt_temptable('aqcr4131',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF             
   #No.FUN-850046--end
 
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
      THEN CALL r413_tm(0,0)
      ELSE CALL r413()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r413_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r413_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr413"
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
      CONSTRUCT BY NAME tm.wc ON qcf021,qcf02,qcf13
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
      IF INFIELD(qcf021) THEN
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_ima"
         LET g_qryparam.state = "c"
         CALL cl_create_qry() RETURNING g_qryparam.multiret
         DISPLAY g_qryparam.multiret TO qcf021
         NEXT FIELD qcf021
      END IF
#No.FUN-570243 --end
 
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
      CLOSE WINDOW r413_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr413'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr413','9031',1)
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
         CALL cl_cmdat('aqcr413',g_time,l_cmd)
      END IF
      CLOSE WINDOW r413_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r413()
   ERROR ""
END WHILE
   CLOSE WINDOW r413_w
END FUNCTION
 
FUNCTION r413()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_sql     STRING,                       #TQC-B50110 mod
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
          sr               RECORD
                                  qcf01 LIKE qcf_file.qcf01,
                                  qcf02 LIKE qcf_file.qcf02,
                                  qcf05 LIKE qcf_file.qcf05,
                                  qcf03 LIKE qcf_file.qcf03,
                                  pmc03 LIKE pmc_file.pmc03,
                                  qcf021 LIKE qcf_file.qcf021,
                                  ima02 LIKE ima_file.ima02,
                                  qcf04 LIKE qcf_file.qcf04,
                                  qcf22 LIKE qcf_file.qcf22,
                                  qcf091 LIKE qcf_file.qcf091,
                                  qcf09 LIKE qcf_file.qcf09,
                                  qcf13 LIKE qcf_file.qcf13,
                                  qcg03 LIKE qcg_file.qcg03,
                                  qcg04 LIKE qcg_file.qcg04,
                                  azf03 LIKE azf_file.azf03,
                                  qcg11 LIKE qcg_file.qcg11,
                                  qcg07 LIKE qcg_file.qcg07,
                                  qcg08 LIKE qcg_file.qcg08,
                                  qcg131 LIKE qcg_file.qcg131,
                                  qcg132 LIKE qcg_file.qcg132,
                                  qcgg04 LIKE qcgg_file.qcgg04
                        END RECORD
 
#No.FUN-850046----------start--
    DEFINE      l_qcz        RECORD LIKE qcz_file.*
    DEFINE      l_qcf09      LIKE ze_file.ze03      
    DEFINE      l_qcf13      LIKE gen_file.gen02         
    DEFINE      l_str1       LIKE type_file.chr1000  
    DEFINE      l_flg        LIKE type_file.chr1     
    DEFINE      l_n          LIKE type_file.num5     
    DEFINE      l_n1         LIKE type_file.num5  
    DEFINE      l_qcgg03     LIKE qcgg_file.qcgg03
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
       EXIT PROGRAM 
    END IF
    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?,?)"
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep1',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
       EXIT PROGRAM 
    END IF
    
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1) 
    
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aqcr413'   
#No.FUN-850046--end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND qcfuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND qcfgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND qcfgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT qcf01,qcf02,qcf05,qcf03,' ',qcf021,' ',",
                 "       qcf04,qcf22,qcf091,qcf09,qcf13,qcg03,qcg04,' ',",
                 "       qcg11,qcg07,qcg08,qcg131,qcg132,0 ",
                 "  FROM qcf_file,qcg_file ",
                 " WHERE  qcf01 = qcg01 ",
                 "   AND  qcf18 = '1' ",
                 "   AND  qcf14='Y' ",
                 "   AND  qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r413_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r413_curs1 CURSOR FOR r413_prepare1
     #CALL cl_outnam('aqcr413') RETURNING l_name     #No.FUN-850046
     #START REPORT r413_rep TO l_name                #No.FUN-850046
     LET g_pageno = 0
     FOREACH r413_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         SELECT ima02 INTO sr.ima02 FROM ima_file
          WHERE ima01 = sr.qcf021
         SELECT azf03 INTO sr.azf03 FROM azf_file
          WHERE azf01 = sr.qcg04 AND azf02='6' #6818
         #No.FUN-850046---start-- 
         SELECT * INTO l_qcz.* FROM qcz_file WHERE qcz00='0'
         SELECT gen02 INTO l_qcf13 FROM gen_file WHERE gen01=sr.qcf13
         IF STATUS THEN LET l_qcf13='' END IF
         CASE sr.qcf09
           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_qcf09
           WHEN '2' CALL cl_getmsg('aqc-005',g_lang) RETURNING l_qcf09
           WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_qcf09
         END CASE 
      
         IF tm.ans = 'Y' THEN   #印測量值
            LET l_n = 0
            DECLARE qcgg04_cs CURSOR FOR
             SELECT qcgg04 FROM qcgg_file
              WHERE qcgg01 = sr.qcf01 AND qcgg03 = sr.qcg03
              LET l_n1=10
              LET l_str1 = NULL    #No.FUN-620041 add
              #PRINT               #MOD-8B0028 mark
           
            FOREACH qcgg04_cs INTO sr.qcgg04
                LET l_n = l_n +1
                IF l_n1 < (g_len-14) THEN
                   LET l_flg='N'
                   LET l_str1 = l_str1 CLIPPED,' ',cl_numfor(sr.qcgg04,6,2)
                   LET l_n1=l_n1+7
                ELSE
                  LET l_str1 = l_str1 CLIPPED,' ', cl_numfor(sr.qcgg04,6,2)
                  EXECUTE insert_prep1 USING
                      sr.qcf01,sr.qcg03,sr.qcg03,l_str1,sr.qcf01   #MOD-8B0031
                     #sr.qcf01,sr.qcg03,l_qcgg03,l_str1,sr.qcgg04  #MOD-8B0031 mark
                  LET l_str1 = NULL
                  LET l_flg='Y'
                  LET l_n1=10
                END IF
            END FOREACH
         END IF   
         EXECUTE insert_prep USING
             sr.qcf021,sr.ima02,sr.qcf01,sr.qcf04,sr.qcf02,sr.qcf22,sr.qcf091,
             l_qcf09,l_qcf13,sr.qcg04,sr.azf03,sr.qcg11,sr.qcg07,sr.qcg131,
             sr.qcg132,sr.qcg03,l_str1,sr.qcg08,l_flg              
         #OUTPUT TO REPORT r413_rep(sr.*)
         #No.FUN-850046--end          
     END FOREACH
 
     #No.FUN-850046----start--
     LET g_sql= "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
                
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'qcf021,qcf02,qcf13')
        RETURNING tm.wc
     END IF
     
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",tm.ans
     
     CALL cl_prt_cs3('aqcr413','aqcr413',g_sql,g_str)
     #FINISH REPORT r413_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-850046--end
END FUNCTION
 
#No.FUN-850046----start--
#REPORT r413_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#          l_num        LIKE oqu_file.oqu12,       #No.FUN-680104 DEC(12,2)
#          l_rate       LIKE gec_file.gec04,       #No.FUN-680104 DEC(5,2) #TQC-840066
#          l_qcz        RECORD LIKE qcz_file.*,
#          l_qcf09      LIKE ze_file.ze03,       #No.FUN-680104 VARCHAR(04)
#          l_qcf13      LIKE gen_file.gen02,       #No.FUN-680104 VARCHAR(10)
#          l_str        LIKE qcf_file.qcf062,       #No.FUN-680104 VARCHAR(04)
#          l_str1       LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(300)    #No.FUN-620041 add
# Prog. Version..: '5.30.06-13.03.12(01)     #No.FUN-620041 add
#          l_n          LIKE type_file.num5,          #No.FUN-680104 SMALLINT
#          l_n1         LIKE type_file.num5,          #No.FUN-680104 SMALLINT
#          sr               RECORD
#                                  qcf01 LIKE qcf_file.qcf01,
#                                  qcf02 LIKE qcf_file.qcf02,
#                                  qcf05 LIKE qcf_file.qcf05,
#                                  qcf03 LIKE qcf_file.qcf03,
#                                  pmc03 LIKE pmc_file.pmc03,
#                                  qcf021 LIKE qcf_file.qcf021,
#                                  ima02 LIKE ima_file.ima02,
#                                  qcf04 LIKE qcf_file.qcf04,
#                                  qcf22 LIKE qcf_file.qcf22,
#                                  qcf091 LIKE qcf_file.qcf091,
#                                  qcf09 LIKE qcf_file.qcf09,
#                                  qcf13 LIKE qcf_file.qcf13,
#                                  qcg03 LIKE qcg_file.qcg03,
#                                  qcg04 LIKE qcg_file.qcg04,
#                                  azf03 LIKE azf_file.azf03,
#                                  qcg11 LIKE qcg_file.qcg11,
#                                  qcg07 LIKE qcg_file.qcg07,
#                                  qcg08 LIKE qcg_file.qcg08,
#                                  qcg131 LIKE qcg_file.qcg131,
#                                  qcg132 LIKE qcg_file.qcg132,
#                                  qcgg04 LIKE qcgg_file.qcgg04
#                        END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.qcf021,sr.qcf01
#  FORMAT
#   PAGE HEADER
#      SELECT * INTO l_qcz.* FROM qcz_file WHERE qcz00='0'
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_x[9] CLIPPED,tm.bdate ,' - ',tm.edate
#      PRINT g_dash
#      PRINT g_x[11] CLIPPED,sr.qcf021 CLIPPED #TQC-5B0034
#      PRINT g_x[12] CLIPPED,sr.ima02 CLIPPED #TQC-5B0034
#      PRINT ''
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.qcf021
#      SKIP TO TOP OF PAGE
##     PRINT g_x[11] CLIPPED,sr.qcf021,' ',
##           g_x[12] CLIPPED,sr.ima02
##     PRINT ''
##     PRINT g_x[15] CLIPPED,COLUMN 39,g_x[16] CLIPPED,
##           COLUMN 78,g_x[17] CLIPPED,COLUMN 114,g_x[22] CLIPPED
##     PRINT '---------- -------- ---------- -------- -------- --------',
##           ' -------- --------------- ------ ------ -------- ------',
##           ' ------'
#
#   BEFORE GROUP OF sr.qcf01
#      SELECT gen02 INTO l_qcf13 FROM gen_file WHERE gen01=sr.qcf13
#      IF STATUS THEN LET l_qcf13='' END IF
#      CASE sr.qcf09
#        WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_qcf09
#        WHEN '2' CALL cl_getmsg('aqc-005',g_lang) RETURNING l_qcf09
#        WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_qcf09
#      END CASE
# 
#      PRINT COLUMN  g_c[31],sr.qcf01 CLIPPED,
#            COLUMN  g_c[32],sr.qcf04 ,
#            COLUMN  g_c[33],sr.qcf02,
#            COLUMN  g_c[34],cl_numfor(sr.qcf22,34,0),
#            COLUMN  g_c[35],cl_numfor(sr.qcf091,35,0),
#            COLUMN  g_c[36],l_qcf09 CLIPPED,
#            COLUMN  g_c[37],l_qcf13 CLIPPED;
#
#   ON EVERY ROW
#      CASE sr.qcg08
#        WHEN '1' LET l_str = g_x[14] CLIPPED
#        WHEN '2' LET l_str = g_x[15] CLIPPED
#        WHEN '3' LET l_str = g_x[16] CLIPPED
#      END CASE
#      PRINT COLUMN g_c[38],sr.qcg04,
#            COLUMN g_c[39],sr.azf03,
#            COLUMN g_c[40],cl_numfor(sr.qcg11,40,0),
#            COLUMN g_c[41],cl_numfor(sr.qcg07,41,0),
#            COLUMN g_c[42],l_str,
#            COLUMN g_c[43],cl_numfor(sr.qcg131,43,2),    #No.FUN-620041 modify
#            COLUMN g_c[44],cl_numfor(sr.qcg132,44,2)     #No.FUN-620041 modify
#      IF tm.ans = 'Y' THEN   #印測量值
#         LET l_n = 0
#         DECLARE qcgg04_cs CURSOR FOR
#          SELECT qcgg04 FROM qcgg_file
#           WHERE qcgg01 = sr.qcf01 AND qcgg03 = sr.qcg03
#           LET l_n1=10
#           LET l_str1 = NULL    #No.FUN-620041 add
#           PRINT
#        #------------No.FUN-620041 modify
#          #PRINT column 4,g_x[13] CLIPPED;
#         FOREACH qcgg04_cs INTO sr.qcgg04
#             LET l_n = l_n +1
#             IF l_n1 < (g_len-14) THEN
#                LET l_flg='N'
#                LET l_str1 = l_str1 CLIPPED,' ',cl_numfor(sr.qcgg04,6,2)
#                LET l_n1=l_n1+7
#             ELSE
#               LET l_str1 = l_str1 CLIPPED,' ', cl_numfor(sr.qcgg04,6,2)
#               PRINT COLUMN g_c[31],g_x[13] CLIPPED;
#               PRINT l_str1 CLIPPED
#               LET l_str1 = NULL
#               LET l_flg='Y'
#               LET l_n1=10
#             END IF
#         END FOREACH
#         IF l_flg = 'N' THEN
#            PRINT COLUMN g_c[31],g_x[13] CLIPPED;
#            PRINT l_str1 CLIPPED
#            LET l_str1 = NULL
#         END IF
#       #------------No.FUN-620041 modify
#         PRINT
#     END IF
# 
#   ON LAST ROW
#      PRINT ""
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-850046----end
