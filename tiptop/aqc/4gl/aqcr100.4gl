# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aqcr100.4gl
# Descriptions...: IQC 轉 EXCEL
# Date & Author..: 02/11/05 By Payton
# Modify.........: No.FUN-4B0001 04/11/02 By Smapmin 收貨單號,料件編號,廠商編號,檢驗員開窗
# Modify.........: No.FUN-4C0099 05/01/12 By kim 報表轉XML功能
# Modify.........: No.MOD-530865 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-550121 05/05/27 By echo 新增報表備註
# Modify..........: No.MOD-590003 05/09/05 By Nigel 報表格式不齊
# Modify.........: No.FUN-5C0078 05/12/20 By jackie 抓取qcs_file的程序多加判斷qcs00<'5'
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.TQC-730029 07/03/12 By pengu 1.不良原因只能印出一個
#                                                  2.備註欄位改抓qao_file
# Modify.........: No.TQC-750064 07/06/12 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30001 10/03/31 By Summer 將aqc-005改成apm-244
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
              more    LIKE type_file.chr1         #No.FUN-680104 VARCHAR(01)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
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
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r100_tm(0,0)
      ELSE CALL r100()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r100_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680104 SMALLINT
         l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   LET p_row = 6 LET p_col = 20
   OPEN WINDOW r100_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr100"
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
      CONSTRUCT BY NAME tm.wc ON qcs01,qcs021,qcs03,qcs13,qcs04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
              LET g_qryparam.form = "q_qcs3"
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
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr100','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aqcr100',g_time,l_cmd)
      END IF
      CLOSE WINDOW r100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r100()
   ERROR ""
END WHILE
   CLOSE WINDOW r100_w
END FUNCTION
 
