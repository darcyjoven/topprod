# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aqcr300.4gl
# Descriptions...: 進料檢驗報告
# Date & Author..: 99/05/10 By Melody
# Modify.........: No:7706 08/08/06 By Mandy
#                  檢驗項目不合格時，項目判定欄會出現「重工」(ze01=aqc-005) 。
#                  應將 aqc005 改為「驗退」，重工應另使用一個 訊息 (於 FQC 或 PQC 時使用)
# Modify.........: No:8198 03/09/15 By Apple 程式為OPEN WINDOW r300_w,為何會有段程式為CLOSE WINDOW r520_w
# Modify.........: No.FUN-4B0001 04/11/02 By Smapmin 收貨單號,料件編號,廠商編號,檢驗員開窗
# Modify.........: No.FUN-550063 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-550121 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/16 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: No.TQC-590013 05/09/28 By Rosayu 當單頭有資料而單身沒資料時無列印
# Modify.........: No.TQC-5A0009 05/10/06 By kim 料號放大
# Modify.........: No.FUN-5C0078 05/12/20 By jackie 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.FUN-5C0076 05/12/22 By jackie 增加傳參g_argv1，分別配合IQC，倉庫QC和OQC的需要
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: NO.FUN-610075 06/01/20 By Nicola 列印多單位資料
# Modify.........: NO.MOD-640175 06/04/09 By day  不使用雙單位時，不打印雙單位信息
# Modify.........: No.TQC-660119 06/06/27 By Sarah aqcr300相關程式產出的報表名稱不能都是aqcr300.??r
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-730009 07/03/06 By Ray Crystal Report修改
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.MOD-820153 08/02/26 By Pengu 新增列印銷退QC單
# Modify.........: No.FUN-850062 08/05/13 By baofei 修改EXECUTE字段個數于臨時表不對應
# Modify.........: No.TQC-860034 08/06/23 By Smapmin 備註列印錯誤
# Modify.........: No.MOD-950288 09/06/02 By mike 將tm.wc,l_sql定義為string
# Modify.........: No.MOD-970269 09/07/30 By mike 在table5中加上qcuicd01與qcuicd02兩欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/12 By huangrh 精簡程式
# Modify.........: No.FUN-A50053 10/05/25 By liuxqa 追单MOD-990048
# Modify.........: No.FUN-B80066 11/08/05 By xuxz  AQC模組程序撰寫規範修正
# Modify.........: No:TQC-C10039 12/01/13 By minpp  CR报表列印TIPTOP与EasyFlow签核图片 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING,                      #MOD-950288
              more    LIKE type_file.chr1         #No.FUN-680104 VARCHAR(01)
              END RECORD
 
