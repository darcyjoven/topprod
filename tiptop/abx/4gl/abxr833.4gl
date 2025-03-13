# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abxr833.4gl
# Descriptions...: 成品折合原料清冊作業(abxr833)
# Date & Author..:
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬ima021
# Modify.........: No.MOD-580323 05/08/28 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0007 06/10/25 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
# Modify.........: No.FUN-850089 08/06/03 By TSD.lucasyeh 轉CR報表
# Modify.........: No.FUN-890101 08/09/23 By dxfwo  CR 追單到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE g_level LIKE  type_file.chr1               #No.FUN-680062      VARCHAR(1)
   DEFINE p_exist LIKE  type_file.chr1               #No.FUN-680062      VARCHAR(1)
   DEFINE tm  RECORD                              # Print condition RECORD
              wc      STRING,             # Where condition
              s       LIKE type_file.chr2,               #FUN-6A0007 排序
              u       LIKE type_file.chr2,               #FUN-6A0007 小計
              yy      LIKE type_file.chr4,
              ima15   LIKE type_file.chr1,
              rname   LIKE type_file.chr1,               #FUN-6A0007 報表格式
              detail  LIKE type_file.chr1                #FUN-6A0007 明細列印
              #a       LIKE type_file.chr1 ,             #FUN-6A0007
              #b       LIKE type_file.chr1               #FUN-6A0007
              END RECORD,
                  l_outbill     LIKE oga_file.oga01              # 出貨單號,傳參數用
 
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   g_ima1916a    LIKE ima_file.ima1916     #FUN-6A0007
DEFINE   g_ima1916b    LIKE ima_file.ima1916     #FUN-6A0007
DEFINE   g_bxe01       LIKE bxe_file.bxe01  #FUN-6A0007
DEFINE   g_bxe02       LIKE bxe_file.bxe02  #FUN-6A0007
DEFINE   g_bxe03       LIKE bxe_file.bxe03  #FUN-6A0007
DEFINE   g_sql         STRING,              #FUN-850089 add
         g_str         STRING,              #FUN-850089 add
         l_table       STRING               #FUN-850089 add
