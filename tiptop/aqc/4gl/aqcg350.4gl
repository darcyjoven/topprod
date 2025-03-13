# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: aqcg350.4gl
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
# Modify.........: No.FUN-B40087 11/05/12 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正 
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/12 By wangrr GR程式優化

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
###GENGRE###START
TYPE sr1_t RECORD
    qcm01 LIKE qcm_file.qcm01,
    qcm02 LIKE qcm_file.qcm02,
    qcm021 LIKE qcm_file.qcm021,
    qcm04 LIKE qcm_file.qcm04,
    qcm041 LIKE qcm_file.qcm041,
    qcm05 LIKE qcm_file.qcm05,
    qcm06 LIKE qcm_file.qcm06,
    qcm09 LIKE qcm_file.qcm09,
    qcm091 LIKE qcm_file.qcm091,
    qcm21 LIKE qcm_file.qcm21,
    qcm22 LIKE qcm_file.qcm22,
    qcn01 LIKE qcn_file.qcn01,
    qcn03 LIKE qcn_file.qcn03,
    qcn04 LIKE qcn_file.qcn04,
    qcn05 LIKE qcn_file.qcn05,
    qcn06 LIKE qcn_file.qcn06,
    qcn07 LIKE qcn_file.qcn07,
    qcn08 LIKE qcn_file.qcn08,
    qcn09 LIKE qcn_file.qcn09,
    qcn10 LIKE qcn_file.qcn10,
    qcn11 LIKE qcn_file.qcn11,
    gen02 LIKE gen_file.gen02,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    ima109 LIKE ima_file.ima109,
    azf03_1 LIKE azf_file.azf03,
    azf03_2 LIKE azf_file.azf03,
    ecm45 LIKE ecm_file.ecm45,
    eca02 LIKE eca_file.eca02,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add

END RECORD

TYPE sr2_t RECORD
    qao01_1 LIKE qao_file.qao01,
    qao02_1 LIKE qao_file.qao02,
    qao021_1 LIKE qao_file.qao021,
    qao03_1 LIKE qao_file.qao03,
    qao05_1 LIKE qao_file.qao05,
    qao06_1 LIKE qao_file.qao06
END RECORD

TYPE sr3_t RECORD
    qao01_2 LIKE qao_file.qao01,
    qao02_2 LIKE qao_file.qao02,
    qao021_2 LIKE qao_file.qao021,
    qao03_2 LIKE qao_file.qao03,
    qao05_2 LIKE qao_file.qao05,
    qao06_2 LIKE qao_file.qao06
END RECORD

TYPE sr4_t RECORD
    qao01_3 LIKE qao_file.qao01,
    qao02_3 LIKE qao_file.qao02,
    qao021_3 LIKE qao_file.qao021,
    qao03_3 LIKE qao_file.qao03,
    qao05_3 LIKE qao_file.qao05,
    qao06_3 LIKE qao_file.qao06
END RECORD

TYPE sr5_t RECORD
    qao01_4 LIKE qao_file.qao01,
    qao02_4 LIKE qao_file.qao02,
    qao021_4 LIKE qao_file.qao021,
    qao03_4 LIKE qao_file.qao03,
    qao05_4 LIKE qao_file.qao05,
    qao06_4 LIKE qao_file.qao06
END RECORD

