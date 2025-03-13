# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aqcr340.4gl
# Descriptions...: FQC 檢驗報告
# Date & Author..: 99/05/10 By Melody
# Modify.........: NO.FUN-550063 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-550121 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-550002 05/06/06 By Trisy 單據編號加大
# Modify.........: No.FUN-570243 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-590013 05/09/28 By Rosayu 當單頭有資料而單身沒資料時無法列印
# Modify.........: No.FUN-590110 05/09/29 By day  報表轉xml
# Modify.........: No.MOD-590409 05/09/21 By Rosayu 單頭製造部門資訊抓錯,抓到業務部門oea15改為sfb82
# Modify.........: No.FUN-5A0141 05/10/20 By Pengu 調整報表格式
# Modify.........: No.TQC-5A0091 05/11/22 By Rosayu 部門資料沒有帶出
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: NO.FUN-610075 06/01/20 By Nicola 列印多單位資料
# Modify.........: No.TQC-610086 06/04/18 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-730009 07/03/08 By Ray Crystal Report修改
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.MOD-7C0158 07/12/24 By Pengu 調整l_sql的SQL語法
# Modify.........: No.MOD-820094 08/02/20 By Pengu 調整備註用子報表列印
# Modify.........: No.CHI-830021 08/03/25 By Pengu 應依據整體參數判斷是否顯示多單位資料
# Modify.........: No.MOD-880244 08/08/29 By claire insert 個數與寫入個數不符
# Modify.........: No.MOD-870309 08/09/04 By claire 單頭備註以單身筆數重複,應以單頭只印一次方式處理
# Modify.........: No.MOD-890053 08/09/04 By claire 調整變數名稱
# Modify.........: No.MOD-8B0079 08/11/07 By sherry insert_prep5 插入臨時表的個數與execute的個數不一致
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B30080 11/03/10 By destiny tm.wc长度不够
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
             #wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600) #TQC-B30080
              wc      STRING,                      #TQC-B30080
               b      LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)     # 是否列印訂單memo
               c      LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)    # 是否列印訂單嘜頭
              more    LIKE type_file.chr1         #No.FUN-680104 VARCHAR(1)
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680104 INTEGER
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
DEFINE  l_table6   STRING
DEFINE  l_table7   STRING
DEFINE  l_table8   STRING
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
   LET g_towhom =ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway =ARG_VAL(5)
   LET g_copies =ARG_VAL(6)
   LET tm.wc =ARG_VAL(7)
#--------------No.TQC-610086 modify
   LET tm.b =ARG_VAL(8)
   LET tm.c =ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#--------------No.TQC-610086 end
