# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdr206.4gl
# Descriptions...: 集團調撥申請單明細列印
# Date & Author..: 04/01/14 By Carrier
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY 將變數用Like方式定義,報表拉成一行
# Modify.........: No.FUN-550026 05/05/17 By yoyo單據編號格式放大
# Modify.........: No:MOD-630001 06/03/02 By Vivien “工廠”修改為“營運中心”
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/29 By zhuying 欄位形態定義為LIKE

# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/14 By xumin報表表頭格式修改
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,      #No.FUN-680108 VARCHAR(500) 
           a       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
           b       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
           c       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
           d       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
           more    LIKE type_file.chr1          #No.FUN-680108 VARCHAR(01)
           END RECORD
DEFINE   g_i       LIKE type_file.num5          #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg     LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(72)

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
   LET tm.c     = ARG_VAL(10)
   LET tm.d     = ARG_VAL(11)
#------------No:TQC-610088 modify
  #LET tm.more  = ARG_VAL(13)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No:FUN-570264 ---end---
#------------No:TQC-610088 modify
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
   IF NOT cl_null(tm.wc) THEN
      CALL r206()
   ELSE
      CALL r206_tm(0,0)
   END IF
END MAIN

FUNCTION r206_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680108 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(1000)

      LET p_row = 5 LET p_col = 13
   OPEN WINDOW r206_w AT p_row,p_col
        WITH FORM "axd/42f/axdr206"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.a     = '4'
   LET tm.b     = '5'
   LET tm.c     = '3'
   LET tm.d     = 'N'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
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
      CLOSE WINDOW r206_w
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.b,tm.c,tm.d,tm.more

   INPUT tm.a,tm.b,tm.c,tm.d,tm.more WITHOUT DEFAULTS
         FROM FORMONLY.a,FORMONLY.b,FORMONLY.c,
              FORMONLY.d,FORMONLY.more HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1234]' THEN
            NEXT FIELD a
         END IF

      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[012345]' THEN
            NEXT FIELD b
         END IF

      AFTER FIELD c
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[123]' THEN
            NEXT FIELD c
         END IF

      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF

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
      CLOSE WINDOW r206_w
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axdr206'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axdr206','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",        #No:TQC-610088 add
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",tm.c     CLIPPED,"'",
                         " '",tm.d     CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
         CALL cl_cmdat('axdr206',g_time,l_cmd)
      END IF
      CLOSE WINDOW r206_w
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r206()
   ERROR ""
END WHILE
   CLOSE WINDOW r206_w
END FUNCTION

FUNCTION r206()
DEFINE l_name    LIKE type_file.chr20        # External(Disk) file name              #No.FUN-680108 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0091
DEFINE l_sql     LIKE type_file.chr1000      # RDSQL STATEMENT                         #No.FUN-680108 VARCHAR(1000)
DEFINE l_za05    LIKE za_file.za05           #MOD-4B0067
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(10)
DEFINE sr        RECORD
                     add01    LIKE add_file.add01,
                     add02    LIKE add_file.add02,
                     add03    LIKE add_file.add03,
                     gen02    LIKE gen_file.gen02,
                     add00    LIKE add_file.add00,
                     add06    LIKE add_file.add06,
                     addmksg  LIKE add_file.addmksg,
                     addsign  LIKE add_file.addsign,
                     add07    LIKE add_file.add07,
                     add08    LIKE add_file.add08
                 END RECORD