TYPE sr6_t RECORD
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
              "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
              "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('aqcg350',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087                                                         
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
      EXIT PROGRAM 
   END IF
 
   LET g_sql ="qao01_1.qao_file.qao01,",
              "qao02_1.qao_file.qao02,",
              "qao021_1.qao_file.qao021,",
              "qao03_1.qao_file.qao03,",
              "qao05_1.qao_file.qao05,",
              "qao06_1.qao_file.qao06"
   LET l_table1 = cl_prt_temptable('aqcg3501',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087                                                         
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
      EXIT PROGRAM 
   END IF
 
   LET g_sql ="qao01_2.qao_file.qao01,",
              "qao02_2.qao_file.qao02,",
              "qao021_2.qao_file.qao021,",
              "qao03_2.qao_file.qao03,",
              "qao05_2.qao_file.qao05,",
              "qao06_2.qao_file.qao06"
   LET l_table2 = cl_prt_temptable('aqcg3502',g_sql) CLIPPED
   IF l_table2 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087                                                         
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
      EXIT PROGRAM 
   END IF
 
   LET g_sql ="qao01_3.qao_file.qao01,",
              "qao02_3.qao_file.qao02,",
              "qao021_3.qao_file.qao021,",
              "qao03_3.qao_file.qao03,",
              "qao05_3.qao_file.qao05,",
              "qao06_3.qao_file.qao06"
   LET l_table3 = cl_prt_temptable('aqcg3503',g_sql) CLIPPED
   IF l_table3 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087                                                         
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
      EXIT PROGRAM 
   END IF
 
   LET g_sql ="qao01_4.qao_file.qao01,",
              "qao02_4.qao_file.qao02,",
              "qao021_4.qao_file.qao021,",
              "qao03_4.qao_file.qao03,",
              "qao05_4.qao_file.qao05,",
              "qao06_4.qao_file.qao06"
   LET l_table4 = cl_prt_temptable('aqcg3504',g_sql) CLIPPED
   IF l_table4 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087                                                         
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
      EXIT PROGRAM
   END IF
 
   LET g_sql ="qcu01.qcu_file.qcu01,",
              "qcu02.qcu_file.qcu02,",
              "qcu021.qcu_file.qcu021,",
              "qcu03.qcu_file.qcu03,",
              "qcu04.qcu_file.qcu04,",
              "qcu05.qcu_file.qcu05,",
              "qce03.qce_file.qce03"
   LET l_table5 = cl_prt_temptable('aqcg3505',g_sql) CLIPPED
   IF l_table5 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087                                                         
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
      EXIT PROGRAM 
   END IF
#No.FUN-730009 --end
#  CALL g350_cre_tmp()     #FUN-A50053 add #FUN-B40087 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g350_tm(0,0)
      ELSE CALL g350()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)
END MAIN
 
FUNCTION g350_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW g350_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcg350"
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
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)
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
      CLOSE WINDOW g350_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcg350'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcg350','9031',1)
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
         CALL cl_cmdat('aqcg350',g_time,l_cmd)
      END IF
      CLOSE WINDOW g350_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g350()
   ERROR ""
END WHILE
   CLOSE WINDOW g350_w
END FUNCTION
 
FUNCTION g350()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
  # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
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
#FUN-A50053 add --end 
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#No.FUN-730009 --begin
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
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"# No.FUN-C40020 add4?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-B80066
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep3:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep4 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep4:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-B80066
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep5 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep5:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)         #FUN-B40087
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
 
 
     PREPARE g350_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)
        EXIT PROGRAM
     END IF
     DECLARE g350_curs1 CURSOR FOR g350_prepare1

#FUN-C50008--add--str
     DECLARE qao_cur2 CURSOR FOR 
        SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
         WHERE qao01=? AND qao02=0 AND qao021=0 AND qao03=? AND qao05='1'

     DECLARE qao_cur3 CURSOR FOR 
        SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
         WHERE qao01=? AND qao02=0 AND qao021=0 AND qao03=? AND qao05='2'
     
     DECLARE qcu_cur CURSOR FOR
        SELECT * FROM qcu_file WHERE qcu01=? AND qcu03=?
#FUN-C50008--add--end

