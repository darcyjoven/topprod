# Prog. Version..: '5.10.00-08.01.04(00003)'     #
# Pattern name...: axdr200.4gl
# Descriptions...: 集團調撥申請單列印
# Date & Author..: 04/1/13	By Hawk
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02,ima021
# Modify.........: No.MOD-4B0067 04/11/16 BY DAY 將變數用Like方式定義,報表拉成一行
# Modify.........: No:FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/28 By zhuying 欄位形態定義為LIKE

# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,      #No.FUN-680108 VARCHAR(500)
           a       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
           b       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
           more    LIKE type_file.chr1          #No.FUN-680108 VARCHAR(01)
           END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT

MAIN
   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
  #---------------No:TQC-610088 modify
  #LET tm.more  = ARG_VAL(13)       
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No:FUN-570264 ---end---
  #---------------No:TQC-610088 end
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
   IF NOT cl_null(tm.wc) THEN
      CALL r200()
   ELSE
      CALL r200_tm(0,0)
   END IF
END MAIN

FUNCTION r200_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01        #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680108 SMALLINT
       l_cmd          LIKE type_file.chr1000     #No.FUN-680108 VARCHAR(1000)

       LET p_row = 4 LET p_col = 11
   OPEN WINDOW r200_w AT p_row,p_col
        WITH FORM "axd/42f/axdr200"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a    = '4'
   LET tm.b    = '5'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON add01,add02,add03,add04
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
      CLOSE WINDOW r200_w
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.b,tm.more
   INPUT  tm.a,tm.b,tm.more WITHOUT DEFAULTS
         FROM FORMONLY.a,FORMONLY.b,FORMONLY.more HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIELD a
         IF cl_null(tm.a) THEN NEXT FIELD a END IF
         IF tm.a NOT MATCHES '[1234]' THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF cl_null(tm.b) THEN NEXT FIELD b END IF
         IF tm.b NOT MATCHES '[0-5]' THEN NEXT FIELD b END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION CONTROLZ
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

      #No:FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 ---end---

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r200_w
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axdr200'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr200','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,      #No:TQC-610088 add
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('axdr200',g_time,l_cmd)
      END IF
      CLOSE WINDOW r200_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r200()
   ERROR ""
END WHILE
   CLOSE WINDOW r200_w
END FUNCTION

FUNCTION r200()
DEFINE l_name    LIKE type_file.chr20,       #No.FUN-680108 VARCHAR(20)
#       l_time       LIKE type_file.chr8        #No.FUN-6A0091
       l_sql     LIKE type_file.chr1000,     #No.FUN-680108 VARCHAR(300)
       l_za05    LIKE za_file.za05,          #MOD-4B0067
       l_order   ARRAY[5] OF LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(10)