DEFINE sr1       RECORD
                     add01    LIKE add_file.add01,
                     add02    LIKE add_file.add02,
                     add03    LIKE add_file.add03,
                     gen02    LIKE gen_file.gen02,
                     add00    LIKE add_file.add00,
                     add06    LIKE add_file.add06,
                     addmksg  LIKE add_file.addmksg,
                     addsign  LIKE add_file.addsign,
                     add07    LIKE add_file.add07,
                     add08    LIKE add_file.add08,
                     ade02    LIKE ade_file.ade02,
                     ade03    LIKE ade_file.ade03,
                     ima02    LIKE ima_file.ima02,
                     ima021   LIKE ima_file.ima02,
                     ade16    LIKE ade_file.ade16,
                     ade17    LIKE ade_file.ade17,
                     ade04    LIKE ade_file.ade04,
                     ade12    LIKE ade_file.ade12,
                     ade13    LIKE ade_file.ade13,
                     ade18    LIKE ade_file.ade18,
                     ade06    LIKE ade_file.ade06,
                     ade07    LIKE ade_file.ade07,
                     ade08    LIKE ade_file.ade08,
                     ade09    LIKE ade_file.ade09,
                     ade10    LIKE ade_file.ade10,
                     ade05    LIKE ade_file.ade05,
                     ade15    LIKE ade_file.ade15,
                     ade14    LIKE ade_file.ade14,
                     ade19    LIKE ade_file.ade19,
                     ade20    LIKE ade_file.ade20
                 END RECORD

       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05
       FROM zz_file WHERE zz01 = 'axdr206'

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
     CASE
        WHEN tm.c = '1' LET tm.wc = tm.wc CLIPPED," AND add07 = 'Y'"
        WHEN tm.c = '2' LET tm.wc = tm.wc CLIPPED," AND add07 = 'N'"
     END CASE

     IF tm.d = 'N' THEN
        LET l_sql = " SELECT add01,add02,add03,gen02,add00,",
                    "        add06,addmksg,addsign,add07,add08",
                    "   FROM add_file,OUTER gen_file ",
                    " WHERE add03 = gen_file.gen01 ",
                    "   AND ", tm.wc CLIPPED,
                    " ORDER BY add01"
     ELSE
        LET l_sql = " SELECT add01,add02,add03,gen02,add00,add06,addmksg,",
                    "        addsign,add07,add08,ade02,ade03,ima02,ima021,ade16,",
                    "        ade17,ade04,ade12,ade13,ade18,ade06,ade07,",
                    "        ade08,ade09,ade10,ade05,ade15,ade14,ade19,ade20",
                    "   FROM add_file,ade_file,OUTER ima_file,",
                    "        OUTER gen_file ",
                    "  WHERE ade01 = add01  AND add03 = gen_file.gen01 ",
                    "    AND ade03 = ima_file.ima01  ",
                    "    AND ", tm.wc CLIPPED,
                    " ORDER BY add01,ade02"
     END IF
     PREPARE r206_prepare1 FROM l_sql
     IF SQLCA.sqlcode !=0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         EXIT PROGRAM
     END IF
     DECLARE r206_curs1 CURSOR FOR r206_prepare1

     CALL cl_outnam('axdr206') RETURNING l_name
 #     IF tm.d = 'N' THEN LET g_len = 87 ELSE LET g_len = 335 END IF  #MOD-4B0067
      IF tm.d = 'N' THEN LET g_len = 95 ELSE LET g_len = 353 END IF  #MOD-4B0067
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     IF tm.d = 'N' THEN
        START REPORT r206_rep1 TO l_name
        LET g_pageno = 0
        FOREACH r206_curs1 INTO sr.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            OUTPUT TO REPORT r206_rep1(sr.*)
        END FOREACH
        FINISH REPORT r206_rep1
     ELSE
        START REPORT r206_rep2 TO l_name
        LET g_pageno = 0
        FOREACH r206_curs1 INTO sr1.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            IF cl_null(sr1.ade05)   THEN LET sr1.ade05  = 0 END IF
            IF cl_null(sr1.ade12)   THEN LET sr1.ade12  = 0 END IF
            IF cl_null(sr1.ade15)   THEN LET sr1.ade15  = 0 END IF
            OUTPUT TO REPORT r206_rep2(sr1.*)
        END FOREACH
        FINISH REPORT r206_rep2
     END IF

     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

REPORT r206_rep1(sr)
DEFINE l_last_sw    LIKE type_file.chr1        #No.FUN-680108 VARCHAR(1) 
DEFINE l_str        LIKE type_file.chr8        #No.FUN-680108 VARCHAR(08)
DEFINE l_desc       LIKE type_file.chr8        #No.FUN-680108 VARCHAR(08)
DEFINE sr           RECORD
                     add01    LIKE add_file.add01,
                     add02    LIKE add_file.add02,
                     add03    LIKE add_file.add03,
                     gen02    LIKE gen_file.gen02,
                     add00    LIKE add_file.add00,
                     add06    LIKE add_file.add06,
                     addmksg  LIKE add_file.addmksg,
                     addsign  LIKE add_file.addsign,
                     add07    LIKE add_file.add07,
                     add08    LIKE add_file.add08
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.add01
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#TQC-6A0095--BEGIN
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN g_len-20,'FROM:',g_user CLIPPED ,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
#TQC-6A0095--END
      PRINT g_dash[1,g_len]
