# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdr211.4gl
# Descriptions...: 集團調撥需求表列印
# Date & Author..: 04/3/02	By Hawk
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0067 04/11/17 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No:MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/29 By zhuying 欄位形態定義為LIKE

# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/13 By xumin 項次問題更改
DATABASE ds

GLOBALS "../../config/top.global"

   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-680108 VARCHAR(500) 
              bdate   LIKE ade_file.ade08,
              edate   LIKE ade_file.ade08,
              a       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
              more    LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT

MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT
   LET g_trace  = 'N'
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No:FUN-570264 ---end---
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
   IF NOT cl_null(tm.wc) THEN
      CALL r211()
   ELSE
      CALL r211_tm(0,0)
   END IF
END MAIN

FUNCTION r211_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680108 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

       LET p_row = 4 LET p_col = 11
   OPEN WINDOW r211_w AT p_row,p_col
        WITH FORM "axd/42f/axdr211"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET tm.a    = '5'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON add01,add02,ade06,ade03
                HELP 1

      #No:FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No:FUN-580031 ---end---

      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
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

      #-----MOD-610033---------
      ON ACTION CONTROLP
         CASE
               WHEN INFIELD(ade06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_azp"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ade06
                    NEXT FIELD ade06
         END CASE
      #-----END MOD-610033-----
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT

      #No:FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No:FUN-580031 ---end---

 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r211_w
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.more WITHOUT DEFAULTS HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIElD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF

      AFTER FIELD edate
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         IF tm.bdate > tm.edate THEN NEXT FIELD bdate END IF

      AFTER FIELD a
         IF tm.a NOT MATCHES '[0-5]' THEN NEXT FIELD a END IF

      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG CALL cl_cmdask()

      ON ACTION CONTROLT LET g_trace = 'Y'

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

      #No:FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 ---end---

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r211_w
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axdr211'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr211','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                       #---------No:TQC-610088 modify
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                       #---------No:TQC-610088 end
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('axdr211',g_time,l_cmd)
      END IF
      CLOSE WINDOW r211_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r211()
   ERROR ""
END WHILE
   CLOSE WINDOW r211_w
END FUNCTION

FUNCTION r211()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680108 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0091
          l_sql     LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(400)
          l_chr     LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
           l_za05    LIKE za_file.za05,      #NO.MOD-4B0067
          l_order   ARRAY[5] OF LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(20) 
          sr               RECORD
                               add01  LIKE add_file.add01,
                               add02  LIKE add_file.add02,
                               ade02  LIKE ade_file.ade02,
                               ade03  LIKE ade_file.ade03,
                               ade04  LIKE ade_file.ade04,
                               ade05  LIKE ade_file.ade05,
                               ade06  LIKE ade_file.ade06,
                               ade07  LIKE ade_file.ade07,
                               ade08  LIKE ade_file.ade08,
                               ade09  LIKE ade_file.ade09,
                               ima02  LIKE ima_file.ima02,
                               ima021 LIKE ima_file.ima021
                           END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CASE tm.a
       WHEN '0' LET tm.wc = tm.wc CLIPPED ," AND add06 = '0'"
       WHEN '1' LET tm.wc = tm.wc CLIPPED ," AND add06 = '1'"
       WHEN '2' LET tm.wc = tm.wc CLIPPED ," AND add06 = 'S'"
       WHEN '3' LET tm.wc = tm.wc CLIPPED ," AND add06 = 'R'"
       WHEN '4' LET tm.wc = tm.wc CLIPPED ," AND add06 = 'W"
     END CASE
     LET l_sql = "SELECT add01,add02,ade02,ade03,ade04,ade05,ade06,",
                 "       ade07,ade08,ade09,ima02,ima021",
                 "  FROM add_file,ade_file,OUTER ima_file",
                 " WHERE add01=ade01 AND ima01 = ade03",
                 "   AND ade08 BETWEEN '",tm.bdate, "'",
                 "   AND '",tm.edate,"'",
                 "   AND ade13 = 'N' AND add07 = 'N' ",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY ade08,ade06,ade07,add01,ade02"

     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE r211_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        EXIT PROGRAM
     END IF
     DECLARE r211_curs1 CURSOR FOR r211_prepare1

     CALL cl_outnam('axdr211') RETURNING l_name
     START REPORT r211_rep TO l_name
     LET g_pageno = 0

     FOREACH r211_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       OUTPUT TO REPORT r211_rep(sr.*)
     END FOREACH

     FINISH REPORT r211_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r211_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,              #No.FUN-680108 VARCHAR(1)
          sr           RECORD
                         add01  LIKE add_file.add01,
                         add02  LIKE add_file.add02,
                         ade02  LIKE ade_file.ade02,
                         ade03  LIKE ade_file.ade03,
                         ade04  LIKE ade_file.ade04,
                         ade05  LIKE ade_file.ade05,
                         ade06  LIKE ade_file.ade06,
                         ade07  LIKE ade_file.ade07,
                         ade08  LIKE ade_file.ade08,
                         ade09  LIKE ade_file.ade09,
                         ima02  LIKE ima_file.ima02,
                         ima021 LIKE ima_file.ima021
                       END RECORD,
          l_bdate      LIKE type_file.dat,            #No.FUN-680108 DATE
          l_edate      LIKE type_file.dat,            #No.FUN-680108 DATE 
          l_yyyy       LIKE type_file.num5,           #No.FUN-680108 SMALLINT 
          l_mon        LIKE type_file.num5,           #No.FUN-680108 SMALLINT
          l_rowno      LIKE type_file.num5,           #No.FUN-680108 SMALLINT
          l_rowno1     LIKE type_file.num5,           #No.FUN-680108 SMALLINT
          l_days       INTERVAL DAY TO DAY, 
          l_azp02      LIKE azp_file.azp02

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ade08,sr.ade06,sr.ade07,sr.add01,sr.ade02
  FORMAT
   PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT g_x[9],':',tm.bdate,'-',tm.edate
            PRINT g_dash[1,g_len]

            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
                  g_x[41],g_x[42]
            PRINT g_dash1
            LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ade06
      LET l_rowno = 1

   BEFORE GROUP OF sr.add01
      LET l_rowno1 = 1
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.ade08;
      PRINT COLUMN g_c[32],sr.ade06;
      IF l_rowno = 1 THEN
          SELECT azp02 INTO l_azp02 FROM azp_file
           WHERE azp01 = sr.ade06
          PRINT COLUMN g_c[33],l_azp02;
          LET l_rowno = l_rowno +1
      END IF
      PRINT COLUMN g_c[34],sr.ade07;
      PRINT COLUMN g_c[35],sr.add01;
      IF l_rowno1 = 1 THEN
          PRINT COLUMN g_c[36],sr.add02;
          LET l_rowno1 = l_rowno1 +1
      END IF
#      PRINT COLUMN g_c[37],sr.ade02 USING '###&', #FUN-590118
      PRINT COLUMN g_c[37],cl_numfor(sr.ade02,4,0),  #TQC-6A0095
            COLUMN g_c[38],sr.ade03,
             COLUMN g_c[39],sr.ima02,  #MOD-4A0238
             COLUMN g_c[40],sr.ima021,  #MOD-4A0238
            COLUMN g_c[41],sr.ade04,
            COLUMN g_c[42],sr.ade05 USING '----------&.&&&'
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED
 
   AFTER GROUP OF sr.ade08
      PRINT
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED,
                    COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#Patch....NO:TQC-610037 <001> #
