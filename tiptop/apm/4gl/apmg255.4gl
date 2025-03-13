# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: apmg255.4gl
# Descriptions...: 採購核價單列印
# Date & Author..: 97/08/22  By  Kitty
#        Modify  : #No:7624 03/07/17 By Mandy 加印作業編號
# Modify.........: No.FUN-550019 05/04/27 By Danny 採購含稅單價
# Modify.........: No.FUN-550060  05/05/31 By yoyo單據編號格式放大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.FUN-580013 05/08/12 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-5A0005 05/10/05 BY yiting 核價報表中: 新單價印在數量欄位上..( 若為分量計價則無此問題 )
# Modify.........: No.FUN-5A0139 05/10/21 By Pengu 調整報表的格式
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 報表名稱與製表日期對調
# Modify.........: No.FUN-610018 06/01/17 By ice 採購含稅單價功能調整
# Modify.........: No.TQC-610085 06/04/04 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-640048 06/04/08 By Echo 採購核價單無列印「規格 」欄位
# Modify.........: No.MOD-640096 06/04/09 By Mandy 分量計價為'Y'時,新核准日(pmj09)未印出
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.TQC-6B0095 06/11/16 By Ray 報表格式調整
# Modify.........: No.FUN-710091 07/01/14 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740084 07/04/20 By Rayven 無勾選使用分量計價功能，應該也要能被印出來
# Modify.........: No.TQC-740181 07/04/22 By Claire 少傳 pmr01,pmr02
# Modify.........: No.TQC-790123 07/04/22 By Claire 調整FUN-740084語法
# Modify.........: No.MOD-840066 08/04/09 By Dido 增加 gec011 條件
# Modify.........: No.MOD-870026 08/07/02 By Smapmin 抓取azi03
# Modify.........: No.MOD-980207 09/08/26 By Dido OUTER 語法調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:MOD-A60085 10/06/12 By Carrier 主报表和子报表连接SQL错误
# Modify.........: No.CHI-A90030 10/10/01 By Summer 增加採購單位的顯示
# Modify.........: No.FUN-B40092 11/05/25 By xujing 憑證報表轉GRW
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B40092 11/08/17 By xujing 程式規範修改
# Modify.........: No.FUN-C40019 12/04/10 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片 
# Modify.........: No.FUN-C50003 12/05/14 By yangtt GR程式優化
# Modify.........: No.FUN-C50140 12/06/12 By nanbing GR修改
# Modify.........: NO.FUN-CB0058 12/11/30 By yangtt 4rp中的visibility condition在4gl中實現，達到單身無定位點
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)  # Where condition
              a       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)    # 選擇(1)已列印 (2)未列印 (3)全部
              more    LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
#FUN-710091  --begin
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE l_table1   STRING
#FUN-710091  --end
###GENGRE###START
TYPE sr1_t RECORD
    pmi01 LIKE pmi_file.pmi01,
    pmi02 LIKE pmi_file.pmi02,
    pmi03 LIKE pmi_file.pmi03,
    pmi05 LIKE pmi_file.pmi05,
    pmc03 LIKE pmc_file.pmc03,
    pmi04 LIKE pmi_file.pmi04,
    pmj02 LIKE pmj_file.pmj02,
    pmj03 LIKE pmj_file.pmj03,
    pmj031 LIKE pmj_file.pmj031,
    pmj032 LIKE pmj_file.pmj032,
    pmj04 LIKE pmj_file.pmj04,
    ima44 LIKE ima_file.ima44,
    ima908 LIKE ima_file.ima908,
    pmj05 LIKE pmj_file.pmj05,
    pmj06 LIKE pmj_file.pmj06,
    pmj07 LIKE pmj_file.pmj07,
    pmj08 LIKE pmj_file.pmj08,
    pmj09 LIKE pmj_file.pmj09,
    pmj10 LIKE pmj_file.pmj10,
    pmi08 LIKE pmi_file.pmi08,
    pmi081 LIKE pmi_file.pmi081,
    pmj06t LIKE pmj_file.pmj06t,
    pmj07t LIKE pmj_file.pmj07t,
    gec07 LIKE gec_file.gec07,
    azi03 LIKE azi_file.azi03,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD

