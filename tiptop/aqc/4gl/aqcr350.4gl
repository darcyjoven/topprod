# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aqcr350.4gl
# Descriptions...: PQC 檢驗報告
# Date & Author..: 99/05/10 By Melody
# Modify.........: NO.FUN-550063 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-550121 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-570243 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-590013 05/09/28 By Rosayu當單頭有資料而單身沒資料時無法列印
# Modify.........: No.FUN-590110 05/09/29 By day  報表轉xml
# Modify.........: No.TQC-5B0034 05/11/08 by Rosayu 品名規格調整
# Modify.........: No.TQC-5B0108 05/11/12 by Claire 單據長度調整
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-730009 07/03/06 By Ray Crystal Report修改
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.MOD-870310 07/07/29 By claire 備註改為子報表寫法
# Modify.........: No.TQC-960249 09/06/22 By destiny修改子報表寫法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50053 10/05/31 By liuxqa 改用temp table 的方式执行报表
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-B30081 11/03/10 By destiny tm.wc长度不够
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
# Modify.........: No:TQC-C90118 12/09/28 By chenjing PQC單號，工單編號，工藝序，檢驗員欄位建議增加開窗處理
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
             #wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              wc      STRING,                      #TQC-B30081
              more    LIKE type_file.chr1          #No.FUN-680104 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
