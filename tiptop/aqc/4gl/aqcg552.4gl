# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aqcg552.4gl
# Descriptions...: PQC 檢驗報告
# Date & Author..: 99/05/10 By Melody
# Modify.........: NO.FUN-550063 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-550121 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-570243 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: NO.MOD-590501 05/10/03 BY yiting 報表位置不正確、調整  請看貼圖 (料號放大請先不處理)
# Modify.........: NO.TQC-5A0009 05/10/06 BY kim 料號放大
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 報表調整
# Modify.........: No.FUN-5B0059 06/01/03 By Sarah 當(cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)時才CALL g552_tm()
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-730009 07/03/06 By Judy Crystal Report修改
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.CHI-8A0040 08/10/31 By claire 不良原因改寫子報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50053 10/05/25 By liuxqa 追单MOD-980259
# Modify.........: No.TQC-B30078 11/03/10 By destiny tm.wc长度不够
# Modify.........: No.FUN-B40087 11/05/11 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/12 By wangrr GR程式優化
# Modify.........: No.FUN-C30085 12/06/29 By lixiang 修改缺点数欄位小數取位問題 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
             #wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)  #TQC-B30078
              wc      STRING,                      #TQC-B30078                 
              more    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5       #count/index for any purpose        #No.FUN-680104 SMALLINT
#FUN-730009.....begin 
DEFINE   g_sql     STRING
DEFINE   l_table   STRING
DEFINE   l_table1  STRING   #CHI-8A0040 
DEFINE   g_str     STRING
#FUN-730009.....end
###GENGRE###START
TYPE sr1_t RECORD
    qcm01 LIKE qcm_file.qcm01,
    qcm02 LIKE qcm_file.qcm02,
    qcm021 LIKE qcm_file.qcm021,
    qcm03 LIKE qcm_file.qcm03,
    qcm04 LIKE qcm_file.qcm04,
    qcm041 LIKE qcm_file.qcm041,
    qcm05 LIKE qcm_file.qcm05,
    qcm06 LIKE qcm_file.qcm06,
    qcm09 LIKE qcm_file.qcm09,
    qcm091 LIKE qcm_file.qcm091,
    qcm12 LIKE qcm_file.qcm12,
    qcm21 LIKE qcm_file.qcm21,
    qcm22 LIKE qcm_file.qcm22,
    qcn03 LIKE qcn_file.qcn03,
    qcn04 LIKE qcn_file.qcn04,
    qcn05 LIKE qcn_file.qcn05,
    qcn06 LIKE qcn_file.qcn06,
    qcn07 LIKE qcn_file.qcn07,
    qcn08 LIKE qcn_file.qcn08,
    qcn09 LIKE qcn_file.qcn09,
    qcn10 LIKE qcn_file.qcn10,
    qcn11 LIKE qcn_file.qcn11,
    qce03 LIKE qce_file.qce03,
    qcu04 LIKE qcu_file.qcu04,
    qcu05 LIKE qcu_file.qcu05,
    qcv04 LIKE qcv_file.qcv04,
    azf03 LIKE azf_file.azf03,
    ima02 LIKE ima_file.ima02,
    ecm45 LIKE ecm_file.ecm45,
    eca02 LIKE eca_file.eca02,
    gen02 LIKE gen_file.gen02,
    azf03a LIKE azf_file.azf03,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD

TYPE sr2_t RECORD
    qcu01 LIKE qcu_file.qcu01,
    qcu02 LIKE qcu_file.qcu02,
    qcu021 LIKE qcu_file.qcu021,
    qcu03 LIKE qcu_file.qcu03,
    qcu04 LIKE qcu_file.qcu04,
    qcu05 LIKE qcu_file.qcu05,
    qce03 LIKE qce_file.qce03