#No.FUN-730009 --begin
#    CALL cl_outnam('aqcg350') RETURNING l_name
#    START REPORT g350_rep TO l_name
#    LET g_pageno = 0
#No.FUN-730009 --end
#    DELETE FROM aqcg350_tmp     #FUN-A50053 add   #FUN-B40087
#    DELETE FROM aqcg3501_tmp    #FUN-A50053 add
#    DELETE FROM aqcg3502_tmp    #FUN-A50053 add
#    DELETE FROM aqcg3503_tmp    #FUN-A50053 add   
#    DELETE FROM aqcg3504_tmp    #FUN-A50053 add 
#    DELETE FROM aqcg3505_tmp    #FUN-A50053 add           
     FOREACH g350_curs1 INTO sr.*
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
          EXECUTE insert_prep USING sr.qcm.qcm01,sr.qcm.qcm02,sr.qcm.qcm021,sr.qcm.qcm04,sr.qcm.qcm041,sr.qcm.qcm05,
                                    sr.qcm.qcm06,sr.qcm.qcm09,sr.qcm.qcm091,sr.qcm.qcm21,sr.qcm.qcm22,sr.qcn.qcn01,
                                    sr.qcn.qcn03,sr.qcn.qcn04,sr.qcn.qcn05,sr.qcn.qcn06,sr.qcn.qcn07,sr.qcn.qcn08,
                                    sr.qcn.qcn09,sr.qcn.qcn10,sr.qcn.qcn11,
                                    l_gen02,l_ima02,l_ima021,l_ima109,l_azf03_1,l_azf03_2,l_ecm45,l_eca02
				    ,"",  l_img_blob,"N",""  # No.FUN-C40020 add
#FUN-B40087
#         INSERT INTO aqcg350_tmp VALUES (sr.qcm.qcm01,sr.qcm.qcm02,sr.qcm.qcm021,sr.qcm.qcm04,sr.qcm.qcm041,sr.qcm.qcm05, 
#                                  sr.qcm.qcm06,sr.qcm.qcm09,sr.qcm.qcm091,sr.qcm.qcm21,sr.qcm.qcm22,sr.qcn.qcn01,
#                                  sr.qcn.qcn03,sr.qcn.qcn04,sr.qcn.qcn05,sr.qcn.qcn06,sr.qcn.qcn07,sr.qcn.qcn08,
#                                  sr.qcn.qcn09,sr.qcn.qcn10,sr.qcn.qcn11,
#                                  l_gen02,l_ima02,l_ima021,l_ima109,l_azf03_1,l_azf03_2,l_ecm45,l_eca02)          
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
        #FUN-C50008--mark--str
        # DECLARE qao_cur2 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
        #                                        WHERE qao01=sr.qcm.qcm01
        #                                          AND qao02=0
        #                                          AND qao021=0
        #                                          AND qao03=sr.qcn.qcn03
        #                                          AND qao05='1'
        # FOREACH qao_cur2 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
        #FUN-C50008--mark--end
         FOREACH qao_cur2 USING sr.qcm.qcm01,sr.qcn.qcn03 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06 #FUN-C50008 add 
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep2 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #  INSERT INTO aqcg3502_tmp VALUES (l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06)  #FUN-B40087
         END FOREACH
        #FUN-C50008--mark--str
        # DECLARE qao_cur3 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
        #                                        WHERE qao01=sr.qcm.qcm01
        #                                          AND qao02=0
        #                                         AND qao021=0
        #                                          AND qao03=sr.qcn.qcn03
        #                                          AND qao05='2'
        # FOREACH qao_cur3 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
        #FUN-C50008--mark--end
         FOREACH qao_cur3 USING sr.qcm.qcm01,sr.qcn.qcn03 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06  #FUN-C50008 add 
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep3 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
       #    INSERT INTO aqcg3503_tmp VALUES (l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06)  #FUN-B40087
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
        #FUN-C50008--mark--str
        # DECLARE qcu_cur CURSOR FOR
        #    SELECT * FROM qcu_file WHERE qcu01=sr.qcn.qcn01
        #                             AND qcu03=sr.qcn.qcn03
        #    FOREACH qcu_cur INTO l_qcu.*
        #FUN-C50008--mark--end
            FOREACH qcu_cur USING sr.qcn.qcn01,sr.qcn.qcn03 INTO l_qcu.* #FUN-C50008 add
                LET l_qce03 = NULL
                SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
