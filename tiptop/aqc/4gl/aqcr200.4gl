# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcr200.4gl
# Descriptions...: FQC 檢驗報告
# Date & Author..: 99/05/10 By Melody
# Modify.........: No.FUN-4C0099 05/01/12 By kim 報表轉XML功能
# Modify.........: No.MOD-530865 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-550121 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-570243 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-690121 06/10/16 By Jackho cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.TQC-750064 07/06/12 By pengu 拿掉單頭[檢驗量]欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
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
      THEN CALL r200_tm(0,0)
      ELSE CALL r200()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
END MAIN
 
FUNCTION r200_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680104 SMALLINT
         l_cmd        LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW r200_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcr200"
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
      CONSTRUCT BY NAME tm.wc ON qcf01,qcf021,qcf02,qcf13,qcf04
 
#No.FUN-570243 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
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
         CLOSE WINDOW r200_w
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
      CLOSE WINDOW r200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aqcr200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aqcr200','9031',1)
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
         CALL cl_cmdat('aqcr200',g_time,l_cmd)
      END IF
      CLOSE WINDOW r200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r200()
   ERROR ""
END WHILE
   CLOSE WINDOW r200_w
END FUNCTION
 
FUNCTION r200()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680104 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680104 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(40)
       sr        RECORD
                    qcf        RECORD LIKE qcf_file.*
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
 
  LET l_sql = "SELECT * FROM qcf_file ",
                 " WHERE  qcf14 = 'Y' AND qcf18='1' ",
                 "   AND ", tm.wc CLIPPED
 
 
     PREPARE r200_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690121
        EXIT PROGRAM
     END IF
     DECLARE r200_curs1 CURSOR FOR r200_prepare1
     CALL cl_outnam('aqcr200') RETURNING l_name
     START REPORT r200_rep TO l_name
     LET g_pageno = 0
     FOREACH r200_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         OUTPUT TO REPORT r200_rep(sr.*)
     END FOREACH
 
     FINISH REPORT r200_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r200_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
          l_gen02      LIKE gen_file.gen02,
          l_pmc03      LIKE pmc_file.pmc03,
          l_qcg07      LIKE qcg_file.qcg07,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          l_ima109     LIKE ima_file.ima109,
          l_sfb22      LIKE sfb_file.sfb22,
          l_occ02      LIKE occ_file.occ02,
          l_gem02      LIKE gem_file.gem02,
          l_azf03      LIKE azf_file.azf03,
          l_ima15      LIKE ima_file.ima15,
          l_qce03      LIKE qce_file.qce03,
          l_qcf09      LIKE ze_file.ze03,       #No.FUN-680104 VARCHAR(04)
          l_qcg05      LIKE type_file.chr2,          #No.FUN-680104 VARCHAR(02)
          msg          LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(40)
          qcf21_desc   LIKE qcf_file.qcf062,       #No.FUN-680104 VARCHAR(04)
          qcg08_desc   LIKE qcf_file.qcf062,       #No.FUN-680104 VARCHAR(04)
          l_qcu        DYNAMIC ARRAY OF RECORD LIKE qcu_file.*,
          l_g_x_26     LIKE qcs_file.qcs03,       #No.FUN-680104 VARCHAR(09)
          x,i          LIKE type_file.num5,          #No.FUN-680104 SMALLINT
       sr        RECORD
                    qcf        RECORD LIKE qcf_file.*
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.qcf.qcf01
  FORMAT
  PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #No.TQC-6A0091
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      #PRINT    #No.TQC-6A0091
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42]
      PRINT g_dash1
      LET l_last_sw = 'n'
  ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
         WHERE ima01=sr.qcf.qcf021
      IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
      END IF
      LET l_qcg07=0
      SELECT SUM(qcg07) INTO l_qcg07 FROM qcg_file
         WHERE qcg01=sr.qcf.qcf01
      IF cl_null(l_qcg07) THEN LET l_qcg07=0 END IF
      FOR i=1 TO 10 INITIALIZE l_qcu[i].* TO NULL END FOR
      DECLARE qcu_cs CURSOR FOR
         SELECT qcu04,SUM(qcu05) FROM qcu_file WHERE qcu01=sr.qcf.qcf01
         GROUP BY qcu04
      LET i=1
      FOREACH qcu_cs INTO l_qcu[i].qcu04,l_qcu[i].qcu05
          IF STATUS THEN CALL cl_err('foreach qcu',STATUS,0)
             EXIT FOREACH
          END IF
          LET i=i+1
          IF i > 10 THEN EXIT FOREACH END IF
     END FOREACH
 
      CASE sr.qcf.qcf09
           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING l_qcf09
           WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING l_qcf09
           WHEN '3' CALL cl_getmsg('aqc-094',g_lang) RETURNING l_qcf09
      END CASE
      PRINT COLUMN g_c[31],sr.qcf.qcf04,
            COLUMN g_c[32],sr.qcf.qcf01,
            COLUMN g_c[33],sr.qcf.qcf02,
            COLUMN g_c[34],sr.qcf.qcf021,
            COLUMN g_c[35],l_ima02,
            COLUMN g_c[36],l_ima021,
            COLUMN g_c[37],sr.qcf.qcf22,
           #--------------No.TQC-750064 modify
           #COLUMN g_c[38],sr.qcf.qcf06,
            COLUMN g_c[38],sr.qcf.qcf091,
           #--------------No.TQC-750064 end
            COLUMN g_c[39],l_qcg07,
            COLUMN g_c[40],l_qcf09,'  ',
            COLUMN g_c[41],sr.qcf.qcf12;
#           LET x=180
            LET x=g_c[42]
            FOR i=1 TO 10
              LET l_qce03=''
              LET msg=''
              IF NOT cl_null(l_qcu[i].qcu04) THEN
                  SELECT qce03 INTO l_qce03 FROM qce_file
                     WHERE qce01=l_qcu[i].qcu04
                  LET msg=l_qce03 CLIPPED,'*',l_qcu[i].qcu05 USING '-----'
                  PRINT COLUMN x,msg;
                  LET x=x+40
              END IF
            END FOR
      #      PRINT COLUMN 260,sr.qcf.qcf12
            PRINT ''
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED   #No.TQC-6A0091
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED   #No.TQC-6A0091
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
 
