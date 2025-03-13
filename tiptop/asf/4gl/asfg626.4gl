# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfg626.4gl
# Descriptions...: 工單完工/入庫/入庫退回單據列印
# Date & Author..: 98/06/11  By  Star
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: NO.FUN-550067 05/05/31 By day     單據編號加大
# Modify.........: No.FUN-550124 05/05/30 By echo    新增報表備註
# Modify.........: No.FUN-580005 05/08/03 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: NO.FUN-5B0015 05/11/01 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660134 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.MOD-6C0128 06/12/29 By pengu OUTER段SQL語法未轉換
# Modify.........: No.TQC-710012 07/01/19 By day ora文檔修改ksccont->kscconf
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.CHI-950036 09/07/17 By jan CR報表'FQC單號'位置調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50018 11/06/01 By xumm CR轉GRW
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/05/10 By yangtt GR程式優化
# Modify.........: No.FUN-C30085 12/07/02 By nanbing GR修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5          #No.FUN-680121 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
   DEFINE tm  RECORD                   # Print condition RECORD
#             wc      VARCHAR(800),       # Where condition    #TQAC-630166
              wc      STRING,          # Where condition    #TQAC-630166
              more    LIKE type_file.chr1                   # Prog. Version..: '5.30.06-13.03.12(01)# Input more condition(Y/N)
              END RECORD,
          g_ksc00 LIKE ksc_file.ksc00,
          g_program      LIKE apm_file.apm01                #No.FUN-680121 VARCHAR(10)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-580005 --start--
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580005 --end--
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_str      STRING   
#No.FUN-710082--end  
 
