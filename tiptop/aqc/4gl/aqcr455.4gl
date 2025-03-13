# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aqcr455.4gl
# Descriptions...: FQC 檢驗報告
# Date & Author..: 99/05/10 By Melody
# Modify.........: No.FUN-4C0099 05/02/01 By kim 報表轉XML功能
# Modify.........: No.FUN-550063 05/05/16 By Will 單據編號放大
# Modify.........: No.FUN-550121 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-590013 05/09/28 By Rosayu當單頭有資料而單身沒資料時無法列印
# Modify.........: No.TQC-5A0009 05/10/06 By kim 料號放大
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 單頭品名規格調整
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680104 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-730009 07/03/05 By Judy Crystal Report修改
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.MOD-870027 08/07/02 By claire 調整備註,說明用子報表列印
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B50110 11/05/19 By zhangll wc定義為STRING
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
             #wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              wc      STRING,                      #TQC-B50110 mod
              more    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
#FUN-730009.....bgein
DEFINE   g_sql     STRING
DEFINE   l_table   STRING
DEFINE   l_table1  STRING  #MOD-870027 
DEFINE   l_table2  STRING  #MOD-870027 
DEFINE   g_str     STRING
#FUN-730009.....end
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
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
#FUN-730009.....bgein
   LET g_sql = "qcf01.qcf_file.qcf01,qcf02.qcf_file.qcf02,",
               "qcf021.qcf_file.qcf021,qcf03.qcf_file.qcf03,",
               "qcf04.qcf_file.qcf04,qcf041.qcf_file.qcf041,",
               "qcf05.qcf_file.qcf05,qcf06.qcf_file.qcf06,",
               "qcf09.qcf_file.qcf09,qcf091.qcf_file.qcf091,",
               "qcf12.qcf_file.qcf12,qcf19.qcf_file.qcf19,",
               "qcf20.qcf_file.qcf20,qcf21.qcf_file.qcf21,",
               "qcf22.qcf_file.qcf22,qcg03.qcg_file.qcg03,",
               "qcg04.qcg_file.qcg04,qcg05.qcg_file.qcg05,",
               "qcg06.qcg_file.qcg06,qcg07.qcg_file.qcg07,",
               "qcg08.qcg_file.qcg08,qcg09.qcg_file.qcg09,",
               "qcg10.qcg_file.qcg10,qcg11.qcg_file.qcg11,",
              #"qce03.qce_file.qce03,qcu04.qcu_file.qcu04,",  #MOD-870027 mark
              #"qcu05.qcu_file.qcu05,qcv04.qcv_file.qcv04,",  #MOD-870027 mark
               "azf03.azf_file.azf03,ima02.ima_file.ima02,",
               "sfb22.sfb_file.sfb22,occ02.occ_file.occ02,",
               "gen02.gen_file.gen02,gem02.gem_file.gem02,",
               "azf03a.azf_file.azf03,",
               "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
              "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
              "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

   LET l_table = cl_prt_temptable('aqcr455',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#MOD-8700027-begin-mark
#   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#               " VALUES(?,?,?,?,?,?,?,?,?,?,?,",
#               "        ?,?,?,?,?,?,?,?,?,?,?,?,",
#               "        ?,?,?,?,?,?,?,?)"  #MOD-870027 cancel ,?,?,?,?
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN
#      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
#   END IF
#MOD-8700027-end-mark
#FUN-730009.....end
#MOD-870027-begin-add
   LET g_sql = "qcu01.qcu_file.qcu01,qcu02.qcu_file.qcu02,",
               "qcu021.qcu_file.qcu021,qcu03.qcu_file.qcu03,",
               "qcu04.qcu_file.qcu04,qcu05.qcu_file.qcu05,",
               "qce03.qce_file.qce03"
   LET l_table1 = cl_prt_temptable('aqcr4551',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "qcv01.qcv_file.qcv01,qcv02.qcv_file.qcv02,",
               "qcv021.qcv_file.qcv021,",
               "qcv03.qcv_file.qcv03,qcv04.qcv_file.qcv04"
   LET l_table2 = cl_prt_temptable('aqcr4552',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
#MOD-870027-end-add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r455_tm(0,0)
      ELSE CALL r455()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r455_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW r455_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr455"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON qcf01,qcf021,qcf03,qcf02,qcf13
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
         IF INFIELD(qcf021) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcf021
            NEXT FIELD qcf021
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
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      CLOSE WINDOW r455_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr455'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr455','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aqcr455',g_time,l_cmd)
      END IF
      CLOSE WINDOW r455_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r455()
   ERROR ""
END WHILE
   CLOSE WINDOW r455_w
END FUNCTION
 
FUNCTION r455()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_sql     STRING,                       #TQC-B50110 mod
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
#FUN-730009.....bgein
          l_gen02   LIKE gen_file.gen02,
          l_ima02   LIKE ima_file.ima02,
          l_ima109  LIKE ima_file.ima109,
          l_azf03   LIKE azf_file.azf03,
          l_sfb22   LIKE sfb_file.sfb22,
          l_occ02   LIKE occ_file.occ02,
          l_gem02   LIKE gem_file.gem02,
          l_azf03a  LIKE azf_file.azf03,
          l_qce03   LIKE qce_file.qce03,
          l_qcv04   LIKE qcv_file.qcv04,
          l_qcu     RECORD LIKE qcu_file.*,
          l_qcv     RECORD LIKE qcv_file.*,  #MOD-870027 add
#FUN-730009.....end
          sr        RECORD
                    qcf        RECORD LIKE qcf_file.*,
                    qcg        RECORD LIKE qcg_file.*
                    END RECORD
     DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
     CALL cl_del_data(l_table)     #FUN-730009
     CALL cl_del_data(l_table1)    #MOD-870027
     CALL cl_del_data(l_table2)    #MOD-870027
 
#MOD-870027-begin-add
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,?,?)"   #TQC-C10039 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
      EXIT PROGRAM
   END IF
#MOD-870027-end-add
 
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
 
 
#bugno:6010 --> SQL:qcf14 = 'Y' 移除
     LET l_sql = "SELECT * FROM qcf_file,OUTER qcg_file ", #TQC-590013 add OUTER
                 " WHERE qcf_file.qcf01=qcg_file.qcg01 AND qcf18='2' ",
              #  " WHERE qcf_file.qcf01=qcg_file.qcg01 AND qcf14 = 'Y' AND qcf18='2' ",
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r455_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r455_curs1 CURSOR FOR r455_prepare1
#FUN-730009.....bgein mark
#    CALL cl_outnam('aqcr455') RETURNING l_name
#    START REPORT r455_rep TO l_name
#FUN-730009.....end mark
     LET g_pageno = 0
     FOREACH r455_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#FUN-730009.....bgein
         LET l_gen02=NULL
         LET l_ima02=NULL
         LET l_ima109=NULL
         LET l_azf03=NULL
         LET l_sfb22=NULL
         LET l_occ02=NULL
         LET l_gem02=NULL
         LET l_azf03a=NULL
         LET l_qce03=NULL
         LET l_qcv04=NULL
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcf.qcf13
         SELECT ima02,ima109 INTO l_ima02,l_ima109 
           FROM ima_file 
          WHERE ima01=sr.qcf.qcf021
         SELECT azf03 INTO l_azf03 
           FROM azf_file 
          WHERE azf01=l_ima109 AND azf02='8'
         SELECT sfb22,occ02,gem02 INTO l_sfb22,l_occ02,l_gem02 
           FROM sfb_file,gem_file,occ_file,oea_file 
          WHERE sfb01=sr.qcf.qcf02 AND sfb22=oea01 AND oea03=occ01 AND sfb82=gem01
         IF STATUS THEN LET l_sfb22='' LET l_occ02='' LET l_gem02='' END IF
         SELECT azf03 INTO l_azf03a 
           FROM azf_file 
          WHERE azf01=sr.qcg.qcg04 AND azf02='6'
        #MOD-870027-begin-mark
        # DECLARE qcu_cur CURSOR FOR                                        
        #   SELECT * FROM qcu_file WHERE qcu01=sr.qcg.qcg01  AND qcu03=sr.qcg.qcg03                        
        #   FOREACH qcu_cur INTO l_qcu.*                        # SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
        #   END FOREACH
        #SELECT qcv04 FROM qcv_file WHERE qcv01 =sr.qcg.qcg01     AND qcv03 =sr.qcg.qcg03
        #MOD-870027-end-mark
         EXECUTE insert_prep USING sr.qcf.qcf01,sr.qcf.qcf02,sr.qcf.qcf021,
                                   sr.qcf.qcf03,sr.qcf.qcf04,sr.qcf.qcf041,
                                   sr.qcf.qcf05,sr.qcf.qcf06,sr.qcf.qcf09,
                                   sr.qcf.qcf091,sr.qcf.qcf12,sr.qcf.qcf19,
                                   sr.qcf.qcf20,sr.qcf.qcf21,sr.qcf.qcf22,
                                   sr.qcg.qcg03,sr.qcg.qcg04,sr.qcg.qcg05,
                                   sr.qcg.qcg06,sr.qcg.qcg07,sr.qcg.qcg08,
                                   sr.qcg.qcg09,sr.qcg.qcg10,sr.qcg.qcg11,
                                  #l_qce03,l_qcu.qcu04,l_qcu.qcu05,l_qcv04,  #MOD-870027 mark
                                   l_azf03,l_ima02,l_sfb22,l_occ02,l_gen02,
                                   l_gem02,l_azf03a,
                                   "",l_img_blob, "N",""   #TQC-C10039 ADD "",l_img_blob, "N","" 
#MOD-870027-begin-add
      #不良原因
      DECLARE qcu_cur CURSOR FOR
         SELECT * FROM qcu_file WHERE qcu01=sr.qcg.qcg01
                                  AND qcu03=sr.qcg.qcg03
         FOREACH qcu_cur INTO l_qcu.*
             LET l_qce03 = NULL
             SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
         EXECUTE insert_prep1 USING l_qcu.qcu01,l_qcu.qcu02,l_qcu.qcu021,
                                    l_qcu.qcu03,l_qcu.qcu04,l_qcu.qcu05,
                                    l_qce03
         END FOREACH
 
         #備註
         DECLARE qcv_cur CURSOR FOR
            SELECT * FROM qcv_file WHERE qcv01 =sr.qcg.qcg01
                                         AND qcv03 =sr.qcg.qcg03
         FOREACH qcv_cur INTO l_qcv.*
          EXECUTE insert_prep2 USING l_qcv.qcv01,l_qcv.qcv02,l_qcv.qcv021,
                                     l_qcv.qcv03,l_qcv.qcv04
         END FOREACH
#MOD-870027-end-add
#        OUTPUT TO REPORT r455_rep(sr.*)
#FUN-730009.....end
     END FOREACH
#FUN-730009.....begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     CALL cl_wcchp(tm.wc,'qcf01,qcf021,qcf03,qcf02,qcf13')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730113
   #MOD-870027-begin-modify
   # LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
   #MOD-870027-end-modify
   # CALL cl_prt_cs3('aqcr455',l_sql,g_str)        #TQC-730113
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "qcf01"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('aqcr455','aqcr455',l_sql,g_str)
 
#    FINISH REPORT r455_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
#FUN-730009.....bgein mark
#REPORT r455_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
#          l_gen02      LIKE gen_file.gen02,
#          l_pmc03      LIKE pmc_file.pmc03,
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          l_ima109     LIKE ima_file.ima109,
#          l_sfb22      LIKE sfb_file.sfb22,
#          l_occ02      LIKE occ_file.occ02,
#          l_gem02      LIKE gem_file.gem02,
#          l_azf03      LIKE azf_file.azf03,
#          l_ima15      LIKE ima_file.ima15,
#          l_qce03      LIKE qce_file.qce03,
#          l_qcv04      LIKE qcv_file.qcv04,  #bugno:6010 add
#          l_qcf09      LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(4)
#          l_qcg05      LIKE aba_file.aba18,         #No.FUN-680104 VARCHAR(2)
#          qcf21_desc   LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(4)
#          qcg08_desc   LIKE ze_file.ze03,        #No.FUN-680104 VARCHAR(4)
#          l_qcu        RECORD LIKE qcu_file.*,
#          l_g_x_25     LIKE qcv_file.qcv04,         #No.FUN-680104 VARCHAR(9)
#          l_g_x_26     LIKE qcs_file.qcs03,         #No.FUN-680104 VARCHAR(9)
#          sr        RECORD
#                    qcf        RECORD LIKE qcf_file.*,
#                    qcg        RECORD LIKE qcg_file.*
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.qcf.qcf01,sr.qcg.qcg03
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcf.qcf13
#      SELECT ima02,ima021,ima109
#        INTO l_ima02,l_ima021,l_ima109
#        FROM ima_file
#       WHERE ima01=sr.qcf.qcf021
#      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=l_ima109 AND azf02='8'
#      SELECT sfb22,occ02,gem02
#        INTO l_sfb22,l_occ02,l_gem02
#        FROM sfb_file,gem_file,occ_file,oea_file
#       WHERE sfb01=sr.qcf.qcf02 AND sfb22=oea01 AND oea03=occ01 AND sfb82=gem01
#      IF STATUS THEN LET l_sfb22='' LET l_occ02='' LET l_gem02='' END IF
#      CASE sr.qcf.qcf09
#           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_qcf09
#           WHEN '2' CALL cl_getmsg('aqc-005',g_lang) RETURNING l_qcf09
#           WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_qcf09
#      END CASE
#      CASE sr.qcf.qcf21
#           WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcf21_desc
#           WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcf21_desc
#           WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcf21_desc
#      END CASE
#
#      PRINT COLUMN 01,g_x[11] CLIPPED,sr.qcf.qcf01,
##            COLUMN 23,g_x[28] CLIPPED,sr.qcf.qcf03,' ',sr.qcf.qcf05 USING '#&',
##            COLUMN 55,g_x[16] CLIPPED,sr.qcf.qcf02
#            COLUMN 29,g_x[28] CLIPPED,sr.qcf.qcf03,' ',sr.qcf.qcf05 USING '#&',  #No.FUN-550063
#            COLUMN 62,g_x[16] CLIPPED,sr.qcf.qcf02     #No.FUN-550063
#      PRINT COLUMN 01,g_x[17] CLIPPED,sr.qcf.qcf021,
#            COLUMN 50,g_x[30] CLIPPED,l_azf03 #TQC-5A0009 46->50
#      PRINT COLUMN 01,g_x[18] CLIPPED,l_ima02 CLIPPED
#            #COLUMN 50,g_x[31] CLIPPED,qcf21_desc CLIPPED #TQC-5A0009 46->50 #TQC-5B0034 mark
#      PRINT COLUMN 01,g_x[21] CLIPPED,l_sfb22,
#            COLUMN 50,g_x[29] CLIPPED,l_occ02  #TQC-5A0009 46->50
#      PRINT COLUMN 01,g_x[22] CLIPPED,l_gem02,
#            COLUMN 50,g_x[23] CLIPPED,sr.qcf.qcf19 CLIPPED,'-',sr.qcf.qcf20, #TQC-5A0009 46->50
#            COLUMN 63,g_x[31] CLIPPED,qcf21_desc CLIPPED #TQC-5B0034 add
#      PRINT COLUMN 01,g_x[13] CLIPPED,sr.qcf.qcf04,
#            COLUMN 23,g_x[33] CLIPPED,sr.qcf.qcf041,
#            COLUMN 50,g_x[19] CLIPPED,sr.qcf.qcf22 USING '#######&', #TQC-5A0009 46->50
#            COLUMN 63,g_x[20] CLIPPED,sr.qcf.qcf06 USING '#######&'
#      PRINT COLUMN 01,g_x[34] CLIPPED,sr.qcf.qcf091 USING '#######&',
#            COLUMN 23,g_x[24] CLIPPED,l_qcf09,
#            COLUMN 50,g_x[15] CLIPPED,l_gen02 #TQC-5A0009 46->50
#      PRINT COLUMN 01,g_x[25] CLIPPED,sr.qcf.qcf12
#      PRINT g_dash2
#      PRINT g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],
#            g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.qcf.qcf01
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#      LET l_azf03=NULL #TQC-590013 add
#      SELECT azf03 INTO l_azf03 FROM azf_file
#         WHERE azf01=sr.qcg.qcg04 AND azf02='6'
#      CASE sr.qcg.qcg05
#           WHEN '1' LET l_qcg05='CR'
#           WHEN '2' LET l_qcg05='MA'
#           WHEN '3' LET l_qcg05='MI'
#      END CASE
#      CASE sr.qcg.qcg08
#           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING qcg08_desc
#           WHEN '2' CALL cl_getmsg('aqc-005',g_lang) RETURNING qcg08_desc
#      END CASE
#      PRINT COLUMN g_c[35],sr.qcg.qcg03 USING '###&', #FUN-590118
#            COLUMN g_c[36],sr.qcg.qcg04,
#            COLUMN g_c[37],l_azf03,
#            COLUMN g_c[38],l_qcg05,
#            COLUMN g_c[39],sr.qcg.qcg06 USING '###&.&&',
#            COLUMN g_c[40],sr.qcg.qcg09 USING '##&',
#            COLUMN g_c[41],sr.qcg.qcg10 USING '##&',
#            COLUMN g_c[42],cl_numfor(sr.qcg.qcg11,42,0),
#            COLUMN g_c[43],cl_numfor(sr.qcg.qcg07,43,2),
#            COLUMN g_c[44],qcg08_desc
#      LET l_g_x_26=g_x[26]
#      DECLARE qcu_cur CURSOR FOR
#         SELECT * FROM qcu_file WHERE qcu01=sr.qcg.qcg01
#                                  AND qcu03=sr.qcg.qcg03
#         FOREACH qcu_cur INTO l_qcu.*
#             SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
#             PRINT COLUMN 07,l_g_x_26,l_qcu.qcu04 CLIPPED,' ',l_qce03,
#                   COLUMN 63,l_qcu.qcu05 USING '####&.&&'
#             LET l_g_x_26='         '
#         END FOREACH
##bugno:6010 add display 單身備註 .....................................
#      DECLARE qcv_cur CURSOR FOR
#         SELECT qcv04 FROM qcv_file WHERE qcv01 =sr.qcg.qcg01
#                                      AND qcv03 =sr.qcg.qcg03
#      LET l_g_x_25=g_x[25]
#      FOREACH qcv_cur INTO l_qcv04
#          PRINT COLUMN 07,l_g_x_25,l_qcv04 CLIPPED
#          LET l_g_x_25='         '
#      END FOREACH
##bugno:6010 end ......................................................
#
#   ON LAST ROW
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
### FUN-550121
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[9]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[9]
#             PRINT g_memo
#      END IF
### END FUN-550121
#
#END REPORT
#FUN-730009.....end mark