#No.FUN-730009 --begin
   LET g_sql ="qcf00.qcf_file.qcf00,",
              "qcf01.qcf_file.qcf01,",
              "qcf02.qcf_file.qcf02,",
              "qcf021.qcf_file.qcf021,",
              "qcf03.qcf_file.qcf03,",
              "qcf04.qcf_file.qcf04,",
              "qcf041.qcf_file.qcf041,",
              "qcf05.qcf_file.qcf05,",
              "qcf06.qcf_file.qcf06,",
              "qcf061.qcf_file.qcf061,",
              "qcf062.qcf_file.qcf062,",
              "qcf071.qcf_file.qcf071,",
              "qcf072.qcf_file.qcf072,",
              "qcf081.qcf_file.qcf081,",
              "qcf082.qcf_file.qcf082,",
              "qcf09.qcf_file.qcf09,",
              "qcf091.qcf_file.qcf091,",
              "qcf10.qcf_file.qcf10,",
              "qcf101.qcf_file.qcf101,",
              "qcf11.qcf_file.qcf11,",
              "qcf12.qcf_file.qcf12,",
              "qcf13.qcf_file.qcf13,",
              "qcf14.qcf_file.qcf14,",
              "qcf15.qcf_file.qcf15,",
              "qcf16.qcf_file.qcf16,",
              "qcf17.qcf_file.qcf17,",
              "qcf18.qcf_file.qcf18,",
              "qcf19.qcf_file.qcf19,",
              "qcf20.qcf_file.qcf20,",
              "qcf21.qcf_file.qcf21,",
              "qcf22.qcf_file.qcf22,",
              "qcfprno.qcf_file.qcfprno,",
              "qcfacti.qcf_file.qcfacti,",
              "qcfuser.qcf_file.qcfuser,",
              "qcfgrup.qcf_file.qcfgrup,",
              "qcfmodu.qcf_file.qcfmodu,",
              "qcfdate.qcf_file.qcfdate,",
              "qcf30.qcf_file.qcf30,",
              "qcf31.qcf_file.qcf31,",
              "qcf32.qcf_file.qcf32,",
              "qcf33.qcf_file.qcf33,",
              "qcf34.qcf_file.qcf34,",
              "qcf35.qcf_file.qcf35,",
              "qcf36.qcf_file.qcf36,",
              "qcf37.qcf_file.qcf37,",
              "qcf38.qcf_file.qcf38,",
              "qcf39.qcf_file.qcf39,",
              "qcf40.qcf_file.qcf40,",
              "qcf41.qcf_file.qcf41,",
              "qcfspc.qcf_file.qcfspc,",
              "qcg01.qcg_file.qcg01,",
              "qcg03.qcg_file.qcg03,",
              "qcg04.qcg_file.qcg04,",
              "qcg05.qcg_file.qcg05,",
              "qcg06.qcg_file.qcg06,",
              "qcg07.qcg_file.qcg07,",
              "qcg08.qcg_file.qcg08,",
              "qcg09.qcg_file.qcg09,",
              "qcg10.qcg_file.qcg10,",
              "qcg11.qcg_file.qcg11,",
              "qcg12.qcg_file.qcg12,",
              "qcg131.qcg_file.qcg131,",
              "qcg132.qcg_file.qcg132,",
              "gen02.gen_file.gen02,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ima109.ima_file.ima109,",
              "azf03_1.azf_file.azf03,",
              "azf03_2.azf_file.azf03,",
              "sfb22.sfb_file.sfb22,",
              "sfb221.sfb_file.sfb221,",
              "sfb82.sfb_file.sfb82,",
              "occ02.occ_file.occ02,",
              "gem02.gem_file.gem02,",
              "oea01.oea_file.oea01,",
              "oea04.oea_file.oea04,",
              "oea44.oea_file.oea44,",
              "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
              "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
              "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039

   LET l_table = cl_prt_temptable('aqcr340',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_1.qao_file.qao01,",
              "qao02_1.qao_file.qao02,",
              "qao021_1.qao_file.qao021,",
              "qao03_1.qao_file.qao03,",
              "qao05_1.qao_file.qao05,",
              "qao06_1.qao_file.qao06"
   LET l_table1 = cl_prt_temptable('aqcr3401',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_2.qao_file.qao01,",
              "qao02_2.qao_file.qao02,",
              "qao021_2.qao_file.qao021,",
              "qao03_2.qao_file.qao03,",
              "qao05_2.qao_file.qao05,",
              "qao06_2.qao_file.qao06"
   LET l_table2 = cl_prt_temptable('aqcr3402',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_3.qao_file.qao01,",
              "qao02_3.qao_file.qao02,",
              "qao021_3.qao_file.qao021,",
              "qao03_3.qao_file.qao03,",
              "qao05_3.qao_file.qao05,",
              "qao06_3.qao_file.qao06"
   LET l_table3 = cl_prt_temptable('aqcr3403',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_4.qao_file.qao01,",
              "qao02_4.qao_file.qao02,",
              "qao021_4.qao_file.qao021,",
              "qao03_4.qao_file.qao03,",
              "qao05_4.qao_file.qao05,",
              "qao06_4.qao_file.qao06"
   LET l_table4 = cl_prt_temptable('aqcr3404',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qcu01.qcu_file.qcu01,",
              "qcu02.qcu_file.qcu02,",
              "qcu021.qcu_file.qcu021,",
              "qcu03.qcu_file.qcu03,",
              "qcu04.qcu_file.qcu04,",
              "qcu05.qcu_file.qcu05,",
              "qce03.qce_file.qce03"
   LET l_table5 = cl_prt_temptable('aqcr3405',g_sql) CLIPPED
   IF l_table5 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="ocf01.ocf_file.ocf01,",
              "ocf02.ocf_file.ocf02,",
              "ocf101.ocf_file.ocf101,",
              "ocf102.ocf_file.ocf102,",
              "ocf103.ocf_file.ocf103,",
              "ocf104.ocf_file.ocf104,",
              "ocf105.ocf_file.ocf105,",
              "ocf106.ocf_file.ocf106,",
              "ocf107.ocf_file.ocf107,",
              "ocf108.ocf_file.ocf108,",
              "ocf109.ocf_file.ocf109,",
              "ocf110.ocf_file.ocf110,",
              "ocf111.ocf_file.ocf111,",
              "ocf112.ocf_file.ocf112,",
              "ocf201.ocf_file.ocf201,",
              "ocf202.ocf_file.ocf202,",
              "ocf203.ocf_file.ocf203,",
              "ocf204.ocf_file.ocf204,",
              "ocf205.ocf_file.ocf205,",
              "ocf206.ocf_file.ocf206,",
              "ocf207.ocf_file.ocf207,",
              "ocf208.ocf_file.ocf208,",
              "ocf209.ocf_file.ocf209,",
              "ocf210.ocf_file.ocf210,",
              "ocf211.ocf_file.ocf211,",
              "ocf212.ocf_file.ocf212"
   LET l_table6 = cl_prt_temptable('aqcr3406',g_sql) CLIPPED
   IF l_table6 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qde01.qde_file.qde01,",
              "qde02.qde_file.qde02,",
              "qde03.qde_file.qde03,",
              "qde04.qde_file.qde04,",
              "qde05.qde_file.qde05,",
              "qde06.qde_file.qde06,",
              "qde08.qde_file.qde08,",
              "qde09.qde_file.qde09,",
              "qde10.qde_file.qde10,",
              "qde11.qde_file.qde11,",
              "qde12.qde_file.qde12,",
              "qde13.qde_file.qde13"
   LET l_table7 = cl_prt_temptable('aqcr3407',g_sql) CLIPPED
   IF l_table7 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="oao01.oao_file.oao01,",
              "oao03.oao_file.oao03,",
              "oao04.oao_file.oao04,",
              "oao05.oao_file.oao05,",
              "oao06.oao_file.oao06"
   LET l_table8 = cl_prt_temptable('aqcr3408',g_sql) CLIPPED
   IF l_table8 = -1 THEN EXIT PROGRAM END IF
#No.FUN-730009 --end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r340_tm(0,0)
      ELSE CALL r340()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r340_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r340_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr340"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.b    = 'N'
   LET tm.c    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON qcf01,qcf021,qcf02,qcf13
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
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
   DISPLAY BY NAME tm.b,tm.c,tm.more
   INPUT BY NAME tm.b,tm.c,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]"
            THEN NEXT FIELD b
         END IF
      AFTER FIELD c
         IF tm.c NOT MATCHES "[YN]"
            THEN NEXT FIELD c
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
      CLOSE WINDOW r340_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr340'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr340','9031',1)
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
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('aqcr340',g_time,l_cmd)
      END IF
      CLOSE WINDOW r340_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r340()
   ERROR ""
END WHILE
   CLOSE WINDOW r340_w
END FUNCTION
 
FUNCTION r340()
   DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000) #TQC-B30080
          l_sql     STRING,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
#No.FUN-730009 --begin
          l_oea01      LIKE oea_file.oea01,
          l_ofb01      LIKE ofb_file.ofb01,
          l_oea04      LIKE oea_file.oea04,
          l_oea44      LIKE oea_file.oea44,
          l_gen02      LIKE gen_file.gen02,
          l_pmc03      LIKE pmc_file.pmc03,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_ima109     LIKE ima_file.ima109,
          l_ima15      LIKE ima_file.ima15,
          l_azf03_1    LIKE azf_file.azf03,
          l_azf03_2    LIKE azf_file.azf03,
          l_qao01      LIKE qao_file.qao01,
          l_qao02      LIKE qao_file.qao02,
          l_qao021     LIKE qao_file.qao021,
          l_qao03      LIKE qao_file.qao03,
          l_qao05      LIKE qao_file.qao05,
          l_qao06      LIKE qao_file.qao06,
          l_qce03      LIKE qce_file.qce03,
          l_sfb22      LIKE sfb_file.sfb22,
          l_sfb221     LIKE sfb_file.sfb221,
          l_sfb82      LIKE sfb_file.sfb82, #TQC-5A0091 add
          l_occ02      LIKE occ_file.occ02,
          l_gem02      LIKE gem_file.gem02,
          l_qcu        RECORD LIKE qcu_file.*,
          l_qde        RECORD LIKE qde_file.*,
          l_oao        RECORD LIKE oao_file.*,
#No.FUN-730009 --end
          sr        RECORD
                   #MOD-880244-modify-add
                   qcf00  LIKE qcf_file.qcf00,
                   qcf01  LIKE qcf_file.qcf01,
                   qcf02  LIKE qcf_file.qcf02,
                   qcf021 LIKE qcf_file.qcf021,
                   qcf03  LIKE qcf_file.qcf03,
                   qcf04  LIKE qcf_file.qcf04,
                   qcf041 LIKE qcf_file.qcf041,
                   qcf05  LIKE qcf_file.qcf05,
                   qcf06  LIKE qcf_file.qcf06,
                   qcf061 LIKE qcf_file.qcf061,
                   qcf062 LIKE qcf_file.qcf062,
                   qcf071 LIKE qcf_file.qcf071,
                   qcf072 LIKE qcf_file.qcf072,
                   qcf081 LIKE qcf_file.qcf081,
                   qcf082 LIKE qcf_file.qcf082,
                   qcf09  LIKE qcf_file.qcf09,
                   qcf091 LIKE qcf_file.qcf091,
                   qcf10  LIKE qcf_file.qcf10,
                   qcf101 LIKE qcf_file.qcf101,
                   qcf11  LIKE qcf_file.qcf11,
                   qcf12  LIKE qcf_file.qcf12,
                   qcf13  LIKE qcf_file.qcf13,
                   qcf14  LIKE qcf_file.qcf14,
                   qcf15  LIKE qcf_file.qcf15,
                   qcf16  LIKE qcf_file.qcf16,
                   qcf17  LIKE qcf_file.qcf17,
                   qcf18  LIKE qcf_file.qcf18,
                   qcf19  LIKE qcf_file.qcf19,
                   qcf20  LIKE qcf_file.qcf20,
                   qcf21  LIKE qcf_file.qcf21,
                   qcf22  LIKE qcf_file.qcf22,
                  qcfprno LIKE qcf_file.qcfprno,
                  qcfacti LIKE qcf_file.qcfacti,
                  qcfuser LIKE qcf_file.qcfuser,
                  qcfgrup LIKE qcf_file.qcfgrup,
                  qcfmodu LIKE qcf_file.qcfmodu,
                  qcfdate LIKE qcf_file.qcfdate,
                   qcf30  LIKE qcf_file.qcf30,
                   qcf31  LIKE qcf_file.qcf31,
                   qcf32  LIKE qcf_file.qcf32,
                   qcf33  LIKE qcf_file.qcf33,
                   qcf34  LIKE qcf_file.qcf34,
                   qcf35  LIKE qcf_file.qcf35,
                   qcf36  LIKE qcf_file.qcf36,
                   qcf37  LIKE qcf_file.qcf37,
                   qcf38  LIKE qcf_file.qcf38,
                   qcf39  LIKE qcf_file.qcf39,
                   qcf40  LIKE qcf_file.qcf40,
                   qcf41  LIKE qcf_file.qcf41,
                  qcfspc  LIKE qcf_file.qcfspc,
                   qcg01  LIKE qcg_file.qcg01,
                   qcg03  LIKE qcg_file.qcg03,
                   qcg04  LIKE qcg_file.qcg04,
                   qcg05  LIKE qcg_file.qcg05,
                   qcg06  LIKE qcg_file.qcg06,
                   qcg07  LIKE qcg_file.qcg07,
                   qcg08  LIKE qcg_file.qcg08,
                   qcg09  LIKE qcg_file.qcg09,
                   qcg10  LIKE qcg_file.qcg10,
                   qcg11  LIKE qcg_file.qcg11,
                   qcg12  LIKE qcg_file.qcg12,
                   qcg131 LIKE qcg_file.qcg131,
                   qcg132 LIKE qcg_file.qcg132
                   # qcf        RECORD LIKE qcf_file.*,
                   # qcg        RECORD LIKE qcg_file.*
                   #MOD-880244-modify-end
                    END RECORD,
#No.FUN-730009 --begin
          sr2       RECORD
                    ocf        RECORD LIKE ocf_file.*
                    END        RECORD
#No.FUN-730009 --end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-730009 --begin
     DISPLAY l_table
     DISPLAY l_table1
     DISPLAY l_table2
     DISPLAY l_table3
     DISPLAY l_table4
     DISPLAY l_table5
     DISPLAY l_table6
     DISPLAY l_table7
     DISPLAY l_table8
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
     CALL cl_del_data(l_table5)
     CALL cl_del_data(l_table6)
     CALL cl_del_data(l_table7)
     CALL cl_del_data(l_table8)
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)"   #TQC-C10039 ADD 4?
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
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?)"
     PREPARE insert_prep6 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep6:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table7 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?)"
     PREPARE insert_prep7 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep7:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table8 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?)"
     PREPARE insert_prep8 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep8:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