END RECORD
###GENGRE###END

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
#FUN-730009.....begin
   LET g_sql = "qcm01.qcm_file.qcm01,qcm02.qcm_file.qcm02,",
               "qcm021.qcm_file.qcm021,qcm03.qcm_file.qcm03,",
               "qcm04.qcm_file.qcm04,qcm041.qcm_file.qcm041,",
               "qcm05.qcm_file.qcm05,qcm06.qcm_file.qcm06,",
               "qcm09.qcm_file.qcm09,qcm091.qcm_file.qcm091,",
               "qcm12.qcm_file.qcm12,qcm21.qcm_file.qcm21,",
               "qcm22.qcm_file.qcm22,qcn03.qcn_file.qcn03,",
               "qcn04.qcn_file.qcn04,qcn05.qcn_file.qcn05,",
               "qcn06.qcn_file.qcn06,qcn07.qcn_file.qcn07,",
               "qcn08.qcn_file.qcn08,qcn09.qcn_file.qcn09,",
               "qcn10.qcn_file.qcn10,qcn11.qcn_file.qcn11,",
               "qce03.qce_file.qce03,qcu04.qcu_file.qcu04,",
               "qcu05.qcu_file.qcu05,qcv04.qcv_file.qcv04,",
               "azf03.azf_file.azf03,ima02.ima_file.ima02,",
               "ecm45.ecm_file.ecm45,eca02.eca_file.eca02,",
               "gen02.gen_file.gen02,azf03a.azf_file.azf03,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('aqcg552',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087
      EXIT PROGRAM 
   END IF
   #CHI-8A0040-begin-mark
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
   #            " VALUES(?,?,?,?,?,?,?,?,?,?,",
   #            "        ?,?,?,?,?,?,?,?,?,?,?,",
   #            "        ?,?,?,?,?,?,?,?,?,?,?)"
   #PREPARE insert_prep FROM g_sql
   #IF STATUS THEN 
   #   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   #END IF
   #CHI-8A0040-end-mark
#FUN-730009.....end
   #CHI-8A0040-begin-add
   LET g_sql ="qcu01.qcu_file.qcu01,",
              "qcu02.qcu_file.qcu02,",
              "qcu021.qcu_file.qcu021,",
              "qcu03.qcu_file.qcu03,",
              "qcu04.qcu_file.qcu04,",
              "qcu05.qcu_file.qcu05,",
              "qce03.qce_file.qce03"
   LET l_table1 = cl_prt_temptable('aqcg5521',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087
      EXIT PROGRAM 
   END IF
   #CHI-8A0040-end-add
 
  #start FUN-5B0059
  #IF cl_null(g_bgjob) OR g_bgjob = 'N'
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') AND cl_null(tm.wc)
  #end FUN-5B0059
      THEN CALL g552_tm(0,0)
      ELSE CALL g552()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
END MAIN
 
FUNCTION g552_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW g552_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcg552"
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
      CONSTRUCT BY NAME tm.wc ON qcm01,qcm03,qcm02,qcm021,qcm05,qcm04,qcm13
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
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   INPUT BY NAME tm.more WITHOUT DEFAULTS #TQC-5B0034
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
      CLOSE WINDOW g552_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcg552'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcg552','9031',1)
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
         CALL cl_cmdat('aqcg552',g_time,l_cmd)
      END IF
      CLOSE WINDOW g552_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g552()
   ERROR ""
END WHILE
   CLOSE WINDOW g552_w
END FUNCTION
 
FUNCTION g552()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
   #LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680104 CAHR(1000)
          l_sql     STRING,                       #TQC-B30078
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(40)
#FUN-730009.....begin
          l_ima02   LIKE ima_file.ima02,
          l_ima109  LIKE ima_file.ima109,
          l_ecm45   LIKE ecm_file.ecm45,
          l_azf03   LIKE azf_file.azf03,
          l_azf03a  LIKE azf_file.azf03,
          l_eca02   LIKE eca_file.eca02,
          l_gen02   LIKE gen_file.gen02,
          l_qcv04   LIKE qcv_file.qcv04,
          l_qce03   LIKE qce_file.qce03,
          #CHI-8A0040-begin-modify
          #l_qcu     RECORD LIKE qcu_file.*,
          l_qcu     RECORD 
                    qcu01   LIKE qcu_file.qcu01,  
                    qcu02   LIKE qcu_file.qcu02,  
                    qcu021  LIKE qcu_file.qcu021,  
                    qcu03   LIKE qcu_file.qcu03,  
                    qcu04   LIKE qcu_file.qcu04,  
                    qcu05   LIKE qcu_file.qcu05  
                    END RECORD, 
          #CHI-8A0040-end-modify