TYPE sr2_t RECORD
    pmr01 LIKE pmr_file.pmr01,
    pmr02 LIKE pmr_file.pmr02,
    pmr03 LIKE pmr_file.pmr03,
    pmr04 LIKE pmr_file.pmr04,
    pmr05 LIKE pmr_file.pmr05,
    pmr05t LIKE pmr_file.pmr05t
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
#------------------No.TQC-610085 modify
  #LET tm.more  = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------------No.TQC-610085 end
   #NO.FUN-710091   --begin
   LET g_sql="pmi01.pmi_file.pmi01,",
             "pmi02.pmi_file.pmi02,",
             "pmi03.pmi_file.pmi03,",
             "pmi05.pmi_file.pmi05,",
             "pmc03.pmc_file.pmc03,",
             "pmi04.pmi_file.pmi04,",
             "pmj02.pmj_file.pmj02,",
             "pmj03.pmj_file.pmj03,",
             "pmj031.pmj_file.pmj031,",
             "pmj032.pmj_file.pmj032,",
             "pmj04.pmj_file.pmj04,",
             "ima44.ima_file.ima44,",   #CHI-A90030 add
             "ima908.ima_file.ima908,", #CHI-A90030 add
             "pmj05.pmj_file.pmj05,",
             "pmj06.pmj_file.pmj06,",
             "pmj07.pmj_file.pmj07,",
             "pmj08.pmj_file.pmj08,",
             "pmj09.pmj_file.pmj09,",
             "pmj10.pmj_file.pmj10,",
             "pmi08.pmi_file.pmi08,",
             "pmi081.pmi_file.pmi081,",
             "pmj06t.pmj_file.pmj06t,",
             "pmj07t.pmj_file.pmj07t,",
             "gec07.gec_file.gec07,",
             "azi03.azi_file.azi03,",
             "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
             "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
             "sign_show.type_file.chr1,",                       #FUN-C40019 add
             "sign_str.type_file.chr1000"                       #FUN-C40019 add
   LET l_table = cl_prt_temptable('apmg255',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time #FUN-B40092
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
      EXIT PROGRAM 
   END IF
         
   LET g_sql= "pmr01.pmr_file.pmr01,",
              "pmr02.pmr_file.pmr02,", 
              "pmr03.pmr_file.pmr03,",
              "pmr04.pmr_file.pmr04,",
              "pmr05.pmr_file.pmr05,",
              "pmr05t.pmr_file.pmr05t"
   LET l_table1 = cl_prt_temptable('apmg2551',g_sql) CLIPPED
   IF  l_table1 = -1 THEN 
       CALL cl_used(g_prog, g_time,2) RETURNING g_time #FUN-B40092
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
       EXIT PROGRAM 
   END IF
   #NO.FUN-710091   --end
         
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g255_tm(0,0)        # Input print condition
      ELSE CALL g255()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
END MAIN
 
FUNCTION g255_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000      #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW g255_w AT p_row,p_col WITH FORM "apm/42f/apmg255"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmi01,pmi02,pmi03
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
      LET INT_FLAG = 0 CLOSE WINDOW g255_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.a, tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]'  OR cl_null(tm.a) THEN
            NEXT FIELD a
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW g255_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmg255'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmg255','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmg255',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g255_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g255()
   ERROR ""
END WHILE
   CLOSE WINDOW g255_w
END FUNCTION
 