#                EXECUTE insert_prep5 USING l_qcu.*,l_qce03   #FUN-A50053 mark
                EXECUTE insert_prep5 USING  l_qcu.qcu01,l_qcu.qcu02,l_qcu.qcu021,l_qcu.qcu03,
                                            l_qcu.qcu04,l_qcu.qcu05,l_qce03               
              # INSERT INTO aqcg3505_tmp VALUES (l_qcu.qcu01,l_qcu.qcu02,l_qcu.qcu021,l_qcu.qcu03,  #FUN-B40087
              #                                  l_qcu.qcu04,l_qcu.qcu05,l_qce03)
            END FOREACH
#        OUTPUT TO REPORT g350_rep(sr.*)
#No.FUN-730009 --end
     END FOREACH
 
#No.FUN-730009 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'qcm01,qcm02,qcm021,qmc05,qcm04,qcm13')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05
#FUN-B40087
{
#FUN-A50053 add --begin      
     LET l_sql= " SELECT A.* FROM aqcg350_tmp A",
"                 LEFT OUTER JOIN aqcg3501_tmp B",
"                      ON A.qcm01 = B.qao01_1 ",
"                 LEFT OUTER JOIN aqcg3502_tmp C",
"                      ON A.qcm01 = C.qao01_2 ",
"                 LEFT OUTER JOIN aqcg3503_tmp D",
"                      ON A.qcm01 = D.qao01_3 ",
"                 LEFT OUTER JOIN aqcg3504_tmp E",
"                      ON A.qcm01 = E.qao01_4 ",
"                 LEFT OUTER JOIN aqcg3505_tmp F",
"                      ON A.qcm01 = F.qcu01 "
     PREPARE g350_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4||"|"||l_table5)
        EXIT PROGRAM
     END IF
     DECLARE g350_curs2 CURSOR FOR g350_prepare2  
     FOREACH g350_curs2 INTO sr1.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-B80066
            EXIT FOREACH
         END IF
         EXECUTE insert_prep USING sr1.*
     END FOREACH
#FUN-A50053 add --end 
}
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
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," | ",
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED," | ",     #No.TQC-960249
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED," | ",     #No.TQC-960249
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED," | ",     #No.TQC-960249
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED," | ",     #No.TQC-960249
###GENGRE###                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED 
#FUN-A50053 mod --end 
   # CALL cl_prt_cs3('aqcg350',l_sql,g_str)  #TQC-730113
###GENGRE###     CALL cl_prt_cs3('aqcg350','aqcg350',l_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "qcm01"                    # No.FUN-C40020 add
    CALL aqcg350_grdata()    ###GENGRE###