###GENGRE###START
TYPE sr1_t RECORD
    ksc00 LIKE ksc_file.ksc00,
    ksc01 LIKE ksc_file.ksc01,
    ksc02 LIKE ksc_file.ksc02,
    ksd17 LIKE ksd_file.ksd17,
    ksc04 LIKE ksc_file.ksc04,
    gem02 LIKE gem_file.gem02,
    ksc05 LIKE ksc_file.ksc05,
    azf03 LIKE azf_file.azf03,
    ksc06 LIKE ksc_file.ksc06,
    ksc07 LIKE ksc_file.ksc07,
    ksd03 LIKE ksd_file.ksd03,
    ksd11 LIKE ksd_file.ksd11,
    ksd04 LIKE ksd_file.ksd04,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    ksd14 LIKE ksd_file.ksd14,
    ksd15 LIKE ksd_file.ksd15,
    ksd08 LIKE ksd_file.ksd08,
    ksd05 LIKE ksd_file.ksd05,
    ksd06 LIKE ksd_file.ksd06,
    ksd07 LIKE ksd_file.ksd07,
    ksd09 LIKE ksd_file.ksd09,
    ksd13 LIKE ksd_file.ksd13,
    ksd12 LIKE ksd_file.ksd12,
    str LIKE type_file.chr1000,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
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
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
 
   LET g_ksc00 = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm2.s3   = '3'
 
   #No.FUN-710082--begin
   LET g_sql ="ksc00.ksc_file.ksc00,",
              "ksc01.ksc_file.ksc01,",
              "ksc02.ksc_file.ksc02,",
             #"ksc03.ksc_file.ksc03,",   #CHI-950036
              "ksd17.ksd_file.ksd17,",   #CHI-950036
              "ksc04.ksc_file.ksc04,",
              "gem02.gem_file.gem02,",
              "ksc05.ksc_file.ksc05,",
              "azf03.azf_file.azf03,",
              "ksc06.ksc_file.ksc06,",
              "ksc07.ksc_file.ksc07,",
              "ksd03.ksd_file.ksd03,",
              "ksd11.ksd_file.ksd11,",
              "ksd04.ksd_file.ksd04,",
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ksd14.ksd_file.ksd14,",
              "ksd15.ksd_file.ksd15,",
              "ksd08.ksd_file.ksd08,",
              "ksd05.ksd_file.ksd05,",
              "ksd06.ksd_file.ksd06,",
              "ksd07.ksd_file.ksd07,",
              "ksd09.ksd_file.ksd09,",
              "ksd13.ksd_file.ksd13,",
              "ksd12.ksd_file.ksd12,",
              "str.type_file.chr1000,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('asfg626',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add #FUN-BB0047 mark
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?, ?,?,?,?,?, ?,?,?,?,?) "# No.FUN-C40020 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add #FUN-BB0047
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   #No.FUN-710082--end  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_program) THEN LET g_program = 'asfg626' END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g626_tm(0,0)        # Input print condition
      ELSE CALL g626()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g626_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 16
   END IF
   OPEN WINDOW g626_w AT p_row,p_col
      WITH FORM "asf/42f/asfg626"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ksc01,ksd11,ksc02
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
      LET INT_FLAG = 0 CLOSE WINDOW g626_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g626_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfg626'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfg626','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_ksc00 CLIPPED,"'",              #TQC-610080
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
         CALL cl_cmdat('asfg626',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g626_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g626()
   ERROR ""
END WHILE
   CLOSE WINDOW g626_w
END FUNCTION
 
FUNCTION g626()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
   #LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add

   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166        #No.FUN-680121 VARCHAR(1200)
          l_sql     STRING,          # RDSQL STATEMENT   #TQC-630166
          sr        RECORD
                    ksc00   LIKE ksc_file.ksc00,
                    ksc01   LIKE ksc_file.ksc01,
                    ksc02   LIKE ksc_file.ksc02,
                   #ksc03   LIKE ksc_file.ksc03,   #CHI-950036
                    ksd17   LIKE ksd_file.ksd17,   #CHI-950036
                    ksc04   LIKE ksc_file.ksc04,
                    gem02   LIKE gem_file.gem02,
                    ksc05   LIKE ksc_file.ksc05,
                    azf03   LIKE azf_file.azf03,
                    ksc06   LIKE ksc_file.ksc06,
                    ksc07   LIKE ksc_file.ksc07,
                    ksd03   LIKE ksd_file.ksd03,
                    ksd11   LIKE ksd_file.ksd11,
                    ksd04   LIKE ksd_file.ksd04,
                    ima02   LIKE ima_file.ima02,
                    ima021  LIKE ima_file.ima021,   #No.FUN-710082
                    ksd14   LIKE ksd_file.ksd14,
                    ksd15   LIKE ksd_file.ksd15,
                    ksd08   LIKE ksd_file.ksd08,
                    ksd05   LIKE ksd_file.ksd05,
                    ksd06   LIKE ksd_file.ksd06,
                    ksd07   LIKE ksd_file.ksd07,
                    ksd09   LIKE ksd_file.ksd09,
                    #No.FUN-580005 --start--
                    ksd33   LIKE ksd_file.ksd33,
                    ksd35   LIKE ksd_file.ksd35,
                    ksd30   LIKE ksd_file.ksd30,
                    ksd32   LIKE ksd_file.ksd32,
                    #No.FUN-580005 --end--
                    ksd13   LIKE ksd_file.ksd13,
                    ksd12   LIKE ksd_file.ksd12
                    END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5                   #No.FUN-580005        #No.FUN-680121 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580005
#No.FUN-710082--begin
DEFINE l_str2        LIKE type_file.chr1000          #No.FUN-680121 VARCHAR(100)#No.FUN-580005
DEFINE l_ksd35       STRING     #No.FUN-580005
DEFINE l_ksd32       STRING     #No.FUN-580005
DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
#No.FUN-710082--end  
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND kscuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND kscgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND kscgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('kscuser', 'kscgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ksc00,ksc01,ksc02,ksd17,ksc04,gem02,ksc05,azf03,",        #CHI-950036 ksc03-->ksd17
                 "ksc06,ksc07,ksd03,ksd11,ksd04,ima02,ima021,ksd14,ksd15,ksd08,",  #No.FUN-710082
#                "ksc06,ksc07,ksd03,ksd11,ksd04,ima02,ksd14,ksd15,ksd08,",         #No.FUN-710082
                 "ksd05,ksd06,ksd07,ksd09, ",
                 "ksd33,ksd35,ksd30,ksd32,ksd13,ksd12",
                #FUN-C50003-----mod---str---
                #" FROM ksc_file, ksd_file, ",
                #"  OUTER gem_file, OUTER ima_file, OUTER azf_file ",   #No.MOD-6C0128 modify ora file
                #" WHERE ksc01 = ksd01 AND  ksc_file.ksc04=gem_file.gem01  ",
                #"   AND  ksc_file.ksc05=azf_file.azf01  AND azf_file.azf02='2' ", #6818
                #"   AND  ksd_file.ksd04=ima_file.ima01  AND kscconf!='X' ",  #FUN-660134  #No.TQC-710012
                 " FROM ksc_file LEFT OUTER JOIN gem_file ON ksc04=gem01 ",
                 "               LEFT OUTER JOIN azf_file ON ksc05=azf01 AND azf02='2', ",
                 "      ksd_file LEFT OUTER JOIN ima_file ON ksd04=ima01 ",
                 " WHERE ksc01 = ksd01 AND kscconf!='X' ",
                #FUN-C50003-----mod---str---
             #   "   AND ksc00='",g_ksc00,"' AND ",tm.wc clipped
                 "   AND ",tm.wc clipped
     IF NOT cl_null(g_ksc00) THEN
        LET l_sql=l_sql CLIPPED," AND ksc00= '",g_ksc00,"'"  #bugno:7540 modify
     END IF
     LET l_sql=l_sql CLIPPED," ORDER BY ksc01,ksd03"   #No.FUN-710082
     PREPARE g626_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE g626_curs1 CURSOR FOR g626_prepare1
 
     #No.FUN-710082--begin
#    CALL cl_outnam('asfg626') RETURNING l_name
#    #No.FUN-580005 --start--
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
#    IF g_sma115 = "Y" THEN
#       LET g_zaa[37].zaa06 = "N"
#    ELSE
#       LET g_zaa[37].zaa06 = "Y"
#    END IF
#    LET g_len=80  #TQC-610080
#    CALL cl_prt_pos_len()
#    #No.FUN-580005 --end--
#    START REPORT g626_rep TO l_name
#    LET g_pageno = 0
 
     CALL cl_del_data(l_table) 
 
     FOREACH g626_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
#          OUTPUT TO REPORT g626_rep(sr.*)
 
          IF g_sma115 = "Y" THEN
             SELECT ima906 INTO l_ima906 FROM ima_file
              WHERE ima01 = sr.ksd04
             LET l_str2 = " "
             IF NOT cl_null(sr.ksd35) AND sr.ksd35 <> 0 THEN
                CALL cl_remove_zero(sr.ksd35) RETURNING l_ksd35
                LET l_str2 = l_ksd35, sr.ksd33 CLIPPED
             END IF
             IF l_ima906 = "2" THEN
                IF cl_null(sr.ksd35) OR sr.ksd35 = 0 THEN
                   CALL cl_remove_zero(sr.ksd32) RETURNING l_ksd32
                   LET l_str2 = l_ksd32, sr.ksd30 CLIPPED
                ELSE
                   IF NOT cl_null(sr.ksd32) AND sr.ksd32 <> 0 THEN
                      CALL cl_remove_zero(sr.ksd32) RETURNING l_ksd32
                      LET l_str2 = l_str2 CLIPPED,',',l_ksd32, sr.ksd30 CLIPPED
                   END IF
                END IF
             END IF
          END IF
 
         EXECUTE insert_prep USING sr.ksc00,sr.ksc01,sr.ksc02,sr.ksd17,sr.ksc04,   #CHI-950036 ksc03-->ksd17
                                   sr.gem02,sr.ksc05,sr.azf03,sr.ksc06,sr.ksc07,
                                   sr.ksd03,sr.ksd11,sr.ksd04,sr.ima02,sr.ima021,
                                   sr.ksd14,sr.ksd15,sr.ksd08,sr.ksd05,sr.ksd06,
                                   sr.ksd07,sr.ksd09,sr.ksd13,sr.ksd12,l_str2,"",  l_img_blob,"N",""  # No.FUN-C40020 add
 
     END FOREACH
 
#    FINISH REPORT g626_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     LET l_sql = "SELECT * FROM ",l_table CLIPPED                                 
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'ksc01,ksd11,ksc02')  
        RETURNING tm.wc                                                           
     END IF                      
###GENGRE###     LET l_str = tm.wc CLIPPED,";",g_zz05,";",g_sma115
 
  #  LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088 
  #  CALL cl_prt_cs3('asfg626',l_sql,l_str) 
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
###GENGRE###     CALL cl_prt_cs3('asfg626','asfg626',l_sql,l_str) 
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "ksc00"                    # No.FUN-C40020 add
    CALL asfg626_grdata()    ###GENGRE###
     #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT g626_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         l_str        LIKE type_file.chr8,          #No.FUN-680121 VARCHAR(8)
#         sr        RECORD
#                   ksc00   LIKE ksc_file.ksc00,
#                   ksc01   LIKE ksc_file.ksc01,
#                   ksc02   LIKE ksc_file.ksc02,
#                   ksc03   LIKE ksc_file.ksc03,
#                   ksc04   LIKE ksc_file.ksc04,
#                   gem02   LIKE gem_file.gem02,
#                   ksc05   LIKE ksc_file.ksc05,
#                   azf03   LIKE azf_file.azf03,
#                   ksc06   LIKE ksc_file.ksc06,
#                   ksc07   LIKE ksc_file.ksc07,
#                   ksd03   LIKE ksd_file.ksd03,
#                   ksd11   LIKE ksd_file.ksd11,
#                   ksd04   LIKE ksd_file.ksd04,
#                   ima02   LIKE ima_file.ima02,
#                   ksd14   LIKE ksd_file.ksd14,
#                   ksd15   LIKE ksd_file.ksd15,
#                   ksd08   LIKE ksd_file.ksd08,
#                   ksd05   LIKE ksd_file.ksd05,
#                   ksd06   LIKE ksd_file.ksd06,
#                   ksd07   LIKE ksd_file.ksd07,
#                   ksd09   LIKE ksd_file.ksd09,
#                   #No.FUN-580005 --start--
#                   ksd33   LIKE ksd_file.ksd33,
#                   ksd35   LIKE ksd_file.ksd35,
#                   ksd30   LIKE ksd_file.ksd30,
#                   ksd32   LIKE ksd_file.ksd32,
#                   #No.FUN-580005 --end--
#                   ksd13   LIKE ksd_file.ksd13,
#                   ksd12   LIKE ksd_file.ksd12
#                   END RECORD,
#            l_hh          LIKE type_file.chr1000,      #No.FUN-680121 VARCHAR(40)
#            l_cnt         LIKE type_file.num5          #No.FUN-680121 SMALLINT
#  DEFINE l_str2        LIKE type_file.chr1000,         #No.FUN-680121 VARCHAR(100)#No.FUN-580005
#         l_ksd35       STRING,    #No.FUN-580005
#         l_ksd32       STRING     #No.FUN-580005
#  DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
 
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN 6
#        PAGE LENGTH g_page_line
 
# ORDER BY sr.ksc01, sr.ksd03
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     IF sr.ksc00='0' THEN LET l_hh=g_x[21] END IF
#     IF sr.ksc00='1' THEN LET l_hh=g_x[22] END IF
#     IF sr.ksc00='2' THEN LET l_hh=g_x[23] END IF
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED
#     PRINT
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[11] CLIPPED,sr.ksc01,
#           COLUMN 41,g_x[15] CLIPPED,sr.ksc05,'  ',sr.azf03
#     PRINT g_x[12] CLIPPED,sr.ksc02,COLUMN 41,g_x[16] CLIPPED,sr.ksc06
#     PRINT g_x[13] CLIPPED,sr.ksc03,COLUMN 41,g_x[17] CLIPPED,sr.ksc07
#     PRINT g_x[14] CLIPPED,sr.ksc04,'  ',sr.gem02
#     PRINT g_dash2[1,g_len]
##No.FUN-560069 --start--
#     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[44],g_x[38],g_x[39]
#     PRINTX name=H2 g_x[40],g_x[41],g_x[45]
#     PRINTX name=H3 g_x[42],g_x[43],g_x[46]
 
#     PRINT g_dash1 CLIPPED
#     LET l_last_sw = 'n'
##No.FUN-560069 ---end--
##No.FUN-550056-begin
##     IF sr.ksc00 = '0' THEN PRINT g_x[24],g_x[25] CLIPPED END IF
##     IF sr.ksc00 = '1' THEN PRINT g_x[18],g_x[19] CLIPPED END IF
##     IF sr.ksc00 = '2' THEN PRINT g_x[26],g_x[27] CLIPPED END IF
##     PRINT g_x[20] CLIPPED
##     PRINT g_dash1[1,g_len]
 
#  BEFORE GROUP OF sr.ksc01   #單號
#     SKIP TO TOP OF PAGE
 
#  ON EVERY ROW
##No.FUN-580005 ---start--
#     IF g_sma115 = "Y" THEN
#        SELECT ima906 INTO l_ima906 FROM ima_file
#         WHERE ima01 = sr.ksd04
#        LET l_str2 = " "
#        IF NOT cl_null(sr.ksd35) AND sr.ksd35 <> 0 THEN
#           CALL cl_remove_zero(sr.ksd35) RETURNING l_ksd35
#           LET l_str2 = l_ksd35, sr.ksd33 CLIPPED
#        END IF
#        IF l_ima906 = "2" THEN
#           IF cl_null(sr.ksd35) OR sr.ksd35 = 0 THEN
#              CALL cl_remove_zero(sr.ksd32) RETURNING l_ksd32
#              LET l_str2 = l_ksd32, sr.ksd30 CLIPPED
#           ELSE
#              IF NOT cl_null(sr.ksd32) AND sr.ksd32 <> 0 THEN
#                 CALL cl_remove_zero(sr.ksd32) RETURNING l_ksd32
#                 LET l_str2 = l_str2 CLIPPED,',',l_ksd32, sr.ksd30 CLIPPED
#              END IF
#           END IF
#        END IF
#     END IF
#     PRINTX name=D1 COLUMN g_c[31], sr.ksd03 USING '###&', #FUN-590118
#                    COLUMN g_c[32], sr.ksd11 CLIPPED,
#                    COLUMN g_c[33], sr.ksd14 USING '###&', #FUN-590118
#                    COLUMN g_c[34], sr.ksd15 CLIPPED,
#                    COLUMN g_c[35], sr.ksd08 CLIPPED,
#                    COLUMN g_c[36], cl_numfor(sr.ksd09,36,3),
#                    COLUMN g_c[37], l_str2 CLIPPED,
#                    COLUMN g_c[44], cl_numfor(sr.ksd13,44,3),
#                    COLUMN g_c[38], sr.ksd05 CLIPPED,
#                    COLUMN g_c[39], sr.ksd12 CLIPPED
#     PRINTX name=D2 COLUMN g_c[40], ' ',
#                    #COLUMN g_c[41], sr.ksd04[1,20],
#                    COLUMN g_c[41], sr.ksd04 CLIPPED, #NO.FUN-5B0015
#                    COLUMN g_c[45], sr.ksd06 CLIPPED
#     PRINTX name=D3 COLUMN g_c[42], ' ',
#                    COLUMN g_c[43], sr.ima02 CLIPPED,
#                    COLUMN g_c[46], sr.ksd07 CLIPPED
##No.FUN-580005 ---end--
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#TQC-630166-start
#        CALL cl_wcchp(tm.wc,'ksc01,ksd11,ksc02')  
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#        CALL cl_prt_pos_wc(tm.wc)
#             IF tm.wc[001,070] > ' ' THEN            # for 80
#        PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             IF tm.wc[071,140] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             IF tm.wc[141,210] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             IF tm.wc[211,280] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#TQC-630166-end
#     END IF
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
## FUN-550124
#     PRINT
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[9] CLIPPED
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[9] CLIPPED
#            PRINT g_memo
#     END IF
### END FUN-550124
 
#END REPORT
##Patch....NO.TQC-610037 <> #
#No.FUN-710082--end  

###GENGRE###START
FUNCTION asfg626_grdata()
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
        LET handler = cl_gre_outnam("asfg626")
        IF handler IS NOT NULL THEN
            START REPORT asfg626_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                      #  ," ORDER BY ksc01 "     #FUN-C50003 add #FUN-C30085 mark
                        ," ORDER BY ksc01,ksd03 "  #FUN-C30085 add
            DECLARE asfg626_datacur1 CURSOR FROM l_sql
            FOREACH asfg626_datacur1 INTO sr1.*
                OUTPUT TO REPORT asfg626_rep(sr1.*)
            END FOREACH
            FINISH REPORT asfg626_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT asfg626_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_ksc04_gem02        STRING          #FUN-B50018
    DEFINE l_ksc05_azf03        STRING          #FUN-B50018
    DEFINE l_ksc05_ksd06_ksd07  STRING          #FUN-B50018
    DEFINE l_str1               STRING          #FUN-C30085 add     
    ORDER EXTERNAL BY sr1.ksc01,sr1.ksd03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ksc01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.ksd03

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-C30085 sta
            LET l_str1 = cl_gr_getmsg("gre-268",g_lang,g_sma115)
            PRINTX l_str1
            #FUN-C30085 end
            #FUN-B50018----add-----str-----------------
            LET l_ksc04_gem02 = sr1.ksc04, ' ',sr1.gem02
            PRINTX l_ksc04_gem02

            LET l_ksc05_azf03 = sr1.ksc05, ' ',sr1.azf03
            PRINTX l_ksc05_azf03

            LET l_ksc05_ksd06_ksd07 = '(',sr1.ksd05,'/',sr1.ksd06,'/',sr1.ksd07,')'
            PRINTX l_ksc05_ksd06_ksd07

            PRINTX g_sma115
            #FUN-B50018----add-----end-----------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.ksc01
        AFTER GROUP OF sr1.ksd03

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-B80086