FUNCTION g255()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                 #No.FUN-680136 VARCHAR(1000)
          l_za05    LIKE za_file.za05,            #No.FUN-680136 VARCHAR(40)
          sr               RECORD pmi01 LIKE pmi_file.pmi01,
                                  pmi02 LIKE pmi_file.pmi02,
                                  pmi03 LIKE pmi_file.pmi03,
                                  pmi05 LIKE pmi_file.pmi05,   #NO:7178 分量計價
                                  pmc03 LIKE pmc_file.pmc03,
                                  pmi04 LIKE pmi_file.pmi04,
                                  pmj02 LIKE pmj_file.pmj02,
                                  pmj03 LIKE pmj_file.pmj03,
                                  pmj031 LIKE pmj_file.pmj031,
                                  pmj032 LIKE pmj_file.pmj032, #MOD-640048
                                  pmj04 LIKE pmj_file.pmj04,
                                  ima44 LIKE ima_file.ima44,   #CHI-A90030 add
                                  ima908 LIKE ima_file.ima908, #CHI-A90030 add
                                  pmj05 LIKE pmj_file.pmj05,
                                  pmj06 LIKE pmj_file.pmj06,
                                  pmj07 LIKE pmj_file.pmj07,
                                  pmj08 LIKE pmj_file.pmj08,
                                  pmj09 LIKE pmj_file.pmj09,
                                  pmj10 LIKE pmj_file.pmj10,    #No:7624
                                  #No.FUN-550019
                                  pmi08       LIKE pmi_file.pmi08,   #稅別
                                  pmi081      LIKE pmi_file.pmi081,  #稅率
                                  pmj06t      LIKE pmj_file.pmj06t,  #原含稅單價
                                  pmj07t      LIKE pmj_file.pmj07t,  #新含稅單價
                                  gec07       LIKE gec_file.gec07    #含稅否
                                  #end No.FUN-550019
                        END RECORD
     DEFINE            g_str      STRING
     DEFINE            l_pmr      RECORD LIKE pmr_file.*  
     DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add

     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmg255'
     #No.FUN-710091  --begin
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
#    LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED, " values",   #No.FUN-740084 mark
#     LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED, " values",   #No.FUN-740084
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, " values",  #TQC-A50009 mod 
                 "(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  #CHI-A90030 add ?,?   #FUN-C40019 add 4?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
        EXIT PROGRAM
     END IF
#    LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED," values(?,?,?,?,?,?)"   #No.FUN-740084 mark
#     LET g_sql = "INSERT INTO ds_report.",l_table1 CLIPPED," values(?,?,?,?,?,?)"   #No.FUN-740084
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED," values(?,?,?,?,?,?)"   #TQC-A50009
     PREPARE insert1 FROM g_sql
     IF STATUS THEN
        CALL cl_err("insert1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80088--add--
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1) #FUN-B40092
        EXIT PROGRAM
     END IF
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmiuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmigrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmigrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmiuser', 'pmigrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ",
                 " pmi01,pmi02,pmi03,pmi05,pmc03,pmi04,pmj02,pmj03,pmj031,pmj032,", #NO:7178   #MOD-640048
                 " pmj04,ima44,ima908,pmj05,pmj06,pmj07,pmj08,pmj09,pmj10,", #No:7624  #CHI-A90030 add ima44,ima908 
                 #No.FUN-550019
                 " pmi08,pmi081,pmj06t,pmj07t,gec07 ",
               # " FROM pmi_file, pmj_file,OUTER pmc_file,OUTER gec_file ",
               # " WHERE pmi01 = pmj01 AND pmi03=pmc01",
               # "   AND pmi08 = gec_file.gec01 AND ",tm.wc clipped
               #FUN-C50003----mark---str---
               # " FROM pmi_file, pmj_file,OUTER pmc_file,OUTER gec_file,OUTER ima_file ", #CHI-A90030 add ima_file
               # " WHERE pmi01 = pmj01 AND pmi03=pmc_file.pmc01 AND pmi08=gec_file.gec01 AND '1' = gec_file.gec011 ", #MOD-840066	#MOD-980207 
               # "   AND pmj03 = ima_file.ima01 ", #CHI-A90030 add
               #FUN-C50003----mark---end---
               #FUN-C50003-----add----str---
                 " FROM pmi_file LEFT OUTER JOIN pmc_file ON pmi03=pmc01 ",
                 "               LEFT OUTER JOIN gec_file ON pmi08=gec01 AND '1'=gec011 ,",
                 "      pmj_file LEFT OUTER JOIN ima_file ON pmj03=ima01",
                 " WHERE pmi01=pmj01",
               #FUN-C50003-----add----end---
                 "   AND ",tm.wc clipped
                 #end No.FUN-550019
     CASE WHEN tm.a ='1' LET l_sql = l_sql CLIPPED, " AND pmiconf ='Y' "
          WHEN tm.a ='2' LET l_sql = l_sql CLIPPED, " AND pmiconf ='N' "
          WHEN tm.a ='3' LET l_sql = l_sql CLIPPED, " AND pmiconf !='X'"
          OTHERWISE EXIT CASE
     END CASE
     PREPARE g255_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM
     END IF
     DECLARE g255_curs1 CURSOR FOR g255_prepare1

     #FUN-C50003-----add----str---
         DECLARE pmr_curs CURSOR FOR
           SELECT *
             FROM pmr_file
            WHERE pmr01 = ? 
              AND pmr02 = ? 
            ORDER BY pmr03
     #FUN-C50003-----add----end---
 
   # CALL cl_outnam('apmg255') RETURNING l_name
   # START REPORT g255_rep TO l_name
   # LET g_pageno = 0
     FOREACH g255_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
      IF sr.pmi05 = 'Y' THEN #分量計價
     #FUN-C50003-----mark---str---
     #   DECLARE pmr_curs CURSOR FOR
     #     SELECT *
     #       FROM pmr_file
     #      WHERE pmr01 = sr.pmi01
     #        AND pmr02 = sr.pmj02
     #      ORDER BY pmr03
     #FUN-C50003-----mark---end---
         #No.FUN-710091  --begin
         FOREACH pmr_curs USING sr.pmi01,sr.pmj02 INTO l_pmr.*   #FUN-C500003 add USING sr.pmi01,sr.pmj02
            EXECUTE insert1 USING l_pmr.pmr01,l_pmr.pmr02,l_pmr.pmr03,l_pmr.pmr04,l_pmr.pmr05,l_pmr.pmr05t
         END FOREACH
      END IF
         #No.FUN-710091  --end