#No.FUN-730009 --end
 
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
    #MOD-890053-begin-modify
    # LET l_sql = "SELECT * FROM qcf_file,OUTER qcg_file ", #TQC-590013 add OUTER
      LET l_sql = "SELECT qcf00,qcf01 ,qcf02 ,qcf021,qcf03 ,qcf04 ,qcf041,qcf05,  ",
                  "       qcf06,qcf061,qcf062,qcf071,qcf072,qcf081,qcf082,qcf09 , ",
                  "       qcf091,qcf10,qcf101,qcf11 ,qcf12 ,qcf13 ,qcf14 ,qcf15 , ",
                  "       qcf16, qcf17,qcf18 ,qcf19 ,qcf20 ,qcf21 ,qcf22 , ",
                  "       qcfprno,qcfacti,qcfuser,qcfgrup,qcfmodu,qcfdate,",
                  "       qcf30,qcf31 ,qcf32 ,qcf33 ,qcf34 ,qcf35 ,qcf36 ,qcf37 , ",
                  "       qcf38,qcf39 ,qcf40 ,qcf41 ,qcfspc,",
                  "       qcg01,qcg03 ,qcg04 ,qcg05 ,qcg06 ,qcg07 ,qcg08 ,qcg09, ",
                  "       qcg10,qcg11 ,qcg12 ,qcg131,qcg132 ",
                  " FROM  qcf_file,OUTER qcg_file ",
    #MOD-890053-end-modify
                 " WHERE qcf_file.qcf01=qcg_file.qcg01 AND qcf18='1' ",
               # " WHERE qcf_file.qcf01=qcg_file.qcg01 AND qcf14 = 'Y' AND qcf18='1' ",
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r340_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r340_curs1 CURSOR FOR r340_prepare1
 
     LET l_sql = " SELECT * FROM ocf_file ",         #NO:6882
                 " WHERE  ocf01=? AND ocf02=? "
     PREPARE asfr102_p2 FROM l_sql                   # RUNTIME 編譯
     DECLARE asfr102_curs2                           # CURSOR
        CURSOR FOR asfr102_p2
 