DEFINE sr        RECORD
                     add      RECORD LIKE add_file.*,
                     ade      RECORD LIKE ade_file.*,
                     gen02    LIKE   gen_file.gen02,
                     gem02    LIKE   gem_file.gem02,
                     ima02    LIKE   ima_file.ima02,
                     ima021   LIKE   ima_file.ima021
                 END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     IF g_priv2='4' THEN                           #只能使用自己的資料
         LET tm.wc = tm.wc clipped," AND adduser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
         LET tm.wc = tm.wc clipped," AND addgrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
         LET tm.wc = tm.wc clipped," AND addgrup IN ",cl_chk_tgrup_list()
     END IF

     IF tm.a = '1' THEN LET tm.wc = tm.wc CLIPPED," AND add00 = '1'" END IF
     IF tm.a = '2' THEN LET tm.wc = tm.wc CLIPPED," AND add00 = '2'" END IF
     IF tm.a = '3' THEN LET tm.wc = tm.wc CLIPPED," AND add00 = '3'" END IF
     CASE
        WHEN tm.b = '0' LET tm.wc = tm.wc CLIPPED," AND add06 = '0'"
        WHEN tm.b = '1' LET tm.wc = tm.wc CLIPPED," AND add06 = '1'"
        WHEN tm.b = '2' LET tm.wc = tm.wc CLIPPED," AND add06 = 'S'"
        WHEN tm.b = '3' LET tm.wc = tm.wc CLIPPED," AND add06 = 'R'"
        WHEN tm.b = '4' LET tm.wc = tm.wc CLIPPED," AND add06 = 'W'"
     END CASE
 
     LET l_sql = " SELECT add_file.*,ade_file.*,gen02,",
                 "        gem02,ima02,ima021",
                 "   FROM add_file,ade_file,OUTER ima_file,",
                 "        OUTER gen_file,OUTER gem_file",
                 " WHERE add01 = ade01 AND add03 = gen_file.gen01",
                 "   AND add04 = gem01 ",
                 "   AND ade03 = ima01 ",
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY add01,ade02 "
 
     PREPARE r200_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        EXIT PROGRAM
     END IF
     DECLARE r200_curs1 CURSOR FOR r200_prepare1

     CALL cl_outnam('axdr200') RETURNING l_name
     START REPORT r200_rep TO l_name
     LET g_pageno = 0
     FOREACH r200_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       OUTPUT TO REPORT r200_rep(sr.*)
     END FOREACH
     FINISH REPORT r200_rep

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r200_rep(sr)
DEFINE l_last_sw    LIKE type_file.chr1,      #No.FUN-680108 VARCHAR(1)
       l_str        LIKE type_file.chr8,      #No.FUN-680108 VARCHAR(08)
       l_desc       LIKE fan_file.fan02       #No.FUN-680108 VARCHAR(04)
DEFINE sr           RECORD
                     add      RECORD LIKE add_file.*,
                     ade      RECORD LIKE ade_file.*,
                     gen02    LIKE   gen_file.gen02,
                     gem02    LIKE   gem_file.gem02,
                     ima02    LIKE   ima_file.ima02,
                     ima021   LIKE   ima_file.ima021
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.add.add01,sr.ade.ade02
  FORMAT
   PAGE HEADER
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46],g_x[47],g_x[48],g_x[49]
      PRINT g_dash1
      LET l_last_sw = 'n'
 #MOD-4B0067(BEGIN)
  BEFORE GROUP OF sr.add.add01
      SKIP TO TOP OF PAGE

   ON EVERY ROW
      PRINT COLUMN  g_c[31],sr.add.add01,
            COLUMN  g_c[32],sr.add.add02,
            COLUMN  g_c[33],sr.add.add03,
            COLUMN  g_c[34],sr.gen02,
            COLUMN  g_c[35],sr.add.add04,
            COLUMN  g_c[36],sr.gem02,
            COLUMN  g_c[37],sr.add.add00;
      CASE sr.add.add00
           WHEN '1' PRINT COLUMN g_c[38],g_x[09] CLIPPED;
           WHEN '2' PRINT COLUMN g_c[38],g_x[10] CLIPPED;
           WHEN '3' PRINT COLUMN g_c[38],g_x[11] CLIPPED;
      END CASE
      PRINT COLUMN  g_c[39],sr.ade.ade02 USING '###&', #FUN-590118
            COLUMN  g_c[40],sr.ade.ade03,
             COLUMN  g_c[41],sr.ima02,  #MOD-4A0238
             COLUMN  g_c[42],sr.ima021,  #MOD-4A0238
            COLUMN  g_c[43],sr.ade.ade04,
            COLUMN  g_c[44],sr.ade.ade05 USING '-----------&.&&',
            COLUMN  g_c[45],sr.ade.ade06,
            COLUMN  g_c[46],sr.ade.ade07,
            COLUMN  g_c[47],sr.ade.ade08,
            COLUMN  g_c[48],sr.ade.ade09,
            COLUMN  g_c[49],sr.ade.ade10

 #MOD-4B0067(END)
   ON LAST ROW
      LET l_last_sw = 'y'

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,COLUMN 31,g_x[5] CLIPPED,
                    COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,COLUMN 31,g_x[5] CLIPPED,
               COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