DEFINE   g_bxe02a      LIKE bxe_file.bxe02  #FUN-850089 add
DEFINE   g_bxe03a      LIKE bxe_file.bxe03  #FUN-850089 add
DEFINE   g_bxe02b      LIKE bxe_file.bxe02  #FUN-850089 add
DEFINE   g_bxe03b      LIKE bxe_file.bxe03  #FUN-850089 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
#---FUN-850089 add---start
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql =  "order1.bwb_file.bwb03,",
                "order2.bwb_file.bwb03,",
                "order3.bwb_file.bwb03,",
                "order4.bwb_file.bwb03,",
                "bwb01.bwb_file.bwb01,",
                "bwb03.bwb_file.bwb03,",
                "bwb04.bwb_file.bwb04,",
                "ima106.ima_file.ima106,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "ima25.ima_file.ima25,",
                "ima1916a.ima_file.ima1916,",
                "bwe02.bwe_file.bwe02,",
                "bwe03.bwe_file.bwe03,",
                "bwe031.bwe_file.bwe031,",
                "bwe04.bwe_file.bwe04,",
                "ima02b.ima_file.ima02,",
                "ima021b.ima_file.ima021,",
                "ima25b.ima_file.ima25,",
                "ima1916b.ima_file.ima1916,",
  	        "bxe02a.bxe_file.bxe02,",
	        "bxe03a.bxe_file.bxe03,",
  	        "bxe02b.bxe_file.bxe02,",
	        "bxe03b.bxe_file.bxe03"
                                            #24 items
   LET l_table = cl_prt_temptable('abxr833',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add---end
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc= ARG_VAL(1)
   IF cl_null(tm.wc)
   THEN
       CALL abxr833_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr833_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062 smallint
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 18
   END IF
 
   OPEN WINDOW abxr833_w AT p_row,p_col
        WITH FORM "abx/42f/abxr833"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
WHILE TRUE
   LET tm.wc = ""
   LET tm.yy    = YEAR(TODAY)-1
   LET tm.ima15 = "1"
   #FUN-6A0007...............begin
   #LET tm.a     = "4"
   #LET tm.b     = "N"
   LET tm2.s1    = '2'
   LET tm2.s2    = '1'
   LET tm2.u1    = 'N'
   LET tm2.u2    = 'N'
   LET tm.rname  = '1'
   LET tm.detail = 'Y'
  
   #CONSTRUCT BY NAME tm.wc ON bwa01
   CONSTRUCT BY NAME tm.wc ON bwb03,ima1916a,bwe03,ima1916b
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(bwb03)  # 成品料號
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima20"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO bwb03
             NEXT FIELD bwb03
           WHEN INFIELD(ima1916a)  # 半成品/成品保稅群組代碼
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_bxe01"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ima1916a
             NEXT FIELD ima1916a
           WHEN INFIELD(bwe03)  # 原料料號
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_ima20"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO bwe03
             NEXT FIELD bwe03
           WHEN INFIELD(ima1916b)  # 半成品/成品保稅群組代碼
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_bxe01"
             LET g_qryparam.state = 'c'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO ima1916b
             NEXT FIELD ima1916b
         END CASE
 
   #FUN-6A0007...............end
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr833_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1"
   THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   IF INT_FLAG
   THEN
      LET INT_FLAG = 0 CLOSE WINDOW abxr833_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
         
   END IF
   #FUN-6A0007...............begin
   INPUT BY NAME tm2.s1,tm2.s2,tm2.u1,tm2.u2,
                 tm.yy,tm.ima15,tm.rname,tm.detail WITHOUT DEFAULTS
   #INPUT tm.yy,tm.ima15,tm.a,tm.b WITHOUT DEFAULTS
   #        FROM formonly.yy,ima15,formonly.a,formonly.b
   #FUN-6A0007...............end
 
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD ima15
         #IF tm.ima15 NOT MATCHES "[12]"
         IF tm.ima15 NOT MATCHES "[123]" #FUN-6A0007
         THEN
             NEXT FIELD ima15
         END IF
     #FUN-6A0007...............begin
     #AFTER FIELD a
     #   IF tm.a  NOT MATCHES "[1234]"
     #   THEN
     #       NEXT FIELD a
     #   END IF
     #AFTER FIELD b
     #   IF tm.b  NOT MATCHES "[YN]"
     #   THEN
     #       NEXT FIELD b
     #   END IF
      AFTER FIELD yy    # 盤點年度
         IF NOT cl_null(tm.yy) THEN
            IF tm.yy < 0 THEN
               CALL cl_err('yyyy','aim-391',0)
               NEXT FIELD yy
            END IF
         END IF
      AFTER FIELD rname  # 報表格式
         IF tm.rname NOT MATCHES "[12]" THEN
            NEXT FIELD rname
         END IF
      AFTER FIELD s1     # 排序
         IF tm2.s1 NOT MATCHES "[12]" THEN
            NEXT FIELD s1
         END IF
      AFTER FIELD s2     # 排序
         IF tm2.s2 NOT MATCHES "[12]" THEN
            NEXT FIELD s2
         END IF
      AFTER FIELD u1     # 小計
         IF tm2.u1 NOT MATCHES "[YN]" THEN
            NEXT FIELD u1
         END IF
      AFTER FIELD u2     # 小計
         IF tm2.u2 NOT MATCHES "[YN]" THEN
            NEXT FIELD u2
         END IF
      AFTER FIELD detail # 明細列印否
         IF tm.detail NOT MATCHES "[YN]" THEN
            NEXT FIELD detail
         END IF
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.u = tm2.u1,tm2.u2
      #FUN-6A0007...............end
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE INPUT        #TQC-860021
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
   END INPUT
   IF INT_FLAG
   THEN
      LET INT_FLAG = 0 EXIT WHILE
   END IF
   CALL cl_wait()
   #FUN-6A0007...............begin 做ima1916a,ima1916b字串替換
   CALL cl_replace_str(tm.wc,'ima1916a','a.ima1916') RETURNING tm.wc
   CALL cl_replace_str(tm.wc,'ima1916b','b.ima1916') RETURNING tm.wc
   #FUN-6A0007...............begin 做ima1916a,ima1916b字串替換
   CALL abxr833()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr833_w
END FUNCTION
 
FUNCTION abxr833()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name   #No.FUN-680062  VARCHAR(20)    
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       #No.FUN-680062  VARCHAR(1000)
          l_za05    LIKE za_file.za05,            #No.FUN-680062  VARCHAR(40)    
          xima15    LIKE type_file.chr1,          #No.FUN-680062  VARCHAR(1)    
          l_cnt     LIKE type_file.num5,          #No.FUN-680062  smallint
          bwa       RECORD LIKE bwa_file.*
   #FUN-6A0007...............begin
   DEFINE l_order   ARRAY[5] OF LIKE bwb_file.bwb03
   DEFINE l_bwc03   LIKE bwc_file.bwc03
   DEFINE sr        RECORD
                    order1     LIKE bwb_file.bwb03,
                    order2     LIKE bwb_file.bwb03,
                    order3     LIKE bwb_file.bwb03,
                    order4     LIKE bwb_file.bwb03,
                    bwb01      LIKE bwb_file.bwb01,
                    bwb03      LIKE bwb_file.bwb03,
                    bwb04      LIKE bwb_file.bwb04,
                    ima106     LIKE ima_file.ima106,
                    ima02      LIKE ima_file.ima02,
                    ima021     LIKE ima_file.ima021,
                    ima25      LIKE ima_file.ima25,
                    ima1916a   LIKE ima_file.ima1916,
                    bwe02      LIKE bwe_file.bwe02,
                    bwe03      LIKE bwe_file.bwe03,
                    bwe031     LIKE bwe_file.bwe031,
                    bwe04      LIKE bwe_file.bwe04,
                    ima02b     LIKE ima_file.ima02,
                    ima021b    LIKE ima_file.ima021,
                    ima25b     LIKE ima_file.ima25,
                    ima1916b   LIKE ima_file.ima1916
                    END RECORD
   #FUN-6A0007...............end
     DEFINE l_str1,l_str2 STRING   #No.MOD-580323 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
    #---FUN-850089 add---start
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #---FUN-850089 add---end
   
  
 
     DECLARE abxr833_za_cur CURSOR FOR
             SELECT za02,za05 FROM za_file
              WHERE za01 = "abxr833" AND za03 = g_rlang
     FOREACH abxr833_za_cur INTO g_i,l_za05
        LET g_x[g_i] = l_za05
     END FOREACH
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abxr833'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
   #FUN-6A0007...............begin
   #LET l_sql="SELECT bwa_file.* ",
   #           "  FROM bwa_file,ima_file  ",
   #           " WHERE bwa02 = ima01 AND ",#ima106 = '2' AND ",
   #           tm.wc clipped
   LET l_sql = "SELECT '','','','', ",
               "       bwb01,bwb03,bwb04, ",
               "       a.ima106,a.ima02,a.ima021,a.ima25,a.ima1916, ",
               "       bwe02,bwe03,bwe031,bwe04, ",
               "       b.ima02,b.ima021,b.ima25,b.ima1916 ",
               "  FROM bwb_file,bwe_file,ima_file a,ima_file b ",
               " WHERE bwb03 = a.ima01 AND bwe03 = b.ima01 ",
               "   AND bwe01 = bwb01 AND bwe03 != bwb03 ",
               "   AND (a.ima106 !='5' OR a.ima106 IS NULL) ", 
               "   AND ",tm.wc CLIPPED,
               "   AND bwb011 = bwe011 ",
               "   AND bwb011 = ",tm.yy
   # 保稅
   IF tm.ima15 = '1' THEN
      LET l_sql = l_sql," AND b.ima15 = 'Y' "
   END IF
   IF tm.ima15 = '2' THEN
      LET l_sql = l_sql," AND b.ima15 = 'N' "
   END IF
   #FUN-6A0007...............end
   
     PREPARE abxr833_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM
     END IF
     DECLARE abxr833_curs1 CURSOR FOR abxr833_prepare1
 
#No.FUN-890101---begin---
#     CALL cl_outnam('abxr833') RETURNING l_name
#     #FUN-6A0007...............begin
#     IF tm.rname = '2' THEN   # 依報表格式改變表身列印順序
#        LET g_zaa[31].zaa07 = 7
#        LET g_zaa[32].zaa07 = 8
#        LET g_zaa[33].zaa07 = 9
#        LET g_zaa[34].zaa07 = 10
#        LET g_zaa[35].zaa07 = 11
#        LET g_zaa[36].zaa07 = 12
#        LET g_zaa[37].zaa07 = 13
#        LET g_zaa[38].zaa07 = 1
#        LET g_zaa[39].zaa07 = 2
#        LET g_zaa[40].zaa07 = 3
#        LET g_zaa[41].zaa07 = 4
#        LET g_zaa[42].zaa07 = 5
#        LET g_zaa[43].zaa07 = 6
#        # 重新定義各欄位起始位置      
#        LET g_c[38] = 1
#        LET g_c[39] = g_c[38] + g_zaa[38].zaa05 + 1
#        LET g_c[40] = g_c[39] + g_zaa[39].zaa05 + 1
#        LET g_c[41] = g_c[40] + g_zaa[40].zaa05 + 1
#        LET g_c[42] = g_c[41] + g_zaa[41].zaa05 + 1
#        LET g_c[43] = g_c[42] + g_zaa[42].zaa05 + 1
#        LET g_c[31] = g_c[43] + g_zaa[43].zaa05 + 1
#        LET g_c[32] = g_c[31] + g_zaa[31].zaa05 + 1
#        LET g_c[33] = g_c[32] + g_zaa[32].zaa05 + 1
#        LET g_c[34] = g_c[33] + g_zaa[33].zaa05 + 1
#        LET g_c[35] = g_c[34] + g_zaa[34].zaa05 + 1
#        LET g_c[36] = g_c[35] + g_zaa[35].zaa05 + 1
#        LET g_c[37] = g_c[36] + g_zaa[36].zaa05 + 1
#     END IF
#     #START REPORT abxr833_rep TO l_name
#     START REPORT abxr833_rep2 TO l_name
#No.FUN-890101
#No.FUN-890101---end---
     LET g_pageno = 0
     FOREACH abxr833_curs1 INTO sr.*
     IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
        # 若bwc_file是所被折合的那筆不用列印---------(S)) 
        LET l_bwc03 = ' '
        SELECT bwc03 INTO l_bwc03   #被折合的料號
          FROM bwc_file
         WHERE bwc01 = sr.bwb01     #盤點單
           AND bwc02 = sr.bwe02     #項次
           AND bwc011 = tm.yy    #年度
        IF SQLCA.sqlcode THEN
           CALL cl_err('sel bwc03',STATUS,1)
           LET l_bwc03= ' '
        END IF
        # 若bwc_file是所被折合的那筆不用列印
        IF sr.bwe03 = l_bwc03 THEN  #一種是原料本身另外為被折合的半成品
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt
             FROM bwe_file
            WHERE bwe01 = sr.bwb01
              AND bwe02 = sr.bwe02
              AND bwe011 = tm.yy
              AND bwe03 != l_bwc03
           IF l_cnt > 0 THEN  CONTINUE FOREACH END IF
        END IF
        # 若bwc_file是所被折合的那筆不用列印---------(E))
 
        #若盤點數量為0或空白,要將主件品號的下列欄位改成被折合的品號欄位:
        #  型態,主件品號,品名,規格 ,單位 ,盤點數量
        IF (sr.bwb04=0 OR cl_null(sr.bwb04)) THEN
            SELECT bwc03,bwc05 INTO sr.bwb03,sr.bwb04
              FROM bwc_file
             WHERE bwc01 = sr.bwb01
               AND bwc02 = sr.bwe02
               AND bwc011 = tm.yy
            IF SQLCA.sqlcode THEN
               LET sr.bwb03=' '
               LET sr.bwb04=' '
            END IF
         END IF
         LET sr.ima02  = NULL
         LET sr.ima021 = NULL
         LET sr.ima25  = NULL
         LET sr.ima106 = NULL
         SELECT ima02,ima021,ima25,ima106
           INTO sr.ima02,sr.ima021,sr.ima25,sr.ima106
           FROM ima_file
          WHERE ima01 = sr.bwb03
 
 
        # 篩選排列順序
        IF tm.rname = '1' THEN
           FOR g_i = 1 TO 2
               CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bwb03
                                             LET l_order[g_i+2] = sr.bwe03
                    WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima1916a
                                             LET l_order[g_i+2] = sr.ima1916b
                    OTHERWISE LET l_order[g_i] = '-'
               END CASE
           END FOR
        ELSE
           FOR g_i = 1 TO 2
               CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.bwe03
                                             LET l_order[g_i+2] = sr.bwb03
                    WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ima1916b
                                             LET l_order[g_i+2] = sr.ima1916a
                    OTHERWISE LET l_order[g_i] = '-'
               END CASE
           END FOR
 
        END IF
        LET sr.order1 = l_order[1]
        LET sr.order2 = l_order[2]
        LET sr.order3 = l_order[3]
        LET sr.order4 = l_order[4]
 
       #---FUN-850089 add---start
       LET g_bxe02a = ""
       LET g_bxe03a = ""
       LET g_bxe02b = ""
       LET g_bxe03b = ""
       #選取品名規格
       SELECT bxe02,bxe03 INTO g_bxe02a,g_bxe03a
         FROM bxe_file
        WHERE bxe01 = sr.ima1916a
       #選取品名規格(2)
       SELECT bxe02,bxe03 INTO g_bxe02b,g_bxe03b
         FROM bxe_file
        WHERE bxe01 = sr.ima1916b
	## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
        EXECUTE insert_prep USING sr.*,
                                  g_bxe02a, g_bxe03a,
                                  g_bxe02b, g_bxe03b
        ##--------------------------CR (3)---------------------------------##
       #---FUN-850089 add---end
#        OUTPUT TO REPORT abxr833_rep2(sr.*)         #No.FUN-890101
     END FOREACH
 
#     FOREACH abxr833_curs1 INTO bwa.*
#     IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       IF bwa.bwa06 = 0 THEN continue FOREACH END IF
#       IF tm.ima15="1"
#       THEN
#           SELECT ima15 INTO xima15 FROM ima_file where ima01 = bwa.bwa02
#           IF xima15 <> "Y"
#           THEN
#               continue foreach
#           END IF
#       END IF
#       IF tm.b = 'N' THEN
#          let l_cnt = 0
#          select count(*) into l_cnt from bne_file where bne01 = bwa.bwa02
#          if l_cnt = 0
#          then
#              continue foreach
#          end if
#       #  select count(*) into l_cnt from bwe_file
#       #        where bwe00 = "S" AND bwe01 = bwa.bwa01 AND bwe03 <> bwa.bwa02
#       #  IF cl_null(l_cnt) THEN continue foreach END IF
#       END IF
##No.MOD-580323 --start--
#       CALL cl_getmsg('abx-010',g_lang) RETURNING l_str1
#       CALL cl_getmsg('abx-832',g_lang) RETURNING l_str2
#       MESSAGE l_str1,bwa.bwa01,l_str2,bwa.bwa02
##      MESSAGE "盤點標簽=",bwa.bwa01," 料號=",bwa.bwa02
##No.MOD-580323 --end--
#       CALL ui.Interface.refresh()
#       OUTPUT TO REPORT abxr833_rep(bwa.*)
#     END FOREACH
 
     #FINISH REPORT abxr833_rep
#     FINISH REPORT abxr833_rep2   #No.FUN-890101   
#FUN-6A0007...............end
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #No.FUN-890101 
   #---FUN850089 add---start
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'bwb03,ima1916a,bwe03,ima1916b')
             RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = ""
     END IF
 
     LET g_str = g_str,";",tm.yy,";",tm.rname,";",tm.detail,";",
                           tm.s[1,1],";",tm.s[2,2],";",
                           tm.u[1,1],";",tm.u[2,2],";",
                           g_bxz.bxz100,";", g_bxz.bxz101,";", g_bxz.bxz102
 
     CALL cl_prt_cs3('abxr833','abxr833',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
   #---FUN850089 add---end
END FUNCTION
 
#FUN-6A0007...............begin
#REPORT abxr833_rep2(sr)
#   DEFINE l_last_sw LIKE type_file.chr1
#   DEFINE l_str     STRING 
#   DEFINE sr        RECORD
#                    order1     LIKE bwb_file.bwb03,
#                    order2     LIKE bwb_file.bwb03,
#                    order3     LIKE bwb_file.bwb03,
#                    order4     LIKE bwb_file.bwb03,
#                    bwb01      LIKE bwb_file.bwb01,
#                    bwb03      LIKE bwb_file.bwb03,
#                    bwb04      LIKE bwb_file.bwb04,
#                    ima106     LIKE ima_file.ima106,
#                    ima02      LIKE ima_file.ima02,
#                    ima021     LIKE ima_file.ima021,
#                    ima25      LIKE ima_file.ima25,
#                    ima1916a LIKE ima_file.ima1916,
#                    bwe02      LIKE bwe_file.bwe02,
#                    bwe03      LIKE bwe_file.bwe03,
#                    bwe031     LIKE bwe_file.bwe031,
#                    bwe04      LIKE bwe_file.bwe04,
#                    ima02b     LIKE ima_file.ima02,
#                    ima021b    LIKE ima_file.ima021,
#                    ima25b     LIKE ima_file.ima25,
#                    ima1916b LIKE ima_file.ima1916
#                    END RECORD
#  
#   OUTPUT TOP MARGIN g_top_margin
#          LEFT MARGIN 0
#          BOTTOM MARGIN g_bottom_margin
#          PAGE LENGTH g_page_line
#   ORDER BY sr.order1,sr.order2,sr.order3,sr.order4
#   FORMAT
#     PAGE HEADER
#         LET l_str = g_bxz.bxz100 CLIPPED,
#                    ' ',g_company CLIPPED,
#                    ' ',g_bxz.bxz102 CLIPPED,
#                    '                   ',g_x[12],g_bxz.bxz101 CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED)
#                            -FGL_WIDTH(g_bxz.bxz100 CLIPPED)
#                            -FGL_WIDTH(g_bxz.bxz102 CLIPPED))/2)+3,l_str CLIPPED
#        PRINT ' '
#        LET g_pageno = g_pageno + 1
#        IF g_pageno = 1 THEN
#           IF tm.rname = '1' THEN
#              LET g_x[1] = g_x[1]
#           ELSE
#              LET g_x[1] = g_x[11]
#           END IF
#        END IF
#        # 報表格式名稱
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#        PRINT ' '
#        # 製表日期....
#        PRINT COLUMN 01,g_x[2] CLIPPED,g_pdate USING 'yy/mm/dd',
#              COLUMN 110,g_x[13] CLIPPED,tm.yy USING '####',
#              COLUMN g_len - 10,g_x[3] CLIPPED,g_pageno USING '###'
#        PRINT g_dash
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#              g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],
#              g_x[43]
#        PRINT g_dash1
#        LET l_last_sw = 'n'
#
#     ON EVERY ROW
#        IF tm.detail = 'Y' THEN
#           PRINT COLUMN g_c[31],sr.ima106,
#                 COLUMN g_c[32],sr.bwb03,
#                 COLUMN g_c[33],sr.ima02,
#                 COLUMN g_c[34],sr.ima021,
#                 COLUMN g_c[35],sr.ima25,
#                 COLUMN g_c[36],sr.bwb01,
#                 COLUMN g_c[37],cl_numfor(sr.bwb04,37,3),
#                 COLUMN g_c[38],sr.bwe03,
#                 COLUMN g_c[39],sr.ima02b,
#                 COLUMN g_c[40],sr.ima021b,
#                 COLUMN g_c[41],sr.ima25b,
#                 COLUMN g_c[42],cl_numfor(sr.bwe031,42,4),
#                 COLUMN g_c[43],cl_numfor(sr.bwe04,43,4)
#        END IF
#
#     AFTER GROUP OF sr.order1
#        IF tm.u[1,1] = 'Y' THEN  # 是否小計
#           IF tm.rname = '1' THEN
#             CASE 
#              WHEN tm.s[1,1] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[34],g_x[18] CLIPPED,sr.bwb03 CLIPPED,
#                       COLUMN g_c[35],g_x[14] CLIPPED,
#                       COLUMN g_c[37],cl_numfor(GROUP SUM(sr.bwb04),37,3)
#                 PRINT ''
#              WHEN tm.s[1,1] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916a
#                 CALL abxr833_bxe01()
#                 PRINT COLUMN g_c[34],g_x[15] CLIPPED,sr.ima1916a CLIPPED,
#                       COLUMN g_c[35],g_x[14] CLIPPED,
#                       COLUMN g_c[37],cl_numfor(GROUP SUM(sr.bwb04),37,3)
#                 PRINT COLUMN g_c[34],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[34],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE
#           ELSE
#             CASE 
#              WHEN tm.s[1,1] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[40],g_x[18] CLIPPED,sr.bwe03 CLIPPED,
#                       COLUMN g_c[41],g_x[14] CLIPPED,
#                       COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bwe031),42,4),
#                       COLUMN g_c[43],cl_numfor(GROUP SUM(sr.bwe04),43,4)
#                 PRINT ''
#              WHEN tm.s[1,1] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916b
#                 CALL abxr833_bxe01()
#                 PRINT COLUMN g_c[40],g_x[15] CLIPPED,sr.ima1916b CLIPPED,
#                       COLUMN g_c[41],g_x[14] CLIPPED,
#                       COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bwe031),42,4),
#                       COLUMN g_c[43],cl_numfor(GROUP SUM(sr.bwe04),43,4)
#                 PRINT COLUMN g_c[40],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[40],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE
#           END IF
#        END IF
#
#     AFTER GROUP OF sr.order2
#        IF tm.u[2,2] = 'Y' THEN  # 是否小計
#           IF tm.rname = '1' THEN
#             CASE 
#              WHEN tm.s[2,2] = '1'  # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[34],g_x[18] CLIPPED,sr.bwb03 CLIPPED,
#                       COLUMN g_c[35],g_x[14] CLIPPED,
#                       COLUMN g_c[37],cl_numfor(GROUP SUM(sr.bwb04),37,3)
#                 PRINT ''
#              WHEN tm.s[2,2] = '2'  # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916a
#                 CALL abxr833_bxe01()
#                 PRINT COLUMN g_c[34],g_x[15] CLIPPED,sr.ima1916a CLIPPED,
#                       COLUMN g_c[35],g_x[14] CLIPPED,
#                       COLUMN g_c[37],cl_numfor(GROUP SUM(sr.bwb04),37,3)
#                 PRINT COLUMN g_c[34],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[34],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE
#           ELSE
#             CASE 
#              WHEN tm.s[2,2] = '1'  # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[40],g_x[18] CLIPPED,sr.bwe03 CLIPPED,
#                       COLUMN g_c[41],g_x[14] CLIPPED,
#                       COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bwe031),42,4),
#                       COLUMN g_c[43],cl_numfor(GROUP SUM(sr.bwe04),43,4)
#                 PRINT ''
#              WHEN tm.s[2,2] = '2'  # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916b
#                 CALL abxr833_bxe01()
#                 PRINT COLUMN g_c[40],g_x[15] CLIPPED,sr.ima1916b CLIPPED,
#                       COLUMN g_c[41],g_x[14] CLIPPED,
#                       COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bwe031),42,4),
#                       COLUMN g_c[43],cl_numfor(GROUP SUM(sr.bwe04),43,4)
#                 PRINT COLUMN g_c[40],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[40],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE
#           END IF
#        END IF
# 
#     AFTER GROUP OF sr.order3
#        IF tm.u[1,1] = 'Y' THEN
#           IF tm.rname = '1' THEN
#             CASE 
#              WHEN tm.s[1,1] = '1'  # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[40],g_x[18] CLIPPED,sr.bwe03 CLIPPED,
#                       COLUMN g_c[41],g_x[14] CLIPPED,
#                       COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bwe031),42,4),
#                       COLUMN g_c[43],cl_numfor(GROUP SUM(sr.bwe04),43,4)
#                 PRINT ''
#              WHEN tm.s[1,1] = '2'  # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916b
#                 CALL abxr833_bxe01()
#                 PRINT COLUMN g_c[40],g_x[15] CLIPPED,sr.ima1916b CLIPPED,
#                       COLUMN g_c[41],g_x[14] CLIPPED,
#                       COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bwe031),42,4),
#                       COLUMN g_c[43],cl_numfor(GROUP SUM(sr.bwe04),43,4)
#                 PRINT COLUMN g_c[40],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[40],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE
#           ELSE
#             CASE 
#              WHEN tm.s[1,1] = '1'  # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[34],g_x[18] CLIPPED,sr.bwb03 CLIPPED,
#                       COLUMN g_c[35],g_x[14] CLIPPED,
#                       COLUMN g_c[37],cl_numfor(GROUP SUM(sr.bwb04),37,3)
#                 PRINT ''
#              WHEN tm.s[1,1] = '2'  # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916a
#                 CALL abxr833_bxe01()
#                 PRINT COLUMN g_c[34],g_x[15] CLIPPED,sr.ima1916a CLIPPED,
#                       COLUMN g_c[35],g_x[14] CLIPPED,
#                       COLUMN g_c[37],cl_numfor(GROUP SUM(sr.bwb04),37,3)
#                 PRINT COLUMN g_c[34],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[34],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE
#           END IF
#        END IF
#
#     AFTER GROUP OF sr.order4
#        IF tm.u[2,2] = 'Y' THEN
#           IF tm.rname = '1' THEN
#             CASE 
#              WHEN tm.s[2,2] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[40],g_x[18] CLIPPED,sr.bwe03 CLIPPED,
#                       COLUMN g_c[41],g_x[14] CLIPPED,
#                       COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bwe031),42,4),
#                       COLUMN g_c[43],cl_numfor(GROUP SUM(sr.bwe04),43,4)
#                 PRINT ''
#              WHEN tm.s[2,2] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916b
#                 CALL abxr833_bxe01()
#                 PRINT COLUMN g_c[40],g_x[15] CLIPPED,sr.ima1916b CLIPPED,
#                       COLUMN g_c[41],g_x[14] CLIPPED,
#                       COLUMN g_c[42],cl_numfor(GROUP SUM(sr.bwe031),42,4),
#                       COLUMN g_c[43],cl_numfor(GROUP SUM(sr.bwe04),43,4)
#                 PRINT COLUMN g_c[40],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[40],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE
#           ELSE
#             CASE 
#              WHEN tm.s[2,2] = '1'   # 料件
#                 PRINT g_dash1
#                 PRINT COLUMN g_c[34],g_x[18] CLIPPED,sr.bwb03 CLIPPED,
#                       COLUMN g_c[35],g_x[14] CLIPPED,
#                       COLUMN g_c[37],cl_numfor(GROUP SUM(sr.bwb04),37,3)
#                 PRINT ''
#              WHEN tm.s[2,2] = '2'   # 保稅代碼 
#                 PRINT g_dash1
#                 LET g_bxe01 = sr.ima1916a
#                 CALL abxr833_bxe01()
#                 PRINT COLUMN g_c[34],g_x[15] CLIPPED,sr.ima1916a CLIPPED,
#                       COLUMN g_c[35],g_x[14] CLIPPED,
#                       COLUMN g_c[37],cl_numfor(GROUP SUM(sr.bwb04),37,3)
#                 PRINT COLUMN g_c[34],g_x[16] CLIPPED,g_bxe02 CLIPPED
#                 PRINT COLUMN g_c[34],g_x[17] CLIPPED,g_bxe03 CLIPPED
#                 PRINT ''
#              OTHERWISE EXIT CASE
#             END CASE
#           END IF
#        END IF
#
#     
#     ON LAST ROW
#        PRINT g_dash
#        LET l_last_sw = 'y'
#        PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
#              COLUMN (g_len-9),g_x[7] CLIPPED
#
#
#     PAGE TRAILER
#        IF l_last_sw = 'n' THEN
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,
#                 COLUMN (g_len-9),g_x[6] CLIPPED
#        ELSE
#          SKIP 2 LINE
#        END IF
#
#END REPORT
#No.FUN-890101
 
# 保稅規格代碼、品名、規格
FUNCTION abxr833_bxe01()
 
 LET g_bxe02 = NULL
 LET g_bxe03 = NULL
 
 SELECT bxe02,bxe03 INTO g_bxe02,g_bxe03
 FROM bxe_file
 WHERE bxe01 = g_bxe01
 
END FUNCTION
#FUN-6A0007...............begin
 
#FUN-6A0007..............................mark begin
#REPORT abxr833_rep(bwa)
#   DEFINE l_last_sw  LIKE type_file.chr1,         #No.FUN-680062  VARCHAR(1)    
#          g_count LIKE type_file.num5,            #No.FUN-680062  smallint    
#          x_ima25 LIKE ima_file.ima25,
#          x_ima15 LIKE ima_file.ima15,
#          x_ima02 LIKE ima_file.ima02,
#          x_ima021 LIKE ima_file.ima021,
#          x_ima106 LIKE ima_file.ima106,
#          x_bne08 LIKE bne_file.bne08,
#          x_bnd02 LIKE bnd_file.bnd02,
#          x_bnd04 LIKE bnd_file.bnd04,
#          xx    LIKE type_file.chr1000,           #No.FUN-680062 VARCHAR(100)     
#          rset  LIKE type_file.num5,              #No.FUN-680062 smallint     
#          bwa RECORD LIKE bwa_file.*,
#          bwe RECORD LIKE bwe_file.*
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY bwa.bwa01
#
#  FORMAT
#   PAGE HEADER
#      LET xx       = "財政部台北關稅局監管大騰電子企業股份有限公司立德廠",
#                     "保稅工廠"
#      LET g_x[1]   = (tm.yy-1911) USING "&&","年度 半成品盤存數折合原料分析清表"
#      LET g_x[3]   = "頁次:"
#      LET g_len    = 132
#      #PRINT (g_len-FGL_WIDTH(xx))/2 SPACES,xx clipped
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      PRINT
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      LET   g_pageno = g_pageno + 1
#      PRINT COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      LET l_last_sw = "n"
#
#   BEFORE GROUP OF bwa.bwa01
#      PRINT "==================================================================================================================================="
#      PRINT "1.3.5.7.9 料件編號             盤點標籤    用料清表核備文號     單    位     盤點數量                           備            註"
#      PRINT "          成品品名規格           下階用料品名規格                                保稅否 單位用量   折合數量        (核准文號) "
#      PRINT "--------- -------------------- ------------------------------------------------- ------ -------- ------------ ---------------------"
#    select ima02,ima021,ima25,ima15 into x_ima02,x_ima021,x_ima25,x_ima15
#    from ima_file where ima01 = bwa.bwa02
#   #select bnd04 into x_bnd04 FROM bnd_file where bnd01 = bwa.bwa02
#
#       declare selbnd01 cursor for
#       select bnd02,bnd04 from bnd_file
#       where bnd01 = bwa.bwa02
#       order by bnd02 desc
#       foreach selbnd01 into x_bnd02,x_bnd04
#           exit foreach
#       end foreach
#
#    PRINT COLUMN 06,"料號:",bwa.bwa02,
#          COLUMN 11,bwa.bwa01        ,
#          COLUMN 35,x_bnd04 clipped,
#          COLUMN 69,"EA" clipped,
#          COLUMN 74,bwa.bwa06 USING "####,###,##&"
#
#    PRINT COLUMN 11,x_ima02 clipped,' ',x_ima021 clipped
#    PRINT
#
#   ON EVERY ROW
#    declare selbwe cursor for
#       select * from bwe_file
#    where bwe00 = "S" AND bwe01 = bwa.bwa01 AND bwe03 <> bwa.bwa02
#    order by bwe00,bwe01,bwe02
#    foreach selbwe into bwe.*
#       LET g_count = 1
#       select ima02,ima021,ima25,ima15,ima106
#               into x_ima02,x_ima021,x_ima25,x_ima15,x_ima106
#               from ima_file where ima01 = bwe.bwe03
#       IF tm.ima15 = "1" AND x_ima15 = "N" THEN
#           continue foreach
#       END IF
#       IF tm.a<>'4' AND tm.a<>x_ima106 THEN
#           continue foreach
#       END IF
#       declare selbne08 cursor for
#       select bnd02,bne08 from bne_file,bnd_file
#       where bnd01 = bwa.bwa02
#       and   bnd01 = bne01
#       and   bne05 = bwe.bwe03
#       order by bnd02 desc
#       foreach selbne08 INTO x_bnd02,x_bne08
#           exit foreach
#       end foreach
#       IF x_bne08 = 0
#       THEN
#           CONTINUE FOREACH
#       END IF
#       LET g_level = 0
#       LET p_exist = "N"
#       LET rset    = 4
#       call bom(0,bwa.bwa02,bwe.bwe03) returning g_level
# 
#       let x_bnd04=' '
#       declare selbnd02 cursor for
#       select bnd02,bnd04 from bnd_file
#       where bnd01 = bwe.bwe03
#       order by bnd02 desc
#       foreach selbnd02 into x_bnd02,x_bnd04
#           exit foreach
#       end foreach
#       if bwe.bwe031 > 0 THEN
#          PRINT COLUMN g_level,g_level using "&",
#                COLUMN 07+rset,bwe.bwe03,
#                COLUMN 27+rset,x_ima02 ,
#                 COLUMN 51+rset,x_ima021 CLIPPED, #MOD-4A0238
#                COLUMN 79+rset,x_ima15 ,
#                COLUMN 84+rset,bwe.bwe031 using "#,###,##&",
#                COLUMN 94+rset,bwe.bwe04 using "####,###,##&",
#                COLUMN 104+rset,x_bnd04
#          LET g_count = g_count+1
#       end if
#   end foreach
#
#   AFTER GROUP OF bwa.bwa01
#   PRINT
#
#   ON LAST ROW
#      PRINT "==================================================================================================================================="
#    PRINT "(abxr833)                                                                   (結 束) "
#      LET l_last_sw = 'n'
#
#   PAGE TRAILER
#      IF l_last_sw = 'y'
#      THEN
#      PRINT "==================================================================================================================================="
#         PRINT "(abxr833)                                                                (接 下 頁) "
#      ELSE
#        SKIP 2 LINE
#      END IF
#
#END REPORT
#
#function bom(p_level,a1,a2)
#  DEFINE a1      LIKE bne_file.bne01                    #No.FUN-680062   VARCHAR(20) 
#  DEFINE a2,a3   LIKE bne_file.bne05                    #No.FUN-680062   VARCHAR(20)   
#  DEFINE p_level    LIKE type_file.num5                 #No.FUN-680062   smallint   
#  DEFINE l_n,ii,jj  LIKE type_file.num5                 #No.FUN-680062   smallint   
#  DEFINE KK ARRAY[500] OF LIKE type_file.chr20          #No.FUN-680062   VARCHAR(20)   
#
#  LET p_level = p_level + 1
#  LET ii = 1
#  FOR ii = 1 TO 500
#      LET KK[ii] = " "
#  END FOR
#  LET ii = 1
#
#  declare selxxx cursor for
#     select bne05 from bne_file
#  where bne01 = a1
#  foreach selxxx into a3
#      IF a3 is null then let a3 = " " end if
#      LET KK[ii] = a3
#      LET ii = ii + 1
#  end foreach
#  let  jj = ii - 1
#  call set_count(jj)
#
#  for ii = 1 to jj
#      if a2 = kk[ii]
#      then
#          let p_exist = "Y"
#          return p_level
#      end if
#  end for
#
# IF p_exist = "N"
# then
#  for ii = 1 TO jj
# 
#          select count(*) into l_n from bnd_file where bnd01 = kk[ii]
#          if l_n > 0
#          then
#              IF p_exist = "N"
#              THEN
#               call bom(p_level,kk[ii],a2) returning p_level
#               IF p_exist = "N" AND p_level > 0
#               THEN
#                   LET p_level = p_level - 1
#               END IF
#              END IF
#          end if
#  end for
# end if
# return p_level
#end function
#FUN-6A0007..............................mark end 
#Patch....NO.TQC-610035 <001,002> #