#No.FUN-550026 --start--
{      PRINT COLUMN  02,g_x[11] CLIPPED,
            COLUMN  40,g_x[12] CLIPPED,
            COLUMN  68,g_x[13] CLIPPED
      PRINT '---------- -------- -------- -------- ',
            '---------- ----------    -   ----   -    --------'
}
      PRINT g_x[11] CLIPPED,
            COLUMN  18,g_x[29] CLIPPED,
            COLUMN  45,g_x[12] CLIPPED,
            COLUMN  74,g_x[13] CLIPPED
      PRINT '---------------- -------- -------- -------- ',
            '---------- ----------    -   ----   -    --------'
      LET l_last_sw = 'n'
#No.FUN-550026 --end--

   ON EVERY ROW
      CASE sr.add00
          WHEN '1' LET l_desc= cl_getmsg('axd-082',g_lang)
          WHEN '2' LET l_desc= cl_getmsg('axd-083',g_lang)
          WHEN '3' LET l_desc= cl_getmsg('axd-084',g_lang)
      END CASE

      CASE sr.add06
           WHEN '0' CALL cl_getmsg('apy-558',g_lang) RETURNING l_str
           WHEN '1' CALL cl_getmsg('apy-559',g_lang) RETURNING l_str
           WHEN 'S' CALL cl_getmsg('apy-561',g_lang) RETURNING l_str
           WHEN 'R' CALL cl_getmsg('apy-562',g_lang) RETURNING l_str
           WHEN 'W' CALL cl_getmsg('apy-563',g_lang) RETURNING l_str
      END CASE
#No.FUN-550026  --start--
{      PRINT COLUMN   01,sr.add01 CLIPPED,
            COLUMN   12,sr.add02,
            COLUMN   21,sr.add03,
            COLUMN   30,sr.gen02,
            COLUMN   39,sr.add00,
            COLUMN   41,l_desc CLIPPED,
            COLUMN   50,sr.add06,
            COLUMN   52,l_str,
            COLUMN   64,sr.addmksg,
            COLUMN   68,sr.addsign,
            COLUMN   75,sr.add07,
            COLUMN   80,sr.add08
}
      PRINT COLUMN   01,sr.add01 CLIPPED,
            COLUMN   18,sr.add02 CLIPPED,
            COLUMN   27,sr.add03 CLIPPED,  #TQC-6A0095
            COLUMN   36,sr.gen02 CLIPPED,  #TQC-6A0095
            COLUMN   45,sr.add00 CLIPPED,  #TQC-6A0095
            COLUMN   47,l_desc CLIPPED,
            COLUMN   56,sr.add06 CLIPPED,  #TQC-6A0005
            COLUMN   58,l_str CLIPPED,     #TQC-6A0095
            COLUMN   70,sr.addmksg CLIPPED, #TQC-6A0095
            COLUMN   74,sr.addsign CLIPPED, #TQC-6A0095
            COLUMN   81,sr.add07 CLIPPED,  #TQC-6A0095
            COLUMN   86,sr.add08 CLIPPED  #TQC-6A0095
#No.FUN-550026 --end--
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT

REPORT r206_rep2(sr)
DEFINE l_last_sw    LIKE type_file.chr1               #No.FUN-680108 VARCHAR(1)
DEFINE l_str        LIKE type_file.chr8               #No.FUN-680108 VARCHAR(08)
DEFINE l_desc       LIKE ze_file.ze03                 #No.FUN-680108 VARCHAR(08)
DEFINE l_desc1      LIKE ze_file.ze03                 #No.FUN-680108 VARCHAR(10)
DEFINE sr           RECORD
                    add01    LIKE add_file.add01,
                    add02    LIKE add_file.add02,
                    add03    LIKE add_file.add03,
                    gen02    LIKE gen_file.gen02,
                    add00    LIKE add_file.add00,
                    add06    LIKE add_file.add06,
                    addmksg  LIKE add_file.addmksg,
                    addsign  LIKE add_file.addsign,
                    add07    LIKE add_file.add07,
                    add08    LIKE add_file.add08,
                    ade02    LIKE ade_file.ade02,
                    ade03    LIKE ade_file.ade03,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,
                    ade16    LIKE ade_file.ade16,
                    ade17    LIKE ade_file.ade17,
                    ade04    LIKE ade_file.ade04,
                    ade12    LIKE ade_file.ade12,
                    ade13    LIKE ade_file.ade13,
                    ade18    LIKE ade_file.ade18,
                    ade06    LIKE ade_file.ade06,
                    ade07    LIKE ade_file.ade07,
                    ade08    LIKE ade_file.ade08,
                    ade09    LIKE ade_file.ade09,
                    ade10    LIKE ade_file.ade10,
                    ade05    LIKE ade_file.ade05,
                    ade15    LIKE ade_file.ade15,
                    ade14    LIKE ade_file.ade14,
                    ade19    LIKE ade_file.ade19,
                    ade20    LIKE ade_file.ade20
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.add01,sr.ade02
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#TQC-6A0095--BEGIN
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_pdate ,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      LET g_pageno = g_pageno + 1
      PRINT g_pdate ,' ',TIME,
            COLUMN g_len-7,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