#No.FUN-730009 --begin
DEFINE  g_str      STRING
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING
DEFINE  l_table2   STRING
DEFINE  l_table3   STRING
DEFINE  l_table4   STRING
DEFINE  l_table5   STRING
#No.FUN-730009 --end
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
#No.FUN-730009 --begin
   LET g_sql ="qcm01.qcm_file.qcm01,",
              "qcm02.qcm_file.qcm02,",
              "qcm021.qcm_file.qcm021,",
              "qcm04.qcm_file.qcm04,",
              "qcm041.qcm_file.qcm041,",
              "qcm05.qcm_file.qcm05,",
              "qcm06.qcm_file.qcm06,",
              "qcm09.qcm_file.qcm09,",
              "qcm091.qcm_file.qcm091,",
              "qcm21.qcm_file.qcm21,",
              "qcm22.qcm_file.qcm22,",
              "qcn01.qcn_file.qcn01,",
              "qcn03.qcn_file.qcn03,",
              "qcn04.qcn_file.qcn04,",
              "qcn05.qcn_file.qcn05,",
              "qcn06.qcn_file.qcn06,",
              "qcn07.qcn_file.qcn07,",
              "qcn08.qcn_file.qcn08,",
              "qcn09.qcn_file.qcn09,",
              "qcn10.qcn_file.qcn10,",
              "qcn11.qcn_file.qcn11,",
              "gen02.gen_file.gen02,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ima109.ima_file.ima109,",
              "azf03_1.azf_file.azf03,",
              "azf03_2.azf_file.azf03,",
              "ecm45.ecm_file.ecm45,",
              "eca02.eca_file.eca02,",
              "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
              "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
              "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

   LET l_table = cl_prt_temptable('aqcr350',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_1.qao_file.qao01,",
              "qao02_1.qao_file.qao02,",
              "qao021_1.qao_file.qao021,",
              "qao03_1.qao_file.qao03,",
              "qao05_1.qao_file.qao05,",
              "qao06_1.qao_file.qao06"
   LET l_table1 = cl_prt_temptable('aqcr3501',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_2.qao_file.qao01,",
              "qao02_2.qao_file.qao02,",
              "qao021_2.qao_file.qao021,",
              "qao03_2.qao_file.qao03,",
              "qao05_2.qao_file.qao05,",
              "qao06_2.qao_file.qao06"
   LET l_table2 = cl_prt_temptable('aqcr3502',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_3.qao_file.qao01,",
              "qao02_3.qao_file.qao02,",
              "qao021_3.qao_file.qao021,",
              "qao03_3.qao_file.qao03,",
              "qao05_3.qao_file.qao05,",
              "qao06_3.qao_file.qao06"
   LET l_table3 = cl_prt_temptable('aqcr3503',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_4.qao_file.qao01,",
              "qao02_4.qao_file.qao02,",
              "qao021_4.qao_file.qao021,",
              "qao03_4.qao_file.qao03,",
              "qao05_4.qao_file.qao05,",
              "qao06_4.qao_file.qao06"
   LET l_table4 = cl_prt_temptable('aqcr3504',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qcu01.qcu_file.qcu01,",
              "qcu02.qcu_file.qcu02,",
              "qcu021.qcu_file.qcu021,",
              "qcu03.qcu_file.qcu03,",
              "qcu04.qcu_file.qcu04,",
              "qcu05.qcu_file.qcu05,",
              "qce03.qce_file.qce03"
   LET l_table5 = cl_prt_temptable('aqcr3505',g_sql) CLIPPED
   IF l_table5 = -1 THEN EXIT PROGRAM END IF
#No.FUN-730009 --end
   CALL r350_cre_tmp()     #FUN-A50053 add 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r350_tm(0,0)
      ELSE CALL r350()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r350_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r350_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr350"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
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
      CONSTRUCT BY NAME tm.wc ON qcm01,qcm02,qcm021,qcm05,qcm04,qcm13
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
         IF INFIELD(qcm021) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcm021
              NEXT FIELD qcm021
         END IF
    #TQC-C90118--start--
         IF INFIELD(qcm01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_qcm1"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcm01 
            NEXT FIELD qcm01 
         END IF
         IF INFIELD(qcm02) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_qcm02"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcm02 
            NEXT FIELD qcm02 
         END IF
         IF INFIELD(qcm05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_qcm4"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcm05 
            NEXT FIELD qcm05 
         END IF
         IF INFIELD(qcm13) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen02"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcm13 
            NEXT FIELD qcm13 
         END IF
    #TQC-C90118--end---
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
      CLOSE WINDOW r350_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr350'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr350','9031',1)
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
         CALL cl_cmdat('aqcr350',g_time,l_cmd)
      END IF
      CLOSE WINDOW r350_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r350()
   ERROR ""
END WHILE
   CLOSE WINDOW r350_w
END FUNCTION
 
FUNCTION r350()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000) #TQC-B30081
          l_sql     STRING,                       #TQC-B30081
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
#No.FUN-730009 --begin
          l_gen02      LIKE gen_file.gen02,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_ima109     LIKE ima_file.ima109,
          l_azf03_1    LIKE azf_file.azf03,
          l_azf03_2    LIKE azf_file.azf03,
          l_qao01      LIKE qao_file.qao01,
          l_qao02      LIKE qao_file.qao02,
          l_qao021     LIKE qao_file.qao021,
          l_qao03      LIKE qao_file.qao03,
          l_qao05      LIKE qao_file.qao05,
          l_qao06      LIKE qao_file.qao06,
          l_qce03      LIKE qce_file.qce03,
          l_ecm45      LIKE ecm_file.ecm45,
          l_eca02      LIKE eca_file.eca02,
          l_qcu        RECORD LIKE qcu_file.*,
#No.FUN-730009 --end
          sr        RECORD
                     qcm        RECORD LIKE qcm_file.*,
                     qcn        RECORD LIKE qcn_file.*
                    END RECORD,
#FUN-A50053 add --begin                    
          sr1       RECORD
              qcm01  LIKE qcm_file.qcm01,
              qcm02  LIKE qcm_file.qcm02,
              qcm021 LIKE qcm_file.qcm021,
              qcm04  LIKE qcm_file.qcm04,
              qcm041 LIKE qcm_file.qcm041,
              qcm05  LIKE qcm_file.qcm05,
              qcm06  LIKE qcm_file.qcm06,
              qcm09  LIKE qcm_file.qcm09,
              qcm091 LIKE qcm_file.qcm091,
              qcm21  LIKE qcm_file.qcm21,
              qcm22  LIKE qcm_file.qcm22,
              qcn01  LIKE qcn_file.qcn01,
              qcn03  LIKE qcn_file.qcn03,
              qcn04  LIKE qcn_file.qcn04,
              qcn05  LIKE qcn_file.qcn05,
              qcn06  LIKE qcn_file.qcn06,
              qcn07  LIKE qcn_file.qcn07,
              qcn08  LIKE qcn_file.qcn08,
              qcn09  LIKE qcn_file.qcn09,
              qcn10  LIKE qcn_file.qcn10,
              qcn11  LIKE qcn_file.qcn11,
              gen02  LIKE gen_file.gen02,
              ima02  LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021,
              ima109 LIKE ima_file.ima109,
             azf03_1 LIKE azf_file.azf03,
             azf03_2 LIKE azf_file.azf03,
              ecm45  LIKE ecm_file.ecm45,
              eca02  LIKE eca_file.eca02 
                    END RECORD                  
    DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039 
#FUN-A50053 add --end 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#No.FUN-730009 --begin
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
     CALL cl_del_data(l_table5)
     DISPLAY l_table
     DISPLAY l_table1
     DISPLAY l_table2
     DISPLAY l_table3
     DISPLAY l_table4
     DISPLAY l_table5
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)"   #TQC-C10039 ADD 4?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep3:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep4 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep4:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep5 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep5:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
#No.FUN-730009 --end
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
     #LET l_sql = "SELECT * FROM qcm_file,OUTER qcn_file ", #TQC-590013 add OUTER  #FUN-A50053 mark
     LET l_sql = "SELECT * FROM qcm_file LEFT OUTER JOIN qcn_file ON qcm01 = qcn01 ", #TQC-590013 add OUTER     
                 " WHERE qcm18='1' ",   #FUN-A50053 mod
#                 " WHERE qcm_file.qcm01=qcn_file.qcn01 AND qcm18='1' ",  #FUN-A50053 mark                
#                " WHERE qcm_file.qcm01=qcn_file.qcn01 AND qcm14 = 'Y' AND qcm18='1' ",
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r350_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r350_curs1 CURSOR FOR r350_prepare1
#No.FUN-730009 --begin
#    CALL cl_outnam('aqcr350') RETURNING l_name
#    START REPORT r350_rep TO l_name
#    LET g_pageno = 0
#No.FUN-730009 --end
     DELETE FROM aqcr350_tmp     #FUN-A50053 add
     DELETE FROM aqcr3501_tmp    #FUN-A50053 add
     DELETE FROM aqcr3502_tmp    #FUN-A50053 add
     DELETE FROM aqcr3503_tmp    #FUN-A50053 add   
     DELETE FROM aqcr3504_tmp    #FUN-A50053 add 
     DELETE FROM aqcr3505_tmp    #FUN-A50053 add           
     FOREACH r350_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#No.FUN-730009 --begin
         LET l_azf03_1=NULL
         LET l_azf03_2=NULL
         LET l_gen02=NULL
         LET l_ima02=NULL
         LET l_ima021=NULL
         LET l_ima109=NULL
         LET l_ecm45=NULL
         LET l_eca02=NULL
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcm.qcm13
         SELECT ima02,ima021,ima109
           INTO l_ima02,l_ima021,l_ima109
           FROM ima_file
          WHERE ima01=sr.qcm.qcm021
         SELECT azf03 INTO l_azf03_1 FROM azf_file WHERE azf01=l_ima109 AND azf02='8'
         SELECT ecm45,eca02 INTO l_ecm45,l_eca02 FROM ecm_file,eca_file
          WHERE ecm06=eca01 AND ecm01=sr.qcm.qcm02 AND ecm03=sr.qcm.qcm05
            AND ecm012 = sr.qcm.qcm012                        #FUN-A60027
         SELECT azf03 INTO l_azf03_2 FROM azf_file
            WHERE azf01=sr.qcn.qcn04 AND azf02='6'
#FUN-A50053 mark --begin             
#         EXECUTE insert_prep USING sr.qcm.qcm01,sr.qcm.qcm02,sr.qcm.qcm021,sr.qcm.qcm04,sr.qcm.qcm041,sr.qcm.qcm05,
#                                   sr.qcm.qcm06,sr.qcm.qcm09,sr.qcm.qcm091,sr.qcm.qcm21,sr.qcm.qcm22,sr.qcn.qcn01,
#                                   sr.qcn.qcn03,sr.qcn.qcn04,sr.qcn.qcn05,sr.qcn.qcn06,sr.qcn.qcn07,sr.qcn.qcn08,
#                                   sr.qcn.qcn09,sr.qcn.qcn10,sr.qcn.qcn11,
#                                   l_gen02,l_ima02,l_ima021,l_ima109,l_azf03_1,l_azf03_2,l_ecm45,l_eca02
          INSERT INTO aqcr350_tmp VALUES (sr.qcm.qcm01,sr.qcm.qcm02,sr.qcm.qcm021,sr.qcm.qcm04,sr.qcm.qcm041,sr.qcm.qcm05, 
                                   sr.qcm.qcm06,sr.qcm.qcm09,sr.qcm.qcm091,sr.qcm.qcm21,sr.qcm.qcm22,sr.qcn.qcn01,
                                   sr.qcn.qcn03,sr.qcn.qcn04,sr.qcn.qcn05,sr.qcn.qcn06,sr.qcn.qcn07,sr.qcn.qcn08,
                                   sr.qcn.qcn09,sr.qcn.qcn10,sr.qcn.qcn11,
                                   l_gen02,l_ima02,l_ima021,l_ima109,l_azf03_1,l_azf03_2,l_ecm45,l_eca02)          
        #MOD-870310-begin-mark
         #DECLARE qao_cur1 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
         #                                       WHERE qao01=sr.qcm.qcm01
         #                                         AND qao02=0
         #                                         AND qao021=0
         #                                         AND qao03=0 AND qao05='1'
         #FOREACH qao_cur1 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #   IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
         #   EXECUTE insert_prep1 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #END FOREACH
        #MOD-870310-end-mark
         DECLARE qao_cur2 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
                                                WHERE qao01=sr.qcm.qcm01
                                                  AND qao02=0
                                                  AND qao021=0
                                                  AND qao03=sr.qcn.qcn03
                                                  AND qao05='1'
         FOREACH qao_cur2 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep2 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
            INSERT INTO aqcr3502_tmp VALUES (l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06)
         END FOREACH
         DECLARE qao_cur3 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
                                                WHERE qao01=sr.qcm.qcm01
                                                  AND qao02=0
                                                  AND qao021=0
                                                  AND qao03=sr.qcn.qcn03
                                                  AND qao05='2'
         FOREACH qao_cur3 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep3 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
            INSERT INTO aqcr3503_tmp VALUES (l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06)
         END FOREACH
        #MOD-870310-begin-mark
         #DECLARE qao_cur4 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
         #                                       WHERE qao01=sr.qcm.qcm01
         #                                         AND qao02=0
         #                                         AND qao021=0
         #                                         AND qao03=0 AND qao05='2'
         #FOREACH qao_cur4 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #   IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
         #   EXECUTE insert_prep4 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #END FOREACH
        #MOD-870310-end-mark
         DECLARE qcu_cur CURSOR FOR
            SELECT * FROM qcu_file WHERE qcu01=sr.qcn.qcn01
                                     AND qcu03=sr.qcn.qcn03
            FOREACH qcu_cur INTO l_qcu.*
                LET l_qce03 = NULL
                SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
#                EXECUTE insert_prep5 USING l_qcu.*,l_qce03   #FUN-A50053 mark
                EXECUTE insert_prep5 USING  l_qcu.qcu01,l_qcu.qcu02,l_qcu.qcu021,l_qcu.qcu03,
                                            l_qcu.qcu04,l_qcu.qcu05,l_qce03               
                INSERT INTO aqcr3505_tmp VALUES (l_qcu.qcu01,l_qcu.qcu02,l_qcu.qcu021,l_qcu.qcu03,
                                                 l_qcu.qcu04,l_qcu.qcu05,l_qce03)
            END FOREACH
#        OUTPUT TO REPORT r350_rep(sr.*)
#No.FUN-730009 --end
     END FOREACH
 
#No.FUN-730009 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'qcm01,qcm02,qcm021,qmc05,qcm04,qcm13')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05 
#FUN-A50053 add --begin      
     LET l_sql= " SELECT A.* FROM aqcr350_tmp A",
"                 LEFT OUTER JOIN aqcr3501_tmp B",
"                      ON A.qcm01 = B.qao01_1 ",
"                 LEFT OUTER JOIN aqcr3502_tmp C",
"                      ON A.qcm01 = C.qao01_2 ",
"                 LEFT OUTER JOIN aqcr3503_tmp D",
"                      ON A.qcm01 = D.qao01_3 ",
"                 LEFT OUTER JOIN aqcr3504_tmp E",
"                      ON A.qcm01 = E.qao01_4 ",
"                 LEFT OUTER JOIN aqcr3505_tmp F",
"                      ON A.qcm01 = F.qcu01 "
     PREPARE r350_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r350_curs2 CURSOR FOR r350_prepare2  
     FOREACH r350_curs2 INTO sr1.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         EXECUTE insert_prep USING sr1.*,"",l_img_blob, "N",""  #TQC-C10039 ADD "",l_img_blob, "N",""
     END FOREACH
#FUN-A50053 add --end 
#FUN-A50053 mark --begin                              
#     LET l_sql = " SELECT A.*,B.*,C.*,F.*,D.*,E.* ",
#   #TQC-730113## "   FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C,OUTER ",l_table3 CLIPPED,
#"           FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A",
#"                 LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
#"                      ON A.qcm01 = B.qao01_1 ",
#"                 LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C",
#"                      ON A.qcm01 = C.qao01_2 ",
#"                 LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table3 CLIPPED," D",
#"                      ON A.qcm01 = D.qao01_3 ",
#"                 LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table4 CLIPPED," E",
#"                      ON A.qcm01 = E.qao01_4 ",
#"                 LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table5 CLIPPED," F",
#"                      ON A.qcm01 = F.qcu01 "," | ",                 
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," | ",     #No.TQC-960249
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED," | ",     #No.TQC-960249
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED," | ",     #No.TQC-960249
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED," | ",     #No.TQC-960249
#                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED            #No.TQC-960249
#FUN-A50053 mark --end 
#FUN-A50053 mod --begin
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," | ",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," | ",     #No.TQC-960249
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED," | ",     #No.TQC-960249
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED," | ",     #No.TQC-960249
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED," | ",     #No.TQC-960249
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED 
#FUN-A50053 mod --end 
   # CALL cl_prt_cs3('aqcr350',l_sql,g_str)  #TQC-730113
    LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "qcm01"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('aqcr350','aqcr350',l_sql,g_str)
#    FINISH REPORT r350_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-730009 --end
END FUNCTION

#FUN-A50053 add --begin
FUNCTION r350_cre_tmp()                                                         
                                                            
  CREATE TEMP TABLE aqcr350_tmp(                                                
              qcm01  LIKE qcm_file.qcm01,
              qcm02  LIKE qcm_file.qcm02,
              qcm021 LIKE qcm_file.qcm021,
              qcm04  LIKE qcm_file.qcm04,
              qcm041 LIKE qcm_file.qcm041,
              qcm05  LIKE qcm_file.qcm05,
              qcm06  LIKE qcm_file.qcm06,
              qcm09  LIKE qcm_file.qcm09,
              qcm091 LIKE qcm_file.qcm091,
              qcm21  LIKE qcm_file.qcm21,
              qcm22  LIKE qcm_file.qcm22,
              qcn01  LIKE qcn_file.qcn01,
              qcn03  LIKE qcn_file.qcn03,
              qcn04  LIKE qcn_file.qcn04,
              qcn05  LIKE qcn_file.qcn05,
              qcn06  LIKE qcn_file.qcn06,
              qcn07  LIKE qcn_file.qcn07,
              qcn08  LIKE qcn_file.qcn08,
              qcn09  LIKE qcn_file.qcn09,
              qcn10  LIKE qcn_file.qcn10,
              qcn11  LIKE qcn_file.qcn11,
              gen02  LIKE gen_file.gen02,
              ima02  LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021,
              ima109 LIKE ima_file.ima109,
             azf03_1 LIKE azf_file.azf03,
             azf03_2 LIKE azf_file.azf03,
              ecm45  LIKE ecm_file.ecm45,
              eca02  LIKE eca_file.eca02)

  CREATE TEMP TABLE aqcr3501_tmp(
              qao01_1  LIKE  qao_file.qao01,
              qao02_1  LIKE  qao_file.qao02,
              qao021_1 LIKE  qao_file.qao021,
              qao03_1  LIKE  qao_file.qao03,
              qao05_1  LIKE  qao_file.qao05,
              qao06_1  LIKE  qao_file.qao06)
 
  CREATE TEMP TABLE aqcr3502_tmp(
              qao01_2  LIKE qao_file.qao01,
              qao02_2  LIKE qao_file.qao02,
             qao021_2  LIKE qao_file.qao021,
              qao03_2  LIKE qao_file.qao03,
              qao05_2  LIKE qao_file.qao05,
              qao06_2  LIKE qao_file.qao06) 
              
  CREATE TEMP TABLE aqcr3503_tmp(
              qao01_3 LIKE qao_file.qao01,
              qao02_3 LIKE qao_file.qao02,
              qao021_3 LIKE qao_file.qao021,
              qao03_3 LIKE qao_file.qao03,
              qao05_3 LIKE qao_file.qao05,
              qao06_3 LIKE qao_file.qao06)  
                                            
  CREATE TEMP TABLE aqcr3504_tmp(
              qao01_4 LIKE qao_file.qao01,
              qao02_4 LIKE qao_file.qao02,
              qao021_4 LIKE qao_file.qao021,
              qao03_4 LIKE qao_file.qao03,
              qao05_4 LIKE qao_file.qao05,
              qao06_4 LIKE qao_file.qao06)

  CREATE TEMP TABLE aqcr3505_tmp( 
              qcu01 LIKE qcu_file.qcu01,
              qcu02 LIKE qcu_file.qcu02,
              qcu021 LIKE qcu_file.qcu021,
              qcu03 LIKE qcu_file.qcu03,
              qcu04 LIKE qcu_file.qcu04,
              qcu05 LIKE qcu_file.qcu05,
              qce03 LIKE qce_file.qce03)                                                           
                                                             
END FUNCTION        
#No.FUN-730009 --begin
#REPORT r350_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
#          l_qao06      LIKE qao_file.qao06,
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
#          l_qcv04      LIKE qcv_file.qcv04,       #bugno:6010 add
#          l_qcm09      LIKE ze_file.ze03,       #No.FUN-680104 VARCHAR(04)
#          l_qcn05      LIKE type_file.chr2,         #No.FUN-680104 VARCHAR(02)
#          qcm21_desc   LIKE ze_file.ze03,      #No.FUN-680104 VARCHAR(04)
#          qcn08_desc   LIKE ze_file.ze03,      #No.FUN-680104 VARCHAR(04)
#          l_qcu        RECORD LIKE qcu_file.*,
# Prog. Version..: '5.30.06-13.03.12(09)           #bugno:6010 add
#          l_g_x_26     LIKE qcs_file.qcs03,       #No.FUN-680104 VARCHAR(09)
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
#
##No.FUN-590110-begin
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2+1),g_company CLIPPED
# 
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
# 
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.qcm.qcm01
#      SKIP TO TOP OF PAGE
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
#            COLUMN 29,g_x[16] CLIPPED,sr.qcm.qcm02,
#            COLUMN 55,g_x[28] CLIPPED,sr.qcm.qcm05   #TQC-5B0108 &051112  53->55
##No.FUN-550063 ---end--
#      PRINT COLUMN 01,g_x[17] CLIPPED,sr.qcm.qcm021,
#            COLUMN 46,g_x[30] CLIPPED,l_azf03
#      PRINT COLUMN 01,g_x[18] CLIPPED,l_ima02 CLIPPED #TQC-5B0034
#            #COLUMN 46,g_x[31] CLIPPED,qcm21_desc CLIPPED #TQC-5B0034 mark
#      PRINT COLUMN 01,g_x[21] CLIPPED,l_ecm45,
#            COLUMN 46,g_x[29] CLIPPED,l_eca02,
#            COLUMN 63,g_x[31] CLIPPED,qcm21_desc CLIPPED #TQC-5B0034 add
#      PRINT COLUMN 01,g_x[13] CLIPPED,sr.qcm.qcm04,
#            COLUMN 23,g_x[33] CLIPPED,sr.qcm.qcm041,
#            COLUMN 46,g_x[19] CLIPPED,sr.qcm.qcm22 USING '#######&',
#            COLUMN 63,g_x[20] CLIPPED,sr.qcm.qcm06 USING '#######&'
#      PRINT COLUMN 01,g_x[34] CLIPPED,sr.qcm.qcm091 USING '#######&',
#            COLUMN 23,g_x[24] CLIPPED,l_qcm09,
#            COLUMN 46,g_x[15] CLIPPED,l_gen02
#         DECLARE qao_cur CURSOR FOR SELECT qao06 FROM qao_file
#                                                WHERE qao01=sr.qcm.qcm01
#                                                  AND qao02=0
#                                                  AND qao021=0
#                                                  AND qao03=0 AND qao05='1'
#         FOREACH qao_cur INTO l_qao06
#            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
#            IF NOT cl_null(l_qao06) THEN
#               PRINT COLUMN 01,l_qao06
#            END IF
#         END FOREACH
#
# #    PRINT COLUMN 01,g_x[25] CLIPPED,sr.qcm.qcm12
#      PRINT g_dash2[1,g_len]
#      PRINTX name=H1 g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],
#            g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#      PRINT g_dash1
#
#   ON EVERY ROW
#      LET l_azf03=NULL #TQC-590013 add
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
#         DECLARE qao_cur2 CURSOR FOR SELECT qao06 FROM qao_file
#                                                WHERE qao01=sr.qcm.qcm01
#                                                  AND qao02=0
#                                                  AND qao021=0
#                                                  AND qao03=sr.qcn.qcn03
#                                                  AND qao05='1'
#         FOREACH qao_cur2 INTO l_qao06
#            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
#            IF NOT cl_null(l_qao06) THEN
#               PRINT COLUMN 01,l_qao06
#            END IF
#         END FOREACH
#
#      PRINTX name=D1 COLUMN g_c[37],sr.qcn.qcn03 USING '###&',#FUN-590118
#            COLUMN g_c[38],sr.qcn.qcn04 CLIPPED,
#            COLUMN g_c[39],l_azf03[1,14],
#            COLUMN g_c[40],l_qcn05 CLIPPED,
#            COLUMN g_c[41],cl_numfor(sr.qcn.qcn06,41,2),
#            COLUMN g_c[42],sr.qcn.qcn09 USING '####&',
#            COLUMN g_c[43],sr.qcn.qcn10 USING '####&',
#            COLUMN g_c[44],cl_numfor(sr.qcn.qcn11,44,0),
#            COLUMN g_c[45],cl_numfor(sr.qcn.qcn07,45,2),
#            COLUMN g_c[46],qcn08_desc CLIPPED
#      LET l_g_x_26=g_x[26]
#      DECLARE qcu_cur CURSOR FOR
#         SELECT * FROM qcu_file WHERE qcu01=sr.qcn.qcn01
#                                  AND qcu03=sr.qcn.qcn03
#         FOREACH qcu_cur INTO l_qcu.*
#             SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
#             PRINT COLUMN 07,l_g_x_26,l_qcu.qcu04 CLIPPED,' ',l_qce03,
#                   COLUMN g_c[45],cl_numfor(l_qcu.qcu05,45,2)
#             LET l_g_x_26='         '
#         END FOREACH
#         DECLARE qao_cur3 CURSOR FOR SELECT qao06 FROM qao_file
#                                                WHERE qao01=sr.qcm.qcm01
#                                                  AND qao02=0
#                                                  AND qao021=0
#                                                  AND qao03=sr.qcn.qcn03
#                                                  AND qao05='2'
#         FOREACH qao_cur3 INTO l_qao06
#            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
#            IF NOT cl_null(l_qao06) THEN
#               PRINT COLUMN 01,l_qao06
#            END IF
#         END FOREACH
#{
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
#}
#
#   AFTER GROUP OF sr.qcm.qcm01
#         DECLARE qao_cur4 CURSOR FOR SELECT qao06 FROM qao_file
#                                                WHERE qao01=sr.qcm.qcm01
#                                                  AND qao02=0
#                                                  AND qao021=0
#                                                  AND qao03=0 AND qao05='2'
#         FOREACH qao_cur4 INTO l_qao06
#            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
#            IF NOT cl_null(l_qao06) THEN
#               PRINT COLUMN 01,l_qao06
#            END IF
#         END FOREACH
##No.FUN-590110-end
#
#
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
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
#No.FUN-730009 --end
 
#Patch....NO.TQC-610036 <> #