#FUN-730009.....end
          sr        RECORD
                    qcm        RECORD LIKE qcm_file.*,
                    qcn        RECORD LIKE qcn_file.*
                    END RECORD
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)   #FUN-730009
     CALL cl_del_data(l_table1)  #CHI-8A0040
 
     #CHI-8A0040-begin-add
      LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " VALUES(?,?,?,?,?,?,?,?,?,?,",
                  "        ?,?,?,?,?,?,?,?,?,?,?,",
                  "        ?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?)"#FUN-C40020 ADD 4?
      PREPARE insert_prep FROM g_sql
      IF STATUS THEN
         CALL cl_err('insert_prep:',status,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087
         EXIT PROGRAM
      END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087
        EXIT PROGRAM
     END IF
     #CHI-8A0040-end-add
 
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
 
 
#bugno:6010 --> SQL:qcm14 = 'Y' 移除
     LET l_sql = "SELECT * FROM qcm_file, qcn_file ",
                 " WHERE qcm01=qcn01 AND qcm18='2' ",
             #   " WHERE qcm01=qcn01 AND qcm14 = 'Y' AND qcm18='2' ",
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE g552_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM
     END IF
     DECLARE g552_curs1 CURSOR FOR g552_prepare1

#FUN-C50008--add--str
     DECLARE qcu_cur CURSOR FOR
        SELECT * FROM qcu_file WHERE qcu01=? AND qcu03=?
#FUN-C50008--add--end

#FUN-730009.....begin mark
#    CALL cl_outnam('aqcg552') RETURNING l_name
#    START REPORT g552_rep TO l_name
#FUN-730009.....end mark
     LET g_pageno = 0
     FOREACH g552_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#FUN-730009.....begin
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcm.qcm13
         SELECT ima02,ima109 INTO l_ima02,l_ima109 
           FROM ima_file 
          WHERE ima01=sr.qcm.qcm021 
         SELECT azf03 INTO l_azf03 FROM azf_file 
          WHERE azf01=l_ima109 AND azf02='8'
         #FUN-A50053 --mod  str
         #SELECT ecm45,eca02 INTO l_ecm45,l_eca02 FROM ecm_file,eca_file
         # WHERE ecm06=eca01 AND ecm01=sr.qcm.qcm02 AND ecm03=sr.qcm.qcm05
         SELECT sgm45,eca02 INTO l_ecm45,l_eca02 FROM sgm_file,eca_file
          WHERE sgm06=eca01 AND sgm01=sr.qcm.qcm03 AND sgm03=sr.qcm.qcm05
         #FUN-A50053 --mod end
         IF STATUS THEN LET l_ecm45=' ' LET l_eca02=' ' END IF
         SELECT azf03 INTO l_azf03a FROM azf_file 
          WHERE azf01=sr.qcn.qcn04 AND azf02='6'
         #CHI-8A0040-begin-add
         #不良原因
      #FUN-C50008--mark--str
      #   DECLARE qcu_cur CURSOR FOR
      #     SELECT * FROM qcu_file WHERE qcu01=sr.qcn.qcn01
      #                                AND qcu03=sr.qcn.qcn03
      #   FOREACH qcu_cur INTO l_qcu.*
      #FUN-C50008--mark--end
        FOREACH qcu_cur USING sr.qcn.qcn01,sr.qcn.qcn03 INTO l_qcu.* #FUN-C50008 add
             LET l_qce03 = NULL
             SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
             EXECUTE insert_prep1 USING l_qcu.*,l_qce03
         END FOREACH
         #DECLARE qcu_cur CURSOR FOR                                          
         #  SELECT * FROM qcu_file WHERE qcu01=sr.qcn.qcn01                                                          AND qcu03=sr.qcn.qcn03                                 FOREACH qcu_cur INTO l_qcu.*                                         
         #    SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
         #  END FOREACH
         #CHI-8A0040-end-add
         SELECT qcv04 FROM qcv_file WHERE qcv01 =sr.qcn.qcn01                                                         AND qcv03 =sr.qcn.qcn03
         EXECUTE insert_prep USING sr.qcm.qcm01,sr.qcm.qcm02,sr.qcm.qcm021,
                                   sr.qcm.qcm03,sr.qcm.qcm04,sr.qcm.qcm041,
                                   sr.qcm.qcm05,sr.qcm.qcm06,sr.qcm.qcm09,
                                   sr.qcm.qcm091,sr.qcm.qcm12,sr.qcm.qcm21,
                                   sr.qcm.qcm22,sr.qcn.qcn03,sr.qcn.qcn04,
                                   sr.qcn.qcn05,sr.qcn.qcn06,sr.qcn.qcn07,
                                   sr.qcn.qcn08,sr.qcn.qcn09,sr.qcn.qcn10,
                                   sr.qcn.qcn11,l_qce03,l_qcu.qcu04,l_qcu.qcu05,
                                   l_qcv04,l_azf03,l_ima02,l_ecm45,l_eca02,
                                   l_gen02,l_azf03a,"",  l_img_blob,"N",""  # No.FUN-C40020 add 
#        OUTPUT TO REPORT g552_rep(sr.*)
#FUN-730009.....end 
     END FOREACH
#FUN-730009.....begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     CALL cl_wcchp(tm.wc,'qcm01,qcm03,qcm02,qcm021,qcm05,qcm04,qcm13')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05
  #  LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730113
    #CHI-8A0040-begin-add
    #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
    #CHI-8A0040-end-add
  #  CALL cl_prt_cs3('aqcg552',l_sql,g_str)         #TQC-730113
###GENGRE###     CALL cl_prt_cs3('aqcg552','aqcg552',l_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "qcm01"                    # No.FUN-C40020 add
    CALL aqcg552_grdata()    ###GENGRE###
#    FINISH REPORT g552_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#FUN-730009.....end
END FUNCTION
 
#FUN-730009.....begin mark
#REPORT g552_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#          l_gen02      LIKE gen_file.gen02,
#          l_pmc03      LIKE pmc_file.pmc03,
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          l_ima109     LIKE ima_file.ima109,
#          l_ecm45      LIKE ecm_file.ecm45,
#          l_eca02      LIKE eca_file.eca02,
#          l_gem02      LIKE gem_file.gem02,
#          l_azf03      LIKE azf_file.azf03,
#          l_ima15      LIKE ima_file.ima15,
#          l_qce03      LIKE qce_file.qce03,
#          l_qcv04      LIKE qcv_file.qcv04,        #bugno:6010 add
#          l_qcm09      LIKE qcf_file.qcf062,       #No.FUN-680104 VARCHAR(4)
#          l_qcn05      LIKE aba_file.aba18,        #No.FUN-680104 VARCHAR(2)
#          qcm21_desc   LIKE qcf_file.qcf062,       #No.FUN-680104 VARCHAR(4)
#          qcn08_desc   LIKE qcf_file.qcf062,       #No.FUN-680104 VARCHAR(4)
#          l_qcu        RECORD LIKE qcu_file.*,
#          l_g_x_25     LIKE qcm_file.qcm12,        #No.FUN-680104 VARCHAR(9) #bugno:6010 add
#          l_g_x_26     LIKE qcm_file.qcm12,        #No.FUN-680104 VARCHAR(9)
#          sr        RECORD
#                    qcm        RECORD LIKE qcm_file.*,
#                    qcn        RECORD LIKE qcn_file.*
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.qcm.qcm01,sr.qcn.qcn03
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
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcm.qcm13
#      SELECT ima02,ima021,ima109
#        INTO l_ima02,l_ima021,l_ima109
#        FROM ima_file
#       WHERE ima01=sr.qcm.qcm021
#      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=l_ima109 AND azf02='8'
#      CASE sr.qcm.qcm09
#           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_qcm09
#           WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING l_qcm09
#      END CASE
#      CASE sr.qcm.qcm21
#           WHEN 'N' CALL cl_getmsg('aqc-001',g_lang) RETURNING qcm21_desc
#           WHEN 'T' CALL cl_getmsg('aqc-002',g_lang) RETURNING qcm21_desc
#           WHEN 'R' CALL cl_getmsg('aqc-003',g_lang) RETURNING qcm21_desc
#      END CASE
#      SELECT ecm45,eca02 INTO l_ecm45,l_eca02 FROM ecm_file,eca_file
#       WHERE ecm06=eca01 AND ecm01=sr.qcm.qcm02 AND ecm03=sr.qcm.qcm05
#      IF STATUS THEN LET l_ecm45='' LET l_eca02='' END IF
#
#      PRINT COLUMN 01,g_x[11] CLIPPED,sr.qcm.qcm01,
##No.FUN-550063 --start--
#            COLUMN 27,g_x[9] CLIPPED,sr.qcm.qcm03,'/',sr.qcm.qcm05 USING '#&',
#            COLUMN 64,g_x[16] CLIPPED,sr.qcm.qcm02
##No.FUN-550063 ---end--
#      PRINT COLUMN 01,g_x[17] CLIPPED,sr.qcm.qcm021,
#            COLUMN 51,g_x[30] CLIPPED,l_azf03 #TQC-5A0009 46->51
#      PRINT COLUMN 01,g_x[18] CLIPPED,l_ima02 CLIPPED #TQC-5B0034
#            #COLUMN 51,g_x[31] CLIPPED,qcm21_desc CLIPPED #TQC-5A0009 46->51#TQC-5B0034 mark
#      PRINT COLUMN 01,g_x[21] CLIPPED,l_ecm45,
#            COLUMN 51,g_x[29] CLIPPED,l_eca02, #TQC-5A0009 46->51 #TQC-5B0034
#            COLUMN 64,g_x[31] CLIPPED,qcm21_desc CLIPPED #TQC-5B0034
#      PRINT COLUMN 01,g_x[13] CLIPPED,sr.qcm.qcm04,
#            COLUMN 23,g_x[33] CLIPPED,sr.qcm.qcm041,
#            COLUMN 51,g_x[19] CLIPPED,sr.qcm.qcm22 USING '#######&', #TQC-5A0009 46->51
#            COLUMN 63,g_x[20] CLIPPED,sr.qcm.qcm06 USING '#######&'
#      PRINT COLUMN 01,g_x[34] CLIPPED,sr.qcm.qcm091 USING '#######&',
#            COLUMN 23,g_x[24] CLIPPED,l_qcm09,
#            COLUMN 51,g_x[15] CLIPPED,l_gen02 #TQC-5A0009 46->51
#      PRINT COLUMN 01,g_x[25] CLIPPED,sr.qcm.qcm12
#
#      PRINT g_dash2
#      PRINT g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],
#            g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.qcm.qcm01
#      SKIP TO TOP OF PAGE
#
#
#   ON EVERY ROW
#      SELECT azf03 INTO l_azf03 FROM azf_file
#         WHERE azf01=sr.qcn.qcn04 AND azf02='6'
#      CASE sr.qcn.qcn05
#           WHEN '1' LET l_qcn05='CR'
#           WHEN '2' LET l_qcn05='MA'
#           WHEN '3' LET l_qcn05='MI'
#      END CASE
#      CASE sr.qcn.qcn08
#           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING qcn08_desc
#           WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING qcn08_desc
#      END CASE
#      PRINT COLUMN g_c[35],sr.qcn.qcn03 USING '###&', #FUN-590118
#            COLUMN g_c[36],sr.qcn.qcn04,
#            COLUMN g_c[37],l_azf03[1,14],
#            COLUMN g_c[38],l_qcn05,
#            COLUMN g_c[39],sr.qcn.qcn06 USING '##&.&&',
#            COLUMN g_c[40],sr.qcn.qcn09 USING '##&',
#            COLUMN g_c[41],sr.qcn.qcn10 USING '##&',
#            COLUMN g_c[42],cl_numfor(sr.qcn.qcn11,42,0),
#            COLUMN g_c[43],cl_numfor(sr.qcn.qcn07,43,2),
#            COLUMN g_c[44],qcn08_desc
#      LET l_g_x_26=g_x[26]
#      DECLARE qcu_cur CURSOR FOR
#         SELECT * FROM qcu_file WHERE qcu01=sr.qcn.qcn01
#                                  AND qcu03=sr.qcn.qcn03
#         FOREACH qcu_cur INTO l_qcu.*
#             SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
#            ##NO.MOD-590501----
#            #PRINT COLUMN 07,l_g_x_26 CLIPPED,
#            #      COLUMN 16,l_qcu.qcu04,
#            #      COLUMN 23,l_qce03 CLIPPED,
#            #      COLUMN 63,l_qcu.qcu05 USING '####&.&&'
#             PRINT COLUMN g_c[35],l_g_x_26 CLIPPED,
#                   COLUMN g_c[36],l_qcu.qcu04,
#                   COLUMN g_c[37],l_qce03 CLIPPED,
#                   COLUMN g_c[43],cl_numfor(l_qcu.qcu05,43,2)
#            ##NO.MOD-590501(end)----
#             LET l_g_x_26='         '
#         END FOREACH
##bugno:6010 add display 單身備註 .....................................
#      DECLARE qcv_cur CURSOR FOR
#         SELECT qcv04 FROM qcv_file WHERE qcv01 =sr.qcn.qcn01
#                                      AND qcv03 =sr.qcn.qcn03
#      LET l_g_x_25=g_x[25]
#      FOREACH qcv_cur INTO l_qcv04
#          PRINT COLUMN 07,l_g_x_25,l_qcv04 CLIPPED
#          LET l_g_x_25='         '
#      END FOREACH
##bugno:6010 end ......................................................
#
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
#             PRINT g_x[10]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[10]
#             PRINT g_memo
#      END IF
### END FUN-550121
#
#END REPORT
#FUN-730009.....end mark

###GENGRE###START
FUNCTION aqcg552_grdata()
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
        LET handler = cl_gre_outnam("aqcg552")
        IF handler IS NOT NULL THEN
            START REPORT aqcg552_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY qcm01,qcn03" 
          
            DECLARE aqcg552_datacur1 CURSOR FROM l_sql
            FOREACH aqcg552_datacur1 INTO sr1.*
                OUTPUT TO REPORT aqcg552_rep(sr1.*)
            END FOREACH
            FINISH REPORT aqcg552_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aqcg552_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_qcm21_desc  STRING
    DEFINE l_qcm09       STRING
    DEFINE l_qcn05       STRING 
    DEFINE l_qcn08_desc  STRING
    DEFINE l_sql         STRING
    DEFINE l_qcn07       STRING  #FUN-C30085 add   
 
    ORDER EXTERNAL BY sr1.qcm01,sr1.qcn03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.qcm01
            LET l_lineno = 0
            #FUN-B40087  ADD --------STR -----
            IF sr1.qcm21 = 'N' OR sr1.qcm21 = 'T' OR sr1.qcm21 = 'R' THEN
               LET l_qcm21_desc = cl_gr_getmsg("gre-108",g_lang,sr1.qcm21)
            ELSE
               LET l_qcm21_desc = NULL
            END IF
            PRINTX l_qcm21_desc

            IF sr1.qcm09 = '1' THEN
               LET l_qcm09 = cl_gr_getmsg("gre-104",g_lang,'1')
            ELSE
               LET l_qcm09 = cl_gr_getmsg("gre-104",g_lang,'2')
            END IF
            PRINTX l_qcm09 
            #FUN-B40087  ADD --------END -----  
 
        BEFORE GROUP OF sr1.qcn03

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B40087  ADD --------STR ----- 
            IF sr1.qcn05 = "1" THEN
               LET l_qcn05 = "CR"
            ELSE IF sr1.qcn05 = "2" THEN
                    LET l_qcn05 = "MA"
                 ELSE IF sr1.qcn05 = "3" THEN
                         LET l_qcn05 = "MI"
                      ELSE 
                         LET l_qcn05 = ""
                      END IF
                 END IF
            END IF
            PRINTX l_qcn05
            IF sr1.qcn08 = '1' THEN
               LET l_qcn08_desc = cl_gr_getmsg("gre-104",g_lang,'1')
            ELSE
               LET l_qcn08_desc = cl_gr_getmsg("gre-104",g_lang,'2')
            END IF
            PRINTX l_qcn08_desc

            #FUN-C30085--add---begin---
            IF sr1.qcn07 = 0 THEN
               LET l_qcn07 = '0' 
            ELSE
               LET l_qcn07 = sr1.qcn07
            END IF
            PRINTX l_qcn07
            #FUN-C30085--add---end---
 
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE qcu01 = '",sr1.qcm01 CLIPPED,"'",
                        " AND qcu03 =  ",sr1.qcn03 CLIPPED
            START REPORT aqcg552_subrep01
            DECLARE aqcg552_repcur1 CURSOR FROM l_sql
            FOREACH aqcg552_repcur1 INTO sr2.*
                OUTPUT TO REPORT aqcg552_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT aqcg552_subrep01
            #FUN-B40087  ADD --------END -----
              
            PRINTX sr1.*

        AFTER GROUP OF sr1.qcm01
        AFTER GROUP OF sr1.qcn03

        
        ON LAST ROW

END REPORT
#FUN-B40087  ADD --------STR -----
REPORT aqcg552_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_qcu04_qce03    STRING
    DEFINE l_n              LIKE type_file.num5

    ORDER EXTERNAL BY sr2.qcu01

    FORMAT
        BEFORE GROUP OF sr2.qcu01
            LET l_n = 0  

        ON EVERY ROW
            LET l_n = l_n + 1
            PRINTX l_n

            LET l_qcu04_qce03 = sr2.qcu04,' ',sr2.qce03
            PRINTX l_qcu04_qce03
            PRINTX sr2.*
END REPORT
#FUN-B40087  ADD --------END -----
###GENGRE###END
