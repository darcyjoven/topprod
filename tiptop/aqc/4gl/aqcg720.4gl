# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aqcg720.4gl
# Descriptions...: 倉庫檢驗申請單(多單位)列印
# Date & Author..: 06/03/21 By cl 
# Modify.........: No.FUN-640193 06/04/14 By Carrier 合并aqct710/aqct720,使檢驗申請的入口程序為一支
# Modify.........: No.FUN-640193 06/04/17 By wujie   接上，同樣將報表合并為一支
# Modify.........: No.TQC-610086 06/04/19 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-730009 07/03/07 By Ray Crystal Report修改
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.TQC-750256 07/06/04 By rainy aqct710串過來時，應直接列印不要再開QBE視窗
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.TQC-AB0036 10/11/09 By suncx sybase第一階段測試BUG修改        
# Modify.........: No.FUN-B40097 11/05/28 By chenying 憑證類CR報表轉成GR
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              more    LIKE type_file.chr1          #No.FUN-680104 CAHR(1)
              END RECORD
DEFINE   g_argv1         LIKE qsa_file.qsa01       #No.FUN-680104 VARCHAR(16)
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
#No.FUN-730009 --begin
DEFINE   g_sql      STRING
DEFINE   g_str      STRING
DEFINE   l_table    STRING
#No.FUN-730009 --end
###GENGRE###START
TYPE sr1_t RECORD
    qsa01 LIKE qsa_file.qsa01,
    qsa11 LIKE qsa_file.qsa11,
    qsa02 LIKE qsa_file.qsa02,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    qsa03 LIKE qsa_file.qsa03,
    qsa04 LIKE qsa_file.qsa04,
    qsa05 LIKE qsa_file.qsa05,
    qsa10 LIKE qsa_file.qsa10,
    qsa12 LIKE qsa_file.qsa12,
    pmc03 LIKE pmc_file.pmc03,
    pmh05 LIKE pmh_file.pmh05,
    qsa06 LIKE qsa_file.qsa06,
    qsa08 LIKE qsa_file.qsa08,
    ima109 LIKE ima_file.ima109,
    azf03 LIKE azf_file.azf03,
    ima15 LIKE ima_file.ima15,
    qsa07 LIKE qsa_file.qsa07,
    img09 LIKE img_file.img09,
    qsa30 LIKE qsa_file.qsa30,
    qsa32 LIKE qsa_file.qsa32,
    qsa33 LIKE qsa_file.qsa33,
    qsa35 LIKE qsa_file.qsa35,
    ima906 LIKE ima_file.ima906,
    qsa35_1 LIKE qsa_file.qsa35,
    qsa32_1 LIKE qsa_file.qsa32,
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
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690121
 
#------------No.TQC-610086 modify
#  LET g_argv1 = ARG_VAL(1)
#  LET tm.wc    = ARG_VAL(2)
#  LET g_rep_user = ARG_VAL(3)
#  LET g_rep_clas = ARG_VAL(4)
#  LET g_template = ARG_VAL(5)
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies= '1'
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
#------------No.TQC-610086 end
 
#No.FUN-730009 --begin
   LET g_sql ="qsa01.qsa_file.qsa01,",
              "qsa11.qsa_file.qsa11,",
              "qsa02.qsa_file.qsa02,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "qsa03.qsa_file.qsa03,",
              "qsa04.qsa_file.qsa04,",
              "qsa05.qsa_file.qsa05,",
              "qsa10.qsa_file.qsa10,",
              "qsa12.qsa_file.qsa12,",
              "pmc03.pmc_file.pmc03,",
              "pmh05.pmh_file.pmh05,",
              "qsa06.qsa_file.qsa06,",
              "qsa08.qsa_file.qsa08,",
              "ima109.ima_file.ima109,",
              "azf03.azf_file.azf03,",
              "ima15.ima_file.ima15,",
              "qsa07.qsa_file.qsa07,",
              "img09.img_file.img09,",
              "qsa30.qsa_file.qsa30,",
              "qsa32.qsa_file.qsa32,",
              "qsa33.qsa_file.qsa33,",
              "qsa35.qsa_file.qsa35,",
              "ima906.ima_file.ima906,",
              "qsa35_1.qsa_file.qsa35,",
              "qsa32_1.qsa_file.qsa32,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('aqcg720',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40097
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097
      EXIT PROGRAM 
   END IF