FUNCTION r100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(40)
       sr        RECORD
                    qcs        RECORD LIKE qcs_file.*
                    END RECORD
 
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
 
 
  LET l_sql = " SELECT * FROM qcs_file ",
                 " WHERE  qcs14 = 'Y'",
                 "   AND  qcs00<'5' ",  #No.FUN-5C0078
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r100_curs1 CURSOR FOR r100_prepare1
     CALL cl_outnam('aqcr100') RETURNING l_name
     START REPORT r100_rep TO l_name
     LET g_pageno = 0
     FOREACH r100_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         OUTPUT TO REPORT r100_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r100_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r100_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
          l_gen02      LIKE gen_file.gen02,
          l_pmc03      LIKE pmc_file.pmc03,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_ima109     LIKE ima_file.ima109,
          l_azf03      LIKE azf_file.azf03,
          l_ima15      LIKE ima_file.ima15,
          l_qce03      LIKE qce_file.qce03,
          i            LIKE type_file.num5,        #No.FUN-680104 SMALLINT
          l_qcs09      LIKE type_file.chr4,        #No.FUN-680104 VARCHAR(04)
          l_qct05      LIKE type_file.chr2,        #No.FUN-680104 VARCHAR(02)
          l_str        LIKE ze_file.ze03,          #No.FUN-680104 VARCHAR(04)
          l_qct07      LIKE qct_file.qct07,
          x            LIKE type_file.num5,        #No.FUN-680104 SMALLINT
          l_qcu        ARRAY[10]  OF RECORD LIKE qcu_file.*,
          msg          LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(40)
          qcs21_desc   LIKE type_file.chr4,         #No.FUN-680104 VARCHAR(04)
          qct08_desc   LIKE type_file.chr4,         #No.FUN-680104 VARCHAR(04)
          l_g_x_26     LIKE qcs_file.qcs03,        #No.FUN-680104 VARCHAR(09)
         #-------------No.TQC-730029 add
          l_qao06      LIKE qao_file.qao06,
          l_str1       STRING,
         #-------------No.TQC-730029 end
       sr        RECORD
                    qcs        RECORD LIKE qcs_file.*
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.qcs.qcs01,sr.qcs.qcs02,sr.qcs.qcs05
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42]
      PRINT g_dash1
      LET l_last_sw = 'n'
   ON EVERY ROW
       SELECT pmc03 INTO l_pmc03 FROM pmc_file  WHERE pmc01=sr.qcs.qcs03
       IF SQLCA.sqlcode THEN LET l_pmc03 = NULL END IF
 
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
           WHERE ima01=sr.qcs.qcs021
       IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
       END IF
 
       CASE sr.qcs.qcs09
          WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_str
          WHEN '2' CALL cl_getmsg('apm-244',g_lang) RETURNING l_str #MOD-A30001 aqc-005->apm-244
          WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING l_str
       END CASE
       FOR i=1 TO 10 INITIALIZE l_qcu[i].* TO NULL END FOR
       DECLARE qcu_cs CURSOR FOR
          SELECT qcu04,SUM(qcu05) FROM qcu_file WHERE qcu01=sr.qcs.qcs01
             AND qcu02=sr.qcs.qcs02 AND qcu021=sr.qcs.qcs05
             GROUP BY qcu04
       LET i=1
       FOREACH qcu_cs INTO l_qcu[i].qcu04,l_qcu[i].qcu05
            IF STATUS THEN CALL cl_err('foreach qcu' ,STATUS,0)
               EXIT FOREACH
            END IF
            LET i=i+1
            IF i> 10 THEN EXIT FOREACH END IF
       END FOREACH
       LET l_qct07=0
       SELECT SUM(qct07) INTO l_qct07 FROM qct_file
            WHERE qct01=sr.qcs.qcs01 AND qct02=sr.qcs.qcs02
                  AND qct021=sr.qcs.qcs05
       IF cl_null(l_qct07) THEN LET l_qct07=0 END IF
 
      #-----------No.TQC-730029 add
       LET l_qao06 = NULL
       LET l_str1  = NULL
       DECLARE qao_cur CURSOR FOR 
          SELECT qao06 FROM qao_file
                 WHERE qao01=sr.qcs.qcs01
                   AND qao02=sr.qcs.qcs02
                   AND qao021=sr.qcs.qcs05
                   AND qao03=0 AND qao05='2'
       FOREACH qao_cur INTO l_qao06
          IF SQLCA.SQLCODE THEN LET l_qao06=' ' END IF
          IF NOT cl_null(l_qao06) THEN
             LET l_str1 = l_str1 CLIPPED,' ',l_qao06 CLIPPED
          END IF
       END FOREACH
      #-----------No.TQC-730029 end
 
       PRINT COLUMN g_c[31],sr.qcs.qcs04,
             COLUMN g_c[32],sr.qcs.qcs01,
             COLUMN g_c[33],l_pmc03,
             COLUMN g_c[34],sr.qcs.qcs021,
             COLUMN g_c[35],l_ima02,
             COLUMN g_c[36],l_ima021,
             COLUMN g_c[37],cl_numfor(sr.qcs.qcs22,37,3),
            #-----------------No.TQC-750064 modify
            #COLUMN g_c[38],cl_numfor(sr.qcs.qcs06,38,3),
             COLUMN g_c[38],cl_numfor(sr.qcs.qcs091,38,3),
            #-----------------No.TQC-750064 end
             COLUMN g_c[39],l_qct07,
             COLUMN g_c[40],l_str,'  ',
            #-----------No.TQC-730029 modify
            #COLUMN g_c[41],sr.qcs.qcs12;
             COLUMN g_c[41],l_str1;
            #-----------No.TQC-730029 end
#            LET x=180
            #LET x=g_c[42]      #No.TQC-730029 mark
             FOR i=1 TO 10
                LET l_qce03=' '
                IF NOT cl_null(l_qcu[i].qcu04) THEN
                    SELECT qce03 INTO l_qce03 FROM qce_file
                       WHERE qce01=l_qcu[i].qcu04
                    LET msg=l_qce03 CLIPPED,'*',l_qcu[i].qcu05 USING '-----'
                   #----------No.TQC-730029 modify
                   #PRINT COLUMN x,msg CLIPPED;
                    PRINT COLUMN g_c[42],msg CLIPPED
                   #LET x=x+40      
                   #----------No.TQC-730029 end
                END IF
             END FOR
             PRINT ''
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #MOD-590003
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED   #MOD-590003
         ELSE SKIP 2 LINE
      END IF
## FUN-550121
      PRINT ''
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
            PRINT g_x[9]
            PRINT g_memo
         ELSE
            PRINT
            PRINT
         END IF
      ELSE
             PRINT g_x[9]
             PRINT g_memo
      END IF
## END FUN-550121
 
END REPORT
 