#TQC-6A0095--END
      PRINT g_dash[1,g_len]

      LET l_last_sw = 'n'
 #MOD-4B0067(BEGIN)
      CALL cl_getmsg('axd-021',g_lang) RETURNING g_msg
      CASE WHEN sr.add00 = '1' LET l_desc = g_msg[1,8]
           WHEN sr.add00 = '2' LET l_desc = g_msg[9,16]
           WHEN sr.add00 = '3' LET l_desc = g_msg[17,24]
      END CASE

      CASE sr.add06
           WHEN '0' CALL cl_getmsg('apy-558',g_lang) RETURNING l_str
           WHEN '1' CALL cl_getmsg('apy-559',g_lang) RETURNING l_str
           WHEN 'S' CALL cl_getmsg('apy-561',g_lang) RETURNING l_str
           WHEN 'R' CALL cl_getmsg('apy-562',g_lang) RETURNING l_str
           WHEN 'W' CALL cl_getmsg('apy-563',g_lang) RETURNING l_str
      END CASE

#No.FUN-550026 --start--
{      PRINT COLUMN  02,g_x[11] CLIPPED,
            COLUMN  40,g_x[12] CLIPPED,
            COLUMN  68,g_x[13] CLIPPED,
            COLUMN  89,g_x[14] CLIPPED,
            COLUMN 128,g_x[27] CLIPPED,
            COLUMN 147,g_x[28] CLIPPED,
            COLUMN 178,g_x[15] CLIPPED,
            COLUMN 193,g_x[16] CLIPPED,
            COLUMN 223,g_x[17] CLIPPED,
            COLUMN 241,g_x[18] CLIPPED,
            COLUMN 251,g_x[19] CLIPPED,
            COLUMN 264,g_x[20] CLIPPED,
            COLUMN 280,g_x[21] CLIPPED,
            COLUMN 294,g_x[22] CLIPPED,
            COLUMN 301,g_x[23] CLIPPED,
            COLUMN 310,g_x[24] CLIPPED,
            COLUMN 323,g_x[25] CLIPPED,
            COLUMN 332,g_x[26] CLIPPED
      PRINT '---------- -------- -------- -------- ',
            '---------- ----------    -   ----   -    --------',

            ' ---- -------------------- ------------------------------',
            ' ------------------------------ -------------- ---------- ---------- -------- -------- --------',
            ' ---- --------------- --------------- ---------------',
            ' ------ -------- ------------ -------- ----'
}
      PRINT g_x[11] CLIPPED,
            COLUMN  18,g_x[29] CLIPPED,
            COLUMN  45,g_x[12] CLIPPED,
            COLUMN  74,g_x[13] CLIPPED,
            COLUMN  95,g_x[14] CLIPPED,
            COLUMN 134,g_x[27] CLIPPED,
            COLUMN 153,g_x[28] CLIPPED,
            COLUMN 184,g_x[15] CLIPPED,
            COLUMN 207,g_x[16] CLIPPED,
#MOD-630001 --start
            COLUMN 241,g_x[17] CLIPPED,
            COLUMN 259,g_x[18] CLIPPED,
            COLUMN 269,g_x[19] CLIPPED,
            COLUMN 282,g_x[20] CLIPPED,
            COLUMN 298,g_x[21] CLIPPED,
            COLUMN 312,g_x[22] CLIPPED,
            COLUMN 319,g_x[23] CLIPPED,
            COLUMN 328,g_x[24] CLIPPED,
            COLUMN 341,g_x[25] CLIPPED,
            COLUMN 350,g_x[26] CLIPPED
#MOD-630001 --end
      PRINT '---------------- -------- -------- -------- ',
            '---------- ----------    -   ----   -    --------',
            ' ---- -------------------- ------------------------------',
            ' ------------------------------ ---------------------- -------------- ---------- -------- -------- --------',  #MOD-630001
            ' ---- --------------- --------------- ---------------',
            ' ------ -------- ------------ -------- ----'
#No.FUN-550026 --end--
 #    PRINT

   ON EVERY ROW
      CASE sr.ade18
           WHEN  '1' CALL cl_getmsg('axm-024',g_lang) RETURNING l_desc1
           WHEN  '2' CALL cl_getmsg('axm-025',g_lang) RETURNING l_desc1
           WHEN  '3' CALL cl_getmsg('axm-026',g_lang) RETURNING l_desc1
           OTHERWISE  LET l_desc1 = ''
      END CASE