#No.FUN-730009 --end
   #IF cl_null(g_argv1) THEN      #TQC-750256
   IF cl_null(tm.wc) THEN         #TQC-750256
      CALL g720_tm(0,0)
   ELSE
      #LET tm.wc=" qsa01='",g_argv1,"'"  #TQC-750256
      CALL g720()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g720_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 14
 
   OPEN WINDOW g720_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcg720"    #No.FUN-640193
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
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
      CONSTRUCT BY NAME tm.wc ON qsa01,qsa11,qsa12,qsa02,qsa03,qsa04,qsa05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(qsa01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_qsa"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO qsa01
                NEXT FIELD qsa01
              WHEN INFIELD(qsa12)
                CALL cl_init_qry_var()      #TQC-AB0036 add
                LET g_qryparam.form = "q_pmc"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO qsa12
                NEXT FIELD qsa12
              WHEN INFIELD(qsa02)
                CALL cl_init_qry_var()      #TQC-AB0036 add
                LET g_qryparam.form = "q_ima98"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO qsa02
                NEXT FIELD qsa02
              WHEN INFIELD(qsa03)
                CALL cl_init_qry_var()      #TQC-AB0036 add
                LET g_qryparam.form = "q_imd1"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO qsa03
                NEXT FIELD qsa03
              OTHERWISE
                EXIT CASE
          END CASE
 
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
         CLOSE WINDOW g720_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
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
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
 
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
      CLOSE WINDOW g720_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcg720'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcg720','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",
                         " '",g_rep_clas CLIPPED,"'",
                         " '",g_template CLIPPED,"'"
         CALL cl_cmdat('aqcg720',g_time,l_cmd)
      END IF
      CLOSE WINDOW g720_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g720()
   ERROR ""
END WHILE
   CLOSE WINDOW g720_w
END FUNCTION
 
FUNCTION g720()
#No.FUN-730009 --begin
   DEFINE l_str2       STRING
   DEFINE l_ima906     LIKE ima_file.ima906,
          l_qsa35      LIKE qsa_file.qsa35,
          l_qsa32      LIKE qsa_file.qsa32
#No.FUN-730009 --end
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
          sr        RECORD
                    qsa01  LIKE qsa_file.qsa01,
                    qsa11  LIKE qsa_file.qsa11,
                    qsa02  LIKE qsa_file.qsa02,
                    ima02  LIKE ima_file.ima02,
                    ima021 LIKE ima_file.ima021,
                    qsa03  LIKE qsa_file.qsa03,
                    qsa04  LIKE qsa_file.qsa04,
                    qsa05  LIKE qsa_file.qsa05,
                    qsa10  LIKE qsa_file.qsa10,
                    qsa12  LIKE qsa_file.qsa12,
                    pmc03  LIKE pmc_file.pmc03,
                    pmh05  LIKE pmh_file.pmh05,
                    qsa06  LIKE qsa_file.qsa06,
                    qsa08  LIKE qsa_file.qsa08,
                    ima109 LIKE ima_file.ima109,
                    azf03  LIKE azf_file.azf03,
                    ima15  LIKE ima_file.ima15,
                    qsa07  LIKE qsa_file.qsa07,
                    img09  LIKE img_file.img09,
                    qsa30  LIKE qsa_file.qsa30,
                    qsa32  LIKE qsa_file.qsa32,
                    qsa33  LIKE qsa_file.qsa33,
                    qsa35  LIKE qsa_file.qsa35
                    END RECORD
 
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-730009 --begin
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "   ?,?,?,?,     ?, ?, ?, ?, ?, ?)"#FUN-C40020 add 4 ?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40097
        EXIT PROGRAM
     END IF
#No.FUN-730009 --end
 
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
 
     SELECT sma115 INTO g_sma115 FROM sma_file
 
#No.FUN-730009 --begin
#    LET g_len=81
#    FOR g_i=1 TO g_len
#        LET g_dash[g_i,g_i]='='
#    END FOR
#No.FUN-730009 --end
 
 
     LET l_sql = "SELECT qsa01,qsa11,qsa02,ima02,ima021,qsa03,",
                 " qsa04,qsa05,qsa10,qsa12,' ',' ',qsa06, ",
                 " qsa08,ima109,' ',ima15,qsa07,' ',qsa30,qsa32,qsa33,qsa35 ",
                 "  FROM qsa_file LEFT OUTER JOIN ima_file ON qsa02=ima01 ",
                 " WHERE ",
                 #"   AND qsa14 = '2'",   #No.FUN-640193 
                 "    ", tm.wc CLIPPED
     PREPARE g720_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE g720_curs1 CURSOR FOR g720_prepare1
#No.FUN-730009 --begin
#    CALL cl_outnam('aqcg720') RETURNING l_name
#    START REPORT g720_rep TO l_name
#    LET g_pageno = 0
#No.FUN-730009 --end
     FOREACH g720_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#No.FUN-730009 --begin
         SELECT pmc03 INTO sr.pmc03 FROM pmc_file WHERE pmc01=sr.qsa12
         SELECT azf03 INTO sr.azf03 FROM azf_file WHERE azf01=sr.ima109 AND azf02='8' AND ima01=sr.qsa02
         SELECT pmh05 INTO sr.pmh05 FROM pmh_file,aza_file
          WHERE pmh01=sr.qsa02
            AND pmh02=sr.qsa12
            AND pmh13=aza17
            AND pmh21 = " "                                             #CHI-860042                                                 
            AND pmh22 = '1'                                             #CHI-860042
            AND pmh23 = ' '                                             #No.CHI-960033
            AND pmhacti = 'Y'                                           #CHI-910021
         SELECT img09 INTO sr.img09 FROM img_file,qsa_file
          WHERE img01=sr.qsa02
            AND img02=sr.qsa03
            AND img03=sr.qsa04
            AND img04=sr.qsa05
         SELECT ima906 INTO l_ima906
           FROM ima_file
          WHERE ima01=sr.qsa02
         LET l_str2 = ""
         IF g_sma115 = "Y" THEN
            CALL cl_remove_zero(sr.qsa35) RETURNING l_qsa35 
            CALL cl_remove_zero(sr.qsa32) RETURNING l_qsa32
         END IF
         EXECUTE insert_prep USING sr.*,l_ima906,l_qsa35,l_qsa32,"",  l_img_blob,"N",""  # No.FUN-C40020 add
#        OUTPUT TO REPORT g720_rep(sr.*)
#No.FUN-730009 --end
     END FOREACH
 
#No.FUN-730009 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'qsa01,qsa11,qsa12,qsa02,qsa03,qsa04,qsa05')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05,";",g_sma115
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730113
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   # CALL cl_prt_cs3('aqcg720',l_sql,g_str)         #TQC-730113
###GENGRE###     CALL cl_prt_cs3('aqcg720','aqcg720',l_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "qsa01"                    # No.FUN-C40020 add
    CALL aqcg720_grdata()    ###GENGRE###
#    FINISH REPORT g720_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-730009 --end
END FUNCTION
 
#No.FUN-730009 --begin
#REPORT g720_rep(sr)
#   DEFINE l_str2       STRING
#   DEFINE l_ima906     LIKE ima_file.ima906,
#          l_qsa35      LIKE qsa_file.qsa35,
#          l_qsa32      LIKE qsa_file.qsa32
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#          l_pmc03      LIKE pmc_file.pmc03,
#          l_pmh05      LIKE pmh_file.pmh05,
#          l_ima02      LIKE ima_file.ima02,
#          l_ima09      LIKE ima_file.ima09,
#          l_ima021     LIKE ima_file.ima021,
#          l_ima109     LIKE ima_file.ima109,
#          l_azf03      LIKE azf_file.azf03,
#          l_ima15      LIKE ima_file.ima15,
#          l_img09      LIKE img_file.img09,
#          sr        RECORD
#                    qsa01  LIKE qsa_file.qsa01,
#                    qsa11  LIKE qsa_file.qsa11,
#                    qsa02  LIKE qsa_file.qsa02,
#                    ima02  LIKE ima_file.ima02,
#                    ima021 LIKE ima_file.ima021,
#                    qsa03  LIKE qsa_file.qsa03,
#                    qsa04  LIKE qsa_file.qsa04,
#                    qsa05  LIKE qsa_file.qsa05,
#                    qsa10  LIKE qsa_file.qsa10,
#                    qsa12  LIKE qsa_file.qsa12,
#                    pmc03  LIKE pmc_file.pmc03,
#                    pmh05  LIKE pmh_file.pmh05,
#                    qsa06  LIKE qsa_file.qsa06,
#                    qsa08  LIKE qsa_file.qsa08,
#                    ima109 LIKE ima_file.ima109,
#                    azf03  LIKE azf_file.azf03,
#                    ima15  LIKE ima_file.ima15,
#                    qsa07  LIKE qsa_file.qsa07,
#                    img09  LIKE img_file.img09,
#                    qsa30  LIKE qsa_file.qsa30,
#                    qsa32  LIKE qsa_file.qsa32,
#                    qsa33  LIKE qsa_file.qsa33,
#                    qsa35  LIKE qsa_file.qsa35
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.qsa01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.qsa01
#      SKIP TO TOP OF PAGE
# 
#      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.qsa12
#      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima109 AND azf02='8' AND ima01=sr.qsa02
#      SELECT pmh05 INTO l_pmh05 FROM pmh_file,aza_file
#       WHERE pmh01=sr.qsa02
#         AND pmh02=sr.qsa12
#         AND pmh13=aza17
#      SELECT img09 INTO l_img09 FROM img_file,qsa_file
#       WHERE img01=sr.qsa02
#         AND img02=sr.qsa03
#         AND img03=sr.qsa04
#         AND img04=sr.qsa05
#
#     #單位注解      
#      SELECT ima906 INTO l_ima906
#        FROM ima_file
#       WHERE ima01=sr.qsa02
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.qsa35) RETURNING l_qsa35 
#                LET l_str2 = l_qsa35 USING '<<<<<<<<.<<' , sr.qsa33 CLIPPED
#                IF cl_null(sr.qsa35) OR sr.qsa35 = 0 THEN
#                    CALL cl_remove_zero(sr.qsa32) RETURNING l_qsa32
#                    LET l_str2 = l_qsa32 USING '<<<<<<<<.<<', sr.qsa30 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.qsa32) AND sr.qsa32 > 0 THEN
#                      CALL cl_remove_zero(sr.qsa32) RETURNING l_qsa32
#                      LET l_str2 = l_str2 CLIPPED,',',l_qsa32 USING '<<<<<<<<.<<', sr.qsa30 CLIPPED
#                   END IF
#                  END IF
#            WHEN "3"
#                IF NOT cl_null(sr.qsa35) AND sr.qsa35 > 0 THEN
#                    CALL cl_remove_zero(sr.qsa35) RETURNING l_qsa35
#                    LET l_str2 = l_qsa35 USING '<<<<<<<<.<<', sr.qsa33 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#
#      PRINT COLUMN 01,g_x[11] CLIPPED,sr.qsa01,
#            COLUMN 48,g_x[22] CLIPPED,sr.qsa08
#      PRINT COLUMN 03,g_x[12] CLIPPED,sr.qsa11
#      PRINT COLUMN 01,g_x[13] CLIPPED,sr.qsa02[1,30],
#            COLUMN 46,g_x[23] CLIPPED,sr.ima109 CLIPPED,' ',l_azf03
#      PRINT COLUMN 05,g_x[14] CLIPPED,sr.ima02[1,30],
#            COLUMN 50,g_x[24] CLIPPED,sr.ima15
#      PRINT COLUMN 05,g_x[15] CLIPPED,sr.ima021[1,30]
#      PRINT COLUMN 05,g_x[16] CLIPPED,sr.qsa03,
#            COLUMN 50,g_x[25] CLIPPED,sr.qsa07[1,30] CLIPPED
#      PRINT COLUMN 05,g_x[17] CLIPPED,sr.qsa04 CLIPPED
#      PRINT COLUMN 05,g_x[18] CLIPPED,sr.qsa05 CLIPPED
#      PRINT COLUMN 05,g_x[19] CLIPPED,sr.qsa10 CLIPPED,
#            COLUMN 50,g_x[26] CLIPPED,l_img09 CLIPPED
#      PRINT COLUMN 01,g_x[20] CLIPPED,sr.qsa12 CLIPPED,' ',l_pmc03 CLIPPED, ' ',l_pmh05 CLIPPED;
##No.FUN-640193--begin                                                                                                               
#      IF g_sma115 ='Y' OR l_ima906 MATCHES '[23]' THEN                                                                                               
#         PRINT COLUMN 46,g_x[27] CLIPPED,l_str2 CLIPPED                                                                            
#      ELSE                                                                                                                          
#         PRINT                                                                                                                      
#      END IF                                                                                                                        
##No.FUN-640193--end  
#      PRINT COLUMN 03,g_x[21] CLIPPED,sr.qsa06 CLIPPED
# 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#
#END REPORT
#No.FUN-730009 --end
 