#No.FUN-730009 --begin
#    CALL cl_outnam('aqcr340') RETURNING l_name
#    START REPORT r340_rep TO l_name
#    LET g_pageno = 0
#No.FUN-730009 --end
     FOREACH r340_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#No.FUN-730009 --begin
         LET l_gen02 = NULL
         LET l_pmc03 = NULL
         LET l_ima02 = NULL
         LET l_ima021 = NULL
         LET l_ima15 = NULL
         LET l_ima109= NULL
         LET l_azf03_1 = NULL
         LET l_azf03_2 = NULL
         LET l_sfb22 = NULL
         LET l_sfb221 = NULL
         LET l_sfb82 = NULL
         LET l_occ02 = NULL
         LET l_gem02 = NULL
         LET l_oea01 = NULL
         LET l_oea04 = NULL
         LET l_oea44 = NULL
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcf13  #MOD-890053 modify
         SELECT ima02,ima021,ima109
           INTO l_ima02,l_ima021,l_ima109
           FROM ima_file
          WHERE ima01=sr.qcf021   #MOD-890053 modify
         SELECT azf03 INTO l_azf03_1 FROM azf_file WHERE azf01=l_ima109 AND azf02='8'
         SELECT sfb22,sfb221,sfb82 INTO l_sfb22,l_sfb221,l_sfb82 FROM sfb_file
           WHERE sfb01=sr.qcf02   #MOD-890053 modify
         SELECT occ02 INTO l_occ02 FROM oea_file,occ_file
           WHERE oea04=occ01 AND oea01=l_sfb22
         SELECT gem02 INTO l_gem02 FROM gem_file
           WHERE gem01 = l_sfb82
         SELECT azf03 INTO l_azf03_2 FROM azf_file
            WHERE azf01=sr.qcg04 AND azf02='6'   #MOD-890053 modify
         SELECT oea01,oea04,oea44 INTO l_oea01,l_oea04,l_oea44
           FROM oea_file              #抓單頭資料
          WHERE oea01=l_sfb22
         EXECUTE insert_prep USING sr.*,l_gen02,l_ima02,l_ima021,l_ima109,l_azf03_1,l_azf03_2,
                                   l_sfb22,l_sfb221,l_sfb82,l_occ02,l_gem02,l_oea01,l_oea04,l_oea44,
                                   "",l_img_blob, "N",""   #TQC-C10039 ADD "",l_img_blob, "N",""
 
        #MOD-870309-begin-mark
         #DECLARE qao_cur1 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
         #                                       WHERE qao01=sr.qcf.qcf01
         #                                         AND qao02=0
         #                                         AND qao021=0
         #                                         AND qao03=0 AND qao05='1'
         #FOREACH qao_cur1 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #   IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
         #   EXECUTE insert_prep1 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #END FOREACH
        #MOD-870309-end-mark
 
         DECLARE qao_cur2 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
                                                WHERE qao01=sr.qcf01  #MOD-890053 modify
                                                  AND qao02=0
                                                  AND qao021=0
                                                  AND qao03=sr.qcg03  #MOD-890053 modify
                                                  AND qao05='1'
         FOREACH qao_cur2 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep2 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         END FOREACH
 
         DECLARE qao_cur3 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
                                                WHERE qao01=sr.qcf01   #MOD-890053 modify
                                                  AND qao02=0
                                                  AND qao021=0
                                                  AND qao03=sr.qcg03   #MOD-890053 modify
                                                  AND qao05='2'
         FOREACH qao_cur3 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep3 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         END FOREACH
 
        #MOD-870309-begin-mark
         #DECLARE qao_cur4 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
         #                                       WHERE qao01=sr.qcf01   #MOD-890053 modify
         #                                         AND qao02=0
         #                                         AND qao021=0
         #                                         AND qao03=0 AND qao05='2'
         #FOREACH qao_cur4 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #   IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
         #   EXECUTE insert_prep4 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         #END FOREACH
        #MOD-870309-end-mark
 
         DECLARE qcu_cur CURSOR FOR
            SELECT * FROM qcu_file WHERE qcu01=sr.qcg01  #MOD-890053 modify
                                     AND qcu03=sr.qcg03  #MOD-890053 modify
         FOREACH qcu_cur INTO l_qcu.*
             LET l_qce03 = NULL
             SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
             #EXECUTE insert_prep5 USING l_qcu.*,l_qce03   #MOD-8B0079 mark
             EXECUTE insert_prep5 USING l_qcu.qcu01,l_qcu.qcu02,l_qcu.qcu021,l_qcu.qcu03,
                                        l_qcu.qcu04,l_qcu.qcu05,l_qce03
         END FOREACH
 
         IF tm.c ='Y' THEN
            OPEN asfr102_curs2 USING l_oea04,l_oea44
            FETCH asfr102_curs2 INTO sr2.*
            IF SQLCA.SQLCODE=0 AND NOT cl_null(l_oea04) THEN
               EXECUTE insert_prep6 USING sr2.*
            END IF
         END IF
 
         DECLARE qde_cur CURSOR FOR SELECT * FROM qde_file WHERE
                                    qde01 = sr.qcf01 AND qde02 = sr.qcf02  #MOD-890053 modify
         FOREACH qde_cur INTO l_qde.*
            IF SQLCA.SQLCODE THEN
               CALL cl_err('foreach:',SQLCA.SQLCODE,1)
               EXIT FOREACH
            END IF
             EXECUTE insert_prep7 USING l_qde.*
         END FOREACH
         IF tm.b = 'Y' THEN
            DECLARE s_memo1_c CURSOR FOR
              SELECT * FROM oao_file
               WHERE oao01 =l_sfb22
                 AND oao05 IN ('1','2')
                 AND oao03=0
                ORDER BY oao03
            FOREACH s_memo1_c INTO l_oao.*
                IF SQLCA.SQLCODE THEN
                   EXIT FOREACH
                ELSE
                   EXECUTE insert_prep8 USING l_oao.*
                END IF
            END FOREACH
         END IF
