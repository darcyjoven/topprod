# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcr321.4gl
# Descriptions...: IQC不良原因分析(By 料號)
# Date & Author..: 99/05/15 By Sophia
# Modify.........: No.FUN-550063 05/05/19 By day   單據編號加大
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570243 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580013 05/08/16 By yoyo 憑証類報表原則修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-5C0078 05/12/20 By jackie 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.TQC-610086 06/04/18 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: NO.FUN-740013 07/04/18 BY TSD.c123k 改為Crystal Report
# Modify.........: NO.MOD-870066 08/07/07 BY claire 語法調整
# Modify.........: NO.CHI-910058 09/02/05 By xiaofeizhu 已轉CR，不需使用zaa
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              bdate   LIKE type_file.dat,          #No.FUN-680104 DATE
              edate   LIKE type_file.dat,          #No.FUN-680104 DATE
              more    LIKE type_file.chr1         #No.FUN-680104 VARCHAR(1)
              END RECORD,
          g_head1  DYNAMIC ARRAY OF RECORD
              qcu04    LIKE qcu_file.qcu04,
              qcu05    LIKE qcu_file.qcu05
              END RECORD,
          g_tot1       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot2       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot3       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot4       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot5       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot6       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot7       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot8       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot9       LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
          g_tot10      LIKE qcu_file.qcu05        #No.FUN-680104 DEC(12,3)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
#FUN-740013 add --------------------------------------
DEFINE   l_table    STRING
DEFINE   g_sql      STRING
DEFINE   g_str      STRING
DEFINE   l_qcu05    ARRAY[11] of LIKE qcu_file.qcu05,                                #CHI-910058 ARRAY[10]-->ARRAY[11]  
         l_amt      LIKE qcu_file.qcu05,
         l_n        LIKE type_file.num5
#FUN-740013 end --------------------------------------
 
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
 
#FUN-740013 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-740013 *** ##
   LET g_sql = "qcs01.qcs_file.qcs01,",
               "qcs22.qcs_file.qcs22,",
               "qcu04.qcu_file.qcu04,",
               "qcu05.qcu_file.qcu05,",
               "qcs021.qcs_file.qcs021,",
               "amt.qcs_file.qcs22,",
               "cnt.type_file.num5,",
               "g1_qcu04.qcu_file.qcu04,",
               "g2_qcu04.qcu_file.qcu04,",
               "g3_qcu04.qcu_file.qcu04,",
               "g4_qcu04.qcu_file.qcu04,",
               "g5_qcu04.qcu_file.qcu04,",
               "g6_qcu04.qcu_file.qcu04,",
               "g7_qcu04.qcu_file.qcu04,",
               "g8_qcu04.qcu_file.qcu04,",
               "g9_qcu04.qcu_file.qcu04,",
               "g10_qcu04.qcu_file.qcu04,",
               "l_qcu05_1.qcu_file.qcu05,",
               "l_qcu05_2.qcu_file.qcu05,",
               "l_qcu05_3.qcu_file.qcu05,",
               "l_qcu05_4.qcu_file.qcu05,",
               "l_qcu05_5.qcu_file.qcu05,",
               "l_qcu05_6.qcu_file.qcu05,",
               "l_qcu05_7.qcu_file.qcu05,",
               "l_qcu05_8.qcu_file.qcu05,",
               "l_qcu05_9.qcu_file.qcu05,",
               "l_qcu05_10.qcu_file.qcu05,",
               "l_str1.adj_file.adj02,",
               "l_str2.adj_file.adj02,",
               "l_str3.adj_file.adj02,",
               "l_str4.adj_file.adj02,",
               "l_str5.adj_file.adj02,",
               "l_str6.adj_file.adj02,",
               "l_str7.adj_file.adj02,",
               "l_str8.adj_file.adj02,",
               "l_str9.adj_file.adj02,",
               "l_str10.adj_file.adj02"
 
   LET l_table = cl_prt_temptable('aqcr321',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
#FUN-740013 - END
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#------------No.TQC-610086 modify
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#------------No.TQC-610086 end
   CALL r321_cre_tmp()
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r321_tm(0,0)
      ELSE CALL r321()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r321_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r321_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr321"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON qcs021,qcs03,qcu04
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
         IF INFIELD(qcs021) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_qcs2"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO qcs021
              NEXT FIELD qcs021
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
   INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
          IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD edate
          IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
          IF tm.edate < tm.bdate THEN NEXT FIELD edate END IF
 
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
      CLOSE WINDOW r321_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr321'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr321','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aqcr321',g_time,l_cmd)
      END IF
      CLOSE WINDOW r321_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r321()
   ERROR ""