#No.FUN-610018
#         #No.FUN-550019
#         IF sr.gec07 = 'Y' THEN      #No.FUN-560102
#            LET sr.pmj06 = sr.pmj06t
#            LET sr.pmj07 = sr.pmj07t
#         END IF
#         #end No.FUN-550019
#         OUTPUT TO REPORT g255_rep(sr.*)    #No.FUN-710091 mark
          SELECT azi03 INTO t_azi03 FROM azi_file   #MOD-870026
             WHERE azi01 = sr.pmj05   #MOD-870026
          EXECUTE insert_prep USING sr.*,t_azi03,   #No.FUN-710091 add
                                    "",l_img_blob,"N",""    #FUN-C40019 add
     END FOREACH
     #No.FUN-710091 --begin
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'apmg255'
     CALL cl_wcchp(tm.wc,'pmi01,pmi02,pmi03')                                                   RETURNING tm.wc 
###GENGRE###     LET g_str =tm.wc,";",g_sma.sma116 #CHI-A90030 add sma116
     #No.MOD-A60085  --Begin
###GENGRE###     LET l_sql =" SELECT A.*,B.pmr01,B.pmr02,B.pmr03,B.pmr04,B.pmr05,B.pmr05t",  #TQC-740181 add pmr01,pmr02
###GENGRE###                " FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON A.pmi01=B.pmr01 AND A.pmj02 = B.pmr02"   #No.FUN-740084  #TQC-790123 modify
     #          " WHERE A.pmi01 = B.pmr01",
     #          "   AND A.pmj02 = B.pmr02"
     #No.MOD-A60085  --End  
   # CALL cl_prt_cs3('apmg255',l_sql,g_str)  #TQC-730088
###GENGRE###     CALL cl_prt_cs3('apmg255','apmg255',l_sql,g_str)

    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "pmi01"               #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
    CALL apmg255_grdata()    ###GENGRE###
 