###GENGRE###START
FUNCTION aqcg720_grdata()
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
        LET handler = cl_gre_outnam("aqcg720")
        IF handler IS NOT NULL THEN
            START REPORT aqcg720_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY qsa01" 
            DECLARE aqcg720_datacur1 CURSOR FROM l_sql
            FOREACH aqcg720_datacur1 INTO sr1.*
                OUTPUT TO REPORT aqcg720_rep(sr1.*)
            END FOREACH
            FINISH REPORT aqcg720_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aqcg720_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_qsa12_pmc03_pmh05   STRING   #FUN-B40097
    DEFINE l_ima109_azf03        STRING   #FUN-B40097
    DEFINE l_str_1               STRING   #FUN-B40097
    DEFINE l_qsa35_1             STRING   #FUN-B40097
    DEFINE l_qsa32_1             STRING   #FUN-B40097
    DEFINE l_str2                STRING   #FUN-B40097
    DEFINE l_display             STRING   #FUN-B40097
    
    ORDER EXTERNAL BY sr1.qsa01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_sma115               #FUN-B40097
              
        BEFORE GROUP OF sr1.qsa01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40097-----add-----str--------------
            LET sr1.ima02 = sr1.ima02[1,30]
            LET sr1.ima021 = sr1.ima021[1,30]
            LET l_ima109_azf03 = sr1.ima109,' ',sr1.azf03
            LET sr1.qsa02 = sr1.qsa02[1,30]
            LET sr1.qsa07 = sr1.qsa07[1,30]
            LET l_qsa12_pmc03_pmh05 = sr1.qsa12,' ',sr1.pmc03,' ',sr1.pmh05
            PRINTX l_ima109_azf03
            PRINTX l_qsa12_pmc03_pmh05 

            LET l_qsa32_1 = sr1.qsa32_1
            LET l_qsa35_1 = sr1.qsa35_1
            IF cl_null(sr1.qsa35) OR sr1.qsa35 = 0 THEN
               LET l_str_1 = l_qsa32_1,sr1.qsa30
            ELSE
               IF NOT cl_null(sr1.qsa32) AND sr1.qsa32 > 0 THEN
                  LET l_str_1 = l_qsa35_1,sr1.qsa33,',',l_qsa32_1,sr1.qsa30
               ELSE
                  LET l_str_1 = l_qsa35_1,sr1.qsa33
               END IF
            END IF
            PRINTX l_str_1

            IF sr1.ima906 = '2' THEN
               LET l_str2 = l_str_1
            ELSE 
               IF sr1.ima906 = '3' THEN
                  IF NOT cl_null(sr1.qsa35) AND sr1.qsa35> 0 THEN
                     LET l_str2 = l_qsa35_1,sr1.qsa33
                  ELSE
                     LET l_str2 = NULL
                  END IF
               END IF
           END IF
           PRINTX l_str2 


            IF g_sma115 = 'Y' OR sr1.ima906 = '2' OR sr1.ima906 = '3' THEN
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF
            PRINTX l_display
            #FUN-B40097-----add-----end--------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.qsa01

        
        ON LAST ROW

END REPORT
###GENGRE###END