#No.FUN-550026 --start--
      PRINT COLUMN   01,sr.add01 CLIPPED,
            COLUMN   18,sr.add02 CLIPPED,  #TQC-6A0095
            COLUMN   27,sr.add03 CLIPPED,   #TQC-6A0095
            COLUMN   36,sr.gen02 CLIPPED,  #TQC-6A0095
            COLUMN   45,sr.add00 CLIPPED,  #TQC-6A0095
            COLUMN   47,l_desc CLIPPED,
            COLUMN   56,sr.add06 CLIPPED,  #TQC-6A0095
            COLUMN   58,l_str CLIPPED,   #TQC-6A0095
            COLUMN   70,sr.addmksg CLIPPED,  #TQC-6A0095
            COLUMN   74,sr.addsign CLIPPED,  #TQC-6A0095
            COLUMN   81,sr.add07 CLIPPED, #TQC-6A0095
            COLUMN   86,sr.add08 CLIPPED,  #TQC-6A0095
            COLUMN   95,sr.ade02 USING "<<<<",
            COLUMN  100,sr.ade03 CLIPPED,
             COLUMN  121,sr.ima02 CLIPPED,  #MOD-4A0238  #TQC-6A0095
            COLUMN  152,sr.ima021 CLIPPED,  #TQC-6A0095
            COLUMN  183,sr.ade16 CLIPPED,'/',  #TQC-6A0095
            COLUMN  200,sr.ade17 USING "<<<",
            COLUMN  207,sr.ade06 CLIPPED,
#MOD-630001  --start
            COLUMN  224,sr.ade07 CLIPPED,
            COLUMN  232,sr.ade08 CLIPPED, #TQC-6A0095
            COLUMN  241,sr.ade09 CLIPPED, #TQC-6A0095
            COLUMN  250,sr.ade10 CLIPPED, #TQC-6A0095
            COLUMN  259,sr.ade04 CLIPPED, #TQC-6A0095
            COLUMN  264,sr.ade05 USING "----------&.&&&",
            COLUMN  280,sr.ade12 USING "----------&.&&&",
            COLUMN  296,sr.ade15 USING "----------&.&&&",
            COLUMN  312,sr.ade13 CLIPPED, #TQC-6A0095
            COLUMN  319,sr.ade14 CLIPPED, #TQC-6A0095
            COLUMN  328,sr.ade18 CLIPPED, #TQC-6A0095
            COLUMN  330,l_desc1 CLIPPED,
            COLUMN  341,sr.ade19 USING "<<<<<<<<",
            COLUMN  350,sr.ade20 USING "<<<"
#MOD-630001  --end
{
      PRINT COLUMN   01,sr.add01 CLIPPED,
            COLUMN   17,sr.add02,
            COLUMN   26,sr.add03,
            COLUMN   35,sr.gen02,
            COLUMN   34,sr.add00,
            COLUMN   46,l_desc CLIPPED,
            COLUMN   55,sr.add06,
            COLUMN   57,l_str,
            COLUMN   69,sr.addmksg,
            COLUMN   73,sr.addsign,
            COLUMN   80,sr.add07,
            COLUMN   85,sr.add08,
            COLUMN   94,sr.ade02 USING "<<<<",
            COLUMN   99,sr.ade03 CLIPPED,
             COLUMN  120,sr.ima02,  #MOD-4A0238
            COLUMN  151,sr.ima021,
            COLUMN  182,sr.ade16,'/',
            COLUMN  199,sr.ade17 USING "<<<",
            COLUMN  192,sr.ade06 CLIPPED,
            COLUMN  203,sr.ade07 CLIPPED,
            COLUMN  214,sr.ade08,
            COLUMN  223,sr.ade09,
            COLUMN  232,sr.ade10,
            COLUMN  241,sr.ade04,
            COLUMN  246,sr.ade05 USING "----------&.&&&",
            COLUMN  262,sr.ade12 USING "----------&.&&&",
            COLUMN  278,sr.ade15 USING "----------&.&&&",
            COLUMN  294,sr.ade13,
            COLUMN  301,sr.ade14,
            COLUMN  310,sr.ade18,
            COLUMN  312,l_desc1 CLIPPED,
            COLUMN  323,sr.ade19 USING "<<<<<<<<",
            COLUMN  332,sr.ade20 USING "<<<"
}
      PRINT
 #MOD-4B0067(END)
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