#    FINISH REPORT g350_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-730009 --end
END FUNCTION
{
#FUN-A50053 add --begin
FUNCTION g350_cre_tmp()                                                         
                                                            
  CREATE TEMP TABLE aqcg350_tmp(                                                
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

  CREATE TEMP TABLE aqcg3501_tmp(
              qao01_1  LIKE  qao_file.qao01,
              qao02_1  LIKE  qao_file.qao02,
              qao021_1 LIKE  qao_file.qao021,
              qao03_1  LIKE  qao_file.qao03,
              qao05_1  LIKE  qao_file.qao05,
              qao06_1  LIKE  qao_file.qao06)
 
  CREATE TEMP TABLE aqcg3502_tmp(
              qao01_2  LIKE qao_file.qao01,
              qao02_2  LIKE qao_file.qao02,
             qao021_2  LIKE qao_file.qao021,
              qao03_2  LIKE qao_file.qao03,
              qao05_2  LIKE qao_file.qao05,
              qao06_2  LIKE qao_file.qao06) 
              
  CREATE TEMP TABLE aqcg3503_tmp(
              qao01_3 LIKE qao_file.qao01,
              qao02_3 LIKE qao_file.qao02,
              qao021_3 LIKE qao_file.qao021,
              qao03_3 LIKE qao_file.qao03,
              qao05_3 LIKE qao_file.qao05,
              qao06_3 LIKE qao_file.qao06)  
                                            
  CREATE TEMP TABLE aqcg3504_tmp(
              qao01_4 LIKE qao_file.qao01,
              qao02_4 LIKE qao_file.qao02,
              qao021_4 LIKE qao_file.qao021,
              qao03_4 LIKE qao_file.qao03,
              qao05_4 LIKE qao_file.qao05,
              qao06_4 LIKE qao_file.qao06)

  CREATE TEMP TABLE aqcg3505_tmp( 
              qcu01 LIKE qcu_file.qcu01,
              qcu02 LIKE qcu_file.qcu02,
              qcu021 LIKE qcu_file.qcu021,
              qcu03 LIKE qcu_file.qcu03,
              qcu04 LIKE qcu_file.qcu04,
              qcu05 LIKE qcu_file.qcu05,
              qce03 LIKE qce_file.qce03)                                                           
                                                             
END FUNCTION       
} 
#No.FUN-730009 --begin
#REPORT g350_rep(sr)
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

###GENGRE###START
FUNCTION aqcg350_grdata()
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
        LET handler = cl_gre_outnam("aqcg350")
        IF handler IS NOT NULL THEN
            START REPORT aqcg350_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY qcm01,qcn03"
          
            DECLARE aqcg350_datacur1 CURSOR FROM l_sql
            FOREACH aqcg350_datacur1 INTO sr1.*
                OUTPUT TO REPORT aqcg350_rep(sr1.*)
            END FOREACH
            FINISH REPORT aqcg350_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aqcg350_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE sr5 sr5_t
    DEFINE sr6 sr6_t
    DEFINE l_lineno         LIKE type_file.num5
    #FUN-B40087  ADD --------STR -----
    DEFINE l_azf03_2        LIKE azf_file.azf03
    DEFINE l_qcm09          STRING 
    DEFINE l_qcm21_desc     STRING
    DEFINE l_qcn05          STRING
    DEFINE l_qcn08_desc     STRING 
    DEFINE l_sql            STRING 
    DEFINE l_azf03_2d       LIKE azf_file.azf03 
    #FUN-B40087  ADD --------END -----
 
    ORDER EXTERNAL BY sr1.qcm01,sr1.qcn03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.qcm01
            LET l_lineno = 0
            #FUN-B40087  ADD --------STR -----
            IF sr1.qcm09 = '1' OR sr1.qcm09 = '2' THEN
               LET l_qcm09 = cl_gr_getmsg("gre-112",g_lang,sr1.qcm09)
            ELSE
               LET l_qcm09 = NULL
            END IF
            PRINTX l_qcm09

            IF cl_null(sr1.qcm21) THEN 
               LET sr1.qcm21 = "N"
            END IF


            IF sr1.qcm21 = 'N' OR sr1.qcm21 = 'T' OR sr1.qcm21 = 'R' THEN
               LET l_qcm21_desc = cl_gr_getmsg("gre-109",g_lang,sr1.qcm21)
            ELSE
               LET l_qcm21_desc = cl_gr_getmsg("gre-109",g_lang,'N')
            END IF

            PRINTX l_qcm21_desc
            LET l_azf03_2d = sr1.azf03_2
           #LET l_azf03_2 = l_azf03_2d.subString(1,35)
            LET l_azf03_2 = sr1.azf03_2[1,35]
            PRINTX l_azf03_2 
           
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE qao01_1 = '",sr1.qcm01 CLIPPED,"'",
                        " AND qao03_1 = ",sr1.qcn03 CLIPPED,
                        " AND qao02_1 = 0 AND qao021_1 = 0 AND qao05_1 = '1'"
            START REPORT aqcg350_subrep01
            DECLARE aqcg350_repcur1 CURSOR FROM l_sql
            FOREACH aqcg350_repcur1 INTO sr2.*
                OUTPUT TO REPORT aqcg350_subrep01(sr2.*)
            END FOREACH
            FINISH REPORT aqcg350_subrep01
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
                      ELSE LET l_qcn05 = ""
                      END IF
                 END IF
            END IF
            PRINTX l_qcn05
 
            IF sr1.qcn08 = '1' OR sr1.qcn08 = '2' THEN
               LET l_qcn08_desc = cl_gr_getmsg("gre-112",g_lang,sr1.qcn08)
            ELSE
               LET l_qcn08_desc = NULL
            END IF
            PRINTX l_qcn08_desc

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE qao01_2 = '",sr1.qcm01 CLIPPED,"'",
                        " AND qao03_2 = ",sr1.qcn03 CLIPPED,
                        " AND qao02_2= 0 AND qao021_2 = 0 AND qao05_2 = '1'"
            START REPORT aqcg350_subrep02
            DECLARE aqcg350_repcur2 CURSOR FROM l_sql
            FOREACH aqcg350_repcur2 INTO sr3.*
                OUTPUT TO REPORT aqcg350_subrep02(sr3.*)
            END FOREACH
            FINISH REPORT aqcg350_subrep02
 
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                        " WHERE qcu01 = '",sr1.qcn01 CLIPPED,"'",
                        " AND qcu03 = ",sr1.qcn03 CLIPPED
            START REPORT aqcg350_subrep05
            DECLARE aqcg350_repcur5 CURSOR FROM l_sql
            FOREACH aqcg350_repcur5 INTO sr6.*
                OUTPUT TO REPORT aqcg350_subrep05(sr6.*)
            END FOREACH
            FINISH REPORT aqcg350_subrep05

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE qao01_3 = '",sr1.qcm01 CLIPPED,"'",
                        " AND qao03_3 = ",sr1.qcn03 CLIPPED,
                        " AND qao02_3= 0 AND qao021_3 = 0 AND qao05_3 = '2'"
            START REPORT aqcg350_subrep03
            DECLARE aqcg350_repcur3 CURSOR FROM l_sql
            FOREACH aqcg350_repcur3 INTO sr4.*
                OUTPUT TO REPORT aqcg350_subrep03(sr4.*)
            END FOREACH
            FINISH REPORT aqcg350_subrep03
            PRINTX sr1.*

        AFTER GROUP OF sr1.qcm01
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                        " WHERE qao01_4 = '",sr1.qcm01 CLIPPED,"'",
                        " AND qao03_4 = 0",
                        " AND qao02_4= 0 AND qao021_4 = 0 AND qao05_4 = '2'"
            START REPORT aqcg350_subrep04
            DECLARE aqcg350_repcur4 CURSOR FROM l_sql
            FOREACH aqcg350_repcur4 INTO sr5.*
                OUTPUT TO REPORT aqcg350_subrep04(sr5.*)
            END FOREACH
            FINISH REPORT aqcg350_subrep04          
            #FUN-B40087  ADD --------END -----  

        AFTER GROUP OF sr1.qcn03

        
        ON LAST ROW

END REPORT
#FUN-B40087  ADD --------STR -----
REPORT aqcg350_subrep01(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT
REPORT aqcg350_subrep02(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT
REPORT aqcg350_subrep03(sr4)
    DEFINE sr4 sr4_t

    FORMAT
        ON EVERY ROW
            PRINTX sr4.*
END REPORT
REPORT aqcg350_subrep04(sr5)
    DEFINE sr5 sr5_t

    FORMAT
        ON EVERY ROW
            PRINTX sr5.*
END REPORT
REPORT aqcg350_subrep05(sr6)
    DEFINE sr6 sr6_t
    DEFINE l_qcu04_qce03    STRING
    DEFINE l_n              LIKE type_file.num5
 
    ORDER EXTERNAL BY sr6.qcu01

    FORMAT
        BEFORE GROUP OF sr6.qcu01
            LET l_n = 0

        ON EVERY ROW
            LET l_n = l_n + 1
            PRINTX l_n

            LET l_qcu04_qce03 = sr6.qcu04,' ',sr6.qce03
            PRINTX l_qcu04_qce03
            PRINTX sr6.*
END REPORT
#FUN-B40087  ADD --------END -----
###GENGRE###END