END WHILE
   CLOSE WINDOW r321_w
END FUNCTION
 
FUNCTION r321()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
          l_i       LIKE type_file.num5,          #No.FUN-680104 SMALLINT
          l_qcs     RECORD LIKE qcs_file.*,
          l_qcu     RECORD LIKE qcu_file.*,
          sr        RECORD
                    qcs021    LIKE qcs_file.qcs021,
                    qcs01     LIKE qcs_file.qcs01,
                    qcs22     LIKE qcs_file.qcs22,
                    qcu04     LIKE qcu_file.qcu04,
                    qcu05     LIKE qcu_file.qcu05
                    END RECORD
#CHI-910058 --Begin--#
   DEFINE l_last_sw    LIKE type_file.chr1,        
          l_pmc03      LIKE pmc_file.pmc03,      
          l_amt        LIKE qcu_file.qcu05,
          amt          LIKE qcs_file.qcs22,  
          l_str1       LIKE adj_file.adj02,       
          l_str2       LIKE adj_file.adj02,       
          l_str3       LIKE adj_file.adj02,       
          l_str4       LIKE adj_file.adj02,      
          l_str5       LIKE adj_file.adj02,      
          l_str6       LIKE adj_file.adj02,      
          l_str7       LIKE adj_file.adj02,       
          l_str8       LIKE adj_file.adj02,       
          l_str9       LIKE adj_file.adj02,       
          l_str10      LIKE adj_file.adj02,       
          cnt          LIKE type_file.num5
#CHI-910058 --End --#                    
 
#FUN-740013 - add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-740013 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
#FUN-740013 - END
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
 
     LET l_sql = "SELECT * FROM qcs_file,qcu_file ",
                 " WHERE qcs01=qcu01 ",
                 "   AND qcs02=qcu02 ",
                 "   AND qcs05=qcu021 ",
                 "   AND qcs14 = 'Y'",
                 "   AND qcs04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND  qcs00<'5' ",  #No.FUN-5C0078
                 "   AND ", tm.wc CLIPPED
 
 
 
     PREPARE r321_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r321_curs1 CURSOR FOR r321_prepare1
#    CALL cl_outnam('aqcr321') RETURNING l_name        #CHI-910058 Mark                           
#    START REPORT r321_rep TO l_name                   #CHI-910058 Mark
#    LET g_pageno = 0                                  #CHI-910058 Mark
     LET g_tot1 = 0       LET g_tot2 = 0
     LET g_tot3 = 0       LET g_tot4 = 0
     LET g_tot5 = 0       LET g_tot6 = 0
     LET g_tot7 = 0       LET g_tot8 = 0
     LET g_tot9 = 0       LET g_tot10= 0
     DELETE FROM aqcr321_tmp
 
     FOREACH r321_curs1 INTO l_qcs.*,l_qcu.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         INSERT INTO aqcr321_tmp VALUES (l_qcs.qcs021,l_qcs.qcs01,l_qcs.qcs22,
                                         l_qcu.qcu04,l_qcu.qcu05)
     END FOREACH
     #------表頭前十名不良原因資料----------
     FOR l_i = 1 TO 10
         INITIALIZE g_head1[l_i].* TO NULL
     END FOR
 
     LET l_i = 1
     DECLARE r321_head CURSOR FOR
      SELECT qcu04,SUM(qcu05) qcu05 FROM aqcr321_tmp
       GROUP BY qcu04
       ORDER BY qcu05 DESC
     FOREACH r321_head INTO g_head1[l_i].*
       IF STATUS THEN CALL cl_err('foreach head',STATUS,0) EXIT FOREACH END IF
       IF l_i >= 10 THEN  EXIT FOREACH END IF
       LET l_i = l_i + 1
     END FOREACH
     #------單身資料-----------------
     DECLARE r321_qcs021 CURSOR FOR                                                      #CHI-910058 Add
       SELECT DISTINCT qcs021 FROM aqcr321_tmp                                           #CHI-910058 Add 
     FOREACH r321_qcs021 INTO sr.qcs021                                                  #CHI-910058 Add
       FOR l_n = 1 TO 10                                                                 #CHI-910058 Add     
           LET l_qcu05[l_n] = 0                                                          #CHI-910058 Add
       END FOR                                                                           #CHI-910058 Add     
     
     DECLARE r321_body CURSOR FOR