#        OUTPUT TO REPORT r340_rep(sr.*)
#No.FUN-730009 --end
     END FOREACH
 
     #MOD-870309-begin-add
     #列印整張備註
      LET l_sql = "SELECT qcf01 FROM qcf_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   ORDER BY qcf01"
      PREPARE r340_prepare2 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare1:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      DECLARE r340_cs2 CURSOR FOR r340_prepare2
 
      FOREACH r340_cs2 INTO sr.qcf01   #MOD-890053 modify
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach2:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
         DECLARE qao_cur4 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
                                                WHERE qao01=sr.qcf01   #MOD-890053 modify
                                                  AND qao02=0
                                                  AND qao021=0
                                                  AND qao03=0 AND qao05='2'
         FOREACH qao_cur4 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep4 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         END FOREACH
 
         DECLARE qao_cur1 CURSOR FOR SELECT qao01,qao02,qao021,qao03,qao05,qao06 FROM qao_file
                                                WHERE qao01=sr.qcf01   #MOD-890053 modify
                                                  AND qao02=0
                                                  AND qao021=0
                                                  AND qao03=0 AND qao05='1'
         FOREACH qao_cur1 INTO l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep1 USING l_qao01,l_qao02,l_qao021,l_qao03,l_qao05,l_qao06
         END FOREACH
 
      END FOREACH
     #MOD-870309-end-add
 
 
#No.FUN-730009 --begin
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'qcf01,qcf021,qcf02,qcf13')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05,";",tm.b,";",tm.c,";",g_sma.sma115    #No.CHI-830021 add
  #-------------------No.MOD-820094 modify
  #  LET l_sql = " SELECT A.*,G.*,B.*,C.*,F.*,D.*,E.*,H.*,I.* ",
  ##TQC-730113## "   FROM ",l_table CLIPPED," A,OUTER ",l_table1 CLIPPED," B,OUTER ",l_table2 CLIPPED," C,OUTER ",l_table3 CLIPPED,
  #              "   FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A, ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B, ",g_cr_db_str CLIPPED,l_table2 CLIPPED," C, ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
  ##TQC-730113## " D,OUTER ",l_table4 CLIPPED," E,OUTER ",l_table5 CLIPPED," F,OUTER",l_table6 CLIPPED," G,OUTER ",l_table7 CLIPPED," H,OUTER",l_table8 CLIPPED," I",      
  #              " D, ",g_cr_db_str CLIPPED,l_table4 CLIPPED," E, ",g_cr_db_str CLIPPED,l_table5 CLIPPED," F,",g_cr_db_str CLIPPED,l_table6 CLIPPED," G, ",g_cr_db_str CLIPPED,l_table7 CLIPPED," H, ",g_cr_db_str CLIPPED,l_table8 CLIPPED," I",   #No.MOD-7C0158 modify
  #              "  WHERE A.qcf01 = B.qao01_1(+) ",
  #              "    AND A.qcf01 = C.qao01_2(+)",
  #              "    AND A.qcf01 = D.qao01_3(+)",
  #              "    AND A.qcf01 = E.qao01_4(+)",
  #              "    AND A.qcg01 = F.qcu01(+)",
  #              "    AND A.oea04 = G.ocf01(+)",
  #              "    AND A.qcf01 = H.qde01(+)",
  #              "    AND A.sfb22 = I.oao01(+)"
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table7 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table8 CLIPPED
  #-------------------No.MOD-820094 end
   # CALL cl_prt_cs3('aqcr340',l_sql,g_str)  #TQC-730113
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "qcf01"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('aqcr340','aqcr340',l_sql,g_str)
#    FINISH REPORT r340_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-730009 --end
END FUNCTION
 