DEFINE   g_argv1         LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)      #No.FUN-5C0076
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_str           STRING       #No.FUN-5C0076
DEFINE   g_str1          STRING       #No.FUN-5C0076
DEFINE   g_str2          STRING       #No.FUN-5C0076
DEFINE   g_str3          STRING       #No.FUN-5C0076
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  l_table1   STRING
DEFINE  l_table2   STRING
DEFINE  l_table3   STRING
DEFINE  l_table4   STRING
DEFINE  l_table5   STRING
define  g_wc       string #darcy:2022/07/14 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
  
   LET g_argv1 = ARG_VAL(1) #"1"
   LET g_towhom = ARG_VAL(2) #""
   LET g_rlang = ARG_VAL(3) #"2"
   LET g_bgjob = ARG_VAL(4) #"Y"
   LET g_prtway = ARG_VAL(5) #"1"
   LET g_copies = ARG_VAL(6) #"1"
   LET tm.wc    = ARG_VAL(7) #"1=2"
   let g_wc = tm.wc #darcy:2022/07/14 add
   LET g_rep_user = ARG_VAL(8) 
   LET g_rep_clas = ARG_VAL(9) #"N"
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   CASE g_argv1
      WHEN "1" LET g_prog = 'aqcr300'
      WHEN "2" LET g_prog = 'aqcr360'
      WHEN "3" LET g_prog = 'aqcr370'
      OTHERWISE 
      EXIT PROGRAM
         
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690121
   LET g_sql ="qcs00.qcs_file.qcs00,",
              "qcs01.qcs_file.qcs01,",
              "qcs02.qcs_file.qcs02,",
              "qcs021.qcs_file.qcs021,",
              "qcs03.qcs_file.qcs03,",
              "qcs04.qcs_file.qcs04,",
              "qcs041.qcs_file.qcs041,",
              "qcs05.qcs_file.qcs05,",
              "qcs06.qcs_file.qcs06,",
              "qcs061.qcs_file.qcs061,",
              "qcs062.qcs_file.qcs062,",
              "qcs071.qcs_file.qcs071,",
              "qcs072.qcs_file.qcs072,",
              "qcs081.qcs_file.qcs081,",
              "qcs082.qcs_file.qcs082,",
              "qcs09.qcs_file.qcs09,",
              "qcs091.qcs_file.qcs091,",
              "qcs10.qcs_file.qcs10,",
              "qcs101.qcs_file.qcs101,",
              "qcs11.qcs_file.qcs11,",
              "qcs12.qcs_file.qcs12,",
              "qcs13.qcs_file.qcs13,",
              "qcs14.qcs_file.qcs14,",
              "qcs15.qcs_file.qcs15,",
              "qcs16.qcs_file.qcs16,",
              "qcs17.qcs_file.qcs17,",
              "qcs18.qcs_file.qcs18,",
              "qcs19.qcs_file.qcs19,",
              "qcs20.qcs_file.qcs20,",
              "qcs21.qcs_file.qcs21,",
              "qcs22.qcs_file.qcs22,",
              "qcsprno.qcs_file.qcsprno,",
              "qcsacti.qcs_file.qcsacti,",
              "qcsuser.qcs_file.qcsuser,",
              "qcsgrup.qcs_file.qcsgrup,",
              "qcsmodu.qcs_file.qcsmodu,",
              "qcsdate.qcs_file.qcsdate,",
              "qcs30.qcs_file.qcs30,",
              "qcs31.qcs_file.qcs31,",
              "qcs32.qcs_file.qcs32,",
              "qcs33.qcs_file.qcs33,",
              "qcs34.qcs_file.qcs34,",
              "qcs35.qcs_file.qcs35,",
              "qcs36.qcs_file.qcs36,",
              "qcs37.qcs_file.qcs37,",
              "qcs38.qcs_file.qcs38,",
              "qcs39.qcs_file.qcs39,",
              "qcs40.qcs_file.qcs40,",
              "qcs41.qcs_file.qcs41,",
              "qcsspc.qcs_file.qcsspc,",
              "qct01.qct_file.qct01,",
              "qct02.qct_file.qct02,",
              "qct021.qct_file.qct021,",
              "qct03.qct_file.qct03,",
              "qct04.qct_file.qct04,",
              "qct05.qct_file.qct05,",
              "qct06.qct_file.qct06,",
              "qct07.qct_file.qct07,",
              "qct08.qct_file.qct08,",
              "qct09.qct_file.qct09,",
              "qct10.qct_file.qct10,",
              "qct11.qct_file.qct11,",
              "qct12.qct_file.qct12,",
              "qct131.qct_file.qct131,",
              "qct132.qct_file.qct132,",
              "gen02.gen_file.gen02,",
              "pmc03.pmc_file.pmc03,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ima15.ima_file.ima15,",
              "ima109.ima_file.ima109,",
              "azf03_1.azf_file.azf03,",
              "azf03_2.azf_file.azf03,",
              "sign_type.type_file.chr1,",      #簽核方式   #TQC-C10039
              "sign_img.type_file.blob ,",      #簽核圖檔   #TQC-C10039
              "sign_show.type_file.chr1,",      #是否顯示簽核資料(Y/N)  #TQC-C10039
              "sign_str.type_file.chr1000"      #簽核字串 #TQC-C10039
              #darcy:2022/06/27 s---
              ,",qctt001.qctt_file.qctt04,",
              "qctt002.qctt_file.qctt04,",
              "qctt003.qctt_file.qctt04,",
              "qctt004.qctt_file.qctt04,",
              "qctt005.qctt_file.qctt04,",
              "qctt006.qctt_file.qctt04,",
              "qctt007.qctt_file.qctt04,",
              "qctt008.qctt_file.qctt04,",
              "qctt009.qctt_file.qctt04,",
              "qctt010.qctt_file.qctt04"
              #darcy:2022/06/27 e---
              ,",qcttmark.type_file.chr1000"
              #darcy:2022/12/07 add s---
              ,",qcsud03.qcs_file.qcsud03,",
              "qctud02.qct_file.qctud02"
              #darcy:2022/12/07 add e---

   LET l_table = cl_prt_temptable('aqcr300',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_1.qao_file.qao01,",
              "qao03_1.qao_file.qao03,",
              "qao05_1.qao_file.qao05,",
              "qao06_1.qao_file.qao06"
   LET l_table1 = cl_prt_temptable('aqcr3001',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_2.qao_file.qao01,",
              "qao03_2.qao_file.qao03,",
              "qao05_2.qao_file.qao05,",
              "qao06_2.qao_file.qao06"
   LET l_table2 = cl_prt_temptable('aqcr3002',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_3.qao_file.qao01,",
              "qao03_3.qao_file.qao03,",
              "qao05_3.qao_file.qao05,",
              "qao06_3.qao_file.qao06"
   LET l_table3 = cl_prt_temptable('aqcr3003',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qao01_4.qao_file.qao01,",
              "qao03_4.qao_file.qao03,",
              "qao05_4.qao_file.qao05,",
              "qao06_4.qao_file.qao06"
   LET l_table4 = cl_prt_temptable('aqcr3004',g_sql) CLIPPED
   IF l_table4 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="qcu01.qcu_file.qcu01,",
              "qcu02.qcu_file.qcu02,",
              "qcu021.qcu_file.qcu021,",
              "qcu03.qcu_file.qcu03,",
              "qcu04.qcu_file.qcu04,",
              "qcu05.qcu_file.qcu05,",
              "qcuicd01.qcu_file.qcuicd01,", #MOD-970269                                                                            
              "qcuicd02.qcu_file.qcuicd02,", #MOD-970269    
              "qce03.qce_file.qce03"
   LET l_table5 = cl_prt_temptable('aqcr3005',g_sql) CLIPPED
   IF l_table5 = -1 THEN EXIT PROGRAM END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r300_tm(0,0)
   ELSE
      CALL r300()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680104 SMALLINT
         l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(01)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r300_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   IF g_argv1 != "1" THEN
      CALL r300_form_default()                  #No.FUN-5C0076
   END IF
 
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
      CONSTRUCT BY NAME tm.wc ON qcs01,qcs021,qcs03,qcs13
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             #darcy:2022/07/14 s---
             if g_argv1 ="1" and not cl_null(g_wc) then
               let tm.wc = g_wc
               let g_action_choice = ""
               exit while
             end if
             #darcy:2022/07/14 e---
 
   ON ACTION CONTROLP    #FUN-4B0001
      CASE WHEN INFIELD(qcs01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs4"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcs01
              NEXT FIELD qcs01
           WHEN INFIELD(qcs021)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcs021
              NEXT FIELD qcs021
           WHEN INFIELD(qcs03)
              CALL cl_init_qry_var()
              CASE g_argv1
                WHEN '1'
                  LET g_qryparam.form = "q_qcs3"
                WHEN '2'
                  LET g_qryparam.form = "q_qcs3"
                WHEN '3'
                  LET g_qryparam.form = "q_occ"
              END CASE
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      LET g_action_choice = "locale"
      IF g_argv1 != "1" THEN
         CALL r300_form_default()                  #No.FUN-5C0076
      END IF
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r300_w    #No:8198
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   INPUT BY NAME tm.more WITHOUT DEFAULTS
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr300','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aqcr300',g_time,l_cmd)
      END IF
      CLOSE WINDOW r300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r300()
   ERROR ""
END WHILE
   CLOSE WINDOW r300_w
END FUNCTION
 
FUNCTION r300()
   DEFINE  l_img_blob     LIKE type_file.blob              #TQC-C10039
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
          l_sql     STRING,                       #MOD-950288
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
          l_gen02      LIKE gen_file.gen02,
          l_pmc03      LIKE pmc_file.pmc03,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_ima109     LIKE ima_file.ima109,
          l_ima15      LIKE ima_file.ima15,
          l_azf03_1    LIKE azf_file.azf03,
          l_azf03_2    LIKE azf_file.azf03,
          l_qao01      LIKE qao_file.qao01,
          l_qao03      LIKE qao_file.qao03,
          l_qao05      LIKE qao_file.qao05,
          l_qao06      LIKE qao_file.qao06,
          l_qce03      LIKE qce_file.qce03,
          l_qcu        RECORD LIKE qcu_file.*,
          sr        RECORD
                    qcs        RECORD LIKE qcs_file.*,
                    qct        RECORD LIKE qct_file.*
                    END RECORD
   #darcy:2022/06/27 add s---
   define l_qctt04  LIKE qctt_file.qctt04  
   define l_cnt     like type_file.num5    
   define l_qctt    array [20] of DECIMAL(15,3)
   #darcy:2022/06/27 add e---
   #darcy:2022/08/11 add s---
   define l_mark    like type_file.chr1000
   define l_str     string
   #darcy:2022/08/11 add e---
   #darcy:2022/12/09 add s---
   define l_qcs01    like qcs_file.qcs01,
          l_qcs02    like qcs_file.qcs02,
          l_qcs05    like qcs_file.qcs05
   #darcy:2022/12/09 add e---
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LOCATE l_img_blob IN MEMORY   #blob初始化   #TQC-C10039
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     CALL cl_del_data(l_table4)
     CALL cl_del_data(l_table5)
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ", #darcy:2022/06/27 add 
                 "        ?, ?, ?, ?, ?, ?, ? , ?,?,?)" #darcy:2022/08/11 add 1 ?   ##TQC-C10039  add 4? #darcy:2022/12/07 add 2?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?, ?, ?, ?)"   #TQC-860034
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?, ?, ?, ?)"   #TQC-860034
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                 " VALUES(?, ?, ?, ?)"   #TQC-860034
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep3:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                 " VALUES(?, ?, ?, ?)"  #TQC-860034
     PREPARE insert_prep4 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep4:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?,?,?)" #MOD-970269 add ?,?  
     PREPARE insert_prep5 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep5:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-B80066
        EXIT PROGRAM
     END IF
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup')
      display tm.wc
      
     CASE g_argv1
         WHEN '1'
           LET l_sql = "SELECT * FROM qcs_file LEFT OUTER JOIN qct_file ", #TQC-590013 add OUTER
                       "    ON qcs01 = qct01 AND qcs02 = qct02 AND qcs05 = qct021", #AND qcs14 = 'Y'",  #bugno:6010 mark
                       " WHERE qcs00<'5' ",  #No.FUN-5C0078
                       "   AND qcs14 != 'X' ",   #FUN-A50053 add
                       "   AND ", tm.wc CLIPPED
 
         WHEN '2'
           LET l_sql = "SELECT * FROM qcs_file LEFT OUTER JOIN qct_file ",
                       "    ON qcs01 = qct01 AND qcs02 = qct02 AND qcs05 = qct021", #AND qcs14 = 'Y'",
                       " WHERE qcs00 IN ('A','B','C','D','E','F','G','Z') ",   #No.MOD-820153 add 'H'
                       "   AND qcs14 != 'X' ",         #FUN-A50053 add
                       "   AND ", tm.wc CLIPPED
 
         WHEN '3'
           LET l_sql = "SELECT * FROM qcs_file LEFT OUTER JOIN qct_file ",
                       "    ON qcs01 = qct01 AND qcs02 = qct02 AND qcs05 = qct021", #AND qcs14 = 'Y'",
                       " WHERE qcs00 IN ('5','6') ",
                       "   AND qcs14 != 'X' ",     #FUN-A50053 add
                       "   AND ", tm.wc CLIPPED
     END CASE
     PREPARE r300_prepare1 FROM  l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r300_curs1 CURSOR FOR r300_prepare1
     LET g_prog = 'aqcr300'   #No.FUN-5C0076
     CASE g_argv1
        WHEN "1" LET g_prog = 'aqcr300'
        WHEN "2" LET g_prog = 'aqcr360'
        WHEN "3" LET g_prog = 'aqcr370'
     END CASE
     LET g_prog = 'aqcr300'   #No.FUN-5C0076
     #darcy:2022/06/27 s---
     display l_sql
     display "-----"
     display tm.wc
     display "-----"
     DECLARE r300_qctt_curs CURSOR FOR  
         SELECT qctt04 FROM qctt_file WHERE qctt01 =? and qctt02 =? and qctt021=? and qctt03 =?
     #darcy:2022/06/27 e---
     FOREACH r300_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_gen02 = NULL
         LET l_pmc03 = NULL
         LET l_ima02 = NULL
         LET l_ima021 = NULL
         LET l_ima15 = NULL
         LET l_ima109= NULL
         LET l_azf03_1 = NULL
         LET l_azf03_2 = NULL
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.qcs.qcs13
         SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=sr.qcs.qcs03
         if cl_null(l_pmc03) then let l_pmc03 = sr.qcs.qcsud08  end if#darcy:2022/11/17 add 
         SELECT ima02,ima021,ima15,ima109
           INTO l_ima02,l_ima021,l_ima15,l_ima109
           FROM ima_file
          WHERE ima01=sr.qcs.qcs021
         SELECT azf03 INTO l_azf03_1 FROM azf_file WHERE azf01=l_ima109 AND azf02='8'
         SELECT azf03 INTO l_azf03_2 FROM azf_file
            WHERE azf01=sr.qct.qct04 AND azf02='6'
         #darcy:2022/12/09 add s---
         # 检测值和单身查询
         let l_qcs01 = ''
         select unique qctt01,qctt02,qctt021 into l_qcs01,l_qcs02,l_qcs05
           from qcs_file a ,qctt_file,qcs_file b
          where a.qcs01= sr.qcs.qcs01 and a.qcs02 =sr.qcs.qcs02 and a.qcs05=sr.qcs.qcs05
            and qctt01 =b.qcs01 and qctt02=b.qcs02 and qctt021 = b.qcs05
            and a.qcs03 = b.qcs03 and a.qcs04=b.qcs04 and a.qcs021=b.qcs021
         if not cl_null(l_qcs01) then
            select * into sr.qct.* from qct_file 
             where qct01 = l_qcs01 and qct02 = l_qcs02 
               and qct021 = l_qcs05 and qct03 = sr.qct.qct03
         end if
         #darcy:2022/12/09 add e---
         #darcy:2022/06/27 s---
         #测量值
         let l_cnt =1
         call l_qctt.clear()
         foreach r300_qctt_curs using sr.qct.qct01,sr.qct.qct02,sr.qct.qct021,sr.qct.qct03
          into l_qctt[l_cnt]
            if l_cnt >19 then
               exit foreach
            end if
            let l_cnt = l_cnt + 1
         end foreach
         #darcy:2022/08/11 s---
         # 测量值范围
         if not cl_null(sr.qct.qct131) or not cl_null(sr.qct.qct132) then
            if not cl_null(sr.qct.qct131) then
               let l_str=sr.qct.qct131,"~"
            else 
               let l_str ="∞~"
            end if
            if not cl_null(sr.qct.qct132) then
               let l_str =l_str,sr.qct.qct132
            else
               let l_str = l_str,"∞"
            end if 
            let l_str = cl_replace_str(l_str,".000","")
            let l_mark = cl_replace_str(l_str," ","")
         else
            let l_mark = ""   
         end if
         #darcy:2022/08/11 e---
         #darcy:2022/06/27 e---
         #darcy:2022/10/19 add s---
         # 免费样品入库的时候，品名规格抓取qcsud11/12
         if sr.qcs.qcs00 ='3' then
            select qcsud11,qcsud12 into l_ima02,l_ima021 from qcs_file
             where qcs01 = sr.qcs.qcs01 and qcs02 = sr.qcs.qcs02 and qcs05=sr.qcs.qcs05
            #darcy:2023/08/09 add s---
            if cl_null(l_mark) then
               let l_mark = sr.qct.qctud03
            end if
            #darcy:2023/08/09 add e---
         end if
         #darcy:2022/10/19 add e---
         EXECUTE insert_prep USING sr.qcs.qcs00,sr.qcs.qcs01,sr.qcs.qcs02,sr.qcs.qcs021,sr.qcs.qcs03,sr.qcs.qcs04,
                                   sr.qcs.qcs041,sr.qcs.qcs05,sr.qcs.qcs06,sr.qcs.qcs061,sr.qcs.qcs062,sr.qcs.qcs071,
                                   sr.qcs.qcs072,sr.qcs.qcs081,sr.qcs.qcs082,sr.qcs.qcs09,sr.qcs.qcs091,sr.qcs.qcs10,
                                   sr.qcs.qcs101,sr.qcs.qcs11,sr.qcs.qcs12,sr.qcs.qcs13,sr.qcs.qcs14,sr.qcs.qcs15,
                                   sr.qcs.qcs16,sr.qcs.qcs17,sr.qcs.qcs18,sr.qcs.qcs19,sr.qcs.qcs20,sr.qcs.qcs21,
                                   sr.qcs.qcs22,sr.qcs.qcsprno,sr.qcs.qcsacti,sr.qcs.qcsuser,sr.qcs.qcsgrup,sr.qcs.qcsmodu,
                                   sr.qcs.qcsdate,sr.qcs.qcs30,sr.qcs.qcs31,sr.qcs.qcs32,sr.qcs.qcs33,sr.qcs.qcs34,
                                   sr.qcs.qcs35,sr.qcs.qcs36,sr.qcs.qcs37,sr.qcs.qcs38,sr.qcs.qcs39,sr.qcs.qcs40,
                                   sr.qcs.qcs41,sr.qcs.qcsspc,sr.qct.qct01,sr.qct.qct02,sr.qct.qct021,sr.qct.qct03,
                                   sr.qct.qct04,sr.qct.qct05,sr.qct.qct06,sr.qct.qct07,sr.qct.qct08,sr.qct.qct09,
                                   sr.qct.qct10,sr.qct.qct11,sr.qct.qct12,sr.qct.qct131,sr.qct.qct132,
                                   l_gen02,l_pmc03,l_ima02,l_ima021,l_ima15,l_ima109,l_azf03_1,l_azf03_2,            #No.FUN-850062
                                   "",l_img_blob, "N",""    #TQC-C10039 ADD "",l_img_blob, "N",""
                                   ,l_qctt[1],l_qctt[2],l_qctt[3],l_qctt[4],l_qctt[5],l_qctt[6],l_qctt[7],l_qctt[8],l_qctt[9],l_qctt[10] #darcy:2022/06/27 add
         #darcy:2022/07/14 s---    
                                   ,l_mark #darcy:2022/08/11 add 
                                   ,sr.qcs.qcsud03,sr.qct.qctud02 #darcy:2022/12/07 add
         if l_cnt > 10 then
            EXECUTE insert_prep USING sr.qcs.qcs00,sr.qcs.qcs01,sr.qcs.qcs02,sr.qcs.qcs021,sr.qcs.qcs03,sr.qcs.qcs04,
                                   sr.qcs.qcs041,sr.qcs.qcs05,sr.qcs.qcs06,sr.qcs.qcs061,sr.qcs.qcs062,sr.qcs.qcs071,
                                   sr.qcs.qcs072,sr.qcs.qcs081,sr.qcs.qcs082,sr.qcs.qcs09,sr.qcs.qcs091,sr.qcs.qcs10,
                                   sr.qcs.qcs101,sr.qcs.qcs11,sr.qcs.qcs12,sr.qcs.qcs13,sr.qcs.qcs14,sr.qcs.qcs15,
                                   sr.qcs.qcs16,sr.qcs.qcs17,sr.qcs.qcs18,sr.qcs.qcs19,sr.qcs.qcs20,sr.qcs.qcs21,
                                   sr.qcs.qcs22,sr.qcs.qcsprno,sr.qcs.qcsacti,sr.qcs.qcsuser,sr.qcs.qcsgrup,sr.qcs.qcsmodu,
                                   sr.qcs.qcsdate,sr.qcs.qcs30,sr.qcs.qcs31,sr.qcs.qcs32,sr.qcs.qcs33,sr.qcs.qcs34,
                                   sr.qcs.qcs35,sr.qcs.qcs36,sr.qcs.qcs37,sr.qcs.qcs38,sr.qcs.qcs39,sr.qcs.qcs40,
                                   sr.qcs.qcs41,sr.qcs.qcsspc,sr.qct.qct01,sr.qct.qct02,sr.qct.qct021,sr.qct.qct03,
                                   sr.qct.qct04,sr.qct.qct05,sr.qct.qct06,sr.qct.qct07,"",sr.qct.qct09,
                                   sr.qct.qct10,"",sr.qct.qct12,sr.qct.qct131,sr.qct.qct132,
                                   l_gen02,l_pmc03,l_ima02,l_ima021,l_ima15,l_ima109,l_azf03_1,"",            #No.FUN-850062
                                   "",l_img_blob, "N",""    #TQC-C10039 ADD "",l_img_blob, "N",""
                                   ,l_qctt[11],l_qctt[12],l_qctt[13],l_qctt[14],l_qctt[15],l_qctt[16],l_qctt[17],l_qctt[18],l_qctt[19],l_qctt[20]
                                   ,l_mark #darcy:2022/08/11 add 
                                   ,sr.qcs.qcsud03,"" #darcy:2022/12/07 add
         end if
         #darcy:2022/07/14 e---
         DECLARE qao_cur2 CURSOR FOR SELECT qao01,qao03,qao05,qao06 FROM qao_file
                                                WHERE qao01=sr.qcs.qcs01
                                                  AND qao02=sr.qcs.qcs02
                                                  AND qao021=sr.qcs.qcs05
                                                  AND qao03=sr.qct.qct03
                                                  AND qao05='1'
         FOREACH qao_cur2 INTO l_qao01,l_qao03,l_qao05,l_qao06
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep2 USING l_qao01,l_qao03,l_qao05,l_qao06
         END FOREACH
         
         DECLARE qao_cur3 CURSOR FOR SELECT qao01,qao03,qao05,qao06 FROM qao_file
                                                WHERE qao01=sr.qcs.qcs01
                                                  AND qao02=sr.qcs.qcs02
                                                  AND qao021=sr.qcs.qcs05
                                                  AND qao03=sr.qct.qct03
                                                  AND qao05='2'
         FOREACH qao_cur3 INTO l_qao01,l_qao03,l_qao05,l_qao06
            IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
            EXECUTE insert_prep3 USING l_qao01,l_qao03,l_qao05,l_qao06
         END FOREACH
 
         DECLARE qcu_cur CURSOR FOR
            SELECT * FROM qcu_file WHERE qcu01=sr.qct.qct01
                                     AND qcu02=sr.qct.qct02
                                     AND qcu021=sr.qct.qct021
                                     AND qcu03=sr.qct.qct03
            FOREACH qcu_cur INTO l_qcu.*
                LET l_qce03 = NULL
                SELECT qce03 INTO l_qce03 FROM qce_file WHERE qce01=l_qcu.qcu04
                EXECUTE insert_prep5 USING l_qcu.qcu01,l_qcu.qcu02,l_qcu.qcu021,
                                           l_qcu.qcu03,l_qcu.qcu04,l_qcu.qcu05,
                                           l_qcu.qcuicd01,l_qcu.qcuicd02,l_qce03 
            END FOREACH
     END FOREACH
     LET l_sql = "SELECT DISTINCT qcs01,qcs02,qcs05 FROM ",
                  g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE r300_p FROM l_sql
     DECLARE r300_curs CURSOR FOR r300_p
     FOREACH r300_curs INTO sr.qcs.qcs01,sr.qcs.qcs02,sr.qcs.qcs05 
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        DECLARE qao_cur1 CURSOR FOR SELECT qao01,qao03,qao05,qao06 FROM qao_file
                                               WHERE qao01=sr.qcs.qcs01
                                                 AND qao02=sr.qcs.qcs02
                                                 AND qao021=sr.qcs.qcs05
                                                 AND qao03='0'
                                                 AND qao05='1'
        FOREACH qao_cur1 INTO l_qao01,l_qao03,l_qao05,l_qao06
           IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
           EXECUTE insert_prep1 USING l_qao01,'',l_qao05,l_qao06
        END FOREACH
        
        DECLARE qao_cur4 CURSOR FOR SELECT qao01,qao03,qao05,qao06 FROM qao_file
                                               WHERE qao01=sr.qcs.qcs01
                                                 AND qao02=sr.qcs.qcs02
                                                 AND qao021=sr.qcs.qcs05
                                                 AND qao03='0'
                                                 AND qao05='2'
        FOREACH qao_cur4 INTO l_qao01,l_qao03,l_qao05,l_qao06
           IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
           EXECUTE insert_prep4 USING l_qao01,'',l_qao05,l_qao06
        END FOREACH
     END FOREACH
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'qcs01,qcs021,qcs03,qcs13')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05,";",g_argv1,";",g_sma.sma115
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table  CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",   
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED
     LET g_cr_table = l_table                 #主報表的temp table名稱  #TQC-C10039
     LET g_cr_apr_key_f = "qcs01|qcs02|qcs05"       #報表主鍵欄位名稱  #TQC-C10039
     CALL cl_prt_cs3('aqcr300','aqcr300',l_sql,g_str)
 
END FUNCTION
 
#依據不同傳參Default Form 初值
FUNCTION r300_form_default()
   DEFINE l_items       LIKE ze_file.ze03       #No.FUN-680104 VARCHAR(100)
 
   LET l_items = NULL
   IF g_argv1 = "2" THEN      #倉庫QC
      LET l_items = NULL
      LET l_items = cl_getmsg('lib-258',g_lang)
      CALL cl_set_comp_att_text("qcs01",l_items CLIPPED)
   END IF
   IF g_argv1 = "3" THEN      #OQC
      LET l_items = NULL
      LET l_items = cl_getmsg('axr-501',g_lang)
      LET l_items = l_items CLIPPED,',',cl_getmsg('sub-115',g_lang)
      CALL cl_set_comp_att_text("qcs01,qcs03",l_items CLIPPED)
   END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