#     SELECT * FROM aqcr321_tmp                                                          #CHI-910058 Mark
      SELECT DISTINCT qcu04,SUM(qcu05) qcu05 FROM aqcr321_tmp                            #CHI-910058 Add
       GROUP BY qcu04                                                                    #CHI-910058 Add
       ORDER BY qcu05 DESC                                                               #CHI-910058 Add
#    FOREACH r321_body INTO sr.*                                                         #CHI-910058 Mark
     FOREACH r321_body INTO sr.qcu04                                                     #CHI-910058 Add
       IF STATUS THEN CALL cl_err('foreach body',STATUS,0) EXIT FOREACH END IF
 
#      OUTPUT TO REPORT r321_rep(sr.*)                                                   #CHI-910058 Mark
     #CHI-910058 --Begin--#
      SELECT SUM(qcu05) INTO l_amt FROM aqcr321_tmp
       WHERE qcs021 = sr.qcs021
         AND qcu04 = sr.qcu04
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      FOR l_n = 1 TO 10
          IF g_head1[l_n].qcu04 = sr.qcu04 THEN
             LET l_qcu05[l_n] = l_qcu05[l_n] + l_amt
          END IF
      END FOR
 
     #CHI-910058 BY COCKROACH
     #SELECT SUM(qcs22) INTO amt FROM aqcr321_tmp
     # WHERE qcs021 = sr.qcs021              
     LET g_sql = "SELECT SUM(A.qcs22) FROM ",                                                                                       
                 " (SELECT DISTINCT qcs021,qcs22  FROM aqcr321_tmp  WHERE qcs021 = '",sr.qcs021,"') A"                              
     PREPARE pre_sel_sum FROM g_sql                                                                                                 
     EXECUTE pre_sel_sum INTO amt    
     #CHI-910058 END
      DROP TABLE x
      SELECT DISTINCT qcs01 FROM aqcr321_tmp         
       WHERE qcs021 = sr.qcs021
       GROUP BY qcs01
       INTO TEMP x
      SELECT COUNT(*) INTO cnt FROM x
      IF cl_null(amt) THEN LET amt = 0 END IF
      IF cl_null(cnt) THEN LET cnt = 0 END IF
 
      FOR l_n = 1 TO 10
          IF cl_null(g_head1[l_n].qcu04) THEN
             LET g_head1[l_n].qcu04 = ' '
          END IF
      END FOR     
     #CHI-910058 --End --#
 
     END FOREACH
 
     #CHI-910058 --Begin--#
      CALL r321_qce(g_head1[1].qcu04) RETURNING l_str1
      CALL r321_qce(g_head1[2].qcu04) RETURNING l_str2
      CALL r321_qce(g_head1[3].qcu04) RETURNING l_str3
      CALL r321_qce(g_head1[4].qcu04) RETURNING l_str4
      CALL r321_qce(g_head1[5].qcu04) RETURNING l_str5
      CALL r321_qce(g_head1[6].qcu04) RETURNING l_str6
      CALL r321_qce(g_head1[7].qcu04) RETURNING l_str7
      CALL r321_qce(g_head1[8].qcu04) RETURNING l_str8
      CALL r321_qce(g_head1[9].qcu04) RETURNING l_str9
      CALL r321_qce(g_head1[10].qcu04) RETURNING l_str10
 
      IF cl_null(l_str1) THEN LET l_str1 = ' ' END IF
      IF cl_null(l_str2) THEN LET l_str2 = ' ' END IF
      IF cl_null(l_str3) THEN LET l_str3 = ' ' END IF
      IF cl_null(l_str4) THEN LET l_str4 = ' ' END IF
      IF cl_null(l_str5) THEN LET l_str5 = ' ' END IF
      IF cl_null(l_str6) THEN LET l_str6 = ' ' END IF
      IF cl_null(l_str7) THEN LET l_str7 = ' ' END IF
      IF cl_null(l_str8) THEN LET l_str8 = ' ' END IF
      IF cl_null(l_str9) THEN LET l_str9 = ' ' END IF
      IF cl_null(l_str10) THEN LET l_str10 = ' ' END IF
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k ***
      EXECUTE insert_prep USING
         sr.qcs01,    sr.qcs22,    sr.qcu04,   sr.qcu05,
         sr.qcs021,   amt,         cnt,        g_head1[1].qcu04,
         g_head1[2].qcu04,  g_head1[3].qcu04,  g_head1[4].qcu04,
         g_head1[5].qcu04,  g_head1[6].qcu04,  g_head1[7].qcu04,
         g_head1[8].qcu04,  g_head1[9].qcu04,  g_head1[10].qcu04,
         l_qcu05[1],  l_qcu05[2],  l_qcu05[3],  l_qcu05[4],  l_qcu05[5],
         l_qcu05[6],  l_qcu05[7],  l_qcu05[8],  l_qcu05[9],  l_qcu05[10],
         l_str1,      l_str2,      l_str3,      l_str4,      l_str5,
         l_str6,      l_str7,      l_str8,      l_str9,      l_str10
     END FOREACH         
     #CHI-910058 --End--#     
 