#    FINISH REPORT g255_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-710091  --end
END FUNCTION
#No.FUN-710091  --begin
#REPORT g255_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
#          l_str        LIKE type_file.chr8,          #No.FUN-680136 VARCHAR(8)
#          l_str1       LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(100)
#          sr               RECORD pmi01 LIKE pmi_file.pmi01,
#                                  pmi02 LIKE pmi_file.pmi02,
#                                  pmi03 LIKE pmi_file.pmi03,
#                                  pmi05 LIKE pmi_file.pmi05,   #NO:7178 分量計價
#                                  pmc03 LIKE pmc_file.pmc03,
#                                  pmi04 LIKE pmi_file.pmi04,
#                                  pmj02 LIKE pmj_file.pmj02,
#                                  pmj03 LIKE pmj_file.pmj03,
#                                  pmj031 LIKE pmj_file.pmj031,
#                                  pmj032 LIKE pmj_file.pmj032,  #MOD-640048
#                                  pmj04 LIKE pmj_file.pmj04,
#                                  pmj05 LIKE pmj_file.pmj05,
#                                  pmj06 LIKE pmj_file.pmj06,
#                                  pmj07 LIKE pmj_file.pmj07,
#                                  pmj08 LIKE pmj_file.pmj08,
#                                  pmj09 LIKE pmj_file.pmj09,
#                                  pmj10 LIKE pmj_file.pmj10,    #No:7624
#                                  #No.FUN-550019
#                                  pmi08       LIKE pmi_file.pmi08,   #稅別
#                                  pmi081      LIKE pmi_file.pmi081,  #稅率
#                                  pmj06t      LIKE pmj_file.pmj06t,  #原含稅單價
#                                  pmj07t      LIKE pmj_file.pmj07t,  #新含稅單價
#                                  gec07       LIKE gec_file.gec07    #含稅否
#                                  #end No.FUN-550019
#                        END RECORD,
#      l_hh          LIKE ima_file.ima01,      #No.FUN-680136 VARCHAR(40)
#      l_cnt         LIKE type_file.num5,      #No.FUN-680136 SMALLINT
#      l_pmr         RECORD LIKE pmr_file.*    #NO:7178 分量計價資料
#
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.pmi01,sr.pmj02
#
#  FORMAT
#   PAGE HEADER
##No.FUN-580013--start
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      #PRINT g_head CLIPPED,pageno_total     #TQC-5B0037 mark
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total      #TQC-5B0037 add
##No.FUN-580013--end
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN 1,  g_x[11] CLIPPED , sr.pmi01,               #單號
##No.FUN-550060 --start--
#            COLUMN 27, g_x[13] CLIPPED , sr.pmi03 CLIPPED,' ',
#            COLUMN 51,g_x[14] CLIPPED,sr.pmc03 CLIPPED;                  #廠商
#      #No.FUN-550019
#      #No.FUN-610018 --start--
#      PRINT COLUMN 72,g_x[27] CLIPPED,sr.pmi08,                  #稅別
#            COLUMN 91,g_x[28] CLIPPED,sr.pmi081 USING '##&','%'  #稅率
##           COLUMN 87,g_x[29] CLIPPED,sr.gec07                   #含稅
#      #end No.FUN-550019
#     PRINT COLUMN 1,  g_x[12] CLIPPED , sr.pmi02,               #日期
#           COLUMN 27, g_x[15] CLIPPED , sr.pmi04 CLIPPED
#      PRINT g_dash2[1,g_len]
##No.FUN-580013--start
##----No.FUN-5A0139 begin
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33]
#      PRINTX name=H2 g_x[34],g_x[35],g_x[47]
#      PRINTX name=H3 g_x[36],g_x[37],g_x[39],g_x[48],g_x[40]          #No.FUN-610018 #MOD-640048
#      PRINTX name=H4 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[49],g_x[46]  #No.FUN-610018
##----No.FUN-5A0139 end
#      PRINT g_dash1
##No.FUN-580013--end
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.pmi01   #單號
#      SKIP TO TOP OF PAGE
#
#   ON EVERY ROW
#    SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05   #No.CHI-6A0004
#           FROM azi_file WHERE azi01=sr.pmj05
##No.FUN-580013--start
##--------No.FUN-5A0139 begin
#      PRINTX name=D1
#            COLUMN g_c[31],sr.pmj02 USING '#####',
#            COLUMN g_c[32],sr.pmj03,
#            COLUMN g_c[33],sr.pmj04     #No:7624
#      PRINTX name=D2
#            COLUMN g_c[35],sr.pmj031 CLIPPED,
#            COLUMN g_c[47],sr.pmj10 CLIPPED  #No:7624
#      PRINTX name=D3
#           #COLUMN g_c[37],sr.pmj05  CLIPPED,
#            COLUMN g_c[37],sr.pmj032 CLIPPED,       #MOD-640048
#            COLUMN g_c[39],cl_numfor(sr.pmj06,39,t_azi03) CLIPPED,    #No.CHI-6A0004
#            COLUMN g_c[48],cl_numfor(sr.pmj06t,48,t_azi03) CLIPPED,  #No.FUN-610018   #No.CHI-6A0004
#            COLUMN g_c[40],sr.pmj08
#      #NO:7178
#      IF sr.pmi05 != 'Y' THEN 
#         PRINTX name=D4
#               COLUMN g_c[42],sr.pmj05  CLIPPED,                     #MOD-640048
#               COLUMN g_c[45],cl_numfor(sr.pmj07,45,t_azi03) CLIPPED,   #No.CHI-6A0004
#               COLUMN g_c[49],cl_numfor(sr.pmj07t,49,t_azi03) CLIPPED,  #No.FUN-610018   #No.CHI-6A0004
#               COLUMN g_c[46],sr.pmj09
#      END IF
#
#      IF sr.pmi05 = 'Y' THEN #分量計價
#         DECLARE pmr_curs CURSOR FOR
#           SELECT *
#             FROM pmr_file
#            WHERE pmr01 = sr.pmi01
#              AND pmr02 = sr.pmj02
#            ORDER BY pmr03
#         LET g_cnt = 1
#         FOREACH pmr_curs INTO l_pmr.*
#         LET l_str1 = l_pmr.pmr03 USING '------&.&&' CLIPPED,'-',
#                     l_pmr.pmr04 USING '------&.&&' CLIPPED
#             #MOD-640096----------add
#             IF g_cnt = '1' THEN 
#                 PRINTX name=D4
#                       COLUMN g_c[42],sr.pmj05  CLIPPED,#幣別
#                       COLUMN g_c[44],l_str1 CLIPPED,
#                       COLUMN g_c[45],cl_numfor(l_pmr.pmr05,45,t_azi03) CLIPPED,  #No.CHI-6A0004
#                       COLUMN g_c[49],cl_numfor(l_pmr.pmr05t,49,t_azi03) CLIPPED, #No.FUN-610018  #No.CHI-6A0004
#                       COLUMN g_c[46],sr.pmj09 #新核准日
#             ELSE
#                 PRINTX name=D4
#                       COLUMN g_c[42],'',
#                       COLUMN g_c[44],l_str1 CLIPPED,
#                       COLUMN g_c[45],cl_numfor(l_pmr.pmr05,45,t_azi03) CLIPPED,   #No.CHI-6A0004
#                       COLUMN g_c[49],cl_numfor(l_pmr.pmr05t,49,t_azi03) CLIPPED, #No.FUN-610018   #No.CHI-6A0004
#                       COLUMN g_c[46],''
#             END IF
#             #MOD-640096----------end
#             LET g_cnt = 0
#             LET l_str1= ' '
#         END FOREACH
#         PRINT
#      END IF
#
##No.FUN-580013--end
#
##No.FUN-550060 --end--
##     IF sr.pmi05 != 'Y' THEN
##         PRINT COLUMN 59,cl_numfor(sr.pmj07,15,t_azi03) CLIPPED; #No:7624   #No.CHI-6A0004
##         #PRINT COLUMN g_c[42],cl_numfor(sr.pmj07,42,g_azi03) CLIPPED; #No.FUN-580013
##         PRINT COLUMN g_c[43],cl_numfor(sr.pmj07,36,g_azi03) CLIPPED; #No.MOD-5A0005
##     END IF
##     PRINT COLUMN 76,sr.pmj09 #No:7624
##     PRINT COLUMN g_c[44],sr.pmj09 #No.FUN-580013
##     PRINTX name=D3
##           COLUMN g_c[46],sr.pmj031 CLIPPED
##     IF sr.pmi05 = 'Y' THEN #分量計價
##        DECLARE pmr_curs CURSOR FOR
##          SELECT *
##            FROM pmr_file
##           WHERE pmr01 = sr.pmi01
##             AND pmr02 = sr.pmj02
##           ORDER BY pmr03
##        LET g_cnt = 1
##        FOREACH pmr_curs INTO l_pmr.*
##            #No.FUN-550019
##            IF sr.gec07 = 'Y' THEN           #No.FUN-560102
##               LET l_pmr.pmr05 = l_pmr.pmr05t
##            END IF
##            #end No.FUN-550019
##No.FUN-580013--start
##            PRINTX name=D2
##                  COLUMN g_c[42],l_pmr.pmr03 USING '------&.&&' CLIPPED,'-',l_pmr.pmr04 USING '------&.&&' CLIPPED,
##                  COLUMN g_c[43],cl_numfor(l_pmr.pmr05,43,g_azi03) CLIPPED #No:7624
##NO.FUN-580013--end
##            LET g_cnt = 0
##        END FOREACH
##        PRINT
##     END IF
##--------No.FUN-5A0139 end
#   ON LAST ROW
#      LET l_last_sw = 'y'
#      PRINT g_dash[1,g_len]    #No.TQC-6B0095
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9), g_x[7] CLIPPED    #No.TQC-6B0095
#
#   PAGE TRAILER
### FUN-550114
#      IF l_last_sw = 'n' THEN
#       #  PRINT g_x[26]
#         PRINT g_dash[1,g_len]    #No.TQC-6B0095
#         PRINT g_x[4] clipped,g_x[5] CLIPPED,COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#       #  PRINT g_x[26]
#         SKIP 2 LINE    #No.TQC-6B0095
#      END IF
#     PRINT ''
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[26]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[26]
#            PRINT g_memo
#     END IF
### END FUN-550114
#      LET l_last_sw = 'n'
#END REPORT
#No.FUN-710091  --end
#Patch....NO.TQC-610036 <002> #