#No.FUN-730009 --begin
#REPORT r340_rep(sr)
#   DEFINE l_oea01 LIKE oea_file.oea01
#   DEFINE l_ofb01 LIKE ofb_file.ofb01
#   DEFINE l_oea04 LIKE oea_file.oea04
#   DEFINE l_oea44 LIKE oea_file.oea44
#   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#          l_qao06      LIKE qao_file.qao06,
#          l_gen02      LIKE gen_file.gen02,
#          l_pmc03      LIKE pmc_file.pmc03,
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          l_ima109     LIKE ima_file.ima109,
#          l_sfb22      LIKE sfb_file.sfb22,
#          l_sfb221     LIKE sfb_file.sfb221,
#          l_sfb82      LIKE sfb_file.sfb82, #TQC-5A0091 add
#          l_occ02      LIKE occ_file.occ02,
#          l_gem02      LIKE gem_file.gem02,
#          l_azf03      LIKE azf_file.azf03,
#          l_ima15      LIKE ima_file.ima15,
#          l_qce03      LIKE qce_file.qce03,
#          l_qcv04      LIKE qcv_file.qcv04,  #bugno:6010 add
#          l_qcf09      LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(04)
#          l_qcg05      LIKE type_file.chr2,       #No.FUN-680104 VARCHAR(02)
#          qcf21_desc   LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(04)
#          qcg08_desc   LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(04)
#          l_qcu        RECORD LIKE qcu_file.*,
#          l_qde        RECORD LIKE qde_file.*,
#          l_sql1       LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(300)
#          l_g_x_26     LIKE qcs_file.qcs03,       #No.FUN-680104 VARCHAR(09)
#          l_y          LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(01)
# Prog. Version..: '5.30.06-13.03.12(09)        # bugno:6010 add
#          sr            RECORD
#                        qcf        RECORD LIKE qcf_file.*,
#                        qcg        RECORD LIKE qcg_file.*
#                        END RECORD,
#          sr3           RECORD
#                        ocf        RECORD LIKE ocf_file.*,    #NO:6882
#                        l_occ02      LIKE occ_file.occ02
#                        END        RECORD,
#           sr4          RECORD
#                        oao03      LIKE oao_file.oao03,   #NO:6882
#                        oao05      LIKE oao_file.oao05,
#                        oao06      LIKE oao_file.oao06
#                        END        RECORD
#
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.qcf.qcf01,sr.qcg.qcg03
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
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1] CLIPPED   #No.TQC-6A0091
#      PRINT
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.qcf.qcf01
#      SKIP TO TOP OF PAGE
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcf.qcf13
#      SELECT ima02,ima021,ima109
#        INTO l_ima02,l_ima021,l_ima109
#        FROM ima_file
#       WHERE ima01=sr.qcf.qcf021
#      SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=l_ima109 AND azf02='8'
#      #TQC-5A0091 mark
#      #SELECT sfb22,sfb221,occ02,gem02     #NO:6882
#      #  INTO l_sfb22,l_sfb221,l_occ02,l_gem02
#      #  FROM sfb_file,gem_file,occ_file,oea_file
#      # WHERE sfb01=sr.qcf.qcf02
#      #   AND sfb22=oea01
#      #   AND oea04=occ01
#      #   #AND oea15=gem01 #MOD-590409 mark
#      #   AND sfb82=gem01   #MOD-490409 add
#      #TQC-5A0091 end mark
#      #TQC-5A0091 add
#      SELECT sfb22,sfb221,sfb82 INTO l_sfb22,l_sfb221,l_sfb82 FROM sfb_file
#        WHERE sfb01=sr.qcf.qcf02
#      SELECT occ02 INTO l_occ02 FROM oea_file,occ_file
#        WHERE oea04=occ01 AND oea01=l_sfb22
#      SELECT gem02 INTO l_gem02 FROM gem_file
#        WHERE gem01 = l_sfb82
#      #TQC-5A0091 end
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
#      PRINT COLUMN 01,g_x[11] CLIPPED,sr.qcf.qcf01 CLIPPED,  #No.TQC-6A0091
##No.FUN-550063 --start--
#            COLUMN 27,g_x[16] CLIPPED,sr.qcf.qcf02 CLIPPED,  #No.TQC-6A0091
#            COLUMN 53,g_x[28] CLIPPED,sr.qcf.qcf05 CLIPPED,  #No.TQC-6A0091
#            COLUMN 79,g_x[31] CLIPPED,qcf21_desc CLIPPED     #No.FUN-5A0141
##No.FUN-550063 ---end--
#      PRINT COLUMN 01,g_x[17] CLIPPED,sr.qcf.qcf021 CLIPPED, #No.FUN-550002
#            COLUMN 53,g_x[30] CLIPPED,l_azf03 CLIPPED                #No.FUN-5A0141  #No.TQC-6A0091
#      PRINT COLUMN 01,g_x[18] CLIPPED,l_ima02 CLIPPED
#            #COLUMN 46,g_x[31] CLIPPED,qcf21_desc CLIPPED    #No.FUN-5A0141 mark
#      PRINT COLUMN 01,g_x[21] CLIPPED,l_sfb22 CLIPPED,  #No.TQC-6A0091
#            COLUMN 53,g_x[29] CLIPPED,l_occ02 CLIPPED           #No.FUN-5A0141
#      PRINT COLUMN 01,g_x[22] CLIPPED,l_gem02 CLIPPED,  #No.FUN-550002
#            COLUMN 53,g_x[23] CLIPPED,sr.qcf.qcf19 CLIPPED,'-',sr.qcf.qcf20  #No.FUN-5A0141
#      #-----No.FUN-610075-----
#      PRINT COLUMN 01,g_x[64] CLIPPED,sr.qcf.qcf30 CLIPPED,  #No.TQC-6A0091
#            COLUMN 27,g_x[65] CLIPPED,sr.qcf.qcf31 USING '####&',
#            COLUMN 53,g_x[66] CLIPPED,sr.qcf.qcf32 USING '#######&'
#      PRINT COLUMN 01,g_x[67] CLIPPED,sr.qcf.qcf33,  #No.TQC-6A0091
#            COLUMN 27,g_x[68] CLIPPED,sr.qcf.qcf34 USING '####&',
#            COLUMN 53,g_x[69] CLIPPED,sr.qcf.qcf35 USING '#######&'
#      #-----No.FUN-610075 END-----
#      PRINT COLUMN 01,g_x[13] CLIPPED,sr.qcf.qcf04 CLIPPED,  #No.TQC-6A0091
#            COLUMN 27,g_x[33] CLIPPED,sr.qcf.qcf041 CLIPPED,         #No.FUN-5A0141
#            COLUMN 53,g_x[19] CLIPPED,sr.qcf.qcf22 USING '#######&',  #No.FUN-5A0141
#            COLUMN 70,g_x[20] CLIPPED,sr.qcf.qcf06 USING '#######&'   #No.FUN-5A0141
#      #-----No.FUN-610075-----
#      PRINT COLUMN 01,g_x[70] CLIPPED,sr.qcf.qcf36 CLIPPED,  #No.TQC-6A0091
#            COLUMN 27,g_x[71] CLIPPED,sr.qcf.qcf37 USING '####&',
#            COLUMN 53,g_x[72] CLIPPED,sr.qcf.qcf38 USING '#######&'
#      PRINT COLUMN 01,g_x[73] CLIPPED,sr.qcf.qcf39 CLIPPED,  #No.TQC-6A0091
#            COLUMN 27,g_x[74] CLIPPED,sr.qcf.qcf40 USING '####&',
#            COLUMN 53,g_x[75] CLIPPED,sr.qcf.qcf41 USING '#######&'
#      #-----No.FUN-610075 END-----
#      PRINT COLUMN 01,g_x[34] CLIPPED,sr.qcf.qcf091 USING '#######&',
#            COLUMN 27,g_x[24] CLIPPED,l_qcf09 CLIPPED,               #No.FUN-5A0141  #No.TQC-6A0091
#            COLUMN 53,g_x[15] CLIPPED,l_gen02 CLIPPED                #No.FUN-5A0141  #No.TQC-6A0091
#         DECLARE qao_cur CURSOR FOR SELECT qao06 FROM qao_file
#                                                WHERE qao01=sr.qcf.qcf01
#                                                  AND qao02=0
#                                                  AND qao021=0
#                                                  AND qao03=0 AND qao05='1'
#         FOREACH qao_cur INTO l_qao06
#            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
#            IF NOT cl_null(l_qao06) THEN
#               PRINT COLUMN 01,l_qao06 CLIPPED  #No.TQC-6A0091
#            END IF
#         END FOREACH
#
##     PRINT COLUMN 01,g_x[25] CLIPPED,sr.qcf.qcf12
#      PRINT g_dash2[1,g_len]
#      PRINTX name=H1 g_x[54],g_x[55],g_x[56],g_x[57],g_x[58],
#            g_x[59],g_x[60],g_x[61],g_x[62],g_x[63]
#      PRINT g_dash1
#
#   ON EVERY ROW
#      LET l_azf03 = NULL # TQC-590013 add
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
#         DECLARE qao_cur2 CURSOR FOR SELECT qao06 FROM qao_file
#                                                WHERE qao01=sr.qcf.qcf01
#                                                  AND qao02=0
#                                                  AND qao021=0
#                                                  AND qao03=sr.qcg.qcg03
#                                                  AND qao05='1'
#         FOREACH qao_cur2 INTO l_qao06
#            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
#            IF NOT cl_null(l_qao06) THEN
#               PRINT COLUMN 01,l_qao06 CLIPPED  #No.TQC-6A0091
#            END IF
#         END FOREACH
#
#      PRINTX name=D1 COLUMN g_c[54],sr.qcg.qcg03 USING '###&', #FUN-590118
#            COLUMN g_c[55],sr.qcg.qcg04 CLIPPED,
#            COLUMN g_c[56],l_azf03[1,14],
#            COLUMN g_c[57],l_qcg05 CLIPPED,
#            COLUMN g_c[58],cl_numfor(sr.qcg.qcg06,58,2),
#            COLUMN g_c[59],sr.qcg.qcg09 USING '####&',
#            COLUMN g_c[60],sr.qcg.qcg10 USING '####&',
#            COLUMN g_c[61],cl_numfor(sr.qcg.qcg11,61,2),
#            COLUMN g_c[62],cl_numfor(sr.qcg.qcg07,62,2),
#            COLUMN g_c[63],qcg08_desc CLIPPED  #No.TQC-6A0091
#      LET l_g_x_26=g_x[26]
#      DECLARE qcu_cur CURSOR FOR
#         SELECT * FROM qcu_file WHERE qcu01=sr.qcg.qcg01
#                                  AND qcu03=sr.qcg.qcg03
#         FOREACH qcu_cur INTO l_qcu.*
#             SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
#             PRINT COLUMN 07,l_g_x_26,l_qcu.qcu04 CLIPPED,' ',l_qce03 CLIPPED,
#                   COLUMN g_c[62],cl_numfor(l_qcu.qcu05,62,2)
#             LET l_g_x_26='         '
#         END FOREACH
#         DECLARE qao_cur3 CURSOR FOR SELECT qao06 FROM qao_file
#                                                WHERE qao01=sr.qcf.qcf01
#                                                  AND qao02=0
#                                                  AND qao021=0
#                                                  AND qao03=sr.qcg.qcg03
#                                                  AND qao05='2'
#         FOREACH qao_cur3 INTO l_qao06
#            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
#            IF NOT cl_null(l_qao06) THEN
#               PRINT COLUMN 01,l_qao06 CLIPPED  #No.TQC-6A0091
#            END IF
#         END FOREACH
#
#{
##bugno:6010 add display 單身備註 .....................................
#      DECLARE qcv_cur CURSOR FOR
#         SELECT qcv04 FROM qcv_file WHERE qcv01 =sr.qcg.qcg01
#                                      AND qcv03 =sr.qcg.qcg03
#      LET l_g_x_25=g_x[25]
#      FOREACH qcv_cur INTO l_qcv04
#          PRINT COLUMN 07,l_g_x_25 CLIPPED,l_qcv04 CLIPPED   #No.TQC-6A0091
#          LET l_g_x_25='         '
#      END FOREACH
#
#
##bugno:6010 end ......................................................
#}
#    AFTER GROUP OF sr.qcf.qcf01
##---->印聯產品資料 NO:6872
#      SELECT COUNT(*) INTO g_cnt FROM qde_file
#             WHERE qde01 = sr.qcf.qcf01 AND qde02 = sr.qcf.qcf02
#      IF g_cnt > 0 THEN
#         PRINT '     '
#         PRINT COLUMN 1,g_x[50] CLIPPED,g_x[51]
#         PRINT COLUMN 1,g_x[52] CLIPPED,COLUMN 39,g_x[53] CLIPPED
#         PRINT " ---- --------------------     ----   ---------- ",
#               "-------------------------------"
#      ELSE
#         PRINT '     '
#      END IF
#      DECLARE qde_cur CURSOR FOR SELECT * FROM qde_file WHERE
#                                 qde01 = sr.qcf.qcf01 AND qde02 = sr.qcf.qcf02
#      FOREACH qde_cur INTO l_qde.*
#         IF SQLCA.SQLCODE THEN
#            CALL cl_err('foreach:',SQLCA.SQLCODE,1)
#            EXIT FOREACH
#         END IF
#         PRINT COLUMN  2,l_qde.qde03 USING "####",
#               COLUMN  7,l_qde.qde05 CLIPPED,  #No.TQC-6A0091
#               COLUMN 32,l_qde.qde12 CLIPPED,  #No.TQC-6A0091
#               COLUMN 39,l_qde.qde06 USING "#########&", #數量
#               COLUMN 50,l_qde.qde08 CLIPPED  #No.TQC-6A0091
#         PRINT COLUMN 07,l_ima02 CLIPPED,  #No.TQC-6A0091
#               COLUMN 39,l_qde.qde09 CLIPPED, #倉  #No.TQC-6A0091
#               COLUMN 50,l_qde.qde10 CLIPPED, #儲  #No.TQC-6A0091
#               COLUMN 61,l_qde.qde11 CLIPPED  #批  #No.TQC-6A0091
#      END FOREACH
#
#     #====================================================NO:6882印memo
#      IF tm.b ='Y' THEN
#         DECLARE s_memo1_c CURSOR FOR
#           SELECT oao03,oao05,oao06,oao04 FROM oao_file
#            WHERE oao01 =l_sfb22
#              AND oao05 IN ('1','2')
#              AND oao03=0
#             ORDER BY oao03
#         LET l_y='Y'            #PRINT title one time
#         FOREACH s_memo1_c INTO sr4.*
#             IF SQLCA.SQLCODE THEN
#                EXIT FOREACH
#             ELSE
#                IF l_y='Y' THEN    #PRINT title
#                    PRINT
#                    PRINT g_x[46] CLIPPED,g_x[47] CLIPPED
#                    PRINT
#                    PRINT COLUMN 10,g_x[48] CLIPPED
#                    PRINT COLUMN 10,g_x[49] CLIPPED
#                END IF
#                PRINT COLUMN 11,sr4.oao03 USING '&&',
#                      COLUMN 16,sr4.oao05 CLIPPED,  #No.TQC-6A0091
#                      COLUMN 19,sr4.oao06 CLIPPED  #No.TQC-6A0091
#             END IF
#             LET l_y='N'
#         END FOREACH
#         PRINT
#      END IF
#      #====================================================NO:6882印麥頭
#      IF tm.c ='Y' THEN
#          SELECT oea01,oea04,oea44 INTO l_oea01,l_oea04,l_oea44
#            FROM oea_file              #抓單頭資料
#           WHERE oea01=l_sfb22
#          IF SQLCA.SQLCODE THEN
#              LET l_oea01=NULL
#              LET l_oea04=NULL
#              LET l_oea44=NULL
#          END IF
#          OPEN asfr102_curs2 USING l_oea04,l_oea44
#          FETCH asfr102_curs2 INTO sr3.*
#          IF SQLCA.SQLCODE=0 AND NOT cl_null(l_oea04) THEN
#              IF LINENO>40 THEN SKIP TO TOP OF PAGE END IF
#              PRINT
#              PRINT g_x[44] CLIPPED,g_x[45] CLIPPED
#              PRINT
#              PRINT COLUMN 10,g_x[40] CLIPPED,sr3.ocf.ocf01,' ',l_occ02,
#                    COLUMN 45,g_x[41] CLIPPED,sr3.ocf.ocf02
#              PRINT '       ------------------------------   ',
#                           '-----------------------------'
#              PRINT COLUMN 21,g_x[42] CLIPPED,
#                    COLUMN 52,g_x[43] CLIPPED
#              PRINT '       ------------------------------   '
#                           ,'-----------------------------'
#              PRINT COLUMN 8,sr3.ocf.ocf101 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf201 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf102 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf202 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf103 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf203 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf104 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf204 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf105 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf205 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf106 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf206 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf107 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf207 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf108 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf208 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf109 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf209 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf110 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf210 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf111 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf211 CLIPPED  #No.TQC-6A0091
#              PRINT COLUMN 8,sr3.ocf.ocf112 CLIPPED,  #No.TQC-6A0091
#                    COLUMN 41,sr3.ocf.ocf212 CLIPPED  #No.TQC-6A0091
#          END IF
#      END IF
#      #====================================================NO:6882
#         DECLARE qao_cur4 CURSOR FOR SELECT qao06 FROM qao_file
#                                                WHERE qao01=sr.qcf.qcf01
#                                                  AND qao02=0
#                                                  AND qao021=0
#                                                  AND qao03=0 AND qao05='2'
#         FOREACH qao_cur4 INTO l_qao06
#            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
#            IF NOT cl_null(l_qao06) THEN
#               PRINT COLUMN 01,l_qao06 CLIPPED  #No.TQC-6A0091
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