#    FINISH REPORT r321_rep                       #CHI-910058 Mark
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-740013 TSD.c123k mark
 
    # FUN-740013 add
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'qcs021,qcs03,qcu04')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.bdate,";",tm.edate
 
    CALL cl_prt_cs3('aqcr321','aqcr321',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
    # FUN-740013 end
 
END FUNCTION
 
#CHI-910058 ----Mark--Begin--#
#REPORT r321_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#         l_pmc03      LIKE pmc_file.pmc03,
#         l_qcu05      ARRAY[10] of LIKE qcu_file.qcu05,       #No.FUN-680104 DEC(12,3)
#         l_amt        LIKE qcu_file.qcu05,
#         amt          LIKE qcs_file.qcs22,       #No.FUN-680104 DEC(12,3)
#         l_n          LIKE type_file.num5,       #No.FUN-680104 SMALLINT
#         l_str1       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str2       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str3       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str4       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str5       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str6       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str7       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str8       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str9       LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         l_str10      LIKE adj_file.adj02,       #No.FUN-680104 VARCHAR(20)
#         cnt          LIKE type_file.num5,       #No.FUN-680104 SMALLINT
#         sr        RECORD
#                   qcs021    LIKE qcs_file.qcs021,
#                   qcs01     LIKE qcs_file.qcs01,
#                   qcs22     LIKE qcs_file.qcs22,
#                   qcu04     LIKE qcu_file.qcu04,
#                   qcu05     LIKE qcu_file.qcu05
#                   END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.qcs021,sr.qcu04
# FORMAT
#  PAGE HEADER
 
#  BEFORE GROUP OF sr.qcs021
#     FOR l_n = 1 TO 10
#         LET l_qcu05[l_n] = 0
#     END FOR
 
#  AFTER GROUP OF sr.qcu04    #不良原因
#     SELECT SUM(qcu05) INTO l_amt FROM aqcr321_tmp
#      WHERE qcs021 = sr.qcs021
#        AND qcu04 = sr.qcu04
#     IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#     FOR l_n = 1 TO 10
#         IF g_head1[l_n].qcu04 = sr.qcu04 THEN
#            LET l_qcu05[l_n] = l_qcu05[l_n] + l_amt
#         END IF
#     END FOR
 
#  AFTER GROUP OF sr.qcs021   #料號
#     LET amt = GROUP SUM(sr.qcs22)   #總送驗量
#     DROP TABLE x
#    #SELECT DISTINCT qcs01 INTO cnt FROM aqcr321_tmp  #MOD-870066 mark
#     SELECT DISTINCT qcs01 FROM aqcr321_tmp           #MOD-870066
#      WHERE qcs021 = sr.qcs021
#      GROUP BY qcs01
#      INTO TEMP x
#     SELECT COUNT(*) INTO cnt FROM x
#     IF cl_null(amt) THEN LET amt = 0 END IF
#     IF cl_null(cnt) THEN LET cnt = 0 END IF
 
#     # add FUN-740013 -----------------------------------------------------
#     FOR l_n = 1 TO 10
#         IF cl_null(g_head1[l_n].qcu04) THEN
#            LET g_head1[l_n].qcu04 = ' '
#         END IF
#     END FOR
 
#     CALL r321_qce(g_head1[1].qcu04) RETURNING l_str1
#     CALL r321_qce(g_head1[2].qcu04) RETURNING l_str2
#     CALL r321_qce(g_head1[3].qcu04) RETURNING l_str3
#     CALL r321_qce(g_head1[4].qcu04) RETURNING l_str4
#     CALL r321_qce(g_head1[5].qcu04) RETURNING l_str5
#     CALL r321_qce(g_head1[6].qcu04) RETURNING l_str6
#     CALL r321_qce(g_head1[7].qcu04) RETURNING l_str7
#     CALL r321_qce(g_head1[8].qcu04) RETURNING l_str8
#     CALL r321_qce(g_head1[9].qcu04) RETURNING l_str9
#     CALL r321_qce(g_head1[10].qcu04) RETURNING l_str10
 
#     IF cl_null(l_str1) THEN LET l_str1 = ' ' END IF
#     IF cl_null(l_str2) THEN LET l_str2 = ' ' END IF
#     IF cl_null(l_str3) THEN LET l_str3 = ' ' END IF
#     IF cl_null(l_str4) THEN LET l_str4 = ' ' END IF
#     IF cl_null(l_str5) THEN LET l_str5 = ' ' END IF
#     IF cl_null(l_str6) THEN LET l_str6 = ' ' END IF
#     IF cl_null(l_str7) THEN LET l_str7 = ' ' END IF
#     IF cl_null(l_str8) THEN LET l_str8 = ' ' END IF
#     IF cl_null(l_str9) THEN LET l_str9 = ' ' END IF
#     IF cl_null(l_str10) THEN LET l_str10 = ' ' END IF
 
#     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> TSD.c123k ***
#     EXECUTE insert_prep USING
#        sr.qcs01,    sr.qcs22,    sr.qcu04,   sr.qcu05,
#        sr.qcs021,   amt,         cnt,        g_head1[1].qcu04,
#        g_head1[2].qcu04,  g_head1[3].qcu04,  g_head1[4].qcu04,
#        g_head1[5].qcu04,  g_head1[6].qcu04,  g_head1[7].qcu04,
#        g_head1[8].qcu04,  g_head1[9].qcu04,  g_head1[10].qcu04,
#        l_qcu05[1],  l_qcu05[2],  l_qcu05[3],  l_qcu05[4],  l_qcu05[5],
#        l_qcu05[6],  l_qcu05[7],  l_qcu05[8],  l_qcu05[9],  l_qcu05[10],
#        l_str1,      l_str2,      l_str3,      l_str4,      l_str5,
#        l_str6,      l_str7,      l_str8,      l_str9,      l_str10
#     #------------------------------ CR (3) ------------------------------
#     # end FUN-740013 -------------------------------------------------------
 
#  PAGE TRAILER
 
#END REPORT
#CHI-910058 ----Mark--End--#
 
FUNCTION r321_qce(p_qcu04)
  DEFINE p_qcu04   LIKE qcu_file.qcu04,
         l_str     LIKE adj_file.adj02       #No.FUN-680104 VARCHAR(20)
 
   SELECT qce03[1,20] INTO l_str
     FROM qce_file
    WHERE qce01 = p_qcu04
 
   RETURN l_str
END FUNCTION
 
FUNCTION r321_cre_tmp()
#No.FUN-680104-begin
  CREATE TEMP TABLE aqcr321_tmp(
    qcs021    LIKE qcs_file.qcs021,
    qcs01     LIKE qcs_file.qcs01,
    qcs22     LIKE qcs_file.qcs22,
    qcu04     LIKE qcu_file.qcu04,
    qcu05     LIKE qcu_file.qcu05);
#No.FUN-680104-end
END FUNCTION
#Patch....NO.TQC-610036 <> #