###GENGRE###START
FUNCTION apmg255_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE sr2      sr2_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("apmg255")
        IF handler IS NOT NULL THEN
            START REPORT apmg255_rep TO XML HANDLER handler
#           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
#                       " ORDER BY pmi01,pmj02"

            LET l_sql =" SELECT A.*,B.pmr01,B.pmr02,B.pmr03,B.pmr04,B.pmr05,B.pmr05t",
                       " FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
                        g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON A.pmi01=B.pmr01 AND A.pmj02 = B.pmr02",
                       " ORDER BY pmi01,pmj02,pmr03"
          
            DECLARE apmg255_datacur1 CURSOR FROM l_sql
            FOREACH apmg255_datacur1 INTO sr1.*,sr2.*
                OUTPUT TO REPORT apmg255_rep(sr1.*,sr2.*)
            END FOREACH
            FINISH REPORT apmg255_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT apmg255_rep(sr1,sr2)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40092------add------str
    DEFINE l_sql STRING
    DEFINE l_display1 LIKE type_file.chr1
    DEFINE l_display2 LIKE type_file.chr1
    DEFINE l_pmr05_fmt      STRING
    DEFINE l_pmj06_fmt      STRING
    DEFINE l_pmj07_fmt      STRING
    DEFINE l_pmr05t_fmt     STRING
    DEFINE l_pmj06t_fmt     STRING
    DEFINE l_pmj07t_fmt     STRING
    DEFINE l_display        STRING
    #FUN-B40092------add------end
    DEFINE l_ima908         STRING #FUN-C50140 add
    DEFINE l_ima908_1   LIKE ima_file.ima908   #FUN-CB0058
    DEFINE sr1_o    sr1_t    #FUN-CB0058
    DEFINE l_pmj031    LIKE pmj_file.pmj031    #FUN-CB0058
    DEFINE l_pmj032    LIKE pmj_file.pmj032    #FUN-CB0058
    DEFINE l_pmj09     LIKE pmj_file.pmj09     #FUN-CB0058
    
    ORDER EXTERNAL BY sr1.pmi01,sr1.pmj02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.pmi01
            LET l_lineno = 0
            LET sr1_o.pmj031 = NULL  #FUN-CB0058
            LET sr1_o.pmj032 = NULL  #FUN-CB0058
            LET sr1_o.ima908 = NULL  #FUN-CB0058
            LET sr1_o.pmj09  = NULL  #FUN-CB0058
        BEFORE GROUP OF sr1.pmj02

        
        ON EVERY ROW
            #FUN-B40092------add------str
            IF g_sma.sma116 = '0' OR g_sma.sma116 = '2' THEN
               LET l_display = "N"
               LET l_ima908_1 = " "   #FUN-CB0058
            ELSE 
               LET l_display = "Y"
               IF NOT cl_null(sr1.ima908) THEN #FUN-CB0058
                  IF sr1.ima908 = sr1_o.ima908  THEN    #FUN-CB0058 add
                     LET l_ima908_1 = " "     #FUN-CB0058
                  ELSE     #FUN-CB0058 add
                     LET l_ima908_1 = sr1.ima908   #FUN-CB0058
                  END IF    #FUN-CB0058
               ELSE
                  LET l_ima908_1 = sr1.ima908   #FUN-CB0058
               END IF   #FUN-CB0058 add
            END IF
            PRINTX l_display 
            PRINTX l_ima908_1      #FUN-CB0058 
 
            #FUN-CB0058---add---str--
            IF NOT cl_null(sr1.pmj031) THEN 
               IF sr1.pmj031 = sr1_o.pmj031 THEN 
                  LET l_pmj031 = " "   
               ELSE    
                  LET l_pmj031 = sr1.pmj031  
               END IF  
            ELSE
               LET l_pmj031 = sr1.pmj031 
            END IF 
            PRINTX l_pmj031 
  
            IF NOT cl_null(sr1.pmj032) THEN  
               IF sr1.pmj032 = sr1_o.pmj032 THEN       
                  LET l_pmj032 = " "        
               ELSE     
                  LET l_pmj032 = sr1.pmj032       
               END IF    
            ELSE
               LET l_pmj032 = sr1.pmj032       
            END IF   
            PRINTX l_pmj032

            IF NOT cl_null(sr1.pmj09) THEN
               IF sr1.pmj09 = sr1_o.pmj09 THEN
                  LET l_pmj09 = " "
               ELSE
                  LET l_pmj09 = sr1.pmj09
               END IF
            ELSE
               LET l_pmj09 = sr1.pmj09
            END IF
            PRINTX l_pmj09
            #FUN-CB0058---add---end--

            #FUN-C50140 sta
            LET l_ima908 = cl_gr_getmsg('gre-269',g_lang,l_display)
            PRINTX l_ima908
            #FUN-C50140 end
            LET l_pmr05_fmt = cl_gr_numfmt('pmr_file','pmr05',sr1.azi03)
            PRINTX l_pmr05_fmt
     
            LET l_pmj06_fmt = cl_gr_numfmt('pmj_file','pmj06',sr1.azi03)
            PRINTX l_pmj06_fmt

            LET l_pmj07_fmt = cl_gr_numfmt('pmj_file','pmj07',sr1.azi03)
            PRINTX l_pmj07_fmt

            LET l_pmr05t_fmt = cl_gr_numfmt('pmr_file','pmr05t',sr1.azi03)
            PRINTX l_pmr05t_fmt

            LET l_pmj06t_fmt = cl_gr_numfmt('pmj_file','pmj06t',sr1.azi03)
            PRINTX l_pmj06t_fmt

            LET l_pmj07t_fmt = cl_gr_numfmt('pmj_file','pmj07t',sr1.azi03)
            PRINTX l_pmj07t_fmt

            IF sr1.pmi05 = 'Y' AND  cl_null(sr1.pmj032) THEN
               LET l_display1 = 'Y'
            ELSE
               LET l_display1 = 'N'
            END IF 
            IF sr1.pmi05 = 'Y' AND  NOT cl_null(sr1.pmj032) THEN
               LET l_display2 = 'Y'
            ELSE 
               LET l_display2 = 'N'
            END IF
            PRINTX l_display1
            PRINTX l_display2
             
            #FUN-B40092------add------end
            LET sr1_o.* = sr1.*    #FUN-CB0058
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
                                   
            PRINTX sr2.*
            PRINTX sr1.*

        AFTER GROUP OF sr1.pmi01
        AFTER GROUP OF sr1.pmj02

        
        ON LAST ROW

END REPORT
###GENGRE###END
